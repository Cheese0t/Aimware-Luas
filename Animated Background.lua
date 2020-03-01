--Background by Cheeseot--
local dots = {}
local menuref = gui.Reference("MENU")
local settingsref = gui.Reference("SETTINGS")
local oldx, oldy = menuref:GetValue()
local movex, movey = 0,0
local bgtab = gui.Tab(settingsref, "bgtab", "Background")
local boxthing = gui.Groupbox(bgtab, "Background by Cheeseot", 16, 16)
local dotbox = gui.Checkbox(boxthing, "dotbox", "Dots", 1)
local linebox = gui.Checkbox(boxthing, "linebox", "Lines", 1)
local bgbox = gui.Checkbox(boxthing, "bgbox", "Background Fade", 1)
local dotsizeslider = gui.Slider( boxthing, "sizeslider", "Size", 2, 0, 5 )
local dotsize = 2
local dotamountslider = gui.Slider( boxthing, "amountslider", "Amount", 250, 0, 500 )
local amount = 250
local dotspeedslider = gui.Slider( boxthing, "speedslider", "Max. Speed", 50, 0, 500 )
local speed, oldspeed = 5, 5
local minspeedslider = gui.Slider( boxthing, "minspeedslider", "Min. Speed", 10, 0, 500 )
local minspeed, oldminspeed = 1, 1
local dotcolor = gui.ColorPicker(dotbox, "dotcolor", "Background Dot Color", 255, 255, 255, 130 )
local linecolor = gui.ColorPicker(linebox, "linecolor", "Background Line Color", 255, 255, 255, 65)
local fadecolor = gui.ColorPicker(bgbox, "fadecolor", "Background Fade Color", 0, 0, 0, 125)
local w,h = 1920,1080
local menux, menuy, menusizex, menusizey, scale = 0, 0, 800, 600, 1
local solidmenu = gui.Checkbox(boxthing, "solidmenu", "Make Menu Solid", 1)
local constantspeed = gui.Checkbox(boxthing, "constantspeed", "Keep Speed Independent of FPS", 1)
local framerate = 0.0

local function getfps()
   local framerate = 0.9 * framerate + (1.0 - 0.9) * globals.AbsoluteFrameTime()
   return math.floor((1.0 / framerate) + 0.5)
end

local function screensize()

	w,h = draw.GetScreenSize()

end

callbacks.Register("Draw",screensize)

local function randompos()
	
	for _,dot in ipairs(dots) do
	
	::start::
	
	local posx = math.random(w)
	local posy = math.random(h)
	
		if solidmenu:GetValue() then
			if not (posx > menux and posx < menux + menusizex and posy > menuy and posy < menuy + menusizey) then
		
				dot[1] = posx
				dot[2] = posy
		
			else 
				goto start
			end
		else
		
			dot[1] = posx
			dot[2] = posy
			
		end
	end
end

local randombutton = gui.Button(boxthing, "Randomize Position", randompos)

local function distance(w1,h1,w2,h2)

	local dist = math.sqrt((w2 - w1)^2 + (h2 - h1)^2)
	return dist

end

--Background by Cheeseot--

local function inRect(x,y,x1,y1,x2,y2)

	if x >= x1 and x <= x2 then
	
		if y >= y1 and y <= y2 then
		
			return true	
			
		else
		
			return false		
		end	
		
	else
	
		return false	
	end
end

local function background()

if menuref:IsActive() then

dotsize = dotsizeslider:GetValue()
amount = math.floor(dotamountslider:GetValue())
dotamountslider:SetValue(amount)
speed = math.floor(dotspeedslider:GetValue())
dotspeedslider:SetValue(speed)
minspeed = math.floor(minspeedslider:GetValue())

	if speed < minspeed then

		minspeed = speed

	end
	
minspeedslider:SetValue(minspeed)

local liner,lineg,lineb,linea = linecolor:GetValue()

