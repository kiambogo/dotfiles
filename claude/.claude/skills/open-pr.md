# Open Pull Request

## Method selection

Check the remote URL and available tools:
- If the remote is GitHub and `gh` is installed (`gh --version`): use the `gh` CLI — it's faster and doesn't require MCP auth
- Otherwise: use the GitHub/GitLab MCP server

## Steps

1. Push the current branch:
   - `gh`: `git push -u origin HEAD`
   - MCP: push via the MCP server

2. Open a PR with the following content:
   - Title: same as ticket title
   - Description:
     * Link to TDD doc
     * Link to ticket
     * Summary of changes
     * Review check results (all 5, with verdicts)
     * Any notable implementation decisions
     * **Forge session**: `claude --resume $CLAUDE_SESSION_ID` (for resuming work on this change)
   - Reviewers: from firm config
   - Labels: from firm config

   Using `gh`:
   ```
   gh pr create \
     --title "<title>" \
     --body "<description>" \
     --reviewer <reviewers> \
     --label <labels>
   ```

   Using MCP: create via the GitHub MCP server with the same fields.

3. Return the PR URL
