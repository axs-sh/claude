# axs for Claude Code

[axs brain](https://axs.sh/docs/brain) is shared team memory and rules for Claude Code: the right memory before the
agent makes the mistake, lessons saved when you correct it, and team rules that block or ask before a command.

This repository is the Claude Code plugin marketplace of [axs](https://axs.sh). It has two plugins:

- `axs@axs`: axs brain with the axs CLI's login. `axs install claude` installs it
  ([Connect your agents](https://axs.sh/docs/getting-started/agents)).
- `brain@axs`: axs brain only, without the axs CLI.

(`mem@axs` is the old name of `brain@axs`; install `brain@axs` instead.)

## Install

With the axs CLI ([install it](https://axs.sh/docs/getting-started)):

```
axs login
axs install claude
```

Without the CLI:

```
claude plugin marketplace add axs-sh/claude; claude plugin install brain@axs
```

Then start Claude Code: it opens axs brain in the browser (or shows the link). Approve it and pick the team; the
MCP tools work in that same session.

Update: `claude plugin marketplace update axs && claude plugin update brain@axs` (or `axs@axs`).

## What it does

- Hooks on session start, prompt, tool batch, shell commands and Stop send the event to axs brain; the answer adds
  your rules and the matching memories to the agent's context, checks team rules, and asks for a lesson after a
  correction.
- The MCP server (`https://brain.axs.sh/mcp`) gives the agent the memory tools: `memory_context`,
  `memory_search`, `memory_get`, `memory_write`, `memory_update` and more.

When the server is down or slow, Claude Code keeps working without memories: every hook gives up after 1 to 3
seconds and never blocks.

The plugin ships a small signed helper (macOS and Linux on Intel and Arm, Windows 10 and 11) that sends the hook
events. The device token is kept in the platform's secure credential store, never in settings files or
`hooks.json`.

## Plans

axs is a hosted service: Personal €12 a month, Team €20 per person a month, 14 days free.
See [Plans and billing](https://axs.sh/docs/account/billing).

Docs: [axs.sh/docs](https://axs.sh/docs) · Other agents (Codex, Cursor, any MCP client):
[Connect your agents](https://axs.sh/docs/getting-started/agents)

## Maintainers

Build the helper: `./build.sh` (needs Go), then commit `plugins/brain/hooks/bin/`. Tests:
`cd ../server && go test ./braincli` (add `BRAIN_PLUGIN_E2E=1` for the end to end run with `claude`).
Release: `publish.sh` (signs SHA256SUMS, pushes and tags this repository).
