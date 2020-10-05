--[GTL] I'M IN YOUR LUA! STEALING YOUR HAX...

----Server Check
if (SERVER) then
	return
end

require("koof") --GGeeeee

-----Functions and Libraries
---Localizing *FIX THIS* not fully implemented
local pairs = pairs
local FindMetaTable = FindMetaTable
local tostring = tostring
local math = math
local ScrW = surface.ScreenWidth
local ScrH = surface.ScreenHeight


---Prototyping
local info, dbug = {}, {}


---lhook - Lua Hooking Library
local lhook = {}
lhook.hooks = {} --FORMAT: hooks[otable][oname] = {otable, oname, ofunc, lfunc, hks[hname] = hfunc}

--Removes hook to gtable[gname] under hname.
function lhook.remove(gtable, gname, hname)
	lhook.hooks[gtable][gname].hks[hname] = nil
end

--add - adds a hook to gtable[gname] so that hfunc is ran under hname.
function lhook.add(gtable, gname, hname, hfunc, hafter, hreturn)
	if (lhook.hooks[gtable] == nil) then
		lhook.hooks[gtable] = {}
	end
	if (lhook.hooks[gtable][gname] == nil) then
		--Lambdize func
		local lhkt = {}
		lhkt.otable = gtable
		lhkt.oname = gname
		lhkt.ofunc = gtable[gname]
		lhkt.hks = {}
		
		local function e(err_msg)
			print(
				"\n\nlhook - Error in " .. gname .. " hook " .. ch .. ".\n" ..
				err_msg
				.. "\n\n"
			)
			
			dbug:add({Color(0, 240, 127), "lhook - Error in " .. gname .. " hook " .. ch .. ". Check console for details."})
			
			lhook.remove(gtable, gname, ch)
		end
		
		local function ba(bab, arg)
			local ret = nil
			
			for ch, ht in pairs(lhkt.hks) do
				if (ht.hbefore == bab) then
					local hf = ht.hfunc
					
					_, rot = xpcall(hf, e, unpack(arg))
					
					if (ret == nil && ht.hreturn) then
						ret = rot
					end
				end
			end
			
			return ret
		end
		
		lhkt.lfunc = function(...)
			local arg = {...}
			
			local ret = nil
			
			ret = ba(false, arg)
			
			local r = lhkt.ofunc(unpack(arg))
			
			local rot = ba(true, arg)
			if (ret == nil) then
				ret = rot
			end
			
			if (ret == nil) then
				return r
			else
				return ret
			end
		end
		
		gtable[gname] = lhkt.lfunc
		
		lhook.hooks[gtable][gname] = lhkt
	end
	
	lhook.hooks[gtable][gname].hks[hname] = {hfunc = hfunc, hbefore = hbefore || false, hreturn = hreturn || false}
end

--Removes all hooks from gtable[gname] and restores original function.
function lhook.removeall(gtable, gname)
	local lhk = lhook.hooks[gtable][gname]
	if (lhk) then
		lhk.otable[lhk.oname] = lhk.ofunc
		table.remove(lhook.hooks[gtable], gname)
		if (lhook.hooks[gtable] == {}) then
			lhook.hooks[gtable] = nil
		end
	end
end


---dhook - Detour Hooking Library
local dhook = {}

function dhook.add(efunc, hname, hfunc, hafter, hreturn)
	local function lgmfunc(gm, ...)
		local arg = {...}
		hfunc(unpack(arg))
	end
	
	lhook.add(GAMEMODE, efunc, hname, lgmfunc, hafter, hreturn)
end

function dhook.remove(efunc, hname)
	lhook.remove(GAMEMODE, efunc, hname)
end


---Paint Library
local paint = {}

--SetFont
function paint.SetFont(name)
	surface.SetFont(name)
end

--SetColorText - Set Text Color Alias
function paint.SetColorText(color)
	surface.SetTextColor(color)
end

--SetColorDraw - Set Draw Color Alias
function paint.SetColorDraw(color)
	surface.SetDrawColor(color)
end

--SetColor - Alias for Set Color [Text & Draw]
function paint.SetColor(color)
	paint.SetColorText(color)
	paint.SetColorDraw(color)
end

--SetTexture
function paint.SetTexture(name)
	surface.SetTexture(surface.GetTextureID(name))
end

--SetMaterial
function paint.SetMaterial(name)
	surface.SetMaterial(Material(name))
end

--GetTextSize - Gets size of a paticalar string in [name | current] font.
function paint.GetTextSize(text, name)
	if (name != nil) then
		paint.SetFont(name)
	end
	
	return surface.GetTextSize(text)
end

--Cache Font Sizes
paint.FontSizeCache = {}
paint.FontSizeCChar = "Z"

--GetFontSize - Uses GetTextSize to get an idea of the font size using cchar.
function paint.GetFontSize(name)
	if (paint.FontSizeCache[name] != nil) then
		local ft = paint.FontSizeCache[name]
		return ft.w, ft.h
	end
	
	local w, h = paint.GetTextSize(paint.FontSizeCChar, name)
	
	paint.FontSizeCache[name] = {}
	paint.FontSizeCache[name].w, paint.FontSizeCache[name].h = w, h
	
	return w, h
end

--GetTextureSize - Gets the size of a Texture
function paint.GetTextureSize(name)
	return surface.GetTextureSize(surface.GetTextureID(name))
end

--CreateFont - Creates a font
function paint.CreateFont(name, font, size, outline, weight, antialias, shadow, blur, additive)
	surface.CreateFont(
		name,
		{
			font = font || "Arial",
			size = size || "8",
			outline = outline || false,
			weight = weight || 400,
			antialias = antialias || false,
			shadow = shadow || false,
			blur = blur || 0,
			additive = additive || false
		}
	)
end

--Alignment constants
paint.TA_CT = 0
paint.TA_BR = 1

--GetAlignedPos - To emulate draw's alignment capability. Except not derp.
function paint.GetAlignedPos(x, y, w, h, xalign, yalign)
	if (xalign == paint.TA_CT) then
		x = x - (w / 2)
	elseif (xalign == paint.TA_BR) then
		x = x - w
	end
	
	if (xalign == paint.TA_CT) then
		y = y - (h / 2)
	elseif (xalign == paint.TA_BR) then
		y = y - h
	end
	
	return x, y
end

--DrawText - Draws text at x,y with color, font, and will change pos to meet xalign/yalign
function paint.DrawText(text, x, y, color, font, xalign, yalign)
	if (color) then
		paint.SetColorText(color)
	end
	
	if (font) then
		paint.SetFont(font)
	end
	
	if (xalign || yalign) then
		local w, h = paint.GetFontSize(font)
		x, y = paint.GetAlignedPos(x, y, w, h, xalign, yalign)
	end
	
	surface.SetTextPos(x, y)
	surface.DrawText(text)
end

--DrawLine - Draws a line from x1,y1 to x2,y2 with color
function paint.DrawLine(x1, y1, x2, y2, color)
	if (color) then
		paint.SetColorDraw(color)
	end
	
	surface.DrawLine(x1, y1, x2, y2)
end

--DrawCircle - Alias for surface.DrawCircle, the one surface function that takes a color. why? donteven
function paint.DrawCircle(x, y, r, color)
	surface.DrawCircle(x, y, r, color)
end

--DrawPoly - Draws table t's polygon with color
function paint.DrawPoly(t, color)
	if (color) then
		paint.SetColorDraw(color)
	end
	
	surface.DrawPoly(t)
end

--DrawRect - Draw a rectangle with color
function paint.DrawRect(x, y, w, h, color)
	if (color) then
		paint.SetColorDraw(color)
	end
	
	surface.DrawRect(x, y, w, h)
end

--DrawRectOutlined - Draw an outlined rectangle with color
function paint.DrawRectOutlined(x, y, w, h, color)
	if (color) then
		paint.SetColorDraw(color)
	end
	
	surface.DrawOutlinedRect(x, y, w, h)
end

--DrawRectTextured - Draw textured rectangle with color and texture
function paint.DrawRectTextured(x, y, w, h, color, texture)
	if (color) then
		paint.SetColorDraw(color)
	end
	
	if (texture) then
		paint.SetTexture(texture)
	end
	
	surface.DrawTexturedRect(x, y, w, h)
end

--DrawRectTexturedUV - Draws repeated texture w/twxth in rectangle w/wxh with color and texture
function paint.DrawRectTexturedUV(x, y, w, h, tw, th, color, texture)
	if (color) then
		paint.SetColorDraw(color)
	end
	
	if (texture) then
		paint.SetTexture(texture)
	end
	
	surface.DrawTexturedRectUV(x, y, w, h, tw, th)
end

--DrawRectTexturedRotated - Draws textured rect rotated rot degrees with color and texture
function paint.DrawRectTexturedRotated(x, y, w, h, rot, color, texture)
	if (color) then
		paint.SetColorDraw(color)
	end
	
	if (texture) then
		paint.SetTexture(texture)
	end
	
	surface.DrawTexturedRectRotated(x, y, w, h, rot)
end




---Splitting strings into things
local function split(strings, sep, mask)
	local elements = string.Explode(sep, strings, false)
	
	if (mask != nil) then
		if (type(mask) == "table") then
			local lmask = mask
			mask = function(i)
				return lmask[i]
			end
		end
		
		for i, e in pairs(elements) do
			elements[i] = mask(e)
		end
	end
	
	return elements
end

--Alias for splitting comma
local function csplit(strings, mask)
	return split(strings, ",", mask)
end

--Alias for splitting comma numbra
local function ncsplit(strings)
	return csplit(strings, tonumber)
end


---Generate Random String
local function rndStringBounded(l, s, e)
	local rndstr = ""
	for i = 1, l, 1 do
		rndstr = rndstr .. string.char(Math.random(s, e))
	end
	return rndstr
end

local function rndString(l)
	return rndStringBounded(l, 33, 126)
end

--Dictionary Length
local function dictLen(t)
	local r = 0
	
	for _, _ in pairs(t) do
		r = r + 1
	end
	
	return r
end


---Trace Functions
local function GetTraceTable(start, endpos, filter, mask)
	return {start = start, endpos = endpos, filter = filter, mask = mask}
end

function GetTraceResult(start, endpos, filter, mask)
	return util.TraceLine(GetTraceTable(start, endpos, filter, mask))
end




----Derma - Pre
local dVars = {}

local function addDermaVar(key, t, r)
	local dat = split(key, "_")
	local cstring = string.Implode(">", {unpack(dat, 2)})
	
	if (!dVars[dat[1]]) then
		dVars[dat[1]] = {}
	end
	
	dVars[dat[1]][cstring] = {
		t = t,
		r = r,
		key = key
	}
end




----Prefix
local srcn = debug.getinfo(1).short_src
local prefix = (srcn:sub(5, srcn:len() - 4))




----CVars & Commands
local tVars = {}

local function cName(key)
	return prefix .. "_" .. key
end

local function cKey(name)
	return string.sub(name, string.len(prefix) + 2)
end

local function addVar(key, defval, desc, ginfo)
	if (ginfo) then
		addDermaVar(key, ginfo.t, ginfo.r)
	end
	
	local cv = cName(key)
	tVars[key] = CreateClientConVar(cv, defval, true, false)
end

local function getVar(key)
	return tVars[key]:GetString()
end

local function getVarS(key, sep, mask)
	return split(getVar(key), sep, mask)
end

local function getVarSC(key, mask)
	return csplit(getVar(key), mask)
end

local function getVarSCN(key)
	return ncsplit(getVar(key))
end

local function getVarVector(key)
	return Vector(unpack(getVarSCN(key)))
end

local function getVarInt(key)
	return tVars[key]:GetInt()
end

local function getVarFloat(key)
	return tVars[key]:GetFloat()
end

local function getVarBool(key)
	return tVars[key]:GetBool()
end

local function addCCB(key, func)
	cvars.AddChangeCallback(cName(key), func)
end

local function runVar(key, ...)
	local arg = {...}
	RunConsoleCommand(cName(key), unpack(arg))
end

local function addCom(key, func, description, autocomplete, pre)
	concommand.Add((pre || "") .. cName(key), func, autocomplete, description)
end

local function addPMComFunc(key, fpt, fmt)
	addCom(key, fpt.f, fpt.desc, nil, "+")
	addCom(key, fmt.f, fmt.desc, nil, "-")
end

local function addPMCom(pmkey, cvkey, onval, offval)
	local fpt = {desc = "generated +-"}
	local fmt = {desc = "generated +-"}
	function fpt.f()
		runVar(cvkey, onval)
	end
	function fmt.f()
		runVar(cvkey, offval)
	end
	addPMComFunc(pmkey, fpt, fmt)
end




---Timer Library
--(this is pretty much just the garry one but slightly stripped down and modified for dhook)

--Localizing
local CurTime = CurTime

local timer = {}
timer.T = {}
timer.S = {}

local PAUSED = -1
local STOPPED = 0
local RUNNING = 1

--Create - creates a timer.
function timer.Create(name, delay, reps, func)
	timer.T[name] = {
		status = STOPPED,
		delay = delay,
		repititions = reps,
		func = func,
		last = CurTime()
	}
	
	timer.Start(name)
end

--Remove - removes a timer.
function timer.Remove(name)
	timer.T[name] = nil
end

--Exists - checks if a timer exists.
function timer.Exists(name)
	return (timer.T[name] != nil)
end

--Modify - modify an existing timer's data.
function timer.Modify(name, tdat)
	if (timer.Exists(name)) then
		for key, val in pairs(tdat) do
			timer.T[name][key] = val
		end
	end
end

--Start - starts a timer.
function timer.Start(name)
	timer.T[name].n = 0
	timer.T[name].status = RUNNING
	timer.T[name].last = CurTime()
end

