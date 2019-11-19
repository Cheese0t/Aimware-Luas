local info = {}
local steamids = {}
local windowactive = 0

local function in_table(tbl, value)
    for _, v in ipairs(tbl) do
        if value == v then
            return true
        end
    end
    return false
end

function tablelength(tbl)
	local length = 0
	for _ in pairs(tbl) do length = length + 1 end
	return length
end

local function buildtable()
	local lp = entities.GetLocalPlayer();
	if lp ~= nil then
		local lpindex = lp:GetIndex()
		for i = 1, globals.MaxClients(), 1 do
			local player_info = client.GetPlayerInfo(i);		
			if player_info ~= nil and in_table(steamids, player_info["SteamID"]) == false and player_info["IsBot"] == false and player_info["IsGOTV"] == false and lpindex ~= i then
				player_info["Active"] = 0
				player_info["Index"] = i
				table.insert(steamids, player_info["SteamID"])
				info[player_info["SteamID"]] = player_info
			elseif player_info ~= nil and in_table(steamids, player_info["SteamID"]) == true and info[player_info["SteamID"]]["Index"] == nil then
				info[player_info["SteamID"]]["Index"] = i
			elseif player_info ~= nil and in_table(steamids, player_info["SteamID"]) == true then 
				if info[player_info["SteamID"]]["Index"] ~= i then 
				info[player_info["SteamID"]]["Index"] = i
				end
				if info[player_info["SteamID"]]["Name"] ~= player_info["Name"] then
				info[player_info["SteamID"]]["Name"] = player_info["Name"]
				end
			end
		end
	end
end	

local function inmygame(steamid)
	for i = 1, globals.MaxClients(), 1 do
		local tempinfo = client.GetPlayerInfo(i)
		if tempinfo ~= nil then
			if steamid == tempinfo["SteamID"] then
			return true 
			end
		end
	end
	return false 
end

local function deleteindex()
	for k,v in pairs(info) do
		if not inmygame(k) then
		v["Index"] = nil
		end
	end
end		

local function IsInRect( x, y, x1, y1, x2, y2 )
    return x >= x1 and x < x2 and y >= y1 and y < y2;
end

local PListWindow = gui.Window( "plistwindow", "Per Player ESP", 100, 100, 200, 175 );

function refresh( x1, y1, x2, y2, active )
	local mx, my = input.GetMousePos(); 
	local i = 0	
	local lp = entities.GetLocalPlayer();
	for k,v in pairs(info) do		
		if v["Index"] ~= nil then
			local ent = entities.GetByIndex(v["Index"])
			if ent ~= nil then
				if lp:GetTeamNumber() == ent:GetTeamNumber() then
					goto skip
				end
			end
			i = i + 1		
			if IsInRect( mx, my, x1 + 16 , y1 + 16 + (i - 1) * 25 , x2 - 16, y1 + 16 + (i - 1) * 25 + 20 ) then
				if input.IsButtonPressed( "mouse1" ) and v["Active"] == 0 then			
					draw.Color( 127, 127, 127, 63 );
					draw.RoundedRectFill( x1 + 16 , y1 + 16 + (i - 1) * 25 , x2 - 16, y1 + 16 + (i - 1) * 25 + 20 );
					v["Active"] = 1
				elseif v["Active"] == 1 and input.IsButtonPressed( "mouse1" )then
					draw.Color( 127, 127, 127, 150 );
					draw.RoundedRectFill( x1 + 16 , y1 + 16 + (i - 1) * 25 , x2 - 16, y1 + 16 + (i - 1) * 25 + 20 );
					v["Active"] = 0
				else
					draw.Color( 127, 127, 127, 63 );
					draw.RoundedRect( x1 + 16 , y1 + 16 + (i - 1) * 25 , x2 - 16, y1 + 16 + (i - 1) * 25 + 20 );
				end
			end
			if v["Active"] == 1 then
				draw.Color( 127, 127, 127, 150 );
				draw.RoundedRectFill( x1 + 16 , y1 + 16 + (i - 1) * 25 , x2 - 16, y1 + 16 + (i - 1) * 25 + 20 );
			end			
				draw.Color( 255, 255, 255, 255 );
				draw.Text( x1 + 16 + 5, y1 + 16 + (i - 1) * 25 + 3 , v["Name"] );
		end
		::skip::
	end
end

local players = gui.Custom( PListWindow, "players", 0, 0, 200, 175, refresh)

local function ESP(builder)
local ent = builder:GetEntity()
local player = entities.GetLocalPlayer()
	if not ent:IsPlayer() or player == nil then return end
	if player:GetHealth() <= 0 then return end
	local entidx = ent:GetIndex()
	local EspRect = {builder:GetRect()}
	local weapon = ent:GetPropEntity("m_hActiveWeapon") 
	for k, v in pairs(info) do
		if v["Index"] ~= nil then
			local index = v["Index"]
			if index == entidx and v["Active"] == 1 then
				builder:AddTextTop(v["Name"])
				draw.OutlinedRect(EspRect[1],EspRect[2],EspRect[3],EspRect[4])
				if weapon ~= nil then
				builder:AddTextBottom(weapon:GetName())
				end
				local hp = ent:GetHealth()
				local R = math.floor(255 - hp * 2.55)
				local G = math.floor(hp * 2.55)
				local B = 0
				builder:Color(R,G,B,255)
				builder:AddBarLeft(hp/100)
			end
		end
	end
end

callbacks.Register("DrawESP", "ESP" ,ESP)

local function refreshbutton()
	
	if gui.Reference("MENU"):IsActive() and windowactive == 0 then
		PListWindow:SetActive(1)
		windowactive = 1
	elseif not gui.Reference("MENU"):IsActive() and windowactive == 1 then
		PListWindow:SetActive(0)
		windowactive = 0
	end
end
callbacks.Register("Draw","refreshbutton",refreshbutton)


local function GameEvents(event)
	if event:GetName() == "game_init" or event:GetName() == "player_team" or event:GetName() == "player_changename" or event:GetName() == "game_end" or event:GetName() == "player_disconnect" then
		buildtable()
		deleteindex()
	end
end

callbacks.Register("FireGameEvent",GameEvents)

client.AllowListener("game_init")
client.AllowListener("player_team")
client.AllowListener("player_changename")
client.AllowListener("game_end")
client.AllowListener("player_disconnect")

local function cleartables()
local lp = entities.GetLocalPlayer()
    if lp == nil then 
		info = {}
		steamids = {}
	end	
end

callbacks.Register("Draw", "cleatables", cleartables)

buildtable()