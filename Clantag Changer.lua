local _SetTag = ffi.cast('int(__fastcall*)(const char*, const char*)', mem.FindPattern('engine.dll', '53 56 57 8B DA 8B F9 FF 15'))
local last = nil
local enable = gui.Checkbox(gui.Reference("misc","enhancement","appearance"), "customtagenable", "Enable custom clantag", 0)
local tagbox = gui.Editbox(gui.Reference("misc","enhancement","appearance"), "customtag", "Clantag")
local speedslider = gui.Slider(gui.Reference("misc","enhancement","appearance"), "customtagspeed", "Clantag speed", 3, 0, 10, 0.1)
local tag = " "
local lasttag = nil
local tagsteps = {}

local SetTag = function(v)
  if v ~= last then
    _SetTag(v, "")
    last = v
  end
end

local function makesteps()
  tagsteps = {" "}

  for i = 1, #tag do
    table.insert(tagsteps, tag:sub(1, i))
  end

  for i = #tagsteps - 1, 1, -1 do
    table.insert(tagsteps, tagsteps[i])
  end
end

local function monkey()
  if enable:GetValue() then
    gui.SetValue("misc.clantag", false)
    tag = tagbox:GetValue()
    if tag:match("gamesense") then tag = "retard" end
    if lasttag ~= tag then
      makesteps()
      lasttag = tag
    end
    if speedslider:GetValue() == 0 then
      SetTag(tag)
    else
      SetTag(tagsteps[math.floor(globals.TickCount()/((11-speedslider:GetValue())*3.5))%(#tagsteps-1)+1])
    end
  else
    SetTag("")
  end
end

callbacks.Register("Draw", monkey)

callbacks.Register("Unload", function()
  SetTag("")
end)