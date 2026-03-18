# Create Ticket

Given the approved TDD and firm config:
1. Identify the ticket tracker (linear | jira | github_issues)
2. Use the appropriate MCP server to create a ticket with:
   - Title: imperative description of the change (e.g. "Fix N+1 query in user listing")
   - Description: problem summary + link to TDD doc + affected systems + out of scope
   - Assignee: engineer from firm config
   - Labels: from firm config defaults
3. Return the ticket URL
