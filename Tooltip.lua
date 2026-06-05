local addonName, addon = ...
local L = addon.L

addon.Tooltip = addon.Tooltip or {}

local Tooltip = addon.Tooltip

local function setting(key)
    if addon.Settings and addon.Settings.Get then
        return addon.Settings:Get(key)
    end
    return true
end

local pendingGUID = nil
local pendingUnit = nil
local lastInspectTime = 0
local retryTimer = nil
local currentTooltipUnit = nil

local MOUSEOVER_INSPECT_THROTTLE = 1.5
local MOUSEOVER_CACHE_TTL = 300
local TOOLTIP_LINE_ADDED_KEY = addonName .. "_TooltipLineAdded"

-- Slots used to compute iLvl. Skip 4 (Shirt) and 19 (Tabard). Matches TacoTip's
-- GetScore loop (anzz1/TacoTip gearscore.lua): iterate 1-18, skip shirt, count
-- every filled slot exactly once. A 2H weapon is NEVER doubled for the iLvl
-- average -- TacoTip's TitanGrip/Hunter multipliers apply only to GearScore, not
-- to LevelTotal/ItemCount. Slot 16 (MainHand), 17 (OffHand) and 18 (Ranged) each
-- add their item level once. This is the formula CLAUDE.md commits us to.
local ILVL_SLOTS = {1, 2, 3, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18}

-- Hidden tooltip used to read the effective "Item Level" line, which includes
-- Valor upgrade bonuses that C_Item.GetDetailedItemLevelInfo ignores on MoP Classic.
local scanTip = CreateFrame("GameTooltip", addonName .. "ScanTip", nil, "GameTooltipTemplate")
scanTip:SetOwner(UIParent, "ANCHOR_NONE")
local ILVL_PATTERN = ITEM_LEVEL:gsub("%%d", "(%%d+)")

local function getSlotItemLevel(unit, slot)
    local link = GetInventoryItemLink(unit, slot)
    if not link then return nil end

    scanTip:ClearLines()
    -- Skip slots whose item data isn't cached yet: SetInventoryItem returns
    -- false, and reading on would risk picking up stale lines from the prior scan.
    if not scanTip:SetInventoryItem(unit, slot) then
        return nil
    end
    for i = 2, min(scanTip:NumLines(), 6) do
        local text = _G[addonName .. "ScanTipTextLeft" .. i]
        if text then
            local lvl = text:GetText() and text:GetText():match(ILVL_PATTERN)
            if lvl then return tonumber(lvl) end
        end
    end

    if C_Item and C_Item.GetDetailedItemLevelInfo then
        local lvl = C_Item.GetDetailedItemLevelInfo(link)
        if lvl and lvl > 0 then return lvl end
    end
    local _, _, _, itemLevel = GetItemInfo(link)
    if itemLevel and itemLevel > 0 then return itemLevel end
    return nil
end

-- TacoTip's worn-gear average (anzz1/TacoTip gearscore.lua GetScore): sum the
-- item level of every filled slot once, divide by the number of filled slots.
-- No slot is ever doubled. Items not yet cached return nil and are skipped;
-- if any equipped slot hasn't resolved we bail to nil (TacoTip's IsReady=false)
-- so a partial -- and inflated -- average is never shown. Re-hovering after a
-- moment picks the data up once the client has it.
local function computeInspectItemLevel(unit)
    local total, count = 0, 0
    for _, slot in ipairs(ILVL_SLOTS) do
        local lvl = getSlotItemLevel(unit, slot)
        if lvl then
            total = total + lvl
            count = count + 1
        end
    end

    if count == 0 then return nil end

    -- Bail if any equipped slot's data hasn't loaded yet. Every filled slot is
    -- counted exactly once, so resolved (count) must equal equipped slots; a
    -- shortfall means at least one item is still uncached and the average would
    -- be skewed. (TacoTip sets IsReady=false and returns nothing in this case.)
    local equipped = 0
    for _, slot in ipairs(ILVL_SLOTS) do
        if GetInventoryItemLink(unit, slot) then equipped = equipped + 1 end
    end

    if count < equipped then
        return nil
    end

    return total / count
end

local function safeEquals(a, b)
    local ok, result = pcall(rawequal, a, b)
    if ok then return result end
    ok, result = pcall(function() return a == b end)
    if ok then return result end
    return false
end

local function safeUnitGUID(unit)
    local ok, guid = pcall(UnitGUID, unit)
    if ok and guid then return guid end
    return nil
end

