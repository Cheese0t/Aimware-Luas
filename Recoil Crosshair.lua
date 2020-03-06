--Recoil Crosshair by Cheeseot
local ButtonPosition = gui.Reference( "VISUALS", "Other", "Extra" );
local PunchCheckbox = gui.Checkbox( ButtonPosition, "lua_recoilcrosshair", "Recoil Crosshair", 1 );
local recoilcolor = gui.ColorPicker(PunchCheckbox, "recoilcolor", "Recoil Crosshair Color", 255,255,255,255)
local IdleCheckbox = gui.Checkbox( ButtonPosition, "lua_recoilidle", "Hide Recoil Crosshair When Idle", 1 );

local function punch()

local rifle = 0;
local me = entities.GetLocalPlayer();
if me ~= nil and not gui.GetValue("rbot.master") then
    if me:IsAlive() then
    local scoped = me:GetProp("m_bIsScoped");
    if scoped == 256 then scoped = 0 end
    if scoped == 257 then scoped = 1 end
    local my_weapon = me:GetPropEntity("m_hActiveWeapon");
    if my_weapon ~=nil then
        local weapon_name = my_weapon:GetClass();
        local canDraw = 0;
        local snipercrosshair = 0;
        weapon_name = string.gsub(weapon_name, "CWeapon", "");
        if weapon_name == "Aug" or weapon_name == "SG556" then
            rifle = 1;
            else
            rifle = 0;
            end

        if scoped == 0 or (scoped == 1 and rifle == 1) then
            canDraw = 1;
            else
            canDraw = 0;
            end

        if weapon_name == "Taser" or weapon_name == "CKnife" then
            canDraw = 0;
            end

        if weapon_name == "AWP" or weapon_name == "SCAR20" or weapon_name == "G3SG1"  or weapon_name == "SSG08" then
            snipercrosshair = 1;
            end

    --Recoil Crosshair by Cheeseot

        if PunchCheckbox:GetValue() and canDraw == 1 then
            local punchAngleVec = me:GetPropVector("localdata", "m_Local", "m_aimPunchAngle");
            local punchAngleX, punchAngleY = punchAngleVec.x, punchAngleVec.y
            local w, h = draw.GetScreenSize();
            local x = w / 2;
            local y = h / 2;
            local fov = 90 --gui.GetValue("vis_view_fov");      polak pls add this back

            if fov == 0 then
                fov = 90;
                end
            if scoped == 1 and rifle == 1 then
                fov = 45;
                end
            
            local dx = w / fov;
            local dy = h / fov;
			
			local px = 0
			local py = 0
			
            if gui.GetValue("esp.other.norecoil") then
				px = x - (dx * punchAngleY)*1.2;
				py = y + (dy * punchAngleX)*2;
            else
				px = x - (dx * punchAngleY)*0.6;
				py = y + (dy * punchAngleX);
			end
            
            if px > x-0.5 and px < x then px = x end
            if px < x+0.5 and px > x then px = x end
            if py > y-0.5 and py < y then py = y end
            if py < y+0.5 and py > y then py = y end

			if IdleCheckbox:GetValue() then
            if px == x and py == y and snipercrosshair ~=1 then return; end
			end
				
            draw.Color(recoilcolor:GetValue());
            draw.FilledRect(px-3, py-1, px+3, py+1);
            draw.FilledRect(px-1, py-3, px+1, py+3);
            end
        end
    end
    end
end
callbacks.Register("Draw", "punch", punch);
--Recoil Crosshair by Cheeseot