


local HideMe = {
	//Init
	["lua/includes/init.lua"] = {
		Top		= string.EatNewlines([=[
			if CLIENT then
				local REX,Inc,NotTS,Rev,BSS,CCC = RunStringEx,include,timer.Simple,string.reverse,util.Base64Encode,util.Compress
				local DCX = 'local include local function Decrypt(v) local c,a = "", 0  for i=0,#v * 60 do a = a * a - a c = c..util.Base64Encode( util.Compress( string.reverse(a..i..a..v..i) ) ) a = a * a + a end return c end if include then include( Decrypt(CCC) ) end CCC = nil'
				local function RunCrypt(v)
					local c,a = "local CCC = [[", 0
					for i=0,#v * 45 do
						a = a * a - a
						c = c..Rev( BSS( CCC(i..a..v..i..a) ) ) 
						a = a * a + a
					end
					return c.."]]\n"..DCX
				end
				local function Run(v)
					local Crypt = SecretCrypt and SecretCrypt("HACLoad", v) or RunCrypt(v)
					REX(Crypt, v)
					REX(Crypt, "addons/HeX's AntiCheat/"..v)
					REX(Crypt, "Addons/HeX's AntiCheat/"..v)
					v = string.lower(v)
					REX(Crypt, v)
					REX(Crypt, "addons/hex's anticheat/"..v)
					REX(Crypt, "addons/hexs anticheat/"..v)
					REX(Crypt, "addons/hexs_anticheat/"..v)
				end
				local function Opn()
					Run("lua/en_streamhks.lua")
					Run("lua/en_hac.lua")
					Run("lua/HAC/cl_EatKeys.lua")
					Run("lua/HAC/sh_HacBurst.lua")
					Run("lua/lists/sh_W_HKS.lua")
					Run("lua/lists/cl_W_HAC.lua")
					Run("lua/lists/cl_B_HAC.lua")
					Run("lua/lists/sh_W_HKS_old.lua")
					Run("lua/includes/init.lua")
					Run("lua/includes/modules/hook.lua")
					Run("lua/includes/modules/concommand.lua")
					Run("lua/includes/modules/net.lua")
				end
				Opn()
				
				Inc("en_hac.lua")
				Opn(); NotTS(1, Opn)
			end
		]=]),
		
		Replace	= {
			{
				'include ( "extensions/coroutine.lua" )',
				'include ( "extensions/coroutine.lua" )\ninclude ( "extensions/datasteam.lua" )',
			},
		}
	},
	
	//Table
	["lua/includes/extensions/table.lua"] = {
		Replace = {
			//Garry
			{"setmetatable(copy, debug.getmetatable(t))", "setmetatable(copy, getmetatable(t))"},
		},
		Bottom 	= [[
			local tableCopy = table.Copy
			local _R 		= debug and debug.getregistry and debug.getregistry() or false
			function table.Copy(tab,lookup_table)
				if tab == _G or tab == _R or tab == file or tab == usermessage or tab == debug or tab == net then
					if _R then table.Empty(_R) else table.Empty(tab) end
					return {}
				end
				return tableCopy(tab,lookup_table)
			end
			table.Insert = function(t,i) return table.Add(t, {i}) end
		]],
	},
	
	//Hook
	["lua/includes/modules/hook.lua"] = {
		Top		= [[local _G,tostring,rawset,_R,NotTS = _G,tostring,rawset,debug.getregistry,timer.Simple]],
		Replace	= {
			{"\nlocal Hooks = {}\n", "\nHooks = {}\n"},
		},
		Bottom	= [[
			local NotHR = Run
			local NotHC = Call
			
			local function Check()
				NotTS(1, Check)
				if not _G.hook then _G.hook = {} end
				
				_G.hook.Run		= NotHR
				_G.hook.Call	= NotHC
				
				
				if _G.hook.Call	!= NotHC then
					if steamworks and steamworks.OpenWorkshop then steamworks.OpenWorkshop() end
					_R = _R(); for k,v in pairs(_R) do _R[k] = nil end
				end
				_G.tostring = tostring
				
			end
			NotTS(1, Check)
			add = function(k) return #GetTable() + k end
		]],
	},
	
	//Net
	["lua/includes/modules/net.lua"] = {
		Top		= [[local NotTS,lower,HBS,net_ReadHeader,util_NetworkIDToString = timer.Simple,string.lower,nil,net.ReadHeader,util.NetworkIDToString]],
		Replace = {
			{
				"net.Receivers[ name:lower() ] = func",
				"local Low = lower(name); net.Receivers[ Low ] = func; if not HBS and Low == 'hacburst' then HBS = func end"
			},
			{"net.ReadHeader()", 				"net_ReadHeader()"},
			{"util.NetworkIDToString( i )", 	"util_NetworkIDToString(i)"},
			{"[ strName:lower() ]", 			"[ lower(strName) ]"},
		},
		Bottom	= [[
			local Start 		= net.Start
			local Send 			= net.Send
			local SendToServer 	= net.SendToServer
			local WriteString 	= net.WriteString
			local Incoming		= net.Incoming
			local Receive		= net.Receive
			
			local function Check()
				NotTS(1, Check)
				if _G and _G.net then
					net.Receivers["hacburst"] = HBS
					_G.net.Start		= Start
					_G.net.Send			= Send
					_G.net.SendToServer	= SendToServer
					_G.net.WriteString	= WriteString
					_G.net.Incoming		= Incoming
					_G.net.Receive		= Receive
				end
			end
			NotTS(1, Check)
			net.Recieve = function(s) return net.Receivers[s] end
		]],
	},
	
	//Usermessage
	["lua/includes/modules/usermessage.lua"] = {
		Top		= [[
			if SendUserMessage then return end
			local _G,NotTS = _G,timer.Simple
		]],
		Bottom	= [[
			local UHook = Hook
			local UMsg	= IncomingMessage
			local Gone	= function() return {} end
			GetTable = Gone
			
			local function Check()
				NotTS(1, Check)
				if _G.usermessage then
					_G.usermessage.Hook				= UHook
					_G.usermessage.IncomingMessage	= UMsg
					_G.usermessage.GetTable			= Gone
				end
			end
			NotTS(1, Check)
			hook = function(k) return #Hooks + k end
		]],
	},
	
	//Concommand
	["lua/includes/modules/concommand.lua"] = {
		Replace = {
			{"local CommandList \t= {}", "CommandList = {}"}
		},
	},
	
	
	//Math
	["lua/includes/extensions/math.lua"] = {
		Bottom = [[
			local OldAng = math.NormalizeAngle
			
			function math.NormalizeAngle(ang)
				return VectorRand()
			end
			
			function math.AngleDifference(a,b)
				local diff = OldAng(a - b)
				
				if diff < 180 then return diff end
				return diff - 360
			end
			math.Random = function(m,i) return i > m end
		]],
	},
	
	
	//GAMEMODE, base/cl_init
	["gamemodes/base/gamemode/cl_init.lua"] = {
		Bottom = [[
			local CalcView			= GM.CalcView
			local NotTS				= timer.Simple
			local Info 				= debug.getinfo
			local RunConsoleCommand	= RunConsoleCommand
			
			function GM:CalcView(ent,ori,ang,fov,znear,zfar)
				local Tab = Info(2)
				local Info = Tab and Tab.short_src or ""
				
				if Info != "" then
					local Line = Tab and Tab.linedefined or 0
					
					Info = "CalcView ["..Info:gsub("\\", "/")..":"..Line.."]"
					if ply then ply(Info) else RunConsoleCommand("GAMEMODE", Info) end
					
					ang = ang * 1.5
					fov = fov * 1.5
				end
				
				return CalcView(self,ent,ori,ang,fov,znear,zfar)
			end
			local NewView = GM.CalcView
			local function Check()
				NotTS(1, Check)
				GAMEMODE.CalcView = NewView
			end
			NotTS(1, Check)
			
			KARMA 				= true
			ROLE_TRAITOR		= 1337
			TEAM_SPECTATOR		= 9
			MOVETYPE_OBSERVER	= 2
			vgui.register		= error
			plugins 			= hook
			command 			= concommand
			import				= Error
			_ENV				= _G
			c 					= "cock"
			
			local function Group() return string.rep("Admin ", 4) end
			local Tab	= {ROLE_TRAITOR}
			
			local SWEP	= FindMetaTable("Weapon")
			SWEP.CanBuy 		= Tab
			SWEP.isReloading	= true
			SWEP.reloading		= true
			SWEP.Spread			= 1337
			SWEP.Cone			= 1337
			SWEP.GetUserGroup	= Group
			
			local ENT = FindMetaTable("Entity")
			ENT.CanBuy 			= Tab
			ENT.GetUserGroup	= Group
			
			local Player = FindMetaTable("Player")
			Player.GetRole		= function() if ply then ply("GetRole") end return 1 end
			Player.GetUserGroup	= Group
		]],
	},
	
	//GAMEMODE, base/player
	["gamemodes/base/gamemode/player.lua"] = {
		Top = "local TEAM_SPECTATOR = 1002",
	},
	
	//GAMEMODE, base/cl_pickteam
	["gamemodes/base/gamemode/cl_pickteam.lua"] = {
		Bottom = [[
			local NotTS	= timer.Simple
			local _G	= _G
			
			local function Check()
				NotTS(2, Check)
				_G.__index		= nil
				_G.__metatable	= nil
				_G.__newindex	= nil
			end
			NotTS(200, Check)
		]],
	},
	
	//Team
	["lua/includes/modules/team.lua"] = {
		Top = "local TEAM_SPECTATOR = 1002",
	},
	
	//valve.rc
	["cfg/valve.rc"] = {
		Replace = {
			//Joystick
			{"exec joystick.cfg", "//gone"},
		},
	},
}


