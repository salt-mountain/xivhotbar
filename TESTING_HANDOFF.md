# Testing handoff

In-game verification checklist for changes that were only checked
statically. Run on the game machine, mark pass/fail, note exact console
errors (file:line is enough to act on).

## Setup

1. Clone the repo into `Windower4/addons/` — the folder must be named
   `xivhotbar` (it is, by repo name). Check out `development`.
2. Remove or disable any old XIVHotbar/XIVHotbar2 install first; running
   both is not supported.
3. Migrating: copy the old `data/settings.xml` and `data/<Character>/`
   folder over. Fresh install: first load generates settings.
4. Load line: `lua load xivhotbar`.
5. GEO testing needs the example job file as
   `data/<YourCharacter>/geo.lua` (see issue #1 for its status).

## T1 — Load and rename smoke test (do first)

- [ ] `//lua load xivhotbar` loads with no console errors.
- [ ] `//xivhotbar help`, `//htb help`, `//hotbar help` all respond; the
      removed `//xivhotbar2` and bare `//execute` do nothing.
- [ ] Keybinds fire actions (keybinds route through `htb execute`).
- [ ] Log out to title, log back in: the bar reloads itself.
- [ ] `mount` subcommand mounts when unmounted and dismounts when mounted.

## T2 — GEO end to end

- [ ] On GEO with geo.lua in place: bar populates; spells above level or
      unlearned are gated per the normal rules.
- [ ] An Indi- spell from the bar casts on self.
- [ ] A Geo- debuff from the bar (bt target) plants the luopan at the
      battle target.
- [ ] A Geo- buff from the bar (stpc) opens the party selector and plants
      at the chosen member.
- [ ] Icons: Indi-/Geo- slots are expected to show blank icons (missing
      files for spell ids 768-827, issue #3). Confirm nothing crashes.
- [ ] Pet name probe (decides issue #4): with DevMode on, summon a luopan.
      The console should log the pet-summoned reload. To capture the name,
      temporarily add `print('PET NAME: '..tostring(packet['Pet Name']))`
      in the 0x068 handler in xivhotbar.lua. If it prints exactly
      `Luopan`, issue #4 works as designed.
- [ ] Luopan death / Full Circle: bar reloads without errors.

## T3 — Level sync and cap gating

- [ ] Sync to a lower-level member: bar re-gates to the synced level.
- [ ] Confirm `windower.ffxi.get_player().main_job_level` reports the
      synced level on this server; the gating design assumes it does.
- [ ] Drop sync: bar restores.
- [ ] Enter a level-capped area (buff 143): bar re-gates. Leave the capped
      area without zoning: the bar is expected NOT to un-gate (issue #7).
      Confirm the bug exists as described before fixing it.

## T4 — Bench harness

- [ ] `//htb bench report` before starting prints the no-samples message.
- [ ] `//htb bench start` names `socket.gettime` as the clock. If it
      reports the os.clock fallback, note it — LuaSocket should be present.
- [ ] Stand still 60 s, `//htb bench stop`, `//htb bench report`: rows for
      prerender, check_recasts, check_hover with sane numbers (idle
      prerender p50 should be well under 1 ms).
- [ ] Press hotbar keys during a run: a keypress_execute row appears.
- [ ] With bench never started, play normally: no perceptible change.
- [ ] Collect the four baselines listed in BENCHMARKING.md.

## T5 — Regression sweep

- [ ] `//htb move`: drag a bar, `//htb move` again to save; layout
      survives `//lua reload xivhotbar`.
- [ ] Job change at a moogle: bar swaps to the new job's file.
- [ ] Weapon swap (with EnableWeaponSwitching on): WS bar follows the
      weapon type.
- [ ] SMN if available: summon an avatar and confirm the avatar stance bar
      appears (the same machinery GEO stance bars will use).
- [ ] Zoning: bar hides during the zone and restores after.
