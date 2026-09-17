-- multi-loader
-- repo: github.com/pui-enjoyer/multi-loader
-- credits to alaraks

local http = require("gamesense/http")
local ffi = require("ffi")

local repo = "pui-enjoyer/multi-loader"
local api_url = "https://api.github.com/repos/" .. repo .. "/contents/scripts"
local raw_url = "https://raw.githubusercontent.com/" .. repo .. "/main/scripts/"

local connected = true
local err_code = "404"
local last_update = globals.realtime()
local last_idx = 1
local click_time = 0
local click_idx = -1
local is_updating = false
local is_loading = true
local load_start = globals.realtime()

local scripts = {}
local script_urls = {}
local loaded = {}
local presets = (database and database.read and database.read("multi_loader_presets")) or {}

local active_preset = nil
if database and database.read then
    local ok, saved_p = pcall(database.read, "multi_loader_active_preset")
    if ok and type(saved_p) == "string" and #saved_p > 0 then
        active_preset = saved_p
    end
end

local current_items = {}

local build_list, update_list, update_visibility, toggle_preset, fetch_scripts, load_script, unload_script, check_autoload

local refresh = ui.new_button("config", "presets", "Refresh script list", function()
    fetch_scripts()
end)

local list = ui.new_listbox("config", "presets", " ", {""})
local info = ui.new_label("config", "presets", "Updated 0 seconds ago")
local reload = ui.new_checkbox("config", "presets", "Save scripts locally") -- save folder: %script%/multi-loader/

local default_scripts = {
    "luasensez.lua",
    "ultra mega exploits patcher.lua"
}

if database and database.read then
    local ok, cached = pcall(database.read, "multi_loader_cached_scripts")
    if ok and type(cached) == "table" then
        local seen = {}
        for _, s in ipairs(default_scripts) do seen[s] = true end
        for _, s in ipairs(cached) do
            if type(s) == "string" and s:find("%.lua$") and not seen[s] then
                table.insert(default_scripts, s)
                seen[s] = true
            end
        end
    end
end

local add = ui.new_multiselect("config", "presets", "\n", default_scripts)
ui.set(add, {})
local name = ui.new_textbox("config", "presets", "\n ")
ui.set(name, "")

if database and database.read then
    local ok, r = pcall(database.read, "multi_loader_save_locally")
    if ok and type(r) == "boolean" then
        ui.set(reload, r)
    end
end

local btn_load = ui.new_button("config", "presets", "Load script", function()
    local item = current_items[ui.get(list) + 1]
    if item and item.type == "script" then
        load_script(item.name)
    end
end)

local btn_unload = ui.new_button("config", "presets", "Unload script", function()
    local item = current_items[ui.get(list) + 1]
    if item and item.type == "script" then
        unload_script(item.name)
    end
end)

local btn_enable_autoload = ui.new_button("config", "presets", "Enable autoload", function()
    local item = current_items[ui.get(list) + 1]
    if item and item.type == "preset" then
        toggle_preset(item.data)
        update_list()
        update_visibility()
    end
end)

local btn_disable_autoload = ui.new_button("config", "presets", "Disable autoload", function()
    local item = current_items[ui.get(list) + 1]
    if item and item.type == "preset" and active_preset == item.name then
        toggle_preset(item.data)
        update_list()
        update_visibility()
    end
end)

local btn_delete_preset = ui.new_button("config", "presets", "Delete preset", function()
    local item = current_items[ui.get(list) + 1]
    if item and item.type == "preset" then
        if active_preset == item.name then
            toggle_preset(item.data)
        end
        for i, p in ipairs(presets) do
            if p.name == item.name then
                table.remove(presets, i)
                break
            end
        end
        if database and database.write then
            pcall(database.write, "multi_loader_presets", presets)
        end
        update_list()
        update_visibility()
    end
end)

local btn_create = ui.new_button("config", "presets", "Create autoload preset", function()
    local p_name = ui.get(name)
    local p_scripts = ui.get(add)
    if p_name == "" or #p_scripts == 0 then return end

    table.insert(presets, {name = p_name, scripts = p_scripts})
    if database and database.write then
        pcall(database.write, "multi_loader_presets", presets)
    end
    ui.set(name, "")
    ui.set(add, {})
    update_list()
    update_visibility()
end)

--social = ui.new_slider("config", "presets", "\n", 1, 2, 1, true, "", 1, {[1] = "Discord", [2] = "Telegram"})

