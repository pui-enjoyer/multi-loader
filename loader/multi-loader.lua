-- multi-loader
-- repo: github.com/pui-enjoyer/multi-loader
-- credits to alaraks

-- Emergency repair if angelwings or a troll script poisoned globals in this session
if rawget(_G, "org_delay_call") and type(rawget(_G, "org_delay_call")) == "function" then
    client.delay_call = rawget(_G, "org_delay_call")
    rawset(_G, "org_delay_call", nil)
end
if rawget(_G, "org_req") and type(rawget(_G, "org_req")) == "function" then
    require = rawget(_G, "org_req")
    rawset(_G, "org_req", nil)
end

local real_client = client
local real_client_delay_call = client.delay_call
local real_client_set_event_callback = client.set_event_callback
local real_client_unset_event_callback = client.unset_event_callback
local real_client_log = client.log
local real_ui = ui
local real_ui_set_visible = ui.set_visible
local real_ui_set_enabled = ui.set_enabled
local real_ui_set_callback = ui.set_callback
local real_ui_new_checkbox = ui.new_checkbox
local real_ui_new_slider = ui.new_slider
local real_ui_new_combobox = ui.new_combobox
local real_ui_new_multiselect = ui.new_multiselect
local real_ui_new_hotkey = ui.new_hotkey
local real_ui_new_button = ui.new_button
local real_ui_new_color_picker = ui.new_color_picker
local real_ui_new_textbox = ui.new_textbox
local real_ui_new_listbox = ui.new_listbox
local real_ui_new_label = ui.new_label
local real_ui_new_string = ui.new_string
local real_require = require
local real_loadstring = loadstring or load

local ml_runtime = {
    scripts = {},
    ref_owners = {},
    active_loading = nil,
    active_context = nil,
    orig_ui_fns = {}
}

local function track_ui_create(s_name, c_type, orig_fn, tab, container, name, ...)
    local sc = ml_runtime.scripts[s_name]
    if not sc then
        return orig_fn(tab, container, name, ...)
    end

    local base_key = string.format("%s:%s:%s:%s", tostring(c_type), tostring(tab), tostring(container), tostring(name))
    local count = (sc.load_counts[base_key] or 0) + 1
    sc.load_counts[base_key] = count
    local key = base_key .. "#" .. count

    local existing_ref = sc.ui_keys[key]
    if existing_ref ~= nil then
        pcall(real_ui_set_visible, existing_ref, true)
        pcall(real_ui_set_enabled, existing_ref, true)
        if c_type == "button" then
            local cb = ...
            if type(cb) == "function" then
                local wrapped_btn = function(...)
                    if not sc.active then return end
                    local prev_ctx = ml_runtime.active_context
                    ml_runtime.active_context = s_name
                    local ok, err = pcall(cb, ...)
                    ml_runtime.active_context = prev_ctx
                    if not ok then
                        real_client_log(string.format("[multi-loader] Error in button (%s): %s", s_name, tostring(err)))
                    end
                end
                pcall(real_ui_set_callback, existing_ref, wrapped_btn)
            end
        elseif c_type == "combobox" or c_type == "multiselect" or c_type == "listbox" then
            local args = { ... }
            if #args > 0 and ui.update then
                pcall(ui.update, existing_ref, unpack(args))
            end
        end
        return existing_ref
    end

    local ref
    if c_type == "button" then
        local cb = ...
        if type(cb) == "function" then
            local wrapped_btn = function(...)
                if not sc.active then return end
                local prev_ctx = ml_runtime.active_context
                ml_runtime.active_context = s_name
                local ok, err = pcall(cb, ...)
                ml_runtime.active_context = prev_ctx
                if not ok then
                    real_client_log(string.format("[multi-loader] Error in button (%s): %s", s_name, tostring(err)))
                end
            end
            ref = orig_fn(tab, container, name, wrapped_btn)
        else
            ref = orig_fn(tab, container, name, cb)
        end
    else
        ref = orig_fn(tab, container, name, ...)
    end

    if ref ~= nil then
        sc.ui_keys[key] = ref
        table.insert(sc.ui_refs, ref)
        ml_runtime.ref_owners[ref] = s_name
    end
    return ref
