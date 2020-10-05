--[[
Datastream Module
By Janorkie and Deco da Man
]]--

require "glon"

function string.split(str,d)
	local t = {}
	local len = str:len()
	local i = 0
	while i*d < len do
		t[i+1] = str:sub(i*d+1,(i+1)*d)
		i=i+1
	end
	return t
end

local function MergeChanges(dest,changes)
	for k,v in pairs(changes) do
		if v == "\1\2\1" then -- Delete code
			dest[k] = nil
		else
			dest[k] = v
		end
	end
end

if SERVER then

umsg.PoolString "DSStart"
umsg.PoolString "DSPacket"
umsg.PoolString "DSEnd"
umsg.PoolString "DSRequestResponse"
umsg.PoolString "DSPacketReceived"
umsg.PoolString "DSConfirmEnd"

local table = table
local string = string
local umsg = umsg
local concommand = concommand
local util = util
local hook = hook
local math = math
local type = type
local pairs = pairs
local tostring = tostring
local tonumber = tonumber
local RecipientFilter = RecipientFilter
local pcall = pcall
local error = error
local glon = glon
local iterations = CreateConVar( "gmod_datastream_iterations", "1", { FCVAR_ARCHIVE } )
local rawget = rawget
local rawset = rawset
local setmetatable = setmetatable
local _R = _R
local print = print
local ErrorNoHalt = ErrorNoHalt
local IsValid = IsValid

module "datastream"
local _outgoing = {}
local _incoming = {}
local _hooks = {}

function Hook(h,f)
	local hk = {}
	hk.handler = h
	hk.func = f
	_hooks[h] = hk
end

function StreamToClients( rcp, h, d, cb )
	local o = {}
	-- Recipient information
	local rt = type(rcp)
	if rt == "CRecipientFilter" then
		o.rf = rcp
	elseif rt == "table" then
		o.rf = RecipientFilter()
		for k,v in pairs(rcp) do
			o.rf:AddPlayer(v)
		end
	elseif rt == "Player" then
		o.rf = rcp
	else
		error(("Invalid type %q given to datastream.StreamToClients for recipients!"):format(type(rcp)))
	end
	
	-- Data information
	o.decdata = d
	o.encdata = ""
	o.sent = 0
	o.size = 0
	-- Operation state
	o.block = 1
	o.state = 1
	-- Operation handlers
	o.handler = h
	o.callback = cb
	-- Put the operation into the queue and finish up
	o.id = table.insert(_outgoing,o)
	return o.id
end

function DownstreamActive() return #_incoming > 0 end

function GetProgress(id)
	if _outgoing[id] then return _outgoing[id].sent end
end

local function CallStreamHook(ply,h,id,encdat,decdat)
	if not _hooks[h] then
		if hook.Call("DataStreamError", nil, ply, h, id, encdat, decdat) then
			ErrorNoHalt(("DataStreamServer: Unhandled stream %q!"):format(h))
		end
		return
	end
	if hook.Call("CompletedIncomingStream",GAMEMODE,ply,h,id,encdat,decdat) then return end
	_hooks[h].func(ply,h,id,encdat,decdat)
end

