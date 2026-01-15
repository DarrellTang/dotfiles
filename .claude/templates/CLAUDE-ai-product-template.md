# [PROJECT_NAME] - Project Context for Claude Code

## Project Overview

[1-2 sentence description of what this AI/content product does]

### Target Audience
[Who are the primary users? What are their pain points and goals?]

### Core Experience
[What is the primary user experience? How does AI enhance it?]

## Architecture & Design Patterns

### Product Type: [AI-Powered / Content-Driven / Hybrid]

[Brief description of whether this is primarily AI-driven (conversational), content-driven (structured prompts), or both]

## User Journey

### Phase 1: [Phase Name]
**Duration:** [Time estimate]
**User Goal:** [What is the user trying to accomplish?]
**AI Role:** [What is Claude/AI doing in this phase?]

### Phase 2: [Phase Name]
**Duration:** [Time estimate]
**User Goal:** [What is the user trying to accomplish?]
**AI Role:** [What is Claude/AI doing in this phase?]

### Phase 3: [Phase Name]
**Duration:** [Time estimate]
**User Goal:** [What is the user trying to accomplish?]
**AI Role:** [What is Claude/AI doing in this phase?]

## Core Content Architecture

### Progressive Context Building

**Critical Design Principle:** [Explain how context accumulates or flows through the product]

### File/Module Structure

```
[project-name]/
├── [module-1]/                    # [Description]
├── [module-2]/                    # [Description]
├── [module-3]/                    # [Description]
└── README.md                       # Quick start guide
```

### Content Delivery Patterns

**If Content-Driven (Prompt-Based):**
- Each step/module follows this structure:
  1. Time estimate at the top
  2. "PASTE THIS INTO YOUR CHAT:" section with the actual prompt
  3. Structured instructions/questions
  4. Output format specification
  5. "🛑 STOP HERE" checkpoint instruction

**If AI-Conversational:**
- Conversation flows are [describe pattern: Socratic / discovery-based / directive]
- AI behavior is [describe: % mentoring vs teaching, response patterns]

## AI Behavior & Patterns

### Conversation Style
[Describe the AI's personality, tone, and interaction patterns]

### Context Management
- **Input context:** [What does AI receive as context?]
- **Context accumulation:** [How does context grow through the interaction?]
- **Token efficiency:** [Any patterns for keeping context manageable?]

## MCP Integration (if applicable)

### Server Configuration
- **[MCP Name]:** [What it does and why it's needed]

### Integration Points
- [Where MCP is used in the user journey]
- [How MCP results feed back to AI]

## Content/Prompt Patterns

### Key Content Principles

- **Principle 1:** [e.g., "Approximate beats omit - estimate numbers instead of leaving blanks"]
- **Principle 2:** [e.g., "Progressive context - users never copy-paste between steps"]
- **Principle 3:** [e.g., "Explicit checkpoints - AI pauses at defined boundaries"]

### Checkpoint & Stopping Syntax

Use this exact format to prevent AI from continuing past defined breakpoints:

```markdown
🛑 STOP HERE
Do not continue to the next step until [user condition is met].
```

## Development & Maintenance

### Testing & Validation

**Before shipping changes:**
- [ ] Full conversation test through all phases
- [ ] Context persistence check
- [ ] Checkpoint validation
- [ ] Token count verification

### Common Pitfalls to Avoid

1. **[Pitfall 1]** - [Why it breaks / What to do instead]
2. **[Pitfall 2]** - [Why it breaks / What to do instead]

## Technical Specifications

### Token & Performance Targets
- **Total token budget:** [e.g., ~50K tokens per complete flow]
- **Context window required:** [e.g., 200K (Claude) or 128K (GPT-4)]
- **Time efficiency:** [e.g., 90 min with dictation / 2-3 hours typing]

### Platform Requirements
- **Recommended AI:** [e.g., Claude (200K context) preferred]
- **Dependencies:** [External APIs, libraries, etc.]

## Success Metrics & Validation

### User Success Indicators
- [Metric 1 - e.g., 80%+ completion rate]
- [Metric 2 - e.g., Users achieve outcome X in time Y]

### Product Quality Indicators
- [Quality 1 - e.g., AI responses stay within context bounds]
- [Quality 2 - e.g., Checkpoints prevent AI from jumping ahead]

---

**Note:** See global `~/.claude/CLAUDE.md` for git commit and PR conventions.
