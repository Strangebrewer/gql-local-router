#!/bin/bash

if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
  echo ""
  echo "rover CLI must be installed manually in a PowerShell window."
  echo "Run the following commands in PowerShell (in order):"
  echo ""
  echo "   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser"
  echo "   iwr -UseBasicParsing 'https://rover.apollo.dev/win/latest' | iex"
  echo ""

  echo "Downloading Apollo Router binary..."
  ROUTER_VERSION=$(curl -s https://api.github.com/repos/apollographql/router/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
  curl -L "https://github.com/apollographql/router/releases/download/v${ROUTER_VERSION}/router-v${ROUTER_VERSION}-x86_64-pc-windows-msvc.tar.gz" -o router.tar.gz
  tar -xzf router.tar.gz
  mv dist/router.exe ./router.exe
  rm -rf router.tar.gz dist/

  echo "Setup complete."
else
  echo "Installing rover CLI..."
  curl -sSL https://rover.apollo.dev/nix/latest | sh

  echo "Downloading Apollo Router binary..."
  curl -sSL https://router.apollo.dev/download/nix/latest | sh

  echo "Setup complete."
fi
