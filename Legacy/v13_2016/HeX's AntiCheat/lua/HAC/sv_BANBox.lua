/*
    HeX's AntiCheat
    Copyright (C) 2016  MFSiNC (STEAM_0:0:17809124)
	
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/


HAC.Box = {
	Port	= "COM4",
	
	Cmds	= {},
	Reason	= "",
	Format	= "",
	SteamID	= "",
	Nick	= "",
	
	PhoneUp 	= false,
	CanRing 	= false,
	LightState 	= false,
	
	Counters = {
		["Ban"] 		= 0,
		["Detection"] 	= 1,
		["FLT"] 		= 2,
		["Failure"] 	= 3,
	},
}


//Port
function HAC.Box.Open(reload)
	serial.Close()
	
	if reload then
		timer.Simple(2, function()
			serial.Open(HAC.Box.Port, 1,1)
		end)
	else
		serial.Open(HAC.Box.Port, 1,1)
	end
end
HAC.Box.Open()


//Send
function HAC.Box.OnSend(self, Idx,This)
	--print("! OnSend: ", self, This)
	serial.Write(This)
end
HAC.Box.OutBuff = selector.Init( {}, HAC.Box.OnSend)
local OutBuff = HAC.Box.OutBuff

function serial.Command(...)
	local Out = ""
	for k,v in pairs( {...} ) do
		if v == "" then continue end
		Out = Out..(k > 1 and "|" or "")..v
	end
	
	OutBuff:Add(Out.."\n")
end


//Read
HAC.Box.InBuff = ringbuffer.Init(128)
local InBuff = HAC.Box.InBuff

function HAC.Box.Think()
	//Send
	OutBuff:Select()
	
	//Read
	local Got,Size = serial.Read(1)
	if not Got then return end
	
	InBuff:Add(Got)
	
	if Got == "\n" then
		//Buffer
		local Cmd 	= ""
		for k = InBuff:Size(), 1, -1 do
			local v = InBuff.ToTable[k]
			if v == "\n" then continue end
			
			Cmd = Cmd..v
		end
		
		InBuff:Reset()
		
		
		--MsgC(HAC.YELLOW, Cmd.."\n")
		
		//Call commands
		local Tab = Cmd:Split("|")
		local This = Tab[1]
		table.remove(Tab, 1)
		
		local Func = HAC.Box.Cmds[ This ]
		if Func then
			Func( unpack(Tab) )
		else
			MsgC(HAC.YELLOW, "BANBox: No hook for '"..This.."'\n")
		end
	end
end
hook.Add("Think", "HAC.Box.Think", HAC.Box.Think)


//Add command
function HAC.Box.Hook(cmd, func)
	if HAC.Box.Cmds[ cmd ] then
		ErrorNoHalt("! HAC.Box.Hook: command '"..cmd.."' exists!\n")
		return
	end
	
	HAC.Box.Cmds[ cmd ] = func
end



//Toggle LEDs
function HAC.Box.Toggle(state)
	if state then
		timer.Create("HAC.Box.Toggle", 0.5, 0, function()
			serial.Command("l")
		end)
	else
		timer.Destroy("HAC.Box.Toggle")
		
		serial.Command("d")
	end
end

//Toggle Light
function HAC.Box.DynamicLight(state, off)
	HAC.Box.LightState = state
	serial.Command("r", "4", (state and "1" or "0") )
	
	if off then
		timer.Simple(off, function()
			if not HAC.Box.IsActive() then
				HAC.Box.DynamicLight(false)
			end
		end)
	end
end






//Ring
local Rings = {
	[1] 	= "1",
	[5] 	= "0",
	
	[9] 	= "1",
	[13] 	= "0",
}

local Last = "0"
local Upto = 1
function HAC.Box.RingTimer()
	if not HAC.Box.CanRing then --Only ever ring if hook is down
		if Last == "1" then
			Last = "0"
			
			serial.Command("r", "5", "0")
		end
		return
	end
	
	if Upto > 30 then
		Upto = 1
	end
	
	local This = Rings[ Upto ]
	if This then
		Last = This
		
		serial.Command("r", "5", This)
	end
	
	Upto = Upto + 1