local function safeGetTooltipUnit(tooltip)
    local ok, _, unit = pcall(tooltip.GetUnit, tooltip)
    if not ok or not unit then return nil end
    local existsOk = pcall(UnitExists, unit)
    if not existsOk then return nil end
    return unit
end

local function isMouseoverCacheValid(member)
    if not member or not member.itemLevel or not member.lastScanAt then
        return false
    end

    return (addon:GetTimestamp() - member.lastScanAt) < MOUSEOVER_CACHE_TTL
end

local function canInspectMouseover()
    local now = addon:GetTimestamp()
    return (now - lastInspectTime) >= MOUSEOVER_INSPECT_THROTTLE
end

-- MoP Classic 5.5.0 prints "Out of range" / "Unknown unit" to UIErrorsFrame
-- when CanInspect returns false, ignoring the showError=false flag. Wrap the
-- call so the error message never reaches the screen.
local function silentCanInspect(unit)
    local orig = UIErrorsFrame.AddMessage
    UIErrorsFrame.AddMessage = function() end
    local ok, result = pcall(CanInspect, unit, false)
    UIErrorsFrame.AddMessage = orig
    return ok and result
end

local function addTooltipLines(tooltip, member)
    if tooltip[TOOLTIP_LINE_ADDED_KEY] then
        return
    end
    if not member or not setting("showItemLevel") then
        return
    end

    if not member.itemLevel then return end

    local iR, iG, iB = addon.Colors:GetItemLevelColor(member.itemLevel)
    tooltip:AddLine(string.format("%s: %.1f", L.UNIT_TOOLTIP_ILVL_LABEL, member.itemLevel), iR, iG, iB)
    tooltip[TOOLTIP_LINE_ADDED_KEY] = true
end

local function clearTooltipFlag(tooltip)
    tooltip[TOOLTIP_LINE_ADDED_KEY] = nil
end

local function onTooltipSetUnit(tooltip)
    if not addon.initialized then
        return
    end

    clearTooltipFlag(tooltip)

    local unit = safeGetTooltipUnit(tooltip)
    if not unit or not UnitIsPlayer(unit) then
        currentTooltipUnit = nil
        return
    end

    currentTooltipUnit = unit
    local guid = safeUnitGUID(unit)
    if not guid then
        return
    end

    local _, classFile = UnitClass(unit)

    -- Color player name by class (inline color codes survive the default
    -- tooltip pipeline; SetTextColor gets overridden later on this build)
    if setting("showClassColors") and classFile then
        local classColor = RAID_CLASS_COLORS[classFile]
        if classColor then
            local nameLine = _G["GameTooltipTextLeft1"]
            if nameLine then
                local currentText = nameLine:GetText()
                if currentText and currentText ~= "" then
                    local hex = string.format("%02x%02x%02x",
                        math.floor(classColor.r * 255),
                        math.floor(classColor.g * 255),
                        math.floor(classColor.b * 255))
                    nameLine:SetText("|cff" .. hex .. currentText .. "|r")
                end
            end
        end
    end

    -- Replace guild line with "Rank of <Guild>"
    if setting("showGuildRank") then
        local guildName, guildRankName = GetGuildInfo(unit)
        if guildName and guildRankName then
            for i = 2, tooltip:NumLines() do
                local line = _G["GameTooltipTextLeft" .. i]
                if line then
                    local text = line:GetText()
                    if text and text:find(guildName, 1, true) then
                        line:SetText(string.format("%s of <%s>", guildRankName, guildName))
                        line:SetTextColor(0.25, 1.0, 0.25)
                        break
                    end
                end
            end
        end
    end

    -- Color the class name on the "Level XX Class" line
    if setting("showClassColors") and classFile then
        local classColor = RAID_CLASS_COLORS[classFile]
        local localizedClass = UnitClass(unit)
        if classColor and localizedClass then
            local colorCode = string.format("|cff%02x%02x%02x",
                math.floor(classColor.r * 255),
                math.floor(classColor.g * 255),
                math.floor(classColor.b * 255))
            for i = 2, tooltip:NumLines() do
                local line = _G["GameTooltipTextLeft" .. i]
                if line then
                    local text = line:GetText()
                    if text and text:find(localizedClass, 1, true) then
                        local newText = text:gsub(localizedClass, colorCode .. localizedClass .. "|r")
                        line:SetText(newText)
                        break
                    end
                end
            end
        end
    end

    -- Self tooltip: use GetAverageItemLevel directly (no inspect needed)
    if UnitIsUnit(unit, "player") then
        if not setting("showItemLevel") then return end

        local averageItemLevel, equippedItemLevel = GetAverageItemLevel()
        local itemLevel = equippedItemLevel or averageItemLevel
        if itemLevel and itemLevel > 0 then
            local rounded = addon:RoundItemLevel(itemLevel)
            local iR, iG, iB = addon.Colors:GetItemLevelColor(rounded)
            tooltip:AddLine(string.format("%s: %.1f", L.UNIT_TOOLTIP_ILVL_LABEL, rounded), iR, iG, iB)
            tooltip[TOOLTIP_LINE_ADDED_KEY] = true
        end
        return
    end

    local member = addon.members[guid]
    addon:Debug("hover", unit, UnitName(unit), "cached=", member and member.itemLevel or "no")

    if member and isMouseoverCacheValid(member) then
        addon:Debug("  cache hit:", member.itemLevel)
        addTooltipLines(tooltip, member)
        return
    end

    if not member then
        member = addon:GetOrCreateMember(guid)
        local shortName = UnitName(unit)
        member.name = shortName or GetUnitName(unit, false) or UNKNOWN
        member.classFile = classFile
        member.mouseoverOnly = true
    end

    addTooltipLines(tooltip, member)

    if retryTimer then
        retryTimer:Cancel()
        retryTimer = nil
    end

    local throttleOk = canInspectMouseover()
    local canInspectResult = silentCanInspect(unit)
    addon:Debug("  throttleOk=", throttleOk, "CanInspect=", canInspectResult)

    if throttleOk and canInspectResult then
        pendingGUID = guid
        pendingUnit = unit
        lastInspectTime = addon:GetTimestamp()
        addon:Debug("  NotifyInspect ->", UnitName(unit))
        NotifyInspect(unit)
    else
        local retryGUID = guid
        local now = addon:GetTimestamp()
        local remaining = math.max(MOUSEOVER_INSPECT_THROTTLE - (now - lastInspectTime), 0.1)
        addon:Debug("  scheduling retry in", string.format("%.2f", remaining), "s")

        retryTimer = C_Timer.NewTimer(remaining, function()
            retryTimer = nil

            if not GameTooltip:IsShown() then
                addon:Debug("  retry: tooltip closed, abort")
                return
            end

            local retryUnit = safeGetTooltipUnit(GameTooltip)
            if not retryUnit or not safeEquals(safeUnitGUID(retryUnit), retryGUID) then
                addon:Debug("  retry: unit changed, abort")
                return
            end

            if not silentCanInspect(retryUnit) then
                addon:Debug("  retry: cannot inspect, abort")
                return
            end

            pendingGUID = retryGUID
            pendingUnit = retryUnit
            lastInspectTime = addon:GetTimestamp()
            addon:Debug("  retry: NotifyInspect ->", UnitName(retryUnit))
            NotifyInspect(retryUnit)
        end)
    end
