import json
import sys
import re
import subprocess
from pathlib import Path

import requests
from bs4 import BeautifulSoup

BEATPORT_URL = "https://www.beatport.com/genre/drum-bass/1/top-100"
STATE_FILE = Path(__file__).parent.parent / "last-discovery.json"
MAX_NEW_TRACKS = 5
SCRAPE_COUNT = 10

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36"
}


def normalize(text):
    text = text.lower().strip()
    text = re.sub(r'[&+]', ' and ', text)
    text = re.sub(r'\bx\b', 'and', text)
    text = re.sub(r'[^\w\s]', '', text)
    text = re.sub(r'\s+', ' ', text)
    return text


def load_seen():
    if STATE_FILE.exists():
        return set(json.loads(STATE_FILE.read_text()))
    return set()


def save_seen(seen):
    STATE_FILE.write_text(json.dumps(sorted(seen), indent=2))


def scrape_beatport():
    resp = requests.get(BEATPORT_URL, headers=HEADERS, timeout=30)
    if resp.status_code != 200:
        print(f"Error: Beatport returned {resp.status_code}", file=sys.stderr)
        sys.exit(1)

    soup = BeautifulSoup(resp.text, "html.parser")
    tracks = []

    script_tag = soup.find("script", id="__NEXT_DATA__")
    if script_tag:
        data = json.loads(script_tag.string)
        try:
            results = data["props"]["pageProps"]["dehydratedState"]["queries"][0]["state"]["data"]["results"]
            for r in results[:SCRAPE_COUNT]:
                artist = " & ".join(a["name"] for a in r["artists"])
                tracks.append({"artist": artist, "title": r["name"]})
        except (KeyError, IndexError, TypeError) as e:
            print(f"Warning: __NEXT_DATA__ parse failed ({e}), trying HTML fallback", file=sys.stderr)
            tracks = []

    if not tracks:
        rows = soup.select("div.kvuRbj")
        for row in rows[:SCRAPE_COUNT]:
            title_link = row.select_one("a")
            if not title_link:
                continue
            parent = row.parent
            artist_links = parent.select('a[href*="/artist/"]') if parent else []
            artist = " & ".join(a.get_text(strip=True) for a in artist_links)
            tracks.append({"artist": artist, "title": title_link.get_text(strip=True)})

    if not tracks:
        print("Error: Could not parse any tracks from Beatport", file=sys.stderr)
        sys.exit(1)

    return tracks


def resolve_youtube(artist, title):
    query = f"{artist} - {title}"
    result = subprocess.run(
        ["yt-dlp", f"ytsearch:{query}", "--get-id", "--get-title", "--no-download"],
        capture_output=True, text=True, timeout=30
    )
    if result.returncode != 0 or not result.stdout.strip():
        print(f"Warning: No YouTube result for '{query}'", file=sys.stderr)
        return None

    lines = result.stdout.strip().split("\n")
    if len(lines) >= 2:
        video_id = lines[-1]
        return f"https://youtube.com/watch?v={video_id}"
    return None


def main():
    seen = load_seen()
    tracks = scrape_beatport()

    new_tracks = []
    for t in tracks:
        key = normalize(f"{t['artist']} {t['title']}")
        if key not in seen:
            yt_url = resolve_youtube(t["artist"], t["title"])
            if yt_url:
                new_tracks.append({
                    "artist": t["artist"],
                    "title": t["title"],
                    "youtube_url": yt_url
                })
                seen.add(key)
            if len(new_tracks) >= MAX_NEW_TRACKS:
                break

    save_seen(seen)

    print(json.dumps(new_tracks, indent=2))


if __name__ == "__main__":
    main()
