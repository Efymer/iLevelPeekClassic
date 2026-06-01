local addonName, addon = ...

addon.Config = addon.Config or {}

-- TBC Classic iLvl bands, by tier of content.
-- 154+:    Sunwell Plateau (T6.5) / Sunmote gear
-- 146+:    Black Temple / Hyjal Summit (T6)
-- 141+:    Serpentshrine Cavern / Tempest Keep (T5)
-- 128+:    Karazhan / Gruul / Magtheridon (T4) and badge gear
-- 110+:    pre-raid epics / heroic dungeon blues / early reputation gear
-- below:   leveling / questing greens
addon.Config.ilvlColorThresholds = {
    { min = 154, color = { 1.00, 0.82, 0.00 } }, -- legendary gold (Sunwell)
    { min = 146, color = { 1.00, 0.50, 0.00 } }, -- orange (BT / Hyjal, T6)
    { min = 141, color = { 0.64, 0.21, 0.93 } }, -- epic purple (SSC / TK, T5)
    { min = 128, color = { 0.00, 0.44, 0.87 } }, -- rare blue (Kara / Gruul / Mag, T4)
    { min = 110, color = { 0.12, 1.00, 0.00 } }, -- uncommon green (pre-raid / heroics)
    { min = 0,   color = { 0.62, 0.62, 0.62 } }, -- fallback gray
}
