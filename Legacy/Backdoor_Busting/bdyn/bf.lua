--[GTL] I'M IN YOUR LUA! STEALING YOUR HAX...

local bf = {}
bf.mt = {}
bf.maxidx = 30000

bf.dif = (
	function()
		return 0
	end
)

bf.new = (
	function(ipf, prg, msg)
		local bfi = {}

		bfi.ptr = 0
		bfi.tbl = {[0] = 0}
		bfi.ipf = ipf or bf.dif
		bfi.prg = prg or ""
		bfi.msg = msg or ""

		setmetatable(bfi, bf.mt)

		return bfi
	end
)

bf.dop = (
	function(prg, msg)
		local bfi = bf.new(nil, prg, msg)

		bfi:run()

		print(bfi.msg)
	end
)


bf.mt.__index = bf.mt

bf.mt.bfdo = (
	function(self, idx)
		local op = self.prg[idx]

		if (op == nil) then
			return
		end

		if (op == ">") then

			self.ptr = (self.ptr + 1) % bf.maxidx

			if (self.tbl[self.ptr] == nil) then
				self.tbl[self.ptr] = 0
			end

		elseif (op == "<") then

			self.ptr = (self.ptr + (bf.maxidx - 1)) % bf.maxidx

			if (self.tbl[self.ptr] == nil) then
				self.tbl[self.ptr] = 0
			end

		elseif (op == "+") then

			self.tbl[self.ptr] = self.tbl[self.ptr] + 1

		elseif (op == "-") then

			self.tbl[self.ptr] = self.tbl[self.ptr] - 1

		elseif (op == ".") then

			self.msg = self.msg .. string.char(self.tbl[self.ptr])

		elseif (op == ",") then

			self.tbl[self.ptr] = self.ipf()

		elseif (op == "[") then

			local oprg = self.prg
			local bitbot = ""
			local nidx = idx + 1
			local ccount = 1

			while(nidx < self.prg:len()) do
				if (self.prg[nidx] == "]") then
					ccount = ccount - 1

					if (ccount == 0) then
						nidx = nidx + 1
						break
					end
				elseif (self.prg[nidx] == "[") then
					ccount = ccount + 1
				end

				bitbot = bitbot .. self.prg[nidx]

				nidx = nidx + 1
			end

			while(self.tbl[self.ptr] ~= 0) do
				self:run(bitbot, self.msg)
			end

			self.prg = oprg

			return self:bfdo(nidx)

		end

		if (idx ~= self.prg:len()) then
			return self:bfdo(idx + 1)
		else
			return
		end
	end
)

bf.mt.run = (
	function(self, prg, msg)
		self.prg = prg or self.prg
		self.msg = msg or self.msg

		self:bfdo(1)
	end
)


bf.dop(
	"++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>.",
	"[BF] "
)