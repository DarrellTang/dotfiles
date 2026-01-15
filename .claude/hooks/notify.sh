#!/bin/bash
PROJECT=$(basename "$PWD")

# AgentVibes install location
AGENTVIBES_DIR="$HOME/claude-experiments/.claude/hooks"

echo "{\"session_id\":\"stop\",\"transcript_path\":\"/tmp/stop.md\",\"message\":\"Response ready\",\"title\":\"$PROJECT\"}" | /opt/homebrew/bin/claude-code-notification --sound Hero &

# Use AgentVibes if available, fall back to say
if [[ -f "$AGENTVIBES_DIR/play-tts.sh" ]]; then
    bash "$AGENTVIBES_DIR/play-tts.sh" "$PROJECT ready"
else
    say -v Samantha "$PROJECT ready"
fi
