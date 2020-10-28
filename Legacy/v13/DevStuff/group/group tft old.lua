

do return end

local ACS = "103582791434419294"
local ACS32 = "1247312"

local UH_64 = "103582791430768725"
local UH_32 = "1247317"





print("! gid_64: ", tonumber(UH_64) )




local function G_64To32(gid_64)
	return tostring( (tonumber(gid_64) - 103582791429521408) )
end


function gmp_shiftl(x,n)
    return x * math.pow(2, n)
end
local function G_32To64(gid_32)
	--print ((1 << 56) | (7 << 52) | 1497026)
	--return ( bit.lshift(1 << 56) | bit.lshift(7 << 52) | tonumber(gid_32) )
	
	--return bit.bor( bit.lshift(1,56), bit.lshift(7,52), tonumber(gid_32) )
	
	return tostring( bit.bor(
		bit.bor(
			bit.lshift(1,56),
			bit.lshift(7,52)
		),
		
		gid_32
	) )
end


print("! G_32To64: ", G_32To64(UH_32), G_32To64(UH_32) == UH_64 )

print("! G_64To32: ",  G_64To32(UH_64), G_64To32(UH_64) == UH_32 )





do return end

local bad = "76561198043687911" --skiddles
local good = "76561197995883976"


local SID = good

--http://steamcommunity.com/gid/[g:1:1247317] --UH

--[[
{
	"name": "GetUserGroupList",
	"version": 1,
	"httpmethod": "GET",
	"parameters": [
		{
			"name": "key",
			"type": "string",
			"optional": false,
			"description": "access key"
		},
		{
			"name": "steamid",
			"type": "uint64",
			"optional": false,
			"description": "SteamID of user"
		}
	]
	
},
]]

