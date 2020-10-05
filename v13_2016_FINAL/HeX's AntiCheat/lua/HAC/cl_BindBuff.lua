
local pairs			= pairs
local NotRCC		= RunConsoleCommand
local NotFR			= file.Read
local NotTS			= timer.Simple
local NotJST		= util.TableToJSON
local NotSL			= string.lower
local NotSLF		= string.Left
local NotSST		= string.Split
local NotSS			= string.sub
local NotSTT		= string.Trim
local NotNSX		= net.SendEx
local NotTIS		= function(k,v) k[#k+1] = v end
local Binds 		= { config = {} }

local function Buff()
	local Cont = NotFR("cfg/config.cfg", "MOD")
	if Cont then
		for k,v in pairs( NotSST(Cont,"\n") ) do
			if NotSL( NotSLF(v,5) ) == "bind " then
				NotTIS(Binds.config, NotSTT( NotSS(v,5) ) )
			end
		end
	else
		NotRCC("whoops", "BBuff=NoCont")
	end
	
	local Cont = NotFR("cfg/autoexec.cfg", "MOD")
	if Cont then
		Binds.autoexec = Cont
	end
	
	NotNSX("Buff", NotJST(Binds), nil,nil,true)
end
NotTS(2, Buff)








