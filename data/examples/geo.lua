-- Example GEO layout. Copy to data/<YourCharacter>/GEO.lua and edit.
--
-- Listing a spell you cannot cast yet is safe: the addon hides it until you
-- meet the level and have learned it.
--
-- Targeting for Geomancy:
--   Indi- spells   'me'     self-only aura that follows you
--   Geo- buffs     'stpc'   luopan is planted at the party member you pick
--   Geo- debuffs   'bt'     planted at your battle target ('stnpc' to click)
--   Entrust        'me'     the follow-up Indi- goes on 'stpc'
--
-- The ['Luopan'] block appears while a luopan is out.
-- It is bound to Hotbar 5 which is not enabled by default.
-- You will need to enable it in data/settings.xml to be able to see it.

xivhotbar_keybinds_job['Base'] = {

  -- Hotbar #1: Indi auras (self) + Entrust
  {'battle 1 1', 'ma', 'Indi-Haste', 'me', 'I.Haste'},
  {'battle 1 2', 'ma', 'Indi-Fury', 'me', 'I.Fury'},
  {'battle 1 3', 'ma', 'Indi-Refresh', 'me', 'I.Refresh'},
  {'battle 1 4', 'ma', 'Indi-Regen', 'me', 'I.Regen'},
  {'battle 1 5', 'ma', 'Indi-Barrier', 'me', 'I.Barrier'},
  {'battle 1 6', 'ma', 'Indi-Fend', 'me', 'I.Fend'},
  {'battle 1 7', 'ma', 'Indi-Acumen', 'me', 'I.Acumen'},
  {'battle 1 8', 'ma', 'Indi-Focus', 'me', 'I.Focus'},
  {'battle 1 9', 'ma', 'Indi-Precision', 'me', 'I.Precis'},
  {'battle 1 10', 'ja', 'Entrust', 'me', 'Entrust'},
  {'battle 1 11', 'ja', 'Full Circle', 'me', 'FullCirc'},
  {'battle 1 12', 'ja', 'Bolster', 'me', 'Bolster'},

  -- Hotbar #2: Geo bubbles.
  -- Debuffs on 'bt' (planted at battle target). Buffs on 'stpc'
  -- (planted at the selected party member, e.g. the tank).
  {'battle 2 1', 'ma', 'Geo-Frailty', 'bt', 'G.Frail'},
  {'battle 2 2', 'ma', 'Geo-Torpor', 'bt', 'G.Torpor'},
  {'battle 2 3', 'ma', 'Geo-Malaise', 'bt', 'G.Malaise'},
  {'battle 2 4', 'ma', 'Geo-Languor', 'bt', 'G.Languor'},
  {'battle 2 5', 'ma', 'Geo-Slow', 'bt', 'G.Slow'},
  {'battle 2 6', 'ma', 'Geo-Paralysis', 'bt', 'G.Para'},
  {'battle 2 7', 'ma', 'Geo-Vex', 'bt', 'G.Vex'},
  {'battle 2 8', 'ma', 'Geo-Haste', 'stpc', 'G.Haste'},
  {'battle 2 9', 'ma', 'Geo-Fury', 'stpc', 'G.Fury'},
  {'battle 2 10', 'ma', 'Geo-Refresh', 'stpc', 'G.Refresh'},
  {'battle 2 11', 'ma', 'Geo-Regen', 'stpc', 'G.Regen'},
  {'battle 2 12', 'ma', 'Geo-Barrier', 'stpc', 'G.Barrier'},
  -- 'stnpc' alternates if you prefer click-targeting debuff placement:
  -- {'battle 2 1', 'ma', 'Geo-Frailty', 'stnpc', 'G.Frail'},

  -- Hotbar #3: nukes (tier-shared slots), dark, utility.
  -- Same-slot rows demonstrate tiered slot sharing: the highest tier you
  -- know and can cast is the one shown.
  {'battle 3 1', 'ma', 'Stone V', 'bt', 'Stone'},
  {'battle 3 1', 'ma', 'Stone IV', 'bt', 'Stone'},
  {'battle 3 1', 'ma', 'Stone III', 'bt', 'Stone'},
  {'battle 3 1', 'ma', 'Stone II', 'bt', 'Stone'},
  {'battle 3 1', 'ma', 'Stone', 'bt', 'Stone'},
  {'battle 3 2', 'ma', 'Water IV', 'bt', 'Water'},
  {'battle 3 3', 'ma', 'Aero IV', 'bt', 'Aero'},
  {'battle 3 4', 'ma', 'Fire IV', 'bt', 'Fire'},
  {'battle 3 5', 'ma', 'Blizzard IV', 'bt', 'Blizzard'},
  {'battle 3 6', 'ma', 'Thunder IV', 'bt', 'Thunder'},
  {'battle 3 7', 'ma', 'Drain', 'bt', 'Drain'},
  {'battle 3 8', 'ma', 'Aspir', 'bt', 'Aspir'},
  {'battle 3 9', 'ma', 'Sleep II', 'stnpc', 'Sleep2'},
  {'battle 3 9', 'ma', 'Sleep', 'stnpc', 'Sleep'},
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