end

local function track_ui_string(s_name, name, default)
    local sc = ml_runtime.scripts[s_name]
    if not sc or not real_ui_new_string then
        return real_ui_new_string and real_ui_new_string(name, default)
    end
    local key = "string:" .. tostring(name)
    local count = (sc.load_counts[key] or 0) + 1
    sc.load_counts[key] = count
    local full_key = key .. "#" .. count

    local existing_ref = sc.ui_keys[full_key]
    if existing_ref ~= nil then
        return existing_ref
    end

    local ref = real_ui_new_string(name, default)
    if ref ~= nil then
        sc.ui_keys[full_key] = ref
        table.insert(sc.ui_refs, ref)
        ml_runtime.ref_owners[ref] = s_name
    end
    return ref
end

local function script_set_event_callback(s_name, event, fn)
    if type(event) ~= "string" or type(fn) ~= "function" then return end
    local sc = ml_runtime.scripts[s_name]
    if not sc then return end

    if event == "shutdown" then
        table.insert(sc.shutdown_cbs, fn)
        return
    end

    for _, cb in ipairs(sc.callbacks) do
        if cb.event == event and cb.raw_fn == fn then
            return
        end
    end

    local wrapped_fn = function(...)
        if not sc.active then return end
        local prev_ctx = ml_runtime.active_context
        ml_runtime.active_context = s_name
        local ok, r1, r2, r3, r4 = pcall(fn, ...)
        ml_runtime.active_context = prev_ctx
        if not ok then
            real_client_log(string.format("[multi-loader] Error in %s (%s): %s", s_name, event, tostring(r1)))
            return
        end
        return r1, r2, r3, r4
    end

    table.insert(sc.callbacks, {
        event = event,
        raw_fn = fn,
        wrapped_fn = wrapped_fn
    })

    real_client_set_event_callback(event, wrapped_fn)
end

local function script_unset_event_callback(s_name, event, fn)
    if type(event) ~= "string" or type(fn) ~= "function" then return end
    local sc = ml_runtime.scripts[s_name]
    if not sc then return end

    if event == "shutdown" then
        for i, f in ipairs(sc.shutdown_cbs) do
            if f == fn then
                table.remove(sc.shutdown_cbs, i)
                break
            end
        end
        return
    end

    for i, cb in ipairs(sc.callbacks) do
        if cb.event == event and cb.raw_fn == fn then
            pcall(real_client_unset_event_callback, event, cb.wrapped_fn)
            table.remove(sc.callbacks, i)
            break
        end
    end
end

local function script_delay_call(s_name, delay, fn)
    if type(fn) ~= "function" then return end
    local sc = ml_runtime.scripts[s_name]
    if not sc then return end

    local token = {}
    sc.timers[token] = true

    return real_client_delay_call(delay, function(...)
        if not sc.active or not sc.timers[token] then
            return
        end
        sc.timers[token] = nil
        local prev_ctx = ml_runtime.active_context
        ml_runtime.active_context = s_name
        local ok, err = pcall(fn, ...)
        ml_runtime.active_context = prev_ctx
        if not ok then
            real_client_log(string.format("[multi-loader] Error in delay_call (%s): %s", s_name, tostring(err)))
        end
    end)
end

