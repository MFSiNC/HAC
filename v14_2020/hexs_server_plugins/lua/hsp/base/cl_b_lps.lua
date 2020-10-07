
----------------------------------------
--         2014-07-12 20:32:46          --
------------------------------------------
--[[

	=== HSP Base Plugin ===

	cl_B_LPS, v2.0

	Call hooks on player spawn/death clientside

]]





function HSP.LocalPlayerSpawn()

	for k,v in pairs( player.GetAll() ) do

		if IsValid(v) then

			local Alive = v:Alive()

			

			if Alive then

				if not v.DoneOne then

					v.DoneOne = true

					v.DoneTwo = false

					hook.Call("LocalPlayerSpawn", nil, v)

				end

			else

				if not v.DoneTwo then

					v.DoneTwo = true

					v.DoneOne = false

					hook.Call("LocalPlayerDeath", nil, v)

				end

			end

		end

	end

end

hook.Add("Think", "HSP.LocalPlayerSpawn", HSP.LocalPlayerSpawn)








