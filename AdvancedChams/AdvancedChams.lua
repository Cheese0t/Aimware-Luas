local SCRIPT_FILE_NAME = GetScriptName()
local SCRIPT_FILE_ADDR = "https://raw.githubusercontent.com/Cheese0t/Aimware-Luas/master/AdvancedChams/AdvancedChams.lua"
local VERSION_FILE_ADDR = "https://raw.githubusercontent.com/Cheese0t/Aimware-Luas/master/AdvancedChams/Version.txt"
local VERSION_NUMBER = "2.1a"
local version_check_done = false
local update_downloaded = false
local update_available = false
local up_to_date = false
local updaterfont1 = draw.CreateFont("Bahnschrift", 18)
local updaterfont2 = draw.CreateFont("Bahnschrift", 14)
local updateframes = 0
local fadeout = 0
local spacing = 0
local fadein = 0

local function handleUpdates()
	if updateframes < 5.5 then
		if up_to_date or updateframes < 0.25 then
			updateframes = updateframes + globals.AbsoluteFrameTime()
			if updateframes > 5 then
				fadeout = ((updateframes - 5) * 510)
			end
			if updateframes > 0.1 and updateframes < 0.25 then
				fadein = (updateframes - 0.1) * 4500
			end
			if fadein < 0 then fadein = 0 end
			if fadein > 650 then fadein = 650 end
			if fadeout < 0 then fadeout = 0 end
			if fadeout > 255 then fadeout = 255 end
		end
		if updateframes >= 0.25 then fadein = 650 end
		for i = 0, 600 do
			local alpha = 200-i/3 - fadeout
			if alpha < 0 then alpha = 0 end
			draw.Color(15,15,15,alpha)
			draw.FilledRect(i - 650 + fadein, 0, i+1 - 650 + fadein, 30)
			draw.Color(255,75,75,alpha)
			draw.FilledRect(i - 650 + fadein, 30, i+1 - 650 + fadein, 31)
		end
		draw.SetFont(updaterfont1)
		draw.Color(255,75,75,255 - fadeout)
		draw.Text(7 - 650 + fadein, 7, "Advanced")
		draw.Color(225,225,225,255 - fadeout)
		draw.Text(7 + draw.GetTextSize("Advanced") - 650 + fadein, 7, "Chams")
		draw.Color(255,75,75,255 - fadeout)
		draw.Text(7 + draw.GetTextSize("AdvancedChams  ") - 650 + fadein, 7, "\\")
		spacing = draw.GetTextSize("AdvancedChams  \\  ")
		draw.SetFont(updaterfont2)
		draw.Color(225,225,225,255 - fadeout)
	end

    if (update_available and not update_downloaded) then
		draw.Text(7 + spacing - 650 + fadein, 9, "Downloading latest version.")
        local new_version_content = http.Get(SCRIPT_FILE_ADDR);
        local old_script = file.Open(SCRIPT_FILE_NAME, "w");
        old_script:Write(new_version_content);
        old_script:Close();
        update_available = false
        update_downloaded = true
	end
	
    if (update_downloaded) then
		draw.Text(7 + spacing - 650 + fadein, 9, "Update available, please reload the script.")
        return
    end

    if (not version_check_done) then
        version_check_done = true
		local version = http.Get(VERSION_FILE_ADDR)
		version = string.gsub(version, "\n", "")
		if (version ~= VERSION_NUMBER) then
            update_available = true
		else 
			up_to_date = true
		end
	end
	
	if up_to_date and updateframes < 5.5 then
		draw.Text(7 + spacing - 650 + fadein, 9, "Successfully loaded latest version: v" .. VERSION_NUMBER)
	end
end

callbacks.Register("Draw", handleUpdates)

local ref = gui.Reference("VISUALS", "CHAMS")
local ref1 = gui.Reference("VISUALS", "CHAMS", "Friendly")
local ref2 = gui.Reference("VISUALS", "CHAMS", "Enemy")
local ref3 = gui.Reference("VISUALS", "CHAMS", "Local")
local ref4 = gui.Reference("VISUALS", "CHAMS", "Backtrack")
local ref5 = gui.Reference("VISUALS", "CHAMS", "Ghost")
local ref6 = gui.Reference("VISUALS", "CHAMS", "Weapon")
local menuref = gui.Reference("MENU")
ref1:SetInvisible(1)
ref2:SetInvisible(1)
ref3:SetInvisible(1)
ref4:SetPosY(155)
ref5:SetPosY(155)
ref6:SetInvisible(1)
local group = gui.Groupbox(ref, "", 16,16)
local text1 = gui.Text(group, "Main selection")
local modeswitch = gui.Combobox(group, "chams.modeswitch", "", "Enemy", "Friendly", "Local", "Viewmodel")
local typeswitch = gui.Combobox(group, "chams.typeswitch", "", "Visible", "Invisible", "Visible Attachment", "Invisible Attachment")
local typeswitchvm = gui.Combobox(group, "chans.typeswitchvm", "", "Arms", "Weapon")
local advancedcheck = gui.Checkbox(group, "chams.advancedmode", "", 0)
local text2 = gui.Text(group, "Advanced Mode")
local advancedgroup = gui.Groupbox(ref, "", 16, 155)
local advancedinfo = gui.Text(advancedgroup, "You can find a list of textures at: https://pastebin.com/hWnq6Yvb - Some of them may not work")
local basetext = gui.Text(advancedgroup, "Base settings")
local bumptext = gui.Text(advancedgroup, "Bumpmap settings")
local overlaytext = gui.Text(advancedgroup, "Overlay settings")
text1:SetPosY(-25)
modeswitch:SetWidth(125)
modeswitch:SetPosX(100)
modeswitch:SetPosY(-50)
typeswitch:SetWidth(125)
typeswitch:SetPosX(235)
typeswitch:SetPosY(-50)
typeswitchvm:SetWidth(125)
typeswitchvm:SetPosX(235)
typeswitchvm:SetPosY(-50)
typeswitchvm:SetInvisible(1)
advancedcheck:SetPosX(568)
advancedcheck:SetPosY(-43)
advancedgroup:SetInvisible(1)
text2:SetPosX(480)
text2:SetPosY(-38)
advancedinfo:SetPosX(35)
advancedinfo:SetPosY(270)
basetext:SetPosY(-30)
bumptext:SetPosY(70)
overlaytext:SetPosY(170)

local EnemyVisMat, EnemyIzMat, EnemyVisOverMat, EnemyIzOverMat = nil, nil, nil, nil
local FriendVisMat, FriendIzMat, FriendVisOverMat, FriendIzOverMat = nil, nil, nil, nil
local LocalVisMat, LocalIzMat, LocalVisOverMat, LocalIzOverMat = nil, nil, nil, nil
local EnemyAttVisMat, EnemyAttIzMat, EnemyAttVisOverMat, EnemyAttIzOverMat = nil, nil, nil, nil
local FriendAttVisMat, FriendAttIzMat, FriendAttVisOverMat, FriendAttIzOverMat = nil, nil, nil, nil
local LocalAttVisMat, LocalAttIzMat, LocalAttVisOverMat, LocalAttIzOverMat = nil, nil, nil, nil
local ArmsMat, ArmsOverMat, WeaponMat, WeaponOverMat = nil, nil, nil, nil

local function RemoveDefaults()
	gui.SetValue("esp.chams.enemy.occluded", 0)
	gui.SetValue("esp.chams.enemy.visible", 0)
	gui.SetValue("esp.chams.enemy.overlay", 0)
	gui.SetValue("esp.chams.friendly.occluded", 0)
	gui.SetValue("esp.chams.friendly.visible", 0)
	gui.SetValue("esp.chams.friendly.overlay", 0)
	gui.SetValue("esp.chams.local.occluded", 0)
	gui.SetValue("esp.chams.local.visible", 0)
	gui.SetValue("esp.chams.local.overlay", 0)
	gui.SetValue("esp.chams.weapon.occluded", 0)
	gui.SetValue("esp.chams.weapon.visible", 0)
	gui.SetValue("esp.chams.weapon.overlay", 0)
end

RemoveDefaults()

