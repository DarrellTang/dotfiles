---
name: weekly-plan
description: "Run a weekly planning session: scorecard recap of the past week, then propose and push next week's tasks to Sunsama. Use when Darrell asks for weekly planning, weekly recap, what to focus on this week, or wants to turn vault strategy into Sunsama tasks."
allowed-tools:
  - Bash
  - Read
  - Write
  - mcp__basic-memory__search_notes
  - mcp__basic-memory__read_note
  - mcp__sunsama__get-tasks-by-day
  - mcp__sunsama__get-tasks-backlog
  - mcp__sunsama__get-streams
  - mcp__sunsama__create-task
  - mcp__sunsama__update-task-planned-time
  - mcp__sunsama__update-task-stream
  - mcp__sunsama__update-task-notes
  - mcp__sunsama__update-task-snooze-date
  - mcp__sunsama__update-task-complete
  - mcp__sunsama__update-task-text
  - mcp__sunsama__delete-task
  - mcp__sunsama__create-subtasks
  - mcp__sunsama__reorder-task
---

# Weekly Planning Session

Run a full weekly scorecard + next-week planning session. Bridges vault strategy into Sunsama daily tasks.

## Step 1: Gather Data (parallel)

Run all of these in parallel:

1. **Sunsama tasks for past week** — Call `get-tasks-by-day` for each day Mon-Sun of the past week (7 calls). Use ISO date format (YYYY-MM-DD).
2. **Sunsama tasks for next week** — Call `get-tasks-by-day` for each day Mon-Sun of the coming week (7 calls). This shows existing scheduled tasks, recurring blocks, and calendar events so new tasks can be placed intelligently around existing commitments.
3. **Sunsama backlog** — Call `get-tasks-backlog`
4. **Sunsama streams** — Call `get-streams` (needed for stream ID mapping when creating tasks)
5. **Vault strategy docs** — Search basic-memory for:
   - "Content Flywheel" — content seeds, channel status
   - "Strategic Audit" — quarterly priorities
   - "Weekend Sprint Strategy" — validation plan
   - Recent harvests — decisions and open threads
   - Active client context (HFD, PatentBots, P3MS)

Reference `references/strategic-context.md` for vault navigation details.

## Step 2: Weekly Scorecard

Present a scorecard table to Darrell:

| Metric | Value |
|--------|-------|
| Tasks completed | X/Y (Z%) |
| By stream | IDA: X, HFD: X, Upwork: X, TikTok: X, etc. |
| Time invested | Xh estimated across completed tasks |
| Backlog age | X items, oldest from [date] |
| Strategy alignment | Which strategic priorities got attention vs ignored |

Then flag:
- **Stale backlog items** — anything >30 days old
- **Strategic gaps** — priorities with zero tasks completed
- **Silent streams** — streams with no activity this week

## Timezone

Darrell is in **America/Los_Angeles** (Pacific). Pass this timezone explicitly to any Sunsama API that accepts a `timezone` parameter (e.g., `get-tasks-by-day`, `reorder-task`).

## Darrell's Daily Structure (Weekdays)

**Source of truth:** `~/Documents/DT Vault/2-areas/lifestyle-business-os/time-energy/perfect-week-schedule.md` (from 4-day energy audit, 2026-03-26). Read this note before ordering tasks — don't duplicate it here, the energy map may evolve.

Key rules from the energy audit (apply when ordering):

1. **Never schedule high-value work before 10:30am.** Mornings are routine energy.
2. **Protect 10:30-13:00 (Peak #1) for consulting/creative work.** Revenue-generating window: proposals, deep consulting delivery, strategic content (e.g. Skool paid tier work).
3. **Batch IDA (day job) to 15:30-17:00 (Second Wind).** Neutral-energy work — don't burn peak hours on it.
4. **Eat by 13:30.** Lunch closes Peak #1, opens Recovery Zone.
5. **Afternoon Recovery (14:00-15:30)** is for walk, break, light admin.
6. **Side projects (DJing, personal content) → evening only (21:00+ second wind).**
7. **Weekends** are for content creation (TikTok filming, Skool), personal tasks, recording sessions.

Typical weekday order:
1. Morning routine (drop-offs, walk if morning) → calendar standups (IT Ops 8:30, IDA 9:30)
2. Peak #1: consulting delivery (P3MS, PatentBots, DT Consulting), strategic content
3. Lunch (before 13:30)
4. Recovery: walk, HFD work, light admin
5. Second Wind: IDA work batched here
6. Flex: pickups, household
7. Evening: side-project work (DnB discovery, streaming prep)

**Do NOT create** standalone HFD check-in tasks — the daily HFD standup (already a recurring calendar item) covers client communication.

## Step 3: Propose Next Week's Tasks

Cross-reference vault strategy docs with scorecard gaps. Pull from:

- **Content Flywheel** — content seeds, TikTok streak targets
- **Upwork-First strategy** — proposals target (3-5/week), profile optimization items
- **Weekend Sprint Strategy** — next validation steps
- **Client obligations** — HFD deliverables, PatentBots hours, P3MS follow-up
- **Backlog** — surface items that keep getting skipped (especially >30 days)

Propose **10-15 tasks** organized by stream, each with:
- Task title
- Stream assignment
- Time estimate (minutes)
- Day assignment (specific day if time-sensitive, otherwise "backlog")
- Brief rationale (which strategy doc or gap it addresses)

## Step 4: User Confirmation

Ask Darrell to confirm, adjust, or remove proposed tasks before pushing. Wait for explicit approval. Accept shorthand like "looks good", "ship it", or specific edits like "drop #3, move #7 to Tuesday".

## Step 5: Push to Sunsama

For each approved task:

1. `create-task` with title, `streamIds`, and `timeEstimate`. Do NOT use `snoozeUntil` for day assignment — it has a timezone bug that places tasks one day early.
2. `update-task-snooze-date` with `newDay` (YYYY-MM-DD) to assign the task to the correct day. This is the reliable method for day placement.
3. `update-task-notes` to add vault context links where relevant
4. `create-subtasks` for complex tasks that need breakdown

**Important:** `create-task` accepts `streamIds` and `timeEstimate` inline and these work correctly. Only day assignment needs the two-step approach.

For backlog cleanup during the session:
- `update-task-complete` to mark done items
- `update-task-text` to update stale task titles
- `delete-task` to remove duplicates or irrelevant items

Rules:
- Tasks with specific deadlines or day-sensitivity → assigned to that day via `update-task-snooze-date`
- Everything else → backlog (no date, skip the snooze-date call)
- Always set stream and time estimate
- Before creating tasks, review existing tasks for the target week to avoid overloading days and to place new tasks in gaps around existing commitments

After all tasks are created and assigned to days, **reorder every day** using `reorder-task` to match the daily structure. Reorder calls must be sequential (not parallel) — each call shifts positions. Order all tasks on each day top-to-bottom following the daily structure block order.

## Step 6: Summary

Print confirmation:

```
Weekly plan pushed to Sunsama:
  Scheduled: X tasks across Mon-Fri
  Backlog: Y tasks added
  Streams: [list of streams used]
  Total planned time: Xh
```
