---
name: youtube-insight-harvest
description: "Use when the user shares a YouTube URL and wants to extract insights, discuss the content, and save structured notes to their Obsidian vault. Also use when the user says 'harvest this video', 'process this video', 'what did this video say', or wants to turn a YouTube video into actionable knowledge. Triggers on any YouTube URL (youtube.com or youtu.be) paired with intent to learn from or discuss the content."
---

# YouTube Insight Harvest

Process YouTube videos into structured vault notes through a two-phase workflow: automated extraction followed by collaborative discussion. The skill separates mechanical steps (transcript + summary) from judgment steps (discussion + vault placement) because the discussion is where the real value happens.

## Dependencies

- `yt-dlp` (installed via Homebrew)
- Basic Memory MCP (for vault search and note creation)
- Transcript cleanup script: `~/.claude/skills/youtube-insight-harvest/scripts/clean-transcript.py`

## Phase 1: Automated Extraction (No Human Input Needed)

Run these steps without stopping to ask the user anything.

### Step 1: Download Transcript

```bash
yt-dlp --write-auto-subs --sub-langs en --skip-download --convert-subs srt \
  -o "/tmp/youtube-transcript/%(title)s" "<URL>"
```

**Fallback chain if transcript download fails or content seems wrong:**
1. Try `--sub-langs en-orig` (some videos use `en-orig` instead of `en`)
2. Try `--write-subs` instead of `--write-auto-subs` (manual subs)
3. Try `--list-subs` to see what subtitle tracks exist and pick the best English one
4. If all fail, tell the user no transcript is available

**Sanity check:** After downloading, read the first few lines of the transcript. If the content doesn't match the video title (wrong video's subtitles), try the next subtitle track. The `en` track occasionally returns subtitles from a different video — `en-orig` is usually the correct fallback.

### Step 2: Clean the Transcript

```bash
python3 ~/.claude/skills/youtube-insight-harvest/scripts/clean-transcript.py \
  "/tmp/youtube-transcript/<title>.en.srt" \
  "/tmp/youtube-transcript/clean_transcript.txt"
```

SRT files have duplicate lines from subtitle timing overlaps. The script deduplicates and strips timestamps to produce readable text.

### Step 3: Read and Summarize

Read the cleaned transcript. Produce a summary with these sections:

**Video metadata block:**
- Title, source URL, creator name, approximate length

**Frameworks** — Mental models, conceptual structures, or ways of thinking about problems that the speaker proposes. These are the reusable lenses the user can apply to their own work. Extract the structure, not just the conclusion.

**Decision Heuristics** — Concrete rules of thumb or principles for making decisions. Things the user could apply tomorrow. Write them as direct, actionable statements.

**Provocations** — Claims that challenge conventional thinking or the user's current assumptions. These don't need to be "right" — they need to be worth sitting with. Include enough context that the provocation makes sense without re-reading the transcript.

**Open Questions** — Things the video raises but doesn't fully resolve, or things that are interesting but the user would need to test against their own experience before adopting.

Not every video will have meaningful content in all four categories. If a section would be empty or forced, skip it. A short technical tutorial might only produce Decision Heuristics. A philosophical talk might be mostly Provocations. Match the structure to the content.

### Step 4: Pull Vault Context

Search Basic Memory for notes related to the video's key topics. Look for:
- Existing notes that the video's ideas connect to
- Existing workflows or patterns that the video validates or challenges
- Strategic context that helps the user evaluate relevance

Include 2-4 relevant vault connections in the summary. If nothing relevant exists, say so — don't force connections.

### Step 5: Present for Discussion

Present the summary and vault connections to the user. End with an open prompt — something like "What resonated?" or "Where do you want to dig in?" rather than a specific question.

This is where Phase 1 ends and the conversation becomes collaborative. The user may want to:
- Discuss specific ideas and how they apply to their situation
- Challenge or refine the frameworks
- Connect insights to current projects or decisions
- Identify actions to take

Follow the conversation naturally. Don't rush toward vault storage.

## Phase 2: Save to Vault (After Discussion)

Only after the discussion has reached a natural stopping point — or the user asks to save — create the vault note.

### Vault Note Structure

Save via `mcp__basic-memory__write_note` to `3-resources/` with the project set to `obsidian`.

**Title format:** `YouTube - <Short Descriptive Title> (<Creator Name>)`

**Tags:** Always include `youtube` plus topic-relevant tags and the creator's name as a tag.

**Content structure:**

```markdown
# YouTube - <Short Descriptive Title> (<Creator Name>)

**Source:** <URL>
**Watched:** <YYYY-MM-DD>
**Creator:** <Name>

## Frameworks
[extracted frameworks — include enough context to be useful standalone]

## Decision Heuristics
[actionable rules of thumb as direct statements]

## Provocations
[claims worth sitting with — include context]

## Open Questions
[unresolved or untested ideas]

## Actions Taken
[what the user decided to do based on this video — filled in from the discussion]

## Related
[wikilinks to connected vault notes discovered during vault context pull]
```

If a section was skipped in the summary, skip it in the vault note too.

### Borrowed vs. Owned Taste

Some videos will produce insights the user wants to adopt as their own constraints (because they already have the domain experience to validate them). Others will produce "borrowed taste" — frameworks from trusted sources that the user is testing but hasn't fully internalized yet.

If the discussion surfaces constraints the user wants to encode as durable rules, offer to add them to the [[Constraint Library]] as well. Don't do this automatically — the user decides what graduates from "interesting idea" to "hard rule."

## What This Skill Is NOT

- Not a transcription service. The transcript is a means to an end.
- Not a summary generator. The summary is a conversation starter, not the deliverable.
- Not an auto-save tool. The vault note is created after discussion, incorporating what the user actually found valuable — not a dump of everything the video said.

The value is in the discussion phase. The automation exists to get there faster.
