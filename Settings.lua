local addonName, addon = ...

addon.Settings = addon.Settings or {}

local defaults = {
    showItemLevel   = true,
    showClassColors = true,
    showGuildRank   = true,
}

function addon.Settings:Initialize()
    if not iLevelPeekTBCDB then
        iLevelPeekTBCDB = {}
    end

    for key, value in pairs(defaults) do
        if iLevelPeekTBCDB[key] == nil then
            iLevelPeekTBCDB[key] = value
        end
    end

    addon.db = iLevelPeekTBCDB
    self:CreatePanel()
end

function addon.Settings:Get(key)
    if addon.db then
        return addon.db[key]
    end
    return defaults[key]
end

function addon.Settings:AddToggle(category, key, name, tooltip)
    local setting = Settings.RegisterAddOnSetting(
        category,
        addonName .. "_" .. key,
        key,
        addon.db,
        Settings.VarType.Boolean,
        name,
        defaults[key]
    )
    setting:SetValueChangedCallback(function(_, val)
        addon.db[key] = val
    end)
    Settings.CreateCheckbox(category, setting, tooltip)
end

function addon.Settings:CreatePanel()
    -- The modern Settings registry is present on TBC Classic 2.5.x; if a future
    -- build drops it, the slash command and tooltip features still work without a panel.
    if not (Settings and Settings.RegisterVerticalLayoutCategory) then
        return
    end

    local L = addon.L
    local category, layout = Settings.RegisterVerticalLayoutCategory("iLevelPeek TBC")

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L.SETTINGS_SECTION_DISPLAY))
    self:AddToggle(category, "showItemLevel", L.SETTINGS_SHOW_ILVL_NAME, L.SETTINGS_SHOW_ILVL_TIP)

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L.SETTINGS_SECTION_APPEARANCE))
    self:AddToggle(category, "showClassColors", L.SETTINGS_SHOW_COLORS_NAME, L.SETTINGS_SHOW_COLORS_TIP)
    self:AddToggle(category, "showGuildRank",   L.SETTINGS_SHOW_GUILD_NAME,  L.SETTINGS_SHOW_GUILD_TIP)

    Settings.RegisterAddOnCategory(category)
    self.categoryID = category:GetID()
end

SLASH_ILVLPEEK1 = "/ilevelpeek"
SLASH_ILVLPEEK2 = "/ilvlpeek"
SlashCmdList["ILVLPEEK"] = function(msg)
    msg = (msg or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
    if msg == "debug" then
        addon.debug = not addon.debug
        print("|cff7fcfff[iLvlPeek]|r debug =", addon.debug and "ON" or "OFF")
        return
    end
    if addon.Settings.categoryID then
        Settings.OpenToCategory(addon.Settings.categoryID)
    end
end
