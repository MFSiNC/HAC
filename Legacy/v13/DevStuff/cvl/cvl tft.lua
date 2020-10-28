

function string.NoQuotes(str)
	str = str:Trim()
	if str:Check('"') then
		str = str:sub(2)
	end
	
	if str:EndsWith('"') then
		str = str:sub(0,-2)
	end
	return str
end

local AllFlags = {
	["ARCHIVE"] = 1, ["SPONLY"] = 1, ["GAMEDLL"] = 1, ["CHEAT"] = 1, ["USERINFO"] = 1, ["NOTIFY"] = 1,
	["PROTECTED"] = 1, ["PRINTABLEONLY"] = 1, ["UNLOGGED"] = 1, ["NEVER_AS_STRING"] = 1,
	["REPLICATED"] = 1, ["DEMO"] = 1, ["DONTRECORD"] = 1, ["SERVER_CAN_EXECUTE"] = 1,
	["CLIENTCMD_CAN_EXECUTE"] = 1, ["CLIENTDLL"] = 1,
}


------------------------------
local Cont = file.Read("ug_cinema_config.txt", "DATA") --temp
------------------------------

Cont = Cont:gsub("\r\n", "\n")

local Cmds 	= {}
local CVars = {}

for Num,Line in pairs( Cont:Split("\n") ) do
	if Num == 1 then continue end --Skip first line
	
	local This = Line:Split(",")
	local Cmd 	= This[1]
	local Val 	= This[2]
	
	if not (Cmd and Val) then continue end
	Cmd = Cmd:NoQuotes()
	Val = Val:NoQuotes()
	
	if Val == "cmd" then
		//Get Help
		local Help = ""
		for i=3, #This do
			local Temp = This[i]
			
			if ValidString(Temp) then
				Help = Help.." "..Temp:NoQuotes()..","
			end
		end
		if Help != "" then
			Help = Help:Trim():Trim(",")
		end
		
		
		//Add to table
		if Cmds[ Cmd ] then
			ErrorNoHalt("! Cmds[ "..Cmd.." ] exists!\n")
		else
			Cmds[ Cmd ] = {
				Val,
				Help,
			}
		end
	else
		Val = Val:gsub(" ", "") --Remove useless spaces from value
		
		//Get Flags, Help
		local Flags = ""
		local Help	= ""
		for i=3, #This do
			local Temp = This[i]
			
			if ValidString(Temp) then
				Temp = Temp:NoQuotes()
				
				if AllFlags[ Temp ] then
					Flags = Flags..Temp..","
				else
					Help = Help.." "..Temp..","
				end
			end
		end
		if Flags != "" then	Flags = Flags:Trim():Trim(",")	end
		if Help != "" then	Help = Help:Trim():Trim(",")	end
		
		//Add to table
		if CVars[ Cmd ] then
			ErrorNoHalt("! CVars[ "..Cmd.." ] exists!\n")
		else
			CVars[ Cmd ] = {
				V = Val,
				F = Flags,
				H = Help,
			}
		end
	end
end

//Check ammount
local Count = table.Count(Cmds) --Cmds
if Count < 200 then
	--self:FailInit("CVL_LowCmds="..Count, HAC.Msg.CVL_LowCmds)
end
Count = table.Count(CVars)		--CVars
if Count < 200 then
	--self:FailInit("CVL_LowCVars="..Count, HAC.Msg.CVL_LowCVars)
end



-----------------------------------------------------------------
HAC.SERVER.CVL_Ignore = {
	["_restart"] = "Shutdown and restart the engine.",
	["adsp_debug"] = {V = "0", F = "ARCHIVE", H = ""},
	["adsp_alley_min"] = {V = "1337", F = "", H = ""},
}


HAC.SERVER.CVL_Cmd = {

}

HAC.SERVER.CVL_CVar = {

}

-----------------------------------------------------------------


//Cmds
for Cmd,Tab in pairs(Cmds) do
	local Val,Help = Tab[1], Tab[2]
	
	//Ignore
	if HAC.SERVER.CVL_Ignore[ Cmd ] then
		Cmds[ Cmd ] = nil
		continue
	end
	local ExHelp = HAC.SERVER.CVL_Cmd[ Cmd ]
	
	//Unknown/new
	if not ExHelp then
		local Log = Format('["%s"] = "%s",', Cmd, (Help or "H") )
		
		--Log, cvl_cc_%s, also LogOnly
		print("! unknown: ", Log)
		Cmds[ Cmd ] = nil
		continue
	end
	
	//Value, should always be "cmd"
	if Val != "cmd" then
		print("! Not Cmd: ", Cmd, Val)
	end
	
	//Help
	if ValidString(Help) and (ExHelp and ExHelp != "H") and ExHelp != Help then
		print("! Help: ", Cmd, ExHelp, Help)
	end
end


//CVars
for Cmd,Tab in pairs(CVars) do
	local Val,Flags,Help = Tab.V, Tab.F, Tab.H
	
	if HAC.SERVER.CVL_Ignore[ Cmd ] then
		CVars[ Cmd ] = nil
		continue
	end
	local ExTab = HAC.SERVER.CVL_CVar[ Cmd ]
	
	//Unknown/new
	if not ExTab then
		local Log = Format('["%s"] = {V = "%s", F = "%s", H = "%s"},', Cmd, Val, (Flags or "F"), (Help or "H") )
		
		--Log, cvl_cv_%s, also LogOnly
		print("! cv unknown: ", Log)
		CVars[ Cmd ] = nil
		continue
	end
	
	//Value
	if Val != ExTab.V then
		print("! cv Val mismatch: ", Cmd, Val, ExTab.V)
	end
	
	//Flags
	if ValidString(Flags) and (ExTab.F and ExTab.F != "F") and Flags != ExTab.F then
		print("! cv Flags: ", Cmd, ExTab.F, Flags)
	end
	
	//Help
	if ValidString(Help) and (ExTab.H and ExTab.H != "H") and ExTab.H != Help then
		print("! cv Help: ", Cmd, ExTab.H, Help)
	end
	
end



--[[
//Final check, Cmds
for Cmd,Tab in pairs(Cmds) do
	--HAC.SERVER.Black_Keys
end

//Final check, CVars
for Cmd,Tab in pairs(CVars) do
	
end
]]














