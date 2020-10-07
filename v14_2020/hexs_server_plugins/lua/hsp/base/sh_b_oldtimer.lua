
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[
	=== HSP Base Plugin ===
	sh_B_OldTimer, v1.0
	Optional my ass!
]]



local CurTime = CurTime
local UnPredictedCurTime = UnPredictedCurTime
local unpack = unpack
local pairs = pairs
local table = table
local pcall = pcall
local ErrorNoHalt = ErrorNoHalt
local hook = hook
local tostring = tostring
local tonumber=tonumber
local type=type
local error=error


HSP.timer = {} --Here we go again


--TimerError("Simple",value.Func,value.Args,e)
local function TimerError(name,func,args,e)
	local str="[Timer error] "
	if name then
		str=str.."Timer '"..tostring(name)..' failed: '
	else
		str=str.."Simple timer failed: "
	end
	str=str..tostring(e)..'\n'
	ErrorNoHalt(str) str="" -- String length limit. Wtf?
	if type(func) == "function" then
		local data=debug.getinfo(func) or {}
		str=str..'> Func '..(data.source or "SRC?")..':'..(data.linedefined or "?")..'-'..(data.lastlinedefined or "?")..'\n'
	end
	ErrorNoHalt(str) str=""
	if args and type(args)=="table" and table.Count(args) > 0 then
		str=str..'> Args '..table.ToString(args)
	end
	str=str..'\n'
	ErrorNoHalt(str)
end



// Some definitions
local PAUSED = -1
local STOPPED = 0
local RUNNING = 1

// Declare our locals
local Timer = {}
local TimerSimple = {}

local function CreateTimer( name )
	if ( Timer[name] == nil ) then
		Timer[name] = {}
		Timer[name].Status = STOPPED
		return true
	end
	return false
end




function HSP.timer.Exists( name )
	if ( Timer[name] == nil ) then return false
	else return true end
end


function HSP.timer.Create( name, delay, reps, func, ... )
	if ( HSP.timer.Exists( name ) ) then
		HSP.timer.Destroy( name )
	end
	
	HSP.timer.Adjust(name, delay, reps, func, ...)
	HSP.timer.Start(name)
end


function HSP.timer.Start( name )
	if ( !HSP.timer.Exists( name ) ) then return false end
	Timer[name].n = 0
	Timer[name].Status = RUNNING
	Timer[name].Last = CurTime()
	
	return true
end


function HSP.timer.Adjust( name, delay, reps, func, ... )
	CreateTimer( name )
	delay = tonumber(delay) or error("Invalid delay")
	reps = tonumber(reps) or error("Invalid repetitions")
	
	Timer[name].Delay = delay
	Timer[name].Repetitions = reps
	
	if ( func != nil ) then
		Timer[name].Func = func
	end
	
	Timer[name].Args = {...}
	
	return true
end


function HSP.timer.Pause( name )
	if ( !HSP.timer.Exists( name ) ) then return false; end
	if ( Timer[name].Status == RUNNING ) then
		Timer[name].Diff = CurTime() - Timer[name].Last
		Timer[name].Status = PAUSED
		return true
	end
	
	return false
end


function HSP.timer.UnPause( name )
	if ( !HSP.timer.Exists( name ) ) then return false; end
	if ( Timer[name].Status == PAUSED ) then
		Timer[name].Diff = nil
		Timer[name].Status = RUNNING
		return true
	end
	
	return false
end


function HSP.timer.Toggle( name )
	if ( HSP.timer.Exists( name ) ) then
		if ( Timer[name].Status == PAUSED ) then
			return UnPause( name )
		elseif ( Timer[name].Status == RUNNING ) then
			return Pause( name )
		end
	end
	
	return false
end


function HSP.timer.Stop( name )
	if ( !HSP.timer.Exists( name ) ) then return false; end
	if ( Timer[name].Status != STOPPED ) then
		Timer[name].Status = STOPPED
		return true
	end
	
	return false
end


function HSP.timer.Destroy( name )
	Timer[name] = nil
end
HSP.timer.Remove = HSP.timer.Destroy


function HSP.timer.Simple( delay, func, ... )
	delay = tonumber(delay) or error("incorrect delay")
	local new_timer = {}
	
	new_timer.Finish = UnPredictedCurTime() + delay
	
	if type(func)!="function" then
		error("no function specified")
	end
	
	new_timer.Func = func
	new_timer.Args = {...}
	
	table.insert(TimerSimple, new_timer)
	
	return true
end

function HSP.timer.NextTick(func, ...)
	HSP.timer.Simple(0,func, ...)
end

function HSP.timer.GetTable()
	return Timer
end

function HSP.timer.GetTimerSimpleTable()
	return TimerSimple
end




function HSP.timer.Check()
	for key, value in pairs(Timer) do
		if (value.Status == PAUSED) then
			value.Last = CurTime() - value.Diff
		elseif ( value.Status == RUNNING && ( value.Last + value.Delay ) <= CurTime() ) then
			value.Last = CurTime()
			value.n = value.n + 1 
			local b, e = pcall( value.Func, unpack( value.Args ) )
			if ( !b ) then
				TimerError(key,value.Func,value.Args,e) --ErrorNoHalt( "Timer Error: "..tostring(e).."\n" )
				Timer[key] = nil --- timers shouldn't error, so remove them to make us start fixing the timer errors instead of just ignoring them because we know it won't "do anything"
			end
			if ( value.n >= value.Repetitions && value.Repetitions != 0) then
				HSP.timer.Stop( key )
			end
		end
	end
	
	//Run Simple timers
	for key, value in pairs( TimerSimple ) do
		if ( value.Finish <= CurTime() ) then
			local b,e = pcall( value.Func, unpack( value.Args ) )
			
			if (!b) then
				TimerError(nil,value.Func,value.Args,e) --ErrorNoHalt( "Timer Error: "..tostring(e).."\n" )
			end
			
			TimerSimple[key] = nil --Kill Timer
		end
	end

end
hook.Add("Think", "CheckTimers2", HSP.timer.Check)

--[[
function HSP.TimeGuard()
	hook.Add("Think", "CheckTimers2", HSP.timer.Check)
end
hook.Add("Tick", "HSP.TimeGuard", HSP.TimeGuard)
]]






