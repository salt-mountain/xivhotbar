# XIVHotbar

Final Fantasy XIV style hotbars for Final Fantasy XI, as a Windower 4 addon.

This is an addon born out of
[XIVHotbar2](https://github.com/Technyze/XIVHotbar2) by Technyze, which was a
fork of XIVHotbar by [SirEdeonX](https://github.com/SirEdeonX/FFXIAddons) and
[Akirane](https://github.com/Akirane/XIVHotbar).

This addon is focused on supporting Retail servers with a 99 level cap.

<!-- SCREENSHOT: default two-bar layout at 1080p, on a job with a full first bar -->
![Default layout](images/readme/placeholder-default-layout.png)

## What it does

- Creates MMO Style Hotbars onto which spells, abilities and custom macros can be mapped.
- Bars follow your job, subjob, equipped weapon type, and active pet or stance.
- Actions you have not learned, or cannot use at your level, stay hidden or greyed out.
- Recast timers, MP cost, and inventory counts display on the slots.
- Two pages of bars, Main and General, toggled with a key.

## Installing

1. Put this addon in `Windower4/addons/`. The folder must be named
   `xivhotbar`.

2. Add the load line to `Windower4/scripts/init.txt`:

   ```
   lua load xivhotbar
   ```

3. On first run the addon creates `data/settings.xml` from
   `defaults.lua`, and creates a job file and `General.lua` for your
   character:

   ```
   Windower4/addons/xivhotbar/data/<YourCharacter>/<JOB>.lua
   Windower4/addons/xivhotbar/data/<YourCharacter>/General.lua
   ```

   Both start empty, with the slot format documented in comments at the top.
   A new job file is created the first time you play each job.

**If it looks like nothing loaded, that is expected on a fresh install.**
Empty slots draw almost nothing, so two empty bars are easy to miss. Add an
action, or copy an example file, and the bars become obvious.

## Setting up your bars

Your actions live in the files above. Edit them in a text editor, then run
`//htb reload` in game to pick up the changes.

The quickest start is to copy an example over your own file:

```
data/examples/geo.lua  ->  data/<YourCharacter>/GEO.lua
```

Example files exist for most jobs with example layouts to re-use or modify.

### Which file, and which page

Two separate questions decide where an action shows up, and the word
"General" unhelpfully appears in both.

**Which file** decides *who* gets the action:

- `<JOB>.lua` — that job only
- `General.lua` — every job

**Which environment** decides *which page* it appears on. That is the first
word of a slot entry:

- `battle` — the Main page
- `field` — the General page, toggled with the backslash key

The two choices are independent, so all four
combinations are valid:

| In this file | With this environment | The action appears |
| --- | --- | --- |
| `GEO.lua` | `battle 1 1` | on GEO's Main page |
| `GEO.lua` | `field 1 1` | on GEO's General page |
| `General.lua` | `battle 1 1` | on the Main page, for every job |
| `General.lua` | `field 1 1` | on the General page, for every job |

So `General.lua` does not mean "the General page." It means "shared by all
jobs," and you still choose which page each of its actions lands on.

### Slot format

One line is one slot:

```lua
{'environment hotbar slot', 'type', 'action', 'target', 'label', 'icon'}
```

| Field | What it is | Values |
| --- | --- | --- |
| `environment` | which page it appears on | `battle` for Main, `field` for General. `b` and `f` also work |
| `hotbar` | which row | 1 to 6 |
| `slot` | which slot in that row | 1 to `HotbarLength`, 12 by default |
| `type` | what kind of action | `ma`, `ja`, `ws`, `ct`, `pet`, `input`, `macro`, `gs` |
| `action` | the name, spelled as it is in game | |
| `target` | who it targets | `me`, `t`, `bt`, `stpc`, `stnpc`, or blank. Any FFXI target works |
| `label` | the short text drawn on the slot | optional, blank if omitted |
| `icon` | a file in `images/icons/custom`, without `.png` | optional |

Use `ja` for pet abilities, including Summoner Blood Pacts.

```lua
xivhotbar_keybinds_job['Base'] = {
    {'battle 1 1', 'ja', 'Berserk', 'me', 'Berserk'},
    {'battle 1 2', 'ma', 'Cure IV', 'stpc', 'Cure4'},
}
```

### Blocks within a job file

A job file can hold several blocks. Which one applies depends on what you are
doing at the time, and they stack.

| Block | Applies when |
| --- | --- |
| `['Base']` | always, for that job |
| `['Root']` | in `General.lua` only, always |
| `['WHM']` | when `WHM` is your subjob |
| `['Sword']` | that weapon type is equipped |
| `['Carbuncle']` | that pet is out — any avatar or wyvern |
| `['Luopan']` | when the GEO Luopan is out |
| `['Light Arts']` | that stance is active |

Weapon type names are **case-sensitive** and must be one of: `Hand-to-hand`,
`Dagger`, `Sword`, `Great Sword`, `Axe`, `Great Axe`, `Scythe`, `Polearm`,
`Katana`, `Great Katana`, `Club`, `Staff`, `Bow`, `Marksmanship`. Weapon
blocks also require `EnableWeaponSwitching` in `data/settings.xml`.

<!-- SCREENSHOT: a pet stance bar appearing when a pet is summoned -->
![Stance bar](images/readme/placeholder-stance-bar.png)

## Keybinds

Two rows are bound out of the box: `1`–`0` for the first row, `SHIFT+1`–`0`
for the second. Keybinds live in `data/keybinds.lua`.

Letters, `-` and `=` are deliberately left alone, since letters may be
movement keys depending on your keyboard layout and `-`/`=` open menus.
`CTRL+number` and `ALT+number` are left free because they are FFXI's two
native macro banks, so binding them trades your in-game macros for two more
hotbar rows. A slot can run any command a macro can, so those macros can move
into your job files instead.

**Adding a row takes two steps.** Raise `Hotbar/Style/HotbarCount` in
`data/settings.xml`, *and* uncomment the matching row in `data/keybinds.lua`.
Doing only the first gives you a visible bar with no keys; doing only the
second gives you keys that never bind.

Entries are positional, so use an empty string `''` to leave a slot unbound
rather than deleting it, or every key after it shifts up a slot.

If keys ever stay claimed after a crash, `//unbind <key>` releases one, and
restarting Windower releases all of them. Binds are runtime state, not saved.

## Slots can do more than spells

This is the answer to giving up `CTRL`/`ALT` for macro banks: a hotbar slot
can hold anything a native macro can, without the six-line limit.

```lua
-- any game command
{'battle 1 5', 'input', '/ra <t>', '', 'Ranged'},

-- a multi-step macro, semicolon separated, waits allowed
{'battle 1 6', 'macro', 'input /ja "Sneak Attack" <me>;wait 1;input /ws "Viper Bite" <t>', '', 'SA+VB'},

-- a GearSwap command
{'battle 1 7', 'gs', 'c set TreasureMode Tag', '', 'TH'},

-- any other addon, via macro
{'field 1 1', 'macro', 'send Alt /ma "Cure IV" <me>', '', 'Alt Cure'},
```

## Commands

`//htb` is interchangeable with `//hotbar` and `//xivhotbar`.

| Command | What it does |
| --- | --- |
| `//htb move` | drag bars to reposition; run again to save |
| `//htb reload` | reload after editing a job file |
| `//htb mount [name]` | mount, or dismount if mounted |
| `//htb release` | release your pet |
| `//htb dev [on\|off]` | toggle diagnostic messages |

## Settings

Settings live in `data/settings.xml`, created on first run with every setting
already in it. Edit that file, then run `//lua reload xivhotbar` — settings are
read when the addon loads, so `//htb reload` will not pick them up.

The ones most people want:

| Setting | Notes |
| --- | --- |
| `Hotbar/Style/HotbarCount` | how many rows are drawn and bound. Default 2 |
| `Hotbar/Style/HotbarLength` | slots per row. Default 12 |
| `Hotbar/Theme/Slot` and `Frame` | slot and frame art sets |
| `Hotbar/HideEmptySlots` | default true |
| `Hotbar/ShowActionDescription` | tooltip text on hover |
| `Overlays/DisableScroll` | the scroll overlay on unlearned spells |
| `Controls/ToggleBattleMode` | key that switches Main and General pages |
| `General/EnableWeaponSwitching` | required for weapon type blocks |

`ToggleBattleMode` is a DIK keycode, not a letter. The default `43` is
backslash. Use the integer column of a
[DIK keycode table](https://community.bistudio.com/wiki/DIK_KeyCodes) to pick
another.

### Bar positions apply per character by default

`//htb move` writes offsets into a section named after your character. To use
the same positions on every character, copy those offset values into the
`<Global>` section of `data/settings.xml` and delete the character section.

### defaults.lua

`defaults.lua` is only the template used to create `settings.xml` the first
time the addon runs. Editing it has no effect once that file exists.

## Icons

Each slot picks its art in this order:

1. The `icon` field of the slot, naming a file in `images/icons/custom`
   without the extension. Subfolders work: `'ffxiv/drk/souleater'`.
2. A file in `images/icons/custom` whose name matches the action.
3. The bundled icon set, keyed by the action's in-game icon id.
4. A fallback: the spell's element, or a generic icon for abilities.

To use your own art, drop a PNG into `images/icons/custom` named after the
action — `full circle.png` for Full Circle — and it is picked up without any
change to your job file.

Slots draw icons at 40×40. Any size
works since images are resized to fit, but square art at 40×40 or larger keeps
its shape and stays sharp. It must be a `.png`.

## Troubleshooting

Reload in increasing order of severity: `//htb reload`, then
`//lua reload xivhotbar`.

**Nothing on screen after a fresh install.** Empty bars are nearly invisible.
Copy an example file into your character folder and `//htb reload`.

**"Couldn't load `<JOB>`.lua"** means that file has a syntax error, usually a
missing comma or brace. The addon releases its keybinds when this happens, so
your number keys behave normally until you fix it.

**A weapon block is not applying.** Unequip and re-equip the weapon. Also
check `EnableWeaponSwitching` and that the block name matches the weapon type
exactly, including capitals.

**An action is missing from a bar.** The addon hides actions you have not
learned or cannot use yet. Confirm the name is spelled as it is in game.

Bugs and requests: <https://github.com/salt-mountain/xivhotbar/issues>

## License

- The addon code is BSD 3-Clause. See [LICENSE](LICENSE).
- Icons and other art derived from Final Fantasy XI and Final Fantasy XIV, and
  the in-game description text under `priv_res/`, are the property of Square
  Enix Holdings Co., Ltd. and are **not** covered by that license.
- This is a non-commercial fan project, not affiliated with, endorsed by, or
  sponsored by Square Enix.
- XIVHotbar's earlier authors are not involved in or responsible for this fork.

[NOTICE](NOTICE) and [ASSETS.md](ASSETS.md) record what came from where.
