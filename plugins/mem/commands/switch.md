---
description: "Switch this device to another of your axs mem teams (no team: list them)"
argument-hint: "[team]"
allowed-tools: ["Bash(${CLAUDE_PLUGIN_ROOT}/hooks/bin/axs-mem:*)"]
---

```!
"${CLAUDE_PLUGIN_ROOT}/hooks/bin/axs-mem" switch --client claude $ARGUMENTS
```

Tell the user the result above in one short line, or show the team list as it is (the `*` marks the current team). Do not call any axs mem tool.
