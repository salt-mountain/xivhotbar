-- ============================================================================
-- GEO example layout — UNTESTED IN-GAME (static-data draft, 2026-08-24)
-- ============================================================================
-- Usage: copy to data/<YourCharacterName>/geo.lua and edit to taste.
--
-- Every spell name and level below was cross-checked against the addon's
-- bundled spell data (priv_res/spells.lua, GEO = job id 21). The addon
-- level-gates and learned-gates automatically, so listing a spell you can't
-- cast yet is safe — it shows once you can.
--
-- Targeting model (important for GEO):
--   Indi- spells   -> 'me'    self-only aura, follows you
--   Geo- buffs     -> 'stpc'  select a party member; the luopan is planted
--                             AT THEM (use 'me' variant to drop it at your
--                             own feet instead)
--   Geo- debuffs   -> 'bt'    planted at your current battle target;
--                             'stnpc' variants let you click any mob
--   Entrust        -> 'me'    (JA; the follow-up Indi- goes on 'stpc')
--
-- The ['Luopan'] stance block at the bottom requires the buff_table entry
-- [1014] = 'Luopan' in lib/action_manager.lua (backlog B4) and in-game
-- confirmation that the 0x068 pet packet names the pet "Luopan".
-- Until then that block is simply never activated — harmless.
-- ============================================================================

xivhotbar_keybinds_job['Base'] = {

  -- Hotbar #1: Indi auras (self) + Entrust
  {'battle 1 1', 'ma', 'Indi-Haste', 'me', 'I.Haste'},        -- 93
  {'battle 1 2', 'ma', 'Indi-Fury', 'me', 'I.Fury'},          -- 34
  {'battle 1 3', 'ma', 'Indi-Refresh', 'me', 'I.Refresh'},    -- 30
  {'battle 1 4', 'ma', 'Indi-Regen', 'me', 'I.Regen'},        -- 15
  {'battle 1 5', 'ma', 'Indi-Barrier', 'me', 'I.Barrier'},    -- 28
  {'battle 1 6', 'ma', 'Indi-Fend', 'me', 'I.Fend'},          -- 40
  {'battle 1 7', 'ma', 'Indi-Acumen', 'me', 'I.Acumen'},      -- 46
  {'battle 1 8', 'ma', 'Indi-Focus', 'me', 'I.Focus'},        -- 22
  {'battle 1 9', 'ma', 'Indi-Precision', 'me', 'I.Precis'},   -- 10
  {'battle 1 10', 'ja', 'Entrust', 'me', 'Entrust'},
  {'battle 1 11', 'ja', 'Full Circle', 'me', 'FullCirc'},
  {'battle 1 12', 'ja', 'Bolster', 'me', 'Bolster'},

  -- Hotbar #2: Geo bubbles.
  -- Debuffs on 'bt' (planted at battle target). Buffs on 'stpc'
  -- (planted at the selected party member, e.g. the tank).
  {'battle 2 1', 'ma', 'Geo-Frailty', 'bt', 'G.Frail'},       -- 80
  {'battle 2 2', 'ma', 'Geo-Torpor', 'bt', 'G.Torpor'},       -- 56
  {'battle 2 3', 'ma', 'Geo-Malaise', 'bt', 'G.Malaise'},     -- 92
  {'battle 2 4', 'ma', 'Geo-Languor', 'bt', 'G.Languor'},     -- 68
  {'battle 2 5', 'ma', 'Geo-Slow', 'bt', 'G.Slow'},           -- 52
  {'battle 2 6', 'ma', 'Geo-Paralysis', 'bt', 'G.Para'},      -- 72
  {'battle 2 7', 'ma', 'Geo-Vex', 'bt', 'G.Vex'},             -- 74
  {'battle 2 8', 'ma', 'Geo-Haste', 'stpc', 'G.Haste'},       -- 97
  {'battle 2 9', 'ma', 'Geo-Fury', 'stpc', 'G.Fury'},         -- 38
  {'battle 2 10', 'ma', 'Geo-Refresh', 'stpc', 'G.Refresh'},  -- 34
  {'battle 2 11', 'ma', 'Geo-Regen', 'stpc', 'G.Regen'},      -- 19
  {'battle 2 12', 'ma', 'Geo-Barrier', 'stpc', 'G.Barrier'},  -- 32
  -- 'stnpc' alternates if you prefer click-targeting debuff placement:
  -- {'battle 2 1', 'ma', 'Geo-Frailty', 'stnpc', 'G.Frail'},

  -- Hotbar #3: nukes (tier-shared slots), dark, utility.
  -- Same-slot rows demonstrate tiered slot sharing: the highest tier you
  -- know and can cast is the one shown.
  {'battle 3 1', 'ma', 'Stone V', 'bt', 'Stone'},             -- 100 (JP)
  {'battle 3 1', 'ma', 'Stone IV', 'bt', 'Stone'},            -- 76
  {'battle 3 1', 'ma', 'Stone III', 'bt', 'Stone'},           -- 58
  {'battle 3 1', 'ma', 'Stone II', 'bt', 'Stone'},            -- 34
  {'battle 3 1', 'ma', 'Stone', 'bt', 'Stone'},               -- 4
  {'battle 3 2', 'ma', 'Water IV', 'bt', 'Water'},            -- 79
  {'battle 3 3', 'ma', 'Aero IV', 'bt', 'Aero'},              -- 82
  {'battle 3 4', 'ma', 'Fire IV', 'bt', 'Fire'},              -- 85
  {'battle 3 5', 'ma', 'Blizzard IV', 'bt', 'Blizzard'},      -- 88
  {'battle 3 6', 'ma', 'Thunder IV', 'bt', 'Thunder'},        -- 91
  {'battle 3 7', 'ma', 'Drain', 'bt', 'Drain'},               -- 15
  {'battle 3 8', 'ma', 'Aspir', 'bt', 'Aspir'},               -- 30
  {'battle 3 9', 'ma', 'Sleep II', 'stnpc', 'Sleep2'},        -- 70
  {'battle 3 9', 'ma', 'Sleep', 'stnpc', 'Sleep'},            -- 35
  {'battle 3 11', 'ja', 'Blaze of Glory', 'me', 'BoG'},
  {'battle 3 12', 'ja', 'Theurgic Focus', 'me', 'Theurgic'},
}

