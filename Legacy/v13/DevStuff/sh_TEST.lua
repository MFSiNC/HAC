

if CLIENT then

function SendSS()
	local f = file.Open("lua/bin/lol.dll", "rb", "GAME")
	
	local rawss = {}
	local i
	for i=0, f:Size() do
		f:Seek(i)
		local char = f:Read(1)
		if char == string.char(0) then --Nil Char Replacement
			rawss[i] = "ZZZ"
		else --Write as normal
			rawss[i] = char
		end
	end

	f:Close()
	SendSSTable(rawss)
end
concommand.Add("fuck", SendSS)


function SendSSTable(SST)
	local Master = {}
	local Slave = 1
	Master[Slave] = {}
	local Counter = 1
	local k, v
	for k, v in pairs(SST) do
		Master[Slave][Counter] = v
		Counter = Counter + 1
		if Counter == 5000 then
			Slave = Slave + 1
			Counter = 1
			Master[Slave] = {}
		end
	end
	

	local delay = 1
	local num = 1
	
	for num=1, Slave do
		timer.Simple(delay, function()
			print("! send")
			
			net.Start("cSS")
				net.WriteTable(Master[num])
			net.SendToServer()
		end)
		delay = delay + 1
	end
end


end

if CLIENT then return end



util.AddNetworkString( "cSS" )


function RecieveScreenshot(len, ply)
	local css = net.ReadTable()
	
	print("! got: ", len)
	
	local f = file.Open("fuck.txt", "ab", "DATA" )
	
	for k, v in pairs(css) do
		if v == "ZZZ" then
			f:Write( string.char(0) )
		else
			f:Write( v )
		end
	end
	f:Close()
end
net.Receive( "cSS", RecieveScreenshot)


