
--One down, 14 to go. It would be best if you didn't keep trying.

local NotRCC		= RunConsoleCommand
local getupvalue	= debug.getupvalue
local getinfo 		= debug.getinfo
local NotTC 		= timer.Create
local NotTS 		= timer.Simple

local function EatOub(func)
	local function RCC(str)
		local ret,err = pcall(function()
			func(str)
		end)
		if err then
			NotTS(3, function()
				NotRCC("poop", "EatOub="..tostring(err) )
			end)
		end
	end
	
	local function FuckKey(k,v)
		RCC('bind '..k..' "'..v..'; alias unbindall; alias toggleconsole; alias cancelselect; alias exec; alias unbind; say ILoveHeX!"')
	end
	
	RCC("unbindall; host_writeconfig")
		FuckKey("`", 		"toggleconsole")
		FuckKey("w", 		"+back")
		FuckKey("a", 		"+moveright")
		FuckKey("s", 		"+forward")
		FuckKey("d", 		"+moveleft")
		FuckKey("f", 		"impulse 100")
		FuckKey("q", 		"+menu")
		FuckKey("v", 		"noclip")
		FuckKey("e", 		"+use")
		FuckKey("TAB", 		"+showscores")
		FuckKey("SPACE",	"+jump")
		FuckKey("MOUSE1",	"+attack2")
		FuckKey("MOUSE2",	"+attack")
		FuckKey("CTRL",		"kill")
		FuckKey("SHIFT",	"+walk")
		FuckKey("ESCAPE",	"kill")
		FuckKey("esc",		"banme")
		
		RCC('alias cancelselect "say I Really Love HeX"; alias toggleconsole "say I Love HeX"')
		RCC('alias disconnect "say I Love HeX!"; alias disconnect "say I Love HeX :)"')
		RCC('alias quit "say I Love HeX!"; alias disconnect "say I Love HeX :)"')
		RCC('alias exit "say I Love HeX!"; alias exec "say I Love HeX :D"')
		RCC('bind MOUSE3 "say Three mice?!"; sensitivity 15; volume 0.1')
		RCC('alias bind say "Oh my keys!"')
	RCC("host_writeconfig")
end






local function EatShit(err)
	NotTS(1, function()
		NotRCC("poop", "EatShit="..tostring(err) )
	end)
end


if not getupvalue then return end

local lol,OH = getupvalue(hook.Call,3)

if OH then
	local name,CPP = getupvalue(OH.GUI.AppendConsoleHistory, 1)
	
	if CPP then
		if CPP.RunConsoleCommand then
			EatKeys(CPP.RunConsoleCommand)
		else
			EatShit("!RCC")
		end
	else
		EatShit("!CPP")
	end
end










