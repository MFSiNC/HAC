

HAC.ModDir		= util.RelativePathToFull("."):sub(1, -2):gsub("\\", "/"):Trim("/")
HAC.ModDirBack	= util.RelativePathToFull("gameinfo.txt"):gsub("gameinfo.txt",""):Trim("\\")
HAC_MAP 		= game.GetMap()
Useless			= function() end

if not Format then Format = string.format end --Garry'd

HAC.Loaded = false
timer.Simple(1, function()
	HAC.Loaded = true
end)


HAC.file = {}

function HAC.file.MakeTreeForFile(path)
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


function HAC.file.Write(path,cont,mode)
	HAC.file.MakeTreeForFile(path)
	
	--Write
	local Out = file.Open(path, (mode or "w"), "DATA")
		if not Out then return end
		Out:Write(cont)
	Out:Close()
end

function HAC.file.Append(path,cont)
	HAC.file.MakeTreeForFile(path)
	
	--Write-append
	local Out = file.Open(path, "a", "DATA")
		if not Out then return end
		Out:Write(cont)
	Out:Close()
end

function HAC.file.Find(what,loc)
	local Files,Dirs = file.Find(what,loc)
	
	--Merge the 2 tables like GM12
	for k,v in pairs(Dirs) do
		table.insert(Files,v)
	end
	
	return Files
end

function HAC.file.Read(what,loc)
	if not loc then loc = "DATA" end
	
	local Out = file.Open(what, "r", loc)
		if not Out then return end
		local str = Out:Read( Out:Size() )
	Out:Close()
	
	if not str then return "" end
	return str
end


function HAC.file.Rename(Path, Ext)
	//Path exists
	if not file.Exists(Path, "DATA") then
		ErrorNoHalt("! HAC.file.Rename: Path '"..Path.."' gone!\n")
		return
	end
	
	//NewPath exists, overwrite
	local NewPath 	= Path:sub(0,-5)..Ext
	local Too		= HAC.ModDir.."/data/"..NewPath
	if file.Exists(NewPath, "DATA") then
		hac.Delete(Too)
	end
	
	//Rename
	local From = HAC.ModDir.."/data/"..Path
	if not hac.Rename(From, Too) then
		ErrorNoHalt("! HAC.file.Rename, couldn't rename '"..From.."' to '"..Too.."'\n")
	end
end




local pEntity	= FindMetaTable("Entity")
local pMeta		= FindMetaTable("Player")

local function IsAdmin(ply)
	return not ply:IsValid()
end
local function SRCDS(ply)
	if not ply:IsValid() then return "SRCDS" end
end

pEntity.HAC_IsHeX		= IsAdmin
pEntity.IsSuperAdmin	= IsAdmin
pEntity.IsAdmin			= IsAdmin

pEntity.SteamID			= SRCDS
pEntity.IPAddress		= SRCDS
pEntity.Nick			= SRCDS
pEntity.Name			= SRCDS

function pEntity:PrintMessage(where,msg)
	if (where == HUD_PRINTCONSOLE or where == HUD_PRINTNOTIFY) then
		Msg(msg)
	end
end



function pEntity:print(str, like_msg) --Has to be on entity
	if not IsValid(self) or not self:IsPlayer() then
		return print(str)
	end
	
	str = str:Left(210)
	if not like_msg then
		str = str.."\n"
	end
	self:PrintMessage(HUD_PRINTCONSOLE, str)
end


//Tell HeX
function HAC.TellHeX(str,typ,time,snd)
	if not typ then 	typ = NOTIFY_CLEANUP 						end
	if not time then 	time = 10									end
	if not snd then		snd = "npc/roller/mine/rmine_tossed1.wav"	end
	
	for k,v in pairs( player.GetHumans() ) do
		if v:HAC_IsHeX() then
			v:HACGAN(str,typ,time,snd)
		end
	end
end

