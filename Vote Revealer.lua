-- Vote revealer by Cheeseot

local activeVotes = {};
local font = draw.CreateFont('Arial', 14, 14);
local votecolor = {};
local animend = 0;
local votername = ""
local votetype = 0
local votetarget = ""
local enemyvote = 0
local yescount = 0
local nocount = 0
local voteresult = 0
local displayed = 0
local scrnw, scrnh = 0

local timer = timer or {}
local timers = {}

local function screensize()
    scrnw, scrnh = draw.GetScreenSize()
end

callbacks.Register("Draw", screensize)

local function timerCreate(name, delay, times, func)

    table.insert(timers, {["name"] = name, ["delay"] = delay, ["times"] = times, ["func"] = func, ["lastTime"] = globals.RealTime()})

end

local function timerRemove(name)

    for k,v in pairs(timers or {}) do
    
        if (name == v["name"]) then table.remove(timers, k) end
    
    end

end

local function timerTick()

    for k,v in pairs(timers or {}) do
    
        if (v["times"] <= 0) then table.remove(timers, k) end
        
        if (v["lastTime"] + v["delay"] <= globals.RealTime()) then 
            timers[k]["lastTime"] = globals.RealTime()
            timers[k]["times"] = timers[k]["times"] - 1
            v["func"]() 
        end
    
    end

end

callbacks.Register( "Draw", "timerTick", timerTick);

local function startTimer()
timerCreate("sleep", 4, 1, function() animend = 1; enemyvote = 0; voteresult = 0; displayed = 0 end)
end

local function getVoteEnd(um)
if um:GetID() == 47 or um:GetID() == 48 then
	startTimer()
	yescount = 0
	nocount = 0
	enemyvote = 2
	
	if um:GetID() == 47 then
		voteresult = 1
	end
	if um:GetID() == 48 then
		voteresult = 2
	end
end

if um:GetID() == 46 then
local localPlayer = entities.GetLocalPlayer();
local team = um:GetInt(1)
local idx = um:GetInt(2)
votetype = um:GetInt(3)
votetarget = um:GetString(5)
if (string.len(votetarget) > 20) then
	votetarget = string.sub(votetarget, 0, 15) .. "..."
end
votername = client.GetPlayerNameByIndex(idx)
if (string.len(votername) > 20) then
	votername = string.sub(votername, 0, 15) .. "..."
end
if localPlayer:GetTeamNumber() ~= team and votetype ~= 1 then
enemyvote = 1
displayed = 1
end
end
end;

callbacks.Register("DispatchUserMessage", getVoteEnd)

-- Vote revealer by Cheeseot


local function add(time, ...)
    table.insert(activeVotes, {
        ["text"] = { ... },
        ["time"] = time,
        ["delay"] = globals.RealTime() + time,
        ["color"] = {votecolor, {10, 10, 10}},
        ["x_pad"] = -11,
        ["x_pad_b"] = -11,
    })
end

local function getMultiColorTextSize(lines)
    local fw = 0
    local fh = 0;
    for i = 1, #lines do
        draw.SetFont(font);
        local w, h = draw.GetTextSize(lines[i][4])
        fw = fw + w
        fh = h;
    end
    return fw, fh
end

local function drawMultiColorText(x, y, lines)
    local x_pad = 0
    for i = 1, #lines do
        local line = lines[i];
        local r, g, b, msg = line[1], line[2], line[3], line[4]
        draw.SetFont(font);
        draw.Color(r, g, b, 255);
        draw.Text(x + x_pad, y, msg);
        local w, _ = draw.GetTextSize(msg)
        x_pad = x_pad + w
    end
end

local function showVotes(count, color, text, layer)
    local y = scrnh / 2 - 15 + scrnh/10 - 8  + 9 + (36 * (count - 1));
    local w, h = getMultiColorTextSize(text)
    local mw = w < 50 and 50 or w
    if globals.RealTime() < layer.delay then
        if layer.x_pad < mw then layer.x_pad = layer.x_pad + (mw - layer.x_pad) * 0.05 end
        if layer.x_pad > mw then layer.x_pad = mw end
        if layer.x_pad > mw / 1.09 then
            if layer.x_pad_b < mw - 6 then
                layer.x_pad_b = layer.x_pad_b + ((mw - 6) - layer.x_pad_b) * 0.05
            end
        end
        if layer.x_pad_b > mw - 6 then
            layer.x_pad_b = mw - 6
        end
    elseif animend == 1 then
        if layer.x_pad_b > -11 then
            layer.x_pad_b = layer.x_pad_b - (((mw - 5) - layer.x_pad_b) * 0.05) + 0.01
        end
        if layer.x_pad_b < (mw - 11) and layer.x_pad >= 0 then
            layer.x_pad = layer.x_pad - (((mw + 1) - layer.x_pad) * 0.05) + 0.01
        end
        if layer.x_pad < 0 then
            table.remove(activeVotes, count)
        end
    end
    local c1 = color[1]
    local c2 = color[2]
    local a = 255;
    draw.Color(c1[1], c1[2], c1[3], a);
    draw.FilledRect(layer.x_pad - layer.x_pad, y, layer.x_pad + 28, (h + y) + 20);
    draw.Color(c2[1], c2[2], c2[3], a);
    draw.FilledRect(layer.x_pad_b - layer.x_pad, y, layer.x_pad_b + 22, (h + y) + 20);
    drawMultiColorText(layer.x_pad_b - mw + 18, y + 9, text)
