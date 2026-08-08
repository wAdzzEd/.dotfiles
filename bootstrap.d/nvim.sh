#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/common.sh"

info "Installing Neovim plugins..."

nvim --headless "+Lazy! sync" +qa

success "Neovim plugins installed."
