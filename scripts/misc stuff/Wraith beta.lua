-- Wraith Beta - improved readability

-- Libraries
local ffi = require 'ffi'
local bit = require 'bit'
local vector = require "vector"
local antiaim_funcs = require "gamesense/antiaim_funcs" or error "https://gamesense.pub/forums/viewtopic.php?id=29665"
local surface = require "gamesense/surface"
local base64 = require "gamesense/base64" or error("Base64 library required")
local clipboard = require "gamesense/clipboard" or error("Clipboard library required")

-- Global aliases
local require_fn, pcall_fn, ipairs_fn, pairs_fn, unpack_fn = require, pcall, ipairs, pairs, unpack
local tonumber_fn, tostring_fn, toticks_fn, totime_fn = tonumber, tostring, toticks, totime

-- FFI
local ffi_ns = {
    new = ffi.new, typeof = ffi.typeof, cast = ffi.cast,
    cdef = ffi.cdef, sizeof = ffi.sizeof, string = ffi.string
}

-- Panorama
local panorama_ns = {
    loadstring = panorama.loadstring,
    open = panorama.open
}

-- Plist
local plist_ns = {
    get = plist.get,
    set = plist.set
}

-- Config
local config_ns = {
    export = config.export,
    import = config.import,
    load = config.load
}

-- Database
local database_ns = {
    flush = database.flush,
    read = database.read,
    write = database.write
}

-- Bit operations
local bit_ns = {
    arshift = bit.arshift, band = bit.band, bnot = bit.bnot,
    bor = bit.bor, bswap = bit.bswap, bxor = bit.bxor,
    lshift = bit.lshift, rol = bit.rol, ror = bit.ror,
    rshift = bit.rshift, tobit = bit.tobit, tohex = bit.tohex
}

-- String
local string_ns = {
    byte = string.byte, char = string.char, find = string.find,
    format = string.format, gmatch = string.gmatch, gsub = string.gsub,
    len = string.len, lower = string.lower, match = string.match,
    rep = string.rep, reverse = string.reverse, sub = string.sub,
    upper = string.upper
}

-- Math
local math_ns = {
    abs = math.abs, acos = math.acos, asin = math.asin, atan = math.atan,
    atan2 = math.atan2, ceil = math.ceil, cos = math.cos, cosh = math.cosh,
    deg = math.deg, exp = math.exp, floor = math.floor, fmod = math.fmod,
    frexp = math.frexp, ldexp = math.ldexp, log = math.log, log10 = math.log10,
    max = math.max, min = math.min, modf = math.modf, pow = math.pow,
    rad = math.rad, random = math.random, randomseed = math.randomseed,
    sin = math.sin, sinh = math.sinh, sqrt = math.sqrt, tan = math.tan,
    tanh = math.tanh, pi = math.pi
}

-- UI
local ui_ns = {
    get = ui.get, is_menu_open = ui.is_menu_open, menu_size = ui.menu_size,
    menu_position = ui.menu_position, mouse_position = ui.mouse_position,
    name = ui.name, new_button = ui.new_button, new_checkbox = ui.new_checkbox,
    new_color_picker = ui.new_color_picker, new_combobox = ui.new_combobox,
    new_hotkey = ui.new_hotkey, new_label = ui.new_label, new_listbox = ui.new_listbox,
    new_multiselect = ui.new_multiselect, new_slider = ui.new_slider,
    new_string = ui.new_string, new_textbox = ui.new_textbox,
    reference = ui.reference, set = ui.set, set_callback = ui.set_callback,
    set_visible = ui.set_visible, update = ui.update
}

-- Renderer
local renderer_ns = {
    blur = renderer.blur, circle = renderer.circle,
    circle_outline = renderer.circle_outline, gradient = renderer.gradient,
    indicator = renderer.indicator, line = renderer.line,
    load_jpg = renderer.load_jpg, load_png = renderer.load_png,
    load_rgba = renderer.load_rgba, load_svg = renderer.load_svg,
    measure_text = renderer.measure_text, rectangle = renderer.rectangle,
    text = renderer.text, texture = renderer.texture,
    triangle = renderer.triangle, world_to_screen = renderer.world_to_screen
}

-- Globals
local globals_ns = {
    absoluteframetime = globals.absoluteframetime,
    chokedcommands = globals.chokedcommands,
    commandack = globals.commandack,
    curtime = globals.curtime,
    framecount = globals.framecount,
    frametime = globals.frametime,
    lastoutgoingcommand = globals.lastoutgoingcommand,
    mapname = globals.mapname,
    maxplayers = globals.maxplayers,
    oldcommandack = globals.oldcommandack,
    realtime = globals.realtime,
    tickcount = globals.tickcount,
    tickinterval = globals.tickinterval
}

-- Entity
local entity_ns = {
    get_all = entity.get_all,
    get_bounding_box = entity.get_bounding_box,
    get_classname = entity.get_classname,
    get_esp_data = entity.get_esp_data,
    get_game_rules = entity.get_game_rules,
    get_local_player = entity.get_local_player,
    get_origin = entity.get_origin,
    get_player_name = entity.get_player_name,
    get_player_resource = entity.get_player_resource,
    get_player_weapon = entity.get_player_weapon,
    get_players = entity.get_players,
    get_prop = entity.get_prop,
    get_steam64 = entity.get_steam64,
    hitbox_position = entity.hitbox_position,
    is_alive = entity.is_alive,
    is_dormant = entity.is_dormant,
    is_enemy = entity.is_enemy,
    new_prop = entity.new_prop,
    set_prop = entity.set_prop
}

-- Client
local client_ns = {
    camera_angles = _G.client.camera_angles,
    camera_position = _G.client.camera_position,
    color_log = _G.client.color_log,
    create_interface = _G.client.create_interface,
    current_threat = _G.client.current_threat,
    delay_call = _G.client.delay_call,
    draw_debug_text = _G.client.draw_debug_text,
    draw_hitboxes = _G.client.draw_hitboxes,
    error_log = _G.client.error_log,
    exec = _G.client.exec,
    eye_position = _G.client.eye_position,
    find_signature = _G.client.find_signature,
    fire_event = _G.client.fire_event,
    get_cvar = _G.client.get_cvar,
    get_model_name = _G.client.get_model_name,
    key_state = _G.client.key_state,
    latency = _G.client.latency,
    log = _G.client.log,
    random_float = _G.client.random_float,
    random_int = _G.client.random_int,
    real_latency = _G.client.real_latency,
    register_esp_flag = _G.client.register_esp_flag,
    reload_active_scripts = _G.client.reload_active_scripts,
    request_full_update = _G.client.request_full_update,
    scale_damage = _G.client.scale_damage,
    screen_size = _G.client.screen_size,
    set_clan_tag = _G.client.set_clan_tag,
    set_event_callback = _G.client.set_event_callback,
    system_time = _G.client.system_time,
    timestamp = _G.client.timestamp,
    trace_bullet = _G.client.trace_bullet,
    trace_line = _G.client.trace_line,
    unix_time = _G.client.unix_time,
    unset_event_callback = _G.client.unset_event_callback,
    update_player_list = _G.client.update_player_list,
    userid_to_entindex = _G.client.userid_to_entindex,
    visible = _G.client.visible
}

-- Entity list interface
local void_ptr_type = ffi_ns.typeof('void***')
local entity_list_interface = client_ns.create_interface('client.dll', 'VClientEntityList003') or error('VClientEntityList003 wasnt found', 2)
local raw_entity_list = ffi_ns.cast(void_ptr_type, entity_list_interface) or error('rawientitylist is nil', 2)
local get_client_entity = ffi_ns.cast('void*(__thiscall*)(void*, int)', raw_entity_list[0][3]) or error('get_client_entity is nil', 2)
local get_client_networkable = ffi_ns.cast('void*(__thiscall*)(void*, int)', raw_entity_list[0][0]) or error('get_client_networkable_t is nil', 2)

-- FFI structures
ffi_ns.cdef([[
    struct animation_layer_t {
        char  pad_0000[20];
        uint32_t m_nOrder;
        uint32_t m_nSequence;
        float m_flPrevCycle;
        float m_flWeight;
        float m_flWeightDeltaRate;
        float m_flPlaybackRate;
        float m_flCycle;
        void *m_pOwner;
        char  pad_0038[4];
    };

    struct animstate_t1 {
        char pad[3];
        char m_bForceWeaponUpdate;
        char pad1[91];
        void* m_pBaseEntity;
        void* m_pActiveWeapon;
        void* m_pLastActiveWeapon;
        float m_flLastClientSideAnimationUpdateTime;
        int m_iLastClientSideAnimationUpdateFramecount;
        float m_flAnimUpdateDelta;
        float m_flEyeYaw;
        float m_flPitch;
        float m_flGoalFeetYaw;
        float m_flCurrentFeetYaw;
        float m_flCurrentTorsoYaw;
        float m_flUnknownVelocityLean;
        float m_flLeanAmount;
        char pad2[4];
        float m_flFeetCycle;
        float m_flFeetYawRate;
        char pad3[4];
        float m_fDuckAmount;
        float m_fLandingDuckAdditiveSomething;
        char pad4[4];
        float m_vOriginX;
        float m_vOriginY;
        float m_vOriginZ;
        float m_vLastOriginX;
        float m_vLastOriginY;
        float m_vLastOriginZ;
        float m_vVelocityX;
        float m_vVelocityY;
        char pad5[4];
        float m_flUnknownFloat1;
        char pad6[8];
        float m_flUnknownFloat2;
        float m_flUnknownFloat3;
        float m_flUnknown;
        float m_flSpeed2D;
        float m_flUpVelocity;
        float m_flSpeedNormalized;
        float m_flFeetSpeedForwardsOrSideWays;
        float m_flFeetSpeedUnknownForwardOrSideways;
        float m_flTimeSinceStartedMoving;
        float m_flTimeSinceStoppedMoving;
        bool m_bOnGround;
        bool m_bInHitGroundAnimation;
        char m_pad[2];
        float m_flJumpToFall;
        float m_flTimeSinceInAir;
        float m_flLastOriginZ;
        float m_flHeadHeightOrOffsetFromHittingGroundAnimation;
        float m_flStopToFullRunningFraction;
        char pad7[4];
        float m_flMagicFraction;
        char pad8[60];
        float m_flWorldForce;
        char pad9[462];
        float m_flMaxYaw;
    };
]])

database_ns.write("current_clip_board_to_save", "")

-- Filesystem
local filesystem_funcs = {}
local filesystem_signatures = {
    {'remove_search_path', '\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x8B\x55\x08\x53\x8B\xD9', 'void(__thiscall*)(void*, const char*, const char*)'},
    {'remove_file', '\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x8D\x85\xCC\xCC\xCC\xCC\x56\x50\x8D\x45\x0C', 'void(__thiscall*)(void*, const char*, const char*)'},
    {'find_next', '\x55\x8B\xEC\x83\xEC\x0C\x53\x8B\xD9\x8B\x0D\xCC\xCC\xCC\xCC', 'const char*(__thiscall*)(void*, int)'},
    {'find_is_directory', '\x55\x8B\xEC\x0F\xB7\x45\x08', 'bool(__thiscall*)(void*, int)'},
    {'find_close', '\x55\x8B\xEC\x53\x8B\x5D\x08\x85', 'void(__thiscall*)(void*, int)'},
    {'find_first', '\x55\x8B\xEC\x6A\x00\xFF\x75\x10\xFF\x75\x0C\xFF\x75\x08\xE8\xCC\xCC\xCC\xCC\x5D', 'const char*(__thiscall*)(void*, const char*, const char*, int*)'},
    {'get_current_directory', '\x55\x8B\xEC\x56\x8B\x75\x08\x56\xFF\x75\x0C', 'bool(__thiscall*)(void*, char*, int)'}
}

local ffi_lib = require('ffi')

local function create_interface_function(dll_name, interface_name, signature, typedef)
    local interface = client_ns.create_interface(dll_name, interface_name) or error("invalid interface", 2)
    local sig_address = client_ns.find_signature(dll_name, signature) or error("invalid signature", 2)
    local success, type_result = pcall_fn(ffi_lib.typeof, typedef)
    if not success then
        error(type_result, 2)
    end
    local func_ptr = ffi_lib.cast(type_result, sig_address) or error("invalid typecast", 2)
    return function(...)
        return func_ptr(interface, ...)
    end
end

for i = 1, #filesystem_signatures do
    local sig_data = filesystem_signatures[i]
    filesystem_funcs[sig_data[1]] = create_interface_function('filesystem_stdio.dll', 'VFileSystem017', sig_data[2], sig_data[3])
end

local add_search_path = vtable_bind("filesystem_stdio.dll", "VFileSystem017", 11, "void(__thiscall*)(void*, const char*, const char*, int)")
local CONFIG_FOLDER = "WRAITH_CONFIGS"
local current_dir_buffer = ffi_ns.typeof("char[128]")()
filesystem_funcs.get_current_directory(current_dir_buffer, ffi_ns.sizeof(current_dir_buffer))
local current_directory = string_ns.format('%s', ffi_ns.string(current_dir_buffer))
add_search_path(current_directory, CONFIG_FOLDER, 0)

