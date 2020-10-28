

local Cap = render.Capture(
	{
		h		= ScrH(),
		w		= ScrW(),
		x 		= 0,
		y 		= 0,
		quality	= 40,
		format	= "jpeg",
	}
)
if not (Cap and Cap:find("JFIF")) then
	_H.DelayGMG("CC=CCE")
end

Cap = nil

return "nil"


