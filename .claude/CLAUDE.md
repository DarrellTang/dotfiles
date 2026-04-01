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
- When looking for project documents, notes, or saved context, check MCP tools (especially basic-memory) BEFORE searching the filesystem
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
- Use `document-skills:skill-creator` (Anthropic) for creating/improving skills — it has eval benchmarks and description optimization
- Use `superpowers:brainstorming` for ideation and design before skill creation
- Use `superpowers:writing-plans` for implementation planning
- Other superpowers skills (debugging, code review, git workflows) remain as-is

## Writing From Darrell's Perspective
- When drafting ANYTHING that comes from Darrell (client emails, proposals, SOWs, community posts, blog content, video scripts, LinkedIn posts, status reports, or any outward-facing communication), ALWAYS read the relevant voice guides from Basic Memory first:
  - `reference/darrells-voice-guide` — master voice reference
  - `reference/writing-style-guide-anti-ai-voice` — banned words/phrases, anti-AI patterns
  - `reference/writing-style-guide-inter-teammate-voice` — peer-to-peer comms (Slack, Trello, PR comments, email threads with teammates/clients)
- For teammate/client messages (Slack, Trello, email threads): read the inter-teammate voice guide, not the content voice guide
- For client emails and consulting deliverables: professional but not corporate, concrete over vague
- For content: follow the full voice guide including audience rules and three-tier test

## Constraint Library
- At conversation start, search Basic Memory for "Constraint Library" and read the note
- These are hard rules from repeated corrections — not suggestions
- For domain-specific work, also read the linked references:
  - Content: Darrell's Voice Guide, Writing Style Guide — Anti-AI Voice
  - Infrastructure: Terraform Conventions
- When the user says "log that", append the correction to the Constraint Library via Basic Memory edit_note
