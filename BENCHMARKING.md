# Benchmarking

The harness lives in `lib/bench.lua`, wired into `xivhotbar.lua` at the
prerender handler (labels `prerender`, `check_recasts`, `check_hover`) and
the keybind execute path (`keypress_execute`). It is inert unless started:
when off, the only added work is one boolean test per instrumented site.

## Commands

| Command | Effect |
|---|---|
| `//htb bench start [N]` | begin collecting; discards the first N prerender frames as warmup (default 120, about 2 s) |
| `//htb bench stop` | stop collecting; samples retained |
| `//htb bench report` | print per-label stats: n, min, mean, p50, p95, max, in ms and as a share of the 16.67 ms / 60 fps frame budget |
| `//htb bench reset` | discard all samples |

Timing uses `socket.gettime()` (LuaSocket ships with Windower; wall-clock,
sub-millisecond). If unavailable it falls back to `os.clock()` and says so
in the report header; treat fallback numbers as coarse.

## Why distributions, not single numbers

Frame work is noisy: GC pauses, zone activity, engine contention. A single
reading is meaningless. p50 is the typical cost; p95 and max show hitches.
The warmup window exists because the first seconds after load or zone run
with cold caches and would skew everything.

## Measuring a change

1. Implement the change behind a flag or on a branch so the ON and OFF
   variants are otherwise identical.
2. Hold constant between runs: character, job/subjob, zone and standing
   spot, party size, number of nearby mobs (several loops scale with
   nearby entities), hotbar layout and theme, resolution, fps cap, other
   loaded addons.
3. Per variant: load in, wait for the bar to fully populate, then
   `//htb bench start`, play or stand for a fixed period of at least 60
   seconds doing the same activity in both runs, then
   `//htb bench stop` and `//htb bench report`. Save the numbers.
4. Run OFF, then ON, then OFF again at minimum, so drifting conditions
   show up as an inconsistent baseline.
5. Record with every result: date, server, character and job, zone, party
   size, mob count, fps cap, warmup, run duration, and the commit hash.

## Reading results honestly

- Numbers are valid only for the tested conditions. "check_recasts p50
  dropped 40% standing in Lower Jeuno solo" is a result; "the addon is 40%
  faster" is not.
- Compare like with like: p50 against p50, p95 against p95, same duration.
- Keep the frame-budget share next to any percentage. Halving a 0.2 ms
  function saves 0.6% of a frame: real, and imperceptible.
- A change with no measurable p50/p95 movement under realistic conditions
  is a no-op for users, however clever the code. Say so and move on.

## Baselines to collect before optimizing anything

1. `prerender` p50/p95 idle in town, no party.
2. `prerender` p50/p95 engaged, full party, busy camp.
3. `check_recasts` share of prerender (the before-number for issue #11).
4. `keypress_execute` p50 (expected to be trivial; confirms the keypress
   path needs no work).
