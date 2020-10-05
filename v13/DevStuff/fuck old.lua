			local Out = NotFO(This, "rb", "GAME")
			
				local Size = Out:Size()
				
				for i=0, Size do
					Out:Seek(i)
					local char = Out:Read(1)
					
					if char == "\0" then
						ThisTab[i] = "ZZZ"
					else
						ThisTab[i] = char
						
						if char then
							ThisDLL = ThisDLL..char
						end
					end
				end
			Out:Close()
			
			local tab = {
				Bin 	= ThisTab,
				Name	= v,
				Type	= typ,
				CRC		= NotCRC( ThisDLL:lower() ),
			}
			
			print("! Raw: ", Size, " ThisTab: ", table.Count(ThisTab) )
			
			
			local test = util.Compress( util.TableToJSON(tab) )
			print("! util>JSON: ", #test)
			--local lol = util.Compress(ThisDLL)
			
			--print(v, "raw: ", #ThisDLL, " util: ", #lol, "b64: ", #base64.enc(ThisDLL), " von:", #encode({Bin=ThisDLL}) )
			

			local test = util.Compress( base64.enc( encode({Bin=ThisDLL}) ) )
			print("! util>b64>von: ", # test)
			
			local dec = decode( base64.dec( util.Decompress(test) ) )
			print("! ", dec.Bin == ThisDLL )


			local test = base64.enc( util.Compress( util.TableToJSON(tab) ) )
			print("! b64>util>JSON: ", #test)
			
			local test = base64.enc( util.TableToJSON(tab) )
			print("! b64>JSON: ", #test)
			
			
			local test = util.Compress( encode(tab) )
			print("! util>von: ", #test)
			
			local test = base64.enc( encode(tab) )
			print("! b64>von: ", # test)


