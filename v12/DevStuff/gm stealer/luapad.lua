
 -- Luapad
 -- An in-game scripting environment
 -- by DarKSunrise aka Assassini
 
if not datastream then
 require("datastream");
end
 require("rawio"); --why not do the same to rawio? Because I WANT the functions to be returns to default, so I can overwite them again.

local RawIOProtection = true
if RawIOProtection == true and rawio then --let nobody write outside the garrysmod folder! (kinda) And oly write .txt and .lua files. Things this can't stop: Somebody making a local copy of the funcs before this script gets to them. This will probably stop most script kiddies, though.
	local OldWrite = rawio.writefile
	function rawio.writefile(path,contents)
		if (string.find(path,"garrysmod/garrysmod") or string.find(path,"garrysmod\\garrysmod")) and (string.find(path,".txt") or string.find(path,".lua")) then
			return OldWrite(path,contents)
		else
			ErrorNoHalt("Something tried to write "..path.." Possibly malicious?")
			return 0
		end
	end
	
	local OldDelete = rawio.deletefile
	function rawio.deletefile(path)
		ErrorNoHalt("Something tried to delete "..path.."!!!")
		return 0
	end
	
	local OldRead = rawio.readfile
	function rawio.deletefile(path)
		if (string.find(path,"garrysmod/garrysmod") or string.find(path,"garrysmod\\garrysmod")) and (string.find(path,".txt") or string.find(path,".lua")) then
			return OldRead(path,contents)
		else
			ErrorNoHalt("Something tried to read "..path.." Possibly malicious?")
			return 0
		end
	end
