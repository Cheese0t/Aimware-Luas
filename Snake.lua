local board, highscores, body, head = {}, {}, {}, {}
local boardx, boardy = 100, 100
local boardw, boardh = 30,30
local dragging_offset_x, dragging_offset_x
local is_dragging = false
local foodmade, snakemade, gotfood, inserted = false, false, false, false
local length, direction = 0, 2
local up, right, down, left = 1, 2, 3, 4
local eyex, eyey, tl, tr, bl, br
local win, paused, lost, startscreen, drawsettings = false, false, false, true, false
local tick, tickrate, framerate = 0, 0, 0.0
local difficulty, speedadjust, score = 2, 0, 0
local font1 = draw.CreateFont("Impact", 25)
local font2 = draw.CreateFont("Arial", 15)
local font3 = draw.CreateFont("Arial", 20, 20)
local font4 = draw.CreateFont("Impact", 18)
local icons = draw.CreateFont("Webdings", 18, 18)
local icons2 = draw.CreateFont("Webdings", 32, 32)
local ref = gui.Reference("Misc", "GENERAL", "Main")
local shoulddraw = gui.Checkbox(ref, shoulddraw, "Snake", 1)
local tempdif, tempw, temph, dif = 2, 30, 30
local sounds = true

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

local function getfps()
   local framerate = 0.9 * framerate + (1.0 - 0.9) * globals.AbsoluteFrameTime()
   return math.floor((1.0 / framerate) + 0.5)
end

function dragHandler()
    local mouse_x, mouse_y = input.GetMousePos();

    if (is_dragging == true) then
        boardx = mouse_x - dragging_offset_x;
        boardy = mouse_y - dragging_offset_y;
        return;
    end

    if (mouse_x >= boardx - 1 and mouse_x <= (boardx + 9 + boardw * 11) + 1 and mouse_y >= boardy - 26 and mouse_y <= boardy) and 
		not (inRect(mouse_x, mouse_y, (boardx + 9 + boardw * 11) + 1 - 20, boardy - 26 + 5, (boardx + 9 + boardw * 11) + 1 - 5, boardy - 1 - 5) or 
			inRect(mouse_x, mouse_y,(boardx + 9 + boardw * 11) + 1 - 40, boardy - 26 + 5, (boardx + 9 + boardw * 11) + 1 - 25, boardy - 1 - 5) or 
			inRect(mouse_x, mouse_y,(boardx + 9 + boardw * 11) + 1 - 60, boardy - 26 + 5, (boardx + 9 + boardw * 11) + 1 - 45, boardy - 1 - 5)) then
        is_dragging = true;
        dragging_offset_x = mouse_x - boardx;
        dragging_offset_y = mouse_y - boardy;
        return;
    end
end

local function buildboard()

	for i = 1, boardw do
		local line = {}
		for ii = 1, boardh do
			local pos = {}
			local food = false
			local snake = false
			local head = false
			local tail = false
			pos.food = food
			pos.snake = snake
			pos.head = head
			pos.tail = tail
			table.insert(line, pos)
		end
		table.insert(board, line)
	end
end

buildboard()

local function readscores()

	local f = file.Open("LUA_Snake_Highscores.dat", "r")
	if f ~= nil then
		local scores = f:Read()
		f:Close()
		
		for score in string.gmatch(scores, "%S+") do
			table.insert(highscores,score)
		end
	elseif f == nil then
		local newfile = file.Open("LUA_Snake_Highscores.dat", "w")
		newfile:Close()
	end
	
	while #highscores < 5 do
		table.insert(highscores, 0)	
	end

end

readscores()

local function writescores()
	local newscores = ""
	
	for i,v in ipairs(highscores) do
		newscores = newscores .. v
		if i < 5 then
			newscores = newscores .. " "
		end
	end
	
	local f = file.Open("LUA_Snake_Highscores.dat", "w")
	f:Write(newscores)
	f:Close()
end

