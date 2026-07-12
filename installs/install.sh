#!/bin/sh
#
# Direct Application Installations
#
# This script installs applications that need special installation methods
# or are better installed directly from their official sources.

# Install Dia Browser if not already installed
if [ ! -d "/Applications/Dia.app" ]; then
  echo "Installing Dia..."
  curl -L -o /tmp/dia.dmg "https://releases.diabrowser.com/release/Dia-latest.dmg"
  hdiutil attach /tmp/dia.dmg -quiet
  cp -R "/Volumes/Dia/Dia.app" /Applications/
  hdiutil detach "/Volumes/Dia" -quiet
  rm /tmp/dia.dmg
  echo "Dia installed"
else
  echo "Dia already installed"
fi

echo "Direct application installations completed"