local function get_config_files()
    local files, handle = {}, ffi_ns.typeof("int[1]")()
    local first_file = filesystem_funcs.find_first("*", CONFIG_FOLDER, handle)
    while first_file ~= nil do
        local filename = ffi_ns.string(first_file)
        if not filesystem_funcs.find_is_directory(handle[0]) and filename:find('2124089493w.cfg') then
            files[#files + 1] = filename
        end
        first_file = filesystem_funcs.find_next(handle[0])
    end
    filesystem_funcs.find_close(handle[0])
    return files
end

function update_cfg()
    local config_files = get_config_files()
    local config_names = {}
    for i = 1, #config_files do
        config_names[i] = config_files[i]:gsub('2124089493w.cfg', '')
    end
    return config_names
end

local is_command_line_param = vtable_bind("vgui2.dll", "VGUI_System010", 22, "bool(__thiscall*)(void*, const char*)")

-- User command structures
local button_flags = {
    attack = bit_ns.lshift(1, 0),
    use = bit_ns.lshift(1, 5)
}

local angle_struct = ffi_ns.typeof("struct { float pitch; float yaw; float roll; }")
local vector_struct = ffi_ns.typeof("struct { float x; float y; float z; }")
local usercmd_struct = ffi_ns.typeof([[
    struct {
        uintptr_t vfptr;
        int command_number;
        int tick_count;
        $ viewangles;
        $ aimdirection;
        float forwardmove;
        float sidemove;
        float upmove;
        int buttons;
        uint8_t impulse;
        int weaponselect;
        int weaponsubtype;
        int random_seed;
        short mousedx;
        short mousedy;
        bool hasbeenpredicted;
        $ headangles;
        $ headoffset;
    }
]], angle_struct, vector_struct, angle_struct, vector_struct)

local usercmd_vftable = ffi_ns.typeof("$* (__thiscall*)(uintptr_t ecx, int nSlot, int sequence_number)", usercmd_struct)
local input_vtable = ffi_ns.typeof([[
    struct {
        uintptr_t padding[8];
        $ GetUserCmd;
    }
]], usercmd_vftable)
local input_ptr = ffi_ns.typeof([[
    struct {
        $* vfptr;
    }*
]], input_vtable)

local input_interface = ffi_ns.cast(input_ptr, ffi_ns.cast("uintptr_t**", tonumber_fn(ffi_ns.cast("uintptr_t", client_ns.find_signature("client.dll", "\xB9\xCC\xCC\xCC\xCC\x8B\x40\x38\xFF\xD0\x84\xC0\x0F\x85") or error("client.dll!:input not found."))) + 1)[0])

-- State
local wraith_state = {
    reset_once = false,
    hitgroup_names = {[0] = "body", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"},
    fire_total_hits = 0,
    post_total_hits = 0,
    current_condition = "",
    mode = "back",
    is_defensive_running = false,
    banana = false,
    old_tick_count = 0,
    yaw_increment_spin = 0,
    tickbase_max = nil,
    tickbase_diff = nil,
    current_cmd = nil,
    bomb_defused = false,
    bomb_exploded = false,
    pulse = 240,
    started = 10,
    smooth_wraith = 0,
    smooth_dt = 0,
    smooth_os = 0,
    smooth_pc = 0,
    smooth_bo = 0,
    current_desync = 0,
    fake_fakelag = 0,
    cur = 0,
    is_defusing = false,
    desync_rect_dist = 0,
    dt_os_text_anim = 0,
    current_cond_text_anim = 0,
    smooth_wraith_recode = 0,
    smooth_dt_2 = 0,
    smooth_stance = 0,
    dt_vertical_dist = 0,
    jumping = false,
    on_ground = false,
    rage_fired = false,
    last_jump_ducked = false,
    landing = false,
    waiting_scan_text = 0,
    hittable = false,
    defensive_risk = 0,
    smooth_defensive_bar = 0,
    smooth_left_arrow = 0,
    smooth_right_arrow = 0,
    smooth_up_arrow = 0,
    smooth_arrow_alpha = 0
}

local player_data = {cur = {}, prev = {}, pre_prev = {}, pre_pre_prev = {}}
local anti_aim_data = {}
local player_aa_settings = {}
for player_idx = 1, 64 do
    player_aa_settings[player_idx] = {stand = {}, stand_type = {}, run = {}, run_type = {}, air = {}, air_type = {}, duck = {}, duck_type = {}}
end

local script_info = {user = "Femboy", build = "beta"}

-- UI
local main_checkbox = ui_ns.new_checkbox("AA", "Anti-aimbot angles", "wraith - " .. string_ns.lower(script_info["user"]))
local selected_aa_type = nil
local selected_condition = nil
local current_aa_settings = nil
local current_wraith_settings = nil

local ui_elements = {}
local gamesense_aa_settings = {}
local wraith_aa_settings = {}

local tab_names = {"anti-aim", "anti-aim 2", "visuals", "misc", "config", "debug"}
local condition_names = {"global", "standing", "moving", "slow motion", "in air", "in air duck", "in duck", "in duck moving", "in fake duck", "fakelag", "manual", "freestanding", "backstab", "height", "high distance", "legit"}
local icons = {lua = "", star = "", lock = "", arrows = "", pizza = "", ["up arrow"] = "", cpu = "", smilie = "", heart = ""}

local menu_state = {
    le_icon = "a",
    tabs_names = {"", "⑵", "", "", "", "F"},
    tab = {},
    selected_tab = 0,
    selected_color = {{20, 20, 20, 255}, {210, 210, 210, 255}},
    is_open = true,
    menu_alpha = 255,
    is_hovered = false,
    height = 68,
    dpi_scaling_y = {{84, 149}, {100, 181}, {116, 213}, {132, 245}, {148, 277}},
    selected_gs_tab = false,
    mouse_press = false,
    old_mpos = {0, 0}
}

local menu_key_pressed = false
local menu_initialized = false
local dpi_heights = {["100%"] = 68, ["125%"] = 75, ["150%"] = 85, ["175%"] = 95, ["200%"] = 105}

ui_elements = {
    tab = ui_ns.new_combobox("AA", "Anti-aimbot angles", "\n", tab_names),
    ["anti-aim"] = {
        [0] = ui_ns.new_combobox("AA", "Anti-aimbot angles", "type", "gamesense", "wraith (dont use)"),
        [1] = ui_ns.new_combobox("AA", "Anti-aimbot angles", "condition", condition_names)
    },
    ["anti-aim 2"] = {
        [0] = ui_ns.new_multiselect("AA", "Anti-aimbot angles", "add features", "other anti-aim binds", "manual anti-aim"),
        [1] = ui_ns.new_hotkey("AA", "Anti-aimbot angles", "edge-yaw"),
        [2] = ui_ns.new_hotkey("AA", "Anti-aimbot angles", "freestanding"),
        [3] = ui_ns.new_checkbox("AA", "Anti-aimbot angles", "manual anti-aim"),
        [4] = ui_ns.new_hotkey("AA", "Anti-aimbot angles", "left"),
        [8] = ui_ns.new_slider("AA", "Anti-aimbot angles", "\n left angle", 0, 145, 90, true, "°", 1, {}),
        [5] = ui_ns.new_hotkey("AA", "Anti-aimbot angles", "right"),
        [9] = ui_ns.new_slider("AA", "Anti-aimbot angles", "\n right angle", 0, 145, 90, true, "°", 1, {}),
        [6] = ui_ns.new_hotkey("AA", "Anti-aimbot angles", "forward"),
        [7] = ui_ns.new_hotkey("AA", "Anti-aimbot angles", "reset")
    },
    ["visuals"] = {
        [0] = ui_ns.new_combobox("AA", "Anti-aimbot angles", "indicators", "off", "minimal (og)", "anti urine", "recode alpha"),
        [1] = ui_ns.new_color_picker("AA", "Anti-aimbot angles", "anti-aim indicators", 200, 200, 255, 255),
        [6] = ui_ns.new_multiselect("AA", "Anti-aimbot angles", "indicator extras", "animations on scope", "lowercase", "min damage", "desync", "defensive"),
        [3] = ui_ns.new_combobox("AA", "Anti-aimbot angles", "indicators size", "small", "thin", "bold", "blind"),
        [2] = ui_ns.new_checkbox("AA", "Anti-aimbot angles", "watermark"),
        [4] = ui_ns.new_combobox("AA", "Anti-aimbot angles", "size", "small", "thin", "bold", "blind"),
        [7] = ui_ns.new_checkbox("AA", "Anti-aimbot angles", "notifications size"),
        [5] = ui_ns.new_combobox("AA", "Anti-aimbot angles", "\n nigga", "small", "thin", "bold", "blind"),
        [8] = ui_ns.new_combobox("AA", "Anti-aimbot angles", "extended teleport prediction", "off", "box", "circle"),
        [9] = ui_ns.new_checkbox("AA", "Anti-aimbot angles", "manual anti-aim"),
        [10] = ui_ns.new_color_picker("AA", "Anti-aimbot angles", "manual anti-aim", 200, 200, 200, 200)
    },
    ["misc"] = {
        [6] = ui_ns.new_hotkey("AA", "Anti-aimbot angles", "extended teleport"),
        [7] = ui_ns.new_hotkey("AA", "Anti-aimbot angles", "extended teleport on hit"),
        [8] = ui_ns.new_combobox("AA", "Anti-aimbot angles", "extended teleport hit risk", "high", "medium", "low", "safest"),
        [1] = ui_ns.new_multiselect("AA", "Anti-aimbot angles", "custom animations", "pitch on land", "fallen legs", "moonwalk", "air walk", "blind", "fake walk", "earthquake", "slide", "fake duck", "smoothing"),
        [2] = ui_ns.new_multiselect("AA", "Anti-aimbot angles", "notify", "fire", "damage", "miss", "hurt", "hurt self", "config changes"),
        [3] = ui_ns.new_multiselect("AA", "Anti-aimbot angles", "type \n nots", "default", "center", "console"),
        [4] = ui_ns.new_checkbox("AA", "Anti-aimbot angles", "trashtalk"),
        [5] = ui_ns.new_checkbox("AA", "Anti-aimbot angles", "bypass anti trashtalk")
    },
    ["config"] = {
        [0] = ui_ns.new_label("AA", "Anti-aimbot angles", "config"),
        [1] = ui_ns.new_listbox("AA", "Anti-aimbot angles", "config_board", ""),
        [2] = ui_ns.new_textbox("AA", "Anti-aimbot angles", "config names"),
        [8] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0, [7] = 0
    },
    ["debug"] = {
        [0] = ui_ns.new_checkbox("AA", "Anti-aimbot angles", "alternative ui"),
        [4] = ui_ns.new_combobox("AA", "Anti-aimbot angles", "debug tab icon", "lua", "star", "lock", "arrows", "pizza", "up arrow", "cpu", "smilie", "heart"),
        [2] = ui_ns.new_checkbox("AA", "Anti-aimbot angles", "fps optimizations"),
        [3] = ui_ns.new_multiselect("AA", "Anti-aimbot angles", "disable\n optiz", "3d sky", "fog", "shadows", "blood", "decals", "bloom", "other"),
        [1] = ui_ns.new_combobox("AA", "Anti-aimbot angles", "anti-aim correction", "off", "desync"),
        [5] = ui_ns.new_checkbox("AA", "Anti-aimbot angles", "on shot only (ragebot)"),
        [6] = ui_ns.new_hotkey("AA", "Anti-aimbot angles", "\n on shot bind", true)
    }
}

ui_ns.new_label("Players", "Adjustments", "wraith anti-aim stealer")
steal_aa_toggle = ui_ns.new_checkbox("Players", "Adjustments", "scan anti-aim")
steal_aa_ignore = ui_ns.new_checkbox("Players", "Adjustments", "ignore missing stances")

for condition_idx, condition_name in pairs_fn(condition_names) do
    gamesense_aa_settings[condition_idx] = {
        [0] = ui_ns.new_checkbox("AA", "Anti-aimbot angles", string_ns.format("[%s - gamesense]", condition_name)),
        [1] = ui_ns.new_combobox("AA", "Anti-aimbot angles", string_ns.format("pitch \n %s", condition_name), {"off", "default", "up", "down", "minimal", "random", "custom"}),
        [2] = ui_ns.new_slider("AA", "Anti-aimbot angles", string_ns.format("\n%s pitch slider", condition_name), -89, 89, 0, true, "°", 1, {}),
        [3] = ui_ns.new_combobox("AA", "Anti-aimbot angles", string_ns.format("yaw base \n%s", condition_name), {"local view", "at targets"}),
        [4] = ui_ns.new_combobox("AA", "Anti-aimbot angles", string_ns.format("yaw\n %s", condition_name), {"off", "180", "spin", "static", "180 Z", "crosshair"}),
        [5] = ui_ns.new_slider("AA", "Anti-aimbot angles", string_ns.format("\n%s yaw add", condition_name), -180, 180, 0, true, "°", 1, {}),
        [6] = ui_ns.new_combobox("AA", "Anti-aimbot angles", string_ns.format("yaw jitter\n%s", condition_name), {"off", "offset", "center", "random", "skitter", "slow"}),
        [7] = ui_ns.new_slider("AA", "Anti-aimbot angles", string_ns.format("\n %s yaw jitter", condition_name), -180, 180, 0, true, "°", 1, {}),
        [8] = ui_ns.new_combobox("AA", "Anti-aimbot angles", string_ns.format("body yaw\n %s", condition_name), {"off", "opposite", "jitter", "static"}),
        [9] = ui_ns.new_slider("AA", "Anti-aimbot angles", string_ns.format("\n%s body yaw static side", condition_name), -180, 180, 0, true, "°", 1, {}),
        [10] = ui_ns.new_checkbox("AA", "Anti-aimbot angles", string_ns.format("freestanding body yaw\n %s", condition_name)),
        [11] = ui_ns.new_checkbox("AA", "Anti-aimbot angles", string_ns.format("edge yaw\n %s", condition_name)),
        [12] = ui_ns.new_checkbox("AA", "Anti-aimbot angles", string_ns.format("freestanding\n %s", condition_name)),
        [13] = ui_ns.new_slider("AA", "Anti-aimbot angles", string_ns.format("roll\n %s", condition_name), -45, 45, 0, true, "°", 1, {}),
        [14] = ui_ns.new_checkbox("AA", "Anti-aimbot angles", string_ns.format("force defensive\n %s", condition_name)),
        [15] = ui_ns.new_combobox("AA", "Anti-aimbot angles", string_ns.format("defensive pitch\n %s", condition_name), "off", "up", "random", "minimal", "zero"),
        [16] = ui_ns.new_combobox("AA", "Anti-aimbot angles", string_ns.format("defensive yaw\n %s", condition_name), "off", "forward", "spin", "jitter", "opposite")
    }
    wraith_aa_settings[condition_idx] = {
        [0] = ui_ns.new_checkbox("AA", "Anti-aimbot angles", string_ns.format("[%s - wraith] (incomplete)", condition_name)),
        [1] = ui_ns.new_combobox("AA", "Anti-aimbot angles", string_ns.format("pitch\n %s w", condition_name), {"off", "emotion (89)", "up (-89)", "fake up (180)", "fake down (-180)", "fake zero (1080)", "fake down (-540)"}),
        [2] = ui_ns.new_combobox("AA", "Anti-aimbot angles", string_ns.format("yaw jitter\n %s w", condition_name), {"off", "offset", "center", "random", "3 way", "5 way"}),
        [3] = ui_ns.new_slider("AA", "Anti-aimbot angles", string_ns.format("\n %s yaw jitter w", condition_name), -180, 180, 0, true, "°", 1, {}),
        [4] = ui_ns.new_combobox("AA", "Anti-aimbot angles", string_ns.format("body yaw\n %s w", condition_name), {"off", "opposite", "jitter", "static"})
    }
end

-- Utility functions
local function table_to_string(tbl)
    local result = "\n{"
    for key, value in pairs_fn(tbl) do
        if type(key) == "string" then
            result = result .. "[\"" .. key .. "\"]" .. "="
        end
        if type(value) == "table" then
            result = result .. table_to_string(value)
        elseif type(value) == "boolean" then
            result = result .. tostring_fn(value)
        else
            result = result .. "\"" .. value .. "\""
        end
        result = result .. ",\n"
    end
    if result ~= "" then
        result = result:sub(1, result:len() - 1)
    end
    return result .. "}\n"
end

local function split_string(str, delimiter)
    local result = {}
    for match in string_ns.gmatch(str, "([^" .. delimiter .. "]+)") do
        result[#result + 1] = string_ns.gsub(match, "\n", "")
    end
    return result
end

local function parse_value(value)
    if value == "true" or value == "false" then
        return value == "true"
    else
        return value
    end
end

local function round(num)
    return math_ns.floor(num + 0.5)
end

local function clamp(value, min_val, max_val)
    return math_ns.max(math_ns.min(value, max_val), min_val)
end

local function rgba_to_hex(r, g, b, a)
    return string_ns.format('%02x%02x%02x%02x', r, g, b, a)
end

local function count_occurrences(tbl)
    local counts = {}
    for _, value in ipairs_fn(tbl) do
        counts[value] = (counts[value] or 0) + 1
    end
    return counts
end

local function get_most_common(counts)
    local max_key = next(counts)
    for key in pairs_fn(counts) do
        if counts[max_key] < counts[key] then
            max_key = key
        end
    end
    return max_key
end

local function get_mode(tbl)
    return get_most_common(count_occurrences(tbl))
end

-- Gamesense references
local gs_refs = {
    rage = {
        ref_doubletap = {ui_ns.reference("RAGE", "Aimbot", "Double tap")},
        ref_safepoint = ui_ns.reference("RAGE", "Aimbot", "Force safe point"),
        ref_baim = {ui_ns.reference("RAGE", "Aimbot", "Force body aim")},
        ref_min_damage = {ui_ns.reference("RAGE", "Aimbot", "Minimum damage")},
        ref_min_damage_override = {ui_ns.reference("RAGE", "Aimbot", "Minimum damage override")},
        other = {ref_fakeduck = ui_ns.reference("RAGE", "Other", "Duck peek assist")}
    },
    anti_aim = {
        anti_aimbot_angles = {
            ref_aa_enabled = ui_ns.reference("AA", "Anti-aimbot angles", "Enabled"),
            ref_pitch = {ui_ns.reference("AA", "Anti-aimbot angles", "Pitch")},
            ref_yaw = {ui_ns.reference("AA", "Anti-aimbot angles", "Yaw")},
            ref_yaw_base = ui_ns.reference("AA", "Anti-aimbot angles", "Yaw base"),
            ref_body_yaw = {ui_ns.reference("AA", "Anti-aimbot angles", "Body yaw")},
            ref_yaw_jitter = {ui_ns.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
            ref_freestand_body = ui_ns.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
            ref_edge_yaw = ui_ns.reference("AA", "Anti-aimbot angles", "Edge yaw"),
            ref_freestand = {ui_ns.reference("AA", "Anti-aimbot angles", "Freestanding")},
            ref_roll = ui_ns.reference("AA", "Anti-aimbot angles", "Roll")
        },
        fakelag = {},
        other = {
            ref_slowmotion = {ui_ns.reference("AA", "Other", "Slow motion")},
            ref_onshotantiaim = {ui_ns.reference("AA", "Other", "On shot anti-aim")}
        }
    },
    misc = {
        settings = {
            ref_dpiscale = ui_ns.reference("MISC", "Settings", "DPI scale"),
            ref_menukey = ui_ns.reference("MISC", "Settings", "Menu key"),
            ref_nadetoss = ui_ns.reference("MISC", "Settings", "Faster grenade toss")
        },
        movement = {ref_bhop = ui_ns.reference('MISC', 'Movement', 'Bunny hop')}
    },
    plist = {
        players = ui_ns.reference("Players", "Players", "Player list"),
        force_yaw = ui_ns.reference("Players", "Adjustments", "Force body yaw"),
        force_yaw_value = ui_ns.reference("Players", "Adjustments", "Force body yaw value"),
        force_body = ui_ns.reference("Players", "Adjustments", "Force body yaw"),
        force_body_value = ui_ns.reference("Players", "Adjustments", "Force body yaw value"),
        reset = ui_ns.reference("Players", "Players", "Reset all")
    }
}

local function table_contains(tbl, value)
    local found = false
    for i = 1, #tbl do
        if tbl[i] == value then
            found = true
            break
        end
    end
    return found
end

local function lerp(start_val, end_val, t)
    return start_val + (end_val - start_val) * t
end

local function normalize_angle(angle)
    while angle > 180 do
        angle = angle - 360
    end
    while angle < -180 do
        angle = angle + 360
    end
    return angle
end

function calculate_angle(from_pos, to_pos)
    local delta = to_pos - from_pos
    local yaw = math_ns.atan(delta.y / delta.x)
    yaw = normalize_angle(yaw * 180 / math_ns.pi)
    if delta.x >= 0 then
        yaw = normalize_angle(yaw + 180)
    end
    return yaw
end

local function is_scoped(player)
    local scoped = entity_ns.get_prop(player, "m_bIsScoped")
    if scoped == 1 then
        return true
    end
    return false
end

local ignore_missing_stances = {}
local scan_aa_enabled = {}

ui_ns.set_callback(steal_aa_ignore, function()
    if ui_ns.get(steal_aa_ignore) then
        ignore_missing_stances[ui_ns.get(gs_refs.plist.players)] = true
    else
        if ignore_missing_stances[ui_ns.get(gs_refs.plist.players)] then
            ignore_missing_stances[ui_ns.get(gs_refs.plist.players)] = nil
        end
    end
end)

ui_ns.set_callback(gs_refs.plist.players, function()
    ui_ns.set(steal_aa_ignore, ignore_missing_stances[ui_ns.get(gs_refs.plist.players)] ~= nil)
end)

ui_ns.set_callback(gs_refs.plist.reset, function()
    ignore_missing_stances = {}
    ui_ns.set(steal_aa_ignore, false)
end)

ui_ns.set_callback(steal_aa_toggle, function()
    if ui_ns.get(steal_aa_toggle) then
        scan_aa_enabled[ui_ns.get(gs_refs.plist.players)] = true
    else
        if scan_aa_enabled[ui_ns.get(gs_refs.plist.players)] then
            scan_aa_enabled[ui_ns.get(gs_refs.plist.players)] = nil
        end
    end
end)

ui_ns.set_callback(gs_refs.plist.players, function()
    ui_ns.set(steal_aa_toggle, scan_aa_enabled[ui_ns.get(gs_refs.plist.players)] ~= nil)
end)

ui_ns.set_callback(gs_refs.plist.reset, function()
    scan_aa_enabled = {}
    ui_ns.set(steal_aa_toggle, false)
end)

local function reset_antiaim()
    ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_aa_enabled, false)
    ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_pitch[1], "Off")
    ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_pitch[2], 0)
    ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_yaw[1], "Off")
    ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_yaw[2], 0)
    ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_yaw_base, "Local view")
    ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_body_yaw[1], "Off")
    ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_body_yaw[2], 0)
    ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_yaw_jitter[1], "Off")
    ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_yaw_jitter[2], 0)
    ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_freestand_body, false)
    ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_edge_yaw, false)
    ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_freestand[1], false)
    ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_freestand[2], "Always on")
    ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_roll, 0)
end

local function set_aa_visibility(hide_aa)
    for key, ref in pairs_fn(gs_refs.anti_aim.anti_aimbot_angles) do
        if type(ref) ~= "table" then
            ui_ns.set_visible(ref, not hide_aa)
            if not hide_aa and ui_ns.get(gs_refs.anti_aim.anti_aimbot_angles.ref_body_yaw[1]) == "Off" then
                ui_ns.set_visible(gs_refs.anti_aim.anti_aimbot_angles.ref_freestand_body, false)
            end
        else
            for idx, sub_ref in ipairs_fn(ref) do
                ui_ns.set_visible(sub_ref, not hide_aa)
                if not hide_aa and ui_ns.get(gs_refs.anti_aim.anti_aimbot_angles.ref_body_yaw[1]) == "Opposite" then
                    ui_ns.set_visible(gs_refs.anti_aim.anti_aimbot_angles.ref_body_yaw[2], false)
                end
                if not hide_aa and ui_ns.get(ref[1]) == "Off" and key ~= "ref_pitch" then
                    ui_ns.set_visible(ref[2], false)
                    if ui_ns.get(gs_refs.anti_aim.anti_aimbot_angles.ref_yaw[1]) == "Off" then
                        ui_ns.set_visible(gs_refs.anti_aim.anti_aimbot_angles.ref_yaw_jitter[1], false)
                    end
                end
                if not hide_aa and ui_ns.get(gs_refs.anti_aim.anti_aimbot_angles.ref_pitch[1]) ~= "Custom" then
                    ui_ns.set_visible(gs_refs.anti_aim.anti_aimbot_angles.ref_pitch[2], false)
                end
            end
        end
    end
end

local screen_width, screen_height = client_ns.screen_size()
local watermark_pos = {
    x = database_ns.read("x_82hdnujdsgfu") or screen_width - screen_width + 10,
    y = database_ns.read("y_ajshdahjdjhn") or screen_height - screen_height + 550,
    w = database_ns.read("w_akjdfsahsdff") or 100,
    h = database_ns.read("h_pi2jpoaojkfs") or 100,
    dragging = false
}

local function is_mouse_in_bounds(x, y, w, h)
    local mouse_x, mouse_y = ui_ns.mouse_position()
    return mouse_x >= x and mouse_x <= x + w and mouse_y >= y and mouse_y <= y + h
end

function watermark(local_player, font_size)
    if not ui_ns.get(ui_elements["visuals"][2]) then
        return
    end
    local font_flag = ""
    local watermark_text = "WRAITH [" .. string_ns.upper(script_info["build"]) .. "]" .. " | " .. string_ns.upper(script_info["user"]) .. " | " .. math_ns.floor(client_ns.latency() * 1000) .. "MS"
    if font_size == "small" then
        font_flag = "-"
        watermark_text = "WRAITH   [" .. string_ns.upper(script_info["build"]) .. "]" .. "   |   " .. string_ns.upper(script_info["user"]) .. "   |   " .. math_ns.floor(client_ns.latency() * 1000) .. "MS"
    elseif font_size == "thin" then
        font_flag = ""
    elseif font_size == "bold" then
        font_flag = "b"
    elseif font_size == "blind" then
        font_flag = "+"
    end
    local scr_w, scr_h = client_ns.screen_size()
    local mouse_pos = {ui_ns.mouse_position()}
    local mouse_down = client_ns.key_state(0x01)
    local text_size = {renderer_ns.measure_text(font_flag, watermark_text)}
    if ui_ns.is_menu_open() then
        if watermark_pos.dragging and not mouse_down then
            watermark_pos.dragging = false
        end
        if watermark_pos.dragging and mouse_down then
            watermark_pos.x = mouse_pos[1] - watermark_pos.drag_x
            watermark_pos.y = mouse_pos[2] - watermark_pos.drag_y
        end
        if is_mouse_in_bounds(watermark_pos.x, watermark_pos.y, watermark_pos.w + text_size[1], watermark_pos.h + text_size[2]) and mouse_down then
            watermark_pos.dragging = true
            watermark_pos.drag_x = mouse_pos[1] - watermark_pos.x
            watermark_pos.drag_y = mouse_pos[2] - watermark_pos.y
        end
    end
    if watermark_pos.x + text_size[1] > scr_w then
        watermark_pos.x = watermark_pos.x - 5
    elseif watermark_pos.x + 20 < 0 then
        watermark_pos.x = watermark_pos.x + 5
    end
    if watermark_pos.y + text_size[2] > scr_h then
        watermark_pos.y = watermark_pos.y - 10
    elseif watermark_pos.y + text_size[2] < 0 then
        watermark_pos.y = watermark_pos.y + 10
    end
    local info_lines = {}
    renderer_ns.gradient(watermark_pos.x, watermark_pos.y + text_size[2] + 8, text_size[1] / 1.5, 1, 0, 0, 0, 0, 220, 220, 220, 220, 255, true)
    renderer_ns.gradient(watermark_pos.x + text_size[1] / 1.5, watermark_pos.y + text_size[2] + 8, text_size[1] / 1.5, 1, 220, 220, 220, 255, 0, 0, 0, 0, true)
    renderer_ns.gradient(watermark_pos.x, watermark_pos.y, text_size[1] / 1.5, text_size[2] + 7, 12, 12, 12, 0, 12, 12, 12, 75, true)
    renderer_ns.gradient(watermark_pos.x + text_size[1] / 1.5, watermark_pos.y, text_size[1] / 1.5, text_size[2] + 7, 12, 12, 12, 75, 12, 12, 12, 0, true)
    renderer_ns.text(watermark_pos.x + 18, watermark_pos.y + 5, 255, 255, 255, 220, font_flag, 0, watermark_text)
    if not entity_ns.is_alive(local_player) then
        return
    end
    table.insert(info_lines, {text = "- CONDITION: " .. string_ns.upper(wraith_state.current_condition), r = 240, g = 240, b = 240, a = 220})
    table.insert(info_lines, {text = "- TARGET: " .. string_ns.upper(client_ns.current_threat() == nil and "?" or string_ns.sub(entity_ns.get_player_name(client_ns.current_threat()), 0, 12)), r = 240, g = 240, b = 240, a = 220})
    table.insert(info_lines, {text = "- EXPLOIT CHARGE: " .. (antiaim_funcs.get_double_tap() == false and "0" or "1"), r = 240, g = 240, b = 240, a = 220})
    table.insert(info_lines, {text = "- DESYNC: " .. string_ns.upper(math_ns.abs(wraith_state.current_desync)) .. "*", r = 240, g = 240, b = 240, a = 220})
    for idx, line in pairs_fn(info_lines) do
        text_size2 = {renderer_ns.measure_text(font_flag, line.text)}
        renderer_ns.text(watermark_pos.x + 18, 10 + watermark_pos.y + text_size2[2] * idx, line.r, line.g, line.b, line.a, font_flag, 0, line.text)
    end
end

function draw_glow(x, y, w, h, color, glow_size)
    renderer_ns.rectangle(x, y, w, h, color[1], color[2], color[3], color[4])
    local glow_r = color[1] * glow_size
    local glow_g = color[2] * glow_size
    local glow_b = color[3] * glow_size
    for i = 1, glow_size do
        local alpha = color[4] * i / glow_size
        local width = w + i * 2
        local height = h + i * 2
        local pos_x = x - i
        local pos_y = y - i
        renderer_ns.rectangle(pos_x, pos_y, width, height, glow_r, glow_g, glow_b, alpha)
    end
end

local function draw_desync_bar(local_player, center_x, center_y, text_width, text_height)
    if not table_contains(ui_ns.get(ui_elements["visuals"][6]), "desync") then
        return
    end
    local dsy_rect = {255, 255, 255, 255}
    text_height = text_height + 5
    if is_scoped(local_player) and table_contains(ui_ns.get(ui_elements["visuals"][6]), "animations on scope") then
        wraith_state.desync_rect_dist = lerp(wraith_state.desync_rect_dist, 21 + 2, globals_ns.frametime() * 15)
    elseif not table_contains(ui_ns.get(ui_elements["visuals"][6]), "animations on scope") and ui_ns.get(ui_elements["visuals"][0]) == "recode alpha" then
        wraith_state.desync_rect_dist = 21 + 2
    else
        wraith_state.desync_rect_dist = lerp(wraith_state.desync_rect_dist, 0, globals_ns.frametime() * 10)
    end
    renderer_ns.rectangle(center_x - 21 + round(wraith_state.desync_rect_dist), center_y + text_height, 21 * 2, 4, 15, 15, 15, 255)
    renderer_ns.rectangle(center_x - (21 - 1) + round(wraith_state.desync_rect_dist), center_y + text_height + 1, clamp(math_ns.abs(wraith_state.current_desync) / 58 * (21 * 2 - 2), 0, 21 * 2 - 2), 2, dsy_rect[1], dsy_rect[2], dsy_rect[3], dsy_rect[4])