function load_script(s_name)
    if loaded[s_name] then return end

    local url = script_urls[s_name] or (raw_url .. (s_name:gsub(" ", "%%20")))

    http.get(url, function(success, response)
        if not success or response.status ~= 200 then
            client.log("[multi-loader] Failed to download " .. s_name)
            return
        end

        if ui.get(reload) and writefile then
            pcall(writefile, "multi-loader/" .. s_name, response.body)
        end

        local loader = loadstring or load
        local fn, err = loader(response.body, s_name)
        if not fn then
            client.log("[multi-loader] Error: " .. tostring(err))
            return
        end

        pcall(fn)
        loaded[s_name] = true
        update_list()
        update_visibility()
    end)
end

function unload_script(s_name)
    if not loaded[s_name] then return end
    loaded[s_name] = nil
    update_list()
    update_visibility()
end

function toggle_preset(p)
    if not p then return end
    if active_preset == p.name then
        active_preset = nil
        for _, s in ipairs(p.scripts or {}) do
            unload_script(s)
        end
    else
        if active_preset then
            for _, prev_p in ipairs(presets) do
                if prev_p.name == active_preset then
                    for _, s in ipairs(prev_p.scripts or {}) do
                        unload_script(s)
                    end
                end
            end
        end

        active_preset = p.name
        for _, s in ipairs(p.scripts or {}) do
            load_script(s)
        end
    end

    if database and database.write then
        pcall(database.write, "multi_loader_active_preset", active_preset or "")
    end
end

function check_autoload()
    if not active_preset then return end
    local found = false
    for _, p in ipairs(presets) do
        if p.name == active_preset then
            found = true
            for _, s in ipairs(p.scripts or {}) do
                load_script(s)
            end
            break
        end
    end
    if not found then
        active_preset = nil
        if database and database.write then
            pcall(database.write, "multi_loader_active_preset", "")
        end
    end
end

function fetch_scripts()
    is_loading = true
    load_start = globals.realtime()
    update_list()
    update_visibility()

    http.get(api_url, function(success, response)
        last_update = globals.realtime()
        is_loading = false

        if not success or response.status ~= 200 then
            connected = false
            err_code = tostring(response.status or "404")
            check_autoload()
            update_list()
            update_visibility()
            return
        end

        local ok, data = pcall(json.parse, response.body)
        if not ok or type(data) ~= "table" then
            connected = false
            err_code = "404"
            check_autoload()
            update_list()
            update_visibility()
            return
        end

        connected = true
        scripts = {}
        script_urls = {}

        for _, item in ipairs(data) do
            if item.type == "file" and item.name and item.name:find("%.lua$") then
                table.insert(scripts, item.name)
                script_urls[item.name] = item.download_url
            end
        end

        if #scripts > 0 and database and database.write then
            pcall(database.write, "multi_loader_cached_scripts", scripts)
        end

        check_autoload()
        update_list()
        update_visibility()
    end)
end

function build_list()
    if not connected then
        current_items = {{type = "error"}}
        return {"Failed to connect: " .. err_code}
    end

    local display = {}
    current_items = {}

    table.insert(display, "\a57575770 --= SCRIPTS =--")
    table.insert(current_items, {type = "header"})

    if is_loading then
        local step = math.floor((globals.realtime() - load_start) / 0.25) % 3 + 1
        local dots = string.rep(".", step)
        table.insert(display, "\a808080FFLoading" .. dots)
        table.insert(current_items, {type = "loading"})
    else
        for _, s in ipairs(scripts) do
            local icon = loaded[s] and "\a909090FF◉  " or "\a808080FF○  "
            table.insert(display, icon .. "\abfbdbdFF" .. s)
            table.insert(current_items, {type = "script", name = s})
        end
    end

    table.insert(display, "\a57575770 --= AUTOLOAD =--")
    table.insert(current_items, {type = "header"})

    table.insert(display, "\a757575FF[+] New preset")
    table.insert(current_items, {type = "new_preset"})

    for _, p in ipairs(presets) do
        local icon = (active_preset == p.name) and "\a909090FF◉  " or "\a808080FF○  "
        table.insert(display, icon .. "\abfbdbdFF" .. p.name)
        table.insert(current_items, {type = "preset", name = p.name, data = p})
    end

    return display
end

