--[[
        Copyright © 2026, salt-mountain
        All rights reserved.

        Redistribution and use in source and binary forms, with or without
        modification, are permitted provided that the following conditions are met:

            * Redistributions of source code must retain the above copyright
              notice, this list of conditions and the following disclaimer.
            * Redistributions in binary form must reproduce the above copyright
              notice, this list of conditions and the following disclaimer in the
              documentation and/or other materials provided with the distribution.
            * Neither the name of the copyright holder nor the names of its
              contributors may be used to endorse or promote products derived
              from this software without specific prior written permission.

        THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
        ANY EXPRESS OR IMPLIED WARRANTIES ARE DISCLAIMED.
]]

-- bench.lua — in-game micro-benchmark harness for hot paths.
--
-- Usage from the addon command handler:
--   //htb bench start [warmup_frames]   begin collecting (default warmup 120)
--   //htb bench stop                    stop collecting (keeps samples)
--   //htb bench report                  print distribution stats per label
--   //htb bench reset                   drop all samples
--
-- Instrumentation pattern (zero work when inactive beyond one boolean test):
--   bench.enter('label')
--   ... code under test ...
--   bench.leave('label')
--
-- Design notes:
-- * socket.gettime() (LuaSocket, ships with Windower) gives wall-clock time
--   at microsecond-ish resolution; os.clock() is the fallback (CPU time,
--   coarser, still sub-frame). os.time() is NOT usable (1 s resolution).
-- * Samples are buffered in memory and only formatted on `report` — no disk
--   or chat I/O per frame (observer effect).
-- * A warmup window (in enter/leave pairs of the FIRST label started after
--   `start`) is discarded so cache-population after load/zone doesn't skew
--   the distribution.

local bench = {}

bench.active = false

local ok_socket, socket = pcall(require, 'socket')
local now
if ok_socket and socket and socket.gettime then
    now = socket.gettime
    bench.clock_source = 'socket.gettime'
else
    now = os.clock
    bench.clock_source = 'os.clock (fallback — CPU time, coarser)'
end

local samples = {}      -- label -> array of durations (seconds)
local open = {}         -- label -> start timestamp
local warmup_left = 0   -- frames (samples of the anchor label) to discard
local warmup_total = 0
local anchor_label = nil -- first label seen after start; drives warmup count

local FRAME_BUDGET_MS = 1000 / 60  -- 16.667 ms at 60 fps

function bench.start(warmup_frames)
    samples = {}
    open = {}
    anchor_label = nil
    warmup_total = tonumber(warmup_frames) or 120
    warmup_left = warmup_total
    bench.active = true
    return warmup_total, bench.clock_source
end

function bench.stop()
    bench.active = false
    open = {}
end

function bench.reset()
    samples = {}
    open = {}
    anchor_label = nil
    warmup_left = 0
end

function bench.enter(label)
    if not bench.active then return end
    open[label] = now()
end

function bench.leave(label)
    if not bench.active then return end
    local t0 = open[label]
    if t0 == nil then return end
    local dt = now() - t0
    open[label] = nil

    if anchor_label == nil then anchor_label = label end
    if warmup_left > 0 then
        if label == anchor_label then warmup_left = warmup_left - 1 end
        return -- discard warmup samples for ALL labels during the window
    end

    local s = samples[label]
    if s == nil then s = {} samples[label] = s end
    s[#s + 1] = dt
end

local function percentile(sorted, p)
    if #sorted == 0 then return 0 end
    local idx = math.ceil(#sorted * p)
    if idx < 1 then idx = 1 end
    if idx > #sorted then idx = #sorted end
    return sorted[idx]
end

-- Returns an array of printable lines (caller decides how to display).
function bench.report_lines()
    local lines = {}
    lines[#lines + 1] = string.format('bench: clock=%s, warmup=%d frames%s',
        bench.clock_source, warmup_total,
        bench.active and ' (collecting)' or ' (stopped)')

    local any = false
    for label, s in pairs(samples) do
        any = true
        local sorted = {}
        local sum = 0
        for i = 1, #s do sorted[i] = s[i]; sum = sum + s[i] end
        table.sort(sorted)

        local n    = #sorted
        local mean = (n > 0) and (sum / n) or 0
        local ms   = function(sec) return sec * 1000 end
        local pct  = function(sec) return (ms(sec) / FRAME_BUDGET_MS) * 100 end

        lines[#lines + 1] = string.format(
            '%s: n=%d | min %.3fms | mean %.3fms (%.1f%% of 16.7ms frame) | p50 %.3fms | p95 %.3fms (%.1f%%) | max %.3fms',
            label, n,
            ms(sorted[1] or 0),
            ms(mean), pct(mean),
            ms(percentile(sorted, 0.50)),
            ms(percentile(sorted, 0.95)), pct(percentile(sorted, 0.95)),
            ms(sorted[n] or 0))
    end
    if not any then
        lines[#lines + 1] = 'bench: no samples collected (is it started? past warmup?)'
    end
    return lines
end

return bench
