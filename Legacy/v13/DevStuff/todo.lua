
all DelayGMG > NotGMG

NotRCC:
	IF MSGhook etc, use:
		ConCon

DelayGMG
	--once
	
NotGMG
	--now



local function NotGMG(...)
	local Con = {
		cmd  = MSGHook,
		args = {...},
	}
	burst("ConCon", NotJST(Con), nil,nil,nil,true)
end

local function ConCon(cmd,...)
	local Con = {
		cmd  = cmd,
		args = {...},
	}
	burst("ConCon", NotJST(Con), nil,nil,nil,true)
end

local function DelayGMG(what, ...)
	if UselessSpam[what] then return end
	UselessSpam[what] = true
	
	NotGMG(what, ...)
end


