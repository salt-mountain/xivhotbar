--[[
        Copyright © 2020, Akirane, Technyze
        Copyright © 2026, salt-mountain
        All rights reserved.

        Redistribution and use in source and binary forms, with or without
        modification, are permitted provided that the following conditions are met:

            * Redistributions of source code must retain the above copyright
              notice, this list of conditions and the following disclaimer.
            * Redistributions in binary form must reproduce the above copyright
              notice, this list of conditions and the following disclaimer in the
              documentation and/or other materials provided with the distribution.
            * Neither the name of xivhotbar nor the
              names of its contributors may be used to endorse or promote products
              derived from this software without specific prior written permission.

        THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
        ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
        WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
        DISCLAIMED. IN NO EVENT SHALL SirEdeonX OR Akirane BE LIABLE FOR ANY
        DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
        (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
        LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
        ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
        (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
        SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]

local file_manager = {}
files = require('files')

local current_job_file_path = ""
local current_general_file_path = ""

local function starter_body(player_name, file_name, is_general)
    local notes =
        '-- ' .. file_name .. ' for ' .. player_name .. '\n' ..
        (is_general
            and '-- Actions shared by every job.\n'
             .. '-- Job specific LUA files (<JOB>.lua) hold actions for specific jobs.\n'
            or  '-- Actions for this job only. General.lua holds actions shared by every job.\n') ..
        '--\n' ..
        '-- Each line is one slot:\n' ..
        "--   {'environment hotbar slot', 'type', 'action', 'target', 'label', 'icon'}\n" ..
        '--\n' ..
        '--   environment: which page the action appears on\n' ..
        '--     valid options: battle, b, field, f\n' ..
        '--   type: the type of action you want to bind\n' ..
        '--     valid options: ma, ja, ws, ct, pet, input, macro, gs\n' ..
        '--   target: the target of the action you want to bind\n' ..
        '--     common options: me, t, bt, stpc, stnpc, or blank (any FFXI target works)\n' ..
        '--   label: optional. The short text shown on the slot. Blank if omitted\n' ..
        '--   icon: optional. A file name from images/icons/custom, without .png\n' ..
        '--\n'

    if is_general then
        return notes ..
            "-- Normally you would use the 'field' environment here;\n" ..
            '-- this is the General page, toggled with the backslash key by default.\n' ..
            '--\n' ..
            "-- Example:  {'field 1 1', 'input', '/lastsynth', '', 'Craft'},\n" ..
            '-- See data/examples/ for fuller layouts.\n\n' ..
            "xivhotbar_keybinds_general['Root'] = {\n" ..
            '}\n\n' ..
            'return xivhotbar_keybinds_general\n'
    end

    return notes ..
        "-- 'Base' holds your main job actions. You can also add blocks named\n" ..
        "-- after a subjob (['WHM']), a weapon type (['Sword']), or a pet or\n" ..
        "-- stance (['Carbuncle'], ['Light Arts']).\n" ..
        '--\n' ..
        "-- Example:  {'battle 1 1', 'ja', 'Berserk', 'me', 'Berserk'},\n" ..
        '-- See data/examples/ for fuller layouts.\n\n' ..
        "xivhotbar_keybinds_job['Base'] = {\n" ..
        '}\n\n' ..
        'return xivhotbar_keybinds_job\n'
end

-- Never touches an existing file; by then it is the user's.
function file_manager:ensure_hotbar_file(player_name, file_name, is_general)
    local relative_path = 'data/' .. player_name .. '/' .. file_name

    if windower.file_exists(windower.addon_path .. relative_path) then
        return true, nil
    end

    local target = files.new(relative_path, true)
    if target == nil then
        return false, 'could not create ' .. relative_path
    end

    -- Writing through the files library would emit its own "New file" notice.
    local ok, err = pcall(function()
        target:create_path()
        local handle = assert(io.open(windower.addon_path .. relative_path, 'w'))
        local written, write_err = handle:write(starter_body(player_name, file_name, is_general))
        local closed, close_err = handle:close()
        assert(written, write_err)
        assert(closed, close_err)
    end)

    if not ok then
        -- A partial file would look like an existing one next load.
        os.remove(windower.addon_path .. relative_path)
        return false, tostring(err)
    end

    return true, 'Created ' .. relative_path
end

function file_manager:ensure_character_files(player_name, player_job)
    local created = {}
    local failures = {}

    local wanted = {
        {name = player_job .. '.lua', general = false},
        {name = 'General.lua',        general = true},
    }

    for _, entry in ipairs(wanted) do
        local ok, message = self:ensure_hotbar_file(player_name, entry.name, entry.general)
        if not ok then
            table.insert(failures, message)
        elseif message ~= nil then
            table.insert(created, message)
        end
    end

    return created, failures
end




local function find_in_file_remove(file_path, action, row, slot, environment)

	local testAc = action.action:lower()
	local row_to_find = string.format('%s %d %d', environment, row, slot)
	local found_row = false
	local fileContent = {}
	local file = io.open(file_path , 'r')

	if (file ~= nil) then
		for line in file:lines() do
			table.insert (fileContent, line)
		end
		for key, val in pairs(fileContent) do
			if (val:contains(row_to_find)) then
				if (val:lower():contains(testAc)) then
					found_row = true
					fileContent[key] = '0'
					break
				elseif (val:contains("'gs'")) then
					local stripped_row = val:lower()
					i, j = string.find(stripped_row, '%[.*%]')
					k, l = string.find(testAc, '%[.*%]')
					local sub_row = string.sub(stripped_row, i+3, j-3)
					local sub_ac = string.sub(testAc, k+2, l-2)
					if sub_row == sub_ac then
						found_row = true
						fileContent[key] = '0'
						break
					end
				end
			end
		end
		if(found_row == true) then
			file = io.open(file_path, 'w')
			for index, value in ipairs(fileContent) do
				if (value ~= '0') then
					file:write(value..'\n')
				end
			end
			io.close(file)
		end
	end
	return found_row
end

local function write_swap(file_location, action, d_row, d_slot, s_row, s_slot, environment)

	local testAc = action.action:lower()
	local row_to_find = string.format('%s %d %d', environment, s_row, s_slot)
	local new_row = string.format('%s %d %d', environment, d_row, d_slot)
	local found_row = false
	local fileContent = {}
	local file = io.open(file_location , 'r')

	if (file ~= nil) then
		for line in file:lines() do
			table.insert (fileContent, line)
		end
		for key, val in pairs(fileContent) do
			if (val:contains(row_to_find)) then
				if (val:lower():contains(testAc)) then
					found_row = true
					val = string.gsub(val, "%w %d %d+", new_row)
					fileContent[key] = val
					break
				elseif string.find(val, "'%f[%a]gs%f[%A]'") and string.find(val, 'equip') then
					local stripped_row = val:lower()
					i, j = string.find(stripped_row, '%[.*%]')
					k, l = string.find(testAc, '%[.*%]')
					local sub_row = string.sub(stripped_row, i+3, j-3)
					local sub_ac = string.sub(testAc, k+2, l-2)
					if sub_row == sub_ac then
						found_row = true
						val = string.gsub(val, "%w %d %d+", new_row)
						fileContent[key] = val
						break
					end
				end
			end
		end
		if(found_row == true) then
			file = io.open(file_location, 'w')
			for index, value in ipairs(fileContent) do
				file:write(value..'\n')
			end
			io.close(file)
		end
	end
	return found_row
end


function file_manager:update_file_path(player_name, player_job)
	local basepath = windower.addon_path .. 'data/'..player_name..'/'
	local job_name = player_job
	current_job_file_path = basepath .. job_name .. '.lua'
	current_general_file_path = basepath .. "General.lua"
end





function file_manager:write_changes(action, d_row, d_slot, s_row, s_slot, environment)

	local found_row = write_swap(current_job_file_path, action, d_row, d_slot, s_row, s_slot, environment)

	if (found_row == false) then
		write_swap(current_general_file_path, action, d_row, d_slot, s_row, s_slot, environment)
	end
end

function file_manager:write_remove(action, row, slot, environment)

	local found_row = find_in_file_remove(current_job_file_path, action, row, slot, environment)

	if (found_row == false) then
		find_in_file_remove(current_general_file_path, action, row, slot, environment)
	end
end

return file_manager
