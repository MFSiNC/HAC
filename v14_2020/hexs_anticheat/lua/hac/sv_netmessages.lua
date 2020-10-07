-- Debug ConVar
local sourcenet_netmessage_info = CreateConVar("sourcenet_netmessage_info", "0")

local function log2(val)
	return math.ceil(math.log(val) / math.log(2))
end

-- Engine definitions
NET_MESSAGE_BITS = 6
NUM_NEW_COMMAND_BITS = 4
NUM_BACKUP_COMMAND_BITS = 3
MAX_TABLES_BITS = log2(32)
MAX_USERMESSAGE_BITS = 11
MAX_ENTITYMESSAGE_BITS = 11
MAX_SERVER_CLASS_BITS = 9
MAX_EDICT_BITS = 13

function SourceNetMsg(msg)
	if sourcenet_netmessage_info:GetInt() ~= 0 then
		Msg("[snmi] " .. msg)
	end
end

NET_MESSAGES = {
	[net_NOP] = {
		DefaultCopy = function(netchan, read, write)
			write:WriteUInt(net_NOP, NET_MESSAGE_BITS)
		end
	},
	-- 0
	[net_Disconnect] = {
		DefaultCopy = function(netchan, read, write)
			write:WriteUInt(net_Disconnect, NET_MESSAGE_BITS)
			local reason = read:ReadString()
			write:WriteString(reason)
			SourceNetMsg(string.format("net_Disconnect %s\n", reason))
		end
	},
	-- 1
	[net_File] = {
		DefaultCopy = function(netchan, read, write)
			write:WriteUInt(net_File, NET_MESSAGE_BITS)
			local transferid = read:ReadUInt(32)
			write:WriteUInt(transferid, 32)
			local requested = read:ReadBit()
			write:WriteBit(requested)

			if requested == 0 then
				SourceNetMsg(string.format("net_File %i,false\n", transferid))

				return
			end

			local requesttype = read:ReadUInt(1)
			write:WriteUInt(requesttype, 1)
			local fileid = read:ReadUInt(32)
			write:WriteUInt(fileid, 32)
			SourceNetMsg(string.format("net_File %i,true,%i,%i\n", transferid, requesttype, fileid))
		end
	},
	-- 2
	[net_Tick] = {
		DefaultCopy = function(netchan, read, write)
			write:WriteUInt(net_Tick, NET_MESSAGE_BITS)
			local tick = read:ReadLong()
			write:WriteLong(tick)
			local hostframetime = read:ReadUInt(16)
			write:WriteUInt(hostframetime, 16)
			local hostframetimedeviation = read:ReadUInt(16)
			write:WriteUInt(hostframetimedeviation, 16)
		end
	},
	-- 3 --SourceNetMsg(string.format("net_Tick %i,%i,%i\n", tick, hostframetime, hostframetimedeviation))
	[net_StringCmd] = {
		DefaultCopy = function(netchan, read, write)
			write:WriteUInt(net_StringCmd, NET_MESSAGE_BITS)
			local cmd = read:ReadString()
			write:WriteString(cmd)
			SourceNetMsg(string.format("net_StringCmd %s\n", cmd))
		end
	},
	-- 4
	[net_SetConVar] = {
		DefaultCopy = function(netchan, read, write)
			write:WriteUInt(net_SetConVar, NET_MESSAGE_BITS)
			local count = read:ReadByte()
			write:WriteByte(count)

			for i = 1, count do
				local cvarname = read:ReadString()
				write:WriteString(cvarname)
				local cvarvalue = read:ReadString()
				write:WriteString(cvarvalue)
				SourceNetMsg(string.format("net_SetConVar %s=%s\n", cvarname, cvarvalue))
			end
		end
	},
	-- 5
	[net_SignonState] = {
		DefaultCopy = function(netchan, read, write)
			write:WriteUInt(net_SignonState, NET_MESSAGE_BITS)
			local state = read:ReadByte()
			write:WriteByte(state)
			local servercount = read:ReadLong()
			write:WriteLong(servercount)
			SourceNetMsg(string.format("net_SignonState %i,%i\n", state, servercount))
		end
	},
	-- 6
	CLC = {
		[clc_ClientInfo] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(clc_ClientInfo, NET_MESSAGE_BITS)
				local spawncount = read:ReadLong()
				write:WriteLong(spawncount)
				local sendTableCRC = read:ReadLong()
				write:WriteLong(sendTableCRC)
				local ishltv = read:ReadBit()
				write:WriteBit(ishltv)
				local friendsID = read:ReadLong()
				write:WriteLong(friendsID)
				local guid = read:ReadString()
				write:WriteString(guid)

				for i = 1, MAX_CUSTOM_FILES do
					local useFile = read:ReadBit()
					write:WriteBit(useFile)

					if useFile == 1 then
						local fileCRC = read:ReadUInt(32)
						write:WriteUInt(fileCRC, 32)
						SourceNetMsg("clc_ClientInfo \t> customization file " .. i .. " = " .. fileCRC .. "\n")
					end
				end

				SourceNetMsg(string.format("clc_ClientInfo %i,%i,%i,%i,%s\n", spawncount, sendTableCRC, ishltv, friendsID, guid))
			end
		},
		-- 8
		[clc_Move] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(clc_Move, NET_MESSAGE_BITS)
				local new = read:ReadUInt(NUM_NEW_COMMAND_BITS)
				write:WriteUInt(new, NUM_NEW_COMMAND_BITS)
				local backup = read:ReadUInt(NUM_BACKUP_COMMAND_BITS)
				write:WriteUInt(backup, NUM_BACKUP_COMMAND_BITS)
				local bits = read:ReadWord()
				write:WriteWord(bits)
				local data = read:ReadBits(bits)
				write:WriteBits(data)
			end
		},
		-- 9 --SourceNetMsg(string.format("clc_Move %i,%i,%i\n", new, backup, bits))
		[clc_VoiceData] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(clc_VoiceData, NET_MESSAGE_BITS)
				local bits = read:ReadWord()
				write:WriteWord(bits)
				local data = read:ReadBits(bits)
				write:WriteBits(data)
				SourceNetMsg(string.format("clc_VoiceData %i\n", bits))
			end
		},
		-- 10
		[clc_BaselineAck] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(clc_BaselineAck, NET_MESSAGE_BITS)
				local tick = read:ReadLong()
				write:WriteLong(tick)
				local num = read:ReadUInt(1)
				write:WriteUInt(num, 1)
				SourceNetMsg(string.format("clc_BaselineAck %i,%i\n", tick, num))
			end
		},
		-- 11
		[clc_ListenEvents] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(clc_ListenEvents, NET_MESSAGE_BITS)

				for i = 1, 16 do
					local event = read:ReadUInt(32)
					write:WriteUInt(event, 32)
				end

				SourceNetMsg(string.format("clc_ListenEvents\n"))
			end
		},
		-- 12
		[clc_RespondCvarValue] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(clc_RespondCvarValue, NET_MESSAGE_BITS)
				local cookie = read:ReadInt(32)
				write:WriteInt(cookie, 32)
				local status = read:ReadInt(4)
				write:WriteInt(status, 4)
				local cvarname = read:ReadString()
				write:WriteString(cvarname)
				local cvarvalue = read:ReadString()
				write:WriteString(cvarvalue)
				SourceNetMsg(string.format("clc_RespondCvarValue %i,%i,%s,%s\n", cookie, status, cvarname, cvarvalue))
			end
		},
		-- 13
		[clc_FileCRCCheck] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(clc_FileCRCCheck, NET_MESSAGE_BITS)
				local reserved = read:ReadBit()
				write:WriteBit(reserved)
				local gamepath = read:ReadUInt(2)
				write:WriteUInt(gamepath, 2)
				local pathid = "commonpath"

				if gamepath == 0 then
					pathid = read:ReadString()
					write:WriteString(pathid)
				end

				local prefixid = read:ReadUInt(3)
				write:WriteUInt(prefixid, 3)
				local filename = read:ReadString()
				write:WriteString(filename)
				local crc = read:ReadUInt(32)
				write:WriteUInt(crc, 32)
				SourceNetMsg(string.format("clc_FileCRCCheck %i,%s,%s,%i,%s,%i", reserved, gamepath, pathid, prefixid, filename, crc))
			end
		},
		-- 14
		[clc_CmdKeyValues] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(clc_CmdKeyValues, NET_MESSAGE_BITS)
				local length = read:ReadLong()
				write:WriteLong(length)
				local keyvalues = read:ReadBits(length * 8)
				write:WriteBits(keyvalues)
				SourceNetMsg(string.format("clc_CmdKeyValues %i\n", length))
			end
		},
		-- 16
		[clc_FileMD5Check] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(clc_FileMD5Check, NET_MESSAGE_BITS)
				local reserved = read:ReadBit()
				write:WriteBit(reserved)
				local gamepath = read:ReadUInt(2)
				write:WriteUInt(gamepath, 2)
				local pathid = "commonpath"

				if gamepath == 0 then
					pathid = read:ReadString()
					write:WriteString(pathid)
				end

				local prefixid = read:ReadUInt(3)
				write:WriteUInt(prefixid, 3)
				local filename = read:ReadString()
				write:WriteString(filename)
				local md5 = read:ReadBytes(16)
				write:WriteUInt(md5, 16)
				SourceNetMsg(string.format("clc_FileMD5Check %i,%s,%s,%i,%s,%s", reserved, gamepath, pathid, prefixid, filename, md5))
			end
		},
		-- 17
		[clc_GMod_ClientToServer] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(clc_GMod_ClientToServer, NET_MESSAGE_BITS)
				local bits = read:ReadUInt(20)
				write:WriteUInt(bits, 20)
				local msgtype = read:ReadByte()
				write:WriteByte(msgtype)
				bits = bits - 8

				if msgtype == 0 then
					local id = read:ReadWord()
					write:WriteWord(id)
					bits = bits - 16

					if bits > 0 then
						local data = read:ReadBits(bits)
						write:WriteBits(data)
					end

					SourceNetMsg(string.format("clc_GMod_ClientToServer netmessage bits=%i,msgtype=%i,id=%i/%s\n", bits, msgtype, id, util.NetworkIDToString(id) or "unknown message"))
				elseif msgtype == 2 then
					local strerr = read:ReadString()
					write:WriteString(strerr)
					hook.Run("ReadPacket", ply, nil, "LuaError", strerr)
					SourceNetMsg(string.format("clc_GMod_ClientToServer client Lua error\n%s", strerr))
				elseif msgtype == 4 then
					local count = bits / 16

					if count > 0 then
						local id = read:ReadUInt(16)
						write:WriteUInt(id, 16)
						local str = tostring(id)

						for i = 2, count do
							id = read:ReadUInt(16)
							write:WriteUInt(id, 16)
							str = str .. ", " .. id
						end

						SourceNetMsg(string.format("clc_GMod_ClientToServer GModDataPack::SendFileToClient bits=%i,counts=%i %s\n", bits, count, str))
					else
						SourceNetMsg("clc_GMod_ClientToServer GModDataPack::SendFileToClient\n")
					end
				end
			end
		},
	},
	-- 18
	SVC = {
		[svc_Print] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(svc_Print, NET_MESSAGE_BITS)
				local str = read:ReadString()
				write:WriteString(str)
				SourceNetMsg(string.format("svc_Print %s\n", str))
			end
		},
		-- 7
		[svc_ServerInfo] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(svc_ServerInfo, NET_MESSAGE_BITS)
				-- Protocol version number
				local version = read:ReadShort()
				write:WriteShort(version)
				-- # of servers spawned since server .exe started
				-- So that we can detect new server startup during download, etc.
				-- Map change causes new server to "spawn".
				local servercount = read:ReadLong()
				write:WriteLong(servercount)
				-- Is SourceTV enabled?
				local sourcetv = read:ReadBit()
				write:WriteBit(sourcetv)
				-- 0 == listen, 1 == dedicated
				local dedicated = read:ReadBit()
				write:WriteBit(dedicated)
				-- The client side DLL CRC check.
				local serverclientcrc = read:ReadLong()
				write:WriteLong(serverclientcrc)
				-- Max amount of 'classes' (entity classes?)
				local maxclasses = read:ReadWord()
				write:WriteWord(maxclasses)
				-- The MD5 of the server map must match the MD5 of the client map, else
				-- the client is probably cheating.
				local servermapmd5 = read:ReadBytes(16)
				write:WriteBytes(servermapmd5)
				-- Amount of clients currently connected
				local playernum = read:ReadByte()
				write:WriteByte(playernum)
				-- Max amount of clients
				local maxclients = read:ReadByte()
				write:WriteByte(maxclients)
				-- Interval between ticks
				local interval_per_tick = read:ReadFloat()
				write:WriteFloat(interval_per_tick)
				-- Server platform ('w', ...?)
				local platform = read:ReadChar()
				write:WriteChar(platform)
				-- Directory used by game (eg. garrysmod)
				local gamedir = read:ReadString()
				write:WriteString(gamedir)
				-- Map being played
				local levelname = read:ReadString()
				write:WriteString(levelname)
				-- Skybox to use
				local skyname = read:ReadString()
				write:WriteString(skyname)
				-- Server name
				local hostname = read:ReadString()
				write:WriteString(hostname)
				-- Loading URL of the server
				local loadingurl = read:ReadString()
				write:WriteString(loadingurl)
				-- Gamemode
				local gamemode = read:ReadString()
				write:WriteString(gamemode)
				SourceNetMsg(string.format("svc_ServerInfo %i,%i,%i,%i,%i,%i,%s,%i,%i,%i,%s,%s,%s,%s,%s,%s,%s\n", version, servercount, sourcetv, dedicated, serverclientcrc, maxclasses, servermapmd5, playernum, maxclients, interval_per_tick, string.char(platform), gamedir, levelname, skyname, hostname, loadingurl, gamemode))
			end
		},
		-- 8
		[svc_SendTable] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(svc_SendTable, NET_MESSAGE_BITS)
				local encoded = read:ReadBit()
				write:WriteBit(encoded)
				local bits = read:ReadShort()
				write:WriteShort(bits)
				local data = read:ReadBits(bits)
				write:WriteBits(data)
				SourceNetMsg(string.format("svc_SendTable %i,%i\n", encoded, bits))
			end
		},
		-- 9
		[svc_ClassInfo] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(svc_ClassInfo, NET_MESSAGE_BITS)
				local numclasses = read:ReadShort()
				write:WriteShort(numclasses)
				local useclientclasses = read:ReadBit()
				write:WriteBit(useclientclasses)
				local size = log2(numclasses) + 1

				if useclientclasses == 0 then
					for i = 1, numclasses do
						local classid = read:ReadUInt(size)
						write:WriteUInt(classid, size)
						local classname = read:ReadString()
						write:WriteString(classname)
						local dtname = read:ReadString()
						write:WriteString(dtname)
						SourceNetMsg(string.format("svc_ClassInfo full update,%i,%s,%s\n", classid, classname, dtname))
					end
				end

				SourceNetMsg(string.format("svc_ClassInfo %i,%i\n", numclasses, useclientclasses))
			end
		},
		-- 10
		[svc_SetPause] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(svc_SetPause, NET_MESSAGE_BITS)
				local state = read:ReadBit()
				write:WriteBit(state)
				SourceNetMsg(string.format("svc_SetPause %i\n", state))
			end
		},
		-- 11
		[svc_CreateStringTable] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(svc_CreateStringTable, NET_MESSAGE_BITS)
				local tablename = read:ReadString()
				write:WriteString(tablename)
				local maxentries = read:ReadWord()
				write:WriteWord(maxentries)
				local size = log2(maxentries) + 1
				local entries = read:ReadUInt(size)
				write:WriteUInt(entries, size)
				local bits = read:ReadVarInt32()
				write:WriteVarInt32(bits)
				local userdata = read:ReadBit()
				write:WriteBit(userdata)

				if userdata == 1 then
					local userdatasize = read:ReadUInt(12)
					write:WriteUInt(userdatasize, 12)
					local userdatabits = read:ReadUInt(4)
					write:WriteUInt(userdatabits, 4)
				end

				local compressed = read:ReadBit()
				write:WriteBit(compressed)

				if bits > 0 then
					local data = read:ReadBits(bits)
					write:WriteBits(data)
				end

				SourceNetMsg(string.format("svc_CreateStringTable %s\n", tablename))
			end
		},
		-- 12
		[svc_UpdateStringTable] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(svc_UpdateStringTable, NET_MESSAGE_BITS)
				local tableid = read:ReadUInt(MAX_TABLES_BITS)
				write:WriteUInt(tableid, MAX_TABLES_BITS)
				local morechanged = read:ReadBit()
				write:WriteBit(morechanged)
				local changed = 1

				if morechanged == 1 then
					changed = read:ReadWord()
					write:WriteWord(changed)
				end

				local bits = read:ReadUInt(20)
				write:WriteUInt(bits, 20)
				local data = read:ReadBits(bits)
				write:WriteBits(data)
				SourceNetMsg(string.format("svc_UpdateStringTable tableid=%i,morechanged=%i,changed=%i,bits=%i\n", tableid, morechanged, changed, bits))
			end
		},
		-- 13
		[svc_VoiceInit] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(svc_VoiceInit, NET_MESSAGE_BITS)
				local codec = read:ReadString()
				write:WriteString(codec)
				local quality = read:ReadByte()
				write:WriteByte(quality)
				SourceNetMsg(string.format("svc_VoiceInit codec=%s,quality=%i\n", codec, quality))
			end
		},
		-- 14
		[svc_VoiceData] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(svc_VoiceData, NET_MESSAGE_BITS)
				local client = read:ReadByte()
				write:WriteByte(client)
				local proximity = read:ReadByte()
				write:WriteByte(proximity)
				local bits = read:ReadWord()
				write:WriteWord(bits)
				local voicedata = read:ReadBits(bits)
				write:WriteBits(voicedata)
				SourceNetMsg(string.format("svc_VoiceData client=%i,proximity=%i,bits=%i\n", client, proximity, bits))
			end
		},
		-- 15
		[svc_Sounds] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(svc_Sounds, NET_MESSAGE_BITS)
				local reliable = read:ReadBit()
				write:WriteBit(reliable)
				local num
				local bits

				if reliable == 0 then
					num = read:ReadUInt(8)
					write:WriteUInt(num, 8)
					bits = read:ReadUInt(16)
					write:WriteUInt(bits, 16)
				else
					num = 1
					bits = read:ReadUInt(8)
					write:WriteUInt(bits, 8)
				end

				local data = read:ReadBits(bits)
				write:WriteBits(data)
				SourceNetMsg(string.format("svc_Sounds reliable=%i,num=%i,bits=%i\n", reliable, num, bits))
			end
		},
		-- 17
		[svc_SetView] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(svc_SetView, NET_MESSAGE_BITS)
				local viewent = read:ReadUInt(MAX_EDICT_BITS)
				write:WriteUInt(viewent, MAX_EDICT_BITS)
				SourceNetMsg(string.format("svc_SetView viewent=%i\n", viewent))
			end
		},
		-- 18
		[svc_FixAngle] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(svc_FixAngle, NET_MESSAGE_BITS)
				local relative = read:ReadBit()
				write:WriteBit(relative)
				local x = read:ReadBitAngle(16)
				write:WriteBitAngle(x, 16)
				local y = read:ReadBitAngle(16)
				write:WriteBitAngle(y, 16)
				local z = read:ReadBitAngle(16)
				write:WriteBitAngle(z, 16)
				SourceNetMsg(string.format("svc_FixAngle relative=%i,x=%i,y=%i,z=%i\n", relative, x, y, z))
			end
		},
		-- 19
		[svc_CrosshairAngle] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(svc_CrosshairAngle, NET_MESSAGE_BITS)
				local p = read:ReadBitAngle(16) or 0
				write:WriteBitAngle(p, 16)
				local y = read:ReadBitAngle(16) or 0
				write:WriteBitAngle(y, 16)
				local r = read:ReadBitAngle(16) or 0
				write:WriteBitAngle(r, 16)
				SourceNetMsg(string.format("svc_CrosshairAngle p=%i,y=%i,r=%i\n", p, y, r))
			end
		},
		-- 20
		[svc_BSPDecal] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(svc_BSPDecal, NET_MESSAGE_BITS)
				local pos = read:ReadVector()
				write:WriteVector(pos)
				local texture = read:ReadUInt(9)
				write:WriteUInt(texture, 9)
				local useentity = read:ReadBit()
				write:WriteBit(useentity)
				local ent
				local modulation

				if useentity == 1 then
					ent = read:ReadUInt(MAX_EDICT_BITS)
					write:WriteUInt(ent, MAX_EDICT_BITS)
					modulation = read:ReadUInt(12)
					write:WriteUInt(modulation, 12)
				else
					ent = 0
					modulation = 0
				end

				local lowpriority = read:ReadBit()
				write:WriteBit(lowpriority)
				SourceNetMsg(string.format("svc_BSPDecal %s, %d, %d, %d, %d, %d\n", tostring(pos), texture, useentity, ent, modulation, lowpriority))
			end
		},
		-- 21
		[svc_UserMessage] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(svc_UserMessage, NET_MESSAGE_BITS)
				local msgtype = read:ReadByte()
				write:WriteByte(msgtype)
				local bits = read:ReadUInt(MAX_USERMESSAGE_BITS)
				write:WriteUInt(bits, MAX_USERMESSAGE_BITS)

				if bits > 0 then
					local data = read:ReadBits(bits)
					write:WriteBits(data)
				end

				SourceNetMsg(string.format("svc_UserMessage msgtype=%i,bits=%i\n", msgtype, bits))
			end
		},
		-- 23
		[svc_EntityMessage] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(svc_EntityMessage, NET_MESSAGE_BITS)
				local entity = read:ReadUInt(MAX_EDICT_BITS)
				write:WriteUInt(entity, MAX_EDICT_BITS)
				local class = read:ReadUInt(MAX_SERVER_CLASS_BITS)
				write:WriteUInt(class, MAX_SERVER_CLASS_BITS)
				local bits = read:ReadUInt(MAX_ENTITYMESSAGE_BITS)
				write:WriteUInt(bits, MAX_ENTITYMESSAGE_BITS)
				local data = read:ReadBits(bits)
				write:WriteBits(data)
				SourceNetMsg(string.format("svc_EntityMessage entity=%i,class=%i,bits=%i\n", entity, class, bits))
			end
		},
		-- 24
		[svc_GameEvent] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(svc_GameEvent, NET_MESSAGE_BITS)
				local bits = read:ReadUInt(11)
				write:WriteUInt(bits, 11)
				local data = read:ReadBits(bits)
				write:WriteBits(data)
				SourceNetMsg(string.format("svc_GameEvent bits=%i\n", bits))
			end
		},
		-- 25
		[svc_PacketEntities] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(svc_PacketEntities, NET_MESSAGE_BITS)
				local max = read:ReadUInt(MAX_EDICT_BITS)
				write:WriteUInt(max, MAX_EDICT_BITS)
				local isdelta = read:ReadBit()
				write:WriteBit(isdelta)
				local delta = -1

				if isdelta == 1 then
					delta = read:ReadLong()
					write:WriteLong(delta)
				end

				local baseline = read:ReadUInt(1)
				write:WriteUInt(baseline, 1)
				local changed = read:ReadUInt(MAX_EDICT_BITS)
				write:WriteUInt(changed, MAX_EDICT_BITS)
				local bits = read:ReadUInt(24)
				write:WriteUInt(bits, 24)
				local updatebaseline = read:ReadBit()
				write:WriteBit(updatebaseline)
				local data = read:ReadBits(bits)
				write:WriteBits(data)
				SourceNetMsg(string.format("svc_PacketEntities %i,%i,%i,%i,%i,%i,%i\n", max, isdelta, delta, baseline, changed, bits, updatebaseline))
			end
		},
		-- 26
		[svc_TempEntities] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(svc_TempEntities, NET_MESSAGE_BITS)
				local num = read:ReadUInt(8)
				write:WriteUInt(num, 8)
				--local bits = read:ReadUInt(20)
				--write:WriteUInt(bits, 20)
				local bits = read:ReadVarInt32()
				write:WriteVarInt32(bits)
				local data = read:ReadBits(bits)
				write:WriteBits(data)
				SourceNetMsg(string.format("svc_TempEntities %i,%i\n", num, bits))
			end
		},
		-- 27
		[svc_Prefetch] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(svc_Prefetch, NET_MESSAGE_BITS)
				local index = read:ReadUInt(14)
				write:WriteUInt(index, 14)
				SourceNetMsg(string.format("svc_Prefetch index=%i\n", index))
			end
		},
		-- 28
		[svc_Menu] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(svc_Menu, NET_MESSAGE_BITS)
				local menutype = read:ReadShort()
				write:WriteShort(menutype)
				local bytes = read:ReadWord()
				write:WriteWord(bytes)
				local data = read:ReadBytes(bytes)
				write:WriteBytes(data, bytes)
				SourceNetMsg(string.format("svc_Menu menutype=%i,bytes=%i\n", menutype, bytes))
			end
		},
		-- 29
		[svc_GameEventList] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(svc_GameEventList, NET_MESSAGE_BITS)
				local num = read:ReadUInt(9)
				write:WriteUInt(num, 9)
				local bits = read:ReadUInt(20)
				write:WriteUInt(bits, 20)
				local data = read:ReadBits(bits)
				write:WriteBits(data)
				SourceNetMsg(string.format("svc_GameEventList num=%i,bits=%i\n", num, bits))
			end
		},
		-- 30
		[svc_GetCvarValue] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(svc_GetCvarValue, NET_MESSAGE_BITS)
				local cookie = read:ReadInt(32)
				write:WriteInt(cookie, 32)
				local cvarname = read:ReadString()
				write:WriteString(cvarname)
				SourceNetMsg(string.format("svc_GetCvarValue cvarname=%s\n", cvarname))
			end
		},
		-- 31
		[svc_CmdKeyValues] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(svc_CmdKeyValues, NET_MESSAGE_BITS)
				local length = read:ReadLong()
				write:WriteLong(length)
				local keyvalues = read:ReadBits(length * 8)
				write:WriteBits(keyvalues)
				SourceNetMsg(string.format("svc_CmdKeyValues length=%i\n", length))
			end
		},
		-- 32
		[svc_GMod_ServerToClient] = {
			DefaultCopy = function(netchan, read, write)
				write:WriteUInt(svc_GMod_ServerToClient, NET_MESSAGE_BITS)
				local bits = read:ReadUInt(20)
				write:WriteUInt(bits, 20)
				local msgtype = read:ReadByte()
				write:WriteByte(msgtype)
				bits = bits - 8

				if msgtype == 0 then
					local id = read:ReadWord()
					write:WriteWord(id)
					bits = bits - 16

					if bits > 0 then
						local data = read:ReadBits(bits)
						write:WriteBits(data)
					end

					SourceNetMsg(string.format("svc_GMod_ServerToClient netmessage bits=%i,id=%i/%s\n", bits, id, util.NetworkIDToString(id) or "unknown message"))
				elseif msgtype == 1 then
					local path = read:ReadString()
					write:WriteString(path)
					local length = read:ReadUInt(32)
					write:WriteUInt(length)
					local data = read:ReadBytes(length)
					write:WriteBytes(data)
					SourceNetMsg(string.format("svc_GMod_ServerToClient auto-refresh length=%i,path=%s\n", length, path))
				elseif msgtype == 3 then
					SourceNetMsg(string.format("svc_GMod_ServerToClient GModDataPack::RequestFiles bits=%i\n", bits))
				elseif msgtype == 4 then
					local length = read:ReadUInt(16)
					write:WriteUInt(length, 16)
					local data = read:ReadBytes(length)
					write:WriteBytes(data)
					SourceNetMsg(string.format("svc_GMod_ServerToClient GModDataPack::UpdateFile length=%i\n", length))
				end
			end
		},
	}
}
-- 33
--[[NET_MESSAGES = {
	[net_NOP] = {
		DefaultCopy = function(netchan, read, write)
			write:WriteUInt(net_NOP, NET_MESSAGE_BITS)
		end
	},

	[net_Disconnect] = {
		DefaultCopy = function(netchan, read, write)
			write:WriteUInt(net_Disconnect, NET_MESSAGE_BITS)

			local reason = read:ReadString()
			write:WriteString(reason)

			SourceNetMsg(string.format("net_Disconnect %s\n", reason))
		end
	},

	[net_File] = {
		DefaultCopy = function(netchan, read, write)
			write:WriteUInt(net_File, NET_MESSAGE_BITS)

			local transferid = read:ReadUInt(32)
			write:WriteUInt(transferid, 32)

			local requested = read:ReadBit()
			write:WriteBit(requested)

			if requested == 0 then
				SourceNetMsg(string.format("net_File %i,false\n", transferid))
				return
			end

			local requesttype = read:ReadUInt(1)
			write:WriteUInt(requesttype, 1)

			local fileid = read:ReadUInt(32)
			write:WriteUInt(fileid, 32)

			SourceNetMsg(string.format("net_File %i,true,%i,%i\n", transferid, requesttype, fileid))
		end
	},

	CLC = {},

	SVC = {}
}

local function AddNetMessage(tbl, type)
	local netmessage = INetMessage(type)
	tbl[type] = {
		DefaultCopy = function(netchan, read, write)
			if not netmessage:ReadFromBuffer(read) then
				print("failed to read " .. netmessage)
				return
			end

			if not netmessage:WriteToBuffer(write) then
				print("failed to write " .. netmessage)
				return
			end

			SourceNetMsg(tostring(netmessage) .. "\n")
		end
	}
end

AddNetMessage(NET_MESSAGES, net_Tick)
AddNetMessage(NET_MESSAGES, net_StringCmd)
AddNetMessage(NET_MESSAGES, net_SetConVar)
AddNetMessage(NET_MESSAGES, net_SignonState)

AddNetMessage(NET_MESSAGES.SVC, svc_ServerInfo)
AddNetMessage(NET_MESSAGES.SVC, svc_SendTable)
AddNetMessage(NET_MESSAGES.SVC, svc_ClassInfo)
AddNetMessage(NET_MESSAGES.SVC, svc_SetPause)
AddNetMessage(NET_MESSAGES.SVC, svc_CreateStringTable)
AddNetMessage(NET_MESSAGES.SVC, svc_UpdateStringTable)
AddNetMessage(NET_MESSAGES.SVC, svc_VoiceInit)
AddNetMessage(NET_MESSAGES.SVC, svc_VoiceData)
AddNetMessage(NET_MESSAGES.SVC, svc_Print)
AddNetMessage(NET_MESSAGES.SVC, svc_Sounds)
AddNetMessage(NET_MESSAGES.SVC, svc_SetView)
AddNetMessage(NET_MESSAGES.SVC, svc_FixAngle)
AddNetMessage(NET_MESSAGES.SVC, svc_CrosshairAngle)
AddNetMessage(NET_MESSAGES.SVC, svc_BSPDecal)
AddNetMessage(NET_MESSAGES.SVC, svc_UserMessage)
AddNetMessage(NET_MESSAGES.SVC, svc_EntityMessage)
AddNetMessage(NET_MESSAGES.SVC, svc_GameEvent)
AddNetMessage(NET_MESSAGES.SVC, svc_PacketEntities)
AddNetMessage(NET_MESSAGES.SVC, svc_TempEntities)
AddNetMessage(NET_MESSAGES.SVC, svc_Prefetch)
AddNetMessage(NET_MESSAGES.SVC, svc_Menu)
AddNetMessage(NET_MESSAGES.SVC, svc_GameEventList)
AddNetMessage(NET_MESSAGES.SVC, svc_GetCvarValue)
AddNetMessage(NET_MESSAGES.SVC, svc_CmdKeyValues)
AddNetMessage(NET_MESSAGES.SVC, svc_GMod_ServerToClient)

AddNetMessage(NET_MESSAGES.CLC, clc_ClientInfo)
AddNetMessage(NET_MESSAGES.CLC, clc_Move)
AddNetMessage(NET_MESSAGES.CLC, clc_VoiceData)
AddNetMessage(NET_MESSAGES.CLC, clc_BaselineAck)
AddNetMessage(NET_MESSAGES.CLC, clc_ListenEvents)
AddNetMessage(NET_MESSAGES.CLC, clc_RespondCvarValue)
AddNetMessage(NET_MESSAGES.CLC, clc_FileCRCCheck)
AddNetMessage(NET_MESSAGES.CLC, clc_CmdKeyValues)
AddNetMessage(NET_MESSAGES.CLC, clc_FileMD5Check)
AddNetMessage(NET_MESSAGES.CLC, clc_GMod_ClientToServer)]]
