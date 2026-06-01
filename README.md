# iLevelPeek TBC

`iLevelPeek TBC` is a lightweight World of Warcraft: The Burning Crusade Classic (2.5.x) addon that injects item level directly into unit tooltips, with class-colored names and guild rank.

> This is the **TBC Classic** build (Interface 20505). For the Mists of Pandaria Classic (5.5.0) build, see the `main` branch.

## Features

*   Class-colored player name in the tooltip
*   Guild rank shown as `Rank of <Guild Name>`
*   Class-colored class line (e.g. "Level 70 **Paladin**")
*   Item level coloured by TBC raid-tier gear bands (pre-raid / T4 / T5 / T6 / Sunwell)
*   Works on both yourself and inspected players
*   Players outside inspect range simply show no item-level line — no `iLvl: ...` placeholder
*   Per-GUID cache (5-minute TTL) so re-hovering the same player is instant
*   **Config panel** with toggles for each feature (item level, class colors, guild rank)

## Installation

1.  Close World of Warcraft.
2.  Place the `iLevelPeekClassic` folder into: `World of Warcraft\_classic_era_\Interface\AddOns\` (or your TBC Classic install's AddOns folder).
3.  Start the game and enable `iLevelPeek TBC` in the AddOns list.

## Usage

Hover over any player unit frame to see their item level. Self-tooltips read instantly from your own equipped gear; other players are inspected on hover and cached for 5 minutes per GUID. Inspection only works within ~28 yards (a server limit), so distant players show no line until they pass nearby.

Type `/ilevelpeek` or `/ilvlpeek` to open the settings panel, or find it under **Options > AddOns > iLevelPeek TBC**.

## License

MIT — see [LICENSE](LICENSE).
