#!/bin/bash
export DYLD_INSERT_LIBRARIES=
launchctl unload ~/Library/LaunchAgents/com.local.dyld-inject.plist || echo "service not currently loaded"
clang -arch arm64e -arch x86_64 -dynamiclib -framework AppKit \
  -o SafariCornerTweak.dylib \
  SafariCornerTweak.m
sudo cp SafariCornerTweak.dylib /usr/local/lib/
sudo codesign -f -s - /usr/local/lib/SafariCornerTweak.dylib
cp com.local.dyld-inject.plist ~/Library/LaunchAgents/com.local.dyld-inject.plist
launchctl load ~/Library/LaunchAgents/com.local.dyld-inject.plist
