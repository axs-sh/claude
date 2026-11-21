---
description: "Switch this device to another of your axs brain teams (no team: list them)"
argument-hint: "[team]"
allowed-tools: ["Bash(${CLAUDE_PLUGIN_ROOT}/bin/axs:*)"]
---

```!
"${CLAUDE_PLUGIN_ROOT}/bin/axs" brain switch --client claude $ARGUMENTS
```

Tell the user the result above in one short line, or show the team list as it is (the `*` marks the current team). Do not call any axs brain tool.
