-- multi-loader by alaraks
-- github.com/pui-enjoyer/multi-loader

if rawget(_G, "org_delay_call") and type(rawget(_G, "org_delay_call")) == "function" then
    client.delay_call = rawget(_G, "org_delay_call")
    rawset(_G, "org_delay_call", nil)
end
if rawget(_G, "org_req") and type(rawget(_G, "org_req")) == "function" then
    require = rawget(_G, "org_req")
    rawset(_G, "org_req", nil)
end

local real_client = client
local real_delay_call = client.delay_call
local real_set_event_cb = client.set_event_callback
local real_unset_event_cb = client.unset_event_callback
local real_log = function() end
local real_ui = ui
local real_set_visible = ui.set_visible
local real_set_enabled = ui.set_enabled
local real_set_cb = ui.set_callback
local real_new_checkbox = ui.new_checkbox
local real_new_slider = ui.new_slider
local real_new_combobox = ui.new_combobox
local real_new_multiselect = ui.new_multiselect
local real_new_hotkey = ui.new_hotkey
local real_new_button = ui.new_button
local real_new_color_picker = ui.new_color_picker
local real_new_textbox = ui.new_textbox
local real_new_listbox = ui.new_listbox
local real_new_label = ui.new_label
local real_new_string = ui.new_string
local real_require = require
local real_loadstring = loadstring or load

local rt = {
    scripts     = {},
    ref_owners  = {},
    loading     = nil,
    ctx         = nil,
    orig_ui     = {}
}

local function wrap_btn(sc, s_name, cb)
    return function(...)
        if not sc.active then return end
        local prev = rt.ctx
        rt.ctx = s_name
        local ok, err = pcall(cb, ...)
        rt.ctx = prev
        if not ok then
            real_log("[multi-loader] button error in " .. s_name .. ": " .. tostring(err))
        end
    end
end

local function track_ui(s_name, kind, orig_fn, tab, container, name, ...)
    local sc = rt.scripts[s_name]
    if not sc then return orig_fn(tab, container, name, ...) end

    local base = kind .. ":" .. tostring(tab) .. ":" .. tostring(container) .. ":" .. tostring(name)
    local n = (sc.load_counts[base] or 0) + 1
    sc.load_counts[base] = n
    local key = base .. "#" .. n

    local existing = sc.ui_keys[key]
    if existing ~= nil then
        pcall(real_set_visible, existing, true)
        pcall(real_set_enabled, existing, true)
        if kind == "button" then
            local cb = ...
            if type(cb) == "function" then
                pcall(real_set_cb, existing, wrap_btn(sc, s_name, cb))
            end
        elseif kind == "combobox" or kind == "multiselect" or kind == "listbox" then
            local args = {...}
            if #args > 0 and ui.update then
                pcall(ui.update, existing, unpack(args))
            end
        end
        return existing
    end

    local ref
    if kind == "button" then
        local cb = ...
        if type(cb) == "function" then
            ref = orig_fn(tab, container, name, wrap_btn(sc, s_name, cb))
        else
            ref = orig_fn(tab, container, name, cb)
        end
    else
        ref = orig_fn(tab, container, name, ...)
    end

    if ref ~= nil then
        sc.ui_keys[key] = ref
        table.insert(sc.ui_refs, ref)
        rt.ref_owners[ref] = s_name
    end
    return ref
end

local function track_string(s_name, name, default)
    local sc = rt.scripts[s_name]
    if not sc or not real_new_string then
        return real_new_string and real_new_string(name, default)
    end
    local key = "string:" .. tostring(name)
    local n = (sc.load_counts[key] or 0) + 1
    sc.load_counts[key] = n
    local full_key = key .. "#" .. n

    local existing = sc.ui_keys[full_key]
    if existing ~= nil then return existing end

    local ref = real_new_string(name, default)
    if ref ~= nil then
        sc.ui_keys[full_key] = ref
        table.insert(sc.ui_refs, ref)
        rt.ref_owners[ref] = s_name
    end
    return ref
end

local function script_set_cb(s_name, ev, fn)
    if type(ev) ~= "string" or type(fn) ~= "function" then return end
    local sc = rt.scripts[s_name]
    if not sc then return end

    if ev == "shutdown" then
        table.insert(sc.shutdown_cbs, fn)
        return
    end

    for _, cb in ipairs(sc.callbacks) do
        if cb.event == ev and cb.raw == fn then return end
    end

    local wrapped = function(...)
        if not sc.active then return end
        local prev = rt.ctx
        rt.ctx = s_name
        local ok, r1, r2, r3, r4 = pcall(fn, ...)
        rt.ctx = prev
        if not ok then
            real_log("[multi-loader] " .. s_name .. " (" .. ev .. "): " .. tostring(r1))
            return
        end
        return r1, r2, r3, r4
    end

    table.insert(sc.callbacks, {event = ev, raw = fn, wrapped = wrapped})
    real_set_event_cb(ev, wrapped)
end

local function script_unset_cb(s_name, ev, fn)
    if type(ev) ~= "string" or type(fn) ~= "function" then return end
    local sc = rt.scripts[s_name]
    if not sc then return end

    if ev == "shutdown" then
        for i, f in ipairs(sc.shutdown_cbs) do
            if f == fn then table.remove(sc.shutdown_cbs, i) break end
        end
        return
    end

    for i, cb in ipairs(sc.callbacks) do
        if cb.event == ev and cb.raw == fn then
            pcall(real_unset_event_cb, ev, cb.wrapped)
            table.remove(sc.callbacks, i)
            break
        end
    end
end

local function script_delay(s_name, delay, fn)
    if type(fn) ~= "function" then return end
    local sc = rt.scripts[s_name]
    if not sc then return end

    local token = {}
    sc.timers[token] = true

    return real_delay_call(delay, function(...)
        if not sc.active or not sc.timers[token] then return end
        sc.timers[token] = nil
        local prev = rt.ctx
        rt.ctx = s_name
        local ok, err = pcall(fn, ...)
        rt.ctx = prev
        if not ok then
            real_log("[multi-loader] delay_call error in " .. s_name .. ": " .. tostring(err))
        end
    end)
end

-- embedded json (rxi/json v0.1.2)
local ml_json
do
    local json = {}
    local encode

    local esc_map = {["\\"] = "\\", ['"'] = '"', ["\b"] = "b", ["\f"] = "f", ["\n"] = "n", ["\r"] = "r", ["\t"] = "t"}
    local esc_inv = {["/"] = "/"}
    for k, v in pairs(esc_map) do esc_inv[v] = k end

    local function esc_char(c) return "\\" .. (esc_map[c] or string.format("u%04x", c:byte())) end

    local function enc_table(val, stack)
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
            for _, v in ipairs(val) do table.insert(res, encode(v, stack)) end
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

    local function enc_str(val) return '"' .. val:gsub('[%z\1-\31\\"]', esc_char) .. '"' end
    local function enc_num(val)
        if val ~= val or val <= -math.huge or val >= math.huge then error("unexpected number value '" .. tostring(val) .. "'") end
        return string.format("%.14g", val)
    end

    local type_map = {["nil"] = function() return "null" end, ["table"] = enc_table, ["string"] = enc_str, ["number"] = enc_num, ["boolean"] = tostring}

    encode = function(val, stack)
        local f = type_map[type(val)]
        if f then return f(val, stack) end
        error("unexpected type '" .. type(val) .. "'")
    end

    json.encode = function(val) return (encode(val)) end
    json.stringify = json.encode

    local parse
    local function mkset(...)
        local t = {}
        for i = 1, select("#", ...) do t[select(i, ...)] = true end
        return t
    end

    local spaces     = mkset(" ", "\t", "\r", "\n")
    local delims     = mkset(" ", "\t", "\r", "\n", "]", "}", ",")
    local esc_chars  = mkset("\\", "/", '"', "b", "f", "n", "r", "t", "u")
    local literals   = mkset("true", "false", "null")
    local lit_map    = {["true"] = true, ["false"] = false, ["null"] = nil}

    local function next_ch(str, idx, set, negate)
        for i = idx, #str do
            if set[str:sub(i, i)] ~= negate then return i end
        end
        return #str + 1
    end

    local function dec_err(str, idx, msg)
        local line, col = 1, 1
        for i = 1, idx - 1 do
            col = col + 1
            if str:sub(i, i) == "\n" then line = line + 1; col = 1 end
        end
        error(string.format("%s at line %d col %d", msg, line, col))
    end

    local function cp_to_utf8(n)
        local f = math.floor
        if n <= 0x7f then return string.char(n)
        elseif n <= 0x7ff then return string.char(f(n/64)+192, n%64+128)
        elseif n <= 0xffff then return string.char(f(n/4096)+224, f(n%4096/64)+128, n%64+128)
        elseif n <= 0x10ffff then return string.char(f(n/262144)+240, f(n%262144/4096)+128, f(n%4096/64)+128, n%64+128)
        end
        error(string.format("invalid unicode codepoint '%x'", n))
    end

    local function parse_unicode(s)
        local n1 = tonumber(s:sub(1, 4), 16)
        local n2 = tonumber(s:sub(7, 10), 16)
        if n2 then return cp_to_utf8((n1 - 0xd800) * 0x400 + (n2 - 0xdc00) + 0x10000)
        else return cp_to_utf8(n1) end
    end

    local function parse_str(str, i)
        local res, j, k = "", i + 1, i + 1
        while j <= #str do
            local x = str:byte(j)
            if x < 32 then
                dec_err(str, j, "control character in string")
            elseif x == 92 then
                res = res .. str:sub(k, j - 1)
                j = j + 1
                local c = str:sub(j, j)
                if c == "u" then
                    local hex = str:match("^[dD][89aAbB]%x%x\\u%x%x%x%x", j+1)
                           or str:match("^%x%x%x%x", j+1)
                           or dec_err(str, j-1, "invalid unicode escape in string")
                    res = res .. parse_unicode(hex)
                    j = j + #hex
                else
                    if not esc_chars[c] then dec_err(str, j-1, "invalid escape char '" .. c .. "' in string") end
                    res = res .. esc_inv[c]
                end
                k = j + 1
            elseif x == 34 then
                res = res .. str:sub(k, j - 1)
                return res, j + 1
            end
            j = j + 1
        end
        dec_err(str, i, "expected closing quote for string")
    end

    local function parse_num(str, i)
        local x = next_ch(str, i, delims)
        local s = str:sub(i, x - 1)
        local n = tonumber(s)
        if not n then dec_err(str, i, "invalid number '" .. s .. "'") end
        return n, x
    end

    local function parse_lit(str, i)
        local x = next_ch(str, i, delims)
        local word = str:sub(i, x - 1)
        if not literals[word] then dec_err(str, i, "invalid literal '" .. word .. "'") end
        return lit_map[word], x
    end

    local function parse_arr(str, i)
        local res, n = {}, 1
        i = i + 1
        while 1 do
            local x
            i = next_ch(str, i, spaces, true)
            if str:sub(i, i) == "]" then i = i + 1; break end
            x, i = parse(str, i)
            res[n] = x; n = n + 1
            i = next_ch(str, i, spaces, true)
            local ch = str:sub(i, i)
            i = i + 1
            if ch == "]" then break end
            if ch ~= "," then dec_err(str, i, "expected ']' or ','") end
        end
        return res, i
    end

    local function parse_obj(str, i)
        local res = {}
        i = i + 1
        while 1 do
            local key, val
            i = next_ch(str, i, spaces, true)
            if str:sub(i, i) == "}" then i = i + 1; break end
            if str:sub(i, i) ~= '"' then dec_err(str, i, "expected string for key") end
            key, i = parse(str, i)
            i = next_ch(str, i, spaces, true)
            if str:sub(i, i) ~= ":" then dec_err(str, i, "expected ':' after key") end
            i = next_ch(str, i + 1, spaces, true)
            val, i = parse(str, i)
            res[key] = val
            i = next_ch(str, i, spaces, true)
            local ch = str:sub(i, i)
            i = i + 1
            if ch == "}" then break end
            if ch ~= "," then dec_err(str, i, "expected '}' or ','") end
        end
        return res, i
    end

    local ch_map = {
        ['"'] = parse_str, ["0"] = parse_num, ["1"] = parse_num, ["2"] = parse_num, ["3"] = parse_num,
        ["4"] = parse_num, ["5"] = parse_num, ["6"] = parse_num, ["7"] = parse_num, ["8"] = parse_num,
        ["9"] = parse_num, ["-"] = parse_num, ["t"] = parse_lit, ["f"] = parse_lit, ["n"] = parse_lit,
        ["["] = parse_arr, ["{"] = parse_obj
    }

    parse = function(str, idx)
        local f = ch_map[str:sub(idx, idx)]
        if f then return f(str, idx) end
        dec_err(str, idx, "unexpected character '" .. str:sub(idx, idx) .. "'")
    end

    json.parse = function(str)
        if type(str) ~= "string" then error("expected string, got " .. type(str)) end
        local res, idx = parse(str, next_ch(str, 1, spaces, true))
        idx = next_ch(str, idx, spaces, true)
        if idx <= #str then dec_err(str, idx, "trailing garbage") end
        return res
    end
    json.decode = json.parse

    ml_json = function() return json end

    if package and package.preload then
        package.preload["json"] = ml_json
        package.preload["gamesense/json"] = ml_json
    end
