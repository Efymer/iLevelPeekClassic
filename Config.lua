local addonName, addon = ...

addon.Config = addon.Config or {}

-- MoP Classic Phase 3 (Throne of Thunder) iLvl bands.
-- 541-542: Heroic Thunderforged / Ra-den (top of the tier)
-- 535:     Heroic base ToT
-- 528:     Normal Thunderforged ToT
-- 522:     Normal base ToT
-- 502:     LFR ToT / Celestial Dungeons
-- 463-476: pre-5.2 heroic 5-mans / Tier 14 LFR
addon.Config.ilvlColorThresholds = {
    { min = 540, color = { 1.00, 0.82, 0.00 } }, -- legendary gold (Heroic Thunderforged / Ra-den)
    { min = 528, color = { 1.00, 0.50, 0.00 } }, -- orange (Heroic / Normal Thunderforged)
    { min = 522, color = { 0.64, 0.21, 0.93 } }, -- epic purple (Normal ToT)
    { min = 502, color = { 0.00, 0.44, 0.87 } }, -- rare blue (LFR ToT)
    { min = 463, color = { 0.12, 1.00, 0.00 } }, -- uncommon green (pre-raid / T14 LFR)
    { min = 0,   color = { 0.62, 0.62, 0.62 } }, -- fallback gray
}