local function insertscore(newscore)
local s1, s2, s3, s4, s5
local changed = false


	for i,v in ipairs(highscores) do
		if i == 1 then
			s1 = tonumber(v)
		elseif i == 2 then
			s2 = tonumber(v)
		elseif i == 3 then
			s3 = tonumber(v)
		elseif i == 4 then
			s4 = tonumber(v)
		elseif i == 5 then
			s5 = tonumber(v)
		end
	end
	
	if newscore > s1 then
		s5 = s4
		s4 = s3
		s3 = s2
		s2 = s1
		s1 = newscore
		changed = true
	elseif newscore > s2 then
		s5 = s4
		s4 = s3
		s3 = s2
		s2 = newscore
		changed = true
	elseif newscore > s3 then
		s5 = s4
		s4 = s3
		s3 = newscore
		changed = true
	elseif newscore > s4 then
		s5 = s4
		s4 = newscore
		changed = true
	elseif newscore > s5 then
		s5 = newscore
		changed = true
	end
	
	if changed then
		highscores = {s1, s2, s3, s4, s5}
		writescores()
	end
	
end

local function snakemove()

	if not snakemade then
		body1 = {1, 1}
		body2 = {2, 1}
		body3 = {3, 1}
		head.x, head.y = 3, 1
		length = 3
		table.insert(body,body1)
		table.insert(body,body2)
		table.insert(body,body3)
		snakemade = true
	end

	if snakemade then	
		if not win and not paused and not lost and not startscreen then
			if direction ~= 0 then
			
				if direction == up then
					head.y = head.y - 1
				elseif direction == right then
					head.x = head.x + 1
				elseif direction == down then
					head.y = head.y + 1
				elseif direction == left then
					head.x = head.x - 1
				end
				
				if head.x < 1 then
					head.x = 1
					lost = true
					if sounds then
						client.Command("play buttons\\button11.wav", true)
					end
				end
				if head.x > boardw then 
					head.x = boardw
					lost = true
					if sounds then
						client.Command("play buttons\\button11.wav", true)
					end
				end
				if head.y < 1 then 
					head.y = 1 
					lost = true
					if sounds then
						client.Command("play buttons\\button11.wav", true)
					end
				end
				if head.y > boardh then 
					head.y = boardh 
					lost = true
					if sounds then
						client.Command("play buttons\\button11.wav", true)
					end
				end
				
				if board[head.x][head.y].snake == true then
					lost = true
					if sounds then
						client.Command("play buttons\\button11.wav", true)
					end
				end
				
				if not lost then
					if board[head.x][head.y].food == true then
							gotfood = true
							if sounds then
								client.Command("play buttons\\blip1.wav", true)
							end
							score = score + math.floor((((5 * speedadjust)) * (difficulty / 2))+0.5)
							length = length + 1
							
								if length == boardw * boardh then
									win = true
									if sounds then
										client.Command("play player\\vo\\sas\\niceshot12.wav", true)
									end
								end
								
							board[head.x][head.y].food = false
							foodmade = false
						end
						
					if not gotfood then
						board[body[1][1]][body[1][2]].head = false
						board[body[1][1]][body[1][2]].snake = false
						board[body[1][1]][body[1][2]].tail = false
						table.remove(body, 1)
					end
					
					gotfood = false
					
					local newpart = {head.x, head.y}
					table.insert(body, newpart)
				end
			end
		end
			
		for i, part in ipairs(body) do
			if i == 1 then
				board[part[1]][part[2]].head = false
				board[part[1]][part[2]].snake = true
				board[part[1]][part[2]].tail = true
			elseif i == length then
				board[part[1]][part[2]].head = true
				board[part[1]][part[2]].snake = true
				board[part[1]][part[2]].tail = false
			else
				board[part[1]][part[2]].head = false
				board[part[1]][part[2]].snake = true
				board[part[1]][part[2]].tail = false
			end
		end
	end
end

snakemove()

local function makefood()
::retry::
	if not win and not lost and not paused then
	local foodx = math.random(boardw)
	local foody = math.random(boardh)
		if not board[foodx][foody].snake then
			board[foodx][foody].food = true
			foodmade = true
		else
			goto retry
		end
	end
end

local function resetgame()
	board = {}
	buildboard()
	head = {}
	body = {}
	direction = 2
	length = 0
	tick = 0
	score = 0
	gotfood = false
	win = false
	lost = false
	paused = false
	foodmade = false
	snakemade = false
	startscreen = true
	inserted = false
	snakemove()
end