end

local function draw_manual_arrows(local_player, center_x, center_y)
    if not ui_ns.get(ui_elements["visuals"][9]) or not ui_ns.get(ui_elements["anti-aim 2"][3]) then
        return
    end
    wraith_state.smooth_left_arrow = is_scoped(local_player) and lerp(wraith_state.smooth_left_arrow, 80, globals_ns.frametime() * 15) or lerp(wraith_state.smooth_left_arrow, 60, globals_ns.frametime() * 15)
    wraith_state.smooth_right_arrow = is_scoped(local_player) and lerp(wraith_state.smooth_right_arrow, 80, globals_ns.frametime() * 15) or lerp(wraith_state.smooth_right_arrow, 60, globals_ns.frametime() * 15)
    wraith_state.smooth_up_arrow = is_scoped(local_player) and lerp(wraith_state.smooth_up_arrow, 80, globals_ns.frametime() * 15) or lerp(wraith_state.smooth_up_arrow, 60, globals_ns.frametime() * 15)
    local arrow_positions = {
        ["left"] = {indicator = "", x_pos = -wraith_state.smooth_left_arrow, y_pos = -5},
        ["right"] = {indicator = "", x_pos = wraith_state.smooth_left_arrow, y_pos = -5},
        ["forward"] = {indicator = "", x_pos = 0, y_pos = -wraith_state.smooth_up_arrow}
    }
    local arrow_color = {ui_ns.get(ui_elements["visuals"][10])}
    wraith_state.smooth_arrow_alpha = is_scoped(local_player) and lerp(wraith_state.smooth_arrow_alpha, clamp(arrow_color[4] - 100, 0, 235), globals_ns.frametime() * 15) or lerp(wraith_state.smooth_arrow_alpha, arrow_color[4], globals_ns.frametime() * 15)
    for direction, arrow_data in pairs_fn(arrow_positions) do
        if direction == wraith_state.mode then
            renderer_ns.text(center_x + math_ns.ceil(arrow_data.x_pos), center_y + math_ns.ceil(arrow_data.y_pos), arrow_color[1], arrow_color[2], arrow_color[3], wraith_state.smooth_arrow_alpha, "c+", 0, arrow_data.indicator)
        end
    end
end

local function draw_defensive_indicator(local_player, center_x, center_y)
    if not table_contains(ui_ns.get(ui_elements["visuals"][6]), "defensive") then
        return
    end
    if wraith_state.tickbase_diff ~= nil and wraith_state.tickbase_diff <= -1 and wraith_state.tickbase_diff >= -14 then
        defensive_size_x, defensive_size_y = renderer_ns.measure_text("c", "- defensive -")
        defensive_size_x = defensive_size_x + 15
        renderer_ns.rectangle(center_x - defensive_size_x / 2, center_y / 3 + defensive_size_y - 2, defensive_size_x, 4, 15, 15, 15, 150)
        local tickbase_diff = wraith_state.tickbase_diff
        local defensive_progress = math_ns.abs(-tickbase_diff - 15)
        local smooth_progress = defensive_progress
        if defensive_progress == smooth_progress and defensive_progress > 1 then
            smooth_progress = smooth_progress - 1
        end
        wraith_state.smooth_defensive_bar = lerp(wraith_state.smooth_defensive_bar, smooth_progress, globals_ns.frametime() * 50)
        local text_alpha = lerp(75, 200, (wraith_state.smooth_defensive_bar - 1) / 12)
        renderer_ns.text(center_x, center_y / 3, 255, 255, 255, text_alpha, "c", 0, "- defensive -")
        renderer_ns.rectangle(center_x + 1 - defensive_size_x / 2, center_y / 3 + 10, clamp(wraith_state.smooth_defensive_bar / 12 * defensive_size_x, 0, defensive_size_x) - 2, 2, 200, 200, 200, text_alpha)
    else
        wraith_state.smooth_defensive_bar = 0.5
    end
end

local function predict_position_with_gravity(player, origin, ticks)
    local tick_interval = globals_ns.tickinterval()
    local gravity = cvar.sv_gravity:get_float() * tick_interval
    local jump_impulse = cvar.sv_jump_impulse:get_float() * tick_interval
    local predicted_pos = {origin[1], origin[2], origin[3]}
    local velocity = {entity_ns.get_prop(player, 'm_vecVelocity')}
    local vertical_impulse = velocity[3] > 0 and -gravity or jump_impulse
    for tick = 1, ticks do
        local old_pos = {predicted_pos[1], predicted_pos[2], predicted_pos[3]}
        predicted_pos[1] = predicted_pos[1] + velocity[1] * tick_interval
        predicted_pos[2] = predicted_pos[2] + velocity[2] * tick_interval
        predicted_pos[3] = predicted_pos[3] + (velocity[3] + vertical_impulse) * tick_interval
        local trace = client_ns.trace_line(old_pos[1], old_pos[2], old_pos[3], predicted_pos[1], predicted_pos[2], predicted_pos[3])
        if trace.fraction <= 0.99 then
            return old_pos
        end
    end
    return predicted_pos
end

local function add_vectors(vec1, vec2)
    return {vec1[1] + vec2[1], vec1[2] + vec2[2], vec1[3] + vec2[3]}
end

local function predict_player_position(player, ticks)
    local tick_interval = globals_ns.tickinterval()
    local gravity = cvar.sv_gravity:get_float() * tick_interval
    local jump_impulse = cvar.sv_jump_impulse:get_float() * tick_interval
    local current_pos = {entity_ns.get_origin(player)}
    local predicted_pos = {entity_ns.get_origin(player)}
    local velocity = {entity_ns.get_prop(player, 'm_vecVelocity')}
    local vertical_impulse = velocity[3] > 0 and -gravity or jump_impulse
    for tick = 1, ticks do
        predicted_pos = current_pos
        current_pos = {current_pos[1] + velocity[1] * tick_interval, current_pos[2] + velocity[2] * tick_interval, current_pos[3] + (velocity[3] + vertical_impulse) * tick_interval}
    end
    return current_pos
end

local function draw_3d_box(player, predicted_pos, draw_box)
    local mins = add_vectors({entity_ns.get_prop(player, 'm_vecMins')}, predicted_pos)
    local maxs = add_vectors({entity_ns.get_prop(player, 'm_vecMaxs')}, predicted_pos)
    local vertices = {
        {mins[1], mins[2], mins[3]}, {mins[1], maxs[2], mins[3]}, {maxs[1], maxs[2], mins[3]}, {maxs[1], mins[2], mins[3]},
        {mins[1], mins[2], maxs[3]}, {mins[1], maxs[2], maxs[3]}, {maxs[1], maxs[2], maxs[3]}, {maxs[1], mins[2], maxs[3]}
    }
    local edges = {{0, 1}, {1, 2}, {2, 3}, {3, 0}, {5, 6}, {6, 7}, {1, 4}, {4, 8}, {0, 4}, {1, 5}, {2, 6}, {3, 7}, {5, 8}, {7, 8}, {3, 4}}
    for edge_idx = 1, #edges do
        if vertices[edges[edge_idx][1]] ~= nil and vertices[edges[edge_idx][2]] ~= nil then
            local v1_screen = {renderer_ns.world_to_screen(vertices[edges[edge_idx][1]][1], vertices[edges[edge_idx][1]][2], vertices[edges[edge_idx][1]][3])}
            local v2_screen = {renderer_ns.world_to_screen(vertices[edges[edge_idx][2]][1], vertices[edges[edge_idx][2]][2], vertices[edges[edge_idx][2]][3])}
            renderer_ns.line(v1_screen[1], v1_screen[2], v2_screen[1], v2_screen[2], 255, 255, 255, 255)
        end
    end
end

local function draw_3d_circle_outline(x, y, z, radius, r, g, b, a, step)
    local step_size = step or 3
    local prev_x, prev_y
    for angle = 0, 360, step_size do
        local rad = math_ns.rad(angle)
        local circle_x, circle_y, circle_z = radius * math_ns.cos(rad) + x, radius * math_ns.sin(rad) + y, z
        local screen_x, screen_y = renderer_ns.world_to_screen(circle_x, circle_y, circle_z)
        if screen_x ~= nil and prev_x ~= nil then
            renderer_ns.line(screen_x, screen_y, prev_x, prev_y, r, g, b, a)
        end
        prev_x, prev_y = screen_x, screen_y
    end
end

local function draw_3d_circle_filled(x, y, z, radius, r, g, b, a, step)
    local step_size = step or 3
    local triangles = {}
    for angle = 0, 360, step_size do
        local rad = math_ns.rad(angle)
        local circle_x, circle_y, circle_z = radius * math_ns.cos(rad) + x, radius * math_ns.sin(rad) + y, z
        table.insert(triangles, {circle_x, circle_y, circle_z})
    end
    for tri_idx = 1, #triangles - 2 do
        local v1, v2, v3 = triangles[1], triangles[tri_idx + 1], triangles[tri_idx + 2]
        local v1_x, v1_y = renderer_ns.world_to_screen(v1[1], v1[2], v1[3])
        local v2_x, v2_y = renderer_ns.world_to_screen(v2[1], v2[2], v2[3])
        local v3_x, v3_y = renderer_ns.world_to_screen(v3[1], v3[2], v3[3])
        if v1_x and v2_x and v3_x then
            renderer_ns.triangle(v1_x, v1_y, v2_x, v2_y, v3_x, v3_y, r, g, b, a)
        end
    end
end

local function draw_3d_circle_glow(x, y, z, radius, r, g, b, a, step, layers)
    local step_size = step or 3
    local layer_count = layers or 5
    local alpha_step = a / layer_count
    local current_alpha = a
    for layer = 1, layer_count do
        draw_3d_circle_outline(x, y, z, radius + layer, r, g, b, current_alpha, step_size)
        current_alpha = current_alpha - alpha_step
    end
end

local function draw_extended_teleport_prediction(local_player)
    if ui_ns.get(gs_refs.anti_aim.other.ref_onshotantiaim[1]) and ui_ns.get(gs_refs.anti_aim.other.ref_onshotantiaim[2]) or not (ui_ns.get(ui_elements["misc"][6]) or ui_ns.get(ui_elements["misc"][7]) and wraith_state.hittable) or wraith_state.tickbase_diff == nil or wraith_state.tickbase_diff > 0 then
        return
    end
    if not ui_ns.get(gs_refs.rage.ref_doubletap[1]) and not ui_ns.get(gs_refs.rage.ref_doubletap[2]) then
        return
    end
    predicted_pos = predict_player_position(local_player, 14)
    if ui_ns.get(ui_elements["visuals"][8]) == "circle" then
        draw_3d_circle_glow(predicted_pos[1], predicted_pos[2], predicted_pos[3], 6, 255, 255, 255, 255, 3, 10)
        draw_3d_circle_filled(predicted_pos[1], predicted_pos[2], predicted_pos[3], 7, 255, 255, 255, 150, 3)
    elseif ui_ns.get(ui_elements["visuals"][8]) == "box" then
        draw_3d_box(local_player, predicted_pos, true)
    end
end

local skeleton_bones = {
    main = {0, 1, 6, 5, 4, 3, 2},
    left_arm = {14, 18, 17, 1},
    right_arm = {13, 16, 15, 1},
    left_leg = {12, 10, 8, 2},
    right_leg = {11, 9, 7, 2}
}

local function predict_position_with_trace(player, origin, ticks)
    local tick_interval = globals_ns.tickinterval()
    local gravity = cvar.sv_gravity:get_float() * tick_interval
    local jump_impulse = cvar.sv_jump_impulse:get_float() * tick_interval
    local current_pos, predicted_pos = origin, origin
    local velocity = {entity_ns.get_prop(player, 'm_vecVelocity')}
    local vertical_impulse = velocity[3] > 0 and -gravity or jump_impulse
    for tick = 1, ticks do
        predicted_pos = current_pos
        current_pos = {current_pos[1] + velocity[1] * tick_interval, current_pos[2] + velocity[2] * tick_interval, current_pos[3] + (velocity[3] + vertical_impulse) * tick_interval}
        local trace = client_ns.trace_line(-1, predicted_pos[1], predicted_pos[2], predicted_pos[3], current_pos[1], current_pos[2], current_pos[3])
    end
    return current_pos
end

local function draw_skeleton(player)
    for bone_group, bones in pairs_fn(skeleton_bones) do
        for bone_idx, bone_id in pairs_fn(bones) do
            if bone_idx ~= #bones then
                local hitbox_positions = {}
                for hitbox_id = 0, 18 do
                    local hitbox_pos = {entity_ns.hitbox_position(player, hitbox_id)}
                    local pos = hitbox_pos
                    hitbox_positions[hitbox_id] = {x = pos[1], y = pos[2], z = pos[3]}
                end
                local bone1_x, bone1_y, bone1_z = hitbox_positions[bones[bone_idx]].x, hitbox_positions[bones[bone_idx]].y, hitbox_positions[bones[bone_idx]].z
                local bone1_screen_x, bone1_screen_y = renderer_ns.world_to_screen(bone1_x, bone1_y, bone1_z)
                local bone2_x, bone2_y, bone2_z = hitbox_positions[bones[bone_idx + 1]].x, hitbox_positions[bones[bone_idx + 1]].y, hitbox_positions[bones[bone_idx + 1]].z
                local bone2_screen_x, bone2_screen_y = renderer_ns.world_to_screen(bone2_x, bone2_y, bone2_z)
                renderer_ns.line(bone1_screen_x, bone1_screen_y, bone2_screen_x, bone2_screen_y, 255, 255, 255, 255)
            end
        end
    end
end

local function animate_text(current_length, target_text, speed)
    local text_length = string_ns.len(target_text)
    if current_length < text_length then
        current_length = current_length + 1 * globals_ns.frametime() * speed
    else
        current_length = text_length
    end
    local animated_length = math_ns.floor(current_length)
    local animated_text = string_ns.sub(target_text, 1, animated_length)
    return current_length, animated_text
end

local animated_text_state = ""

local function draw_indicators(event, indicators_enabled, local_player, screen_size, font_size)
    if not indicators_enabled or not entity_ns.is_alive(local_player) then
        return
    end
    draw_extended_teleport_prediction(local_player)
    local indicator_lines = {}
    local indicator_color_r, indicator_color_g, indicator_color_b, indicator_color_a = ui_ns.get(ui_elements["visuals"][1])
    local center_x, center_y = screen_size[1] / 2, screen_size[2] / 2
    local font_flag = ""
    draw_defensive_indicator(local_player, center_x, center_y)
    draw_manual_arrows(local_player, center_x, center_y)
    if font_size == "small" then
        font_flag = "-"
    elseif font_size == "thin" then
        font_flag = ""
    elseif font_size == "bold" then
        font_flag = "b"
    elseif font_size == "blind" then
        font_flag = "+"
    end
    if ui_ns.get(ui_elements["visuals"][0]) ~= "recode alpha" then
        wraith_state.smooth_wraith_recode = 0
        wraith_state.smooth_dt_2 = 0
        wraith_state.smooth_stance = 0
        wraith_state.dt_os_text_anim = 0
        wraith_state.current_cond_text_anim = 0
    end
    if ui_ns.get(indicators_enabled) == "minimal (og)" then
        local sp_text = "SP BAIM FS"
        local sp_only = "SP"
        local baim_text = " BAIM"
        local fs_text = " FS"
        local wraith_text = "WRAITH"
        local dt_text = "DT"
        local os_text = "OS"
        local condition_text = string_ns.upper(wraith_state.current_condition)
        if font_flag == "-" then
            sp_only = "SP"
            baim_text = "  BAIM"
            fs_text = "  FS"
            sp_text = "SP  BAIM  FS"
        end
        if table_contains(ui_ns.get(ui_elements["visuals"][6]), "lowercase") then
            wraith_text = string_ns.lower(wraith_text)
            dt_text = string_ns.lower(dt_text)
            os_text = string_ns.lower(os_text)
            sp_text = string_ns.lower(sp_text)
            sp_only = string_ns.lower(sp_only)
            baim_text = string_ns.lower(baim_text)
            fs_text = string_ns.lower(fs_text)
            condition_text = string_ns.lower(condition_text)
        end
        local wraith_text_size = {renderer_ns.measure_text(font_flag, wraith_text)}
        wraith_state.smooth_wraith = is_scoped(local_player) and lerp(wraith_state.smooth_wraith, -2, globals_ns.frametime() * 15) or lerp(wraith_state.smooth_wraith, renderer_ns.measure_text(font_flag, wraith_text) / 2, globals_ns.frametime() * 15)
        table.insert(indicator_lines, {text = wraith_text, r = 210, g = 210, b = 210, a = 255, size = math_ns.ceil(wraith_state.smooth_wraith)})
        wraith_state.smooth_pc = is_scoped(local_player) and lerp(wraith_state.smooth_pc, -2, globals_ns.frametime() * 15) or lerp(wraith_state.smooth_pc, renderer_ns.measure_text(font_flag, math_ns.abs(wraith_state.current_desync) .. "%") / 2, globals_ns.frametime() * 15)
        table.insert(indicator_lines, {text = math_ns.abs(wraith_state.current_desync) .. "%", r = 210, g = 210, b = 210, a = 255, size = math_ns.ceil(wraith_state.smooth_pc)})
        wraith_state.smooth_dt = is_scoped(local_player) and lerp(wraith_state.smooth_dt, -2, globals_ns.frametime() * 15) or lerp(wraith_state.smooth_dt, renderer_ns.measure_text(font_flag, os_text) / 2, globals_ns.frametime() * 15)
        if ui_ns.get(gs_refs.rage.ref_doubletap[1]) and ui_ns.get(gs_refs.rage.ref_doubletap[2]) then
            local dt_charged = antiaim_funcs.get_double_tap() or wraith_state.tickbase_diff ~= 1
            table.insert(indicator_lines, {text = dt_text, r = 210, g = 210, b = 210, a = dt_charged and 255 or 100, size = math_ns.ceil(wraith_state.smooth_dt)})
            wraith_state.dt_vertical_dist = lerp(wraith_state.dt_vertical_dist, 10, globals_ns.frametime() * 20)
        else
            wraith_state.dt_vertical_dist = lerp(wraith_state.dt_vertical_dist, 0, globals_ns.frametime() * 20)
        end
        wraith_state.smooth_os = is_scoped(local_player) and lerp(wraith_state.smooth_os, -2, globals_ns.frametime() * 15) or lerp(wraith_state.smooth_os, renderer_ns.measure_text(font_flag, os_text) / 2, globals_ns.frametime() * 15)
        if ui_ns.get(gs_refs.anti_aim.other.ref_onshotantiaim[1]) and ui_ns.get(gs_refs.anti_aim.other.ref_onshotantiaim[2]) then
            local dt_enabled = ui_ns.get(gs_refs.rage.ref_doubletap[1]) and ui_ns.get(gs_refs.rage.ref_doubletap[2])
            table.insert(indicator_lines, {text = os_text, r = 210, g = 210, b = 210, a = not dt_enabled and 255 or math_ns.max(wraith_state.pulse, 100), size = math_ns.ceil(wraith_state.smooth_os)})
        end
        wraith_state.smooth_bo = is_scoped(local_player) and lerp(wraith_state.smooth_bo, -2, globals_ns.frametime() * 15) or lerp(wraith_state.smooth_bo, renderer_ns.measure_text(font_flag, sp_text) / 2, globals_ns.frametime() * 15)
        table.insert(indicator_lines, {text = ("\a%s" .. sp_only .. "\a%s" .. baim_text .. "\a%s" .. fs_text):format(string_ns.format("%02X%02X%02X%02X", indicator_color_r, indicator_color_g, indicator_color_b, ui_ns.get(gs_refs.rage.ref_safepoint) and 210 or 100), string_ns.format("%02X%02X%02X%02X", indicator_color_r, indicator_color_g, indicator_color_b, ui_ns.get(gs_refs.rage.ref_baim[1]) and 210 or 100), string_ns.format("%02X%02X%02X%02X", indicator_color_r, indicator_color_g, indicator_color_b, ui_ns.get(gs_refs.anti_aim.anti_aimbot_angles.ref_freestand[1]) and ui_ns.get(gs_refs.anti_aim.anti_aimbot_angles.ref_freestand[2]) and 210 or 100)), r = 210, g = 210, b = 210, a = 255, size = math_ns.ceil(wraith_state.smooth_bo)})
        for line_idx, line_data in pairs_fn(indicator_lines) do
            renderer_ns.text(center_x + (table_contains(ui_ns.get(ui_elements["visuals"][6]), "animations on scope") == true and -line_data.size or -(renderer_ns.measure_text(font_flag, line_data.text) / 2)), 10 + center_y + wraith_text_size[2] * line_idx, line_data.r, line_data.g, line_data.b, line_data.a, font_flag, 0, line_data.text)
        end
        local wraith_size = {renderer_ns.measure_text(font_flag, wraith_text)}
        draw_desync_bar(local_player, center_x, center_y, wraith_size[1], wraith_size[2])
    else
        wraith_state.smooth_wraith = 0
        wraith_state.smooth_dt = 0
        wraith_state.smooth_os = 0
        wraith_state.smooth_pc = 0
        wraith_state.smooth_bo = 0
        if ui_ns.get(indicators_enabled) == "anti urine" then
            table.insert(indicator_lines, {text = "ANTI URINE", r = 255, g = 165, b = 0, a = wraith_state.pulse, size = renderer_ns.measure_text("b", "ANTI URINE") / 2})
            table.insert(indicator_lines, {text = "MIN DAMAGE", r = 191, g = 159, b = 255, a = ui_ns.get(gs_refs.rage.ref_min_damage_override[2]) and 255 or 100, size = renderer_ns.measure_text("b", "MIN DAMAGE") / 2})
            table.insert(indicator_lines, {text = "ON SHOT", r = 128, g = 230, b = 150, a = ui_ns.get(gs_refs.anti_aim.other.ref_onshotantiaim[1]) and ui_ns.get(gs_refs.anti_aim.other.ref_onshotantiaim[2]) and 255 or 100, size = renderer_ns.measure_text("b", "ON SHOT") / 2})
            local dt_enabled = ui_ns.get(gs_refs.rage.ref_doubletap[1]) and ui_ns.get(gs_refs.rage.ref_doubletap[2])
            table.insert(indicator_lines, {text = "DT", r = dt_enabled and 210 or 255, g = dt_enabled and 210 or 0, b = dt_enabled and 210 or 0, a = dt_enabled and 255 or 100, size = renderer_ns.measure_text("b", "DT") / 2})
            for line_idx, line_data in pairs_fn(indicator_lines) do
                renderer_ns.text(center_x - line_data.size, 45 + center_y + 12 * line_idx, line_data.r, line_data.g, line_data.b, line_data.a, "b", 0, line_data.text)
            end
        elseif ui_ns.get(indicators_enabled) == "recode alpha" then
            local wraith_recode_text = ("WRAITH\a%s RECODE"):format(string_ns.format("%02X%02X%02X%02X", indicator_color_r, indicator_color_g, indicator_color_b, math_ns.max(indicator_color_a, 100)))
            local dt_text = "DT"
            local os_text = "ON SHOT"
            local wraith_recode_size = {renderer_ns.measure_text(font_flag, wraith_recode_text)}
            local condition_text = string_ns.upper(wraith_state.current_condition)
            if wraith_state.mode == "left" then
                condition_text = "MANUAL LEFT"
            elseif wraith_state.mode == "right" then
                condition_text = "MANUAL RIGHT"
            elseif wraith_state.mode == "forward" then
                condition_text = "MANUAL FORWARD"
            end
            if table_contains(ui_ns.get(ui_elements["visuals"][6]), "lowercase") then
                wraith_recode_text = string_ns.lower(wraith_recode_text)
                dt_text = string_ns.lower(dt_text)
                os_text = string_ns.lower(os_text)
                condition_text = string_ns.lower(condition_text)
            end
            local dt_charged = antiaim_funcs.get_double_tap() or wraith_state.tickbase_diff ~= 1
            local os_enabled = ui_ns.get(gs_refs.anti_aim.other.ref_onshotantiaim[1]) and ui_ns.get(gs_refs.anti_aim.other.ref_onshotantiaim[2])
            local dt_enabled = ui_ns.get(gs_refs.rage.ref_doubletap[1]) and ui_ns.get(gs_refs.rage.ref_doubletap[2])
            local dt_os_text = ""
            if dt_enabled then
                dt_os_text = dt_text
            elseif os_enabled then
                dt_os_text = os_text
            end
            wraith_state.dt_os_text_anim, ayo = animate_text(wraith_state.dt_os_text_anim, dt_os_text, 50)
            wraith_state.current_cond_text_anim, ayo2 = animate_text(wraith_state.current_cond_text_anim, condition_text, 25)
            if animated_text_state ~= condition_text then
                if #animated_text_state <= #condition_text then
                    wraith_state.current_cond_text_anim = #animated_text_state
                end
                animated_text_state = condition_text
            end
            wraith_recode_text_size = {renderer_ns.measure_text(font_flag, wraith_recode_text)}
            wraith_state.smooth_wraith_recode = is_scoped(local_player) and lerp(wraith_state.smooth_wraith_recode, -2, globals_ns.frametime() * 15) or lerp(wraith_state.smooth_wraith_recode, wraith_recode_text_size[1] / 2, globals_ns.frametime() * 15)
            table.insert(indicator_lines, {text = wraith_recode_text, r = 240, g = 240, b = 240, a = 255, size = math_ns.floor(wraith_state.smooth_wraith_recode), txt_measure = {renderer_ns.measure_text(font_flag, wraith_recode_text)}})
            wraith_state.smooth_dt_2 = is_scoped(local_player) and lerp(wraith_state.smooth_dt_2, -2, globals_ns.frametime() * 15) or lerp(wraith_state.smooth_dt_2, renderer_ns.measure_text(font_flag, dt_os_text) / 2, globals_ns.frametime() * 15)
            if dt_enabled or os_enabled then
                table.insert(indicator_lines, {text = ayo, r = dt_enabled and (dt_charged and 0 or 255) or 135, g = dt_enabled and (dt_charged and 255 or 0) or 206, b = dt_enabled and 0 or 250, a = 255, size = math_ns.floor(wraith_state.smooth_dt_2), txt_measure = {renderer_ns.measure_text(font_flag, ayo)}})
            else
                wraith_state.dt_os_text_anim = 0
            end
            ayo2 = "'  " .. ayo2 .. "  '"
            wraith_state.smooth_stance = is_scoped(local_player) and lerp(wraith_state.smooth_stance, -2, globals_ns.frametime() * 15) or lerp(wraith_state.smooth_stance, renderer_ns.measure_text(font_flag, ayo2) / 2, globals_ns.frametime() * 15)
            table.insert(indicator_lines, {text = ayo2, r = 240, g = 240, b = 240, a = 255, size = math_ns.floor(wraith_state.smooth_stance), txt_measure = {renderer_ns.measure_text(font_flag, ayo2)}})
            for line_idx, line_data in pairs_fn(indicator_lines) do
                renderer_ns.text(center_x + (table_contains(ui_ns.get(ui_elements["visuals"][6]), "animations on scope") == true and -line_data.size or 0), 10 + center_y + wraith_recode_size[2] * line_idx, line_data.r, line_data.g, line_data.b, line_data.a, font_flag, 0, line_data.text)
            end
            local wraith_size = {renderer_ns.measure_text(font_flag, wraith_recode_text)}
            draw_desync_bar(local_player, center_x, center_y, wraith_size[1], wraith_size[2])
        end
    end
