# iLevelPeek Classic

A lightweight unit-tooltip enhancer for **World of Warcraft: Mists of Pandaria Classic (5.5.0)**.

## Features

- **Item level** added to player tooltips, coloured by Throne of Thunder gear bands (LFR / Normal / Heroic / Thunderforged / Ra-den).
- **Class-coloured player name** on the tooltip.
- **Guild rank** shown alongside guild name ("Officer of <Guild>").
- **Class-coloured class line** on "Level XX <Class>".

Self-tooltips read from `GetAverageItemLevel()` instantly. Other players are inspected on hover (28y range), cached for 5 minutes per GUID, and refreshed on `INSPECT_READY`. Players outside inspect range simply show no iLvl line — there is no `iLvl: ...` placeholder.

## Settings

Open with `/ilvlpeek` or `/ilevelpeek`. Three toggles:

- Show Item Level
- Class-Coloured Names
- Show Guild Rank

## Installation

Download the latest release from CurseForge and unzip into `World of Warcraft\_classic_\Interface\AddOns\`.

## License

MIT — see [LICENSE](LICENSE).
