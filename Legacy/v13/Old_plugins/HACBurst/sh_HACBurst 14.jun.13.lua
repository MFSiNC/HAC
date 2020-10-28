
hacburst		= {}
local OneTimeID = {}
local Max		= 5500
local MaxChunks	= 300
local Wait		= 1
local CommonID	= "HACBurst"
local DEBUG 	= false
local CLIENT	= CLIENT
local SERVER	= (not CLIENT)
local NotDGE	= debug.getinfo
local NotTS		= timer.Simple
local NotRCC 	= RunConsoleCommand
local IsValid	= IsValid
local type		= type
local tostring	= tostring

if SERVER then
	util.AddNetworkString(CommonID)
	
	local function ToggleDebug(ply,cmd,args)
		if not ply:IsSuperAdmin() then return end
		
		DEBUG = not DEBUG
		
		print("! Debug: "..tostring(DEBUG) )
	end
	concommand.Add("hb_debug", ToggleDebug)
end

local util 		= {
	TableToJSON 	= util.TableToJSON,
	JSONToTable 	= util.JSONToTable,
	Base64Encode 	= util.Base64Encode,
	Compress 		= util.Compress,
	Decompress		= util.Decompress,
}
hacburst.util 		= util
hacburst.base64_enc = util.Base64Encode

local net		= {
	Start 			= net.Start,
	ReadString 		= net.ReadString,
	ReadDouble 		= net.ReadDouble,
	Receive 		= net.Receive,
	SendToServer 	= net.SendToServer,
	Send 			= net.Send,
	Broadcast		= net.Broadcast,
	WriteString 	= net.WriteString,
	WriteDouble 	= net.WriteDouble,
}


local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function base64_dec(data)
    data = data:gsub('[^'..b..'=]', '')
	
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end
hacburst.base64_dec = base64_dec

local function FPath(func)
	local What = type(func)
	if (What != "function") then return What,0,false end
	local DGI = NotDGE(func)
	if not DGI then return "Gone",0,false end
	
	local Path = (DGI.short_src or What):gsub("\\","/")
	local Line = (DGI.linedefined or 0)
	
	return Path,Line,true
end



local Hooks = {}

local function Hook(sID, Finish,Update,Start)
	if Hooks[sID] then
		local Where = (NotDGE(2).short_src or "Gone")
		if CLIENT then
			ErrorNoHalt("Hacburst "..sID.." exists, not adding from: "..Where.."\n")
			return
		else
			ErrorNoHalt("Hacburst "..sID.." OVERRIDEN from: "..Where.."\n")
		end
	end
	
	Hooks[sID] = {
		Finish	= Finish,
		Update	= Update,
		Start	= Start,
	}
end
hacburst.Hook = Hook


local Buff = {}
if SERVER then
	hacburst.Buff 	= Buff
	hacburst.Hooks 	= Hooks
end

local function CheckFakeStream(sID,tab,Split,Total,str,ply)	
	local Bad = false
	
	if #tab.Cont > 2000000 then
		Bad = "Cont("..#tab.Cont..") > 2000000"
	end
	
	if #str > Max then
		Bad = "#str("..#str..") > Max("..Max..")"
	end	
	if Total > MaxChunks then
		Bad = "Total("..Total..") > MaxChunks("..MaxChunks..")"
	end
	if Split > MaxChunks then
		Bad = "Split("..Split..") > MaxChunks("..MaxChunks..")"
	end
	if Split > Total then
		Bad = "Split("..Split..") > Total("..Total..")"
	end
	
	if Bad then
		if SERVER and IsValid(ply) then
			ply:FailInit("Hacburst error '"..sID.."' failed: "..Bad, HAC.Msg.HB_Bad, true)
			return true
		end
		Error("Hacburst error '"..sID.."' failed: "..Bad.."\n")
		
		return true
	end
end