end
 
 luapad = {};
 luapad.OpenFiles = {};
 luapad.GModRoot = string.gsub(string.gsub(util.RelativePathToFull("gameinfo.txt"), "gameinfo.txt", ""), "\\", "/");
 
 luapad.RestrictedFiles = {
 "data/luapad/_server_globals.txt", "data/luapad/_cached_server_globals.txt",
 "addons/Luapad/data/luapad/_server_globals.txt", "addons/Luapad/data/luapad/_cached_server_globals.txt"
 };
 luapad.debugmode = false;
 luapad.forcedownload = true;
 luapad.IgnoreConsoleOpen = true;
 
 if(SERVER) then
	if(luapad.forcedownload) then
		AddCSLuaFile("autorun/luapad.lua");
		AddCSLuaFile("autorun/luapad_editor.lua");
	end
	
	local content = "-- This is an automatically generated cache file for serverside global functions, meta-tables, and enumerations\n-- Don't touch it, or you'll probably mess up your syntax highlighting\n\nluapad._sG = {};\n";
	local endcontent = "";
	
	for k,v in pairs(_G) do
		if(type(v) == "function" or type(v) == "table") then
			if(type(v) == "function") then
				content = content .. "luapad._sG[\"" .. k .. "\"] = \"f\";\n";
			else
				local hasfunc = false;
				for k,v in pairs(v) do
					if(type(v) == "function") then hasfunc = true; break; end
				end
				
				if(hasfunc) then
					content = content .. "luapad._sG[\"" .. k .. "\"] = {};\n";
					for k2,v2 in pairs(v) do
						if(type(v2) == "function") then
							endcontent = endcontent .. "luapad._sG[\"" .. k .. "\"]" .. "[\"" .. k2 .. "\"] = \"f\";\n";
						end
					end
				end
			end
		end
	end
	
	content = content .. endcontent;
	
	local content = content .. "\n\n-- Enumerations\n\n";
	
	for k,v in pairs(_E) do
		if((type(v) != "function" or type(v) != "table") && string.upper(k) == k) then
			content = content .. "luapad._sG[\"" .. k .. "\"] = \"e\";\n";
		end
	end
	
	local content = content .. "\n\n-- Meta-tables\n\n";
	
	for k,v in pairs(_R) do
		if(type(v) == "table") then
			local hasfunc = false;
			for k,v in pairs(v) do
				if(type(v) == "function") then hasfunc = true; break; end
			end
			
			if(hasfunc) then
				for k2,v2 in pairs(v) do
					if(type(v2) == "function" && !string.find(content, "luapad._sG[\"" .. k2 .. "\"] = \"m\";")) then
						content = content .. "luapad._sG[\"" .. k2 .. "\"] = \"m\";\n";
					end
				end
			end
		end
	end
	
	file.Write("luapad/_server_globals.txt", content);
	
	resource.AddFile("data/luapad/_server_globals.txt");
	resource.AddFile("data/luapad/_welcome.txt");
	resource.AddFile("data/luapad/_about.txt");
	
	if(luapad.forcedownload) then
		resource.AddFile("materials/gui/silkicons/box.vtf");
		resource.AddFile("materials/gui/silkicons/box.vmt");
		resource.AddFile("materials/gui/silkicons/computer.vtf");
		resource.AddFile("materials/gui/silkicons/computer.vmt");
		resource.AddFile("materials/gui/silkicons/disk.vtf");
		resource.AddFile("materials/gui/silkicons/disk.vmt");
		resource.AddFile("materials/gui/silkicons/disk_multiple.vtf");
		resource.AddFile("materials/gui/silkicons/disk_multiple.vmt");
		resource.AddFile("materials/gui/silkicons/folder.vtf");
		resource.AddFile("materials/gui/silkicons/folder.vmt");
		resource.AddFile("materials/gui/silkicons/folder_page_white.vtf");
		resource.AddFile("materials/gui/silkicons/folder_page_white.vmt");
		resource.AddFile("materials/gui/silkicons/page_white.vtf");
		resource.AddFile("materials/gui/silkicons/page_white.vmt");
		resource.AddFile("materials/gui/silkicons/page_white_add.vtf");
		resource.AddFile("materials/gui/silkicons/page_white_add.vmt");
		resource.AddFile("materials/gui/silkicons/page_white_delete.vtf");
		resource.AddFile("materials/gui/silkicons/page_white_delete.vmt");
		resource.AddFile("materials/gui/silkicons/page_white_go.vtf");
		resource.AddFile("materials/gui/silkicons/page_white_go.vmt");
		resource.AddFile("materials/gui/silkicons/page_white_star.vtf");
		resource.AddFile("materials/gui/silkicons/page_white_star.vmt");
	end
	
	function luapad.Upload(ply, handler, id, encoded, decoded)
		if(decoded && (ply:IsAdmin() or ply:IsSuperAdmin())) then
			RunString(decoded);
		end
	end
	
	datastream.Hook("luapad.Upload", luapad.Upload);
	
	function luapad.UploadClient(ply, handler, id, encoded, decoded)
		if(decoded && (ply:IsAdmin() or ply:IsSuperAdmin())) then
			datastream.StreamToClients(player.GetAll(),"luapad.DownloadRunClient",decoded)
		end
	end
	
	datastream.Hook("luapad.UploadClient", luapad.UploadClient);
	
	local function AcceptStream(ply, handler, id)
		if(ply:IsAdmin() or ply:IsSuperAdmin()) and (handler == "luapad.Upload" or handler == "luapad.UploadClient") then return true; end
		if(!ply:IsAdmin()) and (handler == "luapad.Upload" or handler == "luapad.UploadClient") then return false; end
	end
	
	hook.Add("AcceptStream", "luapad.AcceptStream", AcceptStream);

	return;
 end
 
 if (CLIENT) then
	function luapad.DownloadRunClient(handler, id, encoded, decoded)
		luapad.RunScriptClientFromServer(decoded)
	end
	datastream.Hook("luapad.DownloadRunClient",luapad.DownloadRunClient)
 end
 
 if(file.Exists("luapad/_server_globals.txt")) then
	RunString(file.Read("luapad/_server_globals.txt"));
 else
	RunString(file.Read("luapad/_cached_server_globals.txt"));
 end
 
 function luapad.About()
	if(!file.Exists("luapad/_about.txt")) then return; end
	luapad.AddTab("_about.txt", file.Read("luapad/_about.txt"), "data/luapad/");
 end
 
 function luapad.CheckGlobal(func)
	if(luapad._sG[func] != nil) then if(luapad.debugmode) then print("found " .. func .. " in luapad._sG"); end return luapad._sG[func]; end
	if(_E[func] != nil) then if(luapad.debugmode) then print("found " .. func .. " in _E"); end return _E[func]; end
	if(_G[func] != nil) then if(luapad.debugmode) then print("found " .. func .. " in _G"); end return _G[func]; end
	
	return false;
 end
 