scale = gui.GetValue("adv.dpi")
menusizex = 800 * scale
menusizey = 600 * scale
menux,menuy = menuref:GetValue()

	if oldx ~= menux or oldy ~= menuy then
	
		movex = math.abs(menux - oldx)
		movey = math.abs(menuy - oldy)
		oldx, oldy = menux, menuy
		
	elseif oldx == menux and oldy == menuy then
	
		movex = 1
		movey = 1
		
	end

	while #dots < amount do
	
		local posx = math.random(w)
		local posy = math.random(h)
	
		if solidmenu:GetValue() then
	
			if not (posx > menux and posx < menux + menusizex and posy > menuy and posy < menuy + menusizey) then
			
				local velx,vely = 0,0
				local velxm,velym = 0.01,0.01
				local rand = math.random(1,4)
				
					if speed == 0 then 
					
					velx = 0
					vely = 0
					
					else
					
						if rand == 1 then
						
						velx = math.random(minspeed, speed * 10)/1000
						vely = math.random(minspeed, speed * 10)/1000
						
						elseif rand == 2 then
						
						velx = -1*(math.random(minspeed, speed * 10)/1000)
						vely = math.random(minspeed, speed * 10)/1000	
						
						elseif rand == 3 then
						
						velx = math.random(minspeed, speed * 10)/1000
						vely = -1*(math.random(minspeed, speed * 10)/1000)	
						
						elseif rand == 4 then
						
						velx = -1*(math.random(minspeed, speed * 10)/1000)
						vely = -1*(math.random(minspeed, speed * 10)/1000)
						
						end
					end
					
				local dot = {posx, posy, velx, vely, velxm, velym}
				
				table.insert(dots, dot)
			
			end
			
		else
		
			local velx,vely = 0,0
			local velxm,velym = 0.01,0.01
			local rand = math.random(1,4)
			
				if speed == 0 then 
				
				velx = 0
				vely = 0
				
				else
				
					if rand == 1 then
					
					velx = math.random(minspeed, speed * 10)/1000
					vely = math.random(minspeed, speed * 10)/1000
					
					elseif rand == 2 then
					
					velx = -1*(math.random(minspeed, speed * 10)/1000)
					vely = math.random(minspeed, speed * 10)/1000	
					
					elseif rand == 3 then
					
					velx = math.random(minspeed, speed * 10)/1000
					vely = -1*(math.random(minspeed, speed * 10)/1000)	
					
					elseif rand == 4 then
					
					velx = -1*(math.random(minspeed, speed * 10)/1000)
					vely = -1*(math.random(minspeed, speed * 10)/1000)
					
					end
				end
				
			local dot = {posx, posy, velx, vely, velxm, velym}
			
			table.insert(dots, dot)
			
		end
	end
	
	while #dots > amount do
	
		table.remove(dots, 1)
		
	end
	
	if oldspeed ~= speed or oldminspeed ~= minspeed then
	
		for _,dot in ipairs(dots) do
		
			if dot[3] < 0 then
			
				dot[3] = -1*(math.random(minspeed, speed * 10)/1000)
				
			elseif dot[3] > 0 then
			
				dot[3] = (math.random(minspeed, speed * 10)/1000)
				
			else
			
				local randx = math.random(2)
				
				if randx == 1 then 
					
					dot[3] = (math.random(minspeed, speed * 10)/1000)
				
				else 
				
					dot[3] = -1*(math.random(minspeed, speed * 10)/1000)
					
				end
			end
			
			if dot[4] < 0 then
			
				dot[4] = -1*(math.random(minspeed, speed * 10)/1000)
				
			elseif dot[4] > 0 then
			
				dot[4] = (math.random(minspeed, speed * 10)/1000)
				
			else
			
				local randy = math.random(1,2)
				
				if randy == 1 then 
					
					dot[4] = (math.random(minspeed, speed * 10)/1000)
				
				else 
				
					dot[4] = -1*(math.random(minspeed, speed * 10)/1000)
					
				end
			end
		end
	
		oldspeed = speed
		oldminspeed = minspeed
	
	end
	
	if bgbox:GetValue() then
		draw.Color(fadecolor:GetValue())
		draw.FilledRect(0,0,w,h)
	end
	
