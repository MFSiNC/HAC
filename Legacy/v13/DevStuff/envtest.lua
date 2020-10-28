

local NotJTT = util.JSONToTable
local NotCRC = util.CRC
local NotCS = CompileString
local NotJST = util.TableToJSON


local DelayGMG = function(s) MsgC(HAC.BLUE, s.."\n") end
local burst = print
local NotRCC = RCC
local NotDGE = debug.getinfo
local NotDGU = debug.getupvalue


local function test(Cont)
	Cont = NotJTT(Cont)
	
	local Err = ""
	local CME = {}
		CME.CRC = NotCRC(Cont.Cont..Cont.Ras)
		CME.Ran,CME.Ret = xpcall(NotCS(Cont.Cont,Cont.Ras), function(e) if e then Err = e end end, DelayGMG,burst,NotRCC,NotDGE,NotDGU)
		CME.Err = Err
	--CME = NotJST(CME)
	
	PrintTable(CME)
end


local function fuck(str)
	str = NotJST(
		{
			Cont = str,
			Ras = "t",
		}
	)
	
	test(str)
end

--fuck("local arg = {...}; local lol = arg[1]; print(lol)")
fuck([[
	local DelayGMG,burst,NotRCC,NotDGE,NotDGU=...;
	
	DelayGMG( tostring(burst) )
]])








