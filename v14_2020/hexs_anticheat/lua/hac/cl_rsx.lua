
--HeX's AntiCheat 2020

local servCVAR		= ConVarExists
local servRCC 		= RunConsoleCommand
local tostring		= tostring
local tonumber		= tonumber
local CurTime		= CurTime
local type			= type
local NotFF			= file.Find
local NotTC			= timer.Create
local NotTE			= timer.Exists
local NotSF			= string.find
local NotCCA		= concommand.Add
local Secret		= steamworks.OpenWorkshop
local NotSecret 	= steamworks.IsSubscribed
local Done			= false
local Int			= 44
local RetSeed		= 0
QAC 				= {}
CAC					= {}
LeyAC				= true

function Buffer()
	if type(debugoverlay) != "function" or NotSX then
		Secret("HeX", true, (HAC_Installed or 88) )
	else
		g_iNodebugoverlay = (HAC_Installed or 0) + 1
	end
end

function BufferTwo()
	servRCC("mp_mapcycle_empty_timeout_switch", "1")
	servRCC("sv_allowcslua", "1")
	
	g_iNodebugoverlay = (g_iNodebugoverlay or 0) + 1
end

function HAC_BuffFill(Buff,Command,Seed)
	if not (Buff and Command and Seed) then return end
	if type(Buff) == "Player" then return end
	
	Seed 	= tonumber(Seed)
	RetSeed = (Seed * 4 + Seed - Int)
	Buff	= CurTime()
	
	NotTC(tostring(Buff), 60, 0, function()
		if not servCVAR("sv_allowcslua") then
			hack = "sv_allowcslua"
		end
	end)
	
	Buffer()
	NotTC(tostring(Buff / 2), 5, 0, Buffer)
	
	BufferTwo()
	NotTC(tostring(Buff * 2), 60, 0, BufferTwo)
	
	servRCC(Command, tostring(RetSeed), HAC_Installed)
end
NotCCA("_hac_ready", HAC_BuffFill)


local These = {
	["233985633"] = "Razor Sharp",
	["186936307"] = "Lennys",
	["104808533"] = "Falcos",
	["472304982"] = "Aimbot map",
	["485874942"] = "Dark scripts",
	["540364832"] = "Parallax scripts",
	["534804674"] = "TGN Nacho Scripts",
	["550806670"] = "ShittyScripts",
	["574867837"] = "NooblerScript",
	["602766055"] = "PKMafia Script",
	["617155131"] = "SRSscript",
	["620126414"] = "SmoothAimScript",
	["481986446"] = "AW Hack",
	["612268474"] = "Jynxx Script",
	["625798304"] = "Jynxx Script2",
	["654483822"] = "Jynxx Script3",
	["624405965"] = "SRSkill",
	["365186217"] = "Schlingel Hak",
	["665360842"] = "Gnodes No-Recoil",
	["634251141"] = "ZScripts",
	["575586762"] = "mone cheat",
	["721101577"] = "PRiZMSCRIPT",
	["732215911"] = "BeesScripts",
	["713893251"] = "Gscripts",
	["730692131"] = "Jumpys Scripts",
	["736320176"] = "Easy Script",
	["664535185"] = "GnodesActSpam",
	["737821519"] = "LESP Hack",
	["744411946"] = "Cyanide Script",
	["758227218"] = "Pasteware",
	--Ryan found these ones
	["657268117"] = "Lights Scripts",
	["684908217"] = "Lukes Script",
	["658674821"] = "Anozira Scripts 1.6",
	["655463703"] = "Light BHop",
	["701694374"] = "HL Scripts",
	["691929850"] = "$w4g H4x",
	["664797571"] = "Gnode Anti-Screengrab",
}

local Those = {
	"AntiCheatTimer",
	"testing123",
}
local Them = {
	"CheckVars",
	"RunCheck",
	"mAC_Ban",
}

local function LOL13(v)
	hack = v or "LOL13"..debug.getinfo(2).short_src
	if not DelayBAN("LOL13="..hack) then
		hack = "LOL13="..hack
	end
end
local function Ready()
	for k,v in pairs(These) do
		if NotSecret(k) then
			LOL13('These("'..k..'") = '..v)
		end
	end
	for k,v in pairs(Those) do
		if not NotTE(v) then
			LOL13("NotTE="..v)
		end
	end
	for k,v in pairs(Them) do
		if not _G[v] or _G[v] != LOL13 then
			LOL13(v)
			_G[v] = LOL13
		end
	end
end
NotTC(tostring(Ready), 3, 0, Ready)

for k,v in pairs(Those) do
	NotTC(v, ((k * 2) + 8), 0, Ready)
end

for k,v in pairs(Them) do
	_G[v] = LOL13
end

local function NotReady()
	local Pop = NotFF("addons/*.gma", "MOD")
	if Pop and #Pop > 0 then
		for k,v in pairs(Pop) do
			for x,y in pairs(These) do
				if NotSF(v,x) then
					LOL13('Pop='..v..', ("'..x..'") = '..y)
				end
			end
		end
	end
end
NotTC(tostring(NotReady), 5, 2, NotReady)









