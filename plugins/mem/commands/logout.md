---
description: "Log this device out of axs mem (the next session connects it again)"
allowed-tools: ["Bash(${CLAUDE_PLUGIN_ROOT}/hooks/bin/axs-mem:*)"]
---

```!
"${CLAUDE_PLUGIN_ROOT}/hooks/bin/axs-mem" logout --client claude
```

Tell the user the result above in one short line, nothing else. If it says logged out, add that the next `claude` session opens the browser to connect this device again. Do not call any axs mem tool.
