#!/bin/bash

echo "Installing rover CLI..."
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
  powershell -Command "iwr 'https://rover.apollo.dev/win/latest' | iex"
else
  curl -sSL https://rover.apollo.dev/nix/latest | sh
fi

echo "Downloading Apollo Router binary..."
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
  curl -sSL https://router.apollo.dev/download/windows/latest | sh
else
  curl -sSL https://router.apollo.dev/download/nix/latest | sh
fi

echo "Setup complete."
