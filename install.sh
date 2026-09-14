#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

printf '\nInstalling personal development environment...\n\n'

mkdir -p "$HOME/.local/bin"
install -m 755 "$DOTFILES_DIR/bin/pi-cloud" "$HOME/.local/bin/pi-cloud"

if ! grep -Fq 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc" 2>/dev/null; then
  printf '\n# Personal CLI tools\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$HOME/.bashrc"
fi
export PATH="$HOME/.local/bin:$PATH"

if ! command -v rclone >/dev/null 2>&1; then
  echo "Installing rclone..."
  sudo apt-get update
  sudo apt-get install -y rclone
fi

if ! command -v pi >/dev/null 2>&1; then
  echo "Installing Pi coding agent..."
  npm install -g --ignore-scripts @earendil-works/pi-coding-agent
fi

if [[ "${CODESPACES:-}" == "true" ]]; then
  echo "Configuring GitHub Codespaces persistent storage..."

  mkdir -p /workspaces/.private/rclone
  mkdir -p /workspaces/.private/pi-agent
  mkdir -p /workspaces/.pi-sync

  chmod 700 /workspaces/.private
  chmod 700 /workspaces/.private/rclone
  chmod 700 /workspaces/.private/pi-agent

  if [[ -n "${RCLONE_CONFIG_B64:-}" ]]; then
    printf '%s' "$RCLONE_CONFIG_B64" | base64 -d > /workspaces/.private/rclone/rclone.conf
    chmod 600 /workspaces/.private/rclone/rclone.conf
    echo "rclone configuration restored from RCLONE_CONFIG_B64."
  else
    echo "WARNING: RCLONE_CONFIG_B64 is not available."
    echo "pi-cloud will ask you to configure this before cloud sync can work."
  fi
fi

printf '\nDevelopment environment ready.\n'
printf 'Use: pi-cloud\n'
printf 'New session: pi-cloud new\n\n'
