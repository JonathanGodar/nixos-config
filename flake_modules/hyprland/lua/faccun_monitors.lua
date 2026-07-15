hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

local mainMonitor = "desc:AOC 32G1WG4 0x00001C80"
local secondMonitor = "desc:Acer Technologies Acer XF240H 0x7320DBB0"

hl.monitor({
	output = mainMonitor,
	mode = "1920x1080@144",
	position = "1920x0",
})

hl.monitor({
	output = secondMonitor,
	mode = "1920x1080@144",
	position = "0x0",
})

for i = 1, 7 do
	hl.workspace_rule({ workspace = i, monitor = mainMonitor, default = (i == 1) })
end

for i = 8, 10 do
	hl.workspace_rule({ workspace = i, monitor = secondMonitor, default = (i == 8) })
end

-- hl.on("hyprland.start", function()
-- 	hl.dispatch(hl.dsp.focus({ monitor = mainMonitor }))
-- end)
