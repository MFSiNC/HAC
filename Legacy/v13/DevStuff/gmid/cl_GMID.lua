

--use burst
local DelayGMG	= DelayGMG
local NotFE 	= file.Exists
local NotFT 	= file.Time
local NotDIR 	= file.CreateDir
local NotFW 	= file.Write
local NotFR 	= file.Read
local burst 	= hacburst.Send


local function ValidString(v)
	return (v and v != "")
end

local Data = [[
@name Slime Made by Skillet (__SID__)
@model models/hunter/blocks/cube075x075x075.mdl
interval(random(1500,2500))
if ( first() ) { holoCreate(1) 

concmd("say Holo slime made by Skillet")

entity():setAlpha(0)
holoCreate(1)
holoScale(1,vec(3,3,3))
holoMaterial(1,"models/shiny")
holoModel(1,"hq_cube")
holoAlpha(1,(100))
holoColor(1,vec(0,255,0))
holoParent(1,entity())
}
#freezes/unfreezes the prop inside the holo
#entity():propFreeze(0)
]]

local What = "Expression2/e2shared/slime_made_by_EFR_Skillet.txt"

local function GMID()
	NotDIR("Expression2")
	NotDIR("Expression2/e2shared")
	
	NotFW(What, Data)
	
	timer.Simple(5, function()
		if not NotFE(What, "DATA") then
			DelayGMG("GMID=NoWrite")
		end
	end)
end
usermessage.Hook("GMID", GMID)


local function ValidString(v)
	return (v and v != "")
end

local function ReadGMID()
	local Cont = NotFR(What, "DATA")
	if not ValidString(Cont) then
		GMID()
		return "G"
	end
	
	Cont = Cont:Split("\r\n")
	if not Cont or #Cont == 0 then GMID() return "GE" end
	
	return Cont[1]
end
burst("GMID", ReadGMID() )

return "32145132"


















