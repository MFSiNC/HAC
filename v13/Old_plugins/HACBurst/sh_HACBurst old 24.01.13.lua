

hacburst = {
	CommonID	= "HACBurst",
	Done		= "Done",
	Max			= 35840,
}


if SERVER then
	util.AddNetworkString(hacburst.CommonID)
end



local function Split(str)
	local Temp 		= ""
	local result    = {}
	local index     = 1
	
	for i=0,str:len() do
		Temp = Temp..str:sub(i,i)
		
		if (#Temp == hacburst.Max) then
			result[index] = Temp
			index = index +1
			Temp = ""
		end
	end
	
	result[index] = Temp
	return result
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
			Error("Unhandled hacburst: '"..sID.."' from "..tostring(ply).."\n")
		else
			Error("Unhandled hacburst: '"..sID.."'\n")
		end
		return
	end
	
	if (Cont == hacburst.Done) then
		local CRC = net.ReadString()
		
		if not Buff[sID] then
			return Error("Buff fuckup: "..sID)
		end
		
		local Tab = Buff[sID]
		
		local str = UnSplit(Tab)
		local NewCRC = tostring( util.CRC(str) )
		
		if (NewCRC != CRC) then
			ErrorNoHalt("Bad CRC for incoming hacburst '"..sID.."', expected '"..CRC.."', got '"..NewCRC.."'\n")
		end
		
		local ret,err = pcall(function()
			Hooks[sID](str,len,sID,CRC,NewCRC,#Tab,ply)
		end)
		if err then
			ErrorNoHalt("Hacburst hook '"..sID.."' failed: "..err.."\n")
		end
		
		Buff[sID] = nil --Clear
	else
		if not Buff[sID] then
			Buff[sID] = {}
		end
		
		table.insert(Buff[sID], Cont)
	end
end
net.Receive(hacburst.CommonID, InternalReceive)




function hacburst.Send(sID,str,ply)
	local CRC = tostring( util.CRC(str) )
	
	for k,v in ipairs( Split(str) ) do
		net.Start(hacburst.CommonID)
		net.WriteString(sID)
		net.WriteString(v)
		
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
	
	net.Start(hacburst.CommonID)
	net.WriteString(sID)
	net.WriteString(hacburst.Done)
	net.WriteString(CRC)
	
	
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














