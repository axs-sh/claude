# axs brain for Claude Code

Team memory for Claude Code: the right memory before the agent makes the mistake, lessons saved when you
correct it. This repository is a Claude Code plugin marketplace with one plugin, `mem`.

## Install

In a terminal:

```
claude plugin marketplace add axs-sh/claude; claude plugin install brain@axs
```

Then start Claude Code: it opens axs brain in the browser (or shows the link). Approve it and pick the team; the
MCP tools work in that same session (the helper makes the device token before the login and the MCP connection
sends it from the start, the server creates it on approve). The token goes into
`~/.config/axs-brain/claude.json` (0600; installs from before 0.18.0 keep `~/.config/mastermem/`).

Another team or a revoked token: delete that file and start a new session.

## What it does

- Hooks on session start, prompt, tool batch, shell commands (Bash, PowerShell) and Stop send the hook
  event to `<server>/v1/hook/<event>`; the answer adds the matching memories to the agent's context and
  asks for a lesson after a correction.
- The MCP server (`<server>/mcp`, named `mem` in Claude Code) gives the agent the memory
  tools.

When the server is down or slow, Claude Code keeps working without memories: every hook gives up after
1 to 3 seconds and never blocks.

## Requirements

Nothing to install: the plugin ships a small helper (`hooks/bin/`, macOS and Linux on Intel and Arm,
Windows 10 and 11) that sends the hook events. The token is kept in the platform's secure credential store
(on Linux `~/.claude/.credentials.json`, mode 0600), never in settings files or `hooks.json`, and the helper
gets it through its environment, so other users on a shared machine cannot see it in the process list.

Build the helper (maintainers): `./build.sh` (needs Go), then commit `plugins/brain/hooks/bin/`. Tests:
`cd ../server && go test ./braincli` (add `BRAIN_PLUGIN_E2E=1` for the end to end run with `claude`).

## The axs plugin (mem and build, not published yet)

`plugins/axs` is the successor of `mem`: the same hooks and MCP server through the one `axs` binary (`axs brain ...`),
plus build's route hook (`axs build route-hook`: heavy builds and tests go through axs build). Both are switchable:
plugin options `mem` and `build`, or `axs install claude --no-brain|--no-build` (kept in the axs config), or
`AXS_NO_MEM=1` / `AXS_NO_BUILD=1` / `MB_LOCAL=1` in the environment. Its slash commands are `/axs:logout`,
`/axs:switch`, `/axs:yolo` (the server takes `brain:yolo` and `axs:yolo`), `/axs:review`, `/axs:handoff` (saves the session into axs brain so a fresh session can continue; user only).

Install with the CLI (after `axs login`; the plugin gets its own token minted from that login, so no browser login;
it stops before changing anything while the marketplace does not list the axs plugin):

```
axs install claude            # claude plugin marketplace add axs-sh/claude; plugin install axs@axs; uninstall brain@axs
```

Migration from `brain@axs`: nothing breaks if you wait. An installed `brain@axs` keeps running its own `axs-brain` copy, and
the axs binary started as `axs-brain` behaves exactly like it. `axs install claude` replaces it with `axs@axs`; the
token file (`~/.config/axs-brain/claude.json`) stays, so the device stays logged in. Never keep both enabled: every
hook would run twice.

Publish (maintainers, after the owner's go): add `{"name": "axs", "source": "./plugins/axs", ...}` to
`.claude-plugin/marketplace.json`, bump the versions, then `./publish.sh` (`PUBLISH_DRY_RUN=1` first). With that entry
publish.sh runs `build.sh axs`, commits `plugins/axs/bin/<os>-<arch>/axs` and `bin/axs.exe` in the published repo
(here they are ignored) and lists them in the signed SHA256SUMS. Without the entry it leaves `plugins/axs` out.

## Upgrade from mastermem

The plugin was called `mastermem@mastermem` before 0.18.0 (`srmem@srmem` before 0.4.0). Remove it, then install as above:

```
claude plugin uninstall mastermem@mastermem
claude plugin marketplace remove mastermem
```

## Uninstall

```
claude plugin uninstall brain@axs
claude plugin marketplace remove axs
```

Had the older srmem command line client installed (`srmem install --remote`)? Run `srmem uninstall` first, or every hook
fires twice.
