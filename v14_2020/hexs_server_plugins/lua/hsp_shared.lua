
----------------------------------------
--         2014-07-12 20:32:45          --
------------------------------------------
--[[

	=== HeX's Server Plugins ===

	HSP_Shared.lua

	Shared resources

]]





HSP.RED2		= Color(255,0,0)		--More red

HSP.RED			= Color(255,0,11)		--Red

HSP.KIRED 		= Color(255,80,0)		--Killicon Red



HSP.GREEN2		= Color(0,255,0)		--Green

HSP.GREEN		= Color(66,255,96)		--HSP green

HSP.SGREEN		= Color(180,250,160)	--Source green



HSP.BLUE2		= Color(0,0,255)		--Blue

HSP.SBLUE		= Color(0,255,255)		--Blue

HSP.BLUE		= Color(51,153,255)		--HeX Blue

HSP.LPBLUE		= Color(80,170,255)		--Laser pistol blue

HSP.PBLUE		= Color(155,205,248)	--printall blue



HSP.SYELLOW		= Color(255,255,0)		--LuaError Yellow

HSP.YELLOW2		= Color(255,220,0,200)	--HEV yellow

HSP.YELLOW		= Color(255,200,0)		--Yellow



HSP.ORANGE		= Color(255,153,0)		--Respected orange

HSP.PINK		= Color(255,0,153)		--Faggot pink



HSP.PURPLE		= Color(149,102,255)	--ASK2 purple

HSP.KIPURPLE	= Color(192,0,192)		--Killicon Purple

HSP.SVOTE		= Color(255,64,96)		--Solidvote Purple



HSP.GREY		= Color(175,175,175)	--Blackops grey

HSP.SGREY		= Color(192,192,192)	--Source grey



HSP.WHITE		= Color(255,255,255)	--White

HSP.WHITE2		= Color(254,254,254)	--White2





function COLCON(...)

	local color = HSP.WHITE

	for k, v in pairs( {...} ) do

		local typ = type(v)

		

		if (typ == "table" && v["b"] && v["g"] && v["r"] ) then

			color = v

			

		elseif (typ == "Player" and IsValid(v) ) then

			MsgC( team.GetColor( v:Team() ), v:GetName() )

			

		elseif ( (typ == "Entity" or typ == "Weapon" or typ == "Vehicle" or typ == "NPC" ) and IsValid(v) ) then

			MsgC( HSP.BLUE, v:GetClass() )

			

		else

			MsgC(color, tostring(v) )

		end

	end

	MsgC(color, "\n")

end



local function DumpColors()

	for k,v in pairs(HSP) do

		if type(v) == "table" and v["r"] then --Color

			COLCON(HSP.SGREY, k.."\t- ", v, "Test buttocks, HSP colors, -=[UH]=- United Hosts")

		end

	end

end

concommand.Add("hsp_colors"..(SERVER and "" or "_cl"), function(p) if p:IsAdmin() then DumpColors() end end)





//Garry!

if not hook.Hooks then

	hook.Hooks = hook.GetTable()

end





HSP.Contact		= "tell HeX (http://steamcommunity.com/id/MFSiNC)"

THIS_MAP		= game.GetMap():lower()

ModDIR			= util.RelativePathToFull("."):sub(1,-2):gsub("\\", "/"):Trim("/")

_R 				= debug.getregistry()



local pEntity = FindMetaTable("Entity")



function pEntity:print(str,msg) --Has to be on entity

	if not IsValid(self) or not self:IsPlayer() then

		return print(str)

	end

	

	if not msg then

		str = str.."\n"

	end

	self:PrintMessage(HUD_PRINTCONSOLE, str)

end



function pEntity:Msg(str)

	if not IsValid(self) or not self:IsPlayer() then

		return Msg(str)

	end

	

	self:PrintMessage(HUD_PRINTCONSOLE, str)

end





function ValidString(v)

	return (v and type(v) == "string" and v != "")

end

HSP.ValidString = ValidString

string.IsValid	= ValidString --The new way!