end

gamesense_outer = function(x, y, w, h, alpha, vertical)
    vertical = vertical or false
    if not vertical then
        renderer_ns.rectangle(x, y - (h + 3), w, 1, 12, 12, 12, alpha)
        renderer_ns.rectangle(x + 2, y - (h + 2), w - 4, 5, 60, 60, 60, alpha)
        renderer_ns.rectangle(x + 2, y - (h + 1), w - 4, 3, 40, 40, 40, alpha)
        renderer_ns.rectangle(x, y - (h + 3), 1, h + 3, 12, 12, 12, alpha)
        renderer_ns.rectangle(x + 1, y - (h + 2), 4, h + 2, 60, 60, 60, alpha)
        renderer_ns.rectangle(x + 2, y - (h + 1), 3, h + 1, 40, 40, 40, alpha)
        renderer_ns.rectangle(x + 5, y - (h - 2), 1, h - 2, 60, 60, 60, alpha)
        renderer_ns.rectangle(x + w - 1, y - (h + 3), 1, h + 3, 12, 12, 12, alpha)
        renderer_ns.rectangle(x + w - 3, y - (h + 2), 2, h + 2, 60, 60, 60, alpha)
        renderer_ns.rectangle(x + w - 5, y - (h + 1), 3, h + 1, 40, 40, 40, alpha)
        renderer_ns.rectangle(x + w - 6, y - (h - 2), 1, h - 2, 60, 60, 60, alpha)
    else
        renderer_ns.rectangle(x - h / 2 - 4, y - 47, h + 9, w + 9, 12, 12, 12, alpha)
        renderer_ns.rectangle(x - h / 2 - 10, y - 53, h + 20, 1, 12, 12, 12, alpha)
        renderer_ns.rectangle(x - h / 2 - 9, y - 52, h + 18, 1, 60, 60, 60, alpha)
        renderer_ns.rectangle(x - h / 2 - 8, y - 51, h + 17, 3, 40, 40, 40, alpha)
        renderer_ns.rectangle(x - h / 2 - 5, y - 48, h + 10, 1, 60, 60, 60, alpha)
        renderer_ns.rectangle(x - h / 2 - 10, y - 53, 1, w + 19, 12, 12, 12, alpha)
        renderer_ns.rectangle(x - h / 2 - 9, y - 51, 1, w + 18, 60, 60, 60, alpha)
        renderer_ns.rectangle(x - h / 2 - 8, y - 48, 3, w + 10, 40, 40, 40, alpha)
        renderer_ns.rectangle(x - h / 2 - 5, y - 48, 1, w + 9, 60, 60, 60, alpha)
        renderer_ns.rectangle(x + h / 2 + 10, y - 53, 1, w + 20, 12, 12, 12, alpha)
        renderer_ns.rectangle(x + h / 2 + 9, y - 52, 1, w + 18, 60, 60, 60, alpha)
        renderer_ns.rectangle(x + h / 2 + 6, y - 48, 3, w + 10, 40, 40, 40, alpha)
        renderer_ns.rectangle(x + h / 2 + 5, y - 48, 1, w + 10, 60, 60, 60, alpha)
        renderer_ns.rectangle(x - h / 2 - 10, y - 48 + w + 14, h + 20, 1, 12, 12, 12, alpha)
        renderer_ns.rectangle(x - h / 2 - 5, y - 51 + w + 12, h + 10, 1, 60, 60, 60, alpha)
        renderer_ns.rectangle(x - h / 2 - 8, y - 52 + w + 14, h + 17, 3, 40, 40, 40, alpha)
        renderer_ns.rectangle(x - h / 2 - 8, y - 49 + w + 14, h + 17, 1, 60, 60, 60, alpha)
    end
end

local dpi_scale_value = 10 + (string_ns.sub(ui_ns.get(gs_refs.misc.settings.ref_dpiscale), 1, -2) - 100) / 25
local notification_font = surface.create_font('Lucida Console', dpi_scale_value, 400, {0x080})

local Notification = {}
function Notification:new(text, color, time)
    local obj = {m_text = text, m_color = color, m_time = time, lerped_pos = vector(client_ns.screen_size()).y}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

local NotificationManager = {}
function NotificationManager:new()
    local obj = {m_notify_text = {}}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function NotificationManager:add(text, color, time, console_log, event_type)
    color = color or {255, 255, 255, 255}
    time = time or 8.0
    console_log = table_contains(ui_ns.get(ui_elements["misc"][3]), "console") or false
    event_type = event_type or ""
    table.insert(self.m_notify_text, Notification:new(text, color, time))
    if console_log then
        if event_type == "fire" then
            client_ns.color_log(182, 231, 23, '[gamesense] \0')
            client_ns.color_log(210, 210, 255, text)
        else
            print(text)
        end
    end
end

function NotificationManager:think(screen_size, font_size)
    local padding_x, padding_y, line_height = 8, 5, 12 + 1
    local center_x, center_y = screen_size[1] / 2, screen_size[2] / 2
    local text_color
    local time_remaining
    local font_flag = "c"
    local y_offset = 1
    local animated_text
    if font_size == "small" then
        font_flag = "-c"
    elseif font_size == "thin" then
        font_flag = "c"
    elseif font_size == "bold" then
        font_flag = "bc"
    elseif font_size == "blind" then
        font_flag = "+c"
        y_offset = 10
    end
    if #self.m_notify_text > 6 then
        table.remove(self.m_notify_text, 1)
    end
    for idx = #self.m_notify_text, 1, -1 do
        local notification = self.m_notify_text[idx]
        notification.m_time = notification.m_time - globals_ns.frametime()
        if notification.m_time <= 0.0 then
            table.remove(self.m_notify_text, idx)
        end
    end
    if #self.m_notify_text == 0 then
        return
    end
    for idx, notification in ipairs_fn(self.m_notify_text) do
        animated_text = notification.m_text
        if font_size == "small" then
            animated_text = string_ns.upper(notification.m_text)
        end
        local text_size = {renderer_ns.measure_text(font_flag, animated_text)}
        notification.lerped_pos = lerp(notification.lerped_pos, screen_size[2] / 2 + 300 + idx * (23 + text_size[2]), globals_ns.frametime() * 10)
        smooth_center_y = notification.lerped_pos
        time_remaining = notification.m_time
        text_color = notification.m_color
        if time_remaining < 0.5 then
            local fade_progress = time_remaining
            fade_progress = math_ns.min(math_ns.max(fade_progress, 0.0), 0.5)
            fade_progress = fade_progress / 0.5
            text_color[4] = math_ns.floor(fade_progress * 255)
            if idx == 1 and fade_progress < 0.2 then
                padding_y = padding_y - line_height * (1.0 - fade_progress / 0.2)
            end
        else
            text_color[4] = 255
        end
        if notification_font and table_contains(ui_ns.get(ui_elements["misc"][3]), "default") then
            surface.draw_text(center_x, smooth_center_y, text_color[1], text_color[2], text_color[3], text_color[4], notification_font, animated_text)
        end
        if table_contains(ui_ns.get(ui_elements["misc"][3]), "center") then
            gamesense_outer(center_x, smooth_center_y, text_size[2], text_size[1], text_color[4], true)
            smooth_center_y = smooth_center_y - 46
            renderer_ns.gradient(center_x - math_ns.ceil(text_size[1] / 2 + 3), smooth_center_y, math_ns.ceil(text_size[1]) / 2, 1, 59, 175, 222, text_color[4], 202, 70, 205, text_color[4], true)
            renderer_ns.gradient(center_x - 4, smooth_center_y, math_ns.ceil(text_size[1] / 2 + 7.5), 1, 202, 70, 205, text_color[4], 204, 227, 53, text_color[4], true)
            renderer_ns.gradient(center_x - math_ns.ceil(text_size[1] / 2 + 3), smooth_center_y + 1, math_ns.ceil(text_size[1]) / 2, 1, 59, 175, 222, math_ns.max(0, math_ns.min(255, text_color[4])) - 100, 202, 70, 205, text_color[4], true)
            renderer_ns.gradient(center_x - 4, smooth_center_y + 1, math_ns.ceil(text_size[1] / 2 + 7.5), 1, 202, 70, 205, text_color[4], 204, 227, 53, math_ns.max(0, math_ns.min(255, text_color[4])) - 100, true)
            renderer_ns.text(center_x, smooth_center_y + text_size[2] - y_offset, 209, 209, 209, text_color[4], font_flag, 0, animated_text)
        end
        padding_y = padding_y + line_height
    end
end

g_notify = NotificationManager:new()

local trashtalk_phrases = {
    'جدا الحمد لله أبي',
    "₩Ɽ₳ł₮Ⱨ ₴Ɇ₦Đ ₲ⱤɆɆ₮ł₦₲₴ ₱₳Ɽ₳ ₳ ₵Ø₦₳ Đ₳ ₮Ʉ₳ ₥₳̃Ɇ",
    "ஃᅔ>.< член в заднице у русских ＷＲＡＩＴＨ ＲＥＣＯＤＥᅕஃ",
    "ȶʏ ʄօʀ ʍ2 ƈօʍքɨӼɨօռ աɨȶɦ ȶɦɛ քօքֆ ǟռɖ ȶɦɛ ɮǟռɢֆ ʄȶ 𝔀𝓻𝓸𝓽𝓱 𝓵𝓸𝓪",
    "百萬富翁買鬼 ツ",
    "skeet invite code in morse: ... .-- ..-. -.-- -... .-- ..-. -... .--- --.. -... .-.. -.- .... ..-. .-.. -.- --. .. .-. .--. --. .-.. --.- --.- - -.-- .---- -..- . .-- -.- -.-- --.- ---.. .-.. .... ... ...- --.. -..- -.. .--. -..- -- -... - -.--",
    '𝟝𝟙.𝟙𝟟𝟠.𝟙𝟠𝟝.𝟚𝟛𝟛/𝕡𝕝𝕒𝕪𝕖𝕣𝕤.𝕛𝕤𝕠𝕟 𝓬𝓽𝓻𝓵+f "𝖎𝖘𝖘𝖔 𝖋𝖔𝖎 𝖉𝖔𝖕𝖊, 𝖌𝖆𝖓𝖉𝖆 𝖙𝖔𝖖𝖚𝖊"',
    "🕯️⧚🎃⧚🔮 ƙąYRཞơŋ ῳıƖƖ ƈơơ℘ ʂ℘ıɛƖɛŋ 🔮⧚🎃⧚🕯️",
    " ⓔⓜⓑⓡⓐⓒⓔ ⓡⓐⓒⓘⓢⓜ ",
    "yesterday i got smoked by (っ◔◡◔)っ ιвιzα 6ℓ 1.9 т∂ι 160 ¢υρяα 2004 160 нρ / 118 кω 1896 ¢м3 (115.7 ¢υ-ιи)",
    "【　ＷＲＡＩＴＨ　ＡＮＴＩ－ＡＩＭＢＯＴ　ＲＥＣＯＤＥ　】",
    "ʀᴀᴢ ᴀᴅᴅᴇᴅ ᴛʜɪs ᴛᴏ ᴡʀᴀɪᴛʜ ʀᴇᴄᴏᴅᴇ ᴀɴᴅ ɪᴛ ᴍᴀᴅᴇ ɪᴛ sᴏ ᴍᴜᴄʜ ʙᴇᴛᴛᴇʀ"
}

last_random = 0
new_random = 0
textalhao = ""
say_time = 0
ran = false

