---
name: lbos-domain-researcher
description: "Research and build out a domain in the Lifestyle Business OS repo. Takes a domain number and produces populated subdomain files with classified atomic actions. Uses NotebookLM for multi-expert research synthesis and Basic Memory for vault context. Triggers on '/lbos-domain-researcher' or 'research domain [number]' or 'build out domain [number]' in the context of the lifestyle-business-os repo."
---

# LBOS Domain Researcher

Research a single domain of the Lifestyle Business OS taxonomy, synthesize multi-expert perspectives via NotebookLM, and produce classified atomic action files per subdomain.

## Dependencies

- `yt-dlp` (YouTube search)
- `notebooklm` CLI (installed via `uv tool install notebooklm-py[browser]`)
- Basic Memory MCP (vault context)
- Repo: `~/codeWorkspace/lifestyle-business-os`

## Input

The user provides a domain number (e.g., `07`) or name (e.g., "Demand Generation"). The skill reads the taxonomy to determine subdomains and relevant experts.

## Reference Files

- `~/codeWorkspace/lifestyle-business-os/TAXONOMY.md` — full domain/subdomain definitions and expert sources
- `~/codeWorkspace/lifestyle-business-os/SOURCES.md` — existing source registry
- `~/codeWorkspace/lifestyle-business-os/MVP-PIPELINE.md` — minimum viable pipeline context

## Step 1: Load Context

Run these automatically without asking the user.

### 1a. Read the taxonomy

Read `TAXONOMY.md` and extract:
- The domain name and description
- All subdomains with their definitions
- Named frameworks and source authors for this domain

### 1b. Read existing sources

Read `SOURCES.md` to check if this domain already has sources curated. If yes, skip to Step 3.

### 1c. Pull vault context

Search Basic Memory (project: obsidian) for Darrell-specific context relevant to this domain:
- Search for the domain topic (e.g., "demand generation", "audience building")
- Search for "Strategic Audit" for current business context
- Search for "Constraint Library" for hard rules

Compile a context block containing:
- Current clients: HFD (healthcare finance, staff aug), PatentBots (hourly), P3MS (retainer)
- Day job: IDA/LexisNexis SRE
- Education angle: DevOps career transition for sysadmins/network engineers
- Content: TikTok (active), Skool (community + field guides), LinkedIn (minimal)
- Acquisition: Upwork-first strategy
- Technical strengths: deep SRE, infrastructure, AI-native tooling, systems thinking
- Named frameworks: "The Dark Factory Framework" (undeveloped)

Augment this with anything found in the vault search results.

## Step 2: Source Discovery (Interactive)

### 2a. Identify expert candidates

From the taxonomy's named sources AND general YouTube search, find relevant content for this domain. For each expert candidate, run:

```bash
yt-dlp --flat-playlist --print "%(id)s | %(title)s | %(view_count)s views" "ytsearch8:[expert] [domain topic]" 2>&1 | grep -v "WARNING\|Extracting\|Downloading"
```

Search for:
- Every expert named in the taxonomy for this domain
- 2-3 additional experts the user has mentioned in past sessions (check vault for known thought leaders: Hormozi, Priestley, Dan Koe, Chris Do, April Dunford, Donald Miller, Dan Martell, Simon Squibb, GaryVee, Ali Abdaal, Aprilynne Alter, Caleb Ralston, Justin Welsh, James Smith)
- General topic searches to find domain-specific specialists not yet identified

Use subagents to parallelize searches across experts.

### 2b. Present candidates for curation

Present a deduplicated table of the top 15-20 videos, organized by subdomain coverage:

```
| Status | Title | Creator | URL | Why |
|--------|-------|---------|-----|-----|
| PICK   | ...   | ...     | ... | ... |
| MAYBE  | ...   | ...     | ... | ... |
| CUT    | ...   | ...     | ... | ... |
```

Recommend PICK/MAYBE/CUT based on:
- Relevance to THIS domain specifically (not cross-cutting generic content)
- Framework depth (not just motivation or surface advice)
- Expert credibility and view count as tiebreakers

### 2c. Wait for user approval

Ask the user to confirm, add, or remove sources. Do NOT proceed until they approve.

### 2d. Update SOURCES.md

Append the approved sources to `SOURCES.md` under a new domain section. Include the Expert Coverage Matrix update if new experts were added.

## Step 3: NotebookLM Setup

### 3a. Create notebook

