


local FuncYou = {
{"CompileString",	_H.NotHP,	872},

{"NotSX",	_H.NotSX,	808},
{"NotRQ",	_H.NotRQ,	944},

{"NotTS",	_H.NotTS,	20328},
{"NotTC",	_H.NotTC,	19200},
{"timer.Simple",	_E.timer.Simple,	20328},
{"timer.Create",	_E.timer.Create,	19200},

{"file.Open",	_E.file.Open,	11488},
{"file.Exists",	_E.file.Exists,	11040},
{"file.Time",	_E.file.Time,	11360},
{"file.Size",	_E.file.Size,	11424},
{"file.Delete",	_E.file.Delete,	11232},
{"file.Find",	_E.file.Find,	11168},

{"net.WriteInt",	_E.net.WriteInt,	15944},
{"net.ReadInt",	_E.net.ReadInt,	16072},
{"net.WriteFloat",	_E.net.WriteFloat,	13416},
{"net.ReadFloat",	_E.net.ReadFloat,	14720},
{"net.WriteBit",	_E.net.WriteBit,	13544},
{"net.WriteString",	_E.net.WriteString,	13608},
{"net.ReadString",	_E.net.ReadString,	15880},
{"net.WriteDouble",	_E.net.WriteDouble,	13480},
{"net.SendToServer",	_E.net.SendToServer,	14456},
{"net.ReadBit",	_E.net.ReadBit,	14656},


{"util.Compress",	_E.util.Compress,	23800},
{"util.Decompress",	_E.util.Decompress,	25408},
{"util.RelativePathToFull",	_E.util.RelativePathToFull,	25616},
{"util.NetworkIDToString",	_E.util.NetworkIDToString,	23272},
{"util.JSONToTable",	_E.util.JSONToTable,	25688},
{"util.TableToJSON",	_E.util.TableToJSON,	25752},
{"util.Base64Encode",	_E.util.Base64Encode,	25816},
{"util.CRC",	_E.util.CRC,	22856},

{"AddConsoleCommand",	_E.AddConsoleCommand,	3008},
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

return _E.type(FuncYou)


