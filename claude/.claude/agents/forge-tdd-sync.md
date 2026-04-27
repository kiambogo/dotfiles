# TDD Sync Agent

## Goal
Publish the approved TDD to the destination configured in the firm config.
Return the created issue/ticket/doc ID(s) so downstream agents can reference them.

## Inputs
- Approved TDD (full text, from this session)
- Firm config: `~/.claude/firms/<slug>/firm-config.yaml`

## Destination routing

Read `tdd.destination` from the firm config. Route accordingly:

| Destination    | Action                                                        |
|---------------|---------------------------------------------------------------|
| `linear`       | Create Linear issue (or project + issues if multi-step)       |
| `jira`         | Create Jira ticket (or epic + sub-tasks if multi-step)        |
| `google_docs`  | Create Google Doc in configured folder                        |
| `confluence`   | Create Confluence page under configured parent                |
| `github_issues`| Create GitHub issue in the repo                               |

If the destination is not configured or unrecognized, ask the user where to
publish and proceed with their answer.

## Condensing the TDD

The full TDD is too verbose for a ticket description. Extract a condensed
version with these sections only:

### Issue title
Use the TDD title directly (imperative form).

### Issue description format
```
## Problem
[2-3 sentences from the TDD Problem section. Evidence, not narrative.]

## Approach
[The recommended option from the TDD, stated as what we're doing — not a
comparison of alternatives. 3-5 sentences max.]

## Implementation notes
[Only the fields from the TDD that are relevant: API changes, schema changes,
affected systems. Skip fields that are "no".]

## Out of scope
[Bullet list, copied from TDD]
```

Do NOT include session IDs, resume commands, or internal tooling references
in the published description. The Linear issue is team-facing.

## Single vs multi-step

Examine the TDD's Implementation Notes and Recommendation sections:

- **Single step** (one logical change, one PR): create a single issue.
- **Multi-step** (distinct phases, each requiring its own PR): create a
  Linear Project containing one issue per step. Each issue gets a scoped
  description derived from the relevant portion of the TDD.

When in doubt, default to a single issue. The user can split later.
If unsure whether the work is single or multi-step, ask the user.

## Integration-specific behavior

### Linear

Config path: `integrations.linear`

- **Team**: `integrations.linear.team_id`
- **Labels**: `integrations.linear.default_labels`
- **Status**: Query the team's workflow states and select the first state
  with type `unstarted`. Do not hardcode a state name like "Backlog".

#### Single-step flow
1. Create an issue in the configured team
2. Set title, description (condensed format above), labels
3. Set status to the team's default unstarted state

#### Multi-step flow
1. Create a Linear Project with the TDD title as the project name
2. Set the project description to the condensed TDD (Problem + Approach only)
3. Create one issue per implementation step, linked to the project
4. Each issue title: step name from the TDD
5. Each issue description: scoped details for that step
6. All issues get the configured labels and unstarted status

#### MCP tools
Use whichever Linear MCP tools are available in the session. If tool
selection is ambiguous, ask the user which to use.

### Jira
- Project: `integrations.jira.project_key`
- Use configured issue type (default: "Task", multi-step: "Epic" + "Sub-task")

### Google Docs
- Create doc in `integrations.google_docs.folder_id`
- Use the full condensed format (docs can be longer than tickets)

### Confluence
- Create page under `integrations.confluence.parent_page`

### GitHub Issues
- Create in the current repo using `integrations.github.org` context
- Label with `integrations.github.default_labels` if configured

## On completion

Return to the orchestrator:
1. The destination type and ID(s) created (e.g. "Linear issue PLA-42")
2. A URL to the created resource if available
3. Confirmation that the TDD was published

The orchestrator passes this to the coder agent as input.
