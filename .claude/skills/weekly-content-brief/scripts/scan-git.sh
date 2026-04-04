#!/bin/bash
# Scans active repos for commits in the last 7 days
# Used by weekly-content-brief skill

HOME_DIR="$HOME"

SCAN_DIRS=(
  "$HOME_DIR/darrelldoesdevops"
  "$HOME_DIR/clients"
  "$HOME_DIR/dtconsulting"
  "$HOME_DIR/codeWorkspace"
  "$HOME_DIR/git-started"
)

FOUND=0

for scan_dir in "${SCAN_DIRS[@]}"; do
  [ -d "$scan_dir" ] || continue

  # Find all .git directories up to 3 levels deep
  while IFS= read -r gitdir; do
    repo="${gitdir%/.git}"
    COMMITS=$(git -C "$repo" log --since="7 days ago" --oneline --no-merges 2>/dev/null)
    if [ -n "$COMMITS" ]; then
      # Show parent/repo for nested repos (e.g. hfd/Devops, p3ms/HelloWeather-ArgoCD)
      parent=$(basename "$(dirname "$repo")")
      name=$(basename "$repo")
      if [ "$parent" = "$(basename "$scan_dir")" ]; then
        label="$name"
      else
        label="$parent/$name"
      fi
      echo "=== $label ==="
      echo "$COMMITS"
      echo ""
      FOUND=1
    fi
  done < <(find "$scan_dir" -maxdepth 4 -name ".git" -type d 2>/dev/null)
done

if [ "$FOUND" -eq 0 ]; then
  echo "(no commits found in the last 7 days across tracked repos)"
fi