--Pause - pauses a timer.
function timer.Pause(name)
	if (timer.T[name].status == RUNNING) then
		timer.T[name].diff = CurTime() - timer.T[name].last
		timer.T[name].status = PAUSED
	end
end

--Unpause - unpauses a timer.
function timer.UnPause(name)
	if (timer.T[name].status == PAUSED) then
		timer.T[name].diff = nil
		timer.T[name].status = RUNNING
	end
end

--Toggle - toggles a timer's pausedness.
function timer.Toggle(name)
	if (timer.T[name].status == PAUSED) then
		timer.UnPause(name)
	elseif (timer.T[name].status == RUNNING) then
		timer.Pause(name)
	end
end

--Stop - stops a timer.
function timer.Stop(name)
	timer.T[name].status = STOPPED
end

--Simple
function timer.Simple(delay, func)
	table.insert(timer.S, {delay = delay, func = func, create = CurTime()})
end

--Check - run every frame to handle timers.
function timer.Check()
	for name, tdat in pairs(timer.T) do
		if (tdat.status == PAUSED) then
			tdat.last = CurTime() - tdat.diff
		elseif (tdat.status == RUNNING && (tdat.last + tdat.delay) <= CurTime()) then
			tdat.last = CurTime()
			tdat.n = tdat.n + 1
			
			if (tdat.n >= tdat.repititions && tdat.repititions != 0) then
				timer.Stop(name)
			end
			
			local function e(err_msg)
				print("Error on Timer '" .. name .. "':\n" .. err_msg .. "\nThe timer will be stopped.")
				dbug:add({Color(0, 240, 127), "Error on Timer '", name, "'. See console for details."})
				timer.Stop(name)
			end
			
			xpcall(tdat.func, e, nil)
		end
	end
	
	for i, sdat in pairs (timer.S) do
		if ((sdat.create + sdat.delay) <= CurTime()) then
			sdat.func()
			table.remove(timer.S, i)
		end
	end
end

dhook.add("Think", "timer.Check", timer.Check)




----Command in/outer
local function com_on(ucmd, in_val)
	return (bit.band(ucmd:GetButtons(), in_val) > 0)
end

local function com_in(ucmd, in_val)
	ucmd:SetButtons(bit.bor(ucmd:GetButtons(), in_val))
end

local function com_out(ucmd, in_val)
	--ucmd:SetButtons(bit.band(ucmd:GetButtoms(), bit.bnot(in_val)))
	if (com_on(ucmd, in_val)) then
		ucmd:SetButtons(ucmd:GetButtons() - in_val)
	end
end

local function com_tog(ucmd, in_val)
	ucmd:SetButtons(bit.bxor(ucmd:GetButtons(), in_val))
end




----Runner
local function run(p, c, a)
	for _, ca in pairs(a) do
		RunString(ca)
	end
end

addCom("run", run, "Runs lua as loadstring and run_lua_cl.")




----Font
addVar("font", "Arial", "This is the actual font.", {t = "Generic"})
addVar("font_size", 8, "This controls font size.", {t = "Float", r = {min = 2, max = 128}})
addVar("font_outline", 1, "Whether or not font is outlined.", {t = "Boolean"})

local font = {f = "THIS WOULD BE A FONT", fi = 0, h = "THIS WOULD BE ITS HEIGHT"}

local function fup(cv, pval, nval)
	if ((cv == cName("font") && true) || (cv == cName("font_size") && tonumber(nval))) then
		font.f = cName("font") .. font.fi
		font.fi = font.fi + 1
		
		paint.CreateFont(
			font.f, --Name
			getVar("font"), --Font
			getVarInt("font_size"), --Size
			getVarBool("font_outline") --Outline
		)
		
		font.w, font.h = paint.GetFontSize(font.f)
	elseif (cv == cName("font_size")) then
		RunConsoleCommand(cName("font_size"), pval)
		error("Invalid size.")
	elseif (cv == cName("font")) then
		RunConsoleCommand(cName("font"), pval)
		error("Invalid font.")
	end
end

addCCB("font", fup)
addCCB("font_size", fup)
addCCB("font_outline", fup)

--Initialize Font
fup(cName("font"), nil, nil)




----Colors
local col = {}
col.ugly = Color(223, 255, 0, 255)

col.white = Color(255, 255, 255, 255)
col.black = Color(0, 0, 0, 255)

function col.randomConstrained(rc, gc, bc, ac)
	return Color(
		math.random(rc.mi, rc.ma),
		math.random(gc.mi, gc.ma),
		math.random(bc.mi, bc.ma),
		math.random(ac.mi, ac.ma)
	)
end

function col.random()
	local frar = {mi = 0, ma = 255}
	return col.randomConstrained(frar, frar, frar, {mi = 255, ma = 255})
end

function col.inverse(c)
	return Color(255 - c.r, 255 - c.g, 255 - c.b, c.a)
end

function col.ColorVarUpdateFactory(key)
	local function cup(cv, pval, nval) 
		local splits = ncsplit(nval)
		col[key] = Color((splits[1] * 255) || col.ugly.r, (splits[2] * 255) || col.ugly.g, (splits[3] * 255) || col.ugly.b, (splits[4] * 255) || 255)
	end
	
	addCCB(key, cup)
	
	cup(key, col.ugly, getVar(key))
end

function col.getCol(key)
	if (col[key] != nil) then
		return col[key]
	else
		return col.ugly
	end
end

function col.getColI(key)
	return col.inverse(col.getCol(key))
end

local function addColVar(key, defval, desc, gtable)
	addVar(key, defval, desc, {t = "VectorColor"})
	col.ColorVarUpdateFactory(key)
end