local function InternalReceive(len,ply) --Shared
	local idx 		= net.ReadString()
	local sID 		= net.ReadString()
	local Split 	= net.ReadDouble()
	local Total 	= net.ReadDouble()
	local str 		= net.ReadString()
	
	--Same IDX as a previous stream
	if OneTimeID[idx] then
		if IsValid(ply) then
			if SERVER then
				ply:FailInit("Hacburst OneTimeID: '"..sID.."', '"..idx.."'", HAC.Msg.HB_Same)
			end
		else
			Error("Hacburst OneTimeID: '"..sID.."', '"..idx.."'\n")
		end
		return
	end
	
	--IF NOT HANDLED
	if not (Hooks[sID] and Hooks[sID].Finish) then
		if IsValid(ply) then
			if SERVER then
				ply:FailInit("Unhandled hacburst: '"..sID.."'", HAC.Msg.HB_Gone, true)
			end
		else
			Error("Unhandled hacburst: '"..sID.."'\n")
		end
		return
	end
	
	if DEBUG then
		print("! splits: ", sID, Split.."/"..Total)
	end
	
	
	if not Buff[idx] then
		Buff[idx]	= {
			Cont 	= "",
			Total	= Total,
		}
		
		--START STREAM
		if SERVER and Hooks[sID].Start then
			local ret,err = pcall(function()
				Hooks[sID].Start(sID,idx,Split,Total, ply)
			end)
			if err then
				ErrorNoHalt("Hacburst Start '"..sID.."' failed: "..err.."\n")
			end
		end
	end
	Buff[idx].Cont = Buff[idx].Cont..str
	
	--UPDATE STREAM
	if SERVER and Hooks[sID].Update then
		local ret,err = pcall(function()
			Hooks[sID].Update(sID,idx,Split,Total, Buff[idx], ply)
		end)
		if err then
			ErrorNoHalt("Hacburst Update '"..sID.."' failed: "..err.."\n")
		end
	end
	
	--CHECK FAKE
	if CheckFakeStream(sID, Buff[idx],Split,Total,str, ply) then
		Buff[idx] = nil
		return
	end
	
	
	if Split == Buff[idx].Total --[[Total]] then
		OneTimeID[idx] = true --Used
		
		--B64 DECODE
		local Cont = base64_dec(Buff[idx].Cont)
		if not Cont then
			if SERVER and IsValid(ply) then
				ply:FailInit("Hacburst hook '"..sID.."' No Cont64", HAC.Msg.HB_Cont)
			end
			ErrorNoHalt("Hacburst hook '"..sID.."' No Cont64\n")
			
			Buff[idx] = nil
			return
		end
		
		--DECOMPRESS
		Cont = util.Decompress(Cont)
		if not Cont then
			if SERVER and IsValid(ply) then
				ply:FailInit("Hacburst hook '"..sID.."' No ContLZ", HAC.Msg.HB_Comp)
			end
			ErrorNoHalt("Hacburst hook '"..sID.."' No ContLZ\n")
			file.Write("err_"..sID.."-"..idx..".txt", base64_dec(Buff[idx].Cont), "DATA")
			
			Buff[idx] = nil
			return
		end
		
		if DEBUG then
			print("! got Buff[idx], Cont: ", sID, #Buff[idx].Cont, #Cont)
		end
		Buff[idx] = nil
		
		--CALL FINISH
		local ret,err = pcall(function()
			Hooks[sID].Finish(Cont,len,sID,idx,Total,ply)
		end)
		if err then
			if SERVER and IsValid(ply) then
				ply:FailInit("Hacburst hook '"..sID.."' failed: "..err, HAC.Msg.HB_Fail)
			end
			ErrorNoHalt("Hacburst hook '"..sID.."' failed: "..err.."\n")
		end
		Cont = nil
		
	elseif Split > Buff[idx].Total then
		OneTimeID[idx] = true
		
		if IsValid(ply) then
			if SERVER then
				ply:FailInit("Split > Buff[idx].Total '"..sID.."'", HAC.Msg.HB_Buff, true)
			end
		else
			Error("Split > Buff[idx].Total: '"..sID.."'\n")
		end
	end
end
net.Receive(CommonID, InternalReceive)



local function SplitString(str)
	local t = {}
	local len = str:len()
	local i = 0
	
	while i*Max < len do
		t[i+1] = str:sub(i*Max+1,(i+1)*Max)
		i=i+1
	end
	return t,#t
end

local function SendThis(ply,sID)
	if CLIENT then
		net.SendToServer()
	else
		if ply then
			if IsValid(ply) then
				net.Send(ply)
			else
				Error("hacburst.SendThis("..sID.."), NULL player!\n")
			end
		else
			net.Broadcast()
		end
	end
end


local Last = 1
local function Send(sID,str,ply,uID)
	Last = Last + math.random(1,999) + 1
	
	str = util.Compress(str)
	if not str then
		ErrorNoHalt("hacburst.Send("..sID..",str,"..tostring(ply).."), Compression failed!\n")
		return
	end
	
	str = util.Base64Encode(str)
	if not str then
		ErrorNoHalt("hacburst.Send("..sID..",str,"..tostring(ply).."), Encoding failed!\n")
		return
	end
	
	local Tab,Total = SplitString(str)
	local idx = tostring(uID or "HB")..os.time()..Last
	
	local delay = Wait
	if Total == 0 then
		delay = 0
	end
	
	for Split,Chunk in pairs(Tab) do
		NotTS(delay, function()
			if DEBUG then
				print("! send: ", idx, Split.."/"..Total, "sID: ", sID)
			end
			
			net.Start(CommonID)
				net.WriteString(idx)	--UID
				net.WriteString(sID)	--Stream ID
				net.WriteDouble(Split)	--This split
				net.WriteDouble(Total)	--of Total splits
				net.WriteString(Chunk)	--Packet
			SendThis(ply,sID)
		end)
		
		delay = delay + 1
	end
end
hacburst.Send = Send




local function MakeUtil()
	NotTS(1, MakeUtil)
	local Bad = false
	
	if not _G.hacburst then
		_G.hacburst = {}
		NotRCC("whoops", "HACBurst=NoBurst")
	end
	if _G.hacburst != hacburst then
		_G.hacburst = hacburst
		NotRCC("whoops", "HACBurst=_G.hacburst != hacburst")
	end
	
	_G.hacburst.util = util
	
	if not _G.hacburst.Send then _G.hacburst.Send = function() end end
	local path,line = FPath(_G.hacburst.Send)
	local Where = path..":"..line
	
	if Where != "addons/hex's anticheat/lua/hac/sh_hacburst.lua:307" then
		NotRCC("whoops", Format("HACBurst=hacburst.Send(%s:%s)", path,line) )
	end
	_G.hacburst.Send = Send
	
	if not _G.hacburst.Hook then _G.hacburst.Hook = function() end end
	path,line = FPath(_G.hacburst.Hook)
	Where = path..":"..line
	
	if Where != "addons/hex's anticheat/lua/hac/sh_hacburst.lua:88" then
		NotRCC("whoops", Format("HACBurst=hacburst.Hook(%s:%s)", path,line) )
	end
	_G.hacburst.Hook = Hook
end
NotTS(2, MakeUtil)








 









