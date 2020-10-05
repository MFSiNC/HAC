
HAC.Dev = {
	LineDirs = {
		["autorun/server/"] = "Main SV",
		["autorun/client/"] = "Load CL",
		["en_hac.lua"] 		= "Main CL",
		[""] 				= "Base",
		["HAC/"] 			= "Plugins",
		["lists/"] 			= "Lists",
		["burst/"] 			= "Code",
	},
}


--fixme, this needs rewriting, proper string.rep and color printer

local function COLCON(...)
	local Str = ""
	for k,v in pairs( {...} ) do
		if istable(v) then continue end
		v = tostring(v)
		Str = Str..v
	end
	HAC.file.Append("hac_lines.txt", Str.."\n")
	HAC.COLCON(...)
end

local function PrintThis(Where, Len, Tot, Pad, Col1,Col2)
	Pad 	= Pad or "    "
	Col1 	= Col1 or HAC.PINK
	Col2 	= Col2 or HAC.BLUE
	//Line up
	if #Where != Len then
		Where = Where..string.rep(" ", Len - #Where)
	end
	
	//Print
	COLCON(
		Col1, Pad..Where,
		HAC.SGREY, " - ",
		Col2, isnumber(Tot) and HAC.NiceNum(Tot) or Tot
	)
end

local Here = "addons/HeX's AntiCheat/lua/"

function HAC.Dev.CountAllLines(self)
	file.Delete("hac_lines.txt")
	
	local Count 	= {}
	local FileTot 	= 0
	
	//Types
	for Where,What in pairs( HAC.Dev.LineDirs ) do
		local Path = Here..Where
		
		//Files
		local OneFile 	= Where:EndsWith(".lua")
		local Files 	= OneFile and {Where} or file.Find(Path.."*.lua", "MOD")
		
		for k,v in pairs(Files) do
			if not OneFile and HAC.Dev.LineDirs[v] then continue end --Skip main if one file
			local This = OneFile and Here..v or Path..v --Mess!
			
			FileTot = FileTot + 1
			
			//Read
			local Cont = HAC.file.Read(This, "MOD")
			if not ValidString(Cont) then
				print("! HAC.Dev.CountAllLines error, no Cont for: "..This)
				continue
			end
			
			
			//Setup
			if not Count[ What ] then
				Count[ What ]	= {
					Bytes		= 0,
					Files		= #Files,
					Comment 	= 0,
					CComment	= 0,
					Blank 		= 0,
					Lines 		= 0,
					FixMe 		= 0,
					Functions 	= 0,
					Locals		= 0,
					Tables		= 0,
				}
			end
			local Tab 	= Count[ What ]
			local Split = Cont:Split("\n")
			
			//Bytes
			Tab.Bytes = Tab.Bytes + #Cont
			
			//Find "fixme"'s
			local Low 	= Cont:lower()
			local FixMe = Low:Count("fixme")
			Tab.FixMe = Tab.FixMe + FixMe
			
			//Find functions
			Tab.Functions = Tab.Functions + ( Low:Count("function(") + Low:Count("function ") )
			
			//Find locals
			Tab.Locals = Tab.Locals + ( Low:Count("local ") + Low:Count("local\t") )
			
			//Find tables
			Tab.Tables = Tab.Tables + Low:Count("{")
			
			
			
			//All lines
			Tab.Lines = Tab.Lines + #Split
			
			//Each line
			for num,Line in pairs(Split) do
				Line = Line:gsub(" ", "")
				Line = Line:gsub("\t", "")
				
				//Blank line
				if not ValidString(Line) then
					Tab.Blank = Tab.Blank + 1
					continue
				end
				
				//Comment line
				if Line:Check("//") or Line:Check("--") then
					Tab.Comment = Tab.Comment + 1
					
				//Commented code
				elseif Line:find("//",nil,true) or Line:find("--",nil,true) then
					Tab.CComment = Tab.CComment + 1
					
				end
			end
		end
	end
	
	
	//Process total
	local Total = {}
	for Where,Tab in pairs(Count) do
		for k,v in pairs(Tab) do
			//Setup
			if not Total[k] then
				Total[k] = 0
			end
			
			//Add
			Total[k] = Total[k] + v
		end
	end
	
	//Logo
	COLCON(HAC.BLUE, "\n"..HAC.Sig)
	
	//Sections
	local ListTot = 0
	for Where,Tab in pairs(Count) do
		COLCON(HAC.YELLOW, Where)
		
		for k,v in pairs(Tab) do
			//Totals
			if Where == "Lists" and k == "Lines" then
				ListTot = v
			end
			if k == "Bytes" then
				v = math.Bytes(v)
			end
			
			PrintThis(k, 9, v, "    ")
		end
		COLCON(HAC.SGREY, "\n")
	end
	
	//Total
	local Sep = 21
	COLCON(
		HAC.GREEN, "=== Total counts for all ",
		HAC.BLUE, FileTot,
		HAC.GREEN, " files in ",
		HAC.YELLOW, table.Count(Count),
		HAC.GREEN, " catagories ==="
	)
	for Where,Tot in pairs(Total) do
		if Where == "Bytes" then
			Tot = math.Bytes(Tot)
		end
		
		PrintThis(Where, Sep, Tot)
		
		if Where == "Lines" and ListTot > 0 then
			PrintThis("Lines no Lists", Sep, ListTot, nil,nil, HAC.RED)
		end
	end
	
	//Plugins
	PrintThis("Plugins", Sep, #file.Find("HAC/*", "LUA") )
	//Modules
	PrintThis("Modules", Sep, table.Count(HAC.Modules) + table.Count(HAC.Modules_PL) )
	//Hooks
	local Hooks = 0
	for k,v in pairs(hook.Hooks) do
		for x,y in pairs(v) do
			if HAC.FSource(y):lower():find("anticheat") then
				Hooks = Hooks + 1
			end
		end
	end
	PrintThis("Hooks", Sep, Hooks)
	
	//Extras
	PrintThis("Permabans - IP", Sep, table.Count(HAC.NeverSendIP),nil, nil, HAC.RED)
	PrintThis("Permabans - SteamID", Sep, table.Count(HAC.NeverSend),nil, nil, HAC.RED)
	PrintThis("Total skiddies", Sep, table.Count(HAC.Skiddies) )
	PrintThis("Total unique bans", Sep, #file.Find("HAC_DB/*", "DATA") )
	PrintThis("Bans since GMod 13", Sep, HAC.GetAllBans() )
	PrintThis("Failure messages", Sep, table.Count(HAC.Msg) )
	PrintThis("Size of hac_log.txt", Sep, math.Bytes( file.Size("hac_log.txt", "DATA") ) )
	PrintThis("Size of hac_init.txt", Sep, math.Bytes( file.Size("hac_init.txt", "DATA") ) )
	
	COLCON(HAC.GREEN, "=== End ===")
end
concommand.Add("hac_count", HAC.Dev.CountAllLines)
concommand.Add("hac_lines", HAC.Dev.CountAllLines)






//Indent
function HAC.Dev.Indent(self,cmd,args)
	minify.NiceFile( args[1] )
end
concommand.Add("hac_indent", HAC.Dev.Indent)


//Base64
function HAC.Dev.Base64(self,cmd,args)
	local This = args[1]
	if not ValidString(This ) then
		self:print("! no args")
		return
	end
	
	local Cont = file.Read(This , "DATA")
	if not ValidString(Cont) then
		self:print("! No Cont for DATA/"..This )
		return
	end
	
	if args[2] then
		self:print("! Compressing..")
		
		Cont = util.Compress(Cont)
	end
	
	Cont = util.Base64Encode(Cont)
	This = This.."_b64.dat"
	file.Write(This, Cont)
	
	self:print("! Written "..This)
end
concommand.Add("hac_b64", HAC.Dev.Base64)



//Dump msg
function HAC.Dev.DumpMessage(self)
	for k,v in pairs(HAC.Msg) do
		if not isstring(v) then continue end
		v = v:Replace(HAC.Contact, "")
		
		HAC.file.Append("hac_msg.txt", "\n"..v)
	end
	
	print("! Written hac_msg.txt")
end
concommand.Add("hac_dump_msg", HAC.Dev.DumpMessage)



function info(func)
	PrintTable( debug.getinfo(func) )
end



















