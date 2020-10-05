


include("Minify_new.lua")




local New = file.Read("en_hac.lua", "DATA")

New = New:Obfuscate(false,"StealingMyFiles")

HAC.file.Write("hac.txt", New)
print("! saved: ", #New )

HAC.file.Rename("hac.txt", ".lua")



local Run = "function poo()\n"..HAC.file.Read("hac.lua").."\nend"
--MsgC(HSP.YELLOW, Run)

print( CompileString(Run, "Test") )

minify.NiceFile("hac.lua")



