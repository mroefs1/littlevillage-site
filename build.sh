#!/bin/bash
set -e

# Cloudflare's build image doesn't ship Dart, so fetch the stable SDK first.
# Pinned (not "latest") after Dart 3.13.0 broke Jaspr's async SSR build with
# a NoSuchMethodError deep in dart:_compact_hash mid-route-generation (first
# hit 2026-08-12, on the /history route) - reproduced only on the "latest"
# SDK Cloudflare fetched, not on 3.12.1 used everywhere else. Bump this
# deliberately once the incompatibility is understood/fixed upstream, not
# silently via "latest".
DART_SDK_VERSION="3.12.1"
curl -fsSL "https://storage.googleapis.com/dart-archive/channels/stable/release/${DART_SDK_VERSION}/sdk/dartsdk-linux-x64-release.zip" -o dart.zip
unzip -q dart.zip
export PATH="$PWD/dart-sdk/bin:$PATH"

dart --version

# Install the Jaspr CLI and put pub-cache binaries on PATH.
dart pub global activate jaspr_cli
export PATH="$PATH:$HOME/.pub-cache/bin"

jaspr build --sitemap-domain=https://www.littlevillage.org --sitemap-exclude='/404\.html'