	
local _P = {
	Name	= "lua/includes/extensions/net.lua",
	--NoFake	= true,
	
	Top		= string.EatNewlines([[
		if net.Incoming and net.Receive then return end;
		local NotTS 					= timer.Simple
		local lower 					= string.lower
		local net_ReadHeader 			= net.ReadHeader
		local util_NetworkIDToString 	= util.NetworkIDToString
		local NotDGE					= debug.getinfo
		local NBS						= nil
	]], true),
	
	Replace = {
		{"util.NetworkIDToString( i )", "util_NetworkIDToString(i)"},
		{"net.ReadHeader()", 			"net_ReadHeader()"},
		{"local func =", 				"if strName == 'netburst' then NBS(len - 16, client) return end\n\tlocal func ="},
		{"[ strName:lower() ]", 		"[ lower(strName) ]"},
	},
	
	Bottom	= string.Obfuscate([[
		local OneTimeID = {}
		local Max		= 8650
		local MaxChunks	= 990
		local Wait		= 0.3
		local WaitSmall	= 0.18
		local CommonID	= "netburst"
		local lower		= lower
		local _G 		= _G
		local CLIENT	= _G.CLIENT
		local SERVER	= (not CLIENT)
		local NULL		= _G.NULL
		local pairs		= _G.pairs
		local type		= _G.type
		local tostring	= _G.tostring
		local NotDGE	= _G.debug.getinfo
		local NotTS 	= NotTS
		local NotTC		= _G.timer.Create
		local os_Time 	= _G.os.time
		local IsValid	= function(ent) return ent and ent != NULL end
		local NotTIS	= function(k,v) k[#k+1] = v end
		_G.net.DEBUG 	= false
		
		local util 		= {
			["TableToJSON"] 	= _G.util.TableToJSON,
			["JSONToTable"] 	= _G.util.JSONToTable,
			["Base64Encode"] 	= _G.util.Base64Encode,
			["Compress"] 		= _G.util.Compress,
			["Decompress"]		= _G.util.Decompress,
		}
		
		local net		= {	
			["Start"] 			= _G.net.Start,
			["ReadString"] 		= _G.net.ReadString,
			["ReadDouble"] 		= _G.net.ReadDouble,
			["SendToServer"] 	= _G.net.SendToServer,
			["Send"] 			= _G.net.Send,
			["Broadcast"]		= _G.net.Broadcast,
			["WriteString"] 	= _G.net.WriteString,
			["WriteDouble"] 	= _G.net.WriteDouble,
			["Incoming"] 		= _G.net.Incoming,
			["Receive"] 		= _G.net.Receive,
		}
		
		local string	= {
			["sub"] 			= _G.string.sub,
			["gsub"] 			= _G.string.gsub,
			["find"] 			= _G.string.find,
			["char"] 			= _G.string.char,
		}
		
		
		--Base64
		local Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
		local function base64_dec(data)
			data = string.gsub(data, '[^'..Chars..'=]', '')
			
			data = string.gsub(data, '.', function(x)
				if x == '=' then return '' end
				local r,f='',( string.find(Chars,x) - 1 )
				for i=6,1,-1 do
					r = r..( f % 2 ^ i - f % 2 ^ (i-1) > 0 and '1' or '0' )
				end
				return r
			end)
			
			data = string.gsub(data, '%d%d%d?%d?%d?%d?%d?%d?', function(x)
				if #x ~= 8 then return '' end
				local c = 0
				for i=1,8 do
					c = c + ( string.sub(x,i,i)=='1' and 2 ^ (8-i) or 0 )
				end
				return string.char(c)
			end)
			return data
		end
		_G.net.base64_dec = base64_dec
		
		
		--Hook
		local Hooks = {}
		local function Hook(sID, Finish,Update,Start)
			local Where = (NotDGE(2).short_src or "Gone")
			if not Finish then
				ErrorNoHalt("Hook: "..sID..", no Finish! ["..Where.."]\n")
				return
			end
			if Hooks[ sID ] then
				if CLIENT then
					ErrorNoHalt("Error 0, "..sID.." ["..Where.."]\n")
					return
				else
					ErrorNoHalt("Hook: "..sID.." OVERRIDEN from: "..Where.."\n")
				end
			end
			
			Hooks[ sID ] = {
				Finish	= Finish,
				Update	= Update,
				Start	= Start,
			}
		end
		_G.net.Hook = Hook
		
		
		--Check fake
		local Buff = {}
		local function CheckFakeStream(sID,tab,Split,Total,str,ply)	
			local Bad = ""
			
			if #tab.Cont > 2000000 then
				Bad = Bad.."Cont("..#tab.Cont..") > 2000000,"
			end
			
			if #str > Max then
				Bad = Bad.."#str("..#str..") > Max("..Max.."),"
			end	
			if Total > MaxChunks then
				Bad = Bad.."Total("..Total..") > MaxChunks("..MaxChunks.."),"
			end
			if Split > MaxChunks then
				Bad = Bad.."Split("..Split..") > MaxChunks("..MaxChunks.."),"
			end
			if Split > Total then
				Bad = Bad.."Split("..Split..") > Total("..Total.."),"
			end
			
			if Bad != "" then
				if SERVER then
					hook.Run(CommonID, ply, "NetBurst error '"..sID.."' failed: "..Bad, 1)
					return
				end
				ErrorNoHalt("Error 1, '"..sID.."' failed: "..Bad.."\n")
				
				return true
			end
		end
		
		
		--Receive
		local function InternalReceive(len,ply) --Shared
			local idx 		= net.ReadString()
			local sID 		= net.ReadString()
			local Split 	= net.ReadDouble()
			local Total 	= net.ReadDouble()
			local Rem		= net.ReadDouble()
			local str 		= net.ReadString()
			
			local IsValid 	= IsValid(ply)
			if IsValid then
				ply.HAC_BurstRem = Rem
			end
			
			--Same IDX as a previous stream
			if OneTimeID[ idx ] then
				if IsValid then
					if SERVER then
						hook.Run(CommonID, ply, "NetBurst OneTimeID: '"..sID.."', '"..idx.."'", 2)
					end
				else
					ErrorNoHalt("Error 2, '"..sID.."', '"..idx.."'\n")
				end
				return
			end
			
			--IF NOT HANDLED
			if not (Hooks[ sID ] and Hooks[ sID ].Finish) then
				if IsValid then
					if SERVER then
						hook.Run(CommonID, ply, "Unhandled: '"..sID.."'", 3)
					end
				else
					ErrorNoHalt("Error 3, '"..sID.."'\n")
				end
				return
			end
			
			if _G.net.DEBUG then
				print("! splits: ", sID, Split.."/"..Total, " Rem: "..Rem)
			end
			
			
			if not Buff[ idx ] then
				Buff[ idx ]	= {
					Cont 	= "",
					Total	= Total,
				}
				
				--START STREAM
				if SERVER and Hooks[ sID ].Start then
					local ret,err = pcall(function()
						Hooks[ sID ].Start(sID,idx,Split,Total, ply)
					end)
					if err then
						ErrorNoHalt("Start '"..sID.."' failed: "..err.."\n")
					end
				end
			end
			Buff[ idx ].Cont = Buff[ idx ].Cont..str
			
			--UPDATE STREAM
			if SERVER and Hooks[ sID ].Update then
				local ret,err = pcall(function()
					Hooks[ sID ].Update(sID,idx,Split,Total, Buff[ idx ], ply)
				end)
				if err then
					ErrorNoHalt("Update '"..sID.."' failed: "..err.."\n")
				end
			end
			
			--CHECK FAKE
			if CheckFakeStream(sID, Buff[ idx ],Split,Total,str, ply) then
				Buff[ idx ] = nil
				return
			end
			
			
			if Split == Buff[ idx ].Total then
				OneTimeID[ idx ] = true --Used
				
				--B64 DECODE
				local Cont = base64_dec( Buff[ idx ].Cont )
				if not Cont then
					if SERVER and IsValid then
						hook.Run(CommonID, ply, "NetBurst hook '"..sID.."' No Cont64", 4)
					end
					ErrorNoHalt("Error 4, '"..sID.."'\n")
					
					Buff[ idx ] = nil
					return
				end
				
				--DECOMPRESS
				Cont = util.Decompress(Cont)
				if not Cont then
					if SERVER and IsValid then
						hook.Run(CommonID, ply, "NetBurst hook '"..sID.."' No ContLZ", 5)
					end
					ErrorNoHalt("Error 5, '"..sID.."'\n")
					
					Buff[ idx ] = nil
					return
				end
				
				
				if _G.net.DEBUG then
					print("! got Buff[idx], Cont: ", sID, #Buff[ idx ].Cont, #Cont)
				end
				Buff[ idx ] = nil
				
				--CALL FINISH
				local ret,err = pcall(function()
					Hooks[ sID ].Finish(Cont,len,sID,idx,Total,ply)
				end)
				if err then
					if SERVER and IsValid then
						hook.Run(CommonID, ply, "NetBurst hook '"..sID.."' failed: "..err, 6)
					end
					ErrorNoHalt("Error 6, '"..sID.."' : "..err.."\n")
				end
				Cont = nil
				
			elseif Split > Buff[ idx ].Total then
				OneTimeID[ idx ] = true
				
				if IsValid then
					if SERVER then
						hook.Run(CommonID, ply, "Split > Buff[ idx ].Total '"..sID.."'", 7)
					end
				else
					ErrorNoHalt("Error 7, '"..sID.."'\n")
				end
			end
		end
		NBS = InternalReceive
		
		
		--Split string
		local function SplitString(str)
			local Tab = {}
			
			local len = #str
			local Upt = 0
			while Upt * Max < len do
				Tab[ Upt + 1 ] = string.sub(str, Upt * Max + 1, ( Upt + 1) * Max )
				Upt = Upt + 1
			end
			return Tab, #Tab
		end
		_G.net.SplitString = SplitString
		
		
		--Out
		local function SendThis(ply,sID)
			if CLIENT then
				net.SendToServer()
			else
				if ply then
					if IsValid(ply) then
						net.Send(ply)
					else
						if _G.net.DEBUG then ErrorNoHalt("NetBurst.SendThis("..sID.."), NULL player!\n") end
					end
				else
					net.Broadcast()
				end
			end
		end
		
		local Sending = {}
		local Sending_Small = {}
		local function OutBurst()
			local Idx  	= nil
			local This 	= nil
			local Now  	= nil
			local Rem	= -1
			
			--High
			for k,v in pairs(Sending) do
				Rem = Rem + 1
				
				if v.Now and not Now then
					Now	 = true
					Idx  = k
					This = v
				end
			end
			
			--Count
			for k,v in pairs(Sending_Small) do
				Rem = Rem + 1
			end
			
			--Low
			if not Now then
				for k,v in pairs(Sending) do
					Idx  = k
					This = v
					break
				end
			end
			
			if Idx and This then
				if SERVER and _G.net.DEBUG then
					print("! send: ", This.idx, This.Split.."/"..This.Total, "sID: ", This.sID)
				end
				
				net.Start(CommonID)
					net.WriteString(This.idx)	--UID
					net.WriteString(This.sID)	--Stream ID
					net.WriteDouble(This.Split)	--This split
					net.WriteDouble(This.Total)	--of Total splits
					net.WriteDouble(Rem)		--All remaining packets
					net.WriteString(This.Chunk)	--Packet
				SendThis(This.ply, This.sID)
				
				Sending[ Idx ] = nil
			end
		end
		
		local function OutBurst_Small()
			local Idx  	= nil
			local This 	= nil
			local Rem	= -1
			
			for k,v in pairs(Sending_Small) do
				Rem = Rem + 1
				Idx  = k
				This = v
				break
			end
			
			--Count
			for k,v in pairs(Sending) do
				Rem = Rem + 1
			end
			
			if Idx and This then
				if SERVER and _G.net.DEBUG then
					print("! send Small: ", This.idx, This.Split.."/"..This.Total, "sID: ", This.sID)
				end
				
				net.Start(CommonID)
					net.WriteString(This.idx)
					net.WriteString(This.sID)
					net.WriteDouble(This.Split)
					net.WriteDouble(This.Total)
					net.WriteDouble(Rem)
					net.WriteString(This.Chunk)
				SendThis(This.ply, This.sID)
				
				Sending_Small[ Idx ] = nil
			end
		end
		
		
		--Remaining
		local function Remaining()
			local Total = 0
			for k,v in pairs(Sending) do Total = Total + 1 end
			for k,v in pairs(Sending_Small) do Total = Total + 1 end
			return Total
		end
		_G.net.Remaining = Remaining
		
		
		--Main timer
		if SERVER then
			_G.net.InternalReceive 		= InternalReceive
			_G.net.CheckFakeStream 		= CheckFakeStream
			_G.net.SendThis 			= SendThis
			_G.net.Hooks 				= Hooks
			_G.net.Buff 				= Buff
			_G.net.Sending				= Sending
			_G.net.Sending_Small		= Sending_Small
			_G.net.OutBurst 			= OutBurst
			_G.net.OutBurst_Small 		= OutBurst_Small
			
			NotTC("NetBurst", 		Wait, 		0, OutBurst)
			NotTC("OutBurst_Small",	WaitSmall,	0, OutBurst_Small)
		else
			local function EatTimer()
				NotTS(Wait, EatTimer)
				OutBurst()
			end
			NotTS(2, EatTimer)
			
			local function EatTimer_Small()
				NotTS(WaitSmall, EatTimer_Small)
				OutBurst_Small()
			end
			NotTS(5, EatTimer_Small)
		end
		
		
		
		--Send
		local Last = os_Time()
		local function Send(sID,str,ply,uID,Now,Small)
			Last = Last + 8 + #str + #sID
			
			str = util.Compress(str)
			if not str then
				ErrorNoHalt("Error 8, ("..sID..",str,"..tostring(ply)..")\n")
				return
			end
			
			str = util.Base64Encode(str)
			if not str then
				ErrorNoHalt("Error 9, ("..sID..",str,"..tostring(ply)..")\n")
				return
			end
			
			local Tab,Total = SplitString(str)
			local idx = tostring(uID or (Small and "HBs" or "HB"))..Last
			
			for Split,Chunk in pairs(Tab) do
				NotTIS((Small and Sending_Small or Sending), {
						idx 	= idx,
						sID 	= sID,
						Split 	= Split,
						Total 	= Total,
						Chunk 	= Chunk,
						ply		= ply,
						Now		= Now,
					}
				)
			end
			
			return idx
		end
		_G.net.SendEx = Send
		
		
		
		--Idiots
		local function Check()
			NotTS(1, Check)
			if _G and _G.net then
				_G.net.SendEx 		= Send
				_G.net.Hook 		= Hook
				_G.net.base64_dec 	= base64_dec
				_G.net.Remaining 	= Remaining
				
				_G.net.Start		= net.Start
				_G.net.Send			= net.Send
				_G.net.SendToServer	= net.SendToServer
				_G.net.WriteString	= net.WriteString
				_G.net.Incoming		= net.Incoming
				_G.net.Receive		= net.Receive
			end
		end
		NotTS(1, Check)
		net.Recieve = function(s) return net.Receivers[s] end
		
	]], true, "local"),
}
return _P

