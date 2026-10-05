# LinkedIn Video Studio

Make videos with code, using two engines side by side:

| Folder | Engine | Write videos in | Best for |
| --- | --- | --- | --- |
| [`remotion/`](remotion) | [Remotion](https://github.com/remotion-dev/remotion) | React + TypeScript | Data-driven / templated videos, complex component logic |
| [`hyperframes/`](hyperframes) | [HyperFrames](https://github.com/heygen-com/hyperframes) (HeyGen) | HTML + CSS + GSAP | Fast agent-authored motion graphics, explainers, captions, TTS |

Requirements: Node.js 22+, FFmpeg.

## Remotion

```bash
cd remotion
npm install
npm run dev                                  # Studio at http://localhost:3000
npx remotion render HelloWorld out/video.mp4 # render a composition
```

Compositions are registered in `remotion/src/Root.tsx`.

## HyperFrames

```bash
cd hyperframes
npm run dev      # preview studio
npm run check    # lint + validate
npm run render   # -> MP4
```

The composition lives in `hyperframes/index.html`. GSAP is vendored at
`hyperframes/assets/vendor/gsap.min.js` so renders work offline.

### Optional extras (transcription, voiceover, music)

```bash
scripts/install-extras.sh              # whisper.cpp + Kokoro TTS + MusicGen
scripts/install-extras.sh whisper tts  # or pick: whisper | tts | music
```

| Extra | Powers | Model weights come from |
| --- | --- | --- |
| whisper.cpp | `hyperframes transcribe`, captions | huggingface.co |
| Kokoro | `hyperframes tts "text" -o voice.wav` | github.com |
| MusicGen | locally generated background music | huggingface.co |

## AI agent skills

Agent skills for both engines are committed in `.claude/skills/`
(`remotion-*`, `hyperframes*`, `media-use`). Claude Code picks them up automatically.
Refresh them with `npx hyperframes skills update` and
`npx skills add remotion-dev/skills`.

## Cloud sessions

`.claude/hooks/session-start.sh` points both tools at the sandbox's pre-installed
Chromium (`REMOTION_BROWSER_EXECUTABLE`, `HYPERFRAMES_BROWSER_PATH`) and installs
Remotion's dependencies, since Chrome can't be downloaded there.

## Licensing

Remotion is free for individuals and companies of up to 3 people; larger teams need a
[company license](https://www.remotion.pro/license). HyperFrames is Apache 2.0.