local function on_player_death(event)
    if not ui_ns.get(ui_elements["misc"][4]) and not ui_ns.get(ui_elements["misc"][5]) then
        return
    end
    local victim_userid, attacker_userid = event.userid, event.attacker
    if victim_userid == nil or attacker_userid == nil then
        return
    end
    local victim_entindex = client_ns.userid_to_entindex(victim_userid)
    local attacker_entindex = client_ns.userid_to_entindex(attacker_userid)
    if attacker_entindex == entity_ns.get_local_player() and entity_ns.is_enemy(victim_entindex) then
        new_random = client_ns.random_int(1, #trashtalk_phrases)
        while new_random == last_random do
            new_random = client_ns.random_int(1, #trashtalk_phrases)
        end
        textalhao = "say " .. trashtalk_phrases[new_random]
        if ui_ns.get(ui_elements["misc"][5]) then
            say_time = globals_ns.curtime()
            ran = false
        else
            client_ns.exec(textalhao)
        end
        last_random = new_random
    end
end

local function handle_delayed_trashtalk(enabled)
    if not enabled then
        ran = false
        return
    end
    if globals_ns.curtime() >= say_time + 1.5 and globals_ns.curtime() <= say_time + 1.6 and not ran then
        client_ns.exec(textalhao)
        ran = true
    end
end

local function draw_min_damage_indicator(enabled, screen_w, screen_h)
    if not enabled then
        return
    end
    local crosshair_size = cvar.cl_crosshairsize:get_int()
    final_dmg = ui_ns.get(gs_refs.rage.ref_min_damage_override[2]) and ui_ns.get(gs_refs.rage.ref_min_damage_override[3]) or ui_ns.get(gs_refs.rage.ref_min_damage[1])
    dmg_size = renderer_ns.measure_text("", final_dmg)
    renderer_ns.text(screen_w / 2 + 10, screen_h / 2 - 20, 255, 255, 255, 250, "", 0, final_dmg)
end

local function on_paint(event)
    local local_player = entity_ns.get_local_player()
    local screen_size = {client_ns.screen_size()}
    local indicators_size = ui_ns.get(ui_elements["visuals"][3])
    local watermark_size = ui_ns.get(ui_elements["visuals"][4])
    local notifications_size = ui_ns.get(ui_elements["visuals"][5])
    handle_delayed_trashtalk(ui_ns.get(ui_elements["misc"][4]) and ui_ns.get(ui_elements["misc"][5]))
    draw_min_damage_indicator(table_contains(ui_ns.get(ui_elements["visuals"][6]), "min damage") and entity_ns.is_alive(local_player), screen_size[1], screen_size[2])
    watermark(local_player, watermark_size)
    draw_indicators(event, ui_elements["visuals"][0], local_player, screen_size, indicators_size)
    g_notify:think(screen_size, notifications_size)
end

local function get_animation_layer(entity_ptr, layer_idx)
    layer_idx = layer_idx or 1
    entity_ptr = ffi_ns.cast(void_ptr_type, entity_ptr)
    return ffi_ns.cast('struct animation_layer_t**', ffi_ns.cast('char*', entity_ptr) + 0x2990)[0][layer_idx]
end

local function calculate_max_desync(animstate)
    duckammount = animstate.m_fDuckAmount
    speedfraction = math_ns.max(0, math_ns.min(animstate.m_flFeetSpeedForwardsOrSideWays, 1))
    speedfactor = math_ns.max(0, math_ns.min(1, animstate.m_flFeetSpeedUnknownForwardOrSideways))
    unk1 = (animstate.m_flStopToFullRunningFraction * -0.30000001 - 0.19999999) * speedfraction
    unk2 = unk1 + 1
    unk3 = 0
    if duckammount > 0 then
        unk2 = unk2 + duckammount * speedfactor * (0.5 - unk2)
    end
    unk3 = animstate.m_flMaxYaw * unk2
    return unk3
end

local function set_pose_parameter(player, value, param_idx)
    local entity_ptr = get_client_entity(raw_entity_list, player)
    local networkable_ptr = get_client_networkable(raw_entity_list, player)
    local entity_cast = ffi_ns.cast(void_ptr_type, entity_ptr)
    local animstate_offset = ffi_ns.cast("char*", entity_cast) + 0x9960
    local animstate = ffi_ns.cast("struct animstate_t1**", animstate_offset)[0]
    if entity_ptr == nil or networkable_ptr == nil or local_animstate == nil then
        return
    end
    player.set_prop(player, "m_flPoseParameter", 1, 6)
end

local function handle_animations(local_player)
    local entity_ptr = get_client_entity(raw_entity_list, local_player)
    local networkable_ptr = get_client_networkable(raw_entity_list, local_player)
    local entity_cast = ffi_ns.cast(void_ptr_type, entity_ptr)
    local animstate_offset = ffi_ns.cast("char*", entity_cast) + 0x9960
    local animstate = ffi_ns.cast("struct animstate_t1**", animstate_offset)[0]
    if entity_ptr == nil or networkable_ptr == nil or animstate == nil then
        return
    end
    if globals_ns.chokedcommands() == 0 then
        wraith_state.max_desync = calculate_max_desync(animstate)
        wraith_state.current_desync = math_ns.min(math_ns.max(entity_ns.get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60, -58), 58)
        wraith_state.current_desync = wraith_state.current_desync > 0 and math_ns.ceil(wraith_state.current_desync) or math_ns.floor(wraith_state.current_desync)
    end
    if table_contains(ui_ns.get(ui_elements["misc"][1]), "air walk") then
        if vector(entity_ns.get_prop(local_player, 'm_vecVelocity')):length2d() > 1.5 then
            ANIMATION_LAYER_MOVEMENT_MOVE = get_animation_layer(entity_ptr, 6)
            ANIMATION_LAYER_MOVEMENT_MOVE.m_flWeight = 1
        end
    end
    if table_contains(ui_ns.get(ui_elements["misc"][1]), "earthquake") then
        ANIMATION_LAYER_LEAN = get_animation_layer(entity_ptr, 12)
        ANIMATION_LAYER_LEAN.m_flWeight = client_ns.random_float(0, 1)
    end
    if table_contains(ui_ns.get(ui_elements["misc"][1]), "fake walk") and wraith_state.in_speed then
        ANIMATION_LAYER_LEAN = get_animation_layer(entity_ptr, 12)
        ANIMATION_LAYER_LEAN.m_flWeight = 0
        ANIMATION_LAYER_MOVEMENT_MOVE = get_animation_layer(entity_ptr, 6)
        ANIMATION_LAYER_MOVEMENT_MOVE.m_flWeight = 0
    end
    if table_contains(ui_ns.get(ui_elements["misc"][1]), "blind") then
        ANIMATION_LAYER_FLASHED = get_animation_layer(entity_ptr, 9)
        ANIMATION_LAYER_FLASHED.m_nSequence = 224
        ANIMATION_LAYER_FLASHED.m_flWeight = 1
    end
    if table_contains(ui_ns.get(ui_elements["misc"][1]), "moonwalk") then
        entity_ns.set_prop(local_player, 'm_flPoseParameter', 0, 7)
    end
    if table_contains(ui_ns.get(ui_elements["misc"][1]), "smoothing") then
        entity_ns.set_prop(local_player, "m_flPoseParameter", 0, 2)
    end
    if table_contains(ui_ns.get(ui_elements["misc"][1]), "fallen legs") then
        entity_ns.set_prop(local_player, "m_flPoseParameter", 1, 6)
    end
    if table_contains(ui_ns.get(ui_elements["misc"][1]), "slide") then
        entity_ns.set_prop(local_player, "m_flPoseParameter", 1, 0)
    end
    if table_contains(ui_ns.get(ui_elements["misc"][1]), "pitch on land") or true then
        if animstate.m_bInHitGroundAnimation and animstate.m_flHeadHeightOrOffsetFromHittingGroundAnimation > 0.101 and animstate.m_bOnGround and not client_ns.key_state(0x20) then
            if table_contains(ui_ns.get(ui_elements["misc"][1]), "pitch on land") then
                entity_ns.set_prop(local_player, 'm_flPoseParameter', 0.5, 12)
            end
            wraith_state.landing = true
        else
            wraith_state.landing = false
        end
    end
end

local fps_optimization_cvars = {
    ["3d sky"] = {cvar = cvar.r_3dsky, value = 1},
    ["fog"] = {cvars = {cvar.fog_enable, cvar.fog_enable_water_fog}, value = 1},
    ["shadows"] = {cvars = {cvar.r_shadows, cvar.cl_csm_static_prop_shadows, cvar.cl_csm_shadows, cvar.cl_csm_world_shadows, cvar.cl_foot_contact_shadows, cvar.cl_csm_viewmodel_shadows, cvar.cl_csm_rope_shadows, cvar.cl_csm_sprite_shadows, cvar.cl_csm_translucent_shadows, cvar.cl_csm_entity_shadows, cvar.cl_csm_world_shadows_in_viewmodelcascade}, value = 1},
    ["blood"] = {cvar = cvar.violence_hblood, value = 1},
    ["decals"] = {cvars = {cvar.r_drawdecals, cvar.r_drawropes, cvar.r_drawsprites}, value = 1},
    ["bloom"] = {cvar = cvar.mat_disable_bloom, value = 0},
    ["other"] = {cvars = {cvar.r_dynamic, cvar.r_eyegloss, cvar.r_eyes, cvar.r_drawtracers_firstperson, cvar.r_dynamiclighting}, value = 1}
}

local function handle_fps_optimizations()
    if not ui_ns.get(ui_elements["debug"][2]) then
        for cvar_name, cvar_data in pairs_fn(fps_optimization_cvars) do
            if cvar_data.cvar then
                if cvar_data.cvar:get_int() ~= cvar_data.value then
                    cvar_data.cvar:set_int(cvar_data.value)
                end
            else
                for idx, cvar_obj in ipairs_fn(cvar_data.cvars) do
                    if cvar_obj:get_int() ~= cvar_data.value then
                        cvar_obj:set_int(cvar_data.value)
                    end
                end
            end
        end
        return
    end
    for cvar_name, cvar_data in pairs_fn(fps_optimization_cvars) do
        if table_contains(ui_ns.get(ui_elements["debug"][3]), cvar_name) then
            if cvar_data.cvar then
                if cvar_data.cvar:get_int() == cvar_data.value then
                    cvar_data.cvar:set_int(cvar_data.value == 0 and 1 or (cvar_data.value == 1 and 0 or cvar_data.value))
                end
            else
                for idx, cvar_obj in ipairs_fn(cvar_data.cvars) do
                    if cvar_obj:get_int() == cvar_data.value then
                        cvar_obj:set_int(cvar_data.value == 0 and 1 or (cvar_data.value == 1 and 0 or cvar_data.value))
                    end
                end
            end
        else
            if cvar_data.cvar then
                if cvar_data.cvar:get_int() ~= cvar_data.value then
                    cvar_data.cvar:set_int(cvar_data.value)
                end
            else
                for idx, cvar_obj in ipairs_fn(cvar_data.cvars) do
                    if cvar_obj:get_int() ~= cvar_data.value then
                        cvar_obj:set_int(cvar_data.value)
                    end
                end
            end
        end
    end
end

local function on_pre_render()
    local local_player = entity_ns.get_local_player()
    if not entity_ns.is_alive(local_player) then
        return
    end
    handle_animations(local_player)
    handle_fps_optimizations()
end

reset = function()
    wraith_state.tickbase_max, wraith_state.tickbase_diff = nil, nil
    wraith_state.old_tick_count = 0
    wraith_state.cur = 0
    wraith_state.banana = false
    wraith_state.bomb_defused = false
    wraith_state.bomb_exploded = false
    local reset_player_data = {cur = {}, prev = {}}
    local reset_aa_data = {}
    local reset_aa_settings = {}
end

reset()

local function on_run_command(cmd)
    wraith_state.current_cmd = cmd.command_number
end

local function on_predict_command(cmd)
    if cmd.command_number == wraith_state.current_cmd then
        wraith_state.current_cmd = nil
        local tickbase = entity_ns.get_prop(entity_ns.get_local_player(), "m_nTickBase")
        if wraith_state.tickbase_max ~= nil then
            wraith_state.tickbase_diff = tickbase - wraith_state.tickbase_max
        end
        wraith_state.tickbase_max = math_ns.max(tickbase, wraith_state.tickbase_max or 0)
    end
end

local function time_to_ticks(time)
    return math_ns.floor(0.5 + time / globals_ns.tickinterval())
end

local function ticks_to_time(ticks)
    return globals_ns.tickinterval() * ticks
end

local function on_round_prestart()
    wraith_state.fire_total_hits = 0
    wraith_state.post_total_hits = 0
    wraith_state.mode = "back"
    reset()
end

local function on_aim_fire(event)
    if not event then
        return
    end
    rage_fired = true
    if table_contains(ui_ns.get(ui_elements["misc"][2]), "fire") then
        local hitgroup_name = wraith_state.hitgroup_names[event.hitgroup] or "?"
        local target_entindex = event.target
        local backtrack_ticks = globals_ns.tickcount() - event.tick
        local target_desync = math_ns.min(math_ns.max(entity_ns.get_prop(target_entindex, "m_flPoseParameter", 11) * 120 - 60, -58), 58)
        g_notify:add(string_ns.format("fired at %s's %s for %i damage (%d%%) bt=%i (%ims) body=%iº", entity_ns.get_player_name(event.target), hitgroup_name, event.damage, event.hit_chance, backtrack_ticks, totime_fn(backtrack_ticks * 1000), target_desync), {210, 210, 255, 255}, 5, nil, "fire")
    end
    wraith_state.fire_total_hits = entity_ns.get_prop(entity_ns.get_local_player(), "m_totalHitsOnServer")
    wraith_state.handle_time = globals_ns.realtime()
end

local function on_player_hurt(event)
    if not event and (table_contains(ui_ns.get(ui_elements["misc"][2]), "damage") or table_contains(ui_ns.get(ui_elements["misc"][2]), "hurt") or table_contains(ui_ns.get(ui_elements["misc"][2]), "hurt self")) then
        return
    end
    local local_player = entity_ns.get_local_player()
    local hitgroup_name = wraith_state.hitgroup_names[event.hitgroup] or '?'
    local victim_entindex = client_ns.userid_to_entindex(event.userid)
    local attacker_entindex = client_ns.userid_to_entindex(event.attacker)
    if attacker_entindex == local_player then
        if table_contains(ui_ns.get(ui_elements["misc"][2]), "damage") then
            g_notify:add(string_ns.format('hit %s in the %s for %d damage (%d health remaining)', entity_ns.get_player_name(victim_entindex), hitgroup_name, event.dmg_health, event.health), {255, 255, 255, 255}, 5)
        end
    elseif attacker_entindex == 0 and victim_entindex == local_player then
        if table_contains(ui_ns.get(ui_elements["misc"][2]), "hurt self") then
            g_notify:add(string_ns.format("hurt yourself in the %s for %d damage (%d health remaining)", hitgroup_name, event.dmg_health, event.health), {255, 255, 255, 255}, 5)
        end
    elseif attacker_entindex ~= 0 and victim_entindex == local_player then
        if table_contains(ui_ns.get(ui_elements["misc"][2]), "hurt") then
            g_notify:add(string_ns.format("hurt by %s in the %s for %d damage (%d health remaining)", entity_ns.get_player_name(attacker_entindex), hitgroup_name, event.dmg_health, event.health), {255, 255, 255, 255}, 5)
        end
    end
end

local function on_aim_miss(event)
    if not event and table_contains(ui_ns.get(ui_elements["misc"][2]), "miss") then
        return
    end
    wraith_state.post_total_hits = entity_ns.get_prop(entity_ns.get_local_player(), 'm_totalHitsOnServer')
    if event.reason == "?" then
        if wraith_state.post_total_hits == wraith_state.fire_total_hits + 1 and wraith_state.post_total_hits < 255 and wraith_state.fire_total_hits < 255 then
            event.reason = "godmode"
        elseif globals_ns.realtime() - wraith_state.handle_time >= 0.5 then
            event.reason = "delay"
        end
    end
    g_notify:add(string_ns.format('missed shot due to %s', event.reason), {255, 255, 255, 255}, 5)
end

local function on_dormant_hit(event)
    if not table_contains(ui_ns.get(ui_elements["misc"][2]), "fire") then
        return
    end
    g_notify:add(string_ns.format("fired at %s's %s for %i damage (%d%%) bt=? (?ms) body=?º s=dormant", entity_ns.get_player_name(event.userid), string_ns.lower(event.aim_hitbox), event.dmg_health, event.accuracy * 100), {210, 210, 255, 255}, 5, nil, "fire")
end

local function on_dormant_miss(event)
    if not table_contains(ui_ns.get(ui_elements["misc"][2]), "miss") then
        return
    end
    g_notify:add(string_ns.format("fired at %s's %s for ? damage (%d%%) bt=? (?ms) body=?º s=dormant", entity_ns.get_player_name(event.userid), string_ns.lower(event.aim_hitbox), event.accuracy * 100), {210, 210, 255, 255}, 5)
    client_ns.delay_call(0.5, function()
        g_notify:add("missed shot due to dormant", nil, 5)
    end)
end

local function is_manual_aa_active(enabled)
    if not enabled then
        return false
    end
    return wraith_state.mode ~= "back"
end

local function check_defuse_distance(cmd, local_player)
    local allowed_classnames = {"CWorld", "CCSPlayer", "CFuncBrush", "CPhysicsPropMultiplayer", "CBaseEntity", "CC4"}
    local_origin = vector(entity_ns.get_origin(local_player))
    local eye_x, eye_y, eye_z = client_ns.eye_position()
    local pitch, yaw = client_ns.camera_angles()
    local sin_pitch = math_ns.sin(math_ns.rad(pitch))
    local cos_pitch = math_ns.cos(math_ns.rad(pitch))
    local sin_yaw = math_ns.sin(math_ns.rad(yaw))
    local cos_yaw = math_ns.cos(math_ns.rad(yaw))
    local direction = {cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch}
    local fraction, entity_hit = client_ns.trace_line(local_player, eye_x, eye_y, eye_z, eye_x + direction[1] * 8192, eye_y + direction[2] * 8192, eye_z + direction[3] * 8192)
    local is_valid_entity = true
    if entity_hit == -1 or entity_hit == nil or local_player == nil then
        return
    end
    object_origin = vector(entity_ns.get_origin(entity_hit))
    local distance_check = math_ns.abs(local_origin:dist2d(object_origin)) > 150
    if entity_hit ~= nil then
        for idx = 0, #allowed_classnames do
            if entity_ns.get_classname(entity_hit) == allowed_classnames[idx] then
                is_valid_entity = false
            end
        end
    end
    if distance_check then
        is_valid_entity = false
    end
    if not is_valid_entity and not wraith_state.is_defusing and cmd.in_use then
        cmd.in_use = 0
    end
end

local function check_high_distance(local_player, enemy_player)
    if not enemy_player or entity_ns.is_dormant(enemy_player) then
        return
    end
    local enemy_origin = vector(entity_ns.get_origin(enemy_player))
    local local_origin = vector(entity_ns.get_origin(local_player))
    if local_origin:dist2d(enemy_origin) > 1400 and vector(entity_ns.get_prop(local_player, 'm_vecVelocity')):length2d() <= 150 then
        return true
    end
    return false
end

local function check_height_advantage(local_player, enemy_player, cmd)
    if not enemy_player or entity_ns.is_dormant(enemy_player) then
        return
    end
    local enemy_origin = {entity_ns.get_origin(enemy_player)}
    local local_origin = {entity_ns.get_origin(local_player)}
    local weapon = entity_ns.get_player_weapon(local_player)
    if local_origin[3] > enemy_origin[3] + 55 and (vector(entity_ns.get_prop(local_player, 'm_vecVelocity')):length2d() <= 60 or cmd.in_duck == 1) or cmd.in_duck == 1 and entity_ns.get_classname(weapon) == "CKnife" then
        return true
    end
    return false
end

local function check_backstab_risk(local_player, enemy_player)
    if not enemy_player or entity_ns.is_dormant(enemy_player) then
        return
    end
    local enemy_origin = {entity_ns.get_origin(enemy_player)}
    local enemy_view_offset = {entity_ns.get_prop(enemy_player, "m_vecViewOffset")}
    local local_eye_pos = {client_ns.eye_position()}
    local enemy_eye_pos = {enemy_origin[1] + enemy_view_offset[1], enemy_origin[2] + enemy_view_offset[2], enemy_origin[3] + enemy_view_offset[3]}
    local eye_delta = {math_ns.abs(enemy_eye_pos[1] - local_eye_pos[1]), math_ns.abs(enemy_eye_pos[2] - local_eye_pos[2]), math_ns.abs(enemy_eye_pos[3] - local_eye_pos[3])}
    local horizontal_distance = math_ns.abs(eye_delta[1] + eye_delta[2])
    if horizontal_distance > 425 then
        return
    end
    local local_velocity = {entity_ns.get_prop(local_player, 'm_vecVelocity')}
    local enemy_velocity = {entity_ns.get_prop(enemy_player, 'm_vecVelocity')}
    local time_delta = ticks_to_time(16)
    local predicted_local_pos = {local_eye_pos[1] + local_velocity[1] * time_delta, local_eye_pos[2] + local_velocity[2] * time_delta, local_eye_pos[3] + local_velocity[3] * time_delta}
    local predicted_enemy_pos = {enemy_eye_pos[1] + enemy_velocity[1] * time_delta, enemy_eye_pos[2] + enemy_velocity[2] * time_delta, enemy_eye_pos[3] + enemy_velocity[3] * time_delta}
    local trace1_fraction, trace1_entity = client_ns.trace_line(local_player, predicted_local_pos[1], predicted_local_pos[2], predicted_local_pos[3], predicted_enemy_pos[1], predicted_enemy_pos[2], predicted_enemy_pos[3])
    local trace2_fraction, trace2_entity = client_ns.trace_line(local_player, predicted_enemy_pos[1], predicted_enemy_pos[2], predicted_enemy_pos[3], predicted_local_pos[1], predicted_local_pos[2], predicted_local_pos[3])
    local trace3_fraction, trace3_entity = client_ns.trace_line(local_player, local_eye_pos[1], local_eye_pos[2], local_eye_pos[3], enemy_eye_pos[1], enemy_eye_pos[2], enemy_eye_pos[3])
    local trace4_fraction, trace4_entity = client_ns.trace_line(local_player, local_eye_pos[1], local_eye_pos[2], local_eye_pos[3], enemy_origin[1], enemy_origin[2], enemy_origin[3])
    local can_see_predicted1 = trace1_entity == enemy_player or trace1_fraction == 1
    local can_see_predicted2 = trace2_entity == local_player or trace2_fraction == 1
    local can_see_eye = trace3_entity == enemy_player or trace3_fraction == 1
    local can_see_origin = trace4_entity == enemy_player or trace4_fraction == 1
    local enemy_weapon = entity_ns.get_player_weapon(enemy_player)
    if entity_ns.get_classname(enemy_weapon) == "CKnife" and (can_see_predicted1 or can_see_predicted2 or can_see_eye or can_see_origin) then
        return true
    end
    return false
end

local function check_hittable_players()
    local enemy_players = entity_ns.get_players(true)
    if #enemy_players == 0 then
        wraith_state.hittable = false
        return
    end
    for idx, player in ipairs_fn(enemy_players) do
        if entity_ns.is_alive(player) and not entity_ns.is_dormant(player) then
            local esp_flags = entity_ns.get_esp_data(player).flags or 0
            if bit_ns.band(esp_flags, bit_ns.lshift(1, 11)) ~= 0 then
                wraith_state.hittable = true
            else
                wraith_state.hittable = false
            end
        else
            wraith_state.hittable = false
        end
    end
    return false
end

local function handle_extended_teleport(cmd)
    if ui_ns.get(gs_refs.anti_aim.other.ref_onshotantiaim[1]) and ui_ns.get(gs_refs.anti_aim.other.ref_onshotantiaim[2]) then
        return
    end
    if not ui_ns.get(gs_refs.rage.ref_doubletap[1]) and not ui_ns.get(gs_refs.rage.ref_doubletap[2]) then
        return
    end
    if ui_ns.get(ui_elements["misc"][8]) == "safest" then
        wraith_state.defensive_risk = -4
    elseif ui_ns.get(ui_elements["misc"][8]) == "low" then
        wraith_state.defensive_risk = -3
    elseif ui_ns.get(ui_elements["misc"][8]) == "medium" then
        wraith_state.defensive_risk = -2
    elseif ui_ns.get(ui_elements["misc"][8]) == "high" then
        wraith_state.defensive_risk = -1
    end
    if ui_ns.get(ui_elements["misc"][6]) or ui_ns.get(ui_elements["misc"][7]) and wraith_state.hittable then
        cmd.force_defensive = 1
        if wraith_state.tickbase_diff == wraith_state.defensive_risk then
            ui_ns.set(gs_refs.rage.ref_doubletap[1], false)
            cmd.force_defensive = 0
        end
    else
        cmd.force_defensive = 0
        ui_ns.set(gs_refs.rage.ref_doubletap[1], true)
    end
end

local function handle_extended_teleport_debug(cmd)
    print(wraith_state.tickbase_diff)
    if antiaim_funcs.get_double_tap() or wraith_state.tickbase_diff ~= 1 and ui_ns.get(gs_refs.rage.ref_doubletap[1]) and ui_ns.get(gs_refs.rage.ref_doubletap[2]) then
        cmd.force_defensive = 1
        if wraith_state.tickbase_diff ~= 1 then
            ui_ns.set(gs_refs.rage.ref_doubletap[1], false)
        end
    else
        ui_ns.set(gs_refs.rage.ref_doubletap[1], true)
    end
end

local function determine_condition(cmd, local_player, enemy_player)
    local condition_checks = {
        {
            index = 13,
            condition = "backstab",
            check = function()
                return check_backstab_risk(local_player, enemy_player)
            end
        },
        {
            index = 16,
            condition = "legit",
            check = function()
                if bit_ns.band(cmd.buttons, 32) == 32 and not wraith_state.is_defusing then
                    check_defuse_distance(cmd, local_player)
                    return true
                end
            end
        },
        {
            index = 11,
            condition = "manual",
            check = function()
                if is_manual_aa_active(table_contains(ui_ns.get(ui_elements["anti-aim 2"][0]), "manual anti-aim") and ui_ns.get(ui_elements["anti-aim 2"][3])) then
                    return true
                end
            end
        },
        {
            index = 14,
            condition = "height",
            check = function()
                return check_height_advantage(local_player, enemy_player, cmd)
            end
        },
        {
            index = 15,
            condition = "high distance",
            check = function()
                return check_high_distance(local_player, enemy_player)
            end
        },
        {
            index = 12,
            condition = "freestanding",
            check = function()
                return false
            end
        },
        {
            index = 9,
            condition = "in fake duck",
            check = function()
                return ui_ns.get(gs_refs.rage.other.ref_fakeduck) and bit_ns.band(entity_ns.get_prop(local_player, "m_fFlags"), 1) ~= 0
            end
        },
        {
            index = 10,
            condition = "fakelag",
            check = function()
                return not ui_ns.get(gs_refs.rage.ref_doubletap[2]) and not ui_ns.get(gs_refs.anti_aim.other.ref_onshotantiaim[2])
            end
        },
        {
            index = 5,
            condition = "in air",
            check = function()
                return (wraith_state.jumping == true or wraith_state.on_ground == false) and cmd.in_duck == 0
            end
        },
        {
            index = 6,
            condition = "in air duck",
            check = function()
                return (wraith_state.jumping == true or wraith_state.on_ground == false) and cmd.in_duck == 1
            end
        },
        {
            index = 8,
            condition = "in duck moving",
            check = function()
                return cmd.in_duck == 1 and vector(entity_ns.get_prop(local_player, 'm_vecVelocity')):length2d() > 1.1
            end
        },
        {
            index = 7,
            condition = "in duck",
            check = function()
                return cmd.in_duck == 1
            end
        },
        {
            index = 2,
            condition = "standing",
            check = function()
                return vector(entity_ns.get_prop(local_player, 'm_vecVelocity')):length2d() < 1.1
            end
        },
        {
            index = 4,
            condition = "slow motion",
            check = function()
                return ui_ns.get(gs_refs.anti_aim.other.ref_slowmotion[1]) and ui_ns.get(gs_refs.anti_aim.other.ref_slowmotion[2])
            end
        },
        {
            index = 3,
            condition = "moving",
            check = function()
                return vector(entity_ns.get_prop(local_player, 'm_vecVelocity')):length2d() > 1.1 and bit_ns.band(entity_ns.get_prop(local_player, "m_fFlags"), 1) == 1
            end
        }
    }
    for idx, condition_data in ipairs_fn(condition_checks) do
        if condition_data.check() then
            if ui_ns.get(ui_elements["anti-aim"][0]) == "gamesense" then
                if current_aa_settings ~= nil and ui_ns.get(current_aa_settings[condition_data.index][0]) then
                    if ui_ns.get(current_aa_settings[condition_data.index][12]) and ui_ns.get(ui_elements["anti-aim 2"][2]) then
                        if ui_ns.get(current_aa_settings[12][0]) then
                            return "freestanding", 12
                        else
                            return "freestanding", 1
                        end
                    end
                    return condition_data.condition, condition_data.index
                end
            end
        end
    end
    if current_aa_settings ~= nil and ui_ns.get(current_aa_settings[1][0]) then
        return "global", 1
    end
    return "invalid", -1
end

local function apply_antiaim_settings(cmd, local_player, enemy_player, enabled)
    if not enabled then
        return
    end
    wraith_state.current_condition, wraith_state.current_condition_index = determine_condition(cmd, local_player, enemy_player)
    if wraith_state.current_condition == "invalid" then
        reset_antiaim()
        return
    end
    if ui_ns.get(ui_elements["anti-aim"][0]) == "gamesense" then
        ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_pitch[1], ui_ns.get(current_aa_settings[wraith_state.current_condition_index][1]))
        ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_pitch[2], ui_ns.get(current_aa_settings[wraith_state.current_condition_index][2]))
        ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_yaw_base, ui_ns.get(current_aa_settings[wraith_state.current_condition_index][3]))
        ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_yaw[1], ui_ns.get(current_aa_settings[wraith_state.current_condition_index][4]))
        if wraith_state.current_condition == "manual" then
            ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_freestand[1], false)
            if wraith_state.mode == "left" then
                ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_yaw[2], -ui_ns.get(ui_elements["anti-aim 2"][8]))
            elseif wraith_state.mode == "right" then
                ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_yaw[2], ui_ns.get(ui_elements["anti-aim 2"][9]))
            elseif wraith_state.mode == "forward" then
                ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_yaw[2], 180)
            end
        else
            ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_yaw[2], ui_ns.get(current_aa_settings[wraith_state.current_condition_index][5]))
        end
        if ui_ns.get(current_aa_settings[wraith_state.current_condition_index][6]) ~= "slow" then
            ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_yaw_jitter[1], ui_ns.get(current_aa_settings[wraith_state.current_condition_index][6]))
            ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_yaw_jitter[2], ui_ns.get(current_aa_settings[wraith_state.current_condition_index][7]))
        else
            ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_yaw_jitter[1], "Off")
            ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_yaw_jitter[2], 0)
            ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_yaw[2], wraith_state.fake_fakelag >= 3 and -ui_ns.get(current_aa_settings[wraith_state.current_condition_index][7]) / 2 or ui_ns.get(current_aa_settings[wraith_state.current_condition_index][7]) / 2)
            ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_body_yaw[1], "static")
            ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_body_yaw[2], wraith_state.fake_fakelag >= 3 and -180 or 180)
        end
        if ui_ns.get(current_aa_settings[wraith_state.current_condition_index][6]) ~= "slow" then
            ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_body_yaw[1], ui_ns.get(current_aa_settings[wraith_state.current_condition_index][8]))
            ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_body_yaw[2], ui_ns.get(current_aa_settings[wraith_state.current_condition_index][9]))
        end
        ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_freestand_body, ui_ns.get(current_aa_settings[wraith_state.current_condition_index][10]))
        ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_edge_yaw, ui_ns.get(current_aa_settings[wraith_state.current_condition_index][11]))
        ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_roll, ui_ns.get(current_aa_settings[wraith_state.current_condition_index][13]))
        if wraith_state.current_condition == "freestanding" then
            ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_freestand[1], true)
            ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_edge_yaw, false)
        else
            ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_freestand[1], false)
        end
        if ui_ns.get(current_aa_settings[wraith_state.current_condition_index][14]) then
            cmd.force_defensive = 1
        end
        if globals_ns.chokedcommands() < 13 and wraith_state.tickbase_diff ~= nil and wraith_state.tickbase_diff ~= 1 and wraith_state.tickbase_diff < -2 then
            local condition_settings = current_aa_settings[wraith_state.current_condition_index]
            local defensive_pitch = ui_ns.get(condition_settings[15])
            local defensive_yaw = ui_ns.get(condition_settings[16])
            if defensive_pitch ~= "off" and defensive_pitch ~= "zero" then
                ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_pitch[1], defensive_pitch)
            else
                if defensive_pitch == "zero" then
                    ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_pitch[1], "custom")
                    ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_pitch[2], 0)
                end
            end
            if defensive_yaw ~= "off" then
                ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_yaw[1], "180")
                ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_yaw_jitter[1], "off")
                if defensive_yaw == "forward" then
                    ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_yaw[2], 180)
                elseif defensive_yaw == "spin" then
                    ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_yaw[2], clamp(normalize_angle(wraith_state.yaw_increment_spin), -180, 180))
                elseif defensive_yaw == "jitter" then
                    ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_yaw[2], wraith_state.banana and 90 or -90)
                elseif defensive_yaw == "opposite" then
                    local manual_yaw_offsets = {forward = 0, left = 90, right = -90}
                    local yaw_offset = manual_yaw_offsets[wraith_state.mode]
                    if yaw_offset ~= nil then
                        ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_yaw[2], yaw_offset)
                    end
                end
            end
        end
        ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_aa_enabled, true)
    else
        if ui_ns.get(ui_elements["anti-aim"][0]) == "wraith (dont use)" then
            reset_antiaim()
        end
    end