function string.Check(str,check)

	return str:sub(1,#check) == check

end



function string.EndCheck(str,check)

	return str:sub(-1,-#check) == check

end







function player.Get(what)

	what = tostring(what):lower()

	local match = {}

	

	for k,v in pairs( player.GetAll() ) do

		local name = v:Name():lower()

		if (name == what or tonumber(what) == v:EntIndex() or name:find(what)) then

			table.insert(match,v)

		end

	end

	

	return match

end



function player.Name(str)

	return player.Get(str)[1] or NULL

end



function epairs(egc)

    return pairs( ents.FindByClass(egc) )

end









function HSP.Time()

	return os.date("%I:%M:%S%p")

end

function HSP.Date()

	return os.date("%d-%m-%y %I:%M:%S%p")

end

function HSP.DateOnly()

	return os.date("%d-%m-%y")

end









HSP.file = {}



function HSP.file.MakeTreeForFile(path) --Make dir tree, WHY GARRY

	local Tab 	= path:Split("/")

	local Here	= ""

	

	for k,v in ipairs(Tab) do

		if k != #Tab then --Last entry in path table

			Here = Here..v.."/"

		end

	end

	

	if not file.IsDir(Here, "DATA") then

		file.CreateDir(Here, "DATA")

	end

end





function HSP.file.Write(path,cont)

	HSP.file.MakeTreeForFile(path)

	

	--Write

	local Out = file.Open(path, "w", "DATA")

		if not Out then return end

		Out:Write(cont)

	Out:Close()

end



function HSP.file.Append(path,cont)

	HSP.file.MakeTreeForFile(path)

	

	--Write-append

	local Out = file.Open(path, "a", "DATA")

		if not Out then return end

		Out:Write(cont)

	Out:Close()

end



function HSP.file.Find(what,loc)

	local Files,Dirs = file.Find(what,loc)

	

	--Merge the 2 tables like GM12

	if Dirs then

		for k,v in pairs(Dirs) do

			table.insert(Files,v)

		end

	end

	

	return Files

end



function HSP.file.Read(what,loc)

	if not loc or loc == false then loc = "DATA" end

	if loc == true then loc = "GAME" end

	

	local Out = file.Open(what, "r", loc)

		if not Out then return end

		local str = Out:Read( Out:Size() )

	Out:Close()

	

	if not str then return "" end

	return str

end













function HSP.MyCall(lev)

	local DGI = debug.getinfo(lev or 3)

	if not DGI then return "Gone", 0 end

	

	local Path = (DGI.short_src or "Gone"):gsub("\\","/")

	local Line = (DGI.linedefined or 0)

	

	return Path,Line

end

function HSP.FSource(func)

	local typ = type(func)

	if typ != "function" then

		error("! HSP.FSource, func is a: "..typ)

	end

	

	return debug.getinfo(func).short_src or "GONE"

end







HSP.Detour = { Saved = {} }



function HSP.Detour.Meta(lib,func,new)

	if not (lib and func and new) then

		error("Missing args from HSP.Detour.Meta(lib,func,new)")

	end

	

	local _R = debug.getregistry()

	

	if not _R[lib] or not _R[lib][func] then
		return
		--error("Missing table, '_R."..lib.."."..func.."' doesn't exist")

	end

	

	if _R[lib][func.."Old"] then

		_R[lib][func] = _R[lib][func.."Old"]

		_R[lib][func.."Old"] = nil

		HSP.Detour.Saved[lib.."."..func] = nil

		

		ErrorNoHalt( Format("Detour of '%s.%s' from: %s was RELOADED\n", lib, func, HSP.FSource(new)) )

	end

	

	HSP.Detour.Saved[lib.."."..func] = {old = _R[lib][func], new = new}

	_R[lib][func.."Old"] = _R[lib][func]

	_R[lib][func] = new

end

--[[

HSP.Detour.Meta("Player", "PrintMessage", function(new) end)



HSP.Detour.Meta("bf_read", "ReadString", function(new) end)

]]





function HSP.Detour.Global(lib,func,new)

	if not (lib and func and new) then

		error("Missing args from HSP.Detour.Global(lib,func,new)")

	end

	

	local where = lib

	if where == "_G" then

		where = _G

	else

		where = _G[where]

	end

	

	if not where then --Table doesn't exists in _G

		error("Missing table, '_G."..lib.."."..func.."' doesn't exist")

	end

	

	if where[func.."Old"] then

		where[func] = where[func.."Old"]

		where[func.."Old"] = nil

		HSP.Detour.Saved[lib.."."..func] = nil

		

		ErrorNoHalt( Format("Detour of '%s.%s' from: %s was RELOADED\n", lib, func, HSP.FSource(new)) )

	end

	

	HSP.Detour.Saved[lib.."."..func] = {old = where[func], new = new}

	where[func.."Old"] = where[func]

	where[func] = new

end



--[[

HSP.Detour.Global("os", "date", function(new) end)



HSP.Detour.Global("_G", "PrintMessage", function(new) end)

]]







if SERVER then

	function HSP.Detour.Dump(ply,cmd,args)

		if not ply:IsSuperAdmin() then return end

		

		for k,v in pairs( HSP.Detour.Saved ) do

			print("! func,old,new: ", k, HSP.FSource(v.old), HSP.FSource(v.new) )

		end

	end

	concommand.Add("hsp_detour_dump", HSP.Detour.Dump)

end





























