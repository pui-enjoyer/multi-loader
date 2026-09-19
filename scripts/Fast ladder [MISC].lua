local entity_get_prop = entity.get_prop
local ui_get = ui.get
local client_camera_angles = client.camera_angles
local fast_ladder = ui.new_multiselect("MISC", "Movement", "Fast ladder", "Ascending", "Descending")
local ladder_yaw_checkbox = ui.new_checkbox("AA", "Anti-aimbot angles", "Ladder yaw")
local ladder_yaw_slider = ui.new_slider("AA", "Anti-aimbot angles", "\nLadder yaw", -180, 180, 0, true, "°")

local function contains(tbl, val) 
    for i=1, #tbl do
        if tbl[i] == val then return true end 
    end 
    return false 
end

client.set_event_callback("setup_command", function(e)
    local local_player = entity.get_local_player()
    local pitch, yaw = client_camera_angles()
    if entity_get_prop(local_player, "m_MoveType") == 9 then
        e.yaw = math.floor(e.yaw+0.5)
        e.roll = 0
        if ui_get(ladder_yaw_checkbox) then
            if e.forwardmove == 0 then
                e.pitch = 89
                e.yaw = e.yaw + ui_get(ladder_yaw_slider)
                if math.abs(ui_get(ladder_yaw_slider)) > 0 and math.abs(ui_get(ladder_yaw_slider)) < 180 and e.sidemove ~= 0 then
                    e.yaw = e.yaw - ui_get(ladder_yaw_slider)
                end
                if math.abs(ui_get(ladder_yaw_slider)) == 180 then
                    if e.sidemove < 0 then
                        e.in_moveleft = 0
                        e.in_moveright = 1
                    end
                    if e.sidemove > 0 then
                        e.in_moveleft = 1
                        e.in_moveright = 0
                    end
                end
            end
        end

        if contains(ui_get(fast_ladder), "Ascending") then
            if e.forwardmove > 0 then
                if pitch < 45 then
                    e.pitch = 89
                    e.in_moveright = 1
                    e.in_moveleft = 0
                    e.in_forward = 0
                    e.in_back = 1
                    if e.sidemove == 0 then
                        e.yaw = e.yaw + 90
                    end
                    if e.sidemove < 0 then
                        e.yaw = e.yaw + 150
                    end
                    if e.sidemove > 0 then
                        e.yaw = e.yaw + 30
                    end
                end 
            end
        end
        if contains(ui_get(fast_ladder), "Descending") then
            if e.forwardmove < 0 then
                e.pitch = 89
                e.in_moveleft = 1
                e.in_moveright = 0
                e.in_forward = 1
                e.in_back = 0
                if e.sidemove == 0 then
                    e.yaw = e.yaw + 90
                end
                if e.sidemove > 0 then
                    e.yaw = e.yaw + 150
                end
                if e.sidemove < 0 then
                    e.yaw = e.yaw + 30
                end
            end
        end
    end
end)
local csgo_weapons = require "gamesense/csgo_weapons"

-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_exec, client_set_event_callback, client_unset_event_callback, client_userid_to_entindex, entity_get_local_player, entity_get_prop, ui_get, ui_set, ui_set_visible =
      client.exec, client.set_event_callback, client.unset_event_callback, client.userid_to_entindex, entity.get_local_player, entity.get_prop, ui.get, ui.set, ui.set_visible

--autobuy v2
local primary_weapons = {
    "-", 
    "AWP", 
    "SCAR20/G3SG1", 
    "Scout", 
    "M4/AK47", 
    "Famas/Galil", 
    "Aug/SG553", 
    "M249",
    "Negev",
    "Mag7/SawedOff", 
    "Nova", 
    "XM1014", 
    "MP9/Mac10", 
    "UMP45", 
    "PPBizon", 
    "MP7"
}

