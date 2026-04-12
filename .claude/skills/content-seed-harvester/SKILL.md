---
name: content-seed-harvester
description: "Harvests pain signals from Reddit DevOps communities and classifies them into TAYA Big 5 content categories. Feeds the weekly-content-brief with audience-driven content seeds. Use this skill every Sunday at 6pm (before weekly-content-brief), or whenever the user asks to scan Reddit for content ideas, find what people are struggling with, refresh the pain bank, look for video topics, check what the audience needs, or generate content seeds. Also use when the user mentions pain discovery, audience research, or Reddit scraping for content."
allowed-tools:
  - Bash
  - Read
  - Write
---

# Content Seed Harvester

## Purpose

Automated pain discovery for DevOps content creation. Scans Reddit communities where the target audience (mid-level engineers breaking into DevOps) asks questions, vents frustrations, and shares breakthroughs. Extracts pain signals, classifies them using the "They Ask, You Answer" Big 5 framework, and writes them to a pain bank in the vault.

The pain bank becomes an input to the weekly-content-brief skill, shifting content angles from "what Darrell did this week" to "what the audience actually needs."

Output: ~/Documents/DT Vault/1-projects/tiktok/pain-bank.md

Supporting files:
- scripts/fetch-reddit.sh — fetches and parses Reddit RSS feeds into structured TSV
- references/taya-big5.md — Big 5 classification rules with DevOps examples
- references/intent-patterns.md — high-intent post filtering patterns
- examples/pain-bank-format.md — exact output format contract

---

## Step 1: Fetch Reddit Feeds

Run the fetch script and collect output:

  !`bash ~/.claude/skills/content-seed-harvester/scripts/fetch-reddit.sh`

This fetches RSS feeds from 5 subreddits (r/devops, r/kubernetes, r/sysadmin, r/ITCareerQuestions, r/homelab), both /new/ and /top/?t=week for each. Returns a TSV file at `/tmp/content-seed-harvester/raw-posts.tsv` with columns: subreddit, feed_type, title, author, link, date, body.

Takes about 60 seconds due to rate limiting between requests.

If the script reports 0 posts fetched, Reddit may be down or rate-limiting. In that case, skip to Step 10 and report "No posts fetched — Reddit may be unavailable. Existing pain bank unchanged."

---

## Step 2: Read Existing Pain Bank

Read the current pain bank if it exists at this exact path:
  ~/Documents/DT Vault/1-projects/tiktok/pain-bank.md

If the file does not exist, this is the first run — start with zero entries. Do not seed from the example format file (examples/pain-bank-format.md) — that file only shows the output structure, its entries are fictional placeholders. On a first run, every entry in the output will be new.

If the file does exist, note existing entries and their fingerprints for deduplication in Step 6.

---

## Step 3: Load References

Read both reference files before processing:

  ~/.claude/skills/content-seed-harvester/references/taya-big5.md
  ~/.claude/skills/content-seed-harvester/references/intent-patterns.md

These guide the filtering (Step 4) and classification (Step 5) decisions.

---

## Step 4: Filter for High-Intent Posts

Read the TSV output from Step 1. For each post, apply the intent patterns from references/intent-patterns.md.

**Keep** posts that match at least one include pattern: direct confusion, rant/frustration, revelation, decision anxiety, or career direction.

**Discard** posts that match any exclude pattern: link-only with no body text, under 50 words, bot/moderator posts, job postings, meta threads.

Target: 15-40 filtered posts from the ~250 raw posts. If fewer than 10 pass the filter, relax the word count threshold to 30 words. If more than 50 pass, tighten to posts matching 2+ include patterns.

---

## Step 5: Classify Into TAYA Big 5

For each filtered post, classify into one Big 5 category using the rules in references/taya-big5.md:

1. **Cost/Price** — calculating ROI, worried about money
2. **Problems/Negatives** — something going wrong, frustration, fear
3. **Versus/Comparisons** — choosing between options
4. **Reviews** — wanting honest, unfiltered assessments
5. **Best-of Lists** — wanting curated recommendations