local ml_embedded_json
do
    local json = { _version = "0.1.2" }
    local encode
    local escape_char_map = {
        [ "\\" ] = "\\",
        [ "\"" ] = "\"",
        [ "\b" ] = "b",
        [ "\f" ] = "f",
        [ "\n" ] = "n",
        [ "\r" ] = "r",
        [ "\t" ] = "t",
    }
    local escape_char_map_inv = { [ "/" ] = "/" }
    for k, v in pairs(escape_char_map) do escape_char_map_inv[v] = k end

    local function escape_char(c)
        return "\\" .. (escape_char_map[c] or string.format("u%04x", c:byte()))
    end

    local function encode_nil(val) return "null" end

    local function encode_table(val, stack)
        local res = {}
        stack = stack or {}
        if stack[val] then error("circular reference") end
        stack[val] = true

        if rawget(val, 1) ~= nil or next(val) == nil then
            local n = 0
            for k in pairs(val) do
                if type(k) ~= "number" then error("invalid table: mixed or invalid key types") end
                n = n + 1
            end
            if n ~= #val then error("invalid table: sparse array") end
            for i, v in ipairs(val) do table.insert(res, encode(v, stack)) end
            stack[val] = nil
            return "[" .. table.concat(res, ",") .. "]"
        else
            for k, v in pairs(val) do
                if type(k) ~= "string" then error("invalid table: mixed or invalid key types") end
                table.insert(res, encode(k, stack) .. ":" .. encode(v, stack))
            end
            stack[val] = nil
            return "{" .. table.concat(res, ",") .. "}"
        end
    end

    local function encode_string(val)
        return '"' .. val:gsub('[%z\1-\31\\"]', escape_char) .. '"'
    end

    local function encode_number(val)
        if val ~= val or val <= -math.huge or val >= math.huge then
            error("unexpected number value '" .. tostring(val) .. "'")
        end
        return string.format("%.14g", val)
    end

    local type_func_map = {
        [ "nil"     ] = encode_nil,
        [ "table"   ] = encode_table,
        [ "string"  ] = encode_string,
        [ "number"  ] = encode_number,
        [ "boolean" ] = tostring,
    }

    encode = function(val, stack)
        local t = type(val)
        local f = type_func_map[t]
        if f then return f(val, stack) end
        error("unexpected type '" .. t .. "'")
    end

    function json.encode(val) return ( encode(val) ) end

    local parse

    local function create_set(...)
        local res = {}
        for i = 1, select("#", ...) do res[ select(i, ...) ] = true end
        return res
    end

    local space_chars   = create_set(" ", "\t", "\r", "\n")
    local delim_chars   = create_set(" ", "\t", "\r", "\n", "]", "}", ",")
    local escape_chars  = create_set("\\", "/", '"', "b", "f", "n", "r", "t", "u")
    local literals      = create_set("true", "false", "null")

    local literal_map = {
        [ "true"  ] = true,
        [ "false" ] = false,
        [ "null"  ] = nil,
    }

    local function next_char(str, idx, set, negate)
        for i = idx, #str do
            if set[str:sub(i, i)] ~= negate then return i end
        end
        return #str + 1
    end

    local function decode_error(str, idx, msg)
        local line_count = 1
        local col_count = 1
        for i = 1, idx - 1 do
            col_count = col_count + 1
            if str:sub(i, i) == "\n" then
                line_count = line_count + 1
                col_count = 1
            end
        end
        error(string.format("%s at line %d col %d", msg, line_count, col_count))
    end

    local function codepoint_to_utf8(n)
        local f = math.floor
        if n <= 0x7f then
            return string.char(n)
        elseif n <= 0x7ff then
            return string.char(f(n / 64) + 192, n % 64 + 128)
        elseif n <= 0xffff then
            return string.char(f(n / 4096) + 224, f(n % 4096 / 64) + 128, n % 64 + 128)
        elseif n <= 0x10ffff then
            return string.char(f(n / 262144) + 240, f(n % 262144 / 4096) + 128, f(n % 4096 / 64) + 128, n % 64 + 128)
        end
        error(string.format("invalid unicode codepoint '%x'", n))
    end

    local function parse_unicode_escape(s)
        local n1 = tonumber(s:sub(1, 4), 16)
        local n2 = tonumber(s:sub(7, 10), 16)
        if n2 then
            return codepoint_to_utf8((n1 - 0xd800) * 0x400 + (n2 - 0xdc00) + 0x10000)
        else
            return codepoint_to_utf8(n1)
        end
    end

    local function parse_string(str, i)
        local res = ""
        local j = i + 1
        local k = j
        while j <= #str do
            local x = str:byte(j)
            if x < 32 then
                decode_error(str, j, "control character in string")
            elseif x == 92 then
                res = res .. str:sub(k, j - 1)
                j = j + 1
                local c = str:sub(j, j)
                if c == "u" then
                    local hex = str:match("^[dD][89aAbB]%x%x\\u%x%x%x%x", j + 1)
                             or str:match("^%x%x%x%x", j + 1)
                             or decode_error(str, j - 1, "invalid unicode escape in string")
                    res = res .. parse_unicode_escape(hex)
                    j = j + #hex
                else
                    if not escape_chars[c] then
                        decode_error(str, j - 1, "invalid escape char '" .. c .. "' in string")
                    end
                    res = res .. escape_char_map_inv[c]
                end
                k = j + 1
            elseif x == 34 then
                res = res .. str:sub(k, j - 1)
                return res, j + 1
            end
            j = j + 1
        end
        decode_error(str, i, "expected closing quote for string")
    end

    local function parse_number(str, i)
        local x = next_char(str, i, delim_chars)
        local s = str:sub(i, x - 1)
        local n = tonumber(s)
        if not n then decode_error(str, i, "invalid number '" .. s .. "'") end
        return n, x
    end

    local function parse_literal(str, i)
        local x = next_char(str, i, delim_chars)
        local word = str:sub(i, x - 1)
        if not literals[word] then decode_error(str, i, "invalid literal '" .. word .. "'") end
        return literal_map[word], x
    end

    local function parse_array(str, i)
        local res = {}
        local n = 1
        i = i + 1
        while 1 do
            local x
            i = next_char(str, i, space_chars, true)
            if str:sub(i, i) == "]" then
                i = i + 1
                break
            end
            x, i = parse(str, i)
            res[n] = x
            n = n + 1
            i = next_char(str, i, space_chars, true)
            local chr = str:sub(i, i)
            i = i + 1
            if chr == "]" then break end
            if chr ~= "," then decode_error(str, i, "expected ']' or ','") end
        end
        return res, i
    end

    local function parse_object(str, i)
        local res = {}
        i = i + 1
        while 1 do
            local key, val
            i = next_char(str, i, space_chars, true)
            if str:sub(i, i) == "}" then
                i = i + 1
                break
            end
            if str:sub(i, i) ~= '"' then decode_error(str, i, "expected string for key") end
            key, i = parse(str, i)
            i = next_char(str, i, space_chars, true)
            if str:sub(i, i) ~= ":" then decode_error(str, i, "expected ':' after key") end
            i = next_char(str, i + 1, space_chars, true)
            val, i = parse(str, i)
            res[key] = val
            i = next_char(str, i, space_chars, true)
            local chr = str:sub(i, i)
            i = i + 1
            if chr == "}" then break end
            if chr ~= "," then decode_error(str, i, "expected '}' or ','") end
        end
        return res, i
    end

    local char_func_map = {
        [ '"' ] = parse_string,
        [ "0" ] = parse_number,
        [ "1" ] = parse_number,
        [ "2" ] = parse_number,
        [ "3" ] = parse_number,
        [ "4" ] = parse_number,
        [ "5" ] = parse_number,
        [ "6" ] = parse_number,
        [ "7" ] = parse_number,
        [ "8" ] = parse_number,
        [ "9" ] = parse_number,
        [ "-" ] = parse_number,
        [ "t" ] = parse_literal,
        [ "f" ] = parse_literal,
        [ "n" ] = parse_literal,
        [ "[" ] = parse_array,
        [ "{" ] = parse_object,
    }

    parse = function(str, idx)
        local chr = str:sub(idx, idx)
        local f = char_func_map[chr]
        if f then return f(str, idx) end
        decode_error(str, idx, "unexpected character '" .. chr .. "'")
    end

    function json.parse(str)
        if type(str) ~= "string" then error("expected argument of type string, got " .. type(str)) end
        local res, idx = parse(str, next_char(str, 1, space_chars, true))
        idx = next_char(str, idx, space_chars, true)
        if idx <= #str then decode_error(str, idx, "trailing garbage") end
        return res
    end

    json.decode = json.parse
    json.stringify = json.encode

    ml_embedded_json = function() return json end

    if package and package.preload then
        package.preload["json"] = ml_embedded_json
        package.preload["gamesense/json"] = ml_embedded_json
    end
