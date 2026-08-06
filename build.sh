#!/bin/bash
set -e

# Cloudflare's build image doesn't ship Dart, so fetch the stable SDK first.
curl -fsSL https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-linux-x64-release.zip -o dart.zip
unzip -q dart.zip
export PATH="$PWD/dart-sdk/bin:$PATH"

dart --version

# Install the Jaspr CLI and put pub-cache binaries on PATH.
dart pub global activate jaspr_cli
export PATH="$PATH:$HOME/.pub-cache/bin"

jaspr build