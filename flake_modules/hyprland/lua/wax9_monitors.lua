local mainMonitor = "eDP-1"

hl.monitor({
	output = mainMonitor,
	mode = "3000x2000@60",
	position = "0x0",
	scale = "1.33",
})

for i = 1, 7 do
	hl.workspace_rule({ workspace = i, monitor = mainMonitor, default = (i == 1) })
end
