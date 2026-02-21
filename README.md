# macOS Window Corner Radius Tweak

**macOS Tahoe (16) — Darwin 25.x — Apple Silicon**

Reduces macOS window corner radius from 16.0 (Tahoe default) to 10.0 (matching Sequoia / macOS 15).

## Why

I couldn't cope with the corners anymore. I don't like disabling SIP but the
corners are too much. Please for the love of glob() fix this Apple.

## Screenshot

![Screenshot description](screenshot.png)

## Prerequisites

- SIP must be disabled for this to work on macOS core apps (eg Safari)
- Xcode Command Line Tools installed (for clang)

## Disable SIP

1. Shut down your Mac
2. Hold the power button to boot into Recovery Mode
3. Open Terminal from the Utilities menu
4. Run: `csrutil disable`
5. Reboot

## Adjusting the Radius

Edit `kDesiredCornerRadius` in `SafariCornerTweak.m`, then recompile and re-sign.

| Value | Effect |
|-------|--------|
| `0.0` | Fully square |
| `4.0` | Subtle rounding |
| `10.0` | Sequoia (macOS 15) style |
| `16.0` | Tahoe (macOS 16) default |

## Installation

1. Compile

```bash
clang -arch arm64e -dynamiclib -framework AppKit \
  -o SafariCornerTweak.dylib \
  SafariCornerTweak.m
```

2. Sign

```bash
codesign -f -s - SafariCornerTweak.dylib
```

3. Install

```bash
sudo cp SafariCornerTweak.dylib /usr/local/lib/
```

## Launch an app with the fix

```bash
DYLD_INSERT_LIBRARIES=/usr/local/lib/SafariCornerTweak.dylib \
    /Applications/Safari/MacOS/Contents/Safari
```

## Install globally (all apps)

> **Warning:** This injects the dylib into every app in your session. The tweak only modifies
`NSThemeFrame` so it should be harmless, but if any app crashes on launch, remove the env var
immediately with `launchctl unsetenv`.

1. Install the launch agent:

```bash
cp com.local.dyld-inject.plist ~/Library/LaunchAgents/com.local.dyld-inject.plist
```

2. Activate it

```bash
launchctl load ~/Library/LaunchAgents/com.local.dyld-inject.plist
```

## Uninstall

```bash
launchctl unload ~/Library/LaunchAgents/com.local.dyld-inject.plist
rm -f /usr/local/lib/SafariCornerTweak.dylib
```
