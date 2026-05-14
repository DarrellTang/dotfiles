# Always-On Constraints

These rules apply to every session regardless of project. The vault at `~/Documents/DT Vault/` is the single source of truth — read referenced files for full detail.

## Identity
Darrell Tang: SRE/DevOps consultant (DT Consulting LLC, S-Corp). Day job at IDA/LexisNexis. Clients: HFD, PatentBots, P3MS. Content brand: Darrell Does DevOps (TikTok, Skool). DT Consulting ≠ Darrell Does DevOps — never conflate.

## Core Rules
- Short single-line git commits. Always push after work unless told not to. Verify `gh auth status` before GitHub ops.
- Research docs/APIs BEFORE implementing. Validate through primary interaction before committing.
- Code is self-documenting — no unnecessary comments. Practical solutions over abstract patterns. Don't over-engineer.
- Tables, diagrams, lists over prose. Scannable over narrative. READMEs ~50 lines unless complex.
- Use `qmd` to search the vault BEFORE the filesystem. Prefer `qmd query` for exploratory searches.

## Infrastructure (HFD, PatentBots, Homelab)
- CLI over console. Scriptable commands over portal/GUI.
- PRs linked to work items immediately. Never curly-brace placeholders (`REPLACE_HERE` not `{VALUE}`).
- K8s: one manifest per file, no `---` separator. ADO.NET: `Data Source` not `DataSource`.
- HFD KV references always versionless. See vault: `constraint-library.md`, `terraform-conventions.md`.

## Content (TikTok, Skool)
- No hashtags. "Skool" not "school." See vault: `darrells-voice-guide.md`, `writing-style-guide-anti-ai-voice.md`.

## Consulting
- Sell outcomes not methods. Don't mention AI tooling as a selling point.
- HFD is staff augmentation, not leadership. P3MS is ongoing, not "delivered."
- HFD rate: $45/hr. See vault: `constraint-library.md`.

## Writing (outward-facing)
- Professional not corporate. Concrete over vague. Declarative knowledge over procedural.
- Banned: "dive into," "unlock," "game-changer," "imagine if," "let that sink in," "delve," "foster," "moreover."
- Red-green colorblind — never use color as sole differentiator. Shape is the primary semantic channel.
- Full voice guides in vault: `darrells-voice-guide.md`, `writing-style-guide-anti-ai-voice.md`, `writing-style-guide-inter-teammate-voice.md`.

## Pi-Specific
- `Ctrl+L` model select, `Ctrl+P` cycle. `Enter` = steering (interrupts). `Alt+Enter` = follow-up (waits).
- `@` to fuzzy-search files. `Ctrl+V` to paste images. Skills loaded on-demand (progressive disclosure).
- Subagents: scout/researcher = Flash+medium. planner/worker/reviewer/oracle = Pro+high.
