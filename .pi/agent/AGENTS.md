# Global Claude Code Conventions

## Git Commits
- Use short, single-line commit messages only
- No commit body or extended description
- Skip the Claude Code attribution footer and Co-Authored-By line
- Always push commits after completing work unless explicitly told not to
- Before creating repos, pushing, or any GitHub operation: run `gh auth status` to verify the active account is correct for the project

## GitHub Accounts
Two accounts are configured via `gh auth`. Always verify before creating repos or pushing to new remotes.

| Account | Use for | Orgs |
|---------|---------|------|
| `DarrellTang` | Personal projects, homelab, content | `darrelldoesdevops`, `tanghome-us` |
| `darrell-tang-consulting` | Client/consulting work, PatentBots | `darrelldoesdevops`, `OppX-AI` |

Switch with: `gh auth switch --user <account>`

## Pull Requests
- Keep PR descriptions brief (1-3 bullet points max)
- No lengthy summaries or test plans
- Skip the Claude Code attribution footer

## Work Style
- Research documentation and APIs BEFORE implementing, not after debugging failures
- When looking for project documents, notes, or saved context, use `qmd` (CLI or MCP) to search the vault BEFORE searching the filesystem
- Validate changes through primary interaction pattern before committing
- Optimize for token efficiency: minimize redundancy, respect context limits
- Keep READMEs concise (~50 lines max unless complex)

## Documentation
- Tables, diagrams, and lists preferred over prose
- Scannable over narrative
- Include actionable content: commands, examples, troubleshooting
- Brief "why" context for architectural decisions

## Code Quality
- No unnecessary comments - code should be self-documenting
- Practical, working solutions over abstract patterns
- Don't over-engineer; solve the current problem

## Kubernetes Manifests
- One manifest per file - never use `---` separator for multiple documents
- Name files descriptively after the resource (e.g., `letsencrypt-prod-issuer.yaml`)

## Skill Development
- Use `document-skills:skill-creator` (Anthropic) for creating/improving skills, it has eval benchmarks and description optimization

## Writing From Darrell's Perspective
- When drafting ANYTHING that comes from Darrell (client emails, proposals, SOWs, community posts, blog content, video scripts, LinkedIn posts, status reports, or any outward-facing communication), ALWAYS read the relevant voice guides from the vault first:
  - `3-resources/darrells-voice-guide.md` — master voice reference
  - `3-resources/writing-style-guide-anti-ai-voice.md` — banned words/phrases, anti-AI patterns
  - `3-resources/writing-style-guide-inter-teammate-voice.md` — peer-to-peer comms (Slack, Trello, PR comments, email threads with teammates/clients)
- For teammate/client messages (Slack, Trello, email threads): read the inter-teammate voice guide, not the content voice guide
- For client emails and consulting deliverables: professional but not corporate, concrete over vague
- For content: follow the full voice guide including audience rules and three-tier test

## Constraint Library
- At conversation start, read `~/Documents/DT Vault/3-resources/constraint-library.md`
- These are hard rules from repeated corrections, not suggestions
- For domain-specific work, also read the linked references:
  - Content: darrells-voice-guide.md, writing-style-guide-anti-ai-voice.md
  - Infrastructure: coding/terraform-conventions.md
- When the user says "log that", append the correction to the Constraint Library by editing the file directly

## Vault (Knowledge Base)
The vault at `~/Documents/DT Vault/` is a persistent, compounding knowledge base organized by PARA:
- `1-projects/` — active initiatives with defined outcomes
- `2-areas/` — ongoing responsibilities
- `3-resources/` — reference material
- `4-archive/` — completed/inactive items
- `templates/` — note templates

### Naming Convention
All files and folders use **lowercase-hyphenated** names (e.g., `dt-consulting-llc`, `constraint-library.md`). No Title Case, no spaces, no em dashes in filenames. Special files keep underscore prefix: `_context.md`, `_index.md`.

### Search (qmd)
Use `qmd` for vault search. Available as MCP tools (`qmd query`, `qmd get`, `qmd multi_get`) or CLI:
```bash
qmd search "keyword"      # fast BM25 keyword search
qmd vsearch "concept"     # semantic vector search
qmd query "question"      # hybrid + LLM reranking (best quality)
qmd get "path/to/file.md" # retrieve specific document
```
Prefer `qmd query` for exploratory searches. Use `qmd search` when you know the exact terms.

### Writing Notes
Write vault notes using the native Write/Edit tools. Use this frontmatter format:
```markdown
---
title: note-title
type: note
tags:
- relevant-tag
permalink: note-title
---
```

### Ingest Workflow
When a new source arrives (article, video, research, conversation insight):
1. Create the note in the appropriate PARA folder
2. Search qmd for 3-5 related pages: `qmd query "topic of new source"`
3. Update each related page with cross-references (`[[new-note]]`) where relevant
4. Append to `log.md`: `## [YYYY-MM-DD] ingest | Source Title`
5. After writing, run `qmd update && qmd embed` to re-index

### Query Workflow
When answering questions from vault knowledge:
1. Search with `qmd query "the question"`
2. Read the top results
3. Synthesize the answer
4. If the answer is substantial and reusable, offer to file it as a new vault page (triggers ingest workflow)

### Lint (Weekly)
Periodic vault health check. Look for:
- Files outside PARA structure
- Naming convention violations (uppercase, spaces)
- Orphaned pages (no inbound wiki-links)
- Stale claims in `_context.md` that don't match current vault state
- Missing cross-references between related pages

## Sunsama Integration
- MCP server `mcp-sunsama` available globally
- Streams map to: IDA, HFD, Upwork, TikTok, Skool, PatentBots, DT Consulting, P3MS (work) + personal, exercise, meals
- User does nightly planning ritual: planning tonight = tasks for TOMORROW
- Always confirm day-of-week from the actual date before scheduling. Don't assume date offsets, compute them.
- Sunsama API uses UTC dates. User is in US Pacific timezone (America/Los_Angeles).
- Recurring meetings: IT Ops Standup 8:30 AM daily (HFD), IDA standup 9:30 AM daily, Studium trash cans Wednesdays EOD
