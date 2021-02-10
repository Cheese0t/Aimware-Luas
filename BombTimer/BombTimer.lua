--decode base64
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function dec(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

--animation stuff
local function sineout(time, start, add, dur)
    return add * math.sin(time/dur * (math.pi/2)) + start
end

local function sineinout(time, start, add, dur)
	return -add/2 * (math.cos(math.pi*time/dur) - 1) + start
end

--textures for everything in base64
local outlinetexture = draw.CreateTexture(common.DecodePNG(dec([["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"]])))
local circleglowtexture = draw.CreateTexture(common.DecodePNG(dec([["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"]])))
local bombiconglowtexture = draw.CreateTexture(common.DecodePNG(dec([["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"]])))
local bombicontexture = draw.CreateTexture(common.DecodePNG(dec([["iVBORw0KGgoAAAANSUhEUgAAAFAAAABKCAYAAAAsXNNQAAAEqElEQVR4nO2aWYhcRRRAzxvbTGY0miFhDDoxGT8Sg4rLCDGiSMQFRHCJqD9ClIAYFUSiiKB+KAqKYNRIQDT6JS7ol35Ekj+duG+RAQXjuCQqWUxMopIxJQX3wZ2iqvt19+ttuAeKqrp9q16927XcqnoYhmEYhmEYhmEYhmEYhmEYRlvIij7EOeej24FrgDkz7O/5FXgDeNtnsqywWeoy4AvAHQ02sFe4yRuyVQZ0M9hwOZPAaJZlhd+1r+VN6i0WAWfW0+JKl7/eJ4CfOg60oO4VwLqIfKCeSrp9CPve8G2L6p4H7I7Ix7Is+7xoJd0+hFu52i8uo5JuN2C3TzG2iDSLGbBJetGAJwX5RUF+dhvb0lMGPB14CngfuFZkfmf0PfAicAKwFPgS2Axc1uH2Tsd1hou89yThKtWCCZEdUbK5zrlbVH6DKhsLY4k3Oq8eu/RSD/TbrC3A18CrInsYOAxsldjr/Cy9ckuH2zudLuiBeRgI8guC/KBzrq9G7yutB3a9nxXh70D0W5A/3M7GmBvTJGbAJunUEH4C+Evl1wCnRfRim/2y2FNGPZ0w4LPAg4FsRcKAlwI/tKgdZ5RRSbuPsw7KCYvfTSwAvhK5d0NWJsrsUe38Dzgq6YqSH5XfEFmlhtwzNzGF1XWcVWYP3KtWyGHg2IjObRI/AsySoVuLeSW2sXTKWET8tukG2ZOeKmEhsC3Qew94U9Ir5RasFt4xXgVcLmGj6PteeZ2S36vqeUbJ1yg3Z5OS+/BZ+8ycdqRXV3FUJ5Se33ItFvmdIluodLcm6n8oUq/nm4h8l3Nuf0T+oZSZHcjXddqRfhp4ReVXqwuZ+bL5z3kM+BHoB54XWZH5tz/I5ycxsROXg4kRNajKTlapuyEaNeBO4D6VXwtsSOj6Rj8qaX2J05dIa/YH+d8lPhLR7U/Mu/+qdmj2JZ5ZF40acNyPakmfXMV4iHH9ajgqPTFHP3t+ouwq+WogZ4nEI/KVRO5LDgGnSK++B/hD5IOqzOPAdlXXzYXftgqNujHvAldLegz4NFHMLxo3StovLhfKUEOdoHguECNuFEN0kra4Mf+o9N4qeq+r9E8SYuQr9q6IAX2ZQ8AxqjchPTO/L14WlJmQeCS42cvlftScWP0Vi9GoAYdVegfwHHB3RO8u4JxEHX4R+lPSt8pOZDTQ2aR8R2TYvSZ/2lIxrOdcmVa8kS9Wf4h31r+Q+HrgHZF7470ssvYQWe7PD9yC+51zm1XYl3ATcpaospMJnQcSbsz2iHyHc253RD6ecGPWluHGNONIrw/yTwJXqDBeo/xOlZ5I6ITuypDEsZEzpbZtmnxlHgrkpVzaN2NAvyD4yfaSyG+VSINDlsnQ8uH4hE74nUq+D54V0fXPOy4iT93SpeTFv20r8TDhO5kLc84Wx7Va/VPKFaokdA8EPdlP/mdJuQ/UHDhH/lDPR2puHZA5MZNvbH5RdS2XA4WQ5VmWfVyl3dOw7wOn4w0/kmXZoaIF6hnC7d18d4b1qlcXop4e6Cfjt4ArZ4atpuG3hi/JLqZl30jnyeHqmj3JlN4Q1GNAwzAMwzAMwzAMwzAMwzAMw2gDwP+wmxCF4CJz9wAAAABJRU5ErkJggg=="]])))
local bombsiteatexture = draw.CreateTexture(common.RasterizeSVG([[<svg width="32px" height="32px"><polygon fill="#FFFFFF" points="13.59,17.513 18.377,17.513 15.984,9.619"/><path fill="#FFFFFF" d="M16,1.259C7.858,1.259,1.259,7.858,1.259,16c0,8.142,6.6,14.742,14.741,14.742c8.141,0,14.741-6.6,14.741-14.742C30.741,7.858,24.141,1.259,16,1.259z M20.958,25.345l-1.493-4.507h-6.992l-1.431,4.507H7.28l6.994-20.701h3.451l6.993,20.701H20.958z"/></svg>]], 1))
local bombsitebtexture = draw.CreateTexture(common.RasterizeSVG([[<svg width="32px" height="32px"><path fill="#FFFFFF" d="M18.716,17.689h-5.378v5.532h5.378c0.229,0,0.424-0.077,0.591-0.232c0.166-0.157,0.249-0.347,0.249-0.577v-3.915c0-0.227-0.083-0.42-0.249-0.576C19.14,17.767,18.944,17.689,18.716,17.689z"/> <path fill="#FFFFFF" d="M19.399,13.525v-3.42c0-0.228-0.083-0.42-0.249-0.576c-0.165-0.155-0.364-0.232-0.59-0.232h-5.223v5.035h5.316C19.151,14.291,19.399,14.022,19.399,13.525z"/><path fill="#FFFFFF" d="M16,1.518c-8.141,0-14.741,6.6-14.741,14.742C1.259,24.4,7.859,31,16,31c8.142,0,14.741-6.6,14.741-14.741C30.741,8.118,24.142,1.518,16,1.518z M23.285,23.346c0,0.913-0.322,1.684-0.963,2.314c-0.643,0.633-1.419,0.949-2.331,0.949H9.609V5.908h10.226c0.91,0,1.689,0.316,2.331,0.949c0.643,0.632,0.963,1.404,0.963,2.315v4.444c0,0.478-0.155,0.938-0.467,1.383c-0.311,0.446-0.704,0.742-1.181,0.886c0.477,0.083,0.896,0.332,1.26,0.746c0.361,0.416,0.543,0.912,0.543,1.493V23.346z"/></svg>]], 1))
local numbericons = {
	[0] = draw.CreateTexture(common.RasterizeSVG([[<svg width="512" height="512"><path fill="#FFFFFF" d="m256 0c-109.482 0-165 86.518-165 255.194 0 63.267 0 256.806 165 256.806 109.482 0 165-86.737 165-255.839 0-169.307-55.518-256.161-165-256.161zm0 105.707c45.26 0 42.349 104.904 42.349 150.454 0 45.233 3.176 150.132-42.349 150.132-45.361 0-42.349-104.514-42.349-150.132 0-45.363-3.228-150.454 42.349-150.454z"/></g></svg>]],0.05)),
	[1] = draw.CreateTexture(common.RasterizeSVG([[<svg width="512" height="512"><path fill="#FFFFFF" d="m376 512v-512h-99.902l-3.56 9.932c-9.419 26.294-27.202 49.746-52.837 69.697-26.528 20.684-51.211 34.849-73.359 42.1l-10.342 3.383v114.771l19.702-6.519c36.387-12.012 69.448-29.268 98.672-51.445v330.081z"/></g></svg>]],0.05)),
	[2] = draw.CreateTexture(common.RasterizeSVG([[<svg width="512" height="512"><path fill="#FFFFFF" d="m436.879 148.037c0-73.682-52.808-148.037-170.786-148.037-105.308 0-166.875 53.555-178.067 154.878l-1.67 15.103 124.336 12.114 1.025-15.439c3.545-53.467 28.286-60.674 52.031-60.674 32.285 0 48.647 16.348 48.647 48.589 0 94.33-216.104 166.375-235.43 340.774l-1.844 16.655h361.758v-117.107h-171.797c54.405-60.11 171.797-126.067 171.797-246.856z"/></g></svg>]],0.05)),
	[3] = draw.CreateTexture(common.RasterizeSVG([[<svg width="512" height="512"><path fill="#FFFFFF" d="m363.395 231.083c33.926-25.107 51.079-56.792 51.079-94.526 0-66.636-60.732-136.557-162.378-136.557-158.476 0-167.63 144.392-171.108 151.117l118.74 19.087c1.679-4.734-1.149-65.142 49.658-65.142 45.748 0 47.476 48.183 27.715 67.441-13.91 13.568-22.534 11.392-65.405 14.78l-15.601 109.058c14.685-3.471 39.459-12.041 61.758-12.041 25.591 0 51.416 18.164 51.416 58.755 0 43.682-27.524 63.237-54.8 63.237-57.998 0-55.866-65.857-57.524-70.195l-121.787 13.975c1.564 3.002 3.976 161.928 179.985 161.928 101.895 0 181.699-73.085 181.699-165.092 0-52.207-27.934-94.936-73.447-115.825z"/></g></svg>]],0.05)),
	[4] = draw.CreateTexture(common.RasterizeSVG([[<svg width="512" height="512"><path fill="#FFFFFF" d="m379.018 0h-96.988l-206.03 314.106v99.697h187.852v98.197h115.166v-98.196h56.982v-110.537h-56.982zm-178.14 303.267 62.974-97.5v97.5z"/></g></svg>]],0.05)),
	[5] = draw.CreateTexture(common.RasterizeSVG([[<svg width="512" height="512"><path fill="#FFFFFF" d="m272.399 153.729c-15.044 0-30 2.227-44.722 6.621l7.72-42.524h178.606v-117.826h-274.802l-53.54 278.621 99.727 14.077c4.191-3.409 26.049-35.874 66.929-35.874 37.383 0 57.964 25.972 57.964 73.11 0 49.248-20.669 78.647-55.283 78.647-55.767 0-54.844-65.602-56.279-68.613l-123.722 12.496c1.589 3.083 6.57 159.536 178.989 159.536 118.872 0 183.018-94.644 183.018-183.706-.001-114.609-82.808-174.565-164.605-174.565z"/></g></svg>]],0.05)),
	[6] = draw.CreateTexture(common.RasterizeSVG([[<svg width="512" height="512"><path fill="#FFFFFF" d="m207.528 187.158c6.797-50.501 21.724-82.211 58.418-82.211 16.025 0 34.995 4.49 39.39 39.523l1.816 14.535 122.314-12.844-2.798-15.76c-14.574-82.238-71.073-130.401-154.994-130.401-126.182 0-195.674 92.76-195.674 259.368 0 162.263 66.138 252.632 186.24 252.632 102.305 0 173.76-72.685 173.76-175.335-.015-146.489-147.158-200.781-228.472-149.507zm54.712 76.875c32.93 0 51.064 26.14 51.064 73.594 0 31.374-8.042 68.783-46.348 68.783-26.382 0-54.771-24.041-54.771-76.802.002-41.053 18.708-65.575 50.055-65.575z"/></g></svg>]],0.05)),
	[7] = draw.CreateTexture(common.RasterizeSVG([[<svg width="512" height="512"><path fill="#FFFFFF" d="m76 118.646h203.628c-111.729 149.702-123.431 274.51-136.348 393.354h123.516c20.146-158.928 47.398-305.069 164.531-416.411l4.673-4.424v-91.165h-360z"/></g></svg>]],0.05)),
	[8] = draw.CreateTexture(common.RasterizeSVG([[<svg width="512" height="512"><path fill="#FFFFFF" d="m359.389 233.456c30.161-22.441 47.611-56.338 47.611-96.328 0-82.69-60.268-137.128-152.553-137.128-92.3 0-152.447 54.438-152.447 137.128 0 41.118 17.652 74.736 49.381 97.017-38.701 26.337-60.381 68.496-60.381 119.267 0 94.263 67.31 158.588 167.49 158.588 98.873 0 162.51-68.304 162.51-162.44 0-49.6-22.119-90.66-61.611-116.104zm-103.697 54.199c33.706 0 48.794 29.165 48.794 58.066 0 39.36-17.769 62.856-47.549 62.856-24.038 0-49.731-16.772-49.731-63.823 0-21.21 10.21-57.099 48.486-57.099zm-1.245-102.085c-25.254 0-39.155-14.927-39.155-42.041 0-25.723 14.985-41.074 40.093-41.074 24.316 0 38.833 15.234 38.833 40.752 0 27.319-14.121 42.363-39.771 42.363z"/></g></svg>]],0.05)),
	[9] = draw.CreateTexture(common.RasterizeSVG([[<svg width="512" height="512"><path fill="#FFFFFF" d="m250.023 0c-93.632 0-159.023 72.528-159.023 174.936 0 109.849 74.678 169.116 144.932 169.116 23.306 0 44.297-5.977 62.783-17.827-5.83 45.059-18.442 80.435-50.83 80.435-39.824 0-33.909-47.047-36.753-53.848l-113.804 13.125c4.562 10.036-2.356 146.063 144.111 146.063 115.796 0 179.561-92.582 179.561-258.886 0-162.583-60.718-253.114-170.977-253.114zm44.444 182.304c0 10.972-2.109 65.742-43.828 65.742-40.664 0-45.059-51.123-45.059-73.11 0-31.597 7.017-69.272 40.459-69.272 35.537-.001 48.428 45.834 48.428 76.64z"/></g></svg>]],0.05))
}

--auto updates, applied next time you load the script
local ScriptName = GetScriptName()
local ScriptAddress = "https://raw.githubusercontent.com/Cheese0t/Aimware-Luas/master/BombTimer/BombTimer.lua"
local VersionAddress = "https://raw.githubusercontent.com/Cheese0t/Aimware-Luas/master/BombTimer/Version.txt"
local VersionNumber = "1.0"

local function HandleUpdates()
	local Version = http.Get(VersionAddress)
	Version = string.gsub(Version, "\n", "")
	if (Version ~= VersionNumber) then
		local NewVersion = http.Get(ScriptAddress)
		local OldScript = file.Open(ScriptName, "w")
        OldScript:Write(NewVersion)
        OldScript:Close()
	end
end

HandleUpdates()

--gui elements
local menuref = gui.Reference("Menu")
local uiref = gui.Reference("Visuals", "World")
local group = gui.Groupbox(uiref, "Bomb Timer", 328, 290, 297, 300)
local scaleslider = gui.Slider(group, "chs_bombtimer_scale", "Scale", 1, 0.5, 2, 0.01)
local animspeedslider = gui.Slider(group, "chs_bombtimer_speed", "Animation Speed", 0.5, 0, 1, 0.01)
animspeedslider:SetDescription("Time between screen and world position, in seconds.")
local distanceslider = gui.Slider(group, "chs_bombtimer_worlddistance", "Max World Distance", 750, 250, 1500, 1)
distanceslider:SetDescription("Maximum distance timer will be displayed in-world.")
local movecheckbox = gui.Checkbox(group, "chs_bombtimer_movable", "Edit Position", false)

--vars for stuff
local posx,posy = 640, 950
local offsetx,offsety = 640, 950
local targetscale = 1
local scale = 1
local animspeed = 0.5
local worlddistance = 750

--stuff to handle moving the timer
local dragging_offset_x, dragging_offset_y = 0, 0
local is_dragging = false

function dragHandler()
    local mouse_x, mouse_y = input.GetMousePos();

    if (is_dragging == true) then
        posx = mouse_x - dragging_offset_x
        posy = mouse_y - dragging_offset_y
        return;
    end

    if (mouse_x >= posx and mouse_x <= posx + 639 * targetscale and mouse_y >= posy and mouse_y <= posy + 109 * targetscale) then
        is_dragging = true
        dragging_offset_x = mouse_x - posx
        dragging_offset_y = mouse_y - posy
        return;
    end
end

--figure out bomb site by getting middle point of the site the bomb is at and checking which bombsite it is closest to
local function sitename(site)
	local lerp = (site:GetMaxs() - site:GetMins()) * 0.5 + site:GetMins()
	local distance_a = (lerp - (entities.GetPlayerResources():GetProp("m_bombsiteCenterA"))):Length()
	local distance_b = (lerp - (entities.GetPlayerResources():GetProp("m_bombsiteCenterB"))):Length()

		return distance_b > distance_a and "A" or "B"
end

local lastpos = nil
local display = false
local planting = false
local defusing = false

--things for handling animation
local anim = {
	mode = "doneout",
	complete = 1,
	starttime = 0,
	lastpos = {x = 0, y = 0, s = 1}
}

--bomb props and stuff
local bomb = {
	ent = nil,
	explodetime = nil,
	planttime = nil,
	plantstart = nil,
	nexttick = nil,
	planter = nil,
	site = nil,
	timer = nil,
	origin = nil,
	defuse = nil,
	defusestart = nil
}

--reset the bomb when it is no longer needed
local function resetbomb()
	bomb.ent = nil
	bomb.explodetime = nil
	bomb.planttime = nil
	bomb.plantstart = nil
	bomb.nexttick = nil
	bomb.planter = nil
	bomb.site = nil
	bomb.timer = nil
	bomb.origin = nil
	bomb.defuse = nil
	bomb.defusestart = nil
	display = false
	planting = false
	defusing = false
end

--calculate bomb damage
function BombDamage(Player, playerOrigin)
	if Player:GetClass() ~= "CCSPlayer" then return 0 end
	local C4Distance = (bomb.origin - playerOrigin):Length()
	local Gauss = (C4Distance - 75.68) / 789.2 
	local flDamage = 450.7 * math.exp(-Gauss * Gauss)
	local Armor = Player:GetProp("m_ArmorValue")
		if Armor == nil then
			return 0
		end
		if Armor > 0 then
			local flArmorRatio = 0.5
			local flArmorBonus = 0.5
			local flNew = flDamage * flArmorRatio
			local flArmor = (flDamage - flNew) * flArmorBonus
			
			if flArmor > Armor then
				flArmor = Armor * (1 / flArmorBonus)
				flNew = flDamage - flArmor
			end
			
		flDamage = flNew
		end 
		
	return math.max(flDamage, 0)
end

--fuck this function, it's staying ugly
--but really it's here to render text that can scale instead of changing font size because that's ugly
local function drawtext(x,y,h,str)
	local i = 0
	local offset = 0
	for c in string.gmatch(str, ".") do
		if c ~= "." then
			draw.SetTexture(numbericons[tonumber(c)])
			draw.Color(0,0,0,255)
			draw.FilledRect(x + (i * h)+1*scale-(i*3*scale)-offset, y+1*scale, x + (i*h) + h+1*scale-(i*3*scale)-offset, y + h+1*scale)
			draw.Color(255,255,255,255)
			draw.FilledRect(x + (i * h)-(i*3*scale)-offset, y, x + (i*h) + h-(i*3*scale)-offset, y + h)
		else
			local dotpos = 0
			if i == 1 then
				dotpos = 1*scale
			else
				dotpos = -1*scale
			end
			draw.Color(0,0,0,255)
			draw.FilledCircle(x + (i * h)+dotpos, y+1*scale+(h-1*scale), 1.2*scale)
			draw.Color(255,255,255,255)
			draw.FilledCircle(x + (i * h)+dotpos-1*scale, y+(h-1*scale), 1.2*scale)
			offset = h-(7*scale)
		end
		i = i + 1
	end
	draw.SetTexture(nil)
end

--functions that need to be called on events
local events = {
	bomb_beginplant = function(e)
		display = true
		planting = true

		bomb.plantstart = globals.CurTime()
		bomb.planter = client.GetPlayerNameByUserID(e:GetInt("userid")) 
		bomb.site = sitename(entities.GetByIndex(e:GetInt("site")))
	end,
	bomb_abortplant = function()
		resetbomb()
	end,
	bomb_planted = function()
		planting = false
		bomb.planttime = globals.CurTime()
		bomb.nexttick = globals.CurTime() + 1
	end,
	bomb_begindefuse = function()
		defusing = true
	end,
	bomb_abortdefuse = function()
		defusing = false
		bomb.defuse = nil
		bomb.defusestart = nil
	end,
	round_officially_ended = function()
		resetbomb()
	end,
	bomb_defused = function()
		resetbomb()
	end,
	bomb_exploded = function()
		resetbomb()
	end
}

function EventHook(e)
	if events[e:GetName()] ~= nil then
		events[e:GetName()](e)
	end
end

client.AllowListener( "bomb_beginplant" );
client.AllowListener( "bomb_abortplant" );
client.AllowListener( "bomb_begindefuse" );
client.AllowListener( "bomb_abortdefuse" ); 
client.AllowListener( "bomb_defused" );
client.AllowListener( "bomb_exploded" );
client.AllowListener( "round_officially_ended" );
client.AllowListener( "bomb_planted" );

callbacks.Register("FireGameEvent", EventHook);

local function timer()

	--apply settings
	targetscale = scaleslider:GetValue()
	animspeed = animspeedslider:GetValue()
	worlddistance = distanceslider:GetValue()

	if movecheckbox:GetValue() then
		if menuref:IsActive() then
			--handle moving the timer when checkbox is enabled
			local left_mouse_down = input.IsButtonDown(1)
			if (is_dragging == true and left_mouse_down == false) then
				is_dragging = false
				dragging_offset_x = 0
				dragging_offset_y = 0
			end
			if (left_mouse_down) then
				dragHandler()
			end

			--display timer to help moving it
			local sw, sh = draw.GetScreenSize()

			local alpha = sineinout(globals.CurTime(), 0, 1, 0.5)

			draw.Color(255,50,50,25)
			draw.RoundedRectFill(posx - 1, posy - 1, posx + 640 * targetscale, posy + 110 * targetscale, 10 * targetscale)
			draw.Color(255,50,50,255)
			draw.RoundedRect(posx - 1, posy - 1, posx + 640 * targetscale, posy + 110 * targetscale, 10 * targetscale)
			draw.Line(posx + (639 * targetscale)*0.5, posy, posx + (639 * targetscale)*0.5, posy + 109 * targetscale)
			draw.Line(posx, posy + (109 * targetscale)*0.5, posx + 639 * targetscale, posy + (109 * targetscale)*0.5)
			draw.Line(sw*0.5, 0, sw*0.5, sh*0.05)
			draw.Line(sw*0.5, sh - sh*0.05, sw*0.5, sh)
			draw.Line(0, sh*0.5, sw*0.05 , sh*0.5)
			draw.Line(sw - sw*0.05, sh*0.5, sw , sh*0.5)
			draw.Line(sw*0.5-sw*0.02, sh*0.5, sw*0.5+sw*0.02,sh*0.5)
			draw.Line(sw*0.5, sh*0.5-sh*0.02, sw*0.5, sh*0.5+sh*0.02)
			draw.Color(10,10,10,50*alpha)
			draw.FilledCircle(posx + 55 * targetscale, posy + 55 * targetscale, 53 * targetscale)
			draw.Color(10,10,10,30*alpha)
			draw.FilledRect(posx + 107 * targetscale, posy + 55 * targetscale, posx + (107 + 365)* targetscale, posy + 62 * targetscale)
			draw.FilledRect(posx + 107 * targetscale, posy + 36 * targetscale, posx + (107 + 529) * targetscale, posy + 53 * targetscale)
			draw.Color(255,255,255,255*alpha)
			draw.SetTexture(bombicontexture)
			draw.FilledRect(posx + 19 * targetscale, posy + 22 * targetscale, posx + (19 + 80 * 0.9) * targetscale, posy + (22 + 74 * 0.9) * targetscale)
			draw.SetTexture(outlinetexture)
			draw.Color(50,50,50,200*alpha)
			draw.FilledRect(posx, posy, posx + 639 * targetscale, posy + 109 * targetscale)
			draw.SetTexture(nil)
		else
			movecheckbox:SetValue(false)
		end
	end

	if display then
		--find bomb entity if it's planted and we don't have it yet
		if bomb.ent == nil and bomb.planttime ~= nil then
			bomb.ent = entities.FindByClass("CPlantedC4")[1]
			if bomb.ent ~= nil then
				bomb.explodetime = bomb.ent:GetPropFloat("m_flC4Blow")
				bomb.timer = bomb.ent:GetPropFloat("m_flTimerLength")
				bomb.origin = bomb.ent:GetAbsOrigin()
			end
		end

		local fadein = 1
		local player = entities.GetLocalPlayer()
		local dead = false

		--reset bomb if we're not in a game
		if player == nil then
			resetbomb()
			return
		end

		--if local player is dead get the player we're spectating for displaying the timer and calculating damage
		if not player:IsAlive() then
			local spec = player:GetPropEntity("m_hObserverTarget")
			if spec ~= nil then
				player = spec
			else
				dead = true
			end
		end
		local playerOrigin = player:GetAbsOrigin()
		if playerOrigin == nil then
			playerOrigin = lastpos
		else
			lastpos = playerOrigin
		end

		if bomb.origin ~= nil then
			local sw, sh = draw.GetScreenSize()
			local bx, by = client.WorldToScreen(bomb.origin)
			--check if the bomb is on screen and close enough to display timer above bomb
			if (bomb.origin - playerOrigin):Length() < worlddistance and bx ~= nil and by ~= nil and bx > - 50 and by > 30 and bx < sw + 50 and by < sh + 75 then

				local viewangles = engine.GetViewAngles()
				viewangles.y = viewangles.y - 90
				viewangles:Normalize()
				
				--get 2 points above the bomb that always face the camera
				local pos1 = Vector3(bomb.origin.x + 50 * math.cos(math.rad(viewangles.y)),
									 bomb.origin.y + 50 * math.sin(math.rad(viewangles.y)),
									 bomb.origin.z + (25 * (targetscale + 1) * 0.5))

				local pos2 = Vector3(bomb.origin.x, 
									 bomb.origin.y, 
									 bomb.origin.z + (25 * (targetscale + 1) * 0.5))
				
				local p1x, p1y = client.WorldToScreen(pos1)
				local p2x, p2y = client.WorldToScreen(pos2)

				--calculate scaling and cap it
				local scaling = ((p1x - p2x) * targetscale) / (639 / 2)
				if scaling > targetscale then scaling = targetscale end
				if scaling < 0.1 * targetscale then scaling = 0.1 * targetscale end
				local targetx, targety = p2x - (639 * scaling) / 2, p2y

				--Check if we should animate the timer between above the bomb and on screen
				if anim.mode ~= "donein" then 
					if anim.mode ~= "in" then
						anim.starttime = globals.CurTime()
						anim.lastpos.x = offsetx
						anim.lastpos.y = offsety
						anim.lastpos.s = scale
						anim.speedmult = anim.complete
					end
					anim.mode = "in"
					if (globals.CurTime() - anim.starttime) / (animspeed * anim.speedmult) >= 1 then
						anim.mode = "donein"
						scale = scaling
						offsetx, offsety = targetx, targety
						anim.complete = 1
					else
						--if it's moving between the two, get position and scale at current time
						local x = sineout(globals.CurTime() - anim.starttime, anim.lastpos.x, targetx - anim.lastpos.x, animspeed * anim.speedmult)
						local y = sineout(globals.CurTime() - anim.starttime, anim.lastpos.y, targety - anim.lastpos.y, animspeed * anim.speedmult)
						local s = sineout(globals.CurTime() - anim.starttime, anim.lastpos.s, scaling - anim.lastpos.s, animspeed * anim.speedmult)
						scale = s
						offsetx, offsety = x, y
						anim.complete = (globals.CurTime() - anim.starttime) / (animspeed * anim.speedmult)
					end
				else
					scale = scaling
					offsetx, offsety = targetx, targety
				end
			else
				--same as above but in reverse
				if anim.mode ~= "doneout" then 
					if anim.mode ~= "out" then
						anim.starttime = globals.CurTime()
						anim.lastpos.x = offsetx
						anim.lastpos.y = offsety
						anim.lastpos.s = scale
						anim.speedmult = anim.complete
					end
					anim.mode = "out"
					if (globals.CurTime() - anim.starttime) / (animspeed * anim.speedmult) >= 1 then
						anim.mode = "doneout"
						scale = targetscale
						offsetx, offsety = posx, posy
						anim.complete = 1
					else
						local x = sineout(globals.CurTime() - anim.starttime, anim.lastpos.x, posx - anim.lastpos.x, animspeed * anim.speedmult)
						local y = sineout(globals.CurTime() - anim.starttime, anim.lastpos.y, posy - anim.lastpos.y, animspeed * anim.speedmult)
						local s = sineout(globals.CurTime() - anim.starttime, anim.lastpos.s, targetscale - anim.lastpos.s, animspeed * anim.speedmult)
						scale = s
						offsetx, offsety = x, y
						anim.complete = (globals.CurTime() - anim.starttime) / (animspeed * anim.speedmult)
					end

				else
					offsetx, offsety = posx, posy
					scale = targetscale
				end
			end
		else
			offsetx, offsety = posx, posy
			scale = targetscale
		end

		--calculate plant time and display timer when planting
		if planting then
			local planttime = globals.CurTime() - bomb.plantstart
			local PlantMath = planttime / 3.125
			planttime = 3.125 - planttime
			planttime = tostring(string.format("%.2f", planttime))
			if PlantMath <= 0.075 then
				fadein = PlantMath / 0.075
			end
			draw.Color(10,10,10,50 * fadein)
			draw.FilledCircle(offsetx + 55 * scale, offsety + 55 * scale, 53 * scale)
			draw.Color(10,10,10,30 * fadein)
			draw.FilledRect(offsetx + 107 * scale, offsety + 55 * scale, offsetx + (107 + 365)* scale, offsety + 62 * scale)
			draw.FilledRect(offsetx + 107 * scale, offsety + 36 * scale, offsetx + (107 + 529) * scale, offsety + 53 * scale)
			draw.Color(90,225,90,225 * fadein)
			draw.FilledRect(offsetx + 107 * scale, offsety + 36 * scale, offsetx + (107 + (529 * PlantMath)) * scale, offsety + 53 * scale)
			draw.Color(255,255,255,255 * fadein)
			local planttimeformat = 107 + (529 * PlantMath)
			local planttimeformatadd = tonumber(planttime) > 10 and 4*14-7 or 3*14-4
			if planttimeformat + planttimeformatadd > 634 then planttimeformat = 634 - planttimeformatadd end
			drawtext(offsetx + planttimeformat * scale, offsety + 37 * scale, 14 * scale, planttime)
			if bomb.site == "A" then
				draw.Color(0,0,0,100 * fadein)
				draw.FilledCircle(offsetx + 126 * scale, offsety + 86 * scale, 16 * scale)
				draw.Color(255,255,255,255 * fadein)
				draw.SetTexture(bombsiteatexture)
				draw.FilledRect(offsetx + 110 * scale, offsety + 70 * scale, offsetx + (110 + 32) * scale, offsety + (70 + 32) * scale)
			elseif bomb.site == "B" then
				draw.Color(0,0,0,100 * fadein)
				draw.FilledCircle(offsetx + 126 * scale, offsety + 86 * scale, 16 * scale)
				draw.Color(255,255,255,255 * fadein)
				draw.SetTexture(bombsitebtexture)
				draw.FilledRect(offsetx + 110 * scale, offsety + 70 * scale, offsetx + (110 + 32) * scale, offsety + (70 + 32) * scale)
			end
			draw.Color(255,255,255,255 * fadein)
			draw.SetTexture(bombicontexture)
			draw.FilledRect(offsetx + 19 * scale, offsety + 22 * scale, offsetx + (19 + 80 * 0.9) * scale, offsety + (22 + 74 * 0.9) * scale)
		end

		if bomb.ent ~= nil then
			--calculate bomb ticks
			if globals.CurTime() > bomb.nexttick then
				local fComplete = (( bomb.explodetime - globals.CurTime() ) / bomb.timer )
				if fComplete > 1 then fComplete = 1 elseif fComplete < 0 then fComplete = 0 end
				local freq = math.max(0.1 + 0.9 * fComplete, 0.15)
				bomb.nexttick = globals.CurTime() + freq
				bomb.lasttick = globals.CurTime()
			end

			draw.Color(10,10,10,50)
			draw.FilledCircle(offsetx + 55 * scale, offsety + 55 * scale, 53 * scale)
			
			--draw glow on timer and C4 icon at the same time as the bomb ticks
			if bomb.explodetime - globals.CurTime() < 1 then
				draw.SetTexture(circleglowtexture)
				draw.Color(90,225,90,225)
				draw.FilledRect(offsetx - 22 * scale, offsety - 22 * scale, offsetx + (153 - 22)*scale, offsety + (153 - 22)*scale)
				draw.SetTexture(bombiconglowtexture)
				draw.FilledRect(offsetx + 27 * scale, offsety + 21 * scale, offsetx + (27 + 80 * 0.9)*scale, offsety + (21 + 74 * 0.9)*scale)
			elseif bomb.lasttick ~= nil then
				if bomb.lasttick + 0.125 >= globals.CurTime() then
					draw.SetTexture(circleglowtexture)
					draw.Color(255,25,25,255)
					draw.FilledRect(offsetx - 22 * scale, offsety - 22 * scale, offsetx + (153 - 22) * scale, offsety + (153 - 22) * scale)
					draw.SetTexture(bombiconglowtexture)
					draw.FilledRect(offsetx + 27 * scale, offsety + 21 * scale, offsetx + (27 + 80 * 0.9) * scale, offsety + (21 + 74 * 0.9) * scale)
				else
					draw.SetTexture(bombicontexture)
					draw.Color(255,255,255,255)
					draw.FilledRect(offsetx + 19 * scale, offsety + 22 * scale, offsetx + (19 + 80 * 0.9) * scale, offsety + (22 + 74 * 0.9) * scale)
				end
			else
				draw.SetTexture(bombicontexture)
				draw.Color(255,255,255,255)
				draw.FilledRect(offsetx + 19 * scale, offsety + 22 * scale, offsetx + (19 + 80 * 0.9) * scale, offsety + (22 + 74 * 0.9) * scale)
			end

			draw.SetTexture(nil)

			--calculate and display remaining time
			local bombtime = bomb.explodetime - globals.CurTime()
			if bombtime <= 0 then 
				bombtime = 0
				defusing = false
				bomb.defuse = nil
				bomb.defusestart = nil
			end
			local BombMath = bombtime / bomb.timer
			bombtime = tostring(string.format("%.2f", bombtime))
			draw.Color(10,10,10,30)
			draw.FilledRect(offsetx + 107 * scale, offsety + 36 * scale, offsetx + (107 + 529) * scale, offsety + 53 * scale)
			draw.Color(90,225,90,225)
			draw.FilledRect(offsetx + 107 * scale, offsety + 36 * scale, offsetx + (107 + (529 * BombMath)) * scale, offsety + 53 * scale)

			--if defuing calculate and display defuse timer
			if defusing then
				if bomb.defuse == nil then
					local countdown = bomb.ent:GetProp("m_flDefuseCountDown")
					if countdown ~= 0 then
						bomb.defuse = countdown
						bomb.defusestart = globals.CurTime()
					end
				end
				local defusetime = bomb.defuse - globals.CurTime()
				if defusetime < 0 then defusetime = 0 end
				local DefuseMath = defusetime / (bomb.defuse - bomb.defusestart)
				defusetime = tostring(string.format("%.2f", defusetime))
				draw.Color(120,120,255,225)
				local idk = ((bomb.defuse - bomb.defusestart) / bomb.timer)
				draw.FilledRect(offsetx + 107 * scale, offsety + 36 * scale, offsetx + (107 + ((529 * idk) * DefuseMath)) * scale, offsety + 53 * scale)
				if tonumber(bombtime) < tonumber(defusetime) then
					draw.Color(255,25,25,255)
				else
					draw.Color(255,255,255,255)
				end
				local defusetimeformat = 107 + (529 * idk) * DefuseMath
				drawtext(offsetx + defusetimeformat * scale, offsety + 37 * scale, 14 * scale, defusetime)
			else
				if tonumber(bombtime) > 0 then
					draw.Color(255,255,255,255)
					local bombtimeformat = 107 + (529 * BombMath)
					local bombtimeformatadd = tonumber(bombtime) > 10 and 4*14-7 or 3*14-4
					if bombtimeformat + bombtimeformatadd > 634 then bombtimeformat = 634 - bombtimeformatadd end
					drawtext(offsetx + bombtimeformat * scale, offsety + 37 * scale, 14 * scale, bombtime)
				end
			end
			
			--calculate and display damage the bomb will do
			local health = player:GetHealth()
			health = health == nil and health or 100
			local damage = BombDamage(player, playerOrigin)
			local damagelength = health == 0 and 0 or damage/health
			if damagelength > 1 then damagelength = 1 end
			draw.Color(10,10,10,30)
			draw.FilledRect(offsetx + 107 * scale, offsety + 55 * scale, offsetx + (107 + 365)* scale, offsety + 62 * scale)
			draw.Color(255,25 + 200*(1 - damagelength),25,225)
			if damagelength == 1 and math.floor((globals.CurTime()*5) % 2) == 0 then
				draw.Color(255,215,215,225)
			end

			--animate the damage bar filling up when the bomb is planted so it doesn't just appear
			if globals.CurTime() - bomb.planttime <= 0.5 then
				damagelength = damagelength * sineout(globals.CurTime() - bomb.planttime, 0, 1, 0.5)
			end
			draw.FilledRect(offsetx + 107 * scale, offsety + 55 * scale, offsetx + (107 + (365 * damagelength))* scale, offsety + 62 * scale)

			--display bombsite if the timer is on screen and not in-world
			if anim.mode ~= "donein" then
				local fade = anim.mode == "in" and (1 - anim.complete) or anim.complete
				if bomb.site == "A" then
					draw.Color(0,0,0,100*fade)
					draw.FilledCircle(offsetx + 126 * scale, offsety + 86 * scale, 16 * scale)
					draw.Color(255,255,255,255*fade)
					draw.SetTexture(bombsiteatexture)
					draw.FilledRect(offsetx + 110 * scale, offsety + 70 * scale, offsetx + (110 + 32) * scale, offsety + (70 + 32) * scale)
				elseif bomb.site == "B" then
					draw.Color(0,0,0,100*fade)
					draw.FilledCircle(offsetx + 126 * scale, offsety + 86 * scale, 16 * scale)
					draw.Color(255,255,255,255*fade)
					draw.SetTexture(bombsitebtexture)
					draw.FilledRect(offsetx + 110 * scale, offsety + 70 * scale, offsetx + (110 + 32) * scale, offsety + (70 + 32) * scale)
				end
			end
		end

		--draw the rest of the timer
		draw.SetTexture(outlinetexture)
		draw.Color(50,50,50,200 * fadein)
		draw.FilledRect(offsetx, offsety, offsetx + 639 * scale, offsety + 109 * scale)
		draw.SetTexture(nil)
	end
end

callbacks.Register("Draw", timer)