local posx, posy = 100, 100
local boardw, boardh = 16, 16
local bombcount = 40
local flagsleft = 40
local diff = 2
local difftext = "Medium"
local board = {}
local clearables = {}
local aColors = {
                {51, 151, 232},
                {34, 179, 46}, 
                {232, 51, 51}, 
                {129, 51, 232}, 
                {145, 19, 19}, 
                {42, 167, 176}, 
                {25, 25, 25},
                {100, 100, 100}
                }
local aFont = draw.CreateFont("Impact", 30)
local bFont = draw.CreateFont("Tahoma", 24)
local cFont = draw.CreateFont("Tahoma Bold", 28)
local icons = draw.CreateFont("Webdings", 30)
local dragging_offset_x, dragging_offset_x = 0, 0
local is_dragging = false
local startscreen = true
local failed = false
local failstep = 0
local won = false
local active = gui.Checkbox(gui.Reference("MISC", "General", "Extra"), "active", "Minesweeper", 1)

local function dragHandler()
  local mouse_x, mouse_y = input.GetMousePos();

  if (is_dragging == true) then
      posx = mouse_x - dragging_offset_x;
      posy = mouse_y - dragging_offset_y;
      return;
  end

  if (mouse_x >= posx and mouse_x <= (posx + boardw * 30) and mouse_y >= posy - 35 and mouse_y <= posy) then
      is_dragging = true;
      dragging_offset_x = mouse_x - posx;
      dragging_offset_y = mouse_y - posy;
      return;
  end
end

local function inRect(x1, y1, x2, y2, mx, my)
  if (mx > x1 and my > y1) and (mx < x2 and my < y2) then
    return true
  else
    return false
  end
end

local function makeboard()
  board = {}
  for x = 1, boardw, 1 do
    local row = {}
    for y = 1, boardh, 1 do
      local pos = {}
      pos.isBomb = false
      pos.aBombs = 0
      pos.hidden = true
      pos.flag = false
      pos.bNum = 0
      table.insert(row, pos)
    end
    table.insert(board, row)
  end
end

local function assignbombs()
  local i = 0
  while i < bombcount do
    ::retry::
    local x, y = math.random(1, boardw), math.random(1, boardh)
      if not board[x][y].isBomb then
        i = i + 1
        board[x][y].isBomb = true
        board[x][y].bNum = i
      else
        goto retry
      end
  end
end

local function calcadjacent()
  for x, row in ipairs(board) do
    for y, pos in ipairs(board[x]) do
      if not board[x][y].isBomb then
      local adj = 0
        if y - 1 > 0 then
          if x - 1 > 0 then
            if board[x - 1][y - 1].isBomb then adj = adj + 1 end
          end
          if board[x][y - 1].isBomb then adj = adj + 1 end
          if x + 1 <= boardw then
            if board[x + 1][y - 1].isBomb then adj = adj + 1 end
          end
        end
        if x - 1 > 0 then
          if board[x - 1][y].isBomb then adj = adj + 1 end
        end
        if x + 1 <= boardw then
          if board[x + 1][y].isBomb then adj = adj + 1 end
        end
        if y + 1 <= boardh then
          if x - 1 > 0 then
            if board[x - 1][y + 1].isBomb then adj = adj + 1 end
          end
          if board[x][y + 1].isBomb then adj = adj + 1 end
          if x + 1 <= boardw then
            if board[x + 1][y + 1].isBomb then adj = adj + 1 end
          end
        end
        board[x][y].aBombs = adj
      end
    end
  end
end

