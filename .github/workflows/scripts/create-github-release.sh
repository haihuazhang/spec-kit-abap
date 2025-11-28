#!/usr/bin/env bash
set -euo pipefail

# create-github-release.sh
# Create a GitHub release with all template zip files
# Usage: create-github-release.sh <version>

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <version>" >&2
  exit 1
fi

VERSION="$1"

# Remove 'v' prefix from version for release title
VERSION_NO_V=${VERSION#v}

gh release create "$VERSION" \
  .genreleases/spec-kit-abap-template-copilot-sh-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-copilot-ps-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-claude-sh-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-claude-ps-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-gemini-sh-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-gemini-ps-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-cursor-agent-sh-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-cursor-agent-ps-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-opencode-sh-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-opencode-ps-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-qwen-sh-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-qwen-ps-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-windsurf-sh-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-windsurf-ps-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-codex-sh-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-codex-ps-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-kilocode-sh-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-kilocode-ps-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-auggie-sh-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-auggie-ps-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-roo-sh-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-roo-ps-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-codebuddy-sh-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-codebuddy-ps-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-amp-sh-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-amp-ps-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-shai-sh-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-shai-ps-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-q-sh-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-q-ps-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-bob-sh-"$VERSION".zip \
  .genreleases/spec-kit-abap-template-bob-ps-"$VERSION".zip \
  --title "Spec Kit - ABAP Templates - $VERSION_NO_V" \
  --notes-file release_notes.md
