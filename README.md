# iLevelPeek Classic

`iLevelPeek Classic` is a lightweight World of Warcraft: Mists of Pandaria Classic (5.5.0) addon that injects item level directly into unit tooltips, with class-colored names and guild rank.

## Features

*   Class-colored player name in the tooltip
*   Guild rank shown as `Rank of <Guild Name>`
*   Class-colored spec line (e.g. "Level 90 Holy **Paladin**")
*   Item level coloured by Throne of Thunder gear bands (LFR / Normal / Heroic / Thunderforged / Ra-den)
*   Works on both yourself and inspected players
*   Players outside inspect range simply show no item-level line — no `iLvl: ...` placeholder
*   Per-GUID cache (5-minute TTL) so re-hovering the same player is instant
*   **Config panel** with toggles for each feature (item level, class colors, guild rank)

## Installation

1.  Close World of Warcraft.
2.  Place the `iLevelPeekClassic` folder into: `World of Warcraft\_classic_\Interface\AddOns\`
3.  Start the game and enable `iLevelPeek Classic` in the AddOns list.

The final installed path should be:

```
World of Warcraft\_classic_\Interface\AddOns\iLevelPeekClassic\iLevelPeekClassic.toc
```

## Usage

Hover over any player unit frame to see their item level. Self-tooltips read instantly from `GetAverageItemLevel()`; other players are inspected on hover and cached for 5 minutes per GUID.

Type `/ilevelpeek` or `/ilvlpeek` to open the settings panel, or find it under **Options > AddOns > iLevelPeek Classic**.

## License

MIT — see [LICENSE](LICENSE).
