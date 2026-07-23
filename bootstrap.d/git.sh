#!/usr/bin/env bash

source "$(dirname "$0")/common.sh"

info "Checking Git..."

if command -v git >/dev/null; then
    success "Git already installed."
else
    error "Git is not installed."
    exit 1
fi
