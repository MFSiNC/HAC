
print( "Testing FapHack detection methods" )

-- Detects all detours
print( "1:", debug.getupvalue( file.Read, 1 ) ~= nil )


-- Bonus: messed up FapHack WHILE detecting it
print( "3:", debug.setupvalue( ConVarExists, 2, {} ) ~= nil ) -- Sets FapHack table to {}

