





local DoHooks = {
	["Think"] 		= true,
	["CreateMove"]	= true,
}


local hookCall = Call

function Call(name,gm,...)
	if DoHooks and DoHooks[name] then
		DoHooks[name] = nil
	end
	return hookCall(name,gm,...)
end















