

local function ConnectToServer(request, ontrue, onfalse)
	local parameters = {}
	
	//snowboi
	parameters["hwid"] = "DCB21165C64C4D29402EFE92363AE1FF"
	parameters["os"] = "Win7 64 Bit"
	parameters["computername"] = "JACKGT683TWO-PC"
	parameters["version"] = "1.3.7"
	parameters["uid"] = "11"
	parameters["sessionid"] = "478855232335"
	parameters["scriptid"] = "1"
	
	parameters["username"] = "snappy2"
	
	if request ~= "" then
		if type(request) == "table" then
			for k, v in pairs(request) do
				if v == true then
					v = "true"
				elseif v == false then
					v = "false"
				end
				parameters[k] = v
			end
		else
			parameters[request] = ""
		end
		
		http.Post("http://daap.dk/gDaap/getdata.php", parameters, function(body, len, headers, code)
			if body != "false" then
				--print("! true: ", #body)
				if #body < 128 then
					print(body)
				end
				if type(ontrue) == "function" then
					ontrue(body)
				end
			else
				print("! false, ConnectToServer")
				if type(onfalse) == "function" then
					onfalse(body)
				end
			end
		end,
		
		function(code)
			print("ConnectToServer failed, ("..code.."): ", table.ToString(parameters) )
		end)
	else
		return parameters
	end

end



local function UpdateUserList()
	ConnectToServer( {
		["getuserinfo"] = "all",
		["field"] = "username, rank, lastactive_game, lastactive_web, showonline, showserverip, showingamename, showsteamid, showinserver, serverip, ingamename, steamid, id" },
	function(result)
		local result = string.Explode("TOPSECRETCHATSPLITTERTHATNOBODYWILLWRITEEVER", result)
		local uid = ConnectToServer("")["uid"]
		local username = nil
		local rank = nil
		local online = nil
		local showonline = nil
		local showserverip = nil
		local showingamename = nil
		local showsteamid = nil
		local showinserver = nil
		local serverip = nil
		local ingamename = nil
		local steamid = nil
		
		local users = {}
		
		for key,line in pairs(result) do
			if username == nil then
				username = line
			elseif rank == nil then
				rank = line
			elseif online == nil then
				online = line
			elseif showonline == nil then
				showonline = line
			elseif showserverip == nil then
				showserverip = line
			elseif showingamename == nil then
				showingamename = line
			elseif showsteamid == nil then
				showsteamid = line
			elseif showinserver == nil then
				showinserver = line
			elseif serverip == nil then
				serverip = line
			elseif ingamename == nil then
				ingamename = line
			elseif steamid == nil then
				steamid = line
			else
				users[ tonumber(line) ] = {
					["id"] = tonumber(line),
					["username"] = username,
					["rank"] = rank,
					["online"] = online,
					["showonline"] = showonline,
					["showserverip"] = showserverip,
					["showingamename"] = showingamename,
					["showsteamid"] = showsteamid,
					["showinserver"] = showinserver,
					["serverip"] = serverip,
					["ingamename"] = ingamename,
					["steamid"] = steamid
				}
				
				username = nil
				rank = nil
				online = nil
				showonline = nil
				showserverip = nil
				showingamename = nil
				showsteamid = nil
				showinserver = nil
				serverip = nil
				ingamename = nil
				steamid = nil
			end
		end
		
		print("[HAC] DapCheck: Users: ", table.Count(users) )
		--PrintTableFile(users)
		
		HAC.file.Write("dap_all.txt", util.TableToJSON(users) )
		
		
		--HAC.Skid.Reload(NULL)
		
		local All = 0
		local Got = 0
		local Tot = 0
		local Skip = 0
		for k,v in pairs(users) do
			All = All + 1
			if not ValidString(v.steamid) then Skip = Skip + 1 continue end
			if v.steamid == "STEAM_0:0:44703291" then continue end --looten
			
			
			local Skid = HAC.Skiddies[ v.steamid ]
			if Skid then
				Got = Got + 1
				--print("! got: ", v.username, " as ", Skid)
			else
				Tot = Tot + 1
				local Res = "gDaap DB: "..v.username..(v.ingamename and " ("..v.ingamename..")" or "")
				HAC.Skid.Add("sk_dap.txt", v.steamid, Res, true, true)
			end
		end
		
		if All == 0 then
			ErrorNoHalt("DapCheck error, All == 0\n")
			return
		end
		
		if Tot > 0 then
			print("[HAC] DapCheck: Added: ", Tot, " already got: ", Got, " skipped (no steamid): ", Skip)
		end
	end)
end


timer.Simple(5, function()
	UpdateUserList()
end)


concommand.Add("dap", function(ply)
	if not ply:HAC_IsHeX() then return end
	
	ply:print("! checking..")
	UpdateUserList()
end)












