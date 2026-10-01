-- =====================
-- Monitor
-- =====================
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = 1,
})

-- =====================
-- Input
-- =====================
hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,
		["col.active_border"] = "rgba(bd93f9ff)",
		["col.inactive_border"] = "rgba(282a36ff)",
	},
	decoration = {
		rounding = 8,
	},
	input = {
		kb_layout = "us",
		kb_variant = "intl",
		follow_mouse = 2,

		touchpad = {
			natural_scroll = true,
			tap_to_click = true,
			disable_while_typing = true,
		},
	},
})

-- =====================
-- Auto start
-- =====================
hl.on("hyprland.start", function()
	hl.exec_cmd("waybar")
	hl.exec_cmd("hyprpaper")
end)

-- =====================
-- Main modifier
-- =====================
local mainMod = "SUPER"

-- =====================
-- System
-- =====================
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 53 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 53 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute 53 toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute 54 toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region toggle"))

hl.bind(
	"ESCAPE",
	hl.dsp.exec_cmd([[
		ACTIVE_CLASS=$(hyprctl activewindow -j | jq -r '.class')

		case "$ACTIVE_CLASS" in
			audio-popup|network-popup|battery-popup|bluetooth-popup)
				hyprctl dispatch killactive
				;;
		esac
	]]),
	{
		non_consuming = true,
	}
)

-- =====================
-- Applications
-- =====================
hl.bind("CTRL + ALT + T", hl.dsp.exec_cmd("kitty"))
hl.bind("CTRL + ALT + F", hl.dsp.exec_cmd("zen-browser"))
hl.bind(mainMod .. " + SUPER_L", hl.dsp.exec_cmd("~/.config/hypr/scripts/rofi-toogle.sh"))

-- =====================
-- Window management
-- =====================
hl.bind(mainMod .. " + Q", hl.dsp.window.close())

-- Window move
hl.bind(mainMod .. " + LEFT", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + RIGHT", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + UP", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + DOWN", hl.dsp.window.move({ direction = "down" }))

-- Window resize
hl.bind(mainMod .. " + SHIFT + LEFT", hl.dsp.window.resize({ x = -10, y = 0, relative = true }))
hl.bind(mainMod .. " + SHIFT + RIGHT", hl.dsp.window.resize({ x = 10, y = 0, relative = true }))
hl.bind(mainMod .. " + SHIFT + UP", hl.dsp.window.resize({ x = 0, y = -10, relative = true }))
hl.bind(mainMod .. " + SHIFT + DOWN", hl.dsp.window.resize({ x = 0, y = 10, relative = true }))

-- Window focus
hl.bind("ALT + TAB", hl.dsp.window.cycle_next())
hl.bind("ALT + SHIFT + TAB", hl.dsp.window.cycle_next({ next = false }))

-- =====================
-- Workspaces
-- =====================
for i = 1, 5 do
	hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- =====================
-- Popups
-- =====================
local popup_size = "520 400"
local popup_move = "1360 45"

hl.window_rule({
	name = "audio-popup",
	match = { class = "audio-popup" },
	float = true,
	size = popup_size,
	move = popup_move,
})

hl.window_rule({
	name = "network-popup",
	match = { class = "network-popup" },
	float = true,
	size = popup_size,
	move = popup_move,
})

hl.window_rule({
	name = "battery-popup",
	match = { class = "battery-popup" },
	float = true,
	size = popup_size,
	move = popup_move,
})

hl.window_rule({
	name = "bluetooth-popup",
	match = { class = "bluetooth-popup" },
	float = true,
	size = popup_size,
	move = popup_move,
})

-- =====================
-- Rofi
-- =====================
hl.window_rule({
	name = "rofi",
	match = { class = "Rofi" },
})

-- =====================
-- Exit Hyprland
-- =====================
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + L", hl.dsp.exit())
