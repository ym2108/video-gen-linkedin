#!/bin/bash
# Installs HyperFrames' optional extras: whisper.cpp (transcription),
# Kokoro (local TTS) and MusicGen (local background music).
#
#   scripts/install-extras.sh            # everything
#   scripts/install-extras.sh whisper tts  # pick: whisper | tts | music
#
# Model weights download on first use: Kokoro from GitHub, Whisper and
# MusicGen from huggingface.co (must be reachable from your network).
set -euo pipefail

WANT="${*:-whisper tts music}"
PIP="pip install -q"
# Debian/Ubuntu system Python refuses global installs without this flag.
if [ -z "${VIRTUAL_ENV:-}" ] && python3 -m pip install --help 2>/dev/null | grep -q -- --break-system-packages; then
  PIP="$PIP --break-system-packages"
fi

if [[ " $WANT " == *" whisper "* ]]; then
  if command -v whisper-cli >/dev/null; then
    echo "whisper-cli already on PATH"
  else
    SRC="$HOME/.local/src/whisper.cpp"
    [ -d "$SRC" ] || git clone --depth 1 https://github.com/ggml-org/whisper.cpp "$SRC"
    cmake -S "$SRC" -B "$SRC/build" -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DWHISPER_BUILD_TESTS=OFF >/dev/null
    cmake --build "$SRC/build" -j"$(nproc 2>/dev/null || echo 4)" --target whisper-cli
    mkdir -p "$HOME/.local/bin"
    ln -sf "$SRC/build/bin/whisper-cli" "$HOME/.local/bin/whisper-cli"
    echo "whisper-cli -> $HOME/.local/bin/whisper-cli (set HYPERFRAMES_WHISPER_PATH if that isn't on PATH)"
  fi
fi

if [[ " $WANT " == *" tts "* ]]; then
  python3 -m $PIP kokoro-onnx soundfile
fi

if [[ " $WANT " == *" music "* ]]; then
  python3 -m $PIP transformers torch soundfile numpy
fi

npx --yes hyperframes doctor || true
