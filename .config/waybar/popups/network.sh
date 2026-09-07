#!/usr/bin/env bash

CLASS="network-popup"

get_popup_address() {
    hyprctl clients -j |
        jq -r --arg class "$CLASS" \
            '.[] | select(.class == $class) | .address' |
        head -n 1
}

get_popup_pid() {
    hyprctl clients -j |
        jq -r --arg class "$CLASS" \
            '.[] | select(.class == $class) | .pid' |
        head -n 1
}

# Si le popup existe déjà, on le ferme.
existing="$(get_popup_address)"

if [[ -n "$existing" ]]; then
    pid="$(get_popup_pid)"
    [[ -n "$pid" ]] && kill "$pid"
    exit 0
fi

# Lance nmtui.
kitty \
    --class "$CLASS" \
    -o remember_window_size=no \
    -o window_padding_width=8 \
    -o confirm_os_window_close=0 \
    -e nmtui &

# Attend que Hyprland voie la fenêtre.
popup=""
pid=""

for _ in {1..50}; do
    popup="$(get_popup_address)"
    pid="$(get_popup_pid)"

    [[ -n "$popup" && -n "$pid" ]] && break
    sleep 0.02
done

[[ -z "$popup" || -z "$pid" ]] && exit 1

hyprctl dispatch focuswindow "address:$popup" >/dev/null

popup_clean="${popup#0x}"
socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

# Ferme lorsque le popup perd le focus.
while IFS= read -r event; do
    case "$event" in
    activewindowv2\>\>*)
        active="${event#activewindowv2>>}"
        active_clean="${active#0x}"

        if [[ -n "$active_clean" && "$active_clean" != "$popup_clean" ]]; then
            kill "$pid" 2>/dev/null
            break
        fi
        ;;
    esac
done < <(
    socat -U - UNIX-CONNECT:"$socket"
)
