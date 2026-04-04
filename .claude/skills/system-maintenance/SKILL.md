---
name: system-maintenance
description: "Weekly automated system health check for Darrell's Claude Code tooling. Runs at 3am Sunday. Dynamically discovers all uv-managed tools, Claude Code plugins (user scope only), and GSD; classifies each update as safe-to-auto-apply (patch/minor, no MCP schema risk) or needs-human-review (major bump, MCP-backed tool, unknown source); applies safe updates including MCP server restarts; writes a maintenance report to the vault. Use this skill whenever Darrell asks to check tool versions, run maintenance, see what needs updating, or verify his Claude Code environment is healthy."
allowed-tools:
  - Bash
  - Read
  - Write
---

# System Maintenance

## Purpose

Encoded preference skill. Runs silently at 3am Sunday.
Dynamically discovers all managed tools — no hardcoded list.
Classifies update risk, auto-applies safe updates, surfaces concerns.

Output: ~/Documents/DT Vault/2-areas/Personal/Maintenance/YYYY-MM-DD.md

---

## Risk Classification Rules

Apply these rules to every outdated item before touching anything:

**AUTO-APPLY (safe):**
- Patch bump (x.y.Z → x.y.Z+1) on any tool
- Minor bump (x.Y.z → x.Y+1.z) on non-MCP tools
- Minor bump on MCP-backed tools ONLY IF changelog contains no schema/migration/breaking keywords

**NEEDS-HUMAN-REVIEW (write to report, do not apply):**
- Major bump (X.y.z → X+1.y.z) on anything
- Any bump on an MCP-backed tool where changelog mentions: "schema", "migration", "breaking", "database"
- Tool not seen before (new discovery — surface it, don't auto-update)
- Third-party plugins (non `anthropic-agent-skills` / `claude-plugins-official`) ONLY when a version bump is actually available — not just because they exist

**MCP-BACKED TOOLS** (require extra caution — restart needed after upgrade):
- Any uv tool that runs as an MCP server (check if process matches `<toolname> mcp`)
- Currently known: basic-memory. Discover others by checking running MCP processes.

When in doubt, classify as needs-human-review. Safety over convenience.

---

## Step 1: Discover all uv-managed tools

```bash
zsh -l -c "uv tool list 2>/dev/null"
```

This returns every installed uv tool and its current version — no hardcoded list needed.
For each tool found, check PyPI for the latest version:

```bash
# For each tool NAME discovered:
curl -s https://pypi.org/pypi/NAME/json | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['info']['version'])"
```

To check if a uv tool is MCP-backed (requires server restart on upgrade):
```bash
ps aux | grep -E "(mcp|basic-memory)" | grep -v grep
```

If upgrading an MCP-backed tool, restart its server after upgrade:
```bash
zsh -l -c "uv tool upgrade NAME"
pkill -f "NAME mcp" 2>/dev/null
sleep 2
echo "NAME upgraded and MCP server restarted"
```

---

## Step 2: Check GSD

GSD is NOT a system binary. It installs slash commands into ~/.claude/ via npx.

```bash
# Current version
cat ~/.claude/get-shit-done/VERSION 2>/dev/null || echo "GSD not installed"

# Latest on npm
curl -s https://registry.npmjs.org/get-shit-done-cc/latest | python3 -c "import sys,json; print(json.load(sys.stdin).get('version','unknown'))"
```

GSD has no MCP server. Patch and minor bumps are auto-safe.

To apply a GSD update:
```bash
zsh -l -c "npx get-shit-done-cc@latest --claude --global --yes 2>&1"
echo "GSD updated to $(cat ~/.claude/get-shit-done/VERSION)"
```

---

## Step 3: Discover all user-scoped Claude Code plugins

Read the manifest dynamically — do not hardcode plugin names:

```bash
python3 - <<'EOF'
import json, datetime

import os; data = json.load(open(os.path.expanduser('~/.claude/plugins/installed_plugins.json')))
plugins = data.get('plugins', {})

for plugin_key, installs in plugins.items():
    if not isinstance(installs, list):
        continue
    for install in installs:
        if install.get('scope') != 'user':
            continue
        last_updated = install.get('lastUpdated', '')[:10]
        version = install.get('version', 'unknown')
        # Flag if not updated in >90 days
        try:
            delta = (datetime.date.today() - datetime.date.fromisoformat(last_updated)).days
            stale = delta > 90
        except:
            stale = False
        print(f"{plugin_key} | version={version} | last_updated={last_updated} | stale={stale}")
EOF
```

This dynamically finds all user-scope plugins regardless of how many you've added.
Skip anything with `scope != 'user'` — project-scoped plugins are intentionally pinned.

Trusted sources (auto-safe for minor/patch): `anthropic-agent-skills`, `claude-plugins-official`
Third-party sources (`claude-scheduler`, `marketingskills`, etc.): only flag if an actual version bump is available, not simply because they exist. A stale third-party plugin sitting at its current version is fine — surface it only when there's something to act on.

Plugin auto-update is not reliably scriptable via CLI.
For any plugin needing an update, add it to the needs-human-review section with manual instructions.

---

## Step 4: Apply safe updates

For each AUTO-APPLY item:

**uv tools (non-MCP):**
```bash
zsh -l -c "uv tool upgrade TOOLNAME"
```

**uv tools (MCP-backed):**
```bash
zsh -l -c "uv tool upgrade TOOLNAME"
pkill -f "TOOLNAME mcp" 2>/dev/null
sleep 2
```

**GSD:**
```bash
zsh -l -c "npx get-shit-done-cc@latest --claude --global --yes 2>&1"
```

**Claude plugins:** Not scriptable. Add to needs-human-review with manual command.

---

## Step 5: Write maintenance report

```bash
mkdir -p ~/Documents/DT\ Vault/2\ Areas/Personal/Maintenance/
```

Write to: `~/Documents/DT Vault/2-areas/Personal/Maintenance/YYYY-MM-DD.md`

```markdown
# System Maintenance — YYYY-MM-DD

**Run time:** 3:00 AM  
**Status:** [All clear / Action needed]

## Auto-Applied Updates
| Tool | From | To | Notes |
|------|----|-----|-------|
| basic-memory | x.y.z | x.y.z+1 | MCP restarted |

(If nothing was auto-applied: "Nothing required updating.")

## Needs Your Review
| Tool | Current | Latest | Why flagged |
|------|---------|--------|-------------|
| tool-name | x.y.z | X.y.z | Major version bump — review changelog before applying |

Manual commands to apply after review:
- `zsh -l -c "uv tool upgrade basic-memory"` then restart MCP

(If nothing flagged: "Nothing flagged.")

## New Discoveries
List any tools found this run that weren't seen before.
These are not auto-updated — review and decide if they should be tracked.

## Skipped Checks
Anything that couldn't be reached (npm registry down, pypi unreachable, etc.)

## Next maintenance window
Sunday YYYY-MM-DD at 3:00 AM
```

---

## Step 6: Confirm

Print to stdout:
```
Maintenance complete — YYYY-MM-DD
Auto-applied: [list or "none"]
Needs review: [list or "none"]
Report: ~/Documents/DT Vault/2-areas/Personal/Maintenance/YYYY-MM-DD.md
```

---

## Scheduler Note

No interactive prompts. Runs autonomously at 3am.
Cron: `0 3 * * 0` (Sundays 3am)
Register: "Schedule system-maintenance every Sunday at 3am."

Runs well before weekly-content-brief (7pm Sunday).
