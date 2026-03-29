import json
from openai import OpenAI
import os
import sqlite3
from time import time

print("Running db_bot.py!")

fdir = os.path.dirname(__file__)
def getPath(fname):
    return os.path.join(fdir, fname)

# SQLITE
sqliteDbPath = getPath("aidb.sqlite")
setupSqlPath = getPath("setup.sql")
setupSqlDataPath = getPath("setupData.sql")

# Erase previous db
if os.path.exists(sqliteDbPath):
    os.remove(sqliteDbPath)

# Create new db
sqliteCon = sqlite3.connect(sqliteDbPath)
sqliteCursor = sqliteCon.cursor()

# Read in setup files
with (
    open(setupSqlPath) as setupSqlFile,
    open(setupSqlDataPath) as setupSqlDataFile
):
    setupSqlScript = setupSqlFile.read()
    setupSqlDataScript = setupSqlDataFile.read()

# Execute setup files
sqliteCursor.executescript(setupSqlScript)
sqliteCursor.executescript(setupSqlDataScript)

def runSql(query):
    result = sqliteCursor.execute(query).fetchall()
    return result

# OPENAI
configPath = getPath("config.json")
with open(configPath) as configFile:
    config = json.load(configFile)

openAiClient = OpenAI(api_key=config["openaiKey"])
openAiClient.models.list()  # Validates the key
chosen_model = "gpt-4o"

def getChatGptResponse(content):
    stream = openAiClient.chat.completions.create(
        model=chosen_model,
        messages=[{"role": "user", "content": content}],
        stream=True,
    )
    responseList = []
    for chunk in stream:
        if chunk.choices[0].delta.content is not None:
            responseList.append(chunk.choices[0].delta.content)
    return "".join(responseList)


# Extract SQL from markdown-wrapped responses
def sanitizeForJustSql(value):
    gptStartSqlMarker = "```"
    gptEndSqlMarker = "```"
    if gptStartSqlMarker in value:
        value = value.split(gptStartSqlMarker, 1)[1]
        newline_index = value.find("\n")
        if newline_index != -1:
            value = value[newline_index + 1:]
    if gptEndSqlMarker in value:
        value = value.split(gptEndSqlMarker, 1)[0]
    return value.strip()


# Strategies
# Based on: https://arxiv.org/abs/2305.11853
commonSqlOnlyRequest = (
    " Give me a sqlite SELECT statement that answers the question. "
    "Only respond with sqlite syntax, no explanation. "
    "If there is an error do not explain it!"
)

# Single-domain example: a Q&A pair from the same job application domain
singleDomainExample = (
    " Example question: Which companies are currently hiring? "
    " Example SQL: SELECT companyName FROM Company WHERE isHiring = 1; "
)

# Cross-domain example: a Q&A pair from a completely different domain (inventory)
crossDomainExample = (
    " Example question (from an inventory database): "
    "How many units of each product are in stock? "
    " Example SQL: SELECT product_name, quantity FROM inventory WHERE quantity > 0; "
)

strategies = {
    "zero_shot": setupSqlScript + commonSqlOnlyRequest,
    "single_domain": setupSqlScript + singleDomainExample + commonSqlOnlyRequest,
    "cross_domain": setupSqlScript + crossDomainExample + commonSqlOnlyRequest,
}

questions = [
    "Which applicants passed all of their interviews?",
    "What companies are currently hiring and what positions do they have open?",
    "Who received a job offer and did they accept it?",
    "Which job listings have mandatory requirements?",
    "What is the average salary of accepted offers by company?",
]


for strategy in strategies:
    responses = {"strategy": strategy, "prompt_prefix": strategies[strategy]}
    questionResults = []
    print("########################################################################")
    print(f"Running strategy: {strategy}")

    for question in questions:
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        print("Question:")
        print(question)
        error = "None"
        sqlSyntaxResponse = ""
        queryRawResponse = ""
        friendlyResponse = ""

        try:
            getSqlPrompt = strategies[strategy] + " " + question
            sqlSyntaxResponse = getChatGptResponse(getSqlPrompt)
            sqlSyntaxResponse = sanitizeForJustSql(sqlSyntaxResponse)
            print("SQL Syntax Response:")
            print(sqlSyntaxResponse)

            queryRawResponse = str(runSql(sqlSyntaxResponse))
            print("Query Raw Response:")
            print(queryRawResponse)

            # Improved friendly response: give ChatGPT the schema context so it can
            # interpret column values and enums correctly (fixes the class TODO).
            friendlyResultsPrompt = (
                "I have a job application database with the following schema:\n"
                + setupSqlScript
                + "\n\nI asked the question: \"" + question + "\""
                + "\nThe raw database result was: \"" + queryRawResponse + "\""
                + "\nPlease give a concise, friendly answer to the question using this data. "
                "Do not include extra suggestions or chatter."
            )
            friendlyResponse = getChatGptResponse(friendlyResultsPrompt)
            print("Friendly Response:")
            print(friendlyResponse)

        except Exception as err:
            error = str(err)
            print(err)

        questionResults.append({
            "question": question,
            "sql": sqlSyntaxResponse,
            "queryRawResponse": queryRawResponse,
            "friendlyResponse": friendlyResponse,
            "error": error,
        })

    responses["questionResults"] = questionResults

    with open(getPath(f"response_{strategy}_{time()}.json"), "w") as outFile:
        json.dump(responses, outFile, indent=2)


sqliteCursor.close()
sqliteCon.close()
print("Done!")
