# Field Cut: code map

Built from `original/index.html` (3,018 lines, 1 MB). Line numbers are for the working copy `index.html` before any edits.

| Lines | What lives there |
|---|---|
| 1-361 | Page head, styles, HTML for the whole screen |
| 362-2266 | Script: the bundled mp4-muxer library (writes MP4 files) |
| 2267 | One giant line: the Look color presets (LUT data, about 860 KB). Do not open in an editor that struggles with long lines. |
| 2288 | `store`: saves to the browser's localStorage |
| 2291-2300 | Small helpers (toast, timecode, durations) |
| 2384-2470 | Reframe crop, fades, overlays (lower third, watermark), live preview drawing, safe zones |
| 2471-2515 | Histogram, audio setup and meter |
| 2515-2610 | Loading files, thumbnails, source and clip lists |
| 2610-2680 | Sliders, Looks, Quick fix, `autoColor` |
| 2679-2735 | Playback, In and Out marks, `addClip`, scrub strip, main draw loop |
| 2750-2820 | Export setup: pick video and audio codec, real-time recorder |
| 2820-2918 | `exportJob`: the export itself, then `saveResult` (download) |
| 2918-2950 | Still frame, `save()` and restore of project settings |

## Findings that matter for "permanent"
1. **Google Fonts** (lines 4-6): the only real outside dependency. Fix in Phase 1.
2. **`window.claude` downloads** (2898-2907): used only if present. Outside Claude, the code already falls back to a normal browser download link, so standalone use works. Keep the fallback, drop the Claude-only branch later.
3. **Project saving today** (2936-2950): stored in the browser's localStorage under `fc_proj`. It saves event name, watermark, export settings, and clips by file key. If Mike clears browser data, it is gone. Phase 2 adds a real project file.
4. Two comment links (stackoverflow, multimedia.cx) are harmless.

## Added Nov. 4, 2026 (line numbers above are from before these edits)
- **Save / Open project**: search `project file (Save project / Open project)` in `index.html`.
- **Fast export**: search `fast export: read the MP4 ourselves`. `readMp4` reads the frame list, `fastDecodeClip` decodes one clip with WebCodecs, `exportJob` runs it alongside the real-time sound recording. The old frame-by-frame mode (`seekFrame`, "pass 2") is kept only as the automatic backup.
- The Real time mode and the Speed menu were removed.

- **Crossfade export** (join mode only): search `crossfade export: decode two clips at once`. `fastFrames` yields decoded frames, `fastCrossfade` pairs the end of a clip with the start of the next, `renderBlend` draws both and mixes them. Sound: `openMix` and `emitMix` in `makeAudioSink` keep each clip's end and mix it into the next clip's start. Backup (frame-by-frame) mode does not crossfade; it uses straight cuts and shows a message.
- **Trim and Play joined**: search `trim a saved clip`.

## New layout (Nov. 4, 2026, evening)
- `index.html` is the new layout. `index-classic.html` is the layout from before the redesign (same features, kept for comparison). The picture engine, export and project code are shared in spirit but the two files are separate copies.
- Header: Undo, Redo, Load footage, Save/Open project, Shortcuts, **Export...** (opens the export window `#expModal`).
- Bottom **timeline** (`#tl`): top lane = source strip with waveform (`#scrub`, `drawScrub`), bottom lane = sequence of ticked clips in play order (`#seq`, `drawSeq`, `seqLayout`). Drag the bar above it (`#split`) to resize; height is remembered in localStorage `fc_tlh`.
- Sequence lane: drag a block to reorder, drag a block edge to trim, crossfade overlaps are drawn hatched. Source lane: drag the edge of the selected clip to trim.
- Colors: black panels, forest green accent, vintage cream (Out marker, title), navy (placeholders and one clip color). Record dot stays red.
- Undo/redo: search `undo and redo`. Waveform: search `computePeaks`.

## Crop, grid, rotate and flip (added Nov 4)
- Settings per clip/source live in `defS()`: `crop {l,t,r,b}` (fractions of the rotated picture) and `tf {rot,fx,fy}`.
- `dispDims` gives the picture size after rotation. `cropFor` works in that space and returns the source rectangle.
- The vertex shader (`VS`) uses `uTf` to rotate/flip the sampling position.
- `drawGrid` and `GRIDS` draw the preview-only grids. Crop box drawing is in `drawPreview` (`view.cropEdit`), its mouse handling is next to "drag to reframe".
