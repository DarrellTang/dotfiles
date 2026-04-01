---
name: download-youtube-track
description: "Download YouTube tracks for DJing with intelligent naming and ID3 tagging. Use this skill whenever the user wants to download music from YouTube, grab a track, rip audio from a YouTube URL, or download tracks from their weekly DnB discovery list. Also triggers when the user mentions downloading DJ tracks, saving YouTube audio, or batch downloading checked items from an Obsidian discovery note. Even if they just paste a YouTube URL and say 'grab this' or 'download this', this skill applies."
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Agent
  - WebSearch
  - WebFetch
  - mcp__basic-memory__read_note
  - mcp__basic-memory__write_note
  - mcp__basic-memory__search_notes
---

# Download YouTube Track

Download YouTube audio for DJing with automatic research-based naming and ID3 tagging.

## Overview

This skill replaces Stacher as a YouTube-to-Rekordbox pipeline. It downloads audio, researches the correct canonical track name via web searches and YouTube cross-referencing, renames the file to `Artist - Title.mp3`, writes ID3 tags, and routes to the correct genre folder.

## Two Input Modes

### Mode 1: Single URL

The user provides a YouTube URL and optionally a genre.

**Examples:**
- "download this dnb track: https://youtube.com/watch?v=..."
- "grab this future funk track: https://youtube.com/watch?v=..."
- "download this: https://youtube.com/watch?v=..."

**Flow:**

1. **Download** the audio:
   ```bash
   yt-dlp -x --audio-format mp3 --audio-quality 0 \
     --output "$HOME/Music/dj/To Sort/%(fulltitle)s.%(ext)s" \
     "<URL>"
   ```
   If `%(fulltitle)s` produces an empty filename, fall back to `%(title)s`.

2. **Research the canonical name** by spawning a subagent (to protect the main context window). The subagent must:
   - Extract yt-dlp metadata: run `yt-dlp --dump-json "<URL>"` and parse `title`, `uploader`, `description`, `artist`, `track` fields
   - Web search for the track: query like `"<parsed track name>" <parsed artist> site:beatport.com OR site:discogs.com`
   - Search YouTube for the same track to see how other uploads name it
   - Cross-reference all sources to determine the canonical `Artist - Title`
   - Return a JSON object: `{ "artist": "...", "title": "...", "genre": "...", "album": "..." }`

   **Resolution priority** (most authoritative first):
   1. Beatport listing
   2. Discogs release
   3. Spotify track metadata
   4. YouTube consensus across multiple uploads
   5. yt-dlp metadata fields (`artist`, `track`)
   6. Cleaned yt-dlp title (fallback)

   **Cruft to strip** from YouTube titles: `[Official Video]`, `[Official Music Video]`, `(Official Visualiser)`, `(Visualiser)`, `[Official Lyric Visualizer]`, `| UKF Release`, `| Bassrush Records`, `(Free Download)`, `I Drum & Bass`, `[Lyric Video]`, and similar YouTube-specific suffixes.

3. **Rename the file** to `Artist - Title.mp3`. Preserve remix/feature info in the title portion:
   - `Sub Focus - Wildfire.mp3`
   - `Friction - Supersonic (Basstripper Remix).mp3`
   - `Chase & Status - Liquor & Cigarettes (ft. ArrDee).mp3`

4. **Write ID3 tags** using Python mutagen:
   ```bash
   python3 << 'PYTAG'
   from mutagen.id3 import ID3, TIT2, TPE1, TALB, TCON
   import sys
   audio = ID3()
   audio.add(TPE1(encoding=3, text=["<artist>"]))
   audio.add(TIT2(encoding=3, text=["<title>"]))
   audio.add(TCON(encoding=3, text=["<genre>"]))
   # Only add album if discovered
   audio.save("<filepath>")
   PYTAG
   ```
   Mutagen is installed in the skill's venv: `~/.claude/skills/download-youtube-track/.venv/bin/python3`

5. **Move the file to the correct genre folder.** This step is critical — the file MUST physically end up in the destination folder, not just be named there in a summary. Use `mv` explicitly:
   ```bash
   # Determine destination based on user input
   # "dnb" / "drum and bass" / "d&b" → ~/Music/dj/DnB/
   # "future funk" → ~/Music/dj/Future Funk/
   # No genre specified → stays in ~/Music/dj/To Sort/
   mv "$HOME/Music/dj/To Sort/<old_filename>" "<destination_folder>/<new_filename>"
   ```
   Verify the file exists at the destination with `ls` after moving.

6. **Report** the result: final filename, artist, title, genre, destination folder.

### Mode 2: Batch from Discovery Note

The user asks to download tracks from their weekly discovery list.

**Examples:**
- "download from this week's discovery list"
- "download the checked tracks from the latest discovery note"
- "grab the tracks I picked from the weekly list"

**Flow:**

1. **Find the most recent discovery note**:
   ```bash
   ls -1 ~/path/to/vault/1\ Projects/DJing/Weekly\ Discovery/ | sort -r | head -1
   ```
   Or the user may specify a date.

2. **Read the note** via Basic Memory and extract only checked items (`- [x]`). Each line has format:
   ```
   - [x] Artist - Track Name — [YouTube](https://youtube.com/...)
   ```

3. **Extract YouTube URLs** from the checked lines.

4. **Download each track** using the single URL flow above. Spawn subagents in parallel (up to 5 concurrent) for the research step. Genre defaults to "Drum & Bass" since discovery sources are DnB.

5. **Report summary**: list of all downloaded tracks with their canonical names.

## Important Notes

- YouTube audio is lossy (~128-256kbps). MP3 320 is the right ceiling — never convert to FLAC/WAV (wastes space, no quality gain).
- The research subagent is critical — YouTube titles are wildly inconsistent. Always spawn it as a separate Agent to keep the main context clean.
- For tracks where research finds nothing (very obscure), fall back to cleaning the yt-dlp title as best as possible rather than failing.
- If a YouTube URL is unavailable (removed, geo-blocked, age-restricted), search YouTube for the track by name and try an alternate upload before giving up.
- Non-ASCII characters (Japanese, etc.) should be preserved in filenames, not transliterated.
- If a file with the same name already exists in the destination, append ` (2)` to avoid overwriting.

## DJ Library Structure

```
~/Music/dj/
├── DnB/           # Drum & Bass tracks
├── Future Funk/   # Future Funk / City Pop tracks
└── To Sort/       # Ungenred downloads (default landing)
```

## Dependencies

- `yt-dlp` (Homebrew) — audio download
- `ffmpeg` (Homebrew) — audio conversion
- `mutagen` (Python) — ID3 tag writing