-- Subjob example: WHM sub for cures (GEO has no native cures).
xivhotbar_keybinds_job['WHM'] = {
  {'battle 4 1', 'ma', 'Cure IV', 'stpc', 'Cure4'},
  {'battle 4 1', 'ma', 'Cure III', 'stpc', 'Cure3'},
  {'battle 4 1', 'ma', 'Cure II', 'stpc', 'Cure2'},
  {'battle 4 1', 'ma', 'Cure', 'stpc', 'Cure'},
  {'battle 4 2', 'ma', 'Haste', 'stpc', 'Haste'},
  {'battle 4 3', 'ma', 'Regen', 'stpc', 'Regen'},
  {'battle 4 4', 'ma', 'Erase', 'stpc', 'Erase'},
  {'battle 4 5', 'ma', 'Paralyna', 'stpc', 'Paralyna'},
  {'battle 4 6', 'ma', 'Silena', 'stpc', 'Silena'},
}

-- Luopan stance bar: appears while your luopan is up.
-- REQUIRES backlog B4 (buff_table Luopan entry) — inert until then.
xivhotbar_keybinds_job['Luopan'] = {
  {'battle 5 1', 'ja', 'Full Circle', 'me', 'FullCirc'},
  {'battle 5 2', 'ja', 'Ecliptic Attrition', 'me', 'EclAttr'},
  {'battle 5 3', 'ja', 'Lasting Emanation', 'me', 'LastEman'},
  {'battle 5 4', 'ja', 'Dematerialize', 'me', 'Demat'},
  {'battle 5 5', 'ja', 'Life Cycle', 'me', 'LifeCycle'},
  {'battle 5 6', 'ja', 'Concentric Pulse', 'me', 'ConcPulse'},
  {'battle 5 7', 'ja', 'Mending Halation', 'me', 'MendHal'},
  {'battle 5 8', 'ja', 'Radial Arcana', 'me', 'RadArc'},
}

return xivhotbar_keybinds_job
