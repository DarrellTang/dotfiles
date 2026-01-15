#!/bin/bash
# check-repo-freshness.sh - Pre-edit hook to warn about stale repos

FILE_PATH="${1:-$TOOL_INPUT}"

if [ -z "$FILE_PATH" ]; then
    exit 0
fi

if [[ "$FILE_PATH" == *"file_path"* ]]; then
    FILE_PATH=$(echo "$FILE_PATH" | grep -oE '"file_path":\s*"[^"]+"' | cut -d'"' -f4)
fi

if [ -z "$FILE_PATH" ] || [ ! -e "$(dirname "$FILE_PATH" 2>/dev/null)" ]; then
    exit 0
fi

REPO_DIR=$(cd "$(dirname "$FILE_PATH")" 2>/dev/null && git rev-parse --show-toplevel 2>/dev/null)

if [ -z "$REPO_DIR" ]; then
    exit 0
fi

cd "$REPO_DIR" || exit 0

REMOTE_REF=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
if [ -z "$REMOTE_REF" ]; then
    exit 0
fi

git fetch --quiet 2>/dev/null

LOCAL=$(git rev-parse @ 2>/dev/null)
REMOTE=$(git rev-parse @{u} 2>/dev/null)
BASE=$(git merge-base @ @{u} 2>/dev/null)

if [ "$LOCAL" = "$REMOTE" ]; then
    exit 0
elif [ "$LOCAL" = "$BASE" ]; then
    BEHIND_COUNT=$(git rev-list --count @..@{u} 2>/dev/null)
    REPO_NAME=$(basename "$REPO_DIR")
    CURRENT_BRANCH=$(git branch --show-current 2>/dev/null)
    echo "Warning: $REPO_NAME ($CURRENT_BRANCH) is $BEHIND_COUNT commit(s) behind remote."
elif [ "$REMOTE" = "$BASE" ]; then
    exit 0
else
    REPO_NAME=$(basename "$REPO_DIR")
    CURRENT_BRANCH=$(git branch --show-current 2>/dev/null)
    echo "Warning: $REPO_NAME ($CURRENT_BRANCH) has diverged from remote."
fi
