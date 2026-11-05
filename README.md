# Field Cut

A video editor that runs in your web browser. Mark moments, fix color and sound, reframe for 16:9, 9:16, 4:5 and 1:1, and export MP4s. Your footage never leaves your computer. No account, no internet needed.

## How to open it
1. In Finder, open the `field-cut` folder.
2. Double-click `index.html`. It opens in your browser. Chrome is the one it was built and tested for.
3. Drag your video files onto the page, or click Load footage.

Press the Shortcuts button in the app for the keyboard keys.

## What is in this folder
- `index.html` is the whole app. `rec-worklet.js` is a small audio helper it loads.
- `fonts/` holds the IBM Plex fonts (free, open license) so the look works offline.
- `original/` is an untouched copy of the app as it came from Claude. Never edit it.
- `_backup_before_changes/` holds a copy of any file before it was changed.
- `MAP.md` says where each feature lives in the code.
- `scripts/check.sh` checks the app for mistakes.

## How to check your work
Open Terminal, then type:

    cd ~/ClaudeCodeTest/field-cut
    bash scripts/check.sh

It should end with `ALL CHECKS PASSED`.

## How to restore if something breaks
Copy `original/index.html` and `original/rec-worklet.js` over the ones in the main folder. That puts the app back exactly as you first saved it. (Fonts would then load from Google again.)

## Your saved work
Click Save project (or press Cmd+S) to save your clips, grades and crops to a small file ending in `.fieldcut.json`. Click Open project, or drop that file onto the page, to bring it back. The file holds settings only. Your video files stay where they are, so drop the videos in again and Field Cut matches them by name and size. The browser also remembers your last session, but clearing browser data erases that, so use the project file for anything you care about.

## Credits
Fonts: IBM Plex, SIL Open Font License 1.1 (see `fonts/LICENSE.txt`). MP4 writing: mp4-muxer, bundled in `index.html`.

## How exporting works now
Export is fast: about as long as the clip, for all sizes at once (a 30 second clip at 4 sizes took 33 seconds on a 2019 Intel MacBook). Every frame is kept. Field Cut reads the picture straight out of your MP4 or MOV and records the sound while that happens. Keep the tab open and in front until it finishes.

Tested so far: an R10 MP4 (H.264) and an iPhone MOV (HEVC, HDR, portrait). Portrait iPhone video is turned upright and keeps its HDR look.

If Field Cut cannot read a file this way (an unusual codec, or a fragmented MP4), it says so and uses a slower backup mode that jumps to every frame. That mode can repeat a few frames near the start of a clip, so treat it as a rare fallback.

The console (Chrome menu, View, Developer, JavaScript Console) prints a line starting FCTIMING after each export with where the time went.

## The step-by-step guide
Open `guide/field-cut-guide.html` (also copied to Downloads as "Field Cut Step by Step guide.html"). It has 22 steps with pictures (including cutting a long speech into pieces and joining them), tick boxes that remember your place, and a "Stuck?" box. To change it, edit `guide/steps.json` and rebuild:

    python3 ~/ClaudeCodeTest/guide-template/build_guide.py guide/steps.json guide/field-cut-guide.html

## Test results so far (Nov. 4, 2026, 2019 Intel MacBook, 8 GB, Chrome)
- 5 minute video, 2 sizes: 5 minutes 25 seconds. 3 sizes: 6 minutes 56 seconds (memory got tight). All frames kept.
- The page only loads its own files (fonts and your video). No internet is used. A true Wi-Fi-off run is still worth doing once yourself.
- Big exports show a red memory warning before you start.

## Still to test
- Wi-Fi-off run yourself: turn Wi-Fi off, open the page, then load, mark, grade and export.
- Safari (optional). Fast export needs a newer Safari. If it cannot run, it falls back to the slower backup mode.