end
timer.Create("HAC.Box.RingTimer", 0.1, 0, HAC.Box.RingTimer)

function HAC.Box.Ring(state)
	HAC.Box.CanRing = state
end




//Scroll
local Upto 	= 0
local Max 	= 16
local Last 	= ""
local Long 	= ""
function HAC.Box.VFDTimer()
	if Long == "" then
		if Last == "" then
			Last = "Clear"
			
			serial.Command("c")
		end
		return
	end
	
	local New = ""
	local Len = #Long
	
	if Len > 16 then
		if Upto == Len then
			Upto = 0
		end
		Upto = Upto + 1
		
		New = Long:sub(Upto)
		if #New < Max then
			New = New.." "..Long:sub(0,Upto)
		end
		New = New:Left(16)
		
	else
		New = Long
	end
	
	if New != Last then --Stop the flicker by writing only changes!
		--print(">"..New.."<")
		Last = New
		
		serial.Command("v", New, "1")
		--serial.Command("v", New, (Len <= 16 and "1" or "") )
	end
end
timer.Create("VFD", 1, 0, HAC.Box.VFDTimer) --0.09

function HAC.Box.Write(str)
	Upto 	= 0
	Max 	= 16
	Last 	= ""
	Long 	= str
end

function HAC.Box.Clear(wait)
	timer.Simple( (wait or 0), function()
		serial.Command("c")
	end)
end



local function ResetAll(do_clear)
	HAC.Box.Ring(false)
	
	if do_clear then
		HAC.Box.Toggle(false)
		HAC.Box.DynamicLight(false)
		
		HAC.Box.Reason	= ""
		HAC.Box.Format	= ""
		HAC.Box.SteamID	= ""
		HAC.Box.Nick	= ""
		
		HAC.Box.Write("===== RESET ====")
		HAC.Box.Clear(0.5)
		
		//Stop clicking
		HAC.Box.Pulse:Clear()
	end
end
HAC.Box.ResetAll = ResetAll

local function StopPhoneTest()
	if HAC.Box.InPhoneTest then
		HAC.Box.InPhoneTest = false
		
		HAC.Box.Write("- PHONE HANGUP -")
		
		HAC.Box.Toggle(false)
		timer.Simple(2, function()
			ResetAll(true)
		end)
	end
end

//Hook
HAC.Box.Hook("h", function(v)
	HAC.Box.PhoneUp = tobool(v)
	
	//Lift
	if tonumber(v) == 1 then
		ResetAll()
		
		if HAC.Box.InPhoneTest then
			HAC.Box.Write("+ PHONE LIFTED +")
		end
	else
		//Down
		StopPhoneTest()
	end
end)

function HAC.Box.QurryHook()
	serial.Command("q")
end
timer.Simple(4, HAC.Box.QurryHook)



//Buttons

function HAC.Box.IsActive()
	return ValidString(HAC.Box.Reason)
end

local function InfoIfActive(str)
	if not HAC.Box.IsActive() then
		HAC.Box.Write(str)
		HAC.Box.Clear(0.5)
	end
end

HAC.Box.Hook("b", function(v)
	v = tonumber(v)
	
	//- button
	if v == 0 then
		if ValidString(HAC.Box.Reason) then HAC.Box.Write( HAC.Box.Reason ) end
		InfoIfActive("Reason")
	end
	//Reset button
	if v == 1 then
		if ValidString(HAC.Box.Nick) then HAC.Box.Write( HAC.Box.Nick ) end
		InfoIfActive("Nick")
	end
	//Continue button
	if v == 2 then
		if ValidString(HAC.Box.SteamID) then HAC.Box.Write( HAC.Box.SteamID ) end
		InfoIfActive("SteamID")
	end
	//Enter button
	if v == 3 then
		if ValidString(HAC.Box.Format) then HAC.Box.Write( HAC.Box.Format ) end
		InfoIfActive("Formatted Reason")
	end
	
	//Paper size
	if v == 4 then
		HAC.Box.InPhoneTest = true
		
		HAC.Box.Write("++ PHONE TEST ++")
		HAC.Box.Ring(true)
		HAC.Box.Toggle(true)
		HAC.Box.DynamicLight(true)
	end
	
	//LED flashing buttons, stop ring
	if v == 5 or v == 6 then
		HAC.Box.Toggle(false)
		
		if v == 5 then
			if not HAC.Box.IsActive() then
				HAC.Box.DynamicLight( not HAC.Box.LightState )
				
				InfoIfActive(HAC.Box.LightState and "+  LIGHT ON  +" or "-  LIGHT OFF  -")
				return
			end
		end
		
		ResetAll()
		StopPhoneTest()
		InfoIfActive("Cancel alert")
	end
	
	//Shift button
	if v == 7 then
		ResetAll(true)
	end
end)




