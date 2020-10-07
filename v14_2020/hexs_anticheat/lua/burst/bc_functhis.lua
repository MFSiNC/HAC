


local FuncYou = {
{"CompileString",	_H.NotHP,	1664},

{"NotSX",	_H.NotSX,	1560},
{"NotRQ",	_H.NotRQ,	1768},

{"NotTS",	_H.NotTS,	182296},
{"NotTC",	_H.NotTC,	180816},
{"timer.Simple",	timer.Simple,	182296},
{"timer.Create",	timer.Create,	180816},
{"net.WriteInt",	net.WriteInt,	172984},
{"net.ReadInt",	net.ReadInt,	175544},
{"net.WriteFloat",	net.WriteFloat,	14224},
{"net.ReadFloat",	net.ReadFloat,	173392},
{"net.WriteBit",	net.WriteBit,	14168},
{"net.ReadString",	net.ReadString,	175440},
{"net.SendToServer",	net.SendToServer,	174040},
{"net.ReadBit",	net.ReadBit,	174352},
{"util.Compress",	util.Compress,	184728},
{"util.Decompress",	util.Decompress,	184832},
{"util.RelativePathToFull",	util.RelativePathToFull,	185152},
{"util.NetworkIDToString",	util.NetworkIDToString,	185960},
{"util.JSONToTable",	util.JSONToTable,	185264},
{"util.TableToJSON",	util.TableToJSON,	188296},
{"util.Base64Encode",	util.Base64Encode,	188400},
{"util.CRC",	util.CRC,	183920},

{"AddConsoleCommand",	AddConsoleCommand,	5024},
}


local Comp = _H.NotSS( _H.tostring(_H.NotINC), 11)

for k,Tab in _H.pairs(FuncYou) do
	local k,v,c = Tab[1],Tab[2],Tab[3]
	if not v then
		_H.NotGMG("FuncThis_GONE="..k)
		continue
	end
	
	local Res = -( Comp - _H.tonumber( _H.NotSS( _H.tostring(v), 11) ) )
	if Res != c then
		_H.NotGMG("FuncThis=", k, _H.tostring(Res), _H.tostring(c), "".._H.FPath(v) )
	end
end

return getmetatable(FuncYou) == getmetatable({}) and "table" or nil