local settings = {
	enemy = {
	   	vis = {
			base = gui.Combobox(group, "enemy.vis.base", "Base", "Off", "Color", "Flat", "Invisible"),
			baseclr = gui.ColorPicker(group, "enemy.vis.base.clr", "", 255, 0, 0, 255 ),
			overlay = gui.Combobox(group, "enemy.vis.overlay", "Overlay", "Off", "Glow", "Wireframe", "Wireframe glow", "Custom"),
			overlayclr = gui.ColorPicker(group, "enemy.vis.overlay.clr", "", 255, 255, 255, 255 ),
			reflect = gui.Slider(group, "enemy.vis.reflect", "Reflectivity", 0, 0, 5, 0.01 ),
			reflectboost = gui.Checkbox(group, "enemy.vis.reflectboost", "Boost", 0),
			reflectclr = gui.ColorPicker(group, "enemy.vis.reflect.clr", "", 255, 255, 255, 255 ),
			shine = gui.Slider(group, "enemy.vis.shine", "Shine", 0, 0, 5, 0.01 ),
			shineclr = gui.ColorPicker(group, "enemy.vis.shineclr", "", 255, 255, 255, 255 ),
			shineboost = gui.Checkbox(group, "enemy.vis.shineboost", "Boost", 0),
			rim = gui.Slider(group, "enemy.vis.rim", "Rimlight", 0, 0, 10, 0.01 ),
			rimboost = gui.Checkbox(group, "enemy.vis.rimboost", "Boost", 0),
			pearl = gui.Slider(group, "enemy.vis.pearl", "Pearlescent", 0, -15, 15, 0.01 ),
			glowx = gui.Slider(group, "enemy.vis.glowx", "Overlay glow X", 0, 0, 50, 0.01 ),
			glowy = gui.Slider(group, "enemy.vis.glowy", "Overlay glow Y", 1.5, 0, 50, 0.01 ),
			glowz = gui.Slider(group, "enemy.vis.glowz", "Overlay glow Z", 3, 0, 50, 0.01 ),
			basetexturecheck = gui.Checkbox(advancedgroup, "enemy.vis.basetexturecheck", "Custom Texture", 0),
			basespeed = gui.Slider(advancedgroup, "enemy.vis.basespeed", "Animation Speed", 0, 0, 1, 0.01 ),
			baseangle = gui.Slider(advancedgroup, "enemy.vis.baseangle", "Animation Angle", 90, -180, 180, 1 ),
			basetexture = gui.Editbox(advancedgroup, "enemy.vis.basetexture", " "),
			bumpcheck = gui.Checkbox(advancedgroup, "enemy.vis.bumpcheck", "Enable", 0),
			bumpspeed = gui.Slider(advancedgroup, "enemy.vis.bumpspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			bumpangle = gui.Slider(advancedgroup, "enemy.vis.bumpangle", "Animation Angle", 90, -180, 180, 1 ),
			bumpmap = gui.Editbox(advancedgroup, "enemy.vis.bumpmap", " "),
			overlaywireframe = gui.Checkbox(advancedgroup, "enemy.vis.overlaywireframe", "Wireframe", 0),
			overlayspeed = gui.Slider(advancedgroup, "enemy.vis.overlayspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			overlayangle = gui.Slider(advancedgroup, "enemy.vis.overlayangle", "Animation Angle", 90, -180, 180, 1 ),
			overlaytexture = gui.Editbox(advancedgroup, "enemy.vis.overlaytexture", " ")
	   	},
	   	iz = {
			base = gui.Combobox(group, "enemy.iz.base", "Base", "Off", "Color", "Flat", "Invisible"),
			baseclr = gui.ColorPicker(group, "enemy.iz.base.clr", "", 255, 0, 0, 255 ),
			overlay = gui.Combobox(group, "enemy.iz.overlay", "Overlay", "Off", "Glow", "Wireframe", "Wireframe glow", "Custom"),
			overlayclr = gui.ColorPicker(group, "enemy.iz.overlay.clr", "", 255, 255, 255, 255 ),
			reflect = gui.Slider(group, "enemy.iz.reflect", "Reflectivity", 0, 0, 5, 0.01 ),
			reflectboost = gui.Checkbox(group, "enemy.iz.reflectboost", "Boost", 0),
			reflectclr = gui.ColorPicker(group, "reflect.clr", "", 255, 255, 255, 255 ),
			shine = gui.Slider(group, "enemy.iz.shine", "Shine", 0, 0, 5, 0.01 ),
			shineclr = gui.ColorPicker(group, "enemy.iz.shineclr", "", 255, 255, 255, 255 ),
			shineboost = gui.Checkbox(group, "enemy.iz.shineboost", "Boost", 0),
			rim = gui.Slider(group, "enemy.iz.rim", "Rimlight", 0, 0, 10, 0.01 ),
			rimboost = gui.Checkbox(group, "enemy.iz.rimboost", "Boost", 0),
			pearl = gui.Slider(group, "enemy.iz.pearl", "Pearlescent", 0, -15, 15, 0.01 ),
			glowx = gui.Slider(group, "enemy.iz.glowx", "Overlay glow X", 0, 0, 50, 0.01 ),
			glowy = gui.Slider(group, "enemy.iz.glowy", "Overlay glow Y", 1.5, 0, 50, 0.01 ),
			glowz = gui.Slider(group, "enemy.iz.glowz", "Overlay glow Z", 3, 0, 50, 0.01 ),
			basetexturecheck = gui.Checkbox(advancedgroup, "enemy.iz.basetexturecheck", "Custom Texture", 0),
			basespeed = gui.Slider(advancedgroup, "enemy.iz.basespeed", "Animation Speed", 0, 0, 1, 0.01 ),
			baseangle = gui.Slider(advancedgroup, "enemy.iz.baseangle", "Animation Angle", 90, -180, 180, 1 ),
			basetexture = gui.Editbox(advancedgroup, "enemy.iz.basetexture", " "),
			bumpcheck = gui.Checkbox(advancedgroup, "enemy.iz.bumpcheck", "Enable", 0),
			bumpspeed = gui.Slider(advancedgroup, "enemy.iz.bumpspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			bumpangle = gui.Slider(advancedgroup, "enemy.iz.bumpangle", "Animation Angle", 90, -180, 180, 1 ),
			bumpmap = gui.Editbox(advancedgroup, "enemy.iz.bumpmap", " "),
			overlaywireframe = gui.Checkbox(advancedgroup, "enemy.iz.overlaywireframe", "Wireframe", 0),
			overlayspeed = gui.Slider(advancedgroup, "enemy.iz.overlayspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			overlayangle = gui.Slider(advancedgroup, "enemy.iz.overlayangle", "Animation Angle", 90, -180, 180, 1 ),
			overlaytexture = gui.Editbox(advancedgroup, "enemy.iz.overlaytexture", " ")
		   },
		attvis = {
			base = gui.Combobox(group, "enemy.attvis.base", "Base", "Off", "Color", "Flat", "Invisible"),
			baseclr = gui.ColorPicker(group, "enemy.attvis.base.clr", "", 255, 0, 0, 255 ),
			overlay = gui.Combobox(group, "enemy.attvis.overlay", "Overlay", "Off", "Glow", "Wireframe", "Wireframe glow", "Custom"),
			overlayclr = gui.ColorPicker(group, "enemy.attvis.overlay.clr", "", 255, 255, 255, 255 ),
			reflect = gui.Slider(group, "enemy.attvis.reflect", "Reflectivity", 0, 0, 5, 0.01 ),
			reflectboost = gui.Checkbox(group, "enemy.attvis.reflectboost", "Boost", 0),
			reflectclr = gui.ColorPicker(group, "enemy.attvis.reflect.clr", "", 255, 255, 255, 255 ),
			shine = gui.Slider(group, "enemy.attvis.shine", "Shine", 0, 0, 5, 0.01 ),
			shineclr = gui.ColorPicker(group, "enemy.attvis.shineclr", "", 255, 255, 255, 255 ),
			shineboost = gui.Checkbox(group, "enemy.attvis.shineboost", "Boost", 0),
			rim = gui.Slider(group, "enemy.attvis.rim", "Rimlight", 0, 0, 10, 0.01 ),
			rimboost = gui.Checkbox(group, "enemy.attvis.rimboost", "Boost", 0),
			pearl = gui.Slider(group, "enemy.attvis.pearl", "Pearlescent", 0, -15, 15, 0.01 ),
			glowx = gui.Slider(group, "enemy.attvis.glowx", "Overlay glow X", 0, 0, 50, 0.01 ),
			glowy = gui.Slider(group, "enemy.attvis.glowy", "Overlay glow Y", 1.5, 0, 50, 0.01 ),
			glowz = gui.Slider(group, "enemy.attvis.glowz", "Overlay glow Z", 3, 0, 50, 0.01 ),
			basetexturecheck = gui.Checkbox(advancedgroup, "enemy.attvis.basetexturecheck", "Custom Texture", 0),
			basespeed = gui.Slider(advancedgroup, "enemy.attvis.basespeed", "Animation Speed", 0, 0, 1, 0.01 ),
			baseangle = gui.Slider(advancedgroup, "enemy.attvis.baseangle", "Animation Angle", 90, -180, 180, 1 ),
			basetexture = gui.Editbox(advancedgroup, "enemy.attvis.basetexture", " "),
			bumpcheck = gui.Checkbox(advancedgroup, "enemy.attvis.bumpcheck", "Enable", 0),
			bumpspeed = gui.Slider(advancedgroup, "enemy.attvis.bumpspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			bumpangle = gui.Slider(advancedgroup, "enemy.attvis.bumpangle", "Animation Angle", 90, -180, 180, 1 ),
			bumpmap = gui.Editbox(advancedgroup, "enemy.attvis.bumpmap", " "),
			overlaywireframe = gui.Checkbox(advancedgroup, "enemy.attvis.overlaywireframe", "Wireframe", 0),
			overlayspeed = gui.Slider(advancedgroup, "enemy.attvis.overlayspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			overlayangle = gui.Slider(advancedgroup, "enemy.attvis.overlayangle", "Animation Angle", 90, -180, 180, 1 ),
			overlaytexture = gui.Editbox(advancedgroup, "enemy.attvis.overlaytexture", " ")
  		},
	   	attiz = {
			base = gui.Combobox(group, "enemy.attiz.base", "Base", "Off", "Color", "Flat", "Invisible"),
			baseclr = gui.ColorPicker(group, "enemy.attiz.base.clr", "", 255, 0, 0, 255 ),
			overlay = gui.Combobox(group, "enemy.attiz.overlay", "Overlay", "Off", "Glow", "Wireframe", "Wireframe glow", "Custom"),
			overlayclr = gui.ColorPicker(group, "enemy.attiz.overlay.clr", "", 255, 255, 255, 255 ),
			reflect = gui.Slider(group, "enemy.attiz.reflect", "Reflectivity", 0, 0, 5, 0.01 ),
			reflectboost = gui.Checkbox(group, "enemy.attiz.reflectboost", "Boost", 0),
			reflectclr = gui.ColorPicker(group, "reflect.clr", "", 255, 255, 255, 255 ),
			shine = gui.Slider(group, "enemy.attiz.shine", "Shine", 0, 0, 5, 0.01 ),
			shineclr = gui.ColorPicker(group, "enemy.attiz.shineclr", "", 255, 255, 255, 255 ),
			shineboost = gui.Checkbox(group, "enemy.attiz.shineboost", "Boost", 0),
			rim = gui.Slider(group, "enemy.attiz.rim", "Rimlight", 0, 0, 10, 0.01 ),
			rimboost = gui.Checkbox(group, "enemy.attiz.rimboost", "Boost", 0),
			pearl = gui.Slider(group, "enemy.attiz.pearl", "Pearlescent", 0, -15, 15, 0.01 ),
			glowx = gui.Slider(group, "enemy.attiz.glowx", "Overlay glow X", 0, 0, 50, 0.01 ),
			glowy = gui.Slider(group, "enemy.attiz.glowy", "Overlay glow Y", 1.5, 0, 50, 0.01 ),
			glowz = gui.Slider(group, "enemy.attiz.glowz", "Overlay glow Z", 3, 0, 50, 0.01 ),
			basetexturecheck = gui.Checkbox(advancedgroup, "enemy.attiz.basetexturecheck", "Custom Texture", 0),
			basespeed = gui.Slider(advancedgroup, "enemy.attiz.basespeed", "Animation Speed", 0, 0, 1, 0.01 ),
			baseangle = gui.Slider(advancedgroup, "enemy.attiz.baseangle", "Animation Angle", 90, -180, 180, 1 ),
			basetexture = gui.Editbox(advancedgroup, "enemy.attiz.basetexture", " "),
			bumpcheck = gui.Checkbox(advancedgroup, "enemy.attiz.bumpcheck", "Enable", 0),
			bumpspeed = gui.Slider(advancedgroup, "enemy.attiz.bumpspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			bumpangle = gui.Slider(advancedgroup, "enemy.attiz.bumpangle", "Animation Angle", 90, -180, 180, 1 ),
			bumpmap = gui.Editbox(advancedgroup, "enemy.attiz.bumpmap", " "),
			overlaywireframe = gui.Checkbox(advancedgroup, "enemy.attiz.overlaywireframe", "Wireframe", 0),
			overlayspeed = gui.Slider(advancedgroup, "enemy.attiz.overlayspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			overlayangle = gui.Slider(advancedgroup, "enemy.attiz.overlayangle", "Animation Angle", 90, -180, 180, 1 ),
			overlaytexture = gui.Editbox(advancedgroup, "enemy.attiz.overlaytexture", " ")
   		}
   	},
   friend = {
	   	vis = {
			base = gui.Combobox(group, "friend.vis.base", "Base", "Off", "Color", "Flat", "Invisible"),
			baseclr = gui.ColorPicker(group, "friend.vis.base.clr", "", 255, 0, 0, 255 ),
			overlay = gui.Combobox(group, "friend.vis.overlay", "Overlay", "Off", "Glow", "Wireframe", "Wireframe glow", "Custom"),
			overlayclr = gui.ColorPicker(group, "friend.vis.overlay.clr", "", 255, 255, 255, 255 ),
			reflect = gui.Slider(group, "friend.vis.reflect", "Reflectivity", 0, 0, 5, 0.01 ),
			reflectboost = gui.Checkbox(group, "friend.vis.reflectboost", "Boost", 0),
			reflectclr = gui.ColorPicker(group, "friend.vis.reflect.clr", "", 255, 255, 255, 255 ),
			shine = gui.Slider(group, "friend.vis.shine", "Shine", 0, 0, 5, 0.01 ),
			shineclr = gui.ColorPicker(group, "friend.vis.shineclr", "", 255, 255, 255, 255 ),
			shineboost = gui.Checkbox(group, "friend.vis.shineboost", "Boost", 0),
			rim = gui.Slider(group, "friend.vis.rim", "Rimlight", 0, 0, 10, 0.01 ),
			rimboost = gui.Checkbox(group, "friend.vis.rimboost", "Boost", 0),
			pearl = gui.Slider(group, "friend.vis.pearl", "Pearlescent", 0, -15, 15, 0.01 ),
			glowx = gui.Slider(group, "friend.vis.glowx", "Overlay glow X", 0, 0, 50, 0.01 ),
			glowy = gui.Slider(group, "friend.vis.glowy", "Overlay glow Y", 1.5, 0, 50, 0.01 ),
			glowz = gui.Slider(group, "friend.vis.glowz", "Overlay glow Z", 3, 0, 50, 0.01 ),
			basetexturecheck = gui.Checkbox(advancedgroup, "friend.vis.basetexturecheck", "Custom Texture", 0),
			basespeed = gui.Slider(advancedgroup, "friend.vis.basespeed", "Animation Speed", 0, 0, 1, 0.01 ),
			baseangle = gui.Slider(advancedgroup, "friend.vis.baseangle", "Animation Angle", 90, -180, 180, 1 ),
			basetexture = gui.Editbox(advancedgroup, "friend.vis.basetexture", " "),
			bumpcheck = gui.Checkbox(advancedgroup, "friend.vis.bumpcheck", "Enable", 0),
			bumpspeed = gui.Slider(advancedgroup, "friend.vis.bumpspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			bumpangle = gui.Slider(advancedgroup, "friend.vis.bumpangle", "Animation Angle", 90, -180, 180, 1 ),
			bumpmap = gui.Editbox(advancedgroup, "friend.vis.bumpmap", " "),
			overlaywireframe = gui.Checkbox(advancedgroup, "friend.vis.overlaywireframe", "Wireframe", 0),
			overlayspeed = gui.Slider(advancedgroup, "friend.vis.overlayspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			overlayangle = gui.Slider(advancedgroup, "friend.vis.overlayangle", "Animation Angle", 90, -180, 180, 1 ),
			overlaytexture = gui.Editbox(advancedgroup, "friend.vis.overlaytexture", " ")
	   	},
	   	iz = {
			base = gui.Combobox(group, "friend.iz.base", "Base", "Off", "Color", "Flat", "Invisible"),
			baseclr = gui.ColorPicker(group, "friend.iz.base.clr", "", 255, 0, 0, 255 ),
			overlay = gui.Combobox(group, "friend.iz.overlay", "Overlay", "Off", "Glow", "Wireframe", "Wireframe glow", "Custom"),
			overlayclr = gui.ColorPicker(group, "friend.iz.overlay.clr", "", 255, 255, 255, 255 ),
			reflect = gui.Slider(group, "friend.iz.reflect", "Reflectivity", 0, 0, 5, 0.01 ),
			reflectboost = gui.Checkbox(group, "friend.iz.reflectboost", "Boost", 0),
			reflectclr = gui.ColorPicker(group, "friend.iz.reflect.clr", "", 255, 255, 255, 255 ),
			shine = gui.Slider(group, "friend.iz.shine", "Shine", 0, 0, 5, 0.01 ),
			shineclr = gui.ColorPicker(group, "friend.iz.shineclr", "", 255, 255, 255, 255 ),
			shineboost = gui.Checkbox(group, "friend.iz.shineboost", "Boost", 0),
			rim = gui.Slider(group, "friend.iz.rim", "Rimlight", 0, 0, 10, 0.01 ),
			rimboost = gui.Checkbox(group, "friend.iz.rimboost", "Boost", 0),
			pearl = gui.Slider(group, "friend.iz.pearl", "Pearlescent", 0, -15, 15, 0.01 ),
			glowx = gui.Slider(group, "friend.iz.glowx", "Overlay glow X", 0, 0, 50, 0.01 ),
			glowy = gui.Slider(group, "friend.iz.glowy", "Overlay glow Y", 1.5, 0, 50, 0.01 ),
			glowz = gui.Slider(group, "friend.iz.glowz", "Overlay glow Z", 3, 0, 50, 0.01 ),
			basetexturecheck = gui.Checkbox(advancedgroup, "friend.iz.basetexturecheck", "Custom Texture", 0),
			basespeed = gui.Slider(advancedgroup, "friend.iz.basespeed", "Animation Speed", 0, 0, 1, 0.01 ),
			baseangle = gui.Slider(advancedgroup, "friend.iz.baseangle", "Animation Angle", 90, -180, 180, 1 ),
			basetexture = gui.Editbox(advancedgroup, "friend.iz.basetexture", " "),
			bumpcheck = gui.Checkbox(advancedgroup, "friend.iz.bumpcheck", "Enable", 0),
			bumpspeed = gui.Slider(advancedgroup, "friend.iz.bumpspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			bumpangle = gui.Slider(advancedgroup, "friend.iz.bumpangle", "Animation Angle", 90, -180, 180, 1 ),
			bumpmap = gui.Editbox(advancedgroup, "friend.iz.bumpmap", " "),
			overlaywireframe = gui.Checkbox(advancedgroup, "friend.iz.overlaywireframe", "Wireframe", 0),
			overlayspeed = gui.Slider(advancedgroup, "friend.iz.overlayspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			overlayangle = gui.Slider(advancedgroup, "friend.iz.overlayangle", "Animation Angle", 90, -180, 180, 1 ),
			overlaytexture = gui.Editbox(advancedgroup, "friend.iz.overlaytexture", " ")
	   	},
	   	attvis = {
			base = gui.Combobox(group, "friend.attvis.base", "Base", "Off", "Color", "Flat", "Invisible"),
			baseclr = gui.ColorPicker(group, "friend.attvis.base.clr", "", 255, 0, 0, 255 ),
			overlay = gui.Combobox(group, "friend.attvis.overlay", "Overlay", "Off", "Glow", "Wireframe", "Wireframe glow", "Custom"),
			overlayclr = gui.ColorPicker(group, "friend.attvis.overlay.clr", "", 255, 255, 255, 255 ),
			reflect = gui.Slider(group, "friend.attvis.reflect", "Reflectivity", 0, 0, 5, 0.01 ),
			reflectboost = gui.Checkbox(group, "friend.attvis.reflectboost", "Boost", 0),
			reflectclr = gui.ColorPicker(group, "friend.attvis.reflect.clr", "", 255, 255, 255, 255 ),
			shine = gui.Slider(group, "friend.attvis.shine", "Shine", 0, 0, 5, 0.01 ),
			shineclr = gui.ColorPicker(group, "friend.attvis.shineclr", "", 255, 255, 255, 255 ),
			shineboost = gui.Checkbox(group, "friend.attvis.shineboost", "Boost", 0),
			rim = gui.Slider(group, "friend.attvis.rim", "Rimlight", 0, 0, 10, 0.01 ),
			rimboost = gui.Checkbox(group, "friend.attvis.rimboost", "Boost", 0),
			pearl = gui.Slider(group, "friend.attvis.pearl", "Pearlescent", 0, -15, 15, 0.01 ),
			glowx = gui.Slider(group, "friend.attvis.glowx", "Overlay glow X", 0, 0, 50, 0.01 ),
			glowy = gui.Slider(group, "friend.attvis.glowy", "Overlay glow Y", 1.5, 0, 50, 0.01 ),
			glowz = gui.Slider(group, "friend.attvis.glowz", "Overlay glow Z", 3, 0, 50, 0.01 ),
			basetexturecheck = gui.Checkbox(advancedgroup, "friend.attvis.basetexturecheck", "Custom Texture", 0),
			basespeed = gui.Slider(advancedgroup, "friend.attvis.basespeed", "Animation Speed", 0, 0, 1, 0.01 ),
			baseangle = gui.Slider(advancedgroup, "friend.attvis.baseangle", "Animation Angle", 90, -180, 180, 1 ),
			basetexture = gui.Editbox(advancedgroup, "friend.attvis.basetexture", " "),
			bumpcheck = gui.Checkbox(advancedgroup, "friend.attvis.bumpcheck", "Enable", 0),
			bumpspeed = gui.Slider(advancedgroup, "friend.attvis.bumpspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			bumpangle = gui.Slider(advancedgroup, "friend.attvis.bumpangle", "Animation Angle", 90, -180, 180, 1 ),
			bumpmap = gui.Editbox(advancedgroup, "friend.attvis.bumpmap", " "),
			overlaywireframe = gui.Checkbox(advancedgroup, "friend.attvis.overlaywireframe", "Wireframe", 0),
			overlayspeed = gui.Slider(advancedgroup, "friend.attvis.overlayspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			overlayangle = gui.Slider(advancedgroup, "friend.attvis.overlayangle", "Animation Angle", 90, -180, 180, 1 ),
			overlaytexture = gui.Editbox(advancedgroup, "friend.attvis.overlaytexture", " ")
   		},
	   	attiz = {
			base = gui.Combobox(group, "friend.attiz.base", "Base", "Off", "Color", "Flat", "Invisible"),
			baseclr = gui.ColorPicker(group, "friend.attiz.base.clr", "", 255, 0, 0, 255 ),
			overlay = gui.Combobox(group, "friend.attiz.overlay", "Overlay", "Off", "Glow", "Wireframe", "Wireframe glow", "Custom"),
			overlayclr = gui.ColorPicker(group, "friend.attiz.overlay.clr", "", 255, 255, 255, 255 ),
			reflect = gui.Slider(group, "friend.attiz.reflect", "Reflectivity", 0, 0, 5, 0.01 ),
			reflectboost = gui.Checkbox(group, "friend.attiz.reflectboost", "Boost", 0),
			reflectclr = gui.ColorPicker(group, "friend.attiz.reflect.clr", "", 255, 255, 255, 255 ),
			shine = gui.Slider(group, "friend.attiz.shine", "Shine", 0, 0, 5, 0.01 ),
			shineclr = gui.ColorPicker(group, "friend.attiz.shineclr", "", 255, 255, 255, 255 ),
			shineboost = gui.Checkbox(group, "friend.attiz.shineboost", "Boost", 0),
			rim = gui.Slider(group, "friend.attiz.rim", "Rimlight", 0, 0, 10, 0.01 ),
			rimboost = gui.Checkbox(group, "friend.attiz.rimboost", "Boost", 0),
			pearl = gui.Slider(group, "friend.attiz.pearl", "Pearlescent", 0, -15, 15, 0.01 ),
			glowx = gui.Slider(group, "friend.attiz.glowx", "Overlay glow X", 0, 0, 50, 0.01 ),
			glowy = gui.Slider(group, "friend.attiz.glowy", "Overlay glow Y", 1.5, 0, 50, 0.01 ),
			glowz = gui.Slider(group, "friend.attiz.glowz", "Overlay glow Z", 3, 0, 50, 0.01 ),
			basetexturecheck = gui.Checkbox(advancedgroup, "friend.attiz.basetexturecheck", "Custom Texture", 0),
			basespeed = gui.Slider(advancedgroup, "friend.attiz.basespeed", "Animation Speed", 0, 0, 1, 0.01 ),
			baseangle = gui.Slider(advancedgroup, "friend.attiz.baseangle", "Animation Angle", 90, -180, 180, 1 ),
			basetexture = gui.Editbox(advancedgroup, "friend.attiz.basetexture", " "),
			bumpcheck = gui.Checkbox(advancedgroup, "friend.attiz.bumpcheck", "Enable", 0),
			bumpspeed = gui.Slider(advancedgroup, "friend.attiz.bumpspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			bumpangle = gui.Slider(advancedgroup, "friend.attiz.bumpangle", "Animation Angle", 90, -180, 180, 1 ),
			bumpmap = gui.Editbox(advancedgroup, "friend.attiz.bumpmap", " "),
			overlaywireframe = gui.Checkbox(advancedgroup, "friend.attiz.overlaywireframe", "Wireframe", 0),
			overlayspeed = gui.Slider(advancedgroup, "friend.attiz.overlayspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			overlayangle = gui.Slider(advancedgroup, "friend.attiz.overlayangle", "Animation Angle", 90, -180, 180, 1 ),
			overlaytexture = gui.Editbox(advancedgroup, "friend.attiz.overlaytexture", " ")
   		}
   	},
   loc = {
	   	vis = {
			base = gui.Combobox(group, "loc.vis.base", "Base", "Off", "Color", "Flat", "Invisible"),
			baseclr = gui.ColorPicker(group, "loc.vis.base.clr", "", 255, 0, 0, 255 ),
			overlay = gui.Combobox(group, "loc.vis.overlay", "Overlay", "Off", "Glow", "Wireframe", "Wireframe glow", "Custom"),
			overlayclr = gui.ColorPicker(group, "loc.vis.overlay.clr", "", 255, 255, 255, 255 ),
			reflect = gui.Slider(group, "loc.vis.reflect", "Reflectivity", 0, 0, 5, 0.01 ),
			reflectboost = gui.Checkbox(group, "loc.vis.reflectboost", "Boost", 0),
			reflectclr = gui.ColorPicker(group, "loc.vis.reflect.clr", "", 255, 255, 255, 255 ),
			shine = gui.Slider(group, "loc.vis.shine", "Shine", 0, 0, 5, 0.01 ),
			shineclr = gui.ColorPicker(group, "loc.vis.shineclr", "", 255, 255, 255, 255 ),
			shineboost = gui.Checkbox(group, "loc.vis.shineboost", "Boost", 0),
			rim = gui.Slider(group, "loc.vis.rim", "Rimlight", 0, 0, 10, 0.01 ),
			rimboost = gui.Checkbox(group, "loc.vis.rimboost", "Boost", 0),
			pearl = gui.Slider(group, "loc.vis.pearl", "Pearlescent", 0, -15, 15, 0.01 ),
			glowx = gui.Slider(group, "loc.vis.glowx", "Overlay glow X", 0, 0, 50, 0.01 ),
			glowy = gui.Slider(group, "loc.vis.glowy", "Overlay glow Y", 1.5, 0, 50, 0.01 ),
			glowz = gui.Slider(group, "loc.vis.glowz", "Overlay glow Z", 3, 0, 50, 0.01 ),
			basetexturecheck = gui.Checkbox(advancedgroup, "loc.vis.basetexturecheck", "Custom Texture", 0),
			basespeed = gui.Slider(advancedgroup, "loc.vis.basespeed", "Animation Speed", 0, 0, 1, 0.01 ),
			baseangle = gui.Slider(advancedgroup, "loc.vis.baseangle", "Animation Angle", 90, -180, 180, 1 ),
			basetexture = gui.Editbox(advancedgroup, "loc.vis.basetexture", " "),
			bumpcheck = gui.Checkbox(advancedgroup, "loc.vis.bumpcheck", "Enable", 0),
			bumpspeed = gui.Slider(advancedgroup, "loc.vis.bumpspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			bumpangle = gui.Slider(advancedgroup, "loc.vis.bumpangle", "Animation Angle", 90, -180, 180, 1 ),
			bumpmap = gui.Editbox(advancedgroup, "loc.vis.bumpmap", " "),
			overlaywireframe = gui.Checkbox(advancedgroup, "loc.vis.overlaywireframe", "Wireframe", 0),
			overlayspeed = gui.Slider(advancedgroup, "loc.vis.overlayspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			overlayangle = gui.Slider(advancedgroup, "loc.vis.overlayangle", "Animation Angle", 90, -180, 180, 1 ),
			overlaytexture = gui.Editbox(advancedgroup, "loc.vis.overlaytexture", " ")
	   	},
		iz = {
			base = gui.Combobox(group, "loc.iz.base", "Base", "Off", "Color", "Flat", "Invisible"),
			baseclr = gui.ColorPicker(group, "loc.iz.base.clr", "", 255, 0, 0, 255 ),
			overlay = gui.Combobox(group, "loc.iz.overlay", "Overlay", "Off", "Glow", "Wireframe", "Wireframe glow", "Custom"),
			overlayclr = gui.ColorPicker(group, "loc.iz.overlay.clr", "", 255, 255, 255, 255 ),
			reflect = gui.Slider(group, "loc.iz.reflect", "Reflectivity", 0, 0, 5, 0.01 ),
			reflectboost = gui.Checkbox(group, "loc.iz.reflectboost", "Boost", 0),
			reflectclr = gui.ColorPicker(group, "loc.iz.reflect.clr", "", 255, 255, 255, 255 ),
			shine = gui.Slider(group, "loc.iz.shine", "Shine", 0, 0, 5, 0.01 ),
			shineclr = gui.ColorPicker(group, "loc.iz.shineclr", "", 255, 255, 255, 255 ),
			shineboost = gui.Checkbox(group, "loc.iz.shineboost", "Boost", 0),
			rim = gui.Slider(group, "loc.iz.rim", "Rimlight", 0, 0, 10, 0.01 ),
			rimboost = gui.Checkbox(group, "loc.iz.rimboost", "Boost", 0),
			pearl = gui.Slider(group, "loc.iz.pearl", "Pearlescent", 0, -15, 15, 0.01 ),
			glowx = gui.Slider(group, "loc.iz.glowx", "Overlay glow X", 0, 0, 50, 0.01 ),
			glowy = gui.Slider(group, "loc.iz.glowy", "Overlay glow Y", 1.5, 0, 50, 0.01 ),
			glowz = gui.Slider(group, "loc.iz.glowz", "Overlay glow Z", 3, 0, 50, 0.01 ),
			basetexturecheck = gui.Checkbox(advancedgroup, "loc.iz.basetexturecheck", "Custom Texture", 0),
			basespeed = gui.Slider(advancedgroup, "loc.iz.basespeed", "Animation Speed", 0, 0, 1, 0.01 ),
			baseangle = gui.Slider(advancedgroup, "loc.iz.baseangle", "Animation Angle", 90, -180, 180, 1 ),
			basetexture = gui.Editbox(advancedgroup, "loc.iz.basetexture", " "),
			bumpcheck = gui.Checkbox(advancedgroup, "loc.iz.bumpcheck", "Enable", 0),
			bumpspeed = gui.Slider(advancedgroup, "loc.iz.bumpspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			bumpangle = gui.Slider(advancedgroup, "loc.iz.bumpangle", "Animation Angle", 90, -180, 180, 1 ),
			bumpmap = gui.Editbox(advancedgroup, "loc.iz.bumpmap", " "),
			overlaywireframe = gui.Checkbox(advancedgroup, "loc.iz.overlaywireframe", "Wireframe", 0),
			overlayspeed = gui.Slider(advancedgroup, "loc.iz.overlayspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			overlayangle = gui.Slider(advancedgroup, "loc.iz.overlayangle", "Animation Angle", 90, -180, 180, 1 ),
			overlaytexture = gui.Editbox(advancedgroup, "loc.iz.overlaytexture", " ")
	   	},
	   	attvis = {
			base = gui.Combobox(group, "loc.attvis.base", "Base", "Off", "Color", "Flat", "Invisible"),
			baseclr = gui.ColorPicker(group, "loc.attvis.base.clr", "", 255, 0, 0, 255 ),
			overlay = gui.Combobox(group, "loc.attvis.overlay", "Overlay", "Off", "Glow", "Wireframe", "Wireframe glow", "Custom"),
			overlayclr = gui.ColorPicker(group, "loc.attvis.overlay.clr", "", 255, 255, 255, 255 ),
			reflect = gui.Slider(group, "loc.attvis.reflect", "Reflectivity", 0, 0, 5, 0.01 ),
			reflectboost = gui.Checkbox(group, "loc.attvis.reflectboost", "Boost", 0),
			reflectclr = gui.ColorPicker(group, "loc.attvis.reflect.clr", "", 255, 255, 255, 255 ),
			shine = gui.Slider(group, "loc.attvis.shine", "Shine", 0, 0, 5, 0.01 ),
			shineclr = gui.ColorPicker(group, "loc.attvis.shineclr", "", 255, 255, 255, 255 ),
			shineboost = gui.Checkbox(group, "loc.attvis.shineboost", "Boost", 0),
			rim = gui.Slider(group, "loc.attvis.rim", "Rimlight", 0, 0, 10, 0.01 ),
			rimboost = gui.Checkbox(group, "loc.attvis.rimboost", "Boost", 0),
			pearl = gui.Slider(group, "loc.attvis.pearl", "Pearlescent", 0, -15, 15, 0.01 ),
			glowx = gui.Slider(group, "loc.attvis.glowx", "Overlay glow X", 0, 0, 50, 0.01 ),
			glowy = gui.Slider(group, "loc.attvis.glowy", "Overlay glow Y", 1.5, 0, 50, 0.01 ),
			glowz = gui.Slider(group, "loc.attvis.glowz", "Overlay glow Z", 3, 0, 50, 0.01 ),
			basetexturecheck = gui.Checkbox(advancedgroup, "loc.attvis.basetexturecheck", "Custom Texture", 0),
			basespeed = gui.Slider(advancedgroup, "loc.attvis.basespeed", "Animation Speed", 0, 0, 1, 0.01 ),
			baseangle = gui.Slider(advancedgroup, "loc.attvis.baseangle", "Animation Angle", 90, -180, 180, 1 ),
			basetexture = gui.Editbox(advancedgroup, "loc.attvis.basetexture", " "),
			bumpcheck = gui.Checkbox(advancedgroup, "loc.attvis.bumpcheck", "Enable", 0),
			bumpspeed = gui.Slider(advancedgroup, "loc.attvis.bumpspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			bumpangle = gui.Slider(advancedgroup, "loc.attvis.bumpangle", "Animation Angle", 90, -180, 180, 1 ),
			bumpmap = gui.Editbox(advancedgroup, "loc.attvis.bumpmap", " "),
			overlaywireframe = gui.Checkbox(advancedgroup, "loc.attvis.overlaywireframe", "Wireframe", 0),
			overlayspeed = gui.Slider(advancedgroup, "loc.attvis.overlayspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			overlayangle = gui.Slider(advancedgroup, "loc.attvis.overlayangle", "Animation Angle", 90, -180, 180, 1 ),
			overlaytexture = gui.Editbox(advancedgroup, "loc.attvis.overlaytexture", " ")
		},
		attiz = {
			base = gui.Combobox(group, "loc.attiz.base", "Base", "Off", "Color", "Flat", "Invisible"),
			baseclr = gui.ColorPicker(group, "loc.attiz.base.clr", "", 255, 0, 0, 255 ),
			overlay = gui.Combobox(group, "loc.attiz.overlay", "Overlay", "Off", "Glow", "Wireframe", "Wireframe glow", "Custom"),
			overlayclr = gui.ColorPicker(group, "loc.attiz.overlay.clr", "", 255, 255, 255, 255 ),
			reflect = gui.Slider(group, "loc.attiz.reflect", "Reflectivity", 0, 0, 5, 0.01 ),
			reflectboost = gui.Checkbox(group, "loc.attiz.reflectboost", "Boost", 0),
			reflectclr = gui.ColorPicker(group, "loc.attiz.reflect.clr", "", 255, 255, 255, 255 ),
			shine = gui.Slider(group, "loc.attiz.shine", "Shine", 0, 0, 5, 0.01 ),
			shineclr = gui.ColorPicker(group, "loc.attiz.shineclr", "", 255, 255, 255, 255 ),
			shineboost = gui.Checkbox(group, "loc.attiz.shineboost", "Boost", 0),
			rim = gui.Slider(group, "loc.attiz.rim", "Rimlight", 0, 0, 10, 0.01 ),
			rimboost = gui.Checkbox(group, "loc.attiz.rimboost", "Boost", 0),
			pearl = gui.Slider(group, "loc.attiz.pearl", "Pearlescent", 0, -15, 15, 0.01 ),
			glowx = gui.Slider(group, "loc.attiz.glowx", "Overlay glow X", 0, 0, 50, 0.01 ),
			glowy = gui.Slider(group, "loc.attiz.glowy", "Overlay glow Y", 1.5, 0, 50, 0.01 ),
			glowz = gui.Slider(group, "loc.attiz.glowz", "Overlay glow Z", 3, 0, 50, 0.01 ),
			basetexturecheck = gui.Checkbox(advancedgroup, "loc.attiz.basetexturecheck", "Custom Texture", 0),
			basespeed = gui.Slider(advancedgroup, "loc.attiz.basespeed", "Animation Speed", 0, 0, 1, 0.01 ),
			baseangle = gui.Slider(advancedgroup, "loc.attiz.baseangle", "Animation Angle", 90, -180, 180, 1 ),
			basetexture = gui.Editbox(advancedgroup, "loc.attiz.basetexture", " "),
			bumpcheck = gui.Checkbox(advancedgroup, "loc.attiz.bumpcheck", "Enable", 0),
			bumpspeed = gui.Slider(advancedgroup, "loc.attiz.bumpspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			bumpangle = gui.Slider(advancedgroup, "loc.attiz.bumpangle", "Animation Angle", 90, -180, 180, 1 ),
			bumpmap = gui.Editbox(advancedgroup, "loc.attiz.bumpmap", " "),
			overlaywireframe = gui.Checkbox(advancedgroup, "loc.attiz.overlaywireframe", "Wireframe", 0),
			overlayspeed = gui.Slider(advancedgroup, "loc.attiz.overlayspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			overlayangle = gui.Slider(advancedgroup, "loc.attiz.overlayangle", "Animation Angle", 90, -180, 180, 1 ),
			overlaytexture = gui.Editbox(advancedgroup, "loc.attiz.overlaytexture", " ")
		}
	},
	viewmodel = {
		arms = {
			base = gui.Combobox(group, "vm.arms.base", "Base", "Off", "Color", "Flat", "Invisible"),
			baseclr = gui.ColorPicker(group, "vm.arms.base.clr", "", 255, 0, 0, 255 ),
			overlay = gui.Combobox(group, "vm.arms.overlay", "Overlay", "Off", "Glow", "Wireframe", "Wireframe glow", "Custom"),
			overlayclr = gui.ColorPicker(group, "vm.arms.overlay.clr", "", 255, 255, 255, 255 ),
			reflect = gui.Slider(group, "vm.arms.reflect", "Reflectivity", 0, 0, 5, 0.01 ),
			reflectboost = gui.Checkbox(group, "vm.arms.reflectboost", "Boost", 0),
			reflectclr = gui.ColorPicker(group, "vm.arms.reflect.clr", "", 255, 255, 255, 255 ),
			shine = gui.Slider(group, "vm.arms.shine", "Shine", 0, 0, 5, 0.01 ),
			shineclr = gui.ColorPicker(group, "vm.arms.shineclr", "", 255, 255, 255, 255 ),
			shineboost = gui.Checkbox(group, "vm.arms.shineboost", "Boost", 0),
			rim = gui.Slider(group, "vm.arms.rim", "Rimlight", 0, 0, 10, 0.01 ),
			rimboost = gui.Checkbox(group, "vm.arms.rimboost", "Boost", 0),
			pearl = gui.Slider(group, "vm.arms.pearl", "Pearlescent", 0, -15, 15, 0.01 ),
			glowx = gui.Slider(group, "vm.arms.glowx", "Overlay glow X", 0, 0, 50, 0.01 ),
			glowy = gui.Slider(group, "vm.arms.glowy", "Overlay glow Y", 1.5, 0, 50, 0.01 ),
			glowz = gui.Slider(group, "vm.arms.glowz", "Overlay glow Z", 3, 0, 50, 0.01 ),
			basetexturecheck = gui.Checkbox(advancedgroup, "vm.arms.basetexturecheck", "Custom Texture", 0),
			basespeed = gui.Slider(advancedgroup, "vm.arms.basespeed", "Animation Speed", 0, 0, 1, 0.01 ),
			baseangle = gui.Slider(advancedgroup, "vm.arms.baseangle", "Animation Angle", 90, -180, 180, 1 ),
			basetexture = gui.Editbox(advancedgroup, "vm.arms.basetexture", " "),
			bumpcheck = gui.Checkbox(advancedgroup, "vm.arms.bumpcheck", "Enable", 0),
			bumpspeed = gui.Slider(advancedgroup, "vm.arms.bumpspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			bumpangle = gui.Slider(advancedgroup, "vm.arms.bumpangle", "Animation Angle", 90, -180, 180, 1 ),
			bumpmap = gui.Editbox(advancedgroup, "vm.arms.bumpmap", " "),
			overlaywireframe = gui.Checkbox(advancedgroup, "vm.arms.overlaywireframe", "Wireframe", 0),
			overlayspeed = gui.Slider(advancedgroup, "vm.arms.overlayspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			overlayangle = gui.Slider(advancedgroup, "vm.arms.overlayangle", "Animation Angle", 90, -180, 180, 1 ),
			overlaytexture = gui.Editbox(advancedgroup, "vm.arms.overlaytexture", " ")
		},
		weapon = {
			base = gui.Combobox(group, "vm.weapon.base", "Base", "Off", "Color", "Flat", "Invisible"),
			baseclr = gui.ColorPicker(group, "vm.weapon.base.clr", "", 255, 0, 0, 255 ),
			overlay = gui.Combobox(group, "vm.attiz.overlay", "Overlay", "Off", "Glow", "Wireframe", "Wireframe glow", "Custom"),
			overlayclr = gui.ColorPicker(group, "vm.weapon.overlay.clr", "", 255, 255, 255, 255 ),
			reflect = gui.Slider(group, "vm.weapon.reflect", "Reflectivity", 0, 0, 5, 0.01 ),
			reflectboost = gui.Checkbox(group, "vm.weapon.reflectboost", "Boost", 0),
			reflectclr = gui.ColorPicker(group, "vm.weapon.reflect.clr", "", 255, 255, 255, 255 ),
			shine = gui.Slider(group, "vm.weapon.shine", "Shine", 0, 0, 5, 0.01 ),
			shineclr = gui.ColorPicker(group, "vm.weapon.shineclr", "", 255, 255, 255, 255 ),
			shineboost = gui.Checkbox(group, "vm.weapon.shineboost", "Boost", 0),
			rim = gui.Slider(group, "vm.weapon.rim", "Rimlight", 0, 0, 10, 0.01 ),
			rimboost = gui.Checkbox(group, "vm.weapon.rimboost", "Boost", 0),
			pearl = gui.Slider(group, "vm.weapon.pearl", "Pearlescent", 0, -15, 15, 0.01 ),
			glowx = gui.Slider(group, "vm.weapon.glowx", "Overlay glow X", 0, 0, 50, 0.01 ),
			glowy = gui.Slider(group, "vm.weapon.glowy", "Overlay glow Y", 1.5, 0, 50, 0.01 ),
			glowz = gui.Slider(group, "vm.weapon.glowz", "Overlay glow Z", 3, 0, 50, 0.01 ),
			basetexturecheck = gui.Checkbox(advancedgroup, "vm.weapon.basetexturecheck", "Custom Texture", 0),
			basespeed = gui.Slider(advancedgroup, "vm.weapon.basespeed", "Animation Speed", 0, 0, 1, 0.01 ),
			baseangle = gui.Slider(advancedgroup, "vm.weapon.baseangle", "Animation Angle", 90, -180, 180, 1 ),
			basetexture = gui.Editbox(advancedgroup, "vm.weapon.basetexture", " "),
			bumpcheck = gui.Checkbox(advancedgroup, "vm.weapon.bumpcheck", "Enable", 0),
			bumpspeed = gui.Slider(advancedgroup, "vm.weapon.bumpspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			bumpangle = gui.Slider(advancedgroup, "vm.weapon.bumpangle", "Animation Angle", 90, -180, 180, 1 ),
			bumpmap = gui.Editbox(advancedgroup, "vm.weapon.bumpmap", " "),
			overlaywireframe = gui.Checkbox(advancedgroup, "vm.weapon.overlaywireframe", "Wireframe", 0),
			overlayspeed = gui.Slider(advancedgroup, "vm.weapon.overlayspeed", "Animation Speed", 0, 0, 1, 0.01 ),
			overlayangle = gui.Slider(advancedgroup, "vm.weapon.overlayangle", "Animation Angle", 90, -180, 180, 1 ),
			overlaytexture = gui.Editbox(advancedgroup, "vm.weapon.overlaytexture", " ")
		}
	}
}

local cached = {
	enemy = {
	   	vis = {
			base = nil,
			baseclr = {r = nil, g = nil, b = nil, a = nil},
			overlay = nil,
			overlayclr = {r = nil, g = nil, b = nil, a = nil},
			reflect = nil,
			reflectboost = nil,
			reflectclr = {r = nil, g = nil, b = nil},
			shine = nil,
			shineclr = {r = nil, g = nil, b = nil},
			shineboost = nil,
			rim = nil,
			rimboost = nil,
			pearl = nil,
			glowx = nil,
			glowy = nil,
			glowz = nil,
			basetexturecheck = nil,
			basespeed = nil,
			baseangle = nil,
			basetexture = nil,
			bumpcheck = nil,
			bumpspeed = nil,
			bumpangle = nil,
			bumpmap = nil,
			overlaywireframe = nil,
			overlayspeed = nil,
			overlayangle = nil,
			overlaytexture = nil
	   	},
	   	iz = {
			base = nil,
			baseclr = {r = nil, g = nil, b = nil, a = nil},
			overlay = nil,
			overlayclr = {r = nil, g = nil, b = nil, a = nil},
			reflect = nil,
			reflectboost = nil,
			reflectclr = {r = nil, g = nil, b = nil},
			shine = nil,
			shineclr = {r = nil, g = nil, b = nil},
			shineboost = nil,
			rim = nil,
			rimboost = nil,
			pearl = nil,
			glowx = nil,
			glowy = nil,
			glowz = nil,
			basetexturecheck = nil,
			basespeed = nil,
			baseangle = nil,
			basetexture = nil,
			bumpcheck = nil,
			bumpspeed = nil,
			bumpangle = nil,
			bumpmap = nil,
			overlaywireframe = nil,
			overlayspeed = nil,
			overlayangle = nil,
			overlaytexture = nil
	   	},
	   	attvis = {
			base = nil,
			baseclr = {r = nil, g = nil, b = nil, a = nil},
			overlay = nil,
			overlayclr = {r = nil, g = nil, b = nil, a = nil},
			reflect = nil,
			reflectboost = nil,
			reflectclr = {r = nil, g = nil, b = nil},
			shine = nil,
			shineclr = {r = nil, g = nil, b = nil},
			shineboost = nil,
			rim = nil,
			rimboost = nil,
			pearl = nil,
			glowx = nil,
			glowy = nil,
			glowz = nil,
			basetexturecheck = nil,
			basespeed = nil,
			baseangle = nil,
			basetexture = nil,
			bumpcheck = nil,
			bumpspeed = nil,
			bumpangle = nil,
			bumpmap = nil,
			overlaywireframe = nil,
			overlayspeed = nil,
			overlayangle = nil,
			overlaytexture = nil
		},
	   	attiz = {
			base = nil,
			baseclr = {r = nil, g = nil, b = nil, a = nil},
			overlay = nil,
			overlayclr = {r = nil, g = nil, b = nil, a = nil},
			reflect = nil,
			reflectboost = nil,
			reflectclr = {r = nil, g = nil, b = nil},
			shine = nil,
			shineclr = {r = nil, g = nil, b = nil},
			shineboost = nil,
			rim = nil,
			rimboost = nil,
			pearl = nil,
			glowx = nil,
			glowy = nil,
			glowz = nil,
			basetexturecheck = nil,
			basespeed = nil,
			baseangle = nil,
			basetexture = nil,
			bumpcheck = nil,
			bumpspeed = nil,
			bumpangle = nil,
			bumpmap = nil,
			overlaywireframe = nil,
			overlayspeed = nil,
			overlayangle = nil,
			overlaytexture = nil
   		}
   	},
   	friend = {
	   	vis = {
			base = nil,
			baseclr = {r = nil, g = nil, b = nil, a = nil},
			overlay = nil,
			overlayclr = {r = nil, g = nil, b = nil, a = nil},
			reflect = nil,
			reflectboost = nil,
			reflectclr = {r = nil, g = nil, b = nil},
			shine = nil,
			shineclr = {r = nil, g = nil, b = nil},
			shineboost = nil,
			rim = nil,
			rimboost = nil,
			pearl = nil,
			glowx = nil,
			glowy = nil,
			glowz = nil,
			basetexturecheck = nil,
			basespeed = nil,
			baseangle = nil,
			basetexture = nil,
			bumpcheck = nil,
			bumpspeed = nil,
			bumpangle = nil,
			bumpmap = nil,
			overlaywireframe = nil,
			overlayspeed = nil,
			overlayangle = nil,
			overlaytexture = nil
	   	},
	   	iz = {
			base = nil,
			baseclr = {r = nil, g = nil, b = nil, a = nil},
			overlay = nil,
			overlayclr = {r = nil, g = nil, b = nil, a = nil},
			reflect = nil,
			reflectboost = nil,
			reflectclr = {r = nil, g = nil, b = nil},
			shine = nil,
			shineclr = {r = nil, g = nil, b = nil},
			shineboost = nil,
			rim = nil,
			rimboost = nil,
			pearl = nil,
			glowx = nil,
			glowy = nil,
			glowz = nil,
			basetexturecheck = nil,
			basespeed = nil,
			baseangle = nil,
			basetexture = nil,
			bumpcheck = nil,
			bumpspeed = nil,
			bumpangle = nil,
			bumpmap = nil,
			overlaywireframe = nil,
			overlayspeed = nil,
			overlayangle = nil,
			overlaytexture = nil
		},
		attvis = {
			base = nil,
			baseclr = {r = nil, g = nil, b = nil, a = nil},
			overlay = nil,
			overlayclr = {r = nil, g = nil, b = nil, a = nil},
			reflect = nil,
			reflectboost = nil,
			reflectclr = {r = nil, g = nil, b = nil},
			shine = nil,
			shineclr = {r = nil, g = nil, b = nil},
			shineboost = nil,
			rim = nil,
			rimboost = nil,
			pearl = nil,
			glowx = nil,
			glowy = nil,
			glowz = nil,
			basetexturecheck = nil,
			basespeed = nil,
			baseangle = nil,
			basetexture = nil,
			bumpcheck = nil,
			bumpspeed = nil,
			bumpangle = nil,
			bumpmap = nil,
			overlaywireframe = nil,
			overlayspeed = nil,
			overlayangle = nil,
			overlaytexture = nil
		},
	   	attiz = {
			base = nil,
			baseclr = {r = nil, g = nil, b = nil, a = nil},
			overlay = nil,
			overlayclr = {r = nil, g = nil, b = nil, a = nil},
			reflect = nil,
			reflectboost = nil,
			reflectclr = {r = nil, g = nil, b = nil},
			shine = nil,
			shineclr = {r = nil, g = nil, b = nil},
			shineboost = nil,
			rim = nil,
			rimboost = nil,
			pearl = nil,
			glowx = nil,
			glowy = nil,
			glowz = nil,
			basetexturecheck = nil,
			basespeed = nil,
			baseangle = nil,
			basetexture = nil,
			bumpcheck = nil,
			bumpspeed = nil,
			bumpangle = nil,
			bumpmap = nil,
			overlaywireframe = nil,
			overlayspeed = nil,
			overlayangle = nil,
			overlaytexture = nil
   		}
   	},
   	loc = {
	   	vis = {
			base = nil,
			baseclr = {r = nil, g = nil, b = nil, a = nil},
			overlay = nil,
			overlayclr = {r = nil, g = nil, b = nil, a = nil},
			reflect = nil,
			reflectboost = nil,
			reflectclr = {r = nil, g = nil, b = nil},
			shine = nil,
			shineclr = {r = nil, g = nil, b = nil},
			shineboost = nil,
			rim = nil,
			rimboost = nil,
			pearl = nil,
			glowx = nil,
			glowy = nil,
			glowz = nil,
			basetexturecheck = nil,
			basespeed = nil,
			baseangle = nil,
			basetexture = nil,
			bumpcheck = nil,
			bumpspeed = nil,
			bumpangle = nil,
			bumpmap = nil,
			overlaywireframe = nil,
			overlayspeed = nil,
			overlayangle = nil,
			overlaytexture = nil
	   	},
	   	iz = {
			base = nil,
			baseclr = {r = nil, g = nil, b = nil, a = nil},
			overlay = nil,
			overlayclr = {r = nil, g = nil, b = nil, a = nil},
			reflect = nil,
			reflectboost = nil,
			reflectclr = {r = nil, g = nil, b = nil},
			shine = nil,
			shineclr = {r = nil, g = nil, b = nil},
			shineboost = nil,
			rim = nil,
			rimboost = nil,
			pearl = nil,
			glowx = nil,
			glowy = nil,
			glowz = nil,
			basetexturecheck = nil,
			basespeed = nil,
			baseangle = nil,
			basetexture = nil,
			bumpcheck = nil,
			bumpspeed = nil,
			bumpangle = nil,
			bumpmap = nil,
			overlaywireframe = nil,
			overlayspeed = nil,
			overlayangle = nil,
			overlaytexture = nil
		},
		attvis = {
			base = nil,
			baseclr = {r = nil, g = nil, b = nil, a = nil},
			overlay = nil,
			overlayclr = {r = nil, g = nil, b = nil, a = nil},
			reflect = nil,
			reflectboost = nil,
			reflectclr = {r = nil, g = nil, b = nil},
			shine = nil,
			shineclr = {r = nil, g = nil, b = nil},
			shineboost = nil,
			rim = nil,
			rimboost = nil,
			pearl = nil,
			glowx = nil,
			glowy = nil,
			glowz = nil,
			basetexturecheck = nil,
			basespeed = nil,
			baseangle = nil,
			basetexture = nil,
			bumpcheck = nil,
			bumpspeed = nil,
			bumpangle = nil,
			bumpmap = nil,
			overlaywireframe = nil,
			overlayspeed = nil,
			overlayangle = nil,
			overlaytexture = nil
		},
	   	attiz = {
			base = nil,
			baseclr = {r = nil, g = nil, b = nil, a = nil},
			overlay = nil,
			overlayclr = {r = nil, g = nil, b = nil, a = nil},
			reflect = nil,
			reflectboost = nil,
			reflectclr = {r = nil, g = nil, b = nil},
			shine = nil,
			shineclr = {r = nil, g = nil, b = nil},
			shineboost = nil,
			rim = nil,
			rimboost = nil,
			pearl = nil,
			glowx = nil,
			glowy = nil,
			glowz = nil,
			basetexturecheck = nil,
			basespeed = nil,
			baseangle = nil,
			basetexture = nil,
			bumpcheck = nil,
			bumpspeed = nil,
			bumpangle = nil,
			bumpmap = nil,
			overlaywireframe = nil,
			overlayspeed = nil,
			overlayangle = nil,
			overlaytexture = nil
   		}
	},
	viewmodel = {
		arms = {
			base = nil,
			baseclr = {r = nil, g = nil, b = nil, a = nil},
			overlay = nil,
			overlayclr = {r = nil, g = nil, b = nil, a = nil},
			reflect = nil,
			reflectboost = nil,
			reflectclr = {r = nil, g = nil, b = nil},
			shine = nil,
			shineclr = {r = nil, g = nil, b = nil},
			shineboost = nil,
			rim = nil,
			rimboost = nil,
			pearl = nil,
			glowx = nil,
			glowy = nil,
			glowz = nil,
			basetexturecheck = nil,
			basespeed = nil,
			baseangle = nil,
			basetexture = nil,
			bumpcheck = nil,
			bumpspeed = nil,
			bumpangle = nil,
			bumpmap = nil,
			overlaywireframe = nil,
			overlayspeed = nil,
			overlayangle = nil,
			overlaytexture = nil
		},
		weapon = {
			base = nil,
			baseclr = {r = nil, g = nil, b = nil, a = nil},
			overlay = nil,
			overlayclr = {r = nil, g = nil, b = nil, a = nil},
			reflect = nil,
			reflectboost = nil,
			reflectclr = {r = nil, g = nil, b = nil},
			shine = nil,
			shineclr = {r = nil, g = nil, b = nil},
			shineboost = nil,
			rim = nil,
			rimboost = nil,
			pearl = nil,
			glowx = nil,
			glowy = nil,
			glowz = nil,
			basetexturecheck = nil,
			basespeed = nil,
			baseangle = nil,
			basetexture = nil,
			bumpcheck = nil,
			bumpspeed = nil,
			bumpangle = nil,
			bumpmap = nil,
			overlaywireframe = nil,
			overlayspeed = nil,
			overlayangle = nil,
			overlaytexture = nil
		}
	}
}

local lastmode, lasttype, lasttypevm, lastbase, lastoverlay, lastadvanced = nil, nil, nil, nil, nil, nil
local selectedmode, selectedtype, modename, typename, basemode, overlaymode = nil, nil, nil, nil, nil, nil

local function SetSelections()
	selectedmode = modeswitch:GetValue()
	if selectedmode == 3 then
		selectedtype = typeswitchvm:GetValue()
	else
		selectedtype = typeswitch:GetValue()
	end
	if selectedmode == 0 then modename = "enemy" elseif selectedmode == 1 then modename = "friend" elseif selectedmode == 2 then modename = "loc" elseif selectedmode == 3 then modename = "viewmodel" else modename = nil end
	if selectedmode == 3 then
		if selectedtype == 0 then typename = "arms" elseif selectedtype == 1 then typename = "weapon" else typename = nil end
	else
		if selectedtype == 0 then typename = "vis" elseif selectedtype == 1 then typename = "iz" elseif selectedtype == 2 then typename = "attvis" elseif selectedtype == 3 then typename = "attiz" else typename = nil end
	end
	basemode, overlaymode = settings[modename][typename]["base"]:GetValue(), settings[modename][typename]["overlay"]:GetValue()
end

SetSelections()

local function SetupMenu()
	for mode, types in pairs(settings) do
		for type, setting in pairs(types) do
			setting.base:SetDescription("Base material")
			setting.base:SetWidth(264)
			setting.base:SetPosY(6)
			setting.baseclr:SetPosX(-312)
			setting.baseclr:SetPosY(10)
			setting.overlay:SetDescription("Applied over previous materials.")
			setting.overlay:SetWidth(264)
			setting.overlay:SetPosX(312)
			setting.overlay:SetPosY(6)
			setting.overlayclr:SetPosX(0)
			setting.overlayclr:SetPosY(10)
			setting.reflect:SetWidth(475)
			setting.reflect:SetPosY(75)
			setting.reflectboost:SetDescription("Value multiplier")
			setting.reflectboost:SetPosX(490)
			setting.reflectboost:SetPosY(75)
			setting.reflectclr:SetPosX(-101)
			setting.reflectclr:SetPosY(75)
			setting.shine:SetWidth(475)
			setting.shine:SetPosY(128)
			setting.shineclr:SetPosX(-101)
			setting.shineclr:SetPosY(128)
			setting.shineboost:SetDescription("Value multiplier")
			setting.shineboost:SetPosX(490)
			setting.shineboost:SetPosY(128)
			setting.rim:SetWidth(475)
			setting.rim:SetPosY(181)
			setting.rimboost:SetDescription("Value multiplier")
			setting.rimboost:SetPosX(490)
			setting.rimboost:SetPosY(181)
			setting.glowx:SetWidth(175)
			setting.glowx:SetPosY(290)
			setting.glowy:SetWidth(175)
			setting.glowy:SetPosX(200)
			setting.glowy:SetPosY(290)
			setting.glowz:SetWidth(175)
			setting.glowz:SetPosX(400)
			setting.glowz:SetPosY(290)
			setting.basetexturecheck:SetPosY(0)
			setting.basespeed:SetWidth(200)
			setting.basespeed:SetPosX(150)
			setting.basespeed:SetPosY(-13)
			setting.baseangle:SetWidth(200)
			setting.baseangle:SetPosX(375)
			setting.baseangle:SetPosY(-13)
			setting.basetexture:SetPosY(15)
			setting.basetexture:SetValue("models/weapons/customization/materials/gradient")
			setting.bumpcheck:SetPosY(100)
			setting.bumpspeed:SetWidth(200)
			setting.bumpspeed:SetPosX(150)
			setting.bumpspeed:SetPosY(87)
			setting.bumpangle:SetWidth(200)
			setting.bumpangle:SetPosX(375)
			setting.bumpangle:SetPosY(87)
			setting.bumpmap:SetPosY(115)
			setting.bumpmap:SetValue("de_nuke/hr_nuke/hr_river_water_001_normal")
			setting.overlaywireframe:SetPosY(200)
			setting.overlayspeed:SetWidth(200)
			setting.overlayspeed:SetPosX(150)
			setting.overlayspeed:SetPosY(187)
			setting.overlayangle:SetWidth(200)
			setting.overlayangle:SetPosX(375)
			setting.overlayangle:SetPosY(187)
			setting.overlaytexture:SetPosY(215)
			setting.overlaytexture:SetValue("models/inventory_items/music_kit/darude_01/mp3_detail")
		end
	end
end

SetupMenu()

local function HideSettings(i)
	if selectedmode == 3 then
		typeswitchvm:SetInvisible(0)
		typeswitch:SetInvisible(1)
	else
		typeswitchvm:SetInvisible(1)
		typeswitch:SetInvisible(0)
	end
	if i == 1 then
		for mode, types in pairs(settings) do
			for type, setting in pairs(types) do
				for i, option in pairs(setting) do
					if modename == mode and typename == type then
						option:SetInvisible(false)
					else
						option:SetInvisible(true)
					end
				end
			end
		end
	elseif i == 2 then
		if basemode == 1 then
			settings[modename][typename]["reflect"]:SetInvisible(false)
			settings[modename][typename]["reflectboost"]:SetInvisible(false)
			settings[modename][typename]["reflectclr"]:SetInvisible(false)
			settings[modename][typename]["shine"]:SetInvisible(false)
			settings[modename][typename]["shineclr"]:SetInvisible(false)
			settings[modename][typename]["shineboost"]:SetInvisible(false)
			settings[modename][typename]["rim"]:SetInvisible(false)
			settings[modename][typename]["rimboost"]:SetInvisible(false)
			settings[modename][typename]["pearl"]:SetInvisible(false)
			settings[modename][typename]["glowx"]:SetPosY(290)
			settings[modename][typename]["glowy"]:SetPosY(290)
			settings[modename][typename]["glowz"]:SetPosY(290)
			if overlaymode == 1 or overlaymode == 3 then
				advancedgroup:SetPosY(416)
				if advancedcheck:GetValue() then
					ref4:SetPosY(779)
					ref5:SetPosY(779)
				else
					ref4:SetPosY(416)
					ref5:SetPosY(416)
				end
			else
				advancedgroup:SetPosY(363)
				if advancedcheck:GetValue() then
					ref4:SetPosY(726)
					ref5:SetPosY(726)
				else
					ref4:SetPosY(363)
					ref5:SetPosY(363)
				end
			end
		elseif basemode == 2 then
			settings[modename][typename]["reflect"]:SetInvisible(false)
			settings[modename][typename]["reflectboost"]:SetInvisible(false)
			settings[modename][typename]["reflectclr"]:SetInvisible(false)
			settings[modename][typename]["shine"]:SetInvisible(true)
			settings[modename][typename]["shineclr"]:SetInvisible(true)
			settings[modename][typename]["shineboost"]:SetInvisible(true)
			settings[modename][typename]["rim"]:SetInvisible(true)
			settings[modename][typename]["rimboost"]:SetInvisible(true)
			settings[modename][typename]["pearl"]:SetInvisible(true)
			settings[modename][typename]["glowx"]:SetPosY(130)
			settings[modename][typename]["glowy"]:SetPosY(130)
			settings[modename][typename]["glowz"]:SetPosY(130)
			if overlaymode == 1 or overlaymode == 3 then
				advancedgroup:SetPosY(261)
				if advancedcheck:GetValue() then
					ref4:SetPosY(624)
					ref5:SetPosY(624)
				else
					ref4:SetPosY(261)
					ref5:SetPosY(261)
				end
			else
				advancedgroup:SetPosY(208)
				if advancedcheck:GetValue() then
					ref4:SetPosY(571)
					ref5:SetPosY(571)
				else
					ref4:SetPosY(208)
					ref5:SetPosY(208)
				end
			end
		else
			settings[modename][typename]["reflect"]:SetInvisible(true)
			settings[modename][typename]["reflectboost"]:SetInvisible(true)
			settings[modename][typename]["reflectclr"]:SetInvisible(true)
			settings[modename][typename]["shine"]:SetInvisible(true)
			settings[modename][typename]["shineclr"]:SetInvisible(true)
			settings[modename][typename]["shineboost"]:SetInvisible(true)
			settings[modename][typename]["rim"]:SetInvisible(true)
			settings[modename][typename]["rimboost"]:SetInvisible(true)
			settings[modename][typename]["pearl"]:SetInvisible(true)
			settings[modename][typename]["glowx"]:SetPosY(80)
			settings[modename][typename]["glowy"]:SetPosY(80)
			settings[modename][typename]["glowz"]:SetPosY(80)
			if overlaymode == 1 or overlaymode == 3 then
				advancedgroup:SetPosY(208)
				if advancedcheck:GetValue() then
					ref4:SetPosY(571)
					ref5:SetPosY(571)
				else
					ref4:SetPosY(208)
					ref5:SetPosY(208)
				end
			else
				advancedgroup:SetPosY(155)
				if advancedcheck:GetValue() then
					ref4:SetPosY(518)
					ref5:SetPosY(518)
				else
					ref4:SetPosY(155)
					ref5:SetPosY(155)
				end
			end
		end
		if basemode == 0 or basemode == 3 then
			settings[modename][typename]["basetexturecheck"]:SetDisabled(true)
			settings[modename][typename]["basetexture"]:SetDisabled(true)
			settings[modename][typename]["basespeed"]:SetDisabled(true)
			settings[modename][typename]["baseangle"]:SetDisabled(true)
			settings[modename][typename]["bumpcheck"]:SetDisabled(true)
			settings[modename][typename]["bumpmap"]:SetDisabled(true)
			settings[modename][typename]["bumpspeed"]:SetDisabled(true)
			settings[modename][typename]["bumpangle"]:SetDisabled(true)
		else
			if basemode == 1 then
				settings[modename][typename]["basetexturecheck"]:SetDisabled(false)
				settings[modename][typename]["basetexture"]:SetDisabled(false)
				settings[modename][typename]["basespeed"]:SetDisabled(false)
				settings[modename][typename]["baseangle"]:SetDisabled(false)
				settings[modename][typename]["bumpcheck"]:SetDisabled(false)
				settings[modename][typename]["bumpmap"]:SetDisabled(false)
				settings[modename][typename]["bumpspeed"]:SetDisabled(false)
				settings[modename][typename]["bumpangle"]:SetDisabled(false)
			else
				settings[modename][typename]["basetexturecheck"]:SetDisabled(false)
				settings[modename][typename]["basetexture"]:SetDisabled(false)
				settings[modename][typename]["basespeed"]:SetDisabled(false)
				settings[modename][typename]["baseangle"]:SetDisabled(false)
				settings[modename][typename]["bumpcheck"]:SetDisabled(true)
				settings[modename][typename]["bumpmap"]:SetDisabled(true)
				settings[modename][typename]["bumpspeed"]:SetDisabled(true)
				settings[modename][typename]["bumpangle"]:SetDisabled(true)
			end
		end
	elseif i == 3 then
		if overlaymode == 1 or overlaymode == 3 then
			settings[modename][typename]["glowx"]:SetInvisible(false)
			settings[modename][typename]["glowy"]:SetInvisible(false)
			settings[modename][typename]["glowz"]:SetInvisible(false)
			if basemode == 1 then
				advancedgroup:SetPosY(416)
				if advancedcheck:GetValue() then
					ref4:SetPosY(779)
					ref5:SetPosY(779)
				else
					ref4:SetPosY(416)
					ref5:SetPosY(416)
				end
			elseif basemode == 2 then
				advancedgroup:SetPosY(261)
				if advancedcheck:GetValue() then
					ref4:SetPosY(624)
					ref5:SetPosY(624)
				else
					ref4:SetPosY(261)
					ref5:SetPosY(261)
				end
			else
				advancedgroup:SetPosY(208)
				if advancedcheck:GetValue() then
					ref4:SetPosY(571)
					ref5:SetPosY(571)
				else
					ref4:SetPosY(208)
					ref5:SetPosY(208)
				end
			end
		else
			settings[modename][typename]["glowx"]:SetInvisible(true)
			settings[modename][typename]["glowy"]:SetInvisible(true)
			settings[modename][typename]["glowz"]:SetInvisible(true)
			if basemode == 1 then
				advancedgroup:SetPosY(363)
				if advancedcheck:GetValue() then
					ref4:SetPosY(726)
					ref5:SetPosY(726)
				else
					ref4:SetPosY(363)
					ref5:SetPosY(363)
				end
			elseif basemode == 2 then
				advancedgroup:SetPosY(208)
				if advancedcheck:GetValue() then
					ref4:SetPosY(571)
					ref5:SetPosY(571)
				else
					ref4:SetPosY(208)
					ref5:SetPosY(208)
				end
			else
				advancedgroup:SetPosY(155)
				if advancedcheck:GetValue() then
					ref4:SetPosY(518)
					ref5:SetPosY(518)
				else
					ref4:SetPosY(155)
					ref5:SetPosY(155)
				end
			end
		end
		if overlaymode == 4 then
			settings[modename][typename]["overlaywireframe"]:SetDisabled(false)
			settings[modename][typename]["overlayangle"]:SetDisabled(false)
			settings[modename][typename]["overlayspeed"]:SetDisabled(false)
			settings[modename][typename]["overlaytexture"]:SetDisabled(false)
		else
			settings[modename][typename]["overlaywireframe"]:SetDisabled(true)
			settings[modename][typename]["overlayangle"]:SetDisabled(true)
			settings[modename][typename]["overlayspeed"]:SetDisabled(true)
			settings[modename][typename]["overlaytexture"]:SetDisabled(true)
		end
	end
end

HideSettings(1)
HideSettings(2)
HideSettings(3)

local function DispatchMaterial(i, dmode, dtype)
	if i == 1 then
		local r, g, b, a = settings[dmode][dtype]["baseclr"]:GetValue()
		local reflectr, reflectg, reflectb = settings[dmode][dtype]["reflectclr"]:GetValue()
		local reflecta = settings[dmode][dtype]["reflect"]:GetValue()
		local shinevalue = settings[dmode][dtype]["shine"]:GetValue()
		local shiner, shineg, shineb = settings[dmode][dtype]["shineclr"]:GetValue()
		local rimvalue = settings[dmode][dtype]["rim"]:GetValue()
		local pearlvalue = settings[dmode][dtype]["pearl"]:GetValue()
		local ignorez = 0
		local materialtype = "VertexLitGeneric"
		local texture = "VGUI/white_additive"
		local bumpmap = ""
		local basespeed = settings[dmode][dtype]["basespeed"]:GetValue()
		local baseangle = settings[dmode][dtype]["baseangle"]:GetValue()
		local bumpspeed = settings[dmode][dtype]["bumpspeed"]:GetValue()
		local bumpangle = settings[dmode][dtype]["bumpangle"]:GetValue()
		if settings[dmode][dtype]["basetexturecheck"]:GetValue() then
			texture = settings[dmode][dtype]["basetexture"]:GetValue()
		end
		if settings[dmode][dtype]["bumpcheck"]:GetValue() then
			bumpmap = settings[dmode][dtype]["bumpmap"]:GetValue()
		end
		if settings[dmode][dtype]["reflectboost"]:GetValue() then
			reflecta = reflecta * 10
		end
		if settings[dmode][dtype]["shineboost"]:GetValue() then
			shinevalue = shinevalue * 1000
		end
		if settings[dmode][dtype]["rimboost"]:GetValue() then
			rimvalue = rimvalue * 100
		end
		if settings[dmode][dtype]["base"]:GetValue() == 2 then materialtype = "UnlitGeneric" else materialtype = "VertexLitGeneric" end
		if settings[dmode][dtype]["base"]:GetValue() == 3 then
			a = 0
		end
		if dmode == "viewmodel" then
			ignorez = 0
		else
			if dtype == "iz" or dtype == "attiz" then
				ignorez = 1
			else
				ignorez = 0
			end
		end

		local proxies = ""

		local healthproxy =[[ 
		Health
			{
				scale       "1"
				resultVar   "$enthealth"
			}
				Subtract
			{
				srcVar1     "$tempVar"
				srcVar2     "$enthealth"
				resultVar   "$color[0]"
			}
			Subtract
			{
				srcVar1     "$tempVar"
				srcVar2     "$tempVar"
				resultVar   "$color[2]"
			}
			Equals
			{
				srcVar1     "$enthealth"
				resultVar   "$color[1]"
			}
		]]

		local vmt =[[]].. materialtype ..[[ {
			"$basetexture" 				"]].. texture ..[["
			"$color" 					"[]].. r/255 .. " " .. g/255 .. " " .. b/255 ..[[]"
			"$bumpmap"					"]].. bumpmap ..[["
			"$nofog" 					"1"
			"$envmap" 					"env_cubemap"
			"$envmaptint" 				"[]].. reflecta * (reflectr/255) .. " " .. reflecta * (reflectg/255) .. " " .. reflecta * (reflectb/255) ..[[]"
			"$phong" 					"1"
			"$basemapalphaphongmask" 	"1"
			"$phongboost" 				"]].. shinevalue ..[["
			"$rimlight" 				"1"
			"$phongtint" 				"[]].. shiner/255 .. " " .. shineg/255 .. " " .. shineb/255 .. [[]"
			"$rimlightexponent" 		"9999999"
			"$rimlightboost" 			"]].. rimvalue ..[["
			"$pearlescent" 				"]].. pearlvalue ..[["
			"$alpha" 					"]].. a/255 ..[["
			"$ignorez"					"]].. ignorez ..[["
			"$selfillum" 				"1"
			"$enthealth"    			"0"
			"$tempVar"    				"1"
			"$resVal"         			"0"

			"Proxies"
			{
				"TextureScroll"
				{
					"textureScrollVar" "$basetexturetransform"
					"textureScrollRate" "]].. basespeed ..[["
					"textureScrollAngle" "]].. baseangle ..[["
				}

				"TextureScroll"
				{
					"textureScrollVar" "$bumptransform"
					"textureScrollRate" "]].. bumpspeed ..[["
					"textureScrollAngle" "]].. bumpangle ..[["
				}

				]].. proxies ..[[
				
			}
		}]]
		return vmt
	elseif i == 2 then
		local overlaytype = settings[dmode][dtype]["overlay"]:GetValue()
		local ignorez = 0
		if dmode == "viewmodel" then
			ignorez = 0
		else
			if dtype == "iz" or dtype == "attiz" then
				ignorez = 1
			else
				ignorez = 0
			end
		end
		if	overlaytype == 1 or overlaytype == 3 then
			local r, g, b, a = settings[dmode][dtype]["overlayclr"]:GetValue()
			local x, y, z = settings[dmode][dtype]["glowx"]:GetValue(), settings[dmode][dtype]["glowy"]:GetValue(), settings[dmode][dtype]["glowz"]:GetValue()
			local wireframe = 0
			if overlaytype == 3 then wireframe = 1 else wireframe = 0 end
			local vmt = [["VertexLitGeneric" {
				"$additive" 				"1"
				"$envmap" 					"models/effects/cube_white"
				"$envmaptint" 				"[]].. (a/255) * (r/255) .. " " .. (a/255) * (g/255) .. " " .. (a/255) * (b/255) ..[[]"
				"$envmapfresnel" 			"1"
				"$envmapfresnelminmaxexp" 	"[]].. x .. " " .. y .. " " .. z ..[[]"
				"$selfillum" 				"1"
				"$wireframe"				"]].. wireframe ..[["
				"$ignorez"					"]].. ignorez ..[["
				}]]
			return vmt
		elseif overlaytype == 2 then
			local r, g, b, a = settings[dmode][dtype]["overlayclr"]:GetValue()
			local vmt = [["UnlitGeneric" {
				"$color" 					"[]].. r/255 .. " " .. g/255 .. " " .. b/255 ..[[]"
				"$alpha" 					"]].. a/255 ..[["
				"$selfillum" 				"1"
				"$wireframe"				"1"
				"$ignorez"					"]].. ignorez ..[["
				}]]
			return vmt
		elseif overlaytype == 4 then
			local r, g, b, a = settings[dmode][dtype]["overlayclr"]:GetValue()
			local overlaytexture = settings[dmode][dtype]["overlaytexture"]:GetValue()
			local overlaywireframe = 0
			if settings[dmode][dtype]["overlaywireframe"]:GetValue() then
				overlaywireframe = 1
			end
			local overlayspeed = settings[dmode][dtype]["overlayspeed"]:GetValue()
			local overlayangle = settings[dmode][dtype]["overlayangle"]:GetValue()
			local vmt = [["UnlitGeneric" {
				"$basetexture"				"]].. overlaytexture ..[["
				"$color" 					"[]].. r/255 .. " " .. g/255 .. " " .. b/255 ..[[]"
				"$alpha" 					"]].. a/255 ..[["
				"$additive"					"1"
				"$selfillum" 				"1"
				"$wireframe"				"]].. overlaywireframe ..[["
				"$ignorez"					"]].. ignorez ..[["

				"Proxies"
				{
					"TextureScroll"
					{
						"textureScrollVar" "$basetexturetransform"
						"textureScrollRate" "]].. overlayspeed ..[["
						"textureScrollAngle" "]].. overlayangle ..[["
					}
				
			}
				}]]
			return vmt
		end
	end
end

local function MenuHandler()

	local cache = cached[modename][typename]
	local setting = settings[modename][typename]

	if lastadvanced ~= advancedcheck:GetValue() then
		if advancedcheck:GetValue() then
			advancedgroup:SetInvisible(0)
			HideSettings(2)
			HideSettings(3)
		else
			advancedgroup:SetInvisible(1)
			HideSettings(2)
			HideSettings(3)
		end
		lastadvanced = advancedcheck:GetValue()
	end

	if lastmode ~= modeswitch:GetValue() or lasttype ~= typeswitch:GetValue() or lasttypevm ~= typeswitchvm:GetValue() then
		SetSelections()
		HideSettings(1)
		HideSettings(2)
		HideSettings(3)
		lastmode = modeswitch:GetValue()
		lasttype = typeswitch:GetValue()
		lasttypevm = typeswitchvm:GetValue()
	end
	if lastbase ~= setting.base:GetValue() then
		SetSelections()
		HideSettings(2)
		lastbase = setting.base:GetValue()
	end
	if lastoverlay ~= setting.overlay:GetValue() then
		SetSelections()
		HideSettings(3)
		lastoverlay = setting.overlay:GetValue()
	end
end

callbacks.Register("Draw", MenuHandler)

local function CheckChanges()

	if menuref:IsActive() then
		for tempmode = 0, 3 do
			local tempmodename = nil
			if tempmode == 0 then tempmodename = "enemy" elseif tempmode == 1 then tempmodename = "friend" elseif tempmode == 2 then tempmodename = "loc" elseif tempmode == 3 then tempmodename = "viewmodel" else tempmodename = nil end
			for temptype = 0, 3 do
				local temptypename = nil
				if tempmode == 3 then
					if temptype == 0 then temptypename = "arms" elseif temptype == 1 then temptypename = "weapon" else temptypename = nil end
				else
					if temptype == 0 then temptypename = "vis" elseif temptype == 1 then temptypename = "iz" elseif temptype == 2 then temptypename = "attvis" elseif temptype == 3 then temptypename = "attiz" else temptypename = nil end
				end

				if temptypename ~= nil and tempmodename ~= nil then

					local cache = cached[tempmodename][temptypename]
					local setting = settings[tempmodename][temptypename]

		local baser, baseg, baseb, basea = setting.baseclr:GetValue()
		local reflectr, reflectg, reflectb = setting.reflectclr:GetValue()
		local shiner, shineg, shineb = setting.shineclr:GetValue()

		if cache.base ~= setting.base:GetValue() or
		cache.baseclr.r ~= baser or cache.baseclr.g ~= baseg or cache.baseclr.b ~= baseb or cache.baseclr.a ~= basea or
		cache.reflect ~= setting.reflect:GetValue() or
		cache.reflectboost ~= setting.reflectboost:GetValue() or
		cache.reflectclr.r ~= reflectr or cache.reflectclr.g ~= reflectg or cache.reflectclr.b ~= reflectb or
		cache.shine ~= setting.shine:GetValue() or
		cache.shineclr.r ~= shiner or cache.shineclr.g ~= shineg or cache.shineclr.b ~= shineb or
		cache.shineboost ~= setting.shineboost:GetValue() or
		cache.rim ~= setting.rim:GetValue() or
		cache.rimboost ~= setting.rimboost:GetValue() or
		cache.pearl ~= setting.pearl:GetValue() or
		cache.basetexturecheck ~= setting.basetexturecheck:GetValue() or
		cache.basetexture ~= setting.basetexture:GetValue() or
		cache.basespeed ~= setting.basespeed:GetValue() or
		cache.baseangle ~= setting.baseangle:GetValue() or
		cache.bumpcheck ~= setting.bumpcheck:GetValue() or
		cache.bumpmap ~= setting.bumpmap:GetValue() or
		cache.bumpangle ~= setting.bumpangle:GetValue() or
		cache.bumpspeed ~= setting.bumpspeed:GetValue() then

			RemoveDefaults()

			if tempmode == 0 then
				if temptype == 0 then
					if setting.base:GetValue() == 0 then
						EnemyVisMat = nil
					else
						EnemyVisMat = materials.Create("EnemyVisMat", DispatchMaterial(1, tempmodename, temptypename))
					end
				elseif temptype == 1 then
					if setting.base:GetValue() == 0 then
						EnemyIzMat = nil
					else
						EnemyIzMat = materials.Create("EnemyIzMat", DispatchMaterial(1, tempmodename, temptypename))
					end
				elseif temptype == 2 then
					if setting.base:GetValue() == 0 then
						EnemyAttVisMat = nil
					else
						EnemyAttVisMat = materials.Create("EnemyAttVisMat", DispatchMaterial(1, tempmodename, temptypename))
					end
				elseif temptype == 3 then
					if setting.base:GetValue() == 0 then
						EnemyAttIzMat = nil
					else
						EnemyAttIzMat = materials.Create("EnemyAttIzMat", DispatchMaterial(1, tempmodename, temptypename))
					end
				end
			elseif tempmode == 1 then
				if temptype == 0 then
					if setting.base:GetValue() == 0 then
						FriendVisMat = nil
					else
						FriendVisMat = materials.Create("FriendVisMat", DispatchMaterial(1, tempmodename, temptypename))
					end
				elseif temptype == 1 then
					if setting.base:GetValue() == 0 then
						FriendIzMat = nil
					else
						FriendIzMat = materials.Create("FriendIzMat", DispatchMaterial(1, tempmodename, temptypename))
					end
				elseif temptype == 2 then
					if setting.base:GetValue() == 0 then
						FriendAttVisMat = nil
					else
						FriendAttVisMat = materials.Create("FriendAttVisMat", DispatchMaterial(1, tempmodename, temptypename))
					end
				elseif temptype == 3 then
					if setting.base:GetValue() == 0 then
						FriendAttIzMat = nil
					else
						FriendAttIzMat = materials.Create("FriendAttIzMat", DispatchMaterial(1, tempmodename, temptypename))
					end
				end
			elseif tempmode == 2 then
				if temptype == 0 then
					if setting.base:GetValue() == 0 then
						LocalVisMat = nil
					else
						LocalVisMat = materials.Create("LocalVisMat", DispatchMaterial(1, tempmodename, temptypename))
					end
				elseif temptype == 1 then
					if setting.base:GetValue() == 0 then
						LocalIzMat = nil
					else
						LocalIzMat = materials.Create("LocalIzMat", DispatchMaterial(1, tempmodename, temptypename))
					end
				elseif temptype == 2 then
					if setting.base:GetValue() == 0 then
						LocalAttVisMat = nil
					else
						LocalAttVisMat = materials.Create("LocalAttVisMat", DispatchMaterial(1, tempmodename, temptypename))
					end
				elseif temptype == 3 then
					if setting.base:GetValue() == 0 then
						LocalAttIzMat = nil
					else
						LocalAttIzMat = materials.Create("LocalAttIzMat", DispatchMaterial(1, tempmodename, temptypename))
					end
				end
			elseif tempmode == 3 then
				if temptype == 0 then
					if setting.base:GetValue() == 0 then
						ArmsMat = nil
					else
						ArmsMat = materials.Create("ArmsMat", DispatchMaterial(1, tempmodename, temptypename))
					end
				elseif temptype == 1 then
					if setting.base:GetValue() == 0 then
						WeaponMat = nil
					else
						WeaponMat = materials.Create("WeaponMat", DispatchMaterial(1, tempmodename, temptypename))
					end
				end
			end

			cache.base = setting.base:GetValue()
			cache.baseclr.r = baser
			cache.baseclr.g = baseg
			cache.baseclr.b = baseb
			cache.baseclr.a = basea
			cache.reflect = setting.reflect:GetValue()
			cache.reflectboost = setting.reflectboost:GetValue()
			cache.reflectclr.r = reflectr
			cache.reflectclr.g = reflectg
			cache.reflectclr.b = reflectb
			cache.shine = setting.shine:GetValue()
			cache.shineclr.r = shiner 
			cache.shineclr.g = shineg 
			cache.shineclr.b = shineb
			cache.shineboost = setting.shineboost:GetValue()
			cache.rim = setting.rim:GetValue()
			cache.rimboost = setting.rimboost:GetValue()
			cache.pearl = setting.pearl:GetValue()
			cache.basetexturecheck = setting.basetexturecheck:GetValue()
			cache.basetexture = setting.basetexture:GetValue()
			cache.basespeed = setting.basespeed:GetValue()
			cache.baseangle = setting.baseangle:GetValue()
			cache.bumpcheck = setting.bumpcheck:GetValue()
			cache.bumpmap = setting.bumpmap:GetValue()
			cache.bumpangle = setting.bumpangle:GetValue()
			cache.bumpspeed = setting.bumpspeed:GetValue()
		end

		local overlayr, overlayg, overlayb, overlaya = setting.overlayclr:GetValue()

		if cache.overlay ~= setting.overlay:GetValue() or
		cache.overlayclr.r ~= overlayr or cache.overlayclr.g ~= overlayg or cache.overlayclr.b ~= overlayb or cache.overlayclr.a ~= overlaya or
		cache.glowx ~= setting.glowx:GetValue() or
		cache.glowy ~= setting.glowy:GetValue() or
		cache.glowz ~= setting.glowz:GetValue() or
		cache.overlaywireframe ~= setting.overlaywireframe:GetValue() or
		cache.overlaytexture ~= setting.overlaytexture:GetValue() or
		cache.overlayspeed ~= setting.overlayspeed:GetValue() or
		cache.overlayangle ~= setting.overlayangle:GetValue() then

			RemoveDefaults()

			if tempmode == 0 then
				if temptype == 0 then
					if setting.overlay:GetValue() == 0 then
						EnemyVisOverMat = nil
					else
						EnemyVisOverMat = materials.Create("EnemyVisOverMat", DispatchMaterial(2, tempmodename, temptypename))
					end
				elseif temptype == 1 then
					if setting.overlay:GetValue() == 0 then
						EnemyIzOverMat = nil
					else
						EnemyIzOverMat = materials.Create("EnemyIzOverMat", DispatchMaterial(2, tempmodename, temptypename))
					end
				elseif temptype == 2 then
					if setting.overlay:GetValue() == 0 then
						EnemyAttVisOverMat = nil
					else
						EnemyAttVisOverMat = materials.Create("EnemyAttVisOverMat", DispatchMaterial(2, tempmodename, temptypename))
					end
				elseif temptype == 3 then
					if setting.overlay:GetValue() == 0 then
						EnemyAttIzOverMat = nil
					else
						EnemyAttIzOverMat = materials.Create("EnemyAttIzOverMat", DispatchMaterial(2, tempmodename, temptypename))
					end
				end
			elseif tempmode == 1 then
				if temptype == 0 then
					if setting.overlay:GetValue() == 0 then
						FriendVisOverMat = nil
					else
						FriendVisOverMat = materials.Create("FriendVisOverMat", DispatchMaterial(2, tempmodename, temptypename))
					end
				elseif temptype == 1 then
					if setting.overlay:GetValue() == 0 then
						FriendIzOverMat = nil
					else
						FriendIzOverMat = materials.Create("FriendIzOverMat", DispatchMaterial(2, tempmodename, temptypename))
					end
				elseif temptype == 2 then
					if setting.overlay:GetValue() == 0 then
						FriendAttVisOverMat = nil
					else
						FriendAttVisOverMat = materials.Create("FriendAttVisOverMat", DispatchMaterial(2, tempmodename, temptypename))
					end
				elseif temptype == 3 then
					if setting.overlay:GetValue() == 0 then
						FriendAttIzOverMat = nil
					else
						FriendAttIzOverMat = materials.Create("FriendAttIzOverMat", DispatchMaterial(2, tempmodename, temptypename))
					end
				end
			elseif tempmode == 2 then
				if temptype == 0 then
					if setting.overlay:GetValue() == 0 then
						LocalVisOverMat = nil
					else
						LocalVisOverMat = materials.Create("LocalVisOverMat", DispatchMaterial(2, tempmodename, temptypename))
					end
				elseif temptype == 1 then
					if setting.overlay:GetValue() == 0 then
						LocalIzOverMat = nil
					else
						LocalIzOverMat = materials.Create("LocalIzOverMat", DispatchMaterial(2, tempmodename, temptypename))
					end
				elseif temptype == 2 then
					if setting.overlay:GetValue() == 0 then
						LocalAttVisOverMat = nil
					else
						LocalAttVisOverMat = materials.Create("LocalAttVisOverMat", DispatchMaterial(2, tempmodename, temptypename))
					end
				elseif temptype == 3 then
					if setting.overlay:GetValue() == 0 then
						LocalAttIzOverMat = nil
					else
						LocalAttIzOverMat = materials.Create("LocalAttIzOverMat", DispatchMaterial(2, tempmodename, temptypename))
					end
				end
			elseif tempmode == 3 then
				if temptype == 0 then
					if setting.overlay:GetValue() == 0 then
						ArmsOverMat = nil
					else
						ArmsOverMat = materials.Create("ArmsOverMat", DispatchMaterial(2, tempmodename, temptypename))
					end
				elseif temptype == 1 then
					if setting.overlay:GetValue() == 0 then
						WeaponOverMat = nil
					else
						WeaponOverMat = materials.Create("WeaponOverMat", DispatchMaterial(2, tempmodename, temptypename))
					end
				end
			end

			cache.overlay = setting.overlay:GetValue()
			cache.overlayclr.r = overlayr
			cache.overlayclr.g = overlayg
			cache.overlayclr.b = overlayb
			cache.overlayclr.a = overlaya
			cache.glowx = setting.glowx:GetValue()
			cache.glowy = setting.glowy:GetValue()
			cache.glowz = setting.glowz:GetValue()
			cache.overlaywireframe = setting.overlaywireframe:GetValue()
			cache.overlaytexture = setting.overlaytexture:GetValue()
			cache.overlayspeed = setting.overlayspeed:GetValue()
			cache.overlayangle = setting.overlayangle:GetValue()
		end
		end
		end
		end
	end
end

callbacks.Register("Draw", CheckChanges)

local function ApplyChams(Model)
	local ent = Model:GetEntity()
	local lp = entities.GetLocalPlayer()
	if ent ~= nil then
		local class = ent:GetClass()
		if lp:IsAlive() then
			if class == "CBaseAnimating" then
				if ArmsMat ~= nil then
					Model:ForcedMaterialOverride(ArmsMat)
				end
				if ArmsOverMat ~= nil then
					Model:DrawExtraPass()
					Model:ForcedMaterialOverride(ArmsOverMat)
				end
			end
			if class == "CPredictedViewModel" then
				if WeaponMat ~= nil then
					Model:ForcedMaterialOverride(WeaponMat)
				end
				if WeaponOverMat ~= nil then
					Model:DrawExtraPass()
					Model:ForcedMaterialOverride(WeaponOverMat)
				end
			end
		end
		if class == "CBaseWeaponWorldModel" or class == "CBreakableProp" then
			local modelindex = ent:GetProp("m_nModelIndex")
			if modelindex < 67000000 then -- Don't question it.
				local owner = nil
				if class == "CBaseWeaponWorldModel" then
					owner = ent:GetPropEntity("m_hCombatWeaponParent"):GetPropEntity("m_hOwnerEntity")
				else
					owner = ent:GetPropEntity("moveparent")
				end
				if owner:GetTeamNumber() ~= lp:GetTeamNumber() then
					if EnemyAttIzMat ~= nil then
						Model:ForcedMaterialOverride(EnemyAttIzMat)
						Model:DrawExtraPass()
					end
					if EnemyAttIzOverMat ~= nil then 
						Model:ForcedMaterialOverride(EnemyAttIzOverMat)
						Model:DrawExtraPass()
					end
					if EnemyAttVisMat ~= nil then
						Model:ForcedMaterialOverride(EnemyAttVisMat)
					end
					if EnemyAttVisOverMat ~= nil then
						Model:DrawExtraPass()
						Model:ForcedMaterialOverride(EnemyAttVisOverMat)
					end
				end
				if owner:GetTeamNumber() == lp:GetTeamNumber() and owner:GetIndex() ~= lp:GetIndex() then
					if FriendAttIzMat ~= nil then
						Model:ForcedMaterialOverride(FriendAttIzMat)
						Model:DrawExtraPass()
					end
					if FriendAttIzOverMat ~= nil then 
						Model:ForcedMaterialOverride(FriendAttIzOverMat)
						Model:DrawExtraPass()
					end
					if FriendAttVisMat ~= nil then
						Model:ForcedMaterialOverride(FriendAttVisMat)
					end
					if FriendAttVisOverMat ~= nil then
						Model:DrawExtraPass()
						Model:ForcedMaterialOverride(FriendAttVisOverMat)
					end
				end
				if owner:GetIndex() == lp:GetIndex() then
					if LocalAttIzMat ~= nil then
						Model:ForcedMaterialOverride(LocalAttIzMat)
						Model:DrawExtraPass()
					end
					if LocalAttIzOverMat ~= nil then 
						Model:ForcedMaterialOverride(LocalAttIzOverMat)
						Model:DrawExtraPass()
					end
					if LocalAttVisMat ~= nil then
						Model:ForcedMaterialOverride(LocalAttVisMat)
					end
					if LocalAttVisOverMat ~= nil then
						Model:DrawExtraPass()
						Model:ForcedMaterialOverride(LocalAttVisOverMat)
					end
				end
			end
		end
		-- if class == "CCSRagdoll" then
		-- 	Model:ForcedMaterialOverride(FriendVisMat)
		-- end
		if class == "CCSPlayer" then
			if ent:GetTeamNumber() ~= lp:GetTeamNumber() then
				if EnemyIzMat ~= nil then
					Model:ForcedMaterialOverride(EnemyIzMat)
					Model:DrawExtraPass()
				end
				if EnemyIzOverMat ~= nil then 
					Model:ForcedMaterialOverride(EnemyIzOverMat)
					Model:DrawExtraPass()
				end
				if EnemyVisMat ~= nil then
					Model:ForcedMaterialOverride(EnemyVisMat)
				end
				if EnemyVisOverMat ~= nil then
					Model:DrawExtraPass()
					Model:ForcedMaterialOverride(EnemyVisOverMat)
				end
			end
			if ent:GetTeamNumber() == lp:GetTeamNumber() and ent:GetIndex() ~= lp:GetIndex() then
				if FriendIzMat ~= nil then
					Model:ForcedMaterialOverride(FriendIzMat)
					Model:DrawExtraPass()
				end
				if FriendIzOverMat ~= nil then 
					Model:ForcedMaterialOverride(FriendIzOverMat)
					Model:DrawExtraPass()
				end
				if FriendVisMat ~= nil then
					Model:ForcedMaterialOverride(FriendVisMat)
				end
				if FriendVisOverMat ~= nil then
					Model:DrawExtraPass()
					Model:ForcedMaterialOverride(FriendVisOverMat)
				end
			end
			if ent:GetIndex() == lp:GetIndex() then
				if LocalIzMat ~= nil then
					Model:ForcedMaterialOverride(LocalIzMat)
					Model:DrawExtraPass()
				end
				if LocalIzOverMat ~= nil then 
					Model:ForcedMaterialOverride(LocalIzOverMat)
					Model:DrawExtraPass()
				end
				if LocalVisMat ~= nil then
					Model:ForcedMaterialOverride(LocalVisMat)
				end
				if LocalVisOverMat ~= nil then
					Model:DrawExtraPass()
					Model:ForcedMaterialOverride(LocalVisOverMat)
				end
			end
		end
	end
end

callbacks.Register("DrawModel", ApplyChams)

local function RoundStart(e) --semi fix for default chams when loading new config
	if e:GetName() == "round_start" then
		RemoveDefaults()
	end		
end

client.AllowListener("round_start")
callbacks.Register ("FireGameEvent", RoundStart)

local function OnUnload()
	ref1:SetInvisible(0)
	ref2:SetInvisible(0)
	ref3:SetInvisible(0)
	ref4:SetPosY(565)
	ref5:SetPosY(290)
	ref6:SetInvisible(0)
end

callbacks.Register("Unload", OnUnload)