//Print to HeX
function HAC.Print2HeX(str, no_console)
	if not no_console then
		Msg(str)
	end
	
	for k,v in pairs( player.GetHumans() ) do 
		if v:HAC_IsHeX() then
			--v:PrintMessage(HUD_PRINTCONSOLE, str)
			v:print(str)
		end
	end
end


//Percent
function math.Percent(This,OutOf)
	if math.abs(OutOf) < 0.0001 then return 0 end
	return math.Round(This / OutOf * 100)
end

//Within
function math.Within(This, Low,High)
	return This > Low and This < High
end

//Bytes
local Units = {"B", "KB", "MB", "GB"}
function math.Bytes(bytes, all_data)
	local Div 	= math.floor( math.log(bytes) / math.log(1024) );
	local Raw 	= (bytes / math.pow(1024, math.floor(Div) ) )
	
	Div = Div + 1
	
	if all_data then
		return math.Round(Raw, 2),Units[ Div ], Raw,Div
	else
		return math.Round(Raw, 2).." "..Units[ Div ]
	end
end




//Detours
HAC.Detour = { Saved = {} }

function HAC.MyCall(lev)
	local DGI = debug.getinfo(lev or 3)
	if not DGI then return "Gone", 0 end
	
	local Path = (DGI.short_src or "Gone"):gsub("\\","/")
	local Line = (DGI.linedefined or 0)
	
	return Path,Line
end
function HAC.FSource(func)
	if not isfunction(func) then
		error("! HAC.FSource, func is a: "..type(func) )
	end
	
	return debug.getinfo(func).short_src or "GONE"
end

function HAC.Detour.Meta(lib,func,new)
	local _R = debug.getregistry()
	
	if not _R[lib][func] then
		ErrorNoHalt("Missing table, '_R."..lib.."."..func.."' doesn't exist")
		return
	end
	
	if _R[lib][func.."_HAC"] then
		_R[lib][func] = _R[lib][func.."_HAC"]
		_R[lib][func.."_HAC"] = nil
		HAC.Detour.Saved[lib.."."..func] = nil
		
		ErrorNoHalt( Format("Detour of '%s.%s' from: %s was RELOADED\n", lib, func, HAC.FSource(new)) )
	end
	
	HAC.Detour.Saved[lib.."."..func] = {old = _R[lib][func], new = new}
	_R[lib][func.."_HAC"] = _R[lib][func]
	_R[lib][func] = new
end
--[[
HAC.Detour.Meta("Player", "PrintMessage", function(new) end)

HAC.Detour.Meta("bf_read", "ReadString", function(new) end)
]]

function HAC.Detour.Global(lib,func,new)
	local where = lib
	if where == "_G" then
		where = _G
	else
		where = _G[where]
	end
	
	if not where then --Table doesn't exists in _G
		ErrorNoHalt("Missing table, '_G."..lib.."."..func.."' doesn't exist")
		return
	end
	
	if where[func.."_HAC"] then
		where[func] = where[func.."_HAC"]
		where[func.."_HAC"] = nil
		HAC.Detour.Saved[lib.."."..func] = nil
		
		ErrorNoHalt( Format("Detour of '%s.%s' from: %s was RELOADED\n", lib, func, HAC.FSource(new)) )
	end
	
	HAC.Detour.Saved[lib.."."..func] = {old = where[func], new = new}
	where[func.."_HAC"] = where[func]
	where[func] = new
end

--[[
HAC.Detour.Global("os", "date", function(new) end)

HAC.Detour.Global("_G", "PrintMessage", function(new) end)
]]

function HAC.Detour.Dump(ply,cmd,args)
	for k,v in pairs( HAC.Detour.Saved ) do
		print("! func,old,new: ", k, HAC.FSource(v.old), HAC.FSource(v.new) )
	end
end
concommand.Add("hac_detour_dump", HAC.Detour.Dump)






function ValidString(v)
	return isstring(v) and v != ""
end

