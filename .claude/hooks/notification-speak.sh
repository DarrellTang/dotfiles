#!/bin/bash
PROJECT=$(basename "$PWD")

# AgentVibes install location
AGENTVIBES_DIR="$HOME/claude-experiments/.claude/hooks"

# Play notification sound
claude-code-notification --sound Hero &

# Use AgentVibes if available, fall back to say
if [[ -f "$AGENTVIBES_DIR/play-tts.sh" ]]; then
    bash "$AGENTVIBES_DIR/play-tts.sh" "Permission needed for $PROJECT"
else
    say -v Samantha "Permission needed for $PROJECT"
fi
