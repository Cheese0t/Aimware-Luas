local configdelete = gui.Reference("Settings", "Configurations", "Manage Configurations", "Delete")
local configreset = gui.Reference("Settings", "Configurations", "Manage Configurations", "Reset")
local luadelete = gui.Reference("Settings", "Lua Scripts", "Manage Scripts", "Delete")
local menu = gui.Reference("Menu")

local configcheckbox = gui.Checkbox(gui.Reference("Settings", "Configurations", "Manage Configurations"), _, "", 0)
local configtext = gui.Text(gui.Reference("Settings", "Configurations", "Manage Configurations"), "Enable destructive actions")
local luacheckbox = gui.Checkbox(gui.Reference("Settings", "Lua Scripts", "Manage Scripts"), _, "", 0)
local luatext = gui.Text(gui.Reference("Settings", "Lua Scripts", "Manage Scripts"), "Enable destructive actions")

configcheckbox:SetPosX(568)
configcheckbox:SetPosY(-43)
configtext:SetPosX(427)
configtext:SetPosY(-38)
luacheckbox:SetPosX(568)
luacheckbox:SetPosY(-43)
luatext:SetPosX(427)
luatext:SetPosY(-38)


local menustate = false
local toggled = false

configdelete:SetDisabled(true)
configreset:SetDisabled(true)
luadelete:SetDisabled(true)

local function ondraw()
    if menu:IsActive() then
        if (configcheckbox:GetValue() or luacheckbox:GetValue()) and not toggled then
            configcheckbox:SetValue(true)
            luacheckbox:SetValue(true)
            configdelete:SetDisabled(false)
            configreset:SetDisabled(false)
            luadelete:SetDisabled(false)
            toggled = true
        end
        if (not configcheckbox:GetValue() or not luacheckbox:GetValue()) and toggled then
            configcheckbox:SetValue(false)
            luacheckbox:SetValue(false)
            configdelete:SetDisabled(true)
            configreset:SetDisabled(true)
            luadelete:SetDisabled(true)
            toggled = false
        end
    elseif toggled then
        configcheckbox:SetValue(false)
        luacheckbox:SetValue(false)
        configdelete:SetDisabled(true)
        configreset:SetDisabled(true)
        luadelete:SetDisabled(true)
        toggled = false
    end
end

callbacks.Register("Draw", ondraw)