end

local function create_script_env(s_name)
    local sc = ml_runtime.scripts[s_name]
    local env = {}

    local script_client = {}
    for k, v in pairs(real_client) do
        script_client[k] = v
    end
    script_client.set_event_callback = function(event, fn)
        return script_set_event_callback(s_name, event, fn)
    end
    script_client.unset_event_callback = function(event, fn)
        return script_unset_event_callback(s_name, event, fn)
    end
    script_client.delay_call = function(delay, fn)
        return script_delay_call(s_name, delay, fn)
    end

    local script_ui = {}
    for k, v in pairs(real_ui) do
        script_ui[k] = v
    end
    script_ui.new_checkbox = function(...) return track_ui_create(s_name, "checkbox", real_ui_new_checkbox, ...) end
    script_ui.new_slider = function(...) return track_ui_create(s_name, "slider", real_ui_new_slider, ...) end
    script_ui.new_combobox = function(...) return track_ui_create(s_name, "combobox", real_ui_new_combobox, ...) end
    script_ui.new_multiselect = function(...) return track_ui_create(s_name, "multiselect", real_ui_new_multiselect, ...) end
    script_ui.new_hotkey = function(...) return track_ui_create(s_name, "hotkey", real_ui_new_hotkey, ...) end
    script_ui.new_button = function(...) return track_ui_create(s_name, "button", real_ui_new_button, ...) end
    script_ui.new_color_picker = function(...) return track_ui_create(s_name, "color_picker", real_ui_new_color_picker, ...) end
    script_ui.new_textbox = function(...) return track_ui_create(s_name, "textbox", real_ui_new_textbox, ...) end
    script_ui.new_listbox = function(...) return track_ui_create(s_name, "listbox", real_ui_new_listbox, ...) end
    script_ui.new_label = function(...) return track_ui_create(s_name, "label", real_ui_new_label, ...) end
    script_ui.new_string = function(...) return track_ui_string(s_name, ...) end
    script_ui.set_callback = function(...) return ui.set_callback(...) end

    env.client = script_client
    env.ui = script_ui
    env.require = function(mod_name)
        if mod_name == "gamesense/http" then
            local real_mod = real_require("gamesense/http")
            return {
                get = function(...) return real_mod.get(...) end,
                post = function(...) return real_mod.post(...) end
            }
        end
        if mod_name == "json" or mod_name == "gamesense/json" then
            local ok, mod = pcall(real_require, mod_name)
            if ok and type(mod) == "table" then
                return mod
            end
            return ml_embedded_json()
        end
        local is_shared = (type(mod_name) ~= "string") or mod_name:find("^gamesense/") or mod_name == "ffi" or mod_name == "bit" or mod_name == "vector" or mod_name == "json"
        if not is_shared then
            sc.required_modules = sc.required_modules or {}
            table.insert(sc.required_modules, mod_name)
        end
        return real_require(mod_name)
    end

    env._G = env
    env._NAME = s_name

    setmetatable(env, {
        __index = _G,
        __newindex = function(t, k, v)
            rawset(t, k, v)
        end
    })

    return env
