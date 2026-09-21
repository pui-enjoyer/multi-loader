local function U(ffi)
    local ok, r = pcall(require, ffi);
    if not ok then
        error("Failed to load library '" .. ffi .. "'")
    end
    return r;
end

local b = globals.curtime() * (7 * 6107);
math.randomseed(b);

local visuals_things = {}
-- credits to emberlash team https://discord.com/invite/jPZGS7wnYQ
-- fixed and updated by funtazzy
-- tg: @funtazzy; discord: funtazzy
-- yep, thx claude cowork for helping with some of this code
-- AND,LORDMOUSE I LOVE U, HARDSYNC #1

-- i removed all of my comments, sry<3
-- uwu

local ffi = U("ffi");
local h = U("vector");
local S = U("gamesense/pui");
local base64 = U("gamesense/base64");
local images = U("gamesense/images");
local C = U("gamesense/antiaim_funcs");
local i = U("gamesense/csgo_weapons");
local v = U("gamesense/entity");
local l = U("gamesense/trace");
local Z = U("gamesense/surface");
local _ = U("gamesense/http");
local clipboard = U("gamesense/clipboard")
local U = {};
do
    local c = {
        ["lordmouse's emberlash renewed"] = {"Renewed", 1},
        ["lordmouse's emberlash lilith"] = {"Lilith", 2},
        ["lordmouse's emberlash supermegaprivate"] = {"Nightly", 3},
        ["lordmouse's emberlash exclusive"] = {"funclusive", 4}
    };
    do
        local F = c["lordmouse's emberlash exclusive"];
        U.build, U.level = F[1], 4;
    end
    U.build_num = 8
    U.name = "Emberlash";
    U.version = "v3";
    U.username = "funtazzy";
end

local helper = {}
local groups = {
    aa = {
        angles = S.group("AA", "Anti-aimbot angles"),
        fake_lag = S.group("AA", "Fake lag"),
        other = S.group("AA", "Other")
    },
    lua ={
        a = S.group("Lua", "a"),
        b = S.group("Lua", "b")
    }
};
Menu = {
    aa = {
        addons = {},
        angles = {
            preset_info = {}
        },
        builder = {},
        hotkeys = {}
    },
    visuals = {},
    misc = {},
    debug_ui = groups.lua.a:checkbox("emberlash - show hidden ui (debug)")
}
Menu.debug_ui:set_visible(false)

local function table_contains(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end
local c = {};
c.rage = {
    aimbot = {
        enabled = {S.reference("rage", "aimbot", "enabled")},
        target_selection = S.reference("rage", "aimbot", "target selection"),
        target_hitbox = S.reference("rage", "aimbot", "target hitbox"),
        mp_scale = S.reference("rage", "aimbot", "multi-point scale"),
        minimum_damage = S.reference("rage", "aimbot", "minimum damage"),
        minimum_damage_override = {S.reference("rage", "aimbot", "minimum damage override")},
        minimum_hitchance = S.reference("rage", "aimbot", "minimum hit chance"),
        double_tap = {S.reference("rage", "aimbot", "double tap")},
        double_tap_limit = S.reference("rage", "aimbot", "double tap fake lag limit"),
        force_body = S.reference("rage", "aimbot", "force body aim"),
        force_safe = S.reference("rage", "aimbot", "force safe point"),
        auto_scope = S.reference("rage", "aimbot", "automatic scope")
    },
    other = {
        quick_peek = {S.reference("rage", "other", "quick peek assist")},
        quick_peek_assist_mode = {S.reference("rage", "other", "quick peek assist mode")},
        quick_peek_assist_distance = S.reference("rage", "other", "quick peek assist distance"),
        fake_duck = S.reference("rage", "other", "duck peek assist"),
        log_spread = S.reference("rage", "other", "log misses due to spread")
    },
    ps = {S.reference("misc", "miscellaneous", "ping spike")},
    log_hit = S.reference("misc", "miscellaneous", "log damage dealt"),
    log_purchases = S.reference("misc", "miscellaneous", "log weapon purchases")
};
c.aa = {
    angles = {
        enabled = S.reference("aa", "anti-aimbot angles", "enabled"),
        pitch = {S.reference("aa", "anti-aimbot angles", "pitch")},
        yaw = {S.reference("aa", "anti-aimbot angles", "yaw")},
        yaw_base = S.reference("aa", "anti-aimbot angles", "yaw base"),
        yaw_jitter = {S.reference("aa", "anti-aimbot angles", "yaw jitter")},
        body_yaw = {S.reference("aa", "anti-aimbot angles", "body yaw")},
        fs_body_yaw = S.reference("aa", "anti-aimbot angles", "freestanding body yaw"),
        edge_yaw = S.reference("aa", "anti-aimbot angles", "edge yaw"),
        freestanding = {S.reference("aa", "anti-aimbot angles", "freestanding")},
        roll = S.reference("aa", "anti-aimbot angles", "roll")
    },
    fakelag = {
        enabled = S.reference("aa", "fake lag", "enabled"),
        amount = S.reference("aa", "fake lag", "amount"),
        variance = S.reference("aa", "fake lag", "variance"),
        limit = S.reference("aa", "fake lag", "limit")
    },
    other = {
        on_shot_anti_aim = {S.reference("aa", "other", "on shot anti-aim")},
        slow_motion = {S.reference("aa", "other", "slow motion")},
        fake_peek = {S.reference("aa", "other", "fake peek")},
        leg_movement = S.reference("aa", "other", "leg movement")
    }
};
c.visuals = {
    scope = S.reference("visuals", "effects", "remove scope overlay"),
    thirdperson = S.reference("visuals", "effects", "force third person (alive)")
};
c.misc = {
    miscellaneous = {
        override_zoom_fov = S.reference("misc", "miscellaneous", "override zoom fov"),
        clan_tag_spammer = S.reference("misc", "miscellaneous", "clan tag spammer"),
        draw_console_output = S.reference("misc", "miscellaneous", "draw console output")
    },
    settings = {
        menu_color = S.reference("misc", "settings", "menu color"),
        dpi = S.reference("misc", "settings", "DPI scale"),
        anti_untrusted = S.reference("misc", "settings", "anti-untrusted")
    },
    movement = {
        air_strafe = S.reference("misc", "movement", "air strafe"),
        air_strafe_dir = S.reference("misc", "movement", "air strafe direction")
    }
};
c.player_list = {
    players = S.reference("players", "players", "player list"),
    force_body = S.reference("players", "adjustments", "force body yaw"),
    force_body_value = S.reference("players", "adjustments", "force body yaw value"),
    reset = S.reference("players", "players", "reset all")
};
defer(function()
    S.traverse(c, function(F)
        F:override();
        F:set_enabled(true);
        if F.hotkey then
            F.hotkey:set_enabled(true);
        end
    end);
end);
local F = {};
function F.rgba_to_hex(e, q, H, r)
    q = q or e;
    H = H or e;
    r = r or e;
    return string.format("%.2x%.2x%.2x%.2x", e, q, H, r);
end
function F.lerp_color(e, q, H)
    return {
        r = (e.r + ((q.r - e.r) * H)),
        g = (e.g + ((q.g - e.g) * H)),
        b = (e.b + ((q.b - e.b) * H)),
        a = (e.a + ((q.a - e.a) * H))
    };
end
function F.clamp(e, q, H)
    return math.min(math.max(e, q), H);
end
function F.normalize(e, q, H)
    local r = H - q;
    while e < q do
        e = e + r;
    end
    while e > H do
        e = e - r;
    end
    return e;
end
function F.normalize_yaw(e)
    e = ((e % 360) + 360) % 360;
    return ((e > 180) and (e - 360)) or e;
end
function F.get_current_dmg()
    if c.rage.aimbot.minimum_damage_override[1].hotkey:get() then
        return c.rage.aimbot.minimum_damage_override[2]:get(), true
    end

    return c.rage.aimbot.minimum_damage:get(), false
end
local e = {};
do
    local q = {
        [0] = "Always on",
        [1] = "On hotkey",
        [2] = "Toggle",
        [3] = "Off hotkey"
    };
    local H = {};
    local r = {};
    local function j(T)
        local D, D, s = T:get_hotkey();
        return {(q[D] or "Off hotkey"), s};
    end
    local function q(T, D)
        if r[D] and H[D] then
            T:set_hotkey(table.unpack(H[D]));
            H[D] = nil;
            r[D] = false;
        end
    end
    local function T(D, s)
        if not r[s] then
            H[s] = j(D);
            D:set_hotkey("Always on");
            r[s] = true;
        end
    end
    function e.update(H, r, j)
        if (not H) or (not r) then
            return;
        end
        if j then
            T(H, r);
        else
            q(H, r);
        end
    end
    function e.force(H, r)
        if H and r then

            T(H, r);
        end
    end
    function e.restore(H, r)
        if H and r then
            q(H, r);
        end
    end
end


local watermark_cache = {
    uname = "unknown",
    time_str = "00:00",

    ping = 0,
    ping_spike = 0,
    fps = 0,
    loss = 0,
    var = 0,
    timeout = {
        active = false,
        start = nil,
        grace_start = nil,
        duration = 0.0
    },

    last_update = 0,
    
}





local SPEC = {
    headless_name_limit = 16,
    full_name_limit = 32,
    row_h = 26,
    pad_x = 10,
    pad_y = 6,
    gap_y = 6,
    av_size = 18,
    tri_w = 3,
    tri_gap = 5,
    min_w = 130,
    header_h = 30,
    header_compact_w = 160,
    right_gap = 3,
}

local spec_state = {
    alpha        = 0.0,
    header_alpha = 0.0,
    rows         = {},
}

local unpack = table.unpack or unpack




local net_channel = net_channel or {}

net_channel.native_GetNetChannelInfo = vtable_bind(
    "engine.dll",
    "VEngineClient014",
    78,
    "void*(__thiscall*)(void*)"
)

net_channel.native_GetAvgLoss = vtable_thunk(
    11,
    "float(__thiscall*)(void*, int)"
)

net_channel.get_remote_framerate = vtable_thunk(
    25, 
    "void(__thiscall*)(void*, float*, float*, float*)"
)




local function clamp(v, lo, hi)
    if v < lo then return lo end
    if v > hi then return hi end
    return v
end

local function rgb2hex(...)
    local need_alpha = true
    local values = {}

    local src = ...

    if type(src) == "table" then
        if src.r or src.g or src.b or src.a then
            values[1] = src.r
            values[2] = src.g
            values[3] = src.b
            values[4] = src.a

            if type(src.need_alpha) == "boolean" then
                need_alpha = src.need_alpha
            end
        else
            for _, v in ipairs(src) do
                if type(v) == "boolean" then
                    need_alpha = v
                elseif type(v) == "number" then
                    values[#values + 1] = v
                end
            end
        end
    else
        for _, v in ipairs({...}) do
            if type(v) == "boolean" then
                need_alpha = v
            elseif type(v) == "number" then
                values[#values + 1] = v
            end
        end
    end

    local r = clamp(values[1] or 255, 0, 255)
    local g = clamp(values[2] or 255, 0, 255)
    local b = clamp(values[3] or 255, 0, 255)
    local a = clamp(values[4] or 255, 0, 255)

    if need_alpha then
        return string.format("%02x%02x%02x%02x", r, g, b, a)
    end

    return string.format("%02x%02x%02x", r, g, b)
end

local function lerp(a, b, t)
    t = clamp(t or 0, 0, 1)
    return a + (b - a) * t
end

local function round(v)
    return math.floor(v + 0.5)
end

local function table_index_of(t, value)
    for i = 1, #t do
        if t[i] == value then
            return i
        end
    end
    return nil
end

local function table_swap(t, a, b)
    t[a], t[b] = t[b], t[a]
end

local function clip_text(text, limit)
    text = tostring(text or "")
    if limit and limit > 0 and #text > limit then
        return text:sub(1, limit)
    end
    return text
end

local function parse_bind(data)
    local enabled = true
    local ref

    if type(data) == "table" then
        enabled = ui.get(data[1])
        ref = data[2]
    else
        ref = data
    end

    local active, bind_type, bind_key = ui.get(ref)

    local state = active

    return enabled and state and bind_type ~= 0, bind_type == 3
end




local drag_system = {
    items = {},
    active = {},
    start_positions = {},
    drag_now = nil,
}

local function inside(mx, my, x, y, w, h)
    return mx >= x and mx <= x + w and my >= y and my <= y + h
end

function drag_system:_reset_target(target)
    if not target then
        return
    end

    if target.reset then
        pcall(function()
            target:reset()
        end)
        return
    end

    if type(target) == "table" then
        for _, v in ipairs(target) do
            if v and v.reset then
                pcall(function()
                    v:reset()
                end)
            end
        end
    end
end

function drag_system:register(id, group, pos, size, opts)
    opts = opts or {}
    pos = pos or { x = 0, y = 0 }
    size = size or { x = 0, y = 0 }

    if not self.items[id] then
        self.items[id] = {}
    end

    local item = self.items[id]

    local prefix = opts.prefix or id
    local x_min = opts.x_min or 0
    local y_min = opts.y_min or 0
    local x_max = opts.x_max or 8192
    local y_max = opts.y_max or 8192

    if group then
        if not item.pos_x then
            item.pos_x = group:slider(prefix .. " pos_x", x_min, x_max, pos.x or 0)

            if item.pos_x.set_visible then
                item.pos_x:depend(Menu.debug_ui)
            end
        end

        if not item.pos_y then
            item.pos_y = group:slider(prefix .. " pos_y", y_min, y_max, pos.y or 0)

            if item.pos_y.set_visible then
                item.pos_y:depend(Menu.debug_ui)
            end
        end
    end

    item.default_x = pos.x or 0
    item.default_y = pos.y or 0
    item.size = size
    item.opts = opts

    return item
end

function drag_system:get_position(id, screen_w, w)
    local item = self.items[id]
    if not item then
        return 0, 0
    end

    local anchor_right = item.opts and item.opts.anchor_right

    local x = item.default_x or 0
    local y = item.default_y or 0

    if item.pos_x and item.pos_x.get then
        local stored = item.pos_x:get()

        if stored ~= nil then
            x = stored
        end
    end

    if item.pos_y and item.pos_y.get then
        local stored = item.pos_y:get()

        if stored ~= nil then
            y = stored
        end
    end

    if anchor_right and screen_w and w then
        x = screen_w - x - w
    end

    return x, y
end

function drag_system:set_position(id, x, y, screen_w, w)
    local item = self.items[id]
    if not item then
        return
    end

    local anchor_right = item.opts and item.opts.anchor_right

    if x ~= nil and item.pos_x and item.pos_x.set then
        if anchor_right and screen_w and w then
            item.pos_x:set(screen_w - x - w)
        else
            item.pos_x:set(x)
        end
    end

    if y ~= nil and item.pos_y and item.pos_y.set then
        item.pos_y:set(y)
    end
end

function drag_system:update(id, x, y, w, h, opts)
    opts = opts or {}

    local item = self.items[id]
    if not item then
        return x, y, false
    end

    local mx, my = ui.mouse_position()

    local menu_x, menu_y = ui.menu_position()
    local menu_w, menu_h = ui.menu_size()

    local in_menu =
        mx >= menu_x and
        mx <= menu_x + menu_w and
        my >= menu_y and
        my <= menu_y + menu_h

    local hovered = inside(mx, my, x, y, w, h)

    local hover_distance = opts.hover_distance or self.hover_distance or 30

    local near =
        mx >= x - hover_distance and
        mx <= x + w + hover_distance and
        my >= y - hover_distance and
        my <= y + h + hover_distance

    local dragging = self.active[id] == true

    
    
    
    local right_now = client.key_state(0x02)

    if right_now
        and not self.right_click_down
        and hovered
        and not in_menu
        and ui.is_menu_open()
    then
        self:_reset_target(opts.reset)

        client.log(
            string.format(
                "[drag] reset '%s'",
                tostring(id)
            )
        )
    end

    self.right_click_down = right_now

    
    
    
    if in_menu then
        self.active[id] = nil
    end

    if self.drag_now and not client.key_state(0x01) then
        self.drag_now = nil
    end

    if ui.is_menu_open()
        and hovered
        and not in_menu
        and client.key_state(0x01)
        and not dragging
        and self.drag_now == nil
    then
        self.active[id] = true
        self.drag_now = id

        self.start_positions[id] = {
            mouse_x = mx,
            mouse_y = my,
            x = x,
            y = y
        }

        dragging = true

        client.log(
            string.format(
                "[drag] start '%s'",
                tostring(id)
            )
        )
    end

    
    
    
    if dragging then
        if client.key_state(0x01) then
            local start = self.start_positions[id]

            if start then
                local new_x = start.x + (mx - start.mouse_x)
                local new_y = start.y + (my - start.mouse_y)

                local sw, sh = client.screen_size()

                if not opts.lock_x then
                    if opts.anchor_right then
                        local right_offset = sw - new_x - w

                        right_offset = clamp(
                            right_offset,
                            opts.min_x or 0,
                            opts.max_x or math.max(0, sw - w)
                        )

                        if item.pos_x and item.pos_x.set then
                            item.pos_x:set(right_offset)
                        end

                        x = sw - right_offset - w
                    else
                        new_x = clamp(
                            new_x,
                            opts.min_x or 0,
                            opts.max_x or math.max(0, sw - w)
                        )

                        if item.pos_x and item.pos_x.set then
                            item.pos_x:set(new_x)
                        end

                        x = new_x
                    end
                end

                if not opts.lock_y then
                    new_y = clamp(
                        new_y,
                        opts.min_y or 0,
                        opts.max_y or math.max(0, sh - h)
                    )

                    if item.pos_y and item.pos_y.set then
                        item.pos_y:set(new_y)
                    end

                    y = new_y
                end
            end
        else
            if self.drag_now == id then
                self.drag_now = nil
            end

            self.active[id] = nil
            self.start_positions[id] = nil
            dragging = false
        end
    end

    
    
    
    if ui.is_menu_open() then
        local should_draw = false

        if self.drag_now then
            should_draw = self.drag_now == id
        else
            should_draw = hovered or near
        end

        if should_draw then
            local alpha = dragging and 220 or 120

            renderer.rectangle(
                x  ,
                y ,
                w ,
                h ,
                255, 255, 255, 12
            )

            renderer.rectangle(
                x,
                y - 1,
                w + 1,
                1,
                255, 255, 255, alpha
            )

            renderer.rectangle(
                x,
                y + h + 1,
                w + 1,
                1,
                255, 255, 255, alpha
            )

            renderer.rectangle(
                x - 1,
                y,
                1,
                h + 1,
                255, 255, 255, alpha
            )

            renderer.rectangle(
                x + w + 1,
                y,
                1,
                h + 1,
                255, 255, 255, alpha
            )
        end
    end

    return x, y, dragging
end

function drag_system:is_dragging(id)
    return self.active[id] == true
end

function drag_system:is_any_dragging()
    return self.drag_now ~= nil
end

client.set_event_callback("setup_command", function(cmd)
    if not ui.is_menu_open() then
        return
    end

    cmd.in_attack = 0
    cmd.in_attack2 = 0
    cmd.in_attack3 = 0
end)





local ico_raw = {
    user           = "iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAjUlEQVR4nK3SvQkCQRAG0LMBUbAAFS4XUy1Fe7EPxcyfUq4RDTXS9MnCgYsu3Ah+MDDBPFg+tqr+GdTYtFNH0RwP76R9FoFn3zlFYFOATQTuC3AXgRNcM3TBuBO2eIg1VmkPoQyP0kSPlzjinj31hgMWJdBLBRRK+cw23eZwgGcAps/QLxUy7ZjfiirlBRljKcmxOAaTAAAAAElFTkSuQmCC",
    fps            = "iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAcElEQVR4nOWSMQqAMAxFCw6Cg1OX4iC4O4gXcPAq7YUcpKd9EqiYoYMZnPwQyM/P275zXwsYgQnoLNDMo0MHA7ADG9BUwFWBWQenChYLmFUgTwFIZYIFjMpHC5iUT38HfamTTAv0yssut9v715Wr6QJiYqmSoSEP8wAAAABJRU5ErkJggg==",
    ping           = "iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAjElEQVR4nGNgGLTg////+f///1/1////6f///xcgVhP/f1SQgksh3////wOhGMQWRdOYjUvjMiRFS0nRuB9J0X6sGv///6/3////N1CBQ////2ckVmMWmqAIsRqz0QRFidWYgiYICvqdSPwdWKMDFJnQSAVFbi40cKygIQvCllCxPKiaaSCDiE45VAMA4hN8SgjuVMkAAAAASUVORK5CYII=",
    loss           = "iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAACXBIWXMAAAsTAAALEwEAmpwYAAAA10lEQVR4nK3SPUoDQBiE4eQU/pAqRSCdhYqNIDba5QJ6BS9gZ6+dhQfwCCnS6QG0kngDhZSCrY8MfpFVCCbgwMCw+72ws7udzn8L43gVoI8tTMvJ/UXDXZzi0ZduGjA5esBJZufQGu791HUDJre6CxNwUgsfuMVOnWBaTt6tvcxEk4C9OuIRNnGFiwZMvsQGjmu213Y8xKzpuF2ed5zVTPf3BQ3wiheMcF4e1Vr2Botud4j1epKncnLWhn+9Yzqn21n5+bvTEp9gD294x/5SUAMfxCtBy+gT/N9u6lmkdZEAAAAASUVORK5CYII=",
    default_avatar = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAACXBIWXMAAC4jAAAuIwF4pT92AAAKuElEQVRYhZ2XWWxc13nHf3e/dzbOwuEMOYwoUqRFy5ItK5KtSHYcW3bbxGhqGI3SwFD6EKRFgdZx8hC0AYoK8EOKpIj62lSAHtomTQELsBChqSE3qg2ltiVZGyVLokQOySGHw+FwtrsvM32gJcSJWxv9Hg/O/b7f+Z9zv0Xo9/t8Gtuz75CSVJSxIIr2AAd7vvuYqOo7EkYMV5BvZGLae5l07r2pBx6yi6OTM9/4xrOzn8av8EkAz33pSBp4ttvZ+LbWiw7cW+8GAQO6jqLpACiChKzKAExv27EwNv3IKUVSTn7zT3/v7P8L4IU//DPFss2nPcf+IfBw2IvoRQFaLwJgw7HJGjE0VQNZRpVk/CjE7HbQVJUHJ7ezfde+VUVPnOiF0fE/f/mFuU8NcPilV7KmZf2FYLWPZkUBAK8PniLhiRqO6xL4DrIoEfYilMBFi8UJPBfH7AAgqjpTWyZ45PGnUNXY6Sh0jn3rO1978xMBDr/0SjGMoh/YlnkkikJK9EhHPaqhd39PXzdoeS4d10UzUqiKjGV1CTZqH/ElyTLbJ3ew53NfALgAvPqt73zt1K/vEX/z5L7n/cB13SNRFOIHIVfrq5SdLqqs4AU+vuMguA4FSSZnxMFq4rfqxONJjMERANwPrykKQ1bnb3Pr2nkUPbHX8/y//tHf/eTQxypw+KVXFNOyvgcc7UXhfZkPjk9RyBUpL95lrd1AEzavQ4gCDM3AFqBlmaxbJroo4vZ6SK59H+Kl6Yexs0WkZJLc1u10O/XTkqS+/N2/+uM5APkeiWlZT98L3rUtIs9ie67Ac/ufZmm9hiH0ybazbC2OsmFbLNUqdNrr+O0mGUUlnRmk0t5ADX2QZeLIWL5HN+zxYDrNlXoNNZ4glsk+b9vmVeB7ANLRo0f50gvfTAe++xPH7BQsq03guYiiyK7CCIqkEAoCa66FKkiMj44zYMTJFwp4ts3wUInQ9xHpE5NEXASiMCAKQ2RBxBhIs75e46npXVyq3EWPJZAVfeqtN85dfPKZx8oyQKtZf7YXBQ97QYAkiMiyhCHAULaIHUW4tsX2iXF6qg72prRB1ySTLVAoFNAUFUNWqXYaGGsrOEaMhY06ALc6XXqdBtOpFAVR5/bMJR7Y+WgRWXoROCu9/u+/UsIw+Af6fEYUBGRZwgsCpnN5thRGaAQegwmVz37xy1jVKslsHnSRrmWTGSwgSApm6JGLJUjnhvACnyD0kft9jMQAjm2SAvZu3YbT3iDwXNq+SyqdK/78F2+flkqjUxN9+j8UBYGo32PnxBT50iRZsY+RyKCHEQcPv0hxJMXy7UVE28U3HQYKOZJjJdKJGEOT2yjfuo3veQwXSxQe2ovhudTaTXQ9RkrT6Lgud1arPJDJUm21UIx4OhNLvC8VShPPAl8RBQFdN/j6ka9z4LnfZ21+nr7rEE+lEfyQ5duL2I6F6UV0rDaliRFCVUa0uux4aBuz12bpuQ6mKhHRR7IdGq0GG2FETlF4p1qh7phcWq6w3KijigL6YGFZKpa2/QnwuCgIRFGIZ3osle/i12tsHZvEbm6Q0kUqy3WcRgM9laHbbjIxPkY8lyHyPKb3bWdtcZ3l5QqSouDUlvFcB893sCUFWVWIRIXYQB45cvF8H8930AXBkUqjU3/Tpz8a+A5jhQIHP/9Ffvn2GaYLowwWSgxn82zZMUWuNIToOfhhj1gyQz6fRogZzM/cpLFYYyifo9WyMFtNJFFmvdlAQkAXRWzVwA0CEkRo2SKipqEYSaqLd0SpUJr4kdCLtF6vh+2HLK1UcG2TZ/bupzQ6xkBkky4WKG0fx436tOpNSlvy9CSRbCGPtd5h7fIVFlaXsZodFEHEcm1Ms81Th34HOZcnWJxHMzQazTrJwEUQBaqVMqoi63JotjYzkbpZVlvNNQoDAxQf3QENj7rTY+LBz9AHlEyOBw7mCJoNdh7YtVkXxkooj0zwwZU5zp09g6JpdK0WhcIw2/fvZdwLOHV3FtotEvEUeuDBh1ny0COPI6PqNxRZ2Q8gyxIAX/2DP2Lr6DAVs4wtB9jVNQD2Pj6FH0RcfR/S2SSOE6CkNTJbCuzNZLl58X2W1isMpDK4ZpfXj5/AUTWEwGcgNcD1dousppPSYtztdtATyZoYjyfnVE1HlBTCMOKpPZ9j35P7qNws43S6rK/UiWeyjO+eBMAwFLZODtPa6GIYCuO7J0mm4lx//xb50VH27N5P4Hk4CNRqVXqdNoYgYSgasiix2BPxQx+AWq06L3pBULesLr0oQJYl9j6xHy/YLBEtz2Vhpcw7Z/5784P5NVZmVykUUnhBn9ZGF8cJmJutMWAo5ApDLJbniAIfx7ZoWF3Wmg38D5VNEKEqMvUgQNNiXCrfmhHdRv0yvouq6QzGE6QzWQK/Cx7MV1cwFI1rly4zf/kOmdEcnmUShT0KhRTJVPx+WV2tbbBUXgRRwvR82u11UGTaisZIboih/DAxw8D2PHxF28y4qnFBlDXlHKq+4HsuuVQaKVPC9wJWqiuszd5CU1QOHHqGU/95nk7HYXz3JJK82Ub4QUSlvE7lZvk+SLW2TLvTQJUVTCWG67m0bJuR9CAjqSwAkiSjGamFlCSeE69df29WkZVToqQgqCpCu4vtSlQrZRzbIj84QGwoywcfzPDzf3yN2Q+qXLowx7vnbrH07m26C8ubgZeWuXjlPUyrjaHFqHkurWadTqfJ7eUysqoyYMTZMpCia1v0Q//Uf/3qF7MyQBAGJzVJ+cpKbaX4s389wVhxhJ7nEgQOU48+xtWZeZzWOjNWm/MLd9Acm6H0IIP5AhuhR6vdZLW6RHt9hektk9TaDdYtk8F4ArMv4LUbVNsNjOIw066DGvVWFzdqJ++3ZNcuvXW2FwUnDE2jUavQvTWD5zmEvs9bb7/FlTOn0Dwfy/VJBj6fjes8s2sn3U6bm1cvImyss7ha4fO7nyCZyjLXqDOczjGcLzKWG8RIprh8+R0U2yXSDZzQO/HLt0+f/UhPOBhPHFcl5XQ8DAl8j9bqAl3H4saVd2l3GjieTctsk06kKT76JNW2S1HsMwq49RoHJh9CTSS5cuc6iXiKmGEgqCphGNCPegCUF+/iO+Zp4Pi9uPcB3jj7+pwsK8dc27wQOA5r3c32WpUVvD40AVsAa62CvVKmXJmnszKP5TpkhkbIJbOcv34RJwpJJVP3H6UfBQjSZhhFES8Ax/7t9L/M/RYAwE9PHn8TeBW40HdddFEi8FxQ7reOmI7Jyt3rDHptXr91g7huANDobtBwLURdQ5U2//u+7xP64ebLl9ULluu/+rf//PcfmQ0+djA58rtfPbTWWPt2TNWfD40YngCqtAmRAfx2C+Jx+roBQUhMlsmkM1xfWWIglUaWFcIwQJYVOt0OeUU5rerxYz8++ePfGkzE31wA+Kf/+NmbwMu2735f1LVVAN9zicky41umaOo6rq5DEOK7FiVFo9VtE0Sbp408Bz8KCMNgFfg+8PLHBf9fFfh1e/65w18I+tGLuVTmy/ufODS2vLbK+XNnyKfSOK6LIclMprPcWF3CFiVUTcePwgXC8BSyfPKNM6+d/b/8fyLAPfvuXx6bymcGD87fvLR3eW11Z8/1xg1dL6QllQFRqN3stud7ojQTBN4FZPncG2de+1Tj+f8AYxhSjZpe7i0AAAAASUVORK5CYII=",
    empty          = "iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAACXBIWXMAAAsTAAALEwEAmpwYAAABA0lEQVR4nIXSOU5DQRAE0C8v54B7mCUhI8AII5GAxe7LwHlYAt+DFBAfCHFA9lBb/dHo24aJZqa7pmuqqsI6BlUu9LGJc5zlvlu1F7Ywwx5O8YIad3jEO55xsgy8j298YoROUevkXTx20wbu4LqZvPByNe+JL73huLno4glHOfkv8Chpd+Ownf/oFbRny8BJO3o34jDBtNWwiy8Ml4AfQvHYXMRhhWCz9mTc47JKn+pSyaJpWIKTat1Q7aV3oxWCDAufD1OcflMcp9Rr/4DD53G7eJvgg1YAglFYdZUhWbQqYpVUQvIQYYoPvKbSzeTfbJfgCEQIFgGPNEWW5x5nfRBf+gHbOZ9a/7oVCwAAAABJRU5ErkJggg==",
    clock          = "iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAzElEQVR4nK2SQQ6CMBBFWekxRG9hDLpy7QrW4plYWMGQeBj1AHoUdPnMT4ak1gYX2uQnzHReO/NpkvxrASvgCFyAM9AAyyFgDJyADnDA1uQs16omBgq6AROL15J9p7bXxtrreshyleTFqdVkPqiZ9sFhlQ9a7gDUfuIKlBGwCXI7mfYN3ABPoBgCZbmLGFYYnFtcq12/ILPBpxE4B+bADHgAi7BA/0mWpxFY0F0mhnv9AxCsm+VeaVJ7uknOjz7AoG3NrOcmCXxv75f1AuUNNMS82KlpAAAAAElFTkSuQmCC",
    sqrt           = "iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAmUlEQVR4nM3QMQ4BQRQG4G01NgoaHdFqtEq1zgE0XIALqFxA4wYah3AHN9CQaEgUIj7ZZIolWUYh8SeTTF7mS/43SfKXQRujcIYox6AyDp4ziIEz3NBBBWkMquGEZdGDJnrovswXuKBeBDe5/uMwa+GK+btKKRpY4xzuKxyzvWJ2qmKPLe6YfkQ53A+VdyhFw4An2Wd9hX6eB259snjhlCxcAAAAAElFTkSuQmCC",
    visible        = "iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAlElEQVR4nNXRXQpBURTFccU0XF/XpMRYGAQT8TkKYgAIr5jCTzdbTsoDT6xatc9a/Wufc0ql/xQq6GGKPXaYoFt076A2Nu46Yxi+RLZG/go1cUqgatJlCXxEIwUXnhpGNkA/5lHSz78FZylYjzXEWlnS1XCN7lCcX++ZY5XAo/ADWqL17mXL6GCMbbiYi6z8wc/+km51AhQKQZUdiwAAAABJRU5ErkJggg==",
    list           = "iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAeUlEQVR4nNXRsQnCUBSF4YALaGWKjKCQSruAU2ihtSM4QEBs7F0gZJg4kN1noYU8bppXxR9OcYsfDvcUxf+BE3pU2OISZB2JnQ87PMS0kbhEg9n3XiSZj1W944UaZzyTDDjkivtILHOrdrnPOf7MscEtyRWrkTWnzBvD8QlWqQB7iwAAAABJRU5ErkJggg==",
    hit            = "iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAACXBIWXMAAAsTAAALEwEAmpwYAAAA3ElEQVQokZWSQUrEQBBFn2FAmL2K6E4ZQpgTSXI39+pEvMdkshe8gDeYUZ6binTazsKGotO/309XVxcsDLVW66X9HN6qo3pSvyNO6kFtUrZKTB0wAO/ADfAWcQt8AKPalk46qg+J1qt9sm6DaVLjqD5lP5sZQ9upw7So4h6XGXShrjPtOthqBdzHXR9VAIEO+Ax4DTxndblb8XecAV8xA5wXmFmqV5leF7TfVCdhVF8yqFScV3WfCk2Uul0yql0w825K3mkXKfUR0/fsnXNzow6Fltv/p2836mZp/wfhqhvWnFKFzwAAAABJRU5ErkJggg==",
    miss           = "iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAACXBIWXMAAAsTAAALEwEAmpwYAAAA00lEQVR4nO2T3QnCMBRGAzqAS/gzhCD6YnWDDKBVXELXsnSStkv483zkYh5CTEyCPvZAoKRfDpfkXqV6cgCmwNasya+yIXAEOj5pgYNkcqUjoCZOJdmcSusEqS2PVw6cyKdMEXfOoTOggYdZ2uzZtDHpzFONNv8Wssy3yF3C3QJsPAeewMrKzIG7J1d8ExcB8dIR3zy5dWwQ/n8Vgmn+2ONdnEyjYvCeqFx2qQNSZUivwCAqtka6SpSmjbRTeem5c6EB9smVhpAXNz0u7TgOBnuUhxeYMc+b8t6ekAAAAABJRU5ErkJggg=="

    ,
    circled_check_mark = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAACXBIWXMAAAsTAAALEwEAmpwYAAAClElEQVR4nNWX30tUURDHN9Yg+/ESaA+10X+QJEXUomYvWenaS5H11/RmEmmG+G4toqvVeyv9E9pT9BSoQfRDoV/rJ4adC+Px3nPPvV4fGriwzJmZ7+z8OnNKpf+JgKNADZgAXgNv9XsFPAZGgM6DAL4ILAHbpJPINIDeIoDPAvPAjgPyHVgFmvrJ7x+OjOjUgUpe8D5g0wF9CvQD5Rj5MjAATKpsRBtANSv4A+CXGvgLPAO6Muh3A9NAS22IrbFQ5avAT1WUsNYyeb/b1hDwVW39lgiF5HxTFb4B5/OCG5s9JiUb3pqgXXBR2G/lBDwiUXR4wyYddV+r7ajQVB5wtfNSbcifOWb4z0137G1R2n0ehT644Bwbd5xWrDqFGaWiETfhtvVwMid4l+Y4ohcxMtJNQlu7JiYwahT7cjqwYGx8Ak7GyFwzMsP2YMIMm3IO8HvGsOT4RoJch5mY4/ZgWZmrHpBDwIkY/ings3FgNsXZ9yq3ZJkrymwmKMmYnQO+AJedM7kVI/oAHE9xoLkHi3QHZDRjuuSK8h8afiukfpIcWPalADgNfDRgUit3NSIRPUkDd1LQSCrCjgTFc44TltZCFhFfEdaMsYGUu0LybOkPcCnw3183erftQWfoIIqJxKMQcO8gEtI1KkpDdyndiXfAG+CwT9Zp1yj8i3ECveYymi4VTMCM6ZYLSUJ1IzRSIPiQXvFCcz7BirlQJBU9BS8k68CZrCvZ6D7AbzorWX+o4phZSlu6THgLM6bgZpyl9H5W76vO/S7RmAIG44aVDplBbTX7Rlh3V7QsTlS0MN2HyZZOvxX91pRnqaXrmT/nIaQt2gh8mokji4mtth+iPTFlwx3XHTJ6nIpzwpOz4h+nB0n/AGWyjgXThwHXAAAAAElFTkSuQmCC",
    internet_www = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAACXBIWXMAAAsTAAALEwEAmpwYAAACNUlEQVR4nO2WS08UQRSFx40OJuI/UFiID4ivRDGgP0Ax0ZWs+AVsfUHiI8qASzUYVrLkNygSHF9x4WOjJroTX6wNwYgLP3Pj6eRO2V3UkBnUhJN00n3qnrq3u6rrnlJpDf8TgE7gMnAP+Ah802X308AlYFczEvcAj0jHA+BQIxJvACaAn5r4u0syC2wF2oCq47MY09wC1q80+WbgqZv0CjCi51fAJhfbCrzWWAW46gp5bOP1Jm+R0PAeOCBuXtzRHE2fxuYVexCYE/cQKNdTwLiEn+wzi+sX9yyie6GYfj3b8nwWdyM1+RGt3xKwx/GTmuh8RDusmEnH7QN+aM7elALua5KRgP8gvjOi7XJfbp3jK9nGXS75DpqP7bECzq1CAWdiBcwo6ETAD4ifin7C37FTih0I+JPip2PidwraEvCD4icSCrCDyzAY8HZoGd7GxAsKqvlngSHxowkFjCl2KODL4hdSCmgpKGAsoYBrBQVsFP/1n16Cmb+9Cc/SfJyOFbBtFQroSD2KKwVHcVdEu7vgKB5NOooNwGE1Dmsge3OaUc3uLmhGtx233zWjniJtDYCbmshaaVvQjp9HdC8Vc0rP7a4dXy/S/QEZiswDzslclJ0hOZajOa6xL4rtdstWrcuQOEv2RBMsyY5VnCVrDSzZm2zv6DINepH6LFkGM5QylnmmtCrH0y7LlWdKx1dsSj3MYgfOdznYn9RdajSAncBF4K7Wd1GX3d8BLpipaXjiNZSaiF9hPAcvYWnglAAAAABJRU5ErkJggg==",
    bullet = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAACXBIWXMAAAsTAAALEwEAmpwYAAABGklEQVR4nO3VsS4EURiG4VnKDQUhZBIULkPnCjREaPQKhX7nMnQa4gZcBgoKhYiaRKOgEHlkkpkssWtmd+ccCd5mkinO+/3fOXMmSf75rWAa29hCGlM8iQxPurxgN4Z8Aw/6sx9K3Maxal6x2LQ8xbn67DQpb2EJdwME2GxKnuEQYwOEyA/mVFPykhOMYwG3vqfTtLykThP3mAghr9vEekh5VRNHMeT9mrjI74lY8l5NpLHlH0O0fko+2ifnL8vb2MPbkPJs1MmvMY81PMee/KpYKH/OYgWPwScvwQwuiwXLJpZxE2zymiHmcBZcXhEi36LT4PKKEPn9fhBcXlIcxE8Hs3i/msTC1xDD/9Ua2I5OdHnSDRF/8li8A8XbNEv+WjS0AAAAAElFTkSuQmCC",
    not_visible = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAACXBIWXMAAAsTAAALEwEAmpwYAAAB8klEQVR4nO3WzYuNYRjH8cMozWoWWCqULOQUC6//A2ukDmbLgv9gaswpKaS8LJAssPEPyN9goRELsjNehyiN9NFtbtPtmfu5nzPnWSidb53Nea6X3/Nc131dd6czYkQFXMdnHO/8C/DeIj8xWXk2hl04hQu4jVuYxmnsweq2Anox+TIRWI8nyszhKra0ETHZUkRgATcwMayIqSTYsCICr7Bvpcn340MlUE5EL/7OYbYg4jsODpr8AL7VBFrWmInfKhyNJ6iuJIeakm/Fu4ZPWisixugWRHzFzjrHtQ11vV/XmJlYxwpxnmM853S+4PQsfuLa05EpR/CpY6bqsB0/BnHAo+T/koiZQryQa0dqHKZaiV5iO195lhWBEw0x+6nxxQbjpb2AL5nnubHdJGAqNe42lGA6sX1YY7OSYRWO+ebqJ+sXBDwNjRXttuFjSxFnc00zjhcFEYcT2414EM/7fGzMQXfH47BVc43bCUMiDoscIVG35QJ7jQ11MX4TxmUcm3UijvwpR0q4B+BeoRzrSi/wF2FxxAVSx2y8hJyMy6gfJ1yV4sQsgr14qT2tREzgWqEkJRYG3R2NhDMbr1lvBkj8FpexKdOYSxN1KCw22m6cwRXcxR1cipfScJdYU/FJRXxqJWBYYqOGEX5z6CAj/lt+ATq0r3ea47dMAAAAAElFTkSuQmCC",
    info = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAACXBIWXMAAAsTAAALEwEAmpwYAAAB+UlEQVR4nO2XOU4DQRBFJ8ciAUOMDcgJm5ywBKTYMTt3IEBsEdsJAAESNwBslgAiOAPLJVjEAQALeKjlttQq9fT0DEPGl1py8Lrqj6erqyYI/pVAQCvQB5T1Ur9b/zppJ7AJ3BOue83k00zcDuwDNfyl2D2g7bfJh4BnkusVGE2afBp4FwE/gCNgCugGmvRSv2eAY82YUjEm4yYfsSQ/ATo89uaAqsXEUJx3/mJs/gQWYj1BPc4i8GXEeQKyPhsPhPsFR4IbvVZDmGURa9en1Grm3+5grwzu2sGdiTOUcxnYEnA+BQMd4mBuuAw8GOBRKFhn54FLvZxnRB/ghu7CoKx4X9NBSgJmRewWGzQgoM6IoEVgQq9iBKvuCVN9NqgsoExE0EODPYxgMyJ2yQaV/tBAs4g9ZoP6BdSVooGCiN0b1uO9D2FMA3MG+209hEqi1x8H6RmoGOytC9wwwJqrEnwN6OZkXkRrLgN5cRVXUzBwYXAfkR2V+iRjajGpAWBFxNp2JldSY5SYglRLXQpiGtDJzXb86D24AsOWgeTUZ9hU5Quci71vwKBX8obUGGUxUdONZVbXdmMkK+hSq1iGV5V8PEgiYFBPMkn1GPvJQ7rkrmXYdEmxO6l+rFCv53XVzx2Jb1Wd+wyvvzXTou5z49OsJ/R6/Vfg1g8b96MIHrQ3kgAAAABJRU5ErkJggg==",
    fall = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAACXBIWXMAAAsTAAALEwEAmpwYAAAB60lEQVR4nO3XTYhOURzH8TsMkSRvq9kqO0VhMcnL5GVnRWnKAnnZECkraykvjbJSSsKKlJ1SZtgwthJZkYikJCHmo9OcaY7bvc9zZ5773Nn4Lv/3/5zf7/zPOf9zniz7T0UwF4PYkM0EOG+cMfS3yJuNPvTUbWDEJMdKcvbgS8x5h4E6DQwnBo4XfF+Bn/7lMxY1ZWCfYrbUZeBhGwPbSwys7IaBYWxONxpm4UFO/Got4gHcKZjdS5zEspgzB/vjidld60nAWrwpKfMP3MSm2o9fQTPahafKeYVTWJ51C/RgKx63MBKqcgMbu1YVXFSNFzgyLSOYh0tx/a+HNpvs+tDtpsLgVMX78CQ3yFeciEtQxt14Op7n4oemIt6P923WuIwdcYxtSezPRPWqiB8s6OtV+YDeOM6VJD5SVfxMycCXCzpdERfiOL34lMSPVhFfEu/7lG/hmk1yQof72MLA6mmXH/OT+zzwGquS7wsxhN8l4qNJ7rkk/qhS+QPhyYXbsZ8vTuI78bbFzL9jfZJ/IPm2N+sEnNWaZ1hX8LuBjl9FWIpfJcL3w1p3JNCO+M6T21D3imbcFXAtZ+BwI8JJvw+NZYKxyt2sDrAmv9kaE0+OZMrprEmM/8u5FUs/Gk5EowaySSMLZkS4Cf4Cm34B/cOFBQEAAAAASUVORK5CYII=",
    ai = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAACXBIWXMAAAsTAAALEwEAmpwYAAABY0lEQVR4nNWXu0oDQRhGh1QhiEUQxNIuiIVgJ5LGRqy1sRd8ABEsRDsfQPAF0ljlJUTSqiAiWHsH73hJ4pHBDS46uzObf3cGTz2732H/b2dnlfqPAOVQwQPAM9AFpkMIbPPDQQiBh5jAJzDiM3yRv+z6FLgxCOguDPkI3zGE++kCsISdho/W29jLbX8AFhJmbuMN2ARK/YSWgFXgEjkfQDNTQYGLHIJNIsOuAl2KwW3LBuZzfgr6m7HhPIIewAxwJAg+B5aVFKCesZCves8QBxvejJZD+JVz2foBOE4Jfyn8e8D3QeQ9QWDKcu0oMJiHxJYhvOUwQt2NQ7GAJrpZnHHlLj2hpACN2A1PLWsngU5s/S1QkQpUoy7o49hcyroVoG0Y2Z3eZ6QSlaSzIFAD7rFzIpJIAhgDnhwEzlSRAGspI5gtNLyHbv2vEl6LS5gVYD0K16WtqRAAj8B+kHAV8kfWlS9b7bCoM3aydgAAAABJRU5ErkJggg=="
    ,explosion = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAACXBIWXMAAAsTAAALEwEAmpwYAAACSUlEQVR4nO2WXWjPURjHf4jMa3FD242ibRcLF5S42SI3pEjUysWyiylRlJVWyo2XIi0Xqylb7shbiVBSIqXmgmW1lZtFeQ9lGz7rseev43jO+Z3fWv6pfa9One/5Pt/z8jzPybJJTOJ/BrCsnMFXAD+BunIZOMAY2spl4LoaeFKO4FOB92pArqHqXxtYyZ9omSjhNmBVAm+/Z+BWwTiLgZPAEn/iOfBdJysiAlc8A9+AeQmBpwMHgU96dbU+4ZAjOgA0BO7/LX9je07wBuCZw79qkRYBIw5JXHa4uwOWY+NCIHAV0G3w14Sc3jDIg8AWnd8XMPBBjtjRqdAT/Wxw78SOahthdAG3I/O/rgzYCryM8OpjBmYAbxgfLsnucjgPwy9FAZxJDPhxHCY3ZXkA6hLF7joVMQVPgSm5BgRAT4KgvO77BQzsyFIB7DUE/N2eANoNnlUn+oBpRQws0Arn4p7WhRKkJDd7nGvAWcNAU3LwEoCLhpA0oqM63gms1vGQGqoEvnpr3gEzsxQwJrBH833YMNCtvBZgHTAb6C81MeAcNvq1iM21glYDrcBjLb8xDPv9H5jlZI80sxikEZ363QmBRxTH8cDp3SygIUa7ZNFu7XwxSD0/DKwHaqxWDczXt3FMd9gJvI5oygM/7bbYzcCDyIIhzYDKnDckpXwX8CKg80Urrf2NA9YCl4EfAYHB0GdFH+arwDrJhCPAwtgGMkdsqeazn1KNkTUbjMwRw/ILmpMU2BCVgiT53Rv6dHj8Jq2Y54GNedVvFMjMyeEh4IvDAAAAAElFTkSuQmCC"
}



local tex = {}

local function load_tex(name, data, w, h)
    if not data or data == "" or data:sub(1, 1) == "<" then
        return
    end

    local ok, t = pcall(renderer.load_png, data, w, h)
    if ok and t then
        tex[name] = t
    end
end

local function init_icos()
    load_tex("user",                base64.decode(ico_raw.user),                14,14)
    load_tex("fps",                 base64.decode(ico_raw.fps),                 14,14)
    load_tex("ping",                base64.decode(ico_raw.ping),                14,14)
    load_tex("loss",                base64.decode(ico_raw.loss),                14,14)
    load_tex("clock",               base64.decode(ico_raw.clock),               14,14)
    load_tex("empty",               base64.decode(ico_raw.empty),               14,14)
    load_tex("sqrt",                base64.decode(ico_raw.sqrt),                14,14)
    load_tex("visible",             base64.decode(ico_raw.visible),             14,14)
    load_tex("list",                base64.decode(ico_raw.list),                14,14)
    load_tex("hit",                 base64.decode(ico_raw.hit),                 14,14)
    load_tex("miss",                base64.decode(ico_raw.miss),                22,22)
    load_tex("default_avatar",      base64.decode(ico_raw.default_avatar),      32,32)
    load_tex("circled_check_mark",  base64.decode(ico_raw.circled_check_mark),  32,32)
    load_tex("internet_www",        base64.decode(ico_raw.internet_www),        32,32)
    load_tex("bullet",              base64.decode(ico_raw.bullet),              32,32)
    load_tex("not_visible",         base64.decode(ico_raw.not_visible),         32,32)
    load_tex("info",                base64.decode(ico_raw.info),                32,32)
    load_tex("fall",                base64.decode(ico_raw.fall),                32,32)
    load_tex("ai",                  base64.decode(ico_raw.ai),                  32,32)
    load_tex("explosion",           base64.decode(ico_raw.explosion),           32,32)
end

local function create_rounded_avatar(img, radius)
    if not img or img.type ~= "rgba" then
        return nil
    end

    local w = img.width
    local h = img.height

    radius = math.min(radius or math.floor(math.min(w, h) * 0.25), math.floor(math.min(w, h) / 2))

    local size = #img.contents

    local src = ffi.cast("uint8_t*", ffi.cast("const char*", img.contents))
    local dst = ffi.new("uint8_t[?]", size)

    ffi.copy(dst, src, size)

    local function corner_alpha(px, py, cx, cy, r)
        local dx = px - cx
        local dy = py - cy

        if dx * dx + dy * dy > r * r then
            return false
        end

        return true
    end

    for y = 0, h - 1 do
        for x = 0, w - 1 do
            local keep = true
            
            if x < radius and y < radius then
                keep = corner_alpha(x, y, radius, radius, radius)
            
            elseif x >= w - radius and y < radius then
                keep = corner_alpha(x, y, w - radius - 1, radius, radius)
            
            elseif x < radius and y >= h - radius then
                keep = corner_alpha(x, y, radius, h - radius - 1, radius)
            
            elseif x >= w - radius and y >= h - radius then
                keep = corner_alpha(x, y, w - radius - 1, h - radius - 1, radius)
            end

            if not keep then
                local idx = (y * w + x) * 4
                dst[idx + 3] = 0
            end
        end
    end

    return renderer.load_rgba(
        ffi.string(dst, size),
        w,
        h
    )
end

local function init_avatar()
    local lp = entity.get_local_player()
    if not lp then
        tex.avatar = tex.default_avatar
        return
    end

    local s64 = entity.get_steam64(lp)
    if not s64 then
        tex.avatar = tex.default_avatar
        return
    end

    local raw = images.get_steam_avatar(s64)
    if raw then
        local ok, t = pcall(create_rounded_avatar, raw, 32)
        if ok and t then
            tex.avatar = t
            return
        end
    end

    tex.avatar = tex.default_avatar
end
init_icos()
init_avatar()



local function text_w(text)
    local w = renderer.measure_text("b", tostring(text or ""))
    return w
end

local function pill(x, y, w, h, r, g, b, a)
    local rad = math.floor(h / 2)
    if w <= 0 or h <= 0 then return end

    renderer.rectangle(x + rad, y, w - rad * 2, h, r, g, b, a)
    renderer.circle(x + rad,     y + rad, r, g, b, a, rad, 180, 0.5)
    renderer.circle(x + w - rad, y + rad, r, g, b, a, rad,   0, 0.5)
end

local function render_rec(x, y, w, h, radius, color)
    radius = math.min(w/2, h/2, radius)
    local r, g, b, a = unpack(color)
    renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
    renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
    renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
    renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
    renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
    renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
    renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
end

local function render_rec_outline(x, y, w, h, radius, thickness, color)
    radius = math.min(w/2, h/2, radius)
    local r, g, b, a = unpack(color)
    if radius == 1 then
        renderer.rectangle(x, y, w, thickness, r, g, b, a)
        renderer.rectangle(x, y + h - thickness, w , thickness, r, g, b, a)
    else
        renderer.rectangle(x + radius, y, w - radius*2, thickness, r, g, b, a)
        renderer.rectangle(x + radius, y + h - thickness, w - radius*2, thickness, r, g, b, a)
        renderer.rectangle(x, y + radius, thickness, h - radius*2, r, g, b, a)
        renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius*2, r, g, b, a)
        renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness)
        renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness)
        renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, 0.25, thickness)
        renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness)
    end
end

local function render_shadow(x, y, w, h, width, rounding, accent, accent_inner)
    local thickness = 1
    local offset = 1
    local r, g, b, a = unpack(accent)
    if accent_inner then
        render_rec(x , y, w, h + 1, rounding, accent_inner)
    end
    for k = 0, width do
        if a * (k/width)^(1) > 5 then
            local accent = {r, g, b, a * (k/width)^(2)}
            render_rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h + 1 - (k - width - offset)*thickness*2, rounding + thickness * (width - k + offset), thickness, accent)
        end
    end
end

local function render_text(x,y,r,g,b,a,text)
    renderer.text(x,y,r,g,b,a,"b",0,text)
end

local function draw_bg(x, y, w, h, rad)
    rad = rad ~= nil and rad or math.floor(h / 2)
    if w <= 0 or h <= 0 then return end

    local allow_blur = Menu.information.disableblur:get() == false

    if allow_blur then
        for i = 0, rad - 1 do
            local dy    = rad - i - 0.5
            local inset = math.floor(rad - math.sqrt(math.max(0, rad * rad - dy * dy)))
            local lw    = w - inset * 2
            if lw > 0 then
                renderer.blur(x + inset, y + i,          lw, 1, 255, 8)
                renderer.blur(x + inset, y + h - 1 - i,  lw, 1, 255, 8)
            end
        end
        renderer.blur(x, y + rad, w, h - rad * 2, 255, 8)
    end
    render_rec(x, y, w, h, rad, {10, 10, 10, 150})
end

local function draw_avatar(t, x, y, sz, a)
    if not t or a <= 0 then return end

    renderer.texture(t, x, y, sz, sz, 255, 255, 255, a, "f")
end

local function draw_inner_corner(x, y, w, h, rad, side, accent, a)
    local r, g, b = accent[1], accent[2], accent[3]
    rad = rad ~= nil and rad or math.floor(h / 2)
    if rad > h / 2 then rad = math.floor(h / 2) end
    if rad <= 0 or w <= 0 or h <= 0 then return end
    for i = 0, rad * 2 - 1 do
        local dy = i - rad + 0.5
        local abs_dy = math.abs(dy)

        if abs_dy > rad then goto continue end

        local inset = rad - math.sqrt(math.max(0, rad * rad - dy * dy))
        local alpha = a * (1 - abs_dy / rad)

        local base_x, lw

        if side == "left" then
            base_x = x + inset
            lw = w - inset
        else
            lw = w - inset
            base_x = x + (w - lw)
        end

        if lw > 0 then
            for num = 1, 3 do
                local ga = a * (0.01 / lw)
            
                if ga > 0 then
                    renderer.rectangle(
                        base_x - num - 2,
                        y + i - num,
                        lw + num * 2 + 2,
                        1 + num * 2,
                        r, g, b,
                        ga
                    )
                end
            end

            
            renderer.rectangle(
                base_x,
                y + i,
                lw,
                1,
                r, g, b,
                alpha
            )
        end

        ::continue::
    end
end

local function draw_widget_header(x, y, w, h, title, accent, tc, alpha, icon_tex, icon_sz, rad)
    local a255 = math.floor(255 * alpha)
    if a255 <= 0 then return end

    local PAD = SPEC.pad_x
    icon_sz = icon_sz or 14

    draw_bg(x, y, w, h, rad)

    local title_w = text_w(title)
    
    local left_edge = x + PAD + 5
    local right_edge = x + w - PAD
    local title_x = left_edge
    if right_edge > left_edge then
        title_x = left_edge + math.floor(((right_edge - left_edge) - title_w) / 2 + 0.5)
    end

    local ty = y + math.floor((h - renderer.measure_text("b", "0")) / 2) - 3

    if icon_tex then
        local iy = y + math.floor((h - icon_sz) / 2)
        renderer.texture(icon_tex, x + PAD, iy, icon_sz, icon_sz, accent[1], accent[2], accent[3], a255, "f")
    end

    render_text(title_x, ty, tc[1], tc[2], tc[3], a255, title)
end

local function get_ping()
    local ping = math.floor(client.latency() * 1000)
    local ping_spike = 0
    return ping, ping_spike
end

local function get_var()
    local nci = net_channel.native_GetNetChannelInfo()
    if nci == nil then return 0 end
    local ft = ffi.new("float[1]")
    local ft_dev = ffi.new("float[1]")
    local fs_dev = ffi.new("float[1]")
    net_channel.get_remote_framerate(nci, ft, ft_dev, fs_dev)
    return math.floor(ft_dev[0] * 1000)
end

local function get_loss()
    local netchan = net_channel.native_GetNetChannelInfo()
    if not netchan then
        return 0.0, 0.0
    end

    local incoming, outgoing = 0.0, 0.0

    if net_channel.native_GetAvgLoss then
        outgoing = net_channel.native_GetAvgLoss(netchan, 0) or 0.0
        incoming = net_channel.native_GetAvgLoss(netchan, 1) or 0.0
    end

    return math.floor((incoming + outgoing) * 100)
end

local function is_timeout()
    local ack = globals.commandack()
    local last_out = globals.lastoutgoingcommand()
    local choke = globals.chokedcommands()
    local frozen = globals.servertickcount()

    local desync = (last_out - ack) > 48
    local score = 0
    if desync then score = score + 1 end
    if frozen == 0 then score = score + 2 end
    if choke > 20 then score = score + 1 end
    return score >= 3
end

local function get_timeout()
    local now = globals.realtime()

    if is_timeout() then
        if not watermark_cache.timeout.grace_start then
            watermark_cache.timeout.grace_start = now
        end

        if now - watermark_cache.timeout.grace_start > 0.5 then
            if not watermark_cache.timeout.active then
                watermark_cache.timeout.active = true
                watermark_cache.timeout.start = now
            end
            watermark_cache.timeout.duration = now - watermark_cache.timeout.start
        end
    else
        watermark_cache.timeout.active = false
        watermark_cache.timeout.start = nil
        watermark_cache.timeout.duration = 0.0
        watermark_cache.timeout.grace_start = nil
    end
    return watermark_cache.timeout.duration or 0.0
end


local q = {
    RIGHT = 1,
    NONE = 0,
    LEFT = 2
};
local H = {
    NONE = -1.0,
    LEFT = 1,
    RIGHT = 2,
    FORWARD = 3
};
local r = {
    [3] = "CT"
};
local j = {
    [H.LEFT] = -90.0,
    [H.RIGHT] = 90,
    [H.FORWARD] = 180
};

local D = false;
do
    local s, L = 0, 0;
    local function K()
        local W = entity.get_local_player();
        if (not W) or (not entity.is_alive(W)) then
            return;
        end
        s = entity.get_prop(W, "m_fFlags");
    end
    local function W()
        local J = entity.get_local_player();
        if (not J) or (not entity.is_alive(J)) then
            return;
        end
        L = entity.get_prop(J, "m_fFlags");
        D = (bit.band(s, 1) == 1) and (bit.band(L, 1) == 1);
    end
    client.set_event_callback("setup_command", K);
    client.set_event_callback("run_command", W);
end
local ctx = {};
do
    ctx.lp = nil;
    ctx.state = "Global";
    ctx.additional_state = "Global";
    ctx.in_fake_lag = false;
    ctx.shifting_enough = false;
    ctx.send = false;
    ctx.hp = 100;
    ctx.weapon = "None";
    ctx.real_yaw = 0;
    ctx.body_yaw = 0;
    ctx.desync = 0;
    ctx.side = 1;
    ctx.use_active = false;
    ctx.team = 0 
    ctx.mode = "Preset" 
    ctx.in_defensive = false
    ctx.ticks_left = 0

    function ctx.is_warmup()
        local game_rules = entity.get_game_rules()
        if game_rules then
            return entity.get_prop(game_rules, "m_bWarmupPeriod") == 1
        else return false
        end
    end

    function ctx:resolve_aa_mode(format)
        
        
        
        self.mode = Menu.aa.angles.type:get()
        if format == 2 then
            return self.mode
        else
            if string.find(string.lower(self.mode), "builder", 1, true) then
                if format == 1 then
                    return "Builder"
                else
                    return true
                end
            else
                if format == 1 then
                    return "Preset"
                else
                    return false
                end
            end 
        end
    end

    function ctx:get_team()
        local lp = entity.get_local_player()
        if not lp then 
            self.team = 0
            return 0 
        end
        local team = entity.get_prop(lp, "m_iTeamNum")
        return team
    end

    function ctx:get_state()
        local L, K;
        if self.in_fake_lag then
            K = "Fake lag";
        else
            local W = c.aa.angles.freestanding[1]:get() and c.aa.angles.freestanding[1].hotkey:get();
            if W then
                K = "Freestanding";
            else
                K = nil;
            end
        end
        if not self.on_ground then
            if self.in_duck then
                L = "In air-crouch";
            else
                L = "In air";
            end
        else
            local W = c.rage.other.fake_duck:get();
            if self.in_duck or W then
                if self.speed > 10 then
                    L = "Sneaking";
                else
                    L = "Crouching";
                end
            elseif self.speed > 10 then
                local W = c.aa.other.slow_motion[1]:get() and c.aa.other.slow_motion[1].hotkey:get();
                if W then
                    L = "Walking";
                else
                    L = "Moving";
                end
            else
                L = "Standing";
            end
        end
        if not K then
            K = L;
        end
        return L, K;
    end
    local L = function()
        local K = entity.get_local_player();
        if not K then
            return nil;
        end
        local W = entity.get_player_weapon(K);
        if not W then
            return nil;
        end
        local K = i(W);
        if not K then
            return nil;
        end
        return K;
    end;
    function ctx.get_weapon()
        local K = L();
        if K == nil then
            return "None";
        end
        local L = ({
            [0] = "Knife",
            [1] = "Pistols",
            [2] = "SMG",
            [3] = "Rifles",
            [4] = "Shotgun",
            [5] = "Sniper",
            [6] = "Machinegun",
            [7] = "C4",
            [9] = "Grenade",
            [11] = "Stackableitem",
            [12] = "Fists",
            [13] = "Breachcharge",
            [14] = "Bumpmine",
            [15] = "Tablet",
            [16] = "Melee",
            [19] = "Equipment"
        })[K.weapon_type_int];
        local W = K.console_name;
        local J = W:gsub("weapon_", ""):gsub("_.*", "");
        if (L == "Knife") or (L == "Sniper") or (J == "deagle") or K.is_revolver then
            local W = J;
            if W == "ssg08" then
                return "SSG08";
            elseif W == "awp" then
                return "AWP";
            elseif (W == "revolver") or K.is_revolver then
                return "Revolver";
            elseif W == "deagle" then
                return "Deagle";
            elseif W == "bayonet" then
                return "Knife";
            elseif (W == "g3sg1") or (W == "scar20") then
                return "Auto snipers";
            else
                return W:sub(1, 1):upper() .. W:sub(2):lower();
            end
        else
            return L;
        end
    end
    function ctx:get_game_use_state(L)
        if self.weapon == "C4" then
            return true;
        end
        local K = h(entity.get_origin(L));
        local W = r[entity.get_prop(L, "m_iTeamNum")];
        local r = entity.get_all("CPlantedC4");
        for J = 1, #r do
            local y = r[J];
            local r = h(entity.get_origin(y));
            local J = entity.get_prop(y, "m_hDefuser");
            if (J == L) or ((W == "CT") and (r:dist(K) < 87.5)) then
                return true;
            end
        end
        local r = entity.get_all("CHostage");
        for J = 1, #r do
            local y = r[J];
            local r = h(entity.get_origin(y));
            if (W == "CT") and (r:dist(K) < 80) then
                return true;
            end
        end
        local r = h(client.eye_position());
        local K = h(client.camera_angles());
        local W = h():init_from_angles(K.x, K.y, K.z);
        local K = r + (W * 80);
        local W, J = client.trace_line(L, r.x, r.y, r.z, K.x, K.y, K.z);
        if W ~= 1 then
            if J == -1.0 then
                return false;
            end
            local r = entity.get_classname(J);
            if not r then
                return false;
            end
            if r == "CWorld" then
                return false;
            end
            if r == "CCSPlayer" then
                return false;
            end
            if r == "CFuncBrush" then
                return false;
            end
        end
        return false;
    end
    function ctx:is_in_fake_lag(r)
        local L = r.chokedcommands;
        if c.aa.fakelag.enabled:get() then
            if c.aa.fakelag.limit:get() > 1 then
                if c.rage.aimbot.double_tap[1]:get() and c.rage.aimbot.double_tap[1].hotkey:get() and
                    (not c.rage.other.fake_duck:get()) then
                    if L > c.rage.aimbot.double_tap_limit:get() then
                        return true;
                    end
                elseif c.aa.other.on_shot_anti_aim[1]:get() and c.aa.other.on_shot_anti_aim[1].hotkey:get() and
                    (not c.rage.other.fake_duck:get()) then
                    if L > 1 then
                        return true;
                    end
                elseif L ~= nil then
                    return true;
                end
            end
        end
        return false;
    end
    function ctx:shifted_ticks()
        local r = entity.get_local_player();
        if r then
            local L = entity.get_prop(r, "m_nTickBase");
            local r = client.latency();
            local K = math.floor((((L - globals.tickcount()) - 3) - (toticks(r) * 0.5)) + (0.5 * r * 10));
            local r = -14.0 + (c.rage.aimbot.double_tap_limit:get() - 1) + 3;
            self.shifting_enough = K <= r;
        end
    end
    function ctx:get_exploit_hotkey(r, L)
        r = ((r == nil) and true) or r;
        L = ((L == nil) and true) or L;
        local K = c.rage.other.fake_duck:get();
        if not K then
            local K = false;
            local W = false;
            if r then
                K = c.rage.aimbot.double_tap[1]:get() and c.rage.aimbot.double_tap[1].hotkey:get();
            end
            if L then
                W = c.aa.other.on_shot_anti_aim[1]:get() and c.aa.other.on_shot_anti_aim[1].hotkey:get();
            end
            if r and L then
                return K or W;
            elseif r then
                return K;
            elseif L then
                return W;
            end
        end
        return false;
    end
    function ctx:get_exploit()
        return self.shifting_enough;
    end
    local function r(L)
        ctx.in_fake_lag = ctx:is_in_fake_lag(L);
        ctx:shifted_ticks(L);
    end
    local function L(K)
        local W = entity.get_local_player();
        local J = v(W):get_anim_state();
        ctx.on_ground = D;
        ctx.hit_in_ground = J.hit_in_ground_animation;
        ctx.in_duck = entity.get_prop(W, "m_flDuckAmount") == 1;
        do
            local J = {entity.get_prop(W, "m_vecVelocity")};
            local y = h(J[1] or 0, J[2] or 0, 0);
            ctx.speed = y:length();
        end
        ctx.hp = entity.get_prop(W, "m_iHealth");
        ctx.weapon = ctx:get_weapon();
        local J = h(client.camera_angles());

        ctx.real_yaw = F.normalize_yaw((C.get_abs_yaw() - J.y) - 180);
        local J, y = ctx:get_state();
        ctx.state = J;
        ctx.additional_state = y;
        ctx.send = K.chokedcommands == 0;
        if ctx.send then
            ctx.body_yaw = C.get_body_yaw();
            ctx.desync = C.get_desync();
        end
        if ctx.desync > 0 then
            ctx.side = q.LEFT;
        elseif ctx.desync < 0 then
            ctx.side = q.RIGHT;
        else
            ctx.side = q.NONE;
        end
        ctx.use_active = ctx:get_game_use_state(W);
    end
    client.set_event_callback("setup_command", L);
    client.set_event_callback("run_command", r);
end
local Cheat = {};
do
    local r = ffi.typeof(
        "        struct {\n            char\t\t pad_0000[8];\n            int32_t\tclient;\n            int32_t\taudible_mask;\n            uint32_t xuid_low;\n            uint32_t xuid_high;\n            void*\t\tvoice_data;\n            bool\t\t proximity;\n            bool\t\t caster;\n            char\t\t pad_001E[2];\n            int32_t\tformat;\n            int32_t\tsequence_bytes;\n            uint32_t section_number;\n            uint32_t uncompressed_sample_offset;\n            char\t\t pad_0030[4];\n            uint32_t has_bits;\n        } *\n    ");
    local cheat_revealer = {
        names = {
            gs = {
                long = "gamesense",
                color = "95B80CFF"
            },
            nl = {
                long = "neverlose",
                color = "037696FF"
            },
            nw = {
                long = "nixware",
                color = "FFFFFFFF"
            },
            pd = {
                long = "pandora",
                color = "D4A9FFFF"
            },
            pr = {
                long = "primordial",
                color = "E2B6C7FF"
            },
            ot = {
                long = "onetap",
                color = "f7a414FF"
            },
            ft = {
                long = "fatality",
                color = "f00657FF"
            },
            pl = {
                long = "plaguecheat",
                color = "6BFF87FF"
            },
            ev = {
                long = "ev0lve",
                color = "42B7FFFF"
            },
            r7 = {
                long = "rifk7",
                color = "FF00FFFF"
            },
            af = {
                long = "airflow",
                color = "8E76C0FF"
            },
            wh = {
                long = "unknown",
                color = "9F9F9FFF"
            }
        },
        colored_names = {
            gs = {
                short = "\7EAEAEAFFG\00795B80CFFS",
                long = "\7EAEAEAFFgame\00795B80CFFsense"
            },
            nl = {
                short = "\007557FC6FFNL",
                long = "\7EAEAEAFFnever\007557FC6FFlose"
            },
            nw = {
                short = "\7FFFFFFFFNW",
                long = "\7FFFFFFFFnixware"
            },
            pd = {
                short = "\7D4A9FFFFPD",
                long = "\7D4A9FFFFpandora"
            },
            pr = {
                short = "\7E2B6C7FFPR",
                long = "\7E2B6C7FFprimordial"
            },
            ot = {
                short = "\7EAEAEAFFO\7f7a414FFT",
                long = "\7EAEAEAFFone\7f7a414FFtap"
            },
            ft = {
                short = "\7f00657FFFT",
                long = "\7F00657FFfatality"
            },
            pl = {
                short = "\0076BFF87FFPLG",
                long = "\0076BFF87FFplaguecheat"
            },
            ev = {
                short = "\00742B7FFFFEV0",
                long = "\00742B7FFFFev0\7FFFFFFFFlve"
            },
            r7 = {
                short = "\00700F600FFR\7FF00FFFF7",
                long = "\00700F600FFrifk\7FF00FFFF7"
            },
            af = {
                short = "\0078E76C0FFAF",
                long = "\0078E76C0FFairflow"
            },
            wh = {
                short = "unknown",
                long = "unknown"
            }
        },
        users = {}
    };
    local K = {
        nl = {
            sig_count = {},
            found = {}
        },
        nw = {},
        pd = {},
        ot = {},
        ft = {},
        pl = {},
        ev = {},
        r7 = {},
        af = {},
        gs = {}
    };
    local function W(J, y)
        local P = {};
        for f = 1, #J do
            local u = J[f];
            if not P[u] then
                P[u] = true;
                for P = f + 4, #J do
                    if (f % y) == 0 then
                        if J[P] == u then
                            return true;
                        end
                    elseif J[P] == u then
                        return false;
                    end
                end
            end
        end
        return false;
    end
    local J = {
        nl = function(y, P)
            if y.xuid_high == 0 then
                return;
            end
            local f = ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", y) + 22)[0]);
            if f == K.current_signature then
                K.nl.sig_count[P] = (K.nl.sig_count[P] or 0) + 1;
                if K.nl.sig_count[P] > 24 then
                    K.nl.found[P] = 1;
                    return true;
                else
                    K.nl.sig_count[P] = nil;
                end
            end
            if #K.nl.found > 3 then
                return false;
            end
            if not K.nl[P] then
                K.nl[P] = {};
            end
            K.nl[P][#K.nl[P] + 1] = y.xuid_high;
            if #K.nl[P] > 24 then
                if W(K.nl[P], 4) and (y.xuid_high ~= 0) then
                    K.current_signature = f;
                    K.nl[P] = {};
                    return true;
                end
                table.remove(K.nl[P], 1);
            end
            return false;
        end,
        nw = function(W, y)
            if not K.nw[y] then
                K.nw[y] = 0;
            end
            if K.nw[y] > 34 then
                K.nw[y] = nil;
                return true;
            elseif W.xuid_high == 0 then
                K.nw[y] = K.nw[y] + 1;
            else
                K.nw[y] = 0;
            end
            return false;
        end,
        pd = function(W, y)
            if not K.pd[y] then
                K.pd[y] = 0;
            end
            local P = ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", W) + 16)[0]);
            if K.pd[y] > 24 then
                return true;
            elseif (P == "695B") or (P == "1B39") then
                K.pd[y] = K.pd[y] + 1;
            else
                K.pd[y] = 0;
            end
            return false;
        end,
        ot = function(W, y)
            if not K.ot[y] then
                K.ot[y] = {};
            end
            K.ot[y][#K.ot[y] + 1] = {
                sequence_bytes = W.sequence_bytes,
                xuid_low = W.xuid_low,
                section_number = W.section_number,
                umcompressed_sample_offset = W.uncompressed_sample_offset
            };
            if #K.ot[y] > 16 then
                local W = K.ot[y][1];
                for P = 2, #K.ot[y] do
                    local f = K.ot[y][P];
                    if (f.xuid_low ~= W.xuid_low) or (f.section_number ~= W.section_number) or
                        (f.uncompressed_sample_offset ~= W.uncompressed_sample_offset) then
                        table.remove(K.ot[y], 1);
                        return false;
                    end
                end
                table.remove(K.ot[y], 1);
                return true;
            end
            return false;
        end,
        ft = function(W, y)
            if not K.ft[y] then
                K.ft[y] = 0;
            end
            local P = ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", W) + 16)[0]);
            if K.ft[y] > 36 then
                return true;
            elseif (P == "7FFA") or (P == "7FFB") then
                K.ft[y] = K.ft[y] + 1;
            end
            return false;
        end,
        pl = function(W, y)
            if not K.pl[y] then
                K.pl[y] = 0;
            end
            if K.pl[y] > 24 then
                return true;
            elseif ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", W) + 44)[0]) == "7275" then
                K.pl[y] = K.pl[y] + 1;
            else
                K.pl[y] = 0;
            end
            return false;
        end,
        ev = function(W, y)
            if not K.ev[y] then
                K.ev[y] = {};
            end
            K.ev[y][#K.ev[y] + 1] = W.xuid_high;
            if #K.ev[y] > 44 then
                for W = 1, #K.ev[y] - 4 do
                    local P = K.ev[y][W];
                    if ((K.ev[y][W + 1] + K.ev[y][W + 2]) == (K.ev[y][W] * 2)) and (K.ev[y][W + 4] == (P + 1)) then
                        K.ev[y] = {};
                        return true;
                    end
                end
                table.remove(K.ev[y], 1);
            end
            return false;
        end,
        r7 = function(W, y)
            if not K.r7[y] then
                K.r7[y] = 0;
            end
            local P = ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", W) + 16)[0]);
            if K.r7[y] > 24 then
                return true;
            elseif (P == "234") or (P == "134") then
                K.r7[y] = K.r7[y] + 1;
            else
                K.r7[y] = 0;
            end
            return false;
        end,
        af = function(W, y)
            if not K.af[y] then
                K.af[y] = 0;
            end
            if K.af[y] > 24 then
                return true;
            elseif ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", W) + 16)[0]) == "AFF1" then
                K.af[y] = K.af[y] + 1;
            else
                K.af[y] = 0;
            end
            return false;
        end,
        gs = function(W, y)
            local P = ("%.02X"):format(ffi.cast("uint16_t*", ffi.cast("uintptr_t", W) + 22)[0]);
            local f = string.sub(W.sequence_bytes, 1, 4);
            if not K.gs[y] then
                K.gs[y] = {
                    repeated = 0,
                    packet = P,
                    bytes = f
                };
            end
            if (f ~= K.gs[y].bytes) and (P ~= K.gs[y].packet) then
                K.gs[y].packet = P;
                K.gs[y].bytes = f;
                K.gs[y].repeated = K.gs[y].repeated + 1;
            else
                K.gs[y].repeated = 0;
            end
            if K.gs[y].repeated >= 36 then
                K.gs[y] = {
                    repeated = 0,
                    packet = P,
                    bytes = f
                };
                return true;
            end
            return false;
        end
    };
    client.set_event_callback("voice", function(W)
        local y = ffi.cast(r, W.data);
        local r = (ffi.cast("char*", y) + 8)[0] + 1;
        if not cheat_revealer.users[r] then
            cheat_revealer.users[r] = {};
        end
        local W = cheat_revealer.users[r];
        for P, f in pairs(J) do
            do
                local J = W.cheat;
                if (W.cheat ~= P) and ((P ~= "nl") or
                    ((W.cheat ~= "ev") and (W.cheat ~= "gs") and (W.cheat ~= "pl") and (W.cheat ~= "pd") and
                        (W.cheat ~= "r7") and (W.cheat ~= "af") and (W.cheat ~= "ft"))) and
                    ((P ~= "nw") or (W.cheat ~= "nl")) and
                    ((P ~= "ev") or ((W.cheat ~= "pd") and (W.cheat ~= "nl") and (W.cheat ~= "ft"))) and ((P ~= "gs") or
                    ((W.cheat ~= "ev") and (W.cheat ~= "ot") and (W.cheat ~= "pl") and (W.cheat ~= "pd") and
                        (W.cheat ~= "r7") and (W.cheat ~= "ft"))) and
                    ((P ~= "ot") or
                        ((W.cheat ~= "nw") and (W.cheat ~= "ft") and (W.cheat ~= "pd") and (W.cheat ~= "pl"))) then
                    if (P == "ft") and ((W.cheat == "nw") or (W.cheat == "pd")) then
                        break
                    end
                    if f(y, r) then
                        W.cheat = P;
                    end
                end
            end
        end
    end);
    client.set_event_callback("player_connect_full", function(r)
        local W = client.userid_to_entindex(r.userid);
        if W == entity.get_local_player() then
            cheat_revealer.users = {};
        else
            for r, r in pairs(cheat_revealer.users) do
                r[W] = {};
            end
        end
    end);
    function Cheat.get_colored_names()
        return cheat_revealer.colored_names
    end
    function Cheat.get_cheat(r)
        local W = (cheat_revealer.users[r] and cheat_revealer.users[r].cheat) or "unknown";
        local r = cheat_revealer.names[W] or {};
        local J = cheat_revealer.colored_names[W] or {};
        return {
            cheat_id = W,
            cheat_long = (r.long or "unknown"),
            cheat_short_colored = (J.short or "unknown"),
            cheat_long_colored = (J.long or "unknown"),
            cheat_color = (r.color or "9F9F9FFF")
        };
    end
    function Cheat.has_data(r)
        return cheat_revealer.users[r] ~= nil;
    end
    function Cheat.clear_data(r)
        if cheat_revealer.users[r] == nil then
            return false;
        end
        cheat_revealer.users[r] = nil;
        for L, L in pairs(K) do
            L[r] = nil;
        end
        return true;
    end
end

function helper.strip_color(str)
    if type(str) ~= "string" then return str end
    return str:gsub("\7%x%x%x%x%x%x%x%x", "")
              :gsub("\007%x%x%x%x%x%x%x%x", "")
end

local cheats_list = {"global", "gamesense", "neverlose", "nixware", "pandora", "primordial", "onetap", "fatality", "plaguecheat", "ev0lve", "rifk7", "airflow"}
local colored_names = Cheat.get_colored_names()
local cheat_short_keys = {"gs", "nl", "nw", "pd", "pr", "ot", "ft", "pl", "ev", "r7", "af"}
local cheats_display = {"\7EAEAEAFFglobal"}  
for _, key in ipairs(cheat_short_keys) do
    table.insert(cheats_display, colored_names[key].long)
end


local conditions_list = {"Standing", "Moving", "Walking", "Crouching", "Sneaking", "In air", "In air-crouch", "Freestanding", "Fake lag"}
local conditions_list_menu = {"Standing", "Moving", "Walking", "Crouching", "Sneaking", "In air", "In air-crouch", "Fake lag"}
local cheats_list = {"global", "gamesense", "neverlose", "nixware", "pandora", "primordial", "onetap", "fatality", "plaguecheat", "ev0lve", "rifk7", "airflow"}
local sides_list = {"Counter-Terrorists", "Terrorists"}
local pitch_modes = {"STATIC_DOWN", "STATIC_UP", "STATIC_ZERO", "RANDOM", "OSCILLATE", "JITTER", "DISTORT", "SWAY",
                     "UNPREDICTABLE", "STAIR", "WAVE_CHAOS", "SNAP_RANDOM", "PULSE", "SPIRAL", "DRIFT", "HEARTBEAT",
                     "TRIANGLE", "GLITCH", "PENDULUM", "CHAOTIC_BLEND"}
local yaw_modes   = {"STATIC_LEFT", "STATIC_RIGHT", "RANDOM", "SWAY", "JITTER", "DISTORT", "OSCILLATE", "STEP",
                     "UNPREDICTABLE", "OSCILLATE_EDGES", "WAVE_CHAOS", "SPIN_ACCELERATE", "FAKE_JITTER", "ZONE_SWITCH",
                     "SPIRAL_OUT", "RANDOM_HOLD", "SAWTOOTH", "SPRING", "DOUBLE_SWAY", "ADAPTIVE_CHAOS"}


local builder_defaults = {
    yaw_base = "enemy direction", yaw_offset = 0,
    left_right_enabled = false, randomize = 0,
    left_offset = 0, right_offset = 0,
    delay_mode_left = "static", delay_mode_right = "static",
    left_delay_min = 2, left_delay_max = 14, left_delay_value = 2,
    right_delay_min = 2, right_delay_max = 14, right_delay_value = 2,
    freeze = false, freeze_chance = 0, freeze_time = 0, freeze_cooldown = 1,
    body_yaw = "disabled", body_yaw_side = 0,

        
    force_defensive = false,
    custom_defensive = false,
    pitch_mode = "HEARTBEAT",
    pitch_speed = 1.0,
    pitch_angle = 45.0,
    pitch_max_angle = 89,
    pitch_intensity = 1.0,
    yaw_mode = "SWAY",
    yaw_speed = 1.0,
    yaw_angle = 90.0,
    yaw_max_angle = 180,
    yaw_intensity = 1.0,
    body_yaw_type = "Jitter",
    body_yaw_offset = 0,
}



local function to_number(val, fallback) local n = tonumber(val) return (n ~= nil) and n or fallback end
local function to_bool(val) return (val == true) end
local function to_string(val, fallback) return (type(val) == "string") and val or fallback end

local function make_cond_table()
    local t = {}
    for _, cond in ipairs(conditions_list_menu) do
        t[cond] = {}
        for k, v in pairs(builder_defaults) do t[cond][k] = v end
    end
    return t
end

local function create_empty_builder_data()
    local data = {
        cheat_builder = {},
        side_builder  = {},
        base_builder  = make_cond_table()
    }
    for _, cheat in ipairs(cheats_list) do
        data.cheat_builder[cheat] = { override = false }
        for k, v in pairs(make_cond_table()) do data.cheat_builder[cheat][k] = v end
    end
    for _, side in ipairs({"Counter-Terrorists", "Terrorists"}) do
        data.side_builder[side] = {}  
        for k, v in pairs(make_cond_table()) do data.side_builder[side][k] = v end
    end
    return data
end

local function merge_data(target, source)
    if not source then return end
    
    if source.base_builder and target.base_builder then
        for cond, settings in pairs(source.base_builder) do
            if target.base_builder[cond] and type(settings) == "table" then
                for k, v in pairs(settings) do target.base_builder[cond][k] = v end
            end
        end
    end
    
    if source.cheat_builder and target.cheat_builder then
        for cheat, cheat_data in pairs(source.cheat_builder) do
            if target.cheat_builder[cheat] and type(cheat_data) == "table" then
                if cheat_data.override ~= nil then target.cheat_builder[cheat].override = cheat_data.override end
                for cond, settings in pairs(cheat_data) do
                    if cond ~= "override" and target.cheat_builder[cheat][cond] and type(settings) == "table" then
                        for k, v in pairs(settings) do target.cheat_builder[cheat][cond][k] = v end
                    end
                end
            end
        end
    end
    
    if source.side_builder and target.side_builder then
        for side, side_data in pairs(source.side_builder) do
            if target.side_builder[side] and type(side_data) == "table" then
                if side_data.override ~= nil then target.side_builder[side].override = side_data.override end
                for cond, settings in pairs(side_data) do
                    if cond ~= "override" and target.side_builder[side][cond] and type(settings) == "table" then
                        for k, v in pairs(settings) do target.side_builder[side][cond][k] = v end
                    end
                end
            end
        end
    end
end

local function deep_copy(orig)
    if type(orig) ~= "table" then return orig end
    local copy = {}
    for k, v in pairs(orig) do copy[k] = deep_copy(v) end
    return copy
end

local builder_runtime = create_empty_builder_data()
local DB_RUNTIME  = "emberlash_builder_runtime_v2"
local DB_AUTOLOAD = "emberlash_builder_autoload_name"

local loaded_runtime = database.read(DB_RUNTIME)
local did_load_runtime = false
if loaded_runtime then
    merge_data(builder_runtime, loaded_runtime)
    did_load_runtime = true
end

local builder_dirty = false
local menu_was_open = false
client.set_event_callback("paint_ui", function()
    local is_open = S.is_menu_open()
    if menu_was_open and not is_open then
        if builder_dirty then database.write(DB_RUNTIME, builder_runtime) builder_dirty = false end
    end
    menu_was_open = is_open
end)
client.set_event_callback("shutdown", function() database.write(DB_RUNTIME, builder_runtime) end)


function helper.get_builder_setting(mode, filter, condition, key)
    
    
    local val = nil

    if mode == "base" then
        val = builder_runtime.base_builder[condition] and builder_runtime.base_builder[condition][filter]
        
        if key == nil then key = filter end
        val = builder_runtime.base_builder[condition] and builder_runtime.base_builder[condition][key]

    elseif mode == "cheat" then
        local cb = builder_runtime.cheat_builder[filter]
        if cb and cb.override then
            val = cb[condition] and cb[condition][key]
        end
        if val == nil then
            val = builder_runtime.cheat_builder["global"] and
                  builder_runtime.cheat_builder["global"][condition] and
                  builder_runtime.cheat_builder["global"][condition][key]
        end

    elseif mode == "side" then
        local sb = builder_runtime.side_builder[filter]
        if sb then
            val = sb[condition] and sb[condition][key] 
        end
        if val == nil then val = builder_defaults[key] end
    end

    if val == nil then val = builder_defaults[key] end
    local default = builder_defaults[key]
    if type(default) == "number"  then return to_number(val, default)
    elseif type(default) == "boolean" then return to_bool(val)
    elseif type(default) == "string"  then return to_string(val, default)
    end
    return val
end



local r = {};
do
    r.auto_peek_knife = 0;
    r.peek_side = "none";
    r.last_tick_before_peek = false;
    r.enemy_in_dormant = false;
    r.show_last_tick = false;
    r.time_left = 0;
    r.threat_cheat = "unknown";
    r.state = "Searching";
    do
        local L = nil;
        local K = nil;
        local W = {
            left_peek = nil,
            right_peek = nil,
            left_damage = 0,
            right_damage = 0
        };
        local J = {0, 2, 6};
        local y = {0, 2, 4, 6, 12};
        function r.get_freestand_direction()
            local P = v(client.current_threat());
            if P ~= nil then
                local f = h(client.eye_position());
                local u = h(P:get_origin());
                local P = u + h(0, 0, 40);
                local u = h(f:to(P):angles());
                return F.normalize(u.y + 180, -90.0, 90);
            end
            return 0;
        end
        function r.is_peeking()
            local P = entity.get_local_player();
            if not entity.is_alive(P) then
                L = nil;
                K = nil;
                return false;
            end
            local f = client.current_threat();
            if (not f) or (f == 0) then
                L = nil;
                K = nil;
                return false;
            end
            if (not entity.is_alive(f)) or entity.is_dormant(f) then
                L = nil;
                K = nil;
                return false;
            end
            local u = h(entity.get_origin(P));
            local M = h(entity.get_origin(f));
            local o = u:dist(M);
            if o > 4096 then
                K = 0;
                return false;
            end
            local o = M - u;
            local u = h(client.camera_angles());
            local M = math.deg(math.atan2(o.y, o.x));
            local o = math.abs(F.normalize(M - u.y, -180.0, 180));
            if o > 150 then
                K = 0;
                return false;
            end
            local u = globals.tickinterval() * 8;
            local M = h(entity.get_prop(P, "m_vecVelocity"));
            local o = {};
            for X, X in ipairs(J) do
                local J = h(entity.hitbox_position(P, X));
                local b = h(J.x + (M.x * u), J.y + (M.y * u), J.z + (M.z * u));
                local u = b.x - J.x;
                local M = b.y - J.y;
                local t = b.z - J.z;
                local z = math.sqrt((u ^ 2) + (M ^ 2));
                local n;
                if z > 12 then
                    local G = u / (z + 1e-6);
                    local u = M / (z + 1e-6);
                    n = h(J.x + (G * 12), J.y + (u * 12), J.z + (t * (12 / z)));
                else
                    n = b;
                end
                local u = l.line(J, n, {
                    mask = 33636363,
                    skip = P
                });
                local M;
                if u.fraction >= 0.99 then
                    M = n;
                else
                    M = J;
                end
                o[X] = M;
            end
            local J = 0;
            for u, u in pairs(o) do
                for M, M in ipairs(y) do
                    local y = h(entity.hitbox_position(f, M));
                    if y and u then
                        local M, M = client.trace_bullet(P, u.x, u.y, u.z, y.x, y.y, y.z, f);
                        if (M or 0) > (J or 0) then
                            J = M or 0;
                        end
                    end
                end
            end
            L = o;
            K = J or 0;
            return (J or 0) > 0;
        end
        local function J(y, P)
            local f = 0;
            local u = {0, 2};
            local M = {4, 6, 12};
            for o, o in ipairs(u) do
                local u = h(entity.hitbox_position(y, o));
                if u then
                    local o, o = client.trace_bullet(me, P.x, P.y, P.z, u.x, u.y, u.z, y);
                    if o and (o > f) then
                        f = o;
                        if f > 30 then
                            return f;
                        end
                    end
                end
            end
            if f < 30 then
                for u, u in ipairs(M) do
                    local M = h(entity.hitbox_position(y, u));
                    if M then
                        local u, u = client.trace_bullet(me, P.x, P.y, P.z, M.x, M.y, M.z, y);
                        if u and (u > f) then
                            f = u;
                        end
                    end
                end
            end
            return f;
        end
        function r:get_peek_side()
            local y = entity.get_local_player();
            if not entity.is_alive(y) then
                return "none";
            end
            local P = self:is_peeking();
            if not P then
                return "none";
            end
            local P = client.current_threat();
            if (not P) or (P == 0) then
                return "none";
            end
            if (not entity.is_alive(P)) or entity.is_dormant(P) then
                return "none";
            end
            local f = h(client.eye_position()) or h(entity.hitbox_position(y, 2));
            if not f then
                return "none";
            end
            local u = h(client.camera_angles());
            local M = u.y;
            local u = math.rad(M);
            local M = {-math.cos(u), math.sin(u), 0};
            local u = h(f.x + (M[1] * 24), f.y + (M[2] * 24), f.z);
            local o = h(f.x - (M[1] * 24), f.y - (M[2] * 24), f.z);
            local f = J(P, u) or 0;
            local M = J(P, o) or 0;
            local X = h(entity.hitbox_position(y, 0));
            local y = J(P, X) or 0;
            W.left_peek = u;
            W.right_peek = o;
            W.left_damage = f;
            W.right_damage = M;
            local J = f >= 1;
            local P = M >= 1;
            if (J or P) and ((J and P) or (y >= 1)) then
                return "both";
            end
            if J and (not P) then
                return "left";
            elseif P and (not J) then
                return "right";
            end
            return "none";
        end
        local J = false;
        local y = -1.0;
        function r:is_last_tick_before_peek()
            local P = globals.tickcount();
            local f = J;
            local u = self:get_peek_side() ~= "none";
            if (not f) and u then
                y = P;
            end
            J = u;
            if (y ~= -1.0) and (y == P) then
                return true;
            end
            return false;
        end
        function r.debug_peek_points_paint()
            local J = entity.get_local_player();
            if (not J) or (not entity.is_alive(J)) then
                return;
            end
            local y = client.current_threat();
            if (not y) or (y == 0) or (not entity.is_alive(y)) then
                return;
            end
            if L then
                for P, f in pairs(L) do
                    local L, u = renderer.world_to_screen(f.x, f.y, f.z);
                    if L and u then
                        local f;
                        if K and (K > 0) then
                            f = {0, 255, 0, 220};
                        else
                            f = {255, 0, 0, 220};
                        end
                        renderer.circle_outline(L, u, f[1], f[2], f[3], f[4], 5, 0, 1);
                        local f = {
                            [0] = "HEAD",
                            [2] = "CHEST",
                            [6] = "STOMACH"
                        };
                        if f[P] then
                            renderer.text(L + 8, u - 5, 255, 255, 255, 180, nil, 0, f[P]);
                        end
                    end
                end
            end
            local L = h(entity.hitbox_position(y, 0));
            if L then
                local P, f = renderer.world_to_screen(L.x, L.y, L.z);
                if P and f then
                    if K and (K > 0) then
                        renderer.circle_outline(P, f, 255, 0, 0, 220, 8, 0, 1);
                        renderer.text(P + 10, f, 255, 0, 0, 255, nil, 0, "THREAT");
                    else
                        renderer.circle_outline(P, f, 0, 0, 255, 220, 8, 0, 1);
                        renderer.text(P + 10, f, 0, 0, 255, 255, nil, 0, "THREAT (SAFE)");
                    end
                end
            end
            if W.left_peek and W.right_peek then
                local L, P = renderer.world_to_screen(W.left_peek.x, W.left_peek.y, W.left_peek.z);
                if L and P then
                    if W.left_damage > 0 then
                        renderer.circle_outline(L, P, 0, 255, 255, 220, 10, 0, 1);
                        renderer.text(L + 12, P - 8, 0, 255, 255, 255, nil, 0, "LEFT EXPOSED");
                    else
                        renderer.circle_outline(L, P, 120, 120, 120, 120, 10, 0, 1);
                        renderer.text(L + 12, P - 8, 120, 120, 120, 180, nil, 0, "LEFT SAFE");
                    end
                    renderer.text(L + 12, P + 5, 255, 255, 255, 200, nil, 0, string.format("DMG: %.0f", W.left_damage));
                end
                local L, P = renderer.world_to_screen(W.right_peek.x, W.right_peek.y, W.right_peek.z);
                if L and P then
                    if W.right_damage > 0 then
                        renderer.circle_outline(L, P, 255, 255, 0, 220, 10, 0, 1);
                        renderer.text(L + 12, P - 8, 255, 255, 0, 255, nil, 0, "RIGHT EXPOSED");
                    else
                        renderer.circle_outline(L, P, 120, 120, 120, 120, 10, 0, 1);
                        renderer.text(L + 12, P - 8, 120, 120, 120, 180, nil, 0, "RIGHT SAFE");
                    end
                    renderer.text(L + 12, P + 5, 255, 255, 255, 200, nil, 0, string.format("DMG: %.0f", W.right_damage));
                end
                if W.head_damage then
                    local L = h(entity.hitbox_position(J, 0));
                    if L then
                        local P, f = renderer.world_to_screen(L.x, L.y, L.z);
                        if P and f then
                            if W.head_damage > 0 then
                                renderer.circle_outline(P, f, 255, 100, 0, 180, 7, 0, 1);
                            end
                            renderer.text(P + 10, f, 255, 255, 255, 200, nil, 0,
                                string.format("HEAD: %.0f", W.head_damage));
                        end
                    end
                end
            end
            local L, W = client.screen_size();
            local P = L / 2;
            local L = W - 100;
            local W = r:get_peek_side();
            local f = string.format("PEEK STATUS: %s", W:upper());
            local u = ((W == "none") and {100, 255, 100, 255}) or {255, 100, 100, 255};
            renderer.text(P, L, u[1], u[2], u[3], u[4], "c", 0, f);
            if K then
                renderer.text(P, L + 15, 255, 255, 255, 255, "c", 0, string.format("BEST DAMAGE: %.0f", K));
            end
            local L = h(entity.get_origin(J));
            local K = h(entity.get_origin(y));
            if L and K then
                local W, J = renderer.world_to_screen(L.x, L.y, L.z + 64);
                local L, y = renderer.world_to_screen(K.x, K.y, K.z + 64);
                if W and J and L and y then
                    renderer.line(W, J, L, y, 255, 255, 255, 100);
                end
            end
        end
    end
    do
        local L = function(K, W)
            if (K == 0) and (W == 0) then
                return 0;
            end
            return math.deg(math.atan2(W, K));
        end;
        local function K(W, J, y, P, f)
            local u = {};
            local M = entity.get_player_resource();
            local o = globals.maxplayers();
            local X = entity.get_local_player();
            for b = 1, o do
                if entity.get_prop(M, "m_bConnected", b) ~= 1 then
                    goto K
                end
                if entity.get_prop(M, "m_bAlive", b) ~= 1 then
                    goto K
                end
                if (not y) and (b == X) then
                    goto K
                end
                if J then
                    if (not W) and entity.is_enemy(b) then
                        goto K
                    end
                elseif not entity.is_enemy(b) then
                    goto K
                end
                if (not P) and entity.is_dormant(b) then
                    goto K
                end
                if (not f) and (select(5, entity.get_bounding_box(b)) <= 0) then
                    goto K
                end
                u[#u + 1] = b;
                ::K::
            end
            return u;
        end
        local W = function(J)
            while J > 180 do
                J = J - 360;
            end
            while J < -180.0 do
                J = J + 360;
            end
            return J;
        end;
        local function J(y)
            local P = h(client.eye_position());
            local f = h(client.camera_angles());
            local u = nil;
            local M = 180;
            for o = 1, #y do
                local X = y[o];
                local y = h(entity.get_origin(X));
                local o = math.abs(W((L(P.x - y.x, P.y - y.y) - f.y) + 180));
                if o < M then
                    M = o;
                    u = X;
                end
            end
            return u;
        end
        function r.is_enemy_in_dormant()
            local L = J(K(true, false, false, true, false));
            if (L ~= nil) and entity.is_dormant(L) then
                return true;
            end
            return false;
        end
    end
    local L = {};
    do
        local K = {};
        L.last_condition = nil
        L.debug = {
            state = "unknown",
            side = 1,
            current_delay_mode = "unknown",
            ticks_until_switch = 0,
            is_frozen = false,
            freeze_ticks_left = 0,
            freeze_chance = 0
        };
        local W = {
            last_tickbase = 0,
            jitter_counter = 0,
            sequence_history = {},
            max_history = 10
        };
        local function J(y, P)
            local f = math.ceil(y / globals.tickinterval());
            local y = f + P;
            local P = (((y % 2) == 0) and 2) or 3;
            local y = (((W.jitter_counter % 5) == 0) and 1) or 0;
            return P + y;
        end
        local function y(P)
            table.insert(W.sequence_history, 1, P);
            if #W.sequence_history > W.max_history then
                table.remove(W.sequence_history);
            end
        end
        local function P(f, u)
            local M = f[u .. "_delay_mode"];
            local o = f[u .. "_delay_value"];
            local X = f[u .. "_delay_min"];
            local b = f[u .. "_delay_max"];
            if M == "static" then
                return o;
            elseif M == "random" then
                return math.random(X, b);
            elseif M == "fluctuate" then
                local t = (X + b) / 2;
                local z = (b - X) / 2;
                return math.floor(t + (math.cos(globals.curtime() * 2) * z));
            elseif M == "flick" then
                local t = u .. "_flick_timer";
                if f[t] > 0 then
                    f[t] = f[t] - 1;
                    return 1;
                else
                    f[t] = math.random(3, 6);
                    return o;
                end
            elseif M == "ways" then
                return o;
            elseif M == "wave" then
                local t = u .. "_wave_time";
                f[t] = f[t] + 0.1;
                local z = (math.cos(f[t]) * 0.5) + 0.5;
                return math.floor(X + ((b - X) * z));
            elseif M == "pulse" then
                local t = u .. "_pulse_active";
                f[t] = not f[t];
                return (f[t] and X) or b;
            elseif M == "adaptive" then
                local f = {X, b, o, X, b};
                local u = (W.jitter_counter % #f) + 1;
                return f[u];
            elseif M == "chaotic" then
                local f = (globals.tickcount() * 997) + (W.jitter_counter * 7919);
                math.randomseed(f);
                local f = {2, 1, 3, 1, 2};
                local u = math.random(1, 9);
                local M = 0;
                for t, z in ipairs(f) do
                    M = M + z;
                    if u <= M then
                        return math.floor(X + (((b - X) * (t - 1)) / (#f - 1)));
                    end
                end
                return o;
            end
            return o;
        end
        local function f(u, M, o)
            if u.randomize_amount > 0 then
                local X = globals.tickcount();
                local b = X;
                if o then
                    local t = 0;
                    for z = 1, #o do
                        t = t + string.byte(o, z);
                    end
                    b = X + t;
                end
                math.randomseed(b);
                local o = math.random(-u.randomize_amount, u.randomize_amount);
                return M + o;
            end
            return M;
        end
        local function u(M, o)
            o = o or {};
            K[M] = {
                left_delay_mode = (o.left_delay_mode or "static"),
                left_delay_value = (o.left_delay_value or 1),
                left_delay_min = (o.left_delay_min or 1),
                left_delay_max = (o.left_delay_max or 1),
                left_offset = (o.left_offset or 0),
                left_flick_timer = 0,
                left_wave_time = 0,
                left_pulse_active = false,
                right_delay_mode = (o.right_delay_mode or "static"),
                right_delay_value = (o.right_delay_value or 1),
                right_delay_min = (o.right_delay_min or 1),
                right_delay_max = (o.right_delay_max or 1),
                right_offset = (o.right_offset or 0),
                right_flick_timer = 0,
                right_wave_time = 0,
                right_pulse_active = false,
                randomize_amount = (o.randomize_amount or 0),
                base_offset = (o.base_offset or 0),
                freeze_chance = (o.freeze_chance or 0),
                freeze_time = (o.freeze_time or 0),
                freeze_cooldown = (o.freeze_cooldown or 0),
                is_frozen = false,
                freeze_until_tick = 0,
                last_freeze_tick = 0,
                last_switch_tick = 0,
                current_side = 1,
                next_switch_delay = (o.right_delay_value or 1),
                ways_pattern = {1, -1.0, 1, 1, -1.0, -1.0},
                ways_index = 1,
                enemy_ping = 0
            };
            return K[M];
        end
        local function M(o)
            if (o.freeze_chance <= 0) or (o.freeze_time <= 0) then
                return false;
            end
            local X = globals.tickcount();
            local b = math.random(1, 10000);
            local t = o.freeze_chance * 10;
            local z = o.freeze_cooldown or 0;
            if z > 0 then
                local n = o.last_freeze_tick or 0;
                if (X - n) < z then
                    return false;
                end
            end
            local z = b <= t;
            if z then
                o.last_freeze_tick = X;
            end
            return z;
        end
        function L.get(o, X, b)
            if not K[o] then
                u(o, X);
            end
            local u = K[o];
            if X then
                for t, z in pairs(X) do
                    u[t] = z;
                end
            end
            if b.chokedcommands ~= 0 then
                return u.current_side;
            end
            local X = globals.tickcount();
            local t = entity.get_local_player();
            local z = entity.get_prop(t, "m_nTickBase");
            if (u.left_delay_mode == "adaptive") or (u.right_delay_mode == "adaptive") or
                (u.left_delay_mode == "chaotic") or (u.right_delay_mode == "chaotic") then
                if ((W.last_tickbase + J(u.enemy_ping or 0, b.chokedcommands)) < z) or (W.last_tickbase > z) then
                    W.last_tickbase = z;
                    W.jitter_counter = W.jitter_counter + 1;
                end
            end
            if u.is_frozen then
                if X >= u.freeze_until_tick then
                    u.is_frozen = false;
                else
                    L.debug.state = o;
                    L.debug.side = u.current_side;
                    L.debug.current_delay_mode = ((u.current_side == -1.0) and u.left_delay_mode) or u.right_delay_mode;
                    L.debug.ticks_until_switch = u.next_switch_delay - (X - u.last_switch_tick);
                    L.debug.is_frozen = u.is_frozen;
                    L.debug.freeze_ticks_left = (u.is_frozen and (u.freeze_until_tick - X)) or 0;
                    L.debug.freeze_chance = u.freeze_chance;
                    return u.current_side;
                end
            end
            if (X - u.last_switch_tick) >= u.next_switch_delay then
                if (u.left_delay_mode == "ways") or (u.right_delay_mode == "ways") then
                    u.current_side = u.ways_pattern[u.ways_index];
                    u.ways_index = (u.ways_index % #u.ways_pattern) + 1;
                else
                    u.current_side = -u.current_side;
                end
                y(u.current_side);
                u.last_switch_tick = X;
                local J = ((u.current_side == -1.0) and "left") or "right";
                u.next_switch_delay = P(u, J);
                if M(u) then
                    u.is_frozen = true;
                    u.freeze_until_tick = X + u.freeze_time;
                end
            end
            L.debug.state = o;
            L.debug.side = u.current_side;
            L.debug.current_delay_mode = ((u.current_side == -1.0) and u.left_delay_mode) or u.right_delay_mode;
            L.debug.ticks_until_switch = u.next_switch_delay - (X - u.last_switch_tick);
            L.debug.is_frozen = u.is_frozen;
            L.debug.freeze_ticks_left = (u.is_frozen and (u.freeze_until_tick - X)) or 0;
            L.debug.freeze_chance = u.freeze_chance;
            return u.current_side;
        end
        function L.get_offset(J)
            if not K[J] then
                return 0;
            end
            local y = K[J];
            local J = y.current_side * y.base_offset;
            if (y.left_offset ~= 0) and (y.right_offset ~= 0) then
                J = ((y.current_side == -1.0) and y.left_offset) or y.right_offset;
            end
            local P = ((y.current_side == -1.0) and "left") or "right";
            return f(y, J, P);
        end
        function L.reset_state(name)
            local s = K[name]
            if not s then
                return
            end
        
            s.last_switch_tick = 0
            s.current_side = 1
            s.next_switch_delay = s.right_delay_value or 1
        
            s.ways_index = 1
        
            s.left_flick_timer = 0
            s.right_flick_timer = 0
        
            s.left_wave_time = 0
            s.right_wave_time = 0
        
            s.left_pulse_active = false
            s.right_pulse_active = false
        
            s.is_frozen = false
            s.freeze_until_tick = 0
        end

        function L.reset()
            for J, J in pairs(K) do
                J.last_switch_tick = 0;
                J.current_side = 1;
                J.ways_index = 1;
                J.left_flick_timer = 0;
                J.left_wave_time = 0;
                J.right_flick_timer = 0;
                J.left_right_time = 0;
                J.is_frozen = false;
                J.freeze_until_tick = 0;
            end
            W.last_tickbase = 0;
            W.jitter_counter = 0;
            W.sequence_history = {};
        end
    end
    function r:setup(K, W)
        r.peek_side = r:get_peek_side();
        r.last_tick_before_peek = r:is_last_tick_before_peek();
        r.enemy_in_dormant = r:is_enemy_in_dormant();
        local J = r._last_peek_tick_time or 0;
        local y = globals.realtime();
        if r.last_tick_before_peek then
            r._last_peek_tick_time, J = y, y;
            r.show_last_tick, r.time_left = true, 3;
        elseif J and ((y - J) <= 3) then
            r.show_last_tick = true;
            r.time_left = math.max(0, math.ceil(3 - (y - J)));
            if r.time_left <= 0 then
                r.show_last_tick = false;
                r.time_left = 0;
                r._last_peek_tick_time = nil;
            end
        else
            r.show_last_tick = false;
            r.time_left = 0;
            r._last_peek_tick_time = nil;
        end
        local J = {
            yaw_base = "At targets",
            yaw_offset = 0,
            yaw_jitter = "Off",
            jitter_offset = 0,
            body_yaw = "Opposite",
            body_yaw_angle = 0,
            fs_body_yaw = false
        };
        local y = entity.get_local_player();
        local P = h(entity.get_origin(y));
        local y = 0;
        local f = ctx.state;
        local function u(M, o, X)
            J.body_yaw = M;
            J.body_yaw_angle = o;
            J.fs_body_yaw = X or false;
        end
        local M = client.current_threat();
        if M then
            if ctx:resolve_aa_mode(2) == "Cheat-based builder" or not ctx:resolve_aa_mode(0) then
                local o = Cheat.get_cheat(M);
                r.threat_cheat = (o and o.cheat_long) or "unknown";
                r.state = string.format("Preset [%s]", r.threat_cheat);
            else
                r.state = string.format("~ %s ~", ctx:get_state());
            end
            local o = entity.get_prop(M, "m_iPing") or 0;
            local X = h(entity.get_origin(M));
            y = math.ceil(P.z - X.z);
            if K == "Default" then
                if r.threat_cheat == "neverlose" then
                    if f == "Moving" then
                        if r.last_tick_before_peek then
                            if r.peek_side == "left" then
                                u("Static", 90);
                            elseif r.peek_side == "right" then
                                u("Static", -90.0);
                            else
                                u("Jitter", 180, true);
                            end
                        elseif r.show_last_tick then
                            r.state = string.format("Dynamic [%s]", r.threat_cheat);
                            u("Jitter", 180, true);
                        end
                    elseif r.peek_side == "left" then
                        u("Static", -90.0);
                    elseif r.peek_side == "right" then
                        u("Static", 90);
                    elseif r.peek_side == "both" then
                        u("Jitter", 180);
                    end
                elseif r.threat_cheat == "gamesense" then
                    if r.peek_side == "left" then
                        u("Static", 90);
                    elseif r.peek_side == "right" then
                        u("Static", -90.0);
                    elseif r.peek_side == "both" then
                        u("Jitter", 180);
                    end
                elseif r.peek_side == "left" then
                    u("Static", -90.0);
                elseif r.peek_side == "right" then
                    u("Static", 90);
                elseif r.peek_side == "both" then
                    u("Jitter", 180);
                end
            elseif K == "Experimental" then
                if (ctx.additional_state == "Fake lag") or ((y > 120) and (ctx.hp > 93)) then
                    r.state = ((ctx.additional_state == "Fake lag") and "Fake lag") or "Height advantage";
                    u("Off", 0);
                else
                    local K = {
                        Standing = {
                            left_delay_mode = "flick",
                            left_delay_value = 3,
                            right_delay_mode = "random",
                            right_delay_min = 1,
                            right_delay_max = 3,
                            left_offset = -31.0,
                            right_offset = 31
                        },
                        Moving = (function()
                            local y = {
                                neverlose = {
                                    left_delay_mode = "adaptive",
                                    left_delay_value = 1,
                                    left_delay_min = 1,
                                    left_delay_max = 14,
                                    right_delay_mode = "adaptive",
                                    right_delay_value = 1,
                                    right_delay_min = 1,
                                    right_delay_max = 14,
                                    left_offset = -31.0,
                                    right_offset = 33,
                                    randomize_amount = 0,
                                    enemy_ping = o
                                },
                                gamesense = {
                                    left_delay_mode = "chaotic",
                                    left_delay_value = 2,
                                    left_delay_min = 1,
                                    left_delay_max = 5,
                                    right_delay_mode = "chaotic",
                                    right_delay_value = 4,
                                    right_delay_min = 1,
                                    right_delay_max = 8,
                                    left_offset = -29.0,
                                    right_offset = 37,
                                    randomize_amount = 2,
                                    enemy_ping = o
                                },
                                unknown = {
                                    left_offset = -26.0,
                                    right_offset = 32,
                                    randomize_amount = 2
                                }
                            };
                            local P = r.threat_cheat;
                            if (P ~= "neverlose") and (P ~= "gamesense") then
                                P = "unknown";
                            end
                            return y[P];
                        end)(),
                        Walking = {
                            left_delay_mode = "ways",
                            left_delay_value = 2,
                            left_delay_min = 10,
                            left_delay_max = 18,
                            right_delay_mode = "wave",
                            right_delay_value = 17,
                            right_delay_min = 6,
                            right_delay_max = 9,
                            left_offset = -27.0,
                            right_offset = 31,
                            randomize_amount = 0
                        },
                        Crouching = {
                            left_offset = -21.0,
                            right_offset = 34
                        },
                        Sneaking = {
                            left_offset = -21.0,
                            right_offset = 34,
                            randomize_amount = 9
                        },
                        ["In air"] = (function()
                            local y = {
                                neverlose = {
                                    left_delay_mode = "adaptive",
                                    left_delay_value = 1,
                                    left_delay_min = 1,
                                    left_delay_max = 3,
                                    right_delay_mode = "adaptive",
                                    right_delay_value = 1,
                                    right_delay_min = 1,
                                    right_delay_max = 3,
                                    left_offset = -5.0,
                                    right_offset = -2.0,
                                    randomize_amount = 4,
                                    enemy_ping = o
                                },
                                gamesense = {
                                    left_delay_mode = "adaptive",
                                    left_delay_value = 6,
                                    left_delay_min = 1,
                                    left_delay_max = 4,
                                    right_delay_mode = "adaptive",
                                    right_delay_value = 1,
                                    right_delay_min = 1,
                                    right_delay_max = 6,
                                    left_offset = -31.0,
                                    right_offset = 40,
                                    randomize_amount = 1,
                                    enemy_ping = o
                                },
                                unknown = {
                                    left_delay_mode = "random",
                                    left_delay_min = 1,
                                    left_delay_max = 4,
                                    right_delay_mode = "random",
                                    right_delay_min = 1,
                                    right_delay_max = 3,
                                    base_offset = 3,
                                    randomize_amount = 0
                                }
                            };
                            local P = r.threat_cheat;
                            if (P ~= "neverlose") and (P ~= "gamesense") then
                                P = "unknown";
                            end
                            return y[P];
                        end)(),
                        ["In air-crouch"] = (function()
                            local y = {
                                neverlose = {
                                    left_delay_mode = "adaptive",
                                    left_delay_value = 1,
                                    left_delay_min = 1,
                                    left_delay_max = 3,
                                    right_delay_mode = "adaptive",
                                    right_delay_value = 1,
                                    right_delay_min = 1,
                                    right_delay_max = 3,
                                    left_offset = -36.0,
                                    right_offset = 44,
                                    randomize_amount = 8,
                                    enemy_ping = o
                                },
                                gamesense = {
                                    left_delay_mode = "chaotic",
                                    left_delay_value = 3,
                                    left_delay_min = 1,
                                    left_delay_max = 6,
                                    right_delay_mode = "wave",
                                    right_delay_value = 4,
                                    left_offset = -27.0,
                                    right_offset = 38,
                                    randomize_amount = 3,
                                    enemy_ping = o
                                },
                                unknown = {
                                    left_delay_mode = "adaptive",
                                    left_delay_value = 2,
                                    left_delay_min = 1,
                                    left_delay_max = 5,
                                    right_delay_mode = "adaptive",
                                    right_delay_value = 4,
                                    right_delay_min = 1,
                                    right_delay_max = 8,
                                    left_offset = -31.0,
                                    right_offset = 42,
                                    randomize_amount = 2,
                                    enemy_ping = o
                                }
                            };
                            local P = r.threat_cheat;
                            if (P ~= "neverlose") and (P ~= "gamesense") then
                                P = "unknown";
                            end
                            return y[P];
                        end)()
                    };
                    local y = f;
                    local P = y:lower():gsub("^%l", string.upper);
                    local M = K[P];
                    local K = L.get(y, M, W);
                    u("Static", K * 90);
                    local K = L.get_offset(y);
                    J.yaw_offset = K;
                end
            
            else
                local mode = "base"
                local filter = "global"


                local cond = ctx:get_state()

                if K == "Builder" then
                    mode = "base"
                elseif K == "Cheat-based builder" then
                    mode = "cheat"
                    local threat_cheat = (r.threat_cheat or "unknown"):lower()
                    for _, c in ipairs(cheats_list) do
                        if threat_cheat:find(c) then
                            filter = c
                            break
                        end
                    end
                elseif K == "Side-based builder" then
                    mode = "side"
                    filter = (ctx:get_team() == 3 and "Counter-Terrorists" or "Terrorists")
                end

                local yaw_base =            helper.get_builder_setting(mode, filter, cond, "yaw_base")
                local left_right_enabled =  helper.get_builder_setting(mode, filter, cond, "left_right_enabled")
                local yaw_offset =          helper.get_builder_setting(mode, filter, cond, "yaw_offset")
                local left_offset =         helper.get_builder_setting(mode, filter, cond, "left_offset")
                local right_offset =        helper.get_builder_setting(mode, filter, cond, "right_offset")
                local randomize =           helper.get_builder_setting(mode, filter, cond, "randomize")
                local delay_mode_left =     helper.get_builder_setting(mode, filter, cond, "delay_mode_left")
                local left_delay_min =      helper.get_builder_setting(mode, filter, cond, "left_delay_min")
                local left_delay_max =      helper.get_builder_setting(mode, filter, cond, "left_delay_max")
                local left_delay_static =   helper.get_builder_setting(mode, filter, cond, "left_delay_value")
                local delay_mode_right =    helper.get_builder_setting(mode, filter, cond, "delay_mode_right")
                local right_delay_min =     helper.get_builder_setting(mode, filter, cond, "right_delay_min")
                local right_delay_max =     helper.get_builder_setting(mode, filter, cond, "right_delay_max")
                local right_delay_static =  helper.get_builder_setting(mode, filter, cond, "right_delay_value")
                local freeze =              helper.get_builder_setting(mode, filter, cond, "freeze")
                local freeze_chance =       helper.get_builder_setting(mode, filter, cond, "freeze_chance")
                local freeze_time =         helper.get_builder_setting(mode, filter, cond, "freeze_time")
                local freeze_cooldown =     helper.get_builder_setting(mode, filter, cond, "freeze_cooldown")
                local body_yaw =            helper.get_builder_setting(mode, filter, cond, "body_yaw")
                local body_yaw_side =       helper.get_builder_setting(mode, filter, cond, "body_yaw_side")

                J.yaw_base = (yaw_base == "enemy direction") and "At targets" or "Local view"
                local M = {
                    left_delay_mode =  delay_mode_left,
                    left_delay_value = left_delay_static,
                    left_delay_min = left_delay_min,
                    left_delay_max = left_delay_max,
                    left_offset = left_right_enabled and (yaw_offset + left_offset) or yaw_offset,
                    right_delay_mode = delay_mode_right,
                    right_delay_value = right_delay_static,
                    right_delay_min = right_delay_min,
                    right_delay_max = right_delay_max,
                    right_offset = left_right_enabled and (yaw_offset + right_offset) or yaw_offset,
                    freeze_chance = (freeze and freeze_chance) or 0,
                    freeze_time = freeze_time,
                    freeze_cooldown = freeze_cooldown,
                    randomize_amount = randomize,
                }
                if L.last_condition ~= cond then
                    L.reset()
                    L.last_condition = cond
                end

                local K_side = L.get(cond, M, W)
                J.yaw_offset = L.get_offset(cond)
                local b_body_yaw, b_body_yaw_side
                if body_yaw == "jitter" then
                    b_body_yaw = "Static"
                    b_body_yaw_side = K_side * 180 * -1
                    
                elseif body_yaw == "static" then
                    b_body_yaw = "Static"
                    b_body_yaw_side = body_yaw_side * 90
                else
                    b_body_yaw = "Off"
                end
                
                u(b_body_yaw, b_body_yaw_side, false)
            end
        else
            r.state = "Searching";

        end
        if ((ctx.weapon == "Knife") or (ctx.weapon == "Taser")) and (f == "In air-crouch") then
            r.state = "Safe head";
            J.yaw_offset = 0;
            J.yaw_jitter = "Off";
            J.jitter_offset = 0;
            u("Off", 0);
        end
        return J;
    end
    function r:push(K)
        K = K or {};
        c.aa.angles.enabled:override(true);
        local W = K.pitch or "Down";
        local J = K.pitch_angle or 0;
        c.aa.angles.pitch[1]:override(W);
        c.aa.angles.pitch[2]:override(F.clamp(J, -89.0, 89));
        local W = K.yaw_base or "At targets";
        c.aa.angles.yaw_base:override(W);
        local shit_aa = Menu.aa.addons.shit_aa
        local f = (ctx.is_warmup() and (shit_aa:get("Warm-up") == true)) or (shit_aa:get("If enemies dead") == true and r.state == "Searching")
        local W = (f == true) and "Spin" or ((K.yaw ~= nil) and K.yaw or "180")
        local J = (f == true) and 61 or ((K.yaw_offset ~= nil) and K.yaw_offset or 0)
        c.aa.angles.yaw[1]:override(W);
        c.aa.angles.yaw[2]:override(F.clamp(J, -180.0, 180));
        local W = K.yaw_jitter or "Off";
        local J = K.jitter_offset or 0;
        c.aa.angles.yaw_jitter[1]:override(W);
        c.aa.angles.yaw_jitter[2]:override(J);
        local W = K.body_yaw or "Off";
        local J = K.body_yaw_angle or 180;
        local y = K.fs_body_yaw or false;
        c.aa.angles.body_yaw[1]:override(W);
        c.aa.angles.body_yaw[2]:override(J);
        c.aa.angles.fs_body_yaw:override(y);
    end
    function r.cleanup()
    end
    local function K(W, J, y, P)
        return {
            name = W,
            value = J,
            color = (y or {255, 255, 255, 180}),
            b = (P or false)
        };
    end
    function r.debug()
        local W = entity.get_local_player();
        if not entity.is_alive(W) then
            return;
        end
        local W = c.aa.angles;
        local J = {K("pitch", W.pitch[1]:get():lower()), K("pitch_angle", W.pitch[2]:get()),
                   K("yaw", W.yaw[1]:get():lower()), K("offset", W.yaw[2]:get()),
                   K("yaw_jitter", W.yaw_jitter[1]:get():lower()), K("jitter_offset", W.yaw_jitter[2]:get()),
                   K("body_yaw_type", W.body_yaw[1]:get():lower()),
                   K("body_yaw", string.format("%d (%d / %d\194\176)", W.body_yaw[2]:get(), ctx.body_yaw, ctx.desync)),
                   K("fs_body_yaw", W.fs_body_yaw:get())};
        table.insert(J, {
            name = " ",
            color = {255, 255, 255, 255},
            b = false
        });
        local W = client.current_threat();
        local y = L.debug;
        if W and y then
            local P = ((y.side == 1) and "right") or "left";
            local f = ((y.side == 1) and {255, 255, 0, 255}) or {0, 255, 255, 255};
            table.insert(J, K("inverter_state", y.state:lower() or "unknown", {200, 200, 200, 255}, false));
            table.insert(J, K("inverter_side", P, f, true));
            table.insert(J, K("current_delay_mode", y.current_delay_mode or "unknown", {255, 200, 100, 255}, false));
            table.insert(J,
                K("next_switch", string.format("%dt", y.ticks_until_switch or 0), {180, 180, 255, 255}, false));
            if y.is_frozen then
                table.insert(J, K("frozen", string.format("true (%dt left)", y.freeze_ticks_left or 0),
                    {255, 100, 100, 255}, true));
            else
                table.insert(J, K("freeze_chance", string.format("%d%%", y.freeze_chance or 0), {160, 160, 160, 255},
                    false));
            end
            table.insert(J, {
                name = " ",
                color = {255, 255, 255, 255},
                b = false
            });
        end
        table.insert(J,
            K("peeking", r.peek_side ~= "none", ((r.peek_side ~= "none") and {0, 255, 0, 255}) or {255, 0, 0, 255},
                r.peek_side ~= "none"));
        table.insert(J, K("last_tick_before_peek", (r.show_last_tick and ("true (" .. r.time_left .. ")")) or "false",
            (r.show_last_tick and {155, 190, 220, 255}) or {200, 200, 200, 255}, r.show_last_tick));
        if r.peek_side ~= "none" then
            local y = {
                left = {0, 255, 255, 255},
                right = {255, 255, 0, 255},
                both = {128, 128, 255, 255}
            };
            table.insert(J, K("peek_side", r.peek_side, y[r.peek_side] or {255, 255, 255, 255}, r.peek_side ~= "none"));
        end
        local y = entity.get_player_name(W);
        local P = y ~= "unknown";
        table.insert(J, K("target", y, (P and {195, 255, 155, 255}) or {160, 160, 160, 255}, P));
        if P then
            local y = Cheat.get_cheat(W).cheat_long_colored or "unknown";
            table.insert(J, K("cheat", y, ((y ~= "unknown") and {255, 255, 255, 255}) or {160, 160, 160, 255},
                y ~= "unknown"));
        end
        local C, C = client.screen_size();
        local K = (C / 2) + 30;
        for C, W in ipairs(J) do
            local J;
            if W.name == " " then
                J = W.name;
            else
                J = string.format("%s: %s", W.name, tostring(W.value));
            end
            local y = W.color or {255, 255, 255, 255};
            renderer.text(20, K + ((C - 1) * 12) + 230, y[1], y[2], y[3], y[4], (W.b and "b") or "", 0, J);
        end
    end

    client.set_event_callback("player_death", function(C)
        local K = client.userid_to_entindex(C.userid);
        if K == entity.get_local_player() then
            L.reset();
        end
    end);
    client.set_event_callback("round_start", L.reset);
end

local unpack_ = table.unpack or unpack

local function deepcopy(v, seen)
    if type(v) ~= "table" then return v end
    if seen and seen[v] then return seen[v] end

    seen = seen or {}
    local out = {}
    seen[v] = out

    for k, val in pairs(v) do
        out[deepcopy(k, seen)] = deepcopy(val, seen)
    end

    return out
end

local function is_ui_element(v)
    return type(v) == "table" and type(v.get) == "function" and type(v.set) == "function"
end

local function read_element(elem)
    local results = { pcall(elem.get, elem) }
    if not results[1] then
        return nil
    end

    table.remove(results, 1)

    if #results <= 1 then
        return results[1]
    end

    results.__packed = true
    results.n = #results
    return results
end

local function write_element(elem, value)
    if type(value) == "table" and value.__packed then
        local args = {}
        for i = 1, value.n do
            args[i] = value[i]
        end
        pcall(function()
            elem:set(unpack_(args, 1, value.n))
        end)
    else
        pcall(function()
            elem:set(value)
        end)
    end
end

local function resolve_path(root, path)
    local rel = path:gsub("^Menu%.", "")
    local cur = root

    for key in rel:gmatch("[^%.]+") do
        if cur == nil then
            return nil
        end
        cur = cur[key]
    end

    return cur
end

local function should_skip_path(path)
    if path:match("^Menu%.configuration") then
        return true
    end

    if path:match("^Menu%.aa%.builder") then
        return true
    end

    if path == "Menu.settings.visuals.watermark.order_list" then
        return true
    end

    return false
end

local function collect_table(node, path, out, seen)
    if type(node) ~= "table" then
        return
    end

    if seen[node] then
        return
    end
    seen[node] = true

    for k, v in pairs(node) do
        local child_path = path .. "." .. tostring(k)

        if not should_skip_path(child_path) then
            if is_ui_element(v) then
                local val = read_element(v)
                if val ~= nil then
                    out[child_path] = val
                end
            elseif type(v) == "table" then
                collect_table(v, child_path, out, seen)
            end
        end
    end
end

local C = {
    root = nil,
    _extra_getters = {},
    _extra_setters = {},
}

function C:add_extra(name, getter, setter)
    self._extra_getters[name] = getter
    self._extra_setters[name] = setter
end

function C:save()
    local payload = {
        version = 2,
        menu = {},
        builder = deepcopy(builder_runtime or {}),
        extra = {},
    }

    if self.root then
        collect_table(self.root, "Menu", payload.menu, {})
    end

    for name, getter in pairs(self._extra_getters) do
        local ok, data = pcall(getter)
        if ok then
            payload.extra[name] = deepcopy(data)
        end
    end

    return payload
end

function C:load(data)
    if type(data) ~= "table" then
        return false
    end

    if type(data.menu) == "table" then
        for path, value in pairs(data.menu) do
            local elem = resolve_path(self.root, path)
            if elem then
                write_element(elem, value)
            end
        end
    end

    if type(data.builder) == "table" then
        builder_runtime = deepcopy(data.builder)
        database.write(DB_RUNTIME, builder_runtime)
        builder_dirty = false
    end

    if type(data.extra) == "table" then
        for name, value in pairs(data.extra) do
            local setter = self._extra_setters[name]
            if setter then
                pcall(setter, deepcopy(value))
            end
        end
    end

    if update_builder_ui then
        pcall(update_builder_ui)
    end

    return true
end

local L = {}
do
    local K = database.read("emberlashkoxoxoxofam") or {}

    local function W(J)
        local y = base64.encode(json.stringify(J))
        return table.concat({"emberlash", y, "emberlash"}, "::")
    end

    local function J(y)
        local P = y:match("emberlash::([%w%+/=\r\n]+)::emberlash")
        if not P then
            print("Invalid config format")
            return nil
        end
        local decoded = base64.decode(P)
        return json.parse(decoded)
    end

    function L:export(name)
        return W({
            name = name or "Untitled",
            code = C:save(),
        })
    end

    function L:import(blob)
        local cfg = J(blob)
        if not cfg then
            return nil
        end

        C:load(cfg.code or cfg)
        return cfg
    end

    function L.get_configs()
        local out = {}
        for i, cfg in ipairs(K) do
            out[i] = cfg.name
        end
        return out
    end

    function L:get(idx)
        return K[idx]
    end

    function L:delete(idx)
        table.remove(K, idx)
    end

    function L:create(name, encoded)
        table.insert(K, {
            name = name,
            code = encoded
        })
    end

    function L:save(idx, encoded)
        if K[idx] then
            K[idx].code = encoded
        end
    end

    function L:create_from_encoded_data(encoded)
        local cfg = J(encoded)
        if not cfg then
            error("Invalid config data.")
            return
        end

        local base_name = cfg.name or "Config"
        local new_name = base_name
        local n = 0
        local existing = L.get_configs()

        local function exists(s)
            for _, name in ipairs(existing) do
                if name == s then
                    return true
                end
            end
            return false
        end

        while exists(new_name) do
            n = n + 1
            new_name = base_name .. "(" .. n .. ")"
        end

        cfg.name = new_name
        self:create(new_name, encoded)
    end

    defer(function()
        database.write("emberlashkoxoxoxofam", K)
        database.flush()
    end)
end
function Menu.lock(J, y, P)
    if U.level < (P or 2) then
        local P = function(f)
            client.delay_call(0.1, function()
                f:set(y or false);
            end);
        end;
        J:set_callback(P, true);
        
    end
    return J;
end
S.macros.gray = "\0073d3d3dff";
S.macros.exploit = "\7abab61ff";
S.macros.sub = " \0077d7d7dff\226\134\170\r ";
S.macros.seperation =
    "\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128";
do
    Menu.space = groups.aa.angles:label("\nspace");
    Menu.toggle = groups.aa.angles:checkbox(string.format(
        "\226\139\134\226\156\180\239\184\142\203\154\239\189\161\226\139\134 \11%s %s\r \7ce9f9fff[%s]",
        U.name:lower(), U.version, U.build:lower()));
    local function J(y)
        local P = c.aa.angles;
        if y:get() then
            P.yaw[2]:depend({P.yaw[1], 666}, {P.yaw[2], 666});
            P.pitch[2]:depend({P.pitch[1], 666}, {P.pitch[2], 666});
            P.yaw_jitter[1]:depend({P.yaw[1], 666}, {P.yaw[2], 666});
            P.yaw_jitter[2]:depend({P.yaw[1], 666}, {P.yaw[2], 666}, {P.yaw_jitter[1], 666}, {P.yaw_jitter[2], 666});
            P.body_yaw[2]:depend({P.body_yaw[1], 666});
            P.fs_body_yaw:depend({P.body_yaw[1], 666});
        end
    end
    Menu.toggle:set_callback(J);
    S.traverse({c.aa, Menu.space}, function(J)
        J:depend({Menu.toggle, false});
        if J.hotkey then
            J.hotkey:depend({Menu.toggle, false});
        end
    end);
end
Menu.tabs = {};
Menu.tabs.main = groups.aa.angles:combobox("\nTab", {"Home", "Settings", "Anti-aimbot angles"});
S.traverse(Menu.tabs, function(J)
    J:depend({Menu.toggle, true});
end);
Menu.configuration = {};
do
    local J = {
        list = {},
        id = 1
    };
    
    local function get_autoload_options()
        local opts = {"Disabled"}
        if L and L.get_configs then
            local configs = L.get_configs()
            for _, name in ipairs(configs) do
                table.insert(opts, name)
            end
        end
        return opts
    end

    local function y()
        local P = Menu.configuration.name:get():gsub(" ", "");
        if P == "" then
            return true, "Config";
        end
        return true, P;
    end
    local function P(f)
        if #L:get_configs() <= 0 then
            print("No configs available.");
            return false, nil;
        end
        local u = L:get(f);
        if not u then
            print("Config not found.");
            return false, nil;
        end
        return true, u;
    end
    local function f()
        local u, M = P(J.id);
        if (not u) or (not M) then
            print("Config is invalid.");
            return;
        end
        L:import(M.code);
        cvar.play:invoke_callback("ambient\\tones\\elev1");
    end
    local function u()
        local M, o = y();
        if not M then
            return;
        end
        local M = L:export(o);
        local X = L:get(J.id);
        if (not X) or (o ~= X.name) then
            L:create(o, M);
            cvar.play:invoke_callback("ambient\\tones\\elev1");
        else
            L:save(J.id, M);
            cvar.play:invoke_callback("ambient\\tones\\elev1");
        end
    end
    local function M()
        local o, X = P(J.id);
        if (not o) or (not X) then
            return;
        end
        L:delete(J.id);
        cvar.play:invoke_callback("ambient\\tones\\elev1");
    end
    local function P()
        local o, X = y();
        if not o then
            return;
        end
        clipboard.set(L:export(X));
        print("Copied to clipboard.");
    end
    local function y()
        local o = clipboard.get();
        if not o then
            print("Clipboard is empty.");
            return;
        end
        local X = pcall(L.create_from_encoded_data, L, o);
        print((X and "Config imported successfully.") or "Invalid config data.");
    end
    
    Menu.configuration.list = groups.aa.angles:listbox("\nConfig list",
        ((#L:get_configs() > 0) and L:get_configs()) or {"Empty"});
    Menu.configuration.name = groups.aa.angles:textbox("\nConfig name");
    Menu.configuration.save = groups.aa.angles:button("Save", u);
    Menu.configuration.load = groups.aa.angles:button("Load", f);
    Menu.configuration.delete = groups.aa.angles:button("Delete", M);
    Menu.configuration.export = groups.aa.angles:button("Export", P);
    Menu.configuration.import = groups.aa.angles:button("Import", y);
    
    Menu.configuration.reset_builder = groups.aa.angles:button("Reset", function()
        builder_runtime = create_empty_builder_data()
        database.write(DB_RUNTIME, builder_runtime)  
        builder_dirty = false
        if update_builder_ui then update_builder_ui() end
        client.color_log(255, 100, 100, "emberlash > Runtime config reset to defaults.")
    end)

    
    Menu.configuration.autoload_space = groups.aa.angles:label("\nspace")
    Menu.configuration.autoload = groups.aa.angles:combobox("Autoload", get_autoload_options())
    local saved_autoload = database.read(DB_AUTOLOAD) or "Disabled"
    local init_opts = get_autoload_options()
    for i, opt in ipairs(init_opts) do
        if opt == saved_autoload then
            Menu.configuration.autoload:set(opt)
            break
        end
    end
    
    Menu.configuration.autoload:set_callback(function(val)
        local selected_name = (type(val:get()) == "string") and val:get() or "Disabled"
        database.write(DB_AUTOLOAD, selected_name)
        client.color_log(159, 166, 205, "emberlash > Autoload set to: " .. selected_name)
    end)

    Menu.configuration.list:set_callback(function(y)
        local P = L:get(y:get() + 1) or L:get(J.id);
        if P == nil then
            Menu.configuration.name:set("");
            return;
        end
        Menu.configuration.name:set(P.name);
    end);
    
    client.set_event_callback("paint_ui", function()
        if not S.is_menu_open() then return end
        local y = L:get_configs();
        
        if #y ~= #J.list then
            J.list = y;
            if #y == 0 then
                Menu.configuration.list:update({"Empty"});
                Menu.configuration.list.value = 1;
                J.id = 1;
            else
                Menu.configuration.list:update(y);
            end
            
            
            local new_opts = get_autoload_options()
            pcall(function()
                Menu.configuration.autoload:set_visible_items(new_opts)
            end)
            
            local saved_name = database.read(DB_AUTOLOAD) or "Disabled"
            local found = false
            for _, opt in ipairs(new_opts) do
                if opt == saved_name then
                    found = true
                    break
                end
            end
            
            
            if not found then
                saved_name = "Disabled"
                database.write(DB_AUTOLOAD, "Disabled")
            end
            
            Menu.configuration.autoload:set(saved_name)
        end
        
        if Menu.configuration.list.value == nil then
            Menu.configuration.list.value = 1;
        end
        local L_idx = (Menu.configuration.list.value or 1) + 1;
        if L_idx ~= J.id then
            J.id = L_idx;
        end
    end);
    
    S.traverse(Menu.configuration, function(L)
        L:depend({Menu.toggle, true}, {Menu.tabs.main, "Home"});
    end);
end




local ORDER = {
    "branding",
    "username",
    "clock",
    "fps",
    "ping",
    "var",
    "loss",
    "timeout",
}

local ORDER_LABEL = {
    branding = "branding",
    username = "Username",
    clock    = "Clock",
    fps      = "FPS",
    ping     = "Ping",
    var      = "Var",
    loss     = "Loss",
    timeout  = "Timeout",
}

local LOCKED = {
    avatar = true,
}

local state = {
    master_alpha     = 0.0,
    held_w           = 0.0,
    shrink_start     = nil,
    SHRINK_DELAY     = 5.0,
    last_vis_count   = 0,
    last_t           = nil,
    order            = {},
    blocks           = {},
    order_items      = {},
    loss_hide_timer    = nil,
    loss_force_hidden  = false,
    timeout_hide_timer = nil,
    timeout_force_hidden = false,
    HIDE_DELAY         = 5.0,
}

local function copy_order(src)
    local out = {}
    for i = 1, #src do
        out[i] = src[i]
    end
    return out
end

state.order = copy_order(ORDER)

local function get_block_enabled(block_id)
    local visuals = Menu.settings.visuals and Menu.settings.visuals.watermark or {}
    local ref = visuals[block_id]
    if ref == nil or not ref.get then return true end
    return ref:get()
end

local function sync_order_listbox()
    if not Menu.settings.visuals.watermark.order_list then return end
    local items = {}
    for i = 1, #state.order do
        local id    = state.order[i]
        local label = ORDER_LABEL[id]
        local on    = get_block_enabled(id)
        items[i]    = (on and "● " or "○ ") .. label
    end
    Menu.settings.visuals.watermark.order_list:update(items)
end

local function move_selected(delta)
    if not Menu.settings.visuals.watermark.order_list then return end
    local idx = Menu.settings.visuals.watermark.order_list:get()
    if idx == nil then return end
    local pos = idx + 1
    local block_id = state.order[pos]
    if not block_id then return end
    local new_pos = pos + delta
    if new_pos < 1 or new_pos > #state.order then return end
    table_swap(state.order, pos, new_pos)
    sync_order_listbox()
    Menu.settings.visuals.watermark.order_list:set(new_pos - 1)
end



Menu.information = {};
Menu.information.name = groups.aa.fake_lag:label(string.format("Welcome back, \11%s\r!", U.username));
Menu.information.build = groups.aa.fake_lag:label(string.format("You're using \11%s\r build #%s of %s \11%s\r.", U.build,U.build_num, U.name,U.version));
Menu.information.space = groups.aa.fake_lag:label("\nspace");
Menu.information.log_5 = groups.aa.fake_lag:label("\aD4A9FFFFCustom features");
Menu.information.debug = groups.aa.fake_lag:checkbox("\aD4A9FFFFDebug panel");;
Menu.information.disableblur = groups.aa.fake_lag:checkbox("\7D4A9FFFFDisable blur \12<gray>(to fix crashes)");
Menu.information.disableblur:set(true)
S.traverse(Menu.information, function(L)
    L:depend({Menu.toggle, true}, {Menu.tabs.main, "Settings"});
end);

Menu.statistics = {};
Menu.statistics.label = groups.aa.other:label("\11\238\139\188\r  Statistics");
Menu.statistics.separation = groups.aa.other:label("\12<gray>\12<seperation>");
Menu.statistics.hours_played = groups.aa.other:label("\12<gray>Hours played \226\151\166: \110");
Menu.statistics.times_loaded = groups.aa.other:label("\12<gray>Times loaded \226\151\166: \110");
Menu.statistics.enemies_killed = groups.aa.other:label("\12<gray>Enemies killed \226\151\166: \110");
Menu.statistics.hitrate = groups.aa.other:label("\12<gray>Hitrate \226\151\166: \110%");
Menu.statistics.gingerbread_earned = groups.aa.other:label("\12<gray>\100\105\115\99\111\114\100\58\32\64\102\117\110\116\97\122\122\121");
S.traverse(Menu.statistics, function(L)
    L:depend({Menu.toggle, true}, {Menu.tabs.main, "Settings"});
end);

Menu.settings = {
        visuals = {
        watermark = {},
        speclist = {},
        keybinds = {},
    }
};
Menu.settings.r_space = groups.aa.angles:label("\nspace");
Menu.settings.r_label = groups.aa.angles:label("\11\238\132\174\r  Ragebot");
Menu.settings.r_separation = groups.aa.angles:label("\12<gray>\12<seperation>");
Menu.settings.resolver = groups.aa.angles:checkbox(
    "\11\226\128\167\226\130\138\203\154 \226\152\129\239\184\143\226\139\133\226\153\161\240\147\130\131 \224\163\170 \214\180\214\182\214\184\226\152\190.\r  Resolver");
Menu.settings.predict = groups.aa.angles:checkbox("CVar manipulation");
Menu.settings.aimbot_helper = groups.aa.angles:checkbox(S.macros.gray .. "Aimbot helper");

Menu.settings.aimbot_helper_label = groups.aa.angles:label("Will \11prefer/force\r body aim and");
Menu.settings.aimbot_helper_label_2 = groups.aa.angles:label("safe points if needed automatically.");
Menu.settings.aimbot_helper_label:depend(Menu.settings.aimbot_helper);
Menu.settings.aimbot_helper_label_2:depend(Menu.settings.aimbot_helper);
Menu.settings.jump_scout = groups.aa.angles:checkbox("Jump scout helper");
Menu.settings.jump_scout_label = groups.aa.angles:label("Will adjust your \11hit chance,");
Menu.settings.jump_scout_label_2 = groups.aa.angles:label("\11auto stop\r & etc automatically.");
Menu.settings.jump_scout_label:depend(Menu.settings.jump_scout);
Menu.settings.jump_scout_label_2:depend(Menu.settings.jump_scout);
Menu.settings.ideal_tick = groups.aa.angles:checkbox("Ideal tick", 0);
Menu.settings.ideal_tick_settings = groups.aa.angles:multiselect("\nIdeal tick settings",
    {"Double tap", "Freestanding", "Auto peek"});
Menu.settings.ideal_tick_settings:depend(Menu.settings.ideal_tick);
Menu.settings.swap_on_quick_peek = groups.aa.angles:checkbox("Swap to knife with auto peek  [SSG-08]");
Menu.settings.unsafe_recharge = groups.aa.angles:checkbox("\12<exploit>Unsafe exploit recharge");
Menu.settings.duck_peek_assist_fix = groups.aa.angles:checkbox("Crouch with duck peek assist");
Menu.settings.auto_exploit = groups.aa.angles:checkbox("Auto exploit switch");
Menu.settings.auto_exploit_states = groups.aa.angles:multiselect("\nAuto exploit states",
    {"Standing", "Walking", "Crouching", "Sneaking"});
Menu.settings.auto_exploit_avoid = groups.aa.angles:multiselect("Auto exploit avoid", {"Pistols", "Desert eagle",
                                                                               "Auto snipers", "Desert eagle + Crouch"});
S.traverse({Menu.settings.auto_exploit_states, Menu.settings.auto_exploit_avoid}, function(L)
    L:depend(Menu.settings.auto_exploit);
end);
Menu.settings.auto_teleport = groups.aa.angles:checkbox("Auto break lag compensation", 0);
Menu.settings.auto_teleport_options = groups.aa.angles:multiselect("\nAuto break lag compensation options", {"Only in air", "Force recharge"});
Menu.settings.auto_teleport_delay = groups.aa.angles:slider("\nForce recharge delay ", 100, 1000, 400, true, "ms");
Menu.settings.auto_teleport_force_only = groups.aa.angles:checkbox("Don't break if vulnerable");
Menu.settings.auto_teleport_options:depend(Menu.settings.auto_teleport);
Menu.settings.auto_teleport_delay:depend(Menu.settings.auto_teleport, {Menu.settings.auto_teleport_options, "Force recharge"});
Menu.settings.auto_teleport_force_only:depend(Menu.settings.auto_teleport, {Menu.settings.auto_teleport_options, "Force recharge"});
Menu.settings.peek_bot = groups.aa.angles:checkbox("Peek bot", 0);
Menu.settings.peek_bot_debug = groups.aa.angles:checkbox("\aD4A9FFFFPeek bot debug");
Menu.settings.peek_bot_debug:depend(Menu.settings.peek_bot);
Menu.settings.dormant = groups.aa.angles:checkbox(S.macros.gray .. "Break local player dormancy");
Menu.settings.dormant_mode = groups.aa.angles:combobox("\nBreak local player dormancy mode", {"Ghost", "Random"});
Menu.settings.dormant_mode:depend(Menu.settings.dormant);

Menu.settings.v_space = groups.aa.angles:label("\nspace");
Menu.settings.v_label = groups.aa.angles:label("\11\226\139\134\226\152\129\239\184\142\226\139\134\r  Visuals");
Menu.settings.v_separation = groups.aa.angles:label("\12<gray>\12<seperation>");
Menu.settings.accent_label = groups.aa.angles:label("Accent color");
Menu.settings.visuals.accent = groups.aa.angles:color_picker("Accent color", 159, 166, 205);
Menu.settings.force_watermark = groups.aa.angles:checkbox("Force branded watermark");




Menu.settings.crosshair = groups.aa.angles:checkbox("Crosshair indicators");
Menu.settings.arrow = groups.aa.angles:checkbox("Angle arrow");
Menu.settings.scope = groups.aa.angles:checkbox("Custom scope");
Menu.settings.scope_color = groups.aa.angles:color_picker("\nScope color", 159, 166, 205);
Menu.settings.scope_color_2 = groups.aa.angles:color_picker("\nScope color 2", 159, 166, 205, 0);
Menu.settings.scope_exclude = groups.aa.angles:multiselect("\nScope exclude", {"Top", "Bottom", "Left", "Right"});
Menu.settings.scope_gap = groups.aa.angles:slider("\nScope gap", 0, 100, 10, true, "\226\134\185");
Menu.settings.scope_size = groups.aa.angles:slider("\nScope size", 5, 400, 30, true, "%");
S.traverse({Menu.settings.scope_color, Menu.settings.scope_color_2, Menu.settings.scope_exclude, Menu.settings.scope_gap,
            Menu.settings.scope_size}, function(L)
    L:depend(Menu.settings.scope);
end);
Menu.settings.zoom = groups.aa.angles:checkbox("Animated zoom");
Menu.settings.zoom_fov = groups.aa.angles:slider("\nZoom FOV", 1, 100, 10, true, "%");
Menu.settings.zoom_speed = groups.aa.angles:slider("\nZoom speed", 1, 45, 10, true, "ms");
S.traverse({Menu.settings.zoom_fov, Menu.settings.zoom_speed}, function(L)
    L:depend(Menu.settings.zoom);
end);
local visuals = Menu.settings.visuals
local group = groups.aa.angles
visuals.damage = groups.aa.angles:checkbox("Damage indicator");
visuals.watermark.enabled = groups.aa.angles:checkbox("Watermark");
visuals.watermark.position = group:combobox(
    "Position",
    {"Top right", "Bottom center"}
)
visuals.watermark.position:depend(visuals.watermark.enabled)
visuals.watermark.show_setup = groups.aa.angles:checkbox("Show setup watermark");
visuals.watermark.avatar = group:checkbox("Show avatar")
visuals.watermark.avatar:set(true)

    local order_labels = {}
    for i = 1, #state.order do
        order_labels[i] = "● " .. ORDER_LABEL[state.order[i]]
    end
    visuals.watermark.order_list = group:listbox("Element", order_labels)

    visuals.watermark.button1 = group:button("Move up",   function() move_selected(-1) end)
    visuals.watermark.button2 = group:button("Move down", function() move_selected( 1) end)
    


    local function make_show(name)
        local e = group:checkbox("Show " .. name)
        e:set(true)
        e:set_visible(false)
        return e
    end

    visuals.watermark.username     = make_show("Username")
    visuals.watermark.clock        = make_show("Clock")
    visuals.watermark.fps          = make_show("FPS")
    visuals.watermark.ping         = make_show("Ping")
    visuals.watermark.var          = make_show("Var")
    visuals.watermark.var_bad_req  = group:checkbox("Only when bad")
    visuals.watermark.var_bad_req:set(false)
    visuals.watermark.var_bad_req:set_visible(false)
    visuals.watermark.branding_mode =group:combobox("Mode",{"Full", "Name only"})
    visuals.watermark.branding_mode:set_visible(false)
    visuals.watermark.loss         = make_show("Loss")
    visuals.watermark.timeout      = make_show("Timeout")

    visuals.watermark.show_ping_spike = group:checkbox("Show ping spike")
    visuals.watermark.show_ping_spike:set_enabled(false)
    visuals.watermark.show_ping_spike:set_visible(false)

    local elem_settings = {
        branding = {visuals.watermark.branding_mode},
        username = {visuals.watermark.username},
        clock    = {visuals.watermark.clock},
        fps      = {visuals.watermark.fps},
        ping     = {visuals.watermark.ping, visuals.watermark.show_ping_spike},
        var      = {visuals.watermark.var, visuals.watermark.var_bad_req},
        loss     = {visuals.watermark.loss},
        timeout  = {visuals.watermark.timeout},
    }

    local function refresh_settings_visibility(force)
        for _, settings in pairs(elem_settings) do
            for _, e in ipairs(settings) do
                e:set_visible(false)
            end
        end
        if not visuals.watermark.show_setup:get() then return end
        if not visuals.watermark.enabled:get() then return end
        if not Menu.toggle:get() then return end
        if not Menu.tabs.main:get() == "Settings" then return end
        local idx = force or visuals.watermark.order_list:get()
        if idx ~= nil and type(idx) == "number" then
            local block_id = state.order[idx + 1]
            if block_id and elem_settings[block_id] then
                for _, e in ipairs(elem_settings[block_id]) do
                    e:set_visible(true)
                end
            end
        end
    end

    visuals.watermark.order_list:set_callback(function()
        refresh_settings_visibility()
    end, true)
    visuals.watermark.show_setup:depend(visuals.watermark.enabled)
    visuals.watermark.order_list:depend(visuals.watermark.enabled, visuals.watermark.show_setup)
    visuals.watermark.button1:depend(visuals.watermark.enabled, visuals.watermark.show_setup)
    visuals.watermark.button2:depend(visuals.watermark.enabled, visuals.watermark.show_setup)
    visuals.watermark.avatar:depend(visuals.watermark.enabled, visuals.watermark.show_setup)
    visuals.watermark.show_setup:set_callback(refresh_settings_visibility)
    for _, settings in pairs(elem_settings) do
        for _, e in ipairs(settings) do
            e:depend(visuals.watermark.enabled, visuals.watermark.show_setup)
        end
    end
    

    local show_elems = {
        visuals.watermark.username,
        visuals.watermark.clock,
        visuals.watermark.fps,
        visuals.watermark.ping,
        visuals.watermark.var,
        visuals.watermark.var_bad_req,
        visuals.watermark.loss,
        visuals.watermark.timeout,
        visuals.watermark.show_ping_spike,
    }

    for _, e in ipairs(show_elems) do
        e:set_callback(function()
            sync_order_listbox()
        end)
    end

    refresh_settings_visibility(0)
visuals.watermark.seperator = group:label("\n123")
visuals.watermark.seperator:depend(visuals.watermark.enabled, visuals.watermark.show_setup)

visuals.keybinds.enabled = group:checkbox("Keybind list");
visuals.keybinds.toggle_theme = group:checkbox("Toggle theme");
local kb_default_x = math.floor(select(1, client.screen_size()) * 0.5 + 250)
local kb_default_y = 200
local kb_drag = drag_system:register("keybinds", group, { x = kb_default_x, y = kb_default_y }, { x = 160, y = 60 }, {
        prefix = "KB",
        x_min = 0,
        y_min = 0,
        x_max = select(1, client.screen_size()),
        y_max = select(2, client.screen_size()),
    })
    visuals.keybinds.pos_x = kb_drag.pos_x
    visuals.keybinds.pos_y = kb_drag.pos_y

S.traverse(visuals, function(L)
    L:depend({Menu.toggle, true}, {Menu.tabs.main, "Settings"});
end);

visuals.keybinds.toggle_theme:depend(visuals.keybinds.enabled);

visuals.speclist.enabled = groups.aa.angles:checkbox("Spectator list");
visuals.speclist.header = group:checkbox("Header")
visuals.speclist.header:depend(visuals.speclist.enabled);

local default_x = SPEC.right_gap
local default_y = math.floor(math.max(0, select(2, client.screen_size()) * 0.5 - (SPEC.header_h + SPEC.gap_y + SPEC.row_h * 2) * 0.5 - 10))
local drag_item = drag_system:register("spec_list", group, { x = default_x, y = default_y }, { x = SPEC.header_compact_w, y = SPEC.header_h }, {
    prefix = "Spec",
    x_min = 0,
    y_min = 0,
    x_max = select(1, client.screen_size()),
    y_max = select(2, client.screen_size()),
    anchor_right = true,
})
    visuals.speclist.pos_x = drag_item.pos_x
    visuals.speclist.pos_y = drag_item.pos_y

Menu.settings.panel = groups.aa.angles:checkbox(S.macros.gray .. "Multi panel");
Menu.settings.logger = groups.aa.angles:checkbox("Event logger");
visuals.logger_on_screen = groups.aa.angles:checkbox("On screen");
visuals.logger_on_screen:depend(Menu.settings.logger);
visuals.side = groups.aa.angles:checkbox("Side indicators");
visuals.markers = groups.aa.angles:checkbox("Markers");
visuals.marker_list = groups.aa.angles:multiselect("\nMarker list", {"On miss", "Damage"});
visuals.marker_list:depend(visuals.markers);

 drag_system:register(
     "damage_indicator", group, {
         x = select(1, client.screen_size()) / 2 + 10,
         y = select(2, client.screen_size()) / 2 + 10
     })
 drag_system:register(
     "screen_logs", group, {
         x = select(1, client.screen_size()) / 2 - 160/2, 
         y = select(2, client.screen_size()) / 1.35
     })


Menu.settings.m_space = groups.aa.angles:label("\nspace");
Menu.settings.m_label = groups.aa.angles:label("\11\238\132\149\r  Miscellaneous");
Menu.settings.m_separation = groups.aa.angles:label("\12<gray>\12<seperation>");
Menu.settings.ratio = groups.aa.angles:checkbox("Aspect ratio");
Menu.settings.ratio_width = groups.aa.angles:slider("\nWidth", 1, 195, 100, true, "%");
Menu.settings.ratio_width:depend(Menu.settings.ratio);
Menu.settings.viewmodel = groups.aa.angles:checkbox("Viewmodel");
Menu.settings.viewmodel_in_scope = groups.aa.angles:checkbox("In scope");
Menu.settings.viewmodel_center = groups.aa.angles:checkbox("Center in scope");
Menu.settings.viewmodel_center:depend(Menu.settings.viewmodel, Menu.settings.viewmodel_in_scope);
Menu.settings.viewmodel_fov = groups.aa.angles:slider("\nFOV", 0, 120, 68, true, "*");
Menu.settings.viewmodel_x = groups.aa.angles:slider("\nX", -100.0, 100, 0, true, "u", 0.1);
Menu.settings.viewmodel_y = groups.aa.angles:slider("\nY", -100.0, 100, 0, true, "u", 0.1);
Menu.settings.viewmodel_z = groups.aa.angles:slider("\nZ", -100.0, 100, 0, true, "u", 0.1);
S.traverse({Menu.settings.viewmodel_in_scope, Menu.settings.viewmodel_fov, Menu.settings.viewmodel_x, Menu.settings.viewmodel_y,
            Menu.settings.viewmodel_z}, function(L)
    L:depend(Menu.settings.viewmodel);
end);
Menu.settings.animation_breaker = groups.aa.angles:checkbox("Animation breaker");
Menu.settings.anim_in_moving = groups.aa.angles:combobox("Moving", {"Off", "Static", "Jitter"});
Menu.settings.anim_in_air = groups.aa.angles:combobox("In air", {"Off", "Static", "Jitter", "Walking"});
Menu.settings.anim_etc = groups.aa.angles:multiselect("Add-ons", {"Zero pitch on land", "Disable balance adjustment",
                                                          "Smooth yaw angles", "Smooth player animation"});
S.traverse({Menu.settings.anim_in_moving, Menu.settings.anim_in_air, Menu.settings.anim_etc}, function(L)
    L:depend(Menu.settings.animation_breaker);
end);
Menu.settings.edge_stop = groups.aa.angles:checkbox(S.macros.gray .. "Stop on edge", 0);
Menu.settings.optimization = groups.aa.angles:checkbox("Optimization");
Menu.settings.optimization_list = groups.aa.angles:multiselect('\nCustom Optimization',
    {'Fix chams color', 'Disable dynamic lighting', 'Disable dynamic shadows', 'Disable Shadows',
     'Disable first-person tracers', 'Disable ragdolls', 'Disable eye gloss', 'Disable eye movement',
     'Disable muzzle flash light', 'Enable low CPU audio', 'Disable bloom', 'Disable particles',
     'Reduce breakable objects', 'Disable 3d sky', 'Disable fog', 'Disable blood', 'Disable decals'})
Menu.settings.optimization_list:depend(Menu.settings.optimization)
Menu.settings.trash_talk = groups.aa.angles:checkbox("Trash talk");
Menu.settings.trash_talk_mode = groups.aa.angles:combobox("\nTrash talk mode", {"Emberlash", "Aggressive"});
Menu.settings.trash_talk_type = groups.aa.angles:multiselect("\nTrash talk type", {"Kill", "Death", "Revenge"});
S.traverse({Menu.settings.trash_talk_mode, Menu.settings.trash_talk_type}, function(L)
    L:depend(Menu.settings.trash_talk);
end);
Menu.settings.clan_tag = groups.aa.angles:checkbox("Clan tag spammer");
S.traverse(Menu.settings, function(L)
    L:depend({Menu.toggle, true}, {Menu.tabs.main, "Settings"});
end);

Menu.settings.buybot = groups.aa.angles:checkbox("Buybot");
Menu.settings.buybot_list = groups.aa.angles:multiselect("\nBuybot list", {"16K$ REQUIRED","--PRIMARY--","AWP", "SSG08", "AUTO", 
                                                                           "--SECONDARY--", "DEAGLE","TEC8/57/CZ", "DUALS", "P250",
                                                                           "--OTHER--", "HE", "INC", "SMOKE", "TASER", "ARMOR", "DEFUSER"});
Menu.settings.buybot_list:depend(Menu.settings.buybot, {Menu.toggle, true}, {Menu.tabs.main, "Settings"})
Menu.settings.buybot:depend({Menu.toggle, true}, {Menu.tabs.main, "Settings"})
local primary = {
    ["AWP"] = true,
    ["SSG08"] = true,
    ["AUTO"] = true,
}

local secondary = {
    ["DEAGLE"] = true,
    ["TEC8/57/CZ"] = true,
    ["DUALS"] = true,
    ["P250"] = true,
}

local blocked = {
    ["--PRIMARY--"] = true,
    ["--SECONDARY--"] = true,
    [ "--OTHER--"] = true
}

local last = {}

Menu.settings.buybot_list:set_callback(function(self)
    local current = self:get()
    local filtered = {}
    local changed = false

    for _, item in ipairs(current) do
        if not blocked[item] then
            table.insert(filtered, item)
        else
            changed = true
        end
    end

    if changed then
        self:set(filtered)
        current = filtered
    end
    local added

    for _, item in ipairs(current) do
        local found = false

        for _, old in ipairs(last) do
            if old == item then
                found = true
                break
            end
        end

        if not found then
            added = item
            break
        end
    end

    if not added then
        last = current
        return
    end

    local result = {}

    if primary[added] then
        for _, item in ipairs(current) do
            if not primary[item] then
                table.insert(result, item)
            end
        end

        table.insert(result, added)
    elseif secondary[added] then
        for _, item in ipairs(current) do
            if not secondary[item] then
                table.insert(result, item)
            end
        end

        table.insert(result, added)

    else
        result = current
    end

    self:set(result)
    last = result
end)


Menu.aa.addons.anti_backstab = groups.aa.fake_lag:checkbox("Anti-backstab");
Menu.aa.addons.legit_aa = groups.aa.fake_lag:checkbox("Anti-aim on use");
Menu.aa.addons.fast_ladder = groups.aa.fake_lag:checkbox("Fast ladder");
Menu.aa.addons.defensive_legs = groups.aa.fake_lag:checkbox("\12<exploit>Leg movement exploit");
Menu.aa.addons.defensive_peek = groups.aa.fake_lag:checkbox("\12<exploit>Defensive on peek fix");
Menu.aa.addons.shit_aa = groups.aa.fake_lag:multiselect("PAKETA AA on", {"Warm-up", "If enemies dead"});

Menu.aa.angles.space = groups.aa.angles:label("\nspace");
Menu.aa.angles.type = groups.aa.angles:combobox("Anti-aim type", {"Default", "Experimental","Builder", "Cheat-based builder", "Side-based builder"});
Menu.aa.angles.preset_info._1 = groups.aa.angles:label("\aFFFFFFFFYou are using a \a3BBED1FFpreset,")
Menu.aa.angles.preset_info._2 = groups.aa.angles:label(" \aFFFFFFFFa \aC48874FFbuilder, \aFFFFFFFFand the \aC48874FFentire custom staff")
Menu.aa.angles.preset_info._3 = groups.aa.angles:label(" \aCC4821FFis unavailable.")
Menu.aa.angles.preset_info._4 = groups.aa.angles:label("\a3BBED1FFSwitch\aFFFFFFFF the mode to \a8DE0AEFFany builder")
Menu.aa.angles.preset_info._5 = groups.aa.angles:label(" \aFFFFFFFFfor a \aE4ED37ffbetter experience.")

local function get_active_runtime_cond(mode, cond)
    if mode == "Builder" then
        return builder_runtime.base_builder[cond]
    elseif mode == "Cheat-based builder" then
        local cheat = helper.strip_color(Menu.aa.builder.current_cheat:get())
        if type(cheat) ~= "string" then cheat = "global" end
        return builder_runtime.cheat_builder[cheat] and builder_runtime.cheat_builder[cheat][cond]
    elseif mode == "Side-based builder" then
        local side = helper.strip_color(Menu.aa.builder.side_select:get())
        if type(side) ~= "string" then side = "Counter-Terrorists" end
        local sb = builder_runtime.side_builder[side]
        local result = sb and sb[cond]
        return result
    end
end
local function get_active_override(mode)
    if mode == "Builder" then
        return true  
    elseif mode == "Cheat-based builder" then
        local cheat = helper.strip_color(Menu.aa.builder.current_cheat:get())
        if type(cheat) ~= "string" then cheat = "global" end
        if cheat == "global" then return true end
        return builder_runtime.cheat_builder[cheat] and builder_runtime.cheat_builder[cheat].override == true
    elseif mode == "Side-based builder" then
        return true
    end
    return false
end


Menu.aa.builder.condition_select = groups.aa.angles:combobox("Condition", conditions_list_menu)

Menu.aa.builder.current_cheat = groups.aa.angles:combobox("Cheat type", cheats_display)
Menu.aa.builder.side_select = groups.aa.angles:combobox("Side", {"\a2787F5FFCounter-Terrorists", "\aF5A327FFTerrorists"})
Menu.aa.builder.send_to_opposite = groups.aa.other:button("Send to opposite side", function()
    local side = helper.strip_color(Menu.aa.builder.side_select:get())
    if type(side) ~= "string" then return end
    local opposite = (side == "Counter-Terrorists") and "Terrorists" or "Counter-Terrorists"
    local cond = Menu.aa.builder.condition_select:get()
    if type(cond) ~= "string" then cond = "Standing" end
    local src = builder_runtime.side_builder[side] and builder_runtime.side_builder[side][cond]
    if src then
        builder_runtime.side_builder[opposite][cond] = deep_copy(src)
        builder_dirty = true
        client.color_log(159, 166, 205, string.format("emberlash > Copied %s/%s → %s/%s", side, cond, opposite, cond))
    end
end)
Menu.aa.builder.cheat_select = groups.aa.other:multiselect("Send anti-aim to builder", cheats_display)
Menu.aa.builder.send_btn = groups.aa.other:button("Send", function()
    local selected = Menu.aa.builder.cheat_select:get()
    local current_cheat = helper.strip_color(Menu.aa.builder.current_cheat:get())
    local current_cond = Menu.aa.builder.condition_select:get()
    local settings = builder_runtime[current_cheat][current_cond]
    for _, cheat in ipairs(selected) do
        if cheat ~= current_cheat and cheat ~= "global" then
            builder_runtime[cheat][current_cond] = deep_copy(settings)
        end
    end
    builder_dirty = true
    client.color_log(159, 166, 205, "emberlash > Condition copied.")
    update_builder_ui()
end)

local builder_clipboard = nil
Menu.aa.builder.copy_btn = groups.aa.other:button("Copy condition", function()
    local mode = Menu.aa.angles.type:get()
    local cond = Menu.aa.builder.condition_select:get()
    if type(cond) ~= "string" then cond = "Standing" end
    local src = get_active_runtime_cond(mode, cond)
    if src then
        builder_clipboard = { cond = cond, mode = mode, data = deep_copy(src) }
        client.color_log(159, 166, 205, string.format("emberlash > Copied [%s] %s", mode, cond))
    end
end)
Menu.aa.builder.paste_btn = groups.aa.other:button("Paste condition", function()
    if not builder_clipboard then
        client.color_log(255, 100, 100, "emberlash > Clipboard empty.")
        return
    end
    local mode = Menu.aa.angles.type:get()
    local cond = Menu.aa.builder.condition_select:get()
    if type(cond) ~= "string" then cond = "Standing" end
    local dst = get_active_runtime_cond(mode, cond)
    if dst then
        for k, v in pairs(builder_clipboard.data) do dst[k] = v end
        builder_dirty = true
        update_builder_ui()
        client.color_log(159, 166, 205, string.format("emberlash > Pasted [%s/%s] → [%s/%s]",
            builder_clipboard.mode, builder_clipboard.cond, mode, cond))
    end
end)

local builder_combobox_options = {
    yaw_base = {"enemy direction", "local view"},
    delay_mode = {"static", "random", "fluctuate", "flick", "ways", "wave", "pulse", "adaptive", "chaotic"},
    body_yaw = {"jitter", "static", "disabled"}
}

Menu.aa.builder.override = groups.aa.angles:checkbox("Override default anti-aim")
Menu.aa.builder.yaw_base = groups.aa.angles:combobox("Yaw base", {"enemy direction", "local view"})
Menu.aa.builder.yaw_offset = groups.aa.angles:slider("Yaw offset", -180, 180, 0, true, "°")
Menu.aa.builder.left_right_enabled = groups.aa.angles:checkbox("Add left & right offset")
Menu.aa.builder.left_offset = groups.aa.angles:slider("\nLeft offset", -180, 180, 0, true, "l°")
Menu.aa.builder.right_offset = groups.aa.angles:slider("\nRight offset", -180, 180, 0, true, "r°")
Menu.aa.builder.randomize = groups.aa.angles:slider("Randomize", 0, 90, 0, true, "°")
Menu.aa.builder.delay_mode_left = groups.aa.angles:combobox("Delay mode left", builder_combobox_options.delay_mode)
Menu.aa.builder.left_delay_value = groups.aa.angles:slider("\nLeft delay value", 2, 14, 2, true, "t")
Menu.aa.builder.left_delay_min = groups.aa.angles:slider("\nLeft delay min", 2, 14, 2, true, "tn")
Menu.aa.builder.left_delay_max = groups.aa.angles:slider("\nLeft delay max", 2, 14, 6, true, "tx")
Menu.aa.builder.delay_mode_right = groups.aa.angles:combobox("Delay mode right", builder_combobox_options.delay_mode)
Menu.aa.builder.right_delay_value = groups.aa.angles:slider("\nRight delay value", 2, 14, 2, true, "t")
Menu.aa.builder.right_delay_min = groups.aa.angles:slider("\nRight delay min", 2, 14, 2, true, "tn")
Menu.aa.builder.right_delay_max = groups.aa.angles:slider("\nRight delay max", 2, 14, 6, true, "tx")
Menu.aa.builder.freeze = groups.aa.angles:checkbox("Freeze")
Menu.aa.builder.freeze_chance = groups.aa.angles:slider("Freeze chance", 0, 100, 0, true, "%")
Menu.aa.builder.freeze_time = groups.aa.angles:slider("Freeze time", 0, 100, 0, true, "t")
Menu.aa.builder.freeze_cooldown = groups.aa.angles:slider("Freeze cooldown", 1, 1000, 1, true, "t")
Menu.aa.builder.body_yaw = groups.aa.angles:combobox("Body yaw", {"jitter", "static", "disabled"})
Menu.aa.builder.body_yaw_side = groups.aa.angles:slider("Body yaw side", -1, 1, 0, true, "", 1, {[-1] = "    ",[0]  = "  ",  [1]  = "   "})


Menu.aa.angles.defensive = groups.aa.fake_lag:multiselect("Force defensive anti-aim", {"Safe head", "Manual angles", "Freestanding", "Weapon events"});
Menu.aa.angles.unsafe = groups.aa.fake_lag:checkbox("Unsafe states");
Menu.aa.angles.us_states = groups.aa.fake_lag:multiselect("\nUnsafe defensive anti-aim", {"Standing", "Manual angles", "Freestanding"});
Menu.aa.angles.us_states:depend(Menu.aa.angles.unsafe);

Menu.aa.hotkeys.space =           groups.aa.other:label("\nspace");
Menu.aa.hotkeys.static =          groups.aa.other:checkbox("Static manual angles");
Menu.aa.hotkeys.left =            groups.aa.other:hotkey("Manual left");
Menu.aa.hotkeys.right =           groups.aa.other:hotkey("Manual right");
Menu.aa.hotkeys.forward   =       groups.aa.other:hotkey("Manual forward");
Menu.aa.hotkeys.reset =           groups.aa.other:hotkey("Manual reset");
Menu.aa.hotkeys.edge_yaw =        groups.aa.other:hotkey("Edge yaw");
Menu.aa.hotkeys.freestanding =    groups.aa.other:hotkey("Freestanding");
Menu.aa.hotkeys.disablers =       groups.aa.other:multiselect("Freestanding state disablers", unpack({table.unpack(conditions_list_menu, 1, #conditions_list_menu - 2)}));

Menu.aa.builder.force_defensive   = groups.aa.angles:checkbox("Force defensive")
Menu.aa.builder.custom_defensive  = groups.aa.angles:checkbox("Custom defensive")

Menu.aa.builder.def_pitch_mode    = groups.aa.angles:combobox("Pitch mode",     pitch_modes)
Menu.aa.builder.def_pitch_speed   = groups.aa.angles:slider("speed",       0, 500, 100, true, "", 0.01)
Menu.aa.builder.def_pitch_angle   = groups.aa.angles:slider("angle",       -89, 89, 45, true, "°")
Menu.aa.builder.def_pitch_max     = groups.aa.angles:slider("max angle",   0, 89, 89, true, "°")
Menu.aa.builder.def_pitch_int     = groups.aa.angles:slider("intensity",   0, 500, 100, true, "", 0.01)

Menu.aa.builder.def_yaw_mode      = groups.aa.angles:combobox("Yaw mode",       yaw_modes)
Menu.aa.builder.def_yaw_speed     = groups.aa.angles:slider("speed",         0, 500, 100, true, "", 0.01)
Menu.aa.builder.def_yaw_angle     = groups.aa.angles:slider("angle",         -180, 180, 90, true, "°")
Menu.aa.builder.def_yaw_max       = groups.aa.angles:slider("max angle",     0, 180, 180, true, "°")
Menu.aa.builder.def_yaw_int       = groups.aa.angles:slider("intensity",     0, 500, 100, true, "", 0.01)

Menu.aa.builder.def_body_yaw_type = groups.aa.angles:combobox("\nBody yaw",       {"Jitter", "Static", "Disabled"})
Menu.aa.builder.def_body_yaw_off  = groups.aa.angles:slider("Body yaw offset",   -1, 1, 0, true, "", 1, {[-1]="    ",[0]="  ",[1]="   "})

local builder_elements = {
    Menu.aa.builder.yaw_base, 
    Menu.aa.builder.yaw_offset,
    Menu.aa.builder.left_right_enabled,
    Menu.aa.builder.left_offset, Menu.aa.builder.right_offset, Menu.aa.builder.randomize,
    Menu.aa.builder.delay_mode_left,Menu.aa.builder.delay_mode_right,
    Menu.aa.builder.left_delay_min, Menu.aa.builder.left_delay_max, Menu.aa.builder.left_delay_value,
    Menu.aa.builder.right_delay_min, Menu.aa.builder.right_delay_max, Menu.aa.builder.right_delay_value,
    Menu.aa.builder.freeze, Menu.aa.builder.freeze_chance, Menu.aa.builder.freeze_time, Menu.aa.builder.freeze_cooldown,
    Menu.aa.builder.body_yaw, Menu.aa.builder.body_yaw_side,

    Menu.aa.builder.force_defensive,
    Menu.aa.builder.custom_defensive,
    Menu.aa.builder.def_pitch_mode, Menu.aa.builder.def_pitch_speed,
    Menu.aa.builder.def_pitch_angle, Menu.aa.builder.def_pitch_max, Menu.aa.builder.def_pitch_int,
    Menu.aa.builder.def_yaw_mode, Menu.aa.builder.def_yaw_speed,
    Menu.aa.builder.def_yaw_angle, Menu.aa.builder.def_yaw_max, Menu.aa.builder.def_yaw_int,
    Menu.aa.builder.def_body_yaw_type, Menu.aa.builder.def_body_yaw_off,
}

local def_custom_elems = {
    Menu.aa.builder.def_pitch_mode, Menu.aa.builder.def_pitch_speed,
    Menu.aa.builder.def_pitch_angle, Menu.aa.builder.def_pitch_max, Menu.aa.builder.def_pitch_int,
    Menu.aa.builder.def_yaw_mode, Menu.aa.builder.def_yaw_speed,
    Menu.aa.builder.def_yaw_angle, Menu.aa.builder.def_yaw_max, Menu.aa.builder.def_yaw_int,
    Menu.aa.builder.def_body_yaw_type, Menu.aa.builder.def_body_yaw_off,
}
for _, e in ipairs(def_custom_elems) do
    e:depend(Menu.aa.builder.custom_defensive)
end

Menu.aa.builder.def_body_yaw_off:depend(Menu.aa.builder.custom_defensive, {Menu.aa.builder.def_body_yaw_type, "disabled", true})

local function dep_aa(t, ...)
    local extra = {...}
    S.traverse(t, function(elem)
        elem:depend({Menu.toggle, true}, {Menu.tabs.main, "Anti-aimbot angles"}, table.unpack(extra))
    end)
end


dep_aa(Menu.aa.addons)
dep_aa(Menu.aa.angles)
dep_aa(Menu.aa.builder, {
    Menu.aa.angles.type,
    function()
        return ctx:resolve_aa_mode(0)
    end
})
dep_aa(Menu.aa.hotkeys)
dep_aa(Menu.aa.angles.preset_info,{
    Menu.aa.angles.type,
    function()
        return not ctx:resolve_aa_mode(0)
    end
})

dep_aa(Menu.aa.builder.cheat_select, {
    Menu.aa.angles.type,
    function()
        return ctx:resolve_aa_mode(2) == "Cheat-based builder"
    end
})
dep_aa(Menu.aa.builder.current_cheat, {
    Menu.aa.angles.type,
    function()
        return ctx:resolve_aa_mode(2) == "Cheat-based builder"
    end
})

dep_aa(Menu.aa.builder.send_btn, {
    Menu.aa.angles.type, 
    function()
        return ctx:resolve_aa_mode(2) == "Cheat-based builder"
    end
})

dep_aa(Menu.aa.builder.send_to_opposite, {
    Menu.aa.angles.type, 
    function ()
        return ctx:resolve_aa_mode(2) == "Side-based builder"
    end
})

dep_aa(Menu.aa.builder.side_select, {
    Menu.aa.angles.type, 
    function()
        return ctx:resolve_aa_mode(2) == "Side-based builder"
    end
})



local builder_ui_updating = false

function update_builder_ui()
    builder_ui_updating = true
    local mode = ctx:resolve_aa_mode(2)
    local cond = Menu.aa.builder.condition_select:get()
    if type(cond) ~= "string" then cond = "Standing" end
    

    local is_overridden = get_active_override(mode)
    if mode == "Builder" then
        Menu.aa.builder.override:set_visible(false)
    elseif mode == "Cheat-based builder" then
        local cheat = helper.strip_color(Menu.aa.builder.current_cheat:get())
        if type(cheat) ~= "string" then cheat = "global" end
        local is_global = (cheat == "global")
        Menu.aa.builder.override:set_visible(true)
        Menu.aa.builder.override:set_visible(not is_global)
        Menu.aa.builder.override:set(
            not is_global and
            builder_runtime.cheat_builder[cheat] ~= nil and
            builder_runtime.cheat_builder[cheat].override == true
        )
    elseif mode == "Side-based builder" then
        local side = helper.strip_color(Menu.aa.builder.side_select:get())
        if type(side) ~= "string" then side = "Counter-Terrorists" end
        Menu.aa.builder.override:set_visible(false)
        Menu.aa.builder.override:set_enabled(true)
        Menu.aa.builder.override:set(
            builder_runtime.side_builder[side] ~= nil and
            builder_runtime.side_builder[side].override == true
        )
    end

    for _, elem in ipairs(builder_elements) do
        elem:set_enabled(is_overridden)
    end

    local function get_val(key)
        if is_overridden then
            local cond_data = get_active_runtime_cond(mode, cond)
            local v = cond_data and cond_data[key]
            if v ~= nil then return v end
        end
        return builder_defaults[key]
    end

    local function set_cb(elem, val, opts)
        if type(val) ~= "string" then val = opts[1] end
        local found = false
        for _, opt in ipairs(opts) do if opt == val then found = true; break end end
        if not found then val = opts[1] end
        elem:set(val)
    end
    local function set_sl(elem, val, fb)
        local n = tonumber(val)
        elem:set(n ~= nil and n or fb)
    end

    set_cb(Menu.aa.builder.yaw_base,         get_val("yaw_base"),         builder_combobox_options.yaw_base)
    set_cb(Menu.aa.builder.delay_mode_left,   get_val("delay_mode_left"),  builder_combobox_options.delay_mode)
    set_cb(Menu.aa.builder.delay_mode_right,  get_val("delay_mode_right"), builder_combobox_options.delay_mode)
    set_cb(Menu.aa.builder.body_yaw,          get_val("body_yaw"),         builder_combobox_options.body_yaw)

    set_sl(Menu.aa.builder.yaw_offset,        get_val("yaw_offset"),        0)
    set_sl(Menu.aa.builder.left_offset,       get_val("left_offset"),       0)
    set_sl(Menu.aa.builder.right_offset,      get_val("right_offset"),      0)
    set_sl(Menu.aa.builder.randomize,         get_val("randomize"),         0)
    set_sl(Menu.aa.builder.left_delay_min,    get_val("left_delay_min"),    2)
    set_sl(Menu.aa.builder.left_delay_max,    get_val("left_delay_max"),    14)
    set_sl(Menu.aa.builder.left_delay_value,  get_val("left_delay_value"),  2)
    set_sl(Menu.aa.builder.right_delay_min,   get_val("right_delay_min"),   2)
    set_sl(Menu.aa.builder.right_delay_max,   get_val("right_delay_max"),   14)
    set_sl(Menu.aa.builder.right_delay_value, get_val("right_delay_value"), 2)
    set_sl(Menu.aa.builder.freeze_chance,     get_val("freeze_chance"),     0)
    set_sl(Menu.aa.builder.freeze_time,       get_val("freeze_time"),       0)
    set_sl(Menu.aa.builder.freeze_cooldown,   get_val("freeze_cooldown"),   1)
    set_sl(Menu.aa.builder.body_yaw_side,     get_val("body_yaw_side"),     0)
    
    Menu.aa.builder.freeze:set(get_val("freeze") == true)
    Menu.aa.builder.left_right_enabled:set(get_val("left_right_enabled") == true)


    set_cb(Menu.aa.builder.def_pitch_mode, get_val("def_pitch_mode"), pitch_modes)
    set_cb(Menu.aa.builder.def_yaw_mode,   get_val("def_yaw_mode"),   yaw_modes)
    set_cb(Menu.aa.builder.def_body_yaw_type, get_val("def_body_yaw_type"), {"Jitter","Static","Disabled"})

    set_sl(Menu.aa.builder.def_pitch_speed, get_val("def_pitch_speed"), 1.0)
    set_sl(Menu.aa.builder.def_pitch_angle, get_val("def_pitch_angle"), 45.0)
    set_sl(Menu.aa.builder.def_pitch_max,   get_val("def_pitch_max"),   89)
    set_sl(Menu.aa.builder.def_pitch_int,   get_val("def_pitch_int"),   1.0)
    set_sl(Menu.aa.builder.def_yaw_speed,   get_val("def_yaw_speed"),   1.0)
    set_sl(Menu.aa.builder.def_yaw_angle,   get_val("def_yaw_angle"),   90.0)
    set_sl(Menu.aa.builder.def_yaw_max,     get_val("def_yaw_max"),     180)
    set_sl(Menu.aa.builder.def_yaw_int,     get_val("def_yaw_int"),     1.0)
    set_sl(Menu.aa.builder.def_body_yaw_off, get_val("def_body_yaw_off"), 0)

    Menu.aa.builder.force_defensive:set(get_val("force_defensive") == true)
    Menu.aa.builder.custom_defensive:set(get_val("custom_defensive") == true)


    builder_ui_updating = false
end

local function save_builder_ui()
    if builder_ui_updating then return end

    local mode = Menu.aa.angles.type:get()
    local cond = Menu.aa.builder.condition_select:get()
    if type(cond) ~= "string" then cond = "Standing" end

    if not get_active_override(mode) then return end

    local dst = get_active_runtime_cond(mode, cond)
    if not dst then return end

    local function get_str(elem, fb) local v = elem:get() return (type(v) == "string") and v or fb end
    local function get_num(elem, fb) local v = tonumber(elem:get()) return (v ~= nil) and v or fb end
    local function get_bool(elem) return elem:get() == true end

    dst.yaw_base         =  get_str(Menu.aa.builder.yaw_base,         "local view")
    dst.delay_mode_left  =  get_str(Menu.aa.builder.delay_mode_left,  "static")
    dst.delay_mode_right =  get_str(Menu.aa.builder.delay_mode_right, "static")
    dst.body_yaw         =  get_str(Menu.aa.builder.body_yaw,         "disabled")
    dst.yaw_offset       =  get_num(Menu.aa.builder.yaw_offset,       0)
    dst.left_offset      =  get_num(Menu.aa.builder.left_offset,      0)
    dst.right_offset     =  get_num(Menu.aa.builder.right_offset,     0)
    dst.randomize        =  get_num(Menu.aa.builder.randomize,        0)
    dst.left_delay_min   =  get_num(Menu.aa.builder.left_delay_min,   2)
    dst.left_delay_max   =  get_num(Menu.aa.builder.left_delay_max,   14)
    dst.left_delay_value =  get_num(Menu.aa.builder.left_delay_value, 2)
    dst.right_delay_min  =  get_num(Menu.aa.builder.right_delay_min,  2)
    dst.right_delay_max  =  get_num(Menu.aa.builder.right_delay_max,  14)
    dst.right_delay_value = get_num(Menu.aa.builder.right_delay_value, 2)
    dst.freeze_chance    =  get_num(Menu.aa.builder.freeze_chance,    0)
    dst.freeze_time      =  get_num(Menu.aa.builder.freeze_time,      0)
    dst.freeze_cooldown  =  get_num(Menu.aa.builder.freeze_cooldown,  1)
    dst.body_yaw_side    =  get_num(Menu.aa.builder.body_yaw_side,    0)
    dst.freeze           =  get_bool(Menu.aa.builder.freeze)
    dst.left_right_enabled =get_bool(Menu.aa.builder.left_right_enabled)

    dst.force_defensive   = get_bool(Menu.aa.builder.force_defensive)
    dst.custom_defensive  = get_bool(Menu.aa.builder.custom_defensive)
    dst.def_pitch_mode    = get_str(Menu.aa.builder.def_pitch_mode,    "HEARTBEAT")
    dst.def_pitch_speed   = get_num(Menu.aa.builder.def_pitch_speed,   1.0)
    dst.def_pitch_angle   = get_num(Menu.aa.builder.def_pitch_angle,   45.0)
    dst.def_pitch_max     = get_num(Menu.aa.builder.def_pitch_max,     89)
    dst.def_pitch_int     = get_num(Menu.aa.builder.def_pitch_int,     1.0)
    dst.def_yaw_mode      = get_str(Menu.aa.builder.def_yaw_mode,      "SWAY")
    dst.def_yaw_speed     = get_num(Menu.aa.builder.def_yaw_speed,     1.0)
    dst.def_yaw_angle     = get_num(Menu.aa.builder.def_yaw_angle,     90.0)
    dst.def_yaw_max       = get_num(Menu.aa.builder.def_yaw_max,       180)
    dst.def_yaw_int       = get_num(Menu.aa.builder.def_yaw_int,       1.0)
    dst.def_body_yaw_type = get_str(Menu.aa.builder.def_body_yaw_type, "Jitter")
    dst.def_body_yaw_off  = get_num(Menu.aa.builder.def_body_yaw_off,  0)

    builder_dirty = true
end

Menu.aa.builder.override:set_callback(function(val)
    if builder_ui_updating then return end
    local checked = type(val) == "table" and val:get() or val
    local mode = Menu.aa.angles.type:get()

    if mode == "Cheat-based builder" then
        local cheat = helper.strip_color(Menu.aa.builder.current_cheat:get())
        if type(cheat) ~= "string" or cheat == "global" then return end
        builder_runtime.cheat_builder[cheat].override = (checked == true)
    elseif mode == "Side-based builder" then
        local side = helper.strip_color(Menu.aa.builder.side_select:get())
        if type(side) ~= "string" then return end
        builder_runtime.side_builder[side].override = (checked == true)
    end
    builder_dirty = true
    update_builder_ui()
end)

for _, elem in ipairs(builder_elements) do
    elem:set_callback(function() save_builder_ui() end)
end

Menu.aa.hotkeys.left:depend(Menu.aa.hotkeys.static)
Menu.aa.hotkeys.right:depend(Menu.aa.hotkeys.static)
Menu.aa.hotkeys.forward:depend(Menu.aa.hotkeys.static)
Menu.aa.hotkeys.reset:depend(Menu.aa.hotkeys.static)



Menu.aa.builder.current_cheat:set_callback(function() update_builder_ui() end)
Menu.aa.builder.condition_select:set_callback(function() update_builder_ui() end)
Menu.aa.builder.side_select:set_callback(function() update_builder_ui() end)
Menu.aa.angles.type:set_callback(function() update_builder_ui() end)

Menu.aa.builder.left_offset:depend(Menu.aa.builder.left_right_enabled)
Menu.aa.builder.right_offset:depend(Menu.aa.builder.left_right_enabled)

Menu.aa.builder.freeze_chance:depend(Menu.aa.builder.freeze)
Menu.aa.builder.freeze_cooldown:depend(Menu.aa.builder.freeze)
Menu.aa.builder.freeze_time:depend(Menu.aa.builder.freeze)

Menu.aa.builder.body_yaw_side:depend({Menu.aa.builder.body_yaw, "disabled", true})


C.root = Menu

C:add_extra("watermark_order", function()
    return deepcopy(state.order)
end, function(v)
    if type(v) == "table" then
        state.order = deepcopy(v)
        if sync_order_listbox then
            sync_order_listbox()
        end
    end
end)

C:add_extra("drag_positions", function()
    local out = {}

    if drag_system and drag_system.items then
        for id, item in pairs(drag_system.items) do
            out[id] = {
                x = item.pos_x and item.pos_x.get and item.pos_x:get() or nil,
                y = item.pos_y and item.pos_y.get and item.pos_y:get() or nil,
            }
        end
    end

    return out
end, function(v)
    if type(v) ~= "table" or not (drag_system and drag_system.items) then
        return
    end

    for id, pos in pairs(v) do
        local item = drag_system.items[id]
        if item and type(pos) == "table" then
            if item.pos_x and item.pos_x.set and pos.x ~= nil then
                pcall(function() item.pos_x:set(pos.x) end)
            end
            if item.pos_y and item.pos_y.set and pos.y ~= nil then
                pcall(function() item.pos_y:set(pos.y) end)
            end
        end
    end
end)

do
        local autoload_name = database.read(DB_AUTOLOAD) or "Disabled"
        if autoload_name ~= "Disabled" and L and L.get_configs then
            local configs = L.get_configs()
            for i, name in ipairs(configs) do
                if name == autoload_name then
                    local cfg = L:get(i)
                    if cfg then
                        L:import(cfg.code)
                        client.color_log(159, 166, 205, "emberlash > Autoloaded config: " .. autoload_name)
                    end
                    break
                end
            end
        end
    update_builder_ui()
end


Menu.tabs.main:set_callback(function (val)
    update_builder_ui()
end)

do
    local Y = {};
    do
        Y.current_side = -1.0;
        Y._pressed_states = {};
        S.traverse({Menu.aa.hotkeys.left, Menu.aa.hotkeys.right, Menu.aa.hotkeys.forward, Menu.aa.hotkeys.reset}, function(S)
            S:set_callback("On hotkey");
        end);
        local S = {
            left = H.LEFT,
            right = H.RIGHT,
            forward = H.FORWARD
        };
        function Y:update_hotkeys()
            for C, _ in pairs(S) do
                local S = Menu.aa.hotkeys[C]:get();
                local T = self._pressed_states[C] or false;
                if S and (not T) then
                    if self.current_side == _ then
                        self.current_side = H.NONE;
                    else
                        self.current_side = _;
                    end
                end
                self._pressed_states[C] = S;
            end
            local S = Menu.aa.hotkeys.reset:get();
            local C = self._pressed_states.reset or false;
            if S and (not C) then
                self.current_side = H.NONE;
            end
            self._pressed_states.reset = S;
        end
        function Y:run(S, C)
            local _ = Menu.aa.hotkeys.edge_yaw:get();
            local T = Menu.aa.hotkeys.freestanding:get();
            local L = Menu.aa.addons.legit_aa:get() and (S.in_use == 1);
            c.aa.angles.edge_yaw:override(_);
            c.aa.angles.freestanding[1]:override(T and (self.current_side == H.NONE) and
                                                     (not Menu.aa.hotkeys.disablers:get(ctx.state)) and (not L));
            c.aa.angles.freestanding[1]:set_hotkey("Always on");
            if self.current_side == H.NONE then
                return false, "Not enabled";
            end
            if (self.current_side < H.LEFT) or (self.current_side > H.FORWARD) then
                return false, "Invalid side";
            end
            C.yaw_base = "Local view";
            C.yaw = "180";
            C.yaw_offset = j[self.current_side];
            if Menu.aa.hotkeys.static:get() then
                C.yaw_jitter = "Off";
                C.jitter_offset = 0;
                C.body_yaw = "Off";
                C.body_yaw_angle = 0;
            end
            return true;
        end
    end
    local S = {};
    do
        local C = Menu.aa.angles.defensive;
        local _ = {
            max_tickbase = (math.abs(client.get_cvar("sv_maxusrcmdprocessticks")) - 1),
            tickbase_difference = 0,
            command_number = 0,
            choked_commands = 0
        };
        local function j(T)
            _.command_number = T.command_number;
            _.choked_commands = T.chokedcommands;
        end
        local function T(L)
            local K = entity.get_local_player();
            local J = entity.get_prop(K, "m_nTickBase");
            if L.command_number == _.command_number then
                ctx.ticks_left = F.clamp(math.abs(J - _.tickbase_difference), 0, _.max_tickbase - _.choked_commands);
                _.tickbase_difference = math.max(J, _.tickbase_difference or 0);
                _.command_number = 0;
            end
            if not c.rage.other.fake_duck:get() then
                if (ctx:get_exploit_hotkey()) and (ctx.ticks_left > 1) and (ctx.ticks_left < _.max_tickbase) then
                    ctx.in_defensive = true;
                else
                    ctx.in_defensive = false;
                end
            else
                ctx.in_defensive = false;
            end
        end
        local function L()
            ctx.in_defensive = false;
            ctx.ticks_left = 0;
            _.tickbase_difference = 0;
            _.command_number = 0;
            _.choked_commands = 0;
        end
        local function setup_pitch(y)
            y = y or {};
            local P = globals.tickcount();
            local f = y.mode or 1;
            if type(f) == "string" then
                for u, M in ipairs(pitch_modes) do
                    if M == f then
                        f = u;
                        break
                    end
                end
            end
            local _ = y.speed or 1;
            local u = y.angle or 45;
            local M = y.max_angle or 89;
            local o = y.intensity or 1;
            if f == 1 then
                local y = math.min(M, 89);
                local X = client.random_float(-2.0, 2) * o;
                return math.max(-89.0, math.min(y + X, 89));
            elseif f == 2 then
                local y = -math.min(M, 89);
                local X = client.random_float(-2.0, 2) * o;
                return math.max(-89.0, math.min(y + X, 89));
            elseif f == 3 then
                local y = math.cos(P * 0.005 * _) * 3 * o;
                return math.max(-5.0, math.min(y, 5));
            elseif f == 4 then
                local y = math.cos(P * 0.02);
                local X = M * (0.7 + (0.3 * o));
                return client.random_float(-X, X) + (y * 10);
            elseif f == 5 then
                local y = 0.03 * _ * (1 + (math.cos(P * 0.01) * 0.3));
                local X = u * (0.8 + (0.2 * math.cos(P * 0.007)));
                return math.max(-M, math.min(X * math.cos(P * y), M));
            elseif f == 6 then
                local y = (((P % 8) < 3) and 1.5) or 0.7;
                local X = u * y * o;
                return client.random_float(-X, X);
            elseif f == 7 then
                local y = (16 / _) + client.random_float(-3.0, 3);
                local X = P % y;
                if X < (y * 0.3) then
                    return math.min(M, u) + client.random_float(-8.0, 8);
                elseif X < (y * 0.6) then
                    return -math.min(M, u) + client.random_float(-8.0, 8);
                else
                    return client.random_float(-u * 0.5, u * 0.5);
                end
            elseif f == 8 then
                local y = u * math.cos(P * 0.08 * _);
                local X = u * 0.3 * math.cos((P * 0.023 * _) + (math.pi / 4));
                local b = u * 0.15 * math.cos(P * 0.041);
                return math.max(-M, math.min(y + X + b, M));
            elseif f == 9 then
                local y = u * math.cos((P * 0.025 * _) + client.random_float(-8.0, 8));
                local X = client.random_float(-18.0, 18) * o;
                local b = (((P % 17) == 0) and client.random_float(-30.0, 30)) or 0;
                return math.max(-M, math.min(y + X + b, M));
            elseif f == 10 then
                local y = math.floor(30 / _) + client.random_float(-5.0, 5);
                local X = (P / y) % 5;
                local y = {-u, (-u * 0.5), 0, (u * 0.5), u};
                local b = y[X + 1] or 0;
                local y = client.random_float(-3.0, 3);
                return math.max(-M, math.min(b + y, M));
            elseif f == 11 then
                local y = u * 0.5 * math.cos(P * 0.032 * _);
                local X = u * 0.3 * math.cos((P * 0.051 * _) + 1.2);
                local b = u * 0.2 * math.cos((P * 0.077 * _) + 2.4);
                local t = client.random_float(-5.0, 5) * o;
                return math.max(-M, math.min(y + X + b + t, M));
            elseif f == 12 then
                local y = math.floor(12 / _);
                if (P % y) == 0 then
                    local y = {-M, -u, 0, u, M};
                    return y[client.random_float(1, #y)];
                end
                return 0;
            elseif f == 13 then
                local y = 4 * _;
                local X = (P * y) % 100;
                if X < 15 then
                    return M;
                elseif X < 30 then
                    return -M;
                elseif X < 45 then
                    return u * 0.5;
                else
                    return -u * 0.3;
                end
            elseif f == 14 then
                local y = 1 + ((P * 0.0001 * _) % 3);
                local X = 0.025 * _ * y;
                local y = u * (1 + (math.cos(P * 0.008) * 0.4));
                return math.max(-M, math.min(y * math.cos(P * X), M));
            elseif f == 15 then
                local y = (P / 8) % 360;
                local X = math.cos(y * 0.1) * u;
                local y = client.random_float(-8.0, 8) * o;
                return math.max(-M, math.min(X + y, M));
            elseif f == 16 then
                local y = P % math.floor(80 / _);
                if y < 8 then
                    return u * 0.8;
                elseif y < 16 then
                    return -u * 0.4;
                elseif y < 24 then
                    return u * 0.6;
                else
                    return 0;
                end
            elseif f == 17 then
                local y = 60 / _;
                local X = (P % y) / y;
                local y;
                if X < 0.5 then
                    y = u * ((X * 4) - 1);
                else
                    y = u * (3 - (X * 4));
                end
                return math.max(-M, math.min(y, M));
            elseif f == 18 then
                if client.random_float(1, 100) < (15 * o) then
                    return client.random_float(-M, M);
                end
                local y = u * math.cos(P * 0.04 * _);
                if (P % 7) == 0 then
                    return -y;
                end
                return math.max(-M, math.min(y, M));
            elseif f == 19 then
                local y = 50 / _;
                local X = (u / 89) * math.pi * 0.5;
                local b = u * math.cos((math.sqrt(0.98 / y) * P * 0.1 * _) + X);
                local y = 1 - ((P % 500) * 0.001);
                return math.max(-M, math.min(b * y, M));
            elseif f == 20 then
                local y = P * 0.01 * _;
                local _ = u * math.cos(y * 3.14159);
                local f = u * 0.6 * math.cos(y * 1.618);
                local X = u * 0.4 * math.sin(y * 2.718);
                local y = client.random_float(-12.0, 12) * o;
                local u = (((P % 23) == 0) and client.random_float(-25.0, 25)) or 0;
                return math.max(-M, math.min(_ + f + X + y + u, M));
            end
            return 0;
        end
        local function setup_yaw(y)
            y = y or {};
            local P = globals.tickcount();
            local f = y.mode or 1;
            if type(f) == "string" then
                for u, M in ipairs(yaw_modes) do
                    if M == f then
                        f = u;
                        break
                    end
                end
            end
            local K = y.speed or 1;
            local u = y.angle or 90;
            local M = y.max_angle or 180;
            local o = y.intensity or 1;
            if f == 1 then
                local y = -math.min(u, M);
                local X = client.random_float(-3.0, 3) * o;
                return math.max(-180.0, math.min(y + X, 180));
            elseif f == 2 then
                local y = math.min(u, M);
                local X = client.random_float(-3.0, 3) * o;
                return math.max(-180.0, math.min(y + X, 180));
            elseif f == 3 then
                local y = ((P / 30) % 3) - 1;
                local X = y * M * 0.6;
                return X + client.random_float(-M * 0.4, M * 0.4);
            elseif f == 4 then
                local y = u * (0.7 + (0.3 * math.cos(P * 0.011)));
                local X = 0.04 * K * (1 + (math.sin(P * 0.007) * 0.2));
                return math.max(-M, math.min(y * math.cos(P * X), M));
            elseif f == 5 then
                local y = (((P % 12) < 4) and 1.6) or 0.8;
                local X = u * y * o;
                return client.random_float(-X, X);
            elseif f == 6 then
                local y = (22 / K) + client.random_float(-4.0, 4);
                local X = P % y;
                if X < (y * 0.25) then
                    return math.min(u, M) + client.random_float(-12.0, 12);
                elseif X < (y * 0.5) then
                    return -math.min(u, M) + client.random_float(-12.0, 12);
                elseif X < (y * 0.75) then
                    return client.random_float(-u * 0.7, u * 0.7);
                else
                    return math.cos(P * 0.15) * u * 0.5;
                end
            elseif f == 7 then
                local y = u * math.cos(P * 0.018 * K);
                local X = u * 0.3 * math.cos((P * 0.037 * K) + 0.5);
                return math.max(-M, math.min(y + X, M));
            elseif f == 8 then
                local y = 7 + ((P / 100) % 3);
                local X = math.floor(14 / K) + client.random_float(-2.0, 2);
                local b = (2 * M) / y;
                local t = (P / X) % y;
                local y = client.random_float(-5.0, 5);
                return -M + (t * b) + y;
            elseif f == 9 then
                local y = (P / 20) % 4;
                if y == 0 then
                    return client.random_float(-M, M);
                elseif y == 1 then
                    return u * math.cos(P * 0.045 * K);
                elseif y == 2 then
                    return client.random_float(-u, u) + (math.sin(P * 0.03) * u * 0.3);
                else
                    local y = (((P % 3) == 0) and client.random_float(-40.0, 40)) or 0;
                    return y + (math.cos(P * 0.02) * u * 0.5);
                end
            elseif f == 10 then
                local y = math.floor(48 / K);
                local X = P % y;
                if X < 10 then
                    return -M + ((X / 10) * 2 * M);
                elseif X < ((y / 2) - 10) then
                    return M;
                elseif X < ((y / 2) + 10) then
                    return M - ((((X - (y / 2)) + 10) / 10) * 2 * M);
                elseif X < (y - 10) then
                    return -M;
                else
                    return -M + ((((X - y) + 10) / 10) * 2 * M);
                end
            elseif f == 11 then
                local y = u * 0.6 * math.cos(P * 0.028 * K);
                local X = u * 0.4 * math.cos((P * 0.047 * K) + 0.8);
                local b = u * 0.25 * math.cos((P * 0.063 * K) + 1.6);
                local t = client.random_float(-8.0, 8) * o;
                return math.max(-M, math.min(y + X + b + t, M));
            elseif f == 12 then
                local y = 1 + (P * 0.0002 * K);
                local X = ((P * y * K * 0.5) % 360) - 180;
                return math.max(-M, math.min(X, M));
            elseif f == 13 then
                local y = u * math.cos(P * 0.035 * K);
                local X = client.random_float(-8.0, 8) * o;
                if (P % 5) == 0 then
                    return y + (X * 2);
                end
                return y + X;
            elseif f == 14 then
                local angles = {-M, -u, 0, u, M}
            
                local interval = math.max(math.floor(25 / K), 1)
            
                local idx = math.floor(P / interval) % #angles + 1
                local phase = (P % interval) / interval
            
                local base = angles[idx]
                local offset = math.cos(phase * math.pi * 2) * 10 * o
            
                return base + offset
            elseif f == 15 then
                local y = 1 + ((P % 200) * 0.005);
                local o = P * 0.05 * K;
                local X = math.min(M, u * y);
                return X * math.cos(o);
            elseif f == 16 then
                local y = math.floor(18 / K);
                if (P % y) == 0 then
                    return client.random_float(-M, M);
                end
                return 0;
            elseif f == 17 then
                local y = 70 / K;
                local o = (P % y) / y;
                return -M + (o * 2 * M);
            elseif f == 18 then
                local y = 0.08 * K;
                local o = u * math.cos(P * y);
                local y = math.pow(0.998, P % 200);
                return math.max(-M, math.min(o * y, M));
            elseif f == 19 then
                local y = u * 0.7 * math.cos(P * 0.031 * K);
                local o = u * 0.5 * math.cos((P * 0.019 * K) + (math.pi / 3));
                return math.max(-M, math.min(y + o, M));
            elseif f == 20 then
                local y = (P / 50) % 5;
                if y == 0 then
                    return (u * math.cos(P * 0.04 * K)) + client.random_float(-15.0, 15);
                elseif y == 1 then
                    return client.random_float(-M, M);
                elseif y == 2 then
                    return u * math.sin(P * 0.055 * K) * math.cos(P * 0.023);
                elseif y == 3 then
                    local K = (P / 8) % 7;
                    return -M + (K * ((2 * M) / 6));
                else
                    return (u * math.cos(P * 0.03)) + (u * 0.4 * math.sin(P * 0.017));
                end
            end
            return 0;
        end
        function S:run(K, y)

            local P = entity.get_local_player();
            local f = r:get_freestand_direction();
            local is_freestanding = (ctx.additional_state == "Freestanding")
            local is_manual       = (Y.current_side ~= H.NONE)
            local aa_type = Menu.aa.angles.type:get()
            local is_any_builder = (aa_type == "Builder" or aa_type == "Cheat-based builder" or aa_type == "Side-based builder")
            if C:get("Freestanding") then
                if is_freestanding then
                    K.force_defensive = true
                    if ctx.in_defensive then
                        y.pitch       = "Custom"
                        y.pitch_angle = 0
                        y.yaw         = "180"
                        y.yaw_offset = (math.abs(f) <= 15) and -180 or ((f < 0) and -90 or 90)
                        y.body_yaw    = "Opposite"
                        y.body_yaw_angle = 0
                        y.fs_body_yaw = true
                    end
                end
            end
                
            if C:get("Manual angles") then
                if is_manual then
                    K.force_defensive = true
                    if ctx.in_defensive and _.command_number % 7 == 0 then
                        y.pitch          = "Custom"
                        y.pitch_angle    = 0
                        y.yaw            = "180"
                        y.yaw_offset     = (Y.current_side == H.LEFT) and 90 or -90.0
                        y.body_yaw       = "Opposite"
                        y.body_yaw_angle = 0
                        y.fs_body_yaw    = true
                    end
                end
            end
            if Menu.aa.angles.unsafe:get() then
                if is_manual and Menu.aa.angles.us_states:get("Manual angles") then
                    K.force_defensive = false
                    if ctx.in_defensive then
                        y.pitch          = "Custom"
                        y.pitch_angle    = 0
                        y.yaw            = "180"
                        y.yaw_offset     = (Y.current_side == H.LEFT) and 90 or -90.0
                        y.body_yaw       = "Opposite"
                        y.body_yaw_angle = 0
                        y.fs_body_yaw    = true
                    end
                end
                if is_freestanding and Menu.aa.angles.us_states:get("Freestanding") then
                    K.force_defensive = false
                    if ctx.in_defensive then
                        y.pitch          = "Custom"
                        y.pitch_angle    = -89.0
                        y.yaw            = "180"
                        y.yaw_offset     = (f < 0) and -90.0 or 90
                        y.body_yaw       = "Opposite"
                        y.body_yaw_angle = 0
                        y.fs_body_yaw    = true
                    end
                end
            end

            if is_any_builder and not (is_freestanding and C:get("Manual angles")) and not (is_manual and C:get("Freestanding")) then
                local b_mode, b_filter = "base", "global"
                if aa_type == "Cheat-based builder" then
                    b_mode = "cheat"
                    local threat_cheat = (r.threat_cheat or "unknown"):lower()
                    for _, c in ipairs(cheats_list) do
                        if threat_cheat:find(c) then b_filter = c; break end
                    end
                elseif aa_type == "Side-based builder" then
                    b_mode = "side"
                    local team = ctx:get_team()
                    b_filter = (team == 3) and "Counter-Terrorists" or "Terrorists"
                end
            
                local cond = ctx:get_state()
                local force_def    = helper.get_builder_setting(b_mode, b_filter, cond, "force_defensive")
                local custom_def   = helper.get_builder_setting(b_mode, b_filter, cond, "custom_defensive")
            
                if force_def then
                    K.force_defensive = true
                end
            
                if custom_def and ctx.in_defensive then
                    y.pitch       = "Custom"
                    y.yaw         = "180"
                    y.fs_body_yaw = true
                    y.pitch_angle = setup_pitch({
                        mode      = helper.get_builder_setting(b_mode, b_filter, cond, "def_pitch_mode"),
                        speed     = helper.get_builder_setting(b_mode, b_filter, cond, "def_pitch_speed"),
                        angle     = helper.get_builder_setting(b_mode, b_filter, cond, "def_pitch_angle"),
                        max_angle = helper.get_builder_setting(b_mode, b_filter, cond, "def_pitch_max"),
                        intensity = helper.get_builder_setting(b_mode, b_filter, cond, "def_pitch_int"),
                    })
                    y.yaw_offset = setup_yaw({
                        mode      = helper.get_builder_setting(b_mode, b_filter, cond, "def_yaw_mode"),
                        speed     = helper.get_builder_setting(b_mode, b_filter, cond, "def_yaw_speed"),
                        angle     = helper.get_builder_setting(b_mode, b_filter, cond, "def_yaw_angle"),
                        max_angle = helper.get_builder_setting(b_mode, b_filter, cond, "def_yaw_max"),
                        intensity = helper.get_builder_setting(b_mode, b_filter, cond, "def_yaw_int"),
                    })
                    local byt        = helper.get_builder_setting(b_mode, b_filter, cond, "def_body_yaw_type")
                    y.body_yaw       = (byt == "Jitter") and "Jitter" or (byt == "Static") and "Static" or "Off"
                    y.body_yaw_angle = helper.get_builder_setting(b_mode, b_filter, cond, "def_body_yaw_off") * 90
                    return 
                end
            end
            
                if C:get("Weapon events") then
                local _ = entity.get_player_weapon(P);
                local H = entity.get_prop(_, "m_bInReload") == 1;
                if H then
                    K.force_defensive = true;
                    if ctx.in_defensive then
                        y.pitch = "Custom";
                        y.pitch_angle = -45.0;
                        y.yaw = "Spin";
                        y.yaw_offset = 25;
                        y.body_yaw = "Jitter";
                        y.body_yaw_angle = 45;
                        y.fs_body_yaw = true;
                    end
                end
            end
            if C:get("Safe head") then
                if ctx.state == "In air-crouch" then
                    if (ctx.weapon == "Knife") or (ctx.weapon == "Taser") then
                        K.force_defensive = true;
                        if ctx.in_defensive then
                            y.pitch = "Custom";
                            y.pitch_angle = 0;
                            y.yaw = "180";
                            y.yaw_offset = 180;
                            if r.peek_side == "left" then
                                y.body_yaw = "Static";
                                y.body_yaw_angle = -90.0;
                            elseif r.peek_side == "right" then
                                y.body_yaw = "Static";
                                y.body_yaw_angle = 90;
                            else
                                y.body_yaw = "Jitter";
                                y.body_yaw_angle = 180;
                            end
                            y.fs_body_yaw = false;
                        end
                    end
                end
            end


        end
        client.set_event_callback("run_command", j);
        client.set_event_callback("predict_command", T);
        client.set_event_callback("level_init", L);
        client.set_event_callback("round_start", L);
        client.set_event_callback("round_end", L);
        client.set_event_callback("player_death", function(C)
            local _ = client.userid_to_entindex(C.userid);
            if _ == entity.get_local_player() then
                L();
            end
        end);
    end
    local C = {};
    function C.run(_)
        local H = entity.get_players(true);
        local j = entity.get_local_player();
        local T = h(entity.get_prop(j, "m_vecOrigin"));
        for L = 1, #H do
            local K = h(entity.get_prop(H[L], "m_vecOrigin"));
            local J = entity.get_player_weapon(H[L]);
            if (entity.get_classname(J) == "CKnife") and (T:dist(K) <= 389) then
                local T = h(client.eye_position());
                local K = h(entity.hitbox_position(H[L], 4));
                local J, y = client.trace_line(H[L], K.x, K.y, K.z, T.x, T.y, T.z);
                if (y == j) or (J == 1) then
                    _.pitch = "Down";
                    _.yaw_base = "At targets";
                    _.yaw = "180";
                    _.yaw_offset = 180;
                    _.yaw_jitter = "Off";
                    _.jitter_offset = 0;
                    _.body_yaw = "Static";
                    _.body_yaw_angle = 69;
                end
            end
        end
    end
    local _ = {};
    function _.run(H, j)
        if H.in_use == 0 then
            return false;
        end
        if ctx.use_active then
            return false;
        end
        H.force_defensive = false;
        j.pitch = "Off";
        j.yaw_base = "Local view";
        j.yaw = "180";
        j.yaw_offset = 180;
        H.in_use = 0;
        return true;
    end
    local H = {};
    function H.run(j)
        local T = entity.get_local_player();
        client.camera_angles();
        local L = entity.get_prop(T, "m_MoveType");
        local K = entity.get_player_weapon(T);
        local T = entity.get_prop(K, "m_fThrowTime");
        if (L == 9) and (K ~= nil) and ((T == nil) or (T == 0)) then
            if j.forwardmove > 0 then
                if j.pitch < 45 then
                    j.pitch = 89;
                    j.in_moveright = 1;
                    j.in_moveleft = 0;
                    j.in_forward = 0;
                    j.in_back = 1;
                    if j.sidemove == 0 then
                        j.yaw = j.yaw + 90;
                    end
                    if j.sidemove < 0 then
                        j.yaw = j.yaw + 150;
                    end
                    if j.sidemove > 0 then
                        j.yaw = j.yaw + 30;
                    end
                end
            elseif j.forwardmove < 0 then
                j.pitch = 89;
                j.in_moveleft = 1;
                j.in_moveright = 0;
                j.in_forward = 1;
                j.in_back = 0;
                if j.sidemove == 0 then
                    j.yaw = j.yaw + 90;
                end
                if j.sidemove > 0 then
                    j.yaw = j.yaw + 150;
                end
                if j.sidemove < 0 then
                    j.yaw = j.yaw + 30;
                end
            end
        end
    end
    local j = {};
    function j.run(T)
        if ctx.in_defensive and (not T.force_defensive) then
            local T = "Never slide";
            if (c.aa.other.leg_movement:get() == "Never slide") or (c.aa.other.leg_movement:get() == "Off") then
                T = "Always slide";
            end
            c.aa.other.leg_movement:override(T);
        else
            c.aa.other.leg_movement:override();
        end
    end
    local T = {};
    function T.run(L)
        if not c.rage.other.fake_duck:get() then
            if c.rage.aimbot.double_tap[1]:get() and c.rage.aimbot.double_tap[1].hotkey:get() and
                (r.peek_side ~= "none") and (r.peek_side ~= "both") then
                L.force_defensive = true;
                if ctx.ticks_left > 1 then
                    L.no_choke = false;
                    L.allow_send_packet = false;
                end
            end
        end
    end
    local function L(cmd)
        local J = Menu.aa.angles.type:get();
        local y = r:setup(J, cmd);
        Y:update_hotkeys(); 
        Y:run(cmd, y); 
        S:run(cmd, y); 
        if Menu.aa.addons.anti_backstab:get() then
            C.run(y);
        end
        if Menu.aa.addons.legit_aa:get() then
            _.run(cmd, y);
        end
        if Menu.aa.addons.fast_ladder:get() then
            H.run(cmd);
        end
        if Menu.aa.addons.defensive_legs:get() then
            j.run(cmd);
        end
        if Menu.aa.addons.defensive_peek:get() then
            T.run(cmd);
        end
        r:push(y);
    end
    do
        local S = Menu.toggle;
        local function Y()
            if S:get() then
                client.set_event_callback("setup_command", L);
            else
                client.unset_event_callback("setup_command", L);
            end
        end
        S:set_callback(Y, true);
    end
end
local S = {};
do
    local Y = {
        last_time_counter = 0,
        hours_played = 0,
        times_loaded = 0,
        enemies_killed = 0,
        shots_hit = 0,
        shots_missed = 0
    };
    local function C()
        for _ in pairs(Y) do
            Y[_] = database.read("mr_emberlash_stats_" .. _) or 0;
        end
    end
    local function _(H)
        if H then
            database.write("mr_emberlash_stats_" .. H, Y[H]);
            return;
        end
        for H in pairs(Y) do
            database.write("mr_emberlash_stats_" .. H, Y[H]);
        end
    end
    function S.add_kill(H)
        if entity.get_steam64(client.userid_to_entindex(H.userid)) == 0 then
            return;
        end
        Y.enemies_killed = Y.enemies_killed + 1;
        _("enemies_killed");
        S.update_ui();
    end
    function S.add_hit(H)
        if entity.get_steam64(H.target) == 0 then
            return;
        end
        Y.shots_hit = Y.shots_hit + 1;
        _("shots_hit");
        S.update_ui();
    end
    function S.add_miss(H)
        if entity.get_steam64(H.target) == 0 then
            return;
        end
        Y.shots_missed = Y.shots_missed + 1;
        _("shots_missed");
        S.update_ui();
    end
    function S.add_playtime()
        local H = globals.realtime();
        if S.last_time_counter == 0 then
            S.last_time_counter = H;
        end
        if (H - Y.last_time_counter) > 30 then
            Y.hours_played = Y.hours_played + ((H - Y.last_time_counter) / 3600);
            Y.last_time_counter = H;
            _("hours_played");
        end
    end
    function S.get_hitrate()
        local H = Y.shots_hit + Y.shots_missed;
        if H == 0 then
            return 100;
        end
        return (Y.shots_hit / H) * 100;
    end
    function S.update_ui()
        Menu.statistics.hours_played:set(string.format("\12<gray>Hours played \226\151\166: \11%.2f", Y.hours_played));
        Menu.statistics.times_loaded:set("\12<gray>Times loaded \226\151\166: \11" .. Y.times_loaded);
        Menu.statistics.enemies_killed:set("\12<gray>Enemies killed \226\151\166: \11" .. Y.enemies_killed);
        Menu.statistics.hitrate:set(string.format("\12<gray>Hitrate \226\151\166: \11%.1f%%", S.get_hitrate()));
    end
    C();
    Y.times_loaded = Y.times_loaded + 1;
    _("times_loaded");
    S.update_ui();
    client.set_event_callback("aim_hit", function(Y)
        S.add_hit(Y);
    end);
    client.set_event_callback("aim_miss", function(Y)
        S.add_miss(Y);
    end);
    client.set_event_callback("player_death", function(Y)
        if client.userid_to_entindex(Y.attacker) == entity.get_local_player() then
            S.add_kill(Y);
        end
    end);
    client.set_event_callback("paint_ui", function()
        S.add_playtime();
    end);
end
local S = {};
do
    do
        local Y = Menu.settings.resolver;
        local C = vtable_bind("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)");
        local _ = ffi.typeof(
            "            struct {\n                char pad0[0x18];\n                float anim_update_timer;\n                char pad1[0xC];\n                float started_moving_time;\n                float last_move_time;\n                char pad2[0x10];\n                float last_lby_time;\n                char pad3[0x8];\n                float run_amount;\n                char pad4[0x10];\n                void* entity;\n                void* active_weapon;\n                void* last_active_weapon;\n                float last_client_side_animation_update_time;\n                int last_client_side_animation_update_framecount;\n                float eye_timer;\n                float eye_angles_y;\n                float eye_angles_x;\n                float goal_feet_yaw;\n                float current_feet_yaw;\n                float torso_yaw;\n                float last_move_yaw;\n                float lean_amount;\n                char pad5[0x4];\n                float feet_cycle;\n                float feet_yaw_rate;\n                char pad6[0x4];\n                float duck_amount;\n                float landing_duck_amount;\n                char pad7[0x4];\n                float current_origin[3];\n                float last_origin[3];\n                float velocity_x;\n                float velocity_y;\n                char pad8[0x4];\n                float unknown_float1;\n                char pad9[0x8];\n                float unknown_float2;\n                float unknown_float3;\n                float unknown;\n                float m_velocity;\n                float jump_fall_velocity;\n                float clamped_velocity;\n                float feet_speed_forwards_or_sideways;\n                float feet_speed_unknown_forwards_or_sideways;\n                float last_time_started_moving;\n                float last_time_stopped_moving;\n                bool on_ground;\n                bool hit_in_ground_animation;\n                char pad10[0x4];\n                float time_since_in_air;\n                float last_origin_z;\n                float head_from_ground_distance_standing;\n                float stop_to_full_running_fraction;\n                char pad11[0x4];\n                float magic_fraction;\n                char pad12[0x3C];\n                float world_force;\n                char pad13[0x1CA];\n                float min_yaw;\n                float max_yaw;\n            }**\n        ");
        local function H(j)
            if not j then
                return nil;
            end
            local T = C(j);
            if not T then
                return nil;
            end
            local j = ffi.cast(_, ffi.cast("char*", ffi.cast("void***", T)) + 39264);
            if (j == nil) or (j[0] == nil) then
                return nil;
            end
            return j[0];
        end
        local function _(j)
            local T = C(j);
            if not T then
                return 0;
            end
            return ffi.cast("float*", ffi.cast("uintptr_t", T) + 620)[0];
        end
        local function C(j)
            if not j then
                return 60;
            end
            local T = F.clamp(j.feet_speed_forwards_or_sideways, 0, 1);
            local L = (((j.stop_to_full_running_fraction * -0.3) - 0.2) * T) + 1;
            local K = j.duck_amount;
            if K > 0 then
                L = L + (K * T * (0.5 - L));
            end
            return F.clamp(L, 0.5, 1) * 60;
        end
        local j = {};
        local function T(L)
            local K = {};
            K.player = L;
            K.last_simtime = 0;
            K.origin = h(entity.get_origin(L));
            K.broke_lc = false;
            K.in_defensive = false;
            K.ticks_left = 0;
            K.max_tickbase = math.abs(client.get_cvar("sv_maxusrcmdprocessticks")) - 1;
            K.tickbase_difference = 0;
            function K.update()
                local J = toticks(entity.get_prop(K.player, "m_flSimulationTime"));
                local y = J;
                local J = h(entity.get_origin(K.player));
                local P = entity.get_prop(K.player, "m_nTickBase");
                local f = y - K.last_simtime;
                if P then
                    if f < 0 then
                        local u = math.abs(f);
                        K.ticks_left = F.clamp(u, 0, K.max_tickbase);
                        K.tickbase_difference = P;
                    else
                        if K.tickbase_difference > 0 then
                            local u = math.abs(P - K.tickbase_difference);
                            K.ticks_left = F.clamp(u, 0, K.max_tickbase);
                        end
                        K.tickbase_difference = math.max(P, K.tickbase_difference or 0);
                    end
                    K.in_defensive = (K.ticks_left > 1) and (K.ticks_left < K.max_tickbase);
                else
                    K.in_defensive = false;
                    K.ticks_left = 0;
                end
                if f >= 0 then
                    K.broke_lc = (K.origin - J):length2dsqr() > 4096;
                    K.origin = J;
                end
                K.last_simtime = y;
            end
            j[L] = K;
            return K;
        end
        local function L(K, J)
            plist.set(K, "Force body yaw", J.force_body_yaw);
            plist.set(K, "Force body yaw value", J.yaw_value);
        end
        local function K(J, y)
            if not J.angle_history then
                J.angle_history = {};
                J.delay_history = {};
                J.cached_delay = nil;
                J.delay_consistency = 0;
                J.last_update_tick = y;
                return nil;
            end
            local P = y - J.last_update_tick;
            J.last_update_tick = y;
            if (P >= 2) and (P < 10) then
                table.insert(J.delay_history, P);
                if #J.delay_history > 8 then
                    table.remove(J.delay_history, 1);
                end
                if #J.delay_history >= 3 then
                    local y = 0;
                    local f = true;
                    local u = J.delay_history[1];
                    for M = 1, #J.delay_history do
                        y = y + J.delay_history[M];
                        if math.abs(J.delay_history[M] - u) > 1 then
                            f = false;
                        end
                    end
                    if f and (u > 2) then
                        J.cached_delay = u;
                        J.delay_consistency = math.min(J.delay_consistency + 1, 5);
                    else
                        J.delay_consistency = math.max(J.delay_consistency - 1, 0);
                        if J.delay_consistency == 0 then
                            J.cached_delay = nil;
                        end
                    end
                end
            elseif P <= 2 then
                J.delay_consistency = math.max((J.delay_consistency or 0) - 1, 0);
                if J.delay_consistency == 0 then
                    J.cached_delay = nil;
                    J.delay_history = {};
                end
            end
            return J.cached_delay;
        end
        local function J(y, P)
            if (not y.angle_history) or (#y.angle_history < (P + 1)) then
                return nil;
            end
            local f = #y.angle_history - P;
            if (f >= 1) and (f <= #y.angle_history) then
                return y.angle_history[f];
            end
            return nil;
        end
        local function y(P, f, u)
            local M = math.abs(f);
            if M < 5 then
                P.static_ticks = (P.static_ticks or 0) + 1;
                if P.static_ticks >= 3 then
                    return "S";
                end
            else
                P.static_ticks = 0;
            end
            if M > 30 then
                P.jitter_ticks = (P.jitter_ticks or 0) + 1;
                if P.jitter_ticks >= 2 then
                    local f = K(P, u);
                    if f and (P.delay_consistency >= 3) then
                        return "DJ";
                    end
                    return "J";
                end
            else
                P.jitter_ticks = math.max((P.jitter_ticks or 0) - 1, 0);
            end
            return "S";
        end
        local function K(P)
            local f = entity.get_steam64(P);
            if f == 0 then
                return;
            end
            local f = j[P] or T(P);
            f.update();
            local T = H(P);
            if not T then
                return;
            end
            local H = entity.get_prop(P, "m_flSimulationTime");
            local u = _(P);
            local _ = select(2, entity.get_prop(P, "m_angEyeAngles"));
            if (not _) or (not H) then
                return;
            end
            local M = toticks(H);
            local o = S[P];
            if not o then
                o = {
                    last_yaw = _,
                    last_simtime = H,
                    side = 1,
                    jitter_ticks = 0,
                    static_ticks = 0,
                    no_update_ticks = 0,
                    resolve_yaw = 0,
                    last_resolve_yaw = 0,
                    aa_state = "S",
                    angle_history = {},
                    delay_history = {},
                    cached_delay = nil,
                    delay_consistency = 0,
                    last_update_tick = M
                };
                S[P] = o;
                return;
            end
            if (H == o.last_simtime) or (H == u) then
                o.no_update_ticks = (o.no_update_ticks or 0) + 1;
                local u = ((f.defensive ~= nil) and f.defensive) or false;
                L(P, {
                    force_body_yaw = (not u),
                    yaw_value = o.last_resolve_yaw
                });
                client.update_player_list();
                return;
            end
            o.no_update_ticks = 0;
            local u = F.normalize_yaw(_ - o.last_yaw);
            local X = C(T);
            table.insert(o.angle_history, _);
            if #o.angle_history > 16 then
                table.remove(o.angle_history, 1);
            end
            o.aa_state = y(o, u, X, M);
            if (o.aa_state == "DJ") and o.cached_delay then
                local C = J(o, o.cached_delay);
                if C then
                    local T = F.normalize_yaw(_ - C);
                    if math.abs(T) > 30 then
                        o.side = ((T > 0) and 1) or -1.0;
                    end
                    local C = math.abs(T);
                    local T = F.clamp(C / X, 0.15, 1);
                    o.resolve_yaw = o.side * X * T;
                else
                    if math.abs(u) > 30 then
                        o.side = ((u > 0) and 1) or -1.0;
                    end
                    local C = math.abs(u);
                    local T = F.clamp(C / X, 0.15, 1);
                    o.resolve_yaw = o.side * X * T;
                end
            else
                if math.abs(u) > 30 then
                    o.side = ((u > 0) and 1) or -1.0;
                end
                local C = math.abs(u);
                local T = F.clamp(C / X, 0.15, 1);
                o.resolve_yaw = o.side * X * T;
            end
            o.last_resolve_yaw = o.resolve_yaw;
            local C = ((f.defensive ~= nil) and f.defensive) or false;
            local T = ((f.broke_lc ~= nil) and f.broke_lc) or false;
            L(P, {
                force_body_yaw = (not C),
                yaw_value = o.resolve_yaw
            });
            client.update_player_list();
            o.last_yaw = _;
            o.last_simtime = H;
        end
        local function C()
            for _ in pairs(S) do
                if entity.is_enemy(_) then
                    L(_, {
                        force_body_yaw = false,
                        yaw_value = 0
                    });
                end
            end
            client.update_player_list();
        end
        local _;
        local function H()
            local T = entity.get_local_player();
            if (not T) or (not entity.is_alive(T)) then
                C();
                return;
            end
            local C = client.current_threat();
            if C ~= nil then
                _ = C;
            end
            if (not C) or (not entity.is_alive(C)) then
                if _ then
                    L(_, {
                        force_body_yaw = false,
                        yaw_value = 0
                    });
                end
                return;
            end
            if entity.is_dormant(C) then
                L(C, {
                    force_body_yaw = false,
                    yaw_value = 0
                });
                return;
            end
            K(C);
        end
        local function C()
            j = {};
            S = {};
        end
        do
            local function _(j)
                local T = Menu.toggle:get() and j:get();
                if not T then
                    C();
                    c.player_list.reset:set(true);
                end
                if T then
                    client.set_event_callback("net_update_end", H);
                    client.set_event_callback("round_prestart", C);
                else
                    client.unset_event_callback("net_update_end", H);
                    client.unset_event_callback("round_prestart", C);
                end
            end
            Y:set_callback(_, true);
        end
    end
    do
        local Y = Menu.settings.predict;
        local function C()
            cvar.cl_interpolate:set_int(0);
            cvar.cl_interp_ratio:set_int(1);
        end
        do
            local function _(H)
                local j = Menu.toggle:get() and H:get();
                if not j then
                    cvar.cl_interpolate:set_int(1);
                    cvar.cl_interp_ratio:set_int(2);
                end
                if j then
                    client.set_event_callback("pre_render", C);
                else
                    client.unset_event_callback("pre_render", C);
                end
            end
            Y:set_callback(_, true);
        end
    end
    do
        local Y = Menu.settings.aimbot_helper;
        local function C()
        end
        do
            local function _(H)
                local j = Menu.toggle:get() and H:get();
                if not j then
                end
                if j then
                    client.set_event_callback("setup_command", C);
                else
                    client.unset_event_callback("setup_command", C);
                end
            end
            Y:set_callback(_, true);
        end
    end
    do
        local jump_scout = Menu.settings.jump_scout
        local function calc_hitchance_by_distance(dist)
            local clamped_dist = math.min(dist, 1350)
            local hitchance = 55 - (22 * (clamped_dist / 1350))
            return math.floor(hitchance + 0.5)
        end

        local function on_setup_command(state)
            local local_player = entity.get_local_player()
            if (not entity.is_alive(local_player)) or (ctx.weapon ~= "SSG08") then
                c.rage.aimbot.target_selection:override()
                c.rage.aimbot.mp_scale:override()
                c.rage.aimbot.minimum_hitchance:override()
                return
            end

            local is_scoped = entity.get_prop(local_player, "m_bIsScoped") == 1
            if not is_scoped then
                c.rage.aimbot.target_selection:override()
                c.rage.aimbot.mp_scale:override()
                c.rage.aimbot.minimum_hitchance:override()
                return
            end

            if (not ctx.on_ground) or (state.in_jump == 1) then
                c.rage.aimbot.target_selection:override("Best hit chance")
                c.rage.aimbot.mp_scale:override(24)

                local min_hitchance = 60
                local target = client.current_threat()
                if target then
                    local local_pos = h(entity.get_origin(local_player))
                    local target_pos = h(entity.get_origin(target))
                    local dist = (local_pos - target_pos):length()
                    if dist < 1350 then
                        min_hitchance = calc_hitchance_by_distance(dist)
                    end
                end
                c.rage.aimbot.minimum_hitchance:override(min_hitchance)
            elseif ctx.hit_in_ground then
                c.rage.aimbot.target_selection:override("Best hit chance")
                c.rage.aimbot.mp_scale:override()
                c.rage.aimbot.minimum_hitchance:override()
            else
                c.rage.aimbot.target_selection:override()
                c.rage.aimbot.mp_scale:override()
                c.rage.aimbot.minimum_hitchance:override()
            end
            local move_type = entity.get_prop(local_player, "m_MoveType")
            if (ctx.speed < 10) and (not ctx.on_ground) and (move_type ~= 9) then
                c.misc.movement.air_strafe_dir:override({"Movement keys"})
                state.in_speed = 1
                state.quick_stop = true
                state.in_duck = 1
            else
                c.misc.movement.air_strafe_dir:override()
            end
        end

        do
            local function on_toggle_changed(checkbox)
                local enabled = Menu.toggle:get() and checkbox:get()

                if not enabled then
                    c.rage.aimbot.target_selection:override()
                    c.rage.aimbot.mp_scale:override()
                    c.rage.aimbot.minimum_hitchance:override()
                end

                if enabled then
                    client.set_event_callback("setup_command", on_setup_command)
                else
                    client.unset_event_callback("setup_command", on_setup_command)
                end
            end

            jump_scout:set_callback(on_toggle_changed, true)
        end
    end
    do
        local Y = Menu.settings.ideal_tick;
        local C = Menu.settings.ideal_tick_settings;
        local peek = Menu.settings.peek_bot;
        local _ = c.rage.aimbot.double_tap[1];
        local H = c.aa.angles.freestanding[1];
        local j = c.rage.other.quick_peek[1];
        local function T()
            if peek:get() then
                return
            end
            local L = Y.hotkey:get();
            if L then
                e.update(_, "double_tap", C:get("Double tap"));
                if C:get("Freestanding") then
                    H:override(true);
                end
                e.update(j, "auto_peek", C:get("Auto peek"));
            else
                if C:get("Double tap") then
                    e.restore(_, "double_tap");
                end
                if C:get("Auto peek") then
                    e.restore(j, "auto_peek");
                end
            end
        end
        do
            local function C(H)
                local L = Menu.toggle:get() and H:get();
                if not L then
                    e.restore(_, "double_tap");
                    e.restore(j, "auto_peek");
                end
                if L then
                    client.set_event_callback("setup_command", T);
                else
                    client.unset_event_callback("setup_command", T);
                end
            end
            Y:set_callback(C, true);
        end
    end
    do
        local Y = Menu.settings.swap_on_quick_peek;
        local C = c.rage.other.quick_peek[1];
        local _ = 0;
        local H = 0;
        local j = 0;
        local T = 0;
        local L = 0;
        local K = 1;
        local function J()
            return (globals.realtime() - L) >= 0.05;
        end
        local function y(P)
            if (K == P) or (not J()) then
                return;
            end
            r.auto_peek_knife = P;
            client.exec(((P == 1) and "slot1") or "slot3");
            K = P;
            L = globals.realtime();
        end
        local function L()
            return C:get() and C.hotkey:get();
        end
        local function C(K)
            if K then
                y(1);
            end
            _ = 0;
            H = 0;
            j = 0;
            T = 0;
        end
        local function K()
            if ctx.weapon ~= "SSG08" then
                j = 0;
                T = 0;
                return false;
            end
            local J = entity.get_local_player();
            if not J then
                return false;
            end
            local P = entity.get_player_weapon(J);
            if not P then
                return false;
            end
            local f = entity.get_prop(P, "m_bInReload") == 1;
            if f then
                j = 0;
                T = 0;
                return false;
            end
            local f = entity.get_prop(P, "m_flNextPrimaryAttack");
            local P = entity.get_prop(J, "m_nTickBase");
            if (not f) or (not P) then
                return false;
            end
            local J = false;
            if j ~= 0 then
                if (f > j) and (P > T) then
                    J = true;
                end
            end
            j = f;
            T = P;
            return J;
        end
        local function j()
            local T = entity.get_local_player();
            if (not T) or (not entity.is_alive(T)) then
                C(false);
                return;
            end
            if not L() then
                C(true);
                return;
            end
            if _ == 0 then
                if K() then
                    y(3);
                    _ = 1;
                    H = globals.realtime();
                end
            elseif _ == 1 then
                if (globals.realtime() - H) >= 0.35 then
                    y(1);
                    C(false);
                end
            end
        end
        do
            local function _(H)
                local T = Menu.toggle:get() and H:get();
                if not T then
                    C(true);
                end
                if T then
                    client.set_event_callback("setup_command", j);
                else
                    client.unset_event_callback("setup_command", j);
                end
            end
            Y:set_callback(_, true);
        end
    end
    local Y = {};
    do
        local C = Menu.settings.unsafe_recharge;
        Y.timer = globals.tickcount();
        Y.ticks = 14;
        local function _()
            local H = client.current_threat();
            if not H then
                return;
            end
            local H = entity.get_local_player();
            if (not H) or (not entity.is_alive(H)) then
                c.rage.aimbot.enabled[1]:set_hotkey("Always on");
                return;
            end
            local j = c.rage.aimbot.double_tap[1]:get() and c.rage.aimbot.double_tap[1].hotkey:get() and
                          (not c.rage.other.fake_duck:get());
            local T = c.aa.other.on_shot_anti_aim[1]:get() and c.aa.other.on_shot_anti_aim[1].hotkey:get() and
                          (not c.rage.other.fake_duck:get());
            local L = entity.get_player_weapon(H);
            if not L then
                return;
            end
            Y.ticks = (i(L).is_revolver and 17) or 14;
            if j or T then
                if globals.tickcount() >= (Y.timer + Y.ticks) then
                    c.rage.aimbot.enabled[1]:set_hotkey("Always on");
                else
                    c.rage.aimbot.enabled[1]:set_hotkey("On hotkey");
                end
            else
                Y.timer = globals.tickcount();
                c.rage.aimbot.enabled[1]:set_hotkey("Always on");
            end
        end
        local function i()
            Y.timer = globals.tickcount();
        end
        do
            local function Y(H)
                local j = Menu.toggle:get() and H:get();
                if not j then
                    c.rage.aimbot.enabled[1]:set_hotkey("Always on");
                end
                if j then
                    client.set_event_callback("setup_command", _);
                    client.set_event_callback("round_start", i);
                else
                    client.unset_event_callback("setup_command", _);
                    client.unset_event_callback("round_start", i);
                end
            end
            C:set_callback(Y, true);
        end
    end
    do
        local Y = Menu.settings.duck_peek_assist_fix;
        local C = {
            [0] = "Always on",
            [1] = "On hotkey",
            [2] = "Toggle",
            [3] = "Off hotkey"
        };
        local i = nil;
        local _ = false;
        local function H(j)
            local T = {j:get()};
            if j:get_type() == "hotkey" then
                return {(C[T[2]] or "Off hotkey"), T[3]};
            end
            return T;
        end
        local function C(j)
            local T = entity.get_local_player();
            if (not T) or (not entity.is_alive(T)) then
                return;
            end
            local L = (j.in_duck == 1) and (entity.get_prop(T, "m_flDuckAmount") > 0.8);
            local j, T = c.rage.other.fake_duck:get();
            if (j == nil) or (T == nil) then
                return;
            end
            if L and j and (not _) then
                i = H(c.rage.other.fake_duck);
                local H = (((T == 2) or (T == 3)) and "On hotkey") or "Off hotkey";
                c.rage.other.fake_duck:set(H);
                _ = true;
            elseif (not L) and _ and i then
                c.rage.other.fake_duck:set(table.unpack(i));
                i = nil;
                _ = false;
            end
        end
        do
            local function i(_)
                local H = Menu.toggle:get() and _:get();
                if H then
                    client.set_event_callback("setup_command", C);
                else
                    client.unset_event_callback("setup_command", C);
                end
            end
            Y:set_callback(i, true);
        end
    end
    do
        local Y = Menu.settings.auto_exploit;
        local C = Menu.settings.auto_exploit_states;
        local i = Menu.settings.auto_exploit_avoid;
        local _ = c.rage.aimbot.double_tap[1];
        local H = c.aa.other.on_shot_anti_aim[1];
        local function j()
            if ctx.additional_state == "Fake lag" then
                return false;
            end
            if not C:get(ctx.state) then
                return false;
            end
            if i:get("Pistols") and (ctx.weapon == "Pistols") then
                return false;
            end
            if i:get("Desert eagle") and (ctx.weapon == "Deagle") then
                return false;
            end
            if i:get("Auto snipers") and (ctx.weapon == "Auto snipers") then
                return false;
            end
            if i:get("Desert eagle + Crouch") and (ctx.weapon == "Deagle") and
                ((ctx.state == "Crouching") or (ctx.state == "Sneaking")) then
                return false;
            end
            return true;
        end
        local function C()
            local i = j();
            if i then
                _:override(false);
                e.restore(_, "double_tap");
                e.force(H, "on_shot");
            else
                _:override();
                e.restore(H, "on_shot");
                e.restore(_, "double_tap");
            end
        end
        do
            local function i(j)
                local T = Menu.toggle:get() and j:get();
                if not T then
                    _:override();
                    e.restore(_, "double_tap");
                    e.restore(H, "on_shot");
                end
                if T then
                    client.set_event_callback("setup_command", C);
                else
                    client.unset_event_callback("setup_command", C);
                end
            end
            Y:set_callback(i, true);
        end
    end
    do
        local knife_peek = Menu.settings.swap_on_quick_peek;
        local peek_debug = Menu.settings.peek_bot_debug;
        local Y = Menu.settings.peek_bot;
        local C = 0;
        local i = 255;
        local function _(H, j, T, L, K)
            local J, y, P = entity.get_prop(H, "m_vecVelocity");
            return T + (globals.tickinterval() * J * j), L + (globals.tickinterval() * y * j),
                K + (globals.tickinterval() * P * j);
        end
        local function H(j)
            if not j then
                return false;
            end
            return bit.band(entity.get_prop(j, "m_fFlags"), 1) == 0;
        end
        local function j(T)
            if (not entity.is_alive(T)) or entity.is_dormant(T) then
                return false;
            end
            local L = entity.get_prop(T, "m_flDuckAmount");
            local K = entity.get_prop(T, "m_flDuckSpeed");
            local J = entity.get_prop(T, "m_fFlags");
            return (L > 0.1) and (L < 0.9) and (K > 1) and (bit.band(J, 4) == 4);
        end
        local function T(L, K, J)
            return L + ((K - L) * J);
        end
        local function L(K, J, y, P, f, u, M, o, X)
            local b = X or 24;
            local X, t;
            local z, n;
            for G = 0, 360, 360 / b do
                local b = math.rad(G);
                local G, Q = (P * math.sin(b)) + K, (P * math.cos(b)) + J;
                local K, J = renderer.world_to_screen(G, Q, y);
                if not z then
                    z, n = K, J;
                end
                if K and X then
                    renderer.line(K, J, X, t, f, u, M, o);
                end
                X, t = K, J;
            end
            if z and X then
                renderer.line(X, t, z, n, f, u, M, o);
            end
        end
        local function K(J, y, P, f, u, M, o, X, b)
            for t = 1, b do
                local z = f + (t * 3);
                local f = math.floor(X * (1 - (t / (b + 1))));
                L(J, y, P, z, u, M, o, f, 32);
            end
        end
        local function L(J, y, P, f, u, M, o, X, b, t)
            for z = 0, 20 do
                local n = z / 20;
                local G = T(J, f, n);
                local J = T(y, u, n);
                local y = T(P, M, n);
                local P = math.cos((C * 2) + (n * 10)) * 5;
                local f, u = renderer.world_to_screen(G + P, J + P, y);
                if (z > 0) and f and last_sx then
                    local J = math.floor(t * (0.7 + (0.3 * math.cos((C * 3) + (n * 15)))));
                    renderer.line(last_sx, last_sy, f, u, o, X, b, J);
                end
                last_sx, last_sy = f, u;
            end
        end
        local J = {
            is_active = false,
            anchor_vec = nil,
            start_view = nil,
            max_peek_distance = 0
        };
        local y = {};
        local P = {};
        local f = 0;
        local u = false;
        local M = nil;
        local o = false;
        local X = false;
        local function b()
            if c.rage.aimbot.minimum_damage_override[1]:get() and c.rage.aimbot.minimum_damage_override[1].hotkey:get() then
                f = c.rage.aimbot.minimum_damage_override[2]:get();
            else
                f = c.rage.aimbot.minimum_damage:get();
            end
        end
        local function t(z, n)
            local G = n - z;
            if (G.x == 0) and (G.y == 0) then
                return ((G.z > 0) and -90.0) or 90, 0;
            end
            return math.deg(math.atan2(-G.z, G:length2d())), math.deg(math.atan2(G.y, G.x));
        end
        local function z(n, G, Q, k)
            local V = 90 + k.y + n;
            return Q + h(G * math.sin(math.rad(V)), G * math.cos(math.rad(V)), 0);
        end
        local function n(G, Q, k, V)
            local R = {};
            Q = math.max(2, math.floor(Q));
            local w = 360 / Q;
            for Q = 0, 360 - w, w do
                table.insert(R, z(Q, G, k, V));
            end
            return R;
        end
        local function z(G, Q, k, V)
            local R = h(Q.x, Q.y, 0);
            local Q = (h(G.x, G.y, 0) - R) / k;
            local w = (h(V.x, V.y, 0) - R):length();
            local V = {};
            for g = 1, k do
                local k = R + (Q * g);
                if k:length() < w then
                    table.insert(V, h(k.x, k.y, G.z));
                end
            end
            return V;
        end
        local function G(Q, k)
            local V = entity.get_local_player();
            if not V then
                return nil, 1;
            end
            local R = {V};
            for V, V in ipairs(entity.get_players(false)) do
                if not entity.is_enemy(V) then
                    table.insert(R, V);
                end
            end
            local V = k.z;
            local w = h(k.x, k.y, V);
            local g = h(Q.x, Q.y, V);
            local Q = l.line(w, g, {
                skip = R
            });
            local l = Q.fraction;
            local Q = w + ((g - w) * l);
            return h(Q.x, Q.y, k.z), l;
        end
        local function l(Q, k)
            local V = {};
            if (not Q) or (not k) then
                return V;
            end
            local R = {};
            for w = 1, 3 do
                local g = 20 * w;
                local w = n(g, 2, Q, k);
                for n, n in ipairs(w) do
                    table.insert(R, n);
                end
            end
            for n, n in pairs(R) do
                local k, R = G(n, Q);
                if k then
                    table.insert(V, {
                        endpos = k,
                        ideal = n,
                        fraction = R
                    });
                end
            end
            return V;
        end
        local function n(G, Q)
            local k = {};
            for V, V in pairs(G) do
                table.insert(k, V.endpos);
                for G, G in pairs(z(V.ideal, Q, 2, V.endpos)) do
                    table.insert(k, G);
                end
            end
            return k;
        end
        local function z()
            local G = {};
            local Q = {
                Head = 0,
                Chest = 5,
                Stomach = 3,
                Arms = {13, 14, 15, 16, 17, 18},
                Legs = {7, 8, 9, 10},
                Feet = {11, 12}
            };
            if c.rage.aimbot.force_body:get() then
                if c.rage.aimbot.target_hitbox:get("Chest") then
                    table.insert(G, Q.Chest);
                end
                if c.rage.aimbot.target_hitbox:get("Stomach") then
                    table.insert(G, Q.Stomach);
                end
            else
                if c.rage.aimbot.target_hitbox:get("Head") then
                    table.insert(G, Q.Head);
                end
                if c.rage.aimbot.target_hitbox:get("Chest") then
                    table.insert(G, Q.Chest);
                end
                if c.rage.aimbot.target_hitbox:get("Stomach") then
                    table.insert(G, Q.Stomach);
                end
                if c.rage.aimbot.target_hitbox:get("Arms") then
                    for k, k in ipairs(Q.Arms) do
                        table.insert(G, k);
                    end
                end
                if c.rage.aimbot.target_hitbox:get("Legs") then
                    for k, k in ipairs(Q.Legs) do
                        table.insert(G, k);
                    end
                end
                if c.rage.aimbot.target_hitbox:get("Feet") then
                    for k, k in ipairs(Q.Feet) do
                        table.insert(G, k);
                    end
                end
            end
            return G;
        end
        local function G()

            if (ctx.weapon == "Knife" and (knife_peek:get() and r.auto_peek_knife == 0)) or (ctx.weapon == "Taser") then
                return true;
            end
            return false;
        end
        local function Q(k, V)
            local R = entity.get_local_player();
            local w, g, N = entity.get_origin(R);
            local R, R = t(h(w, g, N), V);
            k.in_forward = 1;
            k.in_back = 0;
            k.in_moveleft = 0;
            k.in_moveright = 0;
            k.in_speed = 0;
            k.forwardmove = 450;
            k.sidemove = 0;
            k.move_yaw = R;
        end
        local function t()
            local k = entity.get_local_player();
            if (not k) or (not entity.is_alive(k)) then
                return;
            end
            local V, R, w = entity.get_origin(k);
            table.insert(y, h(V, R, w));
            if #y > 20 then
                table.remove(y, 1);
            end
            local k, V = client.camera_angles();
            table.insert(P, h(k, V, 0));
            if #P > 20 then
                table.remove(P, 1);
            end
        end
        local function P()
            if (not J.is_active) or (not J.anchor_vec) then
                return nil;
            end
            local k = entity.get_local_player();
            if not k then
                return nil;
            end
            local V, R, w = entity.get_origin(k);
            local k = h(V, R, w);
            local V = J.anchor_vec;
            local R = J.max_peek_distance;
            local w = k:dist(V);
            if w <= R then
                return k;
            else
                local w = (k - V):normalized();
                return V + (w * R);
            end
        end
        local function k(V)
            local R = entity.get_local_player();
            t();
            if (not R) or (not entity.is_alive(R)) or (not Y:get()) or G() then
                if J.is_active then
                    J.is_active = false;
                    u = false;
                    M = nil;
                    o = false;
                    c.rage.other.quick_peek_assist_mode[1]:override();
                    e.restore(c.rage.other.quick_peek[1], "auto_peek");
                end
                return;
            end
            if Y.hotkey:get() then
                if not J.is_active then
                    J.is_active = true;
                    o = false;

                    e.force(c.rage.other.quick_peek[1], "auto_peek");
                    local t = (H(R) and 0) or 13;
                    local G = math.max(1, #y - t);
                    if #y > 0 then
                        J.anchor_vec = y[G];
                    else
                        local y, t, G = entity.get_origin(R);
                        J.anchor_vec = h(y, t, G);
                    end
                    local y, t, G = entity.get_origin(R);
                    local w = h(y, t, G);
                    J.max_peek_distance = J.anchor_vec:dist(w);
                    local y, t = client.camera_angles();
                    J.start_view = h(y, t, 0);
                end
                local y = P();
                if not y then
                    if J.is_active then
                        J.is_active = false;
                        u = false;
                        M = nil;
                        o = false;
                        c.rage.other.quick_peek_assist_mode[1]:override();
                        e.restore(c.rage.other.quick_peek[1], "auto_peek");
                    end
                    return;
                end
                local t = y:clone();
                local G, G, G = entity.get_prop(R, "m_vecViewOffset[2]");
                local w = G or 64;
                t.z = (t.z + w) - 4;
                local G = l(t, J.start_view);
                local w = n(G, t);
                local t = z();
                local z = {};
                local n = {client.current_threat()};
                if (#n > 0) and (n[1] ~= nil) and y and (#t > 0) then
                    for G, G in pairs(w) do
                        for w, w in pairs(n) do
                            if w and (not entity.is_dormant(w)) and (not j(w)) then
                                for j, j in pairs(t) do
                                    local t, n, g = entity.hitbox_position(w, j);
                                    if t then
                                        local j, N, B = _(w, 0, t, n, g);
                                        local _, _ = client.trace_bullet(R, G.x, G.y, G.z, j, N, B);
                                        if _ and ((_ >= f) or (_ >= entity.get_prop(w, "m_iHealth"))) then
                                            table.insert(z, {
                                                vec = G,
                                                enemy_vec = h(j, N, B),
                                                damage = _,
                                                target = w
                                            });
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if #z > 0 then
                    table.sort(z, function(_, j)
                        return _.vec:dist(y) < j.vec:dist(y);
                    end);
                    u = true;
                    M = z[1];
                else
                    u = false;
                    M = nil;
                end
                if u and (not H(R)) and M then
                    X = true;
                    o = (V.in_forward ~= 0) or (V.in_back ~= 0) or (V.in_moveleft ~= 0) or (V.in_moveright ~= 0);
                    local _ = entity.get_player_weapon(R);
                    if not _ then
                        return;
                    end
                    local H = entity.get_prop(_, "m_flNextPrimaryAttack") or 0;
                    local _ = entity.get_prop(R, "m_flNextAttack") or 0;
                    local j = globals.curtime();
                    local y = (j >= H) and (j >= _);
                    local _ = ctx:get_exploit();
                    if y and _ and (not o) then
                        Q(V, M.vec);
                        c.rage.other.quick_peek_assist_mode[1]:override();
                    end
                else
                    local _, H, j = entity.get_origin(R);
                    local y = h(_, H, j);
                    local _ = y:dist(J.anchor_vec);
                    if (_ > 5) and X then
                        c.rage.other.quick_peek_assist_mode[1]:override({"Retreat on shot", "Retreat on key release"});
                    else
                        c.rage.other.quick_peek_assist_mode[1]:override();
                    end
                end
            elseif J.is_active then
                J.is_active = false;
                J.anchor_vec = nil;
                J.start_view = nil;
                J.max_peek_distance = 0;
                u = false;
                M = nil;
                o = false;
                X = false;
                c.rage.other.quick_peek_assist_mode[1]:override();
                e.restore(c.rage.other.quick_peek[1], "auto_peek");
            end
        end
        local function _()
            b();
            C = globals.realtime() * 2;
            local e = (math.cos(C * 2) + 1) / 2;
            i = math.floor(T(0, 255, e));
            if (not Y:get()) or (not J.is_active) then
                return;
            end
            local C = entity.get_local_player();
            if (not C) or (not entity.is_alive(C)) then
                return;
            end

            local e = P();
            if not e then
                return;
            end
            local H;
            H = J.start_view;
            if not H then
                return;
            end
            local j = e:clone();
            local e, e, e = entity.get_prop(C, "m_vecViewOffset[2]");
            local C = e or 64;
            j.z = (j.z + C) - 4;
            local C, e, T = Menu.settings.visuals.accent:get();
            l(j, H);
            if u and M then
                local l = M.vec;
                local H = M.enemy_vec;
                local j = M.damage;
                L(l.x, l.y, l.z, H.x, H.y, H.z, C, e, T, 200);
                local l = renderer.world_to_screen(H:unpack());
                if l then
                    K(H.x, H.y, H.z, 10, C, e, T, i, 4);
                end
            end
        end
        do
            local function C(i)
                local l = Menu.toggle:get() and i:get();
                if l then
                    client.set_event_callback("paint", _);
                    client.set_event_callback("setup_command", k);
                else
                    client.unset_event_callback("paint", _);
                    client.unset_event_callback("setup_command", k);
                end
            end
            Y:set_callback(C, true);
        end
        do
            local function Cdebug(i)
                local l = Menu.toggle:get() and peek_debug:get() and Y:get();
                if l then
                    client.set_event_callback("paint", r.debug_peek_points_paint);
                else
                    client.unset_event_callback("paint", r.debug_peek_points_paint);
                end
            end
            Y:set_callback(Cdebug, true);
            peek_debug:set_callback(Cdebug, true);
        end
    end
end
local Y = {};
do
    local function C(i, l, _, e)
        return ((_ * i) / e) + l;
    end
    local function i()
        return globals.frametime();
    end
    local function l(_, e, H, j, T)
        if j <= 0 then
            return H;
        end
        if j >= T then
            return H;
        end
        e = _(j, e, H - e, T);
        if type(e) == "number" then
            if math.abs(H - e) < 0.001 then
                return H;
            end
            local _ = e % 1;
            if _ < 0.001 then
                return math.floor(e);
            end
            if _ > 0.999 then
                return math.ceil(e);
            end
        end
        return e;
    end
    function Y.interp(_, e, H, j)
        j = j or C;
        if type(e) == "boolean" then
            e = (e and 1) or 0;
        end
        return l(j, _, e, i(), H);
    end
end

do 




local function make_block(def)
    return {
        id              = def.id,
        visible_fn      = def.visible_fn,
        value_fn        = def.value_fn,
        measure_fn      = def.measure_fn,
        render_fn       = def.render_fn,
        no_shrink_delay = def.no_shrink_delay or false,
        alpha           = 0.0,
        width           = 0.0,
        target_w        = 0.0,
        visible         = false,
    }
end


local function update_metrics()
    local now = globals.realtime()

    if now - watermark_cache.last_update < 0.5 then
        return 
    end

    watermark_cache.last_update = now
    watermark_cache.var = get_var()
    watermark_cache.ping, watermark_cache.ping_spike = get_ping()
    watermark_cache.loss = get_loss()

    local raw_fps = 1 / globals.frametime()
    watermark_cache.fps = clamp(watermark_cache.fps * 0.7 + raw_fps * 0.3, 0, 6107)
end

local function build_context()
    update_metrics()

    local lp = entity.get_local_player()
    local uname = "unknown"

    if lp then
        local ok, name = pcall(entity.get_player_name, lp)
        if ok and name and name ~= "" then
            uname = name
        end
    end

    local h, ffi = client.system_time()
    local time_str = string.format("%02d:%02d", h, ffi)

    watermark_cache.timeout.duration = get_timeout()
    watermark_cache.uname = uname
    watermark_cache.time_str = time_str
    return {
        uname      = watermark_cache.uname,
        time_str   = watermark_cache.time_str,

        ping       = watermark_cache.ping,
        ping_spike = watermark_cache.ping_spike,

        fps        = math.floor(watermark_cache.fps + 0.5),
        loss       = watermark_cache.loss,
        timeout    = watermark_cache.timeout.duration,
        var        = watermark_cache.var,

        menu_open  = ui.is_menu_open(),

        branding = Menu.settings.visuals.watermark.branding_mode:get() == "Full"
                    and (U.name .. " " .. U.build)
                    or U.name,
        tc         = {215, 218, 224},
        lc         = {185, 188, 195},
        accent     = {Menu.settings.visuals.accent:get()},
    }
end

local function init_blocks()
    state.blocks = {
        avatar = make_block({
            id = "avatar",
            visible_fn = function(ctx)
                return Menu.settings.visuals.watermark.avatar:get()
            end,
            measure_fn = function(ctx)
                local AV   = 30
                local BGAP = 12
                return AV + BGAP
            end,
            render_fn = function(ctx, x, y, w, h, alpha)
                if alpha <= 0.01 then return end
                local AV = 30
                local ay = y + math.floor((h - AV) / 2)
                local a255 = math.floor(255 * alpha)
                local av_t = tex.avatar or tex.default_avatar
                draw_avatar(av_t, x, ay, AV, a255)
            end,
        }),
        branding = make_block({
            id = "branding",
            no_shrink_delay = true,
        
            visible_fn = function(ctx)
                return true
            end,
        
            measure_fn = function(ctx)
                return text_w(ctx.branding) + 12
            end,
        
            render_fn = function(ctx, x, y, w, h, alpha)
                local a255 = math.floor(alpha * 255)
            
                local ty =
                    y +
                    math.floor(
                        (h - renderer.measure_text("b", "0")) / 2
                    ) - 3
                
                render_text(
                    x,
                    ty,
                    ctx.accent[1],
                    ctx.accent[2],
                    ctx.accent[3],
                    a255,
                    ctx.branding
                )
            end
        }),

        username = make_block({
            id = "username",
            visible_fn = function(ctx)
                return Menu.settings.visuals.watermark.username:get()
            end,
            measure_fn = function(ctx)
                local ICO = 14
                local IGAP = 4
                local BGAP = 12
                return ICO + IGAP + text_w(ctx.uname) + BGAP
            end,
            render_fn = function(ctx, x, y, w, h, alpha)
                if alpha <= 0.01 then return end
                local ICO = 14
                local IGAP = 4
                local a255  = math.floor(255 * alpha)
                local ay    = y + math.floor((h - ICO) / 2)
                local ty    = y + math.floor((h - renderer.measure_text("b", "0")) / 2) - 3

                if tex.user then
                    renderer.texture(tex.user, x, ay, ICO, ICO, ctx.accent[1], ctx.accent[2], ctx.accent[3], a255,"b", "f")
                end
                render_text(x + ICO + IGAP, ty, ctx.tc[1], ctx.tc[2], ctx.tc[3], a255, ctx.uname)
            end,
        }),

        clock = make_block({
            id = "clock",
            visible_fn = function(ctx)
                return Menu.settings.visuals.watermark.clock:get()
            end,
            measure_fn = function(ctx)
                local ICO = 14
                local IGAP = 4
                local BGAP = 12
                return ICO + IGAP + text_w(ctx.time_str) + BGAP
            end,
            render_fn = function(ctx, x, y, w, h, alpha)
                if alpha <= 0.01 then return end
                local ICO = 14
                local IGAP = 4
                local a255  = math.floor(255 * alpha)
                local ay    = y + math.floor((h - ICO) / 2)
                local ty    = y + math.floor((h - renderer.measure_text("b","0")) / 2) - 3

                if tex.clock then
                    renderer.texture(tex.clock, x, ay, ICO, ICO, ctx.accent[1], ctx.accent[2], ctx.accent[3], a255,"b", "f")
                end
                render_text(x + ICO + IGAP, ty, ctx.tc[1], ctx.tc[2], ctx.tc[3], a255, ctx.time_str)
            end,
        }),

        fps = make_block({
            id = "fps",
            visible_fn = function(ctx)
                return Menu.settings.visuals.watermark.fps:get()
            end,
            measure_fn = function(ctx)
                local ICO = 14
                local IGAP = 4
                local LGAP = 3
                local BGAP = 12
                return ICO + IGAP + text_w(tostring(ctx.fps)) + LGAP + text_w("FPS") + BGAP
            end,
            render_fn = function(ctx, x, y, w, h, alpha)
                if alpha <= 0.01 then return end
                local ICO = 14
                local IGAP = 4
                local LGAP = 3
                local BGAP = 12
                local a255  = math.floor(255 * alpha)
                local ay    = y + math.floor((h - ICO) / 2)
                local ty    = y + math.floor((h - renderer.measure_text("b", "0")) / 2) - 3
                if tex.fps then
                    renderer.texture(tex.fps, x, ay, ICO, ICO, ctx.accent[1], ctx.accent[2], ctx.accent[3], a255, "f")
                end
                render_text(x + ICO + IGAP, ty, ctx.tc[1], ctx.tc[2], ctx.tc[3], a255, tostring(ctx.fps))
                render_text(x + w - BGAP - text_w("FPS"), ty, ctx.lc[1], ctx.lc[2], ctx.lc[3], a255, "FPS")
            end,
        }),

        ping = make_block({
            id = "ping",
            visible_fn = function(ctx)
                return Menu.settings.visuals.watermark.ping:get()
            end,
            measure_fn = function(ctx)
                local ICO = 14
                local IGAP = 4
                local LGAP = 3
                local BGAP = 12
                return ICO + IGAP + text_w(tostring(ctx.ping)) + LGAP + 
                (Menu.settings.visuals.watermark.show_ping_spike:get() and text_w("("..tostring(ctx.ping_spike)..")") or 0)
                 + text_w( "MS") + BGAP
            end,
            render_fn = function(ctx, x, y, w, h, alpha)
                if alpha <= 0.01 then return end
                local ICO = 14
                local IGAP = 4
                local BGAP = 12
                local a255  = math.floor(255 * alpha)
                local ay    = y + math.floor((h - ICO) / 2)
                local ty    = y + math.floor((h - renderer.measure_text("b", "0")) / 2) - 3
                if tex.ping then
                    renderer.texture(tex.ping, x, ay, ICO, ICO, ctx.accent[1], ctx.accent[2], ctx.accent[3], a255, "f")
                end
                local text = tostring(ctx.ping)
                if Menu.settings.visuals.watermark.show_ping_spike:get() then
                    text = tostring(ctx.ping) .. "("..tostring(ctx.ping_spike)..")"
                end
                render_text(x + ICO + IGAP, ty, ctx.tc[1], ctx.tc[2], ctx.tc[3], a255, text)
                render_text(x + w - BGAP - text_w("MS"), ty, ctx.lc[1], ctx.lc[2], ctx.lc[3], a255, "MS")
            end,
        }),

        loss = make_block({
            id = "loss",
            visible_fn = function(ctx)
                if not Menu.settings.visuals.watermark.loss:get() then
                    state.loss_hide_timer = nil
                    state.loss_was_bad = false
                    return false
                end
                if ctx.loss > 0 then
                    state.loss_was_bad = true
                    state.loss_hide_timer = nil
                    return true
                end
                if ctx.menu_open then
                    return true
                end
                if not state.loss_was_bad then
                    return false
                end
                if state.loss_hide_timer == nil then
                    state.loss_hide_timer = globals.realtime()
                end
                if (globals.realtime() - state.loss_hide_timer) < state.HIDE_DELAY then
                    return true
                end
                state.loss_was_bad = false
                return false
            end,
            measure_fn = function(ctx)
                local ICO = 15
                local IGAP = 4
                local LGAP = 3
                local BGAP = 12
                local val = tostring(ctx.loss) .. "%"
                return ICO + IGAP + text_w(val) + LGAP + text_w("LOSS") + BGAP
            end,
            render_fn = function(ctx, x, y, w, h, alpha)
                if alpha <= 0.01 then return end
                local ICO = 14
                local IGAP = 4
                local BGAP = 12
                local a255  = math.floor(255 * alpha)
                local ay    = y + math.floor((h - ICO) / 2)
                local ty    = y + math.floor((h - renderer.measure_text("b", "0")) / 2) - 3
                local val   = tostring(ctx.loss) .. "%"
                local ls_r, ls_g, ls_b = ctx.tc[1], ctx.tc[2], ctx.tc[3]
                if ctx.loss > 0 then
                    ls_r, ls_g, ls_b = 220, 60, 60
                end
                if tex.loss then
                    renderer.texture(tex.loss, x, ay, ICO, ICO, ctx.accent[1], ctx.accent[2], ctx.accent[3], a255, "f")
                end
                render_text(x + ICO + IGAP, ty, ls_r, ls_g, ls_b, a255, val)
                render_text(x + w - BGAP - text_w("LOSS"), ty, ls_r, ls_g, ls_b, a255, "LOSS")
            end,
        }),

        timeout = make_block({
            id = "timeout",
            visible_fn = function(ctx)
                if not Menu.settings.visuals.watermark.timeout:get() then
                    state.timeout_hide_timer = nil
                    state.timeout_was_bad = false
                    return false
                end
                if ctx.timeout and ctx.timeout > 0 then
                    state.timeout_was_bad = true
                    state.timeout_hide_timer = nil
                    return true
                end
                
                if ctx.menu_open then
                    return true
                end
                if not state.timeout_was_bad then
                    return false
                end
                if state.timeout_hide_timer == nil then
                    state.timeout_hide_timer = globals.realtime()
                end
                if (globals.realtime() - state.timeout_hide_timer) < state.HIDE_DELAY then
                    return true
                end
                state.timeout_was_bad = false
                return false
            end,
            measure_fn = function(ctx)
                local ICO = 13
                local IGAP = 4
                local LGAP = 3
                local BGAP = 12
                local val = string.format("%.1fs", ctx.timeout)
                return ICO + IGAP + text_w(val) + LGAP + text_w("TIMEOUT") + BGAP
            end,
            render_fn = function(ctx, x, y, w, h, alpha)
                if alpha <= 0.01 then return end
                local ICO = 13
                local IGAP = 4
                local BGAP = 12
                local a255  = math.floor(255 * alpha)
                local ay    = y + math.floor((h - ICO) / 2) + 1
                local ty    = y + math.floor((h - renderer.measure_text("b", "0")) / 2) - 3
                local val   = string.format("%.1fs", ctx.timeout)
                if tex.empty then
                    renderer.texture(tex.empty, x, ay, ICO, ICO, ctx.accent[1], ctx.accent[2], ctx.accent[3], a255, "f")
                end
                local to_r, to_g, to_b = ctx.tc[1], ctx.tc[2], ctx.tc[3]
                if ctx.timeout > 5 then
                    to_r, to_g, to_b = 220, 60, 60
                elseif ctx.timeout > 0.1 then
                    to_r, to_g, to_b = 220, 180, 60
                end
                render_text(x + ICO + IGAP, ty, to_r, to_g, to_b, a255, val)
                render_text(x + w - BGAP - text_w("TIMEOUT"), ty, to_r, to_g, to_b, a255, "TIMEOUT")
            end,
        }),

        
        var = make_block({
            id = "var",
            visible_fn = function(ctx)
                if not Menu.settings.visuals.watermark.var:get() then
                    state.var_hide_timer = nil
                    state.var_was_bad = false
                    return false
                end
                if ctx.var and ctx.var >= 3 and Menu.settings.visuals.watermark.var_bad_req:get() then
                    state.var_was_bad = true
                    state.var_hide_timer = nil
                    return true
                end
                if ctx.menu_open then
                    return true
                end
                if not state.var_was_bad then
                    return false
                end
                if state.var_hide_timer == nil then
                    state.var_hide_timer = globals.realtime()
                end
                if (globals.realtime() - state.var_hide_timer) < state.HIDE_DELAY then
                    return true
                end
                state.var_was_bad = false
                return true
                
            end,
            measure_fn = function(ctx)
                local ICO = 16
                local IGAP = 4
                local LGAP = 3
                local BGAP = 12
                local val = string.format("%.0f", ctx.var)
                return ICO + IGAP + text_w(val) + LGAP + text_w("VAR") + BGAP
            end,
            render_fn = function(ctx, x, y, w, h, alpha)
                if alpha <= 0.01 then return end
                local ICO = 16
                local IGAP = 4
                local BGAP = 12
                local a255  = math.floor(255 * alpha)
                local ay    = y + math.floor((h - ICO) / 2)
                local ty    = y + math.floor((h - renderer.measure_text("b", "0")) / 2) - 3
                local val   = string.format("%.0f", ctx.var)
                if tex.sqrt then
                    renderer.texture(tex.sqrt, x, ay, ICO, ICO, ctx.accent[1], ctx.accent[2], ctx.accent[3], a255, "f")
                end
                local var_r, var_g, var_b = ctx.tc[1], ctx.tc[2], ctx.tc[3]
                if ctx.var >= 5 then
                    var_r, var_g, var_b = 220, 60, 60
                elseif ctx.var >= 3 then
                    var_r, var_g, var_b = 220, 180, 60
                end
                render_text(x + ICO + IGAP, ty, var_r, var_g, var_b, a255, val)
                render_text(x + w - BGAP - text_w("VAR"), ty, var_r, var_g, var_b, a255, "VAR")
            end,
        }),
    }

    for id, block in pairs(state.blocks) do
        block.alpha              = 0.0
        block.width              = 0.0
        block.target_w           = 0.0
        block.held_target_w      = 0.0
        block.block_shrink_start = nil
        block.visible            = false
    end
end

init_blocks()

function visuals_things.draw_watermark()
    if not Menu.settings.visuals.watermark.enabled:get() then
        state.master_alpha = lerp(state.master_alpha, 0.0, 0.18)
        if state.master_alpha < 0.01 then
            return
        end
    else
        state.master_alpha = lerp(state.master_alpha, 1.0, 0.18)
    end

    local sw, sh = client.screen_size()
    local now = client.timestamp() / 1000.0
    local dt = 0.016

    if state.last_t ~= nil then
        dt = now - state.last_t
        if dt <= 0 then dt = 0.016 end
        if dt > 0.1 then dt = 0.1 end
    end
    state.last_t = now

    local ctx = build_context()

    local branding_changed = state.last_branding_text ~= nil and state.last_branding_text ~= ctx.branding
    state.last_branding_text = ctx.branding

    local H    = 40
    local PAD  = 12
    local GAP  = 0

    local total_dynamic_w = 0
    local block_measure_cache = {}

    for id, block in pairs(state.blocks) do
        local visible = block.visible_fn(ctx) and state.master_alpha > 0.01
        block.visible = visible

        local target = 0.0
        if visible then
            local full_w = block.measure_fn(ctx)
            block_measure_cache[id] = full_w
            target = full_w * state.master_alpha
        else
            block_measure_cache[id] = block_measure_cache[id] or 0
            target = 0.0
        end

        block.alpha = lerp(block.alpha, visible and state.master_alpha or 0.0, math.min(12.0 * dt, 1))

        if not visible then
            block.held_target_w = 0.0
            block.block_shrink_start = nil
        elseif block.no_shrink_delay then
            block.held_target_w = target
            block.block_shrink_start = nil
        else
            if target >= (block.held_target_w or 0.0) then
                block.held_target_w = target
                block.block_shrink_start = nil
            elseif not block.block_shrink_start then
                block.block_shrink_start = now
            elseif (now - block.block_shrink_start) >= state.SHRINK_DELAY then
                block.held_target_w = target
                block.block_shrink_start = nil
            end
        end

        block.target_w = block.held_target_w or 0.0
        block.width = lerp(block.width, block.target_w, math.min(14.0 * dt, 1))

        if block.width < 0.5 then
            block.width = 0.0
        end

        total_dynamic_w = total_dynamic_w + block.width
    end

    local avatar_block = state.blocks.avatar
    local avatar_w = avatar_block.width

    local total_w = PAD * 2 + avatar_w
    for _, id in ipairs(state.order) do
        local block = state.blocks[id]
        if block then
            total_w = total_w + GAP + block.width
        end
    end

    total_w = math.max(math.floor(total_w + 0.5), PAD * 2)

    local any_newly_hidden = false
    if state.prev_block_visible then
        for id, block in pairs(state.blocks) do
            if state.prev_block_visible[id] == true and not block.visible then
                any_newly_hidden = true
            end
        end
    end
    if not state.prev_block_visible then state.prev_block_visible = {} end
    for id, block in pairs(state.blocks) do
        state.prev_block_visible[id] = block.visible
    end

    local menu_vis_count = 0
    if Menu.settings.visuals.watermark.avatar:get()   then menu_vis_count = menu_vis_count + 1 end
    if Menu.settings.visuals.watermark.username:get() then menu_vis_count = menu_vis_count + 1 end
    if Menu.settings.visuals.watermark.clock:get()    then menu_vis_count = menu_vis_count + 1 end
    if Menu.settings.visuals.watermark.fps:get()      then menu_vis_count = menu_vis_count + 1 end
    if Menu.settings.visuals.watermark.ping:get()     then menu_vis_count = menu_vis_count + 1 end
    if Menu.settings.visuals.watermark.var:get()      then menu_vis_count = menu_vis_count + 1 end
    if Menu.settings.visuals.watermark.loss:get()     then menu_vis_count = menu_vis_count + 1 end
    if Menu.settings.visuals.watermark.timeout:get()  then menu_vis_count = menu_vis_count + 1 end
    local toggle_detected = state.last_vis_count ~= menu_vis_count
    if toggle_detected then state.last_vis_count = menu_vis_count end
    state.last_branding_text = state.last_branding_text or nil

    if toggle_detected or any_newly_hidden or branding_changed then
        state.releasing = true
        state.release_start = now
        state.shrink_start = nil
    end

    if state.releasing then
        if total_w > state.held_w + 2 then
            state.releasing = false
            state.release_start = nil
            state.held_w = total_w
            state.shrink_start = nil
        else
            state.held_w = total_w
            if state.release_start and (now - state.release_start) > 1.0 then
                state.releasing = false
                state.release_start = nil
            end
        end
    else
        if total_w >= state.held_w then
            state.held_w = total_w
            state.shrink_start = nil
        elseif state.shrink_start == nil then
            state.shrink_start = now
        end
        if state.shrink_start ~= nil and (now - state.shrink_start) >= state.SHRINK_DELAY then
            state.shrink_start = nil
            state.releasing = true
            state.release_start = now
        end
    end

    total_w = state.held_w
    local x, y

    if Menu.settings.visuals.watermark.position:get() == "Top right" then
        x = sw - 10 - total_w
        y = 10
    else
        x = math.floor((sw - total_w) * 0.5)
        y = sh - H - 5
    end

    local bg_alpha = math.floor(150 * state.master_alpha)
    if bg_alpha > 0 then
        draw_bg(x, y, total_w - 15, H)
    end

    local accent = ctx.accent
    
    local tc = ctx.tc
    local lc = ctx.lc

    local cy = y + math.floor((H - 14) / 2)
    local ty = y + math.floor((H - renderer.measure_text("b", "0")) / 2)

    local cursor = x + total_w - PAD

    if avatar_block.width > 0.5 then
        local w = avatar_block.width
        local bx = cursor - w
        avatar_block.render_fn(ctx, bx, y, w, H, avatar_block.alpha)
        cursor = bx 
    else
        cursor = cursor
    end

    for _, id in ipairs(state.order) do
        local block = state.blocks[id]
        if block and block.width > 0.5 then
            local w = block.width
            local bx = cursor - w
            block.render_fn(ctx, bx, y, w, H, block.alpha)
            cursor = bx - GAP
        else
            cursor = cursor - GAP
        end
    end
end
end
do
local killer = 0
local pending = {}
local OSK_WORDS = {
    "ебанат", "криворукий", "слоупок", "школьник","долбаёб", "тормоз", "слоумо", "бездарность", "нищий", "авария", "везучий", "пидорас", "хуесос", "еблан", "еблана кусок", "кусок еблана"
}

local LAUGH_LETTERS = {"Х", "А", "П", "В"} 
local LAST_SENT_AT = -math.huge
local MIN_SEND_INTERVAL = 1.5
local FIRST_PHRASE_EXTRA_DELAY_MS = 700
local filett = "ember_tt.csv"
local csv = "bW9kZSx0eXBlLGNvbmRpdGlvbix3ZWlnaHQscGhyYXNlMSxwaHJhc2UyLHBocmFzZTMsdGltZTEsdGltZTIsdGltZTMKMCxraWxsLG5pbCw2MCwxLG5pbCxuaWwsMjY1LG5pbCxuaWwKMCxraWxsLG5pbCwxMCxodHRwczovL2ZhdGFsaXR5Lndpbi8/aW52aXRhdGlvbj1mdWNrdXV1dXUs0YfRkSDQtNGD0LzQsNC7INGC0LXQsdC1INCx0LjRh9GDINC40L3QstCw0LnRgj8s0YXRg9C5INGC0LXQsdC1INCyINGA0L7RgiDRjdGC0L4g0LzQsNC60YHQuNC80YPQvCwyMDAsMzAwLDQwMAowLGtpbGwsbmlsLDcwLNCR0LvRjyDQtdCx0LDRgtGMINGC0Ysg0L/QvtC80YPQstCw0LvRgdGPINC00L7Qu9Cx0L7RkdCxLNC40LTQuCDQsiDRgNC+0LHQu9C+0LrRgSDQuNCz0YDQsNC5INGF0YPQudC90Y8s0L3RgyDQuNC70Lgg0L3QsNGF0YPQuS4g0LzQsNGC0Ywg0YLQstC+0Y8g0LfQvdCw0LXRgiDQtNC+0YDQvtCz0YMsMzAwLDQwMCw1MDAKMCxraWxsLG5pbCwzMCwxLG5pY2UgaXEsbmlsLDE0MCwzNjUsbmlsCjAsa2lsbCxuaWwsMjAsMSzRhdC+0YDQvtGI0L4g0L7RgtGL0LPRgNCw0LssbmlsLDY2LDYzMCxuaWwKMCxraWxsLG5pbCw1MCzQotGLINC40LPRgNC+0Lo/LNCg0LXQsNC70YzQvdC+INGC0LDQuiDQtNGD0LzQsNC10YjRjD8s0J/QvtC20LXQu9C10Lkg0YHQstC+0Y4g0LzQsNGC0YwuINCo0LvRjtGF0YMsMjAwLDQwMCw0MDAKMCxraWxsLG5pbCw1MCwx0YUxINC70LXRgtC4PyzQndCwIDUwMCQsQmVyc2VyazEzMzMuINCw0LTQtNCw0Lkg0LHQuNGH0YwsMjAwLDEwMCwzMDAKMCxraWxsLG5pbCw3NSzQo9C80YDQuCxuaWwsbmlsLDEwMCxuaWwsbmlsCjAsa2lsbCxuaWwsNTAsKkRFQUQqW3BsYXllcl0g0K8g0LzQsNGC0LXRgNC4INGB0LLQvtC10Lkg0LrQu9C40YLQvtGAINC70LjQt9Cw0Lss0KLRiyDRh9GRINC/0LjRiNC10YjRjCDQtNCw0YPQvT8s0L7Rh9C60LDRgdGC0YvQuSDRhdGD0LXRgdC+0YEsMjUwLDIwMCwyMDAKMCxraWxsLG5pbCw2MCwqREVBRCpbcGxheWVyXSDQuNC00Lgg0L/QvtC40LPRgNCw0Lkg0LIg0LrRgTIs0YLQtdCx0LUg0YLQsNC8INC70LXQs9GH0LUg0LHRg9C00LXRgiwg0L/QuNC00L7RgCwyMDAsMzAwLDQwMAowLGtpbGwsbmlsLDUwLGV6LDEsbmlsLDEwMCwyNjAsbmlsCjAsa2lsbCxuaWwsNDAsMSxbb3NrXSxuaWwsMjYwLDQwMCxuaWwKMCxraWxsLHRhc2VyLDQwLDEs0LfQtdCy0YHQtdC0LFtvc2tdLDY1LDAsNTAwCjAsa2lsbCx0YXNlciw2MCxleltzbWlsZV0sbmlsLG5pbCwyNDAsbmlsLG5pbAowLGtpbGwsdGFzZXIsNjAs0J7Qv9CwINGH0ZEg0YEg0LXQsdCw0LvQvtC8PyzQvNCw0YLRjCDRgtCy0L7RjiDRgtCw0LHQvtGA0L7QvCDQtdCx0LvQuCxFWkUg0LfQtdCy0YHQtdC0INC/0LjQtNC+0YDQsNGBINC60LDRgNGC0LDQstGL0LksNDAwLDUwMCw2MDAKMCxraWxsLGtuaWZlLDYwLGlxIGlzc3VlLFtvc2tdLG5pbCwzMDAsMjAwLDU2MAowLGtpbGwsa25pZmUsMzAs0JrQvdCw0LnRhNC10LQg0YXQvtGF0LvRj9GG0LrQsNGPINGI0LvRjtGF0LAs0L/QvtGH0LXQvNGDINGC0Ysg0L7RgiDQvdC+0LbQsCDQvdC1INGB0LzQvtCzINGB0L/QsNGB0YLQuNGB0Yw/LNCR0LjRh9GMINC10LHRg9GH0LjQuSwzMDAsNjAwLDI1MAowLGtpbGwsa25pZmUsNjAs0L3QsCDQvdC+0LbQtVtzbWlsZV0sMSxuaWwsMzAwLDUwMCxuaWwKMCxkZWF0aCxuaWwsMCwpW3NtaWxlXSzQutGA0YPRgtC+INC+0YLRi9Cz0YDQsNC7LNCh0YvQvSDRiNC70Y7RhdC4LDM2MCw1MjAsNTUwCjAsZGVhdGgsbmlsLDAs0LrRgNCw0YHQsNCy0LAs0L/QviBpcSzQvNC+0LvQvtC00LXRhiw0ODAsNDYwLDUwMAowLGRlYXRoLG5pbCwwLNC90YMg0L3QtdGCLNCy0LXQt9GD0YfQuNC5LFtvc2tdLDQ5OSw1MjAsNTgwCjAsZGVhdGgsbmlsLDAs0L3RgyDQutC+0L3QtdGH0L3QvltzbWlsZV0sbmlsLG5pbCw2MjAsbmlsLG5pbAowLGRlYXRoLG5pbCwwLFtsYXVnaF0sW3NtaWxlXSxuaWwsNTgwLDU2MCxuaWwKMCxkZWF0aCxuaWwsMCzRh9C40LzQtdGA0LAg0Y7Qt9C10YAg0LLQuNC00L3QviDRgdGA0LDQt9GDLNChINC60YDRj9C60L7QvCzQpdGD0ZHQstGL0LksNDAwLDIwMCwxNTAKMCxkZWF0aCxuaWwsMCzQvNC+0LfQs9CwINC90LXRgizQt9Cw0YLQviDQstC10LfRg9GH0LjQuVtzbWlsZV0sbmlsLDUwMCw1NDAsbmlsCjAscmV2ZW5nZSxuaWwsMCxbc21pbGVdLNCY0LPRgNC+0LosbmlsLDEyMCwxODAsbmlsCjAscmV2ZW5nZSxuaWwsMCxbc21pbGVdLNCa0YDQsNGB0LDQstCwINC+0YLRi9Cz0YDQsNC7LG5pbCwzMDAsNDAwLG5pbAowLHJldmVuZ2UsbmlsLAowLHJldmVuZ2UsbmlsLAowLHJldmVuZ2UsbmlsLAowLHJldmVuZ2UsbmlsLAowLHJldmVuZ2UsbmlsLAoxLGtpbGwsbmlsLDYwLEdFVCBHT09ELEdFVCBFbWJlcmxhc2guZnVuY2x1c2l2ZSxkaXNjb3JkLmdnL2ZHRnRGQk1kWGEsMjAwLDMwMCwyMDAKMSxraWxsLG5pbCw2MCzQotGLINC40LPRgNC+0Log0L/RgNGP0Lwg0L/QuNC30LTQtdGGLCDQlNCw0LbQtSBaZXNsZXIg0LIg0LDRhdGD0LUsMSwzMDAsNDAwLDEwMAoxLGtpbGwsbmlsLDIwLNCd0LXRgiDQvNC40YLQsCDQvdC1INCx0YDQvtGB0LDQuSDQvNC10L3RjyzQkCDQvtC5INC90LUg0YLQvixFbWJlcmxhc2guZnVuY2x1c2l2ZSDQu9GD0YfRiNC1INC70Y7QsdC+0LLQviwyMDAsMTUwLDMwMAoxLGtpbGwsbmlsLDYwLNCU0JAg0J7QkdCs0K/QktCv0KIg0JfQkCDQndCQ0JzQmCDQntCl0J7QotCjLCDQodCQ0JzQmCDQpNCQ0J3QkNCi0Ksg0J7QoNCY0JPQmNCd0JDQm9Cs0J3QntCT0J4gRU1CRVJMQVNILCDQlNCw0LLQsNC50YLQtSDQvdCw0L/QsNC00LDQudGC0LUg0L/QuNGB0Y7QvdGLIGRpc2NvcmQuZ2cvZkdGdEZCTWRYYSwyMDAsMzAwLDMwMAoxLGtpbGwsbmlsLDIwLNCk0LDQvdCw0YLRiyDQsdC10LzQsdC10YDQu9Cw0YjQsCDQstCw0Lwg0YHRjtC00LAsIC0+IGRpc2NvcmQuZ2cvZkdGdEZCTWRYYSxuaWwsMzAwLDM1MCxuaWwKMSxraWxsLG5pbCwyMCzQnNCY0KLQkNCc0JjQotCQ0JzQmNCi0JDQnNCY0KLQkNCc0JjQotCQ0JzQmNCi0JAs0JHQtdGB0LjRgiDQvdC1INC/0YDQsNCy0LTQsD8s0JAg0LIgRW1iZXJsYXNoLmZ1biDRgtCw0LrQvtCz0L4g0L3QtdGC0YMo0L3RgyDQuNC70Lgg0LXRgdGC0YwpLDEwMCwyMDAsMzAwCjEsa2lsbCxuaWwsNzAs0J3QtdGCINC00LXQvdC10LMg0L3QsCDQvtGA0LjQsyBFbWJlcmxhc2g/LNGC0LDQuiDRgdC60LDRh9Cw0Lkg0LHQtdGB0L/Qu9Cw0YLQvdC+LEVtYmVybGFzaC5mdW4gZGlzY29yZC5nZy9mR0Z0RkJNZFhhKHBlcnNvbmFsIGxlYWspLDIwMCwzMDAsNDAwCjEsa2lsbCxuaWwsNjAs0J3QsNC8INC00LDQu9C4INGB0YPRgNGBINC10LzQsdC10YDQsCzQnNGLINC70LjQutC90YPQu9C4INCwINC/0L7RgtC+0Lwg0YHQtNC10LvQsNC70Lgg0LvRg9GH0YjQtSEs0Jgg0LLRgdGRINGN0YLQviDQsdC10YHQv9C70LDRgtC90L4gKGRpc2NvcmQuZ2cvZkdGdEZCTWRYYSksMjAwLDMwMCwyNTAKMSxraWxsLHRhc2VyLDYwLNCc0LjRgtCwLiDRgtGLINGB0LLQtdGCINC80L7QtdC5INC20LjQt9C90LggKF7ilr1eKSwg0JzQmNCi0JAg0JIg0J/QoNCV0JfQmNCU0JXQndCi0KshLNCSIEVtYmVybGFzaCDQuCDQvdC1INGC0L7Qu9GM0LrQviDRjdGC0L4sMjAwLDMwMCwzNTAKMSxraWxsLHRhc2VyLDYwLNCd0YMg0YLQuNC/0L4gMSzQndGDINGC0Ysg0L/RgNC+0YHRgtC+INCx0LXQtyBFbWJlcmxhc2guZnVuLNCz0LXRgtC90YPRgtGMINC70LXQs9C60L4g0LfQsNGF0L7QtNC4INGB0Y7QtNCwIGRpc2NvcmQuZ2cvZkdGdEZCTWRYYSwyMDAsMjAwLDIwMAoxLGtpbGwsa25pZmUsNjAs0L3QsCDRiNCw0YjQu9GL0LosINC/0L7RgtC+0LzRgyDRh9GC0L4g0LHQtdC3IEVtYmVybGFzaC5mdW4sINCT0LXRgtC90LghINC70YPQsNGI0LrQsCDRhNGA0LjRiNC90LDRjywyMDAsMzAwLDIwMAoxLGtpbGwsa25pZmUsCjEsZGVhdGgsbmlsLDYwLNGPINC90LUg0LzQvtCz0YMg0LIg0YLQtdCx0Y8g0L/QvtC/0LDRgdGC0Yws0YHQtNC10LvQsNC10YjRjCDQvNC90LUg0YLQsNC60LjQtSDQttC1INC/0YDQtdGB0LXRgtC40LrQuD8g0L3QsCBlbWJlcmxhc2guZ3MsINC+0Lkg0L3QsCBFbWJlcmxhc2guZnVuLDIwMCwzMDAsNDAwCjEsZGVhdGgsbmlsLDYwLNCl0YPQtdGB0L7RgSDRjyDQsiDRgtC10LHRjyzQl9C10YDQutCw0LvRjNC90YvQvNC4INGC0LDQv9C60LDQvNC4INCx0LDQsdC60Lgs0JfQsNGF0YPRj9GA0Y4uINCn0LzQviDRgdGD0LrQsCwyMDAsMjAwLDMwMAoxLGRlYXRoLG5pbCw1MCzQvdGDINC00LAs0L/QvtGI0ZHQuyDQvdCw0YXRg9C5LFtvc2tdLDIwMCwzMDAsMTUwCjEsZGVhdGgsbmlsLDMwLNCd0YMg0LzQtdC90Y8g0YLQsNC60L7QuSDQtNCw0YPQvSDRg9Cx0LjQstCw0LXRgizQodGD0LrQsCDQtNCw0LbQtSDQmtC40LfQsNGA0YMg0LIg0LDRhdGD0LUs0YEg0YLQstC+0LXQs9C+INC/0LvQtdC50YHRgtCw0LnQu9CwLDIwMCwyMDAsMzAwCjEsZGVhdGgsbmlsLDQwLNCQ0LPQsCzQoyDRgtC10LHRjyDQsdCw0LHQutCwINC80LXRgNGC0LLQsCzQo9Cx0LvRjtC00L7QugoxLGRlYXRoLG5pbCw1MCxJY2ViZXJnINC40LPRgNCw0LXRgiDQu9GD0YfRiNC1LNGC0LXQsdC1INC/0YDQvtGB0YLQviDQv9C+0LLQtdC30LvQvixbb3NrXSwzMDAsMzAwLDIwMAoxLHJldmVuZ2UsbmlsLDYwLDEsbmlsLG5pbCwxMDAsbmlsLG5pbAoxLHJldmVuZ2UsbmlsLAoxLHJldmVuZ2UsbmlsLAoxLHJldmVuZ2UsbmlsLAoxLHJldmVuZ2UsbmlsLAoxLHJldmVuZ2UsbmlsLAoxLHJldmVuZ2UsbmlsLAo="
local function log(...)
    if not funtazzy then return end
    local parts = {}
    for i = 1, select("#", ...) do
        parts[i] = tostring(select(i, ...))
    end
    print("[trash] <"..globals.curtime() .. ">" .. table.concat(parts, " "))
end


local function split(str, sep)
    local t = {}
    if not str or str == "" then return t end

    for part in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(t, part)
    end

    return t
end

local function is_valid(v)
    return v and v ~= "" and v ~= "nil"
end

local function to_number(v)
    if not is_valid(v) then return nil end
    return tonumber(v)
end

local function count_dense(t)
    local n = 0
    for i = 1, 3 do
        if t[i] ~= nil then n = n + 1 end
    end
    return n
end

local function debug_dump_fields(i, c)
    local parts = {}
    for idx, v in ipairs(c) do
        local last_byte = #v > 0 and string.byte(v, #v) or -1
        table.insert(parts, string.format("c[%d]=%q(len=%d,last_byte=%d)", idx, v, #v, last_byte))
    end
    log("line", i, "fields:", table.concat(parts, " | "))
end

local function load_trash(file)
    log("loading file:", file)

    local raw = readfile(file)

    if not raw or raw == "" then
        log("ERROR: readfile returned empty/nil for", file)
        return {}
    end

    raw = raw:gsub("\r\n", "\n"):gsub("\r", "\n")

    log("raw length:", #raw)

    local result = {}
    local lines = split(raw, "\n")

    log("total lines (incl. header):", #lines)

    local loaded_count = 0
    local skipped_count = 0

    for i = 2, #lines do
        local line = lines[i]

        if line and line ~= "" then
            local c = split(line, ",")
            debug_dump_fields(i, c)

            if c and #c >= 2 then

                local mode_ = tonumber(c[1]) or 0
                local type_ = c[2]

                if is_valid(type_) then

                    local condition = is_valid(c[3]) and c[3] or nil
                    local weight = tonumber(c[4]) or 0

                    local phrases = {}
                    local times = {}

                    for j = 5, 7 do
                        local idx = j - 4
                        if is_valid(c[j]) then
                            phrases[idx] = c[j]
                        end
                    end

                    for j = 8, 10 do
                        local idx = j - 7
                        local n = to_number(c[j])
                        if n then
                            times[idx] = n
                        end
                    end

                    result[mode_] = result[mode_] or {}
                    result[mode_][type_] = result[mode_][type_] or {}

                    table.insert(result[mode_][type_], {
                        condition = condition,
                        weight = weight,
                        phrases = phrases,
                        times = times
                    })

                    loaded_count = loaded_count + 1
                    log(string.format(
                        "line %d OK -> mode=%s type=%s condition=%s weight=%s phrases=%d times=%d",
                        i, tostring(mode_), tostring(type_), tostring(condition),
                        tostring(weight), count_dense(phrases), count_dense(times)
                    ))
                else
                    skipped_count = skipped_count + 1
                    log("line", i, "SKIPPED: invalid type_ field, raw line:", line)
                end
            else
                skipped_count = skipped_count + 1
                log("line", i, "SKIPPED: less than 2 columns, raw line:", line)
            end
        end
    end

    log(string.format("parsing done: loaded=%d skipped=%d", loaded_count, skipped_count))

    return result
end

local function get_trash(filett)
    local ok = readfile(filett)
    if ok == nil then
        writefile(filett, base64.decode(csv))
    end
end

get_trash(filett)
local trash = load_trash(filett)

do
    for m, types_tbl in pairs(trash) do
        for t, entries in pairs(types_tbl) do
            log(string.format("bucket mode=%s type=%s entries=%d", tostring(m), tostring(t), #entries))
        end
    end
end

local RECENT_HISTORY = {}

local function get_history_key(mode, type_)
    return tostring(mode) .. "_" .. tostring(type_)
end

local function get_no_condition_count(entries)
    local n = 0
    for _, e in ipairs(entries) do
        if e.condition == nil then
            n = n + 1
        end
    end
    return n
end

local function get_history_limit(entries)
    local nil_count = get_no_condition_count(entries)
    local limit = math.floor(nil_count / 2)
    if limit < 1 then limit = 0 end
    return limit
end

local function filter_recent(matching, history_key, entries)
    local limit = get_history_limit(entries)
    if limit <= 0 then return matching end

    local recent = RECENT_HISTORY[history_key]
    if not recent or #recent == 0 then return matching end

    local recent_set = {}
    for _, e in ipairs(recent) do
        recent_set[e] = true
    end

    local filtered = {}
    for _, e in ipairs(matching) do
        if e.condition ~= nil or not recent_set[e] then
            table.insert(filtered, e)
        end
    end

    if #filtered == 0 then
        return matching
    end

    return filtered
end

local function push_history(history_key, entry, entries)
    if entry.condition ~= nil then return end

    local limit = get_history_limit(entries)
    if limit <= 0 then return end

    local recent = RECENT_HISTORY[history_key]
    if not recent then
        recent = {}
        RECENT_HISTORY[history_key] = recent
    end

    table.insert(recent, entry)

    while #recent > limit do
        table.remove(recent, 1)
    end
end

local function get_current_condition(weapon)
    if weapon == "taser" then
        return "taser"
    elseif string.find(weapon, "knife") then
        return "knife"
    else return nil 
    end
end

local function gen_smile()
    local n = math.random(1, 5)
    return string.rep(")", n)
end

local function gen_laugh()
    local len = math.random(10, 20)
    local parts = {}
    for i = 1, len do
        table.insert(parts, LAUGH_LETTERS[math.random(#LAUGH_LETTERS)])
    end
    return table.concat(parts)
end

local function gen_osk()
    return OSK_WORDS[math.random(#OSK_WORDS)]
end

local function get_player_name(e, bool)
    local ent_idx = e
    if not bool then
        ent_idx = client.userid_to_entindex(e.userid)
    end
    return entity.get_player_name(ent_idx)
end

local function resolve_placeholders(text, event)
    if not text then return text end

    local result = text:gsub("%[(%a+)%]", function(tag)
        if tag == "smile" then
            return gen_smile()
        elseif tag == "laugh" then
            return gen_laugh()
        elseif tag == "osk" then
            return gen_osk()
        elseif tag == "player" then
            return get_player_name(event, false)
        elseif tag == "local_player" then
            return get_player_name(entity.get_local_player(), true)
        else
            log("resolve_placeholders: unknown tag [" .. tag .. "], leaving as-is")
            return "[" .. tag .. "]"
        end
    end)

    return result
end

local function send_msg(phrase, event)
    local resolved = resolve_placeholders(phrase, event)
    log("send_msg -> raw:", phrase, "resolved:", resolved)
    client.exec('say "' .. resolved .. '"')
end

local function weighted_pick(entries)
    local total = 0
    for _, e in ipairs(entries) do
        total = total + (e.weight or 0)
    end

    log("weighted_pick: total weight =", total, "over", #entries, "entries")

    if total <= 0 then
        local pick = entries[math.random(#entries)]
        log("weighted_pick: total<=0, fallback random index, picked condition=", tostring(pick.condition))
        return pick
    end

    local roll = math.random() * total
    local acc = 0

    for idx, e in ipairs(entries) do
        acc = acc + (e.weight or 0)
        if roll <= acc then
            log("weighted_pick: roll=", roll, "-> picked idx", idx, "condition=", tostring(e.condition), "weight=", e.weight)
            return e
        end
    end

    log("weighted_pick: fallthrough, returning last entry")
    return entries[#entries]
end

local function get_phrase(d, current_condition, event)
    local mode = Menu.settings.trash_talk_mode:get() == "Emberlash" and 1 or 0
    local type_
    if d == 0 then
        type_ = "kill"
    elseif d == 1 then
        type_ = "death"
    else
        type_ = "revenge"
    end

    log("get_phrase called, d=", d, "type_=", type_, "mode=", mode)

    local bucket = trash[mode] and trash[mode][type_]
    if not bucket or #bucket == 0 then
        log("get_phrase: NO BUCKET for mode=", mode, "type_=", type_)
        return
    end

    log("get_phrase: bucket found, entries=", #bucket)

    log("get_phrase: current_condition=", tostring(current_condition))

    local matching = {}
    for _, e in ipairs(bucket) do
        if e.condition == nil or e.condition == current_condition then
            table.insert(matching, e)
        end
    end

    log("get_phrase: matching entries after condition filter=", #matching)

    if #matching == 0 then
        log("get_phrase: NO MATCHING ENTRIES, aborting")
        return
    end

    local history_key = get_history_key(mode, type_)
    matching = filter_recent(matching, history_key, bucket)

    log("get_phrase: matching entries after repeat filter=", #matching)

    local entry = weighted_pick(matching)

    push_history(history_key, entry, bucket)

    local now = globals.curtime()
    local scheduled = 0

    local last_planned_at = LAST_SENT_AT
    for _, p in ipairs(pending) do
        if p.at > last_planned_at then
            last_planned_at = p.at
        end
    end
    local raw_acc_ms = 0
    local prev_actual_at = nil

    for idx = 1, 3 do
        local phrase = entry.phrases[idx]
        local time_ms = entry.times[idx]

        if not phrase or not time_ms then
            log(string.format("get_phrase: chain break at idx=%d (phrase=%s, time=%s)",
                idx, tostring(phrase), tostring(time_ms)))
            break
        end

        local extra_ms = (idx == 1) and FIRST_PHRASE_EXTRA_DELAY_MS or 0
        raw_acc_ms = raw_acc_ms + time_ms + extra_ms

        local natural_at = now + (raw_acc_ms / 1000)
        local base_at = prev_actual_at or last_planned_at

        local actual_at
        if natural_at - base_at < MIN_SEND_INTERVAL then
            actual_at = base_at + MIN_SEND_INTERVAL
            log(string.format(
                "get_phrase: chain step %d SHIFTED (rate-limit): natural_at=%.3f base_at=%.3f -> actual_at=%.3f (+%.0fms)",
                idx, natural_at, base_at, actual_at, (actual_at - natural_at) * 1000
            ))
        else
            actual_at = natural_at
        end

        table.insert(pending, {
            event = event,
            at = actual_at,
            phrase = phrase
        })

        prev_actual_at = actual_at
        last_planned_at = actual_at
        scheduled = scheduled + 1

        log(string.format("get_phrase: chain step %d -> phrase=%s natural=+%.0fms actual_at=%.3f",
            idx, phrase, raw_acc_ms, actual_at))
    end

    if scheduled == 0 then
        log("get_phrase: chain produced 0 scheduled messages")
    end
end

local function on_paint()
    if #pending == 0 then return end

    local now = globals.curtime()
    table.sort(pending, function(a, b) return a.at < b.at end)

    local i = 1
    while i <= #pending do
        local p = pending[i]

        if now >= p.at then
            send_msg(p.phrase, p.event)
            LAST_SENT_AT = now
            table.remove(pending, i)
        else
            i = i + 1
        end
    end
end

local function get_event(e)
    local local_player = entity.get_local_player()
    local attacker = client.userid_to_entindex(e.attacker)
    local victim = client.userid_to_entindex(e.userid)
    local weapon = e.weapon
    local condition = get_current_condition(weapon)

    log(string.format(
        "player_death event: attacker=%s (uid=%s) victim=%s (uid=%s) local_player=%s killer=%s",
        tostring(attacker), tostring(e.attacker),
        tostring(victim), tostring(e.userid),
        tostring(local_player), tostring(killer)
    ))

    if attacker == local_player and victim ~= local_player and Menu.settings.trash_talk_type:get("Kill") then
        log("get_event: branch = WE killed someone")
        get_phrase(0, condition, e)
    elseif attacker ~= local_player and victim == local_player and Menu.settings.trash_talk_type:get("Death")  then
        killer = attacker
        log("get_event: branch = WE got killed, killer set to", killer)
        get_phrase(1, condition, e)
    elseif victim == killer and not entity.is_alive(local_player) and Menu.settings.trash_talk_type:get("Revenge")  then
        log("get_event: branch = REVENGE on killer")
        get_phrase(2, condition, e)
    else
        log("get_event: no branch matched")
    end
end

Menu.settings.trash_talk:set_callback(function(self)
    if self:get() then
        client.set_event_callback("paint", on_paint)
        client.set_event_callback("player_death", get_event)
    else
        client.unset_event_callback("paint", on_paint)
        client.unset_event_callback("player_death", get_event)
    end
end,true)

end



do

local spec_avatar_cache = {}  

local function get_spec_avatar(steam64)
    if spec_avatar_cache[steam64] ~= nil then
        return spec_avatar_cache[steam64] or nil
    end

    local raw = images.get_steam_avatar(steam64)
    if raw then
        local ok, t = pcall(create_rounded_avatar, raw, SPEC.av_size)
        if ok and t then
            spec_avatar_cache[steam64] = t
            return t
        end
    end

    spec_avatar_cache[steam64] = false
    return nil
end

local function get_spectators(lp)
    local result = {}

    if lp and entity.is_alive(lp) then
        for i = 1, globals.maxplayers() do
            if entity.get_classname(i) == "CCSPlayer" then
                local obs_mode   = entity.get_prop(i, "m_iObserverMode")
                local obs_target = entity.get_prop(i, "m_hObserverTarget")

                if obs_target ~= nil
                    and obs_target <= 64
                    and not entity.is_alive(i)
                    and (obs_mode == 4 or obs_mode == 5)
                    and obs_target == lp
                    and i ~= lp
                then
                    local name = entity.get_player_name(i) or "unknown"

                    result[#result + 1] = {
                        name = name,
                        steam64 = entity.get_steam64(i),
                        avatar = get_spec_avatar(entity.get_steam64(i)) or tex.default_avatar,
                        mode = obs_mode,
                        placeholder = false,
                    }
                end
            end
        end
    end

    if #result == 0 and ui.is_menu_open() then
        local preview_name = "funtazzy"

        if lp then
            local ok, name = pcall(entity.get_player_name, lp)
            if ok and name and name ~= "" then
                preview_name = name
            end
        end

        result[1] = {
            name = preview_name,
            steam64 = lp and entity.get_steam64(lp) or nil,
            avatar = tex.avatar or tex.default_avatar,
            mode = 4,
            placeholder = true,
        }
    end

    return result
end

local function draw_spec_row(x, y, w, entry, accent, tc, alpha, name_limit, offset_x)
    local a255 = math.floor(255 * alpha)
    if a255 <= 0 then return end

    local PAD = SPEC.pad_x
    local AV = SPEC.av_size
    local TGAP = SPEC.tri_gap
    local TW = SPEC.tri_w
    local RH = SPEC.row_h

    offset_x = math.floor(offset_x or 0)
    local draw_x = x + offset_x
    local draw_w = math.max(0, w - offset_x)

    draw_bg(draw_x, y, draw_w, RH, 10)

    local tri_x = draw_x + PAD
    local tri_cy = y + math.floor(RH / 2)
    draw_inner_corner(draw_x+2, y+3, 5, RH-4, 10, "right", accent, a255)

    local text_x = tri_x + TW + TGAP
    local ty = y + math.floor((RH - renderer.measure_text("b", "0")) / 2) - 3
    local max_text_w = math.max(0, draw_w - PAD - TW - TGAP - AV - PAD * 2)
    local shown_name = clip_text(entry.name, name_limit)
    renderer.text(text_x, ty, tc[1], tc[2], tc[3], a255, "b", max_text_w, shown_name)

    local av_t = entry.avatar or tex.default_avatar
    if av_t then
        local av_x = draw_x + draw_w - PAD - AV
        local av_y = y + math.floor((RH - AV) / 2)
        renderer.texture(av_t, av_x, av_y, AV, AV, 255, 255, 255, a255, "f")
    end
end

function visuals_things.draw_spectator_list()
    local lp = entity.get_local_player()

    if not lp and not ui.is_menu_open() then
        spec_state.alpha        = 0.0
        spec_state.header_alpha = 0.0
        spec_state.rows         = {}
        return
    end

    local sw, sh         = client.screen_size()
    local header_enabled = Menu.settings.visuals.speclist.header:get()
    local name_limit     = header_enabled and SPEC.headless_name_limit or SPEC.full_name_limit

    local specs = get_spectators(lp) or {}
    local count = #specs

    local PAD  = SPEC.pad_x
    local AV   = SPEC.av_size
    local TW   = SPEC.tri_w
    local TGAP = SPEC.tri_gap
    local RH   = SPEC.row_h
    local GAP  = SPEC.gap_y
    local HH   = SPEC.header_h

    local content_w = SPEC.min_w
    for _, s in ipairs(specs) do
        local shown = clip_text(s.name, name_limit)
        local nw = text_w(shown) + PAD + TW + TGAP + AV + PAD * 2 + 4
        if nw > content_w then content_w = nw end
    end
    if header_enabled then
        content_w = math.max(content_w, text_w("Spectators") + PAD * 2 + 4)
    end
    local row_w = content_w

    local base_x, base_y
    if not header_enabled then
        local total_h = count * RH + math.max(0, count - 1) * GAP
        base_x = sw - SPEC.right_gap - row_w
        base_y = math.floor(sh * 0.5 - total_h * 0.5 - 10)
        base_x = clamp(base_x, 0, math.max(0, sw - row_w))
        base_y = clamp(base_y, 0, math.max(0, sh - math.max(total_h, 1)))
    else
        local total_h = HH + GAP + count * RH + math.max(0, count - 1) * GAP
        local px, py = drag_system:get_position("spec_list", sw, row_w)
        base_x, base_y = px, py
        if ui.is_menu_open() then
            local dx, dy = drag_system:update("spec_list", base_x, base_y, row_w, math.max(total_h, HH), {
                min_x=0, max_x=math.max(0,sw-row_w), min_y=0, max_y=sh, anchor_right=true,
            })
            base_x, base_y = dx, dy
        end
        base_x = clamp(base_x, 0, math.max(0, sw - row_w))
        base_y = clamp(base_y, 0, math.max(0, sh - math.max(total_h, HH)))
    end

    local ctx_accent = { Menu.settings.visuals.accent:get() }
    local tc         = { 215, 218, 224 }
    local row_step   = RH + GAP

    local function row_key(entry)
        return tostring(entry.steam64 or "") .. "|" .. tostring(entry.name or "")
            .. "|" .. tostring(entry.mode or 0) .. "|" .. tostring(entry.placeholder and 1 or 0)
    end
    local function row_width(entry)
        local shown = clip_text(entry.name, name_limit)
        return text_w(shown) + PAD + TW + TGAP + AV + PAD * 2 + 4
    end

    local seen = {}
    for i, entry in ipairs(specs) do
        local key      = row_key(entry)
        
        local target_y = base_y + (header_enabled and HH + GAP or 0) + (i - 1) * row_step
        local target_w = header_enabled and row_w or row_width(entry)
        seen[key] = true

        local st = spec_state.rows[key]
        if not st then
            st = {
                alpha    = 0.0,
                y_offset = header_enabled and -RH or 0,
                cur_y    = target_y,
                w        = target_w,
                removing = false,
                entry    = entry,
            }
            spec_state.rows[key] = st
        else
            st.removing = false
            st.entry    = entry
        end
        st.cur_y = lerp(st.cur_y, target_y, 0.25)

        local target_w = header_enabled and row_w or row_width(entry)
        st.w = lerp(st.w, target_w, 0.22)
    end

    for key, st in pairs(spec_state.rows) do
        if not seen[key] then st.removing = true end
    end

    local any_active = count > 0
    spec_state.alpha = lerp(spec_state.alpha, any_active and 1.0 or 0.0, 0.18)

    local has_removing = false
    for _, st in pairs(spec_state.rows) do
        if st.removing and (st.alpha or 0) > 0.01 then has_removing = true; break end
    end

    if header_enabled then
        local hdr_target = (any_active or has_removing) and 1.0 or 0.0
        spec_state.header_alpha = lerp(spec_state.header_alpha, hdr_target, 0.18)
    end

    if spec_state.alpha < 0.01 and spec_state.header_alpha < 0.01
       and not any_active and not has_removing then
        spec_state.rows = {}
        return
    end

    local header_bottom = base_y + (header_enabled and HH or 0)

    local render_list = {}
    for key, st in pairs(spec_state.rows) do
        render_list[#render_list + 1] = { key = key, st = st }
    end
    table.sort(render_list, function(a, b)
        return (a.st.cur_y or 0) < (b.st.cur_y or 0)
    end)

    local to_remove = {}
    for _, rr in ipairs(render_list) do
        local key, st = rr.key, rr.st

        if st.removing then
            if header_enabled then
                st.y_offset = lerp(st.y_offset or 0, -RH, 0.22)
            end
            st.alpha = lerp(st.alpha or 0, 0.0, 0.18)
            if st.alpha < 0.01 then to_remove[#to_remove+1] = key end
        else
            if header_enabled then
                st.y_offset = lerp(st.y_offset or 0, 0.0, 0.22)
                if (st.y_offset or 0) > -0.5 then st.y_offset = 0 end
            end
            st.alpha = lerp(st.alpha or 0, spec_state.alpha, 0.18)
        end

        local draw_y = math.floor(st.cur_y + (st.y_offset or 0) + 0.5)
        local draw_w = math.floor(st.w + 0.5)

        local clip_a = 1.0
        if header_enabled then
            local overlap = header_bottom - draw_y
            if overlap > 0 then
                clip_a = clamp(1.0 - overlap / (RH * 0.6), 0.0, 1.0)
            end
        end

        local final_a = (st.alpha or 0) * clip_a
        if final_a > 0.01 and st.entry then
            local row_x = header_enabled
                        and base_x 
                        or (sw - SPEC.right_gap - draw_w - 2)
            draw_spec_row(row_x, draw_y, draw_w, st.entry, ctx_accent, tc, final_a, name_limit, 0)
        end
    end

    for _, key in ipairs(to_remove) do spec_state.rows[key] = nil end

    if header_enabled and spec_state.header_alpha > 0.01 then
        draw_widget_header(base_x, base_y, row_w, HH, "Spectators", ctx_accent, tc,
            spec_state.header_alpha, tex.visible, 14, 10)
    end
end
end

do 

    


local KB_BINDS = {
    {
        label = "Gamesense menu",
        get_active = function() return ui.is_menu_open() end
    },
    {
        label      = "Double tap",
        get_active = function() 
            return parse_bind({ui.reference("Rage", "aimbot", "Double Tap")})
        end,
    },
        {
        label      = "Hide shots",
        get_active = function() 
            return parse_bind({ui.reference("aa", "other", "On shot anti-aim")})
        end,
    },
        {
        label      = "Quick peek",
        get_active = function()return parse_bind({ui.reference("rage", "other", "quick peek assist")}) end,
    },
        {
        label      = "dmg override",
        get_active = function() return parse_bind({ui.reference("rage", "aimbot", "Minimum damage override")}) end,
    },
        {
        label      = "Force safe-point",
        get_active = function() return parse_bind(ui.reference("rage", "aimbot", "force safe point")) end,
    },
        {
        label      = "Force baim",
        get_active = function() return parse_bind(ui.reference("rage", "aimbot", "Force body aim")) end,
    },
            {
        label      = "Fake-duck",
        get_active = function() return parse_bind(ui.reference("rage", "other", "Duck peek assist")) end,
    },
            {
        label      = "Slow motion",
        get_active = function() return parse_bind({ui.reference("aa", "other", "slow motion")}) end,
    },
            {
        label      = "Fake peek",
        get_active = function() return parse_bind({ui.reference("aa", "other", "fake peek")}) end,
    },
            {
        label      = "Freestanding",
        get_active = function()
            local bind = parse_bind({ui.reference("aa", "anti-aimbot angles", "Freestanding")})
            local ideal_tick =  (Menu.settings.ideal_tick.hotkey:get() and Menu.settings.ideal_tick:get())
            return bind and not ideal_tick
        end,
    },
            {
        label      = "Ping spike",
        get_active = function()  return parse_bind({ui.reference("misc", "miscellaneous", "Ping spike")}) end,
    },
            {
        label      = "Ideal Tick",
        get_active = function() 
            local ideal_tick = Menu.settings.ideal_tick
            return ideal_tick.hotkey:get() and ideal_tick:get()
        end,
    },
            {
        label      = "Peek-bot",
        get_active = function() 
            local peek_bot = Menu.settings.peek_bot
            return peek_bot.hotkey:get() and peek_bot:get()
        end,
    },            
    {
        label      = "Auto break LC",
        get_active = function() 
            local enabled = Menu.settings.auto_teleport:get() and Menu.settings.auto_teleport.hotkey:get()
            return enabled
        end,
    },
}


local kb_row_state = {}
local kb_state = {
    alpha        = 0.0,
    held_w       = 0.0,
    header_alpha = 0.0,
    background   = 220,
    slider_col   = 60,
}

Menu.settings.visuals.keybinds.toggle_theme:set_callback(function(self)
    kb_state.background = self:get() and 60 or 220
    kb_state.slider_col = self:get() and 220 or 60
end,true)

local KB = {
    pad_x    = 3,
    pad_y    = 6,
    row_h    = 26,
    gap_y    = 4,
    header_h = 30,
    min_w    = 130,
    left_w   = 30,
    radius   = 8,
}

local function draw_toggle_slider(x, y, w, h, t, a255)
    if a255 <= 0 then return end

    local cap_w = 17
    local cap_h = 8
    local cap_x = x + math.floor((w - cap_w) / 2)
    local cap_y = y + math.floor((h - cap_h) / 2)
    local cap_r = math.floor(cap_h / 2)

    local bg = kb_state.background
    local slider = kb_state.slider_col

    render_rec(cap_x, cap_y, cap_w , cap_h, cap_r, {bg, bg, bg, a255})

    local dot_r = cap_r - 2
    local dot_x = cap_x + cap_r + math.floor(t * (cap_w - cap_r * 2))
    local dot_y = cap_y + math.floor(cap_h / 2)

    local dot_alpha = math.floor(lerp(140, 240, t))
    renderer.circle(
        dot_x,
        dot_y,
        slider, slider, slider,
        math.floor(a255 * dot_alpha / 255),
        dot_r,
        0,
        1
    )
end


local function draw_keybinds_row(x, y, w, label, slider_t, accent, a)
    local a255 = math.floor(255 * a)
    if a255 <= 0 then return end

    local PAD = KB.pad_x
    local H   = KB.row_h
    local LW  = KB.left_w
    local tc  = {215, 218, 224}

    render_rec(x, y, LW, H, KB.radius, {12,12,12, clamp(a255, 0, 120)})
    draw_toggle_slider(x, y, LW, H, slider_t, a255)

    local rx = x + LW + PAD
    local rw = w - LW - PAD

    local text_x = rx + PAD
    local text_y = y + math.floor((H - renderer.measure_text("b", "0")) / 2) - 3
    local text_w = text_w(label)

    render_rec(rx, y, text_w + 6, H, KB.radius, {12,12,12, clamp(a255, 0, 120)})

    render_text(text_x, text_y, tc[1], tc[2], tc[3], a255, label)
end

function visuals_things.draw_keybinds_list()

    local menu_open = ui.is_menu_open()
    local sw, sh    = client.screen_size()
    local accent    = { Menu.settings.visuals.accent:get() }
    local tc        = { 215, 218, 224 }

    local bind_info = {}
    for i, bind in ipairs(KB_BINDS) do
        local show, inverted = bind.get_active()
        bind_info[i] = { show = show, inverted = inverted or false, label = bind.label or "?" }
    end

    for i = 1, #KB_BINDS do
        local bi = bind_info[i]
        local st = kb_row_state[i]

        if bi.show then
            if not st then
                kb_row_state[i] = {
                    alpha    = 0.0,
                    slider   = bi.inverted and 0.0 or 1.0,
                    y_offset = -KB.row_h,
                    cur_y    = nil,
                    phase    = "appear",
                    label    = bi.label,
                    inverted = bi.inverted,
                }
            else
                st.label    = bi.label
                st.inverted = bi.inverted

                if st.phase == "wait_slider" or st.phase == "disappear" then
                    st.phase = "appear"
                end
            end
        else
            if st and (st.phase == "appear" or st.phase == "active") then
                st.phase = "wait_slider"
            end
        end
    end

    local visible_rows = {}
    for i = 1, #KB_BINDS do
        local st = kb_row_state[i]
        if st then visible_rows[#visible_rows + 1] = { idx = i, st = st } end
    end

    local has_active = false
    for _, vr in ipairs(visible_rows) do
        if vr.st.phase == "appear" or vr.st.phase == "active" then
            has_active = true; break
        end
    end

    local show_widget = has_active or menu_open

    kb_state.alpha = lerp(kb_state.alpha, show_widget and 1.0 or 0.0, 0.18)

    local content_w = KB.min_w
    for _, st in pairs(kb_row_state) do
        local lw = KB.left_w + KB.pad_x + text_w(st.label) + KB.pad_x + 4
        if lw > content_w then content_w = lw end
    end
    content_w = math.max(content_w, text_w("Keybinds") + KB.pad_x * 2 + 4)
    if kb_state.held_w == 0 then kb_state.held_w = content_w end
    kb_state.held_w = lerp(kb_state.held_w, content_w, 0.2)
    local w = math.floor(kb_state.held_w + 0.5)

    local rows_count = #visible_rows
    local content_h  = rows_count * KB.row_h + math.max(0, rows_count - 1) * KB.gap_y
    local total_h    = KB.header_h + KB.gap_y + content_h

    local bx, by = drag_system:get_position("keybinds", sw, w)
    if menu_open then
        local dx, dy = drag_system:update("keybinds", bx, by, w, total_h, {
            min_x=0, max_x=math.max(0,sw-w), min_y=0, max_y=math.max(0,sh-total_h),
        })
        bx, by = dx, dy
    end
    bx = clamp(bx, 0, math.max(0, sw - w))
    by = clamp(by, 0, math.max(0, sh - total_h))

    local all_gone  = true
    local to_remove = {}
    local row_idx   = 0

    for _, vr in ipairs(visible_rows) do
        local i, st = vr.idx, vr.st
        local target_y = by + KB.header_h + KB.gap_y + row_idx * (KB.row_h + KB.gap_y)
        row_idx = row_idx + 1

        if not st.cur_y then st.cur_y = target_y end
        st.cur_y = lerp(st.cur_y, target_y, 0.3)

        local slider_target = st.inverted and 0.0 or 1.0

        if st.phase == "appear" then
            st.y_offset = lerp(st.y_offset or -KB.row_h, 0.0, 0.22)
        
            if math.abs(st.y_offset or 0) < 0.5 then
                st.y_offset = 0.0
                st.phase = "active"
            end
        
            st.slider = lerp(st.slider, slider_target, 0.12)
            st.alpha  = lerp(st.alpha, kb_state.alpha, 0.18)
        
            all_gone = false
        
        elseif st.phase == "active" then
            st.y_offset = 0.0
        
            st.slider = lerp(st.slider, slider_target, 0.12)
            st.alpha  = lerp(st.alpha, kb_state.alpha, 0.18)
        
            all_gone = false
        
        elseif st.phase == "wait_slider" then
            st.slider = lerp(st.slider, 0.0, 0.12)
            st.alpha  = lerp(st.alpha, kb_state.alpha, 0.18)
        
            all_gone = false
        
            if st.slider < 0.04 then
                st.slider = 0.0
                st.phase = "disappear"
            end
        
        elseif st.phase == "disappear" then
            st.y_offset = lerp(st.y_offset or 0.0, -KB.row_h, 0.22)
            st.alpha    = lerp(st.alpha, 0.0, 0.18)
        
            if st.alpha < 0.01 then
                to_remove[#to_remove + 1] = i
            else
                all_gone = false
            end
        end

        if (st.alpha or 0) > 0.01 then
            local ry = math.floor(st.cur_y + (st.y_offset or 0) + 0.5)
            draw_keybinds_row(bx, ry, w, st.label, st.slider, accent, st.alpha)
        end
    end

    for _, i in ipairs(to_remove) do kb_row_state[i] = nil end

    local header_target
    if show_widget then
        header_target = kb_state.alpha
    else
        header_target = all_gone and 0.0 or kb_state.header_alpha
    end
    kb_state.header_alpha = lerp(kb_state.header_alpha, header_target, 0.18)

    if kb_state.header_alpha > 0.01 then
        draw_widget_header(bx, by, w, KB.header_h, "Keybinds", accent, tc,
            kb_state.header_alpha, tex.list, 14, KB.header_h / 2)
    end
end

end

do

local SIDEIND_SCALE   = 1.25
local SIDEIND_TEXTFLG = "+"

local text_w = function(text)
    local w = renderer.measure_text(SIDEIND_TEXTFLG, tostring(text or ""))
    return w
end

local function resolve(value, ...)
    if type(value) == "function" then
        return value(...)
    end
    return value
end

local function normalize_text(s)
    if s == nil then return nil end
    s = tostring(s)
    s = s:gsub("\r", "")
    s = s:gsub("^%s+", ""):gsub("%s+$", "")
    return s
end

local function upper_text(s)
    s = normalize_text(s)
    if not s then return nil end
    return s:upper()
end

local function has_real_multiline(label)
    if not label then return false end
    local nl_pos = label:find("\n")
    if not nl_pos then return false end

    local after = label:sub(nl_pos + 1)
    after = after:gsub("^%s+", ""):gsub("%s+$", "")

    return after ~= ""
end

local function flatten_parts_to_lines(parts)
    local lines = { {} }
    for _, p in ipairs(parts) do
        local seg = p.text
        local c   = p.color
        local first_seg = true
        for line in (seg .. "\n"):gmatch("([^\n]*)\n") do
            if not first_seg then
                lines[#lines + 1] = {}
            end
            first_seg = false
            if line ~= "" then
                local cur_line = lines[#lines]
                cur_line[#cur_line + 1] = { text = line, color = c }
            end
        end
    end

    local real_lines = {}
    for _, line_segs in ipairs(lines) do
        if #line_segs > 0 then
            real_lines[#real_lines + 1] = line_segs
        end
    end
    return real_lines
end

local SIDEIND = {
    pad_x      = math.floor(10 * SIDEIND_SCALE),
    pad_y      = math.floor(5  * SIDEIND_SCALE),
    row_h      = math.floor(24 * SIDEIND_SCALE),
    gap_y      = math.floor(4  * SIDEIND_SCALE),
    icon_sz    = math.floor(14 * SIDEIND_SCALE),
    icon_gap   = math.floor(6  * SIDEIND_SCALE),
    min_w      = math.floor(10 * SIDEIND_SCALE),
    radius     = math.floor(8  * SIDEIND_SCALE),
    margin_x   = math.floor(10 * SIDEIND_SCALE),
    border_w   = math.floor(3  * SIDEIND_SCALE),
    swatch_r   = math.floor(3  * SIDEIND_SCALE),
    line_pad   = math.floor(6  * SIDEIND_SCALE),
    text_off_y = math.floor(3  * SIDEIND_SCALE),
}

local W = {}
local side_state = {
    master = 0.0,
    items  = {},
}

local ind_frame   = {}
local ind_order_n = 0
local bomb_cache = {
    timer  = nil,
    damage = nil,
    fatal  = nil,
    color  = {255, 255, 255}
}

local SIDEIND_ICONS = {
    ["SLOW"]     = tex.fall,
    ["BOMB"]     = tex.explosion,
    ["PING"]     = tex.internet_www,
    ["DT"]       = tex.bullet,
    ["OSAA"]     = tex.not_visible,
    ["PEEK-ASSIST"] = tex.ai
}

local function register_indicator_icon(key, icon)
    SIDEIND_ICONS[upper_text(key) or key] = icon
end

local function resolve_icon_for_label(label)
    if not label then return nil end

    local u = upper_text(label)
    if not u then return nil end

    local direct = SIDEIND_ICONS[u]
    if direct then return direct end

    for pattern, tex in pairs(SIDEIND_ICONS) do
        if tex and u:find(pattern, 1, true) then
            return tex
        end
    end
    return tex.info
end

local function normalize_indicator_data(label, color, icon, parts)
    return {
        label = label,
        parts = parts,
        color = color or {255, 255, 255},
        icon  = icon or resolve_icon_for_label(label),
    }
end

local function bomb_timer_color(timer_str)
    local secs = tonumber(timer_str:match("([%d%.]+)s"))
    if not secs then return {255, 255, 255} end
    if secs <= 5  then return {255,  60,  60} end
    if secs <= 10 then return {255, 200,  50} end
    return {255, 255, 255}
end

local side_indicator_rules = {}

local function register_side_indicator_rule(key, block)
    side_indicator_rules[key] = {
        key         = key,
        match       = block.match or block.label or block.text or key,   -- string / table / function
        visible     = block.visible,                                     -- bool / function
        render_text = block.render_text or block.text,                   -- string / function
        icon        = block.icon,                                        -- string / function
        color       = block.color,                                       -- table / function
        order       = block.order or 0,
        priority    = block.priority or 0,
    }
end

local function unregister_side_indicator_rule(key)
    side_indicator_rules[key] = nil
end

local function rule_matches(rule, data)
    local label = data.label
    local ulabel = upper_text(label)
    local match = rule.match

    if not match then
        return false
    end

    if type(match) == "function" then
        return match(data) == true
    end

    if type(match) == "string" then
        return ulabel == upper_text(match)
    end

    if type(match) == "table" then
        for _, m in ipairs(match) do
            if type(m) == "function" then
                if m(data) then return true end
            elseif type(m) == "string" then
                if ulabel == upper_text(m) then return true end
            end
        end
    end

    return false
end

local function resolve_side_rule(data)
    local best = nil
    local best_prio = -math.huge
    local best_idx = -math.huge
    local idx = 0

    for _, rule in pairs(side_indicator_rules) do
        idx = idx + 1
        if rule_matches(rule, data) then
            local prio = rule.priority or 0
            if prio > best_prio or (prio == best_prio and idx > best_idx) then
                best = rule
                best_prio = prio
                best_idx = idx
            end
        end
    end

    if not best then
        return nil
    end

    local ok = resolve(best.visible, data)
    if ok == false then
        return false
    end

    return {
        key         = best.key,
        text        = resolve(best.render_text, data),
        icon        = resolve(best.icon, data),
        color       = resolve(best.color, data),
        order       = resolve(best.order, data) or 0,
        priority    = best.priority or 0,
    }
end

function visuals_things.draw_side_indicator()
    local arr = {}

    if bomb_cache.timer then
        local tc = bomb_timer_color(bomb_cache.timer)
        local parts = {
            { text = bomb_cache.timer, color = tc },
        }

        if bomb_cache.fatal then
            parts[#parts+1] = { text = "\n" .. bomb_cache.fatal, color = {255, 60, 60} }
        end

        local dmg = bomb_cache.damage
        if dmg then
            local hp_num = dmg:match("%-?%d+")
            local dmg_color = (hp_num and tonumber(hp_num) ~= 0)
                and {255, 200, 50}
                or  {180, 180, 180}
            parts[#parts+1] = { text = (bomb_cache.fatal and "" or "\n") .. dmg, color = dmg_color }
        end

        ind_frame["BOMB"] = {
            label = "BOMB",
            parts = parts,
            color = tc,
            order = -1,
            icon  = resolve_icon_for_label("BOMB"),
        }
    end

    bomb_cache.timer  = nil
    bomb_cache.damage = nil
    bomb_cache.fatal  = nil

    for key, item in pairs(ind_frame) do
        arr[#arr + 1] = {
            key   = key,
            label = item.label,
            parts = item.parts,
            color = item.color,
            order = item.order,
            icon  = item.icon,
        }
    end

    table.sort(arr, function(a, b)
        return (a.order or 0) < (b.order or 0)
    end)

    ind_frame   = {}
    ind_order_n = 0

    local seen = {}
    for _, item in ipairs(arr) do
        local key = item.key
        seen[key] = true

        local ex = side_state.items[key]
        if not ex then
            side_state.items[key] = {
                alpha    = 0.0,
                label    = item.label,
                parts    = item.parts,
                color    = item.color,
                icon     = item.icon,
                removing = false,
                order    = item.order,
            }
        else
            ex.label    = item.label
            ex.parts    = item.parts
            ex.color    = item.color
            ex.icon     = item.icon
            ex.removing = false
            ex.order    = item.order
        end
    end

    for key, st in pairs(side_state.items) do
        if not seen[key] then
            st.removing = true
        end
    end

    local visible = {}
    for key, st in pairs(side_state.items) do
        visible[#visible + 1] = { key = key, st = st }
    end

    table.sort(visible, function(a, b)
        return (a.st.order or 0) < (b.st.order or 0)
    end)

    local any_active = false
    for _, v in ipairs(visible) do
        if not v.st.removing then
            any_active = true
            break
        end
    end

    side_state.master = lerp(side_state.master, any_active and 1.0 or 0.0, 0.18)

    if side_state.master < 0.01 and not any_active then
        for _, v in ipairs(visible) do
            side_state.items[v.key] = nil
        end
        return
    end

    local row_heights = {}
    for i, v in ipairs(visible) do
        local is_multi = has_real_multiline(v.st.label)
        local is_parts_multi = v.st.parts and #v.st.parts > 1
        row_heights[i] = (is_multi or is_parts_multi)
            and math.floor(SIDEIND.row_h * 1.5)
            or  SIDEIND.row_h
    end

    local total_h = 0
    for i, rh in ipairs(row_heights) do
        total_h = total_h + rh
        if i < #row_heights then
            total_h = total_h + SIDEIND.gap_y
        end
    end

    local sw, sh = client.screen_size()
    local ix     = SIDEIND.margin_x
    local iy     = math.floor(sh * 0.5 - total_h * 0.5)
    local cur_y  = iy
    local to_remove = {}

    for idx, v in ipairs(visible) do
        local key, st   = v.key, v.st
        local row_h     = row_heights[idx]
        local multiline = has_real_multiline(st.label)
        local st_parts  = st.parts

        local target_a = st.removing and 0.0 or side_state.master
        st.alpha = lerp(st.alpha or 0.0, target_a, 0.18)

        if st.removing and st.alpha < 0.01 then
            to_remove[#to_remove + 1] = key
        end

        if (st.alpha or 0) > 0.01 then
            local label_w
            if st_parts then
                label_w = 0
                for _, p in ipairs(st_parts) do
                    for line in (p.text .. "\n"):gmatch("([^\n]*)\n") do
                        local w = text_w(line)
                        if w > label_w then
                            label_w = w
                        end
                    end
                end
            elseif multiline then
                local w1 = text_w((st.label:match("^([^\n]+)") or ""))
                local w2 = text_w((st.label:match("\n(.+)$") or ""))
                label_w = math.max(w1, w2)
            else
                label_w = text_w(st.label)
            end

            local row_w = SIDEIND.pad_x + SIDEIND.icon_sz + SIDEIND.icon_gap + label_w + SIDEIND.pad_x
            local a255  = math.floor(255 * st.alpha)
            local ry    = cur_y
            local gc    = st.color or {255, 255, 255}

            draw_bg(ix, ry, row_w, row_h, SIDEIND.radius)
            draw_inner_corner(ix + 1, ry, SIDEIND.border_w, row_h, row_h / 2, "left", gc, a255)

            local ico_y = ry + math.floor((row_h - SIDEIND.icon_sz) / 2)
            if st.icon then
                renderer.texture(st.icon, ix + SIDEIND.pad_x, ico_y, SIDEIND.icon_sz, SIDEIND.icon_sz, gc[1],gc[2],gc[3], a255, "f")
            else
                render_rec(ix + SIDEIND.pad_x, ico_y, SIDEIND.icon_sz, SIDEIND.icon_sz, SIDEIND.swatch_r,
                    { gc[1], gc[2], gc[3], math.floor(a255 * 0.55) })
            end

            local tx = ix + SIDEIND.pad_x + SIDEIND.icon_sz + SIDEIND.icon_gap
            local line_height = renderer.measure_text(SIDEIND_TEXTFLG, "0")

            local ty
            if multiline or st_parts then
                ty = ry + math.floor((row_h - line_height) / 2)
            else
                ty = ry + math.floor((row_h - line_height) / 2)
            end

            if st_parts and #st_parts > 1 then
                local real_lines = flatten_parts_to_lines(st_parts)

                if #real_lines <= 1 then
                    local segs = real_lines[1] or {}
                    local cur_tx = tx
                    for _, seg in ipairs(segs) do
                        renderer.text(cur_tx, ty, seg.color[1], seg.color[2], seg.color[3], a255, SIDEIND_TEXTFLG, 0, seg.text)
                        cur_tx = cur_tx + renderer.measure_text(SIDEIND_TEXTFLG, seg.text)
                    end
                else
                    local line_h = renderer.measure_text(SIDEIND_TEXTFLG, "0") + SIDEIND.line_pad
                    local cur_ty = ty
                    for _, segs in ipairs(real_lines) do
                        local cur_tx = tx
                        for _, seg in ipairs(segs) do
                            renderer.text(cur_tx, cur_ty - 17, seg.color[1], seg.color[2], seg.color[3], a255, SIDEIND_TEXTFLG, 0, seg.text)
                            cur_tx = cur_tx + renderer.measure_text(SIDEIND_TEXTFLG, seg.text)
                        end
                        cur_ty = cur_ty + line_h
                    end
                end
            else
                renderer.text(tx, ty - 10, gc[1], gc[2], gc[3], a255, SIDEIND_TEXTFLG, 0, st_parts and st_parts[1].text or st.label)
            end
        end

        cur_y = cur_y + row_h + SIDEIND.gap_y
    end

    for _, key in ipairs(to_remove) do
        side_state.items[key] = nil
    end
end

local function push_side_indicator(key, label, color, icon)
    local data  = normalize_indicator_data(label, color, icon, nil)
    data.order  = ind_order_n
    ind_frame[key] = data
    ind_order_n = ind_order_n + 1
end

local function push_side_indicator_parts(key, parts, color, icon)
    ind_frame[key] = {
        label = nil,
        parts = parts,
        color = color or {255, 255, 255},
        icon  = icon,
        order = ind_order_n,
    }
    ind_order_n = ind_order_n + 1
end

W.side = W.side or {}
W.side.push                 = push_side_indicator
W.side.push_parts           = push_side_indicator_parts
W.side.register_icon        = register_indicator_icon
W.side.register_rule        = register_side_indicator_rule
W.side.unregister_rule      = unregister_side_indicator_rule
W.side.resolve_rule         = resolve_side_rule

local custom_indicator_blocks = {}
local custom_indicator_y      = {}

local function register_custom_indicator(key, block)
    custom_indicator_blocks[key] = {
        condition  = block.condition,
        text       = block.text,
        render_text = block.render_text or block.text,
        color      = block.color or {255, 255, 255, 255},
        order      = block.order or 0,
    }
end

local function unregister_custom_indicator(key)
    custom_indicator_blocks[key] = nil
    custom_indicator_y[key]      = nil
end

local function paint_custom_indicators()
    local arr = {}
    for key, block in pairs(custom_indicator_blocks) do
        arr[#arr + 1] = { key = key, block = block }
    end
    table.sort(arr, function(a, b) return a.block.order < b.block.order end)

    for _, e in ipairs(arr) do
        local key, block = e.key, e.block
       

        local ok = (not block.condition) or block.condition()
        if ok then
            local text = resolve(block.render_text or block.text)
            if text and text ~= "" then
                local c = resolve(block.color) or {255, 255, 255, 255}
                local y = renderer.indicator(c[1], c[2], c[3], c[4] or 255, text)
                if y then custom_indicator_y[key] = y end
            end
        end
    end
end

local function get_custom_indicator_y(key)
    return custom_indicator_y[key]
end

W.indicator = W.indicator or {}
W.indicator.register   = register_custom_indicator
W.indicator.unregister = unregister_custom_indicator
W.indicator.paint      = paint_custom_indicators
W.indicator.get_y      = get_custom_indicator_y
visuals_things.indicator_paint = W.indicator.paint

W.indicator.register("slow", {
    condition = function()
        local lp = entity.get_local_player()
        return lp and entity.is_alive(lp)
            and entity.get_prop(lp, "m_flVelocityModifier") ~= 1
    end,

    text = "SLOW",

    render_text = function()
        return "SLOW"
    end,

    color = function()
        local lp = entity.get_local_player()
        local vm = entity.get_prop(lp, "m_flVelocityModifier") or 1

        vm = math.max(0, math.min(1, vm))

        return {
            255,
            math.floor(vm * 255),
            0,
            255
        }
    end,

    order = 0,
})

W.indicator.register("ideal_tick", {
    condition = function()
        local ideal_tick = Menu.settings.ideal_tick
        return ideal_tick.hotkey:get() and ideal_tick:get()
    end,

    text  = "IDEAL-TICK",
    render_text = function()
        return "IDEAL-TICK"
    end,
    color = {78, 162, 186, 255},
    order = 10,
})

W.indicator.register("PEEK-ASSIST", {
    condition = function()
        local peek_bot = Menu.settings.peek_bot
        return peek_bot.hotkey:get() and peek_bot:get()
    end,

    text  = "PEEK-ASSIST",
    render_text = "PEEK-ASSIST",
    color = {184, 192, 227, 255},
    order = 20,
})

W.indicator.register("autobreaklagcomp", {
    condition = function()
        local enabled = Menu.settings.auto_teleport:get() and Menu.settings.auto_teleport.hotkey:get()
        return enabled
    end,
    text = "AUTOBREAKLAGCOMP",
    render_text = "AUTO-LC",
    color = {115, 230, 186, 255},
    order = 60,
})

W.side.register_rule("freestanding", {
    match = { "FS", "FREESTANDING" },

    visible = function()
        local ideal_tick = Menu.settings.ideal_tick
        return not (ideal_tick and ideal_tick.hotkey:get() and ideal_tick:get())
    end,

    render_text = function()
        return "FS"
    end,

    icon = function()
        return resolve_icon_for_label("FS")
    end,

    order = 5,
    priority = 10,
})

W.side.register_rule("ideal_tick_side", {
    match = { "IDEAL-TICK", "IDEAL TICK", "IT" },

    visible = function()
        local ideal_tick = Menu.settings.ideal_tick
        return ideal_tick and ideal_tick.hotkey:get() and ideal_tick:get()
    end,

    render_text = function()
        return "IDEAL-TICK"
    end,

    icon = function()
        return resolve_icon_for_label("IDEAL-TICK")
    end,

    order = 10,
    priority = 20,
})

W.side.register_rule("peek_assist_side", {
    match = { "PEEK-ASSIST", "PEEK ASSIST" },

    render_text = "PEEK-ASSIST",
    icon = function()
        return resolve_icon_for_label("PEEK-ASSIST")
    end,

    order = 20,
    priority = 10,
})

W.side.register_rule("minimum damage", {
    match = { "MD" },

    render_text = function()
        return "MD: ".. F.get_current_dmg()
    end,
    icon = function()
        return resolve_icon_for_label("MD")
    end,

    order = 20,
    priority = 10,
})

local catch_indicators = function(data)
    local label = normalize_text(data.text)
    if not label or label == "" then return end

    if label:match("^[AB]%f[%A]") then
        bomb_cache.timer = label
        bomb_cache.color = {data.r, data.g, data.b}
        return
    end

    if label:find("FATAL") then
        bomb_cache.fatal = label
        return
    end

    if label:find("HP") then
        bomb_cache.damage = label
        return
    end

    local resolved = resolve_side_rule({
        label = label,
        r = data.r,
        g = data.g,
        b = data.b,
        raw = data,
    })

    if resolved == false then
        return
    end

    local final_label = (resolved and resolved.text and resolved.text ~= "") and resolved.text or label
    local final_color = (resolved and resolved.color) or {data.r, data.g, data.b}
    local final_icon  = (resolved and resolved.icon) or resolve_icon_for_label(final_label) or resolve_icon_for_label(label)

    local key = (resolved and resolved.key) or upper_text(final_label) or upper_text(label) or label
    local item = normalize_indicator_data(final_label, final_color, final_icon, nil)
    item.order = (resolved and resolved.order) or ind_order_n

    ind_frame[key] = item
    ind_order_n = ind_order_n + 1
end

Menu.settings.visuals.side:set_callback(function(self)
    if self:get() then
        client.set_event_callback("indicator", catch_indicators)
    else
        client.unset_event_callback("indicator", catch_indicators)
    end
end, true)

end

do

local dmg_state = {
    alpha = 0.0,
    value = 0.0
}

local weapon_allowed = {
    
    CWeaponGlock = true,
    CWeaponHKP2000 = true,
    CWeaponUSP = true,
    CWeaponP250 = true,
    CWeaponFiveSeven = true,
    CWeaponTec9 = true,
    CWeaponElite = true,
    CWeaponCZ75A = true,
    CDEagle = true,

    
    CWeaponMP9 = true,
    CWeaponMP7 = true,
    CWeaponMP5Navy = true,
    CWeaponUMP45 = true,
    CWeaponP90 = true,
    CWeaponBizon = true,
    CWeaponMac10 = true,

    
    CWeaponAK47 = true,
    CWeaponM4A1 = true,
    CWeaponM4A1_Silencer = true,
    CWeaponGalilAR = true,
    CWeaponFamas = true,
    CWeaponSSG08 = true,
    CWeaponAUG = true,
    CWeaponSG556 = true,
    CWeaponAWP = true,
    CWeaponG3SG1 = true,
    CWeaponSCAR20 = true,

    
    CWeaponNova = true,
    CWeaponXM1014 = true,
    CWeaponSawedoff = true,
    CWeaponMag7 = true,

    
    CWeaponM249 = true,
    CWeaponNegev = true,

    
    CWeaponTaser = true,
}


function visuals_things.draw_damage_indicator()
    local lp = entity.get_local_player()

    if not lp or not entity.is_alive(lp) then
        return
    end

    local weapon = entity.get_player_weapon(lp)

    if not weapon then
        return
    end

    local classname = entity.get_classname(weapon)

    if not weapon_allowed[classname] then
        return
    end

    local dmg, override = F.get_current_dmg()

    if not dmg then
        return
    end

    local sw, sh = client.screen_size()

    local x, y = drag_system:get_position(
        "damage_indicator",
        sw,
        0
    )
    if ui.is_menu_open() then
        x, y = drag_system:update(
            "damage_indicator",
            x,
            y,
            20,
            20
        )
    end

    local ft = globals.frametime()

    dmg_state.alpha = dmg_state.alpha +
        ((1 - dmg_state.alpha) * math.min(ft * 12, 1))

    dmg_state.value = dmg_state.value +
        ((dmg - dmg_state.value) * math.min(ft * 12, 1))

    local r, g, b = 255, 255, 255

    if override then
        r, g, b = Menu.settings.visuals.accent:get()
    end

    local text = tostring(math.floor(dmg_state.value + 0.5))

    renderer.text(
        x + 10,
        y + 10,
        r,
        g,
        b,
        math.floor(255 * dmg_state.alpha),
        "c",
        0,
        text
    )

    if ui.is_menu_open() then
        renderer.circle_outline(
            x,
            y,
            255,
            255,
            255,
            40,
            12,
            0,
            1
        )
    end
end
end

do 



local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}

local MAX_TARGETS = 5

local markers_round_dmg = {}   

local markers = {
    list = {}
}

local function find_marker(ent)
    for i=1, #markers.list do
        if markers.list[i].target == ent then
            return markers.list[i]
        end
    end
end

local function push_markers(m)
    if #markers.list >= MAX_TARGETS then
            table.remove(markers.list, 1)
    end
    table.insert(markers.list, m)
end


local function aim_fire(e)
    local m = find_marker(e.target)

    if not m then
        local round_total = markers_round_dmg[e.target] or 0
        m = {
            target        = e.target,
            hits          = {},
            dmg_sum       = round_total,
            displayed_dmg = round_total, 
            start_time    = globals.curtime(),
            alpha         = 0,
            offset        = 0,
        }
        push_markers(m)
    else
        m.start_time = globals.curtime()
    end

    m.last_id  = e.id
    m.miss     = false
    m.reason   = nil
    m.pos      = {entity.hitbox_position(e.target, e.hitgroup)}
    m.hitgroup = e.hitgroup

    table.insert(m.hits, {
        dmg      = 0,
        time     = globals.curtime(),
        hitgroup = e.hitgroup,
        pos      = m.pos
    })
end

local function aim_hit(e)
    local m = find_marker(e.target)
    if not m or m.last_id ~= e.id then return end
    if not Menu.settings.visuals.marker_list:get("Damage") then return end
    m.miss = false

    local dmg = e.damage or 0

    markers_round_dmg[e.target] = (markers_round_dmg[e.target] or 0) + dmg
    m.dmg_sum = markers_round_dmg[e.target]

    m.pos = {entity.hitbox_position(e.target, e.hitgroup)}

    local last = m.hits[#m.hits]
    if last then
        last.dmg = dmg
        last.pos = m.pos
    end
end

local function aim_miss(e)
    local m = find_marker(e.target)
    if not m or m.last_id ~= e.id then return end
    if not Menu.settings.visuals.marker_list:get("On miss") then return end
    m.miss = true 
    m.reason = e.reason
end

function visuals_things.draw_markers()
    local now = globals.curtime()
    local ft  = globals.frametime()

    for i = #markers.list, 1, -1 do
        local m = markers.list[i]
        local dt = now - m.start_time
        local life = 3.5
        if dt > life then
            table.remove(markers.list, i)
        else
            local fade_in = clamp(dt / 0.2, 0, 1)
            local fade_out = clamp((life - dt) / 0.5, 0, 1)
            local target_alpha = fade_in * fade_out

            m.alpha = lerp(m.alpha or 0, target_alpha, 0.15)
            local alpha = clamp(math.floor(m.alpha * 255), 0, 255)

            if not m.displayed_dmg then m.displayed_dmg = 0 end
            if m.dmg_sum > m.displayed_dmg then
                m.displayed_dmg = m.displayed_dmg + (m.dmg_sum - m.displayed_dmg) * math.min(ft * 18, 1)
            else
                m.displayed_dmg = m.dmg_sum
            end

            if alpha > 1 and m.pos then
                local sx, sy = renderer.world_to_screen(
                    m.pos[1],
                    m.pos[2],
                    m.pos[3] + (dt * 8)
                )

                if sx and sy then
                    local text
                    local accent_string = "\a"..rgb2hex(Menu.settings.visuals.accent:get())
                    local r,g,b = 255,255,255
                    if m.miss then 
                        text = "\aB04733FF" .. (m.reason or "miss")
                    else
                        local shown = math.floor(m.displayed_dmg + 0.5)
                        text = accent_string .. tostring(shown > 0 and shown or "")
                    end

                    renderer.text(sx, sy, r, g, b, alpha, "cb", 0, text)
                end
            end
        end
    end
end

local function reset_markers()
    markers.list       = {}
    markers_round_dmg  = {}
end
    Menu.settings.visuals.markers:set_callback(function(self)
        if self:get() then
            client.set_event_callback("round_start", reset_markers)
            client.set_event_callback("aim_miss", aim_miss)
            client.set_event_callback("aim_hit", aim_hit)
            client.set_event_callback("aim_fire", aim_fire)
        else
            client.unset_event_callback("round_start", reset_markers)
            client.unset_event_callback("aim_miss", aim_miss)
            client.unset_event_callback("aim_hit", aim_hit)
            client.unset_event_callback("aim_fire", aim_fire)
        end
    end)

end


do
    local i = 0;
    local function l()
        if not Menu.toggle:get() then
            return false;
        end
        if not Menu.settings.visuals.watermark.enabled:get() and not Menu.settings.crosshair:get() then
            return true
        end

        return Menu.settings.force_watermark:get();
    end
    local function _()
        local e, e = client.screen_size();
        local H, j, T = Menu.settings.visuals.accent:get();
        local L = (l() and 255) or 0;
        i = Y.interp(i, L, 0.15);
        if i > 0 then
            renderer.measure_text("b", string.format("%s %s %s / %s", U.name, U.build, U.version, U.username));
            renderer.text(20, (e / 2) + 250, 255, 255, 255, math.floor(i), "b", 0,
                string.format("\7%s%s %s %s\7%s / %s", F.rgba_to_hex(H, j, T, i), U.name, U.build, U.version,
                    F.rgba_to_hex(255, 255, 255, i), U.username));
        end
    end
    do
        local e = false;
        local function H()
            if l() or (i > 0) then
                if not e then
                    client.set_event_callback("paint", _);
                    e = true;
                end
            elseif e then
                if i < 1 then
                    client.unset_event_callback("paint", _);
                    e = false;
                    i = 0;
                end
            end
        end
        for i, i in ipairs(C) do
            i:set_callback(H, true);
        end
        Menu.toggle:set_callback(H, true);
    end
end
do
    local C = Menu.settings.crosshair;
    local i = 0;
    local l = 0;
    local _ = 0;
    local e = {};
    local function H(j, T, L, K, J, y, P, f, u)
        local M = globals.realtime() * J * 0.17;
        local J = #K;
        if J == 0 then
            return;
        end
        local o = {""};
        local X = (math.cos(M) + 1) * 0.5;
        local b = 0.22 + (0.12 * math.cos(M * 1.7));
        for t = 1, J do
            local z = K:sub(t, t);
            local K = (t - 1) / (((J > 1) and (J - 1)) or 1);
            local J = (M * 2) + (K * math.pi * 2);
            local t = (math.cos(J) + 1) * 0.5;
            local n = math.abs(K - X);
            local K = math.max(0, 1 - (n / b));
            local X = F.lerp_color(y, P, t);
            local y = F.lerp_color(X, f, K * 0.65);
            local P = F.lerp_color(y, u, math.abs(math.cos((J * 0.5) + (M * 0.9))) * 0.5);
            if K > 0.9 then
                P.r = math.min(255, P.r + (18 * (K - 0.9) * 10));
                P.g = math.min(255, P.g + (16 * (K - 0.9) * 10));
                P.b = math.min(255, P.b + (12 * (K - 0.9) * 10));
            end
            local K = F.rgba_to_hex(math.max(0, math.min(P.r + 0.5, 255)), math.max(0, math.min(P.g + 0.5, 255)),
                math.max(0, math.min(P.b + 0.5, 255)), math.max(0, math.min(L, 255)));
            o[#o + 1] = "\7";
            o[#o + 1] = K;
            o[#o + 1] = z;
        end
        local F = table.concat(o);
        renderer.text(j, T, 255, 255, 255, L, "cb", 0, F);
    end
    local F = {
        alpha = 0,
        offset_y = 0,
        add_x = 0,
        width_progress = 0,
        progress = 0,
        max_time = 3,
        height = 2,
        base_offset = 7.99
    };
    local function j(T, L, K, J)
        local y = math.max(0, math.min(1, T / F.max_time));
        local P = T > 0;
        F.alpha = Y.interp(F.alpha, (P and 255) or 0, 0.1);
        F.offset_y = Y.interp(F.offset_y, (P and F.base_offset) or 0, 0.1);
        F.width_progress = Y.interp(F.width_progress, P, 0.1);
        F.progress = Y.interp(F.progress, y, 0.1);
        if F.alpha > 1 then
            local T = (L and ((K / 2) + J + 0.99)) or 0;
            F.add_x = Y.interp(F.add_x, T, 0.05);
        end
    end
    local function T(L, K, J, y, P, f, u)
        if F.alpha < 1 then
            return;
        end
        local M = J * F.width_progress;
        local J = (K / 2) + _ + F.offset_y;
        local K = (((L / 2) + F.add_x) - (M / 2)) + 1;
        local L = K + (M * F.progress);
        renderer.rectangle(K, J - 1, M, F.height + 1, 0, 0, 0, F.alpha * 0.5 * (u / 255));
        for M = 0, F.height - 1 do
            renderer.line(K, J + M, L, J + M, y, P, f, F.alpha * (u / 255));
        end
    end
    local function L(K)
        for J, y in ipairs(K) do
            if not e[J] then
                e[J] = {
                    add_x = 0,
                    alpha = 0,
                    color_r = 255,
                    color_g = 255,
                    color_b = 255
                };
            end
            local K = e[J];
            K.name = y.name;
            K.value = y.value;
            K.target_color = y.color;
            K.use_gradient = y.use_gradient or false;
            K.gradient_colors = y.gradient_colors;
            K.measure = renderer.measure_text("cb", y.name) + 0.99;
            local J = (K.value and 255) or 0;
            K.alpha = Y.interp(K.alpha, J, 0.05);
            K.color_r = Y.interp(K.color_r, y.color[1], 0.1);
            K.color_g = Y.interp(K.color_g, y.color[2], 0.1);
            K.color_b = Y.interp(K.color_b, y.color[3], 0.1);
        end
    end
    local function K(J, y, P, f, u)
        local M = math.floor(10 + (F.width_progress * 6) + 0.5);
        for o, o in ipairs(e) do
            if o.alpha > 1 then
                local e = (P and ((o.measure / 2) + f)) or 0;
                o.add_x = Y.interp(o.add_x, e, 0.05);
                local e = (J / 2) + o.add_x;
                local J = (y / 2) + _ + M;
                local y = o.alpha * (u / 255);
                if o.use_gradient then
                    local P, f, u, X;
                    if o.gradient_colors then
                        P = o.gradient_colors.col1_start;
                        f = o.gradient_colors.col1_end;
                        u = o.gradient_colors.col2_start;
                        X = o.gradient_colors.col2_end;
                    else
                        P = {
                            r = 255,
                            g = 100,
                            b = 100,
                            a = y
                        };
                        f = {
                            r = 255,
                            g = 200,
                            b = 200,
                            a = y
                        };
                        u = {
                            r = 255,
                            g = 255,
                            b = 255,
                            a = y
                        };
                        X = {
                            r = 255,
                            g = 220,
                            b = 220,
                            a = y
                        };
                    end
                    H(e, J, y, o.name, 12.5, P, f, u, X);
                else
                    renderer.text(e, J, o.color_r, o.color_g, o.color_b, y, "cb", 0, o.name);
                end
                M = M + 11;
            end
        end
    end
    local function e()
        local H = Menu.toggle:get() and C:get();
        local J = entity.get_local_player();
        local y = (H and entity.is_alive(J) and 255) or 0;
        i = Y.interp(i, y, 0.15);
        if (not H) and (i < 1) then
            return;
        end
        local H, y = client.screen_size();
        local P, f, u = Menu.settings.visuals.accent:get();
        local M = renderer.measure_text("cb", U.name:lower());
        local o = entity.get_prop(J, "m_bIsScoped") == 1;
        local J = (o and ((M / 2) + 5)) or 0;
        l = Y.interp(l, J, 0.05);
        local J = (Menu.settings.arrow:get() and 49.99) or 20;
        _ = Y.interp(_, J, 0.05);
        renderer.text((H / 2) + l, (y / 2) + _, P, f, u, i, "cb", 0, U.name:lower());
        local J = r.time_left or 0;
        j(J, o, M, 5);
        T(H, y, M, P, f, u, i);
        local j = c.rage.aimbot.double_tap[1]:get() and c.rage.aimbot.double_tap[1].hotkey:get();
        local T = c.aa.other.on_shot_anti_aim[1]:get() and c.aa.other.on_shot_anti_aim[1].hotkey:get();
        local J = ctx:get_exploit();
        local M = "exploit";
        local X = {255, 255, 255};
        local b = false;
        if j and T then
            M = "exploit [!!!]";
            X = {196, 127, 109};
        elseif T then
            X = {230, 255, 132};
        end
        if (j or T) and (not J) then
            M = "exploit charging";
            b = true;
        end
        local J = {{
            name = U.build:lower(),
            value = true,
            color = {255, 255, 255},
            use_gradient = true,
            gradient_colors = {
                col1_start = {
                    r = P,
                    g = f,
                    b = u,
                    a = i
                },
                col1_end = {
                    r = P,
                    g = f,
                    b = u,
                    a = i
                },
                col2_start = {
                    r = 255,
                    g = 255,
                    b = 255,
                    a = i
                },
                col2_end = {
                    r = 255,
                    g = 255,
                    b = 255,
                    a = i
                }
            }
        }, {
            name = r.state:lower(),
            value = true,
            color = {255, 255, 255},
            use_gradient = false
        }, {
            name = M,
            value = (j or T),
            color = X,
            use_gradient = b
        }, {
            name = "safe",
            value = c.rage.aimbot.force_safe:get(),
            color = {255, 255, 255},
            use_gradient = false
        }, {
            name = "body",
            value = c.rage.aimbot.force_body:get(),
            color = {255, 255, 255},
            use_gradient = false
        }};
        L(J);
        K(H, y, o, 5, i);
    end
    do
        local H = false;
        local function r()
            i = 0;
            l = 0;
            _ = 0;
            F.alpha = 0;
            F.offset_y = 0;
            F.add_x = 0;
            F.width_progress = 0;
            F.progress = 0;
        end
        local function l(_)
            local F = Menu.toggle:get() and _:get();
            if F or (i > 0) then
                if not H then
                    client.set_event_callback("paint", e);
                    H = true;
                end
            elseif H and (i < 1) then
                client.unset_event_callback("paint", e);
                H = false;
                r();
            end
        end
        C:set_callback(l, true);
    end
end
do

end
do
    local tp = {
        when = 0,
        used = false,
        restored = true,
        peek_locked = false, 
    }

    local function auto_teleport()
        local force_recharge = Menu.settings.auto_teleport_options:get("Force recharge")
        local only_in_air     = Menu.settings.auto_teleport_options:get("Only in air")
        local force_only      = Menu.settings.auto_teleport_force_only:get()

        local peeking = r.is_peeking()

        if not peeking and tp.peek_locked then
            tp.peek_locked = false
        end

        if tp.used and not tp.restored then
            local should_restore

            if force_recharge then
                local timer_ok = (globals.realtime() - tp.when) > Menu.settings.auto_teleport_delay:get() / 1000
                should_restore = timer_ok
            else
                should_restore = not peeking
            end

            if should_restore then
                c.rage.aimbot.double_tap[1]:override()
                c.aa.other.on_shot_anti_aim[1]:override()
                tp.restored = true
            end
        end

        if not Menu.settings.auto_teleport:get() then return end

        local player = entity.get_local_player()
        if not player or not entity.is_alive(player) then
            tp.used = false
            tp.peek_locked = false
            return
        end

        local dt = c.rage.aimbot.double_tap[1]:get() and c.rage.aimbot.double_tap[1].hotkey:get()
        local osaa = c.aa.other.on_shot_anti_aim[1]:get() and c.aa.other.on_shot_anti_aim[1].hotkey:get()
        if not ((dt or osaa) and ctx:get_exploit()) then return end

        if peeking then
            local air_ok = true
            if only_in_air then
                air_ok = not ctx.on_ground
            end

            if not air_ok then
            elseif force_recharge and force_only and tp.peek_locked then
            else
                c.rage.aimbot.double_tap[1]:override(false)
                c.aa.other.on_shot_anti_aim[1]:override(false)
                tp.used = true
                tp.restored = false
                tp.when = globals.realtime()

                if force_recharge and force_only then
                    tp.peek_locked = true
                end
            end
        end
    end

    Menu.settings.auto_teleport:set_callback(function(self)
        if self:get() then
            client.set_event_callback("setup_command", auto_teleport)
        else
            client.unset_event_callback("setup_command", auto_teleport)
        end
    end)
    
end

do
    local C = Menu.settings.arrow;
    local i = 0;
    local l = 0;
    local _ = 0;
    local F = nil;
    local function e()
        local H = Menu.toggle:get() and C:get();
        local r = entity.get_local_player();
        local j = (H and entity.is_alive(r) and 255) or 0;
        i = Y.interp(i, j, 0.15);
        if (not H) and (i < 1) then
            return;
        end
        if not ctx.real_yaw then
            return;
        end
        local H, r, j = Menu.settings.visuals.accent:get();
        local T = ctx.side;
        F = F or T;
        local F = ((T == q.LEFT) and 1) or 0;
        local L = ((T == q.RIGHT) and 1) or 0;
        l = Y.interp(l, F, 0.18);
        _ = Y.interp(_, L, 0.18);
        local F = {255, 255, 255};
        local q = {math.floor((H * l) + (F[1] * (1 - l))), math.floor((r * l) + (F[2] * (1 - l))),
                   math.floor((j * l) + (F[3] * (1 - l))), i};
        local T = {math.floor((H * _) + (F[1] * (1 - _))), math.floor((r * _) + (F[2] * (1 - _))),
                   math.floor((j * _) + (F[3] * (1 - _))), i};
        local F = ctx.real_yaw;
        
        local H = math.rad(F - 90 - 1)
        local r = math.rad(F - 90 + 1)
        local F, j = client.screen_size();
        local L = h((F / 2) + 1, j / 2);
        local h = math.rad(24);
        renderer.triangle(L.x + (28 * math.cos(H)), L.y - (28 * math.sin(H)), L.x + (40 * math.cos(H)),
            L.y - (40 * math.sin(H)), L.x + (24 * math.cos(H - h)), L.y - (24 * math.sin(H - h)), q[1], q[2], q[3], q[4]);
        renderer.triangle(L.x + (28 * math.cos(r)), L.y - (28 * math.sin(r)), L.x + (40 * math.cos(r)),
            L.y - (40 * math.sin(r)), L.x + (24 * math.cos(r + h)), L.y - (24 * math.sin(r + h)), T[1], T[2], T[3], T[4]);
    end
    do
        local h = false;
        local function F(q)
            local H = Menu.toggle:get() and q:get();
            if H or (i > 0) then
                if not h then
                    client.set_event_callback("paint", e);
                    h = true;
                end
            elseif h then
                if i < 1 then
                    client.unset_event_callback("paint", e);
                    h = false;
                    i = 0;
                    l = 0;
                    _ = 0;
                end
            end
        end
        C:set_callback(F, true);
    end
end
do
    local h = Menu.settings.scope;
    local C = 0;
    local i = 0;
    local function l()
        c.visuals.scope:override(true);
    end
    local function _()
        local F = entity.get_local_player();
        if (not F) or (not entity.is_alive(F)) then
            return;
        end
        local e = entity.get_player_weapon(F);
        if e == nil then
            return;
        end
        c.visuals.scope:override(false);
        local q = entity.get_prop(e, "m_zoomLevel");
        local e = entity.get_prop(F, "m_bIsScoped") == 1;
        local H = entity.get_prop(F, "m_bResumeZoom") == 1;
        local F = q ~= nil;
        local r = F and (q > 0) and e and (not H);
        local F = (r and 255) or 0;
        local e = (r and Menu.settings.scope_size:get()) or 0;
        C = Y.interp(C, F, 0.22);
        i = Y.interp(i, e, 0.15);
        local F = C;
        local e = i;
        if (F < 1) or (e < 1) then
            return;
        end
        local q, H = client.screen_size();
        local r = Menu.settings.scope_gap:get();
        local j = {Menu.settings.scope_color:get()};
        local T, L, K = j[1], j[2], j[3];
        local J = j[4] * (F / 255);
        local j = {Menu.settings.scope_color_2:get()};
        local y, P, f = j[1], j[2], j[3];
        local u = j[4] * (F / 255);
        q, H = q / 2, H / 2;
        if not Menu.settings.scope_exclude:get("Left") then
            renderer.gradient(q - r, H, -e * (F / 255), 1, T, L, K, J, y, P, f, u, true);
        end
        if not Menu.settings.scope_exclude:get("Right") then
            renderer.gradient(q + r, H, e * (F / 255), 1, T, L, K, J, y, P, f, u, true);
        end
        if not Menu.settings.scope_exclude:get("Top") then
            renderer.gradient(q, H - r, 1, -e * (F / 255), T, L, K, J, y, P, f, u, false);
        end
        if not Menu.settings.scope_exclude:get("Bottom") then
            renderer.gradient(q, H + r, 1, e * (F / 255), T, L, K, J, y, P, f, u, false);
        end
    end
    do
        local function F(e)
            local q = Menu.toggle:get() and e:get();
            if not q then
                C = 0;
                i = 0;
            end
            if q then
                client.set_event_callback("paint_ui", l);
                client.set_event_callback("paint", _);
            else
                client.unset_event_callback("paint_ui", l);
                client.unset_event_callback("paint", _);
                c.visuals.scope:override();
            end
        end
        h:set_callback(F, true);
    end
end
do
    local h = Menu.settings.zoom;
    local C = 0;
    local function i(l)
        local _ = entity.get_local_player();
        if (not _) or (not entity.is_alive(_)) then
            return;
        end
        local F, e = Menu.settings.zoom_fov:get(), Menu.settings.zoom_speed:get();
        local q = entity.get_prop(_, "m_bIsScoped") == 1;
        C = Y.interp(C, (q and F) or 0, e / 100);
        l.fov = l.fov - C;
    end
    do
        local function l(_)
            local F = Menu.toggle:get() and _:get();
            if not F then
                C = 0;
            end
            if F then
                client.set_event_callback("override_view", i);
                c.misc.miscellaneous.override_zoom_fov:set_enabled(false);
                c.misc.miscellaneous.override_zoom_fov:override(0);
            else
                client.unset_event_callback("override_view", i);
                c.misc.miscellaneous.override_zoom_fov:set_enabled(true);
                c.misc.miscellaneous.override_zoom_fov:override();
            end
        end
        h:set_callback(l, true);
    end
end
do
    local h = Menu.settings.logger;
    local C = {};
    local W = {};
        local SLOG = {
            max_entries = 5,
            row_h       = 26,
            gap_y       = 4,
            pad_x       = 10,
            icon_sz     = 14,
            icon_gap    = 6,
            radius      = 8,
            lifetime    = 4.0,
            fade_in     = 0.22,
            fade_out    = 0.40,
            min_w       = 160,
        }

        local slog_state = { list = {} }
        local slog_drag_inited = false

        local function push_screen_log(text, icon_type, color, icon_tex)
            if #slog_state.list >= SLOG.max_entries then
                table.remove(slog_state.list, 1)
            end
            table.insert(slog_state.list, {
                text       = text or "",
                icon_type  = icon_type,
                icon_tex   = icon_tex,
                color      = color or {255, 255, 255},
                start_time = globals.curtime(),
                alpha      = 0.0,
            })
        end

        W.logs = W.logs or {}
        W.logs.push = push_screen_log
        local function apply_alpha_to_text(text, a)
            local hex = string.format("%02x", a)

            return text:gsub("\a(%x%x%x%x%x%x)%x%x", function(rgb)
                return "\a" .. rgb .. hex
            end)
        end

        function visuals_things.draw_screen_logs()
            local now = globals.curtime()
            local lp  = entity.get_local_player()
            if not lp then return end
        
            local sw, sh = client.screen_size()
            local base_x, base_y = drag_system:get_position("screen_logs", sw, SLOG.min_w)

            local n = #slog_state.list
            local total_h = math.max(SLOG.row_h, n * (SLOG.row_h + SLOG.gap_y) - SLOG.gap_y)

            if ui.is_menu_open() then
                base_x, base_y = drag_system:update("screen_logs", base_x, base_y, SLOG.min_w, total_h)
            end
        
            for i = n, 1, -1 do
                local e = slog_state.list[i]
                if (now - e.start_time) > SLOG.lifetime then
                    table.remove(slog_state.list, i)
                end
            end
        
            n = #slog_state.list
            for i = 1, n do
                local e   = slog_state.list[i]
                local dt  = now - e.start_time
            
                local a
                if dt < SLOG.fade_in then
                    local t = dt / SLOG.fade_in
                    a = t * t
                elseif dt > (SLOG.lifetime - SLOG.fade_out) then
                    local t = (SLOG.lifetime - dt) / SLOG.fade_out
                    t = math.max(t, 0)
                    a = t * t
                else
                    a = 1.0
                end
                a = clamp(a, 0, 1)
            
                local a255 = math.floor(a * 255)
                if a255 < 2 then goto continue_slog end
            
                local tw    = text_w(e.text)
                local row_w = SLOG.pad_x + SLOG.icon_sz + SLOG.icon_gap + tw + SLOG.pad_x
                if row_w < SLOG.min_w then row_w = SLOG.min_w end
            
                local ry  = base_y + (i - 1) * (SLOG.row_h + SLOG.gap_y)
                local gc  = e.color
                
            
                draw_bg(base_x - row_w / 4, ry, row_w, SLOG.row_h, SLOG.radius)
                draw_inner_corner(base_x + 1  - row_w / 4, ry, 3, SLOG.row_h, SLOG.row_h / 2, "left", gc, a255)
            
                local ico_x = (base_x - row_w / 4) + SLOG.pad_x
                local ico_y = ry + math.floor((SLOG.row_h - SLOG.icon_sz) / 2)
            
                if e.icon_type == "hit" then
                    renderer.texture(tex.hit, ico_x, ico_y, SLOG.icon_sz, SLOG.icon_sz, gc[1], gc[2], gc[3], a255, "f")
                elseif e.icon_type == "miss" then
                    renderer.texture(tex.miss, ico_x-3, ico_y-3, 22, 22, 200, 100, 100, a255, "f")
                else
                    render_rec(ico_x, ico_y, SLOG.icon_sz, SLOG.icon_sz, 3, { 160, 160, 160, math.floor(a255 * 0.45) })
                end
            
                local tx = (base_x - row_w / 4) + SLOG.pad_x + SLOG.icon_sz + SLOG.icon_gap
                local ty = ry + math.floor((SLOG.row_h - renderer.measure_text("b", "0")) / 2) - 3
                render_text(tx, ty, 255, 255, 255, a255,apply_alpha_to_text(e.text, a255))
            
                ::continue_slog::
            end
        end
    

    local C = "spread";
    local i = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?",
               "gear"};
    local l = {
        hc = 0,
        bt = 0,
        predicted_dmg = 0,
        predicted_hitgroup = 0,
        calc_dmg = 0
    };
    local function Z(_)
        if not Menu.settings.resolver:get() then
            return nil;
        end
        if S[_] then
            return {
                yaw = math.floor(S[_].last_resolve_yaw),
                state = (S[_].aa_state or "U")
            };
        end
        return nil;
    end
    local function S(_)
        l.hc = math.floor(_.hit_chance);
        l.bt = globals.tickcount() - _.tick;
        l.predicted_dmg = _.damage;
        l.predicted_hitgroup = _.hitgroup;
    end
    local function _(F)
        local e = i[F.hitgroup + 1] or "?";
        local q = entity.get_player_name(F.target);
        local H = F.damage;
        local r = entity.get_prop(F.target, "m_iHealth");
        local j = l.hc;
        local T = l.bt;
        local L = i[l.predicted_hitgroup + 1] or "?";
        local L = "";
        if l.predicted_dmg > H then
            l.calc_dmg = l.predicted_dmg - H;
            L = "-" .. tostring(l.calc_dmg);
        elseif l.predicted_dmg < H then
            l.calc_dmg = H - l.predicted_dmg;
            L = "+" .. tostring(l.calc_dmg);
        elseif l.predicted_dmg == H then
            L = "+0";
        end
        local K = Z(F.target);
        local F = "";
        if K then
            F = string.format(" (%s: %d\194\176)", K.state, K.yaw);
        end
        local K, J, y = Menu.settings.visuals.accent:get();
        client.color_log(K, J, y, string.format("%s \0", U.name:lower()));
        local log
        if r == 0 then
            log = string.format("did -%d (%s) in %s (%d%%) to %s (%dms/%dt)%s", H, L, e, j, q,
                tonumber(totime(T) * 1000), T, F)
        else
            log = string.format("did -%d (%s) in %s (%d%%) to %s (hp left: %d | %dms/%dt)%s", H, L, e, j, q, r,
                    tonumber(totime(T) * 1000), T, F)
        end
        client.color_log(255, 255, 255, log)
        local col = "\a"..rgb2hex(Menu.settings.visuals.accent:get())
        local wh = "\a"..rgb2hex({200, 200, 200})
        log = string.format(wh.."Hit %s%s"..wh.." in the %s%s"..wh.." for %s%d"..wh.." (%s%s"..wh.. " health remaining)",col , q, col, e, col, H, col, r)
        push_screen_log(log, "hit",{Menu.settings.visuals.accent:get()}, nil)
    end
    local function F(e)
        local q = i[e.hitgroup + 1] or "?";
        local i = entity.get_player_name(e.target);
        local H = l.hc;
        local r = l.bt;
        local l = Z(e.target);
        local Z = "";
        if l and (e.reason ~= "spread") then
            Z = string.format(" (%s: %d\194\176)", l.state, l.yaw);
        end
        if e.reason == "?" then
            C = (l and "resolver") or "unknown";
        else
            C = e.reason;
        end
        client.color_log(255, 0, 50, string.format("%s \0", U.name:lower()));
        local log = string.format("missed shot due to %s (%d%%) (target: %s | group: %s | %dms/%dt)%s", C, H, i, q,
                tonumber(totime(r) * 1000), r, Z);
        client.color_log(255, 255, 255,log)
        local col = "\a"..rgb2hex({200, 100, 120})
        local wh = "\a"..rgb2hex({200, 200, 200})
        log = string.format(wh.."Missed shot due to %s%s"..wh.." (hitchance %d%%)", col, C, H)
        push_screen_log(log, "miss", {200, 100, 120}, nil)
    end
    do
        local function C(i)
            local l = Menu.toggle:get() and i:get();
            if l then
                client.set_event_callback("aim_fire", S);
                client.set_event_callback("aim_hit", _);
                client.set_event_callback("aim_miss", F);
            else
                client.unset_event_callback("aim_fire", S);
                client.unset_event_callback("aim_hit", _);
                client.unset_event_callback("aim_miss", F);
            end
        end
        h:set_callback(C, true);
    end
end




do
    local h = Menu.settings.ratio;
    local S = Menu.settings.ratio_width;
    local C = 0;
    local function i(l)
        local Z, _ = client.screen_size();
        local F = (Z * l) / _;
        C = Y.interp(C, F, 0.15);
        if l == 1 then
            C = 0;
        end
        client.set_cvar("r_aspectratio", tonumber(C));
    end
    local function l()
        client.set_cvar("r_aspectratio", 0);
    end
    local function Z()
        if Menu.toggle:get() and h:get() then
            local _ = 2 - (S:get() * 0.01);
            i(_);
        else
            l();
        end
    end
    do
        local function S(i)
            local _ = Menu.toggle:get() and i:get();
            if not _ then
                C = 0;
                return;
            end
            if _ then
                client.set_event_callback("paint", Z);
            else
                client.unset_event_callback("paint", Z);
            end
        end
        h:set_callback(S);
        client.set_event_callback("shutdown", l);
    end
end

local game_enhancer
do
    local fps_cvars = {
        ['Fix chams color'] = {'mat_autoexposure_max_multiplier', 0.2, 1},
        ['Disable dynamic Lighting'] = {'r_dynamiclighting', 0, 1},
        ['Disable dynamic Shadows'] = {'r_dynamic', 0, 1},
        ['Disable Shadows'] = {'r_shadows', 0, 1},
        ['Disable first-person tracers'] = {'r_drawtracers_firstperson', 0, 1},
        ['Disable ragdolls'] = {'cl_disable_ragdolls', 1, 0},
        ['Disable eye gloss'] = {'r_eyegloss', 0, 1},
        ['Disable eye movement'] = {'r_eyemove', 0, 1},
        ['Disable muzzle flash light'] = {'muzzleflash_light', 0, 1},
        ['Enable low CPU audio'] = {'dsp_slow_cpu', 1, 0},
        ['Disable bloom'] = {'mat_disable_bloom', 1, 0},
        ['Disable particles'] = {'r_drawparticles', 0, 1},
        ['Reduce breakable objects'] = {'func_break_max_pieces', 0, 15},
        ['Disable 3d sky'] = {'r_3dsky', 0, 1},
        ['Disable fog'] = {'fog_enable', 0, 1},
        ['Disable blood'] = {'violence_hblood', 0, 1},
        ['Disable decals'] = {'r_drawdecals', 0, 1}
    }

    local function on_smth_do()
        if not Menu.settings.optimization:get() then 
            for name, data in pairs(fps_cvars) do
                local cvar_name, boost_value, default_value = unpack(data)
                cvar[cvar_name]:set_int(default_value)
            end
            return
        end

        local selected_boosts = Menu.settings.optimization_list:get()
        for name, data in pairs(fps_cvars) do
            local cvar_name, boost_value, default_value = unpack(data)
            cvar[cvar_name]:set_int(table_contains(selected_boosts, name) and boost_value or default_value)
        end
    end

    Menu.settings.optimization:set_callback(on_smth_do, true)
    Menu.settings.optimization_list:set_callback(on_smth_do, true)
    client.set_event_callback("player_spawn", function()
        on_smth_do()
    end)

end

do
    local debug_enabled = Menu.information.debug

    local function togglerdebug(i)
        if i:get() then
            client.set_event_callback("paint", r.debug)
        else
            client.unset_event_callback("paint", r.debug)
        end
    end
    debug_enabled:set_callback(togglerdebug, true)
end
do
    local h = Menu.settings.viewmodel;
    local S, C = Menu.settings.viewmodel_in_scope, Menu.settings.viewmodel_center;
    local i, l, Z, _ = Menu.settings.viewmodel_fov, Menu.settings.viewmodel_x, Menu.settings.viewmodel_y, Menu.settings.viewmodel_z;
    local F, e, q, H = 68, 2.5, 0, -1.5;
    local r = client.find_signature("client_panorama.dll", "\1395\204\204\204\204\255\16\15\183\192");
    local j = ffi.cast("void****", ffi.cast("char*", r) + 2)[0];
    local ffi = vtable_thunk(2,
        "            struct {\n                char         __pad_0x0000[0x1cd];                   // 0x0000\n                bool         hide_vm_scope;                // 0x01d1\n            }\n        *(__thiscall*)(void*, unsigned int)");
    local function r()
        F = Y.interp(F, i:get(), 0.15);
        e = Y.interp(e, l:get() / 10, 0.15);
        q = Y.interp(q, Z:get() / 10, 0.15);
        H = Y.interp(H, _:get() / 10, 0.15);
        if C:get() and (entity.get_prop(entity.get_local_player(), "m_bIsScoped") == 1) then
            e = Y.interp(e, -9.0, 0.15);
            q = Y.interp(q, -1.0, 0.15);
            H = Y.interp(H, -3.5, 0.15);
        end
        client.set_cvar("viewmodel_fov", F);
        client.set_cvar("viewmodel_offset_x", e);
        client.set_cvar("viewmodel_offset_y", q);
        client.set_cvar("viewmodel_offset_z", H);
    end
    local function C()
        local i = entity.get_prop(entity.get_player_weapon(entity.get_local_player()), "m_iItemDefinitionIndex");
        if (not j) or (not i) then
            return;
        end
        local l = ffi(j, i);
        l.hide_vm_scope = not S:get();
    end
    do
        local function ffi(S)
            local i = Menu.toggle:get() and S:get();
            if not i then
                client.set_cvar("viewmodel_fov", 68);
                client.set_cvar("viewmodel_offset_x", 2.5);
                client.set_cvar("viewmodel_offset_y", 0);
                client.set_cvar("viewmodel_offset_z", -1.5);
            end
            if i then
                client.set_event_callback("paint", r);
                client.set_event_callback("run_command", C);
            else
                client.unset_event_callback("paint", r);
                client.unset_event_callback("run_command", C);
            end
        end
        h:set_callback(ffi, true);
    end
end
do
    local ffi = Menu.settings.animation_breaker;
    local h = Menu.settings.anim_in_moving;
    local S = Menu.settings.anim_in_air;
    local C = Menu.settings.anim_etc;
    local i = 0;
    local l = 0;
    local function Z(_)
        l = _.command_number;
    end
    local function _()
        local F = v(entity.get_local_player());
        if not entity.is_alive(entity.get_local_player()) then
            return;
        end
        local v = F:get_anim_state();
        local e = (globals.realtime() * 0.5) % 1;
        if (h:get() ~= "Off") and D then
            local q = ((c.aa.other.leg_movement:get() == "Never slide") and 7) or 0;
            local H = (((globals.tickcount() % 4) > 1) and q) or 1;
            if h:get() == "Static" then
                F:set_prop("m_flPoseParameter", 1, q);
            elseif h:get() == "Jitter" then
                c.aa.other.leg_movement:override((((l % 3) == 0) and "off") or "always slide");
                F:set_prop("m_flPoseParameter", (((globals.tickcount() % 4) > 1) and 0.5) or 1, H);
                if ctx.speed < 1 then
                    F:set_prop("m_flPoseParameter", client.random_float(0.4, 0.8), 7);
                end
            end
        end
        if (S:get() ~= "Off") and (not D) then
            local h = (((globals.tickcount() % 4) > 1) and 7) or 6;
            if S:get() == "Static" then
                F:set_prop("m_flPoseParameter", 1, 6);
            elseif S:get() == "Jitter" then
                F:set_prop("m_flPoseParameter", 1, h);
            elseif S:get() == "Walking" then
                F:get_anim_overlay(6).weight = 1;
                F:get_anim_overlay(7).cycle = e;
                F:get_anim_overlay(6).cycle = e;
            end
        end
        if C:get("Zero pitch on land") and v.hit_in_ground_animation and (v.magic_fraction == 1) and D then
            F:set_prop("m_flPoseParameter", 0.5, 12);
        end
        if C:get("Disable balance adjustment") then
            F:get_anim_overlay(3).weight = 0;
            F:get_anim_overlay(3).cycle = 0;
            F:get_anim_overlay(3).sequence = 979;
        end
        if C:get("Smooth yaw angles") then
            i = Y.interp(i, F:get_prop("m_flPoseParameter", 11), 0.15);
            F:set_prop("m_flPoseParameter", i, 11);
        end
        if C:get("Smooth player animation") then
            F:get_anim_overlay(12).cycle = e;
            F:get_anim_overlay(7).cycle = e;
            F:get_anim_overlay(6).cycle = e;
        end
    end
    do
        local function h(S)
            local Y = Menu.toggle:get() and S:get();
            if Y then
                client.set_event_callback("run_command", Z);
                client.set_event_callback("pre_render", _);
            else
                client.unset_event_callback("run_command", Z);
                client.unset_event_callback("pre_render", _);
            end
        end
        ffi:set_callback(h, true);
    end
end
do
    local ffi = Menu.settings.clan_tag;
    local h = "";
    local function S(Y)
        return math.floor((Y / globals.tickinterval()) + 0.5);
    end
    local function Y(C)
        local i = tostring(C);
        local C = #i;
        globals.tickinterval();
        local v = globals.tickcount() + S(client.latency()) + 6107;
        local l = C;
        local Z = S(3.525666 / l);
        local S = math.floor(v / Z) % l;
        if C > 0 then
            local C = i:sub(S + 1);
            local v = i:sub(1, S);
            return C .. v;
        else
            return i;
        end
    end
    local function S()
        if ffi:get() then
            local C = string.format("%s.fun ", U.name:lower());
            local U = Y(C);
            if U ~= h then
                client.set_clan_tag(U);
            end
            h = U;
        end
    end
    local function U()
        local Y = entity.get_local_player();
        if (Y ~= nil) and (not entity.is_alive(Y)) and ((globals.tickcount() % 2) == 0) then
            S();
        end
    end
    local function Y(C)
        if C.chokedcommands == 0 then
            S();
        end
    end
    do
        local function S(C)
            local i = Menu.toggle:get() and C:get();
            if not i then
                h = "";
                client.set_clan_tag("\0");
            end
            if i then
                client.set_event_callback("paint", U);
                client.set_event_callback("run_command", Y);
                c.misc.miscellaneous.clan_tag_spammer:override(false);
                c.misc.miscellaneous.clan_tag_spammer:set_enabled(false);
            else
                client.unset_event_callback("paint", U);
                client.unset_event_callback("run_command", Y);
                c.misc.miscellaneous.clan_tag_spammer:override();
                c.misc.miscellaneous.clan_tag_spammer:set_enabled(true);
            end
        end
        ffi:set_callback(S, true);
    end
end


do

    local function get_buybot_config()
        local cfg = {}

        for _, item in ipairs(Menu.settings.buybot_list:get()) do
            cfg[item] = true
        end

        return cfg
    end

    local function buybot()
        if not Menu.settings.buybot:get() or not Menu.toggle:get() then
            return
        end

        local lp = entity.get_local_player()
        if not lp then
            return
        end

        local cfg = get_buybot_config()
        if cfg["16K$ REQUIRED"] then
            local money = entity.get_prop(lp, "m_iAccount") or 0
            if money < 7999 then
                return
            end
        end
        if cfg["AWP"] then
            client.exec("buy awp")
        elseif cfg["SSG08"] then
            client.exec("buy ssg08")
        elseif cfg["AUTO"] then
            client.exec("buy scar20; buy g3sg1")
        end

        if cfg["DEAGLE"] then
            client.exec("buy deagle")
        elseif cfg["TEC8/57/CZ"] then
            client.exec("buy tec9; buy fn57; buy cz75a")
        elseif cfg["DUALS"] then
            client.exec("buy elite")
        elseif cfg["P250"] then
            client.exec("buy p250")
        end

        if cfg["HE"] then
            client.exec("buy hegrenade")
        end

        if cfg["INC"] then
            client.exec("buy incgrenade; buy molotov")
        end

        if cfg["SMOKE"] then
            client.exec("buy smokegrenade")
        end

        if cfg["TASER"] then
            client.exec("buy taser")
        end

        if cfg["ARMOR"] then
            client.exec("buy vesthelm; buy vest")
        end

        if cfg["DEFUSER"] then
            client.exec("buy defuser")
        end
    end

    client.set_event_callback("player_spawn", function(e)
        if not Menu.settings.buybot:get() or not Menu.toggle:get() then return end
        local lp = entity.get_local_player()
        
        if not lp or client.userid_to_entindex(e.userid) ~= lp then
            return
        end

        client.delay_call(0.4, buybot)
    end)
end


client.exec("clear");
client.exec("con_filter_enable 1");
client.exec("con_filter_text \"[gamesense] emberlash.fun wtf familynap familytapping hard\"");


client.set_event_callback("paint", function()
    if not Menu.toggle:get() then return end
    visuals_things.indicator_paint()
    if Menu.settings.visuals.keybinds.enabled:get() then
        visuals_things.draw_keybinds_list()
    end
    if Menu.settings.visuals.watermark.enabled:get() then
        visuals_things.draw_watermark()
    end
    if Menu.settings.visuals.speclist.enabled:get() then
        visuals_things.draw_spectator_list()
    end
    if Menu.settings.visuals.side:get() then
        visuals_things.draw_side_indicator()
    end
    if Menu.settings.visuals.markers:get() then
        visuals_things.draw_markers()
    end
    if Menu.settings.visuals.damage:get() then
        visuals_things.draw_damage_indicator()
    end
    if Menu.settings.visuals.logger_on_screen:get() then
        visuals_things.draw_screen_logs()
    end
end)