local secondary_weapons = {
    "-", 
    "CZ75/Tec9/FiveSeven", 
    "P250", 
    "Deagle/Revolver", 
    "Dualies"
}

local grenades = {
    "HE Grenade", 
    "Molotov", 
    "Smoke", 
    "Flash", 
    "Flash", 
    "Decoy", 
    "Decoy"
}

local utilities = {
    "Armor", 
    "Helmet", 
    "Zeus", 
    "Defuser"
}

local prices = {
	["AWP"] = csgo_weapons["weapon_awp"].in_game_price,
	["SCAR20/G3SG1"] = csgo_weapons["weapon_scar20"].in_game_price,
	["Scout"] = csgo_weapons["weapon_ssg08"].in_game_price,
	["M4/AK47"] = csgo_weapons["weapon_m4a1"].in_game_price,
	["Famas/Galil"] = csgo_weapons["weapon_famas"].in_game_price,
	["Aug/SG553"] = csgo_weapons["weapon_aug"].in_game_price,
    ["M249"] = csgo_weapons["weapon_m249"].in_game_price,
    ["Negev"] = csgo_weapons["weapon_negev"].in_game_price,
	["Mag7/SawedOff"] = csgo_weapons["weapon_mag7"].in_game_price,
	["Nova"] = csgo_weapons["weapon_nova"].in_game_price,
	["XM1014"] = csgo_weapons["weapon_xm1014"].in_game_price,
	["MP9/Mac10"] = csgo_weapons["weapon_mp9"].in_game_price,
	["UMP45"] = csgo_weapons["weapon_ump45"].in_game_price,
	["PPBizon"] = csgo_weapons["weapon_bizon"].in_game_price,
	["MP7"] = csgo_weapons["weapon_mp7"].in_game_price,
	["CZ75/Tec9/FiveSeven"] = csgo_weapons["weapon_tec9"].in_game_price,
	["P250"] = csgo_weapons["weapon_p250"].in_game_price,
	["Deagle/Revolver"] = csgo_weapons["weapon_deagle"].in_game_price,
	["Dualies"] = csgo_weapons["weapon_elite"].in_game_price,
	["HE Grenade"] = csgo_weapons["weapon_hegrenade"].in_game_price,
	["Molotov"] = csgo_weapons["weapon_molotov"].in_game_price,
	["Smoke"] = csgo_weapons["weapon_smokegrenade"].in_game_price,
	["Flash"] = csgo_weapons["weapon_flashbang"].in_game_price,
	["Decoy"] = csgo_weapons["weapon_decoy"].in_game_price,
	["Armor"] = csgo_weapons["item_kevlar"].in_game_price,
	["Helmet"] = csgo_weapons["item_assaultsuit"].in_game_price,
	["Zeus"] = csgo_weapons["weapon_taser"].in_game_price,
    ["Defuser"] = csgo_weapons["item_cutters"].in_game_price,
    ["-"] = 0
}

local commands = {
	["AWP"] = "buy awp",
	["SCAR20/G3SG1"] = "buy scar20",
	["Scout"] = "buy ssg08",
	["M4/AK47"] = "buy m4a1",
	["Famas/Galil"] = "buy famas",
	["Aug/SG553"] = "buy aug",
    ["M249"] = "buy m249",
    ["Negev"] = "buy negev",
	["Mag7/SawedOff"] = "buy mag7",
	["Nova"] = "buy nova",
	["XM1014"] = "buy xm1014",
	["MP9/Mac10"] = "buy mp9",
	["UMP45"] = "buy ump45",
	["PPBizon"] = "buy bizon",
	["MP7"] = "buy mp7",
	["CZ75/Tec9/FiveSeven"] = "buy tec9",
	["P250"] = "buy p250",
	["Deagle/Revolver"] = "buy deagle",
	["Dualies"] = "buy elite",
	["HE Grenade"] = "buy hegrenade",
	["Molotov"] = "buy molotov",
	["Smoke"] = "buy smokegrenade",
	["Flash"] = "buy flashbang",
	["Decoy"] = "buy decoy",
	["Armor"] = "buy vest",
	["Helmet"] = "buy vesthelm",
	["Zeus"] = "buy taser 34",
    ["Defuser"] = "buy defuser",
    ["-"] = ""
}

