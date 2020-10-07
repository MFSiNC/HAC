HAC.Garbage = {
	GCI_Static = {1905, 7037}
}

--Top
HAC.Garbage.Top = {
	[1905] = true,
	[7037] = true,
}

--[[
//Bottom
HAC.Garbage.Bottom = {
	--Fixme
}
]]
if HAC.Garbage.GateHook then return end --Don't reload below!

--GateHook
function HAC.Garbage.GateHook(self, Args1, args, what)
	if not ValidString(args[2]) then return INIT_BAN, "HAC.Garbage.GateHook: args[1] invalid!" end
	if not ValidString(args[3]) then return INIT_BAN, "HAC.Garbage.GateHook: args[2] invalid!" end
	local count_top = args[2]
	local count_end = args[3]

	--collectgarbage
	if Args1 == "CGBCount" then
		--Double
		if self.HAC_CGBCountInit then return INIT_BAN, "CGBCount DOUBLE count_top [[" .. count_top .. "]], count_end [[" .. count_end .. "]]" end
		--No "."
		local Good = true

		if not count_top:find(".") then
			Good = false
			self:DoBan("CGBCount count_top: no '.' in count [[" .. count_top .. "]]")
		end

		if not count_end:find(".") then
			Good = false
			self:DoBan("CGBCount count_end: no '.' in count [[" .. count_end .. "]]")
		end

		if not Good then return INIT_DO_NOTHING end
		--Already done
		if self:VarSet("CGBCount_Top") then return INIT_BAN, "CGBCount_Top DOUBLE [[" .. count_top .. "]]" end
		if self:VarSet("CGBCount_Bottom") then return INIT_BAN, "CGBCount_Bottom DOUBLE [[" .. count_end .. "]]" end
		--Fucked with
		local Top = tonumber(count_top)
		local End = tonumber(count_end)

		if not Top or not isnumber(Top) then
			Good = false
			self:DoBan("No CGBCount_Top! [[" .. count_top .. "]]")
		end

		if not End or not isnumber(End) then
			Good = false
			self:DoBan("No CGBCount_Bottom! [[" .. count_end .. "]]")
		end

		--Check
		if Good then
			self.HAC_CGBCountInit = true
			self:LogGarbage("CGBCount_1", count_top)
			self:LogGarbage("CGBCount_2", count_end)
			--Log, top
			Top = math.Round(Top)

			if not HAC.Garbage.Top[Top] then
				--Good = false
				self:LogOnly("CGBCount_Top " .. count_top)
			end

			--HeX, allow to set temp count
			if self:HAC_IsHeX() then
				HAC.Garbage.Top[Top] = true
			end

			--[[
			//Log, Bottom
			if not HAC.Garbage.Bottom[ End ] then
				Good = false
				self:LogOnly("CGBCount_Bottom "..count_end)
			end
			]]
			--Still good, didn't send fake/unknown data
			if Good then
				self.HAC_CGBCount_Good = true
			end
		end
		--gcinfo
	elseif Args1 == "GCICount" then
		--Double
		if self.HAC_GCICountInit then return INIT_BAN, "GCICount DOUBLE count_top [[" .. count_top .. "]], count_end [[" .. count_end .. "]]" end
		--Already done
		if self:VarSet("GCICount_Top") then return INIT_BAN, "GCICount_Top DOUBLE [[" .. count_top .. "]]" end
		if self:VarSet("GCICount_Bottom") then return INIT_BAN, "GCICount_Bottom DOUBLE [[" .. count_end .. "]]" end
		--Fucked with
		local Top = tonumber(count_top)
		local End = tonumber(count_end)
		local Good = true

		if not Top or not isnumber(Top) then
			Good = false
			self:DoBan("No GCICount_Top! [[" .. count_top .. "]]")
		end

		if not End or not isnumber(End) then
			Good = false
			self:DoBan("No GCICount_Bottom! [[" .. count_end .. "]]")
		end

		--Check
		if Good then
			self.HAC_GCICountInit = true
			self:LogGarbage("GCICount_1", count_top)
			self:LogGarbage("GCICount_2", count_end)

			--Log, top
			if not HAC.Garbage.GCI_Static[Top] then
				--Good = false
				self:LogOnly("GCICount_Top " .. count_top)
			end

			--HeX, allow to set temp count
			if self:HAC_IsHeX() then
				HAC.Garbage.GCI_Static[Top] = true
			end

			--[[
			//Log, Bottom
			if not HAC.Garbage.GCI_Static[ End ] then
				Good = false
				self:LogOnly("GCICount_Bottom "..count_end)
			end
			]]
			--Still good, didn't send fake/unknown data
			if Good then
				self.HAC_GCICount_Good = true
			end
		end
	end

	return INIT_DO_NOTHING
end

HAC.Init.GateHook("CGBCount", HAC.Garbage.GateHook)
HAC.Init.GateHook("GCICount", HAC.Garbage.GateHook)
HAC.Init.Add("HAC_CGBCountInit", HAC.Msg.SE_Count, INIT_LONG)
HAC.Init.Add("HAC_GCICountInit", HAC.Msg.SE_Count, INIT_LONG)

--Log
function _R.Player:LogGarbage(typ, count)
	local Log = Format("\n[%s] %s: %s - %s", HAC.Date(), typ, count, self:HAC_Info())
	HAC.file.Append("hac_gcicount.txt", Log)
end

--Correct
function _R.Player:IsReady()
	return self.HAC_DoneGarbageLoop
end

--Check everyone's inits, then call Ready hook
function HAC.Garbage.Check()
	for k, v in Everyone() do
		if v.HAC_DoneGarbageLoop then continue end
		if not v:IsPathReady() then continue end --Skip waiting players, sv_GPath
		if not (v.HAC_CGBCount_Good and v.HAC_GCICount_Good) then continue end --Skip if not passed collectgarbage / gcinfo
		v.HAC_DoneGarbageLoop = true
		HAC.COLCON(HAC.GREEN, "[HAC] " .. v:Nick() .. " is ready! [" .. v:Time() .. "]")
		hook.Run("HACPlayerReady", v)
	end
end

timer.Create("HAC.Garbage.Check", 0.2, 0, HAC.Garbage.Check)

--Reload counts
local function Add(Tab)
	for k, v in pairs(Tab) do
		HAC.Garbage.GCI_Static[tonumber(tostring(k):sub(0, 4))] = true
	end
end

function HAC.Garbage.Update()
	HAC.Garbage.GCI_Static = {}
	--Tables from here
	Add(HAC.Garbage.Top)
	--Add(HAC.Garbage.Bottom)
end

HAC.Garbage.Update()

function HAC.Garbage.Command(self)
	include("hac/sv_Garbage.lua")
	HAC.Garbage.Update()
	self:print("[HAC] Reloading garbage..")

	for k, v in pairs(HAC.Garbage.Top) do
		self:print("   " .. tostring(k))
	end

	self:print("[HAC] Done\n")
end

concommand.Add("garbage", HAC.Garbage.Command)
concommand.Add("gg", HAC.Garbage.Command)
