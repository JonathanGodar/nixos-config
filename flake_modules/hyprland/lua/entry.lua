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
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + enter", hl.dsp.exec_cmd("ghostty"))
hl.bind(mainMod .. " + spaace", hl.dsp.exec_cmd("vicinae toggle"))
hl.bind(mainMod .. " + shift + C", hl.dsp.window.close())
