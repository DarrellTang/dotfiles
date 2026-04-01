#!/bin/bash
# Voice Context Loader - SessionStart hook
# Reads voice guide key rules from the Obsidian vault (source of truth)
# and injects them as additionalContext so they're always in Claude's context.
# No duplicate files -- reads directly from vault.

VAULT="$HOME/Documents/DT Vault/3-resources"
ANTI_AI="$VAULT/Writing Style Guide — Anti-AI Voice.md"

if [[ ! -f "$ANTI_AI" ]]; then
  exit 0
fi

# Extract banned words line (the line after "**Single words:**")
BANNED_WORDS=$(grep '^\*\*Single words:\*\*' "$ANTI_AI" | sed 's/\*\*Single words:\*\* //')

# Extract banned phrases (lines starting with - under "## Banned Phrases")
BANNED_PHRASES=$(awk '/^## Banned Phrases/{found=1; next} /^## /{if(found) exit} found && /^- /' "$ANTI_AI" | sed 's/^- //' | tr '\n' '|' | sed 's/|$//')

# Build condensed rules block
RULES=$(cat <<'ENDRULES'
VOICE CONSTRAINTS (auto-loaded from vault, do not remove):
1. BANNED WORDS: BANNED_WORDS_PLACEHOLDER
2. BANNED PHRASES: BANNED_PHRASES_PLACEHOLDER
3. NO em dashes. Use commas or split the sentence.
4. NO Rule of Three abuse. Use the actual count.
5. NO inspirational closers or manufactured urgency hooks.
6. Voice: senior engineer over coffee, direct, opinionated, real examples.
7. Vary sentence length. No metronome rhythm.
8. Take a stance. No "on one hand / on the other hand."
9. For teammate/client messages: no greetings, lowercase ok, no exclamation marks, deadpan.
10. ALWAYS apply these rules to ALL output: text responses, drafted messages, emails, file writes.
ENDRULES
)

RULES="${RULES//BANNED_WORDS_PLACEHOLDER/$BANNED_WORDS}"
RULES="${RULES//BANNED_PHRASES_PLACEHOLDER/$BANNED_PHRASES}"

# Escape for JSON
RULES_JSON=$(echo "$RULES" | python3 -c 'import sys,json; print(json.dumps(sys.stdin.read()))')

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": $RULES_JSON
  }
}
EOF
