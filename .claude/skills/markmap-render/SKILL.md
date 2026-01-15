---
name: markmap-render
description: Render markmap (.mm.md) files to HTML for committing. Finds all .mm.md files in the project and runs npx markmap to generate interactive HTML mind maps.
---

# Markmap Render

Render all `.mm.md` files to HTML for version control.

## When to Use

- After doc-writer creates `.mm.md` files
- Before committing documentation updates
- When user asks to "render markmaps" or "generate markmap HTML"

## Workflow

1. Find all `*.mm.md` files in project (or specified path)
2. For each file: run `npx markmap filename.mm.md -o filename.html`
3. Report what was rendered

## Usage

**Render all markmaps in project:**
```
/markmap-render
```

**Render in specific directory:**
```
/markmap-render docs/
```

## Commands

Find files:
```bash
find . -name "*.mm.md" -type f
```

Render single file:
```bash
npx markmap input.mm.md -o input.html
```

Render all files:
```bash
find . -name "*.mm.md" -exec sh -c 'npx markmap "$1" -o "${1%.mm.md}.html"' _ {} \;
```

## Output

Report format:
```
Rendered markmaps:
- docs/architecture.mm.md → docs/architecture.html
- docs/platform.mm.md → docs/platform.html

Total: 2 files
```

## Prerequisites

Markmap CLI must be available. Install if needed:
```bash
npm install -g markmap-cli
```

Or use npx (no install required):
```bash
npx markmap
```