function luapad.OnPlayerQuit() --save my open tabs you bastard!
	local tbl = luapad.OpenFiles or {}
	local savtbl = {}
	for k,v in ipairs(tbl) do
		local strTbl = string.Explode("/",v)
		savtbl[k] = {}
		savtbl[k].name = strTbl[#strTbl]
		savtbl[k].prename = string.Left(v,string.len(v)-string.len(strTbl[#strTbl]))
		savtbl[k].location = "../"..v
	end
	if savtbl and savtbl != {} then
		file.Write("luapad/savedtabs.txt",glon.encode(savtbl))
	end
end
 
 function luapad.Toggle()
	if(!luapad.Frame) then


		-- Build it, if it doesn't exist
		luapad.Frame = vgui.Create("DFrame");
		luapad.Frame:SetSize(ScrW() - 40, ScrH() / 1.5);
		luapad.Frame:SetPos(20, 20);
		luapad.Frame:SetTitle("Luapad");
		luapad.Frame:ShowCloseButton(false);
		luapad.Frame:MakePopup();
		
		luapad.CloseButton = vgui.Create("DSysButton", luapad.Frame);
		luapad.CloseButton:SetSize(16, 16);
		luapad.CloseButton:SetPos(luapad.Frame:GetWide() - luapad.CloseButton:GetWide() - 3, 3);
		luapad.CloseButton:SetType("close");
		luapad.CloseButton.DoClick = function() luapad.Toggle(); luapad.OnPlayerQuit(); end
		
		luapad.AboutButton = vgui.Create("DSysButton", luapad.Frame);
		luapad.AboutButton:SetSize(16, 16);
		luapad.AboutButton:SetPos(luapad.Frame:GetWide() - luapad.CloseButton:GetWide() - luapad.AboutButton:GetWide() - 6, 3);
		luapad.AboutButton:SetType("question");
		luapad.AboutButton.DoClick = function() luapad.About(); end
		
		luapad.Toolbar = vgui.Create("DPanelList", luapad.Frame);
		luapad.Toolbar:SetPos(3, 26);
		luapad.Toolbar:SetSize(luapad.Frame:GetWide() - 6, 22);
		luapad.Toolbar:SetSpacing(5);
		luapad.Toolbar:EnableHorizontal(true);
		luapad.Toolbar:EnableVerticalScrollbar(false);
		luapad.Toolbar.PerformLayout = function(self) 
			local Wide = self:GetWide();
			local YPos = 3;
			
			if(!self.Rebuild) then debug.Trace(); end 
			
			self:Rebuild();
			
			if(self.VBar && !m_bSizeToContents) then 
				self.VBar:SetPos(self:GetWide() - 16, 0);
				self.VBar:SetSize(16, self:GetTall());
				self.VBar:SetUp(self:GetTall(), self.pnlCanvas:GetTall());
				YPos = self.VBar:GetOffset() + 3;
				if(self.VBar.Enabled) then Wide = Wide - 16; end 
			end 
		   
			self.pnlCanvas:SetPos(3, YPos);
			self.pnlCanvas:SetWide(Wide);
			
			self:Rebuild();
			
			if(self:GetAutoSize()) then 
				self:SetTall(self.pnlCanvas:GetTall());
				self.pnlCanvas:SetPos(3, 3);
			end
		end
		
		local x,y = luapad.Toolbar:GetPos();
		luapad.PropertySheet = vgui.Create("DPropertySheet", luapad.Frame);
		luapad.PropertySheet:SetPos(3, y + luapad.Toolbar:GetTall() + 5);
		luapad.PropertySheet:SetSize(luapad.Frame:GetWide() - 6, luapad.Frame:GetTall() - 82);
		luapad.PropertySheet:SetPadding(1);
		luapad.PropertySheet:SetFadeTime(0);
		luapad.PropertySheet.____SetActiveTab = luapad.PropertySheet.SetActiveTab;
		luapad.PropertySheet.SetActiveTab = function(...)
			luapad.PropertySheet.____SetActiveTab(...);
			
			if(luapad.PropertySheet:GetActiveTab()) then
				local panel = luapad.PropertySheet:GetActiveTab():GetPanel();
				luapad.Frame:SetTitle("Luapad - " .. panel.path .. panel.name);
			end
		end
		luapad.PropertySheet:InvalidateLayout();
		

		if (file.Exists("luapad/savedtabs.txt")) then
			for k,v in pairs(glon.decode(file.Read("luapad/savedtabs.txt"))) do
				luapad.AddTab(v.name, file.Read(v.location), v.prename)
			end
		elseif(file.Exists("luapad/_welcome.txt")) then
			luapad.AddTab("_welcome.txt", file.Read("luapad/_welcome.txt"), "data/luapad/");
		else
			luapad.NewTab();
		end
		
		luapad.Statusbar = vgui.Create("DPanelList", luapad.Frame);
		luapad.Statusbar:SetPos(3, luapad.Frame:GetTall() - 25);
		luapad.Statusbar:SetSize(luapad.Frame:GetWide() - 6, 22);
		luapad.Statusbar:SetSpacing(5);
		luapad.Statusbar:EnableHorizontal(true);
		luapad.Statusbar:EnableVerticalScrollbar(false);
		luapad.Statusbar.PerformLayout = luapad.Toolbar.PerformLayout;
		luapad.Statusbar:InvalidateLayout();
		
		luapad.AddToolbarItem("New (CTRL + N)", "gui/silkicons/page_white_add", luapad.NewTab);
		luapad.AddToolbarItem("Open (CTRL + O)", "gui/silkicons/folder_page_white", luapad.OpenScript); 
		luapad.AddToolbarItem("Save (CTRL + S)", "gui/silkicons/disk", luapad.SaveScript);
		luapad.AddToolbarItem("Save As (CTRL + ALT + S)", "gui/silkicons/disk_multiple", luapad.SaveAsScript);
		luapad.AddToolbarSpacer()
		luapad.AddToolbarItem("Close tab", "gui/silkicons/page_white_delete", luapad.CloseActiveTab);
		luapad.AddToolbarItem("Run script", "gui/silkicons/page_white_go", function()
			local menu = DermaMenu();
			menu:AddOption("Run clientside", luapad.RunScriptClient);
			menu:AddOption("Run serverside", luapad.RunScriptServer);
			menu:AddOption("Run shared", function() luapad.RunScriptClient(); luapad.RunScriptServer(); end);
			menu:AddOption("Run on all clients", luapad.RunScriptServerClient)
			menu:Open();
		end);
	else
		luapad.Frame:SetVisible(!luapad.Frame:IsVisible());
	end
 end
 
 function luapad.AddToolbarItem(tooltip, mat, func)
	local button = vgui.Create("DImageButton");
	button:SetImage(mat);
	button:SetTooltip(tooltip);
	button:SetSize(16, 16);
	button.DoClick = func;
	
	luapad.Toolbar:AddItem(button);
 end
 
 function luapad.AddToolbarSpacer()
	local lab = vgui.Create("DLabel");
	lab:SetText(" | ");
	lab:SizeToContents();
	
	luapad.Toolbar:AddItem(lab);
 end
 
 function luapad.SetStatus(str, clr)
	timer.Remove("luapad.Statusbar.Fade");
	luapad.Statusbar:Clear();
	
	local msg = vgui.Create("DLabel", luapad.Statusbar);
	msg:SetText(str);
	msg:SetTextColor(clr);
	msg:SizeToContents();
	
	timer.Create("luapad.Statusbar.Fade", 0.01, 0, function(clr)
		local msg = luapad.Statusbar:GetItems()[1];
		local col = msg:GetTextColor();
		col.a = math.Clamp(col.a - 1, 0, 255);
		msg:SetTextColor(Color(col.r, col.g, col.b, col.a));
		
		if(col.a == 0) then timer.Destroy("luapad.Statusbar.Fade"); end
	end);
	
	luapad.Statusbar:AddItem(msg);
	surface.PlaySound("common/wpn_select.wav");
 end
 
 function luapad.AddTab(name, content, path)
	content = content or ""
	path = path or "";
	content = string.gsub(content,"\t","	   ")
	
	local form = vgui.Create("DPanelList", luapad.PropertySheet);
	form:SetSize(luapad.PropertySheet:GetWide(), luapad.PropertySheet:GetTall() - 23);
	form.name = name;
	form.path = path;
 
	 local textentry = vgui.Create("LuapadEditor", form);
	textentry:SetSize(form:GetWide(), form:GetTall())
	textentry:SetText(content or "");
	textentry:RequestFocus();
	
	form:AddItem(textentry);
	
	table.insert(luapad.OpenFiles, path .. name);
	luapad.PropertySheet:AddSheet(name, form, "gui/silkicons/page_white", false, false);
	luapad.PropertySheet:SetActiveTab(luapad.PropertySheet.Items[table.Count(luapad.PropertySheet.Items)]["Tab"]);
	luapad.PropertySheet:InvalidateLayout();
 end
 
 function luapad.NewTab(content)
	 local n;
	if(type(content) != "string") then content = ""; end --nobody likes nil.
	
	for i = 1, 1000 do
		if(!file.Exists("luapad/untitled" .. i .. ".txt") && !table.HasValue(luapad.OpenFiles, "luapad/untitled" .. i .. ".txt")) then
			n = i;
			break;
		end
	end
	
	luapad.AddTab("untitled" .. n .. ".txt", content, "data/luapad/");
 end
 
 function luapad.CloseActiveTab()
	if(table.Count(luapad.PropertySheet.Items) == 1) then return; end
	
	local tabs = {};
	
	for k,v in pairs(luapad.PropertySheet.Items) do
		if(v["Tab"] != luapad.PropertySheet:GetActiveTab()) then
			table.insert(tabs, v["Panel"]);
			v["Tab"]:Remove();
			v["Panel"]:Remove();
		end
	end
	
	luapad.OpenFiles = {};
	luapad.PropertySheet:Remove();
	
	local x,y = luapad.Toolbar:GetPos();
	luapad.PropertySheet = vgui.Create("DPropertySheet", luapad.Frame);
	luapad.PropertySheet:SetPos(3, y + luapad.Toolbar:GetTall() + 5);
	luapad.PropertySheet:SetSize(luapad.Frame:GetWide() - 6, luapad.Frame:GetTall() - 82);
	luapad.PropertySheet:SetPadding(1);
	luapad.PropertySheet:SetFadeTime(0);
	luapad.PropertySheet.____SetActiveTab = luapad.PropertySheet.SetActiveTab;
	luapad.PropertySheet.SetActiveTab = function(...)
		luapad.PropertySheet.____SetActiveTab(...);
		
		if(luapad.PropertySheet:GetActiveTab()) then
			local panel = luapad.PropertySheet:GetActiveTab():GetPanel();
			luapad.Frame:SetTitle("Luapad - " .. panel.path .. panel.name);
		end
	end
	luapad.PropertySheet:InvalidateLayout();
	
	for k,v in pairs(tabs) do 
		luapad.AddTab(v.name, v:GetItems()[1]:GetValue(), v.path);
	end
 end
 
 function luapad.OpenScript()
	if(luapad.OpenTree) then luapad.OpenTree:Remove(); end
	
	local x,y = luapad.PropertySheet:GetPos();
	luapad.OpenTree = vgui.Create("DTree", luapad.Frame);
	 luapad.OpenTree:SetPadding(5);
	luapad.OpenTree:SetPos(x + (luapad.PropertySheet:GetWide() - luapad.PropertySheet:GetWide() / 4), y + 22);
	 luapad.OpenTree:SetSize(luapad.PropertySheet:GetWide() / 4, luapad.PropertySheet:GetTall() - 23);
	
	luapad.OpenTree.DoClick = function()
		local node = luapad.OpenTree:GetSelectedItem();
		local format = string.Explode(".", node.Label:GetValue())[#string.Explode(".", node.Label:GetValue())];
		
		if(#string.Explode(".", node.Label:GetValue()) != 1 && (format == "txt" or rawio)) then
			if(rawio) then
				print(node.Path);
				luapad.AddTab(node.Label:GetValue(), rawio.readfile(luapad.GModRoot .. node.Path .. node.Label:GetValue()), node.Path);
			else
				print(node.Path);
				luapad.AddTab(node.Label:GetValue(), file.Read(string.gsub(node.Path, "data/", "") .. node.Label:GetValue()), node.Path);
			end
			luapad.OpenTree:Remove();
		end
	end	
	
	luapad.OpenCloseButton = vgui.Create("DSysButton", luapad.OpenTree);
	luapad.OpenCloseButton:SetSize(16, 16);
	luapad.OpenCloseButton:SetPos(luapad.OpenTree:GetWide() - 20, 4);
	luapad.OpenCloseButton:SetType("close");
	luapad.OpenCloseButton:SetTooltip("Close");
	luapad.OpenCloseButton.DoClick = function() luapad.OpenTree:Remove(); end
	
	 local node = luapad.OpenTree:AddNode("garrysmod\\data"); -- TODO: luapad.CreateFolder() function for this
	node.RootFolder = "data";
	 node:MakeFolder("data", true);
	node.Icon:SetImage("gui/silkicons/computer");
	
	node.AddNode = function(self, strName)
		self:CreateChildNodes();
		
		local pNode = vgui.Create("DTree_Node", self);
		pNode:SetText(strName);
		pNode:SetParentNode(self); 
		pNode:SetRoot(self:GetRoot()); 
		pNode.AddNode = self.AddNode;
		pNode.Folder = pNode:GetParentNode();
		pNode.Path = "";
		
		local folder = pNode.Folder;
		
		while(folder) do
			if(folder.Label) then
				if(folder.Label:GetValue() != "garrysmod\\data" &&
				folder.Label:GetValue() != "garrysmod\\lua" &&
				folder.Label:GetValue() != "garrysmod\\gamemodes" &&
				folder.Label:GetValue() != "garrysmod\\addons") then -- TODO: luapad.CreateFolder() function for this
					pNode.Path = folder.Label:GetValue() .. "/" .. pNode.Path;
				end
			else
				break;
			end
			
			folder = folder:GetParentNode();
		end
		
		local ffolder = pNode.Folder;
		local root = self.RootFolder;
		
		while(ffolder && !root) do
			if(ffolder.RootFolder) then
				root = ffolder.RootFolder;
				break;
			end
			
			ffolder = ffolder:GetParentNode();
		end
		
		pNode.Path = root .. "/" .. pNode.Path;
		
		if(table.HasValue(luapad.RestrictedFiles, pNode.Path .. pNode.Label:GetValue())) then pNode:Remove(); return; end
		
		local format = string.Explode(".", strName)[#string.Explode(".", strName)];
		
		if(format == strName) then
			pNode.Icon:SetImage("gui/silkicons/folder");
		elseif(format == "txt" or rawio) then
			pNode.Icon:SetImage("gui/silkicons/page_white");
		else
			pNode.Icon:SetImage("gui/silkicons/page_white_delete");
		end
		
		self.ChildNodes:AddItem( pNode ) 
		self:InvalidateLayout() 
		return pNode;
	end 
	
	if(rawio) then
		local node2 = luapad.OpenTree:AddNode("garrysmod\\lua"); -- TODO: luapad.CreateFolder() function for this
		node2.RootFolder = "lua";
		node2:MakeFolder("lua", true);
		node2.Icon:SetImage("gui/silkicons/folder_page_white");
		node2.AddNode = node.AddNode;
		
		local node2 = luapad.OpenTree:AddNode("garrysmod\\addons"); -- TODO: luapad.CreateFolder() function for this
		node2.RootFolder = "addons";
		node2:MakeFolder("addons", true);
		node2.Icon:SetImage("gui/silkicons/box");
		node2.AddNode = node.AddNode;
		
		local node2 = luapad.OpenTree:AddNode("garrysmod\\gamemodes"); -- TODO: luapad.CreateFolder() function for this
		node2.RootFolder = "gamemodes";
		node2:MakeFolder("gamemodes", true);
		node2.Icon:SetImage("gui/silkicons/folder_page_white");
		node2.AddNode = node.AddNode;
	end
 end

 function luapad.SaveScript()
	local contents = luapad.PropertySheet:GetActiveTab():GetPanel():GetItems()[1]:GetValue() or "";
	contents = string.gsub(contents,"   	","\t")
	local path = "../" .. luapad.PropertySheet:GetActiveTab():GetPanel().path;
	local a = 0;
	
	print(path .. luapad.PropertySheet:GetActiveTab():GetPanel().name);
	
	if(!file.Exists(path .. luapad.PropertySheet:GetActiveTab():GetPanel().name)) then
		luapad.SaveAsScript();
	else
		if(table.HasValue(luapad.RestrictedFiles, luapad.PropertySheet:GetActiveTab():GetPanel().path .. luapad.PropertySheet:GetActiveTab():GetPanel().name)) then
			luapad.SetStatus("Save failed! (this file is marked as restricted)", Color(205, 92, 92, 255));
			return;
		end
		
		if(rawio) then
			local dirs = {};
			local fpath = "";
			
			for k,v in pairs(string.Explode("/", string.gsub(path, "../", "",1))) do
				if(k == #string.Explode("/", string.gsub(path, "../", "",1))) then break; end
				
				if(k == 1) then
					fpath = fpath .. v;
				else
					fpath = fpath .. "/" .. v;
				end
				
				local a = rawio.mkdir(luapad.GModRoot .. fpath);
			end
			
			a = rawio.writefile(luapad.GModRoot .. string.gsub(path, "../", "",1) .. luapad.PropertySheet:GetActiveTab():GetPanel().name, contents);
		else
			file.Write(string.gsub(path, "../data/", "",1) .. luapad.PropertySheet:GetActiveTab():GetPanel().name, contents);
		end
		
		if((rawio && tobool(a)) or (!rawio && file.Exists(string.gsub(path, "../data/", "",1) .. luapad.PropertySheet:GetActiveTab():GetPanel().name))) then
			luapad.SetStatus("File succesfully saved!", Color(92, 205, 92, 255));
		else
			luapad.SetStatus("Save failed! (check your filename for illegal characters)", Color(205, 92, 92, 255));
		end
	end
 end
 
 function luapad.SaveAsScript()
	 Derma_StringRequest("Luapad",  
		"You are about to save a file, please enter the desired filename.",
		luapad.PropertySheet:GetActiveTab():GetPanel().path .. luapad.PropertySheet:GetActiveTab():GetPanel().name,
		
		function(filename)
			if(table.HasValue(luapad.RestrictedFiles, filename)) then
				luapad.SetStatus("Save failed! (this file is marked as restricted)", Color(205, 92, 92, 255));
				return;
			end
			local contents = luapad.PropertySheet:GetActiveTab():GetPanel():GetItems()[1]:GetValue() or "";
			if string.find(filename,"../") == 1 then filename = string.gsub(filename, "../", "",1); end --I really do hate how '.' is a wildcard...
			
			if(rawio) then
				local dirs = {};
				local fpath = "";
				
				for k,v in pairs(string.Explode("/", filename)) do
					if(k == #string.Explode("/", filename)) then break; end
					
					if(k == 1) then
						fpath = fpath .. v;
					else
						fpath = fpath .. "/" .. v;
					end
					
					local a = rawio.mkdir(luapad.GModRoot .. fpath);
				end
				
				a = rawio.writefile(luapad.GModRoot .. filename, contents);
			else
				file.Write(string.gsub(filename, "data/", "",1), contents);
			end
			
			if((rawio && (a ~= 0)) or (!rawio && file.Exists(string.gsub(filename, "data/", "",1)))) then
				luapad.SetStatus("File succesfully saved!", Color(92, 205, 92, 255));
				luapad.PropertySheet:GetActiveTab():GetPanel().name = string.Explode("/", filename)[#string.Explode("/", filename)];
				luapad.PropertySheet:GetActiveTab():GetPanel().path = string.gsub(filename, luapad.PropertySheet:GetActiveTab():GetPanel().name, "",1);
				luapad.PropertySheet:GetActiveTab():SetText(string.Explode("/", filename)[#string.Explode("/", filename)]);
				luapad.PropertySheet:SetActiveTab(luapad.PropertySheet:GetActiveTab());
			else
				luapad.SetStatus("Save failed! (check your filename for illegal characters)", Color(205, 92, 92, 255));
			end
		end,
		
		nil,
		"Save", 
		"Cancel"
	);
 end
 
 function luapad.RunScriptClient()
	local objectDefintions = "local me = player.GetByID("..LocalPlayer():EntIndex()..")\nlocal this = me:GetEyeTrace().Entity\n"
	local did, err = pcall(RunString,objectDefintions..luapad.PropertySheet:GetActiveTab():GetPanel():GetItems()[1]:GetValue())
	if did then 
		luapad.SetStatus("Code ran sucessfully!", Color(92, 205, 92, 255)); 
	else
		luapad.SetStatus(err, Color(205, 92, 92, 255)); 
	end
 end
 
function luapad.RunScriptClientFromServer(script)
	local did, err = pcall(RunString,script)
	if did then 
		luapad.SetStatus("Code ran sucessfully!", Color(92, 205, 92, 255)); 
	else
		luapad.SetStatus(err, Color(205, 92, 92, 255)); 
	end
end
 
 function luapad.RunScriptServer()
	if(luapad.UploadID) then luapad.SetStatus("Another upload already in progress!", Color(205, 92, 92, 255)); return; end 
 
	local function done()
		luapad.UploadID = nil;
		luapad.SetStatus("Upload to server completed! Check server console for possible errors.", Color(92, 205, 92, 255));
	end
	
	local function accepted(accepted, tempid, id)
		if(accepted) then
			luapad.UploadID = id;
			luapad.SetStatus("Upload accepted, now uploading..", Color(92, 205, 92, 255));
		else
			luapad.SetStatus("Upload denied by server! This is could be due you not being an admin.", Color(205, 92, 92, 255));
		end
	end
	
	
	local objectDefintions = "local me = player.GetByID("..LocalPlayer():EntIndex()..")\nlocal this = me:GetEyeTrace().Entity\n"
	
	datastream.StreamToServer("luapad.Upload", objectDefintions..luapad.PropertySheet:GetActiveTab():GetPanel():GetItems()[1]:GetValue(), done, accepted)
 end
 
 function luapad.RunScriptServerClient()
	if(luapad.UploadID) then luapad.SetStatus("Another upload already in progress!", Color(205, 92, 92, 255)); return; end 
 
	local function done()
		luapad.UploadID = nil;
		luapad.SetStatus("Upload to client completed!", Color(92, 205, 92, 255));
	end
	
	local function accepted(accepted, tempid, id)
		if(accepted) then
			luapad.UploadID = id;
			luapad.SetStatus("Upload accepted, now uploading..", Color(92, 205, 92, 255));
		else
			luapad.SetStatus("Upload denied by server! This is could be due you not being an admin.", Color(205, 92, 92, 255));
		end
	end
	
	local objectDefintions = "local me = player.GetByID("..LocalPlayer():EntIndex()..")\nlocal this = me:GetEyeTrace().Entity\n"
	
	datastream.StreamToServer("luapad.UploadClient", objectDefintions..luapad.PropertySheet:GetActiveTab():GetPanel():GetItems()[1]:GetValue(), done, accepted)
 end
 
concommand.Add("luapad", luapad.Toggle);





--Redistributable datastream fix.
if (SERVER) then
	local META = FindMetaTable("CRecipientFilter")
	if META then
		function META:IsValid()
			return true
		end
	else
		ErrorNoHalt(os.date().." Failed to fix datastream fuckup: \"CRecipientFilter\"'s metatable invalid.")
	end
end