local function maingame()
	
	if not win and not paused and not lost and not startscreen then
		if input.IsButtonPressed(37) and direction ~= left and direction ~= right then
			direction = left
			tick = 0
			snakemove()
		elseif input.IsButtonPressed(38) and direction ~= up and direction ~= down then
			direction = up
			tick = 0
			snakemove()
		elseif input.IsButtonPressed(39) and direction ~= right and direction ~= left then
			direction = right
			tick = 0
			snakemove()
		elseif input.IsButtonPressed(40) and direction ~= down and direction ~= up then
			direction = down
			tick = 0
			snakemove()
		end
		
		local fpsadjust = 10000 / getfps()
		tick = tick + fpsadjust
	end
	
	if input.IsButtonPressed(8) and not paused and not win and not lost and not startscreen then
		paused = true
		if sounds then
			client.Command("play buttons\\lever7.wav", true)
		end
	end
	
	if input.IsButtonPressed(32) then
		if shoulddraw:GetValue() then
			if paused then
				paused = false
				if sounds then
					client.Command("play buttons\\lever7.wav", true)
				end
			elseif startscreen then
				startscreen = false
				if sounds then
					client.Command("play common\\warning.wav", true)
				end
			elseif lost or win then
				resetgame()
			end
		end
	end
	
	if not paused and not lost and not win and not startscreen then
		if not shoulddraw:GetValue() then
			paused = true
		end
	end
	
	if lost or win then
		if not inserted then
			inserted = true
			insertscore(score)
		end
	end
	
	speedadjust = math.floor(((length - 3) / 5) + 1)
	if speedadjust > 5 then speedadjust = 5 end
	
	if difficulty == 1 then
		tickrate = 400 - ((speedadjust - 1) * 35)
	elseif difficulty == 2 then
		tickrate = 300 - ((speedadjust - 1) * 35)
	elseif difficulty == 3 then
		tickrate = 220 - ((speedadjust - 1) * 30)
	else
		tickrate = 200
	end

	if tick >= tickrate then
		snakemove()
		tick = 0
	end

	if not foodmade then
		makefood()
	end
	
end

callbacks.Register("Draw", maingame)

