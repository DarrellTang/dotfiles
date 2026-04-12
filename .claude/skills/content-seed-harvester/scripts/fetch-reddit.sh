#!/bin/bash
# Fetches Reddit RSS feeds from target DevOps subreddits
# Parses Atom XML into structured TSV for Claude processing
# Output: /tmp/content-seed-harvester/raw-posts.tsv

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR="/tmp/content-seed-harvester"
OUTPUT_FILE="$OUTPUT_DIR/raw-posts.tsv"
mkdir -p "$OUTPUT_DIR"

SUBREDDITS=("devops" "kubernetes" "sysadmin" "ITCareerQuestions" "homelab")
FEED_TYPES=("new" "top")

USER_AGENT="content-seed-harvester/1.0 (claude-code-skill; educational-content-research)"

# Write TSV header
echo -e "subreddit\tfeed_type\ttitle\tauthor\tlink\tdate\tbody" > "$OUTPUT_FILE"

FETCH_COUNT=0

for sub in "${SUBREDDITS[@]}"; do
  for feed in "${FEED_TYPES[@]}"; do
    # Rate limiting: 6 seconds between requests
    if [ "$FETCH_COUNT" -gt 0 ]; then
      sleep 6
    fi

    if [ "$feed" = "top" ]; then
      URL="https://www.reddit.com/r/${sub}/top/.rss?t=week"
    else
      URL="https://www.reddit.com/r/${sub}/new/.rss"
    fi

    echo "Fetching: r/${sub}/${feed}..." >&2

    # Save response to temp file to avoid pipe/heredoc conflicts
    TMPFILE="$OUTPUT_DIR/${sub}_${feed}.xml"
    curl -s --max-time 15 \
      -H "User-Agent: $USER_AGENT" \
      -H "Accept: application/rss+xml" \
      "$URL" > "$TMPFILE" 2>/dev/null || true

    if [ ! -s "$TMPFILE" ]; then
      echo "  WARN: Empty response from r/${sub}/${feed}" >&2
      FETCH_COUNT=$((FETCH_COUNT + 1))
      continue
    fi

    # Check for rate limit or error HTML responses
    if head -5 "$TMPFILE" | grep -qi "<html"; then
      echo "  WARN: Got HTML instead of RSS from r/${sub}/${feed} (possible rate limit)" >&2
      rm -f "$TMPFILE"
      FETCH_COUNT=$((FETCH_COUNT + 1))
      continue
    fi

    # Parse with Python script
    python3 "$SCRIPT_DIR/parse-rss.py" "$sub" "$feed" < "$TMPFILE" >> "$OUTPUT_FILE" || true
    rm -f "$TMPFILE"

    FETCH_COUNT=$((FETCH_COUNT + 1))
  done
done

TOTAL=$(tail -n +2 "$OUTPUT_FILE" | wc -l | tr -d ' ')
echo "" >&2
echo "Fetched $TOTAL posts from ${#SUBREDDITS[@]} subreddits" >&2
echo "$OUTPUT_FILE"
