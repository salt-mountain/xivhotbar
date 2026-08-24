# Asset Inventory

The code in this repository is BSD-3-Clause licensed (see `LICENSE`). The
image assets are not: most are derived from Square Enix game art and are not
ours to license. This file records what ships with the addon, where it came
from, and how it is handled.

## Categories

- **Square Enix art** — icons extracted from or derived from FINAL FANTASY XI
  or FINAL FANTASY XIV. © Square Enix Holdings Co., Ltd. Included as part of
  a non-commercial fan addon, with no rights claimed. Bundling the game's own
  icons for the game's own spells is long-standing practice across the
  Windower addon ecosystem.
- **Addon-original** — created by authors in this addon's lineage
  (SirEdeonX, Akirane, Technyze). Distributed with the addon under its terms.

## Inventory

| Path | Files | Contents | Category |
|---|---|---|---|
| `images/icons/spells/` | 856 | FFXI spell icons, named by in-game icon ID | Square Enix art |
| `images/icons/abilities/` | 246 | FFXI ability icons, named by in-game icon ID | Square Enix art |
| `images/icons/custom/ffxiv/` | 768 | FFXIV job-action icons, organized per FFXIV job | Square Enix art |
| `images/icons/weapons/` | 14 | Weapon-skill icons (FFXIV-sourced) | Square Enix art |
| `images/icons/custom/trusts/` | 41 | FFXI Trust portraits | Square Enix art |
| `images/icons/custom/summons/` | 19 | FFXI avatar art | Square Enix art |
| `images/icons/custom/mounts/` | 15 | FFXI mount art | Square Enix art |
| `images/icons/custom/blue/` | 17 | FFXI blue-magic icons | Square Enix art |
| `images/icons/elements/` | 8 | FFXI element icons | Square Enix art |
| `images/icons/skillchain/` | 14 | FFXI skillchain icons | Square Enix art |
| `images/icons/custom/old_weapons/` | 14 | Generic weapon icons from the original XIVHotbar | Addon-original |
| `images/icons/custom/` (top level) | 74 | Utility icons (`ws.png`, `check.png`, ...) and misc game-derived images | Mixed |
| `images/other/` | 9 | UI chrome (`blank.png`, `highlight.png`, `move.png`, ...) | Mostly addon-original |
| `themes/` | 13 | Slot/frame chrome for the classic, ffxi, and ffxiv themes | `classic` addon-original; `ffxi`/`ffxiv` styled after the games |

## Handling

1. Square Enix art ships as-is, attributed here and in the README. It is
   excluded from the BSD license by the scope notes in `NOTICE`. This addon
   is not affiliated with or endorsed by Square Enix.
2. If redistribution of any asset ever becomes a problem, the icon sets can
   be swapped for free replacements keyed to the same icon IDs, or blanked.

## Data tables

`priv_res/spells.lua`, `jobs.lua`, `job_abilities.lua`, `weapon_skills.lua`,
and `horizon_spells.lua` are generated copies of the Windower project's
`resources` library, © 2013-2022 Windower, BSD-3-Clause. Each file retains
the Windower license notice.