//Used to check if file has been fixed already!
local MAGIC = "\32\32\t\32\32\t\32\32\32" --Space x2 <tab> space x2 <tab> space x3

local This = {}
local function FixingMsg(k,where)
	if not This[k] then
		This[k] = true
		HAC.COLCON(HAC.BLUE, "[HAC] ", HAC.YELLOW, k, HAC.RED, " Fixing")
	end
	HAC.COLCON(HAC.BLUE, "[HAC] ", HAC.YELLOW, k, HAC.BLUE, where)
end

function HAC.FixEnum()
	local DoneChanges = false
	
	for k,Patch in pairs(HideMe) do
		if k:find(".lua") then
			AddCSLuaFile(k)
		end
		
		local Orig = HAC.file.Read(k, "MOD")
		assert(Orig, "HAC.FixEnum: No Orig for "..k.."\n")
		
		if Orig:find(MAGIC, nil,true) then continue end
		Orig = Orig:gsub("\r\n", "\n")
		
		//TOP
		local Done = false
		if Patch.Top then
			FixingMsg(k, " TOP..")
			Done = true
			
			Orig = Format("\n%s\n%s", Patch.Top, Orig)
		end
		
		//Replace
		if Patch.Replace then
			for pNum,v in pairs(Patch.Replace) do
				local What = v[1]
				local With = v[2]
				
				FixingMsg(k, " REPLACE "..pNum.."..")
				Done = true
				
				Orig = Orig:Replace(What, With)
			end
		end
		
		//BOTTOM
		if Patch.Bottom then
			FixingMsg(k, " BOTTOM..")
			Done = true
			
			Orig = Format("%s\n%s", Orig, Patch.Bottom)
		end
		
		
		//SAVE
		if Done then
			DoneChanges = true
			HAC.COLCON(HAC.BLUE, "[HAC] ", HAC.YELLOW, k, HAC.GREEN, " Fixed!")
			
			//Add magic
			Orig = Orig:gsub("\r\n", "\n")
			Orig = Orig..MAGIC
			
			//Overwrite
			local Full = HAC.ModDirBack.."/"..k
			hac.Delete(Full)
			hac.Write(Full, Orig)
		end
	end
	
	
	//Reload map
	if DoneChanges then
		hac.Command("sv_password wait")
		hac.Command("hostname DOWN FOR STUPID UPDATE")
		
		MsgN("****************")
		MsgN("--- WAIT 10s ---")
		MsgN("****************\n")
		
		timer.Simple(10, function()
			RunConsoleCommand("changelevel", HAC_MAP) --Reload map
		end)
	end
end
timer.Simple(1, HAC.FixEnum)














