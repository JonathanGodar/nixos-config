hl.config({
	input = {
		kb_layout = "se",
		kb_variant = "nodeadkeys",

		follow_mouse = 1,
		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
		touchpad = {
			natural_scroll = true,
		},
	},
	misc = {
		disable_splash_rendering = true,
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("ghostty -e zellij"))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("vicinae toggle"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.close())
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("firefox"))

hl.config({
	misc = {
		force_default_wallpaper = 0, -- to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
	},
})

hl.config({
	cursor = {
		inactive_timeout = 30,
		no_hardware_cursors = 1, -- TODO remove this, fix nvidia and hope this solves the issue.
	},
})

for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. "+ SHIFT + f", hl.dsp.window.float())
hl.bind(mainMod .. "+ f", hl.dsp.window.fullscreen())
hl.bind(mainMod .. "+ m", hl.dsp.window.fullscreen({ mode = "maximized" }))

local dir_map = {
	h = "l",
	j = "d",
	k = "u",
	l = "r",
}

for key, dir in pairs(dir_map) do
	hl.bind(mainMod .. "+" .. key, hl.dsp.focus({ direction = dir }))
end

-- TODO move so that this is required in flake/some config option is available in lua.
require("lua/faccun_monitors")
