-- multi-loader
-- repo: github.com/pui-enjoyer/multi-loader
-- credits to alaraks

local http = require("gamesense/http")
local ffi = require("ffi")
local pui = require("gamesense/pui")

local function ensure_dir(path)
    pcall(function()
        local fs_ptr = client.create_interface("filesystem_stdio.dll", "VFileSystem017")
        if fs_ptr then
            local fs = ffi.cast("void***", fs_ptr)
            local create_dir = ffi.cast("void(__thiscall*)(void*, const char*, const char*)", fs[0][22])
            create_dir(fs, path, nil)
        end
    end)
end
ensure_dir("multi-loader")

local readfile = rawget(_G, "readfile")
local writefile = rawget(_G, "writefile")

if not readfile or not writefile then
    pcall(function()
        local base_fs_ptr = client.create_interface("filesystem_stdio.dll", "VBaseFileSystem011")
        if base_fs_ptr then
            local base_fs = ffi.cast("void***", base_fs_ptr)
            local base_vtbl = base_fs[0]
            local v_open = ffi.cast("void* (__thiscall*)(void*, const char*, const char*, const char*)", base_vtbl[2])
            local v_close = ffi.cast("void (__thiscall*)(void*, void*)", base_vtbl[3])
            local v_read = ffi.cast("int (__thiscall*)(void*, void*, int, void*)", base_vtbl[0])
            local v_write = ffi.cast("int (__thiscall*)(void*, const void*, int, void*)", base_vtbl[1])
            local v_size = ffi.cast("unsigned int (__thiscall*)(void*, void*)", base_vtbl[7])

            if not readfile then
                readfile = function(path)
                    local handle = v_open(base_fs, path, "r", nil)
                    if handle == nil or handle == ffi.cast("void*", 0) then return nil end
                    local size = tonumber(v_size(base_fs, handle))
                    local buf = ffi.new("char[?]", size + 1)
                    v_read(base_fs, buf, size, handle)
                    v_close(base_fs, handle)
                    return ffi.string(buf, size)
                end
            end

            if not writefile then
                writefile = function(path, data)
                    local handle = v_open(base_fs, path, "w", nil)
                    if handle == nil or handle == ffi.cast("void*", 0) then return false end
                    local str = tostring(data)
                    v_write(base_fs, str, #str, handle)
                    v_close(base_fs, handle)
                    return true
                end
            end
        end
    end)
end

pcall(ffi.cdef, [[
    typedef struct {
        uint32_t dwLowDateTime;
        uint32_t dwHighDateTime;
    } multiloader_FILETIME;

    typedef struct {
        uint32_t dwFileAttributes;
        multiloader_FILETIME ftCreationTime;
        multiloader_FILETIME ftLastAccessTime;
        multiloader_FILETIME ftLastWriteTime;
        uint32_t nFileSizeHigh;
        uint32_t nFileSizeLow;
    } multiloader_WIN32_FILE_ATTRIBUTE_DATA;

    int __stdcall GetFileAttributesExA(const char* lpFileName, int fInfoLevelId, void* lpFileInformation);
]])

local function get_current_unix_time()
    if client and client.unix_time then
        local ok, t = pcall(client.unix_time)
        if ok and t and t > 0 then return t end
    end
    if client and client.timestamp then
        local ok, ms = pcall(client.timestamp)
        if ok and ms and ms > 0 then return math.floor(ms / 1000) end
    end
    if os and os.time then
        local ok, t = pcall(os.time)
        if ok and t and t > 0 then return t end
    end
    return globals.realtime()
end

local function parse_iso8601(str)
    if type(str) ~= "string" then return nil end
    local y, m, d, h, mi, s = str:match("(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)")
    if not y then return nil end
    y, m, d, h, mi, s = tonumber(y), tonumber(m), tonumber(d), tonumber(h), tonumber(mi), tonumber(s)
    if not y or not m or not d or not h or not mi or not s then return nil end

    local days_before_month = {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334}
    local days = (y - 1970) * 365 + math.floor((y - 1969) / 4) - math.floor((y - 1901) / 100) + math.floor((y - 1601) / 400)
    days = days + days_before_month[m] + (d - 1)
    local is_leap = (y % 4 == 0 and (y % 100 ~= 0 or y % 400 == 0))
    if is_leap and m > 2 then
        days = days + 1
    end
    return days * 86400 + h * 3600 + mi * 60 + s
end

local function get_file_modification_time(s_name)
    local paths = {
        "multi-loader/" .. s_name,
        "csgo/multi-loader/" .. s_name,
        s_name,
        "csgo/" .. s_name
    }
    for _, path in ipairs(paths) do
        local ok, res = pcall(function()
            local d = ffi.new("multiloader_WIN32_FILE_ATTRIBUTE_DATA")
            if ffi.C.GetFileAttributesExA(path, 0, d) ~= 0 then
                local high = ffi.cast("uint64_t", d.ftLastWriteTime.dwHighDateTime)
                local low = ffi.cast("uint64_t", d.ftLastWriteTime.dwLowDateTime)
                if high > 0ULL or low > 0ULL then
                    local ft = high * 4294967296ULL + low
                    if ft > 116444736000000000ULL then
                        return tonumber((ft - 116444736000000000ULL) / 10000000ULL)
                    end
                end
            end
            return nil
        end)
        if ok and res then
            return res
        end
    end
    return nil
end

local menu_color_ref = ui.reference("MISC", "Settings", "Menu color")
local last_accent_hex = nil

local function get_accent_hex()
    if menu_color_ref then
        local ok, r, g, b, a = pcall(ui.get, menu_color_ref)
        if ok and r and g and b then
            return string.format("\a%02X%02X%02X%02X", r, g, b, a or 255)
        end
    end
    return "\a909090FF"
end

local function url_encode(str)
    if not str then return "" end
    return (str:gsub("([^%w%-%_%.~])", function(c)
        return string.format("%%%02X", string.byte(c))
    end))
end

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
local script_meta = {}
local loaded = {}
local script_load_times = {}
local script_unload_times = {}
local script_file_times = {}
local preset_load_times = {}
local preset_unload_times = {}
local presets = (database and database.read and database.read("multi_loader_presets")) or {}

for _, p in ipairs(presets) do
    if not p.updated_at and database and database.read then
        p.updated_at = database.read("multi_loader_preset_updated_" .. p.name)
    end
end

if database and database.read then
    local ok_meta, cached_meta = pcall(database.read, "multi_loader_cached_meta")
    if ok_meta and type(cached_meta) == "table" then
        script_meta = cached_meta
    end
end

local repo_scripts_updated_at = nil

local active_preset = nil
if database and database.read then
    local ok, saved_p = pcall(database.read, "multi_loader_active_preset")
    if ok and type(saved_p) == "string" and #saved_p > 0 then
        active_preset = saved_p
    end
    local ok_r, saved_r = pcall(database.read, "multi_loader_repo_time")
    if ok_r and type(saved_r) == "number" and saved_r > 0 then
        repo_scripts_updated_at = saved_r
    end
    local ok_s, cached_s = pcall(database.read, "multi_loader_cached_scripts")
    if ok_s and type(cached_s) == "table" and #cached_s > 0 then
        scripts = cached_s
    end
end

local current_items = {}

local build_list, update_list, update_visibility, toggle_preset, fetch_scripts, load_script, unload_script, check_autoload

local menu = pui.group("config", "presets")

local refresh = menu:button("Refresh script list", function()
    fetch_scripts()
end)

local list = menu:listbox(" ", {""})
local info = menu:label("Updated 0 seconds ago")
local reload = menu:checkbox("Save scripts locally") -- save folder: %script%/multi-loader/

local default_scripts = {}

if database and database.read then
    local ok, cached = pcall(database.read, "multi_loader_cached_scripts")
    if ok and type(cached) == "table" then
        for _, s in ipairs(cached) do
            if type(s) == "string" and s:find("%.lua$") then
                table.insert(default_scripts, s)
            end
        end
    end
end

local add = menu:multiselect("\n", default_scripts)
add:set({})
local name = menu:textbox("\n ")
name:set("")

if database and database.read then
    local ok, r = pcall(database.read, "multi_loader_save_locally")
    if ok and type(r) == "boolean" then
        reload:set(r)
    end
end

local btn_load_script = menu:button("Load script", function()
    local item = current_items[list:get() + 1]
    if item and item.type == "script" then
        client.delay_call(0, function()
            load_script(item.name)
        end)
    end
end)

local btn_unload_script = menu:button("Unload script", function()
    local item = current_items[list:get() + 1]
    if item and item.type == "script" then
        client.delay_call(0, function()
            unload_script(item.name)
        end)
    end
end)

local is_setting_preset_scripts = false

local edit_preset_scripts = menu:multiselect("\n", default_scripts)
edit_preset_scripts:set({})
edit_preset_scripts:set_visible(false)

edit_preset_scripts:set_callback(function()
    if is_updating or is_setting_preset_scripts then return end
    local item = current_items[list:get() + 1]
    if item and item.type == "preset" and item.data then
        local new_scripts = edit_preset_scripts:get() or {}
        local old_scripts = item.data.scripts or {}
        item.data.scripts = new_scripts
        local now_unix = get_current_unix_time()
        item.data.updated_at = now_unix

        for i, p in ipairs(presets) do
            if p.name == item.name then
                p.scripts = new_scripts
                p.updated_at = now_unix
                break
            end
        end

        if database and database.write then
            pcall(database.write, "multi_loader_presets", presets)
            pcall(database.write, "multi_loader_preset_updated_" .. item.name, now_unix)
            if database.flush then pcall(database.flush) end
        end

        if active_preset == item.name then
            local active_set = {}
            for _, s in ipairs(new_scripts) do
                active_set[s] = true
                if not loaded[s] then
                    load_script(s, true)
                end
            end
            for _, s in ipairs(old_scripts) do
                if not active_set[s] and loaded[s] then
                    unload_script(s, true)
                end
            end
            update_list()
        end
    end
end)

local btn_load_preset = menu:button("Load preset", function()
    local item = current_items[list:get() + 1]
    if item and item.type == "preset" then
        if active_preset ~= item.name then
            client.delay_call(0, function()
                toggle_preset(item.data)
            end)
        end
    end
end)

local btn_unload_preset = menu:button("Unload preset", function()
    local item = current_items[list:get() + 1]
    if item and item.type == "preset" then
        if active_preset == item.name then
            client.delay_call(0, function()
                toggle_preset(item.data)
            end)
        end
    end
end)

local btn_delete_preset = menu:button("Delete preset", function()
    local item = current_items[list:get() + 1]
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
            pcall(database.write, "multi_loader_preset_updated_" .. item.name, nil)
            if database.flush then pcall(database.flush) end
        end
        for idx, it in ipairs(current_items) do
            if it.type == "new_preset" then
                last_idx = idx - 1
                list:set(last_idx)
                break
            end
        end
        update_list()
    end
end)

local spacer1 = menu:label("\n")
local spacer2 = menu:label("\n ")
local spacer3 = menu:label("\n  ")
local spacer4 = menu:label("\n   ")
spacer1:set_visible(false)
spacer2:set_visible(false)
spacer3:set_visible(false)
spacer4:set_visible(false)

local btn_create = menu:button("Create autoload preset", function()
    local p_name = name:get()
    local p_scripts = add:get()
    if p_name == "" or #p_scripts == 0 then return end

    local now_unix = get_current_unix_time()
    local found = false
    for _, p in ipairs(presets) do
        if p.name == p_name then
            p.scripts = p_scripts
            p.updated_at = now_unix
            found = true
            break
        end
    end
    if not found then
        table.insert(presets, {name = p_name, scripts = p_scripts, updated_at = now_unix})
    end

    if database and database.write then
        pcall(database.write, "multi_loader_presets", presets)
        pcall(database.write, "multi_loader_preset_updated_" .. p_name, now_unix)
        if database.flush then pcall(database.flush) end
    end
    name:set("")
    add:set({})
    update_list()
end)



local function count_lines(str)
    if type(str) ~= "string" or #str == 0 then return 0 end
    local count = 1
    for _ in str:gmatch("\n") do
        count = count + 1
    end
    return count
end

local function execute_chunk(body, s_name, silent)
    if type(body) ~= "string" then
        loaded[s_name] = nil
        if not silent then
            update_list()
            update_visibility()
        end
        return false
    end

    if body:sub(1, 3) == "\xEF\xBB\xBF" then
        body = body:sub(4)
    end

    local loader = loadstring or load
    local fn, err = loader(body, s_name)
    if not fn then
        client.log("[multi-loader] Error: " .. tostring(err))
        loaded[s_name] = nil
        if not silent then
            update_list()
        end
        return false
    end

    local ok, runtime_err = pcall(fn)
    if not ok then
        client.log("[multi-loader] Runtime error in " .. s_name .. ": " .. tostring(runtime_err))
        loaded[s_name] = nil
        if not silent then
            update_list()
        end
        return false
    end

    loaded[s_name] = true
    script_load_times[s_name] = globals.realtime()
    if not silent then
        update_list()
    end
    return true
end

local function http_get_script(s_name, cb)
    local j_url = "https://cdn.jsdelivr.net/gh/" .. repo .. "@main/scripts/" .. url_encode(s_name)
    local r_url = raw_url .. url_encode(s_name)
    local primary_url = script_urls[s_name] or j_url

    http.get(primary_url, function(success, response)
        if success and response.status == 200 then
            cb(true, response)
        else
            local fallback_url = (primary_url == j_url) and r_url or j_url
            http.get(fallback_url, function(f_success, f_response)
                if f_success and f_response.status == 200 then
                    cb(true, f_response)
                else
                    cb(false, response or f_response)
                end
            end)
        end
    end)
end

function load_script(s_name, silent)
    if loaded[s_name] then return end

    loaded[s_name] = true
    if not silent then
        update_list()
    end

    local save_locally = reload:get()
    local meta = script_meta[s_name]

    local local_content = nil
    local normalized_local = nil
    if readfile then
        local ok, content = pcall(readfile, "multi-loader/" .. s_name)
        if ok and type(content) == "string" and #content > 0 then
            local_content = content
            normalized_local = content:gsub("\r\n", "\n")
        end
    end

    if save_locally then
        if local_content and normalized_local then
            local local_size = #normalized_local
            local local_lines = count_lines(normalized_local)
            local is_different = false

            if meta then
                local remote_size = meta.size
                local saved_sha = database and database.read and database.read("multi_loader_sha_" .. s_name)
                local saved_lines = database and database.read and database.read("multi_loader_lines_" .. s_name)

                if remote_size and local_size ~= remote_size then
                    is_different = true
                elseif meta.sha and saved_sha and saved_sha ~= meta.sha then
                    is_different = true
                elseif saved_lines and local_lines ~= saved_lines then
                    is_different = true
                end
            end

            if is_different then
                client.log(string.format("[multi-loader] %s differs on repo, updating local copy...", s_name))
                http_get_script(s_name, function(success, response)
                    if success and response.status == 200 then
                        local new_lines = count_lines(response.body)
                        ensure_dir("multi-loader")
                        if writefile then
                            pcall(writefile, "multi-loader/" .. s_name, response.body)
                        end
                        local now_unix = get_current_unix_time()
                        script_file_times[s_name] = now_unix
                        if database and database.write then
                            if meta and meta.sha then
                                pcall(database.write, "multi_loader_sha_" .. s_name, meta.sha)
                            end
                            pcall(database.write, "multi_loader_size_" .. s_name, #response.body)
                            pcall(database.write, "multi_loader_lines_" .. s_name, new_lines)
                            pcall(database.write, "multi_loader_updated_" .. s_name, now_unix)
                            if database.flush then pcall(database.flush) end
                        end
                        client.log(string.format("[multi-loader] Updated %s locally and loaded (%d bytes, %d lines)", s_name, #response.body, new_lines))
                        execute_chunk(response.body, s_name, silent)
                    else
                        client.log(string.format("[multi-loader] Failed to update %s from repo, loading local copy", s_name))
                        if local_content then
                            execute_chunk(local_content, s_name, silent)
                        else
                            loaded[s_name] = nil
                            if not silent then
                                update_list()
                            end
                        end
                    end
                end)
                return
            else
                client.log(string.format("[multi-loader] Prioritizing local %s (%d bytes, %d lines)", s_name, local_size, local_lines))
                execute_chunk(local_content, s_name, silent)
                return
            end
        else
            client.log(string.format("[multi-loader] Downloading %s to local storage...", s_name))
            http_get_script(s_name, function(success, response)
                if not success or response.status ~= 200 then
                    client.log("[multi-loader] Failed to download " .. s_name)
                    loaded[s_name] = nil
                    if not silent then
                        update_list()
                    end
                    return
                end

                local new_lines = count_lines(response.body)
                ensure_dir("multi-loader")
                if writefile then
                    pcall(writefile, "multi-loader/" .. s_name, response.body)
                end
                local now_unix = get_current_unix_time()
                script_file_times[s_name] = now_unix
                if database and database.write then
                    if meta and meta.sha then
                        pcall(database.write, "multi_loader_sha_" .. s_name, meta.sha)
                    end
                    pcall(database.write, "multi_loader_size_" .. s_name, #response.body)
                    pcall(database.write, "multi_loader_lines_" .. s_name, new_lines)
                    pcall(database.write, "multi_loader_updated_" .. s_name, now_unix)
                    if database.flush then pcall(database.flush) end
                end
                client.log(string.format("[multi-loader] Saved %s locally and loaded (%d bytes, %d lines)", s_name, #response.body, new_lines))
                execute_chunk(response.body, s_name, silent)
            end)
            return
        end
    else
        http_get_script(s_name, function(success, response)
            if success and response.status == 200 then
                execute_chunk(response.body, s_name, silent)
            elseif local_content then
                client.log(string.format("[multi-loader] Remote fetch failed, fallback to local %s", s_name))
                execute_chunk(local_content, s_name, silent)
            else
                client.log("[multi-loader] Failed to download " .. s_name)
                loaded[s_name] = nil
                if not silent then
                    update_list()
                end
            end
        end)
    end
end

function unload_script(s_name, silent)
    if not loaded[s_name] then return end
    loaded[s_name] = nil
    script_unload_times[s_name] = globals.realtime()
    if not silent then
        update_list()
    end
end

function toggle_preset(p)
    if not p then return end
    if active_preset == p.name then
        active_preset = nil
        preset_unload_times[p.name] = globals.realtime()
        for _, s in ipairs(p.scripts or {}) do
            unload_script(s, true)
        end
    else
        if active_preset then
            preset_unload_times[active_preset] = globals.realtime()
            for _, prev_p in ipairs(presets) do
                if prev_p.name == active_preset then
                    for _, s in ipairs(prev_p.scripts or {}) do
                        unload_script(s, true)
                    end
                end
            end
        end

        active_preset = p.name
        preset_load_times[p.name] = globals.realtime()
        for _, s in ipairs(p.scripts or {}) do
            load_script(s, true)
        end
    end

    if database and database.write then
        pcall(database.write, "multi_loader_active_preset", active_preset or "")
        if database.flush then pcall(database.flush) end
    end
    update_list()
end

function check_autoload()
    if not active_preset then return end
    local found = false
    for _, p in ipairs(presets) do
        if p.name == active_preset then
            found = true
            preset_load_times[p.name] = globals.realtime()
            for _, s in ipairs(p.scripts or {}) do
                load_script(s, true)
            end
            update_list()
            break
        end
    end
    if not found then
        active_preset = nil
        if database and database.write then
            pcall(database.write, "multi_loader_active_preset", "")
            if database.flush then pcall(database.flush) end
        end
    end
end

local function finish_fetch_scripts()
    if #scripts > 0 and database and database.write then
        pcall(database.write, "multi_loader_cached_scripts", scripts)
        pcall(database.write, "multi_loader_cached_meta", script_meta)
        if database.flush then pcall(database.flush) end
    end

    if #scripts > 0 then
        pcall(ui.update, add.ref, scripts)
        pcall(ui.update, edit_preset_scripts.ref, scripts)

        local valid_map = {}
        local norm_map = {}
        for _, s in ipairs(scripts) do
            valid_map[s] = true
            local norm = s:gsub("%b[]", ""):gsub("%s+", ""):lower()
            norm_map[norm] = s
        end
        for _, p in ipairs(presets) do
            if p.scripts then
                local clean = {}
                for _, s in ipairs(p.scripts) do
                    if valid_map[s] then
                        table.insert(clean, s)
                    else
                        local norm = s:gsub("%b[]", ""):gsub("%s+", ""):lower()
                        if norm_map[norm] then
                            table.insert(clean, norm_map[norm])
                        end
                    end
                end
                p.scripts = clean
            end
        end
        local cur_add = add:get()
        if type(cur_add) == "table" and #cur_add > 0 then
            local clean_add = {}
            for _, s in ipairs(cur_add) do
                if valid_map[s] then
                    table.insert(clean_add, s)
                else
                    local norm = s:gsub("%b[]", ""):gsub("%s+", ""):lower()
                    if norm_map[norm] then
                        table.insert(clean_add, norm_map[norm])
                    end
                end
            end
            add:set(clean_add)
        end
    end

    check_autoload()
    update_list()
end

function fetch_scripts()
    is_loading = true
    load_start = globals.realtime()
    update_list()

    local function parse_jsdelivr_response(body)
        local ok_parse, j_data = pcall(json.parse, body)
        if ok_parse and type(j_data) == "table" and type(j_data.files) == "table" then
            local found_scripts = {}
            local found_urls = {}
            local found_meta = {}

            for _, item in ipairs(j_data.files) do
                if item.name then
                    local s_name = item.name:match("^/scripts/(.+%.lua)$")
                    if s_name then
                        table.insert(found_scripts, s_name)
                        local d_url = "https://cdn.jsdelivr.net/gh/" .. repo .. "@main/scripts/" .. url_encode(s_name)
                        found_urls[s_name] = d_url
                        found_meta[s_name] = {
                            size = item.size,
                            sha = item.hash,
                            url = d_url,
                            updated_at = nil
                        }
                    end
                end
            end

            if #found_scripts > 0 then
                last_update = globals.realtime()
                is_loading = false
                connected = true
                scripts = found_scripts
                script_urls = found_urls
                script_meta = found_meta
                finish_fetch_scripts()
                return true
            end
        end
        return false
    end

    local function fetch_via_github()
        http.get(api_url, function(success, response)
            last_update = globals.realtime()
            is_loading = false

            if success and response.status == 200 then
                local ok, data = pcall(json.parse, response.body)
                if ok and type(data) == "table" then
                    connected = true
                    scripts = {}
                    script_urls = {}
                    script_meta = {}

                    for _, item in ipairs(data) do
                        if item.type == "file" and item.name and item.name:find("%.lua$") then
                            table.insert(scripts, item.name)
                            script_urls[item.name] = item.download_url

                            local cached_time = nil
                            if database and database.read then
                                local saved_sha = database.read("multi_loader_github_sha_" .. item.name)
                                if saved_sha == item.sha then
                                    cached_time = database.read("multi_loader_github_time_" .. item.name)
                                end
                            end

                            script_meta[item.name] = {
                                size = item.size,
                                sha = item.sha,
                                url = item.download_url,
                                updated_at = cached_time
                            }
                        end
                    end

                    if #scripts > 0 then
                        finish_fetch_scripts()
                        return
                    end
                end
            end

            connected = false
            err_code = "Offline"
            if #scripts == 0 and #default_scripts > 0 then
                scripts = default_scripts
            end
            check_autoload()
            update_list()
        end)
    end

    local function fetch_via_jsdelivr(sha)
        local endpoint = sha and ("https://data.jsdelivr.com/v1/package/gh/" .. repo .. "@" .. sha .. "/flat")
            or ("https://data.jsdelivr.com/v1/package/gh/" .. repo .. "@main/flat")
        http.get(endpoint, function(j_ok, j_resp)
            if j_ok and j_resp.status == 200 and parse_jsdelivr_response(j_resp.body) then
                return
            end
            if sha then
                http.get("https://data.jsdelivr.com/v1/package/gh/" .. repo .. "@main/flat", function(m_ok, m_resp)
                    if m_ok and m_resp.status == 200 and parse_jsdelivr_response(m_resp.body) then
                        return
                    end
                    fetch_via_github()
                end)
            else
                fetch_via_github()
            end
        end)
    end

    local atom_url = "https://github.com/" .. repo .. "/commits/main.atom"
    http.get(atom_url, function(a_ok, a_resp)
        if a_ok and a_resp.status == 200 and type(a_resp.body) == "string" then
            local sha = a_resp.body:match("<id>tag:github%.com,2008:Grit::Commit/([a-f0-9]+)</id>")
            local updated_iso = a_resp.body:match("<updated>(%d+-%d+-%d+T%d+:%d+:%d+Z)</updated>")
            if updated_iso then
                local t_unix = parse_iso8601(updated_iso)
                if t_unix then
                    repo_scripts_updated_at = t_unix
                    if database and database.write then
                        pcall(database.write, "multi_loader_repo_time", t_unix)
                        if database.flush then pcall(database.flush) end
                    end
                end
            end
            if sha and #sha >= 7 then
                fetch_via_jsdelivr(sha)
                return
            end
        end
        fetch_via_jsdelivr(nil)
    end)
end

function build_list()
    if not connected and #scripts == 0 then
        current_items = {{type = "error"}}
        return {"Failed to connect: " .. err_code}
    end

    local display = {}
    current_items = {}

    local header_text = connected and "\a57575770 --= SCRIPTS =--" or "\a57575770 --= SCRIPTS (OFFLINE) =--"
    table.insert(display, header_text)
    table.insert(current_items, {type = "header"})

    if is_loading and #scripts == 0 then
        table.insert(display, "\a808080FFLoading...")
        table.insert(current_items, {type = "loading"})
    else
        local accent_hex = get_accent_hex()
        for _, s in ipairs(scripts) do
            local is_on = not not loaded[s]
            local display_name = s:gsub("%.lua$", "")
            local color = is_on and accent_hex or "\aC8C8C8FF"

            local item_text
            local rest, tag = display_name:match("^(.-)%s*(%b[])$")
            if tag and #rest > 0 then
                item_text = string.format("%s%s %s%s", color, rest, accent_hex, tag)
            else
                local l_tag, l_rest = display_name:match("^(%b[])%s*(.*)$")
                if l_tag and #l_rest > 0 then
                    item_text = string.format("%s%s %s%s", color, l_rest, accent_hex, l_tag)
                else
                    item_text = color .. display_name
                end
            end

            table.insert(display, item_text)
            table.insert(current_items, {type = "script", name = s})
        end
    end

    table.insert(display, "\a57575770 --= AUTOLOAD =--")
    table.insert(current_items, {type = "header"})

    table.insert(display, "\a757575FF[+] New preset")
    table.insert(current_items, {type = "new_preset"})

    local accent_hex = get_accent_hex()
    for _, p in ipairs(presets) do
        local is_active = (active_preset == p.name)
        local display_name = p.name:gsub("%.lua$", "")
        local color = is_active and accent_hex or "\aC8C8C8FF"

        local item_text
        local rest, tag = display_name:match("^(.-)%s*(%b[])$")
        if tag and #rest > 0 then
            item_text = string.format("%s%s %s%s", color, rest, accent_hex, tag)
        else
            local l_tag, l_rest = display_name:match("^(%b[])%s*(.*)$")
            if l_tag and #l_rest > 0 then
                item_text = string.format("%s%s %s%s", color, l_rest, accent_hex, l_tag)
            else
                item_text = color .. display_name
            end
        end

        table.insert(display, item_text)
        table.insert(current_items, {type = "preset", name = p.name, data = p})
    end

    return display
end

function update_list()
    is_updating = true
    local display = build_list()
    list:update(display)

    local cur = list:get()
    local cur_item = current_items[cur + 1]
    if not cur_item or cur_item.type == "header" or cur_item.type == "loading" then
        local target_idx = nil
        if last_idx and current_items[last_idx + 1] and current_items[last_idx + 1].type ~= "header" and current_items[last_idx + 1].type ~= "loading" then
            target_idx = last_idx
        else
            for i, it in ipairs(current_items) do
                if it.type == "script" then
                    target_idx = i - 1
                    break
                end
            end
            if not target_idx then
                for i, it in ipairs(current_items) do
                    if it.type == "preset" or it.type == "new_preset" then
                        target_idx = i - 1
                        break
                    end
                end
            end
        end
        if target_idx then
            last_idx = target_idx
            list:set(target_idx)
        end
    end

    is_updating = false
    update_visibility()
end

local function format_ago(prefix, t)
    if not t then return "Not updated" end
    local now = get_current_unix_time()
    local sec
    if t > 1000000000 then
        sec = math.max(0, math.floor(now - t))
    else
        sec = math.max(0, math.floor(globals.realtime() - t))
    end

    if sec < 60 then
        return string.format("%s %d second%s ago", prefix, sec, sec == 1 and "" or "s")
    elseif sec < 3600 then
        local m = math.floor(sec / 60)
        return string.format("%s %d minute%s ago", prefix, m, m == 1 and "" or "s")
    elseif sec < 86400 then
        local h = math.floor(sec / 3600)
        return string.format("%s %d hour%s ago", prefix, h, h == 1 and "" or "s")
    else
        local d = math.floor(sec / 86400)
        return string.format("%s %d day%s ago", prefix, d, d == 1 and "" or "s")
    end
end

local function get_info_text()
    if is_loading then
        local step = math.floor((globals.realtime() - load_start) / 0.25) % 3 + 1
        return "Loading" .. string.rep(".", step)
    end

    if not connected and #scripts == 0 then
        return "Failed to connect: " .. err_code
    end

    local idx = list:get()
    local item = current_items[idx + 1]

    if not item then
        if not connected then
            return "Offline mode (" .. err_code .. ")"
        end
        return format_ago("Updated", last_update)
    end

    if item.type == "script" then
        local file_time = nil
        if script_meta[item.name] and script_meta[item.name].updated_at then
            file_time = script_meta[item.name].updated_at
        elseif database and database.read then
            file_time = database.read("multi_loader_github_time_" .. item.name)
        end
        if not file_time then
            file_time = get_file_modification_time(item.name)
        end
        if not file_time and database and database.read then
            file_time = database.read("multi_loader_updated_" .. item.name)
        end
        if not file_time then
            file_time = repo_scripts_updated_at
        end
        if not file_time and database and database.read then
            file_time = database.read("multi_loader_repo_time")
        end
        if not file_time then
            file_time = script_file_times[item.name]
        end
        if file_time then
            return format_ago("Updated", file_time)
        elseif is_loading then
            return "Checking update time..."
        else
            return "Not updated"
        end
    elseif item.type == "preset" then
        local p = item.data
        local t = (p and p.updated_at)
        if not t and database and database.read then
            t = database.read("multi_loader_preset_updated_" .. item.name)
        end
        if t then
            return format_ago("Updated", t)
        else
            return "Not updated"
        end
    elseif item.type == "new_preset" then
        return "Auto-loads selected scripts"
    else
        if not connected then
            return "Offline mode (" .. err_code .. ")"
        end
        return format_ago("Updated", last_update)
    end
end

function update_visibility()
    local idx = list:get()
    local item = current_items[idx + 1]

    if item and (item.type == "header" or item.type == "loading" or item.type == "error") then
        if last_idx and current_items[last_idx + 1] and current_items[last_idx + 1].type ~= "header" then
            idx = last_idx
            item = current_items[idx + 1]
        end
    end

    if not item or item.type == "error" then
        info:set("Failed to connect: " .. err_code)
        btn_load_script:set_visible(false)
        btn_unload_script:set_visible(false)
        btn_load_preset:set_visible(false)
        btn_unload_preset:set_visible(false)
        btn_delete_preset:set_visible(false)
        edit_preset_scripts:set_visible(false)
        spacer1:set_visible(false)
        spacer2:set_visible(false)
        spacer3:set_visible(false)
        spacer4:set_visible(false)
        btn_create:set_visible(false)
        add:set_visible(false)
        name:set_visible(false)
        return
    end

    info:set(get_info_text())

    local is_new = (item.type == "new_preset")
    local is_script = (item.type == "script")
    local is_preset = (item.type == "preset")

    local is_script_loaded = is_script and not not loaded[item.name]
    local show_load_s = is_script and not is_script_loaded
    local show_unload_s = is_script and is_script_loaded

    local is_preset_active = is_preset and (active_preset == item.name)
    local show_load_p = is_preset and not is_preset_active
    local show_unload_p = is_preset and is_preset_active

    -- 1. Сначала показываем нужные элементы (высота контейнера не проседает, скролл не зажимается в 0)
    if show_load_s then btn_load_script:set_visible(true) end
    if show_unload_s then btn_unload_script:set_visible(true) end
    if show_load_p then btn_load_preset:set_visible(true) end
    if show_unload_p then btn_unload_preset:set_visible(true) end
    if is_script then
        spacer1:set_visible(true)
        spacer2:set_visible(true)
        spacer3:set_visible(true)
        spacer4:set_visible(true)
    end
    if is_preset then
        edit_preset_scripts:set_visible(true)
        btn_delete_preset:set_visible(true)
    end

    if is_preset and item and item.data then
        is_setting_preset_scripts = true
        edit_preset_scripts:set(item.data.scripts or {})
        is_setting_preset_scripts = false
    end

    if is_new then
        add:set_visible(true)
        name:set_visible(true)
        btn_create:set_visible(true)
    end

    -- 2. Затем скрываем ненужные
    if not show_load_s then btn_load_script:set_visible(false) end
    if not show_unload_s then btn_unload_script:set_visible(false) end
    if not show_load_p then btn_load_preset:set_visible(false) end
    if not show_unload_p then btn_unload_preset:set_visible(false) end
    if not is_script then
        spacer1:set_visible(false)
        spacer2:set_visible(false)
        spacer3:set_visible(false)
        spacer4:set_visible(false)
    end
    if not is_preset then
        edit_preset_scripts:set_visible(false)
        btn_delete_preset:set_visible(false)
    end

    if not is_new then
        add:set_visible(false)
        name:set_visible(false)
        btn_create:set_visible(false)
    end
end

list:set_callback(function()
    if is_updating then return end

    local idx = list:get()
    local item = current_items[idx + 1]
    if not item then return end

    if item.type == "header" or item.type == "loading" or item.type == "error" then
        is_updating = true
        if last_idx and last_idx < #current_items and current_items[last_idx + 1] and current_items[last_idx + 1].type ~= "header" then
            list:set(last_idx)
        else
            for i, it in ipairs(current_items) do
                if it.type == "new_preset" or it.type == "script" then
                    last_idx = i - 1
                    list:set(last_idx)
                    break
                end
            end
        end
        is_updating = false
        update_visibility()
        return
    end

    last_idx = idx

    local now = globals.realtime()
    if click_idx == idx and (now - click_time) < 0.5 then
        click_idx = -1
        click_time = 0

        if item.type == "script" then
            client.delay_call(0, function()
                if loaded[item.name] then
                    unload_script(item.name)
                else
                    load_script(item.name)
                end
            end)
            return
        elseif item.type == "preset" then
            client.delay_call(0, function()
                toggle_preset(item.data)
            end)
            return
        end
    else
        click_idx = idx
        click_time = now
    end

    update_visibility()
end)


reload:set_callback(function()
    if database and database.write then
        pcall(database.write, "multi_loader_save_locally", reload:get())
        if database.flush then pcall(database.flush) end
    end
end)

local last_info_text = ""
local last_step = -1
local last_frame_sec = -1
local last_selected_idx = -1

client.set_event_callback("paint_ui", function()
    if not ui.is_menu_open() then return end

    local cur_accent = get_accent_hex()
    if last_accent_hex == nil then
        last_accent_hex = cur_accent
    elseif cur_accent ~= last_accent_hex then
        last_accent_hex = cur_accent
        update_list()
    end

    if is_loading then
        local step = math.floor((globals.realtime() - load_start) / 0.25) % 3 + 1
        if step ~= last_step then
            last_step = step
            local text = "Loading" .. string.rep(".", step)
            if text ~= last_info_text then
                last_info_text = text
                info:set(text)
            end
        end
        return
    end

    local cur_sec = math.floor(globals.realtime())
    local cur_idx = list:get()
    if cur_sec == last_frame_sec and cur_idx == last_selected_idx then
        return
    end
    last_frame_sec = cur_sec
    last_selected_idx = cur_idx

    local text = get_info_text()
    if text ~= last_info_text then
        last_info_text = text
        info:set(text)
    end
end)

if menu_color_ref then
    pcall(ui.set_callback, menu_color_ref, function()
        last_accent_hex = get_accent_hex()
        update_list()
    end)
end

update_list()
fetch_scripts()
