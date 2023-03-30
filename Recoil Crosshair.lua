-- Recoil Crosshair by Cheeseot and contributors

-- optimization, locals are faster than globals
-- https://lua-users.org/wiki/OptimisingUsingLocalVariables
local math_tan = math.tan
local math_rad = math.rad
local math_sin = math.sin
local tonumber = tonumber
local entities_GetLocalPlayer = entities.GetLocalPlayer
local gui_GetValue = gui.GetValue
local client_SetConVar = client.SetConVar
local client_GetConVar = client.GetConVar
local draw_GetScreenSize = draw.GetScreenSize
local draw_Color = draw.Color
local draw_FilledRect = draw.FilledRect

local refExtra = gui.Reference("Visuals", "Other", "Extra")
local settingCombobox = gui.Combobox(refExtra, "lua_recoilcrosshair", "Recoil Crosshair", "Off", "In-game", "Custom")
local settingColor = gui.ColorPicker(settingCombobox, "color", "", 255, 0, 0, 255)

local varNameRbotEnable = "rbot.master"
local varNameNoRecoil = "esp.other.norecoil"

local function GetIneyePlayer()
	local localPlayer = entities_GetLocalPlayer()
	if not localPlayer then
		return nil
	end

	if localPlayer:IsAlive() then
		return localPlayer
	end

	local obsTarget = localPlayer:GetPropEntity("m_hObserverTarget")
	if not obsTarget or not obsTarget:IsPlayer() then
		return nil
	end
	return obsTarget
end

local WEAPONTYPE_PISTOL = 1
local WEAPONTYPE_SHOTGUN = 4
local WEAPONTYPE_SNIPER_RIFLE = 5
local WEAPONTYPE_MACHINEGUN = 6

callbacks.Register("CreateMove", function()
	-- don't enable in-game recoil crosshair when ragebot is enabled or using no recoil
	local value = (not gui_GetValue(varNameRbotEnable) and 
		not gui_GetValue(varNameNoRecoil) and settingCombobox:GetValue() == 1) and 1 or 0

	client_SetConVar("cl_crosshair_recoil", value, true)
end)

callbacks.Register("Draw", function()
	local setting = settingCombobox:GetValue()
	
	if gui_GetValue(varNameRbotEnable) or setting == 0 then
		return
	end

	local noVisRecoil = gui_GetValue(varNameNoRecoil)

	local localPlayer = entities_GetLocalPlayer()
	local ineyePlayer = GetIneyePlayer()
	-- if localPlayer is nil then ineyePlayer is nil too
	-- draw recoil crosshair when using no visual recoil or when using ingame crosshair and scoped
	if not localPlayer or (not ineyePlayer or not ineyePlayer:IsAlive()) or
		(not noVisRecoil and setting ~= 2 and not ineyePlayer:GetPropBool("m_bIsScoped")) then
		return
	end

	local activeWeapon = ineyePlayer:GetPropEntity("m_hActiveWeapon")
	if not activeWeapon or activeWeapon:GetPropFloat("m_flRecoilIndex") <= 1 then
		return
	end

	local weaponType = activeWeapon:GetWeaponType()
	if WEAPONTYPE_PISTOL > weaponType or weaponType > WEAPONTYPE_MACHINEGUN or
		weaponType == WEAPONTYPE_SHOTGUN or
		weaponType == WEAPONTYPE_SNIPER_RIFLE then
		return
	end

	local fov = ineyePlayer:GetPropInt("m_iFOV")
	if fov <= 0 then
		fov = ineyePlayer:GetPropInt("m_iDefaultFOV")
	end

	local punchAngle = localPlayer:GetPropVector("localdata", "m_Local", "m_aimPunchAngle")
	local screenW, screenH = draw_GetScreenSize()
	local centerX = screenW * 0.5
	local centerY = screenH * 0.5

	local VIEWPUNCH_COMPENSATE_MAGIC_SCALAR = 0.65
	if noVisRecoil then
		VIEWPUNCH_COMPENSATE_MAGIC_SCALAR =
			VIEWPUNCH_COMPENSATE_MAGIC_SCALAR * tonumber(client_GetConVar("weapon_recoil_scale"))
	end

	-- https://github.com/perilouswithadollarsign/cstrike15_src/blob/master/game/shared/cstrike15/weapon_csbase.cpp#L2109
	local flAngleToScreenPixel = VIEWPUNCH_COMPENSATE_MAGIC_SCALAR * 2 * ( screenH / ( 2.0 * math_tan( math_rad( fov ) * 0.5 ) ) )
	local recoilX = centerX - ( flAngleToScreenPixel * math_sin( math_rad( punchAngle.y ) ) )
	local recoilY = centerY + ( flAngleToScreenPixel * math_sin( math_rad( punchAngle.x ) ) )

	local diffX = recoilX - centerX
	local diffY = recoilY - centerY

	if (5 > diffX and diffX > -5) and (5 > diffY and diffY > -5) then
		return
	end

	draw_Color(settingColor:GetValue())
	draw_FilledRect(recoilX - 3, recoilY - 1, recoilX + 3, recoilY + 1)
	draw_FilledRect(recoilX - 1, recoilY - 3, recoilX + 1, recoilY + 3)
end)