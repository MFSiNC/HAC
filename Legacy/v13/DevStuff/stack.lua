


stack trace


[ERROR] lua/includes/modules/notification.lua:258: attempt to call field 'Register' (a nil value)
1. unknown - lua/includes/modules/notification.lua:258
2. old - [C]:-1
3. unknown - filename:334
4. pcall - [C]:-1
5. require - filename:54
6. unknown - Startup:1





local function Trace()
	local level = 1
	
	while true do
		local info = debug.getinfo(level)
		if not info then break end
		
		print(level, info.what, info.name, info.short_src, info.currentline)
		
		level = level + 1
	end
	
	Msg("\n\n")
end



local function Poop()
	Trace()
end

Poop()




















