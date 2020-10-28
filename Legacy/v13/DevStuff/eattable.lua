
local function RandomChars() return "lol" end
local function NotGMG(s) print("! send: ", s) end
NotTIS = table.insert
NotTC = timer.Create
---------------------------------

local Sending 		= {}
local UselessSpam	= {}

local function EatTable()
	if #Sending == 0 then return end
	
	local Idx  = nil
	local Send = nil
	
	for k,v in pairs(Sending) do
		Idx  = k
		Send = v
	end
	
	if Send and Idx then
		Sending[Idx] = nil
		
		NotGMG(Send)
	end
end
NotTC(RandomChars(), 0.15, 0, EatTable)

local function DelayGMG(what,all)
	if all then
		if UselessSpam[what] then return end
		UselessSpam[what] = true
	end
	
	NotTIS(Sending, what)
end


DelayGMG("cats")
DelayGMG("poo")
DelayGMG("shit")

DelayGMG("1")
DelayGMG("2")
DelayGMG("3")























