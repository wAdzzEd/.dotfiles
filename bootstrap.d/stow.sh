#!/usr/bin/env bash

source "$(dirname "$0")/common.sh"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

cd "$ROOT"

info "Creating symbolic links..."

stow --verbose .

success "Dotfiles linked."
