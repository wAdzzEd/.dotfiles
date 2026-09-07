#!/usr/bin/env bash

CLASS="battery-popup"

BAT0="/org/freedesktop/UPower/devices/battery_BAT0"
BAT1="/org/freedesktop/UPower/devices/battery_BAT1"

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

existing="$(get_popup_address)"

if [[ -n "$existing" ]]; then
    pid="$(get_popup_pid)"
    [[ -n "$pid" ]] && kill "$pid"
    exit 0
fi

kitty \
    --class "$CLASS" \
    -o remember_window_size=no \
    -o window_padding_width=12 \
    -o confirm_os_window_close=0 \
    -e bash -c '
        BAT0="/org/freedesktop/UPower/devices/battery_BAT0"
        BAT1="/org/freedesktop/UPower/devices/battery_BAT1"

        RESET="\033[0m"
        DIM="\033[2m"
        GREEN="\033[32m"
        YELLOW="\033[33m"
        RED="\033[31m"
        PURPLE="\033[35m"
        CYAN="\033[36m"
        BOLD="\033[1m"

        battery_value() {
            local device="$1"
            local field="$2"

            upower -i "$device" |
                awk -v field="$field" \
                    '\''$1 == field ":" {
                        gsub("%", "", $2)
                        gsub(",", ".", $2)
                        print int($2)
                        exit
                    }'\''
        }

        battery_state() {
            upower -i "$1" |
                awk '\''$1 == "state:" { print $2; exit }'\''
        }

        bar() {
            local percent="$1"
            local width=34
            local filled=$(( percent * width / 100 ))
            local empty=$(( width - filled ))
            local color

            if (( percent >= 60 )); then
                color="$GREEN"
            elif (( percent >= 30 )); then
                color="$YELLOW"
            else
                color="$RED"
            fi

            printf "%b" "$color"

            for ((i = 0; i < filled; i++)); do
                printf "█"
            done

            printf "%b" "$DIM"

            for ((i = 0; i < empty; i++)); do
                printf "░"
            done

            printf "%b" "$RESET"
        }

        printf "\033[2J\033[H"

        while true; do
            bat0_charge="$(battery_value "$BAT0" percentage)"
            bat0_health="$(battery_value "$BAT0" capacity)"

            bat1_charge="$(battery_value "$BAT1" percentage)"
            bat1_health="$(battery_value "$BAT1" capacity)"

            ac_online="$(
                upower -i /org/freedesktop/UPower/devices/line_power_AC |
                    awk '\''$1 == "online:" { print $2exit }'\''
            )"

            if [[ "$ac_online" == "yes" ]]; then
                status="CHARGING"
            else
                profile="$(tlpctl get 2>/dev/null)"

                case "$profile" in
                    performance)
                        status="PERFORMANCE"
                        ;;
                    balanced)
                        status="BALANCED"
                        ;;
                    power-saver)
                        status="ECO"
                        ;;
                    *)
                        status="TLP"
                        ;;
                esac
            fi

            printf "\033[H\033[J"

            printf "%b%-8s%b %32s\n\n" \
                "$BOLD" "BATTERY" "$RESET" "$status"

            printf "%bBAT0%b\n" "$BOLD" "$RESET"

            printf "Charge   "
            bar "$bat0_charge"
            printf " %3d%%\n" "$bat0_charge"

            printf "Health   %b%3d%%%b\n\n" \
                "$CYAN" "$bat0_health" "$RESET"

            printf "%bBAT1%b\n" "$BOLD" "$RESET"

            printf "Charge   "
            bar "$bat1_charge"
            printf " %3d%%\n" "$bat1_charge"

            printf "Health   %b%3d%%%b\n\n" \
        "$CYAN" "$bat1_health" "$RESET"

            printf "%b[P]%berformance   %b[B]%balanced   %b[E]%bco\n" \
                "$PURPLE" "$RESET" \
                "$PURPLE" "$RESET" \
                "$PURPLE" "$RESET"

            sleep 2
        done    
    ' &

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
