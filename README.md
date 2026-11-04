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

If Field Cut cannot read a file this way (an unusual codec, or a fragmented MP4), it says so and uses a slower backup mode that jumps to every frame. That mode can repeat a few frames near the start of a clip, so treat it as a rare fallback.

The console (Chrome menu, View, Developer, JavaScript Console) prints a line starting FCTIMING after each export with where the time went.

## Still to test
- Wi-Fi-off run: open the page with Wi-Fi off and repeat load, mark, grade, export.
- A MOV from the iPhone (only an R10 MP4 has been tested so far). iPhone files may use HEVC, which Fast export tries to read. If it cannot, it falls back automatically.
- Save one exported file and watch it: check picture and sound are in sync.
- A clip of 5 minutes, to confirm timing and memory at your longest expected length.
- Safari (optional).