function update_list()
    is_updating = true
    local display = build_list()
    ui.update(list, display)
    if last_idx and last_idx < #display then
        ui.set(list, last_idx)
    end
    is_updating = false
end

function update_visibility()
    local idx = ui.get(list)
    local item = current_items[idx + 1]

    if not connected or not item or is_loading then
        if not connected then
            ui.set(info, "Failed to connect: " .. err_code)
        elseif is_loading then
            local step = math.floor((globals.realtime() - load_start) / 0.25) % 3 + 1
            ui.set(info, "Loading" .. string.rep(".", step))
        end
        ui.set_visible(btn_load, true)
        ui.set_visible(btn_unload, false)
        ui.set_visible(btn_enable_autoload, false)
        ui.set_visible(btn_disable_autoload, false)
        ui.set_visible(btn_create, false)
        ui.set_visible(btn_delete_preset, false)
        ui.set_visible(add, false)
        ui.set_visible(name, false)
        return
    end

    local sec = math.floor(globals.realtime() - last_update)
    ui.set(info, string.format("Updated %d second%s ago", sec, sec == 1 and "" or "s"))

    local is_new = (item.type == "new_preset")
    local is_script = (item.type == "script")
    local is_preset = (item.type == "preset")

    ui.set_visible(btn_create, is_new)
    ui.set_visible(add, is_new)
    ui.set_visible(name, is_new and #ui.get(add) > 0)

    if is_new then
        ui.set_visible(btn_load, false)
        ui.set_visible(btn_unload, false)
        ui.set_visible(btn_enable_autoload, false)
        ui.set_visible(btn_disable_autoload, false)
        ui.set_visible(btn_delete_preset, false)
    elseif is_script and loaded[item.name] then
        ui.set_visible(btn_load, false)
        ui.set_visible(btn_unload, true)
        ui.set_visible(btn_enable_autoload, false)
        ui.set_visible(btn_disable_autoload, false)
        ui.set_visible(btn_delete_preset, false)
    elseif is_preset then
        local is_active = (active_preset == item.name)
        ui.set_visible(btn_enable_autoload, not is_active)
        ui.set_visible(btn_disable_autoload, is_active)
        ui.set_visible(btn_delete_preset, true)
        ui.set_visible(btn_load, false)
        ui.set_visible(btn_unload, false)
    else
        ui.set_visible(btn_load, true)
        ui.set_visible(btn_unload, false)
        ui.set_visible(btn_enable_autoload, false)
        ui.set_visible(btn_disable_autoload, false)
        ui.set_visible(btn_delete_preset, false)
    end
end

ui.set_callback(list, function()
    if is_updating then return end

    local idx = ui.get(list)
    local item = current_items[idx + 1]
    if not item then return end

    if item.type == "header" or item.type == "loading" or item.type == "error" then
        is_updating = true
        ui.set(list, last_idx)
        is_updating = false
        return
    end

    last_idx = idx

    local now = globals.realtime()
    if click_idx == idx and (now - click_time) < 0.5 then
        click_idx = -1
        click_time = 0

        if item.type == "script" then
            if loaded[item.name] then
                unload_script(item.name)
            else
                load_script(item.name)
            end
            return
        elseif item.type == "preset" then
            toggle_preset(item.data)
            update_list()
            update_visibility()
            return
        end
    else
        click_idx = idx
        click_time = now
    end

    update_visibility()
end)

ui.set_callback(add, function()
    local item = current_items[ui.get(list) + 1]
    if item and item.type == "new_preset" then
        ui.set_visible(name, #ui.get(add) > 0)
    end
end)

ui.set_callback(reload, function()
    if database and database.write then
        pcall(database.write, "multi_loader_save_locally", ui.get(reload))
    end
end)

local last_sec = -1
local last_step = -1
client.set_event_callback("paint_ui", function()
    if not ui.is_menu_open() then return end

    if is_loading then
        local step = math.floor((globals.realtime() - load_start) / 0.25) % 3 + 1
        if step ~= last_step then
            last_step = step
            update_list()
            ui.set(info, "Loading" .. string.rep(".", step))
        end
        return
    end

    if not connected then return end

    local sec = math.floor(globals.realtime() - last_update)
    if sec ~= last_sec then
        last_sec = sec
        ui.set(info, string.format("Updated %d second%s ago", sec, sec == 1 and "" or "s"))
    end
end)

update_list()
update_visibility()
fetch_scripts()