--new menu
local menu = {
    enabled = ui.new_checkbox("MISC", "Miscellaneous", "Autobuy (v2)"),
    hide = ui.new_checkbox("MISC", "Miscellaneous", "Hide autobuy"),
    primary = ui.new_combobox("MISC", "Miscellaneous", "Primary", primary_weapons),
    secondary = ui.new_combobox("MISC", "Miscellaneous", "Secondary", secondary_weapons),
    grenades = ui.new_multiselect("MISC", "Miscellaneous", "Grenades", grenades),
    utilities = ui.new_multiselect("MISC", "Miscellaneous", "Utilities", utilities),
    cost_based = ui.new_checkbox("MISC", "Miscellaneous", "Cost based"),
    threshold = ui.new_slider("MISC", "Miscellaneous", "Balance override", 0, 16000, 0, true, "$", 1, {[0] = "Auto"}),
    primary_2 = ui.new_combobox("MISC", "Miscellaneous", "Backup primary", primary_weapons),
    secondary_2 = ui.new_combobox("MISC", "Miscellaneous", "Backup secondary", secondary_weapons),
    grenades_2 = ui.new_multiselect("MISC", "Miscellaneous", "Backup grenades", grenades),
    utilities_2 = ui.new_multiselect("MISC", "Miscellaneous", "Backup utilities", utilities),
}

--weapon prices
local weapon_cost = 0

local function calculate_weapon_prices()
    weapon_cost = 0
    --utilities
	local utility_purchase = ui_get(menu.utilities)
	for i = 1, #utility_purchase do
        local n = utility_purchase[i]

        weapon_cost = weapon_cost + prices[n]
    end

    --secondary
    weapon_cost = weapon_cost + prices[ui_get(menu.secondary)]

    --primary
    weapon_cost = weapon_cost + prices[ui_get(menu.primary)]
    
    --grenades
    local grenade_purchase = ui_get(menu.grenades)
    for i = 1, #grenade_purchase do
        local n = grenade_purchase[i]

        weapon_cost = weapon_cost + prices[n]
    end
end

-- split into two funcs because otherwise the storing gets fked up
local logged_grenades_full = {}
local logged_grenades_eco = {}

local function grenade_limit_callback_full()
	local total_nades = ui_get(menu.grenades)

	if #total_nades > 4 then
		ui_set(menu.grenades, logged_grenades)
		return
	end

    logged_grenades_full = total_nades
    prepare_cmd()
end

local function grenade_limit_callback_eco()
	local total_nades = ui_get(menu.grenades_2)

	if #total_nades > 4 then
		ui_set(menu.grenades_2, logged_grenades)
		return
	end

    logged_grenades_eco = total_nades
    prepare_cmd()
end

--cmd handler
local cmd_full = ""
local cmd_eco = ""

local function prepare_cmd()
    --reset vars
    cmd_full = ""
    cmd_eco = ""

    --full buy cmd
    --secondary
    cmd_full = cmd_full .. commands[ui_get(menu.secondary)] .. ";"
    --utilities
    local utility_purchase = ui_get(menu.utilities)
    for i = 1, #utility_purchase do
        cmd_full = cmd_full .. commands[utility_purchase[i]] .. ";"
    end
    --primary
    cmd_full = cmd_full .. commands[ui_get(menu.primary)] .. ";"
    --grenades
    local grenade_purchase = ui_get(menu.grenades)
    for i = 1, #grenade_purchase do
        cmd_full = cmd_full .. commands[grenade_purchase[i]] .. ";"
    end

    --eco buy cmd
    --secondary
    cmd_eco = cmd_eco .. commands[ui_get(menu.secondary_2)] .. ";"
    --utilities
    local utility_purchase = ui_get(menu.utilities_2)
    for i = 1, #utility_purchase do
        cmd_eco = cmd_eco .. commands[utility_purchase[i]] .. ";"
    end
    --primary
    local prim = commands[ui_get(menu.primary_2)]
    cmd_eco = cmd_eco .. commands[ui_get(menu.primary_2)] .. ";"
    --grenades
    local grenade_purchase = ui_get(menu.grenades_2)
    for i = 1, #grenade_purchase do
        cmd_eco = cmd_eco .. commands[grenade_purchase[i]] .. ";"
    end

    calculate_weapon_prices()
