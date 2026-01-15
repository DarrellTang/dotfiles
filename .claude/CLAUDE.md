# Global Claude Code Conventions

## Git Commits
- Use short, single-line commit messages only
- No commit body or extended description
- Skip the Claude Code attribution footer and Co-Authored-By line

## Pull Requests
- Keep PR descriptions brief (1-3 bullet points max)
- No lengthy summaries or test plans
- Skip the Claude Code attribution footer

## Work Style
- Research documentation and APIs BEFORE implementing, not after debugging failures
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