----ibuff *FIX THIS* general betey and len (w/h don't do anything)
local ibuff = {}
ibuff.buffs = {}

ibuff.mt = {}

ibuff.mt.__index = ibuff.mt

function ibuff.mt.register(self, name)
	self.name = name
	self.msgs = {}
	
	ibuff.buffs[name] = self
	
	addVar("buff_" .. self.name, 1, "Show buffer " .. self.name .. ".", {t = "Generic"})
	addVar("buff_" .. self.name .. "_pos", "420,420", "Position of buffer " .. self.name .. ".", {t = "Generic"})
	addVar("buff_" .. self.name .. "_size", "200,73", "Withd/Height of " .. self.name .. ".", {t = "Generic"})
	addVar("buff_" .. self.name .. "_alert", 20, "Time for messages to show in  " .. self.name .. ".", {t = "Float", r = {min = 4, max = 128}})
	addVar("buff_" .. self.name .. "_decay", 32, "Time for messages to decay in " .. self.name .. ".", {t = "Float", r = {min = 8, max = 256}})
end

function ibuff.mt.add(self, msgt)
	local ctime = CurTime()
	
	if (!self.msgs[ctime]) then
		self.msgs[ctime] = {}
	end
	
	table.insert(self.msgs[ctime], msgt)
	
	local col = Color(0, 0, 0)
	
	for _, i in pairs(msgt) do
		if (type(i) == "table" && i.r && i.g && i.b) then
			col = i
		elseif (type(i) == "string") then
			MsgC(col, i)
		end
	end
	MsgN()
end

function ibuff.mt.draw(self)
	if (!getVarBool("buff_" .. self.name)) then
		return
	end
	
	paint.SetFont(font.f)
	
	local cbase = getVarVector("buff_" .. self.name .. "_pos")
	local cpos = Vector(cbase.x, cbase.y)
	
	local ctime = CurTime()
	
	for mtime, ms in pairs(self.msgs) do
		local dtime = (ctime - mtime)
		
		if (dtime > getVarFloat("buff_" .. self.name .. "_decay")) then
			self.msgs[mtime] = nil
		elseif (dtime < getVarFloat("buff_" .. self.name .. "_alert")) then
			for _, msgt in pairs(ms) do
				paint.SetColorText(col.white)
				
				local h = 0
				
				for _, msgi in pairs(msgt) do
					if (type(msgi) == "table" && msgi.a && msgi.b && msgi.g && msgi.r) then
						paint.SetColorText(msgi)
					else
						msgi = tostring(msgi)
						
						local w, ah = paint.GetTextSize(msgi)
						paint.DrawText(msgi, cpos.x, cpos.y)
						cpos.x = cpos.x + w
						
						h = math.max(h, ah)
					end
				end
				
				cpos.x = cbase.x
				cpos.y = cpos.y + h
			end
		end
	end
end

function ibuff.new(name)
	local nbuff = {}
	
	setmetatable(nbuff, ibuff.mt)
	
	nbuff:register(name)
	
	return nbuff
end

function ibuff.get(name)
	return ibuff.buffs[name]
end

function ibuff.draw()
	for _, pbuff in pairs(ibuff.buffs) do
		pbuff:draw()
	end
end

local info = ibuff.new("info")
--[[local]] dbug = ibuff.new("dbug")




----Metatable Defining
---Angle
local angle = FindMetaTable("Angle")

--Less Than
function angle:__lt(a)
	for i, v in pairs(self) do
		if (math.abs(v) >= math.abs(a[i])) then
			return false
		end
	end
	
	return true
end

--Less Than or Equal
function angle:__le(a)
	if (self == a) then
		return true
	else
		return self < a
	end
end

--Normalize
function angle:NormalizeAngle()
	return Angle(
		math.NormalizeAngle(self.p),
		math.NormalizeAngle(self.y),
		math.NormalizeAngle(self.r)
	)
end


---Entity
local Entity = FindMetaTable("Entity")

--Trace Table
function Entity:GetTraceTable(start, filter, mask)
	return GetTraceTable(start, self:OBBCenter(), filter, mask)
end

--Trace Result
function Entity:GetTraceResult(start, filter, mask)
	return util.TraceLine(self:GetTraceTable(start, filter, mask))
end

--On Screen
function Entity:OnScreen()
	if (self == LocalPlayer()) then
		return false
	end
	
	local tl, br, _, _ = self:GetScreenBox()
	local w = ScrW()
	local h = ScrH()
	
	if (
		(tl.x < 0 && br.x < 0) || (tl.x > w && br.x > w) ||
		(tl.y < 0 && br.y < 0) || (tl.y > h && br.y > h)
	) then
		return false
	end
	
	return true
end

--Random Color
function Entity:GetRandomColor()
	if (!self[cName("random_color")]) then
		local rc = {mi = 64, ma = 255}
		self[cName("random_color")] = col.randomConstrained(rc, rc, rc, {mi = 255, ma = 255})
	end
	
	return self[cName("random_color")]
end

--Distance from Entity ent
function Entity:Distance(ent)
	return self:GetPos():Distance(ent:GetPos())
end

--2D Screen Box
function Entity:GetScreenBox()
	local obmi, obma = self:WorldSpaceAABB()
	local wsab = {obmi, obma}
	
	local tinit = obmi:ToScreen()
	local t = tinit.y
	local l = tinit.x
	local b = tinit.y
	local r = tinit.x
	
	for _, x in pairs(wsab) do
		for _, y in pairs(wsab) do
			for _, z in pairs(wsab) do
				local sp = Vector(x.x, y.y, z.z):ToScreen()
				
				if (sp.x < l) then
					l = sp.x
				elseif (sp.x > r) then
					r = sp.x
				end
				if (sp.y < t) then
					t = sp.y
				elseif (sp.y > b) then
					b = sp.y
				end
				
			end
		end
	end
	
	return Vector(l, t), Vector(r, b), r - l, b - t
end


---Weapon
local Weapon = FindMetaTable("Weapon")

function Weapon:AdminOnly()
	return (!self.Spawnable && self.AdminSpawnable)
end


---Player
local Player = FindMetaTable("Player")

--Is Friend
function Player:IsFriend()
	return (self:GetFriendStatus() == "friend")
end

--Is Ally
function Player:IsAlly()
	return (LocalPlayer():Team() == self:Team())
end

--Team Name
function Player:GetTeamName()
	return team.GetName(self:Team())
end

--TeamColor
function Player:GetTeamColor()
	return team.GetColor(self:Team())
end

--Health Color
function Player:GetHealthColor()
	local hco = math.min(100, self:Health()) * 2.55
	
	return Color(255 - hco, hco, 0, 255)
end

--Usergroup
function Player:GetUserGroup()
	if (!IsValid(self)) then
		return false
	end
	return self:GetNetworkedString("UserGroup")
end

--Admin
function Player:GetAdmin()
	if (self:IsSuperAdmin()) then
		return "sadmin"
	elseif(self:IsAdmin()) then
		return "admin"
	end
	
	return "none"
end

--Has Admin
local std_usg = {
	--"member",
	"guest",
	"user"--,
	--"regular"
}

function Player:HasAdmin()
	if (self:GetAdmin() != "none") then
		return true
	end
	
	local ug = self:GetUserGroup():lower()

	if (!ug || ug == "") then
		return false
	end
	
	for _, usg in pairs(std_usg) do
		if (ug == usg) then
			return false
		end
	end
	
	return true
end

--Alive
function Player:IsAlive()
	return (self:Health() > 0)
end

--Spectator
function Player:IsSpectator()
	return (self:GetObserverMode() != 0)
end

--Angle To
function Player:AngleTo(pos)
	a = self:GetShootPos()
	b = a + (self:GetAimVector() * 2)
	c = pos
	
	sc = a:Distance(b)
	sb = a:Distance(c)
	sa = b:Distance(c)
	
	-- c ^ 2 = a ^ 2 + b ^ 2 - 2 * a * b * cos(c)
	return math.deg(math.acos((sa * sa - sb * sb - sc * sc) / (-2 * sb * sc)))
end

--Angle At
function Player:AngleAt(pos)
	return (pos - self:GetShootPos()):Angle()
end


--Hitgroups
local hitgroups = {
	generic = HITGROUP_GENERIC,
	head = HITGROUP_HEAD,
	chest = HITGROUP_CHEST,
	stomach = HITGROUP_STOMACH,
	larm = HITGROUP_LEFTARM,
	rarm = HITGROUP_RIGHTARM,
	lleg = HITGROUP_LEFTLEG,
	rleg = HITGROUP_RIGHTLEG,
	gear = HITGROUP_GEAR,
	
}

--GetPositions
local psfunc = {}

function Player:GetPositions(t)
	if (psfunc[t]) then
		return psfunc[t](self)
	end
end

--Hitboxes
local hitboxes = {
	head = 0,
	chest = 16,
	spine = 15,
	stomach = 15,
	rshoulder = 4,
	lshoulder = 1,
	rforearm = 5,
	lforearm = 2,
	relbow = 4,
	lelbow = 1,
	rthigh = 11,
	lthigh = 7,
	rcalf = 12,
	lcalf = 8,
	rhand = 6,
	lhand = 3,
	rfoot = 13,
	lfoot = 9,
	rtoe = 14,
	ltoe = 10
}

--Array of Hitbox Positions
function Player:GetHitboxPositions()
	local r = {}
	
	local hbs = self:GetHitboxSet()
	local hbm = self:GetHitBoxCount(hbs)
	
	for i, b in pairs(hitboxes) do
		if (b < hbm) then
			local hb = self:GetHitBoxBone(b, hbs)
			local hbp, hba = self:GetBonePosition(hb)
			local hbbbmin, hbbbmax = self:GetHitBoxBounds(b, hbs)
			
			hbbbmin:Rotate(hba)
			hbbbmax:Rotate(hba)
			
			r[i] = (hbp + 0.5 * (hbbbmin + hbbbmax))
		end
	end
	
	return r
end

psfunc.hitbox = Player["GetHitboxPositions"]

--Bones
local bones = {
	head = "ValveBiped.Bip01_Head1",
	chest = "ValveBiped.Bip01_Spine",
	spine = "ValveBiped.Bip01_Spine",
	rshoulder = "ValveBiped.Bip01_R_Shoulder",
	lshoulder = "ValveBiped.Bip01_L_Shoulder",
	rforearm = "ValveBiped.Bip01_R_Forearm",
	lforearm = "ValveBiped.Bip01_L_Forearm",
	relbow = "ValveBiped.Bip01_R_Elbow",
	lelbow = "ValveBiped.Bip01_L_Elbow",
	rthigh = "ValveBiped.Bip01_R_Thigh",
	lthigh = "ValveBiped.Bip01_L_Thigh",
	rcalf = "ValveBiped.Bip01_R_Calf",
	lcalf = "ValveBiped.Bip01_L_Calf",
	rhand = "ValveBiped.Bip01_R_Hand",
	lhand = "ValveBiped.Bip01_L_Hand",
	rfoot = "ValveBiped.Bip01_R_Foot",
	lfoot = "ValveBiped.Bip01_L_Foot"
}
--ValveBiped.Anim_Attachment_RH

--Array of Bone Positions
function Player:GetBonePositions()
	local r = {}
	
	for i, bt in pairs(bones) do
		for _, b in pairs(csplit(bt)) do
			local rn = self:LookupBone(b)
			if (rn) then
				r[i] = self:GetBonePosition(rn)
			end
		end
	end
	
	return r
end

psfunc.bone = Player["GetBonePositions"]

--Attachments
local attachments = {
	head = "eyes,forward,head,anim_attachment_head,lefteye,righteye,nose,mouth,moth_left,mout_right,hat,headcrab",
	chest = "chest",
	hips = "hips",
	lleg = "anim_attachment_RH",
	rleg = "anim_attachment_LH",
	lhand = "lefthand,Blood_Left",
	rhand = "righthand,Blood_Right"
}

--Array of Attachment Positions
function Player:GetAttachmentPositions()
	local r = {}
	
	for i, at in pairs(attachments) do
		for _, a in pairs(csplit(at)) do
			local an = self:LookupAttachment(a)
			if (an) then
				r[i] = self:GetAttachment(
						an
					).Pos
				break
			end
		end
	end
	
	return r
end

psfunc.attachment = Player["GetAttachmentPositions"]

--Defualt Position (entity center)
function Player:GetDefaultPositions()
	return {
		head = self:GetShootPos(),
		chest = self:LocalToWorld(self:OBBCenter())
	}
end

psfunc.default = Player["GetDefaultPositions"]


--Has Weapon
function Player:HasWeapon()
	local aw = self:GetActiveWeapon()
	
	return (aw:IsValid() && aw:IsWeapon())
end

--Weapon Name
function Player:GetWeaponName()
	if (!self:HasWeapon()) then
		return nil
	end

	return self:GetActiveWeapon():GetPrintName()
end

--Current Ammo
function Player:GetCurrentAmmo()
	if (self:HasWeapon()) then
		return self:GetAmmoCount(self:GetActiveWeapon():GetPrimaryAmmoType())
	end
	
	return
end




----Spam
---ULX Psay Check
addVar("spam_admins", 0, "Whether or not ULX psay spam goes to admins.", {t = "Boolean"})

local spam_index = 0

local can_ulx_psay = true

if (ulx) then --*FIX THIS* a real check
	can_ulx_psay = true
else
	can_ulx_psay = false
end

---Stop a spam
local function stopspam(p, c, args)
	timer.Remove(cName("spam_" .. args[1]))
end

addCom("spam_stop", stopspam, "Stop a spammer.")

---Stops all spam
local function endspam()
	for i = 0, spam_index, 1 do
		stopspam(nil, nil, {i})
	end
end

addCom("spam_end", endspam, "Ends a spammer.")

---Command Spamming
local function cmdspam(p, c, args, full)
	timer.Create(cName("spam_" .. spam_index), tonumber(args[1]), tonumber(args[2]), function()
		LocalPlayer():ConCommand(full:sub(args[1]:len() + args[2]:len() + 2))
	end)
	
	spam_index = spam_index + 1
end

addCom("spam_command", cmdspam, "Spams a command.")

---Advert Spam
local function advertspam(p, c, args)
	local msg = string.Implode(" ", {unpack(args, 3)})
	
	timer.Create(cName("spam_" .. spam_index), tonumber(args[1]), tonumber(args[2]), function()
		if (can_ulx_psay) then
			for _, p in pairs (player.GetAll()) do
				if (!(p == LocalPlayer()) && (!p:HasAdmin() || getVarBool("spam_admins"))) then
					RunConsoleCommand("ulx", "psay", p:Nick(), msg)
				end
			end
		else
			RunConsoleCommand("say", msg)
		end
	end)
	
	spam_index = spam_index + 1
end

addCom("spam_advert", advertspam, "Spams an advert.")

--




----Minmodels *FIX THIS* brokes
addVar("minmodels", 0, "Enable/Disable minmodels.", {t = "Boolean"})
addVar("minmodels_model", "models/player/kleiner.mdl", "Model for minmodels.", {t = "Generic"})

---Precache
local precache = util.PrecacheModel

---GetModel (For Gamemode overriding.)
function Player:GetMinModel()
	return getVar("minmodels_model")
end

---Minmodel main.
local function minmodels()
	if (!getVarBool("minmodels")) then
		return
	end
	
	for _, p in pairs(player.GetAll()) do
		local model = p:GetMinModel()
		precache(model)
		p:SetModel(model)
	end
end

dhook.add("Think", "minmodels", minmodels)




----ESP
addVar("esp", 0, "Enable/Disable ESP", {t = "Boolean"})
addColVar("esp_color", "1,1,1,0.5", "Default ESP Color.")

addVar("esp_crosshair", 0, "Crosshair. Each non-zero number is unique.", {t = "Float", r = {min = 0, max = 2}})
addColVar("esp_crosshair_color", "1,1,1,0.5", "Crosshair color.")

addVar("esp_radar", 0, "Enable/Disable radar.", {t = "Boolean"})
addVar("esp_radar_length", 240, "Side length of radar box.", {t = "Float", r = {min = 8, max = 640}})
addVar("esp_radar_radius", 1024, "Distance from player something will be shown on the radar.", {t = "Float", r = {min = 128, max = 8092}})
addVar("esp_radar_pos", "16,16", "Screen position of the radar.", {t = "Generic"})
addVar("esp_radar_rotate", 1, "Rotate radar with player.", {t = "Boolean"})
addVar("esp_radar_view_vectors", 0, "Show where people are aiming on radar.", {t = "Boolean"})
addVar("esp_radar_bg", 1, "Use a background on radar.", {t = "Boolean"})
addColVar("esp_radar_color", "1,0,0,0.5", "Default foreground color for radar.")
addColVar("esp_radar_color_bg", "0,0.83,0.23,0.5", "Default background color for radar.")

addVar("esp_scoreboard", 0, "Show ESP Scoreboard", {t = "Boolean"})
addVar("esp_scoreboard_pos", "120,240", "Screen position for ESP Scoreboard to show.", {t = "Generic"})

addVar("esp_p", 0, "Show players on ESP.", {t = "Boolean"})
addVar("esp_p_local", 0, "Show Local data on ESP.", {t = "Boolean"})

addVar("esp_p_show_dead", 0, "Show dead people on ESP.", {t = "Boolean"})
addVar("esp_p_show_spec", 0, "Show spectators on ESP.", {t = "Boolean"})
addVar("esp_p_show_team", 1, "Show team mates on ESP.", {t = "Boolean"})
addVar("esp_p_show_inactive", 1, "Show inactive players on ESP.", {t = "Boolean"})

addVar("esp_p_health", 0, "Show health in player info on ESP.", {t = "Boolean"})
addVar("esp_p_health_bar", 0, "Show health bar in player ESP.", {t = "Boolean"})
addVar("esp_p_name", 0, "Show name in player info on ESP.", {t = "Boolean"})
addVar("esp_p_usergroup", 0, "Shows non-standard usergroup in player info on ESP.", {t = "Boolean"})
addVar("esp_p_admin", 0, "Show admin icon in icon ESP.", {t = "Boolean"})
addVar("esp_p_id_steam", 0, "Show Steam ID in player ESP.", {t = "Boolean"})
addVar("esp_p_id_unique", 0, "Show Unique ID in player ESP.", {t = "Boolean"})
addVar("esp_p_id_entity", 0, "Show Entity Index in player ESP.", {t = "Boolean"})
addVar("esp_p_aim", 0, "Show where the player is aiming.", {t = "Boolean"})
addVar("esp_p_weapon", 0, "Show weapon in player ESP.", {t = "Boolean"})
addVar("esp_p_weapon_ammo", 0, "Show remaining ammo in player ESP.", {t = "Boolean"})
addVar("esp_p_box", 0, "Draw a box around players.", {t = "Boolean"})
addVar("esp_p_halo", 0, "Create a halo effect around players.", {t = "Boolean"})
addVar("esp_p_avatar", 0, "DO NOT USE OH GOD WHY", {t = "Boolean"}) --*FIX THIS* in general
--[[
addVar("esp_p_material", "none", "Material for drawing. Player will just draw through wall, others are materials in /player/")
addVar("esp_p_stencil", 0, "Stencil. Kind of like halo.")
]]
addVar("esp_w", 0, "Show weapons on ESP.", {t = "Boolean"})
addVar("esp_w_name", 0, "Show weapon name (best attempt) on weapons.", {t = "Boolean"})
addVar("esp_w_admin", 0, "Show if weapons require priveleges.", {t = "Boolean"})
addVar("esp_w_recoil", 0, "Show weapon recoil.", {t = "Boolean"})
addVar("esp_w_box", 0, "Show boxes around weapons.", {t = "Boolean"})
addVar("esp_w_halo", 0, "Show halos around weapons.", {t = "Boolean"})

addVar("esp_icons", 1, "Draw icons in ESP.", {t = "Boolean"})
addVar("esp_icons_size", 32, "Size of icons.", {t = "Float", r = {min = 2, max = 256}})

addVar("esp_debug", 0, "Debug ESP.", {t = "Boolean"})
addVar("esp_debug_entities", 0, "Show entities in debug ESP.", {t = "Boolean"})


---Halo
local esp_halo = {}
esp_halo.cqu = {}

function esp_halo.add(ent, c)
	if (!esp_halo.cqu[c]) then
		esp_halo.cqu[c] = {}
	end
	
	table.insert(esp_halo.cqu[c], ent)
end

function esp_halo.lfunc()
	for c, entt in pairs(esp_halo.cqu) do
		halo.Add(entt, c, 10, 10, 1, true, true)
	end
	
	esp_halo.cqu = {}
end

dhook.add("PreDrawHalos", "esp_halo", esp_halo.lfunc)


---Crosshair
local function esp_crosshair()
	local crosshair_mode = getVarInt("esp_crosshair")
	
	if (crosshair_mode == 0) then
		return
	end
	
	local ccol = col.getCol("esp_crosshair_color")
	local tl = Vector(ScrW() / 2, ScrH() / 2)
	local br = tl + Vector(1, 1)
	
	paint.SetColorDraw(ccol)
	
	if (crosshair_mode == 1) then
		--Left
		paint.DrawRect(tl.x - 4, tl.y, 2, 2)
		
		--Right
		paint.DrawRect(br.x + 4, tl.y, 2, 2)
		
		--Top
		paint.DrawRect(tl.x, tl.y - 4, 2, 2)
		
		--Bottom
		paint.DrawRect(tl.x, br.y + 4, 2, 2)
	elseif(crosshair_mode == 2) then
		paint.DrawRectOutlined(tl.x - 4, tl.y - 4, 10, 10)
		paint.DrawRectOutlined(tl.x - 1, tl.y - 1, 4, 4)
		paint.DrawLine(tl.x - 4, tl.y - 4, tl.x - 1, tl.y - 1)
		paint.DrawLine(br.x + 4, br.y + 4, br.x + 1, br.y + 1)
	end
end


---Radar
local function esp_radar()
	if (!getVarBool("esp_radar")) then
		return
	end
	
	--All The Radar Variables
	local pos = getVarSCN("esp_radar_pos")
	pos = Vector(pos[1], pos[2])
	local side_length = getVarInt("esp_radar_length")
	local side_radius= side_length / 2
	local radius = getVarInt("esp_radar_radius")
	
	local foreground = col.getCol("esp_radar_color")
	
	local origin = LocalPlayer():GetPos()
	local yaw = math.rad((-1 * LocalPlayer():EyeAngles().y - 90))
	
	local world_ratio = side_radius / radius
	
	if (getVarBool("esp_radar_bg")) then
		paint.DrawRect(pos.x, pos.y, side_length, side_length, col.getCol("esp_radar_color_bg"))
	end
	
	paint.DrawRectOutlined(pos.x, pos.y, side_length, side_length, foreground)
	
	local function DrawBlip(x, y, ang, c)
		paint.SetColorDraw(c)
		paint.DrawRect(x - 1, y - 1, 3, 3)
		if (getVarBool("esp_radar_view_vectors") && ang) then
			paint.DrawLine(x, y, x + 4 * math.sin(ang), y + 4 * math.cos(ang))
			--*FIX THIS* test
			--nop don work
		end
	end
	
	local left_bound_world = origin.x - radius
	local top_bound_world = origin.y - radius
	
	for _, p in pairs(player.GetAll()) do
		if (
			!p:IsSpectator() &&
			p:IsAlive()
		) then
			local dpos = p:GetPos()
			local ang = p:EyeAngles().y
			
			dpos.x = world_ratio * (dpos.x - left_bound_world) - side_radius
			dpos.y = world_ratio * (dpos.y - top_bound_world) - side_radius
			
			if (getVarBool("esp_radar_rotate")) then
				local dx = dpos.x
				dpos.x = -1 * (dx * math.cos(yaw) - dpos.y * math.sin(yaw))
				dpos.y = dx * math.sin(yaw) + dpos.y * math.cos(yaw)
				ang = ang + yaw
			end
			
			if (
				math.max(
					math.abs(dpos.x),
					math.abs(dpos.y)
				) + 1 <= side_radius
			) then
				DrawBlip(pos.x + dpos.x + side_radius, pos.y + dpos.y + side_radius, ang, p:GetTeamColor())
			end
		end
	end
	
	--Cross Thingy
	paint.SetColorDraw(foreground)
	
	paint.DrawLine(pos.x + side_radius, pos.y, pos.x + side_radius, pos.y + side_length)
	paint.DrawLine(pos.x + side_radius + 1, pos.y, pos.x + side_radius + 1, pos.y + side_length)
	paint.DrawLine(pos.x, pos.y + side_radius, pos.x + side_length, pos.y + side_radius)
	paint.DrawLine(pos.x, pos.y + side_radius + 1, pos.x + side_length, pos.y + side_radius + 1)
end


---Scoreboard
local function esp_scoreboard()
	if (!getVarBool("esp_scoreboard")) then
		return
	end
	
	local pos = getVarSCN("esp_scoreboard_pos")
	pos = Vector(pos[1], pos[2])
	
	local function DrawInfo(...)
		local arg = {...}
		
		local xoff = 0
		
		for i, v in pairs(arg) do
			if (
				type(v) == "table" &&
				v.r && v.g && v.b &&
				v.a
			) then
				paint.SetColorText(v)
			else
				paint.DrawText(tostring(v), pos.x + 168 * xoff, pos.y)
				xoff = xoff + 1
			end
		end
		
		pos.y = pos.y + font.h + 4
	end
	
	paint.SetFont(font.f)
	paint.SetColor(col.getCol("esp_color"))
	
	DrawInfo(
		col.black,
		"Name",
		"Health",
		"Team",
		"Steam ID",
		"Spectator?",
		"Alive?",
		"Admin",
		"Weapon"
	)
	
	for _, p in pairs(player.GetAll()) do
		local rcol = p:GetRandomColor()
		local tcol = p:GetTeamColor()
		local hcol = p:GetHealthColor()
		
		DrawInfo(
			rcol, p:Nick(),
			hcol, p:Health(),
			tcol, p:GetTeamName(),
			rcol, p:SteamID(),
			tcol, p:IsSpectator(),
			hcol, p:IsAlive(),
			rcol, p:GetAdmin(),
			tcol, p:GetWeaponName() --*FIX THIS* workarounded
		)
	end
end


---Player
local function esp_player(p)
	if (!getVarBool("esp_p")) then
		return
	end
	
	--Local Drawing
	if (p == LocalPlayer()) then
		if (getVarBool("esp_p_local")) then
			local cpos = Vector(100, 100)
			
			paint.SetFont(font.f)
			
			local function drawText(text, c)
				paint.DrawText(text, cpos.x, cpos.y, c)
				cpos = cpos + Vector(0, font.h + 2)
			end
			
			local hcol = p:GetHealthColor()
			local tcol = p:GetTeamColor()
			local rcol = p:GetRandomColor()
			local icol = col.getColI("esp_color")
			
			drawText("Health: " .. p:Health(), hcol)
			drawText("Name: " .. p:Name(), rcol)
			drawText("Team: " .. p:GetTeamName(), tcol)
			drawText("SteamID: " .. p:SteamID(), rcol)
			drawText("UniqueID: " .. p:UniqueID(), rcol)
			drawText("EntityID: " .. p:EntIndex(), rcol)
			drawText("Alive?: " .. tostring(p:IsAlive()), hcol)
		end
		
		return
	end
	
	--Filter
	if (
		!p:OnScreen() ||
		(!getVarBool("esp_p_show_dead") && !p:IsAlive()) ||
		(!getVarBool("esp_p_show_spec") && p:IsSpectator()) ||
		(!getVarBool("esp_p_show_team") && p:IsAlly()) ||
		(!getVarBool("esp_p_show_inactive") && false) --*FIX THIS* active check
	) then
		if (p[cName("esp_p_avatar")] != nil) then
			p[cName("esp_p_avatar")]:Remove()
			p[cName("esp_p_avatar")] = nil
		end
		return
	end
	
	--Player Drawing
	local tl, br, w, h = p:GetScreenBox()
	
	local hcol = p:GetHealthColor()
	local tcol = p:GetTeamColor()
	local rcol = p:GetRandomColor()
	
	local dpos = Vector(br.x + 4, tl.y)
	local isize = getVar("esp_icons_size")
	local ipos = Vector(tl.x - isize, tl.y)
	
	--Health Bar
	if (getVarBool("esp_p_health_bar")) then
		local hp = math.min(100, p:Health())
		
		local bh = math.max(math.min(h, ScrH() / 2), 12)
		local bw = math.max(math.min(h / 14, ScrW() / 28), 8)
		local bu = (100 - hp) * (bh / 100)
		
		ipos.x = ipos.x - bw - 2
		
		paint.DrawRect(tl.x - bw - 1, tl.y, bw, bh, col.black)
		paint.DrawRect(tl.x - bw + 1, tl.y + bu + 2, bw - 4, bh - bu - 4, hcol)
	end
	
	--Set Font
	paint.SetFont(font.f)
	
	--Add Text to ESP for Player
	local function addText(text, col)
		paint.DrawText(text, dpos.x, dpos.y, col)
		dpos.y = dpos.y + font.h
	end
	
	--Name
	if (getVarBool("esp_p_name")) then
		addText(p:Nick(), rcol)
	end
	
	--Usergroup
	if (getVarBool("esp_p_usergroup")) then
		if (p:HasAdmin()) then
			addText(p:GetUserGroup(), rcol)
		end
	end
	
	--Health
	if (getVar("esp_p_health")) then
		local dout
		if (p:IsAlive()) then
			dout = "Health: " .. p:Health()
		else
			dout = "DEAD"
		end
		
		addText(dout, hcol)
	end
	
	--Steam ID
	if (getVarBool("esp_p_id_steam")) then
		addText(p:SteamID(), rcol)
	end
	
	--Unique ID
	if (getVarBool("esp_p_id_unique")) then
		addText("UID: " .. p:UniqueID(), rcol)
	end
	
	--Entity Index
	if (getVarBool("esp_p_id_entity")) then
		addText("EntID: " .. p:EntIndex(), rcol)
	end
	
	--Weapon
	if(p:HasWeapon()) then
		local w = p:GetActiveWeapon()
		local wname = w:GetPrintName() || w:GetClass() || "NO WEAPON NAME?"
		
		if (getVarBool("esp_p_weapon")) then
			addText(wname, tcol)
		end
		
		local ca = p:GetCurrentAmmo()
		if (getVarBool("esp_p_weapon_ammo") && ca && ca > 0) then
			addText("Ammo: " .. ca, tcol)
		end
	end
	
	--Icons
	if (getVarBool("esp_icons")) then
		local function addIcon(icon)
			paint.DrawRectTextured(ipos.x, ipos.y, isize, isize, col.white, "VGUI/HUD/" .. icon)
			ipos.y = ipos.y + isize + 4
		end
		
		--Avatar *FIX THIS* get it 'with' everything else
		if (getVarBool("esp_p_avatar")) then
			if (p[cName("esp_p_avatar")] == nil) then
				local panel = vgui.Create("DPanel")
				panel:SetSize(32, 32)
				panel:SetPos(ipos.x, ipos.y)
				ipos.y = ipos.y + isize + 4
				
				local avatar = vgui.Create("AvatarImage", panel)
				avatar:SetSize(32, 32)
				avatar:SetPos(0, 0)
				avatar:SetPlayer(p, isize)
				avatarShouldDraw = 0
				
				p[cName("esp_p_avatar")] = panel
			else
				p[cName("esp_p_avatar")]:SetPos(ipos.x, ipos.y)
				ipos.y = ipos.y + 32 + 4
			end
		elseif (p[cName("esp_p_avatar")] != nil) then
			p[cName("esp_p_avatar")]:Remove()
			p[cName("esp_p_avatar")] = nil
		end
		
		--Friend
		local fs = (p:GetFriendStatus())
		if (fs != "none") then
			addIcon(fs)
		end
		
		--Admin
		if (getVarBool("esp_p_admin") && p:HasAdmin()) then
			addIcon("admin")
		end
		
		--Dead
		if (!p:IsAlive()) then
			addIcon("dead")
		end
		
		--Spectator
		if (p:IsSpectator()) then
			addIcon("spectator")
		end
	end
	
	--Aim Vectors
	if (getVarBool("esp_p_aim")) then
		local sp = p:GetShootPos()
		local tr = GetTraceResult(sp, sp + p:GetAimVector() * 64, p, mask_shot)
		local s, e = sp:ToScreen(), tr.HitPos:ToScreen()
		paint.DrawLine(s.x, s.y, e.x, e.y, rcol)
	end
	
	--Box
	if (getVarBool("esp_p_box")) then
		paint.DrawRectOutlined(tl.x, tl.y, w, h, tcol)
	end
	
	--Halo
	if (getVarBool("esp_p_halo")) then
		esp_halo.add(p, tcol)
	end
end

--Weapon Func
local function esp_weapon(wep)
	if (!getVarBool("esp_w") || !wep:IsValid() || !wep:IsWeapon() || (wep:GetOwner():IsValid() && wep:GetOwner():IsPlayer())) then
		return
	end
	
	local tl, br, w, h = wep:GetScreenBox()
	local rcol = wep:GetRandomColor()
	
	local dpos = Vector(br.x, tl.y)
	
	paint.SetFont(font.f)
	paint.SetColor(rcol)
	
	--*FIX THIS* we could factory these functions, ye?
	local function AddText(text)
		paint.DrawText(text, dpos.x, dpos.y)
		dpos.y = dpos.y + font.h + 4
	end
	
	--Name
	if (getVarBool("esp_w_name")) then
		AddText(wep:GetPrintName())
	end
	
	--Admin
	if (getVarBool("esp_w_admin")) then
		AddText("Req admin? " .. wep:AdminOnly())
	end
	
	--Recoil
	if (getVarBool("esp_w_recoil")) then
		AddText("Recoil: " .. wep.Recoil)
	end
	
	--Box
	if (getVarBool("esp_w_box")) then
		paint.DrawRectOutlined(tl.x, tl.y, w, h)
	end
	
	--Halo
	if (getVarBool("esp_w_halo")) then
		esp_halo.add(wep, rcol)
	end
end


---AntiCapture *FIX THIS* ann it doesn't do it doesn't do anything
local esp = true
local orc = render.Capture
local arc = nil
local lrc = nil
local tab = {format = "png", quality = 9, x = 0, y = 0, w = ScrW(), h = ScrH()}

local cocap = coroutine.create(
	function()
		while (true) do
			lrc = orc(unpack(arc))
			esp = true
			coroutine.yield()
		end
	end
)

render.Capture = (
	function(...)
		esp = false
		arc = {...}
		
		print("orc")
		
		timer.Simple(
			0.1,
			function()
				coroutine.resume(cocap)
			end
		)
		
		return lrc
	end
)

render.Capture = nil



---ESP Main
local function ESP()
	if (esp && !getVarBool("esp")) then
		return
	end
	
	--Crosshair
	esp_crosshair()
	
	--Radar
	esp_radar()
	
	--Scoreboard
	esp_scoreboard()
	
	--ibuff
	ibuff.draw()
	
	--Players
	for _, p in pairs(player.GetAll()) do
		esp_player(p)
	end
	
	--Weapons
	for _, w in pairs(ents.FindByClass("weapon_*")) do
		esp_weapon(w)
	end
	
	--Debug *FIX THIS* this is all written kind of derpily.
	if (getVarBool("esp_debug")) then
		paint.SetFont(font.f)
		
		--HITBOX DEBUG *FIX THIS*
		paint.SetColor(Color(0, 255, 255, 255))
		
		for _, p in pairs(player.GetAll()) do
			if (p != LocalPlayer()) then
				for i = 0, 0--[[p:GetHitboxSetCount()]], 1 do
					local set = p:GetHitboxSet(i)
					
					for j = 0, p:GetHitBoxCount(set), 1 do
						local bmin, bmax = p:GetHitBoxBounds(j, set)
						
						if (bmin == nil || bmax == nil) then
							break
						end
						
						local hbp, hba = p:GetBonePosition(p:GetHitBoxBone(j, set))
						
						bmin:Rotate(hba)
						bmax:Rotate(hba)
						
						local bs = {bmin + hbp, bmax + hbp} --{p:LocalToWorld(bmin), p:LocalToWorld(bmax)}
						
						--for k, pos3 in pairs(bs) do
						--	local pos = pos3:ToScreen()
						--	paint.DrawText(i .. "/" .. j .. "/" .. k, pos.x, pos.y)
						--end
						
						local poiss = {}
						
						for _, x in pairs(bs) do
							for _, y in pairs(bs) do
								for _, z in pairs(bs) do
									table.insert(poiss, (Vector(x.x, y.y, z.z):ToScreen()))
								end
							end
						end
						
						for k = 1, #poiss - 1 do
							for l = k + 1, #poiss do
								paint.DrawLine(poiss[k].x, poiss[k].y, poiss[l].x, poiss[l].y)
								
								local sss = ((bs[1] + bs[2]) * 0.5):ToScreen()
								paint.DrawText(j, sss.x, sss.y)
							end
						end
					end
				end
			end
		end
		--END HITBOX
		
		
		if (getVarBool("esp_debug_entities")) then
			for i, ent in pairs(ents.GetAll()) do
				if (ent:OnScreen() && !ent:IsWorld()) then
					local tl, br, w, h = ent:GetScreenBox()
					
					local rcol = ent:GetRandomColor()
					
					paint.SetColor(rcol)
					
					paint.DrawRectOutlined(tl.x, tl.y, w, h)
					
					local dpos = Vector(br.x, tl.y)
					
					local function AddText(text)
						paint.DrawText(text, dpos.x, dpos.y)
						dpos.y = dpos.y + font.h + 4
					end
					
					AddText("Class: " .. ent:GetClass())
					AddText("Entity Index: " .. ent:EntIndex())
				end
			end
		end
	end
end

dhook.add("HUDPaint", "esp", ESP)

--ESP 3D Main
--[[
local function ESP3D()
	cam.Start3D(EyePos(), EyeAngles())
	
	--Stencil Starting
	if (getVarBool("esp_p_stencil")) then
		render.ClearSencil()
		render.SetStencilEnable(true)
		
		render.SetStencilFailOperation(STENCILOPERATION_KEEP)
		render.SetStencilZFailOperation(STENCILOPERATION_REPLACE)
		render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
		render.SetStencilReferenceValue(1)
		
		for _, p in pairs(player.GetAll()) do
			if (p:OnScreen()) then
				p:SetModelScale(Vector(1.1, 1.1, 1.1))
				p:DrawModel()
				p:SetModelScale(Vector(1, 1, 1))
			end
		end
		
		render.SetStencilReferenceValue(2)
	end
	
	--Player Drawing
	local mat = getVar("esp_p_material")
	if (mat != "none") then
		if (mat == "player") then
			cam.IgnoreZ(true)
		else
			SetMaterialOverride(Material("player/" .. mat))
		end
	end
	for _, p in pairs(player.GetAll()) do
		local tcol = p:GetTeamColor()
		
		render.SetcolorModulation(tcol.r / 255, tcol.g / 255, tcol.b / 255)
		render.SetBlend(tcol.a / 255)
		
		p:DrawModel()

	end
	cam.IgnoreZ(false)
	SetMaterialOverride(nil)
	
	--Stencil Ending
	if (getVarBool("esp_p_stencil")) then
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
		render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
		render.SetStencilReferenceValue(1)
		
		render.SetMaterial(Material("player/solid"))
		render.DrawScreenQuad()
		
		render.SetStencilEnable(false)
	end
	
	cam.End3D()
end

dhook.add("PostDrawOpaqueRenderables", "esp3d", ESP3D)
]]




----TickAttack
local ask_attack = false
local ask_stop = false
local ask_angle = nil

local function tickaskdo()
	if (ask_stop) then
		RunConsoleCommand("-attack")
		ask_stop = false
	elseif (ask_attack) then
		RunConsoleCommand("+attack")
		ask_attack = false
		ask_stop = true
	end
	
	if (ask_angle != nil) then
		LocalPlayer():SetEyeAngles(ask_angle)
		ask_angle = nil
	end
end

dhook.add("Tick", "tickaskdo", tickaskdo)




----Auto
addVar("auto_pistol", 0, "Automatically fire non-automatic weapons when left mouse is held down.", {t = "Boolean"})
addVar("auto_hop", 1, "Automatically jump when space is being held down.", {t = "Boolean"})
addVar("auto_flashlight", 0, "Automatically spam flashlight when f is held down.", {t = "Boolean"})

local dyn_auto_shoting = false

local function Auto(ucmd)
	--Pistol
	if (getVarBool("auto_pistol") && input.IsMouseDown(MOUSE_LEFT)) then
		ask_attack = true
	end
	
	--Hop
	if (getVarBool("auto_hop") && !LocalPlayer():IsOnGround()) then
		com_out(ucmd, IN_JUMP)
	end
	
	--Flashlight
	if (getVarBool("auto_flashlight") && input.IsKeyDown(KEY_F)) then
		RunConsoleCommand("impulse", 100)
	end
end

dhook.add("CreateMove", "auto", Auto)




----Remove
addVar("remove_recoil", 0, "Remove a weapon's recoil.", {t = "Boolean"})
addVar("remove_spread", 0, "Remove a weapon's spread.", {t = "Boolean"})
addVar("remove_roll", 0, "Remove player roll.", {t = "Boolean"})

----Bot
addVar("bot_trigger", 0, "Enable/Disable triggerbot.", {t = "Boolean"})
addVar("bot_trigger_targets", "all,head,chest,stomach", "Target filtering for triggerbot. all for no filter, head for head, head,spine for head or spine, etc.", {t = "Generic"})
addPMCom("triggerbot", "bot_trigger", 1, 0)

addVar("bot_aim", 0, "Enable/Disable aimbot.", {t = "Boolean"})
addVar("bot_aim_autoshoot", 0, "Automatically shoot when aimbot is aiming at a target.", {t = "Boolean"})
addVar("bot_aim_lock", 0, "Lock onto a target until they become un-targetable.", {t = "Boolean"})
addVar("bot_aim_fov", 0, "Field of View to search for a target.", {t = "Float", r = {min = 0, max = 360}})
addVar("bot_aim_gradient", 0, "Enable gradiated aiming.", {t = "Boolean"})
addVar("bot_aim_gradient_percent", 50, "Percent of distance to travel per aim.", {t = "Float", r = {min = 0, max = 100}})
addVar("bot_aim_gradient_autoshoot_fov", 4, "Degrees from target to start allowing autoshoot.", {t = "Float", r = {min = 1, max = 32}})
addVar("bot_aim_forcefield", 0, "Enable 'forcefield' FoV ovveride.", {t = "Boolean"})
addVar("bot_aim_forcefield_distance", 100, "Distance to use forcefield.", {t = "Float", r = {min = 16, max = 4096}})
addVar("bot_aim_forcefield_angle", 42, "Forcefield FoV.", {t = "Float", r = {min = 1, max = 360}})
addVar("bot_aim_method", "auto", "Method to aim at targets.", {t = "Generic"})
addVar("bot_aim_method_auto", "hitbox,bone,attachment,default", "What methods auto goes through.", {t = "Generic"})
addVar("bot_aim_position", "head,lshoulder,rshoulder,chest,hips,lforearm,rforearm,lelbow,relbow,lthigh,rthigh,lcalf,rcalf,lhand,rhand,lfoot,rfoot", "Positions to aim at from high to low priority.", {t = "Generic"})
addVar("bot_aim_organize", "health,danger,admin,distance", "Way to choose the 'best' target.", {t = "Generic"})
addVar("bot_aim_silent", 0, "Aim without moving the local view.", {t = "Boolean"})
addPMCom("aim", "bot_aim", 1, 0)

addVar("bot_ignore_team", 1, "Have bots ignore teammates.", {t = "Boolean"})
addVar("bot_ignore_friends", 1, "Have bots ignore Steam friends.", {t = "Boolean"})
addVar("bot_ignore_admins", 0, "Have bots ignore admins.", {t = "Boolean"})

local dyn_bot_firing = false
local dyn_bot_lock = nil

---Ensures Target is Valid for bot_ignore vars
function Player:ValidBotTarget()
	return (
		(self != LocalPlayer()) &&
		(self:IsAlive()) &&
		(!getVarBool("bot_ignore_friends") || (self:GetFriendStatus() != "friend")) &&
		(!getVarBool("bot_ignore_team") || !self:IsAlly()) &&
		(!getVarBool("bot_ignore_admins") || !self:HasAdmin())
	)
end

--Automatic Selection of Method Positions
function Player:GetAutoPositions()
	local r = {}
	
	local aorder = getVarSC("bot_aim_method_auto")
	
	for _, f in pairs(aorder) do
		local ps = self:GetPositions(f)
		if (ps) then
			for i, pos in pairs(ps) do
				if (r[i] == nil) then
					r[i] = pos
				end
			end
		end
	end
	
	return r
end

psfunc.auto = Player["GetAutoPositions"]


---Aim Sorting Functions
local sorts = {}

--Admin
function sorts.admin(a, b)
	return b:HasAdmin()
end

--Danger
addVar("bot_aim_organize_threshhold_danger", 0.25, "", {t = "Float", r = {min = 0, max = 1}}) --*FIX THIS* tune min/max
function sorts.danger(a, b)
	local modo = getVarFloat("bot_aim_organize_threshhold_danger")
	
	local sp = LocalPlayer():GetShootPos()
	local va = a:AngleTo(sp)
	local vb = b:AngleTo(sp)
	
	return (math.floor(va / modo) > math.floor(vb / modo))
end

--Health
addVar("bot_aim_organize_threshhold_health", 1, "", {t = "Float", r = {min = 0, max = 1}}) --*FIX THIS* tune min/max
function sorts.health(a, b)
	local modo = getVarFloat("bot_aim_organize_threshhold_health")
	
	local va = a:Health()
	local vb = b:Health()
	
	return (math.floor(va / modo) < math.floor(vb / modo))
end

--Distance
addVar("bot_aim_organize_threshhold_distance", 100, "", {t = "Float", r = {min = 0, max = 1}}) --*FIX THIS* tune min/max
function sorts.distance(a, b)
	local modo = getVarFloat("bot_aim_organize_threshhold_distance")
	
	local lp = LocalPlayer()
	local va = a:Distance(lp)
	local vb = b:Distance(lp)
	
	return (math.floor(va / modo) < math.floor(vb / modo))
end

--Angle
addVar("bot_aim_organize_threshhold_angle", 0.25, "", {t = "Float", r = {min = 0, max = 1}}) --*FIX THIS* tune min/max
function sorts.angle(a, b)
	local modo = getVarFloat("bot_aim_organize_threshhold_angle")
	
	local lp = LocalPlayer()
	local va = lp:AngleTo(a:GetShootPos())
	local vb = lp:AngleTo(b:GetShootPos())
	
	return (math.floor(va / modo) < math.floor(vb / modo))
end

---Get First Visible Position
function Player:GetFirstPos()
	local lp = LocalPlayer()
	local sp = lp:GetShootPos()
	
	local method = getVar("bot_aim_method")
	local positions = self:GetPositions(method)
	local possible_positions = getVarSC("bot_aim_position")
	
	local first_visible
	
	if (possible_positions && positions) then
		for _, position in pairs(possible_positions) do
			local apos = positions[position]
			if (apos) then
				local tr = GetTraceResult(
					sp,
					positions[position],
					lp,
					MASK_SHOT
				)
				
				if (tr.HitNonWorld && tr.Entity == self) then
					first_visible = apos
					break
				end
			end
		end
	end

	if (first_visible) then
		return first_visible
	end
end

---FoV Check
function FoVCheck(targpos)
	local fov = getVarFloat("bot_aim_fov")
	
	if (fov == 0.0 || fov >= 360.0) then
		return true
	end
	
	local angto = LocalPlayer():AngleTo(targpos)
	return (
		angto <= fov ||
		(
			getVarBool("bot_aim_forcefield") &&
			(LocalPlayer():GetPos():Distance(targpos) <= getVarFloat("bot_aim_forcefield_distance")) &&
			(angto <= getVarFloat("bot_aim_forcefield_angle"))
		)
	)
end


---Best Aim Target
local function BestAimTarget()
	--Get Possible Targets
	local possible_targets = {}
	
	for _, p in pairs(player.GetAll()) do
		if (
			p:ValidBotTarget()
		) then
			local first_visible = p:GetFirstPos()
			
			if (first_visible && FoVCheck(first_visible)) then
				table.insert(possible_targets, {p = p, pos = first_visible})
			end
		end
	end
	
	--No Targets
	if (#possible_targets == 0) then
		return nil, nil
	end
	
	--Find Best Target of Possibilities
	local sort_methods = getVarSC("bot_aim_organize")
	
	local sort_index = 1
	
	while (sort_index <= #sort_methods && #possible_targets > 1) do
		local sort_func = sorts[sort_methods[sort_index]]
		
		local best = nil
		local new_possible_targets = {}
		
		for _, pt in pairs(possible_targets) do
			local p = pt.p
			local ppos = pt.pos
			
			if (best == nil) then
				best = p
				new_possible_targets = {{p = p, pos = ppos}}
			else
				local pbetter = sort_func(p, best)
				local bbetter = sort_func(best, p)
				
				if (pbetter == bbetter) then
					table.insert(new_possible_targets, {p = p, pos = ppos})
				elseif (pbetter) then
					best = p
					new_possible_targets = {{p = p, pos = ppos}}
				end
			end
		end
		
		possible_targets = new_possible_targets
		sort_index = sort_index + 1
	end
	
	local return_target = possible_targets[1]
	return return_target.p, return_target.pos
end

--for nospread
local cone_class = {
	weapon_pistol = Vector(0.01, 0.01, 0.01),
	weapon_smg1 = Vector(0.04362, 0.04362, 0.04362),
	weapon_ar2 = Vector(0.02618, 0.02618, 0.02618)
}

local cone_base = {
	weapon_mor_base = (
		function(wep, mul)
			local cone = wep.Primary.Cone
			if (wep:GetIronsights() == true) and wep.Owner:KeyDown(IN_ATTACK2) then
				cone = cone * 0.5
			end
			return Vector(cone, cone, cone) * mul
		end
	),
	weapon_mad_base = (
		function(wep, mul)
			local cone = wep.Primary.Cone
			
			if (wep.Weapon:GetDTBool(3)) then
				cone = cone * wep.data.Cone
			end
			
			return Vector(cone, cone, cone) * mul
		end
	),
	cmodel_cstm_base = (
		function(wep, mul)
			local cone = wep.Weapon:GetDTFloat(0)
			return Vector(cone, cone, cone) * mul
		end
	),
	weapon_cs_base2 = (
		function(wep, mul)
			local cone = wep.Primary.Cone + 0.05
			return Vector(cone, cone, cone) * mul
		end
	),
	ls_snip_base = (
		function(wep, mul)
			local cone = wep.Primary.Cone
			
			if (!wep.Ironsights) then
				cone = cone + 0.05
			end
			
			return Vector(cone, cone, cone) * mul
		end
	)
}

local function __km_GetCone(wep, mul)
	mul = mul || -1
	
	local wclass = wep:GetClass()
	
	local wclassc = cone_class[wclass]
	if (wclassc) then
		return wclassc
	end
	
	local wbase = wep.Base
	
	if (wbase && cone_base[wbase]) then
		return cone_base[wbase](wep, mul)
	end
	
	if wep != nil && wep.Primary != nil then
		if (wep.Primary.Cone) then
			local cone = wep.Primary.Cone
			
			if (type(cone) == "vector") then
				return cone * mul
			elseif (type(cone) == "number") then
				return Vector(cone, cone, cone) * mul
			end
		end
	end
	
	return Vector(0, 0, 0)
end

local function __km_SpreadCorrect(icmd, ang)
	return km_ms(km_md5(icmd), ang:Forward(), __km_GetCone(LocalPlayer():GetActiveWeapon())):Angle():NormalizeAngle()
end


--Triggerbot
local function bot_trigger(ucmd)
	if (!getVarBool("bot_trigger")) then
		return
	end
	
	local lp = LocalPlayer()
	local sp = lp:GetShootPos()
	local av = lp:GetAimVector()
	
	local td = GetTraceTable(
		sp,
		sp + av * 8192,
		lp,
		MASK_SHOT
	)
	
	local tr = util.TraceLine(td)
	
	local targ = tr.Entity
	
	local target_group = tr.HitGroup
	local target_filter = getVarSC("bot_trigger_targets")
	local filter_bool = (target_filter == nil) || (target_filter[1] == "all")
	
	if (!filter_bool) then
		for _, i in pairs(target_filter) do
			if (target_group == hitgroups[i]) then
				filter_bool = true
			end
		end
	end
	
	
	if (
		targ:IsValid() &&
		targ:IsPlayer() &&
		targ:ValidBotTarget() &&
		filter_bool &&
		!(getVarBool("bot_aim") && getVarBool("bot_aim_autoshoot"))
	) then
		ask_attack = true --ucmd:SetButtons(bit.bor(ucmd:GetButtons(), IN_ATTACK))
		dyn_bot_firing = true
	end
end

--Aimbot
local _icmd = 0
local psang = nil

local function bot_aim(ucmd, ang)
	if (!getVarBool("bot_aim")) then
		dyn_bot_lock = nil
		return ang
	end
	
	local targ, targpos = nil, nil
	
	if (getVarBool("bot_aim_lock")) then
		if (dyn_bot_lock && IsValid(dyn_bot_lock) && dyn_bot_lock:ValidBotTarget()) then
			targ, targpos = dyn_bot_lock, dyn_bot_lock:GetFirstPos()
		end
	end
	
	if (!targpos) then
		targ, targpos = BestAimTarget()
		dyn_bot_lock = targ
	end
	
	if (targ && targ:IsValid()) then
		local pang = LocalPlayer():AngleAt(targpos)
		
		local dograd = getVarBool("bot_aim_gradient")
		
		if (dograd) then
			local ap = getVarFloat("bot_aim_gradient_percent") / 100
			local cang = LocalPlayer():EyeAngles()
			
			pang = Angle(math.ApproachAngle(cang.p, pang.p, math.AngleDifference(cang.p, pang.p) * ap), math.ApproachAngle(cang.y, pang.y, math.AngleDifference(cang.y, pang.y) * ap), 0)
		end
		
		ang = pang
		
		if (getVarBool("bot_aim_autoshoot") && (!dograd || (LocalPlayer():AngleTo(targpos) <= getVarFloat("bot_aim_gradient_autoshoot_fov")))) then
			ask_attack = true --ucmd:SetButtons(bit.bor(ucmd:GetButtons(), IN_ATTACK))
			dyn_bot_firing = true
		end
	end
	
	return ang
end

--Cremove - New Remove Main
local rname = cName("recoil")

local function cremove(ucmd, ang)
	--Norecoil *FIX THIS* do the rework
	local w = LocalPlayer():GetActiveWeapon()
	
	if (IsValid(w)) then
		if (w.Primary == nil) then
			w.Primary = {}
			w.Primary.Recoil = w.Recoil
		end
	end
	
	if (getVarBool("remove_recoil")) then
		if (w.Primary.Recoil != 0) then
			w[rname] = w.Primary.Recoil
			w.Recoil = 0
			w.Primary.Recoil = 0
		end
	elseif (w.Primary.Recoil == 0 && w[rname] && w[rname] > 0) then
		w.Recoil = w[rname]
		w.Primary.Recoil = w[rname]
	end
	
	
	--Nospread
	if (getVarBool("remove_spread") && bit.band(ucmd:GetButtons(), IN_ATTACK) > 0) then
		if (psang != ang) then
			psang = ang
		end
		ang = __km_SpreadCorrect(_icmd, ang)
	else
		psang = nil
	end
	
	
	--Noroll
	if (getVarBool("remove_roll") && ang.r != 0) then
		ang = Angle(ang.p, ang.y, 0)
	end
	
	return ang
end

local function bot_at(ucmd, ang)
	if (dyn_bot_firing) then
		ucmd:SetButtons(bit.band(ucmd:GetButtons(), bit.bnot(IN_ATTACK)))
		dyn_bot_firing = false
	else
		--Triggerbot
		bot_trigger(ucmd)
		
		--Aimbot
		ang = bot_aim(ucmd, ang)
	end
	
	return ang
end

--Bot/Remove Main
local function BotRemove(ucmd)
	local __icmd = km_cmd(ucmd)
	if (__icmd != 0) then
		_icmd = __icmd
	end
	
	
	local ang = psang || ucmd:GetViewAngles()
	
	--[Aim|Trigger]bot
	ang = bot_at(ucmd, ang)
	
	--Remove Main
	ang = cremove(ucmd, ang)
	
	ucmd:SetViewAngles(ang)
end

dhook.add("CreateMove", "botremove", BotRemove)




----Admin Stuff
--addVar("admin_print_join")
--addVar("admin_print_leave")
--addVar("admin_print_period")

local function admin_msg(c)
	return function(p)
		if (p:HasAdmin()) then
			info:add(
				{
					col.white, (p:GetUserGroup() || "Admin") .. " ",
					Color(0, 0, 255), p:Name(),
					col.white, " has ", (((c && "") || "dis") .. "connected.")
				}
			)
		end
	end
end

dhook.add("PlayerAuthed", "admin_connect", admin_msg(true))
dhook.add("PlayerDiconnected", "admin_disconnect", admin_msg(false))




----Gamemode Things
local gmn = GAMEMODE.Name

addVar("generic_prop_kill_spawn", 1, "Spawn the prop.", {t = "Generic"})
addVar("generic_prop_kill_prop", "models/props_c17/Lockers001a.mdl", "Prop to spawn for generic.", {t = "Generic"})
addVar("generic_prop_kill_delay", 0.04, "Delay between pk actions.", {t = "Float", r = {min = 0.04, max = 1}})

local function prop_kill()
	local lp = LocalPlayer()
	if (!lp:HasWeapon() || lp:GetActiveWeapon():GetClass() != "weapon_physgun") then
		return
	end
	
	local lpa = LocalPlayer():EyeAngles()
	local pko = getVarFloat("generic_prop_kill_delay")
	
	if (getVarBool("generic_prop_kill_spawn")) then
		ask_angle = Angle(45, lpa.y, lpa.r)
		
		timer.Simple(
			pko * 1,
			function()
				RunConsoleCommand("gm_spawn", getVar("generic_prop_kill_prop"))
			end
		)
		
		timer.Simple(
			pko * 2,
			function()
				ask_angle = Angle(30, lpa.y, lpa.r)
			end
		)
		
		timer.Simple(
			pko * 3,
			function()
				RunConsoleCommand("+attack")
			end
		)
		
		timer.Simple(
			pko * 4,
			function()
				ask_angle = lpa
			end
		)
	end
	
	timer.Simple(
		pko * 5,
		function()
			dhook.add(
				"CreateMove",
				"prop_kill",
				function(ucmd)
					ucmd:SetMouseWheel(127)
					dhook.remove("CreateMove", "prop_kill")
				end
			)
		end
	)
	
	timer.Simple(
		pko * 6,
		function()
			RunConsoleCommand("-attack")
		end
	)
	
	if (getVarBool("generic_prop_kill_spawn")) then
		timer.Simple(
			pko * 6 + 1.4,
			function()
				RunConsoleCommand("undo")
			end
		)
	end
end

addCom("generic_prop_kill", prop_kill, "Generic scroll wheel propkill.")

--Sandbox
if (gmn == "Sandbox") then
	function Player:IsAlly()
		return (self == LocalPlayer())
	end
	
---TTT
elseif (gmn == "Trouble in Terrorist Town") then
	local o__km_GetCone = __km_GetCone
	
	__km_GetCone = (
		function(wep, mul)
			if (wep["GetPrimaryCone"]) then
				local cone = wep:GetPrimaryCone()
				return Vector(cone, cone, cone) * (mul || -1)
			end
			
			return o__km_GetCone(wep, mul)
		end
	)
	
	col.TRAITOR = Color(255, 0, 0, 255)
	col.DETECTIVE = Color(0, 0, 255, 255)
	col.INNOCENT = Color(0, 255, 0, 255)

	addVar("ttt_innocent_enemies", 1, "Consider fellow Terrorists in Trouble in Terrorist Town enemies.", {t = "Boolean"})
	
	--Override Is Ally
	function Player:IsAlly()
		if (LocalPlayer():IsTraitor()) then
			return self:IsTraitor()
		end
		
		return !(self:IsTraitor() || (self:IsTerror() && getVarBool("ttt_innocent_enemies")))
	end
	
	--Override Team Color
	function Player:GetTeamColor()
		if (self:IsTraitor()) then
			return col.TRAITOR
		elseif (self:IsDetective()) then
			return col.DETECTIVE
		end
		
		return col.INNOCENT
	end
	
	
	--TTT Minmodels
	addVar("ttt_minmodels_traitor", "models/player/kleiner.mdl", "Traitor minmodel.", {t = "Generic"})
	addVar("ttt_minmodels_detective", "models/player/police.mdl", "Detective minmodel.", {t = "Generic"})
	addVar("ttt_minmodels_innocent", "models/player/barney.mdl", "Innocent minmodel.", {t = "Generic"})
	
	--Override GetMinModel
	function Player:GetMinModel()
		if (self:IsTraitor()) then
			return getVar("ttt_minmodels_traitor")
		elseif (self:IsDetective()) then
			return getVar("ttt_minmodels_detective")
		else
			return getVar("ttt_minmodels_innocent")
		end
	end
	
	
	--TTT Traitor Weapon Detector
	local function WeaponDetect(ent)
		if (
			!LocalPlayer():IsTraitor() &&
			ent:IsValid() &&
			ent:IsWeapon() &&
			ent:GetOwner():IsValid() &&
			(ent:GetOwner() != LocalPlayer()) &&
			!ent:GetOwner():IsDetective() &&
			!ent:GetOwner():IsTraitor()
		) then
			timer.Simple(0.5, function()
				if (ent.CanBuy) then
					ent:GetOwner():SetRole(1)
					info:add({Color(255, 0, 0), ent:GetOwner():Nick(), Color(0, 0, 0), " is a ", Color(255, 0, 0), "TRAITOR", Color(127, 127, 127), " with weapon ", ent:GetPrintName()})
				end
			end)
		end
	end
	
	dhook.add("OnEntityCreated", "weapondetect", WeaponDetect)
	
	
	addVar("ttt_prop_throw_turn_deg", 15, "Degrees to turn for prop throw. Lower degrees can be more unstable, but higher degrees may not impart very much force.", {t = "Float", r = {min = 4, max = 60}})
	
	
	addVar("ttt_esp_c4", 1, "Show C4 on ESP.", {t = "Boolean"})
	addVar("ttt_esp_c4_alert", 1, "Show an alert when there is C4.", {t = "Boolean"})
	addVar("ttt_esp_c4_alert_pos", "120,120", "Position of C4 alert.", {t = "Generic"})
	
	--"Traitor Ent" ESP
	local function ttt_esp()
		if (getVarBool("ttt_esp_c4")) then
			local c4s = ents.FindByClass("ttt_c4")
			
			paint.SetFont(font.f)
			paint.SetColor(col.TRAITOR)
			
			if (getVarBool("ttt_esp_c4_alert") && #c4s > 0) then
				local pos = getVarSCN("ttt_esp_c4_alert_pos")
				pos = Vector(pos[1], pos[2])
				paint.DrawText("OH NO " .. #c4s .. "C4(s)!", pos.x, pos.y)
			end
			
			for _, c4 in pairs(c4s) do
				if (c4:IsValid() && c4:OnScreen() && c4:GetArmed()) then
					local pos = c4:GetPos():ToScreen()
					paint.DrawText("[C4][" .. string.FormattedTime(c4:GetExplodeTime() - CurTime(), "%02i:%02i") .. "]", pos.x, pos.y)
				end
			end
		end
		
		if (game.GetMap():sub(1, 13) == "ttt_minecraft") then
			paint.SetFont(font.f)
			paint.SetColor(Color(0, 255, 255, 255))
			
			for _, physbox in pairs(ents.FindByClass("func_physbox")) do
				if (physbox:Health() == 0) then
					local pos = physbox:GetPos():ToScreen()
					paint.DrawText("[D]", pos.x, pos.y)
				end
			end
		end
	end
	
	dhook.add("HUDPaint", "ttt_esp", ttt_esp)
	
	
	addVar("ttt_c4_disarm", 1, "Disarm C4s YO!", {t = "Boolean"})
	
	
	local function ttt_disarm()
		if (!getVarBool("ttt_c4_disarm")) then
			return
		end
		
		for _, c4 in pairs(ents.FindByClass("ttt_c4")) do
			if (c4:IsValid() && LocalPlayer():GetPos():Distance(c4:GetPos()) < 242) then
				for i = 1, 6 do
					RunConsoleCommand("ttt_c4_disarm", c4:EntIndex(), i)
				end
			end
		end
	end
	
	dhook.add("Tick", "ttt_disarm", ttt_disarm)
	
	
	addVar("ttt_auto_identify", 1, "Au1tomatically identify corpses.", {t = "Boolean"})
	addVar("ttt_auto_identify_traitor", 0, "Still identify as traitor", {t = "Boolean"})
	
	local function ttt_ident()
		if (!getVarBool("ttt_auto_identify") || (self:IsTraitor() && !getVarBool("ttt_auto_identify_traitr"))) then
			return
		end
		
		for _, corpse in pairs(ents.FindByClass("prop_ragdoll")) do
			if (corpse:IsValid() && LocalPlayer():GetPos():Distance(corpse:GetPos()) < 128) then
				local eidx = corpse:EntIndex()
				local id = (CurTime() - corpse.time)
				LocalPlayer().search_id = {
					id = id,
					eidx = eidx
				}
				
				print(LocalPlayer().search_id)
				PrintTable(LocalPlayer().search_id)
				
				RunConsoleCommand("ttt_confirm_death", eidx, id)
			end
		end
	end
	
	dhook.add("Tick", "ttt_ident", ttt_ident)
	
	
	--TTT Prop Thrower Turn Function
	local function _prop_throw_turn(ndeg)
		LocalPlayer():SetEyeAngles(LocalPlayer():EyeAngles() - Angle(0, ndeg, 0))
	end
	
	--TTT Prop Thrower
	local function prop_throw()
		local lp = LocalPlayer()
		if (!lp:HasWeapon() || lp:GetActiveWeapon():GetClass() != "weapon_zm_carry") then
			return
		end
		
		local turnvar = getVarInt("ttt_prop_throw_turn_deg")
		for i = 1, (180 / turnvar), 1 do
			timer.Simple(i * 0.001 * turnvar, function()
				_prop_throw_turn(turnvar)
			end)
		end
		
		timer.Simple(0.23, function()
			_prop_throw_turn(180)
		end)
		
		timer.Simple(.35, function()
			RunConsoleCommand("+attack")
		end)
		
		timer.Simple(.36, function()
			RunConsoleCommand("-attack")
		end)
	end
	
	addCom("ttt_prop_throw", prop_throw, "Throws prop with magneto stick.")
	
	--Override prop_kill
	prop_kill = prop_throw
	
	
	addVar("ttt_ghost", 0, "Enable/Disable auto-ghosting.", {t = "Boolean"})
	addVar("ttt_ghost_delay", 5, "Time between ghost messages.", {t = "Float", r = {min = 1, max = 600}})
	addVar("ttt_ghost_ignore_friends", 1, "Ignore Steam friends when ghosting.", {t = "Boolean"})
	addVar("ttt_ghost_ignore_self", 1, "Ignore self while ghosting.", {t = "Boolean"})
	
	
	local function ttt_ghost()
		timer.Modify("ttt_ghost", {delay = getVarFloat("ttt_ghost_delay")})
		
		if (!getVarBool("ttt_ghost")) then
			return
		end
		
		local lp = LocalPlayer()
		
		local ts = ""
			
		for _, t in pairs(player.GetAll()) do
			if (
				t:IsTraitor() &&
				t:IsAlive() &&
				!t:IsSpec() &&
				(!getVarBool("ttt_ghost_ignore_friends") || t:GetFriendStatus() == "none") &&
				(!("ttt_ghost_ignore_self") || t != LocalPlayer())
			) then
				ts = ts .. " " .. t:Nick() .. "  |^|  "
			end
		end
		
		if (ts != "") then
			if (can_ulx_psay) then
				for _, p in pairs(player.GetAll()) do
					if (!p:IsTraitor() && p:IsAlive() && !p:IsSpec() && !p:HasAdmin() && !(p == lp)) then
						RunConsoleCommand("ulx", "psay", p:Nick(), "Traitor(s):" .. ts)
					end
				end
			elseif (lp:IsAlive() && !lp:IsSpec()) then
				RunConsoleCommand("say", "Traitor(s):" .. ts)
			end
		end
	end
	
	timer.Create("ttt_ghost", 10, 0, ttt_ghost)
	
---Dark RP
elseif (gmn == "DarkRP") then
	function Player:IsAlly()
		return (self == LocalPlayer())
	end
	
	addVar("rp_esp", 0, "Enables/Disables RP ESP.", {t = "Boolean"})
	addVar("rp_esp_ents", "money_printer,spawned_shipment,gunlab", "Show custom entities on RP ESP.", {t = "Generic"})
	
	local function rp_ent_esp(ent)
		if (!ent:OnScreen()) then
			return
		end
		
		local tl, _, w, h = ent:GetScreenBox()
		
		local rcol = ent:GetRandomColor()
		paint.SetColor(rcol)
		
		paint.DrawRectOutlined(tl.x, tl.y, w, h)
		
		paint.DrawText(ent:GetClass(), tl.x, tl.y - font.h - 2)
	end
	
	local function rp_esp()
		if (!getVarBool("rp_esp")) then
			return
		end
		
		paint.SetFont(font.f)
		
		local classes = getVarSC("rp_esp_ents")
		
		for _, class in pairs(classes) do
			local cents = ents.FindByClass(class)
			
			for _, ent in pairs(cents) do
				rp_ent_esp(ent)
			end
			
			--for _, ent in pairs(ents.GetAll()) do
			--	if (ent:IsValid() && ent:IsMoneyPrinter()) then
			--		rp_ent_esp(ent)
			--	end
			--end
		end
	end
	
	dhook.add("HUDPaint", "rp_esp", rp_esp)
	
	
	addVar("rp_namesteal", 0, "", {t = "Boolean"})
	
	local rp_names = {}
	
	local function rp_namesteal()
		if (!getVarBool("rp_namesteal")) then
			return
		end
		
		if (rp_names[1] == nil) then
			rp_names = player.GetAll()
		end
		
		RunConsoleCommand("say", "/rpname " .. rp_names[1]:Name() .. "&")
		table.remove(rp_names, 1)
	end
	
	dhook.add("Tick", "rp_namesteam", rp_namesteal) --*FIX THIS* rework as timer, also not repeatedly steal the same
	
	--Autowanted
	addVar("rp_auto_wanted", 0, "Turn on autowanted.")
	addVar("rp_auto_wanted_delay", 0.5, "Delay between wanteds.", {t = "Float", r = {min = 0.1, max = 16}})
	addVar("rp_auto_wanted_friends", 0, "wanted friends.", {t = "Boolean"})
	addVar("rp_auto_wanted_reason", "Printer farm.", "Reason to wanted people.", {t = "Generic"})
	
	local want_buff = {}
	
	local function rp_auto_wanted()
		timer.Modify("rp_auto_wanted", {delay = getVarFloat("rp_auto_wanted_delay")})
		
		if (!getVarBool("rp_auto_wanted")) then
			want_buff = {}
			return
		end
		
		if (#want_buff == 0) then
			want_buff = player.GetAll()
		end
		
		local want_targ = LocalPlayer()
		
		while (want_targ == LocalPlayer() || (want_targ:IsFriend() && !getVarBool("rp_auto_wanted_friends"))) do
			if (#want_buff == 0) then
				return
			end
			
			want_targ = want_buff[1]
			
			table.remove(want_buff, 1)
		end
		
		RunConsoleCommand("say", "/wanted " .. want_targ:UserID() .. " " .. getVar("rp_auto_wanted_reason"))
		--RunConsoleCommand("say", "/warrant " .. want_targ:UserID() .. " " .. getVar("rp_auto_wanted_reason"))
	end
	
	timer.Create("rp_auto_wanted", 10, 0, rp_auto_wanted)
	
	
	--FAdmin Spam
	local function fadvert_spam(p, c, args)
		cmdspam(
			p,
			c,
			{
				args[1],
				args[2],
				"fadmin",
				"message",
				"*",
				args[3],
				args[4]
			}
		)
	end
	
	addCom("rp_spam_fadvert", fadvert_spam, "Spam an FAdvert.")
	
	
---F2S: Stronghold
elseif (gmn == "F2S: Stronghold") then
	--Is Protected (Stronghold Spawnprotection)
	function Player:IsProtected()
		return (self:GetColor().a < 255)
	end
	
	--Override IsAlly()
	function Player:IsAlly()
		return ((self:Team() == LocalPlayer():Team()) && self:GetTeamName() != "No Team")
	end
	
	--Override IsValidBotTarget()
	local obt = Player["IsValidBotTarget"]
	
	function Player:IsValidBotTarget()
		return (obt(self) && !LocalPlayer():IsProtected() && !self:IsProtected())
	end
	
	
---GmodZ
elseif (gmn == "GmodZ") then
	addVar("gmodz_esp", 1, "Enable/Disable GmodZ ESP.", {t = "Boolean"})
	
	addVar("gmodz_esp_items", 1, "Show GmodZ items on ESP.", {t = "Boolean"})
	addVar("gmodz_esp_items_id_entity", 0, "Show entity indexes on GmodZ items.", {t = "Boolean"})
	addVar("gmodz_esp_items_box", 1, "Show boxes around GmodZ items.", {t = "Boolean"})
	
	addVar("gmodz_esp_inventories", 1, "Show GmodZ inventories on ESP.", {t = "Boolean"})
	addVar("gmodz_esp_inventories_id_entity", 0, "Show entity indexes on GmodZ items.", {t = "Boolean"})
	addVar("gmodz_esp_inventories_box", 1, "Show boxes around GmodZ inventoreis.", {t = "Boolean"})
	
	addVar("gmodz_esp_zombies", 1, "Show GmodZ zombies on ESP.", {t = "Boolean"})
	addVar("gmodz_esp_zombies_id_entity", 0, "Show entity indexes on GmodZ items.", {t = "Boolean"})
	addVar("gmodz_esp_zombies_box", 1, "Show boxes around GmodZ zombies.", {t = "Boolean"})
	
	--Draw GmodZ esp for a table of entites. func determines what is drawn.
	local function gmodz_esp_entt(t, etype, func)
		for _, ent in pairs(t) do
			if (ent:IsValid() && ent:OnScreen()) then
				local tl, _, w, h = ent:GetScreenBox()
				
				if (getVarBool("gmodz_esp_" .. etype .."_box")) then
					paint.DrawRectOutlined(tl.x, tl.y, w, h)
				end
				
				local text = func(ent)
				
				if (getVarBool("gmodz_esp_" .. etype .. "_id_entity")) then
					text = text .. "\n" .. ent:EntIndex()
				end
				
				paint.DrawText(text, tl.x, tl.y - font.h - 2, ent:GetRandomColor())
			end
		end
	end
	
	local function gmodz_esp()
		if (!getVarBool("gmodz_esp")) then
			return
		end
		
		paint.SetFont(font.f)
		paint.SetColor(col.getCol("esp_color"))
		
		--Item ESP
		if (getVarBool("gmodz_esp_items")) then
			gmodz_esp_entt(
				ents.FindByClass("gmodz_item"),
				"items",
				function(ent)
					return ent.id
				end
			)
		end
		
		--Ivnetory ESP
		if (getVarBool("gmodz_esp_inventories")) then
			gmodz_esp_entt(
				ents.FindByClass("gmodz_inv"),
				"inventories",
				function()
					return "Inventory"
				end
			)
		end
		
		--Zombie ESP
		if (getVarBool("gmodz_esp_zombies")) then
			gmodz_esp_entt(
				ents.FindByClass("gmodz_mob"),
				"zombies",
				function()
					return "Zombie"
				end
			)
		end
	end
	
	dhook.add("HUDPaint", "gmodz_esp", gmodz_esp)

--BaseWars
elseif (gmn == "Basewars") then
	addVar("bw_esp", 0, "Enables/Disables BW ESP.", {t = "Boolean"})
	addVar("bw_esp_money", 1, "Show BW money.", {t = "Boolean"})
	addVar("bw_esp_ents", "money_printer_bronze,money_printer_silver,money_printer_gold", "Show custom entities on BW ESP.", {t = "Generic"})
	
	local function bw_ent_esp(ent)
		if (!ent:OnScreen()) then
			return
		end
		
		local tl, _, w, h = ent:GetScreenBox()
		
		local rcol = ent:GetRandomColor()
		paint.SetColor(rcol)
		
		paint.DrawRectOutlined(tl.x, tl.y, w, h)
		
		paint.DrawText(ent:GetClass(), tl.x, tl.y - font.h - 2)
	end
	
	local function bw_esp()
		if (!getVarBool("bw_esp")) then
			return
		end
		
		paint.SetFont(font.f)
		
		if (getVarBool("bw_esp_money")) then
			for _, mb in pairs(ents.FindByClass("prop_moneybag")) do
				local pos = mb:GetPos():ToScreen()
				paint.DrawText("[$]", pos.x, pos.y, Color(0, 255, 0, 255))
			end
		end
		
		local classes = getVarSC("bw_esp_ents")
		
		for _, class in pairs(classes) do
			local cents = ents.FindByClass(class)
			
			for _, ent in pairs(cents) do
				bw_ent_esp(ent)
			end
		end
	end
	
	dhook.add("HUDPaint", "bw_esp", bw_esp)
	
--Fireart
elseif (gmn == "Fireart") then
	addVar("fa_esp", 1, "Show FA Specific ESP.")
	
	local function fa_esp()
		if (!getVarBool("fa_esp")) then
			return
		end
		
		for _, npc in pairs(ents.FindByClass("npc_*")) do
			if (npc:OnScreen() && npc:IsAlive()) then
				local tl, _, w, h = npc:GetScreenBox()
				paint.DrawRectOutlined(tl.x, tl.y, w, h, tcol)
			end
		end
	end
	
--MORBUS
elseif (gmn == "MORBUS") then
	col.HUMAN = Color(144, 255, 255, 255)
	col.BROOD = Color(182, 0, 255, 255)
	col.SWARM = Color(255, 38, 255, 255)
	
	--IsAlien
	function Player:IsAlien()
		return (self:IsBrood() || self:IsSwarm())
	end
	
	--Override Is Ally
	function Player:IsAlly()
		if (LocalPlayer():IsHuman()) then
			return self:IsHuman()
		else
			return self:IsAlien()
		end
	end
	
	--Override Team Color
	function Player:GetTeamColor()
		if (self:IsBrood()) then
			return col.BROOD
		elseif (self:IsSwarm()) then
			return col.SWARM
		end
		
		return col.HUMAN
	end
	
	
	--MORBUS Alien Weapon Detector
	local function WeaponDetect(ent)
		if (ent:IsValid() && ent:GetOwner():IsValid()) then
			local cs = ent:GetClass()
			if (cs == "weapon_mor_brood") then
				ent:GetOwner():SetRole(2)
			elseif (cs == "weapon_mor_swarm") then
				ent:GetOwner():SetRole(3)
			end
		end
	end
	
	dhook.add("OnEntityCreated", "weapondetect", WeaponDetect)
	
	
	--also detect on load
	for _, ent in pairs(ents.FindByClass("weapon_mor_*")) do
		if (ent:IsValid() && ent:GetOwner():IsValid()) then
			local cs = ent:GetClass()
			if (cs == "weapon_mor_brood") then
				ent:GetOwner():SetRole(2)
			elseif (cs == "weapon_mor_swarm") then
				ent:GetOwner():SetRole(3)
			end
		end
	end
	
	
	addVar("mor_ghost", 0, "Enable/Disable auto-ghosting.", {t = "Boolean"})
	addVar("mor_ghost_delay", 5, "Time between ghost messages.", {t = "Float", r = {min = 1, max = 600}})
	addVar("mor_ghost_ignore_friends", 1, "Ignore Steam friends when ghosting.", {t = "Boolean"})
	addVar("mor_ghost_ignore_self", 1, "Ignore self while ghosting.", {t = "Boolean"})
	
	
	local function mor_ghost()
		timer.Modify("mor_ghost", {delay = getVarFloat("mor_ghost_delay")})
		
		if (!getVarBool("mor_ghost")) then
			return
		end
		
		local lp = LocalPlayer()
		
		local ts = ""
			
		for _, t in pairs(player.GetAll()) do
			if (
				t:IsBrood() &&
				t:IsAlive() &&
				!t:IsSpec() &&
				(!getVarBool("mor_ghost_ignore_friends") || t:GetFriendStatus() == "none") &&
				(!getVarBool("mor_ghost_ignore_self") || t != LocalPlayer())
			) then
				ts = ts .. " " .. t:Nick() .. "  |^|  "
			end
		end
		
		if (ts != "") then
			RunConsoleCommand("say", "// Brood(s):" .. ts)
		end
	end
	
	timer.Create("mor_ghost", 10, 0, mor_ghost)
	
	
	addVar("mor_brood_spam", 0, "Kiiiillll Freeennzzyyyy", {t = "Boolean"})
	
	local function broodspam()
		if (!getVarBool("mor_brood_spam") || !LocalPlayer():IsBrood() || !LocalPlayer():GetActiveWeapon():IsValid()) then
			return
		end
		
		local cs = LocalPlayer():GetActiveWeapon():GetClass()
		if (cs == "weapon_mor_brood") then
			RunConsoleCommand("slot1")
		else
			RunConsoleCommand("slot7")
		end
	end
	
	dhook.add("Tick", "broodspam", broodspam)
	
--ZS
elseif (gmn == "Zombie Survival") then
	--swep:GetCone()
	
	local ois = Player["IsSpectator"]
	
	function Player:IsSpectator()
		return (ois(self) || (self:GetWeaponName() == "Crow"))
	end
	
--Prophunt
elseif (gmn == "Prop Hunt") then

--Zmod
elseif (gmn == "Modded ZMod") then
	
	addVar("mzmod_esp", 1, "Show MZMod ESP.")
	
	addVar("mzmod_esp_backpack_box", 1, "Show MZMod ESP for object.")
	addVar("mzmod_esp_ammo_box", 1, "Show MZMod ESP for object.")
	addVar("mzmod_esp_resource_box", 1, "Show MZMod ESP for object.")
	addVar("mzmod_esp_weapon_box", 1, "Show MZMod ESP for object.")
	addVar("mzmod_esp_backpack_id_entity", 1, "Show MZMod ESP for object.")
	addVar("mzmod_esp_ammo_id_entity", 1, "Show MZMod ESP for object.")
	addVar("mzmod_esp_resource_id_entity", 1, "Show MZMod ESP for object.")
	addVar("mzmod_esp_weapon_id_entity", 1, "Show MZMod ESP for object.")
	
	--Draw GmodZ esp for a table of entites. func determines what is drawn.
	local function gmodz_esp_entt(t, etype, func)
		for _, ent in pairs(t) do
			if (ent:IsValid() && ent:OnScreen()) then
				local tl, _, w, h = ent:GetScreenBox()
				
				if (getVarBool("mzmod_esp_" .. etype .."_box")) then
					paint.DrawRectOutlined(tl.x, tl.y, w, h)
				end
				
				local text = func(ent)
				
				if (getVarBool("mzmod_esp_" .. etype .. "_id_entity")) then
					text = text .. "\n" .. ent:EntIndex()
					paint.DrawText(text, tl.x, tl.y - font.h - 2, ent:GetRandomColor())
				end
			end
		end
	end
	
	local function zm_esp()
		if (!getVarBool("mzmod_esp")) then
			return
		end
		
		paint.SetFont(font.f)
		
		gmodz_esp_entt(
			ents.FindByClass("bac_*"),
			"backpack",
			function(bp) return "bp" .. bp:GetClass():sub(13) end
		)
		
		gmodz_esp_entt(
			ents.FindByClass("zmod_*"),
			"ammo",
			function(a) return a:GetClass() end
		)
		
		gmodz_esp_entt(
			ents.FindByClass("r_*"),
			"resource",
			function(r) return r:GetClass() end
		)
		
		gmodz_esp_entt(
			ents.FindByClass("sim_*"),
			"weapon",
			function(w) return w:GetClass() end
		)
	end
	
	dhook.add("HUDPaint", "zm_esp", zm_esp)
	
	
end

addCom("gm_prop_kill", prop_kill, "Generic prop kill. Can be changed for game mode.")




----Anti-Anti-Cheat

---Anti-Save
lhook.add(
	file,
	"Read",
	"anti-read",
	function(fname)
		local ress, _ = string.find(fname, prefix .. ".lua")
		
		if (ress != nil) then
			return "--antimoveforce script by falco 2/02/2007\n" ..
				"local nomoves = {\"attack\", \"left\", \"right\", \"forward\", \"back\", \"moveleft\", \"moveright\"}\n" ..
				"local original_rcc = _G.RunConsoleCommand\n" ..
				"local function fix(command, ...)\n" ..
				"for _, c in pairs(nomoves) do\n" ..
				"if (command == \"+\" .. c || command == \"-\" .. c) then\n" ..
				"return\n" ..
				"end\n" ..
				"end\n" ..
				"origninal_rcc(command, ...)\n" ..
				"end\n" ..
				"_G.RunConsoleCommand = fix\n"
		end
		
		local dess, _ = string.find(fname, ".dll")
		
		if (dess != nil) then
			return "\0\0\0\0"
		end
		
		return
	end,
	false,
	true
)




----Menu

---Localization
local vgui = vgui

---Derma Creation
local dframe = vgui.Create("DFrame")
	dframe:SetPos(42, 42)
	dframe:SetSize(500, 500)
	dframe:SetTitle(prefix .. " - Derma Menu")
	dframe:SetDraggable(true)
	dframe:ShowCloseButton(false)
	dframe:SetKeyboardInputEnabled(true) -- eh

local dprop = vgui.Create("DProperties")
	dprop:SetParent(dframe)
	dprop:SetPos(2, 24)
	dprop:SetSize(496, 474)
	dprop:SetKeyboardInputEnabled(true) -- eh

local get = {
	Generic = getVar,
	Float = getVarFloat,
	Boolean = getVarBool,
	VectorColor = getVarVector
}

local drows = {}
for key, tab in pairs(dVars) do
	drows[key] = {}
	for cstring, tabdat in pairs(tab) do
		drows[key][tabdat.key] = dprop:CreateRow(key, cstring)
			drows[key][tabdat.key]:Setup(tabdat.t, tabdat.r)
			drows[key][tabdat.key]:SetValue(get[tabdat.t](tabdat.key))
			drows[key][tabdat.key]:SetKeyboardInputEnabled(true) --eh
			drows[key][tabdat.key].DataChanged = (
				function(self, newdat)
					if (tabdat.t != "VectorColor") then
						runVar(tabdat.key, newdat)
					end
				end
			)
	end
end

---Open&Close Funcs&Commands
local function show_derma_menu()
	dframe:Show()
	gui.EnableScreenClicker(true)
end

addCom("menu_show_derma", show_derma_menu, "Show Derma Menu.")

local function hide_derma_menu()
	gui.EnableScreenClicker(false)
	dframe:Hide()
end

addCom("menu_hide_derma", hide_derma_menu, "Hide Derma Menu.")

hide_derma_menu()




----Dyn Testbed
---Test Adding Function
local function addTest(com, func)
	addCom("test_" .. com, func, "test")
end


---Recursive Table Reader
local function getTable(t, p)
	local r = ""
	for i, ob in pairs(t) do
		r = r .. p .. tostring(i) .. ":::" .. tostring(ob) .. "\n"
		if (type(ob) == "table" && table.Count(ob) > 0) then
			r = r .. getTable(ob, p .. ":")
		end
	end
	return r
end


---Usergroup Testing
addTest(
	"print_ugs",
	function()
		local usg = {}
		for _, p in pairs(player.GetAll()) do
				local pusg = p:GetUserGroup()
				if (!usg[pusg]) then usg[pusg] = {} end
				table.insert(usg[pusg], p)
		end
		for pusg, ps in pairs(usg) do
			local msgt = {
				Color(0, 0, 255), pusg,
				col.white, " has ",
				Color(127, 127, 127)
			}
			
			for _, p in pairs(ps) do
				table.insert(msgt, p:Name() .. "   |^|   ")
			end
			
			info:add(msgt) --*FIX THIS* improve
		end
	end
)


addTest(
	"byte",
	function(p, c, args)
		local o = ""
		for _, b in pairs({string.byte(args[1], 1, string.len(args[1]))}) do
			o = o .. "\\" .. b
		end
		
		print(o)
	end
)


addTest(
	"breakhook",
	function()
		dhook.add(
			"Tick",
			"LOLITSBROKED",
			function()
				error('dur')
			end
		)
	end
)


----*TODO* List

-- Also - make a general function factory for all the +- gubbins things like +-attack, jump, and also others like impulse 100 so a func can just be called rather than current complicated things

--http.Fetch( "http://.../.lua", runstring)
--DOC:
--http.Fetch(url, success_function, nonsuccess_function)
--about using this: This givees too much power for someone stealing the script. They can just get the most recent whenever.

--also modul -> deflua and pass _G to script?

--Read map logic entities to find keypad passwords
--Also general entesp for non-solid walls, invisible buttons, etc

--add orgasm (oh Oh OH OH OH! OH!!)