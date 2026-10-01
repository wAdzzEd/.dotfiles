#!/usr/bin/env bash

set -u

if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <class> <command> [args...]" >&2
    exit 1
fi

CLASS="$1"
shift

get_popup_info() {
    hyprctl clients -j 2>/dev/null |
        jq -r --arg class "$CLASS" '
            .[]
            | select(.class == $class)
            | "\(.address) \(.pid) \(.at[0]) \(.at[1]) \(.size[0]) \(.size[1])"
        ' |
        sed -n '1p'
}

EXISTING_ADDRESS=""
EXISTING_PID=""

while read -r EXISTING_ADDRESS EXISTING_PID _; do
    break
done < <(get_popup_info)

if [[ -n "$EXISTING_ADDRESS" && -n "$EXISTING_PID" ]]; then
    kill "$EXISTING_PID" 2>/dev/null || true
    exit 0
fi

kitty \
    --class "$CLASS" \
    -o remember_window_size=no \
    -o confirm_os_window_close=0 \
    "$@" &

LAUNCH_PID=$!

POPUP_ADDRESS=""
POPUP_PID=""
POPUP_X=""
POPUP_Y=""
POPUP_W=""
POPUP_H=""

for _ in {1..50}; do

    while read -r POPUP_ADDRESS POPUP_PID POPUP_X POPUP_Y POPUP_W POPUP_H; do
        break
    done < <(get_popup_info)

    if [[ -n "$POPUP_ADDRESS" && -n "$POPUP_PID" ]]; then
        break
    fi

    sleep 0.05
done

if [[ -z "$POPUP_ADDRESS" || -z "$POPUP_PID" ]]; then
    kill "$LAUNCH_PID" 2>/dev/null || true
    echo "Impossible de trouver la fenêtre $CLASS" >&2
    exit 1
fi

echo "Popup trouvé : $POPUP_ADDRESS / PID $POPUP_PID" >&2

hyprctl dispatch focuswindow \
    "address:$POPUP_ADDRESS" >/dev/null

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

if [[ ! -S "$SOCKET" ]]; then
    echo "Socket Hyprland introuvable : $SOCKET" >&2
    kill "$POPUP_PID" 2>/dev/null || true
    exit 1
fi

POPUP_ADDRESS_CLEAN="${POPUP_ADDRESS#0x}"

while kill -0 "$POPUP_PID" 2>/dev/null; do

    # -------------------------------------------------
    # Mouse-out
    # -------------------------------------------------

    CURSOR="$(hyprctl cursorpos 2>/dev/null || true)"

    if [[ "$CURSOR" =~ ^([0-9]+),([0-9]+)$ ]]; then

        CURSOR_X="${BASH_REMATCH[1]}"
        CURSOR_Y="${BASH_REMATCH[2]}"

        if ((CURSOR_X < POPUP_X || \
            CURSOR_X >= POPUP_X + POPUP_W || \
            CURSOR_Y < POPUP_Y || \
            CURSOR_Y >= POPUP_Y + POPUP_H)); then

            kill "$POPUP_PID" 2>/dev/null || true
            exit 0
        fi
    fi

    # -------------------------------------------------
    # Focus loss
    # -------------------------------------------------

    if read -r -t 0.05 EVENT; then

        case "$EVENT" in

        activewindowv2\>\>*)

            ACTIVE_ADDRESS="${EVENT#activewindowv2>>}"
            ACTIVE_ADDRESS_CLEAN="${ACTIVE_ADDRESS#0x}"

            if [[ -n "$ACTIVE_ADDRESS_CLEAN" &&
                "$ACTIVE_ADDRESS_CLEAN" != "$POPUP_ADDRESS_CLEAN" ]]; then

                kill "$POPUP_PID" 2>/dev/null || true
                exit 0
            fi

            ;;
        esac
    fi

done < <(
    socat -U - UNIX-CONNECT:"$SOCKET"
)
