#!/usr/bin/env bash

source "$(dirname "$0")/common.sh"

if [[ "$SHELL" != */zsh ]]; then

    info "Changing default shell..."

    chsh -s "$(which zsh)"

fi
