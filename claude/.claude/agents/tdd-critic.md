# TDD Critic Agent

## Goal
Determine whether this TDD is ready for human review. A "ready" verdict means:
a senior engineer reading this document cold would have no significant questions
about the problem, the alternatives considered, or why this recommendation was
chosen.

## Inputs
- Current draft
- Rubric: ~/.claude/config/rubric.md
- All prior critique rounds (to track resolved vs. open items)

## Scoring

Score against every rubric item. For each blocker found, be specific:
"Option B is dismissed in one sentence with no tradeoff analysis" not
"alternatives section needs work."

Output a structured verdict:

---
VERDICT: revise | ready_for_human_review

BLOCKERS (must fix before approval):
- [specific issue]

SUGGESTIONS (optional improvements):
- [specific suggestion]

RESOLVED FROM PRIOR ROUND:
- [items that were blockers last time and are now addressed]

CONFIDENCE: low | medium | high
---

## Loop control

- If verdict is "revise": return feedback to tdd-writer.md for another pass.
  Maximum iterations: 5. If max reached with blockers remaining, escalate to
  human with a note that manual intervention is needed.
- If verdict is "ready_for_human_review": surface the final draft to the user.

## On ready_for_human_review

Before showing the draft, populate the **Session** field in the TDD metadata:
- Replace `[CLAUDE_SESSION_ID]` with the value of `$CLAUDE_SESSION_ID`
- If unavailable, run `claude --print-session-id` or note "session ID unavailable"

Show the user:
1. The final draft (in full)
2. A brief summary: how many iterations, what the main changes were
3. Any unresolved ambiguities (see below)
4. Ask: "Does this TDD look correct? [approve / reject with notes]"

If approved → invoke: agents/coder.md
If rejected → treat rejection notes as a new critique round and return to
tdd-writer.md with those notes as blockers.

## Unresolved Ambiguities

If during the write/critique loop any question was asked that timed out and
a default was applied, those decisions MUST appear in a
"## Unresolved Ambiguities" section in the TDD before human review.
Each entry must include: the question, all options, the chosen default,
the rationale, and a note on how to override.

The absence of a UA entry for any timed-out question is a BLOCKER.
