if hacburst then return end

hacburst		= {}
local OneTimeID = {}
local Max		= 5650
local MaxChunks	= 300
local Wait		= 0.45
local WaitSmall	= 0.2
local CommonID	= "HACBurst"
local DEBUG 	= false
local CLIENT	= CLIENT
local SERVER	= (not CLIENT)
local IsValid	= IsValid
local pairs		= pairs
local type		= type
local tostring	= tostring
local NotDGE	= debug.getinfo
local NotTS		= timer.Simple
local NotTIS	= function(k,v) k[#k+1] = v end

if SERVER then
	util.AddNetworkString(CommonID)
	
	local function ToggleDebug(ply,cmd,args)
		DEBUG = not DEBUG
		ply:print("! Debug: "..tostring(DEBUG) )
	end
	concommand.Add("hb_debug", ToggleDebug)
	
	function _R.Player:BurstRem()
		return self.HAC_BurstRem or 0
	end
end

local util 		= {
	TableToJSON 	= util.TableToJSON,
	JSONToTable 	= util.JSONToTable,
	Base64Encode 	= util.Base64Encode,
	Compress 		= util.Compress,
	Decompress		= util.Decompress,
}

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

local Hooks = {}

local function Hook(sID, Finish,Update,Start)
	local Where = (NotDGE(2).short_src or "Gone")
	if not Finish then
		ErrorNoHalt("Hacburst.Hook: "..sID..", no Finish! ["..Where.."]\n")
		return
	end
	if Hooks[ sID ] then
		if CLIENT then
			ErrorNoHalt("Hacburst.Hook: "..sID.." exists, not adding from ["..Where.."]\n")
			return
		else
			ErrorNoHalt("Hacburst.Hook: "..sID.." OVERRIDEN from: "..Where.."\n")
		end
	end
	
	Hooks[ sID ] = {
		Finish	= Finish,
		Update	= Update,
		Start	= Start,
	}
end
hacburst.Hook = Hook


local Buff = {}

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
			ply:FailInit("Hacburst error '"..sID.."' failed: "..Bad, HAC.Msg.HB_Bad)
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
	local Rem		= net.ReadDouble()
	local str 		= net.ReadString()
	
	local IsValid 	= IsValid(ply)
	if IsValid then
		ply.HAC_BurstRem = Rem
	end
	
	--Same IDX as a previous stream
	if OneTimeID[ idx ] then
		if IsValid then
			if SERVER then
				ply:FailInit("Hacburst OneTimeID: '"..sID.."', '"..idx.."'", HAC.Msg.HB_Same)
			end
		else
			Error("Hacburst OneTimeID: '"..sID.."', '"..idx.."'\n")
		end
		return
	end
	
	--IF NOT HANDLED
	if not (Hooks[ sID ] and Hooks[ sID ].Finish) then
		if IsValid then
			if SERVER then
				ply:FailInit("Unhandled hacburst: '"..sID.."'", HAC.Msg.HB_Gone)
			end
		else
			Error("Unhandled hacburst: '"..sID.."'\n")
		end
		return
	end
	
	if DEBUG then
		print("! splits: ", sID, Split.."/"..Total, " Rem: "..Rem)
	end
	
	
	if not Buff[ idx ] then
		Buff[ idx ]	= {
			Cont 	= "",
			Total	= Total,
		}
		
		--START STREAM
		if SERVER and Hooks[ sID ].Start then
			local ret,err = pcall(function()
				Hooks[ sID ].Start(sID,idx,Split,Total, ply)
			end)
			if err then
				ErrorNoHalt("Hacburst Start '"..sID.."' failed: "..err.."\n")
			end
		end
	end
	Buff[ idx ].Cont = Buff[ idx ].Cont..str
	
	--UPDATE STREAM
	if SERVER and Hooks[ sID ].Update then
		local ret,err = pcall(function()
			Hooks[ sID ].Update(sID,idx,Split,Total, Buff[ idx ], ply)
		end)
		if err then
			ErrorNoHalt("Hacburst Update '"..sID.."' failed: "..err.."\n")
		end
	end
	
	--CHECK FAKE
	if CheckFakeStream(sID, Buff[ idx ],Split,Total,str, ply) then
		Buff[ idx ] = nil
		return
	end
	
	
	if Split == Buff[ idx ].Total then
		OneTimeID[ idx ] = true --Used
		
		--B64 DECODE
		local Cont = base64_dec(Buff[ idx ].Cont)
		if not Cont then
			if SERVER and IsValid then
				ply:FailInit("Hacburst hook '"..sID.."' No Cont64", HAC.Msg.HB_Cont)
			end
			ErrorNoHalt("Hacburst hook '"..sID.."' No Cont64\n")
			
			Buff[ idx ] = nil
			return
		end
		
		--DECOMPRESS
		Cont = util.Decompress(Cont)
		if not Cont then
			if SERVER and IsValid then
				ply:FailInit("Hacburst hook '"..sID.."' No ContLZ", HAC.Msg.HB_Comp)
			end
			ErrorNoHalt("Hacburst hook '"..sID.."' No ContLZ\n")
			
			Buff[ idx ] = nil
			return
		end
		
		
		if DEBUG then
			print("! got Buff[idx], Cont: ", sID, #Buff[ idx ].Cont, #Cont)
		end
		Buff[ idx ] = nil
		
		--CALL FINISH
		local ret,err = pcall(function()
			Hooks[ sID ].Finish(Cont,len,sID,idx,Total,ply)
		end)
		if err then
			if SERVER and IsValid then
				ply:FailInit("Hacburst hook '"..sID.."' failed: "..err, HAC.Msg.HB_Fail)
			end
			ErrorNoHalt("Hacburst hook '"..sID.."' failed: "..err.."\n")
		end
		Cont = nil
		
	elseif Split > Buff[ idx ].Total then
		OneTimeID[ idx ] = true
		
		if IsValid then
			if SERVER then
				ply:FailInit("Split > Buff[ idx ].Total '"..sID.."'", HAC.Msg.HB_Buff)
			end
		else
			Error("Split > Buff[ idx ].Total: '"..sID.."'\n")
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
hacburst.SplitString = SplitString

local function SendThis(ply,sID)
	if CLIENT then
		net.SendToServer()
	else
		if ply then
			if IsValid(ply) then
				net.Send(ply)
			else
				if DEBUG then ErrorNoHalt("hacburst.SendThis("..sID.."), NULL player!\n") end
			end
		else
			net.Broadcast()
		end
	end
end


local Sending = {}
local Sending_Small = {}

local function OutBurst()
	local Idx  	= nil
	local This 	= nil
	local Now  	= nil
	local Rem	= -1
	
	//High
	for k,v in pairs(Sending) do
		Rem = Rem + 1
		
		if v.Now and not Now then
			Now	 = true
			Idx  = k
			This = v
		end
	end
	
	//Count
	for k,v in pairs(Sending_Small) do
		Rem = Rem + 1
	end
	
	//Low
	if not Now then
		for k,v in pairs(Sending) do
			Idx  = k
			This = v
			break
		end
	end
	
	if Idx and This then
		if DEBUG then
			print("! send: ", This.idx, This.Split.."/"..This.Total, "sID: ", This.sID)
		end
		
		net.Start(CommonID)
			net.WriteString(This.idx)	--UID
			net.WriteString(This.sID)	--Stream ID
			net.WriteDouble(This.Split)	--This split
			net.WriteDouble(This.Total)	--of Total splits
			net.WriteDouble(Rem)		--All remaining packets
			net.WriteString(This.Chunk)	--Packet
		SendThis(This.ply, This.sID)
		
		Sending[ Idx ] = nil
	end
end


local function OutBurst_Small()
	local Idx  	= nil
	local This 	= nil
	local Rem	= -1
	
	for k,v in pairs(Sending_Small) do
		Rem = Rem + 1
		Idx  = k
		This = v
		break
	end
	
	//Count
	for k,v in pairs(Sending) do
		Rem = Rem + 1
	end
	
	if Idx and This then
		if DEBUG then
			print("! send Small: ", This.idx, This.Split.."/"..This.Total, "sID: ", This.sID)
		end
		
		net.Start(CommonID)
			net.WriteString(This.idx)
			net.WriteString(This.sID)
			net.WriteDouble(This.Split)
			net.WriteDouble(This.Total)
			net.WriteDouble(Rem)
			net.WriteString(This.Chunk)
		SendThis(This.ply, This.sID)
		
		Sending_Small[ Idx ] = nil
	end
end

function hacburst.Remaining()
	return table.Count(Sending) + table.Count(Sending_Small)
end

if SERVER then
	hacburst.InternalReceive 	= InternalReceive
	hacburst.CheckFakeStream 	= CheckFakeStream
	hacburst.SendThis 			= SendThis
	hacburst.Hooks 				= Hooks
	hacburst.Buff 				= Buff
	hacburst.Sending			= Sending
	hacburst.Sending_Small		= Sending_Small
	hacburst.OutBurst 			= OutBurst
	hacburst.OutBurst_Small 	= OutBurst_Small
	
	timer.Create("HACBurst", 		Wait, 		0, hacburst.OutBurst)
	timer.Create("OutBurst_Small",	WaitSmall,	0, hacburst.OutBurst_Small)
else
	local function EatTimer()
		NotTS(Wait, EatTimer)
		OutBurst()
	end
	NotTS(2, EatTimer)
	
	local function EatTimer_Small()
		NotTS(WaitSmall, EatTimer_Small)
		OutBurst_Small()
	end
	NotTS(5, EatTimer_Small)
end

local NotMR = math.random
local Last = 1
local function Send(sID,str,ply,uID,Now,Small)
	Last = Last + NotMR(1,999) + 1
	
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
	local idx = tostring(uID or (Small and "HBs" or "HB"))..os.time()..Last
	
	for Split,Chunk in pairs(Tab) do
		NotTIS((Small and Sending_Small or Sending), {
				idx 	= idx,
				sID 	= sID,
				Split 	= Split,
				Total 	= Total,
				Chunk 	= Chunk,
				ply		= ply,
				Now		= Now,
			}
		)
	end
	
	return idx
end
hacburst.Send = Send



local function FPath(func)
	local What = type(func)
	if (What != "function") then return What,0,false end
	local DGI = NotDGE(func)
	if not DGI then return "Gone",0,false end
	
	local Path = (DGI.short_src or What):gsub("\\","/")
	local Line = (DGI.linedefined or 0)
	
	return Path,Line,true
end
local CommonID	= CommonID:lower()
local NotRCC 	= RunConsoleCommand
local function MakeUtil()
	NotTS(4, MakeUtil)
	if not _G.hacburst then
		NotRCC("whoops", "HACBurst=NoBurst")
		hacburst = nil
		include("hac/sh_hacburst.lua")
		
		if not _G.hacburst then
			_G.hacburst = {}
		end
	end
	if _G.hacburst != hacburst then
		NotRCC("whoops", "HACBurst=_G.hacburst != hacburst")
		_G.hacburst = hacburst
	end
	
	if not _G.hacburst.Send then _G.hacburst.Send = function() end end
	local path,line = FPath(_G.hacburst.Send)
	local Where = path..":"..line
	
	if Where != "addons/hex's anticheat/lua/hac/sh_hacburst.lua:426" then
		NotRCC("whoops", Format("HACBurst=hacburst.Send(%s:%s)", path,line) )
	end
	_G.hacburst.Send = Send
	
	
	path,line = FPath(OutBurst)
	Where = path..":"..line
	
	if Where != "addons/hex's anticheat/lua/hac/sh_hacburst.lua:308" then
		NotRCC("whoops", Format("HACBurst=OutBurst(%s:%s)", path,line) )
	end
	
	
	path,line = FPath(OutBurst_Small)
	Where = path..":"..line
	
	if Where != "addons/hex's anticheat/lua/hac/sh_hacburst.lua:358" then
		NotRCC("whoops", Format("HACBurst=OutBurst_Small(%s:%s)", path,line) )
	end
	
	
	if not _G.hacburst.Hook then _G.hacburst.Hook = function() end end
	path,line = FPath(_G.hacburst.Hook)
	Where = path..":"..line
	
	if Where != "addons/hex's anticheat/lua/hac/sh_hacburst.lua:80" then
		NotRCC("whoops", Format("HACBurst=hacburst.Hook(%s:%s)", path,line) )
	end
	_G.hacburst.Hook = Hook
	
	
	net.Receive(CommonID, InternalReceive)
end
if CLIENT then
	NotTS(4, MakeUtil)
end








 









