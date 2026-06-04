local addonName, addon = ...

addon.Config = addon.Config or {}

-- MoP Classic Phase 5 (Siege of Orgrimmar) iLvl bands.
-- No LFR or Flexible difficulty exists in MoP Classic — only Normal and Heroic.
-- 566-600: Heroic SoO (566) / Heroic Warforged (572) / legendary cloak (600)
-- 553-559: Normal SoO (553) / Normal Warforged (559)
-- 528:     Celestials / Ordos world bosses
-- 496:     Timeless Isle gear
-- 463:     pre-SoO / Throne of Thunder carryover
addon.Config.ilvlColorThresholds = {
    { min = 566, color = { 1.00, 0.82, 0.00 } }, -- legendary gold (Heroic / Warforged / cloak)
    { min = 553, color = { 1.00, 0.50, 0.00 } }, -- orange (Normal / Normal Warforged)
    { min = 528, color = { 0.64, 0.21, 0.93 } }, -- epic purple (Celestials / Ordos)
    { min = 496, color = { 0.00, 0.44, 0.87 } }, -- rare blue (Timeless Isle)
    { min = 463, color = { 0.12, 1.00, 0.00 } }, -- uncommon green (pre-SoO / ToT carryover)
    { min = 0,   color = { 0.62, 0.62, 0.62 } }, -- fallback gray
}
