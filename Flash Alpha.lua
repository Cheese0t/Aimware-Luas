local flashed = false
local updateflash = 0
local dur = 0
local prevdur = 0
local endtime = 0
local ref = gui.Reference("VISUALS", "Shared")
local alphaslider = gui.Slider(ref, alphaslider, "Max Flash Alpha", 255, 0, 255)
local flashtimer = gui.Checkbox(ref, flashtimer, "Flash Timer", 0)

local function event(e)
	if e:GetName() == "flashbang_detonate" then
		updateflash = 1
		local lp = entities.GetLocalPlayer()
		if lp ~= nil then
			lp:SetPropFloat(alphaslider:GetValue(), "m_flFlashMaxAlpha")
		end
	end
end

client.AllowListener( "flashbang_detonate" )
callbacks.Register("FireGameEvent", event)

--flash alpha and timer by Cheeseot

local function flash()
	local lp = entities.GetLocalPlayer()
	if lp ~= nil then
		if updateflash ~= 0 then
			dur = lp:GetPropFloat("m_flFlashDuration")
			if dur == 0 then 
				updateflash = updateflash + 1
				if updateflash >= 5 then
					updateflash = 0
				end
			end
			if dur ~= 0 and dur ~= prevdur then
				updateflash = 0
				endtime = globals.CurTime() + dur
				flashed = true
			end
		end
	end
	if flashed then
	local w,h = draw.GetScreenSize()
		if globals.CurTime() >= endtime then 
			flashed = false
			prevdur = 0
			return
		end
		if dur ~= 0 and prevdur ~= dur then
			prevdur = dur
		end
		if flashtimer:GetValue() then
			local percent = (endtime - globals.CurTime()) / dur
			draw.Color(0,0,0,50)
			draw.RoundedRectFill(w/2 - 40, h/2 + 30, w/2 + 40, h / 2 + 35)
			draw.Color(255,20,20,255)
			if (80 * percent) > 2 then
			draw.FilledRect(w/2 - 39, h/2 + 31, w/2 - 38, h / 2 + 34)
			end
			draw.FilledRect(w/2 - 38, h/2 + 30, w/2 - 40 + (80 * percent), h / 2 + 35)
			draw.Color(0,0,0,255)
			draw.RoundedRect(w/2 - 40, h/2 + 30, w/2 + 40, h / 2 + 35)
		end
	end
end

callbacks.Register("Draw", flash)