end

local round_started = false

--callbacks
local function on_net_update_end(e)
    if round_started then
        local money = entity_get_prop(entity_get_local_player(), "m_iAccount")

        local threshold = ui_get(menu.threshold)

        local price_threshold = 0

        if ui_get(menu.cost_based) and (threshold == 0) then
            price_threshold = weapon_cost
        elseif (threshold ~= 0) then
            price_threshold = ui_get(menu.threshold)
        end

        if money < price_threshold then
            client_exec(cmd_eco)
        else
            client_exec(cmd_full)
        end
        
        round_started = false
    end
end

local function on_round_prestart(e)
    round_started = true
end

local function on_player_spawn(e)
    if not round_started and not e.inrestart and client_userid_to_entindex(e.userid) == entity_get_local_player() then 
        round_started = true
    end
end

--visibility
local function handle_vis()
    local state = ui_get(menu.enabled)
    local state2 = (not ui_get(menu.hide))
    local state3 = ui_get(menu.cost_based)

    ui_set_visible(menu.hide, state)

    if state and state2 then
        ui_set_visible(menu.primary, state)
        ui_set_visible(menu.secondary, state)
        ui_set_visible(menu.grenades, state)
        ui_set_visible(menu.utilities, state)
        ui_set_visible(menu.cost_based, state)
        ui_set_visible(menu.threshold, state3)
        ui_set_visible(menu.primary_2, state3)
        ui_set_visible(menu.secondary_2, state3)
        ui_set_visible(menu.grenades_2, state3)
        ui_set_visible(menu.utilities_2, state3)
    elseif not state2 then
        ui_set_visible(menu.primary, state2)
        ui_set_visible(menu.secondary, state2)
        ui_set_visible(menu.grenades, state2)
        ui_set_visible(menu.utilities, state2)
        ui_set_visible(menu.cost_based, state2)
        ui_set_visible(menu.threshold, state2)
        ui_set_visible(menu.primary_2, state2)
        ui_set_visible(menu.secondary_2, state2)
        ui_set_visible(menu.grenades_2, state2)
        ui_set_visible(menu.utilities_2, state2)
    else
        ui_set_visible(menu.primary, state)
        ui_set_visible(menu.secondary, state)
        ui_set_visible(menu.grenades, state)
        ui_set_visible(menu.utilities, state)
        ui_set_visible(menu.cost_based, state)
        ui_set_visible(menu.threshold, state)
        ui_set_visible(menu.primary_2, state)
        ui_set_visible(menu.secondary_2, state)
        ui_set_visible(menu.grenades_2, state)
        ui_set_visible(menu.utilities_2, state)
    end

end

local function on_script_toggle()
    local state = ui.get(menu.enabled)
    local update_callback = state and client_set_event_callback or client_unset_event_callback
    update_callback("net_update_end", on_net_update_end)
    update_callback("round_prestart", on_round_prestart)
    update_callback("player_spawn", on_player_spawn)

    handle_vis()
end

