local addonName, addon = ...

addon.L = addon.L or {}

local L = addon.L

-- English (default)
L.UNIT_TOOLTIP_ILVL_LABEL  = "iLvl"

-- Settings panel
L.SETTINGS_SECTION_DISPLAY    = "Tooltip Display"
L.SETTINGS_SECTION_APPEARANCE = "Tooltip Appearance"

L.SETTINGS_SHOW_ILVL_NAME   = "Show Item Level"
L.SETTINGS_SHOW_ILVL_TIP    = "Display item level in the tooltip."
L.SETTINGS_SHOW_COLORS_NAME = "Class-Colored Names"
L.SETTINGS_SHOW_COLORS_TIP  = "Color player names and class text by their class color."
L.SETTINGS_SHOW_GUILD_NAME  = "Show Guild Rank"
L.SETTINGS_SHOW_GUILD_TIP   = "Display guild rank alongside guild name."

local locale = GetLocale()

if locale == "ruRU" then
    L.SETTINGS_SECTION_DISPLAY    = "Отображение подсказки"
    L.SETTINGS_SECTION_APPEARANCE = "Внешний вид подсказки"
    L.SETTINGS_SHOW_ILVL_NAME     = "Показывать уровень предметов"
    L.SETTINGS_SHOW_ILVL_TIP      = "Отображать уровень предметов в подсказке."
    L.SETTINGS_SHOW_COLORS_NAME   = "Цвета классов"
    L.SETTINGS_SHOW_COLORS_TIP    = "Окрашивать имена игроков и текст класса в цвет класса."
    L.SETTINGS_SHOW_GUILD_NAME    = "Показывать ранг в гильдии"
    L.SETTINGS_SHOW_GUILD_TIP     = "Отображать ранг в гильдии рядом с названием гильдии."

elseif locale == "esES" or locale == "esMX" then
    L.SETTINGS_SECTION_DISPLAY    = "Información del tooltip"
    L.SETTINGS_SECTION_APPEARANCE = "Apariencia del tooltip"
    L.SETTINGS_SHOW_ILVL_NAME     = "Mostrar nivel de objeto"
    L.SETTINGS_SHOW_ILVL_TIP      = "Muestra el nivel de objeto en el tooltip."
    L.SETTINGS_SHOW_COLORS_NAME   = "Nombres con color de clase"
    L.SETTINGS_SHOW_COLORS_TIP    = "Colorea los nombres y texto de clase según su clase."
    L.SETTINGS_SHOW_GUILD_NAME    = "Mostrar rango de hermandad"
    L.SETTINGS_SHOW_GUILD_TIP     = "Muestra el rango de hermandad junto al nombre de la hermandad."
end
