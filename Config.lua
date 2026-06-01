local addonName, addon = ...

addon.Config = addon.Config or {}

-- TBC Classic iLvl bands, by tier of content. Colors are TacoTip's exact
-- quality palette (its GS_Rarity table), so the iLvl line matches the colors
-- TacoTip uses on Classic/TBC inspect tooltips.
-- 154+:    Sunwell Plateau (T6.5) / Sunmote gear
-- 146+:    Black Temple / Hyjal Summit (T6)
-- 141+:    Serpentshrine Cavern / Tempest Keep (T5)
-- 128+:    Karazhan / Gruul / Magtheridon (T4) and badge gear
-- 110+:    pre-raid epics / heroic dungeon blues / early reputation gear
-- below:   leveling / questing greens
addon.Config.ilvlColorThresholds = {
    { min = 154, color = { 0.90, 0.80, 0.50 } }, -- legendary gold (Sunwell)        [TacoTip GS_Rarity 7]
    { min = 146, color = { 0.94, 0.09, 0.00 } }, -- legendary red (BT / Hyjal, T6)   [TacoTip GS_Rarity 5]
    { min = 141, color = { 0.69, 0.28, 0.97 } }, -- epic purple (SSC / TK, T5)       [TacoTip GS_Rarity 4]
    { min = 128, color = { 0.00, 0.50, 1.00 } }, -- rare blue (Kara / Gruul / Mag, T4) [TacoTip GS_Rarity 3]
    { min = 110, color = { 0.12, 1.00, 0.00 } }, -- uncommon green (pre-raid / heroics) [TacoTip GS_Rarity 2]
    { min = 0,   color = { 0.55, 0.55, 0.55 } }, -- poor gray                        [TacoTip GS_Rarity 0]
}