end

do
    local create_map = {
        checkbox = real_ui_new_checkbox,
        slider = real_ui_new_slider,
        combobox = real_ui_new_combobox,
        multiselect = real_ui_new_multiselect,
        hotkey = real_ui_new_hotkey,
        button = real_ui_new_button,
        color_picker = real_ui_new_color_picker,
        textbox = real_ui_new_textbox,
        listbox = real_ui_new_listbox,
        label = real_ui_new_label,
    }
    ml_runtime.orig_ui_fns = create_map

    for c_type, orig_fn in pairs(create_map) do
        local fn_name = "new_" .. c_type
        ui[fn_name] = function(...)
            local active_s = ml_runtime.active_loading or ml_runtime.active_context
            if active_s then
                return track_ui_create(active_s, c_type, orig_fn, ...)
            end
            return orig_fn(...)
        end
    end

    if real_ui_new_string then
        ui.new_string = function(...)
            local active_s = ml_runtime.active_loading or ml_runtime.active_context
            if active_s then
                return track_ui_string(active_s, ...)
            end
            return real_ui_new_string(...)
        end
    end

    ui.set_callback = function(ref, fn)
        local active_s = ml_runtime.ref_owners[ref] or ml_runtime.active_loading or ml_runtime.active_context
        if active_s and ml_runtime.scripts[active_s] then
            local sc = ml_runtime.scripts[active_s]
            sc.ui_callbacks = sc.ui_callbacks or {}
            if type(fn) == "function" then
                local wrapped_ui_cb = function(...)
                    if not sc.active then return end
                    local prev_ctx = ml_runtime.active_context
                    ml_runtime.active_context = active_s
                    local ok, err = pcall(fn, ...)
                    ml_runtime.active_context = prev_ctx
                    if not ok then
                        real_client_log(string.format("[multi-loader] Error in UI callback (%s): %s", active_s, tostring(err)))
                    end
                end
                sc.ui_callbacks[ref] = wrapped_ui_cb
                return real_ui_set_callback(ref, wrapped_ui_cb)
            else
                sc.ui_callbacks[ref] = nil
                return real_ui_set_callback(ref, fn)
            end
        end
        return real_ui_set_callback(ref, fn)
    end

    client.set_event_callback = function(event, fn)
        local active_s = ml_runtime.active_loading or ml_runtime.active_context
        if active_s then
            return script_set_event_callback(active_s, event, fn)
        end
        return real_client_set_event_callback(event, fn)
    end

    client.unset_event_callback = function(event, fn)
        local active_s = ml_runtime.active_loading or ml_runtime.active_context
        if active_s then
            return script_unset_event_callback(active_s, event, fn)
        end
        for _, sc in pairs(ml_runtime.scripts) do
            if sc.callbacks then
                for i, cb in ipairs(sc.callbacks) do
                    if cb.event == event and cb.raw_fn == fn then
                        pcall(real_client_unset_event_callback, event, cb.wrapped_fn)
                        table.remove(sc.callbacks, i)
                        return
                    end
                end
            end
        end
        return real_client_unset_event_callback(event, fn)
    end

    client.delay_call = function(delay, fn)
        local active_s = ml_runtime.active_loading or ml_runtime.active_context
        if active_s then
            return script_delay_call(active_s, delay, fn)
        end
        return real_client_delay_call(delay, fn)
    end
