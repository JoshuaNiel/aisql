# Job Application Tracker

My project models data that a recruiter or job seeker might find useful. It tracks people applying for jobs, companies and their listings, requirements for each position, interviews conducted per application, and offers extended to candidates.

<img src="JobApplicationERD.jpg">

## Query I thought it did well on

**Question**: Who received a job offer and did they accept it?

**GPT SQL Response**:
```sql
SELECT p.firstname, p.lastname, o.salary, o.accepted
FROM Offer o
JOIN JobApplication ja ON o.applicationId = ja.id
JOIN Person p ON ja.personId = p.id;
```

**Raw Result**: `[('Alice', 'Nguyen', 130000, 1), ('David', 'Kim', 145000, 0), ('Emma', 'Patel', 95000, None)]`

**Friendly Response**: Three candidates received job offers. Alice Nguyen accepted her offer with a salary of $130,000. David Kim declined his offer of $145,000. Emma Patel has not yet responded to her offer of $95,000.

This worked well because the query involved a straightforward multi-table join with no complex aggregation, and the result rows mapped cleanly to natural-language sentences.

## Question that it tripped up on

**Question**: What is the average salary of accepted offers by company?

**GPT SQL Response**:
```sql
SELECT c.companyName, AVG(o.salary)
FROM Offer o
JOIN JobApplication ja ON o.applicationId = ja.id
JOIN Company c ON ja.companyId = c.id
WHERE o.accepted = 1
GROUP BY c.companyName;
```

**Raw Result**: `[('TechNova Inc.', 130000.0)]`

**Zero-shot Friendly Response**: The average salary of accepted offers by company is $130,000.

The SQL was correct, but the zero-shot friendly response dropped the company name entirely. Without understanding that the first column was a company name and the second was the average, it just reported a raw number. I would have preferred something like: "TechNova Inc. has an average accepted offer salary of $130,000."

## Multi-shot (single-domain)

I re-ran the same question using the single-domain strategy, which primes GPT with a job-domain example Q&A before asking the real question.

**Single-domain Friendly Response**: TechNova Inc. has an average accepted offer salary of $130,000. No other companies have had offers accepted yet.

The single-domain example helped — GPT now included the company name and even noted that only one company had data. The extra context from the example Q&A appeared to anchor it toward more complete, field-aware answers.

## Cross-domain comparison

The cross-domain strategy primed GPT with an inventory-domain example before the job application question. The SQL it generated was identical to the other strategies, but the friendly response landed somewhere between the two:

**Cross-domain Friendly Response**: The average salary for accepted job offers at TechNova Inc. is $130,000.

It included the company name but didn't mention the absence of data for other companies. The cross-domain example still provided useful structural guidance (show label + value) even though the domain was unrelated.

## Conclusion

For straightforward joins and lookups, GPT-4o generates accurate SQLite queries reliably across all three strategies. The main failure mode is in the friendly response step: when raw results are just IDs or aggregated numbers, a zero-shot prompt without schema context produces vague or incomplete answers. Providing the schema in the friendly response prompt (not just the SQL generation prompt) made a significant difference. Single-domain prompting also improved result interpretation by showing GPT what a good answer looks like in context. Cross-domain was a smaller improvement but still better than zero-shot, suggesting that the *format* of an example matters more than its domain.
