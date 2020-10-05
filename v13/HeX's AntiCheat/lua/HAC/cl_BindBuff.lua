
local NotRCC		= RunConsoleCommand
local NotFR			= file.Read
local NotTS			= timer.Simple
local NotJST		= util.TableToJSON

local function Buff()
	local Cont = NotFR("cfg/config.cfg", "MOD")
	if not Cont then
		NotRCC("whoops", "BBuff=NoCont")
		return
	end
	
	local Binds = {}
	for k,v in pairs( Cont:Split("\n") ) do
		if v:Left(5) == "bind " then
			table.insert(Binds, v:sub(#"bind "):Trim() )
		end
	end
	
	hacburst.Send("Buff", NotJST(Binds), nil,nil,true)
end
NotTS(2, Buff)

local function HAC_PEX(um)
	LocalPlayer():ConCommand( um:ReadString() )
end
usermessage.Hook("HAC.PEX", HAC_PEX)





