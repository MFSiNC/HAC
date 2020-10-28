

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
	_H.DelayBAN("CC=NCE")
end

Cap = nil

return "SCF"