local function StreamTick(rep)
	if not rep and iterations:GetInt() > 0 then
		for i=1,iterations:GetInt() do
			StreamTick(true)
		end
	end
	for id,o in pairs(_outgoing) do
		if type(o.rf) != "CRecipientFilter" and !IsValid(o.rf) then
			-- Player disconnected
			_outgoing[o.id] = nil
			return
		end
		if o.state == 1 then -- Processing stage.
			if o.decdata then
				local enc = ""
				local b,err = pcall(glon.encode, o.decdata)
				if b then enc = err else ErrorNoHalt(("DataStreamServer Encoding Error: %s (operation %s)"):format(err, id)) _outgoing[o.id] = nil return end
				o.encdata = string.split(enc,128)
				o.state = 2
			else
				o.state = 3
			end
			umsg.Start("DSStart",o.rf)
				umsg.Long(o.id)
				umsg.String(o.handler)
				umsg.Bool(type(o.encdata) == "table" and #o.encdata <= 1)
				if type(o.encdata) == "table" and #o.encdata <= 1 then
					umsg.String(o.encdata[1] or "")
					if o.callback then o.callback(o.id) end
					_outgoing[o.id] = nil
				end
			umsg.End()
			return
		elseif o.state == 2 then -- Sending stage.
			umsg.Start("DSPacket",o.rf)
				umsg.Long(o.id)
				umsg.String(o.encdata[o.block])
			umsg.End()
			o.block = o.block+1
			if o.block > #o.encdata then o.state = 3 end
			return
		elseif o.state == 3 then -- Ending stage
			umsg.Start("DSEnd",o.rf)
				umsg.Long(o.id)
			umsg.End()
			if o.callback then o.callback(o.id) end
			_outgoing[o.id] = nil
			return
		end
	end
end
hook.Add("Tick","DatastreamTick",StreamTick)

-- Default stuff that will be put in base gamemode
local function AcceptStream()
	return true
end
hook.Add("AcceptStream","AcceptStream",AcceptStream)

-- Messages from the client
local function DSRequest(pl,cmd,args)
	if args[1] ~= "\1" then return end
	local h = args[2]
	local id = tonumber(args[3])
	if hook.Call("AcceptStream",GAMEMODE,pl,h,id) then
		local o = {
			pl = pl,
			handler = h,
			buffer = "",
		}
		o.id = table.insert(_incoming,o)
		umsg.Start("DSRequestResponse",pl)
			umsg.Long(id)
			umsg.Bool(true)
			umsg.Long(o.id)
		umsg.End()
	else
		umsg.Start("DSRequestResponse",pl)
			umsg.Long(id)
			umsg.Bool(false)
		umsg.End()
	end
end
concommand.Add("__dsr",DSRequest)

local function DSPacket(pl,cmd,args)
	if args[1] ~= "\1" then return end
	local id = tonumber(args[3])
	if not _incoming[id] then return end
	local data = args[2]
	_incoming[id].buffer = _incoming[id].buffer..data
	umsg.Start("DSPacketReceived",pl)
		umsg.Long(id)
		umsg.Long(_incoming[id].buffer:len())
	umsg.End()
end
concommand.Add("__dsp",DSPacket)

local function DSEnd(pl, cmd, args)
	if args[1] ~= "\1" then return end
	local id = tonumber(args[2])
	if not _incoming[id] then return end
	local reptab = {["\\"]="\\",["n"]="\n"}
	local encdat = string.gsub(_incoming[id].buffer,"\\(.)",reptab)
	local decdat = ""
	local b,err = pcall(glon.decode,encdat)
	if b then decdat=err else ErrorNoHalt("DataStreamServer Decoding Error: "..err.." (operation "..id.." from "..pl:Name().."("..pl:SteamID().."))") return end
	CallStreamHook(pl,_incoming[id].handler,id,encdat,decdat)
	_incoming[id] = nil
	umsg.Start("DSConfirmEnd",pl)
		umsg.Long(id)
	umsg.End()
end
concommand.Add("__dse",DSEnd)

function _R.Player:SendData(handler, data, callback)
	StreamToClients(self, handler, data, callback)
end

function _R.Player:CreateSharedTable(name,data,clientchanges)
	CreateSharedTable(self,name,data,clientchanges)
end

function _R.Player:GetSharedTable(name)
	return GetSharedTable(self,name)
end

--SharedTable
_R.SharedTable = {
	__index = function(self, key)
		return rawget(self, "__realtable")[key]
	end,
	__newindex = function(self, key, value)
		rawget(self,"__realtable")[key] = value
		if value == nil then
			rawget(self,"__changes")[key] = "\1\2\1" -- Our delete code.
		else
			rawget(self,"__changes")[key] = value
		end
		rawset(self,"__changed",true)
	end,
	__call = function(self, ...)
		-- Think of something l33t to do here
	end,
}
local supported_types = {
	--table			=	true, -- not supported yet
	string			=	true,
	number			=	true,
	boolean			=	true,
	number			=	true,
	Vector			=	true,
	Angle			=	true,
	Entity			=	true,
	Player			=	true,
	CEffectData		=	true,
	ConVar			=	true,
	Color			=	true,
}

local SharedTables = {}
function CreateSharedTable(pl,name,data,clientchanges)
	for k,v in pairs(data) do
		if not supported_types[type(k)] then
			error(("Invalid type %q for key %q!"):format(type(k), tostring(k)))
		elseif not supported_types[type(v)] then
			error(("Invalid type %q for value %q (of key %q)!"):format(type(v), tostring(v), tostring(k)))	
		end
	end
	local t = setmetatable({
		__pl = pl,
		__realtable = data,
		__changes = {},
		__changed = false,
		__clientchanges = clientchanges
	}, _R.SharedTable)
	if not SharedTables[pl] then SharedTables[pl] = {} end
	SharedTables[pl][name] = t
	StreamToClients(pl, "SharedTableCreate", {name = name, data = data, clientchanges = clientchanges})
	return t
end
local function OnTick()
	for k,v in pairs(SharedTables) do
		for tk,tv in pairs(v) do
			local b, err = pcall(
			function( )
				if rawget(tv,"__changed") then
					StreamToClients(rawget(tv,"__pl"), "SharedTableUpdate", {name = tk,changes = rawget(tv,"__changes")})
					rawset(tv,"__changed",false)
					rawset(tv,"__changes",{})
				end
			end)
			if not b then ErrorNoHalt("DatastreamServer STUError: " .. err ) end
		end
	end
end
hook.Add("Tick", "SharedTableTick", OnTick)
function GetSharedTable(pl,name)
	if SharedTables[pl] then
		return SharedTables[pl][name]
	end
	return nil
end

local function SharedTableUpdate(pl,handler,id,encoded,decoded)
	local st = GetSharedTable(pl,decoded.name)
	if not st then return end
	if rawget(st,"__clientchanges") then
		MergeChanges(rawget(st,"__realtable"),decoded.changes)
	else
		pl:PrintMessage(HUD_PRINTCONSOLE, "DatastreamClient STError: Not allowed to change this table!")
	end
end
Hook("SharedTableUpdate",SharedTableUpdate)

elseif CLIENT then
local table = table
local string = string
local usermessage = usermessage
local hook = hook
local math = math
local os = os
local util = util
local RunConsoleCommand = RunConsoleCommand
local LocalPlayer = LocalPlayer
local type = type
local pairs = pairs
local tostring = tostring
local RecipientFilter = RecipientFilter
local pcall = pcall
local error = error
local setmetatable = setmetatable
local glon = glon
local _R = _R
local print = print
local PrintTable = PrintTable
local ErrorNoHalt = ErrorNoHalt
local rawget = rawget
local rawset = rawset

module "datastream"

local _outgoing = {}
local _incoming = {}
local _tempout = {}
local _hooks = {}

function Hook(h,f)
	local hk = {}
	hk.handler = h
	hk.func = f
	_hooks[h] = hk
end

function StreamToServer(h,d,cb,acb)
	local o = {
		-- Data information
		decdata = d,
		encdata = "",
		sent = 0,
		size = 0,
		-- Operation state
		block = 1,
		state = 1,
		-- Operation handlers
		handler = h,
		callback = cb,
		acallback = acb,
	}
	o.id = table.insert(_tempout,o)
	RunConsoleCommand("__dsr","\1",h,o.id)
	return o.id
end

function DownstreamActive() return #_incoming > 0 end

function GetProgress(id)
	if _outgoing[id] then return _outgoing[id].sent end
end

local function CallStreamHook(h,id,encdat,decdat)
	if not _hooks[h] then
		ErrorNoHalt("DataStreamClient: Unhandled stream "..h.."!")
	return end
	hook.Call("CompletedIncomingStream",GAMEMODE,h,id,encdat,decdat)
	_hooks[h].func(h,id,encdat,decdat)
end

local function StreamTick()
	for id,o in pairs(_outgoing) do
		if o.state == 1 then -- Processing stage.
			if o.decdata then
				local enc = ""
				local b,err = pcall(glon.encode, o.decdata)
				if b then enc=err else ErrorNoHalt("DataStreamClient Encoding Error: "..err.." (operation "..o.id..")\n") _outgoing[o.id] = nil return end
				o.encdata = string.split(string.gsub(string.gsub(enc,"\\","\\\\"),"\n","\\n"),128)
				o.state = 2
			else
				o.state = 3
			end
			return
		elseif o.state == 2 then -- Sending stage.
			RunConsoleCommand("__dsp","\1",o.encdata[o.block],o.id)
			o.block = o.block+1
			if o.block > #o.encdata then o.state = 3 end
			return
		elseif o.state == 3 then -- Ending stage
			RunConsoleCommand("__dse","\1",o.id)
			o.state = 4
			return
		end
	end
end
hook.Add("Tick","DatastreamTick",StreamTick)

-- Usermessages from the server
local function DSStart(data)
	local id = data:ReadLong()
	local handler = data:ReadString()
	local o = {
	id = id,
	handler = handler,
	buffer = "",
	}
	_incoming[id] = o
	if data:ReadBool() then
		local encdat = data:ReadString()
		local decdat = ""
		local b,err = pcall(glon.decode,encdat)
		if b then decdat=err else ErrorNoHalt("DataStreamClient Decoding Error: "..err.." (operation "..id..")\n") return end
		CallStreamHook(_incoming[id].handler,id,encdat,decdat)
		_incoming[id] = nil
	end
end
usermessage.Hook("DSStart",DSStart)

local function DSPacket(data)
	local id = data:ReadLong()
	if not _incoming[id] then return end
	local data = data:ReadString()
	_incoming[id].buffer = _incoming[id].buffer..data
end
usermessage.Hook("DSPacket",DSPacket)

local function DSEnd(data)
	local id = data:ReadLong()
	if not _incoming[id] then return end
	local encdat = _incoming[id].buffer
	local decdat = ""
	local b,err = pcall(glon.decode,encdat)
	if b then decdat=err else ErrorNoHalt("DataStreamClient Decoding Error: "..err.." (operation "..id..")\n") return end
	CallStreamHook(_incoming[id].handler,id,encdat,decdat)
	_incoming[id] = nil
end
usermessage.Hook("DSEnd",DSEnd)

local function DSConfirmEnd(data)
	local id = data:ReadLong()
	local o = _outgoing[id]
	if not o then return end
	if o.callback then
		o.callback(o.id)
	end
	_outgoing[o.id] = nil
end
usermessage.Hook("DSConfirmEnd",DSConfirmEnd)

-- Accept/Deny Handlers

local function DSRequestResponse(data)
	local tempid = data:ReadLong()
	local o = _tempout[tempid]
	local accept = data:ReadBool()
	if not o then return end
	_tempout[tempid] = nil
	if accept then
		o.id = data:ReadLong()
		_outgoing[o.id] = o
		if o.acallback then
			o.acallback(true,tempid,o.id)
		end
	else
		if o.acallback then
			o.acallback(false,tempid)
		end
	end
end
usermessage.Hook("DSRequestResponse",DSRequestResponse)

-- Packet Confirmation Message
local function DSPacketReceived(data)
	local id = data:ReadLong()
	if not _outgoing[id] then return end
	_outgoing[id].sent = data:ReadLong()
end
usermessage.Hook("DSPacketReceived",DSPacketReceived)

--SharedTable
_R.SharedTable = {
	__index = function(self, key)
		return rawget(self, "__realtable")[key]
	end,
	__newindex = function(self, key, value)
		if not rawget(self,"__clientchanges") then ErrorNoHalt("DatastreamClient STError: Not allowed to change this table!") return end
		rawget(self,"__realtable")[key] = value
		if value == nil then
			rawget(self,"__changes")[key] = "\1\2\1" -- Our delete code.
		else
			rawget(self,"__changes")[key] = value
		end
		rawset(self,"__changed",true)
	end,
	__call = function(self, ...)
		-- Think of something l33t to do here
	end,
}

local SharedTables = {}

local function OnTick()
	for k,v in pairs(SharedTables) do
		local b, err = pcall(
		function( )
			if rawget(v,"__changed") and rawget(v,"__clientchanges") then
				StreamToServer("SharedTableUpdate", {name = k,changes = rawget(v,"__changes")})
				rawset(v,"__changed",false)
				rawset(v,"__changes",{})
			end
		end)
		if not b then ErrorNoHalt( "DatastreamClient STUError: "..err.."\n" ) end
	end
end
hook.Add("Tick", "SharedTableTick", OnTick)
function GetSharedTable(name)
	return SharedTables[name] or nil
end

local function SharedTableCreate(handler,id,encoded,decoded)
	local t = setmetatable({
		__realtable = decoded.data,
		__changes = {},
		__changed = false,
		__clientchanges = decoded.clientchanges
	}, _R.SharedTable)
	SharedTables[decoded.name] = t
end
Hook("SharedTableCreate",SharedTableCreate)

local function SharedTableUpdate(handler,id,encoded,decoded)
	local st = GetSharedTable(decoded.name)
	if not st then return end
	MergeChanges(st,decoded.changes)
end
Hook("SharedTableUpdate",SharedTableUpdate)

end
