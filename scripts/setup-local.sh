#!/bin/bash
# One-time setup for working on this repo on your own machine (macOS or Linux;
# on Windows, run it inside WSL).
#
#   scripts/setup-local.sh           # Remotion deps + headless Chrome for both engines
#   scripts/setup-local.sh --extras  # also Kokoro TTS and whisper.cpp
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

fail() { echo "✗ $1" >&2; exit 1; }

command -v git >/dev/null || fail "git is required"
command -v node >/dev/null || fail "Node.js 22+ is required (https://nodejs.org)"
NODE_MAJOR=$(node -p 'process.versions.node.split(".")[0]')
[ "$NODE_MAJOR" -ge 22 ] || fail "Node.js 22+ is required (found $(node -v))"
command -v ffmpeg >/dev/null || fail "FFmpeg is required (macOS: brew install ffmpeg; Ubuntu: sudo apt install ffmpeg)"

echo "→ Installing Remotion dependencies"
(cd remotion && npm install --loglevel=error)

# The cloud sandbox points both tools at a pre-installed Chrome; locally they
# download their own headless Chrome once.
if [ -z "${HYPERFRAMES_BROWSER_PATH:-}" ]; then
  echo "→ Downloading headless Chrome for HyperFrames"
  npx --yes hyperframes browser ensure
fi
if [ -z "${REMOTION_BROWSER_EXECUTABLE:-}" ]; then
  echo "→ Downloading headless Chrome for Remotion"
  (cd remotion && npx remotion browser ensure)
fi

if [ "${1:-}" = "--extras" ]; then
  echo "→ Installing Kokoro TTS and whisper.cpp"
  scripts/install-extras.sh tts whisper
fi

echo "✓ Local setup done. Open this folder in Claude Code and say \"sync\" to pull the latest work."