end

local function onTooltipCleared(tooltip)
    clearTooltipFlag(tooltip)
    currentTooltipUnit = nil

    if retryTimer then
        retryTimer:Cancel()
        retryTimer = nil
    end
end

function Tooltip:Initialize()
    if self.initialized then
        return
    end

    self.initialized = true

    GameTooltip:HookScript("OnTooltipSetUnit", onTooltipSetUnit)
    GameTooltip:HookScript("OnTooltipCleared", onTooltipCleared)
end

function Tooltip:OnInspectReady(guid)
    addon:Debug("INSPECT_READY", guid, "pending=", pendingGUID, "match=", pendingGUID and safeEquals(pendingGUID, guid))
    if not pendingGUID or not safeEquals(pendingGUID, guid) then
        return false
    end

    local member = addon.members[guid]
    local unit = pendingUnit

    pendingGUID = nil
    pendingUnit = nil

    if not member or not unit then
        addon:Debug("  no member or unit")
        return true
    end

    local itemLevel = computeInspectItemLevel(unit)
    addon:Debug("  computeInspectItemLevel unit=", unit, "result=", itemLevel)

    if itemLevel and itemLevel > 0 then
        member.itemLevel = addon:RoundItemLevel(itemLevel)
        member.lastScanAt = addon:GetTimestamp()
        member.status = "ready"
        addon:Debug("  cached iLvl=", member.itemLevel, "for", member.name)
    else
        addon:Debug("  iLvl missing or 0 -- inspect data not populated yet")
    end

    if member.itemLevel then
        if GameTooltip:IsShown() then
            local tooltipUnit = safeGetTooltipUnit(GameTooltip)
            if tooltipUnit and safeEquals(safeUnitGUID(tooltipUnit), guid) then
                clearTooltipFlag(GameTooltip)
                GameTooltip:SetUnit(tooltipUnit)
            end
        end
    end

    ClearInspectPlayer()
    return true
end