--init
do 
    ui.set_callback(menu.enabled, on_script_toggle)
    on_script_toggle()
    ui.set_callback(menu.grenades, grenade_limit_callback_full)
    ui.set_callback(menu.grenades_2, grenade_limit_callback_eco)

    ui.set_callback(menu.primary, prepare_cmd)
    ui.set_callback(menu.secondary, prepare_cmd)
    ui.set_callback(menu.grenades, prepare_cmd)
    ui.set_callback(menu.utilities, prepare_cmd)

    ui.set_callback(menu.primary_2, prepare_cmd)
    ui.set_callback(menu.secondary_2, prepare_cmd)
    ui.set_callback(menu.grenades_2, prepare_cmd)
    ui.set_callback(menu.utilities_2, prepare_cmd)

    prepare_cmd()

    ui.set_callback(menu.hide, handle_vis)
    ui.set_callback(menu.cost_based, handle_vis)
    handle_vis()
end
-- Cache common functions
local bit_band, client_set_event_callback, entity_get_bounding_box, entity_get_local_player, entity_get_players, entity_get_prop, entity_hitbox_position, entity_is_alive, math_ceil, math_pow, math_sqrt, renderer_line, renderer_text, renderer_world_to_screen, ui_get, ui_new_checkbox = bit.band, client.set_event_callback, entity.get_bounding_box, entity.get_local_player, entity.get_players, entity.get_prop, entity.hitbox_position, entity.is_alive, math.ceil, math.pow, math.sqrt, renderer.line, renderer.text, renderer.world_to_screen, ui.get, ui.new_checkbox

local revolver_helper = ui_new_checkbox("lua", "a", "Enable revolver helper")

local function Vector(x,y,z) 
	return {x=x or 0,y=y or 0,z=z or 0} 
end

local function Distance(from_x,from_y,from_z,to_x,to_y,to_z)  
  return math_ceil(math_sqrt(math_pow(from_x - to_x, 2) + math_pow(from_y - to_y, 2) + math_pow(from_z - to_z, 2)))
end

local function check_revolver_distance(player,victim)
	if player == nil then return end
	if victim == nil then return end
	
	local weap = entity_get_prop(entity_get_prop(player, "m_hActiveWeapon"), "m_iItemDefinitionIndex")
	if weap == nil then return end
	local vnum = bit_band(weap, 0xFFFF)
	local player_origin = Vector(entity_get_prop(player, "m_vecOrigin"))
	local victim_origin = Vector(entity_get_prop(victim, "m_vecOrigin"))

	local units = Distance(player_origin.x, player_origin.y, player_origin.z, victim_origin.x, victim_origin.y, victim_origin.z)
	local no_kevlar = entity_get_prop(victim, "m_ArmorValue") == 0	

	if not (vnum == 64 and no_kevlar) then
		return 0
	end
	
	if units < 585 and units > 511 then
		return 1
	elseif units < 511 then
		return 2
	else
		return 0
	end
end


local function draw_status(player, status)
	local x1, y1, x2, y2, alpha_multiplier = entity_get_bounding_box(player)

	if (x1 == nil or alpha_multiplier == 0) then
		return
	end
	
	local x_center = x1 / 2 + x2 / 2
	local y_additional = name == "" and -8 or 0

	if status == 1 then
		renderer_text(x_center, y1 - 20 + y_additional, 255, 0, 0, 255, "cb", 0, "DMG")
	else
		renderer_text(x_center, y1 - 20 + y_additional, 50, 205, 50, 255, "cb", 0, "DMG+")
	end
end

