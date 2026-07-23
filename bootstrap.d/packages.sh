#!/usr/bin/env bash

source "$(dirname "$0")/common.sh"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

PACMAN="$ROOT/bootstrap.d/packages/pacman.txt"
AUR="$ROOT/bootstrap.d/packages/aur.txt"

info "Installing pacman packages..."

while IFS= read -r package || [[ -n "$package" ]]; do

    [[ -z "$package" ]] && continue
    [[ "$package" =~ ^# ]] && continue

    sudo pacman -S --needed --noconfirm "$package"

done < "$PACMAN"

if command -v yay >/dev/null; then

    info "Installing AUR packages..."

    while IFS= read -r package || [[ -n "$package" ]]; do

        [[ -z "$package" ]] && continue
        [[ "$package" =~ ^# ]] && continue

        yay -S --needed --noconfirm "$package"

    done < "$AUR"

fi

success "Packages installed."