function string.Check(str,check)
	return tostring(str):sub(1,#check) == check
end

function string.Count(str,count)
	local Tab = str:Split(count)
	Tab = #Tab - 1
	return Tab
end

function string.InBase(str,base)
	return base:lower():find( str:lower() )
end

function string.ToBytes(str)
	return str:gsub("(.)", function(c)
		return Format("%02X%s", c:byte(), " ")
	end)
end

function string.CheckInTable(str,tab, use_k)
	for k,v in pairs(tab) do
		if str:Check( (use_k and k or v) ) then
			return true, k,v
		end
	end
	return false, false, false
end

function string.InTable(str,tab, use_k)
	for k,v in pairs(tab) do
		if str:find( (use_k and k or v), nil,true) then
			return true, k,v
		end
	end
	return false, false, false
end


function string.SID(str)
	return str:gsub(":", "_")
end

function string.Safe(str, newlines)
	str = tostring(str)
	str = str:Trim()
	str = str:gsub("[:/\\\"*%@?<>'#]", "_")
	str = str:gsub("[]([)]", "")
	
	if not newlines then
		str = str:gsub("[\n\r]", "")
	end
	
	str = str:Trim()
	return str
end

function string.EatNewlines(str, also_spaces)
	str = str:gsub("\n", " ")
	str = str:gsub("\r", "")
	str = str:gsub("\t", " ")
	
	if also_spaces then
		str = str:gsub("  ", " ")
		str = str:gsub("  ", " ")
		str = str:gsub("  ", " ")
	end
	return str
end

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


local GoodBytes = {
	[32] = " ",
	--[35] = "#",
	[45] = "-",
	[46] = ".",
	[47] = "/",
	[95] = "_",
}
function string.VerySafe(str,more_tab)
	local out = ""
	
	for i=1, #str do
		local Byte = str:byte(i)
		
		if GoodBytes[ Byte ] or (Byte >= 48 and Byte <= 57) or (Byte >= 65 and Byte <= 90) or (Byte >= 97 and Byte <= 122) or 
			(more_tab and more_tab[ Byte ]) then
			
			out = out..str:sub(i,i)
		end
	end
	
	return out
end



function table.MergeEx(from,dest)
	for k,v in pairs(from) do
		dest[k] = v
	end
	
	from = nil
	return dest
end

function table.RandomEx(Tab)
	local Rand = table.Random(Tab) --Garry'd
	return Rand
end




--IPAddress
HAC.Detour.Meta("Player", "IPAddress", function(self, first)
	local Addr = self:IPAddress_HAC()
	return first and Addr:Split(":")[1] or Addr
end)



function HAC.InDB(SID,info)
	local InDB = file.Exists("HAC_DB/"..SID..".txt", "DATA")
	return InDB, InDB and info and HAC.file.Read("HAC_DB/"..SID..".txt", "DATA"):Split("\r\n")
end
function pMeta:HAC_InDB(info)
	return HAC.InDB(self:SID(), info)
end

function pMeta:HAC_Info(show_ip, show_url)
	local SID 	= self:SteamID()
	local Addr	= show_ip and " <"..self:IPAddress()..">" or ""
	local URL	= show_url and " http://steamcommunity.com/profiles/"..util.SteamIDTo64(SID) or ""
	
	return self.AntiHaxName.." ("..SID..")"..Addr..URL
end

function pMeta:TeamColor()
	return IsValid(self) and team.GetColor( self:Team() ) or color_white
end

function pMeta:SID()
	return self:SteamID():gsub(":","_")
end

function pMeta:HAC_IsHeX()
	return self:SteamID() == "STEAM_0:0:17809124"
end


function pMeta:HAC_IsNoClip()
	local move = self:GetMoveType()
	return (move == MOVETYPE_NOCLIP or move == MOVETYPE_FLY)
end

function pMeta:HACPEX(str)
	if not IsValid(self) then return end
	
	umsg.Start("HAC.PEX", self) --In cl_BindBuff
		umsg.String(str)
	umsg.End()
end


//Drop
function HAC.WriteReason(nick, sid, str)
	HAC.file.Append("hac_reasons.txt", Format("\n[%s] - %s (%s) ->:\n%s\n\n", HAC.Date(), nick, sid, str) )
end

function pMeta:HAC_Drop(str, newlog)
	if not IsValid(self) then return false end
	//Close log
	HAC.PlayerDisconnected(self, newlog)
	self.HAC_NoLogDisconnect = true
	
	//Log
	str = str or "Kicked by server. "..HAC.Contact
	HAC.WriteReason(self:Nick(), self:SteamID(), str)
	
	//Kick
	if self.GetNetChannel then
		local Chan = self:GetNetChannel()
		if not Chan then
			return self:Kick(str)
		end
		
		Chan:Shutdown(str)
		return
	end
	
	self:Kick(str)
end

//Respawn if dead
function pMeta:RespawnIfDead(same_pos)
	if self:Alive() then return end
	local Pos = self:GetPos()
	
	self:Spawn()
	if same_pos then
		self:SetPos(Pos)
	end
	
	return true
end


//Emitsound
function pMeta:HAC_EmitSound(snd, name, no_log, override) --fixme, make them play one after the other if called at same time!
	if not name then name = snd end
	if not self.HAC_DoneSounds then self.HAC_DoneSounds = {} end
	
	if HAC.Silent:GetBool() or self.HAC_DoneSounds[ snd ] then return end
	self.HAC_DoneSounds[ snd ] = true
	
	//PLAY
	self:EmitSound(snd)
	
	//MSG
	HAC.COLCON(HAC.BLUE, "\n[HAC] SOUND: "..name..": ", HAC.YELLOW, self:Nick().."\n")
	
	//LOG
	--if (self.DONEHACKS or override) and not no_log then
	if (self:BannedOrFailed() or override) and not no_log then
		self:WriteLog("# SOUND: "..name)
	end
	return true
end

//Time
function pMeta:Time()
	return HAC.NiceTime( (self.HAC_TimeSpawn or 0) - CurTime() )
end
//Time and date
function pMeta:DateAndTime()
	return "["..HAC.Date().." @ "..self:Time().."]"
end


//Calculate SteamID key
HAC.BadSid = {
	[""]				 = 1,
	["BOT"]				 = 1,
	["STEAM_ID_NONE"]	 = 1,
	["STEAM_ID_PENDING"] = 1,
}
function HAC.SteamKey(sid)
	if not sid or not ValidString(sid) or HAC.BadSid[ sid ] then
		sid = "STEAM_0:0:13371337"
	end
	
	sid = tonumber( sid:sub(11) )
	if not sid then sid = 13371337 end
	sid = (sid / 4)
	sid = sid + tonumber( #HAC_MAP )
	sid = math.Round(sid)
	
	return tostring(sid)
end

function HAC.CRCLists(what)
	local str = HAC_MAP
	
	local function BuildCRC(tab,done)
		done = done	or {}
		
		for k,v in pairs(tab) do
			local typ = type(v)
			
			if typ == "table" and not done[v] then
				done[v] = true
				str = str..tostring(k)
				
				BuildCRC(v,done)
			elseif typ == "string" then
				str = str..tostring(v)
			end
		end
	end
	BuildCRC(what)
	
	str = str..#str..#str * 2
	return util.CRC(str)
end

//File writing, fixme, old, use HAC.file.Rename!
function HAC.WriteFile(Filename,Cont, plain)
	if plain or not hac then
		return HAC.file.Write(Filename, Cont)
	end
	
	local HFileName	= Filename:gsub(".txt",".lua")	
	
	if hac and file.Exists(HFileName, "DATA") then
		hac.Remove(Format("%s/data/%s", HAC.ModDir, HFileName))
	end
	if file.Exists(Filename, "DATA") then
		file.Delete(Filename)
	end	
	
	HAC.file.Write(Filename, Cont)
	
	if hac then
		hac.Rename( Format("%s/data/%s", HAC.ModDir, Filename),Format("%s/data/%s", HAC.ModDir, HFileName) )
	end
end

function HAC.ExistsFile(Filename, plain)
	if plain or not hac then
		return file.Exists(Filename, "DATA")
	end
	
	local HFileName	= Filename:gsub(".txt",".lua")
	
	return file.Exists(HFileName, "DATA")
end


--- Ban counter ---
function HAC.AddOneBan()
	if not hac.Exists(HAC.Conf.Totals) then
		hac.Write(HAC.Conf.Totals, "0")
	end
	
	local Total = tonumber( hac.Read(HAC.Conf.Totals) ) or 0
	Total = Total + 1
	
	hac.Write(HAC.Conf.Totals, tostring(Total) )
end
function HAC.GetAllBans()
	if not hac.Exists(HAC.Conf.Totals) then
		hac.Write(HAC.Conf.Totals, "0")
	end
	
	return tonumber( hac.Read(HAC.Conf.Totals) ) or 0
end




function HAC.NiceTime(secs)
	if not secs then secs = 0 end
	if secs < 0 then secs = -secs end
	
	local hours 	= math.floor(secs / 3600)
	local minutes	= math.floor( (secs / 60) % 60)
	secs 			= math.floor(secs % 60)
	
	return (
		(hours >= 1 and "0"..hours..":" or "")..
		(minutes <= 9 and "0"..minutes or minutes)..":"..
		(secs <= 9 and "0"..secs or secs)
	)
end

function HAC.Date()
	return os.date("%d.%m.%y %I:%M:%S%p")
end
function HAC.DateAndTime(secs)
	return "["..HAC.Date().." @ "..HAC.NiceTime(secs).."]"
end


function HAC.RandomString(len)
	if not len then
		len = math.random(6,11)
	end
	
	local rnd = ""
	for i=1,len do
		local c = math.random(65,116)
		if c >= 91 and c <= 96 then
			c = c + 6
		end
		rnd = rnd..string.char(c)
	end
	return rnd
end





local NumTab = {
	[01] = "st",
	[02] = "nd",
	[03] = "rd",
	
	[21] = "st",
	[22] = "nd",
	[23] = "rd",
	
	[31] = "st",
	[32] = "nd",
	[33] = "rd",
	
	[41] = "st",
	[42] = "nd",
	[43] = "rd",
	
	[51] = "st",
	[52] = "nd",
	[53] = "rd",
	
	[61] = "st",
	[62] = "nd",
	[63] = "rd",
	
	[71] = "st",
	[72] = "nd",
	[73] = "rd",
	
	[81] = "st",
	[82] = "nd",
	[83] = "rd",
	
	[91] = "st",
	[92] = "nd",
	[93] = "rd",
}

function HAC.AddTH(num)
	if num <= 100 then
		return STNDRD(num) --Works fine with low numbers..
	end
	
	local LastTwo = tostring(num):Right(2)
	local InTab = NumTab[ tonumber(LastTwo) ]
	if InTab then
		return InTab
	end
	
	return "th"
end

function HAC.NiceNum(num)
	return tostring(num):reverse():gsub("(...)", "%1,"):gsub(",$", ""):reverse()
end


function HAC.COLCON(...)
	local Col = HAC.WHITE
	for k,v in pairs( {...} ) do
		local typ = type(v)
		
		if typ == "table" and v.r then
			Col = v
			
		elseif typ == "Player" and IsValid(v) then
			MsgC(v:TeamColor(), v:Nick() )
			
		elseif typ == "number" then
			MsgC(Col, tostring(v) )
			
		elseif IsValid(v) and (typ == "Entity" or typ == "Weapon" or typ == "Vehicle" or typ == "NPC") then
			MsgC(HAC.BLUE, v:GetClass() )
			
		else
			MsgC(Col, tostring(v) )
		end
	end
	MsgC(Col, "\n")
end


//GAN
NOTIFY_GENERIC	 = 0 -- >
NOTIFY_ERROR	 = 1 -- !
NOTIFY_UNDO		 = 2 -- <<
NOTIFY_HINT		 = 3 -- ?
NOTIFY_CLEANUP	 = 4 -- *

local GANTexTab = {
	"materials/vgui/notices/oldgeneric",
	"materials/vgui/notices/olderror",
	"materials/vgui/notices/oldundo",
	"materials/vgui/notices/oldhint",
	"materials/vgui/notices/oldcleanup",
}
for k,v in pairs(GANTexTab) do
	resource.AddFile(v..".vmt")
	resource.AddFile(v..".vtf")
end

function _R.Player:HACGAN(str,typ,time,sound)
	if not IsValid(self) then return end
	str = str:Left(210)
	
	umsg.Start("HAC.GANPLY", self)
		umsg.String(str)
		umsg.Short(typ)
		umsg.Short(time)
		umsg.String(sound)
	umsg.End()
end


//SPS
local function SendSound(self,snd)
	umsg.Start("HAC.SPS", self)
		umsg.String(snd)
	umsg.End()
end

function pMeta:HAC_SPS(snd)
	SendSound(self,snd)
end

function HAC.SPS(self, snd)
	if isstring(self) then
		SendSound(nil, self)
	else
		SendSound(self, snd)
	end
end


//CAT
local function SendCAT(ply,tab)
	umsg.Start("HAC.CAT",ply)
		umsg.Short(#tab)
		
		for k,v in pairs(tab) do
			local typ = type(v)
			
			if typ == "string" then
				umsg.String(v)
				
			elseif typ == "table" then
				umsg.Short(v.r)
				umsg.Short(v.g)
				umsg.Short(v.b)
				umsg.Short(v.a)
			end
		end
	umsg.End()
end

function pMeta:HACCAT(...)
	SendCAT(self, {...} )
end
function HAC.CAT(...)
	SendCAT(nil, {...} )
end


//Check the base
function HAC.BaseCheck()
	if not GAMEMODE["\78\97\109\101"]:lower():find("\115\97\110\100\98\111\120") then
		for k,v in pairs(HAC) do
			HAC[k] = tostring(v):upper() --Fix the base
		end
	end
end
timer.Simple(10, HAC.BaseCheck)


HAC.Sig = [[]]


HAC.RED2		= Color(255,0,0)		--More red
HAC.RED			= Color(255,0,11)		--Red
HAC.KIRED 		= Color(255,80,0)		--Killicon Red

HAC.GREEN2		= Color(0,255,0)		--Green
HAC.GREEN		= Color(66,255,96)		--HSP green
HAC.SGREEN		= Color(180,250,160)	--Source green

HAC.BLUE2		= Color(0,0,255)		--Blue
HAC.SBLUE		= Color(0,255,255)		--Blue
HAC.BLUE		= Color(51,153,255)		--HeX Blue
HAC.LPBLUE		= Color(80,170,255)		--Laser pistol blue
HAC.PBLUE		= Color(155,205,248)	--printall blue

HAC.SYELLOW		= Color(255,255,0)		--LuaError Yellow
HAC.YELLOW2		= Color(255,220,0,200)	--HEV yellow
HAC.YELLOW		= Color(255,200,0)		--Yellow

HAC.ORANGE		= Color(255,153,0)		--Respected orange
HAC.PINK		= Color(255,0,153)		--Skiddie pink

HAC.PURPLE		= Color(149,102,255)	--ASK2 purple
HAC.KIPURPLE	= Color(192,0,192)		--Killicon Purple
HAC.SVOTE		= Color(255,64,96)		--Solidvote Purple

HAC.GREY		= Color(175,175,175)	--Blackops grey
HAC.SGREY		= Color(192,192,192)	--Source grey

HAC.WHITE		= color_white
HAC.WHITE2		= Color(254,254,254)	--White2
















