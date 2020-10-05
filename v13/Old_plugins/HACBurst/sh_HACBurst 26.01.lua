

hacburst		= {}
local Max		= 512 --63000
local Done		= "Done"
local CommonID	= "HACBurst"
local DEBUG 	= true


if SERVER then
	util.AddNetworkString(CommonID)
	
	util.AddNetworkString("start_msg")
	util.AddNetworkString("msg_part")
end

// ill just write a wrapper, you can sort of conform it to your needs

if CLIENT then
	function SendLongString(str)
		local len = string.len(str)
		local pos = 1
		local index = 0
		
		local tosend = {}
		
		while(len > 0) do
			local part = string.sub(pos, math.min(60 * 1024, len - pos))
			
			table.insert(tosend, part)
			
			pos = pos + 60 * 1024
			index = index + 1
			len = len - 60 * 1024
		end
		
		
		local id = tostring(RealTime() + math.random(0, 1000)) -- idk, you can change this later
		
		net.Start("start_msg")
			net.WriteString(id)
			net.WriteUInt(index, 16)
		net.SendToServer()
		
		index = 1
		for k,v in pairs(tosend) do
			net.Start("msg_part")
				net.WriteString(id)
				net.WriteUInt(index, 16)
				net.WriteString(v)
			net.SendToServer()
			index = index + 1
		end
		
	end
else
	net.Receive("start_msg", function(len,pl)
		pl.RecQueue = pl.RecQueue or {}
		
		local id = net.ReadString()
		local count = net.ReadUInt(16)
		pl.RecQueue[id] = pl.RecQueue[id] or {}
		pl.RecQueue[id].ExpectedCount = count
	end)
	
	net.Receive("msg_part", function(len,pl)
		pl.RecQueue = pl.RecQueue or {}
		local id = net.ReadString()
		local index = net.ReadUInt(16)
		
		pl.RecQueue[id] = pl.RecQueue[id] or {}
		pl.RecQueue[id].Tab = pl.RecQueue[id].Tab or {}
		
		pl.RecQueue[id].Tab[index] = net.ReadString()
		
		pl.RecQueue[id].GotCount = (pl.RecQueue[id].GotCount or 0) + 1
		
		if(pl.RecQueue[id].ExpectedCount != nil and pl.RecQueue[id].ExpectedCount == pl.RecQueue[id].GotCount) then
			local msg = ""
			
			for k,v in ipairs( pl.RecQueue[id].Tab ) do
				msg = msg .. v
			end
			
			pl.RecQueue[id] = nil
			
			print("! got bytes: ", #msg)
		end
	end)
end

--[[
if CLIENT then

concommand.Add("test", function(p,c,a,s)
	local size = tonumber(s)
	if size == 0 then return print("no size") end
	
	local str = string.rep("H", size)
	
	print("! sending: ", #str, " bytes")
	SendLongString(str)
end)

end
]]


local function Split(str)
	local t = {}
	local len = str:len()
	local i = 0
	
	while i*Max < len do
		t[i+1] = str:sub(i*Max+1,(i+1)*Max)
		i=i+1
	end
	return t,#t
end

local function UnSplit(tab)
	local Temp = ""
	for k,v in ipairs(tab) do
		Temp = Temp..v
	end
	return Temp
end




local Hooks = {}
function hacburst.Hook(sID, callback)
	if Hooks[sID] then
		ErrorNoHalt("Hacburst "..sID.." exists, not adding from "..debug.getinfo(2).short_src)
		return
	end
	
	Hooks[sID] = callback
end


local Buff = {}
local function InternalReceive(len,ply) --Shared
	local sID 	= net.ReadString()
	local Cont	= net.ReadString()
	
	if not Hooks[sID] then
		if IsValid(ply) then
			if not CLIENT then
				HAC.LogAndKickFailedInit(ply,"Unhandled hacburst: '"..sID.."'", HAC.Msg.LOL2, true)
			end
		else
			Error("Unhandled hacburst: '"..sID.."'\n")
		end
		return
	end
	
	if (Cont == Done) then
		local CRC = net.ReadString()
		
		if not Buff[sID] then
			if CLIENT then
				Error("Buff fuckup: "..sID)
			else
				HAC.LogAndKickFailedInit(ply,"Buff fuckup: "..sID, HAC.Msg.LOL2, true)
			end
			return
		end
		
		local Tab 		= Buff[sID]
		local Splits 	= #Tab
		Buff[sID] = nil --Clear
		
		local str 		= UnSplit(Tab)
		local NewCRC 	= tostring( util.CRC(str) )
		
		if (NewCRC != CRC) then
			if IsValid(ply) and not CLIENT then
				HAC.LogAndKickFailedInit(ply,"Bad CRC for incoming hacburst '"..sID.."', expected '"..CRC.."', got '"..NewCRC.."'", HAC.Msg.LOL2, true)
				return
			end
			Error("Bad CRC for incoming hacburst '"..sID.."', expected '"..CRC.."', got '"..NewCRC.."'\n")
		end
		
		local ret,err = pcall(function()
			Hooks[sID](str,len,sID,CRC,NewCRC,Splits,ply)
		end)
		if err then
			if IsValid(ply) and not CLIENT then
				HAC.LogAndKickFailedInit(ply,"Hacburst hook '"..sID.."' failed: "..err, HAC.Msg.LOL, true)
				return
			end
			ErrorNoHalt("Hacburst hook '"..sID.."' failed: "..err.."\n")
		end
	else
		if not Buff[sID] then
			Buff[sID] = {}
		end
		
		table.insert(Buff[sID], Cont)
	end
end
net.Receive(CommonID, InternalReceive)




local function SendThis(ply)
	if CLIENT then
		net.SendToServer()
	else
		if ply then
			net.Send(ply)
		else
			net.Broadcast()
		end
	end
end

local function SendChunk(sID,CRC,ply, v,Splits,Total)
	net.Start(CommonID)
		net.WriteString(sID)
		net.WriteString(v)
	SendThis(ply)
	
	if DEBUG then
		print("! chunk ", sID.." ", Total.Splits.."/"..Splits, CurTime() )
	end
	
	Total.Splits = Total.Splits + 1
	
	if Splits == 0 or Total.Splits == Splits then
		if DEBUG then
			print("! end ", sID.." ", Total.Splits.."/"..Splits, CurTime() )
		end
		
		net.Start(CommonID)
			net.WriteString(sID)
			net.WriteString(Done)
			net.WriteString(CRC)
		SendThis(ply)
	end
end

function hacburst.Send(sID,str,ply)
	if str then return end --off
	
	local CRC = tostring( util.CRC(str) )
	
	local Tab,Splits = Split(str)
	local Total = {Splits = 0}
	local fast	= true
	
	if Splits != 0 then
		fast = false
	end
	
	if DEBUG then
		if fast then
			print("! start FAST: ", sID, CurTime() )
		else
			print("! start ", sID..", WILL SPLIT "..Splits.." times! "..CurTime().."\n")
		end
	end
	
	for k,v in ipairs(Tab) do
		if fast then
			SendChunk(sID,CRC,ply, v,Splits,Total)
		else
			--timer.Simple(k + 2, function()
				SendChunk(sID,CRC,ply, v,Splits,Total)
			--end)
		end
	end
end