end

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
        load_script(item.name)
    end
end)

local btn_unload_script = menu:button("Unload script", function()
    local item = current_items[list:get() + 1]
    if item and item.type == "script" then
        unload_script(item.name)
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
            toggle_preset(item.data)
        end
    end
end)

local btn_unload_preset = menu:button("Unload preset", function()
    local item = current_items[list:get() + 1]
    if item and item.type == "preset" then
        if active_preset == item.name then
            toggle_preset(item.data)
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

    local sc = ml_runtime.scripts[s_name]
    if not sc then
        sc = {
            active = true,
            ui_keys = {},
            ui_refs = {},
            load_counts = {},
            callbacks = {},
            timers = {},
            shutdown_cbs = {},
            ui_callbacks = {},
            required_modules = {}
        }
        ml_runtime.scripts[s_name] = sc
    else
        sc.active = true
        sc.load_counts = {}
        sc.callbacks = {}
        sc.timers = {}
        sc.shutdown_cbs = {}
        sc.ui_callbacks = sc.ui_callbacks or {}
        sc.required_modules = sc.required_modules or {}
    end

    local loader = loadstring or load
    local fn, err = loader(body, s_name)
    if not fn then
        client.log("[multi-loader] Compile error in " .. s_name .. ": " .. tostring(err))
        loaded[s_name] = nil
        if not silent then
            update_list()
            update_visibility()
        end
        return false
    end

    local env = create_script_env(s_name)
    if setfenv then
        setfenv(fn, env)
    end

    local prev_loading = ml_runtime.active_loading
    local prev_ctx = ml_runtime.active_context
    ml_runtime.active_loading = s_name
    ml_runtime.active_context = s_name

    local ok, runtime_err = pcall(fn)

    ml_runtime.active_loading = prev_loading
    ml_runtime.active_context = prev_ctx

    if not ok then
        client.log("[multi-loader] Runtime error in " .. s_name .. ": " .. tostring(runtime_err))
        unload_script(s_name, true)
        loaded[s_name] = nil
        if not silent then
            update_list()
            update_visibility()
        end
        return false
    end

    loaded[s_name] = true
    script_load_times[s_name] = globals.realtime()
    if not silent then
        update_list()
        update_visibility()
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
    if not loaded[s_name] and not (ml_runtime.scripts[s_name] and ml_runtime.scripts[s_name].active) then
        return
    end

    local sc = ml_runtime.scripts[s_name]
    if sc then
        sc.active = false

        -- 1. Call registered shutdown callbacks
        for _, s_fn in ipairs(sc.shutdown_cbs) do
            local prev_ctx = ml_runtime.active_context
            ml_runtime.active_context = s_name
            pcall(s_fn)
            ml_runtime.active_context = prev_ctx
        end
        sc.shutdown_cbs = {}

        -- 2. Unregister event callbacks
        for _, cb in ipairs(sc.callbacks) do
            pcall(real_client_unset_event_callback, cb.event, cb.wrapped_fn)
        end
        sc.callbacks = {}

        -- 3. Invalidate active timers
        sc.timers = {}

        -- 4. Neutralize UI callbacks
        if sc.ui_callbacks then
            for ref, _ in pairs(sc.ui_callbacks) do
                pcall(real_ui_set_callback, ref, function() end)
            end
            sc.ui_callbacks = {}
        end

        -- 5. Hide and disable all UI elements created by this script
        for _, ref in ipairs(sc.ui_refs) do
            pcall(real_ui_set_visible, ref, false)
            pcall(real_ui_set_enabled, ref, false)
        end

        -- 6. Clean up required custom modules if any
        if sc.required_modules then
            for _, mod in ipairs(sc.required_modules) do
                package.loaded[mod] = nil
            end
            sc.required_modules = {}
        end
    end

    loaded[s_name] = nil
    script_unload_times[s_name] = globals.realtime()
    if not silent then
        update_list()
        update_visibility()
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
            local display_name = s:gsub("%.lua$", ""):gsub("^%b[]%s*", ""):gsub("%s*%b[]$", "")
            local color = is_on and accent_hex or "\aC8C8C8FF"
            table.insert(display, color .. display_name)
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
        local display_name = p.name:gsub("%.lua$", ""):gsub("^%b[]%s*", ""):gsub("%s*%b[]$", "")
        local color = is_active and accent_hex or "\aC8C8C8FF"
        table.insert(display, color .. display_name)
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
            if loaded[item.name] then
                unload_script(item.name)
            else
                load_script(item.name)
            end
            return
        elseif item.type == "preset" then
            toggle_preset(item.data)
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

real_client_set_event_callback("shutdown", function()
    for s_name, _ in pairs(loaded) do
        unload_script(s_name, true)
    end
    for _, sc in pairs(ml_runtime.scripts) do
        if sc.active then
            for _, ref in ipairs(sc.ui_refs) do
                pcall(real_ui_set_visible, ref, false)
                pcall(real_ui_set_enabled, ref, false)
            end
        end
    end
end)
