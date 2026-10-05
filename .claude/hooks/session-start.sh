#!/bin/bash
# Prepares Claude Code cloud sessions for rendering with Remotion + HyperFrames.
set -euo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"

# Cloud sandboxes can't download Chrome; point both tools at the pre-installed headless shell.
SHELL_BIN=$(ls /opt/pw-browsers/chromium_headless_shell-*/chrome-linux/headless_shell 2>/dev/null | head -1 || true)
if [ -n "$SHELL_BIN" ] && [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  echo "export REMOTION_BROWSER_EXECUTABLE=$SHELL_BIN" >> "$CLAUDE_ENV_FILE"
  echo "export HYPERFRAMES_BROWSER_PATH=$SHELL_BIN" >> "$CLAUDE_ENV_FILE"
fi

if [ "${CLAUDE_CODE_REMOTE:-}" = "true" ] && [ ! -d "$ROOT/remotion/node_modules" ]; then
  (cd "$ROOT/remotion" && npm install --loglevel=error)
fi
