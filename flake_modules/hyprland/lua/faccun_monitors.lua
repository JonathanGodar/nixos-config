hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

hl.monitor({
	output = "DP-1",
	mode = "1920x1080@144",
	position = "1920x0",
})

hl.monitor({
	output = "DP-2",
	mode = "1920x1080@144",
	position = "0x0",
})

for i = 1, 7 do
	hl.workspace_rule({ workspace = i, monitor = "DP-1" })
end

for i = 8, 10 do
	hl.workspace_rule({ workspace = i, monitor = "DP-2" })
end
