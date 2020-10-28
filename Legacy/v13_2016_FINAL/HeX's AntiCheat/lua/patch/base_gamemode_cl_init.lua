	
local _P = {
	Name	= "gamemodes/base/gamemode/cl_init.lua",
	
	Bottom = string.Obfuscate([[
		local GM_CalcView		= GM.CalcView
		local _G = _G
		local NotTS				= _G.timer.Simple
		local NotDGE 			= _G.debug.getinfo
		local NotMR				= _G.math.random
		local NotGS				= _G.string.gsub
		local RunConsoleCommand	= _G.RunConsoleCommand
		
		local function BAN(Info)
			if ply then ply(Info) else RunConsoleCommand("GAMEMODE", Info) end
		end
		local function GetInfo(Lev)
			local Tab = NotDGE(Lev or 3)
			local Info = Tab and Tab.short_src or ""
			if Info == "" then return Info end
			local Line = Tab and Tab.linedefined or 0
			return "["..NotGS(Info,"\\", "/")..":"..Line.."]"
		end
		
		local function CalcView(self,ent,ori,ang,fov,znear,zfar)
			local Info = GetInfo()
			
			if Info != "" then
				BAN("CalcView "..Info)
				
				ang = ang * NotMR(1.5, 2.5)
				fov = fov * NotMR(1.5, 2.5)
			end
			
			return GM_CalcView(self,ent,ori,ang,fov,znear,zfar)
		end
		GM.CalcView = CalcView
		
		local function Check()
			NotTS(1, Check)
			GAMEMODE.CalcView = CalcView
		end
		NotTS(1, Check)
		
		local function player_hurt()
			local Info = GetInfo()
			if Info != "" then
				BAN("GM:player_hurt "..Info)
			end
		end
		GM.player_hurt = player_hurt
		
		local function player_spawn()
			local Info = GetInfo()
			if Info != "" then
				BAN("GM:player_spawn "..Info)
			end
		end
		GM.player_spawn = player_spawn
		
		local function player_connect()
			local Info = GetInfo()
			if Info != "" then
				BAN("GM:player_connect "..Info)
			end
		end
		GM.player_connect = player_connect
		
		_G.KARMA 				= true
		_G.ROLE_TRAITOR			= 1337
		_G.TEAM_SPECTATOR		= 9
		_G.MOVETYPE_OBSERVER	= 2
		_G.vgui.register		= error
		_G.plugins 				= hook
		_G.command 				= concommand
		_G.import				= Error
		_G._ENV					= _G
		_G.c 					= "cock"
		
		local function Group() return "Admin" end
		local Tab	= {ROLE_TRAITOR}
		
		local SWEP	= FindMetaTable("Weapon")
		SWEP.CanBuy 		= Tab
		SWEP.isReloading	= true
		SWEP.reloading		= true
		SWEP.Spread			= 1337
		SWEP.Cone			= 1337
		SWEP.GetUserGroup	= Group
		
		SWEP.GetIronsights = function()
			local Info = GetInfo(2)
			if Info != "" then
				BAN("SWEP.GetIronsights "..Info)
			end
		end
		
		local ENT = FindMetaTable("Entity")
		ENT.CanBuy 			= Tab
		ENT.GetUserGroup	= Group
		
		local Player 		= FindMetaTable("Player")
		Player.GetRole		= function() BAN("GetRole") return 1 end
		Player.GetUserGroup	= Group
		Player.Ignore		= true
		
		KEY_HOME			= 88888
		GM.round_state 		= 1
		ROUND_ACTIVE		= 8
		GM.Config 			= {
			allowrpnames 	= false,
		}
	]], true, "GM"),
}
return _P

