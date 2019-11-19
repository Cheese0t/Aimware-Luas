--Health Chams by Cheeseot--

local ref = gui.Reference("VISUALS","ENEMIES","Options")
local HPchams = gui.Checkbox(ref,"lua_healthchams","Health Chams", 0)
local chamssetting,xqzsetting
local toggle = 0
local health = {}

function RGB2clr(R, G, B)
    return 0xFFFFFF & ((R&0xFF)|((G&0xFF)<<8)|((B&0xFF)<<16))
end

function is_enemy(me, player)
    return (me:GetTeamNumber() ~= player:GetTeamNumber())
end

--Health Chams by Cheeseot--

function healthchams()
	if HPchams:GetValue() then
		if toggle == 0 then
			chamssetting = gui.GetValue("esp_enemy_chams")
			xqzsetting = gui.GetValue("esp_enemy_xqz")
			toggle = 1
			gui.SetValue("esp_enemy_chams", 0)
			gui.SetValue("esp_enemy_xqz", 0)
		end
		local lp = entities:GetLocalPlayer()
		if lp == nil then
			health = {}
		else
			for index, player in pairs( entities.FindByClass( "CCSPlayer" ) ) do
				if (is_enemy(lp, player) and player:IsAlive()) then
					local hp = player:GetHealth()
					if health[index] == nil or health[index] ~= hp then
						health[index] = hp
						local R = math.floor(255 - hp * 2.55)
						local G = math.floor(hp * 2.55)
						local B = 0
						player:SetProp("m_clrRender", RGB2clr(R,G,B))
					end
				end
			end
		end
	elseif toggle == 1 then
		gui.SetValue("esp_enemy_chams", chamssetting)
		gui.SetValue("esp_enemy_xqz", xqzsetting)
		toggle = 0
	end
end

callbacks.Register ("Draw", "healthchams", healthchams)

--Health Chams by Cheeseot--