//Pulse
function HAC.Box.OnPulse(self, Idx,This)
	--print("! pulse: ", self, This, HAC.Box.Counters[ This ] )
	
	serial.Command("p", HAC.Box.Counters[ This ] )
end
HAC.Box.Pulse = selector.Init( {}, HAC.Box.OnPulse)

//Timer
function HAC.Box.PulseTimer()
	HAC.Box.Pulse:Select()
end
timer.Create("HAC.Box.PulseTimer", 1 / 5, 0, HAC.Box.PulseTimer)

//Add
function HAC.Box.Add(typ, now)
	if not HAC.Box.Counters[ typ ] then
		return debug.ErrorNoHalt("HAC.Box.Pulse, no such counter '"..typ.."'")
	end
	
	timer.Simple( (now and 0 or 8), function()
		HAC.Box.Pulse:Add(typ)
	end)
end

//Chatfilter
function HAC.Box.ChatFilter(self)
	HAC.Box.Add("FLT", true)
end
hook.Add("HSPChatFilterEvent", "HAC.Box.ChatFilter", HAC.Box.ChatFilter)




local function GoodTime()
	return math.Within( tonumber( os.date("%H") ), 1, 23)
end

//Starts here
function _R.Player:WriteVFD(str)
	HAC.Box.Reason	= str:VerySafe()
	HAC.Box.SteamID	= self:SteamID()
	HAC.Box.Nick	= self:Nick()
	
	HAC.Box.Format = Format("%s (%s) - %s", HAC.Box.Nick, HAC.Box.SteamID, HAC.Box.Reason)
	HAC.Box.Write( HAC.Box.Format )
	
	if GoodTime() and not HAC.Box.PhoneUp then
		if not HAC.Silent:GetBool() then
			HAC.Box.Ring(true)
		end
		
		HAC.Box.DynamicLight(true)
	end
	HAC.Box.Toggle(true)
	
	//Stop ringing after 10s
	timer.Simple(10, function()
		HAC.Box.Ring(false)
	end)
	
	//Stop flashing
	timer.Simple(160, function()
		HAC.Box.DynamicLight(false)
	end)
end


//Echo
local IsThere = false
HAC.Box.Hook("e", function(v)
	IsThere = true
	
	if v == "Ping" then
		return
	elseif v == "?" then
		v = " Ready "
	end
	MsgC(HAC.YELLOW, "BANBox >"..v.."<\n\n")
end)

//Is there?
function HAC.Box.CheckIfThere()
	IsThere = false
	
	serial.Command("e", "Ping")
	
	timer.Simple(3, function()
		if not IsThere then
			ErrorNoHalt("[BANBox] Reloading @ "..HAC.Date().."\n\n")
			HAC.Box.Reload()
		end
	end)
end
timer.Create("HAC.Box.CheckIfThere", 5 * 60, 0, HAC.Box.CheckIfThere)






timer.Simple(1, function()
	if not serial.IsValid() then
		ErrorNoHalt("sv_BanBox.lua, Can't open serial port!\n")
		return
	end
	
	serial.Command("e", "?")
end)


function HAC.Box.ShutDown()
	serial.Close()
end
hook.Add("ShutDown", "HAC.Box.ShutDown", HAC.Box.ShutDown)






function HAC.Box.Reload(self)
	if self then
		if not self:HAC_IsHeX() then return end
		print("! Reloading banbox")
	end
	
	HAC.Box.Open(true)
end
concommand.Add("bb_reload", HAC.Box.Reload)