local function paint()
	if not ui_get(revolver_helper) then return end
	local lp = entity_get_local_player()
	if lp == nil then return end
	if not entity_is_alive(lp) then return end
	
    local players = entity_get_players(true)
	if #players == nil or #players == 0 then
		return
	end
	for i = 1, #players do
		local entindex = players[i]	
		if (entindex ~= nil and entindex ~= entity_get_local_player()) then
			local line_start = Vector(entity_hitbox_position(entindex, 13))
			local line_stop = Vector(entity_hitbox_position(lp, 3))
			local x1, y1 = renderer_world_to_screen(line_start.x,line_start.y,line_start.z)
			local x2, y2 = renderer_world_to_screen(line_stop.x,line_stop.y,line_stop.z)

			local revolver = check_revolver_distance(lp,entindex)
			local enemy_revolver = check_revolver_distance(entindex,lp)
			
			if revolver ~= 0 and revolver ~= nil then
				draw_status(entindex,revolver)
			end
			
			if enemy_revolver ~= 0 and enemy_revolver ~= nil then
				if x1 ~= nil and x2 ~= nil and y1 ~= nil and y2 ~= nil then
					renderer_line(x1, y1, x2, y2, 255,0,0,255)
				end
			end
		end
	end
	
end

local function setup_callback(i)
    if ui.get(i) then
        client.set_event_callback("paint", paint)
    else
        client.unset_event_callback("paint", paint)
    end
end

ui.set_callback(revolver_helper, setup_callback)
local onionThirdperson = {
    collisionControl = ui.new_checkbox("Visuals", "Effects", "Disable collision"),
    distanceControl = ui.new_slider("Visuals", "Effects", "Thirdperson Cam Dist", 1, 180, 140)
}

local function thirdpersonValues()
    if (ui.get(onionThirdperson.collisionControl)) then
        cvar.cam_collision:set_int(1)
    else
        cvar.cam_collision:set_int(0)
    end

    cvar.c_mindistance:set_int(ui.get(onionThirdperson.distanceControl))
    cvar.c_maxdistance:set_int(ui.get(onionThirdperson.distanceControl))
end

ui.set_callback(onionThirdperson.collisionControl, thirdpersonValues)
ui.set_callback(onionThirdperson.distanceControl, thirdpersonValues)
thirdpersonValues()
--local variables for API functions. Generated using https://github.com/sapphyrus/gamesense-lua/blob/master/generate_api.lua
local client_latency, client_set_clan_tag, client_log, client_timestamp, client_userid_to_entindex, client_trace_line, client_set_event_callback, client_screen_size, client_trace_bullet, client_color_log, client_system_time, client_delay_call, client_visible, client_exec, client_eye_position, client_set_cvar, client_scale_damage, client_draw_hitboxes, client_get_cvar, client_camera_angles, client_draw_debug_text, client_random_int, client_random_float = client.latency, client.set_clan_tag, client.log, client.timestamp, client.userid_to_entindex, client.trace_line, client.set_event_callback, client.screen_size, client.trace_bullet, client.color_log, client.system_time, client.delay_call, client.visible, client.exec, client.eye_position, client.set_cvar, client.scale_damage, client.draw_hitboxes, client.get_cvar, client.camera_angles, client.draw_debug_text, client.random_int, client.random_float
local entity_get_player_resource, entity_get_local_player, entity_is_enemy, entity_get_bounding_box, entity_is_dormant, entity_get_steam64, entity_get_player_name, entity_hitbox_position, entity_get_game_rules, entity_get_all, entity_set_prop, entity_is_alive, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_get_classname = entity.get_player_resource, entity.get_local_player, entity.is_enemy, entity.get_bounding_box, entity.is_dormant, entity.get_steam64, entity.get_player_name, entity.hitbox_position, entity.get_game_rules, entity.get_all, entity.set_prop, entity.is_alive, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.get_classname
local globals_realtime, globals_absoluteframetime, globals_tickcount, globals_lastoutgoingcommand, globals_curtime, globals_mapname, globals_tickinterval, globals_framecount, globals_frametime, globals_maxplayers = globals.realtime, globals.absoluteframetime, globals.tickcount, globals.lastoutgoingcommand, globals.curtime, globals.mapname, globals.tickinterval, globals.framecount, globals.frametime, globals.maxplayers
local ui_new_slider, ui_new_combobox, ui_reference, ui_is_menu_open, ui_set_visible, ui_new_textbox, ui_new_color_picker, ui_set_callback, ui_set, ui_new_checkbox, ui_new_hotkey, ui_new_button, ui_new_multiselect, ui_get = ui.new_slider, ui.new_combobox, ui.reference, ui.is_menu_open, ui.set_visible, ui.new_textbox, ui.new_color_picker, ui.set_callback, ui.set, ui.new_checkbox, ui.new_hotkey, ui.new_button, ui.new_multiselect, ui.get
local renderer_circle_outline, renderer_rectangle, renderer_gradient, renderer_circle, renderer_text, renderer_line, renderer_measure_text, renderer_indicator, renderer_world_to_screen = renderer.circle_outline, renderer.rectangle, renderer.gradient, renderer.circle, renderer.text, renderer.line, renderer.measure_text, renderer.indicator, renderer.world_to_screen
local math_ceil, math_tan, math_cos, math_sinh, math_pi, math_max, math_atan2, math_floor, math_sqrt, math_deg, math_atan, math_fmod, math_acos, math_pow, math_abs, math_min, math_sin, math_log, math_exp, math_cosh, math_asin, math_rad = math.ceil, math.tan, math.cos, math.sinh, math.pi, math.max, math.atan2, math.floor, math.sqrt, math.deg, math.atan, math.fmod, math.acos, math.pow, math.abs, math.min, math.sin, math.log, math.exp, math.cosh, math.asin, math.rad
local table_sort, table_remove, table_concat, table_insert = table.sort, table.remove, table.concat, table.insert
local string_find, string_format, string_gsub, string_len, string_gmatch, string_match, string_reverse, string_upper, string_lower, string_sub = string.find, string.format, string.gsub, string.len, string.gmatch, string.match, string.reverse, string.upper, string.lower, string.sub
local ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error = ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error
--end of local variables

