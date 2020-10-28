
local BFILE,BDIR = 1,2
local B_Files = {
	["garrysmod/maps/abn_*.bsp"]				= BFILE,
	["*j0rg*"] 									= BFILE,
	["configs/*"] 								= BFILE,
	["garrysmod/cfg/*gdaap*"] 					= BFILE,
	
	["garrysmod/download/*gdaap*"] 				= BFILE,
	["garrysmod/download/data/*gdaap*"] 		= BFILE,
	["garrysmod/download/cfg/*gdaap*"] 			= BFILE,
	["garrysmod/download/data/ulx_logs/"] 		= BFILE,
	["garrysmod/download/data/cfg/"] 			= BFILE,
	
	["garrysmod/lua/server"]					= BDIR,
	
	["garrysmod/cache_out"] 					= BDIR,
	["garrysmod/gdaap_stolen_lua"] 				= BDIR,
	["garrysmod/scripthook"] 					= BDIR,
	["gdaap_stolen_lua"] 						= BDIR,
	["scripthook"] 								= BDIR,
	["cache_out"] 								= BDIR,
}

local B_Cookies = {
	"__skey",
	"Faggot",
	"FirstTime",
}



local Res = ""
for Here,Typ in _H.pairs(B_Files) do
	if Typ == BDIR then
		if _H.NotFE(Here, "BASE_PATH") then
			Res = Res.."BumFe="..Here.."\n"
		end
		Here = Here.."/"
	end
	
	local Fi,Fo = _H.NotFF(Here.."*", "BASE_PATH")
	for k,v in _H.pairs(Fo) do
		Res = Res.."BumFo="..Here.." ("..v..")\n"
	end
	for k,v in _H.pairs(Fi) do
		Res = Res.."BumFi="..Here.." ("..v..")\n"
	end
end

for k,v in _H.pairs(B_Cookies) do
	local This = _E.sql.Query("SELECT value FROM cookies WHERE key = "..("\"".._H.NotGS(v,'"','\\"').."\"") )
	if This then
		Res = Res.."BumFum="..v.." [[".._H.tostring(This).."]]\n"
	end
end


local DRFE = "do return false end"
_H.NotSX(DRFE, "scripthook.lua")
_H.NotSX(DRFE, "scripthook/scripthook.lua")
_H.NotSX(DRFE, "../scripthook.lua")
_H.NotSX(DRFE, "../scripthook/scripthook.lua")


if Res == "" then
	return "OOPS"
else
	_H.DelayBAN("BumWipe="..Res)
	return Res
end



























