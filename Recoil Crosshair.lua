-- Recoil Crosshair by Cheeseot and contributors

local refExtra = gui.Reference("Visuals", "Other", "Extra")
local settingGroup = gui.Groupbox(refExtra, "Custom Recoil Crosshair", 296, 220, 296, 0)
local settingEnable = gui.Checkbox(settingGroup, "lua_recoilcrosshair", "Enable", true)
local settingColor = gui.ColorPicker(settingEnable, "color", "", 255, 0, 0, 255)
local settingIngame = gui.Checkbox(settingGroup, "lua_recoilcrosshair.ingame", "Use in-game crosshair", true)

-- optimization, locals are faster than globals
-- https://lua-users.org/wiki/OptimisingUsingLocalVariables
local math_tan = math.tan
local math_rad = math.rad
local math_sin = math.sin
local tonumber = tonumber

callbacks.Register("CreateMove", function()
	-- don't enable in-game recoil crosshair when ragebot is enabled or using no recoil
	local value = (not gui.GetValue("rbot.master") and not gui.GetValue("esp.other.norecoil") and 
		settingEnable:GetValue() and settingIngame:GetValue()) and 1 or 0

	client.SetConVar("cl_crosshair_recoil", value, true)
end)

local function GetIneyesPlayer()
	local localPlayer = entities.GetLocalPlayer()
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

callbacks.Register("Draw", function()
	if gui.GetValue("rbot.master") or not settingEnable:GetValue() then
		return
	end
	
	local noRecoil = gui.GetValue("esp.other.norecoil")
	
	local localPlayer = entities.GetLocalPlayer()
	local player = GetIneyesPlayer()
	-- if localPlayer is nil then player:IsAlive is nil too
	-- draw recoil crosshair when using no recoil or when using ingame crosshair but scoped
	if not localPlayer or (not player or not player:IsAlive()) or
		(not noRecoil and settingIngame:GetValue() and not player:GetPropBool("m_bIsScoped")) then
		return
	end

	local activeWeapon = player:GetPropEntity("m_hActiveWeapon")
	if not activeWeapon or activeWeapon:GetPropFloat("m_flRecoilIndex") <= 1 then
		return
	end

	local weaponType = activeWeapon:GetWeaponType()
	if WEAPONTYPE_PISTOL > weaponType or weaponType > WEAPONTYPE_MACHINEGUN or 
		weaponType == WEAPONTYPE_SHOTGUN or 
		weaponType == WEAPONTYPE_SNIPER_RIFLE then
		return
	end

	local fov = player:GetPropInt("m_iFOV")
	if fov <= 0 then
		fov = player:GetPropInt("m_iDefaultFOV")
	end

	local punchAngle = localPlayer:GetPropVector("localdata", "m_Local", "m_aimPunchAngle")
	local screenW, screenH = draw.GetScreenSize()
	local centerX = screenW * 0.5
	local centerY = screenH * 0.5

	local VIEWPUNCH_COMPENSATE_MAGIC_SCALAR = 0.65
	if noRecoil then
		VIEWPUNCH_COMPENSATE_MAGIC_SCALAR =
			VIEWPUNCH_COMPENSATE_MAGIC_SCALAR * tonumber(client.GetConVar("weapon_recoil_scale"))
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

	draw.Color(settingColor:GetValue())
	draw.FilledRect(recoilX - 3, recoilY - 1, recoilX + 3, recoilY + 1)
	draw.FilledRect(recoilX - 1, recoilY - 3, recoilX + 1, recoilY + 3)
end)