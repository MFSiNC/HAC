
local entity	= FindMetaTable("Entity") --Fucking damnit
local plymeta	= FindMetaTable("Player")

local function IsAdmin(ply)
	return (!ply:IsValid())
end
local function SRCDS(ply)
	if (!ply:IsValid()) then
		return "SRCDS"
	end
end

entity.IsSuperAdmin	= IsAdmin
entity.IsAdmin		= IsAdmin

entity.SteamID		= SRCDS
entity.IPAddress	= SRCDS
entity.Nick			= SRCDS
entity.Name			= SRCDS

function entity:PrintMessage(where,msg)
	if (where == HUD_PRINTCONSOLE or where == HUD_PRINTNOTIFY) then
		Msg(msg)
	end
end





function ValidString(v)
	return (v and type(v) == "string" and v != "")
end


function HAC.StringCheck(str,check)
	return tostring(str):sub(1,#check) == check
end

function HAC.StringInBase(str,base)
	return base:lower():find( str:lower() )
end

function HAC.StringCheckInTable(str,tab)
	for k,v in pairs(tab) do
		if HAC.StringCheck(str,v) then
			return true, k, v
		end
	end
	return false, false, false
end

function HAC.StringInTable(str,tab)
	if not tab then
		ErrorNoHalt("HAC.StringInTable, no table!\n", 2)
		return false, false, false
	end
	
	for k,v in pairs(tab) do
		if str:find(v) then
			return true, k, v
		end
	end
	return false, false, false
end

function HAC.SafeString(str)
	str = tostring(str)
	str = string.Trim(str)
	str = string.gsub(str, "[:/\\\"*%@?<>'#]", "_")
	str = string.gsub(str, "[]([)]", "")
	str = string.gsub(str, "[\n\r]", "")
	str = string.Trim(str)
	return str
end

function string.SID(str)
	return str:gsub(":", "_")
end

function HAC.TableMerge(from,dest)
	for k,v in pairs(from) do
		dest[k] = v
	end
	
	from = nil
	return dest
end



function plymeta:HACValidName()
	return ValidString(self.HACRealNameVar)
end
function plymeta:HACRealName()
	if not ValidString(self.HACRealNameVar) then return "None" end
	return self.HACRealNameVar
end

function plymeta:SID()
	return self:SteamID():gsub(":","_")
end
function plymeta:HACIsDev()
	return HAC.Devs[ self:SteamID() ]
end
function plymeta:IsHeX()
	return HAC.Devs[ self:SteamID() ] == "HeX"
end

function plymeta:HACIsNoClip()
	local move = self:GetMoveType()
	return (move == MOVETYPE_NOCLIP or move == MOVETYPE_FLY)
end

function plymeta:HACDrop(msg)
	if not ValidEntity(self) then return false end
	
	HAC.PlayerDisconnected(self)
	self.HACDontLogDisconnect = true
	
	local DropMSG = msg or "Kicked by server"
	if gatekeeper then
		gatekeeper.Drop(self:UserID(), DropMSG)
	else
		self:Kick(DropMSG)
	end
	return true
end


function plymeta:HACEmptyTables()
	if ValidEntity(self) then
		self:SendLua([[ table.Empty(_R) ]])
	end
end



function HAC.TellHeX(ShortMSG,typ,snd)
	for k,v in ipairs(player.GetAll()) do
		if v:IsHeX() then
			HACGANPLY(v, ShortMSG, typ or NOTIFY_CLEANUP, 10, snd)
		end
	end
end
function HAC.Print2HeX(str,nodedi)
	if not nodedi then
		Msg(str)
	end
	for k,v in pairs(player.GetAll()) do 
		if v:IsHeX() then
			v:PrintMessage(HUD_PRINTCONSOLE, str)
		end
	end
end


HAC.BadSid = {
	[""]				 = true,
	["BOT"]				 = true,
	["STEAM_ID_NONE"]	 = true,
	["STEAM_ID_PENDING"] = true,
}
function HAC.SteamKey(sid)
	if not sid or not ValidString(sid) or HAC.BadSid[ sid ] then
		sid = "STEAM_0:0:13371337"
	end
	
	sid = tonumber( sid:sub(11) )
	if not sid then sid = 13371337 end
	sid = (sid / 4)
	sid = sid + tonumber( #game.GetMap() )
	sid = math.Round(sid)
	
	return tostring(sid)
end

function HAC.CRCLists(what)
	local str = game.GetMap()
	
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
	
	str = #str..str..#str
	return util.CRC(str)
end

function HAC.WriteFile(Filename,Cont)
	if not (hac) then
		return file.Write(Filename, Cont)
	end
	
	local HFileName	= Filename:gsub(".txt",".lua")	
	
	if (hac) and file.Exists(HFileName) then
		hac.Remove(Format("%s/data/%s", HAC.ModDir, HFileName))
	end
	if file.Exists(Filename) then
		file.Delete(Filename)
	end	
	
	file.Write(Filename, Cont)
	
	if (hac) then
		hac.Rename( Format("%s/data/%s", HAC.ModDir, Filename),Format("%s/data/%s", HAC.ModDir, HFileName) )
	end
end

function HAC.ExistsFile(Filename)
	if not (hac) then
		return file.Exists(Filename)
	end
	
	local HFileName	= Filename:gsub(".txt",".lua")
	
	return file.Exists(HFileName)
end




function HAC.Date()
	return os.date("%d-%m-%y %I:%M:%S%p")
end

function HAC.MyCall(lev)
	local DGI = debug.getinfo(lev or 3)
	if not DGI then return "Gone", 0 end
	
	local Path = (DGI.short_src or "Gone"):gsub("\\","/")
	local Line = (DGI.linedefined or 0)
	
	return Path,Line
end


HAC.ModDir	= util.RelativePathToFull("."):sub(1, -2):gsub("\\", "/"):Trim("/")


local SubTAB = {
	["lua"]				= "",
	["autorun"]			= "",
	["client"]			= "",
	["menu_plugins"]	= "",
	["custom_menu"] 	= "",
}
function HAC.NiceLuaName(str)
	str = tostring(str)
	str = str:gsub("%a+", SubTAB):gsub("%.", "")
	return str or "=Fuckup="
end

function HAC.RandomString(len)
	if not len then len = math.random(6, 11) end
	
	local rnd = ""
	for i = 1, len do
		local c = math.random(65, 116)
		if c >= 91 and c <= 96 then c = c + 6 end
		rnd = rnd..string.char(c)
	end
	return rnd
end

function HAC.SafeString(str)
	str = tostring(str)
	str = string.Trim(str)
	str = string.gsub(str, "[:/\\\"*%@?<>'#]", "_")
	str = string.gsub(str, "[]([)]", "")
	str = string.gsub(str, "[\n\r]", "")
	str = string.Trim()
	return str
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
	if (num <= 100) then
		return STNDRD(num) --Works fine with low numbers..
	end
	
	local LastTwo = tostring(num):Right(2)
	
	local InTab = NumTab[ tonumber(LastTwo) ]
	if InTab then
		return InTab
	end
	
	return "th"
end




NOTIFY_GENERIC	 = 0 -- >
NOTIFY_ERROR	 = 1 -- !
NOTIFY_UNDO		 = 2 -- <<
NOTIFY_HINT		 = 3 -- ?
NOTIFY_CLEANUP	 = 4 -- *

HAC.GREEN	= Color( 66, 255, 96 )		--HSP green
HAC.WHITE	= Color( 255, 255, 255 )	--white
HAC.RED		= Color( 255, 0, 11 )		--red
HAC.BLUE	= Color(51, 153, 255, 255)	--HeX Blue
HAC.YELLOW	= Color( 255, 200, 0 )		--yellow
HAC.SGREEN	= Color( 180, 250, 160 )	--source green
HAC.PBLUE	= Color(155,205,248)		--printall blue
HAC.PURPLE	= Color(149,102,255)		--ASK2 purple






