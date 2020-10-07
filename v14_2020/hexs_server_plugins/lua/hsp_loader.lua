
----------------------------------------
--         2014-07-12 20:32:45          --
------------------------------------------
--[[

	=== HeX's Server Plugins ===

	HSP_Loader.lua

	Main loader for the HSP plugin framework

]]



Msg("\n")

Msg("///////////////////////////////////////\n")

Msg("//    HeX's Server Plugins Loader    //\n")

Msg("///////////////////////////////////////\n")



HSP	= {

	Loaded			= false,

	ReallyLoaded	= false,

	Plugins			= {},

	TotalPlugins	= 0,

	TotalBlocked	= 0,

}



include("HSP_Shared.lua")



if SERVER then

	AddCSLuaFile("autorun/HSP_Autorun.lua")

	AddCSLuaFile("HSP_Shared.lua")

	

	MsgN("   Loading modules..")

	include("HSP_Modules.lua")

	

	MsgN("   Loading server..")

	include("HSP_Server.lua")

	

	MsgN("   Loading plugins..")

	include("HSP_Plugins.lua")

	

	local Server = HSP.INI and HSP.INI.Settings.Name

	if Server then

		MsgN("   Loaded > "..Server.." < config!")

	else

		MsgN("   Loaded > **NO_CFG** < config..")

	end

end







PLUGIN_ERR	= 404



PLUGIN_B_SV = 1

PLUGIN_B_SH	= 2

PLUGIN_B_CL	= 3



PLUGIN_SV 	= 4

PLUGIN_SH	= 5

PLUGIN_CL	= 6



local SType = {

	["sv_b"]	= PLUGIN_B_SV,

	["sh_b"]	= PLUGIN_B_SH,

	["cl_b"]	= PLUGIN_B_CL,

	

	["sv_"]		= PLUGIN_SV,

	["sh_"]		= PLUGIN_SH,

	["cl_"]		= PLUGIN_CL,

}

local CLType = {

	[PLUGIN_B_SH]	= true,

	[PLUGIN_B_CL] 	= true,

	

	[PLUGIN_SH] 	= true,

	[PLUGIN_CL]		= true,

}

local BaseType = {

	[PLUGIN_B_SV] 	= true,

	[PLUGIN_B_SH] 	= true,

	[PLUGIN_B_CL] 	= true,

}



function HSP.GetPluginType(what)

	what = what:lower()

	

	local typ2		= SType[ what:sub(1,4) ] or PLUGIN_ERR

	local isBase	= BaseType[typ2]

	

	local typ		= SType[ what:sub(1,3) ] or PLUGIN_ERR

	local IsCL		= CLType[typ]

	

	return typ,isBase,IsCL

end



function HSP.LookupPlugin(what)

	what = what:lower()

	

	for k,v in pairs(HSP.Plugins) do

		if v.what:lower() == what then

			return v

		end

	end

	return false

end







function HSP.HandleInclude(where,v)

	local typ,isBase,IsCL = HSP.GetPluginType(v)

	local path = where.."/"..v

	

	if SERVER then

		//Blocked

		--[[if HSP.ShouldBlockPlugin(v) then

			HSP.TotalBlocked = HSP.TotalBlocked + 1

			return

		end]]

		

		//Add

		if not HSP.Loaded then

			table.insert(HSP.Plugins,

				{

					where	= where,

					what	= v,

					typ		= typ,

					isBase	= isBase,

					IsCL	= IsCL,

					path	= path

				}

			)

			HSP.TotalPlugins = HSP.TotalPlugins + 1

		end

		

		//Dropbox

		--[[if HSP.ExecRemotePlugin(path) then

			return

		end]]

		

		

		//Client

		if IsCL and not HSP.Loaded then

			--print("! AddCSLuaFile: ", path)

			AddCSLuaFile(path)

		end

		

		//Server

		if (typ != PLUGIN_CL and typ != PLUGIN_B_CL) then

			--print("! sv-sh include: ", path)

			include(path)

		end

	end

	

	//Shared

	if CLIENT and IsCL then

		--print("! cl include: ", path)

		include(path)

	end

end







for k,v in pairs( file.Find("HSP/base/*.lua", "LUA") ) do --Main base

	if not ValidString(v) then continue end

	local typ,isBase,IsCL = HSP.GetPluginType(v)

	

	if isBase then

		HSP.HandleInclude("HSP/base",v)

	end

end





local AllFiles,AllDirs = file.Find("HSP/*", "LUA")



for k,dir in pairs(AllDirs) do --New folder-based plugins

	if ValidString(dir) and (dir != "." and dir != ".." and dir != "base") then

		local where = "HSP/"..dir

		local files,dirs = file.Find(where.."/*.lua", "LUA")

		

		//Base

		for k,v in pairs(files) do

			if ValidString(v) then

				local typ,isBase,IsCL = HSP.GetPluginType(v)

				

				if isBase then

					HSP.HandleInclude(where,v)

				end

			end

		end

		

		//Main

		for k,v in pairs(files) do

			if ValidString(v) then

				local typ,isBase,IsCL = HSP.GetPluginType(v)

				

				if not isBase then

					HSP.HandleInclude(where,v)

				end

			end

		end

	end

end









HSP.Loaded = true

timer.Simple(1, function()

	HSP.ReallyLoaded = true

end)



if SERVER then

	Msg("///////////////////////////////////////\n")

	if HSP.TotalBlocked > 0 then

		if HSP.TotalBlocked < 10 then

			HSP.TotalBlocked = "0"..HSP.TotalBlocked

		end

		Msg("//      "..HSP.TotalPlugins.." plugins, "..HSP.TotalBlocked.." Blcoked      //\n")

	else

		Msg("//            "..HSP.TotalPlugins.." plugins            //\n")

	end

	Msg("///////////////////////////////////////\n\n")

else

	Msg("//         All plugins loaded        //\n")

	Msg("///////////////////////////////////////\n\n")

end









