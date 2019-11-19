--LegitAA Settings by Cheeseot---
local ref = gui.Reference("LEGIT", "Extra")
local aabox = gui.Groupbox(ref, "Legit Anti-Aim Settings")
local set = gui.Combobox(aabox, set, "Setting:", "Real", "Fake")
local leftbutton = gui.Keybox(aabox, leftbutton, "Set Left", 0)
local rightbutton = gui.Keybox(aabox, rightbutton, "Set Right", 0)
local offbutton = gui.Keybox(aabox, offbutton, "No Fake", 0)
local indicators = gui.Checkbox(aabox, indicators, "Indicators", 0)
local distance = gui.Slider(aabox, distance, "Indicator Gap", 70, 15, 250)
local rounddist = 0
local scaleslider = gui.Slider(aabox, scaleslider, "Indicator Scale", 1, 0.5, 5)
local iclr = gui.ColorEntry( iclr, "LegitAA Indicator Inactive", 0, 0, 0, 100 )
local aclr = gui.ColorEntry( aclr, "LegitAA Indicator Active", 200, 25, 25, 200 )

local function idk()

rounddist = math.floor(distance:GetValue())
distance:SetValue(rounddist)

local left = leftbutton:GetValue()
local right = rightbutton:GetValue()
local off = offbutton:GetValue()

	if set:GetValue() == 0 then
		if left ~= 0 then
			if input.IsButtonPressed(left) then
				gui.SetValue("lbot_antiaim", 3)
			end
		end

		if right ~= 0 then
			if input.IsButtonPressed(right) then
				gui.SetValue("lbot_antiaim", 2)
			end
		end

		if off ~= 0 then
			if input.IsButtonPressed(off) then
				gui.SetValue("lbot_antiaim", 0)
			end
		end
	elseif set:GetValue() == 1 then
		if left ~= 0 then
			if input.IsButtonPressed(left) then
				gui.SetValue("lbot_antiaim", 2)
			end
		end

		if right ~= 0 then
			if input.IsButtonPressed(right) then
				gui.SetValue("lbot_antiaim", 3)
			end
		end

		if off ~= 0 then
			if input.IsButtonPressed(off) then
				gui.SetValue("lbot_antiaim", 0)
			end
		end
	end

	--LegitAA Settings by Cheeseot---

	if indicators:GetValue() then
	local w,h = draw.GetScreenSize()
	local scale = scaleslider:GetValue()
	
		if set:GetValue() == 0 then
			if gui.GetValue("lbot_antiaim") == 0 then
				draw.Color(iclr:GetValue())
				draw.Triangle(w/2 - rounddist - (15 * scale), h/2, w/2 - rounddist, h/2 - (10 * scale), w/2 - rounddist, h/2 + (10 * scale))
				draw.Triangle(w/2 + rounddist + (15 * scale), h/2, w/2 + rounddist, h/2 + (10 * scale), w/2 + rounddist, h/2 - (10 * scale))
			elseif gui.GetValue("lbot_antiaim") == 3 then
				draw.Color(aclr:GetValue())
				draw.Triangle(w/2 - rounddist - (15 * scale), h/2, w/2 - rounddist, h/2 - (10 * scale), w/2 - rounddist, h/2 + (10 * scale))
				draw.Color(iclr:GetValue())
				draw.Triangle(w/2 + rounddist + (15 * scale), h/2, w/2 + rounddist, h/2 + (10 * scale), w/2 + rounddist, h/2 - (10 * scale))
			elseif gui.GetValue("lbot_antiaim") == 2 then
				draw.Color(iclr:GetValue())
				draw.Triangle(w/2 - rounddist - (15 * scale), h/2, w/2 - rounddist, h/2 - (10 * scale), w/2 - rounddist, h/2 + (10 * scale))
				draw.Color(aclr:GetValue())
				draw.Triangle(w/2 + rounddist + (15 * scale), h/2, w/2 + rounddist, h/2 + (10 * scale), w/2 + rounddist, h/2 - (10 * scale))
			end
		elseif set:GetValue() == 1 then
			if gui.GetValue("lbot_antiaim") == 0 then
				draw.Color(iclr:GetValue())
				draw.Triangle(w/2 - rounddist - (15 * scale), h/2, w/2 - rounddist, h/2 - (10 * scale), w/2 - rounddist, h/2 + (10 * scale))
				draw.Triangle(w/2 + rounddist + (15 * scale), h/2, w/2 + rounddist, h/2 + (10 * scale), w/2 + rounddist, h/2 - (10 * scale))
			elseif gui.GetValue("lbot_antiaim") == 2 then
				draw.Color(aclr:GetValue())
				draw.Triangle(w/2 - rounddist - (15 * scale), h/2, w/2 - rounddist, h/2 - (10 * scale), w/2 - rounddist, h/2 + (10 * scale))
				draw.Color(iclr:GetValue())
				draw.Triangle(w/2 + rounddist + (15 * scale), h/2, w/2 + rounddist, h/2 + (10 * scale), w/2 + rounddist, h/2 - (10 * scale))
			elseif gui.GetValue("lbot_antiaim") == 3 then
				draw.Color(iclr:GetValue())
				draw.Triangle(w/2 - rounddist - (15 * scale), h/2, w/2 - rounddist, h/2 - (10 * scale), w/2 - rounddist, h/2 + (10 * scale))
				draw.Color(aclr:GetValue())
				draw.Triangle(w/2 + rounddist + (15 * scale), h/2, w/2 + rounddist, h/2 + (10 * scale), w/2 + rounddist, h/2 - (10 * scale))
			end
		end
	end

end

callbacks.Register("Draw", idk)
--LegitAA Settings by Cheeseot---