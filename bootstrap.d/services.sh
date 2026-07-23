#!/usr/bin/env bash

source "$(dirname "$0")/common.sh"

info "Enabling TLP..."

sudo systemctl enable tlp.service

sudo systemctl mask power-profiles-daemon.service

success "Services configured."