local function drawboard()
	if shoulddraw:GetValue() then
	local left_mouse_down = input.IsButtonDown(1);

		if (is_dragging == true and left_mouse_down == false) then
			is_dragging = false;
			dragging_offset_x = 0;
			dragging_offset_y = 0;
		end

		if (left_mouse_down) then
			dragHandler();
		end
		
	local mousex, mousey = input.GetMousePos();

	draw.Color(200,50,50,150)
	draw.FilledRect(boardx - 1, boardy - 26, (boardx + 9 + boardw * 11) + 1,boardy - 1)
	draw.Color(255,255,255,255)
	draw.SetFont(font3)
	draw.TextShadow((boardx - 1) + (((boardx + 9 + boardw * 11) + 1) - (boardx - 1)) / 2 - draw.GetTextSize("Snake") / 2, boardy - 23, "Snake")
	draw.SetFont(Font2)
	draw.TextShadow(boardx + 4, boardy - 20, "Score: " .. score)
	draw.SetFont(icons)
	
	if inRect(mousex, mousey,(boardx + 9 + boardw * 11) + 1 - 20, boardy - 26 + 5, (boardx + 9 + boardw * 11) + 1 - 5, boardy - 1 - 5) then
		if left_mouse_down then
			draw.Color(200, 25, 25, 255)
		else
			draw.Color(200, 50, 50, 125)
		end
		draw.FilledRect((boardx + 9 + boardw * 11) + 1 - 20, boardy - 26 + 5, (boardx + 9 + boardw * 11) + 1 - 5, boardy - 1 - 5)
		if input.IsButtonReleased(1) then
			shoulddraw:SetValue(0)
			if sounds then
				client.Command("play buttons\\button22.wav", true)
			end
		end
	end
	
	draw.Color(0, 0, 0, 125)
	draw.OutlinedRect((boardx + 9 + boardw * 11) + 1 - 20, boardy - 26 + 5, (boardx + 9 + boardw * 11) + 1 - 5, boardy - 1 - 5)
	draw.Color(0, 0, 0, 255)
	draw.Text((boardx + 9 + boardw * 11) + 1 - 19, boardy - 26 + 3, "r")
	
	if drawsettings and not inRect(mousex, mousey,(boardx + 9 + boardw * 11) + 1 - 40, boardy - 26 + 5, (boardx + 9 + boardw * 11) + 1 - 25, boardy - 1 - 5)then
		draw.Color(150, 150, 150, 200)
		draw.FilledRect((boardx + 9 + boardw * 11) + 1 - 40, boardy - 26 + 5, (boardx + 9 + boardw * 11) + 1 - 25, boardy - 1 - 5)
	end
	
	if inRect(mousex, mousey,(boardx + 9 + boardw * 11) + 1 - 40, boardy - 26 + 5, (boardx + 9 + boardw * 11) + 1 - 25, boardy - 1 - 5) then
		if left_mouse_down then
			draw.Color(200, 25, 25, 255)
		else
			draw.Color(200, 50, 50, 125)
		end
		draw.FilledRect((boardx + 9 + boardw * 11) + 1 - 40, boardy - 26 + 5, (boardx + 9 + boardw * 11) + 1 - 25, boardy - 1 - 5)
		if input.IsButtonReleased(1) and not drawsettings then
			drawsettings = true
			if sounds then
				client.Command("play buttons\\button22.wav", true)
			end
		elseif input.IsButtonReleased(1) and drawsettings then
			drawsettings = false
			if sounds then
				client.Command("play buttons\\button22.wav", true)
			end
		end
	end
	
	draw.Color(0,0,0,125)
	draw.OutlinedRect((boardx + 9 + boardw * 11) + 1 - 40, boardy - 26 + 5, (boardx + 9 + boardw * 11) + 1 - 25, boardy - 1 - 5)
	draw.Color(0, 0, 0, 255)
	draw.Text((boardx + 9 + boardw * 11) + 1 - 39, boardy - 26 + 3, "@")
	
	if inRect(mousex, mousey,(boardx + 9 + boardw * 11) + 1 - 60, boardy - 26 + 5, (boardx + 9 + boardw * 11) + 1 - 45, boardy - 1 - 5) then
		if left_mouse_down then
			draw.Color(200, 25, 25, 255)
		else
			draw.Color(200, 50, 50, 125)
		end
		draw.FilledRect((boardx + 9 + boardw * 11) + 1 - 60, boardy - 26 + 5, (boardx + 9 + boardw * 11) + 1 - 45, boardy - 1 - 5)
		if input.IsButtonReleased(1) then
			if sounds then
				sounds = false
			elseif not sounds then
				sounds = true
				client.Command("play buttons\\button22.wav", true)
			end
		end
	end
	
	draw.Color(0, 0, 0, 125)
	draw.OutlinedRect((boardx + 9 + boardw * 11) + 1 - 60, boardy - 26 + 5, (boardx + 9 + boardw * 11) + 1 - 45, boardy - 1 - 5)
	draw.Color(0, 0, 0, 255)
	draw.Text((boardx + 9 + boardw * 11) + 1 - 56, boardy - 26 + 3, "X")
	if not sounds then
		draw.Text((boardx + 9 + boardw * 11) + 1 - 59, boardy - 26 + 3, "x")
	end
	
	draw.Color(20, 20, 20, 255)
	draw.FilledRect(boardx, boardy, boardx + 9 + boardw * 11, boardy + 9 + boardh * 11)
	draw.Color(255, 255, 255, 255)
	draw.OutlinedRect(boardx - 1, boardy - 1, (boardx + 9 + boardw * 11) + 1, (boardy + 9 + boardh * 11) + 1)
	
	draw.Color(20, 20, 20, 150)
	draw.FilledRect(boardx - 1, (boardy + 9 + boardh * 11) + 1,(boardx + 9 + boardw * 11) + 1, (boardy + 9 + boardh * 11) + 16)
	draw.SetFont(font2)
	draw.Color(255, 255, 255, 150)
	draw.TextShadow(boardx + 4, (boardy + 9 + boardh * 11) + 1, "Made by: Cheeseot")
	draw.Color(255, 255, 255, 255)
	draw.TextShadow((boardx + 9 + boardw * 11) + 1 - 5 - draw.GetTextSize("Level: " .. speedadjust), (boardy + 9 + boardh * 11) + 1, "Level: " .. speedadjust)
	
	if drawsettings then
		draw.Color(20, 20, 20, 255)
		draw.FilledRect(boardx + 10 + boardw * 11, boardy, boardx + 10 + boardw * 11 + 200, boardy + 215)
		draw.Color(255, 255, 255, 255)
		draw.OutlinedRect(boardx + 10 + boardw * 11 - 1, boardy - 1, boardx + 10 + boardw * 11 + 200 + 1, boardy + 215 + 1)
		draw.SetFont(font3)
		draw.Color(255, 255, 255, 255)
		local settingsmiddle = (boardx + 10 + boardw * 11 + 40) + ((boardx + 10 + boardw * 11 + 200 - 40) - (boardx + 10 + boardw * 11 + 40)) / 2
		draw.Text(settingsmiddle - draw.GetTextSize("Difficulty") / 2, boardy + 15, "Difficulty")
		
		if tempdif <= 1 then
			draw.Color(60, 60, 60, 255)
		elseif inRect(mousex, mousey, boardx + 10 + boardw * 11 + 15, boardy + 40, boardx + 10 + boardw * 11 + 40, boardy + 75) then
			if left_mouse_down then
				draw.Color(220, 25, 25, 255)
			else
				draw.Color(185, 25, 25, 255)
			end
			if input.IsButtonReleased(1) then
				tempdif = tempdif - 1
				if sounds then
					client.Command("play buttons\\button22.wav", true)
				end
			end
		else
			draw.Color(150, 15, 15, 255)
		end
		draw.FilledRect(boardx + 10 + boardw * 11 + 15, boardy + 40, boardx + 10 + boardw * 11 + 40, boardy + 75)
		if tempdif >= 3 then
			draw.Color(60, 60, 60, 255)
		elseif inRect(mousex, mousey, boardx + 10 + boardw * 11 + 200 - 40, boardy + 40, boardx + 10 + boardw * 11 + 200 - 15 , boardy + 75) then
			if left_mouse_down then
				draw.Color(220, 25, 25, 255)
			else
				draw.Color(185, 25, 25, 255)
			end
			if input.IsButtonReleased(1) then
				tempdif = tempdif + 1
				if sounds then
					client.Command("play buttons\\button22.wav", true)
				end
			end
		else
			draw.Color(150, 15, 15, 255)
		end
		draw.FilledRect(boardx + 10 + boardw * 11 + 200 - 40, boardy + 40, boardx + 10 + boardw * 11 + 200 - 15 , boardy + 75)
		
		draw.Color(75, 75, 75, 255)
		draw.FilledRect(boardx + 10 + boardw * 11 + 40, boardy + 40, boardx + 10 + boardw * 11 + 200 - 40, boardy + 75)
		
		if tempdif == 1 then
			dif = "Easy"
		elseif tempdif == 2 then
			dif = "Medium"
		elseif tempdif == 3 then
			dif = "Hard"
		end
		
		draw.SetFont(font1)
		draw.Color(255, 255, 255, 255) 
		draw.TextShadow(settingsmiddle - draw.GetTextSize(dif) / 2, boardy + 44, dif)
		draw.SetFont(icons2)
		draw.Color(25, 25, 25, 255)
		draw.TextShadow(boardx + 10 + boardw * 11 + 15, boardy + 41, "3")
		draw.TextShadow(boardx + 10 + boardw * 11 + 200 - 43, boardy + 41, "4")
		
		draw.SetFont(font3)
		draw.Color(255, 255, 255, 255)
		draw.Text((boardx + 10 + boardw * 11 + 15) + ((settingsmiddle - 7.5) - (boardx + 10 + boardw * 11 + 15)) / 2 - draw.GetTextSize("Width") / 2, boardy + 90, "Width")
		draw.Text((boardx + 10 + boardw * 11 + 200 - 40) + ((boardx + 10 + boardw * 11 + 200 - 15) - (boardx + 10 + boardw * 11 + 200 - 40)) / 2 - draw.GetTextSize("Height"), boardy + 90, "Height")
		if tempw <= 15 then
			draw.Color(60, 60, 60, 255)
		elseif inRect(mousex, mousey, boardx + 10 + boardw * 11 + 15, boardy + 115, boardx + 10 + boardw * 11 + 40, boardy + 150) then
			if left_mouse_down then
				draw.Color(220, 25, 25, 255)
			else
				draw.Color(185, 25, 25, 255)
			end
			if input.IsButtonReleased(1) then
				tempw = tempw - 1
				if sounds then
					client.Command("play buttons\\button22.wav", true)
				end
			end
		else
			draw.Color(150, 15, 15, 255)
		end
		draw.FilledRect(boardx + 10 + boardw * 11 + 15, boardy + 115, boardx + 10 + boardw * 11 + 40, boardy + 150)
		
		if tempw >= 75 then
			draw.Color(60, 60, 60, 255)
		elseif inRect(mousex, mousey, settingsmiddle - 7.5-25, boardy + 115, settingsmiddle - 7.5, boardy + 150) then
			if left_mouse_down then
				draw.Color(220, 25, 25, 255)
			else
				draw.Color(185, 25, 25, 255)
			end
			if input.IsButtonReleased(1) then
				tempw = tempw + 1
				if sounds then
					client.Command("play buttons\\button22.wav", true)
				end
			end
		else
			draw.Color(150, 15, 15, 255)
		end
		draw.FilledRect(settingsmiddle - 7.5-25, boardy + 115, settingsmiddle - 7.5, boardy + 150)
		draw.Color(75, 75, 75, 255)
		draw.FilledRect(boardx + 10 + boardw * 11 + 40, boardy + 115, settingsmiddle - 7.5-25, boardy + 150)
		draw.SetFont(font1)
		draw.Color(255, 255, 255, 255)
		draw.TextShadow((boardx + 10 + boardw * 11 + 40) + ((settingsmiddle - 7.5-25) - (boardx + 10 + boardw * 11 + 40)) / 2 - draw.GetTextSize(tempw) / 2, boardy + 119, tempw)
		draw.SetFont(icons2)
		draw.Color(25, 25, 25, 255)
		draw.TextShadow(boardx + 10 + boardw * 11 + 15, boardy + 116, "3")
		draw.TextShadow(settingsmiddle - 7.5-28, boardy + 116, "4")
		
		if temph >= 75 then
			draw.Color(60, 60, 60, 255)
		elseif inRect(mousex, mousey, boardx + 10 + boardw * 11 + 200 - 40, boardy + 115, boardx + 10 + boardw * 11 + 200 - 15 , boardy + 150) then
			if left_mouse_down then
				draw.Color(220, 25, 25, 255)
			else
				draw.Color(185, 25, 25, 255)
			end
			if input.IsButtonReleased(1) then
				temph = temph + 1
				if sounds then
					client.Command("play buttons\\button22.wav", true)
				end
			end
		else
			draw.Color(150, 15, 15, 255)
		end
		draw.FilledRect(boardx + 10 + boardw * 11 + 200 - 40, boardy + 115, boardx + 10 + boardw * 11 + 200 - 15 , boardy + 150)
		
		if temph <= 15 then
			draw.Color(60, 60, 60, 255)
		elseif inRect(mousex, mousey, settingsmiddle + 7.5, boardy + 115, settingsmiddle + 7.5+25, boardy + 150) then
			if left_mouse_down then
				draw.Color(220, 25, 25, 255)
			else
				draw.Color(185, 25, 25, 255)
			end
			if input.IsButtonReleased(1) then
				temph = temph - 1
				if sounds then
					client.Command("play buttons\\button22.wav", true)
				end
			end
		else
			draw.Color(150, 15, 15, 255)
		end
		draw.FilledRect(settingsmiddle + 7.5, boardy + 115, settingsmiddle + 7.5+25, boardy + 150)
		draw.Color(75, 75, 75, 255)
		draw.FilledRect(settingsmiddle + 7.5+25, boardy + 115, boardx + 10 + boardw * 11 + 200 - 40, boardy + 150)
		draw.SetFont(font1)
		draw.Color(255, 255, 255, 255)
		draw.TextShadow((settingsmiddle + 7.5+25) + ((boardx + 10 + boardw * 11 + 200 - 40) - (settingsmiddle + 7.5+25)) / 2 - draw.GetTextSize(temph) / 2, boardy + 119 , temph)
		draw.SetFont(icons2)
		draw.Color(25, 25, 25, 255)
		draw.TextShadow(settingsmiddle + 7.5, boardy + 116, "3")
		draw.TextShadow(boardx + 10 + boardw * 11 + 200 - 43, boardy + 116, "4")
		
		if tempdif == difficulty and tempw == boardw and temph == boardh then
			draw.Color(60, 60, 60, 255)
		elseif inRect(mousex, mousey, boardx + 10 + boardw * 11 + 30, boardy + 165, boardx + 10 + boardw * 11 + 200 - 30, boardy + 200) then
			if left_mouse_down then
				draw.Color(220, 25, 25, 255)
			else
				draw.Color(185, 25, 25, 255)
			end
			if input.IsButtonReleased(1) then
				difficulty = tempdif
				boardw = tempw
				boardh = temph
				resetgame()
				if sounds then
					client.Command("play buttons\\button22.wav", true)
				end
			end
		else
			draw.Color(150, 15, 15, 255)
		end
		draw.FilledRect(boardx + 10 + boardw * 11 + 30, boardy + 165, boardx + 10 + boardw * 11 + 200 - 30, boardy + 200)
		draw.Color(255, 255, 255, 255)
		draw.SetFont(font1)
		draw.TextShadow((boardx + 10 + boardw * 11 + 30) + ((boardx + 10 + boardw * 11 + 200 - 30) - (boardx + 10 + boardw * 11 + 30)) / 2 - draw.GetTextSize("Apply") / 2, boardy + 169, "Apply")
	end	
		
		for x, line in ipairs(board) do
			for y, pos in ipairs(line) do
			if pos.food then
				draw.Color(150, 50, 50, 255)
			elseif pos.head then
				draw.Color(50, 200, 50, 255)
				eyex = x
				eyey = y
			elseif pos.tail then
				draw.Color(50, 125, 50, 255)
			elseif pos.snake then
				draw.Color(50, 150, 50, 255)
			else
				draw.Color(50, 50, 50, 255)
			end
				draw.FilledRect(boardx + ((x - 1) + 5) + ((x - 1) * 10),
								boardy + ((y - 1) + 5) + ((y - 1) * 10),
								boardx + ((x - 1) + 5) + ((x - 1) * 10) + 10,
								boardy + ((y - 1) + 5) + ((y - 1) * 10) + 10)
			end
		end
			
		if snakemade and eyex ~= nil and eyey ~= nil then
			draw.Color(0, 0, 0, 255)
			if direction == 0 then
				tl = false
				tr = true
				br = true
				bl = false
			elseif direction == up then
				tl = true
				tr = true
				br = false
				bl = false
			elseif direction == right then
				tl = false
				tr = true
				br = true
				bl = false
			elseif direction == down then
				tl = false
				tr = false
				br = true
				bl = true
			elseif direction == left then
				tl = true
				tr = false
				br = false
				bl = true
			end
			
			if br then
				draw.FilledRect((boardx + ((eyex - 1) + 5) + ((eyex - 1) * 10)) + 6,
								(boardy + ((eyey - 1) + 5) + ((eyey - 1) * 10)) + 6,
								(boardx + ((eyex - 1) + 5) + ((eyex - 1) * 10) + 10) - 2,
								(boardy + ((eyey - 1) + 5) + ((eyey - 1) * 10) + 10) - 2)
			end
			if bl then
				draw.FilledRect((boardx + ((eyex - 1) + 5) + ((eyex - 1) * 10)) + 2,
								(boardy + ((eyey - 1) + 5) + ((eyey - 1) * 10)) + 6,
								(boardx + ((eyex - 1) + 5) + ((eyex - 1) * 10) + 10) - 6,
								(boardy + ((eyey - 1) + 5) + ((eyey - 1) * 10) + 10) - 2)
			end
			if tl then
				draw.FilledRect((boardx + ((eyex - 1) + 5) + ((eyex - 1) * 10)) + 2,
								(boardy + ((eyey - 1) + 5) + ((eyey - 1) * 10)) + 2,
								(boardx + ((eyex - 1) + 5) + ((eyex - 1) * 10) + 10) - 6,
								(boardy + ((eyey - 1) + 5) + ((eyey - 1) * 10) + 10) - 6)
			end
			if tr then
				draw.FilledRect((boardx + ((eyex - 1) + 5) + ((eyex - 1) * 10)) + 6,
								(boardy + ((eyey - 1) + 5) + ((eyey - 1) * 10)) + 2,
								(boardx + ((eyex - 1) + 5) + ((eyex - 1) * 10) + 10) - 2,
								(boardy + ((eyey - 1) + 5) + ((eyey - 1) * 10) + 10) - 6)
			end
		end
			
		if startscreen then
		draw.Color(20, 20, 20, 125)
			draw.FilledRect(boardx, boardy, boardx + 9 + boardw * 11, boardy + 9 + boardh * 11)
			draw.Color(255,255,255,255)
			draw.SetFont(font1)
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("Welcome") / 2), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 10), "Welcome")
			draw.SetFont(font2)
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("Use the ARROW KEYS to move") / 2), ((boardy + ((boardy + 9 + boardh * 11) - boardy) / 2) - 30), "Use the ARROW KEYS to move")
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("Press BACKSPACE to pause") / 2), ((boardy + ((boardy + 9 + boardh * 11) - boardy) / 2) -5), "Press BACKSPACE to pause")	
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("Use the buttons in the top right") / 2), ((boardy + ((boardy + 9 + boardh * 11) - boardy) / 2) + 20), "Use the buttons in the top right")	
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("to change game settings") / 2), ((boardy + ((boardy + 9 + boardh * 11) - boardy) / 2) + 35), "to change game settings")	
			draw.SetFont(font4)
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("Press SPACE to start") / 2), (boardy + ((boardy + 9 + boardh * 11) - boardy) - 35), "Press SPACE to start")
		end
		if paused then
			draw.Color(20, 20, 20, 125)
			draw.FilledRect(boardx, boardy, boardx + 9 + boardw * 11, boardy + 9 + boardh * 11)
			draw.Color(255,255,255,255)
			draw.SetFont(font1)
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("Game paused") / 2), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 10), "Game Paused")
			draw.SetFont(font4)
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("Press SPACE to continue") / 2), (boardy + ((boardy + 9 + boardh * 11) - boardy) - 35), "Press SPACE to continue")
		end
		if lost then 
			draw.Color(20, 20, 20, 125)
			draw.FilledRect(boardx, boardy, boardx + 9 + boardw * 11, boardy + 9 + boardh * 11)
			draw.Color(255,255,255,255)
			draw.SetFont(font1)
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("You Lost") / 2), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 10), "You Lost")
			draw.SetFont(font2)
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("Score: " .. score) / 2), ((boardy + ((boardy + 9 + boardh * 11) - boardy) / 10)) + 25, "Score: " .. score)
			draw.SetFont(font4)
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("High Scores") / 2), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 2 - 45), "High Scores")
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("High Scores") - 10), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 2 - 20), "1:")
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("High Scores") - 10), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 2 ), "2:")
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("High Scores") - 10), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 2 + 20), "3:")
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("High Scores") - 10), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 2 + 40), "4:")
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("High Scores") - 10), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 2 + 60), "5:")
			draw.SetFont(font2)
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize(highscores[1]) / 2), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 2 - 20), highscores[1])
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize(highscores[2]) / 2), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 2 ), highscores[2])
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize(highscores[3]) / 2), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 2 + 20), highscores[3])
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize(highscores[4]) / 2), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 2 + 40), highscores[4])
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize(highscores[5]) / 2), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 2 + 60), highscores[5])
			draw.SetFont(font4)
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("Press SPACE to try again") / 2), (boardy + ((boardy + 9 + boardh * 11) - boardy) - 35), "Press SPACE to try again")
		end
		if win then
			draw.Color(20, 20, 20, 125)
			draw.FilledRect(boardx, boardy, boardx + 9 + boardw * 11, boardy + 9 + boardh * 11)
			draw.Color(255,255,255,255)
			draw.SetFont(font1)
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("You Win!") / 2), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 10), "You Win!")
			draw.SetFont(font2)
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("Score: " .. score) / 2), ((boardy + ((boardy + 9 + boardh * 11) - boardy) / 10)) + 25, "Score: " .. score)
			draw.SetFont(font4)
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("High Scores") / 2), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 2 - 45), "High Scores")
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("High Scores") - 10), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 2 - 20), "1:")
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("High Scores") - 10), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 2 ), "2:")
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("High Scores") - 10), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 2 + 20), "3:")
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("High Scores") - 10), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 2 + 40), "4:")
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("High Scores") - 10), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 2 + 60), "5:")
			draw.SetFont(font2)
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize(highscores[1]) / 2), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 2 - 20), highscores[1])
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize(highscores[2]) / 2), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 2 ), highscores[2])
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize(highscores[3]) / 2), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 2 + 20), highscores[3])
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize(highscores[4]) / 2), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 2 + 40), highscores[4])
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize(highscores[5]) / 2), (boardy + ((boardy + 9 + boardh * 11) - boardy) / 2 + 60), highscores[5])
			draw.SetFont(font4)
			draw.Text((boardx + ((boardx + 9 + boardw * 11) - boardx) / 2) - (draw.GetTextSize("Press SPACE to restart") / 2), (boardy + ((boardy + 9 + boardh * 11) - boardy) - 35), "Press SPACE to restart")
		end
	end
end

callbacks.Register("Draw", drawboard)