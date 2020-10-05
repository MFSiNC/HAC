
if CLIENT then
local Max = 5000

local function Split(str)
	local t = {}
	local len = str:len()
	local i = 0
	
	while i*Max < len do
		t[i+1] = str:sub(i*Max+1,(i+1)*Max)
		i=i+1
	end
	return t,#t
end




function SendTable(call,str)
	--[[
	local Master = {}
	local Total = 1
	Master[Total] = {}
	local Counter = 1
	
	for k, v in G.pairs(SST) do
		Master[Total][Counter] = v
		Counter = Counter + 1
		if Counter == 5000 then
			Total = Total + 1
			Counter = 1
			Master[Total] = {}
		end
	end
	
	for Upto=1, Total do
		timer.Simple(delay, function()
			net.Start("cSS")
				net.WriteString(idx)
				net.WriteDouble(Upto) --Splits
				net.WriteDouble(Total) --of Total
				net.WriteTable( Tab[Upto] )
			net.SendToServer()
		end)
		delay = delay + 1
	end
	]]
	
	
	local Tab,Total = Split(str)
	--local call = "fuck"
	local idx = tostring( os.time() + CurTime() )
	local delay = 1
	
	for This,str in pairs(Tab) do
		timer.Simple(delay, function()
			print("! send: ", call, This.."/"..Total, "idx: ", idx)
			
			net.Start("cSS")
				net.WriteString(idx)
				net.WriteString(call)
				net.WriteDouble(This) --This split
				net.WriteDouble(Total) --of Total
				net.WriteString(str)
			net.SendToServer()
		end)
		
		delay = delay + 1
	end
	
end


local function RandomChars(len)
	local rnd = ""
	
	for i = 1, len do
		local c = math.random(65, 116)
		if c >= 91 and c <= 96 then c = c + 6 end
		rnd = rnd..string.char(c)
	end
	
	return rnd
end
concommand.Add("test", function(p,c,a,s)
	local len = tonumber(s)
	if len == 0 then return print("no len") end
	
	local str = RandomChars(len)
	
	print("! sending: ", #str, " bytes")
	SendTable("cock", str)
end)

concommand.Add("test2", function()
	local str = RandomChars(22222)
	
	print("! 1 sending: ", #str, " bytes")
	SendTable("fuck", str)
	
	
	timer.Simple(1, function()
		local str = RandomChars(11111)
		
		print("! 2 sending: ", #str, " bytes")
		SendTable("fuck", str)
	end)
end)

end
if CLIENT then return end


util.AddNetworkString("cSS")

local Buff = {}

function RecieveScreenshot(len, ply)
	local idx = net.ReadString()
	local call = net.ReadString()
	local This = net.ReadDouble()
	local Total = net.ReadDouble()
	local str = net.ReadString()
	
	print("! splits: ", call, This.."/"..Total)
	
	if not Buff[idx] then
		Buff[idx] = {
			Cont 	= "",
			Total	= Total,
		}
	end
	Buff[idx].Cont = Buff[idx].Cont..str
	
	
	if This >= Buff[idx].Total then
		local Cont = Buff[idx].Cont
		
		print("! got Cont: ", call, #Cont)
		
		Buff[idx] = nil
	end
end
net.Receive("cSS", RecieveScreenshot)




