--Background by Cheeseot--

	if dotbox:GetValue() or linebox:GetValue() then
		local mousex, mousey = input.GetMousePos()
		
			for _,dot in ipairs(dots) do
			
				if dot[5] > 0.01 then
					dot[5] = dot[5] * 0.99
				else
					dot[5] = 0.01
				end
					
				if dot[6] > 0.01 then
					dot[6] = dot[6] * 0.99 	
				else
					dot[6] = 0.01 
				end
				
				if dot[1] >= w or dot[1] <= 0 then
					dot[3] = dot[3] * -1
					dot[5] = dot[5] * 0.9
					dot[6] = dot[6] * 0.9 
				end
				
				if dot[2] >= h or dot[2] <= 0 then 
					dot[4] = dot[4] * -1
					dot[5] = dot[5] * 0.9
					dot[6] = dot[6] * 0.9 
				end
				
				if dot[1] > w then
					dot[1] = w 
				end
				
				if dot[1] < 0 then
					dot[1] = 0
				end
				
				if dot[2] > h then
					dot[2] = h 
				end
				
				if dot[2] < 0 then
					dot[2] = 0
				end
				
				if solidmenu:GetValue() then
				
					if inRect(dot[1], dot[2], menux - 5, menuy - 4, menux + 20, menuy + menusizey + 4) then
					
						dot[3] = dot[3] * -1 
						dot[5] = dot[5] * 0.9
						dot[6] = dot[6] * 0.9 
					
					end
					
					if inRect(dot[1], dot[2], menux + menusizex - 20, menuy - 4, menux + menusizex + 5, menuy + menusizey + 4) then
					
						dot[3] = dot[3] * -1
						dot[5] = dot[5] * 0.9
						dot[6] = dot[6] * 0.9
					
					end
					
					if inRect(dot[1], dot[2], menux - 4, menuy - 5, menux + menusizex + 4, menuy + 20) then
					
						dot[4] = dot[4] * -1
						dot[5] = dot[5] * 0.9
						dot[6] = dot[6] * 0.9 
					
					end
					
					if inRect(dot[1], dot[2], menux - 4, menuy + menusizey - 20, menux + menusizex + 4, menuy + menusizey + 5) then
					
						dot[4] = dot[4] * -1
						dot[5] = dot[5] * 0.9
						dot[6] = dot[6] * 0.9 
					
					end
					
					if inRect(dot[1], dot[2], menux - 5, menuy - 5, menux + menusizex + 5, menuy + menusizey + 5) then
					
						if dot[1] - (menux - 5) < (menux + menusizex + 5) - dot[1] and
						dot[1] - (menux - 5) < dot[2] - (menuy - 5) and 
						dot[1] - (menux - 5) < (menuy + menusizey + 5) - dot[2] then
							
							dot[1] = dot[1] - movex
						
							if dot[5] < movex / 10 then 
								dot[5] = movex / 10 
							end
						
							if dot[6] < movey / 10 then 
								dot[6] = movey / 10
							end	
						end
						
						if (menux + menusizex + 5) - dot[1] < dot[1] - (menux - 5) and 
						(menux + menusizex + 5) - dot[1] < dot[2] - (menuy - 5) and 
						(menux + menusizex + 5) - dot[1] < (menuy + menusizey + 5) - dot[2] then
							
							dot[1] = dot[1]+movex
						
							if dot[5] < movex / 10 then
								dot[5] = movex / 10
							end
						
							if dot[6] < movey / 10 then
								dot[6] = movey / 10
							end
						end
						
						if dot[2] - (menuy - 5) < dot[1] - (menux - 5) and 
						dot[2] - (menuy - 5) < (menux + menusizex + 5) - dot[1] and
						dot[2] - (menuy - 5) < (menuy + menusizey + 5) - dot[2] then
						
							dot[2] = dot[2]-movey
						
							if dot[6] < movey / 10 then 
								dot[6] = movey / 10 
							end
						
							if dot[5] < movex / 10 then 
								dot[5] = movex / 10 
							end
						end
						
						if (menuy + menusizey + 5) - dot[2] < dot[1] - (menux - 5) and 
						(menuy + menusizey + 5) - dot[2] < (menux + menusizex + 5) - dot[1] and
						(menuy + menusizey + 5) - dot[2] < dot[2] - (menuy - 5)then
						
							dot[2] = dot[2]+movey
						
							if dot[6] < movey / 10 then 
								dot[6] = movey / 10
							end 
						
							if dot[5] < movex / 10 then 
								dot[5] = movex / 10
							end
						end
					end
				end
				
	--Background by Cheeseot--
				
				if constantspeed:GetValue() then
				
				local fpsadjust = 600 / getfps()
				
					if dot[3] > 0 then
					
						dot[1] = dot[1] + (dot[3] + dot[5]) * fpsadjust
					
					elseif dot[3] < 0 then
					
						dot[1] = dot[1] + (dot[3] - dot[5]) * fpsadjust
						
					end
					
					if dot[4] > 0 then
					
						dot[2] = dot[2] + (dot[4] + dot[6]) * fpsadjust
						
					elseif dot[4] < 0 then
					
						dot[2] = dot[2] + (dot[4] - dot[6]) * fpsadjust
					
					end
				else
				
				if dot[3] > 0 then
					
						dot[1] = dot[1] + (dot[3] + dot[5])
					
					elseif dot[3] < 0 then
					
						dot[1] = dot[1] + (dot[3] - dot[5])
						
					end
					
					if dot[4] > 0 then
					
						dot[2] = dot[2] + (dot[4] + dot[6])
						
					elseif dot[4] < 0 then
					
						dot[2] = dot[2] + (dot[4] - dot[6])
						
					end
				
				end
				
				if math.abs(dot[1] - mousex) <= 150 and math.abs(dot[2] - mousey) <=150 then
				
					local mousedist = distance(dot[1],dot[2],mousex,mousey)
				
					if mousedist < 150 then
					
						local fade = (255-(mousedist/1.5)*2.55)*((linea/255)*2)
						
							if fade > 255 then 
								fade = 255 
							end
						
							if linebox:GetValue() then
								draw.Color(liner,lineg,lineb,fade)
								draw.Line(dot[1],dot[2],mousex,mousey)
							end
						
						--if mousedist < 25 then
							--dot[5] = math.random(3,5)
							--dot[6] = math.random(3,5)
						--end	
					end
				end
				
				if linebox:GetValue() then
					for __,compare in ipairs(dots) do
					
						if dot[1] ~= compare[1] and dot[2] ~= compare[2] then
						
							if math.abs(dot[1] - compare[1]) <= 150 and math.abs(dot[2] - compare[2]) <= 150 then
							
								local dist = distance(dot[1],dot[2],compare[1],compare[2])
								
									if dist < 150 then
									
										local fade = (255-(dist/1.5)*2.55)*(linea/255)
										
										draw.Color(liner,lineg,lineb,fade)
										draw.Line(dot[1],dot[2],compare[1],compare[2])
								end
							end
						end
					end
				end
				
				if dotbox:GetValue() then
					draw.Color(dotcolor:GetValue())
					draw.FilledCircle(dot[1],dot[2],dotsize)
				end
				
			end
		end
	end
end
	
callbacks.Register("Draw",background)

--Background by Cheeseot--