end

local function make_env(s_name)
    local sc = rt.scripts[s_name]

    local sclient = {}
    for k, v in pairs(real_client) do sclient[k] = v end
    sclient.set_event_callback   = function(ev, fn) return script_set_cb(s_name, ev, fn) end
    sclient.unset_event_callback = function(ev, fn) return script_unset_cb(s_name, ev, fn) end
    sclient.delay_call           = function(d, fn)  return script_delay(s_name, d, fn) end

    local sui = {}
    for k, v in pairs(real_ui) do sui[k] = v end
    sui.new_checkbox = function(...) return track_ui(s_name, "checkbox", real_new_checkbox, ...) end
    sui.new_slider = function(...) return track_ui(s_name, "slider", real_new_slider, ...) end
    sui.new_combobox = function(...) return track_ui(s_name, "combobox", real_new_combobox, ...) end
    sui.new_multiselect = function(...) return track_ui(s_name, "multiselect", real_new_multiselect, ...) end
    sui.new_hotkey = function(...) return track_ui(s_name, "hotkey", real_new_hotkey, ...) end
    sui.new_button = function(...) return track_ui(s_name, "button", real_new_button, ...) end
    sui.new_color_picker = function(...) return track_ui(s_name, "color_picker", real_new_color_picker, ...) end
    sui.new_textbox = function(...) return track_ui(s_name, "textbox", real_new_textbox, ...) end
    sui.new_listbox = function(...) return track_ui(s_name, "listbox", real_new_listbox, ...) end
    sui.new_label = function(...) return track_ui(s_name, "label", real_new_label, ...) end
    sui.new_string = function(...) return track_string(s_name, ...) end
    sui.set_callback = function(...) return ui.set_callback(...) end

    local env = {client = sclient, ui = sui}
    env._G    = env
    env._NAME = s_name

    env.require = function(mod)
        if mod == "gamesense/http" then
            local m = real_require("gamesense/http")
            return {get = function(...) return m.get(...) end, post = function(...) return m.post(...) end}
        end
        if mod == "json" or mod == "gamesense/json" then
            local ok, m = pcall(real_require, mod)
            if ok and type(m) == "table" then return m end
            return ml_json()
        end
        local shared = (type(mod) ~= "string") or mod:find("^gamesense/") or mod == "ffi" or mod == "bit" or mod == "vector" or mod == "json"
        if not shared then
            sc.required_modules = sc.required_modules or {}
            table.insert(sc.required_modules, mod)
        end
        return real_require(mod)
    end

    setmetatable(env, {__index = _G, __newindex = function(t, k, v) rawset(t, k, v) end})
    return env
end

do
    local ui_types = {
        checkbox = real_new_checkbox, slider = real_new_slider, combobox = real_new_combobox,
        multiselect = real_new_multiselect, hotkey = real_new_hotkey, button = real_new_button,
        color_picker = real_new_color_picker, textbox = real_new_textbox, listbox = real_new_listbox,
        label = real_new_label
    }
    rt.orig_ui = ui_types

    for kind, orig in pairs(ui_types) do
        local fn_name = "new_" .. kind
        ui[fn_name] = function(...)
            local s = rt.loading or rt.ctx
            if s then return track_ui(s, kind, orig, ...) end
            return orig(...)
        end
    end

    if real_new_string then
        ui.new_string = function(...)
            local s = rt.loading or rt.ctx
            if s then return track_string(s, ...) end
            return real_new_string(...)
        end
    end

    ui.set_callback = function(ref, fn)
        local s = rt.ref_owners[ref] or rt.loading or rt.ctx
        if s and rt.scripts[s] then
            local sc = rt.scripts[s]
            sc.ui_callbacks = sc.ui_callbacks or {}
            if type(fn) == "function" then
                local wrapped = function(...)
                    if not sc.active then return end
                    local prev = rt.ctx
                    rt.ctx = s
                    local ok, err = pcall(fn, ...)
                    rt.ctx = prev
                    if not ok then real_log("[multi-loader] UI cb error in " .. s .. ": " .. tostring(err)) end
                end
                sc.ui_callbacks[ref] = wrapped
                return real_set_cb(ref, wrapped)
            else
                sc.ui_callbacks[ref] = nil
                return real_set_cb(ref, fn)
            end
        end
        return real_set_cb(ref, fn)
    end

    client.set_event_callback = function(ev, fn)
        local s = rt.loading or rt.ctx
        if s then return script_set_cb(s, ev, fn) end
        return real_set_event_cb(ev, fn)
    end

    client.unset_event_callback = function(ev, fn)
        local s = rt.loading or rt.ctx
        if s then return script_unset_cb(s, ev, fn) end
        for _, sc in pairs(rt.scripts) do
            if sc.callbacks then
                for i, cb in ipairs(sc.callbacks) do
                    if cb.event == ev and cb.raw == fn then
                        pcall(real_unset_event_cb, ev, cb.wrapped)
                        table.remove(sc.callbacks, i)
                        return
                    end
                end
            end
        end
        return real_unset_event_cb(ev, fn)
    end

    client.delay_call = function(d, fn)
        local s = rt.loading or rt.ctx
        if s then return script_delay(s, d, fn) end
        return real_delay_call(d, fn)
    end
end

local http = require("gamesense/http")
local ffi  = require("ffi")
local pui  = require("gamesense/pui")

local function ensure_dir(path)
    pcall(function()
        local ptr = client.create_interface("filesystem_stdio.dll", "VFileSystem017")
        if ptr then
            local fs = ffi.cast("void***", ptr)
            ffi.cast("void(__thiscall*)(void*, const char*, const char*)", fs[0][22])(fs, path, nil)
        end
    end)
end
ensure_dir("multi-loader")
ensure_dir("multi-loader/misc stuff")
ensure_dir("multi-loader/anti-aimbot")

local readfile  = rawget(_G, "readfile")
local writefile = rawget(_G, "writefile")

