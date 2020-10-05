
fifo = {
	GetTable = {}
}
fifo.__index = fifo

function fifo.Init(ply, Name, Sending)
	if fifo.GetTable[ Name ] then
		ErrorNoHalt("fifo.Init: ("..tostring(self.ply)..") '"..Name.."' already exists!\n")
		return
	end
	
	local Tab = setmetatable(
		{
			ply		= ply,
			Name	= Name,
			
			Sending	= table.Copy(Sending),
		},
		fifo
	)
	
	fifo.GetTable[ Name ] = Tab
	return Tab
end

function fifo:Remove()
	fifo.GetTable[ self.Name ] = nil
	self = {}; self = nil
end

function fifo:Forward()
	if not self.OnSend then
		ErrorNoHalt("fifo:Forward: ("..tostring(self.ply)..") self.OnSend gone!\n")
		return
	end
	
	local Idx  	= nil
	local This 	= nil
	local Sent	= nil
	
	//Select
	for k,v in pairs(self.Sending) do
		Idx  = k
		This = v
		break
	end
	
	//Send
	if Idx and This then
		Sent = true
		self.OnSend(self.ply, Idx,This, self)
		
		self.Sending[ Idx ] = nil
	end
	
	//AllDone
	if self.AllDone and not Sent then
		self.AllDone(self.ply, self)
	end
end




local ply = {}

local Sending = {
	1,
	2,
	3,
}

local FIFO = fifo.Init(ply, "TEST", Sending)

function FIFO.OnSend(ply, k,v, FIFO)
	print("! OnSend: ", k,v)
end

function FIFO.AllDone(ply, FIFO)
	print("! AllDone")
	FIFO:Remove()
end


FIFO:Forward()
FIFO:Forward()
FIFO:Forward()

FIFO:Forward()



do return end

local Sending = {}

local function OutBurst()
	local Idx  	= nil
	local This 	= nil
	
	for k,v in pairs(Sending) do
		Idx  = k
		This = v
		break
	end
	
	if Idx and This then
		PrintTable(This)
		
		Sending[ Idx ] = nil
	end
end
timer.Create("LOL", 1, 0, OutBurst)

table.insert(Sending, {1} )
table.insert(Sending, {2} )





















