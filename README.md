# SmallScreenshot

A screenshot tool for GNUStep on Linux. Capture the full screen or a region, preview, and save as PNG.

## Features

- **Capture full screen** – One click captures the entire screen.
- **Capture region** – Drag a rectangle on a fullscreen overlay to capture only that area.
- **Preview** – Captured image is shown in the main window.
- **Save as PNG** – Save via the Save button or menu (Cmd+S).

## Dependencies

- **GNUStep** (gnustep-gui, gnustep-base)
- **SmallStepLib** (`../SmallStepLib`) – app lifecycle, menus, file dialogs
- **libX11** – X11 screen capture (Linux; auto-detected via pkg-config)

## Build

SmallStepLib is built first automatically by [`../build_all.sh`](../build_all.sh); to build this app alone:

```bash
. /tmp/gnustep-toolchain/setup-env.sh    # or your GNUstep env (GNUstep.sh)
make -C ../SmallStepLib CC=clang         # once
make CC=clang                            # from this directory
```

## Run

```bash
openapp ./SmallScreenshot.app            # from this directory
# or: ./SmallScreenshot.app/SmallScreenshot
```

## Test

```bash
make -f Tests/GNUmakefile CC=clang all && ./Tests/obj/test_SmallScreenshot
```

## Usage

- **Capture Full Screen** – Captures the entire root window (all monitors on X11).
- **Capture Region…** – The main window hides; a semi-transparent overlay appears. Drag to select a rectangle. Release to capture. Press **Escape** to cancel.
- **Save…** – Opens a save dialog (PNG). The preview image is written to the chosen path.

## SmallStepLib usage

SmallScreenshot uses SmallStepLib as the starting point:

- **SSHostApplication** / **SSAppDelegate** – App entry and lifecycle (no manual `NSApplication` setup).
- **SSMainMenu** – Application menu (Capture Full Screen, Capture Region, Save, Quit).
- **SSFileDialog** – Save dialog for choosing path and filename.
- **SSWindowStyle** – Window style mask for the main window.
- **SSConcurrency** – Capture runs on a background thread; UI updates on the main thread.

## FOSS libraries

- **libX11** – X11 API for `XGetImage()` on the root window. Used for full-screen and region capture. Converts XImage pixel data (with visual masks) to RGB and builds an `NSImage` for preview and PNG export.
- **GNUStep** – NSBitmapImageRep and `representationUsingType:NSPNGFileType` for writing PNG files.

## HiDPI

GNUstep renders at 1:1 pixels; on high-DPI screens set the `GSScaleFactor`
user default once to scale every GNUstep app (see the workspace
[README](../README.md#hidpi-displays)):

```bash
defaults write NSGlobalDomain GSScaleFactor 2.0     # e.g. 2.0 for 192 DPI
defaults delete NSGlobalDomain GSScaleFactor        # revert
```

## License

GNU General Public License v3 or later. See LICENSE.
