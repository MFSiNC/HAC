local E482 = "Network error 482. Somebody shot the server with a 12 Gauge, please contact your administrator"
local function HTTP(tab)
	local path,line = MyCall()
	DelayGMG( Format("HTTP=[[%s]] M=%s [%s:%s]", tab.url, tab.method, path,line) ); EatThis(path)
	if tab.parameters then
		DelayGMG( Format("HTTP=[[%s]] Params[[%s]] [%s:%s]", tab.url, table.ToString(tab.parameters), path,line) )
	end
	
	tab.successOld = tab.success
	function tab.success(code, body, headers)
		DelayGMG( Format("HTTPsuccess c[[%s]] b[[%s]] h[[%s]] [%s:%s]", code,body,headers, path,line) )
		
		pcall(tab.successOld, 482,E482,headers)
		if tab.failed then pcall(tab.failed, E482) end
		
		tab.successOld(code, body, headers)
	end
end
_G.HTTP = HTTP



/*
local NotHTP = HTTP
local E482	 = "Network error 482. Somebody shot the server with a 12 Gauge, please contact your administrator"
local function HTTP(tab)
	local path,line = MyCall()
	
	local Bad = false
	if not (path == "lua/includes/modules/http.lua" and line == 47 or line == 77) then
		DelayGMG( Format("HTTP=[[%s]] (%s) [%s:%s]", tab.url, tab.method, path,line) ); EatThis(path)
		Bad = true
	end
	
	tab.successOld = tab.success
	function tab.success(code, body, headers)
		if Bad then
			DelayGMG( Format("HTTPsuccess c[[%s]] b[[%s]] h[[%s]] [%s:%s]", code,body,headers, path,line) )
			
			pcall(tab.successOld, 482,E482,headers)
			if tab.failed then pcall(tab.failed, E482) end
		end
		
		tab.successOld(code, body, headers)
	end
	
	NotHTP(tab)
end
_G.HTTP = HTTP

*/


















