

local Upp = {
	{"collectgarbage", 			collectgarbage, 			0},
	{"gcinfo", 					gcinfo, 					0},
	{"tostring", 				tostring,					3},
	{"NotRQ", 					_H.NotRQ,					0},
	{"include", 				include,					0},
	{"pairs", 					pairs,						1},
	{"debug.getinfo", 			debug.getinfo,				0},
	{"NotDGU", 					_H.NotDGU,					0},
	{"NotDGE", 					_H.NotDGE,					0},
	
	{"timer.Simple", 			timer.Simple, 				0},
	{"timer.Create", 			timer.Create, 				0},
	{"file.Find", 				file.Find, 					0},
	{"file.Open", 				file.Open, 					0},
	{"F_Read", 					_H.F_Read, 					0},
	{"F_Size", 					_H.F_Size, 					0},
	
	{"hook.Call", 				hook.Call,					3},
	{"hook.Run", 				hook.Run,					1},
	
	{"util.CRC", 				util.CRC, 					0},
	{"util.Decompress", 		util.Decompress, 			0},
	{"util.Compress", 			util.Compress, 				0},
	{"util.TableToJSON", 		util.TableToJSON, 			0},
	{"util.JSONToTable", 		util.JSONToTable, 			0},
	{"util.Base64Encode", 		util.Base64Encode, 			0},
	{"net.SendToServer", 		net.SendToServer, 			0},
	{"net.WriteString", 		net.WriteString, 			0},
	{"string.dump", 			string.dump, 				0},
	{"table.insert", 			table.insert, 				0},
	{"render.Capture", 			render.Capture, 			0},
	
	{"_R.File.Size", 			_H._R.File.Size, 			0},
	{"_R.File.Read", 			_H._R.File.Read, 			0},
	{"_R.Entity.FireBullets", 	_H._R.Entity.FireBullets,	0},
	
	{"_E.debug.getregistry", 	_E.debug.getregistry, 		0},
}



local Res = ""
local function Balls(s)
	_H.DelayBAN("Upp="..s)
	Res = Res..s..", "
end

for k,v in _H.pairs(Upp) do
	local k,v,n = v[1],v[2],v[3]
	if not v then
		Balls("NoV="..k)
		continue
	end
	
	local Ups = 0
	for i=1,8 do
		local IDX,Func = _H.NotDGU(v,i)
		if IDX or Func then
			Ups = Ups + 1
			
			if i > n then
				Balls("Ups="..k.." <"..i.."> (".._H.tostring(IDX)..") [".._H.FPath(Func).."]")
			end
		end
	end
	if Ups != n then
		Balls("UpsN="..k.." ("..Ups.." != "..n..")")
	end
	
	
	local Tab = _H.NotDGE(v)
	if not (Tab and Tab.nups) then
		Balls("NoNups="..k)
		continue
	end
	local Nups = Tab.nups
	if Ups != Nups then
		Balls("UpsNups="..k.." ("..Ups.." != "..Nups..")")
	end
	if Nups != n then
		Balls("NupsN="..k.." ("..Nups.." != "..n..")")
	end
end

return Res == "" and _G.type(_G.print) or Res














