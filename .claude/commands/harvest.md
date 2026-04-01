---
description: "Harvest insights, decisions, and learnings from this session into Darrell's Obsidian vault."
disable-model-invocation: false
allowed-tools:
  - Bash
  - Read
  - Write
  - mcp__basic-memory__write_note
  - mcp__basic-memory__edit_note
  - mcp__basic-memory__read_note
  - mcp__basic-memory__search_notes
---

# /harvest

Extract what matters from this session and write it back to the right places in the vault.
Run this manually at the end of any substantive session — never auto-triggered.

## What to capture

Read the current session transcript. Look for:

**Decisions** — a choice was made and the reasoning matters. Architecture calls, tooling choices, tradeoffs, things ruled out and why.

**Learnings** — things discovered with lasting reference value. How something actually works, a gotcha, a mental model that shifted.

**Open threads** — unresolved questions, things to follow up on, problems identified but not solved.

**Content seeds** — angles, stories, or insights that could become TikTok videos or newsletter content. Specific, not abstract.

**Project state changes** — a project moved forward, client situation changed, or a system was modified in a notable way.

## Routing

Load ~/.claude/commands/harvest-routing.md for the full vault routing table.
Route each item to the correct location. Prefer appending to existing notes over creating new ones.

## Output format per item

```
### [One-line title] — [YYYY-MM-DD]

**Type:** Decision | Learning | Open thread | Content seed | Project update

[2-4 sentences. What happened, what was decided or learned, why it matters.
Concrete enough that future-Darrell understands without needing the conversation.]

**Context:** [session topic in 3-5 words]
```

## Process

1. Read the session transcript
2. Identify 2-6 items worth keeping — be selective, noise degrades the vault
3. For each item, determine vault location using harvest-routing.md
4. Write via Basic Memory MCP — append to existing notes where possible
5. Update _CONTEXT.md if the situation meaningfully changed
6. Print a brief summary: what was written and where

## Selectivity rule

Skip: dead ends with no insight, purely mechanical tasks, info already documented elsewhere, anything irrelevant in 2 weeks.
A good harvest is 2-4 high-signal items, not a log.
