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
with open(setupSqlPath) as setupSqlFile, open(setupSqlDataPath) as setupSqlDataFile:
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
            value = value[newline_index + 1 :]
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
    # Straightforward
    "Who received a job offer and did they accept it?",
    "What companies are currently hiring and how many active job listings does each have?",

    # Multi-join complexity
    "Which applicants passed all of their interviews but never received an offer?",
    "Which people have applied to more than one company, and what was the outcome of each application?",
    "For each active job listing, how many applications are in each status (pending, interviewing, rejected, offered)?",

    # Aggregation and ranking
    "What is the total compensation (salary + starting bonus + easy bonus) for each offer, ranked highest to lowest, and who accepted it?",
    "Which companies have a higher rejection rate than acceptance rate among their applications?",

    # Tricky edge cases (expect trouble)
    "Which applicants have never failed a single interview round?",  # tricky: must exclude people with no interviews at all, or not?
    "Which job listings have received zero applications?",           # NOT EXISTS / NOT IN
    "Who applied to a job listing whose mandatory requirements they do not meet?",  # no skills table — may hallucinate
]


def askQuestion(question, strategy="zero_shot"):
    error = "None"
    sqlSyntaxResponse = ""
    queryRawResponse = ""
    friendlyResponse = ""
    try:
        sqlSyntaxResponse = getChatGptResponse(strategies[strategy] + " " + question)
        sqlSyntaxResponse = sanitizeForJustSql(sqlSyntaxResponse)
        print("SQL:")
        print(sqlSyntaxResponse)

        queryRawResponse = str(runSql(sqlSyntaxResponse))
        print("Raw result:")
        print(queryRawResponse)

        friendlyResultsPrompt = (
            "I have a job application database with the following schema:\n"
            + setupSqlScript
            + '\n\nI asked the question: "'
            + question
            + '"'
            + '\nThe raw database result was: "'
            + queryRawResponse
            + '"'
            + "\nPlease give a concise, friendly answer to the question using this data. "
            "Do not include extra suggestions or chatter."
        )
        friendlyResponse = getChatGptResponse(friendlyResultsPrompt)
        print("Answer:")
        print(friendlyResponse)
    except Exception as err:
        error = str(err)
        print(f"Error: {err}")
    return {
        "question": question,
        "sql": sqlSyntaxResponse,
        "queryRawResponse": queryRawResponse,
        "friendlyResponse": friendlyResponse,
        "error": error,
    }


print("\nHow would you like to run the bot?")
print("  1) Run pre-planned questions across all strategies (saves JSON results)")
print("  2) Ask your own questions interactively")
mode = input("Enter 1 or 2: ").strip()

if mode == "1":
    for strategy in strategies:
        responses = {"strategy": strategy, "prompt_prefix": strategies[strategy]}
        questionResults = []
        print(
            "########################################################################"
        )
        print(f"Running strategy: {strategy}")

        for question in questions:
            print(
                "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            )
            print("Question:")
            print(question)
            result = askQuestion(question, strategy)
            questionResults.append(result)

        responses["questionResults"] = questionResults
        with open(getPath(f"response_{strategy}_{time()}.json"), "w") as outFile:
            json.dump(responses, outFile, indent=2)

elif mode == "2":
    print("\nAvailable strategies:")
    for i, name in enumerate(strategies, 1):
        print(f"  {i}) {name}")
    strategyChoice = input("Choose a strategy (1/2/3, default 1): ").strip()
    strategyNames = list(strategies.keys())
    try:
        chosenStrategy = strategyNames[int(strategyChoice) - 1]
    except (ValueError, IndexError):
        chosenStrategy = strategyNames[0]
    print(f"Using strategy: {chosenStrategy}")
    print("Type your questions below. Press Enter on an empty line to quit.\n")

    while True:
        question = input("Your question: ").strip()
        if not question:
            break
        askQuestion(question, chosenStrategy)
        print()

else:
    print("Invalid choice. Exiting.")

sqliteCursor.close()
sqliteCon.close()
print("Exiting!")
