--[[
    Hotbar keybinds.

    Each row below maps keyboard keys to the slots of one hotbar row, in
    order: the first entry is slot 1, the second is slot 2, and so on.
    A slot with no key (or an empty string) simply isn't bound.

    Two rows are bound by default. They deliberately avoid:
      - letter keys, which can be used for movement depending on keyboard layout
      - the - and = keys, used for menus
      - CTRL+number and ALT+number, which are FFXI's two macro banks

    Uncomment the example rows below to bind more.
    **NOTE**: The number of rows actually bound is also limited by
    Hotbar/Style/HotbarCount in data/settings.xml, so raise that too
    if you add rows.

    Slots can hold more than spells and abilities: a slot can run any game
    command, a multi-step macro with waits, a GearSwap command, or another
    addon's command. See data/examples/General.lua for examples.

    Editing note: entries are positional. If you remove a key from the
    middle of a row, every key after it shifts up one slot. To leave a slot
    unbound while keeping the ones after it in place, use an empty string
    ('') rather than deleting the line.

    Modifier syntax: 'CTRL + 1', 'ALT + 1', 'SHIFT + 1'.
]]

keybinds = {

    -- Hotbar Row #1: number keys
    {
        '1',            -- Slot #1
        '2',            -- Slot #2
        '3',            -- Slot #3
        '4',            -- Slot #4
        '5',            -- Slot #5
        '6',            -- Slot #6
        '7',            -- Slot #7
        '8',            -- Slot #8
        '9',            -- Slot #9
        '0',            -- Slot #10
        '',             -- Slot #11 (unbound: - opens the game menu)
        '',             -- Slot #12 (unbound: = is used by the game)
    },

    -- Hotbar Row #2: shift + number keys
    {
        'SHIFT + 1',    -- Slot #1
        'SHIFT + 2',    -- Slot #2
        'SHIFT + 3',    -- Slot #3
        'SHIFT + 4',    -- Slot #4
        'SHIFT + 5',    -- Slot #5
        'SHIFT + 6',    -- Slot #6
        'SHIFT + 7',    -- Slot #7
        'SHIFT + 8',    -- Slot #8
        'SHIFT + 9',    -- Slot #9
        'SHIFT + 0',    -- Slot #10
        '',             -- Slot #11
        '',             -- Slot #12
    },

    -- Hotbar Row #3 example: CTRL + number keys.
    -- This takes over FFXI's CTRL macro bank. Fine if you're moving your
    -- macros into job files (a slot can hold a full multi-step macro), but
    -- your in-game CTRL macros will stop working while the addon is loaded.
    -- {
    --     'CTRL + 1', 'CTRL + 2', 'CTRL + 3', 'CTRL + 4', 'CTRL + 5', 'CTRL + 6',
    --     'CTRL + 7', 'CTRL + 8', 'CTRL + 9', 'CTRL + 0', '', '',
    -- },

    -- Hotbar Row #4 example: ALT + number keys.
    -- Same tradeoff as above, for FFXI's ALT macro bank.
    -- {
    --     'ALT + 1', 'ALT + 2', 'ALT + 3', 'ALT + 4', 'ALT + 5', 'ALT + 6',
    --     'ALT + 7', 'ALT + 8', 'ALT + 9', 'ALT + 0', '', '',
    -- },

    -- Hotbar Row #5 example: letter keys.
    -- Only do this if you do NOT move with WASD. On the default full-size
    -- keyboard layout these are movement keys, and binding them here means
    -- the game never sees them.
    -- {
    --     'Q', 'W', 'E', 'R', 'T', 'Y', 'A', 'S', 'D', 'F', 'G', 'H',
    -- },

    -- Hotbar Row #6 example: shift + letter keys.
    -- {
    --     'SHIFT + Q', 'SHIFT + W', 'SHIFT + E', 'SHIFT + R', 'SHIFT + T', 'SHIFT + Y',
    --     'SHIFT + A', 'SHIFT + S', 'SHIFT + D', 'SHIFT + F', 'SHIFT + G', 'SHIFT + H',
    -- },

}

return keybinds