```bash
notebooklm create "LBOS - Domain XX - [Domain Name]" --json
```

Parse the notebook ID from output.

### 3b. Set active notebook

```bash
notebooklm use [notebook_id]
```

### 3c. Load sources

For each PICK source, run in parallel:

```bash
notebooklm source add "[youtube_url]" --json
```

### 3d. Wait for processing

Check `notebooklm source list --json` until all sources show `status: ready`. Poll every 15 seconds if needed.

## Step 4: Subdomain Extraction

### 4a. Query per subdomain

For each subdomain, send a structured query to NotebookLM:

```bash
notebooklm ask "[prompt]" --json
```

Use this prompt template, customized per subdomain:

```
Based on all sources: What are the concrete, atomic actions for [SUBDOMAIN NAME] — [subdomain definition from taxonomy]?

Context: This is for a solopreneur building an AI-native lifestyle business. They have two audiences: (1) consulting clients — engineering directors at mid-market companies with infrastructure/DevOps problems, and (2) education customers — Windows sysadmins and network engineers wanting to transition to DevOps engineering roles.

List every discrete action, not general advice. For each action, note whether it requires:
- HUMAN judgment (cannot be delegated)
- AI-ASSIST (AI generates drafts/options, human makes final call)
- AI-AUTO (can be fully delegated to AI agents/tools)
```

Run all subdomain queries in parallel where possible.

### 4b. Parse responses

Extract the `answer` field from each JSON response. If responses are saved to files due to size, read and parse them.

## Step 5: Synthesis and File Generation

### 5a. Deduplicate across subdomains

Review all subdomain responses and:
- Identify actions that appear in multiple subdomains
- Assign each action to its primary subdomain
- Add cross-references ("Note: see also X.Y") for secondary appearances

### 5b. Apply Darrell context

For each action:
- Flag if already partially or fully done (based on vault context)
- Note relevant current clients/tools/projects
- Flag if action is phase-mismatched (belongs to a later execution phase)
- Adjust language from generic to Darrell-specific

### 5c. Write subdomain files

Create one `.md` file per subdomain in the domain directory. Follow this exact template:

```markdown
# X.Y Subdomain Name

## Definition
What this subdomain is and why it matters.

## Current State
Self-assessment: N/10 — [honest assessment based on vault context]

## "Good Looks Like"
What competence in this subdomain produces. 3-5 bullet points.

## Atomic Actions

- [ ] **[ACTION NAME]** `[AI-AUTO|AI-ASSIST|HUMAN]`
  - Input: what this action needs
  - Output: what this action produces
  - Frequency: one-time | periodic | continuous
  - Tools: what tools/systems support this action
  - Context: [Darrell-specific note if applicable]

## Key Frameworks & Sources
Which thought leaders/books/frameworks inform this subdomain.

## Dependencies
Which other subdomains feed into or consume from this one. Use X.Y notation.

## Status
NOT_STARTED
```

Self-assessment guidelines:
- 0-2: Haven't thought about this, no activity
- 3-4: Some ad-hoc activity but no framework or intentionality
- 5-6: Doing this but not optimized, room for systematic improvement
- 7-8: Operational and producing results
- 9-10: Optimized and compounding

### 5d. Update _index.md

If the domain's `_index.md` is still a placeholder, update it with proper subdomain listings and status.

## Step 6: Commit and Push

```bash
cd ~/codeWorkspace/lifestyle-business-os
git add [domain-directory]/ SOURCES.md
git commit -m "Add Domain XX [Name] subdomain files (N subdomains, M atomic actions)"
git push
```

## Step 7: Summary

Present a summary table:

```
| Subdomain | Actions | Self-Assessment | Key Insight |
|-----------|---------|----------------|-------------|
| X.1 ...   | N       | M/10           | ...         |
```

Note any cross-domain patterns observed (recurring action types, universal principles, things that showed up in earlier domains too).

## Error Handling

- If NotebookLM auth fails: prompt user to run `notebooklm login`
- If YouTube search returns garbage: try alternative search terms, ask user for specific URLs
- If a source fails to load in NotebookLM: skip it, note in summary, continue with remaining sources
- If NotebookLM rate limits on queries: wait 5 minutes, retry once, then ask user

## What This Skill Is NOT

- Not a replacement for doing the actual work — it maps what needs doing
- Not a one-shot automation — Step 2 (source curation) requires human judgment
- Not a generic research tool — it's purpose-built for the LBOS taxonomy structure
