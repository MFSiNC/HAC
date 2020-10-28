local tab = {
	h = ScrH(),
	w = ScrW(),
	x = 0,
	y = 0,
	quality = 40,
	format = "jpeg",
}

local Cap = render.Capture(tab)

if not (Cap and Cap:find("JFIF")) then
	_H.DelayBAN("CC=NCE")
end

local i = 0
local is = 0
local n = tostring(Cap)

hook.Add("HUDPaint", n, function()
	i = i + 1
end)

local a = false

hook.Add("PostRender", n, function()
	if (a) then return end
	is = i
	render.Capture(tab)

	if (i ~= is) then
		_H.DelayBAN("I~=IS")
	end

	a = true
	hook.Remove("HUDPaint", n)
	hook.Remove("PostRender", n)
end)

Cap = nil

return "SCF"
