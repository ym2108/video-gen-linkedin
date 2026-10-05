# LinkedIn Video Studio

Videos for LinkedIn, made with code. Read this whole file before making or editing any video, and keep it updated: every new instruction, piece of feedback or lesson from the user goes into the logs at the bottom.

## Repo rules

- This repo (`ym2108/video-gen-linkedin`) is the only repo for this work. Do not push video work to `ym2108/hack`.
- Commits: no `Co-Authored-By`, `Claude-Session` or other Claude attribution trailers. Plain commit messages only.
- Commit source, not MP4s. Renders go in `renders/` or `out/` (gitignored); send the MP4 to the user directly.

## Engines

- `hyperframes/`: HyperFrames (HTML + GSAP). Default for LinkedIn explainers and motion graphics. Start with the `/hyperframes` skill; see `hyperframes/CLAUDE.md`.
- `remotion/`: Remotion (React/TS). Use for data-driven or templated videos. Use the `remotion-*` skills. Register compositions in `src/Root.tsx`; render with `npx remotion render <Id> out/<name>.mp4`.
- Each video is its own HyperFrames project under `hyperframes/videos/<kebab-name>/`.

## Environment (cloud sandbox)

- Network blocks CDNs (cdn.jsdelivr.net) and huggingface.co. Vendor JS/CSS/fonts into the project's `assets/` via `npm pack <pkg>` from npm. GSAP: `assets/vendor/gsap.min.js`. Fonts: `@fontsource/inter` woff2 files in `assets/fonts/` with in-file `@font-face`.
- Chrome comes from `HYPERFRAMES_BROWSER_PATH` / `REMOTION_BROWSER_EXECUTABLE`, set by `.claude/hooks/session-start.sh`. Never run `npx hyperframes browser ensure`.
- Extras: `scripts/install-extras.sh` (whisper | tts | music). Kokoro TTS works here. Whisper and MusicGen need huggingface.co, which is blocked, so no transcription and no generated music unless the host is allowlisted.
- No background music source is available here. Ask the user for a track if music is wanted.

## Video house style (from user feedback)

The user asked for: **Apple style, clean, minimalist, has hooks, understandable.**

- Format: square 1080×1080 for the LinkedIn feed (offer 4:5 if they want more feed space).
- Length: always under 60 seconds (hard limit; target 45–55s). If the script is too long for that, tighten it for the voiceover and on-screen text while keeping its meaning, and tell the user what was cut.
- Tone: catchy and insightful. Open on the sharpest tension or surprising fact, give one clear insight, end on a punchy takeaway or question. Cut anything that doesn't earn its seconds.
- Palette: paper `#f5f5f7`, ink `#1d1d1f`, muted `#6e6e73`, line `#d2d2d7`, one accent blue `#0071e3` (`#2997ff` on black). Use a black ground for the story or case-study section for contrast, then return to light for the lesson.
- Type: Inter 600/700, tight tracking (-0.03 to -0.045em). Big headlines (88–112px), one idea per screen, generous margins (96px sides).
- Motion: soft rise out of blur (y 32 to 0, blur 12px to 0, `power3.out`, about 0.9s). Scene exits fade with a slight blur. Never busy.
- Hook in the first 0.5s: first line on screen immediately, with a visual twist (for example a struck-through "No.").
- Understandable with sound off: on-screen text carries every key phrase; turn abstract ideas into simple diagrams (a dot moving between labelled nodes, bar comparisons, checklists, poll-style options).
- End with the post's question as poll-style options plus a short "Tell me in the comments."
- Hashtags go in the post text, not in the video.
- Numbers from a source get a small source note on screen (for example "as reported by P&G's innovation leaders").

## Voiceover

- Kokoro TTS: `npx hyperframes tts "<text>" -v af_heart -o line-NN.wav`. Default voice `af_heart` (the user has not asked for a different voice yet).
- Use the user's script verbatim. Generate one WAV per line, measure durations with `ffprobe`, then place lines on a timeline (gap about 0.3s within a scene, 0.5–0.7s between scenes).
- Spell out symbols and acronyms for correct pronunciation: "P&G" as "P and G", "CEO" as "C E O", "+" as "and".
- Mix lines into `assets/narration.wav` with ffmpeg `adelay` + `amix=normalize=0`, then `loudnorm=I=-16:TP=-1.5:LRA=11`.
- Keep the per-line WAVs in `assets/vo/` so one line can be re-recorded without redoing the rest.

## Build and check workflow

1. Save the user's script verbatim in `capture/extracted/user_script.txt`.
2. Generate voiceover lines and decide scene windows from their durations.
3. Write `index.html` (one paused GSAP timeline, scenes as timed `.clip` sections, narration as `<audio id="narration">`).
4. `npx hyperframes lint`. The `nested_structure_needs_subcomposition` and `composition_file_too_large` warnings are acceptable for single-file builds.
5. `npx hyperframes snapshot --at <scene midpoints>` and look at the contact sheet. Fix anything cramped or overlapping.
6. `npx hyperframes check` must pass (runtime, layout, motion, contrast).
7. `npx hyperframes render --quality high --output renders/video.mp4`, then send the MP4 to the user.
8. Commit source and update the logs below.

## Lessons learned

- Chrome cannot load CDN scripts here; a CDN `<script>` makes renders fail with `sub_timeline_script_failure`. Always vendor.
- Diagrams with moving dots: give dots fixed target slots (a tidy grid) instead of loose offsets, or they pile on top of labels.
- An "opening door" reads better as wall segments scaling toward the corners (`scaleY` with `transformOrigin`) than sliding past the box edge.
- Stack swapping headlines with absolute positioning only when each fits on one line; otherwise keep them in normal flow so wrapped lines never overlap.
- Re-recording one voiceover line at the same length keeps all timings; check the new duration before re-rendering.

## Feedback log

- 2026-10-02: First video brief: "Apple style video, clean, minimalistic, have hooks and understandable."
- 2026-10-03: Replace "CMD" with "CEO" in the Ideas-get-lost video (on screen and in the voiceover).
- 2026-10-05: Use this repo for all work; no Claude attribution trailers in commits; keep this file updated and use it for every new video.
- 2026-10-05: Every video from now on must be under 1 minute, catchy and insightful. (Ideas get lost, at 70s, predates this rule.)

## Video log

| Video | Path | Notes |
| --- | --- | --- |
| Ideas get lost (P&G Connect + Develop) | `hyperframes/videos/ideas-get-lost/` | 70s, 1080×1080, voice `af_heart`, 10 scenes, light/black/light palette. CEO version. |