Assign one primary category per post. When a post fits multiple categories, use the tie-breaking rules in the reference doc. Prefer underrepresented categories to keep the bank balanced over time.

---

## Step 6: Deduplicate and Merge

For each classified post, generate a fingerprint: the subreddit name + the 3-5 most meaningful keywords from the title (stop words removed, lowercased). This fingerprint is intentionally loose — two posts about "terraform state locking issues" from different weeks should be recognized as the same underlying pain.

Compare against existing pain bank entries:
- **Match found** (similar keywords, same general topic): increment the recurrence count on the existing entry. Append the new link, date, and a representative quote to its "also seen" list. Do not create a duplicate. Each sighting should contribute its own quote so the entry builds a richer picture of the pain over time.
- **No match**: create a new entry.

The recurrence count is the most valuable signal in the pain bank — it tells you how many people independently expressed the same pain. The collection of quotes across sightings is the second most valuable — it shows how different people frame the same struggle.

---

## Step 7: Distill Pain Statements

For each new entry (not a recurrence bump), write a one-liner pain statement. This is the bridge between raw Reddit noise and a content angle.

Rules:
- Written from the audience member's perspective, not yours ("I can't figure out..." not "Users struggle with...")
- One sentence, max 15 words
- Captures the emotional core, not the technical detail
- Uses language the audience would actually say

Examples:
- Raw title: "System Design coming from a purely Systems / Cloud Infra background"
  Pain: "I don't have a CS degree and system design interviews terrify me"
- Raw title: "Stuck in a company with no Git workflow, no PRs"
  Pain: "Nobody at my job cares about engineering practices and I feel stuck"
- Raw title: "Is CKA worth it in 2026?"
  Pain: "I can't tell if this cert will actually help me get hired"

---

## Step 8: Write Pain Bank

Read examples/pain-bank-format.md for the output structure and field layout. The entries in that file are fictional examples — do not copy them into the output. Only write entries that came from the Reddit data you processed in Steps 4-7, plus any real entries that were already in the existing pain bank from Step 2.

Create directory if missing:
  mkdir -p ~/Documents/DT\ Vault/1-projects/tiktok/

Write to: ~/Documents/DT Vault/1-projects/tiktok/pain-bank.md

Organize entries by Big 5 category (H2 sections). Each entry includes:
- Pain statement (H3)
- Recurrence count
- Subreddit
- **Raw quotes** — extract 2-3 key sentences from the post body, not just one. Pick the sentences with the most emotional weight or specificity. These are the exact words Darrell can reference when scripting a hook.
- Link
- First-seen date
- Also-seen list (if recurrence > 1) — each sighting should include its own representative quote and subreddit, so the entry builds a fuller picture. Format: `2026-04-12 (r/devops) — "their quote here"`
- Fingerprint

Update the "Last harvested" line in the header with today's date and current counts.

---

## Step 9: Age Out Old Entries

Move entries whose most recent sighting (either first-seen or latest also-seen date) is older than 8 weeks to the `## Archive` section at the bottom of the file.

Do not delete archived entries — high-recurrence archived items are especially valuable because they represent persistent, evergreen pain that never goes away. The archive is a goldmine for content that compounds.

The weekly-content-brief only reads the active sections (above the Archive heading).

---

## Step 10: Confirm

Print to stdout:

```
Pain bank updated — YYYY-MM-DD
New seeds: [N]
Recurrence bumps: [N]
Aged out: [N]
Top pain this week: [highest-recurrence new or bumped entry's pain statement]
Bank: ~/Documents/DT Vault/1-projects/tiktok/pain-bank.md
```

---

## Scheduler Note

No interactive prompts. Runs autonomously.
Cron: 0 18 * * 0 (Sundays 6pm — 1 hour before weekly-content-brief)
Register: "Schedule content-seed-harvester every Sunday at 6pm."