end

local function check_bomb_defuse(local_player)
    local_origin = vector(entity_ns.get_origin(local_player))
    local bomb_distance = nil
    local bomb_origin = vector(entity_ns.get_prop(entity_ns.get_all("CPlantedC4")[1], "m_vecOrigin"))
    if bomb_origin.x ~= nil then
        bomb_distance = local_origin:dist(bomb_origin)
    else
        bomb_distance = nil
    end
    local team_num = entity_ns.get_prop(local_player, "m_iTeamNum")
    wraith_state.is_defusing = team_num == 3 and bomb_distance < 60 and not wraith_state.bomb_defused and not wraith_state.bomb_exploded
end

local function on_setup_command(cmd)
    local local_player = entity_ns.get_local_player()
    local enemy_threat = client_ns.current_threat()
    if ui_ns.get(ui_elements["debug"][0]) and menu_state.is_hovered or watermark_pos.dragging then
        cmd.in_attack = false
    end
    wraith_state.on_ground = bit_ns.band(entity_ns.get_prop(local_player, "m_fFlags"), 1) == 1
    wraith_state.jumping = ui_ns.get(gs_refs.misc.movement.ref_bhop) and cmd.in_jump == 1
    wraith_state.in_speed = bit_ns.band(cmd.buttons, 131072) > 0
    check_hittable_players()
    handle_extended_teleport(cmd)
    check_bomb_defuse(local_player)
    if globals_ns.chokedcommands() == 0 then
        wraith_state.current_desync = math_ns.min(math_ns.max(entity_ns.get_prop(local_player, "m_flPoseParameter", 11) * 120 - 60, -58), 58)
        wraith_state.current_desync = wraith_state.current_desync > 0 and math_ns.ceil(wraith_state.current_desync) or math_ns.floor(wraith_state.current_desync)
    end
    if globals_ns.chokedcommands() == 0 then
        wraith_state.fake_fakelag = wraith_state.fake_fakelag + 1
        if wraith_state.fake_fakelag >= 6 then
            wraith_state.fake_fakelag = 0
        end
    end
    apply_antiaim_settings(cmd, local_player, enemy_threat, true)
end

local function handle_menu_interaction()
    if not menu_state.is_open then
        menu_state.mouse_press = false
        return
    end
    local dpi_scale = ui_ns.get(gs_refs.misc.settings.ref_dpiscale)
    local menu_size = {ui_ns.menu_size()}
    local menu_pos = {ui_ns.menu_position()}
    local mouse_pos = {ui_ns.mouse_position()}
    scale = {0, 0}
    scale_x = 0
    if dpi_scale == "100%" then
        scale = {menu_state.dpi_scaling_y[1][1], menu_state.dpi_scaling_y[1][2]}
        scale_x = 76
    elseif dpi_scale == "125%" then
        scale = {menu_state.dpi_scaling_y[2][1], menu_state.dpi_scaling_y[2][2]}
        scale_x = 95
    elseif dpi_scale == "150%" then
        scale = {menu_state.dpi_scaling_y[3][1], menu_state.dpi_scaling_y[3][2]}
        scale_x = 113
    elseif dpi_scale == "175%" then
        scale = {menu_state.dpi_scaling_y[4][1], menu_state.dpi_scaling_y[4][2]}
        scale_x = 132
    elseif dpi_scale == "200%" then
        scale = {menu_state.dpi_scaling_y[5][1], menu_state.dpi_scaling_y[5][2]}
        scale_x = 151
    end
    if client_ns.key_state(0x1) then
        if not menu_state.mouse_press then
            menu_state.mouse_press = true
            if mouse_pos[1] > menu_pos[1] + 5 and mouse_pos[1] < menu_pos[1] + 5 + scale_x then
                if mouse_pos[2] > menu_pos[2] + scale[1] and mouse_pos[2] < menu_pos[2] + scale[2] then
                    menu_state.selected_gs_tab = true
                elseif mouse_pos[2] > menu_pos[2] + 19 or mouse_pos[2] < menu_pos[2] + menu_size[2] and (mouse_pos[2] < menu_pos[2] + scale[1] and mouse_pos[2] > menu_pos[2] + scale[2]) and mouse_pos[2] < menu_pos[2] + menu_size[2] and menu_state.selected_gs_tab == true then
                    menu_state.selected_gs_tab = false
                end
            end
        end
    else
        menu_state.mouse_press = false
    end
end

local function handle_manual_aa_binds()
    if entity_ns.get_prop(entity_ns.get_local_player(), "m_MoveType") == 8 then
        wraith_state.current_condition_index = 17
        wraith_state.current_condition = "noclip"
    end
    local manual_hotkeys = {
        ["left"] = ui_elements["anti-aim 2"][4],
        ["right"] = ui_elements["anti-aim 2"][5],
        ["forward"] = ui_elements["anti-aim 2"][6],
        ["back"] = ui_elements["anti-aim 2"][7]
    }
    local new_mode
    for direction, hotkey in pairs_fn(manual_hotkeys) do
        if ui_ns.get(hotkey) and wraith_state[direction .. "_ready"] then
            new_mode = direction == wraith_state.mode and "back" or direction
            wraith_state[direction .. "_ready"] = false
        end
        if not ui_ns.get(hotkey) then
            wraith_state[direction .. "_ready"] = true
        end
    end
    wraith_state.mode = new_mode or wraith_state.mode
end

local function update_animations()
    wraith_state.cur = globals_ns.tickcount()
    if wraith_state.cur > wraith_state.old_tick_count then
        wraith_state.banana = not wraith_state.banana
        wraith_state.old_tick_count = wraith_state.cur + 1
    end
    wraith_state.yaw_increment_spin = wraith_state.yaw_increment_spin + 20
    if wraith_state.yaw_increment_spin >= 1080 then
        wraith_state.yaw_increment_spin = 0
    end
    if wraith_state.started == 10 then
        if wraith_state.pulse >= 10 then
            wraith_state.pulse = wraith_state.pulse + 2.5
        end
        if wraith_state.pulse >= 240 then
            wraith_state.started = 1
        end
    end
    if wraith_state.started == 1 then
        wraith_state.pulse = wraith_state.pulse - 2.5
        if wraith_state.pulse <= 10 then
            wraith_state.started = 10
        end
    end
end

local function track_player_data(local_player)
    local enemy_players = entity_ns.get_players(true)
    if #enemy_players == 0 then
        player_data = {cur = {}, prev = {}, pre_prev = {}, pre_pre_prev = {}}
        return nil
    end
    for idx, player in ipairs_fn(enemy_players) do
        if entity_ns.is_alive(player) and not entity_ns.is_dormant(player) then
            local simtime_ticks = 0
            local esp_flags = entity_ns.get_esp_data(player).flags or 0
            if bit_ns.band(esp_flags, bit_ns.lshift(1, 17)) ~= 0 then
                simtime_ticks = time_to_ticks(entity_ns.get_prop(player, "m_flSimulationTime")) - 14
            else
                simtime_ticks = time_to_ticks(entity_ns.get_prop(player, "m_flSimulationTime"))
            end
            if player_data.cur[player] == nil or simtime_ticks - player_data.cur[player].simtime >= 1 then
                player_data.pre_pre_prev[player] = player_data.pre_prev[player]
                player_data.pre_prev[player] = player_data.prev[player]
                player_data.prev[player] = player_data.cur[player]
                local local_origin = vector(entity_ns.get_prop(local_player, "m_vecOrigin"))
                local player_eye_angles = vector(entity_ns.get_prop(player, "m_angEyeAngles"))
                local player_origin = vector(entity_ns.get_prop(player, "m_vecOrigin"))
                local yaw_delta = math_ns.floor(normalize_angle(player_eye_angles.y - calculate_angle(local_origin, player_origin)))
                local duck_amount = entity_ns.get_prop(player, "m_flDuckAmount")
                local on_ground = bit_ns.band(entity_ns.get_prop(player, "m_fFlags"), 1) == 1
                local velocity_2d = vector(entity_ns.get_prop(player, 'm_vecVelocity')):length2d()
                local stance = on_ground and (duck_amount == 1 and "duck" or (velocity_2d > 1.2 and "running" or "standing")) or "air"
                local weapon = entity_ns.get_player_weapon(player)
                local last_shot_time = entity_ns.get_prop(weapon, "m_fLastShotTime")
                player_data.cur[player] = {
                    id = player,
                    origin = vector(entity_ns.get_origin(player)),
                    pitch = player_eye_angles.x,
                    yaw = yaw_delta,
                    yaw_backwards = math_ns.floor(normalize_angle(calculate_angle(local_origin, player_origin))),
                    simtime = simtime_ticks,
                    stance = stance,
                    esp_flags = entity_ns.get_esp_data(player).flags or 0,
                    last_shot_time = last_shot_time
                }
            end
        end
    end
end

local aa_stealer_active = false

local function analyze_antiaim(local_player)
    if not entity_ns.is_alive(local_player) then
        if aa_stealer_active then
        end
        aa_stealer_active = false
        return
    end
    local enemy_players = entity_ns.get_players(true)
    if #enemy_players == 0 then
        return nil
    end
    for idx, player in ipairs_fn(enemy_players) do
        if entity_ns.is_alive(player) and not entity_ns.is_dormant(player) then
            if player_data.cur[player] ~= nil and player_data.prev[player] ~= nil and player_data.pre_prev[player] ~= nil and player_data.pre_pre_prev[player] ~= nil then
                local aa_type = nil
                local is_on_shot = nil
                local time_since_shot
                local ticks_since_shot
                local yaw_change = math_ns.abs(normalize_angle(player_data.cur[player].yaw - player_data.prev[player].yaw))
                local yaw_delta = normalize_angle(player_data.cur[player].yaw - player_data.prev[player].yaw)
                if player_data.cur[player].last_shot_time ~= nil then
                    time_since_shot = globals_ns.curtime() - player_data.cur[player].last_shot_time
                    ticks_since_shot = time_since_shot / globals_ns.tickinterval()
                    is_on_shot = ticks_since_shot <= math_ns.floor(0.2 / globals_ns.tickinterval())
                end
                if ui_ns.get(ui_elements["debug"][1]) == "desync" then
                    aa_stealer_active = true
                    local cur_yaw = player_data.cur[player].yaw
                    local prev_yaw = player_data.prev[player].yaw
                    local pre_prev_yaw = player_data.pre_prev[player].yaw
                    local pre_pre_prev_yaw = player_data.pre_pre_prev[player].yaw
                    local delta1 = normalize_angle(cur_yaw - prev_yaw)
                    local delta2 = normalize_angle(cur_yaw - pre_prev_yaw)
                    local delta3 = normalize_angle(prev_yaw - pre_pre_prev_yaw)
                    local delta4 = normalize_angle(prev_yaw - pre_prev_yaw)
                    local delta5 = normalize_angle(pre_prev_yaw - pre_pre_prev_yaw)
                    local delta6 = normalize_angle(pre_pre_prev_yaw - cur_yaw)
                    local delta7 = normalize_angle(yaw_change - delta6)
                    if is_on_shot and math_ns.abs(math_ns.abs(player_data.cur[player].pitch) - math_ns.abs(player_data.prev[player].pitch)) > 30 and player_data.cur[player].pitch < player_data.prev[player].pitch then
                        aa_type = "ON SHOT"
                    else
                        if math_ns.abs(player_data.cur[player].pitch) > 60 then
                            if yaw_change > 30 and math_ns.abs(delta2) < 15 and math_ns.abs(delta3) < 15 then
                                aa_type = "[!!]"
                            elseif math_ns.abs(delta1) > 15 or math_ns.abs(delta4) > 15 or math_ns.abs(delta5) > 15 or math_ns.abs(delta6) > 15 then
                                aa_type = "[!!!]"
                            end
                        end
                    end
                    if ui_ns.get(ui_elements["debug"][5]) and ui_ns.get(ui_elements["debug"][6]) then
                        if aa_type ~= "ON SHOT" then
                            plist_ns.set(player, "Add to whitelist", true)
                        else
                            plist_ns.set(player, "Add to whitelist", false)
                        end
                    else
                        plist_ns.set(player, "Add to whitelist", false)
                    end
                    if scan_aa_enabled[player] and aa_type ~= nil then
                        if player_data.cur[player].stance == "standing" and #player_aa_settings[player].stand < 20 then
                            table.insert(player_aa_settings[player].stand_type, aa_type)
                            if aa_type == "[!!!]" and yaw_change > 5 then
                                table.insert(player_aa_settings[player].stand, yaw_change)
                            else
                                if aa_type == "[!!]" then
                                    table.insert(player_aa_settings[player].stand, yaw_change)
                                end
                            end
                        elseif player_data.cur[player].stance == "running" and #player_aa_settings[player].run < 20 then
                            table.insert(player_aa_settings[player].run_type, aa_type)
                            if aa_type == "[!!!]" and yaw_change > 5 then
                                table.insert(player_aa_settings[player].run, yaw_change)
                            else
                                if aa_type == "[!!]" then
                                    table.insert(player_aa_settings[player].run, yaw_change)
                                end
                            end
                        elseif player_data.cur[player].stance == "air" and #player_aa_settings[player].air < 20 then
                            table.insert(player_aa_settings[player].air_type, aa_type)
                            if aa_type == "[!!!]" and yaw_change > 5 then
                                table.insert(player_aa_settings[player].air, yaw_change)
                            else
                                if aa_type == "[!!]" then
                                    table.insert(player_aa_settings[player].air, yaw_change)
                                end
                            end
                        elseif player_data.cur[player].stance == "duck" and #player_aa_settings[player].duck < 20 then
                            table.insert(player_aa_settings[player].duck_type, aa_type)
                            if aa_type == "[!!!]" and yaw_change > 5 then
                                table.insert(player_aa_settings[player].duck, yaw_change)
                            else
                                if aa_type == "[!!]" then
                                    table.insert(player_aa_settings[player].duck, yaw_change)
                                end
                            end
                        end
                    end
                    if player_data.cur[player].pitch >= 78 and player_data.prev[player].pitch > 78 then
                        if aa_type == "[!!!]" or aa_type == "[!!]" then
                            if aa_type == "[!!]" then
                                if normalize_angle(cur_yaw - prev_yaw) > 0 then
                                    plist_ns.set(player, "Force body yaw", true)
                                    plist_ns.set(player, "Force body yaw value", 60)
                                elseif normalize_angle(cur_yaw - prev_yaw) < 0 then
                                    plist_ns.set(player, "Force body yaw", true)
                                    plist_ns.set(player, "Force body yaw value", -60)
                                end
                            elseif aa_type == "[!!!]" then
                                local last_yaw_offset = 0
                                local current_yaw_offset = 0
                                if (prev_yaw == normalize_angle(cur_yaw - yaw_change) or prev_yaw == normalize_angle(cur_yaw + yaw_change)) and (pre_prev_yaw == normalize_angle(cur_yaw + yaw_change) or pre_prev_yaw == cur_yaw) and (pre_prev_yaw == normalize_angle(cur_yaw + yaw_change) or pre_prev_yaw == cur_yaw) then
                                    plist_ns.set(player, "Force body yaw", true)
                                    plist_ns.set(player, "Force body yaw value", 0)
                                    last_yaw_offset = cur_yaw
                                else
                                    if cur_yaw ~= last_yaw_offset then
                                        if cur_yaw < 0 then
                                            plist_ns.set(player, "Force body yaw", true)
                                            plist_ns.set(player, "Force body yaw value", 60)
                                        else
                                            plist_ns.set(player, "Force body yaw", true)
                                            plist_ns.set(player, "Force body yaw value", -60)
                                        end
                                    end
                                end
                            end
                        else
                            plist_ns.set(player, "Force body yaw", false)
                            plist_ns.set(player, "Force body yaw value", 0)
                        end
                    end
                elseif ui_ns.get(ui_elements["debug"][1]) == "---" then
                    aa_type = nil
                    aa_stealer_active = true
                    break
                elseif ui_ns.get(ui_elements["debug"][1]) == "off" then
                    if aa_stealer_active then
                        aa_type = nil
                        ui_ns.set(gs_refs.plist.reset, true)
                        plist_ns.set(player, "Force body yaw", false)
                        plist_ns.set(player, "Force body yaw value", 0)
                        aa_stealer_active = false
                    end
                end
                anti_aim_data[player] = {anti_aim_type = aa_type, yaw_delta = yaw_delta}
            end
        else
            m_fired = false
            time_difference = 0
            ticks_since_last_shot = 0
        end
    end
