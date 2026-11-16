---
description: "Answer quick blind choices from your own project (copy, layout, style, scope) so agents learn what you would pick"
argument-hint: "[topic]"
allowed-tools: ["Read", "Grep", "Glob", "Bash(git log:*)", "Bash(git ls-files:*)", "AskUserQuestion", "mcp__plugin_mastermem_mastermem__memory_search"]
---

Run a short interview: the user answers about 24 quick choices built from their own project, so their agents learn what they would pick. Arguments: `$ARGUMENTS` (optional topic, e.g. `copy`, `layout`, `code`; empty: mix the topics that fit this project).

mastermem saves every answer on its own (dashboard: Judgment). Never write memories yourself in this command, and never mention saving, verdicts or scoring to the user.

Only AskUserQuestion answers are kept. When AskUserQuestion is not available (a headless or non-interactive run), say in one line "The interview needs an interactive Claude Code session." and stop: never ask the choices as plain text.

Talk plainly and briefly. No intro beyond one line: "About 6 rounds of 4 quick choices. Stop any time."

## 1. Find real material (2 to 3 minutes, read only)

Look at this session's working directory: `git ls-files`, the README, recent commits (`git log --oneline -30`), and the files that hold what people see or what the team argues about:
- copy: UI strings, messages files, landing or help texts, command outputs, error messages
- layout: pages, components, GUI or menu definitions, screens
- visual: colors, spacing, icons, theme files
- code: naming, error handling, structure, tests, comments
- scope: README goals, open TODOs, half built features
- ship: recent changes that look unfinished

`memory_search` the topic once and skip anything a memory already settles. No project here: build the choices from the topic alone, still concrete.

## 2. Ask in rounds

Each round is one AskUserQuestion call with up to 4 questions. Stop after about 6 rounds or when the user stops (declines, presses Esc, or says so). No commentary between rounds.

Every question:
- is one real trade-off from this project, never a fact (no "which server", "which path", "which version");
- shows concrete variants, not descriptions of them: the actual alternative texts word for word, a small text mockup in each option's `preview` for layouts, a short code snippet in `preview` for code;
- is blind: never mark any option "(Recommended)", never put your favourite first (vary the order), option descriptions say what the option is, never why it is better;
- has 2 to 4 options, `multiSelect: false`;
- has a `header` naming the topic in one word: Copy, Layout, Visual, Code, Scope or Ship.

Mix the topics within a round. Make the variants differ on one thing at a time (length, tone, density, order, naming, how much to build), so an answer says something clear.

When the user writes their own answer or a note instead of picking: that is the most useful answer. Probe the same thing once more in the next round with a sharper pair of options.

## 3. Close

In 3 to 5 short lines: what you noticed about how they choose (for example "shorter copy every time", "dense lists over cards", "builds less first"), and where it shows: mastermem dashboard, Judgment. Nothing else.
