---
name: weekly-content-brief
description: "Generates a weekly TikTok content brief for Darrell by scanning Git activity and writing 3 ranked video angles to the vault. Use this skill every Sunday evening, or whenever Darrell asks for content ideas, video topics, what to record this week, or what to talk about on TikTok."
allowed-tools:
  - Bash
  - Read
  - Write
---

# Weekly Content Brief

## Purpose

Encoded preference skill. Removes pre-production friction for off-the-cuff talking head videos.
Scans what actually happened this week, then produces 3 ready-to-record video angles in Darrell's voice.

Output: ~/Documents/DT Vault/1-projects/tiktok/Briefs/YYYY-MM-DD.md

Supporting files:
- scripts/scan-git.sh - scans active repos for this week's commits
- references/voice-rules.md - hook and tone rules from Darrell's voice guide
- examples/sample-brief.md - correctly formatted brief example

---

## Step 1: Scan Git Activity

Run the scan script and collect output:

  !`bash ~/.claude/skills/weekly-content-brief/scripts/scan-git.sh`

Returns commit messages from the last 7 days across all active repos.
Skip repos with no commits silently.


## Step 2: Check Existing Seeds and Recent Briefs

Read the content flywheel to avoid duplicating already-posted seeds:
  ~/Documents/DT Vault/1-projects/Content Flywheel.md

List ~/Documents/DT Vault/1-projects/tiktok/Briefs/ to see angles from the last 3 briefs.
Don't repeat an angle already suggested recently.

---

## Step 3: Generate 3 Ranked Video Angles

Load references/voice-rules.md before writing any hooks or talking points.

### The Audience
Mid-level engineers (dev or ops background) trying to break into DevOps/SRE roles.
They see tools on job postings and want to understand them well enough for interviews and on the job.
They're motivated by career progression — getting hired, getting promoted, getting paid more.
They don't need to be talked down to. They need the mental model that connects what they know to what they don't.

### Content Pillars (start here, not from git activity)
1. Mental models over tool memorization — knowing WHY beats knowing HOW
2. Building an online presence that attracts jobs to you
3. Grace and kindness on the learning journey — the world is hard enough

### How to Use Git Activity
Git activity is EVIDENCE, not the angle. The angle comes from the audience's pain point.

BAD: "I rewrote 7 community posts" (work report — audience doesn't care about your workflow)
GOOD: "You're reading docs for tools you'll never use on the job" (audience pain → your rewrite is the proof)

BAD: "My homelab broke at 2 AM" (cool story about you)
GOOD: "What happens when prod goes down and you're 8,000 miles away?" (career fear → your homelab story is the illustration)

For each angle, ask: "What is the viewer getting from this?" If the answer is "insight into Darrell's week," rewrite it. If the answer is "a mental model, career strategy, or emotional permission they needed," ship it.

### Ranking Priority
1. Audience value — does this help someone get hired, get promoted, or stop beating themselves up?
2. Dual audience — lands for devs AND ops people (never assume which side)
3. Flywheel alignment — drives Skool signups or consulting credibility
4. Recency — git activity from this week makes it feel genuine, not manufactured

### Angle Structure

## Angle [N]: [Audience-facing punchline — max 8 words]

**Hook:** [First 1-2 sentences on camera. Starts with THEIR pain, fear, or question — not your activity. Mid-story or direct question. Creates "wait, what?" reaction.]

**Talk about:**
- [The audience problem or misconception this addresses]
- [Your specific experience/story as proof — this is where git activity shows up]
- [The takeaway they can apply to their own career]

**Evidence:** [Which git activity or real work makes this authentic this week]

**Flywheel:** [Skool signup / consulting credibility / community discussion]


---

## Step 4: Add Raw Material Footer

After the 3 angles, append:

## This Week's Raw Material
- [one bullet per repo/item with activity - anonymize client names]

Audit trail so Darrell can see what fed the brief.

---

## Step 5: Write Output File

Create directory if missing:
  mkdir -p ~/Documents/DT\ Vault/1\ Projects/tiktok/Briefs/

Write to: ~/Documents/DT Vault/1-projects/tiktok/Briefs/YYYY-MM-DD.md
Use today's date for filename. See examples/sample-brief.md for full file format.

---

## Step 6: Confirm

Print to stdout:
  Brief written to ~/Documents/DT Vault/1-projects/tiktok/Briefs/YYYY-MM-DD.md
  Angles:
    1. [one-liner]
    2. [one-liner]
    3. [one-liner]

---

## Scheduler Note

No interactive prompts. Runs autonomously.
Cron: 0 19 * * 0 (Sundays 7pm)
Register: "Schedule weekly-content-brief every Sunday at 7pm, read-only execution."
