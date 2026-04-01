---
name: tiktok-pipeline
description: Process raw TikTok videos through the contentops pipeline. Use this skill whenever the user mentions new videos to process, TikTok pipeline, contentops, processing videos from Downloads, or wants to run the video pipeline on MOV/MP4 files. Also triggers when the user says "process these videos," "run the pipeline," "new videos in downloads," or "move videos." This skill handles the full workflow from raw footage to archived, organized output.
---

# TikTok Video Pipeline

This skill orchestrates the contentops video pipeline workflow. Contentops calls Claude internally for title generation and transcription fixing, so pipeline commands must be run by the user outside of Claude Code — nesting Claude inside Claude doesn't work.

## Workflow

### Step 1: Find raw footage

Search Downloads for the most recent MOV/MP4 files. The user will confirm which files are the new ones. Use modification date to identify candidates:

```bash
find ~/Downloads -maxdepth 2 -iname "*.mov" -o -iname "*.mp4" | xargs ls -lt | head -15
```

### Step 2: Move raw footage into the tiktoks working directory

Move (not copy) the confirmed files into the `tiktoks/` directory flat — no subfolders yet. Folder naming happens after the pipeline runs, because contentops generates the titles and metadata that inform the slug.

```
tiktoks/
├── IMG_2975.MOV    ← raw, waiting for pipeline
├── IMG_2976.MOV
├── models/
│   └── ggml-base.en.bin
└── ...existing archived folders...
```

### Step 3: Generate pipeline commands and copy to clipboard

Generate one command per video file. Use `pbcopy` to put all commands on the user's clipboard so they can paste into a separate terminal.

Template:
```
contentops pipeline <filename> --model models/ggml-base.en.bin --min-silence-ms 200
```

The user runs these from inside the `tiktoks/` directory. Key flags:
- `--model`: always `models/ggml-base.en.bin` (relative from tiktoks/)
- `--min-silence-ms 200`: Darrell's preferred silence threshold
- `--text $'Line One\nLine Two'`: optional, skip to let contentops auto-generate titles via Claude
- `-o <path>`: optional, defaults to `{stem}_pipeline.mp4` next to the input

Tell the user the commands are on their clipboard and to run them one at a time.

### Step 4: Wait for user to finish

The user will tell you when pipeline runs are complete. Don't proceed until they confirm.

### Step 5: Read metadata and archive into named folders

After the pipeline finishes, each input file produces:
- `{stem}_pipeline.mp4` — the final processed video
- `{stem}_pipeline_tiktok.json` — title, description, hashtags

Read each `_tiktok.json` to extract the title. Derive a folder slug from the title:
- Lowercase, hyphenated, 3-5 words max
- Prefix with today's date: `YYYY-MM-DD_slug`

Create the folder and move files into it with standardized names:

| Source | Destination |
|---|---|
| `IMG_XXXX.MOV` | `YYYY-MM-DD_slug/raw.MOV` |
| `IMG_XXXX_pipeline.mp4` | `YYYY-MM-DD_slug/final.mp4` |
| `IMG_XXXX_pipeline_tiktok.json` | `YYYY-MM-DD_slug/metadata.json` |

### Reference: contentops commands

| Command | Purpose |
|---|---|
| `contentops pipeline` | Full workflow: scale → normalize → transcribe → fix → cut silence → captions → overlay |
| `contentops cut` | Silence removal only |
| `contentops caption` | Transcribe + burn subtitles only |
| `contentops overlay` | Title card animation only |
| `contentops doctor` | Check prerequisites (ffmpeg, whisper-cli, etc.) |

### Reference: tuning flags

| Flag | Default | Notes |
|---|---|---|
| `--min-silence-ms` | 300 | Darrell prefers 200 |
| `--vad-threshold` | 0.5 | Lower = more sensitive to speech |
| `--font-size` | auto | Override title font size in pixels |
| `--no-interactive` | off | Auto-select first title (for scripting) |
| `--verbose` | off | Show full FFmpeg output |
| `--dry-run` | off | Preview stages without executing |