end

local function on_net_update_end(event)
    local local_player = entity_ns.get_local_player()
    if not ui_ns.get(main_checkbox) then
        return
    end
    if table_contains(ui_ns.get(ui_elements["misc"][1]), "fake duck") then
        entity_ns.set_prop(local_player, "m_flPoseParameter", 1, 1)
    end
    update_animations()
    track_player_data(local_player)
    analyze_antiaim(local_player)
end

client_ns.register_esp_flag("", 255, 255, 255, function(player)
    if not entity_ns.is_alive(entity_ns.get_local_player()) then
        return
    end
    if ui_ns.get(ui_elements["debug"][1]) then
        if entity_ns.is_alive(player) and not entity_ns.is_dormant(player) then
            if anti_aim_data[player] ~= nil then
                if anti_aim_data[player].anti_aim_type ~= nil then
                    return true, "\affffffc8" .. string_ns.upper(anti_aim_data[player].anti_aim_type)
                end
            end
        end
    end
end)

local function draw_custom_menu()
    if not ui_ns.get(ui_elements["debug"][0]) or not ui_ns.get(main_checkbox) then
        menu_state.menu_alpha = 0
        menu_state.is_hovered = false
        menu_initialized = false
        return
    end
    local dpi_scale = ui_ns.get(gs_refs.misc.settings.ref_dpiscale)
    menu_state.height = dpi_heights[dpi_scale] or 68
    if ui_ns.get(gs_refs.misc.settings.ref_menukey) then
        if not menu_key_pressed then
            menu_key_pressed = true
            menu_state.is_open = not menu_state.is_open
            menu_initialized = false
        end
    else
        menu_key_pressed = false
    end
    if not ui_ns.is_menu_open() then
        menu_state.is_open = false
    end
    if not menu_initialized then
        menu_state.fade_start_time = menu_state.is_open and globals_ns.realtime() or globals_ns.realtime()
        menu_initialized = true
    end
    if not menu_state.selected_gs_tab then
        menu_state.menu_alpha = 0
    end
    local target_alpha = menu_state.is_open and menu_state.selected_gs_tab and 255 or 0
    local fade_time = globals_ns.realtime() - menu_state.fade_start_time
    local fade_progress = math_ns.min(1, fade_time / 0.5)
    menu_state.menu_alpha = lerp(menu_state.menu_alpha, target_alpha, fade_progress)
    if menu_state.menu_alpha <= 0 then
        menu_state.is_hovered = false
        return
    end
    local menu_size = {ui_ns.menu_size()}
    local tab_width = math_ns.ceil((menu_size[1] - 12) / #menu_state.tabs_names)
    local menu_pos = {ui_ns.menu_position()}
    local mouse_pos = {ui_ns.mouse_position()}
    menu_state.is_hovered = mouse_pos[1] > menu_pos[1] and mouse_pos[1] < menu_pos[1] + tab_width * #menu_state.tabs_names and mouse_pos[2] > menu_pos[2] - menu_state.height and mouse_pos[2] < menu_pos[2] - menu_state.height + menu_state.height
    for tab_idx, tab_name in ipairs_fn(menu_state.tabs_names) do
        local tab_x = menu_pos[1] + 6 + tab_width * (tab_idx - 1)
        local is_hovered = mouse_pos[1] > tab_x and mouse_pos[1] < tab_x + tab_width and mouse_pos[2] > menu_pos[2] - menu_state.height and mouse_pos[2] < menu_pos[2]
        if menu_state.selected_tab == tab_idx then
            menu_state.selected_color[1] = {20, 20, 20}
            menu_state.selected_color[2] = {210, 210, 210}
        else
            menu_state.selected_color[1] = {12, 12, 12}
            menu_state.selected_color[2] = {90, 90, 90}
        end
        if is_hovered and menu_state.selected_tab ~= tab_idx then
            menu_state.selected_color[1] = {12, 12, 12}
            menu_state.selected_color[2] = {167, 167, 167}
        end
        renderer_ns.rectangle(tab_x, menu_pos[2] - menu_state.height, tab_width, menu_state.height, menu_state.selected_color[1][1], menu_state.selected_color[1][2], menu_state.selected_color[1][3], menu_state.menu_alpha)
        renderer_ns.text(tab_x + tab_width / 2, menu_pos[2] - menu_state.height / 2, menu_state.selected_color[2][1], menu_state.selected_color[2][2], menu_state.selected_color[2][3], menu_state.menu_alpha, "c+d", 0, tab_idx == 6 and icons[ui_ns.get(ui_elements["debug"][4])] or tab_name)
        if is_hovered and client_ns.key_state(0x1) then
            menu_state.selected_tab = tab_idx
            for idx, tab_name_str in ipairs_fn(tab_names) do
                if menu_state.selected_tab == idx then
                    ui_ns.set(ui_elements.tab, tab_name_str)
                end
            end
        end
    end
    gamesense_outer(menu_pos[1], menu_pos[2], menu_size[1], menu_state.height, menu_state.menu_alpha, false)
end

local aa_stealer_label1 = ui_ns.new_label("Players", "Adjustments", "-")
local aa_stealer_label2 = ui_ns.new_label("Players", "Adjustments", "-")

local function import_stolen_aa()
    local selected_player = ui_ns.get(gs_refs.plist.players)
    if selected_player == nil then
        return
    end
    if not scan_aa_enabled[selected_player] then
        g_notify:add("[STEALER] Please enable 'scan anti-aim'.", nil, 5)
        return
    end
    if ignore_missing_stances[selected_player] then
        if #player_aa_settings[selected_player].stand >= 20 or #player_aa_settings[selected_player].run >= 20 or #player_aa_settings[selected_player].air >= 20 or #player_aa_settings[selected_player].duck >= 20 then
            if #player_aa_settings[selected_player].stand >= 20 then
                local stand_type = get_mode(player_aa_settings[selected_player].stand_type)
                local stand_value = get_mode(player_aa_settings[selected_player].stand)
                if stand_type == "[!!]" then
                    stand_type = "Center"
                elseif stand_type == "[!!!]" then
                    stand_type = "Skitter"
                end
                ui_ns.set(gamesense_aa_settings[2][6], stand_type)
                ui_ns.set(gamesense_aa_settings[2][7], stand_value)
            end
            if #player_aa_settings[selected_player].run >= 20 then
                local run_type = get_mode(player_aa_settings[selected_player].run_type)
                local run_value = get_mode(player_aa_settings[selected_player].run)
                if run_type == "[!!]" then
                    run_type = "Center"
                elseif run_type == "[!!!]" then
                    run_type = "Skitter"
                end
                ui_ns.set(gamesense_aa_settings[3][6], run_type)
                ui_ns.set(gamesense_aa_settings[3][7], run_value)
            end
            if #player_aa_settings[selected_player].air >= 20 then
                local air_type = get_mode(player_aa_settings[selected_player].air_type)
                local air_value = get_mode(player_aa_settings[selected_player].air)
                if air_type == "[!!]" then
                    air_type = "Center"
                elseif air_type == "[!!!]" then
                    air_type = "Skitter"
                end
                ui_ns.set(gamesense_aa_settings[5][6], air_type)
                ui_ns.set(gamesense_aa_settings[5][7], air_value)
            end
            if #player_aa_settings[selected_player].duck >= 20 then
                local duck_type = get_mode(player_aa_settings[selected_player].duck_type)
                local duck_value = get_mode(player_aa_settings[selected_player].duck)
                if duck_type == "[!!]" then
                    duck_type = "Center"
                elseif duck_type == "[!!!]" then
                    duck_type = "Skitter"
                end
                ui_ns.set(gamesense_aa_settings[7][6], duck_type)
                ui_ns.set(gamesense_aa_settings[7][7], duck_value)
            end
        else
            g_notify:add("[STEALER] At least one stance must be done", nil, 5)
        end
    else
        if #player_aa_settings[selected_player].stand ~= 20 then
            g_notify:add("[STEALER] Still scanning standing anti-aim", nil, 5)
            return
        end
        if #player_aa_settings[selected_player].run ~= 20 then
            g_notify:add("[STEALER] Still scanning running anti-aim", nil, 5)
            return
        end
        if #player_aa_settings[selected_player].air ~= 20 then
            g_notify:add("[STEALER] Still scanning air anti-aim", nil, 5)
            return
        end
        if #player_aa_settings[selected_player].duck ~= 20 then
            g_notify:add("[STEALER] Still scanning duck anti-aim", nil, 5)
            return
        end
        if #player_aa_settings[selected_player].stand >= 20 then
            local stand_type = get_mode(player_aa_settings[selected_player].stand_type)
            local stand_value = get_mode(player_aa_settings[selected_player].stand)
            if stand_type == "[!!]" then
                stand_type = "Center"
            elseif stand_type == "[!!!]" then
                stand_type = "Skitter"
            end
            ui_ns.set(gamesense_aa_settings[2][6], stand_type)
            ui_ns.set(gamesense_aa_settings[2][7], stand_value)
        end
        if #player_aa_settings[selected_player].run >= 20 then
            local run_type = get_mode(player_aa_settings[selected_player].run_type)
            local run_value = get_mode(player_aa_settings[selected_player].run)
            if run_type == "[!!]" then
                run_type = "Center"
            elseif run_type == "[!!!]" then
                run_type = "Skitter"
            end
            ui_ns.set(gamesense_aa_settings[3][6], run_type)
            ui_ns.set(gamesense_aa_settings[3][7], run_value)
        end
        if #player_aa_settings[selected_player].air >= 20 then
            local air_type = get_mode(player_aa_settings[selected_player].air_type)
            local air_value = get_mode(player_aa_settings[selected_player].air)
            if air_type == "[!!]" then
                air_type = "Center"
            elseif air_type == "[!!!]" then
                air_type = "Skitter"
            end
            ui_ns.set(gamesense_aa_settings[5][6], air_type)
            ui_ns.set(gamesense_aa_settings[5][7], air_value)
        end
        if #player_aa_settings[selected_player].duck >= 20 then
            local duck_type = get_mode(player_aa_settings[selected_player].duck_type)
            local duck_value = get_mode(player_aa_settings[selected_player].duck)
            if duck_type == "[!!]" then
                duck_type = "Center"
            elseif duck_type == "[!!!]" then
                duck_type = "Skitter"
            end
            ui_ns.set(gamesense_aa_settings[7][6], duck_type)
            ui_ns.set(gamesense_aa_settings[7][7], duck_value)
        end
    end
    g_notify:add("[STEALER] Imported anti-aim settings from: " .. entity_ns.get_player_name(selected_player), nil, 5)
end

local function update_aa_stealer_ui()
    local selected_player = ui_ns.get(gs_refs.plist.players)
    if selected_player then
        if scan_aa_enabled[selected_player] then
            perc_stand = #player_aa_settings[selected_player].stand / 20 * 100
            perc_run = #player_aa_settings[selected_player].run / 20 * 100
            perc_air = #player_aa_settings[selected_player].air / 20 * 100
            perc_duck = #player_aa_settings[selected_player].duck / 20 * 100
            steal_string = perc_stand .. "% - " .. perc_run .. "% - " .. perc_air .. "% - " .. perc_duck .. "%"
            ui_ns.set(aa_stealer_label1, string_ns.format("%s", steal_string))
            ui_ns.set(aa_stealer_label2, string_ns.format("%s", "stand - run - air - duck"))
            if ignore_missing_stances[selected_player] then
                if perc_stand == 100 or perc_run == 100 or perc_air == 100 or perc_duck == 100 then
                    ui_ns.set(aa_stealer_label1, string_ns.format('%s', "done!"))
                end
            else
                if perc_stand == 100 and perc_run == 100 and perc_air == 100 and perc_duck == 100 then
                    ui_ns.set(aa_stealer_label1, string_ns.format('%s', "done!"))
                end
            end
        else
            ui_ns.set(aa_stealer_label1, string_ns.format('%s', "waiting for scan..."))
            player_aa_settings[selected_player].stand = {}
            player_aa_settings[selected_player].stand_type = {}
            player_aa_settings[selected_player].run = {}
            player_aa_settings[selected_player].run_type = {}
            player_aa_settings[selected_player].air = {}
            player_aa_settings[selected_player].air_type = {}
            player_aa_settings[selected_player].duck = {}
            player_aa_settings[selected_player].duck_type = {}
        end
    end
end

local import_aa_button = ui_ns.new_button("Players", "Adjustments", "import anti-aim", import_stolen_aa)
local plist_force_body_visible = false

local function on_paint_ui()
    local main_enabled = ui_ns.get(main_checkbox)
    local ui_visible = false
    local current_tab = ui_ns.get(ui_elements.tab)
    local aa_type = ui_ns.get(ui_elements["anti-aim"][0])
    local selected_condition = ui_ns.get(ui_elements["anti-aim"][1])
    draw_custom_menu()
    if not ui_ns.is_menu_open() then
        return
    end
    handle_menu_interaction()
    set_aa_visibility(main_enabled)
    if not main_enabled then
        if not wraith_state.reset_once then
            reset_antiaim()
            wraith_state.reset_once = true
        end
        wraith_state.smooth_wraith = -1080
        wraith_state.smooth_dt = -1080
        wraith_state.smooth_os = -1080
        wraith_state.smooth_pc = -1080
        wraith_state.smooth_bo = -1080
        wraith_state.smooth_wraith_recode = -1080
        wraith_state.smooth_dt_2 = -1080
        wraith_state.smooth_stance = -1080
        wraith_state.dt_os_text_anim = 0
        wraith_state.current_cond_text_anim = 0
    else
        ui_ns.set(gs_refs.anti_aim.anti_aimbot_angles.ref_aa_enabled, true)
        wraith_state.reset_once = false
    end
    if current_tab == "config" then
        ui_ns.update(ui_elements["config"][1], update_cfg())
    end
    ui_ns.set_visible(ui_elements.tab, main_enabled and ui_ns.get(ui_elements["debug"][0]) == false)
    update_aa_stealer_ui()
    if ui_ns.get(ui_elements["debug"][1]) ~= "off" then
        ui_ns.set_visible(gs_refs.plist.force_body, false)
        ui_ns.set_visible(gs_refs.plist.force_body_value, false)
        plist_force_body_visible = true
    else
        if plist_force_body_visible then
            ui_ns.set_visible(gs_refs.plist.force_body, true)
            ui_ns.set_visible(gs_refs.plist.force_body_value, true)
            local enemy_players = entity_ns.get_players(true)
            if #enemy_players ~= 0 then
                for idx, player in ipairs_fn(enemy_players) do
                    plist_ns.set(player, "Force body yaw", false)
                    plist_ns.set(player, "Force body yaw value", 0)
                end
            end
            plist_force_body_visible = false
        end
    end
    for tab_name, tab_elements in pairs_fn(ui_elements) do
        if tab_elements ~= ui_elements.tab then
            for element_idx, element_ref in pairs_fn(tab_elements) do
                ui_ns.set_visible(element_ref, main_enabled and tab_name == current_tab)
                if current_tab == "anti-aim 2" then
                    for hotkey_idx = 1, 9 do
                        if hotkey_idx == 1 or hotkey_idx == 2 then
                            ui_ns.set_visible(ui_elements["anti-aim 2"][hotkey_idx], main_enabled and table_contains(ui_ns.get(ui_elements["anti-aim 2"][0]), "other anti-aim binds"))
                        elseif hotkey_idx > 2 and hotkey_idx < 10 then
                            ui_ns.set_visible(ui_elements["anti-aim 2"][hotkey_idx], main_enabled and table_contains(ui_ns.get(ui_elements["anti-aim 2"][0]), "manual anti-aim"))
                        end
                    end
                end
                if current_tab == "visuals" then
                    ui_ns.set_visible(ui_elements["visuals"][4], main_enabled and ui_ns.get(ui_elements["visuals"][2]))
                    ui_ns.set_visible(ui_elements["visuals"][5], main_enabled and ui_ns.get(ui_elements["visuals"][7]))
                    if not table_contains(ui_ns.get(ui_elements["misc"][3]), "default") and not table_contains(ui_ns.get(ui_elements["misc"][3]), "center") then
                        ui_ns.set_visible(ui_elements["visuals"][5], main_enabled and false)
                        ui_ns.set_visible(ui_elements["visuals"][7], main_enabled and false)
                    end
                end
                if current_tab == "misc" then
                    ui_ns.set_visible(ui_elements["misc"][5], main_enabled and ui_ns.get(ui_elements["misc"][4]))
                end
                if current_tab == "debug" then
                    ui_ns.set_visible(ui_elements["debug"][3], main_enabled and ui_ns.get(ui_elements["debug"][2]))
                end
            end
        end
    end
    for aa_table_idx, aa_settings_table in ipairs_fn({gamesense_aa_settings, wraith_aa_settings}) do
        selected_wraith_settings = aa_settings_table
        for condition_idx, condition_settings in pairs_fn(aa_settings_table) do
            if aa_type == "gamesense" and aa_settings_table == gamesense_aa_settings then
                current_aa_settings = aa_settings_table
            elseif aa_type == "wraith (dont use)" and aa_settings_table == wraith_aa_settings then
                current_wraith_settings = aa_settings_table
            end
            for setting_idx, setting_ref in pairs_fn(condition_settings) do
                ui_visible = (aa_type == "gamesense" and aa_settings_table == gamesense_aa_settings or aa_type == "wraith (dont use)" and aa_settings_table == wraith_aa_settings) and condition_names[condition_idx] == selected_condition and current_tab == "anti-aim" and main_enabled and (setting_ref == aa_settings_table[condition_idx][0] or ui_ns.get(aa_settings_table[condition_idx][0]))
                if aa_type == "gamesense" and aa_settings_table == gamesense_aa_settings then
                    if selected_condition == "freestanding" or selected_condition == "manual" or selected_condition == "legit" or selected_condition == "backstab" then
                        ui_visible = ui_visible and (setting_ref ~= aa_settings_table[condition_idx][11] and setting_ref ~= aa_settings_table[condition_idx][12])
                    end
                    if selected_condition == "manual" then
                        ui_visible = ui_visible and setting_ref ~= aa_settings_table[condition_idx][5]
                    end
                    if ui_ns.get(aa_settings_table[condition_idx][1]) ~= "custom" then
                        ui_visible = ui_visible and setting_ref ~= aa_settings_table[condition_idx][2]
                    end
                    if ui_ns.get(aa_settings_table[condition_idx][4]) == "off" then
                        ui_visible = ui_visible and (setting_ref ~= aa_settings_table[condition_idx][5] and setting_ref ~= aa_settings_table[condition_idx][6] and setting_ref ~= aa_settings_table[condition_idx][7])
                    end
                    if ui_ns.get(aa_settings_table[condition_idx][6]) == "off" then
                        ui_visible = ui_visible and setting_ref ~= aa_settings_table[condition_idx][7]
                    end
                    if ui_ns.get(aa_settings_table[condition_idx][8]) then
                        if ui_ns.get(aa_settings_table[condition_idx][8]) == "off" then
                            ui_visible = ui_visible and setting_ref ~= aa_settings_table[condition_idx][10]
                        end
                        if ui_ns.get(aa_settings_table[condition_idx][8]) == "off" or ui_ns.get(aa_settings_table[condition_idx][8]) == "opposite" then
                            ui_visible = ui_visible and setting_ref ~= aa_settings_table[condition_idx][9]
                        end
                    end
                    if ui_ns.get(aa_settings_table[condition_idx][6]) == "slow" then
                        ui_visible = ui_visible and (setting_ref ~= aa_settings_table[condition_idx][9] and setting_ref ~= aa_settings_table[condition_idx][8])
                    end
                end
                ui_ns.set_visible(setting_ref, ui_visible)
            end
        end
    end
end

writefile(tostring_fn("!default_preset2124089493w.cfg"), "dHJ1ZV9taW5pbWFsXzBfYXQgdGFyZ2V0c18xODBfMF9za2l0dGVyXzIwX2ppdHRlcl8wX2ZhbHNlX2ZhbHNlX2ZhbHNlXzBfZmFsc2Vfb2ZmX29mZl90cnVlX21pbmltYWxfMF9hdCB0YXJnZXRzXzE4MF8wX3NraXR0ZXJfMzBfaml0dGVyXzBfZmFsc2VfZmFsc2VfZmFsc2VfMF9mYWxzZV9vZmZfb2ZmX3RydWVfZGVmYXVsdF8wX2F0IHRhcmdldHNfMTgwXzBfc2xvd183MF9qaXR0ZXJfMF9mYWxzZV9mYWxzZV9mYWxzZV8wX2ZhbHNlX29mZl9vZmZfdHJ1ZV9kZWZhdWx0XzBfYXQgdGFyZ2V0c18xODBfMF9za2l0dGVyXzUwX2ppdHRlcl8wX2ZhbHNlX2ZhbHNlX2ZhbHNlXzBfZmFsc2Vfb2ZmX29mZl90cnVlX2RlZmF1bHRfMF9hdCB0YXJnZXRzXzE4MF8wX3NraXR0ZXJfMzBfaml0dGVyXzBfZmFsc2VfZmFsc2VfZmFsc2VfMF9mYWxzZV9vZmZfb2ZmX3RydWVfZGVmYXVsdF8wX2F0IHRhcmdldHNfMTgwXzBfc2xvd183M19qaXR0ZXJfMF9mYWxzZV9mYWxzZV9mYWxzZV8wX2ZhbHNlX29mZl9vZmZfdHJ1ZV9taW5pbWFsXzBfYXQgdGFyZ2V0c18xODBfLTE1X29mZl81X3N0YXRpY18tNTRfZmFsc2VfZmFsc2VfZmFsc2VfMF9mYWxzZV9vZmZfb2ZmX3RydWVfbWluaW1hbF8wX2F0IHRhcmdldHNfMTgwXzVfc2tpdHRlcl8zMF9qaXR0ZXJfMF9mYWxzZV9mYWxzZV9mYWxzZV8wX2ZhbHNlX29mZl9vZmZfZmFsc2Vfb2ZmXzBfbG9jYWwgdmlld19vZmZfMF9vZmZfMF9vZmZfMF9mYWxzZV9mYWxzZV9mYWxzZV8wX2ZhbHNlX29mZl9vZmZfdHJ1ZV9taW5pbWFsXzBfYXQgdGFyZ2V0c18xODBfM19vZmZzZXRfMTlfaml0dGVyXzE4MF9mYWxzZV9mYWxzZV9mYWxzZV8wX2ZhbHNlX29mZl9vZmZfdHJ1ZV9taW5pbWFsXzBfbG9jYWwgdmlld18xODBfMF9vZmZfMF9zdGF0aWNfMTgwX2ZhbHNlX2ZhbHNlX2ZhbHNlXzBfZmFsc2Vfb2ZmX2ppdHRlcl9mYWxzZV91cF8wX2F0IHRhcmdldHNfc3Bpbl8xOV9vZmZfNDdfaml0dGVyXzBfZmFsc2VfZmFsc2VfZmFsc2VfMF9mYWxzZV91cF9vZmZfdHJ1ZV9yYW5kb21fMF9hdCB0YXJnZXRzXzE4MF8xODBfb2ZmXzBfb2ZmXzE4MF9mYWxzZV9mYWxzZV9mYWxzZV8wX2ZhbHNlX29mZl9vZmZfdHJ1ZV9taW5pbWFsXzBfYXQgdGFyZ2V0c18xODBfMF9vZmZfOF9zdGF0aWNfMF9mYWxzZV9mYWxzZV9mYWxzZV8wX2ZhbHNlX29mZl9vZmZfdHJ1ZV9kZWZhdWx0XzBfYXQgdGFyZ2V0c18xODBfMF9vZmZfMF9zdGF0aWNfMF9mYWxzZV9mYWxzZV9mYWxzZV8wX2ZhbHNlX29mZl9vZmZfdHJ1ZV9vZmZfMF9sb2NhbCB2aWV3XzE4MF8xODBfb2ZmXzBfaml0dGVyXzBfZmFsc2VfZmFsc2VfZmFsc2VfMF9mYWxzZV9vZmZfb2ZmX2ZhbHNlX29mZl9vZmZfMF9vZmZfZmFsc2Vfb2ZmX29mZl8wX29mZl9mYWxzZV9vZmZfb2ZmXzBfb2ZmX2ZhbHNlX29mZl9vZmZfMF9vZmZfZmFsc2Vfb2ZmX29mZl8wX29mZl9mYWxzZV9vZmZfb2ZmXzBfb2ZmX2ZhbHNlX29mZl9vZmZfMF9vZmZfZmFsc2Vfb2ZmX29mZl8wX29mZl9mYWxzZV9vZmZfb2ZmXzBfb2ZmX2ZhbHNlX29mZl9vZmZfMF9vZmZfZmFsc2Vfb2ZmX29mZl8wX29mZl9mYWxzZV9vZmZfb2ZmXzBfb2ZmX2ZhbHNlX29mZl9vZmZfMF9vZmZfZmFsc2Vfb2ZmX29mZl8wX29mZl9mYWxzZV9vZmZfb2ZmXzBfb2ZmX3RydWVfb2ZmX29mZl8wX29mZl8=")
writefile(tostring_fn("!default_fs_preset2124089493w.cfg"), "ZmFsc2Vfb2ZmXzBfbG9jYWwgdmlld19vZmZfMF9vZmZfMF9vZmZfMF9mYWxzZV9mYWxzZV9mYWxzZV8wX2ZhbHNlX29mZl9vZmZfdHJ1ZV9kb3duXzBfYXQgdGFyZ2V0c18xODBfMF9za2l0dGVyXzQ1X2ppdHRlcl8wX2ZhbHNlX2ZhbHNlX3RydWVfMF9mYWxzZV9vZmZfb2ZmX3RydWVfZG93bl8wX2F0IHRhcmdldHNfMTgwXy0xX3Nsb3dfNDlfaml0dGVyXzBfZmFsc2VfZmFsc2VfdHJ1ZV8wX3RydWVfb2ZmX29wcG9zaXRlX3RydWVfZG93bl8wX2F0IHRhcmdldHNfMTgwXzFfc2xvd18xMTBfb3Bwb3NpdGVfMF9mYWxzZV9mYWxzZV9mYWxzZV8wX3RydWVfb2ZmX29wcG9zaXRlX3RydWVfZG93bl8wX2F0IHRhcmdldHNfMTgwXy01X2NlbnRlcl8yN19vcHBvc2l0ZV8wX2ZhbHNlX2ZhbHNlX2ZhbHNlXzBfdHJ1ZV96ZXJvX3NwaW5fdHJ1ZV9taW5pbWFsXy00Nl9hdCB0YXJnZXRzXzE4MF8tNV9jZW50ZXJfMjdfc3RhdGljXzdfZmFsc2VfZmFsc2VfZmFsc2VfMF90cnVlX3JhbmRvbV9qaXR0ZXJfdHJ1ZV9kb3duXzBfYXQgdGFyZ2V0c18xODBfLTdfb2ZmXzMyX3N0YXRpY18tMTgwX2ZhbHNlX2ZhbHNlX2ZhbHNlXzBfZmFsc2Vfb2ZmX29mZl90cnVlX21pbmltYWxfMF9hdCB0YXJnZXRzXzE4MF8tMV9zbG93XzQ1X29wcG9zaXRlXy0xODBfZmFsc2VfZmFsc2VfZmFsc2VfMF90cnVlX21pbmltYWxfb3Bwb3NpdGVfdHJ1ZV9kb3duXzBfYXQgdGFyZ2V0c18xODBfLTJfY2VudGVyXzMyX3N0YXRpY18tMTgwX2ZhbHNlX2ZhbHNlX2ZhbHNlXzBfdHJ1ZV9taW5pbWFsX29wcG9zaXRlX2ZhbHNlX29mZl8wX2xvY2FsIHZpZXdfb2ZmXzBfb2ZmXzBfb2ZmXzBfZmFsc2VfZmFsc2VfZmFsc2VfMF9mYWxzZV9vZmZfb2ZmX2ZhbHNlX29mZl8wX2xvY2FsIHZpZXdfb2ZmXzBfb2ZmXzBfb2ZmXzBfZmFsc2VfZmFsc2VfZmFsc2VfMF9mYWxzZV9vZmZfb2ZmX3RydWVfZG93bl8wX2F0IHRhcmdldHNfMTgwXzBfb2ZmXzE1X29wcG9zaXRlXzBfZmFsc2VfZmFsc2VfZmFsc2VfMF9mYWxzZV9vZmZfb2ZmX3RydWVfb2ZmXzBfYXQgdGFyZ2V0c18xODBfMTgwX29mZl8wX29wcG9zaXRlXzBfZmFsc2VfZmFsc2VfZmFsc2VfMF9mYWxzZV9vZmZfb2ZmX2ZhbHNlX21pbmltYWxfMF9hdCB0YXJnZXRzXzE4MF8tMV9vZmZfOF9vcHBvc2l0ZV8zX2ZhbHNlX2ZhbHNlX2ZhbHNlXzBfZmFsc2VfbWluaW1hbF9vZmZfZmFsc2Vfb2ZmXzBfbG9jYWwgdmlld19vZmZfMF9vZmZfMF9vZmZfMF9mYWxzZV9mYWxzZV9mYWxzZV8wX2ZhbHNlX29mZl9vZmZfdHJ1ZV9jdXN0b21fMF9hdCB0YXJnZXRzX29mZl8wX29mZl8wX29wcG9zaXRlXzE4MF9mYWxzZV9mYWxzZV9mYWxzZV8wX2ZhbHNlX29mZl9vZmZfZmFsc2Vfb2ZmX29mZl8wX29mZl9mYWxzZV9vZmZfb2ZmXzBfb2ZmX2ZhbHNlX29mZl9vZmZfMF9vZmZfZmFsc2Vfb2ZmX29mZl8wX29mZl9mYWxzZV9vZmZfb2ZmXzBfb2ZmX2ZhbHNlX29mZl9vZmZfMF9vZmZfZmFsc2Vfb2ZmX29mZl8wX29mZl9mYWxzZV9vZmZfb2ZmXzBfb2ZmX2ZhbHNlX29mZl9vZmZfMF9vZmZfZmFsc2Vfb2ZmX29mZl8wX29mZl9mYWxzZV9vZmZfb2ZmXzBfb2ZmX2ZhbHNlX2Zha2UgZG93biAoLTE4MClfY2VudGVyXzIzX2ppdHRlcl9mYWxzZV9vZmZfb2ZmXzBfb2ZmX2ZhbHNlX29mZl9vZmZfMF9vZmZfZmFsc2Vfb2ZmX29mZl8wX29mZl90cnVlX29mZl9vZmZfMF9vZmZf")

local function create_config()
    if ui_ns.get(ui_elements["config"][2]) == "" then
        if table_contains(ui_ns.get(ui_elements["misc"][2]), "config changes") then
            g_notify:add("(error) empty config name", nil, 5)
        end
        return
    end
    if not table_contains(get_config_files(), ui_ns.get(ui_elements["config"][2]) .. "2124089493w.cfg") then
        if table_contains(ui_ns.get(ui_elements["misc"][2]), "config changes") then
            g_notify:add("'" .. ui_ns.get(ui_elements["config"][2]) .. "' anti-aim config created", nil, 5)
        end
        writefile(tostring_fn(ui_ns.get(ui_elements["config"][2]) .. "2124089493w.cfg"), "blank")
    else
        if table_contains(ui_ns.get(ui_elements["misc"][2]), "config changes") then
            g_notify:add("(error) '" .. string_ns.sub(get_config_files()[ui_ns.get(ui_elements["config"][1]) + 1], 1, -16) .. "' anti-aim config already exists", nil, 5)
        end
    end
end

local function load_config()
    if ui_ns.get(ui_elements["config"][1]) == nil or get_config_files()[ui_ns.get(ui_elements["config"][1]) + 1] == nil then
        if table_contains(ui_ns.get(ui_elements["misc"][2]), "config changes") then
            g_notify:add("(error) no config selected", nil, 5)
        end
        return
    end
    if readfile(get_config_files()[ui_ns.get(ui_elements["config"][1]) + 1]) == "blank" then
        if table_contains(ui_ns.get(ui_elements["misc"][2]), "config changes") then
            g_notify:add("(error) '" .. string_ns.sub(get_config_files()[ui_ns.get(ui_elements["config"][1]) + 1], 1, -16) .. "' anti-aim config is blank", nil, 5)
        end
        return
    end
    local config_data = split_string(base64.decode(readfile(get_config_files()[ui_ns.get(ui_elements["config"][1]) + 1]), "base64"), "_")
    local data_index = 1
    for aa_table_idx, aa_settings_table in ipairs_fn({gamesense_aa_settings, wraith_aa_settings}) do
        for condition_idx, condition_settings in pairs_fn(aa_settings_table) do
            if aa_settings_table == gamesense_aa_settings then
                for setting_idx = 0, 16 do
                    if config_data[data_index] == "true" then
                        ui_ns.set(aa_settings_table[condition_idx][setting_idx], true)
                    elseif config_data[data_index] == "false" then
                        ui_ns.set(aa_settings_table[condition_idx][setting_idx], false)
                    else
                        ui_ns.set(aa_settings_table[condition_idx][setting_idx], tostring_fn(config_data[data_index]))
                    end
                    data_index = data_index + 1
                end
            else
                for setting_idx = 0, 4 do
                    if config_data[data_index] == "true" then
                        ui_ns.set(aa_settings_table[condition_idx][setting_idx], true)
                    elseif config_data[data_index] == "false" then
                        ui_ns.set(aa_settings_table[condition_idx][setting_idx], false)
                    else
                        ui_ns.set(aa_settings_table[condition_idx][setting_idx], tostring_fn(config_data[data_index]))
                    end
                    data_index = data_index + 1
                end
            end
        end
    end
    if table_contains(ui_ns.get(ui_elements["misc"][2]), "config changes") then
        g_notify:add("'" .. string_ns.sub(get_config_files()[ui_ns.get(ui_elements["config"][1]) + 1], 1, -16) .. "' anti-aim config loaded", nil, 5)
    end
end

local function save_config()
    local config_string = ""
    for aa_table_idx, aa_settings_table in ipairs_fn({gamesense_aa_settings, wraith_aa_settings}) do
        for condition_idx, condition_settings in pairs_fn(aa_settings_table) do
            if aa_settings_table == gamesense_aa_settings then
                for setting_idx = 0, 16 do
                    config_string = config_string .. tostring_fn(ui_ns.get(aa_settings_table[condition_idx][setting_idx])) .. "_"
                end
            elseif aa_settings_table == wraith_aa_settings then
                for setting_idx = 0, 4 do
                    config_string = config_string .. tostring_fn(ui_ns.get(aa_settings_table[condition_idx][setting_idx])) .. "_"
                end
            end
        end
    end
    database_ns.write("current_clip_board_to_save", base64.encode(config_string, "base64"))
    read_data = database_ns.read("current_clip_board_to_save")
    writefile(get_config_files()[ui_ns.get(ui_elements["config"][1]) + 1], read_data)
    if table_contains(ui_ns.get(ui_elements["misc"][2]), "config changes") then
        g_notify:add("'" .. string_ns.sub(get_config_files()[ui_ns.get(ui_elements["config"][1]) + 1], 1, -16) .. "' anti-aim config saved", nil, 5)
    end
end

local function delete_config()
    if ui_ns.get(ui_elements["config"][1]) == nil or get_config_files()[ui_ns.get(ui_elements["config"][1]) + 1] == nil then
        return
    end
    if table_contains(ui_ns.get(ui_elements["misc"][2]), "config changes") then
        g_notify:add("'" .. string_ns.sub(get_config_files()[ui_ns.get(ui_elements["config"][1]) + 1], 1, -16) .. "' anti-aim config deleted", nil, 5)
    end
    filesystem_funcs.remove_file(current_directory .. "/" .. get_config_files()[ui_ns.get(ui_elements["config"][1]) + 1], get_config_files()[ui_ns.get(ui_elements["config"][1]) + 1])
end

local function reset_config()
    if current_aa_settings == nil then
        return
    end
    for condition_idx, condition_name in pairs_fn(condition_names) do
        ui_ns.set(current_aa_settings[condition_idx][0], false)
        ui_ns.set(current_aa_settings[condition_idx][1], "off")
        ui_ns.set(current_aa_settings[condition_idx][2], 0)
        ui_ns.set(current_aa_settings[condition_idx][3], "local view")
        ui_ns.set(current_aa_settings[condition_idx][4], "off")
        ui_ns.set(current_aa_settings[condition_idx][5], 0)
        ui_ns.set(current_aa_settings[condition_idx][6], "off")
        ui_ns.set(current_aa_settings[condition_idx][7], 0)
        ui_ns.set(current_aa_settings[condition_idx][8], "off")
        ui_ns.set(current_aa_settings[condition_idx][9], 0)
        ui_ns.set(current_aa_settings[condition_idx][10], false)
        ui_ns.set(current_aa_settings[condition_idx][11], false)
        ui_ns.set(current_aa_settings[condition_idx][12], false)
        ui_ns.set(current_aa_settings[condition_idx][13], 0)
        ui_ns.set(current_aa_settings[condition_idx][14], false)
        ui_ns.set(current_aa_settings[condition_idx][15], "off")
        ui_ns.set(current_aa_settings[condition_idx][16], "off")
    end
    if table_contains(ui_ns.get(ui_elements["misc"][2]), "config changes") then
        g_notify:add("anti-aim config reset", nil, 5)
    end
end

local function import_from_clipboard()
    local clipboard_data = split_string(base64.decode(clipboard.get(), "base64"), "_")
    local data_index = 1
    for aa_table_idx, aa_settings_table in ipairs_fn({gamesense_aa_settings, wraith_aa_settings}) do
        for condition_idx, condition_settings in pairs_fn(aa_settings_table) do
            if aa_settings_table == gamesense_aa_settings then
                for setting_idx = 0, 16 do
                    if clipboard_data[data_index] == "true" then
                        ui_ns.set(aa_settings_table[condition_idx][setting_idx], true)
                    elseif clipboard_data[data_index] == "false" then
                        ui_ns.set(aa_settings_table[condition_idx][setting_idx], false)
                    else
                        ui_ns.set(aa_settings_table[condition_idx][setting_idx], tostring_fn(clipboard_data[data_index]))
                    end
                    data_index = data_index + 1
                end
            else
                for setting_idx = 0, 4 do
                    if clipboard_data[data_index] == "true" then
                        ui_ns.set(aa_settings_table[condition_idx][setting_idx], true)
                    elseif clipboard_data[data_index] == "false" then
                        ui_ns.set(aa_settings_table[condition_idx][setting_idx], false)
                    else
                        ui_ns.set(aa_settings_table[condition_idx][setting_idx], tostring_fn(clipboard_data[data_index]))
                    end
                    data_index = data_index + 1
                end
            end
        end
    end
    if table_contains(ui_ns.get(ui_elements["misc"][2]), "config changes") then
        g_notify:add("imported wraith anti-aim", nil, 5)
    end
end

local function export_to_clipboard()
    local config_string = ""
    for aa_table_idx, aa_settings_table in ipairs_fn({gamesense_aa_settings, wraith_aa_settings}) do
        for condition_idx, condition_settings in pairs_fn(aa_settings_table) do
            if aa_settings_table == gamesense_aa_settings then
                for setting_idx = 0, 16 do
                    config_string = config_string .. tostring_fn(ui_ns.get(aa_settings_table[condition_idx][setting_idx])) .. "_"
                end
            elseif aa_settings_table == wraith_aa_settings then
                for setting_idx = 0, 4 do
                    config_string = config_string .. tostring_fn(ui_ns.get(aa_settings_table[condition_idx][setting_idx])) .. "_"
                end
            end
        end
    end
    clipboard.set(base64.encode(config_string), "base64")
    if table_contains(ui_ns.get(ui_elements["misc"][2]), "config changes") then
        g_notify:add("exported wraith anti-aim", nil, 5)
    end
end

ui_elements["config"][9] = ui_ns.new_button("AA", "Anti-aimbot angles", "create", create_config)
ui_elements["config"][3] = ui_ns.new_button("AA", "Anti-aimbot angles", "load", load_config)
ui_elements["config"][4] = ui_ns.new_button("AA", "Anti-aimbot angles", "save", save_config)
ui_elements["config"][5] = ui_ns.new_button("AA", "Anti-aimbot angles", "delete", delete_config)
ui_elements["config"][6] = ui_ns.new_button("AA", "Anti-aimbot angles", "reset", reset_config)
ui_elements["config"][7] = ui_ns.new_button("AA", "Anti-aimbot angles", "import from clipboard", import_from_clipboard)
ui_elements["config"][8] = ui_ns.new_button("AA", "Anti-aimbot angles", "export to clipboard", export_to_clipboard)

local function on_shutdown()
    reset_antiaim()
    set_aa_visibility(false)
    ui_ns.set_visible(gs_refs.plist.force_body, true)
    ui_ns.set_visible(gs_refs.plist.force_body_value, true)
    local enemy_players = entity_ns.get_players(true)
    if #enemy_players == 0 then
        return nil
    end
    for idx, player in ipairs_fn(enemy_players) do
        plist_ns.set(player, "Force body yaw", false)
        plist_ns.set(player, "Force body yaw value", 0)
    end
end

local function setup_callbacks(checkbox_ref)
    local is_enabled = ui_ns.get(checkbox_ref)
    local callback_func = is_enabled and client_ns.set_event_callback or client_ns.unset_event_callback
    callback_func("paint", on_paint)
    callback_func("pre_render", on_pre_render)
    callback_func("run_command", on_run_command)
    callback_func("predict_command", on_predict_command)
    callback_func("setup_command", on_setup_command)
    callback_func("net_update_start", handle_manual_aa_binds)
    callback_func("net_update_end", on_net_update_end)
    callback_func("dormant_hit", on_dormant_hit)
    callback_func("dormant_miss", on_dormant_miss)
    callback_func("round_prestart", on_round_prestart)
    callback_func("aim_fire", on_aim_fire)
    callback_func("player_hurt", on_player_hurt)
    callback_func("aim_miss", on_aim_miss)
    callback_func("player_death", on_player_death)
    callback_func("bomb_defused", function()
        wraith_state.bomb_defused = true
    end)
    callback_func("bomb_exploded", function()
        wraith_state.bomb_exploded = true
    end)
    callback_func("cs_match_end_restart", reset)
    callback_func("cs_game_disconnected", reset)
    callback_func("client_disconnect", reset)
    callback_func("player_connect_full", reset)
    callback_func("game_newmap", reset)
end

ui_ns.set_callback(main_checkbox, setup_callbacks)
setup_callbacks(main_checkbox)
client_ns.set_event_callback("paint_ui", on_paint_ui)
client_ns.set_event_callback("shutdown", on_shutdown)

cvar.cl_use_opens_buy_menu:set_int(0)
cvar.cl_autowepswitch:set_int(0)