local function set_aspect_ratio(aspect_ratio_multiplier)
	local screen_width, screen_height = client_screen_size()
	local aspectratio_value = (screen_width*aspect_ratio_multiplier)/screen_height

	if aspect_ratio_multiplier == 1 then
		aspectratio_value = 0
	end
	client_set_cvar("r_aspectratio", tonumber(aspectratio_value))
end

local function noop()
end

--greatest common divisor
local function gcd(m, n)
	while m ~= 0 do
		m, n = math_fmod(n, m), m
	end

	return n
end

local screen_width, screen_height, aspect_ratio_reference

local function on_aspect_ratio_changed()
	local aspect_ratio = ui_get(aspect_ratio_reference)*0.01
	aspect_ratio = 2 - aspect_ratio
	set_aspect_ratio(aspect_ratio)
end

local multiplier = 0.01
local steps = 200

local function setup(screen_width_temp, screen_height_temp)
	screen_width, screen_height = screen_width_temp, screen_height_temp
	local aspect_ratio_table = {}

	for i=1, steps do
		local i2=(steps-i)*multiplier
		local divisor = gcd(screen_width*i2, screen_height)
		if screen_width*i2/divisor < 100 or i2 == 1 then
			aspect_ratio_table[i] = screen_width*i2/divisor .. ":" .. screen_height/divisor
		end
	end

	if aspect_ratio_reference ~= nil then
		ui_set_visible(aspect_ratio_reference, false)
		ui_set_callback(aspect_ratio_reference, noop)
	end

	aspect_ratio_reference = ui.new_slider("VISUALS", "Effects", "Force aspect ratio", 0, steps-1, steps/2, true, "%", 1, aspect_ratio_table)
	ui_set_callback(aspect_ratio_reference, on_aspect_ratio_changed)
end
setup(client_screen_size())

local function on_paint(ctx)
	local screen_width_temp, screen_height_temp = client_screen_size()
	if screen_width_temp ~= screen_width or screen_height_temp ~= screen_height then
		setup(screen_width_temp, screen_height_temp)
	end
end
client.set_event_callback("paint", on_paint)
