local addonName, addon = ...

addon.Config = addon.Config or {}

-- TBC Classic iLvl bands for the *average* equipped item level, by raid tier.
-- Colors are TacoTip's exact quality palette (its GS_Rarity table), so the iLvl
-- line matches the colors TacoTip uses on Classic/TBC inspect tooltips.
-- TBC Anniversary is in Phase 3 (Black Temple / Hyjal) as of October 2026.
-- 154+:    Sunwell Plateau (Phase 4: loot 154-164)
-- 141+:    Black Temple / Hyjal Summit (loot 141-156, T6 = 146)
-- 128+:    Serpentshrine Cavern / Tempest Keep (loot 128-138, T5 = 133)
-- 115+:    Karazhan / Gruul / Magtheridon (loot 115-125, T4 = 120) and badge gear
-- 105+:    heroic dungeon blues (115) / pre-raid / reputation gear
-- below:   leveling / questing greens
addon.Config.ilvlColorThresholds = {
    { min = 154, color = { 0.90, 0.80, 0.50 } }, -- legendary gold (Sunwell)           [TacoTip GS_Rarity 7]
    { min = 141, color = { 0.94, 0.09, 0.00 } }, -- legendary red (BT / Hyjal, T6)     [TacoTip GS_Rarity 5]
    { min = 128, color = { 0.69, 0.28, 0.97 } }, -- epic purple (SSC / TK, T5)         [TacoTip GS_Rarity 4]
    { min = 115, color = { 0.00, 0.50, 1.00 } }, -- rare blue (Kara / Gruul / Mag, T4) [TacoTip GS_Rarity 3]
    { min = 105, color = { 0.12, 1.00, 0.00 } }, -- uncommon green (pre-raid / heroics) [TacoTip GS_Rarity 2]
    { min = 0,   color = { 0.55, 0.55, 0.55 } }, -- poor gray                          [TacoTip GS_Rarity 0]
}