if not readfile or not writefile then
    pcall(function()
        local ptr = client.create_interface("filesystem_stdio.dll", "VBaseFileSystem011")
        if not ptr then return end
        local fs   = ffi.cast("void***", ptr)
        local vtbl = fs[0]
        local v_open  = ffi.cast("void* (__thiscall*)(void*, const char*, const char*, const char*)", vtbl[2])
        local v_close = ffi.cast("void (__thiscall*)(void*, void*)", vtbl[3])
        local v_read  = ffi.cast("int (__thiscall*)(void*, void*, int, void*)", vtbl[0])
        local v_write = ffi.cast("int (__thiscall*)(void*, const void*, int, void*)", vtbl[1])
        local v_size  = ffi.cast("unsigned int (__thiscall*)(void*, void*)", vtbl[7])

        if not readfile then
            readfile = function(path)
                local h = v_open(fs, path, "r", nil)
                if h == nil or h == ffi.cast("void*", 0) then return nil end
                local sz = tonumber(v_size(fs, h))
                local buf = ffi.new("char[?]", sz + 1)
                v_read(fs, buf, sz, h)
                v_close(fs, h)
                return ffi.string(buf, sz)
            end
        end

        if not writefile then
            writefile = function(path, data)
                local h = v_open(fs, path, "w", nil)
                if h == nil or h == ffi.cast("void*", 0) then return false end
                local s = tostring(data)
                v_write(fs, s, #s, h)
                v_close(fs, h)
                return true
            end
        end
    end)
end

pcall(ffi.cdef, [[
    typedef struct { uint32_t lo; uint32_t hi; } ml_FILETIME;
    typedef struct {
        uint32_t   attrs;
        ml_FILETIME ctime; ml_FILETIME atime; ml_FILETIME wtime;
        uint32_t   size_hi; uint32_t size_lo;
    } ml_WIN32_FA_DATA;
]])

local cached_ft = ffi.new("ml_FILETIME")
local cached_fa = ffi.new("ml_WIN32_FA_DATA")

local winapi = {
    get_file_mtime = nil,
    get_system_time = nil,
}

pcall(function()
    local proxy_addr = client.find_signature("client.dll", string.char(0x51, 0xC3))
    local gm_patern = client.find_signature("client.dll", string.char(0xC6, 0x06, 0x00, 0xFF, 0x15, 0xCC, 0xCC, 0xCC, 0xCC, 0x50))
    local gp_patern = client.find_signature("client.dll", string.char(0x50, 0xFF, 0x15, 0xCC, 0xCC, 0xCC, 0xCC, 0x85, 0xC0, 0x0F, 0x84, 0xCC, 0xCC, 0xCC, 0xCC, 0x6A, 0x00))
    if not (proxy_addr and gm_patern and gp_patern) then return end

    local gm_addr = ffi.cast("void***", ffi.cast("char*", gm_patern) + 5)[0][0]
    local gm_proxy = ffi.cast("uintptr_t (__thiscall*)(void*, const char*)", proxy_addr)

    local gp_addr = ffi.cast("void***", ffi.cast("char*", gp_patern) + 3)[0][0]
    local gp_proxy = ffi.cast("uintptr_t (__thiscall*)(void*, uintptr_t, const char*)", proxy_addr)

    local h_k32 = gm_proxy(gm_addr, "kernel32.dll")
    if not h_k32 or h_k32 == 0 then return end

    local a_fa = gp_proxy(gp_addr, h_k32, "GetFileAttributesExA")
    if a_fa and a_fa ~= 0 then
        local proxy_fa = ffi.cast("int (__thiscall*)(uintptr_t, const char*, int, void*)", proxy_addr)
        winapi.get_file_mtime = function(path)
            if not path then return nil end
            local ok, ret = pcall(proxy_fa, a_fa, path, 0, cached_fa)
            if ok and ret ~= 0 then
                local hi = ffi.cast("uint64_t", cached_fa.wtime.hi)
                local lo = ffi.cast("uint64_t", cached_fa.wtime.lo)
                local ft = hi * 4294967296ULL + lo
                if ft > 116444736000000000ULL then
                    return tonumber((ft - 116444736000000000ULL) / 10000000ULL)
                end
            end
            return nil
        end
    end

    local a_time = gp_proxy(gp_addr, h_k32, "GetSystemTimeAsFileTime")
    if a_time and a_time ~= 0 then
        local proxy_time = ffi.cast("void (__thiscall*)(uintptr_t, void*)", proxy_addr)
        winapi.get_system_time = function()
            local ok = pcall(proxy_time, a_time, cached_ft)
            if ok then
                local hi = ffi.cast("uint64_t", cached_ft.hi)
                local lo = ffi.cast("uint64_t", cached_ft.lo)
                local ft = hi * 4294967296ULL + lo
                if ft > 116444736000000000ULL then
                    return tonumber((ft - 116444736000000000ULL) / 10000000ULL)
                end
            end
            return nil
        end
    end
end)

local function unix_now()
    if client and client.unix_time then
        local ok, t = pcall(client.unix_time)
        if ok and t and tonumber(t) and tonumber(t) > 1000000000 then return tonumber(t) end
    end
    if os and os.time then
        local ok, t = pcall(os.time)
        if ok and t and tonumber(t) and tonumber(t) > 1000000000 then return tonumber(t) end
    end
    if client and client.timestamp then
        local ok, ms = pcall(client.timestamp)
        if ok and ms and tonumber(ms) and tonumber(ms) > 1000000000000 then
            return math.floor(tonumber(ms) / 1000)
        end
    end
    if winapi.get_system_time then
        local ok, t = pcall(winapi.get_system_time)
        if ok and t and tonumber(t) and tonumber(t) > 1000000000 then return tonumber(t) end
    end
    return nil
end

local function parse_iso(str)
    if type(str) ~= "string" then return nil end
    local y, m, d, h, mi, s = str:match("(%d+)-(%d+)-(%d+)[T ](%d+):(%d+):(%d+)")
    if not y then return nil end
    y, m, d, h, mi, s = tonumber(y), tonumber(m), tonumber(d), tonumber(h), tonumber(mi), tonumber(s)
    local dbm = {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334}
    local days = (y - 1970) * 365 + math.floor((y - 1969) / 4) - math.floor((y - 1901) / 100) + math.floor((y - 1601) / 400)
    days = days + dbm[m] + (d - 1)
    if (y % 4 == 0 and (y % 100 ~= 0 or y % 400 == 0)) and m > 2 then days = days + 1 end
    return days * 86400 + h * 3600 + mi * 60 + s
end

local function file_mtime(s_name)
    if not s_name or s_name == "----" or s_name == "-" or is_separator(s_name) then return nil end
    if not winapi.get_file_mtime then return nil end
    local rel = script_relpath and script_relpath[s_name]
    local candidates = {
        rel and ("csgo/multi-loader/" .. rel),
        rel and ("multi-loader/" .. rel),
        "csgo/multi-loader/misc stuff/" .. s_name,
        "csgo/multi-loader/anti-aimbot/" .. s_name,
        "multi-loader/misc stuff/" .. s_name,
        "multi-loader/anti-aimbot/" .. s_name,
        "csgo/multi-loader/" .. s_name,
        "multi-loader/" .. s_name
    }
    for _, path in ipairs(candidates) do
        if path then
            local t = winapi.get_file_mtime(path)
            if t and t > 1000000000 then return t end
        end
    end
    return nil
end

local menu_color_ref   = ui.reference("MISC", "Settings", "Menu color")
local last_accent_hex  = nil

local function accent_hex()
    if menu_color_ref then
        local ok, r, g, b, a = pcall(ui.get, menu_color_ref)
        if ok and r then return string.format("\a%02X%02X%02XFF", r, g, b) end
    end
    return "\a909090FF"
end

local function url_enc(str)
    if not str then return "" end
    return (str:gsub("([^%w%-%_%.~])", function(c) return string.format("%%%02X", string.byte(c)) end))
end

local repo    = "pui-enjoyer/multi-loader"
local api_url = "https://api.github.com/repos/" .. repo .. "/git/trees/main?recursive=1"
local raw_url = "https://raw.githubusercontent.com/" .. repo .. "/main/scripts/"

local state = {
    connected   = true,
    err_code    = "404",
    last_update = globals.realtime(),
    last_idx    = 1,
    click_time  = 0,
    click_idx   = -1,
    updating    = false,
    loading     = true,
    load_start  = globals.realtime()
}

local scripts             = {}
local script_urls         = {}
local script_meta         = {}
local script_category     = {}
local script_relpath      = {}
local loaded              = {}
local script_load_times   = {}
local script_unload_times = {}
local script_file_times   = {}
local preset_load_times   = {}
local preset_unload_times = {}
local presets             = (database and database.read and database.read("multi_loader_presets")) or {}
local active_preset       = nil
local repo_updated_at     = nil

for _, p in ipairs(presets) do
    if not p.updated_at and database and database.read then
        p.updated_at = database.read("multi_loader_preset_updated_" .. p.name)
    end
end

do
    local default_global_scripts = {
        "Aimbot logs.lua", "Angelwings 2.6 debug.lua", "Antarctica paste.lua", "Autobuy.lua",
        "Breakables ragebot.lua", "Bullet tracers.lua", "Dormant aimbot.lua", "Emberlash AA.lua",
        "Esp eagle.lua", "Excellent cam.lua", "Fakepitch exploit.lua", "Fast ladder.lua",
        "Fastleaks loader.lua", "Glow health bar.lua", "Hitsound enhanced.lua", "Hysteria debug.lua",
        "Lagcomp box.lua", "Luasense AA.lua", "Nadehelper.lua", "Neverlose hotkeys.lua",
        "Scope overlay.lua", "Simple jumpscout.lua", "Solix AA.lua", "Unsafe charge.lua",
        "Visual fog.lua", "Wraith beta.lua",
    }

    local default_aa_scripts = {
        "AcatelBeta.lua", "Acidtech.lua", "Aesthetic.lua", "Aimtools.lua",
        "Alien.lua", "Alpha_gs.lua", "AlphaBuild.lua", "Alucard.lua",
        "Ambani.lua", "Amina-yaw.lua", "Amnesia.lua", "Amphibia.lua",
        "Ancient.lua", "Angelwings.lua", "Angelwingsfixxxxlasttt.lua", "Annesty.lua",
        "Anoflow.lua", "Antarcticareborn.lua", "Astra.lua", "Aura.lua",
        "Avensive.lua", "Bloodlust.lua", "Bloodstone.lua", "Bloomtool.lua",
        "Bluhgang.lua", "Bolt.lua", "Calypso.lua", "Carinthia.lua",
        "Chernobyl.lua", "CorsaResolver.lua", "Dangerous.lua", "Dash.lua",
        "Dejavu.lua", "Divine.lua", "Drainyaw.lua", "Ecstasy.lua",
        "Elders.lua", "Elixir.lua", "Emberlash.lua", "Emotional.lua",
        "Enderphobia.lua", "Enthusiasm.lua", "Ephoria.lua", "Eternity.lua",
        "Etternace.lua", "Everlast.lua", "Excellent.lua", "Exscord.lua",
        "Feelsense.lua", "Flax-yaw.lua", "Genesis.lua", "Genesisdump.lua",
        "Gloriosa-pasted.lua", "Halflife.lua", "Helios.lua", "Hellyaw.lua",
        "Hyperion.lua", "HysteriaDebug.lua", "Inferno.lua", "Infinixdump.lua",
        "Interitus.lua", "INVINSIBLE.lua", "Jitterdev.lua", "Kitten.lua",
        "Kittyhook.lua", "Komaru.lua", "Lavender.lua", "Leaf-recode.lua",
        "Leviatan.lua", "Lonely.lua", "Lotus.lua", "Luasense.lua",
        "Mercury.lua", "Metasetrecode.lua", "Mewtwotech.lua", "Mlc-yaw recode.lua",
        "Model_changer.lua", "Moisten.lua", "Momentum.lua", "Myth.lua",
        "Mytools.lua", "New hysteria.lua", "Nighcore.lua", "Nyahook.lua",
        "Omegamoe.lua", "Onesensedev.lua", "Opulent.lua", "Outlaw.lua",
        "Ozndump.lua", "Paradise.lua", "Rebellion.lua", "Resolverx.lua",
        "Rinnegan.lua", "Risen.lua", "Risennew.lua", "Romance.lua",
        "Sanchez.lua", "Senkotech.lua", "Serenity.lua", "Starlight.lua",
        "Stellar.lua", "Symmtest.lua", "Syphonic.lua", "Tabsense.lua",
        "Universe.lua", "Vandal.lua", "Venco.lua", "Venus.lua",
        "Winter.lua", "Wraith.lua", "Xo-yaw.lua", "Zephyrus.lua",
        "Zov-yaw.lua",
    }

    for _, sn in ipairs(default_global_scripts) do
        local rel = "misc stuff/" .. sn
        local enc_rel = "misc%20stuff/" .. url_enc(sn)
        local du = "https://raw.githubusercontent.com/" .. repo .. "/main/scripts/" .. enc_rel
        table.insert(scripts, sn)
        script_category[sn] = "Global storage"
        script_relpath[sn] = rel
        script_urls[sn] = du
        script_meta[sn] = { size = 0, sha = nil, url = du, updated_at = nil }
    end

    for _, sn in ipairs(default_aa_scripts) do
        local rel = "anti-aimbot/" .. sn
        local enc_rel = "anti-aimbot/" .. url_enc(sn)
        local du = "https://raw.githubusercontent.com/" .. repo .. "/main/scripts/" .. enc_rel
        table.insert(scripts, sn)
        script_category[sn] = "Anti-aimbot scripts"
        script_relpath[sn] = rel
        script_urls[sn] = du
        script_meta[sn] = { size = 0, sha = nil, url = du, updated_at = nil }
    end

    table.sort(scripts, function(a, b) return a:lower() < b:lower() end)
end

if database and database.read then
    local ok, v = pcall(database.read, "multi_loader_cached_meta")
    if ok and type(v) == "table" then script_meta = v end

    local ok2, v2 = pcall(database.read, "multi_loader_active_preset")
    if ok2 and type(v2) == "string" and #v2 > 0 then active_preset = v2 end

    local ok3, v3 = pcall(database.read, "multi_loader_repo_time")
    if ok3 and type(v3) == "number" and v3 > 0 then repo_updated_at = v3 end

    local ok4, v4 = pcall(database.read, "multi_loader_cached_scripts")
    local ok5, v5 = pcall(database.read, "multi_loader_cached_cat")
    local ok6, v6 = pcall(database.read, "multi_loader_cached_rel")
    if ok4 and type(v4) == "table" and #v4 >= 50 and ok5 and type(v5) == "table" and ok6 and type(v6) == "table" then
        local aa_cnt = 0
        for _, s in ipairs(v4) do
            if v5[s] == "Anti-aimbot scripts" then aa_cnt = aa_cnt + 1 end
        end
        if aa_cnt >= 20 then
            scripts = v4
            script_category = v5
            script_relpath = v6
        end
    end
end

local current_items = {}
local build_list, update_list, update_vis, toggle_preset, fetch_scripts, load_script, unload_script, check_autoload

local AA_SEPARATOR = "-- Only one AA lua can be selected"
local NO_AA_LABEL  = "No AA script loaded*"

local function is_separator(s)
    if not s or type(s) ~= "string" then return false end
    return s == AA_SEPARATOR
        or s == NO_AA_LABEL
        or s == "----"
        or s == "-"
        or s:find("Only one") ~= nil
        or s:find("No AA script") ~= nil
        or s:find("%-%-%-%-") ~= nil
        or s:find("%(No AA") ~= nil
end

local function is_aa_script(s)
    if not s or type(s) ~= "string" or is_separator(s) then return false end
    if script_category and script_category[s] == "Anti-aimbot scripts" then
        return true
    end
    if script_relpath and script_relpath[s] and script_relpath[s]:lower():find("anti%-aim") then
        return true
    end
    if s:lower():find("anti%-aim") then
        return true
    end
    return false
end

local function get_loaded_aa_scripts()
    local res = {}
    local seen = {}
    for s, is_on in pairs(loaded) do
        if is_on and is_aa_script(s) and not seen[s] then
            seen[s] = true
            table.insert(res, s)
        end
    end
    for s, sc in pairs(rt.scripts) do
        if sc and sc.active and is_aa_script(s) and not seen[s] then
            seen[s] = true
            table.insert(res, s)
        end
    end
    table.sort(res, function(a, b) return a:lower() < b:lower() end)
    return res
end

local function get_loaded_aa_script()
    local list = get_loaded_aa_scripts()
    return list[1]
end

local function build_preset_options(preset_data)
    local g_list = {}
    local seen = {}

    for _, s in ipairs(scripts) do
        if type(s) == "string" and s:find("%.lua$") and not seen[s] and not is_aa_script(s) and not is_separator(s) then
            seen[s] = true
            table.insert(g_list, s)
        end
    end
    table.sort(g_list, function(a, b) return a:lower() < b:lower() end)

    local opts = {}
    for _, s in ipairs(g_list) do
        table.insert(opts, s)
    end

    table.insert(opts, AA_SEPARATOR)

    local aa_seen = {}
    local aa_items = {}

    local loaded_aa = get_loaded_aa_scripts()
    for _, s in ipairs(loaded_aa) do
        if not aa_seen[s] then
            aa_seen[s] = true
            table.insert(aa_items, s)
        end
    end

    if preset_data and type(preset_data.scripts) == "table" then
        for _, s in ipairs(preset_data.scripts) do
            if is_aa_script(s) and not aa_seen[s] then
                aa_seen[s] = true
                table.insert(aa_items, s)
            end
        end
    end

    table.sort(aa_items, function(a, b) return a:lower() < b:lower() end)

    if #aa_items > 0 then
        for _, s in ipairs(aa_items) do
            table.insert(opts, s)
        end
    else
        table.insert(opts, NO_AA_LABEL)
    end

    return opts
end

local function sanitize_selection(raw_selected, last_selected)
    if type(raw_selected) ~= "table" then return {}, false end

    local last_set = {}
    if type(last_selected) == "table" then
        for _, s in ipairs(last_selected) do
            last_set[s] = true
        end
    end

    local globals_sel = {}
    local aa_sel = {}
    local raw_set = {}

    for _, s in ipairs(raw_selected) do
        if type(s) == "string" and not is_separator(s) and not raw_set[s] then
            raw_set[s] = true
            if is_aa_script(s) then
                table.insert(aa_sel, s)
            else
                table.insert(globals_sel, s)
            end
        end
    end

    local aa_changed = false
    if #aa_sel > 1 then
        local newly_added = nil
        for _, s in ipairs(aa_sel) do
            if not last_set[s] then
                newly_added = s
                break
            end
        end
        if newly_added then
            aa_sel = { newly_added }
        else
            aa_sel = { aa_sel[#aa_sel] }
        end
        aa_changed = true
    end

    local result = {}
    local res_set = {}
    for _, s in ipairs(globals_sel) do
        table.insert(result, s)
        res_set[s] = true
    end
    for _, s in ipairs(aa_sel) do
        table.insert(result, s)
        res_set[s] = true
    end

    local changed = aa_changed or (#result ~= #raw_selected)
    if not changed then
        for _, s in ipairs(raw_selected) do
            if not res_set[s] then
                changed = true
                break
            end
        end
    end

    return result, changed
end

for _, p in ipairs(presets) do
    if p.scripts then
        p.scripts = sanitize_selection(p.scripts, {})
    end
end

local menu = pui.group("config", "presets")

local refresh  = menu:button("Refresh script list", function() fetch_scripts() end)
local category = menu:combobox("\n", {"Global storage", "Anti-aimbot scripts"})
local list     = menu:listbox(" ", {""})
local info     = menu:label("Loading...")
local reload   = menu:checkbox("Save scripts locally")

if database and database.read then
    local ok, v = pcall(database.read, "multi_loader_category")
    if ok and type(v) == "string" and (v == "Anti-aimbot scripts" or v == "AA" or v == "Anti-aimbot") then
        category:set("Anti-aimbot scripts")
    end
end

category:set_callback(function()
    if database and database.write then
        pcall(database.write, "multi_loader_category", category:get())
        if database.flush then pcall(database.flush) end
    end
    state.last_idx = 1
    update_list()
end)

local default_preset_opts = build_preset_options()

local last_add_selection  = {}
local last_edit_selection = {}
local is_sanitizing_add   = false
local is_sanitizing_edit  = false
local is_setting_preset   = false

local name = menu:textbox("\n ")
name:set("")

local add = menu:multiselect("\n", default_preset_opts)
add:set({})

add:set_callback(function()
    if state.updating or is_sanitizing_add then return end
    local cur = add:get() or {}
    local sanitized, changed = sanitize_selection(cur, last_add_selection)
    if changed then
        is_sanitizing_add = true
        add:set(sanitized)
        is_sanitizing_add = false
    end
    last_add_selection = sanitized
end)

if database and database.read then
    local ok, v = pcall(database.read, "multi_loader_save_locally")
    if ok and type(v) == "boolean" then reload:set(v) end
end

local btn_load_script = menu:button("Load script", function()
    local item = current_items[list:get() + 1]
    if item and item.type == "script" then load_script(item.name) end
end)

local btn_unload_script = menu:button("Unload script", function()
    local item = current_items[list:get() + 1]
    if item and item.type == "script" then unload_script(item.name) end
end)

local edit_preset_scripts = menu:multiselect("\n", default_preset_opts)
edit_preset_scripts:set({})
edit_preset_scripts:set_visible(false)

local function sync_edit_preset()
    if state.updating or is_setting_preset or is_sanitizing_edit then return end
    local item = current_items[list:get() + 1]
    if not (item and item.type == "preset" and item.data) then return end

    local raw_sc = edit_preset_scripts:get() or {}
    local new_sc, changed = sanitize_selection(raw_sc, last_edit_selection)
    if changed then
        is_sanitizing_edit = true
        edit_preset_scripts:set(new_sc)
        is_sanitizing_edit = false
    end
    last_edit_selection = new_sc

    local old_sc    = item.data.scripts or {}
    item.data.scripts = new_sc
    local now = unix_now()
    item.data.updated_at = now

    for _, p in ipairs(presets) do
        if p.name == item.name then
            p.scripts    = new_sc
            p.updated_at = now
            break
        end
    end

    if database and database.write then
        pcall(database.write, "multi_loader_presets", presets)
        pcall(database.write, "multi_loader_preset_updated_" .. item.name, now)
        if database.flush then pcall(database.flush) end
    end

    if active_preset == item.name then
        local active_set = {}
        for _, s in ipairs(new_sc) do
            active_set[s] = true
            if not loaded[s] then load_script(s, true) end
        end
        for _, s in ipairs(old_sc) do
            if not active_set[s] and loaded[s] then unload_script(s, true) end
        end
        update_list()
    end
end

edit_preset_scripts:set_callback(sync_edit_preset)

local btn_load_preset = menu:button("Load preset", function()
    local item = current_items[list:get() + 1]
    if item and item.type == "preset" and active_preset ~= item.name then
        toggle_preset(item.data)
    end
end)

local btn_unload_preset = menu:button("Unload preset", function()
    local item = current_items[list:get() + 1]
    if item and item.type == "preset" and active_preset == item.name then
        toggle_preset(item.data)
    end
end)

local btn_delete_preset = menu:button("Delete preset", function()
    local item = current_items[list:get() + 1]
    if not (item and item.type == "preset") then return end

    if active_preset == item.name then toggle_preset(item.data) end

    for i, p in ipairs(presets) do
        if p.name == item.name then table.remove(presets, i) break end
    end

    if database and database.write then
        pcall(database.write, "multi_loader_presets", presets)
        pcall(database.write, "multi_loader_preset_updated_" .. item.name, nil)
        if database.flush then pcall(database.flush) end
    end

    for idx, it in ipairs(current_items) do
        if it.type == "new_preset" then
            state.last_idx = idx - 1
            list:set(state.last_idx)
            break
        end
    end
    update_list()
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
    local p_name      = name:get()
    local raw_scripts = add:get() or {}
    local p_scripts   = sanitize_selection(raw_scripts, last_add_selection)
    if p_name == "" or #p_scripts == 0 then return end

    local now   = unix_now()
    local found = false
    for _, p in ipairs(presets) do
        if p.name == p_name then
            p.scripts    = p_scripts
            p.updated_at = now
            found = true
            break
        end
    end
    if not found then
        table.insert(presets, {name = p_name, scripts = p_scripts, updated_at = now})
    end

    if database and database.write then
        pcall(database.write, "multi_loader_presets", presets)
        pcall(database.write, "multi_loader_preset_updated_" .. p_name, now)
        if database.flush then pcall(database.flush) end
    end
    name:set("")
    is_sanitizing_add = true
    add:set({})
    is_sanitizing_add = false
    last_add_selection = {}
    update_list()
end)

local function count_lines(str)
    if type(str) ~= "string" or #str == 0 then return 0 end
    local n = 1
    for _ in str:gmatch("\n") do n = n + 1 end
    return n
end

local function execute(body, s_name, silent)
    if type(body) ~= "string" then
        loaded[s_name] = nil
        if not silent then update_list(); update_vis() end
        return false
    end

    if body:sub(1, 3) == "\xEF\xBB\xBF" then body = body:sub(4) end

    local sc = rt.scripts[s_name]
    if not sc then
        sc = {active = true, ui_keys = {}, ui_refs = {}, load_counts = {}, callbacks = {}, timers = {}, shutdown_cbs = {}, ui_callbacks = {}, required_modules = {}}
        rt.scripts[s_name] = sc
    else
        sc.active = true
        sc.load_counts = {}; sc.callbacks = {}; sc.timers = {}; sc.shutdown_cbs = {}
        sc.ui_callbacks   = sc.ui_callbacks or {}
        sc.required_modules = sc.required_modules or {}
    end

    local fn, err = real_loadstring(body, s_name)
    if not fn then
        loaded[s_name] = nil
        if not silent then update_list(); update_vis() end
        return false
    end

    local env = make_env(s_name)
    if setfenv then setfenv(fn, env) end

    local prev_l, prev_c = rt.loading, rt.ctx
    rt.loading = s_name
    rt.ctx     = s_name

    local ok, run_err = pcall(fn)

    rt.loading = prev_l
    rt.ctx     = prev_c

    if not ok then
        unload_script(s_name, true)
        loaded[s_name] = nil
        if not silent then update_list(); update_vis() end
        return false
    end

    loaded[s_name] = true
    script_load_times[s_name] = globals.realtime()
    if not silent then update_list(); update_vis() end
    return true
end

local function http_get(s_name, cb)
    local rel = script_relpath and script_relpath[s_name] or s_name
    local enc_rel = rel:gsub("([^/]+)", function(part) return url_enc(part) end)
    local j_url   = "https://cdn.jsdelivr.net/gh/" .. repo .. "@main/scripts/" .. enc_rel
    local r_url   = raw_url .. enc_rel
    local primary = script_urls[s_name] or j_url

    http.get(primary, function(ok, resp)
        if ok and resp.status == 200 then cb(true, resp); return end
        local fallback = (primary == j_url) and r_url or j_url
        http.get(fallback, function(ok2, resp2)
            if ok2 and resp2.status == 200 then cb(true, resp2)
            else cb(false, resp or resp2) end
        end)
    end)
end

function load_script(s_name, silent)
    if not s_name or is_separator(s_name) or loaded[s_name] then return end

    loaded[s_name] = true
    if not silent then update_list() end

    local save_local = reload:get()
    local meta       = script_meta[s_name]
    local rel        = script_relpath and script_relpath[s_name] or s_name
    local local_raw  = nil
    local local_norm = nil

    if readfile then
        local candidates = {
            "multi-loader/" .. rel,
            "multi-loader/misc stuff/" .. s_name,
            "multi-loader/anti-aimbot/" .. s_name,
            "multi-loader/" .. s_name
        }
        for _, p in ipairs(candidates) do
            local ok, content = pcall(readfile, p)
            if ok and type(content) == "string" and #content > 0 then
                local_raw  = content
                local_norm = content:gsub("\r\n", "\n")
                break
            end
        end
    end

    if save_local then
        if local_raw then
            local local_sz = #local_norm
            local local_ln = count_lines(local_norm)
            local differs  = false

            if meta then
                local saved_sha   = database and database.read and database.read("multi_loader_sha_" .. s_name)
                local saved_lines = database and database.read and database.read("multi_loader_lines_" .. s_name)
                if meta.size and local_sz ~= meta.size then differs = true
                elseif meta.sha and saved_sha and saved_sha ~= meta.sha then differs = true
                elseif saved_lines and local_ln ~= saved_lines then differs = true end
            end

            if differs then
                http_get(s_name, function(ok, resp)
                    if ok and resp.status == 200 then
                        local new_ln = count_lines(resp.body)
                        ensure_dir("multi-loader")
                        ensure_dir("multi-loader/misc stuff")
                        ensure_dir("multi-loader/anti-aimbot")
                        if writefile then pcall(writefile, "multi-loader/" .. rel, resp.body) end
                        local now = unix_now()
                        local script_up = (meta and meta.updated_at) or repo_updated_at
                        if script_up then script_file_times[s_name] = script_up end
                        if database and database.write then
                            if meta and meta.sha then pcall(database.write, "multi_loader_sha_" .. s_name, meta.sha) end
                            pcall(database.write, "multi_loader_size_"       .. s_name, #resp.body)
                            pcall(database.write, "multi_loader_lines_"      .. s_name, new_ln)
                            if script_up then pcall(database.write, "multi_loader_updated_" .. s_name, script_up) end
                            if now then pcall(database.write, "multi_loader_downloaded_" .. s_name, now) end
                            if database.flush then pcall(database.flush) end
                        end
                        execute(resp.body, s_name, silent)
                    else
                        if local_raw then execute(local_raw, s_name, silent)
                        else
                            loaded[s_name] = nil
                            if not silent then update_list() end
                        end
                    end
                end)
            else
                execute(local_raw, s_name, silent)
            end
        else
            http_get(s_name, function(ok, resp)
                if not ok or resp.status ~= 200 then
                    loaded[s_name] = nil
                    if not silent then update_list() end
                    return
                end
                local new_ln = count_lines(resp.body)
                ensure_dir("multi-loader")
                ensure_dir("multi-loader/misc stuff")
                ensure_dir("multi-loader/anti-aimbot")
                if writefile then pcall(writefile, "multi-loader/" .. rel, resp.body) end
                local now = unix_now()
                local script_up = (meta and meta.updated_at) or repo_updated_at
                if script_up then script_file_times[s_name] = script_up end
                if database and database.write then
                    if meta and meta.sha then pcall(database.write, "multi_loader_sha_" .. s_name, meta.sha) end
                    pcall(database.write, "multi_loader_size_"       .. s_name, #resp.body)
                    pcall(database.write, "multi_loader_lines_"      .. s_name, new_ln)
                    if script_up then pcall(database.write, "multi_loader_updated_" .. s_name, script_up) end
                    if now then pcall(database.write, "multi_loader_downloaded_" .. s_name, now) end
                    if database.flush then pcall(database.flush) end
                end
                execute(resp.body, s_name, silent)
            end)
        end
    else
        http_get(s_name, function(ok, resp)
            if ok and resp.status == 200 then
                execute(resp.body, s_name, silent)
            elseif local_raw then
                execute(local_raw, s_name, silent)
            else
                loaded[s_name] = nil
                if not silent then update_list() end
            end
        end)
    end
end

function unload_script(s_name, silent)
    if not s_name or is_separator(s_name) or (not loaded[s_name] and not (rt.scripts[s_name] and rt.scripts[s_name].active)) then return end

    local sc = rt.scripts[s_name]
    if sc then
        sc.active = false

        for _, fn in ipairs(sc.shutdown_cbs) do
            local prev = rt.ctx; rt.ctx = s_name
            pcall(fn)
            rt.ctx = prev
        end
        sc.shutdown_cbs = {}

        for _, cb in ipairs(sc.callbacks) do
            pcall(real_unset_event_cb, cb.event, cb.wrapped)
        end
        sc.callbacks = {}

        sc.timers = {}

        if sc.ui_callbacks then
            for ref in pairs(sc.ui_callbacks) do
                pcall(real_set_cb, ref, function() end)
            end
            sc.ui_callbacks = {}
        end

        for _, ref in ipairs(sc.ui_refs) do
            pcall(real_set_visible, ref, false)
            pcall(real_set_enabled, ref, false)
        end

        if sc.required_modules then
            for _, mod in ipairs(sc.required_modules) do
                package.loaded[mod] = nil
            end
            sc.required_modules = {}
        end
    end

    loaded[s_name] = nil
    script_unload_times[s_name] = globals.realtime()
    if not silent then update_list(); update_vis() end
end

function toggle_preset(p)
    if not p then return end

    if active_preset == p.name then
        active_preset = nil
        preset_unload_times[p.name] = globals.realtime()
        for _, s in ipairs(p.scripts or {}) do
            if not is_separator(s) then unload_script(s, true) end
        end
    else
        if active_preset then
            preset_unload_times[active_preset] = globals.realtime()
            for _, prev_p in ipairs(presets) do
                if prev_p.name == active_preset then
                    for _, s in ipairs(prev_p.scripts or {}) do
                        if not is_separator(s) then unload_script(s, true) end
                    end
                end
            end
        end
        active_preset = p.name
        preset_load_times[p.name] = globals.realtime()
        for _, s in ipairs(p.scripts or {}) do
            if not is_separator(s) then load_script(s, true) end
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
                if not is_separator(s) then load_script(s, true) end
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

local function finish_fetch()
    table.sort(scripts, function(a, b) return a:lower() < b:lower() end)

    if #scripts >= 50 and database and database.write then
        local aa_cnt = 0
        for _, s in ipairs(scripts) do
            if script_category[s] == "Anti-aimbot scripts" then aa_cnt = aa_cnt + 1 end
        end
        if aa_cnt >= 20 then
            pcall(database.write, "multi_loader_cached_scripts", scripts)
            pcall(database.write, "multi_loader_cached_meta", script_meta)
            pcall(database.write, "multi_loader_cached_cat", script_category)
            pcall(database.write, "multi_loader_cached_rel", script_relpath)
            if database.flush then pcall(database.flush) end
        end
    end

    if #scripts > 0 then
        local cur_idx = list and list:get()
        local cur_it = cur_idx and current_items and current_items[cur_idx + 1]
        local edit_data = (cur_it and cur_it.type == "preset") and cur_it.data or nil
        pcall(ui.update, add.ref, build_preset_options())
        pcall(ui.update, edit_preset_scripts.ref, build_preset_options(edit_data))

        local valid, norm_map = {}, {}
        for _, s in ipairs(scripts) do
            if not is_separator(s) then
                valid[s] = true
                norm_map[s:gsub("%b[]", ""):gsub("%s+", ""):lower()] = s
            end
        end

        for _, p in ipairs(presets) do
            if p.scripts then
                local clean = {}
                for _, s in ipairs(p.scripts) do
                    if not is_separator(s) and valid[s] then
                        table.insert(clean, s)
                    elseif not is_separator(s) then
                        local norm = norm_map[s:gsub("%b[]", ""):gsub("%s+", ""):lower()]
                        if norm then table.insert(clean, norm) end
                    end
                end
                p.scripts = sanitize_selection(clean, {})
            end
        end

        local cur = add:get()
        if type(cur) == "table" and #cur > 0 then
            local clean = {}
            for _, s in ipairs(cur) do
                if not is_separator(s) and valid[s] then
                    table.insert(clean, s)
                elseif not is_separator(s) then
                    local norm = norm_map[s:gsub("%b[]", ""):gsub("%s+", ""):lower()]
                    if norm then table.insert(clean, norm) end
                end
            end
            clean = sanitize_selection(clean, last_add_selection)
            is_sanitizing_add = true
            add:set(clean)
            is_sanitizing_add = false
            last_add_selection = clean
        end
    end

    check_autoload()
    update_list()
end

function fetch_scripts()
    state.loading    = true
    state.load_start = globals.realtime()
    update_list()

    local json = ml_json()

    http.get("https://github.com/" .. repo .. "/commits/main.atom", function(ok, resp)
        if ok and resp.status == 200 and type(resp.body) == "string" then
            local iso = resp.body:match("<updated>([^<]+)</updated>")
            if iso then
                local ts = parse_iso(iso)
                if ts and ts > 1000000000 then
                    repo_updated_at = ts
                    if database and database.write then
                        pcall(database.write, "multi_loader_repo_time", ts)
                        if database.flush then pcall(database.flush) end
                    end
                end
            end
        end
    end)

    local function apply_manifest(data)
        if not (type(data) == "table" and type(data.scripts) == "table" and #data.scripts >= 20) then
            return false
        end

        if data.updated_at and tonumber(data.updated_at) then
            repo_updated_at = tonumber(data.updated_at)
            if database and database.write then
                pcall(database.write, "multi_loader_repo_time", repo_updated_at)
            end
        end

        local new_s, new_u, new_m = {}, {}, {}
        local new_c, new_r = {}, {}

        for _, item in ipairs(data.scripts) do
            if item.name and item.relpath then
                local sn = item.name
                local cat = item.category or "Global storage"
                local rel = item.relpath
                local folder = rel:match("^([^/]+)/") or "misc stuff"
                local enc_rel = url_enc(folder) .. "/" .. url_enc(sn)
                local du = "https://raw.githubusercontent.com/" .. repo .. "/main/scripts/" .. enc_rel
                local up = tonumber(item.updated_at)
                table.insert(new_s, sn)
                new_u[sn] = du
                new_m[sn] = { size = item.size, sha = item.sha, url = du, updated_at = up }
                new_c[sn] = cat
                new_r[sn] = rel
            end
        end

        if #new_s >= 20 then
            state.last_update = globals.realtime()
            state.loading = false
            state.connected = true
            scripts, script_urls, script_meta = new_s, new_u, new_m
            script_category, script_relpath = new_c, new_r
            finish_fetch()
            return true
        end
        return false
    end

    local cache_buster = "?v=" .. (unix_now() or math.floor(globals.realtime()))
    local raw_manifest_url = "https://raw.githubusercontent.com/" .. repo .. "/main/manifest.json" .. cache_buster
    http.get(raw_manifest_url, function(ok, resp)
        if ok and resp.status == 200 then
            local ok2, data = pcall(json.parse, resp.body)
            if ok2 and apply_manifest(data) then return end
        end

        local cdn_manifest_url = "https://cdn.jsdelivr.net/gh/" .. repo .. "@main/manifest.json" .. cache_buster
        http.get(cdn_manifest_url, function(ok2, resp2)
            if ok2 and resp2.status == 200 then
                local ok3, data2 = pcall(json.parse, resp2.body)
                if ok3 and apply_manifest(data2) then return end
            end

            local tree_url = "https://api.github.com/repos/" .. repo .. "/git/trees/main?recursive=1"
            http.get(tree_url, function(ok3, resp3)
                if ok3 and resp3.status == 200 then
                    local ok4, data3 = pcall(json.parse, resp3.body)
                    if ok4 and type(data3) == "table" and type(data3.tree) == "table" then
                        local found_s, found_u, found_m = {}, {}, {}
                        local found_c, found_r = {}, {}
                        local fallback_up = repo_updated_at or (database and database.read and database.read("multi_loader_repo_time"))
                        for _, item in ipairs(data3.tree) do
                            if item.type == "blob" and item.path and item.path:find("%.lua$") then
                                local folder, sn = item.path:match("^scripts/([^/]+)/(.+%.lua)$")
                                if not folder then
                                    sn = item.path:match("^scripts/(.+%.lua)$")
                                    folder = "misc stuff"
                                end
                                if sn then
                                    local f_low = folder:lower()
                                    local cat = (f_low:find("anti%-aim") or f_low == "aa") and "Anti-aimbot scripts" or "Global storage"
                                    if #sn > 0 then sn = sn:sub(1, 1):upper() .. sn:sub(2) end
                                    local rel = folder .. "/" .. sn
                                    local enc_rel = url_enc(folder) .. "/" .. url_enc(sn)
                                    local du = "https://raw.githubusercontent.com/" .. repo .. "/main/scripts/" .. enc_rel
                                    local prev_up = script_meta[sn] and script_meta[sn].updated_at
                                    table.insert(found_s, sn)
                                    found_u[sn] = du
                                    found_m[sn] = { size = item.size, sha = item.sha, url = du, updated_at = prev_up or fallback_up }
                                    found_c[sn] = cat
                                    found_r[sn] = rel
                                end
                            end
                        end
                        if #found_s >= 20 then
                            state.last_update = globals.realtime()
                            state.loading = false
                            state.connected = true
                            scripts, script_urls, script_meta = found_s, found_u, found_m
                            script_category, script_relpath = found_c, found_r
                            finish_fetch()
                            return
                        end
                    end
                end

                state.loading = false
                if #scripts > 0 then
                    state.connected = true
                    state.last_update = globals.realtime()
                    finish_fetch()
                else
                    state.connected = false
                    state.err_code = "Offline"
                    check_autoload()
                    update_list()
                end
            end)
        end)
    end)
end

function build_list()
    if not state.connected and #scripts == 0 then
        current_items = {{type = "error"}}
        return {"Failed to connect: " .. state.err_code}
    end

    local display = {}
    current_items = {}

    local current_cat = category and category:get() or "Global storage"
    local hdr_title = (current_cat == "Anti-aimbot scripts") and "AA SCRIPTS" or "GLOBAL STORAGE"
    local hdr = state.connected and ("\a57575770 --= " .. hdr_title .. " =--")
                                 or ("\a57575770 --= " .. hdr_title .. " (OFFLINE) =--")
    table.insert(display, hdr)
    table.insert(current_items, {type = "header"})

    if state.loading and #scripts == 0 then
        table.insert(display, "\a808080FFLoading...")
        table.insert(current_items, {type = "loading"})
    else
        local acc = accent_hex()
        local count = 0
        for _, s in ipairs(scripts) do
            local s_cat = script_category[s] or "Global storage"
            if s_cat == current_cat then
                count = count + 1
                local on    = not not loaded[s]
                local dname = s:gsub("%.lua$", ""):gsub("^%b[]%s*", ""):gsub("%s*%b[]$", "")
                if #dname > 0 then
                    dname = dname:sub(1, 1):upper() .. dname:sub(2)
                end
                table.insert(display, (on and acc or "\aC8C8C8FF") .. dname)
                table.insert(current_items, {type = "script", name = s})
            end
        end
        if count == 0 and not state.loading then
            table.insert(display, "\a808080FFNo scripts in this category")
            table.insert(current_items, {type = "empty"})
        end
    end

    table.insert(display, "\a57575770 --= AUTOLOAD =--")
    table.insert(current_items, {type = "header"})

    table.insert(display, "\a757575FF[+] New preset")
    table.insert(current_items, {type = "new_preset"})

    local acc = accent_hex()
    for _, p in ipairs(presets) do
        local active = (active_preset == p.name)
        local dname  = p.name:gsub("%.lua$", ""):gsub("^%b[]%s*", ""):gsub("%s*%b[]$", "")
        table.insert(display, (active and acc or "\aC8C8C8FF") .. dname)
        table.insert(current_items, {type = "preset", name = p.name, data = p})
    end

    return display
end

function update_list()
    state.updating = true
    local display  = build_list()
    list:update(display)

    local cur      = list:get()
    local cur_item = current_items[cur + 1]

    if not cur_item or cur_item.type == "header" or cur_item.type == "loading" then
        local target = nil
        if state.last_idx and current_items[state.last_idx + 1] and current_items[state.last_idx + 1].type ~= "header" and current_items[state.last_idx + 1].type ~= "loading" then
            target = state.last_idx
        else
            for i, it in ipairs(current_items) do
                if it.type == "script" then target = i - 1; break end
            end
            if not target then
                for i, it in ipairs(current_items) do
                    if it.type == "preset" or it.type == "new_preset" then target = i - 1; break end
                end
            end
        end
        if target then
            state.last_idx = target
            list:set(target)
        end
    end

    state.updating = false
    update_vis()
end

local last_info = ""

local function fmt_ago(prefix, t)
    if not t or t <= 0 then return "Not updated" end
    local now = unix_now()
    if not now then return prefix .. " previously" end
    local diff = now - t
    if diff < 0 then
        if diff >= -300 then
            return prefix .. " just now"
        else
            return prefix .. " recently"
        end
    end
    if diff < 60 then
        return prefix .. " just now"
    end
    local sec = math.floor(diff)
    if sec < 3600 then
        local m = math.floor(sec / 60)
        return string.format("%s %d minute%s ago", prefix, m, m == 1 and "" or "s")
    elseif sec < 86400 then
        local h = math.floor(sec / 3600)
        return string.format("%s %d hour%s ago", prefix, h, h == 1 and "" or "s")
    elseif sec < 86400 * 7 then
        local d = math.floor(sec / 86400)
        return string.format("%s %d day%s ago", prefix, d, d == 1 and "" or "s")
    elseif sec < 86400 * 30 then
        local w = math.floor(sec / (86400 * 7))
        return string.format("%s %d week%s ago", prefix, w, w == 1 and "" or "s")
    elseif sec < 86400 * 365 then
        local mo = math.floor(sec / (86400 * 30))
        return string.format("%s %d month%s ago", prefix, mo, mo == 1 and "" or "s")
    else
        local y = math.floor(sec / (86400 * 365))
        return string.format("%s %d year%s ago", prefix, y, y == 1 and "" or "s")
    end
end

local pending_time_requests = {}
local get_info_text = nil
local request_script_time = nil

request_script_time = function(s_name)
    if not s_name or s_name == "----" or s_name == "-" or is_separator(s_name) or pending_time_requests[s_name] then return end
    local rel = script_relpath and script_relpath[s_name]
    if not rel then
        local is_aa = is_aa_script(s_name)
        rel = (is_aa and "anti-aimbot/" or "misc stuff/") .. s_name
    end

    if database and database.read then
        local saved = database.read("multi_loader_gh_time_" .. s_name)
        if saved and type(saved) == "number" and saved > 1000000000 then
            if not script_meta[s_name] then script_meta[s_name] = {} end
            script_meta[s_name].updated_at = saved
            return
        end
    end

    pending_time_requests[s_name] = true

    local folder = rel:match("^([^/]+)/") or (is_aa_script(s_name) and "anti-aimbot" or "misc stuff")
    local enc_rel = url_enc(folder) .. "/" .. url_enc(s_name)
    local atom_url = "https://github.com/" .. repo .. "/commits/main/scripts/" .. enc_rel .. ".atom"

    http.get(atom_url, function(ok, resp)
        if ok and resp.status == 200 and type(resp.body) == "string" then
            local iso = resp.body:match("<updated>([^<]+)</updated>")
            if iso then
                local ts = parse_iso(iso)
                if ts and ts > 1000000000 then
                    pending_time_requests[s_name] = nil
                    if not script_meta[s_name] then script_meta[s_name] = {} end
                    script_meta[s_name].updated_at = ts
                    if database and database.write then
                        pcall(database.write, "multi_loader_gh_time_" .. s_name, ts)
                        if database.flush then pcall(database.flush) end
                    end
                    local cur_idx = list and list:get()
                    local cur_item = cur_idx and current_items and current_items[cur_idx + 1]
                    if cur_item and cur_item.type == "script" and cur_item.name == s_name then
                        if get_info_text then
                            local txt = get_info_text()
                            if txt ~= last_info then
                                last_info = txt
                                info:set(txt)
                            end
                        end
                    end
                    return
                end
            end
        end

        local api_commit_url = "https://api.github.com/repos/" .. repo .. "/commits?path=" .. url_enc("scripts/" .. folder .. "/" .. s_name) .. "&page=1&per_page=1"
        http.get(api_commit_url, function(ok2, resp2)
            pending_time_requests[s_name] = nil
            if ok2 and resp2.status == 200 and type(resp2.body) == "string" then
                local iso2 = resp2.body:match('"date"%s*:%s*"(%d+%-%d+%-%d+T%d+:%d+:%d+)Z?"') or resp2.body:match('"date"%s*:%s*"([^"]+)"')
                if iso2 then
                    local ts2 = parse_iso(iso2)
                    if ts2 and ts2 > 1000000000 then
                        if not script_meta[s_name] then script_meta[s_name] = {} end
                        script_meta[s_name].updated_at = ts2
                        if database and database.write then
                            pcall(database.write, "multi_loader_gh_time_" .. s_name, ts2)
                            if database.flush then pcall(database.flush) end
                        end
                        local cur_idx = list and list:get()
                        local cur_item = cur_idx and current_items and current_items[cur_idx + 1]
                        if cur_item and cur_item.type == "script" and cur_item.name == s_name then
                            if get_info_text then
                                local txt = get_info_text()
                                if txt ~= last_info then
                                    last_info = txt
                                    info:set(txt)
                                end
                            end
                        end
                        return
                    end
                end
            end
            local cur_idx = list and list:get()
            local cur_item = cur_idx and current_items and current_items[cur_idx + 1]
            if cur_item and cur_item.type == "script" and cur_item.name == s_name then
                if get_info_text then
                    local txt = get_info_text()
                    if txt ~= last_info then
                        last_info = txt
                        info:set(txt)
                    end
                end
            end
        end)
    end)
end

get_info_text = function()
    if state.loading then
        local step = math.floor((globals.realtime() - state.load_start) / 0.25) % 3 + 1
        return "Loading" .. string.rep(".", step)
    end
    if not state.connected and #scripts == 0 then
        return "Failed to connect: " .. state.err_code
    end

    local idx  = list:get()
    local item = current_items[idx + 1]

    if not item or item.type == "header" or item.type == "empty" then
        local current_cat = category and category:get() or "Global storage"
        local count = 0
        for _, s in ipairs(scripts) do
            if (script_category[s] or "Global storage") == current_cat then count = count + 1 end
        end
        return string.format("%d script%s available", count, count == 1 and "" or "s")
    end

    if item.type == "script" then
        local s_name = item.name
        local mtime  = file_mtime(s_name)

        local gh_time = (script_meta[s_name] and script_meta[s_name].updated_at)
        if not gh_time and database and database.read then
            local db_t = database.read("multi_loader_gh_time_" .. s_name)
            if db_t and type(db_t) == "number" and db_t > 1000000000 then
                gh_time = db_t
                if script_meta[s_name] then script_meta[s_name].updated_at = db_t end
            end
        end

        if not gh_time and request_script_time then
            request_script_time(s_name)
        end

        local t = nil
        if mtime and gh_time then
            t = (mtime > gh_time) and mtime or gh_time
        elseif gh_time then
            t = gh_time
        elseif mtime then
            t = mtime
        end

        if not t and database and database.read then
            local saved_up = database.read("multi_loader_updated_" .. s_name)
            if saved_up and type(saved_up) == "number" and saved_up > 1000000000 then
                t = saved_up
            end
        end

        if t and t > 1000000000 then
            return fmt_ago("Updated", t)
        elseif pending_time_requests[s_name] then
            return "Checking update time..."
        elseif repo_updated_at and repo_updated_at > 1000000000 then
            return fmt_ago("Updated", repo_updated_at)
        else
            return "Not updated"
        end
    elseif item.type == "preset" then
        local p = item.data
        local t = (p and p.updated_at) or (database and database.read and database.read("multi_loader_preset_updated_" .. item.name))
        return t and fmt_ago("Updated", t) or "Not updated"
    elseif item.type == "new_preset" then
        return "Auto-loads selected scripts"
    else
        local current_cat = category and category:get() or "Global storage"
        local count = 0
        for _, s in ipairs(scripts) do
            if (script_category[s] or "Global storage") == current_cat then count = count + 1 end
        end
        return string.format("%d script%s available", count, count == 1 and "" or "s")
    end
end

local was_new = false

function update_vis()
    local idx  = list:get()
    local item = current_items[idx + 1]

    if item and (item.type == "header" or item.type == "loading" or item.type == "error" or item.type == "empty") then
        if state.last_idx and current_items[state.last_idx + 1] and current_items[state.last_idx + 1].type ~= "header" and current_items[state.last_idx + 1].type ~= "empty" then
            idx  = state.last_idx
            item = current_items[idx + 1]
        end
    end

    if not item or item.type == "error" or item.type == "empty" then
        local err_txt = (item and item.type == "empty") and "Category is empty" or ("Failed to connect: " .. state.err_code)
        if err_txt ~= last_info then last_info = err_txt; info:set(err_txt) end
        btn_load_script:set_visible(false); btn_unload_script:set_visible(false)
        btn_load_preset:set_visible(false); btn_unload_preset:set_visible(false)
        btn_delete_preset:set_visible(false); edit_preset_scripts:set_visible(false)
        spacer1:set_visible(false); spacer2:set_visible(false)
        spacer3:set_visible(false); spacer4:set_visible(false)
        btn_create:set_visible(false); name:set_visible(false); add:set_visible(false)
        was_new = false
        return
    end

    local txt = get_info_text()
    if txt ~= last_info then last_info = txt; info:set(txt) end

    local is_new    = (item.type == "new_preset")
    local is_script = (item.type == "script")
    local is_preset = (item.type == "preset")

    local s_on      = is_script and not not loaded[item.name]
    local show_ls   = is_script and not s_on
    local show_us   = is_script and s_on
    local p_on      = is_preset and (active_preset == item.name)
    local show_lp   = is_preset and not p_on
    local show_up   = is_preset and p_on

    -- show first to prevent scrollbar collapse
    if show_ls then btn_load_script:set_visible(true) end
    if show_us then btn_unload_script:set_visible(true) end
    if show_lp then btn_load_preset:set_visible(true) end
    if show_up then btn_unload_preset:set_visible(true) end
    if is_script then
        spacer1:set_visible(true); spacer2:set_visible(true)
        spacer3:set_visible(true); spacer4:set_visible(true)
    end
    if is_preset then
        edit_preset_scripts:set_visible(true)
        btn_delete_preset:set_visible(true)
    end

    if is_preset and item.data then
        is_setting_preset = true
        local preset_opts = build_preset_options(item.data)
        pcall(ui.update, edit_preset_scripts.ref, preset_opts)
        local sanitized = sanitize_selection(item.data.scripts or {}, {})
        last_edit_selection = sanitized
        edit_preset_scripts:set(sanitized)
        is_setting_preset = false
    end

    if is_new then
        name:set_visible(true); add:set_visible(true); btn_create:set_visible(true)
        local preset_opts = build_preset_options()
        pcall(ui.update, add.ref, preset_opts)
        if not was_new then
            local loaded_aa = get_loaded_aa_script()
            local init_sel = {}
            for _, s in ipairs(scripts) do
                if loaded[s] and not is_separator(s) and not is_aa_script(s) then
                    table.insert(init_sel, s)
                end
            end
            if loaded_aa then
                table.insert(init_sel, loaded_aa)
            end
            is_sanitizing_add = true
            add:set(init_sel)
            is_sanitizing_add = false
            last_add_selection = init_sel
        end
    end
    was_new = is_new

    -- then hide
    if not show_ls then btn_load_script:set_visible(false) end
    if not show_us then btn_unload_script:set_visible(false) end
    if not show_lp then btn_load_preset:set_visible(false) end
    if not show_up then btn_unload_preset:set_visible(false) end
    if not is_script then
        spacer1:set_visible(false); spacer2:set_visible(false)
        spacer3:set_visible(false); spacer4:set_visible(false)
    end
    if not is_preset then
        edit_preset_scripts:set_visible(false)
        btn_delete_preset:set_visible(false)
    end
    if not is_new then
        name:set_visible(false); add:set_visible(false); btn_create:set_visible(false)
    end
end

list:set_callback(function()
    if state.updating then return end

    local idx  = list:get()
    local item = current_items[idx + 1]
    if not item then return end

    if item.type == "header" or item.type == "loading" or item.type == "error" or item.type == "empty" then
        state.updating = true
        if state.last_idx and state.last_idx < #current_items and current_items[state.last_idx + 1] and current_items[state.last_idx + 1].type ~= "header" and current_items[state.last_idx + 1].type ~= "empty" then
            list:set(state.last_idx)
        else
            for i, it in ipairs(current_items) do
                if it.type == "new_preset" or it.type == "script" then
                    state.last_idx = i - 1
                    list:set(state.last_idx)
                    break
                end
            end
        end
        state.updating = false
        update_vis()
        return
    end

    state.last_idx = idx

    local now = globals.realtime()
    if state.click_idx == idx and (now - state.click_time) < 0.5 then
        state.click_idx  = -1
        state.click_time = 0

        if item.type == "script" then
            if loaded[item.name] then unload_script(item.name)
            else load_script(item.name) end
            return
        elseif item.type == "preset" then
            toggle_preset(item.data)
            return
        end
    else
        state.click_idx  = idx
        state.click_time = now
    end

    update_vis()
end)

reload:set_callback(function()
    if database and database.write then
        pcall(database.write, "multi_loader_save_locally", reload:get())
        if database.flush then pcall(database.flush) end
    end
end)

local last_step      = -1
local last_sec       = -1
local last_sel       = -1

client.set_event_callback("paint_ui", function()
    if not ui.is_menu_open() then return end

    local acc = accent_hex()
    if last_accent_hex == nil then
        last_accent_hex = acc
    elseif acc ~= last_accent_hex then
        last_accent_hex = acc
        update_list()
    end

    if state.loading then
        local step = math.floor((globals.realtime() - state.load_start) / 0.25) % 3 + 1
        if step ~= last_step then
            last_step = step
            local txt = "Loading" .. string.rep(".", step)
            if txt ~= last_info then last_info = txt; info:set(txt) end
        end
        return
    end

    local cur_sec = math.floor(globals.realtime())
    local cur_idx = list:get()
    if cur_sec == last_sec and cur_idx == last_sel then return end
    last_sec = cur_sec
    last_sel = cur_idx

    local txt = get_info_text()
    if txt ~= last_info then last_info = txt; info:set(txt) end
end)

if menu_color_ref then
    pcall(ui.set_callback, menu_color_ref, function()
        last_accent_hex = accent_hex()
        update_list()
    end)
end

update_list()
fetch_scripts()

real_set_event_cb("shutdown", function()
    for s_name in pairs(loaded) do unload_script(s_name, true) end
    for _, sc in pairs(rt.scripts) do
        if sc.active then
            for _, ref in ipairs(sc.ui_refs) do
                pcall(real_set_visible, ref, false)
                pcall(real_set_enabled, ref, false)
            end
        end
    end
end)