local function revealempty()
  if #clearables ~= 0 then
    for i, v in ipairs(clearables) do
      local x, y = v[1], v[2]
      if y - 1 > 0 then
        if x - 1 > 0 then
          if board[x - 1][y - 1].aBombs == 0 and board[x - 1][y - 1].hidden then table.insert(clearables, {x-1,y-1}) end
          board[x - 1][y - 1].hidden = false
          board[x - 1][y - 1].flag = false
        end
        if board[x][y - 1].aBombs == 0 and board[x][y - 1].hidden then table.insert(clearables, {x,y-1}) end
        board[x][y - 1].hidden = false
        board[x][y - 1].flag = false
        if x + 1 <= boardw then
          if board[x + 1][y - 1].aBombs == 0 and board[x + 1][y - 1].hidden then table.insert(clearables, {x+1,y-1}) end
          board[x + 1][y - 1].hidden = false
          board[x + 1][y - 1].flag = false
        end
      end
      if x - 1 > 0 then
        if board[x - 1][y].aBombs == 0 and board[x - 1][y].hidden then table.insert(clearables, {x-1,y}) end
        board[x - 1][y].hidden = false
        board[x - 1][y].flag = false
      end
      if x + 1 <= boardw then
        if board[x + 1][y].aBombs == 0 and board[x + 1][y].hidden then table.insert(clearables, {x+1,y}) end
        board[x + 1][y].hidden = false
        board[x + 1][y].flag = false
      end
      if y + 1 <= boardh then
        if x - 1 > 0 then
          if board[x - 1][y + 1].aBombs == 0 and board[x - 1][y + 1].hidden then table.insert(clearables, {x-1,y+1}) end
          board[x - 1][y + 1].hidden = false
          board[x - 1][y + 1].flag = false
        end
        if board[x][y + 1].aBombs == 0 and board[x][y + 1].hidden then table.insert(clearables, {x,y+1}) end
        board[x][y + 1].hidden = false
        board[x][y + 1].flag = false
        if x + 1 <= boardw then
          if board[x + 1][y + 1].aBombs == 0 and board[x + 1][y + 1].hidden then table.insert(clearables, {x+1,y+1}) end
          board[x + 1][y + 1].hidden = false
          board[x + 1][y + 1].flag = false
        end
      end
      table.remove(clearables, i)
    end
  end
end

callbacks.Register("Draw", revealempty)