end

-- Vote revealer by Cheeseot


local function voteCast(e)
    if (e:GetName() == "vote_cast") then
		timerRemove("sleep")
		animend = 0;
		local index = e:GetInt("entityid");
		local vote = e:GetInt("vote_option");
        local name = client.GetPlayerNameByIndex(index)
        if (string.len(name) > 20) then
            name = string.sub(name, 0, 15) .. "..."
        end
		
		local votearray = {};
		local namearray = {};
			if vote == 0 then
				votearray = { 150, 185, 1, "YES" }
				namearray = { 150, 185, 1, name }
				votecolor = { 150, 185, 1}
				yescount = yescount + 1
			elseif vote == 1 then
				votearray = { 185, 20, 1, "NO" }
				namearray = { 185, 20, 1, name }
				votecolor = { 185, 20, 1}
				nocount = nocount + 1
			else
				votearray = { 150, 150, 150, "??" }
				namearray = { 150, 150, 150, name }
				votecolor = { 150, 150, 150}
			end
			
            add(3,
                namearray,
                { 255, 255, 255, " voted: " },
                votearray,
				{ 255, 255, 255, "   " });
        end
    end;

callbacks.Register('FireGameEvent', voteCast)

local function makeVote()
    for index, votes in pairs(activeVotes) do
        showVotes(index, votes.color, votes.text, votes)
    end
end;

callbacks.Register('Draw', makeVote)

client.AllowListener("vote_cast")


local function drawVote()
local font2 = draw.CreateFont('Arial', 20, 20);
draw.SetFont(font2)
local votetypename = ""
	if enemyvote == 1 then
		if votetype == 0 then
			votetypename = "kick player: "
		elseif votetype == 6 then
			votetypename = "Surrender"
		elseif votetype == 13 then
			votetypename = "Call a timeout"
		else return
		end
            draw.Color(255,150,0,255)
            draw.FilledRect(0, scrnh/2 - 15, draw.GetTextSize(votername .. " wants to " .. votetypename .. votetarget) + 30, scrnh/2 - 15 + scrnh/10 - 8)
            draw.Color(10,10,10,255)
            draw.FilledRect(0, scrnh/2 - 15, draw.GetTextSize(votername .. " wants to " .. votetypename .. votetarget) + 20, scrnh/2 - 15 + scrnh/10 - 8)
            draw.Color(150,185,1,255)
            draw.Text(5 + (draw.GetTextSize(votername .. " wants to " .. votetypename .. votetarget) / 2) - 25 - (draw.GetTextSize("  Yes")), scrnh/2 + scrnh/20, yescount .. " Yes") 
            draw.Color(185,20,1,255)
            draw.Text(5 + (draw.GetTextSize(votername .. " wants to " .. votetypename .. votetarget) / 2) + 25 , scrnh/2 + scrnh/20, nocount .. " No") 
            draw.Color(255,150,0,255)
            draw.Text(5, scrnh/2 + scrnh/100, votername) 
            draw.Color(255,255,255,255)
            draw.Text(draw.GetTextSize(votername .. " ") + 5, scrnh/2 + scrnh/100, "wants to ")
            if votetype == 0 then draw.Color(255,255,255,255) else draw.Color(255,150,0,255) end
            draw.Text(draw.GetTextSize(votername .. " wants to ") + 5, scrnh/2 + scrnh/100, votetypename)
            draw.Color(255,150,0,255)
            draw.Text(draw.GetTextSize(votername .. " wants to " .. votetypename) + 5, scrnh/2 + scrnh/100, votetarget)
    elseif enemyvote == 2 and displayed == 1 then
        if voteresult == 1 then
            draw.Color(150,185,1,255)
            draw.FilledRect(0, scrnh/2 - 15, draw.GetTextSize("Vote Passed") + 110, scrnh/2 - 15 + scrnh/10 - 8)
            draw.Color(10,10,10,255)
            draw.FilledRect(0, scrnh/2 - 15, draw.GetTextSize("Vote Passed") + 100, scrnh/2 - 15 + scrnh/10 - 8)
            draw.Color(150,185,1,255)
            draw.Text(50, scrnh/2 + scrnh/36, "Vote Passed") 
        elseif voteresult == 2 then
            draw.Color(185,20,1,255)
            draw.FilledRect(0, scrnh/2 - 15, draw.GetTextSize("Vote Failed") + 110, scrnh/2 - 15 + scrnh/10 - 8)
            draw.Color(10,10,10,255)
            draw.FilledRect(0, scrnh/2 - 15, draw.GetTextSize("Vote Failed") + 100, scrnh/2 - 15 + scrnh/10 - 8)
            draw.Color(185,20,1,255)
            draw.Text(50, scrnh/2 + scrnh/36, "Vote Failed")  
		end
	end


end

callbacks.Register("Draw", drawVote)

local function reset()
if entities.GetLocalPlayer() == nil then
	enemyvote = 0;
	activeVotes = {};
	displayed = 0;
end
end
callbacks.Register("Draw", reset)

-- Vote revealer by Cheeseot