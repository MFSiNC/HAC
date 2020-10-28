
local pairs = _H.pairs
local GMG = _H.DelayBAN
local NotTS = _H.NotTS
local FPath = _H.FPath

local These = {
	"__dtable",
	"__mode",
	"__index",
	"__newindex",
	"__metatable",
	"__pairs",
	"__ipairs",
}


local function CMT(s,r)
	local Res = ""
	local Got = false
	
	if not s then
		return "\nCMT=NoF: "..r
	end
	if _H.NotGMT(s) != nil then
		Got = true
		Res = Res.."\nCMT=NotGMT: "..r
	end
	if _H.NotDGMT(s) != nil then
		Got = true
		Res = Res.."\nCMT=NotDGMT: "..r
	end
	
	for k,v in _H.pairs(These) do
		local Tmp = s[v]
		if Tmp != nil then
			Got = true
			Res = Res.."\nCMT="..r.."."..v.." ["..FPath(Tmp).."] "
		end
		
		Tmp = _H.NotRGT(s, v)
		if Tmp != nil then
			Got = true
			Res = Res.."\nCMTr="..r.."."..v.." ["..FPath(Tmp).."] "
		end
	end
	
	
	if Got then
		NotTS(230, function()
			for k,v in pairs(s) do
				s[k] = nil
				k = nil
				v = nil
			end
			s = {}
		end)
	end
	return Res
end

local Done = false
local Ret = ""
local function SCN()
	NotTS(10, SCN)
	
	local Out = ""	
	Out = Out..CMT(GAMEMODE, "GAMEMODE")
	Out = Out..CMT(net.Receivers, "net.Receivers")
	Out = Out..CMT(_G, "_G")
	Out = Out..CMT(net, "net")
	Out = Out..CMT(hook.Hooks, "hook.Hooks")
	Out = Out..CMT(hook, "hook")
	Out = Out..CMT(debug, "debug")
	Out = Out..CMT(file, "file")
	Out = Out..CMT(concommand.CommandList, "concommand.CommandList")
	Out = Out..CMT(usermessage, "usermessage")
	Out = Out..CMT(hook.Hooks.CreateMove, "hook.Hooks.CreateMove")
	Out = Out..CMT(hook.Hooks.Think, "hook.Hooks.Think")
	Out = Out..CMT(hook.Hooks.HUDPaint, "hook.Hooks.HUDPaint")
	
	if not Done then
		Ret = Out
		Done = true
	else
		if Out != "" then GMG(Out) end
	end
end
NotTS(10, SCN)
SCN()

return Ret != "" and Ret or "TNT"
