local function drawboard()
  if active:GetValue() then
  local hiddencount = 0
  local mx, my = input.GetMousePos()
  local dt = globals.AbsoluteFrameTime()
  local boardmidx, boardmidy = (boardw * 30) / 2, (boardh * 30) / 2
  local left_mouse_down = input.IsButtonDown(1);
  if (is_dragging == true and left_mouse_down == false) then
    is_dragging = false;
    dragging_offset_x = 0;
    dragging_offset_y = 0;
  end
  if (left_mouse_down) then
    dragHandler();
  end
  draw.Color(100,100,100,100)
  draw.FilledRect(posx, posy - 35, posx + boardw * 30, posy)
  draw.Color(255,255,255,255)
  draw.SetFont(aFont)
  draw.TextShadow(posx + (boardw * 30) / 2 - draw.GetTextSize("Minesweeper") / 2, posy - 27, "Minesweeper")
  draw.SetFont(icons)
  if inRect(posx + (boardw * 30) - 30, posy - 28, posx + (boardw * 30) - 9, posy - 7, mx, my) then
    if input.IsButtonDown(1) then
      draw.Color(255,255,255)
    else
      draw.Color(255,255,255,175)
    end
    if input.IsButtonReleased(1) then
      active:SetValue(0)
    end
  else
    draw.Color(255,255,255,100)
  end
  draw.Text(posx + (boardw * 30) - 33, posy - 30 , "r")
  draw.SetFont(aFont)
  if not startscreen then
    draw.Color(0,0,0,150)
    draw.Triangle(posx + 5, posy - 35 + 17, posx + 20, posy - 29, posx + 20 , posy - 35 + 19)
    draw.Color(200,0,0,255)
    draw.Triangle(posx + 5, posy - 35 + 16, posx + 20, posy - 30, posx + 20 , posy - 35 + 18)
    draw.Color(0,0,0,255)
    draw.FilledRect(posx + 20, posy - 30, posx + 22 , posy - 5)
    draw.Color(255,255,255,255)
    draw.TextShadow(posx + 40 - draw.GetTextSize(flagsleft) / 2, posy - 27, flagsleft)
    for x, row in ipairs(board) do
      for y, pos in ipairs(board[x]) do
        local offset = math.fmod(y, 2) == 0 and x or x + 1
        if math.fmod(offset, 2) ~= 0 then
            draw.Color(200,200,200,255)
        else
            draw.Color(190,190,190,255)
        end
        draw.FilledRect(posx + ((x - 1) * 30),
                        posy + ((y - 1) * 30),
                        posx + ((x - 1) * 30) + 30,
                        posy + ((y - 1) * 30) + 30)
        if failed or won then
          failstep = failstep + dt / 10
          if failed then
            if board[x][y].isBomb then
              if failstep >= board[x][y].bNum then
                board[x][y].flag = false
                board[x][y].hidden = false
                draw.Color(255,0,0,125)
                draw.FilledRect(posx + ((x - 1) * 30),
                          posy + ((y - 1) * 30),
                          posx + ((x - 1) * 30) + 30,
                          posy + ((y - 1) * 30) + 30)
                if board[x][y].bNum == 0 then 
                  draw.Color(0,0,0,255)
                  draw.OutlinedRect(posx + ((x - 1) * 30),
                          posy + ((y - 1) * 30),
                          posx + ((x - 1) * 30) + 30,
                          posy + ((y - 1) * 30) + 30)
                  draw.Color(255,0,0,255)
                  draw.OutlinedRect(posx + ((x - 1) * 30) + 1,
                          posy + ((y - 1) * 30) + 1,
                          posx + ((x - 1) * 30) + 30 - 1,
                          posy + ((y - 1) * 30) + 30 - 1)
                  draw.OutlinedRect(posx + ((x - 1) * 30) + 2,
                          posy + ((y - 1) * 30) + 2,
                          posx + ((x - 1) * 30) + 30 - 2,
                          posy + ((y - 1) * 30) + 30 - 2)
                  draw.Color(0,0,0,255)
                  draw.OutlinedRect(posx + ((x - 1) * 30) + 3,
                          posy + ((y - 1) * 30) + 3,
                          posx + ((x - 1) * 30) + 30 - 3,
                          posy + ((y - 1) * 30) + 30 - 3)
                end
              end
            end
          end
        end
        if board[x][y].isBomb then 
          draw.Color(200,0,0,255) 
          draw.FilledCircle(posx + ((x - 1) * 30 + 15), posy + ((y - 1) * 30) + 15, 7)
          draw.Color(0,0,0,255) 
          draw.OutlinedCircle(posx + ((x - 1) * 30 + 15), posy + ((y - 1) * 30) + 15, 7)
        end
        if board[x][y].aBombs ~= 0 then
          draw.Color(aColors[board[x][y].aBombs][1], aColors[board[x][y].aBombs][2], aColors[board[x][y].aBombs][3], 255)
          draw.TextShadow(posx + ((x - 1) * 30) + 8, posy + ((y - 1) * 30 + 5), board[x][y].aBombs)
        end
        if board[x][y].hidden then
          hiddencount = hiddencount + 1
          if math.fmod(offset, 2) ~= 0 then
              draw.Color(50,50,50,255)
          else
              draw.Color(40,40,40,255)
          end
          draw.FilledRect(posx + ((x - 1) * 30),
                          posy + ((y - 1) * 30),
                          posx + ((x - 1) * 30) + 30,
                          posy + ((y - 1) * 30) + 30)
          if won and board[x][y].bNum < failstep and board[x][y].bNum ~= 0 then
            board[x][y].flag = false
            draw.Color(0,0,0,255)
                  draw.OutlinedRect(posx + ((x - 1) * 30),
                          posy + ((y - 1) * 30),
                          posx + ((x - 1) * 30) + 30,
                          posy + ((y - 1) * 30) + 30)
                  draw.Color(0,150,0,255)
                  draw.OutlinedRect(posx + ((x - 1) * 30) + 1,
                          posy + ((y - 1) * 30) + 1,
                          posx + ((x - 1) * 30) + 30 - 1,
                          posy + ((y - 1) * 30) + 30 - 1)
                  draw.OutlinedRect(posx + ((x - 1) * 30) + 2,
                          posy + ((y - 1) * 30) + 2,
                          posx + ((x - 1) * 30) + 30 - 2,
                          posy + ((y - 1) * 30) + 30 - 2)
                  draw.Color(0,0,0,255)
                  draw.OutlinedRect(posx + ((x - 1) * 30) + 3,
                          posy + ((y - 1) * 30) + 3,
                          posx + ((x - 1) * 30) + 30 - 3,
                          posy + ((y - 1) * 30) + 30 - 3)
                  draw.Color(0,150,0,255) 
                  draw.FilledCircle(posx + ((x - 1) * 30 + 15), posy + ((y - 1) * 30) + 15, 7)
                  draw.Color(0,0,0,255) 
                  draw.OutlinedCircle(posx + ((x - 1) * 30 + 15), posy + ((y - 1) * 30) + 15, 7)
          end
        end
        if board[x][y].flag then
          draw.Color(0,0,0,150)
          draw.Triangle(posx + ((x - 1) * 30) + 5, posy + ((y - 1) * 30) + 16, posx + ((x - 1) * 30) + 20, posy + ((y - 1) * 30) + 5, posx + ((x - 1) * 30) + 20 , posy + ((y - 1) * 30) + 18)
          draw.Color(200,0,0,255)
          draw.Triangle(posx + ((x - 1) * 30) + 5, posy + ((y - 1) * 30) + 15, posx + ((x - 1) * 30) + 20, posy + ((y - 1) * 30) + 4, posx + ((x - 1) * 30) + 20 , posy + ((y - 1) * 30) + 17)
          draw.Color(0,0,0,255)
          draw.FilledRect(posx + ((x - 1) * 30) + 20, posy + ((y - 1) * 30) + 4, posx + ((x - 1) * 30) + 22 , posy + ((y - 1) * 30) + 26)
        end
        if inRect(posx + ((x - 1) * 30),
                  posy + ((y - 1) * 30),
                  posx + ((x - 1) * 30) + 31,
                  posy + ((y - 1) * 30) + 31,
                  mx, my) and not failed and not won then
          draw.Color(10,10,10,255)
          draw.OutlinedRect(posx + ((x - 1) * 30),
                          posy + ((y - 1) * 30),
                          posx + ((x - 1) * 30) + 30,
                          posy + ((y - 1) * 30) + 30)
          if board[x][y].hidden then
            if input.IsButtonPressed(1) and not board[x][y].flag then 
              board[x][y].hidden = false
              if board[x][y].aBombs == 0 and not board[x][y].isBomb then
                table.insert(clearables, {x,y})
              end
              if board[x][y].isBomb then
                failed = true
                board[x][y].bNum = 0
              end
            elseif input.IsButtonPressed(2) then
              if not board[x][y].flag then
                if flagsleft > 0 then
                  board[x][y].flag = true
                  flagsleft = flagsleft - 1
                end
              else
                board[x][y].flag = false
                flagsleft = flagsleft + 1
              end
            end
          end
        end
      end
    end
    if hiddencount <= bombcount and not lost then won = true end
    if (failed or won) and failstep > bombcount + 15 then
      draw.Color(0,0,0,200)
      draw.FilledRect(posx + boardmidx - 100, posy + boardmidy - 85, posx + boardmidx + 100, posy + boardmidy + 85)
      draw.Color(255,255,255,100)
      draw.OutlinedRect(posx + boardmidx - 100, posy + boardmidy - 85, posx + boardmidx + 100, posy + boardmidy + 85)
      draw.Color(255,255,255,255)
      draw.SetFont(cFont)
      draw.Text(posx + boardmidx - draw.GetTextSize("Difficulty") / 2, posy + boardmidy - 70, "Difficulty")
      if inRect(posx + boardmidx - 75, posy + boardmidy - 35, posx + boardmidx + 75, posy + boardmidy, mx, my) then
        if input.IsButtonDown(1) then
          draw.Color(100,100,100,150)
        else
          draw.Color(50,50,50,150)
        end
        if input.IsButtonReleased(1) then
          diff = diff + 1
          if diff > 3 then diff = 1 end
          if diff == 1 then 
            difftext = "Easy"
          elseif diff == 2 then 
            difftext = "Medium" 
          else 
            difftext = "Hard" 
          end
        end
      else
        draw.Color(0,0,0,150)
      end
      draw.FilledRect(posx + boardmidx - 75, posy + boardmidy - 35, posx + boardmidx + 75, posy + boardmidy)
      draw.Color(255,255,255,255)
      draw.SetFont(bFont)
      draw.Text(posx + boardmidx - draw.GetTextSize(difftext) / 2, posy + boardmidy - 27, difftext)
      draw.Color(255,255,255,100)
      draw.OutlinedRect(posx + boardmidx - 75, posy + boardmidy - 35, posx + boardmidx + 75, posy + boardmidy)
      if inRect(posx + boardmidx - 90, posy + boardmidy + 20, posx + boardmidx + 90, posy + boardmidy + 75, mx, my) then
        if input.IsButtonDown(1) then
          draw.Color(100,100,100,150)
        else
          draw.Color(50,50,50,150)
        end
        if input.IsButtonReleased(1) then
          if diff == 1 then 
            boardw = 9
            boardh = 9
            bombcount = 10
            flagsleft = 10
          elseif diff == 2 then 
            boardw = 16
            boardh = 16
            bombcount = 30
            flagsleft = 30
          else 
            boardw = 30
            boardh = 16
            bombcount = 99
            flagsleft = 99
          end
          board = {}
          makeboard()
          assignbombs()
          calcadjacent()
          startscreen = false
          failed = false
          failstep = 0
          won = false
        end
      else
        draw.Color(0,0,0,150)
      end
      draw.FilledRect(posx + boardmidx - 90, posy + boardmidy + 20, posx + boardmidx + 90, posy + boardmidy + 75)
      draw.Color(255,255,255,255)
      draw.SetFont(cFont)
      draw.Text(posx + boardmidx - draw.GetTextSize("START GAME") / 2, posy + boardmidy + 37, "START GAME" )
      draw.Color(255,255,255,100)
      draw.OutlinedRect(posx + boardmidx - 90, posy + boardmidy + 20, posx + boardmidx + 90, posy + boardmidy + 75)
    end
  else
    local startx = 1
    while startx <= boardw do
      local starty = 1
      while starty <= boardh do
        local offset = math.fmod(starty, 2) == 0 and startx or startx + 1
      if math.fmod(offset, 2) ~= 0 then
        draw.Color(50,50,50,255)
      else
        draw.Color(40,40,40,255)
      end
        draw.FilledRect(posx + ((startx - 1) * 30),
                        posy + ((starty - 1) * 30),
                        posx + ((startx - 1) * 30) + 30,
                        posy + ((starty - 1) * 30) + 30)
        starty = starty + 1
      end
      startx = startx + 1
    end
    draw.Color(0,0,0,200)
    draw.FilledRect(posx + boardmidx - 100, posy + boardmidy - 85, posx + boardmidx + 100, posy + boardmidy + 85)
    draw.Color(255,255,255,100)
    draw.OutlinedRect(posx + boardmidx - 100, posy + boardmidy - 85, posx + boardmidx + 100, posy + boardmidy + 85)
    draw.Color(255,255,255,255)
    draw.SetFont(cFont)
    draw.Text(posx + boardmidx - draw.GetTextSize("Difficulty") / 2, posy + boardmidy - 70, "Difficulty")
    if inRect(posx + boardmidx - 75, posy + boardmidy - 35, posx + boardmidx + 75, posy + boardmidy, mx, my) then
      if input.IsButtonDown(1) then
        draw.Color(100,100,100,150)
      else
        draw.Color(50,50,50,150)
      end
      if input.IsButtonReleased(1) then
        diff = diff + 1
        if diff > 3 then diff = 1 end
        if diff == 1 then 
          difftext = "Easy"
        elseif diff == 2 then 
          difftext = "Medium" 
        else 
          difftext = "Hard" 
        end
      end
    else
      draw.Color(0,0,0,150)
    end
    draw.FilledRect(posx + boardmidx - 75, posy + boardmidy - 35, posx + boardmidx + 75, posy + boardmidy)
    draw.Color(255,255,255,255)
    draw.SetFont(bFont)
    draw.Text(posx + boardmidx - draw.GetTextSize(difftext) / 2, posy + boardmidy - 27, difftext)
    draw.Color(255,255,255,100)
    draw.OutlinedRect(posx + boardmidx - 75, posy + boardmidy - 35, posx + boardmidx + 75, posy + boardmidy)
    if inRect(posx + boardmidx - 90, posy + boardmidy + 20, posx + boardmidx + 90, posy + boardmidy + 75, mx, my) then
      if input.IsButtonDown(1) then
        draw.Color(100,100,100,150)
      else
        draw.Color(50,50,50,150)
      end
      if input.IsButtonReleased(1) then
        if diff == 1 then 
          boardw = 9
          boardh = 9
          bombcount = 10
          flagsleft = 10
        elseif diff == 2 then 
          boardw = 16
          boardh = 16
          bombcount = 30
          flagsleft = 30
        else 
          boardw = 30
          boardh = 16
          bombcount = 99
          flagsleft = 99
        end
        makeboard()
        assignbombs()
        calcadjacent()
        startscreen = false
      end
    else
      draw.Color(0,0,0,150)
    end
    draw.FilledRect(posx + boardmidx - 90, posy + boardmidy + 20, posx + boardmidx + 90, posy + boardmidy + 75)
    draw.Color(255,255,255,255)
    draw.SetFont(cFont)
    draw.Text(posx + boardmidx - draw.GetTextSize("START GAME") / 2, posy + boardmidy + 37, "START GAME" )
    draw.Color(255,255,255,100)
    draw.OutlinedRect(posx + boardmidx - 90, posy + boardmidy + 20, posx + boardmidx + 90, posy + boardmidy + 75)
  end
  end
end

callbacks.Register("Draw", drawboard)