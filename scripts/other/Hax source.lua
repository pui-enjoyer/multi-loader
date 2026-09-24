
 bit_band, bit_lshift, client_color_log, client_create_interface, client_delay_call, client_find_signature, client_key_state, client_reload_active_scripts, client_screen_size, client_set_event_callback, client_system_time, client_timestamp, client_unset_event_callback, database_read, database_write, entity_get_classname, entity_get_local_player, entity_get_origin, entity_get_player_name, entity_get_prop, entity_get_steam64, entity_is_alive, globals_framecount, globals_realtime, math_ceil, math_floor, math_max, math_min, panorama_loadstring, renderer_gradient, renderer_line, renderer_rectangle, table_concat, table_insert, table_remove, table_sort, ui_get, ui_is_menu_open, ui_mouse_position, ui_new_checkbox, ui_new_color_picker, ui_new_combobox, ui_new_slider, ui_set, ui_set_visible, setmetatable, pairs, error, globals_absoluteframetime, globals_curtime, globals_frametime, globals_maxplayers, globals_tickcount, globals_tickinterval, math_abs, type, pcall, renderer_circle_outline, renderer_load_rgba, renderer_measure_text, renderer_text, renderer_texture, tostring, ui_name, ui_new_button, ui_new_hotkey, ui_new_label, ui_new_listbox, ui_new_textbox, ui_reference, ui_set_callback, ui_update, unpack, tonumber = bit.band, bit.lshift, client.color_log, client.create_interface, client.delay_call, client.find_signature, client.key_state, client.reload_active_scripts, client.screen_size, client.set_event_callback, client.system_time, client.timestamp, client.unset_event_callback, database.read, database.write, entity.get_classname, entity.get_local_player, entity.get_origin, entity.get_player_name, entity.get_prop, entity.get_steam64, entity.is_alive, globals.framecount, globals.realtime, math.ceil, math.floor, math.max, math.min, panorama.loadstring, renderer.gradient, renderer.line, renderer.rectangle, table.concat, table.insert, table.remove, table.sort, ui.get, ui.is_menu_open, ui.mouse_position, ui.new_checkbox, ui.new_color_picker, ui.new_combobox, ui.new_slider, ui.set, ui.set_visible, setmetatable, pairs, error, globals.absoluteframetime, globals.curtime, globals.frametime, globals.maxplayers, globals.tickcount, globals.tickinterval, math.abs, type, pcall, renderer.circle_outline, renderer.load_rgba, renderer.measure_text, renderer.text, renderer.texture, tostring, ui.name, ui.new_button, ui.new_hotkey, ui.new_label, ui.new_listbox, ui.new_textbox, ui.reference, ui.set_callback, ui.update, unpack, tonumber

-- Переменная для хранения текущей вкладки
current_tab = ui.new_combobox("LUA", "B", "Select Tab", {"Home", "Rage", "Misc", "Visuals","Servers"})
-- Элементы для вкладки Visuals
 visuals_checkbox = ui.new_checkbox("LUA", "B", "Enable Visuals features")
-- ? libraries
 vector = require 'vector';
-- Элементы для вкладки HitMarker
HitMarker_checkbox = ui.new_checkbox("LUA", "B", "Enable HitMarker")
-- Переменная для хранения текущей вкладки HitMarker
HitMarker_tab = ui.new_combobox("LUA", "B", "Select HitMarker", {"Сross", "Outline Сross"})
local shared_esps = ui.reference("visuals", "other esp", "shared esp")
ui.set(shared_esps, false)
ui.set_visible(shared_esps, false)
xuisassa = ui.reference("Visuals", "Player ESP", "Teammates")
 pizdecSS = {
    ["•  [hvhserver.xyz] roll fix"] = "62.122.214.55:27015",
    ["•  HackHaven HvH"] = "46.174.55.54:27015",
    ["•  eXpidors.Ru"] = "46.174.51.137:7777",
    ["•  eXpidors.Ru - Scout"] = "62.122.215.105:6666",
    ["•  sippin' on wok mm hvh"] = "46.174.55.52:1488",
    ["•  War3ft Project"] = "194.93.2.30:1337",
    ["•  SEREGA HVH"] = "46.174.49.147:1488",
    ["•  SharkProject | MM"] = "37.230.228.148:27015",
    ["•  WhiteProject"] = "46.174.49.161:1337",
    ["•  LivixProject HVH"] = "185.9.145.159:28423",
    ["•  GENESIS PROJECT"] = "45.136.204.249:27015",

}

 clipboard = require("gamesense/clipboard")
 servs = {}
for k, v in pairs(pizdecSS) do
    table.insert(servs, k)
end
-- Элементы для вкладки Servers
zalupenko_enable = ui.new_checkbox("LUA", "B", "Enable Servers")
zalupenko = ui.new_listbox("lua", "b", "Connects", servs )

Connects = ui.new_button("lua", "b", "\r Connect", function()
    local index = ui.get(zalupenko)
    local i = 0

    for k, v in pairs(pizdecSS) do
        if index == i then
            servers = v
        end
        i = i + 1
    end
    client.exec("connect " .. servers)
end)
Copyss = ui.new_button("lua", "b", "\r Copy ip-address", function()
    local index = ui.get(zalupenko)
    local i = 0

    for k, v in pairs(pizdecSS) do
        if index == i then
            servers = v
        end
        i = i + 1
    end
	clipboard.set(servers)
end)
RetrySS = ui.new_button("lua", "b", "\r Rejoin (Retry)", function()
	client.exec("disconnect; retry")
end)


local queue = {}

local function aim_fire(c)
	queue[globals.tickcount()] = {c.x,c.y,c.z, globals.curtime() + 2}
end

local function paint(c)
	for tick, data in pairs(queue) do
        if globals.curtime() <= data[4] then
            local x1, y1 = renderer.world_to_screen(data[1], data[2], data[3])
            if x1 ~= nil and y1 ~= nil then
                if ui.get(HitMarker_checkbox) then
                    if ui.get(HitMarker_tab) == "Сross" then
                   --renderer.circle_outline(x1,y1,255,255,255,255,5,0,1.0,1)
			        renderer.line(x1 - 6,y1,x1 + 6,y1,255,255,255,255,5,0,1.0,1)
		        	renderer.line(x1,y1 - 6,x1,y1 + 6 ,255,255,255,255,5,0,1.0,1)
                    end
                    if ui.get(HitMarker_tab) == "Outline Сross" then
                    renderer.circle_outline(x1,y1,255,255,255,255,5,0,1.0,1)
                    renderer.line(x1 - 6,y1,x1 + 6,y1,255,255,255,255,5,0,1.0,1)
                    renderer.line(x1,y1 - 6,x1,y1 + 6 ,255,255,255,255,5,0,1.0,1)
                    end
              end
            end
        end
    end
end

client.set_event_callback("aim_fire",aim_fire)
client.set_event_callback("paint",paint)

client.set_event_callback("round_prestart", function()
    queue = {}
end)

-- ? defines
 bit_band, bit_rshift = bit.band, bit.rshift;
 math_floor = math.floor;
 f = string.format;
 ui_set_callback, ui_new_checkbox, ui_new_slider, ui.new_label, ui_new_color_picker, ui_get, ui_set_visible, ui_set_callback = ui.set_callback, ui.new_checkbox, ui.new_slider, ui.new_label, ui.new_color_picker, ui.get, ui.set_visible, ui.set_callback;
 entity_get_all, entity_get_prop, entity_set_prop, entity_get_local_player = entity.get_all, entity.get_prop, entity.set_prop, entity.get_local_player;
 client_userid_to_entindex, client_set_event_callback = client.userid_to_entindex, client.set_event_callback;
 globals_tickinterval, globals_frametime = globals.tickinterval, globals.frametime;

local int32_to_rgb = function(int32)
  if not int32 then
    return
  end

   limit = 0xff;

   r = bit_band(bit_rshift(int32, 16), limit);
   g = bit_band(bit_rshift(int32, 8), limit);
   b = bit_band(int32, limit);

  return r, g, b
end

local rgb_to_int32 = function(r, g, b)
  return r * (256 * 256) + g * 256 + b;
end

local int = function(x)
  return math_floor(x + 0.5)
end

local math_clamp = function(x, min, max)
  if min > max then
    min, max = max, min;
  end

  if min > x then
    return min
  end

  if x > max then
    return max
  end

  return x
end

local math_lerp = function(a, b, percent)
  return a + (b - a) * percent
end

 menu = {};
 cascade = {};
 backup = nil;

cascade.get = function()
  return entity_get_all 'CCascadeLight' [ 1 ];
end

cascade.get_options = function(ent)
  if not ent then
    return {
      direction = {},
    }
  end

  return {
    direction = vector(entity_get_prop(ent, 'm_envLightShadowDirection')),
    distance = entity_get_prop(ent, 'm_flMaxShadowDist'),
    color = entity_get_prop(ent, 'm_LightColor')
  }
end

 available = cascade.get_options(cascade.get());
 shadow_color = {int32_to_rgb(available.color)} or {164, 211, 251};

menu.set_callback = function(item, callback, force)
  ui_set_callback(item, callback);

  if not force then
    return
  end

  callback(item);
end

menu.master = ui_new_checkbox('LUA', 'b', 'Cascade light');
menu.lerp = ui_new_checkbox('LUA', 'b', 'Allow linear-interpolation', true);
menu.x = ui_new_slider('LUA', 'b', 'X direction', -180, 180, available.direction.x or 2, true, '°');
menu.y = ui_new_slider('LUA', 'b', 'Y direction', -180, 180, available.direction.y or 0, true, '°');
menu.z = ui_new_slider('LUA', 'b', 'Z direction', -180, 0, available.direction.z or 0, true, '°');
menu.distance = ui_new_slider('LUA', 'b', 'Light distance', 0, 1200, available.distance or 400, true, 'ft');
menu.enable_color = ui_new_checkbox('LUA', 'b', 'Enable color modulation');
menu.color_picker = ui_new_color_picker('LUA', 'b', 'Color modulating', unpack(shadow_color));

cascade.set = function(list)
   ent = cascade.get();

  if not ent then
    return
  end

  list = list or {};
  list.direction = list.direction or vector(ui_get(menu.x), ui_get(menu.y), ui_get(menu.z));
  list.distance = list.distance or ui_get(menu.distance);

   options = cascade.get_options(ent);

  if list.lerp then
     frametime = globals_frametime();
     animtime = math_clamp(frametime * 175 * 0.095, 0, 1);

    list.direction = options.direction:lerp(list.direction, animtime)
    list.distance = math_lerp(options.distance, list.distance, animtime);
  end

  entity_set_prop(ent, 'm_envLightShadowDirection', list.direction.x, list.direction.y, list.direction.z);
  entity_set_prop(ent, 'm_flMaxShadowDist', list.distance);

  if not list.color then
    return
  end

  entity_set_prop(ent, 'm_LightColor', list.color);
end

cascade.backup = function()
  if backup ~= nil then
    return
  end

  local ent = cascade.get();

  if not ent then
    return
  end

  backup = cascade.get_options(ent);

  if not ui_get(menu.enable_color) then
    backup.color = nil;
  end
end

cascade.restore = function()
  if backup == nil then
    return
  end

  cascade.set(backup);
  backup = nil;
end

cascade.pre_render = function()
  if not ui_get(menu.master) then
    return
  end

  cascade.backup();
  cascade.set {
    lerp = ui_get(menu.lerp),
    color = ui_get(menu.enable_color) and rgb_to_int32(ui_get(menu.color_picker))
  };
end

cascade.player_connect_full = function(e)
  local lp = entity_get_local_player();

  if client_userid_to_entindex(e.userid) ~= lp then
    return
  end

  cascade.restore();
end
local function update_fog_visibilitys()
    local state = ui_get(menu.master);

    for k, v in ipairs {'master'} do
        ui_set_visible(menu[ v ],  ui.get(current_tab) == "Visuals" and ui.get(visuals_checkbox));
      end

    for k, v in ipairs {'lerp', 'x', 'y', 'z', 'distance', 'enable_color', 'color_picker'} do
      ui_set_visible(menu[ v ], state  and ui.get(current_tab) == "Visuals" and ui.get(visuals_checkbox));
    end

    if not state then
      cascade.restore();
    end

  end

menu.set_callback(menu.enable_color, function(self)
  if not backup then
    return
  end

  local state = ui_get(self);

  if state then
    return
  end

  cascade.set {
    color = backup.color
  };
end);

client_set_event_callback('pre_render', cascade.pre_render);
client_set_event_callback('shutdown', cascade.restore);
client_set_event_callback('player_connect_full', cascade.player_connect_full);
client_set_event_callback('level_init', cascade.restore);





 L_1_ = require("ffi")
 L_2_ = entity
 L_3_ = ui
 L_4_ = globals
 L_5_ = bit
 L_6_ = 14
 L_7_ = 100
 L_8_ = {
	"models/props/de_mirage/towertop_d/towertop_d",
	"models/props/de_dust/palace_bigdome",
	"models/props_lighting/",
	"decals/",
	"particle/",
	"de_nuke/nuke_beam_"
}
 L_9_ = {
	"models/props/de_dust/hr_dust/dust_skybox/",
	"models/props/de_inferno/hr_i/inferno_skybox",
	"models/props/de_nuke/hr_nuke/nuke_skydome_001",
	"models/props/cs_office/clouds",
	"skybox/"
}
-- Элементы для вкладки Fog
 L_10_ = L_3_.reference("VISUALS", "Effects", "Remove fog")
 L_11_ = L_3_.reference("VISUALS", "Colored models", "Props")
 L_12_ = L_3_.new_checkbox("lua", "b", "Override fog")
 L_13_ = L_3_.new_color_picker("lua", "b", "Override fog color", 235, 225, 225, 105)
 L_14_ = L_3_.new_slider("lua", "b", "\nFog start color", -5000 / L_7_, 15000 / L_7_, 0 / L_7_, true, "", L_7_)
 L_15_ = L_3_.new_slider("lua", "b", "\nFog end color", -5000 / L_7_, 15000 / L_7_, 7500 / L_7_, true, "", L_7_)
 L_16_ = L_3_.new_checkbox("lua", "b", "Skybox fog")



-- Fog


local L_17_ = vtable_bind("client.dll", "VClientEntityList003", 3, "uintptr_t(__thiscall*)(void*, int)")

cvar.r_disable_distance_fade_on_big_props:set_raw_int(1)
cvar.r_disable_distance_fade_on_big_props_thresh:set_raw_float(500)

 L_18_ = L_1_.cast("intptr_t**", L_1_.cast("char*", client.find_signature("engine.dll", "\xBE\xCC\xCC\xCC̋\x0E\x85\xC9t\v\x8B\x01\xFFP4")) + 1)[0]
local L_19_
 L_20_ = 1
 L_21_ = L_1_.new("uint8_t[4]")
 L_22_ = L_1_.cast("uint32_t*", L_21_)

local function L_23_func(L_33_arg0, L_34_arg1, L_35_arg2, L_36_arg3)
	L_21_[0] = L_33_arg0
	L_21_[1] = L_34_arg1
	L_21_[2] = L_35_arg2
	L_21_[3] = L_36_arg3

	return L_22_[0]
end

local function L_24_func(L_37_arg0, L_38_arg1, L_39_arg2)
	return L_5_.bor(L_37_arg0, L_5_.lshift(L_38_arg1, 8), L_5_.lshift(L_39_arg2, 16))
end

local L_25_ = {}

local function L_26_func(L_40_arg0, L_41_arg1, ...)
	L_25_[L_40_arg0][L_41_arg1] = {
		L_2_.get_prop(L_40_arg0, L_41_arg1)
	}

	L_2_.set_prop(L_40_arg0, L_41_arg1, ...)
end

local function L_27_func()
	for L_42_forvar0, L_43_forvar1 in pairs(L_25_) do
		for L_44_forvar0, L_45_forvar1 in pairs(L_43_forvar1) do
			L_2_.set_prop(L_42_forvar0, L_44_forvar0, unpack(L_45_forvar1))
		end
	end

	table.clear(L_25_)
end

local function L_28_func(L_46_arg0)
	local L_47_ = not L_46_arg0 and L_3_.get(L_12_)

	for L_50_forvar0, L_51_forvar1 in ipairs(L_8_) do
		for L_52_forvar0, L_53_forvar1 in ipairs(materialsystem.find_materials(L_51_forvar1) or {}) do
			L_53_forvar1:set_material_var_flag(L_6_, not L_47_)

			local L_54_ = L_53_forvar1:get_shader_param("$fogfadeend")

			if L_54_ ~= nil and (L_54_ == 0 or L_54_ > 0.3) then
				L_53_forvar1:set_shader_param("$fogfadeend", 0.33)
			end

			if L_53_forvar1:get_shader_param("$fogscale") ~= nil then
				L_53_forvar1:set_shader_param("$fogscale", 1)
			end

			if L_53_forvar1:get_shader_param("$vertexfogamount") ~= nil then
				L_53_forvar1:set_shader_param("$vertexfogamount", 2)
			end
		end
	end

	local L_48_ = L_47_ and L_3_.get(L_16_)

	for L_55_forvar0, L_56_forvar1 in ipairs(L_9_) do
		for L_57_forvar0, L_58_forvar1 in ipairs(materialsystem.find_materials(L_56_forvar1) or {}) do
			L_58_forvar1:set_material_var_flag(L_6_, not L_48_)
		end
	end

	local L_49_ = L_4_.mapname() or ""

	if L_49_:find("office") then
		L_20_ = 1.75
	elseif L_49_:find("italy") then
		L_20_ = 1.3
	else
		L_20_ = 1
	end
end

local function L_29_func()
	local L_59_ = L_2_.get_local_player()

	if L_59_ == nil then
		return
	end

	local L_60_ = 1
	local L_61_, L_62_, L_63_, L_64_ = L_3_.get(L_13_)
	local L_65_ = L_24_func(L_61_, L_62_, L_63_)
	local L_66_ = L_3_.get(L_14_) * L_7_ * L_20_
	local L_67_ = L_3_.get(L_15_) * L_7_ * L_20_
	local L_68_ = L_64_ / 255
	local L_69_ = L_5_.band(math.max(0, L_2_.get_prop(L_59_, "m_PlayerFog.m_hCtrl") or 0), 65535)

	if L_69_ > 0 and L_69_ < 65535 then
		L_25_[L_69_] = {}

		L_26_func(L_69_, "m_fog.enable", L_60_)
		L_26_func(L_69_, "m_fog.dirPrimary", 0, 0, 0)
		L_26_func(L_69_, "m_fog.colorPrimary", L_65_)
		L_26_func(L_69_, "m_fog.colorSecondary", L_65_)
		L_26_func(L_69_, "m_fog.start", L_66_)
		L_26_func(L_69_, "m_fog.end", L_67_)
		L_26_func(L_69_, "m_fog.maxdensity", L_68_)
		L_26_func(L_69_, "m_fog.ZoomFogScale", 0)
		L_26_func(L_69_, "m_fog.HDRColorScale", 1)
		L_26_func(L_69_, "m_fog.blend", 0)
		L_26_func(L_69_, "m_fog.duration", 0)
	end

	L_25_[L_59_] = {}

	L_26_func(L_59_, "m_skybox3d.fog.enable", L_60_)
	L_26_func(L_59_, "m_skybox3d.fog.dirPrimary", 0, 0, 0)
	L_26_func(L_59_, "m_skybox3d.fog.colorPrimary", L_65_)
	L_26_func(L_59_, "m_skybox3d.fog.colorSecondary", L_65_)
	L_26_func(L_59_, "m_skybox3d.fog.start", L_66_)
	L_26_func(L_59_, "m_skybox3d.fog.end", L_67_)
	L_26_func(L_59_, "m_skybox3d.fog.maxdensity", L_68_)
	L_26_func(L_59_, "m_skybox3d.fog.HDRColorScale", 1)
	L_26_func(L_59_, "m_skybox3d.fog.blend", 0)

	local L_70_ = tonumber(L_18_[0])

	if L_70_ ~= L_19_ then
		L_28_func()

		L_19_ = L_70_
	end
end

local function L_30_func()
	L_27_func()

	if not L_3_.get(L_12_) then
		client.unset_event_callback("pre_render", L_29_func)
		client.unset_event_callback("post_render", L_30_func)
	end
end

local function L_31_func()
	L_28_func()
	client.delay_call(0, L_28_func)
end

local function L_32_func()
	L_28_func(true)
end

L_3_.set_callback(L_12_, function()
	local L_71_ = L_3_.get(L_12_)

	if L_71_ then
		client.set_event_callback("pre_render", L_29_func)
		client.set_event_callback("post_render", L_30_func)
		client.set_event_callback("level_init", L_31_func)
		client.set_event_callback("shutdown", L_32_func)
		L_3_.set(L_10_, false)
	else
		client.unset_event_callback("level_init", L_31_func)
		client.unset_event_callback("shutdown", L_32_func)
	end


	L_28_func()
end)
L_3_.set_callback(L_16_, function()
	L_28_func()
end)
L_3_.set_callback(L_11_, function()
	L_28_func()
end)
L_3_.set_callback(L_10_, function()
	if L_3_.get(L_10_) then
		L_3_.set(L_12_, false)
	end
end)

 js = panorama.open()
 bit = require("bit") -- Библиотека bit для работы с флагами
-- Локальные привязки API
 entity_get_local_player = entity.get_local_player
 entity_get_player_weapon = entity.get_player_weapon
 entity_get_prop = entity.get_prop
 entity_is_dormant = entity.is_dormant
 entity_is_enemy = entity.is_enemy
 entity_get_bounding_box = entity.get_bounding_box
 entity_get_origin = entity.get_origin
 entity_get_player_resource = entity.get_player_resource
 entity_is_alive = entity.is_alive
 entity_get_players = entity.get_players
 client_eye_position = client.eye_position
 client_trace_bullet = client.trace_bullet
 client_screen_size = client.screen_size
 client_userid_to_entindex = client.userid_to_entindex
 client_latency = client.latency
 client_visible = client.visible
 globals_tickcount = globals.tickcount
 globals_maxplayers = globals.maxplayers
 globals_tickinterval = globals.tickinterval
 globals_frametime = globals.frametime
 globals_curtime = globals.curtime
 renderer_indicator = renderer.indicator
 renderer_gradient = renderer.gradient
 renderer_rectangle = renderer.rectangle
 renderer_text = renderer.text
 renderer_line = renderer.line
 renderer_world_to_screen = renderer.world_to_screen
 math_floor = math.floor
 math_ceil = math.ceil
 math_fmod = math.fmod

-- Зависимости
 vector = require("vector")
 weapons = require("gamesense/csgo_weapons")






-- Элементы для вкладки Home
 home_label_welcome = ui.new_label("LUA", "B", "Welcome to \aFFB6C1FFhax.lua\aFFFFFFFF")
 home_label_version = ui.new_label("LUA", "B", "Version \aFFB6C1FF1.0\aFFFFFFFF")
 home_label_owned = ui.new_label("LUA", "B", "Created and Owned by \aFFB6C1FFBassota\aFFFFFFFF")
 home_label_owned_s = ui.new_label("LUA", "B", "Special thanks for \aFFB6C1FFRam1n\aFFFFFFFF")
 label1 = ui.new_button("LUA", "B", "Bassota \aFFB6C1FFYoutube ~", function()
    js.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@bassota-cc")
end)
local label2 = ui.new_button("LUA", "B", "Bassota \aFFB6C1FFServer ~", function()
    js.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/KtQMfrkjsH")
end)
local label3 = ui.new_button("LUA", "B", "Bassota \aFFB6C1FFFakecrime ~", function()
    js.SteamOverlayAPI.OpenExternalBrowserURL("https://fakecrime.bio/bassota")
end)

-- Изначально скрываем элементы Home
ui.set_visible(home_label_welcome, false)
ui.set_visible(home_label_version, false)
ui.set_visible(home_label_owned, false)

ui.set_visible(label1, false)
ui.set_visible(label2, false)
ui.set_visible(label3, false)

-- Элементы для вкладки Rage
local rage_checkbox = ui.new_checkbox("LUA", "B", "Enable Rage features")

-- HaxResolver элементы (в начале)
local rage_hax_resolver = ui.new_checkbox("LUA", "B", string.format("\a%02X%02X%02XFF❤︎ HaxResolver ❤︎", 255, 182, 193))
local b_2 = {}
b_2.rage = {
    predict = ui.new_checkbox("LUA", "B", string.format("\a%02X%02X%02XFFPredict Beta", 255, 182, 193)),
    pingpos = ui.new_combobox("LUA", "B", string.format("\a%02X%02X%02XFFSelect mode", 255, 182, 193), {"High Ping", "Low Ping"}),
    jittercorrectionresolver = ui.new_checkbox("LUA", "B", string.format("\a%02X%02X%02XFFResolver Correction", 255, 182, 193)),
    interesting = ui.new_checkbox("LUA", "B", string.format("\a%02X%02X%02XFF⚠︎ Experimental Mode ⚠︎", 255, 182, 193)),
}

-- Остальные элементы Rage
local rage_dormant_aimbot = ui.new_checkbox("LUA", "B", "Dormant Aimbot")
local rage_dormant_key = ui.new_hotkey("LUA", "B", "Dormant Aimbot Key", true)
local rage_dormant_mindmg = ui.new_slider("LUA", "B", "Dormant Minimum Damage", 0, 100, 10, true)
local rage_dormant_indicator = ui.new_checkbox("LUA", "B", "Dormant Indicator")
local unsafe_crage_in_air = ui.new_checkbox("LUA", "B", "Unsafe Crage in Air")

-- Hitchance Override элементы (упрощённая версия)
local feature = {
    hitchance_override = ui.new_checkbox("LUA", "B", "Hitchance override"), -- Главный чекбокс
    hit_chance_ovr = ui.new_slider("LUA", "B", "Hit chance override", 0, 100, 50, true, "%"),
    hc_ovr_key = ui.new_hotkey("LUA", "B", "Hit chance override", false)
}

-- Ссылка на Minimum Hit Chance
local hc_ref = ui.reference("RAGE", "Aimbot", "Minimum hit chance")
ui.set_visible(hc_ref, false)

-- Переменная для хранения исходного значения Minimum hit chance
local original_hc_value = ui.get(hc_ref)

-- Изначально скрываем элементы Rage
ui.set_visible(rage_hax_resolver, false)
ui.set_visible(b_2.rage.predict, false)
ui.set_visible(b_2.rage.pingpos, false)
ui.set_visible(b_2.rage.jittercorrectionresolver, false)
ui.set_visible(b_2.rage.interesting, false)
ui.set_visible(rage_dormant_aimbot, false)
ui.set_visible(rage_dormant_key, false)
ui.set_visible(rage_dormant_mindmg, false)
ui.set_visible(rage_dormant_indicator, false)
ui.set_visible(unsafe_crage_in_air, false)
ui.set_visible(feature.hitchance_override, false)
ui.set_visible(feature.hit_chance_ovr, false)
ui.set_visible(feature.hc_ovr_key, false)



-- Элементы для вкладки Visuals (Aspect Ratio)
local aspect_ratio_checkbox = ui.new_checkbox("LUA", "B", "Aspect Ratio")
local aspect_ratio_table = {}

-- Проверка доступности client.screen_size
local screen_width, screen_height
if client_screen_size then
    screen_width, screen_height = client_screen_size()
else
    print("client.screen_size is not available, using default resolution 1920x1080")
    screen_width, screen_height = 1920, 1080
end

for i = 1, 200 do
    local i2 = i * 0.01
    i2 = 2 - i2
    local divisor = math_fmod(screen_width * i2, screen_height) == 0 and screen_height or math_fmod(screen_height, screen_width * i2) == 0 and screen_width * i2 or 1
    if screen_width * i2 / divisor < 100 or i2 == 1 then
        aspect_ratio_table[i] = screen_width * i2 / divisor .. ":" .. screen_height / divisor
    end
end
local aspect_ratio_reference = ui.new_slider("LUA", "B", "Force aspect ratio", 1, 199, 100, true, "%", 0.01, aspect_ratio_table)

-- Элементы для вкладки Visuals (Thirdperson Animations)
local ThirdPerson_Ref = { ui.reference("Visuals", "Effects", "Force third person (alive)") }
local ThirdPerson = ui.new_checkbox("LUA", "B", "Thirdperson Animations")
local ThirdPersonDistance = ui.new_slider("LUA", "B", "Thirdperson Distance", 0, 250, 100)
local ThirdPersonZoomSpeed = ui.new_slider("LUA", "B", "Thirdperson Zoom Out Speed", 0, 100, 25, true, "%", 1, {[0] = "Instant"})

-- Элементы для вкладки Visuals (Viewmodel Changer)
local cvar_fov      = cvar.viewmodel_fov
local cvar_offset_x = cvar.viewmodel_offset_x
local cvar_offset_y = cvar.viewmodel_offset_y
local cvar_offset_z = cvar.viewmodel_offset_z

local default_fov       = 680
local default_offset_x  = 25
local default_offset_y  = 0
local default_offset_z  = -15

local viewmodel_changer     = ui.new_checkbox("LUA", "B", "Viewmodel changer")
local viewmodel_fov         = ui.new_slider("LUA", "B", "Offset fov", -1800, 1800, default_fov, true, nil, 0.1)
local viewmodel_offset_x    = ui.new_slider("LUA", "B", "Offset x", -1800, 1800, default_offset_x, true, nil, 0.1)
local viewmodel_offset_y    = ui.new_slider("LUA", "B", "Offset y", -1800, 1800, default_offset_y, true, nil, 0.1)
local viewmodel_offset_z    = ui.new_slider("LUA", "B", "Offset z", -1800, 1800, default_offset_z, true, nil, 0.1)


-- Изначально скрываем элементы Fog

    ui.set_visible(L_12_, false)
    ui.set_visible(L_13_, false)
    ui.set_visible(L_14_, false)
    ui.set_visible(L_15_, false)
    ui.set_visible(L_16_, false)

-- Изначально скрываем элементы Visuals
ui.set_visible(aspect_ratio_checkbox, false)
ui.set_visible(aspect_ratio_reference, false)
ui.set_visible(ThirdPerson, false)
ui.set_visible(ThirdPersonDistance, false)
ui.set_visible(ThirdPersonZoomSpeed, false)
ui.set_visible(viewmodel_changer, false)
ui.set_visible(viewmodel_fov, false)
ui.set_visible(viewmodel_offset_x, false)
ui.set_visible(viewmodel_offset_y, false)
ui.set_visible(viewmodel_offset_z, false)

-- Новые неактивные чекбоксы для Visuals (перемещены в конец)





local current_distance = 0

-- Элементы для вкладки Misc
local misc_checkbox = ui.new_checkbox("LUA", "B", "Enable Misc features")

-- Элементы для вкладки Misc (Custom Scope)
local m_alpha = 0

 scope_overlay = ui.reference('VISUALS', 'Effects', 'Remove scope overlay')
 master_switch = ui.new_checkbox('LUA', 'B', 'Custom scope lines')
 color_picker = ui.new_color_picker('LUA', 'B', '\n scope_lines_color_picker', 0, 0, 0, 255)
 overlay_position = ui.new_slider('LUA', 'B', '\n scope_lines_initial_pos', 0, 500, 190)
 overlay_offset = ui.new_slider('LUA', 'B', '\n scope_lines_offset', 0, 500, 15)
 fade_time = ui.new_slider('LUA', "B", "Fade animation speed", 3, 20, 12, true, 'fr', 1, { [3] = 'Off' })

-- Элементы для вкладки Misc (Custom Healthbar)
local hpbar = {
    customhealthbars = ui.new_checkbox("LUA", "B", "Custom Health bar"),
    gradient = ui.new_checkbox("LUA", "B", "Enable Gradient"),
    label = ui.new_label("LUA", "B", "Full Health"),
    colorpicker = ui.new_color_picker("LUA", "B", "Full Health", 142, 214, 77, 255),
    label2 = ui.new_label("LUA", "B", "Empty Health"),
    colorpicker2 = ui.new_color_picker("LUA", "B", "Empty Health", 244, 48, 87, 255),
}

-- Элементы для вкладки Misc (Bullet Tracer)
local tracer = ui.new_checkbox("LUA", "B", "Bullet tracers redux")
local tracer_color = ui.new_color_picker("LUA", "B", "Tracer Color", 255, 255, 255, 255)

-- Элементы для вкладки Misc (Autobuy)
local primary_weapons = {
    "-",
    "AWP",
    "SCAR20/G3SG1",
    "Scout",
    "M4/AK47",
    "Famas/Galil",
    "Aug/SG553",
    "M249/Negev",
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
    ["AWP"] = 4750,
    ["SCAR20/G3SG1"] = 5000,
    ["Scout"] = 1700,
    ["M4/AK47"] = 3100,
    ["Famas/Galil"] = 2250,
    ["Aug/SG553"] = 3100,
    ["M249"] = 5200,
    ["Negev"] = 1700,
    ["Mag7/SawedOff"] = 1300,
    ["Nova"] = 1050,
    ["XM1014"] = 2000,
    ["MP9/Mac10"] = 1250,
    ["UMP45"] = 1200,
    ["PPBizon"] = 1400,
    ["MP7"] = 1500,
    ["CZ75/Tec9/FiveSeven"] = 500,
    ["P250"] = 300,
    ["Deagle/Revolver"] = 700,
    ["Dualies"] = 400,
    ["HE Grenade"] = 300,
    ["Molotov"] = 600,
    ["Smoke"] = 300,
    ["Flash"] = 200,
    ["Decoy"] = 50,
    ["Armor"] = 650,
    ["Helmet"] = 1000,
    ["Zeus"] = 200,
    ["Defuser"] = 400
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
    ["Defuser"] = "buy defuser"
}

-- Autobuy UI элементы
 autobuy_enabled = ui.new_checkbox("LUA", "B", "Autobuy")
 autobuy_hide = ui.new_checkbox("LUA", "B", "Hide autobuy")
 autobuy_primary = ui.new_combobox("LUA", "B", "Primary", primary_weapons)
 autobuy_secondary = ui.new_combobox("LUA", "B", "Secondary", secondary_weapons)
 autobuy_grenades = ui.new_multiselect("LUA", "B", "Grenades", grenades)
 autobuy_utilities = ui.new_multiselect("LUA", "B", "Utilities", utilities)
 autobuy_cost_based = ui.new_checkbox("LUA", "B", "Cost based")
 autobuy_threshold = ui.new_slider("LUA", "B", "Balance override", 0, 16000, 0, true, "$", 1, {[0] = "Off"})
 autobuy_primary_2 = ui.new_combobox("LUA", "B", "Backup primary", primary_weapons)
 autobuy_secondary_2 = ui.new_combobox("LUA", "B", "Backup secondary", secondary_weapons)
 autobuy_grenades_2 = ui.new_multiselect("LUA", "B", "Backup grenades", grenades)
 autobuy_utilities_2 = ui.new_multiselect("LUA", "B", "Backup utilities", utilities)

-- Изначально скрываем элементы Misc
ui.set_visible(master_switch, false)
ui.set_visible(color_picker, false)
ui.set_visible(overlay_position, false)
ui.set_visible(overlay_offset, false)
ui.set_visible(fade_time, false)
ui.set_visible(hpbar.customhealthbars, false)
ui.set_visible(hpbar.gradient, false)
ui.set_visible(hpbar.label, false)
ui.set_visible(hpbar.label2, false)
ui.set_visible(hpbar.colorpicker, false)
ui.set_visible(hpbar.colorpicker2, false)
ui.set_visible(tracer, false)
ui.set_visible(tracer_color, false)
ui.set_visible(autobuy_enabled, false)
ui.set_visible(autobuy_hide, false)
ui.set_visible(autobuy_primary, false)
ui.set_visible(autobuy_secondary, false)
ui.set_visible(autobuy_grenades, false)
ui.set_visible(autobuy_utilities, false)
ui.set_visible(autobuy_cost_based, false)
ui.set_visible(autobuy_threshold, false)
ui.set_visible(autobuy_primary_2, false)
ui.set_visible(autobuy_secondary_2, false)
ui.set_visible(autobuy_grenades_2, false)
ui.set_visible(autobuy_utilities_2, false)



local players = {}
local queue = {}

-- Переменные для Autobuy
local logged_grenades = {}
local logged_grenades_2 = {}

-- UnsafeCrageinAir ссылки и переменные
local ref = {
    aimbot = ui.reference('RAGE', 'Aimbot', 'Enabled'),
    doubletap = {
        main = { ui.reference('RAGE', 'Aimbot', 'Double tap') },
        fakelag_limit = ui.reference('RAGE', 'Aimbot', 'Double tap fake lag limit')
    }
}

local local_player, callback_reg, dt_charged = nil, false, false

-- Функция для преобразования RGBA в HEX
local function to_hex(r, g, b, a)
    return string.format("%02x%02x%02x%02x", r, g, b, a)
end

-- Функция управления видимостью элементов HaxResolver
local function update_haxresolver_visibility()
    local rage_enabled = ui.get(rage_checkbox)
    local haxresolver_enabled = ui.get(rage_hax_resolver)
    local predict_enabled = ui.get(b_2.rage.predict)
    local jitter_enabled = ui.get(b_2.rage.jittercorrectionresolver)
    local experimental_enabled = ui.get(b_2.rage.interesting)

    ui.set_visible(b_2.rage.predict, rage_enabled and haxresolver_enabled)
    ui.set_visible(b_2.rage.pingpos, rage_enabled and haxresolver_enabled and predict_enabled)
    ui.set_visible(b_2.rage.jittercorrectionresolver, rage_enabled and haxresolver_enabled)
    ui.set_visible(b_2.rage.interesting, rage_enabled and haxresolver_enabled)
end


ffi = require 'ffi'
vector = require 'vector'
images = require 'gamesense/images'
anti_aim = require 'gamesense/antiaim_funcs'


round = function(value, multiplier) local multiplier = 10 ^ (multiplier or 0); return math.floor(value * multiplier + 0.5) / multiplier end
dragging_fn = function(name, base_x, base_y) return (function()local a={}local b,c,d,e,f,g,h,i,j,k,l,m,n,o;local p={__index={drag=function(self,...)local q,r=self:get()local s,t=a.drag(q,r,...)if q~=s or r~=t then self:set(s,t)end;return s,t end,set=function(self,q,r)local j,k=client_screen_size()ui_set(self.x_reference,q/j*self.res)ui_set(self.y_reference,r/k*self.res)end,get=function(self)local j,k=client_screen_size()return ui_get(self.x_reference)/self.res*j,ui_get(self.y_reference)/self.res*k end}}function a.new(u,v,w,x)x=x or 10000;local j,k=client_screen_size()local y=ui_new_slider('LUA','A',u..' window position',0,x,v/j*x)local z=ui_new_slider('LUA','A','\n'..u..' window position y',0,x,w/k*x)ui_set_visible(y,false)ui_set_visible(z,false)return setmetatable({name=u,x_reference=y,y_reference=z,res=x},p)end;function a.drag(q,r,A,B,C,D,E)if globals_framecount()~=b then c=ui_is_menu_open()f,g=d,e;d,e=ui_mouse_position()i=h;h=client_key_state(0x01)==true;m=l;l={}o=n;n=false;j,k=client_screen_size()end;if c and i~=nil then if(not i or o)and h and f>q and g>r and f<q+A and g<r+B then n=true;q,r=q+d-f,r+e-g;if not D then q=math_max(0,math_min(j-A,q))r=math_max(0,math_min(k-B,r))end end end;table_insert(l,{q,r,A,B})return q,r,A,B end;return a end)().new(name, base_x, base_y) end
graphs = function()local a={}function a:renderer_line(b,c,d)renderer_line(b.x,b.y,c.x,c.y,d.r,d.g,d.b,d.a)end;function a:renderer_rectangle_outlined(b,c,d)renderer_line(b.x,b.y,b.x,c.y,d.r,d.g,d.b,d.a)renderer_line(b.x,b.y,c.x,b.y,d.r,d.g,d.b,d.a)renderer_line(c.x,b.y,c.x,c.y,d.r,d.g,d.b,d.a)renderer_line(b.x,c.y,c.x,c.y,d.r,d.g,d.b,d.a)end;function a:renderer_rectangle_filled(b,c,d)local e=c.x-b.x;local f=c.y-b.y;if e<0 then if f<0 then renderer_rectangle(c.x,c.y,-e,-f,d.r,d.g,d.b,d.a)else renderer_rectangle(c.x,b.y,-e,f,d.r,d.g,d.b,d.a)end else if f<0 then renderer_rectangle(b.x,c.y,e,-f,d.r,d.g,d.b,d.a)else renderer_rectangle(b.x,b.y,e,f,d.r,d.g,d.b,d.a)end end end;function a:renderer_rectangle_outlined(b,c,d)renderer_line(b.x,b.y,b.x,c.y,d.r,d.g,d.b,d.a)renderer_line(b.x,b.y,c.x,b.y,d.r,d.g,d.b,d.a)renderer_line(c.x,b.y,c.x,c.y,d.r,d.g,d.b,d.a)renderer_line(b.x,c.y,c.x,c.y,d.r,d.g,d.b,d.a)end;function a:renderer_rectangle_filled_gradient(b,c,g,h,i)local e=c.x-b.x;local f=c.y-b.y;if e<0 then if f<0 then renderer_gradient(c.x,c.y,-e,-f,g.r,g.g,g.b,g.a,h.r,h.g,h.b,h.a,i)else renderer_gradient(c.x,b.y,-e,f,g.r,g.g,g.b,g.a,h.r,h.g,h.b,h.a,i)end else if f<0 then renderer_gradient(b.x,c.y,e,-f,h.r,h.g,h.b,h.a,g.r,g.g,g.b,g.a,i)else renderer_gradient(b.x,b.y,e,f,h.r,h.g,h.b,h.a,g.r,g.g,g.b,g.a,i)end end end;function a:draw(j,k,l,m,n,o)local p=k;local q=n.clr_1;k=0;l=l-p;n.h=n.h-n.thickness;if o then a:renderer_rectangle_outlined({x=n.x,y=n.y},{x=n.x+n.w-1,y=n.y+n.h-1+n.thickness},{r=q[1],g=q[2],b=q[3],a=q[4]})end;if k==l then a:renderer_line({x=n.x,y=n.y+n.h},{x=n.x+n.w,y=n.y+n.h},{r=q[1],g=q[2],b=q[3],a=q[4]})return end;local r=n.w/(m-1)local s=l-k;for t=1,m-1 do local u={(j[t]-p)/s,(j[t+1]-p)/s}local v={{x=n.x+r*(t-1),y=n.y+n.h-n.h*u[1]},{x=n.x+r*t,y=n.y+n.h-n.h*u[2]}}for t=1,n.thickness do a:renderer_line({x=v[1].x,y=v[1].y+t-1},{x=v[2].x,y=v[2].y+t-1},{r=q[1],g=q[2],b=q[3],a=q[4]})end end end;function a:draw_histogram(j,k,l,m,n,o)local p=k;k=0;l=l-p;if o then a:renderer_rectangle_outlined({x=n.x,y=n.y},{x=n.x+n.w-1,y=n.y+n.h-1},{r=255,g=255,b=255,a=255})end;local r=n.w/(m-1)local s=l-k;for t=1,m-1 do local u={(j[t]-p)/s,(j[t+1]-p)/s}local v={{x=math_floor(n.x+r*(t-1)),y=math_floor(n.y+n.h-n.h*u[1])},{x=math_floor(n.x+r*t),y=math_floor(n.y+n.h)},isZero=math_floor(n.y+n.h)==math_floor(n.y+n.h-n.h*u[1])}if n.sDrawBar=="fill"then a:renderer_rectangle_filled({x=v[1].x,y=v[1].y},{x=v[2].x,y=v[2].y},{r=n.clr_1[1],g=n.clr_1[2],b=n.clr_1[3],a=n.clr_1[4]})elseif n.sDrawBar=="gradient_fadeout"then a:renderer_rectangle_filled_gradient({x=v[1].x,y=v[1].y},{x=v[2].x,y=v[2].y},{r=n.clr_1[1],g=n.clr_1[2],b=n.clr_1[3],a=0},{r=n.clr_1[1],g=n.clr_1[2],b=n.clr_1[3],a=n.clr_1[4]},false)elseif n.sDrawBar=="gradient_fadein"then a:renderer_rectangle_filled_gradient({x=v[1].x,y=v[1].y},{x=v[2].x,y=v[2].y},{r=n.clr_1[1],g=n.clr_1[2],b=n.clr_1[3],a=n.clr_1[4]},{r=n.clr_1[1],g=n.clr_1[2],b=n.clr_1[3],a=0},false)else end;if n.bDrawPeeks and not v.isZero then a:renderer_line({x=v[1].x,y=v[1].y},{x=v[2].x,y=v[1].y},{r=n.clr_2[1],g=n.clr_2[2],b=n.clr_2[3],a=n.clr_2[4]})end end end;return a end
gram_create = function(value, count) local gram = { }; for i=1, count do gram[i] = value; end return gram; end
gram_update = function(tab, value, forced) local new_tab = tab; if forced or new_tab[#new_tab] ~= value then table_insert(new_tab, value); table_remove(new_tab, 1); end; tab = new_tab; end
get_average = function(tab) local elements, sum = 0, 0; for k, v in pairs(tab) do sum = sum + v; elements = elements + 1; end return sum / elements; end
hsv_to_rgb = function(b,c,d,e)local f,g,h;local i=math_floor(b*6)local j=b*6-i;local k=d*(1-c)local l=d*(1-j*c)local m=d*(1-(1-j)*c)i=i%6;if i==0 then f,g,h=d,m,k elseif i==1 then f,g,h=l,d,k elseif i==2 then f,g,h=k,d,m elseif i==3 then f,g,h=k,l,d elseif i==4 then f,g,h=m,k,d elseif i==5 then f,g,h=d,k,l end;return f*255,g*255,h*255,e*255 end
notes = function(b)local c=function(d,e)local f={}for g in pairs(d)do table_insert(f,g)end;table_sort(f,e)local h=0;local i=function()h=h+1;if f[h]==nil then return nil else return f[h],d[f[h]]end end;return i end;local j={get=function(k)local l,m=0,{}for n,o in c(package.solus_notes)do if o==true then l=l+1;m[#m+1]={n,l}end end;for p=1,#m do if m[p][1]==b then return k(m[p][2]-1)end end end,set_state=function(q)package.solus_notes[b]=q;table_sort(package.solus_notes)end,unset=function()client_unset_event_callback('shutdown',callback)end}client_set_event_callback('shutdown',function()if package.solus_notes[b]~=nil then package.solus_notes[b]=nil end end)if package.solus_notes==nil then package.solus_notes={}end;return j end
item_count = function(b)if b==nil then return 0 end;if#b==0 then local c=0;for d in pairs(b)do c=c+1 end;return c end;return#b end
contains = function(b,c)for d=1,#b do if b[d]==c then return true end end;return false end
create_integer = function(b,c,d,e)return{min=b,max=c,init_val=d,scale=e,value=d}end

doubletap = {ui.reference("rage", "aimbot", "double tap")}

local read_database = function(script_name, db_name, original)
 if (script_name == nil or script_name == '') or (db_name == nil or db_name == '') or (original == nil or original == { }) then
   client_color_log(216, 181, 121, ('[%s] \1\0'):format(script_name))
   client_color_log(255, 0, 0, 'Error occured while parsing data')
   
   error()
 end
 

 local dbase = database.read(db_name)
 local new_data, corrupted_data, missing_sectors =
   false, false, { }

 if dbase == nil then 
   dbase, new_data = original, true
 else
   for name in pairs(dbase) do
     local found_sector = false

     for oname in pairs(original) do
       if name == oname then
         found_sector = true
       end
     end

     if not found_sector then
       dbase[name] = nil
     end
   end

   for name, val in pairs(original) do
     if dbase[name] == nil then	
       dbase[name], corrupted_data = val, true
       missing_sectors[#missing_sectors+1] = '*' .. name
     else
       local corrupted_sector = false
       for sname, sdata in pairs(val) do
         if sname ~= 'keybinds' and dbase[name][sname] == nil or type(sdata) ~= type(dbase[name][sname]) then
           dbase[name][sname], corrupted_data = sdata, true

           if not corrupted_sector then
             missing_sectors[#missing_sectors+1] = '*' .. name
             corrupted_sector = true
           end
         end
       end
     end
   end

   if #missing_sectors > 0 then
     client_color_log(216, 181, 121, ('[%s] \1\0'):format(script_name))
     client_color_log(255, 255, 255, ('Repairing %d sector(s) \1\0'):format(#missing_sectors))
     client_color_log(155, 220, 220, ('[ %s ]'):format(table_concat(missing_sectors, ' ')))
   end
 end

 if new_data or corrupted_data then
   database.write(db_name, dbase)
 end

 return dbase, original
end

local script_name = 'solus'
local database_name = 'solus'
local menu_tab = { 'LUA', 'A', 'B' }
local menu_palette = { 'Solid', 'Rainbow' }
local m_hotkeys, m_hotkeys_update, m_hotkeys_create = { }, true
local ms_watermark_enable = ui_new_checkbox('Lua', 'b', 'Solus')
local ms_watermark = ui_new_checkbox('Lua', 'b', 'Watermark')
local ms_spectators = ui_new_checkbox('Lua', 'b', 'Spectators') 
local ms_keybinds = ui_new_checkbox('Lua', 'b', 'Hotkey list')
local ms_antiaim = ui_new_checkbox('Lua', 'b', 'Anti-aimbot indication')
local ms_lags_exploit = ui_new_checkbox('Lua', 'b', 'Lags-Exploit indication')
local ms_ieinfo = ui_new_checkbox('Lua', 'b', 'Frequency update information')

local glow_enabled = ui_new_checkbox('Lua', 'b', 'Glow Enabled (low fps warning)')

local ms_palette, ms_color = 
 ui.new_combobox('Lua', 'b', 'Solus Palette', menu_palette),
 ui.new_color_picker('Lua', 'b', 'Solus Global color', 142, 165, 229, 85)

local ms_rainbow_frequency = ui_new_slider('Lua', 'b', 'Rainbow frequency', 1, 100, 10, false, nil, 0.01)
local ms_rainbow_split_ratio = ui_new_slider('Lua', 'b', 'Rainbow split ratio', 0, 100, 100, false, nil, 0.01)

-- Функция управления видимостью элементов ModelChenger
ui = require("gamesense/pui")
ffi = require("ffi")
js = panorama.open()
ffi = require("ffi")
type = type
unpack = unpack
table_insert = table.insert
table_concat = table.concat
client_color_log = client.color_log
package_searchpath = package.searchpath
materialsystem_find_materials = materialsystem.find_materials
client_userid_to_entindex = client.userid_to_entindex
entity_get_local_player = entity.get_local_player
client_delay_call = client.delay_call
client_set_event_callback = client.set_event_callback
client_unset_event_callback = client.unset_event_callback
ui_set_callback = ui.set_callback
ui_get = ui.get
globals_realtime = globals.realtime
tSkyboxList = {
  {
    sName = "Tibet",
    sPath = "cs_tibet",
    bThirdparty = false
  },
  {
    sName = "Baggage",
    sPath = "cs_baggage_skybox_",
    bThirdparty = false
  },
  {
    sName = "Monastery",
    sPath = "embassy",
    bThirdparty = false
  },
  {
    sName = "Italy",
    sPath = "italy",
    bThirdparty = false
  },
  {
    sName = "Aztec",
    sPath = "jungle",
    bThirdparty = false
  },
  {
    sName = "Vertigo",
    sPath = "office",
    bThirdparty = false
  },
  {
    sName = "Daylight",
    sPath = "sky_cs15_daylight01_hdr",
    bThirdparty = false
  },
  {
    sName = "Daylight (2)",
    sPath = "vertigoblue_hdr",
    bThirdparty = false
  },
  {
    sName = "Clouds",
    sPath = "sky_cs15_daylight02_hdr",
    bThirdparty = false
  },
  {
    sName = "Clouds (2)",
    sPath = "vertigo",
    bThirdparty = false
  },
  {
    sName = "Gray",
    sPath = "sky_day02_05_hdr",
    bThirdparty = false
  },
  {
    sName = "Clear",
    sPath = "nukeblank",
    bThirdparty = false
  },
  {
    sName = "Canals",
    sPath = "sky_venice",
    bThirdparty = false
  },
  {
    sName = "Cobblestone",
    sPath = "sky_cs15_daylight03_hdr",
    bThirdparty = false
  },
  {
    sName = "Assault",
    sPath = "sky_cs15_daylight04_hdr",
    bThirdparty = false
  },
  {
    sName = "Clouds (Dark)",
    sPath = "sky_csgo_cloudy01",
    bThirdparty = false
  },
  {
    sName = "Night",
    sPath = "sky_csgo_night02",
    bThirdparty = false
  },
  {
    sName = "Night (2)",
    sPath = "sky_csgo_night02b",
    bThirdparty = false
  },
  {
    sName = "Night (Flat)",
    sPath = "sky_csgo_night_flat",
    bThirdparty = false
  },
  {
    sName = "Dusty",
    sPath = "sky_dust",
    bThirdparty = false
  },
  {
    sName = "Rainy",
    sPath = "vietnam",
    bThirdparty = false
  },
  {
    sName = "amethyst",
    sPath = "amethyst",
    bThirdparty = true
  },
  {
    sName = "clear_night_sky",
    sPath = "clear_night_sky",
    bThirdparty = true
  },
  {
    sName = "cloudynight",
    sPath = "cloudynight",
    bThirdparty = true
  },
  {
    sName = "dreamyocean",
    sPath = "dreamyocean",
    bThirdparty = true
  },
  {
    sName = "grimmnight",
    sPath = "grimmnight",
    bThirdparty = true
  },
  {
    sName = "lakesky",
    sPath = "lakesky",
    bThirdparty = true
  },
  {
    sName = "mars",
    sPath = "mars",
    bThirdparty = true
  },
  {
    sName = "mpa119",
    sPath = "mpa119",
    bThirdparty = true
  },
  {
    sName = "mr1",
    sPath = "mr1",
    bThirdparty = true
  },
  {
    sName = "mr_01",
    sPath = "mr_01",
    bThirdparty = true
  },
  {
    sName = "mr_02",
    sPath = "mr_02",
    bThirdparty = true
  },
  {
    sName = "mr_03",
    sPath = "mr_03",
    bThirdparty = true
  },
  {
    sName = "mr_04",
    sPath = "mr_04",
    bThirdparty = true
  },
  {
    sName = "mr_05",
    sPath = "mr_05",
    bThirdparty = true
  },
  {
    sName = "mr_06",
    sPath = "mr_06",
    bThirdparty = true
  },
  {
    sName = "mr_07",
    sPath = "mr_07",
    bThirdparty = true
  },
  {
    sName = "mr_08",
    sPath = "mr_08",
    bThirdparty = true
  },
  {
    sName = "mr_10",
    sPath = "mr_10",
    bThirdparty = true
  },
  {
    sName = "mr_12",
    sPath = "mr_12",
    bThirdparty = true
  },
  {
    sName = "mr_13",
    sPath = "mr_13",
    bThirdparty = true
  },
  {
    sName = "mr_15",
    sPath = "mr_15",
    bThirdparty = true
  },
  {
    sName = "mr_16",
    sPath = "mr_16",
    bThirdparty = true
  },
  {
    sName = "mr_ice",
    sPath = "mr_ice",
    bThirdparty = true
  },
  {
    sName = "mr_moon",
    sPath = "mr_moon",
    bThirdparty = true
  },
  {
    sName = "mr_night_",
    sPath = "mr_night_",
    bThirdparty = true
  },
  {
    sName = "mr_space",
    sPath = "mr_space",
    bThirdparty = true
  },
  {
    sName = "otherworld",
    sPath = "otherworld",
    bThirdparty = true
  },
  {
    sName = "pandora_b",
    sPath = "pandora_b",
    bThirdparty = true
  },
  {
    sName = "pandora_f",
    sPath = "pandora_f",
    bThirdparty = true
  },
  {
    sName = "ptr_amethyst",
    sPath = "ptr_amethyst",
    bThirdparty = true
  },
  {
    sName = "ptr_clear_night_sky",
    sPath = "ptr_clear_night_sky",
    bThirdparty = true
  },
  {
    sName = "ptr_cloudynight",
    sPath = "ptr_cloudynight",
    bThirdparty = true
  },
  {
    sName = "ptr_dreamyocean",
    sPath = "ptr_dreamyocean",
    bThirdparty = true
  },
  {
    sName = "ptr_grimmnight",
    sPath = "ptr_grimmnight",
    bThirdparty = true
  },
  {
    sName = "ptr_otherworld",
    sPath = "ptr_otherworld",
    bThirdparty = true
  },
  {
    sName = "ptr_sky051",
    sPath = "ptr_sky051",
    bThirdparty = true
  },
  {
    sName = "ptr_sky081",
    sPath = "ptr_sky081",
    bThirdparty = true
  },
  {
    sName = "ptr_sky091",
    sPath = "ptr_sky091",
    bThirdparty = true
  },
  {
    sName = "ptr_sky561",
    sPath = "ptr_sky561",
    bThirdparty = true
  },
  {
    sName = "Real_SkySunset",
    sPath = "Real_SkySunset",
    bThirdparty = true
  },
  {
    sName = "red_planet",
    sPath = "red_planet",
    bThirdparty = true
  },
  {
    sName = "retrosun",
    sPath = "retrosun",
    bThirdparty = true
  },
  {
    sName = "sky002",
    sPath = "sky002",
    bThirdparty = true
  },
  {
    sName = "sky003",
    sPath = "sky003",
    bThirdparty = true
  },
  {
    sName = "sky004",
    sPath = "sky004",
    bThirdparty = true
  },
  {
    sName = "sky051",
    sPath = "sky051",
    bThirdparty = true
  },
  {
    sName = "sky081",
    sPath = "sky081",
    bThirdparty = true
  },
  {
    sName = "sky091",
    sPath = "sky091",
    bThirdparty = true
  },
  {
    sName = "sky100",
    sPath = "sky100",
    bThirdparty = true
  },
  {
    sName = "sky101",
    sPath = "sky101",
    bThirdparty = true
  },
  {
    sName = "sky103",
    sPath = "sky103",
    bThirdparty = true
  },
  {
    sName = "sky104",
    sPath = "sky104",
    bThirdparty = true
  },
  {
    sName = "sky105",
    sPath = "sky105",
    bThirdparty = true
  },
  {
    sName = "sky106",
    sPath = "sky106",
    bThirdparty = true
  },
  {
    sName = "sky107",
    sPath = "sky107",
    bThirdparty = true
  },
  {
    sName = "sky108",
    sPath = "sky108",
    bThirdparty = true
  },
  {
    sName = "sky109",
    sPath = "sky109",
    bThirdparty = true
  },
  {
    sName = "sky110",
    sPath = "sky110",
    bThirdparty = true
  },
  {
    sName = "sky111",
    sPath = "sky111",
    bThirdparty = true
  },
  {
    sName = "sky112",
    sPath = "sky112",
    bThirdparty = true
  },
  {
    sName = "sky113",
    sPath = "sky113",
    bThirdparty = true
  },
  {
    sName = "sky114",
    sPath = "sky114",
    bThirdparty = true
  },
  {
    sName = "sky115",
    sPath = "sky115",
    bThirdparty = true
  },
  {
    sName = "sky116",
    sPath = "sky116",
    bThirdparty = true
  },
  {
    sName = "sky117",
    sPath = "sky117",
    bThirdparty = true
  },
  {
    sName = "sky118",
    sPath = "sky118",
    bThirdparty = true
  },
  {
    sName = "sky119",
    sPath = "sky119",
    bThirdparty = true
  },
  {
    sName = "sky121",
    sPath = "sky121",
    bThirdparty = true
  },
  {
    sName = "sky122",
    sPath = "sky122",
    bThirdparty = true
  },
  {
    sName = "sky123",
    sPath = "sky123",
    bThirdparty = true
  },
  {
    sName = "sky124",
    sPath = "sky124",
    bThirdparty = true
  },
  {
    sName = "sky125",
    sPath = "sky125",
    bThirdparty = true
  },
  {
    sName = "sky126",
    sPath = "sky126",
    bThirdparty = true
  },
  {
    sName = "sky127",
    sPath = "sky127",
    bThirdparty = true
  },
  {
    sName = "sky128",
    sPath = "sky128",
    bThirdparty = true
  },
  {
    sName = "sky129c",
    sPath = "sky129c",
    bThirdparty = true
  },
  {
    sName = "sky129",
    sPath = "sky129",
    bThirdparty = true
  },
  {
    sName = "sky130",
    sPath = "sky130",
    bThirdparty = true
  },
  {
    sName = "sky131",
    sPath = "sky131",
    bThirdparty = true
  },
  {
    sName = "sky132",
    sPath = "sky132",
    bThirdparty = true
  },
  {
    sName = "sky133",
    sPath = "sky133",
    bThirdparty = true
  },
  {
    sName = "sky134",
    sPath = "sky134",
    bThirdparty = true
  },
  {
    sName = "sky135",
    sPath = "sky135",
    bThirdparty = true
  },
  {
    sName = "sky136",
    sPath = "sky136",
    bThirdparty = true
  },
  {
    sName = "sky137",
    sPath = "sky137",
    bThirdparty = true
  },
  {
    sName = "sky138a",
    sPath = "sky138a",
    bThirdparty = true
  },
  {
    sName = "sky138",
    sPath = "sky138",
    bThirdparty = true
  },
  {
    sName = "sky139a",
    sPath = "sky139a",
    bThirdparty = true
  },
  {
    sName = "sky139",
    sPath = "sky139",
    bThirdparty = true
  },
  {
    sName = "sky140",
    sPath = "sky140",
    bThirdparty = true
  },
  {
    sName = "sky141",
    sPath = "sky141",
    bThirdparty = true
  },
  {
    sName = "sky142",
    sPath = "sky142",
    bThirdparty = true
  },
  {
    sName = "sky143",
    sPath = "sky143",
    bThirdparty = true
  },
  {
    sName = "sky144",
    sPath = "sky144",
    bThirdparty = true
  },
  {
    sName = "sky145",
    sPath = "sky145",
    bThirdparty = true
  },
  {
    sName = "sky147",
    sPath = "sky147",
    bThirdparty = true
  },
  {
    sName = "sky148",
    sPath = "sky148",
    bThirdparty = true
  },
  {
    sName = "sky149",
    sPath = "sky149",
    bThirdparty = true
  },
  {
    sName = "sky150day",
    sPath = "sky150day",
    bThirdparty = true
  },
  {
    sName = "sky150",
    sPath = "sky150",
    bThirdparty = true
  },
  {
    sName = "sky151",
    sPath = "sky151",
    bThirdparty = true
  },
  {
    sName = "sky152",
    sPath = "sky152",
    bThirdparty = true
  },
  {
    sName = "sky153",
    sPath = "sky153",
    bThirdparty = true
  },
  {
    sName = "sky154",
    sPath = "sky154",
    bThirdparty = true
  },
  {
    sName = "sky155",
    sPath = "sky155",
    bThirdparty = true
  },
  {
    sName = "sky156",
    sPath = "sky156",
    bThirdparty = true
  },
  {
    sName = "sky157",
    sPath = "sky157",
    bThirdparty = true
  },
  {
    sName = "sky158",
    sPath = "sky158",
    bThirdparty = true
  },
  {
    sName = "sky159",
    sPath = "sky159",
    bThirdparty = true
  },
  {
    sName = "sky161s",
    sPath = "sky161s",
    bThirdparty = true
  },
  {
    sName = "sky161",
    sPath = "sky161",
    bThirdparty = true
  },
  {
    sName = "sky162",
    sPath = "sky162",
    bThirdparty = true
  },
  {
    sName = "sky163",
    sPath = "sky163",
    bThirdparty = true
  },
  {
    sName = "sky164",
    sPath = "sky164",
    bThirdparty = true
  },
  {
    sName = "sky165",
    sPath = "sky165",
    bThirdparty = true
  },
  {
    sName = "sky166",
    sPath = "sky166",
    bThirdparty = true
  },
  {
    sName = "sky167",
    sPath = "sky167",
    bThirdparty = true
  },
  {
    sName = "sky168",
    sPath = "sky168",
    bThirdparty = true
  },
  {
    sName = "sky169",
    sPath = "sky169",
    bThirdparty = true
  },
  {
    sName = "sky170",
    sPath = "sky170",
    bThirdparty = true
  },
  {
    sName = "sky171",
    sPath = "sky171",
    bThirdparty = true
  },
  {
    sName = "sky172",
    sPath = "sky172",
    bThirdparty = true
  },
  {
    sName = "sky173",
    sPath = "sky173",
    bThirdparty = true
  },
  {
    sName = "sky174",
    sPath = "sky174",
    bThirdparty = true
  },
  {
    sName = "sky175",
    sPath = "sky175",
    bThirdparty = true
  },
  {
    sName = "sky176",
    sPath = "sky176",
    bThirdparty = true
  },
  {
    sName = "sky177",
    sPath = "sky177",
    bThirdparty = true
  },
  {
    sName = "sky178",
    sPath = "sky178",
    bThirdparty = true
  },
  {
    sName = "sky179",
    sPath = "sky179",
    bThirdparty = true
  },
  {
    sName = "sky180",
    sPath = "sky180",
    bThirdparty = true
  },
  {
    sName = "sky181",
    sPath = "sky181",
    bThirdparty = true
  },
  {
    sName = "sky182",
    sPath = "sky182",
    bThirdparty = true
  },
  {
    sName = "sky183",
    sPath = "sky183",
    bThirdparty = true
  },
  {
    sName = "sky184",
    sPath = "sky184",
    bThirdparty = true
  },
  {
    sName = "sky185",
    sPath = "sky185",
    bThirdparty = true
  },
  {
    sName = "sky186",
    sPath = "sky186",
    bThirdparty = true
  },
  {
    sName = "sky187",
    sPath = "sky187",
    bThirdparty = true
  },
  {
    sName = "sky190",
    sPath = "sky190",
    bThirdparty = true
  },
  {
    sName = "sky191",
    sPath = "sky191",
    bThirdparty = true
  },
  {
    sName = "sky192",
    sPath = "sky192",
    bThirdparty = true
  },
  {
    sName = "sky1",
    sPath = "sky1",
    bThirdparty = true
  },
  {
    sName = "sky200",
    sPath = "sky200",
    bThirdparty = true
  },
  {
    sName = "sky26_HDR",
    sPath = "sky26_HDR",
    bThirdparty = true
  },
  {
    sName = "sky28_HDR",
    sPath = "sky28_HDR",
    bThirdparty = true
  },
  {
    sName = "sky302",
    sPath = "sky302",
    bThirdparty = true
  },
  {
    sName = "sky303",
    sPath = "sky303",
    bThirdparty = true
  },
  {
    sName = "sky561",
    sPath = "sky561",
    bThirdparty = true
  },
  {
    sName = "sky77",
    sPath = "sky77",
    bThirdparty = true
  },
  {
    sName = "sky78",
    sPath = "sky78",
    bThirdparty = true
  },
  {
    sName = "sky_001",
    sPath = "sky_001",
    bThirdparty = true
  },
  {
    sName = "sky_79",
    sPath = "sky_79",
    bThirdparty = true
  },
  {
    sName = "sky_descent",
    sPath = "sky_descent",
    bThirdparty = true
  },
  {
    sName = "sky_l",
    sPath = "sky_l",
    bThirdparty = true
  },
  {
    sName = "sky_moon",
    sPath = "sky_moon",
    bThirdparty = true
  },
  {
    sName = "sky_z",
    sPath = "sky_z",
    bThirdparty = true
  },
  {
    sName = "space_10",
    sPath = "space_10",
    bThirdparty = true
  },
  {
    sName = "space_11",
    sPath = "space_11",
    bThirdparty = true
  },
  {
    sName = "space_12",
    sPath = "space_12",
    bThirdparty = true
  },
  {
    sName = "space_13",
    sPath = "space_13",
    bThirdparty = true
  },
  {
    sName = "space_14",
    sPath = "space_14",
    bThirdparty = true
  },
  {
    sName = "space_15",
    sPath = "space_15",
    bThirdparty = true
  },
  {
    sName = "space_16",
    sPath = "space_16",
    bThirdparty = true
  },
  {
    sName = "space_17",
    sPath = "space_17",
    bThirdparty = true
  },
  {
    sName = "space_18",
    sPath = "space_18",
    bThirdparty = true
  },
  {
    sName = "space_19",
    sPath = "space_19",
    bThirdparty = true
  },
  {
    sName = "space_1",
    sPath = "space_1",
    bThirdparty = true
  },
  {
    sName = "space_20",
    sPath = "space_20",
    bThirdparty = true
  },
  {
    sName = "space_22",
    sPath = "space_22",
    bThirdparty = true
  },
  {
    sName = "space_23",
    sPath = "space_23",
    bThirdparty = true
  },
  {
    sName = "space_2",
    sPath = "space_2",
    bThirdparty = true
  },
  {
    sName = "space_3",
    sPath = "space_3",
    bThirdparty = true
  },
  {
    sName = "space_4",
    sPath = "space_4",
    bThirdparty = true
  },
  {
    sName = "space_5",
    sPath = "space_5",
    bThirdparty = true
  },
  {
    sName = "space_6",
    sPath = "space_6",
    bThirdparty = true
  },
  {
    sName = "space_7",
    sPath = "space_7",
    bThirdparty = true
  },
  {
    sName = "space_8",
    sPath = "space_8",
    bThirdparty = true
  },
  {
    sName = "space_9",
    sPath = "space_9",
    bThirdparty = true
  },
  {
    sName = "stormymountain_hdr",
    sPath = "stormymountain_hdr",
    bThirdparty = true
  },
  {
    sName = "sunsetmountain",
    sPath = "sunsetmountain",
    bThirdparty = true
  },
  {
    sName = "WhiteDwarf",
    sPath = "WhiteDwarf",
    bThirdparty = true
  }
}

load_name_sky_address = client.find_signature("engine.dll", "\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x56\x57\x8B\xF9\xC7\x45") or error("signature for load_skybox is outdated")
load_name_sky = ffi.cast(ffi.typeof("void(__fastcall*)(const char*)"), load_name_sky_address)

local multicolor_log
multicolor_log = function(...)
  args = {
    ...
  }
  len = #args
  for i = 1, len do
    arg = args[i]
    r, g, b = unpack(arg)
    msg = { }
    if #arg == 3 then
      table_insert(msg, " ")
    else
      for i = 4, #arg do
        table_insert(msg, arg[i])
      end
    end
    msg = table_concat(msg)
    if len > i then
      msg = msg .. "\0"
    end
    client_color_log(r, g, b, msg)
  end
end
do
  _accum_0 = { }
  _len_0 = 1
  for _index_0 = 1, #tSkyboxList do
    tSkyboxData = tSkyboxList[_index_0]
    if (function()
      if tSkyboxData.bThirdparty then
        sPath = "./csgo/materials/skybox/" .. tostring(tSkyboxData.sPath) .. "up.vmt"
        bIsFileExists = package_searchpath("", sPath) == sPath
        if bIsFileExists then
          multicolor_log({
            127,
            255,
            0,
            " + "
          }, {
            255,
            255,
            255,
            "Found ["
          }, {
            0,
            255,
            255,
            "materials\\skybox\\" .. tostring(tSkyboxData.sPath) .. "up.vmt"
          }, {
            255,
            255,
            255,
            "]"
          })
       --[[ else
          multicolor_log({
            255,
            127,
            0,
            " - "
          }, {
            255,
            255,
            255,
            "Not Found ["
          }, {
            0,
            255,
            255,
            "materials\\skybox\\" .. tostring(tSkyboxData.sPath) .. "up.vmt"
          }, {
            255,
            255,
            255,
            "] ("
          }, {
            0,
            255,
            255,
            "No such file!"
          }, {
            255,
            255,
            255,
            ")"
          })]]
        end
        return bIsFileExists
      else
        return true
      end
    end)() then
      _accum_0[_len_0] = tSkyboxData
      _len_0 = _len_0 + 1
    end
  end
  tSkyboxList = _accum_0
end
table.sort(tSkyboxList, function(tA, tB)
  return tA.sName < tB.sName
end)

tScriptData = {
    tMenuReferences = {
      nMasterSwitchEnable = ui.new_checkbox("LUA", "b", "Skybox Changer"),
      nPadding = ui.new_label("LUA", "b", "\nSet Skybox"),
      nMasterSwitch = ui.new_checkbox("LUA", "b", "Set Skybox"),
      nSkyboxColor = ui.new_color_picker("LUA", "b", "Color\nSet Skybox", 255, 255, 255, 255),
      nSkyboxList = ui.new_listbox("LUA", "b", "List\nSet Skybox", (function()
        _accum_0 = { }
        _len_0 = 1
        for _index_0 = 1, #tSkyboxList do
          tSkyboxData = tSkyboxList[_index_0]
          _accum_0[_len_0] = tSkyboxData.sName
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)()),
      nSkyboxColorChangeDelay = ui.new_slider("LUA", "b", "Color Change Delay\nSet Skybox", 1, 5, 1, true, "s.", 1),
      nSkyboxCheckInterval = ui.new_slider("LUA", "b", "Check Inteval\nSet Skybox", 1, 5, 1, true, "s.", 1),
      nHide3dSkybox = ui.new_checkbox("LUA", "b", "Hide 3D Skybox\nSet Skybox")
    },
    tSkyboxIndexToPath = (function()
      _tbl_0 = { }
      for nIterator1, tSkyboxData in ipairs(tSkyboxList) do
        _tbl_0[nIterator1] = tSkyboxData.sPath
      end
      return _tbl_0
    end)(),
    sSkyboxNameCustom = false,
    nSkyboxCheckTimestamp = 0
  }
player_models = {
    ["CameraMan"] = "models/player/custom_player/csgo/cameraman_ported_lev/cameraman_ported_csgo.mdl",
    ["Ballas Wraith"] = "models/player/custom_player/caleon1/ballas1/ballas1.mdl",
    ["Hunk"] = "models/player/custom_player/darnias/hunk/hunk.mdl",
    ["Barber"] = "models/player/custom_player/eminem/gta_sa/bmybar.mdl",
    ["Groove"] = "models/player/custom_player/eminem/gta_sa/fam1.mdl",
    ["Civillian"] = "models/player/custom_player/eminem/gta_sa/somyst.mdl",
    ["Homelles"] = "models/player/custom_player/eminem/gta_sa/swmotr5.mdl",
    ["Aztec"] = "models/player/custom_player/eminem/gta_sa/vla2.mdl",
    ["Prostitute"] = "models/player/custom_player/eminem/gta_sa/vwfypro.mdl",
    ["Wuzi"] = "models/player/custom_player/eminem/gta_sa/wuzimu.mdl",
    ["Ballas Black"] = "models/player/custom_player/frnchise9812/ballas2.mdl",
    ["Tommi"] = "models/player/custom_player/nf/gta/tommi.mdl",
    ["Putin"] = "models/player/custom_player/night_fighter/putin/putin.mdl",
    ["Krueger"] = "models/player/custom_player/kuristaja/krueger/krueger.mdl",
    ["Myers"] = "models/player/custom_player/kuristaja/myers/myers.mdl",
    ["LeatherFace"] = "models/player/custom_player/kuristaja/leatherface/leatherface.mdl",
    ["Billy"] = "models/player/custom_player/kuristaja/billy/billy_normal.mdl",
    ["Ghost"] = "models/player/custom_player/kuristaja/ghostface/ghostface.mdl",
    ["Pennywise"] = "models/player/custom_player/kuristaja/pennywise/pennywise.mdl",
    ["Doomguy"] = "models/player/custom_player/kuristaja/doomguy/doomguy.mdl",
    ["Putin2"] = "models/player/custom_player/kuristaja/putin/putin.mdl",
    ["Spiderman"] = "models/player/custom_player/kuristaja/spiderman/spiderman.mdl",
    ["Skeleton"] = "models/player/custom_player/kuristaja/skeleton/skeleton.mdl",
    ["FIB Male"] = "models/player/custom_player/kuristaja/ash/ash.mdl",
    ["Gta Blood"] = "models/player/custom_player/z-piks.ru/gta_blood.mdl",
    ["Kim"] = "models/player/custom_player/kuristaja/kim_jong_un/kim.mdl",
    ["Gta Crip"] = "models/player/custom_player/z-piks.ru/gta_crip.mdl",
    ["Hitman"] = "models/player/custom_player/voikanaa/hitman/agent47.mdl",
    ["Sauron"] = "models/player/custom_player/legacy/sauron/sauron.mdl",
    ["Trump"] = "models/player/custom_player/kuristaja/trump/trump.mdl",
    ["Gign"] = "models/player/custom_player/eminem/css/ct_gign.mdl",
    ["Arctic"] = "models/player/custom_player/eminem/css/t_arctic.mdl",
    ["Whatch Dogs"] = "models/player/custom_player/kolka/Aiden_Pearce/aiden_pearce.mdl",
    ["T800"] = "models/player/custom_player/night_fighter/t800/govno.mdl",
    ["AndrewGS"] = "models/player/custom_player/frnchise9812/Andrew_gamesensee.mdl",
    ["Trololo"] = "models/player/custom_player/fantom/troll/troll.mdl",
    ["Urban"] = "models/player/custom_player/eminem/css/Urban_CSS.mdl",
    ["AndrewNL"] = "models/player/custom_player/frnchise9812/Andrew_neverlosee.mdl",
    ["Ballas With Hat"] = "models/player/custom_player/kolka/ballas/BallasWithHat.mdl",
    ["Hitler"] = "models/player/custom_player/kuristaja/hitler/hitler.mdl",
    ["Phoenix"] = "models/player/custom_player/eminem/css/Phoenix_CSS.mdl",
    ["Rem"] = "models/player/custom_player/maoling/re0/rem/rem.mdl",
    ["Ram"] = "models/player/custom_player/maoling/re0/ram/ram.mdl",
    ["ReinaBlue"] = "models/player/custom_player/caleon1/reinakousaka/reina_blue.mdl",
    ["ReinaRed"] = "models/player/custom_player/caleon1/reinakousaka/reina_red.mdl",
    ["Prinz"] = "models/player/custom_player/ventoz/azur_lane/prinz_eugen.mdl",
    ["Haku"] = "models/player/custom_player/monsterko/haku_wedding_dress/haku_v3.mdl",
    ["Sinon"] = "models/player/custom_player/kolka/Sinon/sinon.mdl",
    ["Dogirl"] = "models/player/custom_player/2019x/dogirl/a0.mdl",
    ["Karen"] = "models/player/custom_player/kolka/Code_Vein_karen/code_vein_karen_v2.mdl",
    ["Motoko"] = "models/player/custom_player/kuristaja/motoko/motoko.mdl",
    ["Zelda"] = "models/player/custom_player/pikajew/atsuko/princess_zelda_botw/princess_zelda_botw.mdl",
    ["Bunny"] = "models/player/custom_player/natalya/hhp227/bunny-girl.mdl",
    ["Spirit"] = "models/player/custom_player/maoling/date_a_live/tohka/spirit/tohka.mdl",
    ["Kashima"] = "models/player/custom_player/gkuo88/kashimafix/kashimafix.mdl",
    ["Scoundrel"] = "models/player/custom_player/caleon1/scoundrel/scoundrel.mdl",
    ["Reaper"] = "models/player/custom_player/uroboros/the_reaper/the_reaper.mdl",
    ["Whiteout"] = "models/player/custom_player/rabidgames/streetracermale3/whiteout.mdl",
    ["Nitelite"] = "models/player/custom_player/rabidgames/nitelite/nitelite.mdl",
    ["Ninja"] = "models/player/custom_player/rabidgames/ninja/ninja.mdl",
    ["Skye Summer"] = "models/player/custom_player/night_fighter/fortnite/summer_skye/summer_skye.mdl",
    ["Axolotl"] = "models/player/custom_player/night_fighter/fortnite/axolotl/axolotl.mdl",
    ["Bonewasp"] = "models/player/custom_player/canwit/fortnite/bonewasp.mdl",
    ["Velocity"] = "models/player/custom_player/caleon1/velocity/velocity.mdl",
    ["Mezmer"] = "models/player/custom_player/caleon1/mezmer/mezmer.mdl",
    ["Skilet"] = "models/player/custom_player/rabidgames/skilet/skilet.mdl",
    ["Wraith"] = "models/player/custom_player/ventoz/apex/wraith/wraith_default.mdl",
    ["Dark Bom"] = "models/player/custom_player/rabidgames/dark_bom/dark_bom.mdl",
    ["Leet Classic"] = "models/player/custom_player/bbs_93x_net_2016/legacy/classics_1337/tm_leet_variant_classic.mdl",
    ["Tali'Zorah"] = "models/player/custom_player/hekut/talizorah/talizorah.mdl",
    ["Thug Leet"] = "models/player/custom_player/kirby/leetkumla/leetkumla.mdl",
    ["FIB"] = "models/player/custom_player/kirby/kumlafbi/kumlafbi.mdl",
    ["Miyu"] = "models/player/custom_player/kuristaja/cso2/miyu_schoolgirl/miyu.mdl",
    ["Jett"] = "models/player/custom_player/night_fighter/valorant/jett/jett.mdl",
    ["Lisa"] = "models/player/custom_player/kuristaja/cso2/lisa/lisa.mdl",
    ["OgLoc"] = "models/player/custom_player/legacy/toppi/bew/gta/Ogloc.mdl",
    ["Marci"] = "models/player/custom_player/kolka/marci/Marci.mdl",
    ["Mirana"] = "models/player/custom_player/kolka/mirana/Mirana.mdl",
    ["Neon"] = "models/player/custom_player/kolka/neon/neon.mdl",
    ["Antimage Girl"] = "models/player/custom_player/kolka/antimage_girl/antimage_girl.mdl",
    ["Scout Red"] = "models/player/custom_player/kuristaja/tf2/scout/scout_redv2.mdl",
    ["Scout Blue"] = "models/player/custom_player/kuristaja/tf2/scout/scout_bluv2.mdl",
    ["Spy Red"] = "models/player/custom_player/kuristaja/tf2/spy/spy_redv2.mdl",
    ["Spy Blue"] = "models/player/custom_player/kuristaja/tf2/spy/spy_bluv2.mdl",
    ["Gabe"] = "models/player/custom_player/nf/gabe_newell/gabenewell.mdl",
    ["CuddleLeader"] = "models/player/custom_player/legacy/cuddleleader.mdl",
    ["Soldier Red"] = "models/player/custom_player/kuristaja/tf2/soldier/soldier_redv2.mdl",
    ["Soldier Blue"] = "models/player/custom_player/kuristaja/tf2/soldier/soldier_bluv2.mdl",
    ["Engineer Red"] = "models/player/custom_player/kuristaja/tf2/engineer/engineer_redv2.mdl",
    ["Engineer Blue"] = "models/player/custom_player/kuristaja/tf2/engineer/engineer_bluv2.mdl",
    ["Shark"] = "models/player/custom_player/nf/shark/shark.mdl",
    ["Pepe"] = "models/player/custom_player/nf/pepe/pepe.mdl",
    ["Pedobear"] = "models/player/custom_player/eminem/pedobear/pedobear.mdl",
    ["Lara"] = "models/player/custom_player/voikanaa/tru/lara.mdl",
    ["Dr. Disrespect"] = "models/player/custom_player/legacy/gxp/rogue/dr_disrespect/dr_disrespect_v1.mdl",
    ["Assasin"] = "models/player/custom_player/voikanaa/acb/ezio.mdl",
    ["Jihad"] = "models/player/custom_player/uroboros/jihad/jihad.mdl",
    ["Ghony Cyberpunk"] = "models/player/custom_player/nf/cyberpunk_2077/ghony.mdl",
    ["Kurt Cobain"] = "models/player/custom_player/legacy/gxp/kurtcobain/kurtcobain_v1.mdl",
    ["Niko"] = "models/player/custom_player/voikanaa/gtaiv/niko.mdl",
    ["Bikini Girl"] = "models/player/custom_player/voikanaa/misc/bikini_girl.mdl",
    ["Arctic V2"] = "models/player/custom_player/legacy/tm_arctic_varianta.mdl",
    ["Arctic V3"] = "models/player/custom_player/legacy/tm_arctic_variantc.mdl",
}

ffi.cdef[[
    typedef struct 
    {
    	void*   fnHandle;        
    	char    szName[260];     
    	int     nLoadFlags;      
    	int     nServerCount;    
    	int     type;            
    	int     flags;           
    	float  vecMins[3];       
    	float  vecMaxs[3];       
    	float   radius;          
    	char    pad[0x1C];       
    }model_t;
    
    typedef int(__thiscall* get_model_index_t)(void*, const char*);
    typedef const model_t(__thiscall* find_or_load_model_t)(void*, const char*);
    typedef int(__thiscall* add_string_t)(void*, bool, const char*, int, const void*);
    typedef void*(__thiscall* find_table_t)(void*, const char*);
    typedef void(__thiscall* set_model_index_t)(void*, int);
    typedef int(__thiscall* precache_model_t)(void*, const char*, bool);
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
]]

class_ptr=ffi.typeof("void***");rawientitylist=client.create_interface("client_panorama.dll","VClientEntityList003")or error("VClientEntityList003 wasnt found",2);ientitylist=ffi.cast(class_ptr,rawientitylist)or error("rawientitylist is nil",2);get_client_entity=ffi.cast("get_client_entity_t",ientitylist[0][3])or error("get_client_entity is nil",2);rawivmodelinfo=client.create_interface("engine.dll","VModelInfoClient004")or error("VModelInfoClient004 wasnt found",2);ivmodelinfo=ffi.cast(class_ptr,rawivmodelinfo)or error("rawivmodelinfo is nil",2);get_model_index=ffi.cast("get_model_index_t",ivmodelinfo[0][2])or error("get_model_info is nil",2);find_or_load_model=ffi.cast("find_or_load_model_t",ivmodelinfo[0][39])or error("find_or_load_model is nil",2);rawnetworkstringtablecontainer=client.create_interface("engine.dll","VEngineClientStringTable001")or error("VEngineClientStringTable001 wasnt found",2);networkstringtablecontainer=ffi.cast(class_ptr,rawnetworkstringtablecontainer)or error("rawnetworkstringtablecontainer is nil",2);find_table=ffi.cast("find_table_t",networkstringtablecontainer[0][3])or error("find_table is nil",2);

model_names = {}
model_names_ct = {}
general = {}

for k, _ in pairs(player_models) do
    table.insert(model_names, k)
end

for k, _ in pairs(player_models) do
    table.insert(model_names_ct, k)
end

function r_h(r, g, b, a)
    return bit.tohex(
    (math.floor(r + 0.5) * 16777216) +
    (math.floor(g + 0.5) * 65536) +
    (math.floor(b + 0.5) * 256) +
    (math.floor(a + 0.5))
    )
end

function animate_pulse(color, speed)
    r, g, b, a = unpack(color)

    c1 = r * math.abs(math.cos(globals.curtime()*speed))
    c2 = g * math.abs(math.cos(globals.curtime()*speed))
    c3 = b * math.abs(math.cos(globals.curtime()*speed))
    c4 = a * math.abs(math.cos(globals.curtime()*speed))

    return c1, c2, c3, c4
end

name = panorama.open().MyPersonaAPI.GetName()
r, g, b, a = animate_pulse({169, 79, 167, 255}, 6)

player_model_ct_check_Enable = ui.new_checkbox("LUA", "b", "Model Changer")

label6S = ui.new_label('LUA', 'b', '  ')

check_tabS = ui.new_combobox('LUA', 'b', '\aa94fa7FF~ Tab', "CT", "T")
label5S = ui.new_label('LUA', 'b', '  ')

player_model_ct_check = ui.new_checkbox("LUA", "b", "CT Override")
player_model_t_check = ui.new_checkbox("LUA", "b", "T Override")

player_model_ct_list = ui.new_listbox("LUA", "b", "? CT Model List", model_names_ct)
player_model_t_list = ui.new_listbox("LUA", "b", "? T Model List", model_names)

local name_modelss = ui.textbox("LUA", "a", "config name")





-- Функция управления видимостью элементов Solus
local function update_fog_visibilityssssSplus()
  local selected_water = ui.get(ms_watermark_enable)
  local selected_tab = ui.get(current_tab)
  local visuals_enabled = ui.get(visuals_checkbox)
  ui.set_visible(ms_watermark_enable, selected_tab == "Visuals" and visuals_enabled)
  ui.set_visible(ms_watermark, selected_tab == "Visuals" and selected_water and visuals_enabled)
  ui.set_visible(ms_spectators, selected_tab == "Visuals" and selected_water and visuals_enabled)
ui.set_visible(ms_keybinds, selected_tab == "Visuals" and selected_water and visuals_enabled)
ui.set_visible(ms_antiaim, selected_tab == "Visuals" and selected_water and visuals_enabled)
ui.set_visible(ms_lags_exploit, selected_tab == "Visuals"and selected_water and visuals_enabled)
  ui.set_visible(ms_ieinfo, selected_tab == "Visuals"and selected_water and visuals_enabled)
  ui.set_visible(glow_enabled, selected_tab == "Visuals"and selected_water and visuals_enabled)

  ui.set_visible(ms_palette, selected_tab == "Visuals"and selected_water and visuals_enabled)
  ui.set_visible(ms_color, selected_tab == "Visuals"and selected_water and visuals_enabled)
  ui.set_visible(ms_rainbow_frequency, selected_tab == "Visuals"and selected_water and visuals_enabled)
  ui.set_visible(ms_rainbow_split_ratio, selected_tab == "Visuals"and selected_water and visuals_enabled)

  end




-- Функция управления видимостью элементов SkyBoxChenge
local function update_fog_visibilityssssSky()
    local selected_Sky = ui.get(tScriptData.tMenuReferences.nMasterSwitchEnable)
    local selected_tab = ui.get(current_tab)
	local selected_tab_s = ui.get(zalupenko_enable)
    local visuals_enabled = ui.get(visuals_checkbox)
	ui.set_visible(tScriptData.tMenuReferences.nMasterSwitchEnable, selected_tab == "Visuals" and visuals_enabled)
    ui.set_visible(tScriptData.tMenuReferences.nPadding, selected_tab == "Visuals" and selected_Sky and visuals_enabled)
    ui.set_visible(tScriptData.tMenuReferences.nMasterSwitch, selected_tab == "Visuals" and selected_Sky and visuals_enabled)
	ui.set_visible(tScriptData.tMenuReferences.nSkyboxColor, selected_tab == "Visuals" and selected_Sky and visuals_enabled)
	ui.set_visible(tScriptData.tMenuReferences.nSkyboxList, selected_tab == "Visuals" and selected_Sky and visuals_enabled)
	ui.set_visible(tScriptData.tMenuReferences.nSkyboxColorChangeDelay, selected_tab == "Visuals"and selected_Sky and visuals_enabled)
    ui.set_visible(tScriptData.tMenuReferences.nSkyboxCheckInterval, selected_tab == "Visuals"and selected_Sky and visuals_enabled)
    ui.set_visible(tScriptData.tMenuReferences.nHide3dSkybox, selected_tab == "Visuals"and selected_Sky and visuals_enabled)
    end
-- Функция управления видимостью элементов Servers

local function update_fog_visibilityssss()
    local selected_fog = ui.get(L_12_)
    local selected_tab = ui.get(current_tab)
	local selected_tab_s = ui.get(zalupenko_enable)
    local rage_enabled = ui.get(rage_checkbox)
    local haxresolver_enabled = ui.get(rage_hax_resolver)
    local visuals_enabled = ui.get(visuals_checkbox)
    local misc_enabled = ui.get(misc_checkbox)
    local aspect_ratio_enabled = ui.get(aspect_ratio_checkbox)
    local thirdperson_enabled = ui.get(ThirdPerson)
    local viewmodel_enabled = ui.get(viewmodel_changer)
    local custom_scope_enabled = ui.get(master_switch)
    local custom_healthbar_enabled = ui.get(hpbar.customhealthbars)
    local bullet_tracer_enabled = ui.get(tracer)
    local hitchance_override_enabled = ui.get(feature.hitchance_override)
    local autobuy_enabled_state = ui.get(autobuy_enabled)
    local autobuy_cost_based_enabled = ui.get(autobuy_cost_based)

	ui.set_visible(zalupenko_enable, selected_tab == "Servers")
    ui.set_visible(zalupenko, selected_tab == "Servers" and selected_tab_s)
    ui.set_visible(Connects, selected_tab == "Servers" and selected_tab_s)
	ui.set_visible(Copyss, selected_tab == "Servers" and selected_tab_s)
	ui.set_visible(RetrySS, selected_tab == "Servers" and selected_tab_s)
	ui.set_visible(home_label_owned_s, selected_tab == "Home")
    end
   -- menu.enable = ui.new_checkbox('misc', 'settings', '\aFF89D0FFCheat Spoofer')
   -- menu.cheat = ui.new_combobox('misc', 'settings', 'Cheat', {


      -- Функция управления видимостью элементов HitMarker





      local ffi = require('ffi')

      function catch(what)
          return what[1]
      end
       
      function try(what)
          status, result = pcall(what[1])
          if not status then
              what[2](result)
          end
          return result
      end
      
      local revealer = { set_cheat = function(target, cheat) end }
      try {
          function()
              revealer = require('gamesense/cheat_revealer')
          end,
          function(err) end
      }
      
      local signatures = { }
      local natives = { }
      local modules = { }
      local constants = { }
      local procedures = { }
      local menu = { }
      local tools = { }
      local proteus = { }
      
      local timer = 0
      local ev0lve_counter = 0
      
      tools.uint32_to_bytes = function(uint32)
          local raw_addr = ffi.new('uint32_t[1]')
          raw_addr[0] = ffi.cast('uint32_t', uint32)
          return ffi.cast('const void*', raw_addr)
      end
      
      tools.uint32_to_number = function(uint32)
          return tonumber(ffi.cast('uint32_t', uint32))
      end
      
      proteus.send_fatality_voice_data = function()
          local base_voice_data = ffi.new('base_voice_data[1]')
          base_voice_data[0].current_len = 0
          base_voice_data[0].max_len = 15
      
          local msg_voice_data = ffi.new('CCLCMsg_VoiceData[1]')
          ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data, ffi.cast('void *', 0))
          natives.write_raw(ffi.cast('uint32_t', msg_voice_data) + 0x18, ffi.new('char[?]', 8, {0xFA, 0x7F, 0x00, 0x00, 0x9A, 0x9F, 0xEA, 0xFF}), 8)
          msg_voice_data[0].sequence_bytes = math.random(0, 0xFFFFFFF)
          msg_voice_data[0].section_number = math.random(0, 0xFFFFFFF)
          msg_voice_data[0].uncompressed_sample_offset = math.random(0, 0xFFFFFFF)
          msg_voice_data[0].data = base_voice_data
          msg_voice_data[0].format = 0
          msg_voice_data[0].flags = 63
      
          ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data), false, true)
      end
      
      proteus.send_rifk7_voice_data = function()
          local base_voice_data = ffi.new('base_voice_data[1]')
          base_voice_data[0].current_len = 0
          base_voice_data[0].max_len = 15
      
          local msg_voice_data = ffi.new('CCLCMsg_VoiceData[1]')
          ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data, ffi.cast('void *', 0))
          natives.write_raw(ffi.cast('uint32_t', msg_voice_data) + 0x18, ffi.new('char[?]', 8, {0x34, 0x01, 0x00, 0x00, 0x9A, 0x9F, 0xEA, 0xFF}), 8)
          msg_voice_data[0].sequence_bytes = math.random(0, 0xFFFFFFF)
          msg_voice_data[0].section_number = math.random(0, 0xFFFFFFF)
          msg_voice_data[0].uncompressed_sample_offset = math.random(0, 0xFFFFFFF)
          msg_voice_data[0].data = base_voice_data
          msg_voice_data[0].format = 0
          msg_voice_data[0].flags = 63
      
          ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data), false, true)
      end
      
      proteus.send_onetap_voice_data = function()
          local base_voice_data = ffi.new('base_voice_data[1]')
          base_voice_data[0].current_len = 0
          base_voice_data[0].max_len = 15
      
          local msg_voice_data = ffi.new('CCLCMsg_VoiceData[1]')
          ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data, ffi.cast('void *', 0))
          natives.write_raw(ffi.cast('uint32_t', msg_voice_data) + 0x18, ffi.new('char[?]', 8, {0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF}), 8)
          msg_voice_data[0].sequence_bytes = 0x33333333
          msg_voice_data[0].section_number = 0x22222222
          msg_voice_data[0].uncompressed_sample_offset = 0x11111111
          msg_voice_data[0].data = base_voice_data
          msg_voice_data[0].format = 0
          msg_voice_data[0].flags = 63
      
          ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data), false, true)
      end
      
      proteus.send_airflow_voice_data = function()
          local base_voice_data = ffi.new('base_voice_data[1]')
          base_voice_data[0].current_len = 0
          base_voice_data[0].max_len = 15
      
          local msg_voice_data = ffi.new('CCLCMsg_VoiceData[1]')
          ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data, ffi.cast('void *', 0))
          natives.write_raw(ffi.cast('uint32_t', msg_voice_data) + 0x18, ffi.new('char[?]', 8, {0xF1, 0xAF, 0x00, 0x00, 0x9A, 0x9F, 0xEA, 0xFF}), 8)
          msg_voice_data[0].sequence_bytes = math.random(0, 0xFFFFFFF)
          msg_voice_data[0].section_number = math.random(0, 0xFFFFFFF)
          msg_voice_data[0].uncompressed_sample_offset = math.random(0, 0xFFFFFFF)
          msg_voice_data[0].data = base_voice_data
          msg_voice_data[0].format = 0
          msg_voice_data[0].flags = 63
      
          ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data), false, true)
      end
      
      proteus.send_pandora_voice_data = function()
          local base_voice_data = ffi.new('base_voice_data[1]')
          base_voice_data[0].current_len = 0
          base_voice_data[0].max_len = 15
      
          local msg_voice_data = ffi.new('CCLCMsg_VoiceData[1]')
          ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data, ffi.cast('void *', 0))
          natives.write_raw(ffi.cast('uint32_t', msg_voice_data) + 0x18, ffi.new('char[?]', 8, {0x5B, 0x69, 0x00, 0x00, 0x9A, 0x9F, 0xEA, 0xFF}), 8)
          msg_voice_data[0].sequence_bytes = math.random(0, 0xFFFFFFF)
          msg_voice_data[0].section_number = math.random(0, 0xFFFFFFF)
          msg_voice_data[0].uncompressed_sample_offset = math.random(0, 0xFFFFFFF)
          msg_voice_data[0].data = base_voice_data
          msg_voice_data[0].format = 0
          msg_voice_data[0].flags = 63
      
          ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data), false, true)
      end
      
      proteus.send_nixware_voice_data = function()
          local base_voice_data = ffi.new('base_voice_data[1]')
          base_voice_data[0].current_len = 0
          base_voice_data[0].max_len = 15
      
          local msg_voice_data0 = ffi.new('CCLCMsg_VoiceData[1]')
          ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data0, ffi.cast('void *', 0))
          natives.write_virtual(ffi.cast('uint32_t', msg_voice_data0) + 0x18, {2, 0, 0, 0})
          msg_voice_data0[0].sequence_bytes = math.random(0, 0xFFFFFFF)
          msg_voice_data0[0].section_number = math.random(0, 0xFFFFFFF)
          msg_voice_data0[0].uncompressed_sample_offset = math.random(0, 0xFFFFFFF)
          msg_voice_data0[0].data = base_voice_data
          msg_voice_data0[0].format = 0
          msg_voice_data0[0].flags = 63
      
          ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data0), false, true)
      end
      
      proteus.send_plague_voice_data = function()
          local base_voice_data = ffi.new('base_voice_data[1]')
          base_voice_data[0].current_len = 0
          base_voice_data[0].max_len = 15
      
          local msg_voice_data0 = ffi.new('CCLCMsg_VoiceData[1]')
          ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data0, ffi.cast('void *', 0))
          natives.write_virtual(ffi.cast('uint32_t', msg_voice_data0) + 0x18, {math.random(0, 0xFF), math.random(0, 0xFF), math.random(0, 0xFF), math.random(0, 0xFF), math.random(0, 0xFF), math.random(0, 0xFF), math.random(0, 0xFF), math.random(0, 0xFF)})
          msg_voice_data0[0].sequence_bytes = math.random(0, 0xFFFFFFF)
          msg_voice_data0[0].section_number = math.random(0, 0xFFFFFFF)
          msg_voice_data0[0].uncompressed_sample_offset = 0x7275
          msg_voice_data0[0].data = base_voice_data
          msg_voice_data0[0].format = 0
          msg_voice_data0[0].flags = 63
      
          ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data0), false, true)
      end
      
      proteus.send_neverlose_voice_data = function()
          local base_voice_data = ffi.new('base_voice_data[1]')
          base_voice_data[0].current_len = 0
          base_voice_data[0].max_len = 15
      
          local msg_voice_data0 = ffi.new('CCLCMsg_VoiceData[1]')
          ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data0, ffi.cast('void *', 0))
          natives.write_virtual(ffi.cast('uint32_t', msg_voice_data0) + 0x18, {0, 1, 2, 3, 4, 5, 6, 7})
          msg_voice_data0[0].sequence_bytes = math.random(0, 0xFFFFFFF)
          msg_voice_data0[0].section_number = math.random(0, 0xFFFFFFF)
          msg_voice_data0[0].uncompressed_sample_offset = math.random(0, 0xFFFFFFF)
          msg_voice_data0[0].data = base_voice_data
          msg_voice_data0[0].format = 0
          msg_voice_data0[0].flags = 63
      
          ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data0), false, true)
      end
      
      proteus.send_ev0lve_voice_data = function(counter)
          local base_voice_data = ffi.new('base_voice_data[1]')
          base_voice_data[0].current_len = 0
          base_voice_data[0].max_len = 15
      
          local msg_voice_data0 = ffi.new('CCLCMsg_VoiceData[1]')
          ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data0, ffi.cast('void *', 0))
          natives.write_virtual(ffi.cast('uint32_t', msg_voice_data0) + 0x18, {2, 0, 0, 0, 2, 0, 0, 0})
          msg_voice_data0[0].sequence_bytes = math.random(0, 0xFFFFFFF)
          msg_voice_data0[0].section_number = math.random(0, 0xFFFFFFF)
          msg_voice_data0[0].uncompressed_sample_offset = math.random(0, 0xFFFFFFF)
          msg_voice_data0[0].data = base_voice_data
          msg_voice_data0[0].format = 0
          msg_voice_data0[0].flags = 63
      
          local msg_voice_data1 = ffi.new('CCLCMsg_VoiceData[1]')
          ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data1, ffi.cast('void *', 0))
          natives.write_virtual(ffi.cast('uint32_t', msg_voice_data1) + 0x18, {2, 0, 0, 0, 2, 0, 0, 0})
          msg_voice_data1[0].sequence_bytes = math.random(0, 0xFFFFFFF)
          msg_voice_data1[0].section_number = math.random(0, 0xFFFFFFF)
          msg_voice_data1[0].uncompressed_sample_offset = math.random(0, 0xFFFFFFF)
          msg_voice_data1[0].data = base_voice_data
          msg_voice_data1[0].format = 0
          msg_voice_data1[0].flags = 63
      
          local msg_voice_data2 = ffi.new('CCLCMsg_VoiceData[1]')
          ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data2, ffi.cast('void *', 0))
          natives.write_virtual(ffi.cast('uint32_t', msg_voice_data2) + 0x18, {2, 0, 0, 0, 2, 0, 0, 0})
          msg_voice_data2[0].sequence_bytes = math.random(0, 0xFFFFFFF)
          msg_voice_data2[0].section_number = math.random(0, 0xFFFFFFF)
          msg_voice_data2[0].uncompressed_sample_offset = math.random(0, 0xFFFFFFF)
          msg_voice_data2[0].data = base_voice_data
          msg_voice_data2[0].format = 0
          msg_voice_data2[0].flags = 63
      
          local msg_voice_data3 = ffi.new('CCLCMsg_VoiceData[1]')
          ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data3, ffi.cast('void *', 0))
          natives.write_virtual(ffi.cast('uint32_t', msg_voice_data3) + 0x18, {3, 0, 0, 0, 3, 0, 0, 0})
          msg_voice_data3[0].sequence_bytes = math.random(0, 0xFFFFFFF)
          msg_voice_data3[0].section_number = math.random(0, 0xFFFFFFF)
          msg_voice_data3[0].uncompressed_sample_offset = math.random(0, 0xFFFFFFF)
          msg_voice_data3[0].data = base_voice_data
          msg_voice_data3[0].format = 0
          msg_voice_data3[0].flags = 63
      
          local msg_voice_data4 = ffi.new('CCLCMsg_VoiceData[1]')
          ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data4, ffi.cast('void *', 0))
          natives.write_virtual(ffi.cast('uint32_t', msg_voice_data4) + 0x18, {3, 0, 0, 0, 3, 0, 0, 0})
          msg_voice_data4[0].sequence_bytes = math.random(0, 0xFFFFFFF)
          msg_voice_data4[0].section_number = math.random(0, 0xFFFFFFF)
          msg_voice_data4[0].uncompressed_sample_offset = math.random(0, 0xFFFFFFF)
          msg_voice_data4[0].data = base_voice_data
          msg_voice_data4[0].format = 0
          msg_voice_data4[0].flags = 63
      
          if ev0lve_counter == 0 then ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data0), false, true) end
          if ev0lve_counter == 1 then ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data1), false, true) end
          if ev0lve_counter == 2 then ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data2), false, true) end
          if ev0lve_counter == 3 then ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data3), false, true) end
          if ev0lve_counter == 4 then ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data4), false, true) end
      end
      
      local function init_signatures()
          ffi.cdef([[
              typedef struct i_net_channel_info { } i_net_channel_info;
              typedef struct c_net_message { } c_net_message;
      
              typedef bool( __fastcall *send_net_msg_t )( i_net_channel_info *, void *, c_net_message *, bool, bool );
              typedef uintptr_t( __thiscall *get_mod_address_t )( void *, const char * );
              typedef uintptr_t( __thiscall *get_proc_address_t )( void *, uintptr_t, const char * );
      
              typedef uintptr_t( __thiscall *virtual_alloc_t )( uintptr_t, uintptr_t, uintptr_t, uintptr_t, uintptr_t );
              typedef void *( __thiscall *virtual_protect_t )( uintptr_t, uintptr_t, uintptr_t, uint32_t, uint32_t * );
      
              typedef struct CCLCMsg_VoiceData
              {
                  uint32_t INetMessage_vtable;         // 0x0000
                  char pad_0004[ 4 ];                  // 0x0004
                  uint32_t CCLCMsg_VoiceData_vtable;   // 0x0008
                  char pad_000C[ 8 ];                  // 0x000C
                  void* data;                          // 0x0014
                  uint64_t xuid;                       // 0x0018
                  int32_t format;                      // 0x0020
                  int32_t sequence_bytes;              // 0x0024
                  uint32_t section_number;             // 0x0028
                  uint32_t uncompressed_sample_offset; // 0x002C
                  int32_t cached_size;                 // 0x0030
                  uint32_t flags;                      // 0x0034
                  char pad_0038[ 255 ];                // 0x0038
              } CCLCMsg_VoiceData;
      
              typedef struct CNetChannel
              {
                  int32_t vtable;                        // 0x0000 
                  void* msgbinder1;                      // 0x0004 
                  void* msgbinder2;
                  void* msgbinder3;
                  void* msgbinder4;
                  unsigned char m_bProcessingMessages;
                  unsigned char m_bShouldDelete;
                  char pad_0x0016[ 0x2 ];
                  int32_t m_nOutSequenceNr;
                  int32_t m_nInSequenceNr;
                  int32_t m_nOutSequenceNrAck;
                  int32_t m_nOutReliableState;
                  int32_t m_nInReliableState;
                  int32_t m_nChokedPackets;
                  char pad_0030[ 112 ];                  // 0x0030
                  int32_t m_Socket;                      // 0x009C
                  int32_t m_StreamSocket;                // 0x00A0
                  int32_t m_MaxReliablePayloadSize;      // 0x00A4
                  char remote_address[ 32 ];             // 0x00A8
                  char m_szRemoteAddressName[ 64 ];      // 0x00A8
                  float last_received;                   // 0x010C
                  float connect_time;                    // 0x0110
                  char pad_0114[ 4 ];                    // 0x0114
                  int32_t m_Rate;                        // 0x0118
                  char pad_011C[ 4 ];                    // 0x011C
                  float m_fClearTime;                    // 0x0120
                  char pad_0124[ 16688 ];                // 0x0124
                  char m_Name[ 32 ];                     // 0x4254
                  unsigned int m_ChallengeNr;            // 0x4274
                  float m_flTimeout;                     // 0x4278
                  char pad_427C[ 32 ];                   // 0x427C
                  float m_flInterpolationAmount;         // 0x429C
                  float m_flRemoteFrameTime;             // 0x42A0
                  float m_flRemoteFrameTimeStdDeviation; // 0x42A4
                  int32_t m_nMaxRoutablePayloadSize;     // 0x42A8
                  int32_t m_nSplitPacketSequence;        // 0x42AC
                  char pad_42B0[ 40 ];                   // 0x42B0
                  bool m_bIsValveDS;                     // 0x42D8
                  char pad_42D9[ 65 ];                   // 0x42D9
              } CNetChannel;
      
              typedef struct IClientState
              {
                  char pad_0000[ 0x9C ];         // 0x0000
                  CNetChannel* m_NetChannel;     // 0x009C
                  uint32_t m_nChallengeNr;       // 0x00A0
                  char pad_00A4[ 0x64 ];         // 0x00A4
                  uint32_t m_nSignonState;       // 0x0108
                  char pad_010C[ 0x8 ];          // 0x010C
                  float m_flNextCmdTime;         // 0x0114
                  uint32_t m_nServerCount;       // 0x0118
                  uint32_t m_nCurrentSequence;   // 0x011C
                  char pad_0120[ 4 ];            // 0x0120
                  char m_ClockDriftMgr[ 0x50 ];  // 0x0124
                  int32_t m_nDeltaTick;          // 0x0174
                  bool m_bPaused;                // 0x0178
                  char pad_0179[ 7 ];            // 0x0179
                  uint32_t m_nViewEntity;        // 0x0180
                  uint32_t m_nPlayerSlot;        // 0x0184
                  char m_szLevelName[ 260 ];     // 0x0188
                  char m_szLevelNameShort[ 40 ]; // 0x028C
                  char m_szGroupName[ 40 ];      // 0x02B4
                  char pad_02DC[ 52 ];           // 0x02DC
                  uint32_t m_nMaxClients;        // 0x0310
                  char pad_0314[ 18820 ];        // 0x0314
                  float m_flLastServerTickTime;  // 0x4C98
                  bool insimulation;             // 0x4C9C
                  char pad_4C9D[ 3 ];            // 0x4C9D
                  uint32_t oldtickcount;         // 0x4CA0
                  float m_tickRemainder;         // 0x4CA4
                  float m_frameTime;             // 0x4CA8
                  char pad_4CAC[ 0x78 ];         // 0x4CAC
                  char temp[ 0x8 ];              // 0x4CAC
                  int32_t lastoutgoingcommand;   // 0x4CAC
                  int32_t chokedcommands;        // 0x4CB0
                  int32_t last_command_ack;      // 0x4CB4
                  int32_t last_server_tick;      // 0x4CB8
                  int32_t command_ack;           // 0x4CBC
                  char pad_4CC0[ 80 ];           // 0x4CC0
                  char viewangles[ 0xC ];        // 0x4D10
                  char pad_4D14[ 0xD0 ];         // 0x4D1C
                  void* m_Events;                // 0x4DEC
              } IClientState;
      
              typedef struct base_voice_data
              {
                  char data[ 16 ];
                  uint32_t current_len;
                  uint32_t max_len;
              } base_voice_data;
      
              typedef struct voice_usable_fields
              {
                  uint64_t xuid;
                  int32_t sequence_bytes;
                  uint32_t section_number;
                  uint32_t uncompressed_sample_offset;
              } voice_usable_fields;
      
              typedef struct fatality_shared_esp_data
              {
                  uint16_t identifier;
                  uint8_t user_id;
                  uint8_t weapon_id;
                  uint32_t server_tick;
                  char pos[ 12 ];
              } fatality_shared_esp_data;
          
              typedef uint32_t( __fastcall *msg_voicedata_constructor )( CCLCMsg_VoiceData *, void * );
          ]])
      
          signatures.send_net_msg = client.find_signature('engine.dll', string.char(0x55, 0x8B, 0xEC, 0x83, 0xEC, 0x08, 0x56, 0x8B, 0xF1, 0x8B, 0x4D, 0x04))
          assert(tonumber(ffi.cast('uint32_t', signatures.send_net_msg)) ~= 0, 'Failed to find pattern \"send_net_msg\"')
      
          signatures.voicedata_constructor = client.find_signature('engine.dll', string.char(0xC6, 0x46, 0xCC, 0xCC, 0x5E, 0xC3, 0x56, 0x57, 0x8B, 0xF9, 0x8D, 0x4F, 0xCC, 0xC7, 0x07, 0xCC, 0xCC, 0xCC, 0xCC, 0xE8))
          signatures.voicedata_constructor = ffi.cast('uint32_t', signatures.voicedata_constructor) + 6
          assert(tonumber(ffi.cast('uint32_t', signatures.voicedata_constructor)) ~= 6, 'Failed to find pattern \"voicedata_constructor\"')
      
          signatures.client_state = client.find_signature('engine.dll', string.char(0xA1, 0xCC, 0xCC, 0xCC, 0xCC, 0x8B, 0x80, 0xCC, 0xCC, 0xCC, 0xCC, 0xC3)) or error('Failed to find pattern \"client_state\"')
          signatures.client_state = ffi.cast('IClientState ***', ffi.cast('uint32_t', signatures.client_state) + 1)[0][0]
      
          signatures.get_mod_address = client.find_signature('client.dll', string.char(0xC6, 0x06, 0x00, 0xFF, 0x15, 0xCC, 0xCC, 0xCC, 0xCC, 0x50))
          assert(tonumber(ffi.cast('uint32_t', signatures.get_mod_address)) ~= 0, 'Failed to find pattern \"get_mod_address\"')
      
          signatures.get_proc_address = client.find_signature('client.dll', string.char(0x50, 0xFF, 0x15, 0xCC, 0xCC, 0xCC, 0xCC, 0x85, 0xC0, 0x0F, 0x84, 0xCC, 0xCC, 0xCC, 0xCC, 0x6A, 0x00))
          assert(tonumber(ffi.cast('uint32_t', signatures.get_proc_address)) ~= 0, 'Failed to find pattern \"get_proc_address\"')
      
          signatures.call_stub = client.find_signature("client.dll", string.char(0x51, 0xC3))
          assert(tonumber(ffi.cast('uint32_t', signatures.call_stub)) ~= 0, 'Failed to find pattern \"call_stub\"')
      end
      
      local function init_natives()
          natives.send_net_msg = ffi.cast('send_net_msg_t', signatures.send_net_msg)
          natives.get_mod_address = ffi.cast('void***', ffi.cast('char*', signatures.get_mod_address) + 5)[0][0]
          natives.get_proc_address = ffi.cast('void***', ffi.cast('char*', signatures.get_proc_address) + 3)[0][0]
      
          natives.virtual_alloc = function(address, size, memtype, protect)
              return ffi.cast('virtual_alloc_t', signatures.call_stub)(procedures.virtual_alloc, address, size, memtype, protect)
          end
          natives.virtual_protect = function(address, size, new_prot, old_prot)
              return ffi.cast('virtual_protect_t', signatures.call_stub)(procedures.virtual_protect, address, size, new_prot, old_prot)
          end
      
          natives.write_virtual = function(dest, bytes)
              local old_prot = ffi.new('uint32_t[1]')
              natives.virtual_protect(ffi.cast('uintptr_t', dest), #bytes, constants.PAGE_EXECUTE_READWRITE, old_prot)
              ffi.copy(ffi.cast('void*', dest), ffi.new('char[?]', #bytes, bytes), #bytes)
              natives.virtual_protect(ffi.cast('uintptr_t', dest), #bytes, old_prot[0], old_prot)
          end
          natives.write_raw = function(dest, rawbuf, len)
              local old_prot = ffi.new('uint32_t[1]')
              natives.virtual_protect(ffi.cast('uintptr_t', dest), len, constants.PAGE_EXECUTE_READWRITE, old_prot)
              ffi.copy(ffi.cast('void*', dest), rawbuf, len)
              natives.virtual_protect(ffi.cast('uintptr_t', dest), len, old_prot[0], old_prot)
          end
          natives.read_virtual = function(dest, buf, len)
              ffi.copy(ffi.cast('void*', buf), ffi.cast('const void*', dest), len)
          end
      end
      
      local function init_modules()
          modules.kernel32 = ffi.cast('get_mod_address_t', signatures.call_stub)(natives.get_mod_address, 'kernel32.dll')
          assert(tonumber(ffi.cast('uint32_t', modules.kernel32)) ~= 0, 'Failed to find module \"kernel32.dll\"')
      
          modules.ucrtbase = ffi.cast('get_mod_address_t', signatures.call_stub)(natives.get_mod_address, 'ucrtbase.dll')
          assert(tonumber(ffi.cast('uint32_t', modules.ucrtbase)) ~= 0, 'Failed to find module \"ucrtbase.dll\"')
      end
      
      local function init_procedures()
          procedures.virtual_alloc = ffi.cast('get_proc_address_t', signatures.call_stub)(natives.get_proc_address, modules.kernel32, 'VirtualAlloc')
          procedures.virtual_protect = ffi.cast('get_proc_address_t', signatures.call_stub)(natives.get_proc_address, modules.kernel32, 'VirtualProtect')
      end
      
      local function init_constants()
          constants.MEM_COMMIT = 0x1000
          constants.MEM_RESERVE = 0x2000
          constants.PAGE_EXECUTE = 0x10
          constants.PAGE_EXECUTE_READ = 0x20
          constants.PAGE_EXECUTE_READWRITE = 0x40
          constants.PAGE_EXECUTE_WRITECOPY = 0x80
          constants.PAGE_NOACCESS = 0x1
          constants.PAGE_READONLY = 0x2
          constants.PAGE_READWRITE = 0x4
          constants.PAGE_WRITECOPY = 0x8
      end
      
      local function init_menu()
          menu.enable = ui.new_checkbox('lua', 'b', 'Cheat Spoofer')
          menu.cheat = ui.new_combobox('lua', 'b', 'Cheat', {
              'anonymous',
              '\aC1C1C1FFgame\a9FCA2BFFsense',
              '\aEC4B82FFfatality',
              '\a7D68BDFFairflow',
              '\aFFFFFFFFnixware',
              '\a0095B9FFneverlose',
              '\aC09DFCFFpandora',
              '\aF7A414FFonetap',
              '\a00F300FFrifk\aFF00FFFF7',
              '\a6BFF87FFplague',
              '\a3ABBFFFFev0lve'
          })
      end
      
      local function init()
          init_signatures()
          init_natives()
          init_modules()
          init_procedures()
          init_constants()
          init_menu()

      end
      
      init()
      
      client.set_event_callback('net_update_start', function()
          if not ui.get(menu.enable) then
              return
          end
      
          if timer > globals.curtime() then
              return
          end
      
          local shared_esp = ui.reference('visuals', 'other esp', 'shared esp')
      
          local cheat = ui.get(menu.cheat)
          if cheat == 'anonymous' then

              revealer.set_cheat(entity.get_local_player(), 'wh')
              return
          elseif cheat == '\aC1C1C1FFgame\a9FCA2BFFsense' then
              revealer.set_cheat(entity.get_local_player(), 'gs')
              return
          elseif cheat == '\aEC4B82FFfatality' then

              proteus.send_fatality_voice_data()
              revealer.set_cheat(entity.get_local_player(), 'ft')
          elseif cheat == '\a7D68BDFFairflow' then

              proteus.send_airflow_voice_data()
              revealer.set_cheat(entity.get_local_player(), 'af')
          elseif cheat == '\aFFFFFFFFnixware' then

              proteus.send_nixware_voice_data()
              revealer.set_cheat(entity.get_local_player(), 'nw')
          elseif cheat == '\aF7A414FFonetap' then

              proteus.send_onetap_voice_data()
              revealer.set_cheat(entity.get_local_player(), 'ot')
          elseif cheat == '\aC09DFCFFpandora' then

              proteus.send_pandora_voice_data()
              revealer.set_cheat(entity.get_local_player(), 'pd')
          elseif cheat == '\a00F300FFrifk\aFF00FFFF7' then

              proteus.send_rifk7_voice_data()
              revealer.set_cheat(entity.get_local_player(), 'r7')
          elseif cheat == '\a6BFF87FFplague' then

              proteus.send_plague_voice_data()
              revealer.set_cheat(entity.get_local_player(), 'pl')
          elseif cheat == '\a3ABBFFFFev0lve' then

              proteus.send_ev0lve_voice_data()
              revealer.set_cheat(entity.get_local_player(), 'ev')
          elseif cheat == '\a0095B9FFneverlose' then

              proteus.send_neverlose_voice_data()
              revealer.set_cheat(entity.get_local_player(), 'nl2')
          end
      
          ev0lve_counter = ev0lve_counter + 1
          if ev0lve_counter >= 5 then ev0lve_counter = 0 end
      
          timer = globals.curtime() + 0.5
      end)
      
      client.set_event_callback('game_newmap', function()
          timer = 0
          ev0lve_counter = 0
      end)
      
      client.set_event_callback('game_start', function()
          timer = 0
          ev0lve_counter = 0
      end)
      
      client.set_event_callback('round_start', function()
          timer = 0
          ev0lve_counter = 0
      end)
      
      client.set_event_callback('shutdown', function()
      
      --p    ui.set_visible(shared_esp, true)
      end)
      
  function update_fog_visibilityssCheat()
  local selected_fog = ui.get(L_12_)
  local selected_tab = ui.get(current_tab)
  local rage_enabled = ui.get(rage_checkbox)
  local haxresolver_enabled = ui.get(rage_hax_resolver)
  local visuals_enabled = ui.get(visuals_checkbox)
  local misc_enabled = ui.get(misc_checkbox)
  local aspect_ratio_enabled = ui.get(aspect_ratio_checkbox)
  local thirdperson_enabled = ui.get(ThirdPerson)
  local viewmodel_enabled = ui.get(viewmodel_changer)
  local custom_scope_enabled = ui.get(master_switch)
  local custom_healthbar_enabled = ui.get(hpbar.customhealthbars)
  local bullet_tracer_enabled = ui.get(tracer)
  local hitchance_override_enabled = ui.get(feature.hitchance_override)
  local autobuy_enabled_state = ui.get(autobuy_enabled)
  local autobuy_cost_based_enabled = ui.get(autobuy_cost_based)

  ui.set_visible(menu.enable, selected_tab == "Misc" and misc_enabled )
  ui.set_visible(menu.cheat, selected_tab == "Misc" and misc_enabled and ui.get(menu.enable) )

  end
-- Функция управления видимостью элементов HitMarker

local function update_fog_visibilityss()
    local selected_fog = ui.get(L_12_)
    local selected_tab = ui.get(current_tab)
    local rage_enabled = ui.get(rage_checkbox)
    local haxresolver_enabled = ui.get(rage_hax_resolver)
    local visuals_enabled = ui.get(visuals_checkbox)
    local misc_enabled = ui.get(misc_checkbox)
    local aspect_ratio_enabled = ui.get(aspect_ratio_checkbox)
    local thirdperson_enabled = ui.get(ThirdPerson)
    local viewmodel_enabled = ui.get(viewmodel_changer)
    local custom_scope_enabled = ui.get(master_switch)
    local custom_healthbar_enabled = ui.get(hpbar.customhealthbars)
    local bullet_tracer_enabled = ui.get(tracer)
    local hitchance_override_enabled = ui.get(feature.hitchance_override)
    local autobuy_enabled_state = ui.get(autobuy_enabled)
    local autobuy_cost_based_enabled = ui.get(autobuy_cost_based)

    ui.set_visible(HitMarker_checkbox, selected_tab == "Visuals" and visuals_enabled )
    ui.set_visible(HitMarker_tab, selected_tab == "Visuals" and visuals_enabled and ui.get(HitMarker_checkbox))

    end

-- Функция управления видимостью элементов Fog

local function update_fog_visibility()

    local selected_fog = ui.get(L_12_)
    local selected_tab = ui.get(current_tab)
    local rage_enabled = ui.get(rage_checkbox)
    local haxresolver_enabled = ui.get(rage_hax_resolver)
    local visuals_enabled = ui.get(visuals_checkbox)
    local misc_enabled = ui.get(misc_checkbox)
    local aspect_ratio_enabled = ui.get(aspect_ratio_checkbox)
    local thirdperson_enabled = ui.get(ThirdPerson)
    local viewmodel_enabled = ui.get(viewmodel_changer)
    local custom_scope_enabled = ui.get(master_switch)
    local custom_healthbar_enabled = ui.get(hpbar.customhealthbars)
    local bullet_tracer_enabled = ui.get(tracer)
    local hitchance_override_enabled = ui.get(feature.hitchance_override)
    local autobuy_enabled_state = ui.get(autobuy_enabled)
    local autobuy_cost_based_enabled = ui.get(autobuy_cost_based)


    ui.set_visible(L_12_, selected_tab == "Visuals" and visuals_enabled)
    ui.set_visible(L_13_, selected_tab == "Visuals" and visuals_enabled and selected_fog)
    ui.set_visible(L_14_, selected_tab == "Visuals" and visuals_enabled and selected_fog)
    ui.set_visible(L_15_, selected_tab == "Visuals" and visuals_enabled and selected_fog)
    ui.set_visible(L_16_, selected_tab == "Visuals" and visuals_enabled and selected_fog)
end

-- Функция управления видимостью элементов Autobuy
local function handle_autobuy_visibility()
    local state = ui.get(autobuy_enabled)
    local state2 = (not ui.get(autobuy_hide))
    local state3 = ui.get(autobuy_cost_based)

    ui.set_visible(autobuy_hide, state)

    if state and state2 then
        ui.set_visible(autobuy_primary, state)
        ui.set_visible(autobuy_secondary, state)
        ui.set_visible(autobuy_grenades, state)
        ui.set_visible(autobuy_utilities, state)
        ui.set_visible(autobuy_cost_based, state)
        ui.set_visible(autobuy_threshold, state3)
        ui.set_visible(autobuy_primary_2, state3)
        ui.set_visible(autobuy_secondary_2, state3)
        ui.set_visible(autobuy_grenades_2, state3)
        ui.set_visible(autobuy_utilities_2, state3)
    elseif not state2 then
        ui.set_visible(autobuy_primary, state2)
        ui.set_visible(autobuy_secondary, state2)
        ui.set_visible(autobuy_grenades, state2)
        ui.set_visible(autobuy_utilities, state2)
        ui.set_visible(autobuy_cost_based, state2)
        ui.set_visible(autobuy_threshold, state2)
        ui.set_visible(autobuy_primary_2, state2)
        ui.set_visible(autobuy_secondary_2, state2)
        ui.set_visible(autobuy_grenades_2, state2)
        ui.set_visible(autobuy_utilities_2, state2)
    else
        ui.set_visible(autobuy_primary, state)
        ui.set_visible(autobuy_secondary, state)
        ui.set_visible(autobuy_grenades, state)
        ui.set_visible(autobuy_utilities, state)
        ui.set_visible(autobuy_cost_based, state)
        ui.set_visible(autobuy_threshold, state)
        ui.set_visible(autobuy_primary_2, state)
        ui.set_visible(autobuy_secondary_2, state)
        ui.set_visible(autobuy_grenades_2, state)
        ui.set_visible(autobuy_utilities_2, state)
    end
end

-- Функция для подсчёта стоимости покупок Autobuy
local function get_weapon_prices()
    local total_price = 0
    -- Utilities
    local utility_purchase = ui.get(autobuy_utilities)
    for i = 1, #utility_purchase do
        local n = utility_purchase[i]
        for k, v in pairs(prices) do
            if k == n then
                total_price = total_price + v
            end
        end
    end

    -- Secondary
    for k, v in pairs(prices) do
        if k == ui.get(autobuy_secondary) then
            total_price = total_price + v
        end
    end

    -- Primary
    for k, v in pairs(prices) do
        if k == ui.get(autobuy_primary) then
            total_price = total_price + v
        end
    end

    -- Grenades
    local grenade_purchase = ui.get(autobuy_grenades)
    for i = 1, #grenade_purchase do
        local n = grenade_purchase[i]
        for k, v in pairs(prices) do
            if k == n then
                total_price = total_price + v
            end
        end
    end
    return total_price
end

-- Функции для ограничения количества гранат
local function grenade_limit_callback()
    local total_nades = ui.get(autobuy_grenades)
    if #total_nades > 4 then
        ui.set(autobuy_grenades, logged_grenades)
        return
    end
    logged_grenades = total_nades
end

local function grenade_limit_callback_2()
    local total_nades = ui.get(autobuy_grenades_2)
    if #total_nades > 4 then
        ui.set(autobuy_grenades_2, logged_grenades_2)
        return
    end
    logged_grenades_2 = total_nades
end


-- Функция для обновления видимости вкладок
local function update_tab_visibility()
    local selected_fog = ui.get(L_12_)
    local selected_tab = ui.get(current_tab)
    local rage_enabled = ui.get(rage_checkbox)
    local haxresolver_enabled = ui.get(rage_hax_resolver)
    local visuals_enabled = ui.get(visuals_checkbox)
    local misc_enabled = ui.get(misc_checkbox)
    local aspect_ratio_enabled = ui.get(aspect_ratio_checkbox)
    local thirdperson_enabled = ui.get(ThirdPerson)
    local viewmodel_enabled = ui.get(viewmodel_changer)
    local custom_scope_enabled = ui.get(master_switch)
    local custom_healthbar_enabled = ui.get(hpbar.customhealthbars)
    local bullet_tracer_enabled = ui.get(tracer)
    local hitchance_override_enabled = ui.get(feature.hitchance_override)
    local autobuy_enabled_state = ui.get(autobuy_enabled)
    local autobuy_cost_based_enabled = ui.get(autobuy_cost_based)

    -- Вкладка Home (без чекбокса, элементы отображаются сразу)
    ui.set_visible(home_label_welcome, selected_tab == "Home")
    ui.set_visible(home_label_version, selected_tab == "Home")
    ui.set_visible(home_label_owned, selected_tab == "Home")

    ui.set_visible(label1, selected_tab == "Home")
    ui.set_visible(label2, selected_tab == "Home")
    ui.set_visible(label3, selected_tab == "Home")
    --Вкладка Fog

    -- Вкладка Rage
    ui.set_visible(rage_checkbox, selected_tab == "Rage")
    -- HaxResolver элементы (в начале)
    ui.set_visible(rage_hax_resolver, selected_tab == "Rage" and rage_enabled)
    ui.set_visible(b_2.rage.predict, selected_tab == "Rage" and rage_enabled and haxresolver_enabled)
    ui.set_visible(b_2.rage.pingpos, selected_tab == "Rage" and rage_enabled and haxresolver_enabled and ui.get(b_2.rage.predict))
    ui.set_visible(b_2.rage.jittercorrectionresolver, selected_tab == "Rage" and rage_enabled and haxresolver_enabled)
    ui.set_visible(b_2.rage.interesting, selected_tab == "Rage" and rage_enabled and haxresolver_enabled)
    -- Остальные элементы Rage
    ui.set_visible(rage_dormant_aimbot, selected_tab == "Rage" and rage_enabled)
    ui.set_visible(rage_dormant_key, selected_tab == "Rage" and rage_enabled and ui.get(rage_dormant_aimbot))
    ui.set_visible(rage_dormant_mindmg, selected_tab == "Rage" and rage_enabled and ui.get(rage_dormant_aimbot))
    ui.set_visible(rage_dormant_indicator, selected_tab == "Rage" and rage_enabled and ui.get(rage_dormant_aimbot))
    ui.set_visible(unsafe_crage_in_air, selected_tab == "Rage" and rage_enabled)
    -- Hitchance Override элементы (упрощённая версия)
    ui.set_visible(feature.hitchance_override, selected_tab == "Rage" and rage_enabled)
    ui.set_visible(feature.hit_chance_ovr, selected_tab == "Rage" and rage_enabled and hitchance_override_enabled)
    ui.set_visible(feature.hc_ovr_key, selected_tab == "Rage" and rage_enabled and hitchance_override_enabled)


    -- Вкладка Visuals
    ui.set_visible(visuals_checkbox, selected_tab == "Visuals")
    ui.set_visible(aspect_ratio_checkbox, selected_tab == "Visuals" and visuals_enabled)
    ui.set_visible(aspect_ratio_reference, selected_tab == "Visuals" and visuals_enabled and aspect_ratio_enabled)
    ui.set_visible(ThirdPerson, selected_tab == "Visuals" and visuals_enabled)
    ui.set_visible(ThirdPersonDistance, selected_tab == "Visuals" and visuals_enabled and thirdperson_enabled)
    ui.set_visible(ThirdPersonZoomSpeed, selected_tab == "Visuals" and visuals_enabled and thirdperson_enabled)
    ui.set_visible(viewmodel_changer, selected_tab == "Visuals" and visuals_enabled)
    ui.set_visible(viewmodel_fov, selected_tab == "Visuals" and visuals_enabled and viewmodel_enabled)
    ui.set_visible(viewmodel_offset_x, selected_tab == "Visuals" and visuals_enabled and viewmodel_enabled)
    ui.set_visible(viewmodel_offset_y, selected_tab == "Visuals" and visuals_enabled and viewmodel_enabled)
    ui.set_visible(viewmodel_offset_z, selected_tab == "Visuals" and visuals_enabled and viewmodel_enabled)

    -- Вкладка Misc
    ui.set_visible(misc_checkbox, selected_tab == "Misc")
    ui.set_visible(master_switch, selected_tab == "Misc" and misc_enabled)
    ui.set_visible(color_picker, selected_tab == "Misc" and misc_enabled and custom_scope_enabled)
    ui.set_visible(overlay_position, selected_tab == "Misc" and misc_enabled and custom_scope_enabled)
    ui.set_visible(overlay_offset, selected_tab == "Misc" and misc_enabled and custom_scope_enabled)
    ui.set_visible(fade_time, selected_tab == "Misc" and misc_enabled and custom_scope_enabled)
    ui.set_visible(hpbar.customhealthbars, selected_tab == "Misc" and misc_enabled)
    ui.set_visible(hpbar.gradient, selected_tab == "Misc" and misc_enabled and custom_healthbar_enabled)
    ui.set_visible(hpbar.label, selected_tab == "Misc" and misc_enabled and custom_healthbar_enabled)
    ui.set_visible(hpbar.colorpicker, selected_tab == "Misc" and misc_enabled and custom_healthbar_enabled)
    ui.set_visible(hpbar.label2, selected_tab == "Misc" and misc_enabled and custom_healthbar_enabled)
    ui.set_visible(hpbar.colorpicker2, selected_tab == "Misc" and misc_enabled and custom_healthbar_enabled)
    ui.set_visible(tracer, selected_tab == "Misc" and misc_enabled)
    ui.set_visible(tracer_color, selected_tab == "Misc" and misc_enabled and bullet_tracer_enabled)
    -- Autobuy элементы
    ui.set_visible(autobuy_enabled, selected_tab == "Misc" and misc_enabled)
    ui.set_visible(autobuy_hide, selected_tab == "Misc" and misc_enabled and autobuy_enabled_state)
    ui.set_visible(autobuy_primary, selected_tab == "Misc" and misc_enabled and autobuy_enabled_state and (not ui.get(autobuy_hide)))
    ui.set_visible(autobuy_secondary, selected_tab == "Misc" and misc_enabled and autobuy_enabled_state and (not ui.get(autobuy_hide)))
    ui.set_visible(autobuy_grenades, selected_tab == "Misc" and misc_enabled and autobuy_enabled_state and (not ui.get(autobuy_hide)))
    ui.set_visible(autobuy_utilities, selected_tab == "Misc" and misc_enabled and autobuy_enabled_state and (not ui.get(autobuy_hide)))
    ui.set_visible(autobuy_cost_based, selected_tab == "Misc" and misc_enabled and autobuy_enabled_state and (not ui.get(autobuy_hide)))
    ui.set_visible(autobuy_threshold, selected_tab == "Misc" and misc_enabled and autobuy_enabled_state and autobuy_cost_based_enabled and (not ui.get(autobuy_hide)))
    ui.set_visible(autobuy_primary_2, selected_tab == "Misc" and misc_enabled and autobuy_enabled_state and autobuy_cost_based_enabled and (not ui.get(autobuy_hide)))
    ui.set_visible(autobuy_secondary_2, selected_tab == "Misc" and misc_enabled and autobuy_enabled_state and autobuy_cost_based_enabled and (not ui.get(autobuy_hide)))
    ui.set_visible(autobuy_grenades_2, selected_tab == "Misc" and misc_enabled and autobuy_enabled_state and autobuy_cost_based_enabled and (not ui.get(autobuy_hide)))
    ui.set_visible(autobuy_utilities_2, selected_tab == "Misc" and misc_enabled and autobuy_enabled_state and autobuy_cost_based_enabled and (not ui.get(autobuy_hide)))
end
-- Регистрация callback-ов для управления видимостью Fog

client.set_event_callback("paint_ui", function()
    update_fog_visibility()
    update_fog_visibilitys()
    update_fog_visibilityss()
	update_fog_visibilityssss()
    update_fog_visibilityssssSky()
    update_fog_visibilityssssSplus()
    update_fog_visibilityssCheat()
   -- ui.set_visible(name_modelss, selected_tab == "Visuals" and visuals_enabled and ui.get(player_model_ct_check_Enable))
end)
-- Регистрация callback-ов для управления видимостью HaxResolver
ui.set_callback(rage_hax_resolver, update_haxresolver_visibility)
ui.set_callback(b_2.rage.predict, update_haxresolver_visibility)
ui.set_callback(b_2.rage.jittercorrectionresolver, update_haxresolver_visibility)
ui.set_callback(b_2.rage.interesting, update_haxresolver_visibility)

-- Регистрация callback-ов для Autobuy
ui.set_callback(autobuy_enabled, handle_autobuy_visibility)
ui.set_callback(autobuy_hide, handle_autobuy_visibility)
ui.set_callback(autobuy_cost_based, handle_autobuy_visibility)
ui.set_callback(autobuy_grenades, grenade_limit_callback)
ui.set_callback(autobuy_grenades_2, grenade_limit_callback_2)

-- Функция predict для настройки интерполяции
local function predict()
    local lp = entity.get_local_player()
    if not lp or not entity.is_alive(lp) then return end

    if ui.get(rage_hax_resolver) and ui.get(b_2.rage.predict) then
        if ui.get(b_2.rage.pingpos) == "Low Ping" then
            cvar.cl_interpolate:set_int(0)
            cvar.cl_interp_ratio:set_int(1)
            cvar.cl_interp:set_float(0.015)
        else
            cvar.cl_interpolate:set_int(0)
            cvar.cl_interp_ratio:set_int(2)
            cvar.cl_interp:set_float(0.031)
        end

        -- Если включена коррекция джиттера, увеличиваем cl_interp_ratio
        if ui.get(b_2.rage.jittercorrectionresolver) then
            cvar.cl_interp_ratio:set_int(3)
        end
    else
        cvar.cl_interp:set_float(0.016)
        cvar.cl_interp_ratio:set_int(1)
        cvar.cl_interpolate:set_int(0)
    end
end

-- Функция для управления запоминанием и восстановлением Minimum hit chance
local function handle_hitchance_override()
    if ui.get(feature.hitchance_override) then
        -- Запоминаем текущее значение Minimum hit chance при включении
        original_hc_value = ui.get(hc_ref)
    else
        -- Восстанавливаем исходное значение Minimum hit chance при отключении
        ui.set(hc_ref, original_hc_value)
    end
    update_tab_visibility() -- Обновляем видимость
end

ui.set_callback(feature.hitchance_override, handle_hitchance_override)

-- Aspect Ratio функции
local function set_aspect_ratio(aspect_ratio_multiplier)
    local screen_width, screen_height
    if client_screen_size then
        screen_width, screen_height = client_screen_size()
    else
        screen_width, screen_height = 1920, 1080
    end
    local aspectratio_value = (screen_width * aspect_ratio_multiplier) / screen_height
    if aspect_ratio_multiplier == 1 then
        aspectratio_value = 0
    end
    cvar.r_aspectratio:set_float(tonumber(aspectratio_value))
end

local function on_aspect_ratio_changed()
    local aspect_ratio = ui.get(aspect_ratio_reference) * 0.01
    aspect_ratio = 2 - aspect_ratio
    set_aspect_ratio(aspect_ratio)
end

-- Thirdperson функции
local function thirdperson_main()
    if not entity_get_local_player() then return end

    if ui.get(ThirdPerson) then
        if ui.get(ThirdPerson_Ref[1]) and ui.get(ThirdPerson_Ref[2]) then
            local target_distance = ui.get(ThirdPersonDistance)
            local zoom_speed = ui.get(ThirdPersonZoomSpeed)

            if zoom_speed == 0 then
                current_distance = target_distance
            else
                local delta = (target_distance - current_distance) / zoom_speed

                if delta > 0 and current_distance < target_distance then
                    current_distance = current_distance + delta
                elseif delta < 0 and current_distance > target_distance then
                    current_distance = current_distance + delta
                end
            end

            cvar.c_mindistance:set_float(current_distance)
            cvar.c_maxdistance:set_float(current_distance)
        else
            current_distance = 30
        end
    else
        cvar.c_mindistance:set_float(100)
        cvar.c_maxdistance:set_float(100)
    end
end

local function thirdperson_shutdown()
    cvar.c_mindistance:set_float(100)
    cvar.c_maxdistance:set_float(100)
end

-- Viewmodel Changer функции
local function set_viewmodel(fov, x, y, z)
    cvar_fov:set_raw_float(fov * 0.1)
    cvar_offset_x:set_raw_float(x * 0.1)
    cvar_offset_y:set_raw_float(y * 0.1)
    cvar_offset_z:set_raw_float(z * 0.1)
end

local function handle_viewmodel()
    local offset_fov    = ui.get(viewmodel_fov)
    local offset_x      = ui.get(viewmodel_offset_x)
    local offset_y      = ui.get(viewmodel_offset_y)
    local offset_z      = ui.get(viewmodel_offset_z)
    set_viewmodel(offset_fov, offset_x, offset_y, offset_z)
end

ui.set_callback(viewmodel_fov, handle_viewmodel)
ui.set_callback(viewmodel_offset_x, handle_viewmodel)
ui.set_callback(viewmodel_offset_y, handle_viewmodel)
ui.set_callback(viewmodel_offset_z, handle_viewmodel)

local function handle_viewmodel_menu()
    local state = ui.get(viewmodel_changer)
    ui.set_visible(viewmodel_fov, state)
    ui.set_visible(viewmodel_offset_x, state)
    ui.set_visible(viewmodel_offset_y, state)
    ui.set_visible(viewmodel_offset_z, state)
    if not state then
        set_viewmodel(default_fov, default_offset_x, default_offset_y, default_offset_z)
    else
        handle_viewmodel()
    end
end

handle_viewmodel_menu()
ui.set_callback(viewmodel_changer, handle_viewmodel_menu)

-- Custom Scope функции
local clamp = function(v, min, max) local num = v; num = num < min and min or num; num = num > max and max or num; return num end

local g_paint_ui = function()
    if ui.get(master_switch) then
        ui.set(scope_overlay, true)
    end
end

local g_paint = function()
    if not ui.get(master_switch) then return end

    ui.set(scope_overlay, false)

    local width, height = client_screen_size()
    local offset, initial_position, speed, color =
        ui.get(overlay_offset) * height / 1080,
        ui.get(overlay_position) * height / 1080,
        ui.get(fade_time), { ui.get(color_picker) }

    local me = entity_get_local_player()
    local wpn = entity_get_player_weapon(me)

    local scope_level = entity_get_prop(wpn, "m_zoomLevel")
    local scoped = entity_get_prop(me, "m_bIsScoped") == 1
    local resume_zoom = entity_get_prop(me, "m_bResumeZoom") == 1

    local is_valid = entity_is_alive(me) and wpn ~= nil and scope_level ~= nil
    local act = is_valid and scope_level > 0 and scoped and not resume_zoom

    local FT = speed > 3 and globals_frametime() * speed or 1
    local alpha = m_alpha

    renderer_gradient(width/2 - initial_position, height / 2, initial_position - offset, 1, color[1], color[2], color[3], 0, color[1], color[2], color[3], alpha*color[4], true)
    renderer_gradient(width/2 + offset, height / 2, initial_position - offset, 1, color[1], color[2], color[3], alpha*color[4], color[1], color[2], color[3], 0, true)

    renderer_gradient(width / 2, height/2 - initial_position, 1, initial_position - offset, color[1], color[2], color[3], 0, color[1], color[2], color[3], alpha*color[4], false)
    renderer_gradient(width / 2, height/2 + offset, 1, initial_position - offset, color[1], color[2], color[3], alpha*color[4], color[1], color[2], color[3], 0, false)

    m_alpha = clamp(m_alpha + (act and FT or -FT), 0, 1)
end

local function ui_callback(c)
    local master_switch_enabled, addr = ui.get(c), ''

    if not master_switch_enabled then
        m_alpha, addr = 0, 'un'
    end

    local _func = client[addr .. 'set_event_callback']
    _func('paint_ui', g_paint_ui)
    _func('paint', g_paint)
end

ui.set_callback(master_switch, ui_callback)
ui_callback(master_switch)

-- Custom Healthbar функции
local function lerp(a, b, percentage)
    return a + (b - a) * percentage
end

local function handle_checkbox()
    local enabled = ui.get(hpbar.customhealthbars)
    if enabled then
        ui.set(ui.reference("Visuals", "Player ESP", "Health bar"), false)
    end
end

ui.set_callback(hpbar.customhealthbars, handle_checkbox)

-- Bullet Tracer функции
local function handle_bullet_impact(e)
    if not ui.get(tracer) then
        return
    end
    if client_userid_to_entindex(e.userid) ~= entity_get_local_player() then
        return
    end
    local lx, ly, lz = client_eye_position()
    queue[globals_tickcount()] = {lx, ly, lz, e.x, e.y, e.z, globals_curtime() + 2}
end

-- UnsafeCrageinAir функции
local function toticks(seconds)
    return math_floor(seconds / globals_tickinterval() + 0.5)
end

local function check_charge()
    if not local_player or not entity_is_alive(local_player) then
        dt_charged = false
        return
    end

    local m_nTickBase = entity_get_prop(local_player, 'm_nTickBase')
    if not m_nTickBase then
        dt_charged = false
        return
    end

    local latency = client_latency() or 0
    local shift = math_floor(m_nTickBase - globals_tickcount() - toticks(latency))
    local wanted = -14 + (ui.get(ref.doubletap.fakelag_limit) or 1) - 1

    dt_charged = shift <= wanted
end

-- Функция для поиска ближайшего врага
local function get_closest_enemy()
    local local_player = entity_get_local_player()
    if not local_player or not entity_is_alive(local_player) then
        return nil
    end

    local local_pos = vector(client_eye_position())
    if not local_pos.x then
        return nil
    end

    local enemies = entity_get_players(true) -- Только враги
    local closest_enemy = nil
    local closest_dist = math.huge

    for i = 1, #enemies do
        local enemy = enemies[i]
        if entity_is_alive(enemy) and not entity_is_dormant(enemy) then
            local enemy_pos = vector(entity_get_origin(enemy))
            if enemy_pos.x then
                local dist = local_pos:dist(enemy_pos)
                if dist < closest_dist then
                    closest_dist = dist
                    closest_enemy = enemy
                end
            end
        end
    end

    return closest_enemy
end

-- Ссылка на цвет меню
local menu_color = ui.reference("MISC", "Settings", "Menu color")

-- Инициализация видимости и callback-и
update_tab_visibility()
ui.set_callback(current_tab, update_tab_visibility)
ui.set_callback(rage_checkbox, function()
    update_tab_visibility()
    update_haxresolver_visibility()
end)
ui.set_callback(rage_hax_resolver, update_haxresolver_visibility)
ui.set_callback(rage_dormant_aimbot, update_tab_visibility)
ui.set_callback(visuals_checkbox, update_tab_visibility)
ui.set_callback(aspect_ratio_checkbox, function()
    update_tab_visibility()
    if not ui.get(aspect_ratio_checkbox) then
        set_aspect_ratio(1) -- Сбрасываем соотношение сторон до 1:1 при выключении
    end
end)
ui.set_callback(aspect_ratio_reference, on_aspect_ratio_changed)
ui.set_callback(ThirdPerson, update_tab_visibility)
ui.set_callback(viewmodel_changer, update_tab_visibility)
ui.set_callback(misc_checkbox, update_tab_visibility)
ui.set_callback(master_switch, update_tab_visibility)
ui.set_callback(hpbar.customhealthbars, update_tab_visibility)
ui.set_callback(tracer, update_tab_visibility)

-- Dormant Aimbot
local native_GetClientEntity = vtable_bind("client_panorama.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*,int)")
local native_IsWeapon = vtable_thunk(165, "bool(__thiscall*)(void*)")
local native_GetInaccuracy = vtable_thunk(482, "float(__thiscall*)(void*)")

local player_info_prev = {}
local roundStarted = 0

local function modify_velocity(e, goalspeed)
    local minspeed = math.sqrt((e.forwardmove * e.forwardmove) + (e.sidemove * e.sidemove))
    if goalspeed <= 0 or minspeed <= 0 then return end
    if e.in_duck == 1 then goalspeed = goalspeed * 2.94117647 end
    if minspeed <= goalspeed then return end
    local speedfactor = goalspeed / minspeed
    e.forwardmove = e.forwardmove * speedfactor
    e.sidemove = e.sidemove * speedfactor
end

local function on_setup_command(cmd)
    -- HaxResolver predict
    predict()

    -- Dormant Aimbot логика
    if ui.get(rage_checkbox) and ui.get(rage_dormant_aimbot) then
        local lp = entity_get_local_player()
        if not lp then return end

        local my_weapon = entity_get_player_weapon(lp)
        if not my_weapon then return end

        local ent = native_GetClientEntity(my_weapon)
        if ent == nil or not native_IsWeapon(ent) then return end

        local inaccuracy = native_GetInaccuracy(ent)
        if inaccuracy == nil then return end

        local tickcount = globals_tickcount()
        local player_resource = entity_get_player_resource()
        if not player_resource then return end
        local eyepos = vector(client_eye_position())
        if not eyepos.x then return end
        local simtime = entity_get_prop(lp, "m_flSimulationTime")
        if not simtime then return end
        local weapon = weapons(my_weapon)
        if not weapon then return end
        local scoped = entity_get_prop(lp, "m_bIsScoped") == 1
        local onground = bit.band(entity_get_prop(lp, 'm_fFlags') or 0, bit.lshift(1, 0))
        if tickcount < roundStarted then return end

        local can_shoot
        if weapon.is_revolver then
            can_shoot = simtime > (entity_get_prop(my_weapon, "m_flNextPrimaryAttack") or 0)
        elseif weapon.is_melee_weapon then
            can_shoot = false
        else
            can_shoot = simtime > math.max(
                entity_get_prop(lp, "m_flNextAttack") or 0,
                entity_get_prop(my_weapon, "m_flNextPrimaryAttack") or 0,
                entity_get_prop(my_weapon, "m_flNextSecondaryAttack") or 0
            )
        end

        local player_info = {}
        for player = 1, globals_maxplayers() do
            if entity_get_prop(player_resource, "m_bConnected", player) == 1 then
                if entity_is_dormant(player) and entity_is_enemy(player) then
                    local can_hit
                    local origin = vector(entity_get_origin(player))
                    if not origin.x then goto continue end
                    local x1, y1, x2, y2, alpha_multiplier = entity_get_bounding_box(player)
                    if not alpha_multiplier then goto continue end

                    if player_info_prev[player] and origin.x ~= 0 and alpha_multiplier > 0 then
                        local old_origin, old_alpha, old_hittable = unpack(player_info_prev[player])
                        local dormant_accurate = alpha_multiplier > 0.795

                        if dormant_accurate then
                            local target = origin + vector(0, 0, 40)
                            local pitch, yaw = eyepos:to(target):angles()
                            local ent, dmg = client_trace_bullet(lp, eyepos.x, eyepos.y, eyepos.z, target.x, target.y, target.z, true)
                            if not dmg then goto continue end

                            can_hit = (dmg > ui.get(rage_dormant_mindmg)) and (not client_visible(target.x, target.y, target.z))
                            if can_shoot and can_hit and ui.get(rage_dormant_key) then
                                modify_velocity(cmd, (scoped and weapon.max_player_speed_alt or weapon.max_player_speed) * 0.33)

                                if not scoped and weapon.type == "sniperrifle" and cmd.in_jump == 0 and onground == 1 then
                                    cmd.in_attack2 = 1
                                end

                                if inaccuracy < 0.009 and cmd.chokedcommands == 0 then
                                    cmd.pitch = pitch
                                    cmd.yaw = yaw
                                    cmd.in_attack = 1
                                    can_shoot = false
                                end
                            end
                        end
                        player_info[player] = {origin, alpha_multiplier, can_hit}
                    end
                end
            end
            ::continue::
        end
        player_info_prev = player_info
    end

    -- UnsafeCrageinAir логика
    if ui.get(rage_checkbox) and ui.get(unsafe_crage_in_air) then
        -- Проверяем, включён ли Double Tap
        local dt_enabled = ui.get(ref.doubletap.main[1]) and ui.get(ref.doubletap.main[2])
        if not dt_enabled then
            ui.set(ref.aimbot, true)
            if callback_reg then
                client.unset_event_callback('run_command', check_charge)
                callback_reg = false
            end
            return
        end

        -- Проверяем локального игрока
        local_player = entity_get_local_player()
        if not local_player or not entity_is_alive(local_player) then
            ui.set(ref.aimbot, true)
            return
        end

        -- Регистрируем callback для check_charge, если он ещё не зарегистрирован
        if not callback_reg then
            client.set_event_callback('run_command', check_charge)
            callback_reg = true
        end

        -- Проверяем, заряжен ли Double Tap
        check_charge()

        -- Проверяем состояние игрока (в воздухе или на земле)
        local player_flags = entity_get_prop(local_player, 'm_fFlags') or 0
        local is_in_air = bit.band(player_flags, 1) == 0

        -- Проверяем, есть ли ближайший враг
        local closest_enemy = get_closest_enemy()

        -- Применяем логику
        if not dt_charged and is_in_air and closest_enemy then
            ui.set(ref.aimbot, false)
        else
            ui.set(ref.aimbot, true)
        end
    else
        -- Если UnsafeCrageinAir выключен, убедимся, что аимбот включён
        ui.set(ref.aimbot, true)
        if callback_reg then
            client.unset_event_callback('run_command', check_charge)
            callback_reg = false
        end
    end

    -- Hitchance Override логика (упрощённая версия)
    if ui.get(rage_checkbox) and ui.get(feature.hitchance_override) then
        local lp = entity_get_local_player()
        if lp == nil or not entity_is_alive(lp) then return end

        if ui.get(feature.hc_ovr_key) then
            ui.set(hc_ref, ui.get(feature.hit_chance_ovr))
        else
            ui.set(hc_ref, original_hc_value) -- Возвращаем исходное значение, если хоткей не активен
        end
    end
end

-- Переменные для надписи "hax.lua" (заменяем старые)
local hax_text = "hax.lua"
local hax_color_r, hax_color_g, hax_color_b = 255, 182, 193 -- Базовый розовый цвет без альфы, альфу добавим в рендеринге

-- Обновлённая функция painter() (полная версия с новой надписью)
local function painter()
    -- HaxResolver индикатор
    if ui.get(rage_checkbox) and ui.get(rage_hax_resolver) and ui.get(b_2.rage.predict) then
        renderer_indicator(255, 182, 193, 255, "\a" .. to_hex(255, 182, 193, 255 * math.abs(math.cos(globals.curtime() * 1))) .. "HaxResolver")
    end

    -- Dormant Aimbot индикатор
    if not entity_is_alive(entity_get_local_player()) then return end
    if ui.get(rage_checkbox) and ui.get(rage_dormant_aimbot) and ui.get(rage_dormant_key) and ui.get(rage_dormant_indicator) then
        local colors = {132, 196, 20, 245}
        for k, v in pairs(player_info_prev) do
            if k and v[3] == true then
                colors = {252, 222, 30, 245}
                break
            end
        end
        renderer_indicator(colors[1], colors[2], colors[3], colors[4], "DA")
    end

    -- Hitchance Override индикатор
    if ui.get(rage_checkbox) and ui.get(feature.hitchance_override) and ui.get(feature.hc_ovr_key) then
        renderer_indicator(255, 255, 255, 255, "HITCHANCE OVR")
    end

    -- Custom Scope
    g_paint()

    -- Custom Healthbar
    if ui.get(hpbar.customhealthbars) then
        local r, g, b, a = ui.get(hpbar.colorpicker)
        local r2, g2, b2, a2 = ui.get(hpbar.colorpicker2)
        local local_player = entity_get_local_player()

        local force_teammates =  ui.get(xuisassa)
        if not entity_is_alive(local_player) then
            local m_iObserverMode = entity_get_prop(local_player, "m_iObserverMode")
            if m_iObserverMode == 4 or m_iObserverMode == 5 then
                local spectated_ent = entity_get_prop(local_player, "m_hObserverTarget")
                if entity_is_enemy(spectated_ent) then
                    force_teammates = true
                end
            end
        end
        local enemy_players = entity_get_players(not force_teammates)
        for i=1,#enemy_players do
            local e = enemy_players[i]
            if entity_is_alive(local_player) or not force_teammates or force_teammates and (not entity_is_alive(local_player) and not entity_is_enemy(e)) then
                local x1, y1, x2, y2, a = entity_get_bounding_box(e)
                if x1 ~= nil and y1 ~= nil and not entity_is_dormant(e) then
                    local hp = entity_get_prop(e, "m_iHealth")
                    local height = y2 - y1 + 2
                    y1 = y1 - 1
                    local width = x2 - x1
                    local leftside = x1 - 5
                    if hp ~= nil then
                        local percentage = hp/100
                        local name = entity.get_player_name(e)
                        players[name] = {}
                        renderer_rectangle(leftside-1, y1, 4, height, 20, 20, 20, 150)
                        local new_r, new_g, new_b = lerp(r2, r, percentage), lerp(g2, g, percentage), lerp(b2, b, percentage)
                        if ui.get(hpbar.gradient) then
                            renderer_gradient(leftside, math_ceil(y2-(height*percentage))+2, 2, math_floor(height*percentage) - 2, new_r, new_g, new_b, 255, r2, g2, b2, 255, false)
                        else
                            renderer_rectangle(leftside, math_ceil(y2-(height*percentage))+2, 2, math_floor(height*percentage) - 2, new_r, new_g, new_b, 255)
                        end
                        if hp < 100 then
                            renderer_text(leftside-2, y2-(height*percentage)+2, 255, 255, 255, 255, "-cd", 0, hp)
                        end
                        players[name] = {
                            ent = e,
                            teammate = entity_is_enemy(e),
                            health = hp,
                            health_percentage = percentage,
                            active = false,
                            alpha = 255,
                        }
                    end
                end
            end
        end
        if entity_is_alive(local_player) then
            for k,v in pairs(players) do
                if not v.active and entity_is_alive(v.ent) then
                    local x1, y1, x2, y2, a = entity_get_bounding_box(v.ent)
                    if x1 ~= nil and y1 ~= nil then
                        local height = y2 - y1 + 2
                        y1 = y1 - 1
                        local width = x2 - x1
                        local leftside = x1 - 5
                        local percentage = v.health_percentage
                        local hp = v.health
                        renderer_rectangle(leftside-1, y1, 4, height, 20, 20, 20, 150 * (players[k].alpha/255))
                        players[k].alpha = players[k].alpha - 0.25
                        local new_r, new_g, new_b = lerp(r2, r, percentage), lerp(g2, g, percentage), lerp(b2, b, percentage)
                        if ui.get(hpbar.gradient) then
                            renderer_gradient(leftside, math_ceil(y2-(height*percentage))+2, 2, math_floor(height*percentage) - 2, new_r, new_g, new_b, players[k].alpha, r2, g2, b2, players[k].alpha, false)
                        else
                            renderer_rectangle(leftside, math_ceil(y2-(height*percentage))+2, 2, math_floor(height*percentage) - 2, new_r, new_g, new_b, players[k].alpha)
                        end
                        if hp < 100 then
                            renderer_text(leftside-2, y2-(height*percentage)+2, 255, 255, 255, players[k].alpha, "-cd", 0, hp)
                        end
                    end
                end
                if v.alpha < 0 then
                    players[k] = nil
                end
            end
        end
    end

    -- Bullet Tracer
    if ui.get(tracer) then
        for tick, data in pairs(queue) do
            if globals_curtime() <= data[7] then
                local x1, y1 = renderer_world_to_screen(data[1], data[2], data[3])
                local x2, y2 = renderer_world_to_screen(data[4], data[5], data[6])
                if x1 ~= nil and x2 ~= nil and y1 ~= nil and y2 ~= nil then
                    renderer_line(x1, y1, x2, y2, ui.get(tracer_color))
                end
            end
        end
    end

    -- Переливающаяся и увеличенная надпись "hax.lua" внизу экрана
    local screen_width, screen_height = client_screen_size()
    local alpha = 255 * math.abs(math.cos(globals.curtime() * 1)) -- Пульсация альфы
    renderer_text(screen_width / 2, screen_height - 20, hax_color_r, hax_color_g, hax_color_b, alpha, "c+", 0, hax_text)
end

local function paint_ui_handler()
    thirdperson_main() -- Вызываем Thirdperson
    g_paint_ui() -- Вызываем Custom Scope
end

local function resetter(info)
    local freezetime = (cvar.mp_freezetime:get_float() + 1) / globals_tickinterval()
    roundStarted = globals_tickcount() + freezetime
    players = {} -- Очищаем таблицу players для Custom Healthbar
    queue = {} -- Очищаем таблицу queue для Bullet Tracer
end

-- Autobuy логика на начало раунда
client.set_event_callback("round_prestart", function(e)
    if not ui.get(misc_checkbox) or not ui.get(autobuy_enabled) then return end

    local ui_threshold_value = ui.get(autobuy_threshold)
    local price_threshold = 0

    if ui.get(autobuy_cost_based) and (ui_threshold_value == 0) then
        price_threshold = get_weapon_prices()
    elseif (ui_threshold_value ~= 0) then
        price_threshold = ui.get(autobuy_threshold)
    end

    local money = entity.get_prop(entity.get_local_player(), "m_iAccount") or 0

    -- Если денег меньше порога
    if money <= price_threshold then
        -- Secondary (Backup)
        for k, v in pairs(commands) do
            if k == ui.get(autobuy_secondary_2) then
                client.exec(v)
            end
        end

        -- Utilities (Backup)
        local utility_purchase = ui.get(autobuy_utilities_2)
        for i = 1, #utility_purchase do
            local n = utility_purchase[i]
            for k, v in pairs(commands) do
                if k == n then
                    client.exec(v)
                end
            end
        end

        -- Primary (Backup)
        for k, v in pairs(commands) do
            if k == ui.get(autobuy_primary_2) then
                client.exec(v)
            end
        end

        -- Grenades (Backup)
        local grenade_purchase = ui.get(autobuy_grenades_2)
        for i = 1, #grenade_purchase do
            local n = grenade_purchase[i]
            for k, v in pairs(commands) do
                if k == n then
                    client.exec(v)
                end
            end
        end
    else
        -- Utilities
        local utility_purchase = ui.get(autobuy_utilities)
        for i = 1, #utility_purchase do
            local n = utility_purchase[i]
            for k, v in pairs(commands) do
                if k == n then
                    client.exec(v)
                end
            end
        end

        -- Secondary
        for k, v in pairs(commands) do
            if k == ui.get(autobuy_secondary) then
                client.exec(v)
            end
        end

        -- Primary
        for k, v in pairs(commands) do
            if k == ui.get(autobuy_primary) then
                client.exec(v)
            end
        end

        -- Grenades
        local grenade_purchase = ui.get(autobuy_grenades)
        for i = 1, #grenade_purchase do
            local n = grenade_purchase[i]
            for k, v in pairs(commands) do
                if k == n then
                    client.exec(v)
                end
            end
        end
    end
end)

-- Объединённая функция shutdown для Thirdperson, Viewmodel Changer, UnsafeCrageinAir, HaxResolver и Hitchance Override
local function shutdown()
    -- Сброс Thirdperson
    cvar.c_mindistance:set_float(100)
    cvar.c_maxdistance:set_float(100)
    -- Сброс Viewmodel Changer
    set_viewmodel(default_fov, default_offset_x, default_offset_y, default_offset_z)
    -- Сброс UnsafeCrageinAir
    ui.set(ref.aimbot, true)
    -- Сброс HaxResolver
    cvar.cl_interp:set_float(0.016)
    cvar.cl_interp_ratio:set_int(1)
    cvar.cl_interpolate:set_int(0)
    -- Сброс Hitchance Override
    ui.set(hc_ref, original_hc_value)
    ui.set_visible(hc_ref, true)
end

-- Регистрация событий
client.set_event_callback("paint_ui", paint_ui_handler)
client.set_event_callback("shutdown", shutdown)
client.set_event_callback("setup_command", on_setup_command)
client.set_event_callback("paint", painter)
client.set_event_callback("round_prestart", resetter)
client.set_event_callback("bullet_impact", handle_bullet_impact)

client.register_esp_flag("DA", 255, 255, 255, function(player)
    if ui.get(rage_checkbox) and ui.get(rage_dormant_aimbot) and entity_is_enemy(player) and player_info_prev[player] and entity_is_alive(entity_get_local_player()) then
        local _, _, can_hit = unpack(player_info_prev[player])
        return can_hit
    end
end)




function precache_model(modelname)
    rawprecache_table = find_table(networkstringtablecontainer, "modelprecache") or error("couldnt find modelprecache", 2)
    if rawprecache_table then
        precache_table = ffi.cast(class_ptr, rawprecache_table) or error("couldnt cast precache_table", 2)
        if precache_table then
            add_string = ffi.cast("add_string_t", precache_table[0][8]) or error("add_string is nil", 2)

            find_or_load_model(ivmodelinfo, modelname)
            idx = add_string(precache_table, false, modelname, -1, nil)
            if idx == -1 then
                return false
            end
        end
    end
    return true
end

function set_model_index(entity, idx)
    raw_entity = get_client_entity(ientitylist, entity)
    if raw_entity then
        gce_entity = ffi.cast(class_ptr, raw_entity)
        a_set_model_index = ffi.cast("set_model_index_t", gce_entity[0][75])
        if a_set_model_index == nil then
            error("set_model_index is nil")
        end
        a_set_model_index(gce_entity, idx)
    end
end

function change_model(ent, model)
    if model:len() > 5 then
        if precache_model(model) == false then
            error("invalid model", 2)
        end
        idx = get_model_index(ivmodelinfo, model)
        if idx == -1 then
            return
        end
        set_model_index(ent, idx)
    end
end

function update_name()
    me = entity.get_local_player()

    if me == nil then
        return
    end

    team = entity.get_prop(me, 'm_iTeamNum')
    index = (team == 3 and ui.get(player_model_ct_list)) or (team == 2 and ui.get(player_model_t_list))
    i = 0

    for k, v in pairs(player_models) do
        if index == i then
            return name_modelss(k)
        end
        i = i + 1
    end

    return
end

client.set_event_callback("pre_render", function()
    me = entity.get_local_player()
    if me == nil then
        return
    end

    team = entity.get_prop(me, 'm_iTeamNum')

    if (team == 2 and ui.get(player_model_t_check)) or (team == 3 and ui.get(player_model_ct_check)) then
		change_model(me, player_models[name_modelss:get()])
    end
end)

client.set_event_callback("load", function() menu_ex() end)
if ui.is_menu_open() then
    client.set_event_callback("paint_ui", function()
        update_name()

        name_modelss:set_visible(false)

        local selected_tab = ui.get(current_tab)
        local visuals_enabled = ui.get(visuals_checkbox)
        
        
        ui.set_visible(player_model_ct_check_Enable, selected_tab == "Visuals" and visuals_enabled )
        ui.set_visible(label6S, selected_tab == "Visuals" and visuals_enabled and ui.get(player_model_ct_check_Enable))
        ui.set_visible(check_tabS, selected_tab == "Visuals" and visuals_enabled and ui.get(player_model_ct_check_Enable))
        ui.set_visible(label5S, selected_tab == "Visuals" and visuals_enabled and ui.get(player_model_ct_check_Enable))
        
        ui.set_visible(player_model_ct_check, selected_tab == "Visuals" and visuals_enabled and ui.get(check_tabS) == "CT" and ui.get(player_model_ct_check_Enable))
        ui.set_visible(player_model_t_check, selected_tab == "Visuals" and visuals_enabled and ui.get(check_tabS) == "T" and ui.get(player_model_ct_check_Enable))
        
        ui.set_visible(player_model_ct_list, selected_tab == "Visuals"and visuals_enabled and ui.get(check_tabS) == "CT" and ui.get(player_model_ct_check)and ui.get(player_model_ct_check_Enable))
        ui.set_visible(player_model_t_list, selected_tab == "Visuals"and visuals_enabled and ui.get(check_tabS) == "T" and ui.get(player_model_t_list)and ui.get(player_model_ct_check_Enable))
        
    end)
end




tGameData = {
  udCvar_sv_skyname = cvar.sv_skyname,
  udCvar_r_3dsky = cvar.r_3dsky,
  sSkyboxNameDefault = false
}
tScriptFunctions = {
  SetSkyboxName = function(bSetDefaultSkybox)
    if bSetDefaultSkybox and tGameData.sSkyboxNameDefault then
      if tGameData.udCvar_sv_skyname then
        return load_name_sky(tGameData.sSkyboxNameDefault)
      end
    else
      if tGameData.udCvar_sv_skyname then
        tScriptData.sSkyboxNameCustom = tScriptData.tSkyboxIndexToPath[ui_get(tScriptData.tMenuReferences.nSkyboxList) + 1]
        if tScriptData.sSkyboxNameCustom then
          return load_name_sky(tScriptData.sSkyboxNameCustom)
        end
      end
    end
  end,
  SetSkyboxColor = function(nR, nG, nB, nA)
    tCurrentSkyboxMaterials = materialsystem_find_materials("skybox/" .. tostring(tScriptData.sSkyboxNameCustom))
    if tCurrentSkyboxMaterials then
      return client_delay_call(#tCurrentSkyboxMaterials == 0 and ui_get(tScriptData.tMenuReferences.nSkyboxColorChangeDelay) or 0, (function()
        tMaterials = materialsystem_find_materials("skybox/")
        if tMaterials then
          for _index_0 = 1, #tMaterials do
            udMaterial = tMaterials[_index_0]
            udMaterial:color_modulate(nR, nG, nB)
            udMaterial:alpha_modulate(nA)
          end
        end
      end))
    end
  end,
  CheckSkyboxName = function()
    sSkyboxNameCurrent = tGameData.udCvar_sv_skyname:get_string()
    if tScriptData.sSkyboxNameCustom and sSkyboxNameCurrent ~= tScriptData.sSkyboxNameCustom then
      return load_name_sky(tScriptData.sSkyboxNameCustom)
    end
  end
}
tScriptEventCallbacks = {
  OnPlayerConnectFull = function(e)
    if client_userid_to_entindex(e.userid) == entity_get_local_player() then
      tGameData.sSkyboxNameDefault = tGameData.udCvar_sv_skyname:get_string()
    end
    if ui_get(tScriptData.tMenuReferences.nMasterSwitch) then
      tScriptFunctions.SetSkyboxName()
      nR, nG, nB, nA = ui_get(tScriptData.tMenuReferences.nSkyboxColor)
      return tScriptFunctions.SetSkyboxColor(nR, nG, nB, nA)
    end
  end,
  OnPostConfigLoad = function()
    if entity_get_local_player() then
      tScriptFunctions.SetSkyboxName()
      nR, nG, nB, nA = ui_get(tScriptData.tMenuReferences.nSkyboxColor)
      return tScriptFunctions.SetSkyboxColor(nR, nG, nB, nA)
    end
  end,
  OnPaint = function()
    nCurrentTimestamp = globals_realtime()
    if nCurrentTimestamp - tScriptData.nSkyboxCheckTimestamp > ui_get(tScriptData.tMenuReferences.nSkyboxCheckInterval) then
      tScriptData.nSkyboxCheckTimestamp = nCurrentTimestamp
      if entity_get_local_player() then
        tScriptFunctions.SetSkyboxName()
        nR, nG, nB, nA = ui_get(tScriptData.tMenuReferences.nSkyboxColor)
        return tScriptFunctions.SetSkyboxColor(nR, nG, nB, nA)
      end
    end
  end
}
ui_set_callback(tScriptData.tMenuReferences.nMasterSwitch, function(nUiElementReference)
  if ui_get(tScriptData.tMenuReferences.nMasterSwitch) then
    client_set_event_callback("player_connect_full", tScriptEventCallbacks.OnPlayerConnectFull)
    client_set_event_callback("post_config_load", tScriptEventCallbacks.OnPostConfigLoad)
    client_set_event_callback("paint", tScriptEventCallbacks.OnPaint)
    tScriptFunctions.SetSkyboxName()
    nR, nG, nB, nA = ui_get(tScriptData.tMenuReferences.nSkyboxColor)
    return tScriptFunctions.SetSkyboxColor(nR, nG, nB, nA)
  else
    client_unset_event_callback("player_connect_full", tScriptEventCallbacks.OnPlayerConnectFull)
    client_unset_event_callback("post_config_load", tScriptEventCallbacks.OnPostConfigLoad)
    client_unset_event_callback("paint", tScriptEventCallbacks.OnPaint)
    tScriptFunctions.SetSkyboxName(true)
    return tScriptFunctions.SetSkyboxColor(255, 255, 255, 255)
  end
end)
ui_set_callback(tScriptData.tMenuReferences.nSkyboxColor, function(nUiElementReference)
  if ui_get(tScriptData.tMenuReferences.nMasterSwitch) then
    nR, nG, nB, nA = ui_get(nUiElementReference)
    return tScriptFunctions.SetSkyboxColor(nR, nG, nB, nA)
  end
end)
ui_set_callback(tScriptData.tMenuReferences.nSkyboxList, function(nUiElementReference)
  tScriptData.sSkyboxNameCustom = tScriptData.tSkyboxIndexToPath[ui_get(tScriptData.tMenuReferences.nSkyboxList) + 1]
  if ui_get(tScriptData.tMenuReferences.nMasterSwitch) then
    tScriptFunctions.SetSkyboxName()
    nR, nG, nB, nA = ui_get(tScriptData.tMenuReferences.nSkyboxColor)
    return tScriptFunctions.SetSkyboxColor(nR, nG, nB, nA)
  end
end)
ui_set_callback(tScriptData.tMenuReferences.nHide3dSkybox, function(nUiElementReference)
  if ui_get(nUiElementReference) then
    return tGameData.udCvar_r_3dsky:set_raw_int(0)
  else
    return tGameData.udCvar_r_3dsky:set_raw_int(1)
  end
end)
client_set_event_callback("shutdown", function()
  client_unset_event_callback("player_connect_full", tScriptEventCallbacks.OnPlayerConnectFull)
  client_unset_event_callback("post_config_load", tScriptEventCallbacks.OnPostConfigLoad)
  client_unset_event_callback("paint", tScriptEventCallbacks.OnPaint)
  tScriptFunctions.SetSkyboxName(true)
  return tScriptFunctions.SetSkyboxColor(255, 255, 255, 255)
end)
if tGameData.udCvar_sv_skyname then
  tGameData.sSkyboxNameDefault = tGameData.udCvar_sv_skyname:get_string()
  if ui_get(tScriptData.tMenuReferences.nMasterSwitch) then
    client_set_event_callback("player_connect_full", tScriptEventCallbacks.OnPlayerConnectFull)
    client_set_event_callback("post_config_load", tScriptEventCallbacks.OnPostConfigLoad)
    client_set_event_callback("paint", tScriptEventCallbacks.OnPaint)
    tScriptFunctions.SetSkyboxName()
    nR, nG, nB, nA = ui_get(tScriptData.tMenuReferences.nSkyboxColor)
    return tScriptFunctions.SetSkyboxColor(nR, nG, nB, nA)
  end
end

local solus_render = (function() local solus_m = {}; local RoundedRect = function(x, y, w, h, radius, r, g, b, a) renderer.rectangle(x+radius,y,w-radius*2,radius,r,g,b,a)renderer.rectangle(x,y+radius,radius,h-radius*2,r,g,b,a)renderer.rectangle(x+radius,y+h-radius,w-radius*2,radius,r,g,b,a)renderer.rectangle(x+w-radius,y+radius,radius,h-radius*2,r,g,b,a)renderer.rectangle(x+radius,y+radius,w-radius*2,h-radius*2,r,g,b,a)renderer.circle(x+radius,y+radius,r,g,b,a,radius,180,0.25)renderer.circle(x+w-radius,y+radius,r,g,b,a,radius,90,0.25)renderer.circle(x+radius,y+h-radius,r,g,b,a,radius,270,0.25)renderer.circle(x+w-radius,y+h-radius,r,g,b,a,radius,0,0.25) end; local rounding = 4; local rad = rounding + 2; local n = 45; local o = 20; local OutlineGlow = function(x, y, w, h, radius, r, g, b, a) renderer.rectangle(x+2,y+radius+rad,1,h-rad*2-radius*2,r,g,b,a)renderer.rectangle(x+w-3,y+radius+rad,1,h-rad*2-radius*2,r,g,b,a)renderer.rectangle(x+radius+rad,y+2,w-rad*2-radius*2,1,r,g,b,a)renderer.rectangle(x+radius+rad,y+h-3,w-rad*2-radius*2,1,r,g,b,a)renderer.circle_outline(x+radius+rad,y+radius+rad,r,g,b,a,radius+rounding,180,0.25,1)renderer.circle_outline(x+w-radius-rad,y+radius+rad,r,g,b,a,radius+rounding,270,0.25,1)renderer.circle_outline(x+radius+rad,y+h-radius-rad,r,g,b,a,radius+rounding,90,0.25,1)renderer.circle_outline(x+w-radius-rad,y+h-radius-rad,r,g,b,a,radius+rounding,0,0.25,1) end; local FadedRoundedRect = function(x, y, w, h, radius, r, g, b, a, glow) local n=a/255*n;renderer.rectangle(x+radius,y,w-radius*2,1,r,g,b,a)renderer.circle_outline(x+radius,y+radius,r,g,b,a,radius,180,0.25,1)renderer.circle_outline(x+w-radius,y+radius,r,g,b,a,radius,270,0.25,1)renderer.gradient(x,y+radius,1,h-radius*2,r,g,b,a,r,g,b,n,false)renderer.gradient(x+w-1,y+radius,1,h-radius*2,r,g,b,a,r,g,b,n,false)renderer.circle_outline(x+radius,y+h-radius,r,g,b,n,radius,90,0.25,1)renderer.circle_outline(x+w-radius,y+h-radius,r,g,b,n,radius,0,0.25,1)renderer.rectangle(x+radius,y+h-1,w-radius*2,1,r,g,b,n)if ui_get(glow_enabled)then for radius=4,glow do local radius=radius/2;OutlineGlow(x-radius,y-radius,w+radius*2,h+radius*2,radius,r,g,b,glow-radius*2)end end end; local HorizontalFadedRoundedRect = function(x, y, w, h, radius, r, g, b, a, glow, r1, g1, b1) local n=a/255*n;renderer.rectangle(x,y+radius,1,h-radius*2,r,g,b,a)renderer.circle_outline(x+radius,y+radius,r,g,b,a,radius,180,0.25,1)renderer.circle_outline(x+radius,y+h-radius,r,g,b,a,radius,90,0.25,1)renderer.gradient(x+radius,y,w/3.5-radius*2,1,r,g,b,a,0,0,0,n/0,true)renderer.gradient(x+radius,y+h-1,w/3.5-radius*2,1,r,g,b,a,0,0,0,n/0,true)renderer.rectangle(x+radius,y+h-1,w-radius*2,1,r1,g1,b1,n)renderer.rectangle(x+radius,y,w-radius*2,1,r1,g1,b1,n)renderer.circle_outline(x+w-radius,y+radius,r1,g1,b1,n,radius,-90,0.25,1)renderer.circle_outline(x+w-radius,y+h-radius,r1,g1,b1,n,radius,0,0.25,1)renderer.rectangle(x+w-1,y+radius,1,h-radius*2,r1,g1,b1,n)if ui_get(glow_enabled)then for radius=4,glow do local radius=radius/2;OutlineGlow(x-radius,y-radius,w+radius*2,h+radius*2,radius,r1,g1,b1,glow-radius*2)end end end; local FadedRoundedGlow = function(x, y, w, h, radius, r, g, b, a, glow, r1, g1, b1) local n=a/255*n;renderer.rectangle(x+radius,y,w-radius*2,1,r,g,b,n)renderer.circle_outline(x+radius,y+radius,r,g,b,n,radius,180,0.25,1)renderer.circle_outline(x+w-radius,y+radius,r,g,b,n,radius,270,0.25,1)renderer.rectangle(x,y+radius,1,h-radius*2,r,g,b,n)renderer.rectangle(x+w-1,y+radius,1,h-radius*2,r,g,b,n)renderer.circle_outline(x+radius,y+h-radius,r,g,b,n,radius,90,0.25,1)renderer.circle_outline(x+w-radius,y+h-radius,r,g,b,n,radius,0,0.25,1)renderer.rectangle(x+radius,y+h-1,w-radius*2,1,r,g,b,n)if ui_get(glow_enabled)then for radius=4,glow do local radius=radius/2;OutlineGlow(x-radius,y-radius,w+radius*2,h+radius*2,radius,r1,g1,b1,glow-radius*2)end end end; solus_m.linear_interpolation = function(start, _end, time) return (_end - start) * time + start end solus_m.clamp = function(value, minimum, maximum) if minimum>maximum then return math.min(math.max(value,maximum),minimum)else return math.min(math.max(value,minimum),maximum)end end solus_m.lerp = function(start, _end, time) time=time or 0.005;time=solus_m.clamp(globals.frametime()*time*175.0,0.01,1.0)local a=solus_m.linear_interpolation(start,_end,time)if _end==0.0 and a<0.01 and a>-0.01 then a=0.0 elseif _end==1.0 and a<1.01 and a>0.99 then a=1.0 end;return a end solus_m.container = function(x, y, w, h, r, g, b, a, alpha, fn) if alpha*255>0 then renderer.blur(x,y,w,h)end;RoundedRect(x,y,w,h,rounding,17,17,17,a)FadedRoundedRect(x,y,w,h,rounding,r,g,b,alpha*255,alpha*o)if not fn then return end;fn(x+rounding,y+rounding,w-rounding*2,h-rounding*2.0) end; solus_m.horizontal_container = function(x, y, w, h, r, g, b, a, alpha, r1, g1, b1, fn) if alpha*255>0 then renderer.blur(x,y,w,h)end;RoundedRect(x,y,w,h,rounding,17,17,17,a)HorizontalFadedRoundedRect(x,y,w,h,rounding,r,g,b,alpha*255,alpha*o,r1,g1,b1)if not fn then return end;fn(x+rounding,y+rounding,w-rounding*2,h-rounding*2.0) end; solus_m.container_glow = function(x, y, w, h, r, g, b, a, alpha,r1, g1, b1, fn) if alpha*255>0 then renderer.blur(x,y,w,h)end;RoundedRect(x,y,w,h,rounding,17,17,17,a)FadedRoundedGlow(x,y,w,h,rounding,r,g,b,alpha*255,alpha*o,r1,g1,b1)if not fn then return end;fn(x+rounding,y+rounding,w-rounding*2,h-rounding*2.0) end; solus_m.measure_multitext = function(flags, _table) local a=0;for b,c in pairs(_table)do c.flags=c.flags or''a=a+renderer.measure_text(c.flags,c.text)end;return a end solus_m.multitext = function(x, y, _table) for a,b in pairs(_table)do b.flags=b.flags or''b.limit=b.limit or 0;b.color=b.color or{255,255,255,255}b.color[4]=b.color[4]or 255;renderer.text(x,y,b.color[1],b.color[2],b.color[3],b.color[4],b.flags,b.limit,b.text)x=x+renderer.measure_text(b.flags,b.text) end end return solus_m end)()



local script_db, original_db = read_database(script_name, database_name, {
	watermark = {
		nickname = '',		
		beta_status = true,
		gc_state = true,
		style = create_integer(1, 4, 1, 1),
		suffix = nil,
	},

	spectators = {
		avatars = true,
		auto_position = true
	},

	keybinds = {
		{
			require = '',
			reference = { 'legit', 'aimbot', 'Enabled' },
			custom_name = 'Legit aimbot',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'legit', 'triggerbot', 'Enabled' },
			custom_name = 'Legit triggerbot',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'rage', 'aimbot', 'Enabled' },
			custom_name = 'Rage aimbot',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'rage', 'aimbot', 'Force safe point' },
			custom_name = 'Safe point',
			ui_offset = 1
		},


		{
			require = '',
			reference = { 'rage', 'aimbot', 'Quick stop' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'rage', 'other', 'Quick peek assist' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'rage', 'aimbot','Force body aim' },
			custom_name = '',
			ui_offset = 1
		},

		{
			require = '',
			reference = { 'rage', 'other', 'Duck peek assist' },
			custom_name = '',
			ui_offset = 1
		},

		{
			require = '',
			reference = { "rage" , "aimbot" ,"Double tap" },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'rage', 'other', 'Anti-aim correction' },
			custom_name = 'Resolver override',
			ui_offset = 1
		},


		{
			require = '',
			reference = { 'aa', 'anti-aimbot angles', 'Freestanding' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'aa', 'other', 'Slow motion' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'aa', 'other', 'On shot anti-aim' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'aa', 'other', 'Fake peek' },
			custom_name = '',
			ui_offset = 2
		},


		{
			require = '',
			reference = { 'misc', 'movement', 'Z-Hop' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'misc', 'movement', 'Pre-speed' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'misc', 'movement', 'Blockbot' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'misc', 'movement', 'Jump at edge' },
			custom_name = '',
			ui_offset = 2
		},


		{
			require = '',
			reference = { 'misc', 'miscellaneous', 'Last second defuse' },
			custom_name = '',
			ui_offset = 1
		},

		{
			require = '',
			reference = { 'misc', 'miscellaneous', 'Free look' },
			custom_name = '',
			ui_offset = 1
		},

		{
			require = '',
			reference = { 'misc', 'miscellaneous', 'Ping spike' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'misc', 'miscellaneous', 'Automatic grenade release' },
			custom_name = 'Grenade release',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'visuals', 'player esp', 'Activation type' },
			custom_name = 'Visuals',
			ui_offset = 1
		},
	},
})

local get_bar_color = function()
	local r, g, b, a = ui_get(ms_color)

	local palette = ui_get(ms_palette)

	if palette ~= menu_palette[1] then
		local rgb_split_ratio = ui_get(ms_rainbow_split_ratio) / 100

		local h = palette == menu_palette[2] and 
			globals_realtime() * (ui_get(ms_rainbow_frequency) / 100) or 
			 1000

		r, g, b = hsv_to_rgb(h, 1, 1, 1)
		r, g, b = 
			r * rgb_split_ratio, 
			g * rgb_split_ratio, 
			b * rgb_split_ratio
	end

	return r, g, b, a
end

local get_color = function(number, max, i)
    local Colors = {
        { 255, 0, 0 },
        { 237, 27, 3 },
        { 235, 63, 6 },
        { 229, 104, 8 },
        { 228, 126, 10 },
        { 220, 169, 16 },
        { 213, 201, 19 },
        { 176, 205, 10 },
        { 124, 195, 13 }
    }

    local math_num = function(int, max, declspec)
        local int = (int > max and max or int)
        local tmp = max / int;

        if not declspec then declspec = max end

        local i = (declspec / tmp)
        i = (i >= 0 and math_floor(i + 0.5) or math_ceil(i - 0.5))

        return i
    end

    i = math_num(number, max, #Colors)

    return
        Colors[i <= 1 and 1 or i][1], 
        Colors[i <= 1 and 1 or i][2],
        Colors[i <= 1 and 1 or i][3],
        i
end
               
local ms_classes = {
	watermark = function()
		local note = notes 'a_watermark'
		local cstyle = { [1] = {'game', 'sense'}, [2] = {'games', 'ense.pub'}, [3] = {'sk', 'eet'}, [4] = {'ske', 'et.cc'}}


		local m_alpha = 0

		local has_beta = pcall(ui_reference, 'misc', 'Settings', 'Crash logs')
		local get_name = panorama.loadstring([[ return MyPersonaAPI.GetName() ]])
		local get_gc_state = panorama.loadstring([[ return MyPersonaAPI.IsConnectedToGC() ]])

		local classptr = ffi.typeof('void***')
		local latency_ptr = ffi.typeof('float(__thiscall*)(void*, int)')

		local rawivengineclient = client.create_interface('engine.dll', 'VEngineClient014') or error('VEngineClient014 wasnt found', 2)
		local ivengineclient = ffi.cast(classptr, rawivengineclient) or error('rawivengineclient is nil', 2)
		local is_in_game = ffi.cast('bool(__thiscall*)(void*)', ivengineclient[0][26]) or error('is_in_game is nil')

		local g_paint_handler = function()
			local state = ui_get(ms_watermark)
			local r, g, b, a = get_bar_color()

			note.set_state(m_alpha > 0.01)

			note.get(function(id)
				local data_wm = script_db.watermark or { }
				local data_nickname = data_wm.nickname and tostring(data_wm.nickname) or ''
				local data_suffix = (data_wm.suffix and tostring(data_wm.sWuffix) or ''):gsub('beta', '')

				local global_alpha = m_alpha * 255

				if data_wm.beta_status and has_beta and (not data_suffix or #data_suffix < 1) then
					data_suffix = 'beta'
				end

				local sys_time = { client_system_time() }
				local actual_time = ('%02d:%02d:%02d'):format(sys_time[1], sys_time[2], sys_time[3])

				local is_connected_to_gc = not data_wm.gc_state or get_gc_state()
				local gc_state = not is_connected_to_gc and '\x20\x20\x20\x20\x20' or ''

				local nickname = #data_nickname > 0 and data_nickname or get_name()

				local suffix = cstyle[data_wm.style and data_wm.style.value or 1] or cstyle[1][1]

				local text = {
					{text = gc_state,  color = {255, 255, 255, global_alpha}},
					
					{text = suffix[1], color = {255, 255, 255, global_alpha}},
					{text = suffix[2], color = {r, g, b, global_alpha}},
				}
		
				if #data_suffix > 0 then
					table.insert(text, {text = (' [%s]'):format(data_suffix), color = {255, 255, 255, global_alpha}})
				end

				table.insert(text, {text = (' | %s'):format(nickname), color = {255, 255, 255, global_alpha}})
		
				if is_in_game(is_in_game) == true then
					local latency = client.latency()*1000
					if latency > 5 then
						table.insert(text, {text = (' | delay: %dms'):format(latency), color = {255, 255, 255, global_alpha}})
					end
				end

				table.insert(text, {text = (' | %s'):format(actual_time), color = {255, 255, 255, global_alpha}})
		
				local h, w = 19,solus_render.measure_multitext(nil, text) + 8
				local x, y = client_screen_size(), 8 + (25*id)
		
				x = x - w - 10

					solus_render.container(x, y + 2, w, h, r, g, b, a * m_alpha, m_alpha)
					solus_render.multitext(x + 4, y + 4, text)

				if not is_connected_to_gc then
					local realtime = globals_realtime()*1.5
					
					if realtime%2 <= 1 then
						renderer_circle_outline(x+10, y + 11, 89, 119, 239, global_alpha, 5, 0, realtime%1, 2)
					else
						renderer_circle_outline(x+10, y + 11, 89, 119, 239, global_alpha, 5, realtime%1*370, 1-realtime%1, 2)
					end
				end
			end)

			local frames = 8 * globals_frametime()

			if state then
				m_alpha = m_alpha + frames; if m_alpha > 1 then m_alpha = 1 end
			else
				m_alpha = m_alpha - frames; if m_alpha < 0 then m_alpha = 0 end 
			end
		end

		client_set_event_callback('paint_ui', g_paint_handler)
	end,

	spectators = function()
		local screen_size = { client_screen_size() }
		local screen_size = {
			screen_size[1] - screen_size[1] * cvar.safezonex:get_float(),
			screen_size[2] * cvar.safezoney:get_float()
		}

		local dragging = dragging_fn('Spectators', screen_size[1] / 1.385, screen_size[2] / 2)
		local m_alpha, m_width, m_active, m_contents, unsorted = 0, 0, {}, {}, {}

		local get_spectating_players = function()
			local me = entity_get_local_player()

			local players, observing = { }, me
		
			for i = 1, globals_maxplayers() do
				if entity_get_classname(i) == 'CCSPlayer' then
					local m_iObserverMode = entity_get_prop(i, 'm_iObserverMode')
					local m_hObserverTarget = entity_get_prop(i, 'm_hObserverTarget')
		
					if m_hObserverTarget ~= nil and m_hObserverTarget <= 64 and not entity_is_alive(i) and (m_iObserverMode == 4 or m_iObserverMode == 5) then
						if players[m_hObserverTarget] == nil then
							players[m_hObserverTarget] = { }
						end
		
						if i == me then
							observing = m_hObserverTarget
						end
		
						table_insert(players[m_hObserverTarget], i)
					end
				end
			end
		
			return players, observing
		end

		local g_paint_handler = function()
			local data_sp = script_db.spectators or { }

			local master_switch = ui_get(ms_spectators)
			local is_menu_open = ui_is_menu_open()
			local frames = 8 * globals_frametime()
		
			local latest_item = false
			local maximum_offset = 83

			local me = entity_get_local_player()
			local spectators, player = get_spectating_players()
		
			for i=1, 64 do 
				unsorted[i] = {
					idx = i,
					active = false
				}
			end
		
			if spectators[player] ~= nil then
				for _, spectator in pairs(spectators[player]) do
					unsorted[spectator] = { 
						idx = spectator,
		
						active = (function()
							if spectator == me then
								return false
							end

							return true
						end)(),

						avatar = (function()
							if not data_sp.avatars then
								return nil
							end

							local steam_id = entity_get_steam64(spectator)
							local avatar = images.get_steam_avatar(steam_id)
		
							if steam_id == nil or avatar == nil then
								return nil
							end
		
							if m_contents[spectator] == nil or m_contents[spectator].conts ~= avatar.contents then
								m_contents[spectator] = {
									conts = avatar.contents,
									texture = renderer_load_rgba(avatar.contents, avatar.width, avatar.height)
								}
							end
		
							return m_contents[spectator].texture
						end)()
					}
				end
			end
		
			for _, c_ref in pairs(unsorted) do
				local c_id = c_ref.idx
				local c_nickname = entity_get_player_name(c_ref.idx)
		
				if c_ref.active then
					latest_item = true
		
					if m_active[c_id] == nil then
						m_active[c_id] = {
							alpha = 0, offset = 0, active = true
						}
					end
		
					local text_width = renderer_measure_text(nil, c_nickname)
		
					m_active[c_id].active = true
					m_active[c_id].offset = text_width
					m_active[c_id].alpha = m_active[c_id].alpha + frames
					m_active[c_id].avatar = c_ref.avatar
					m_active[c_id].name = c_nickname
		
					if m_active[c_id].alpha > 1 then
						m_active[c_id].alpha = 1
					end
				elseif m_active[c_id] ~= nil then
					m_active[c_id].active = false
					m_active[c_id].alpha = m_active[c_id].alpha - frames
		
					if m_active[c_id].alpha <= 0 then
						m_active[c_id] = nil
					end
				end
		
				if m_active[c_id] ~= nil and m_active[c_id].offset > maximum_offset then
					maximum_offset = m_active[c_id].offset
				end
			end
		
			if is_menu_open and not latest_item then
				local case_name = ' '
				local text_width = renderer_measure_text(nil, case_name)
		
				latest_item = true
				maximum_offset = maximum_offset < text_width and text_width or maximum_offset
		
				m_active[case_name] = {
					name = '',
					active = true,
					offset = text_width,
					alpha = 1
				}
			end
		
			local text = 'spectators'
			local x, y = dragging:get()
			local r, g, b, a = get_bar_color()
		
			local height_offset = 22
			local w, h = 55 + maximum_offset, 50
		
			if m_width == nil then
				m_width = w;
			end

			m_width = solus_render.lerp(m_width, w, 0.115);
			w = round(m_width)

			w = w - (data_sp.avatars and 0 or 17) 

			local right_offset = data_sp.auto_position and (x+w/2) > (({ client_screen_size() })[1] / 2)

			solus_render.container(x, y + 2, w, 19, r, g, b, m_alpha*a, m_alpha)
		
			renderer_text(x - renderer_measure_text(nil, text) / 2 + w/2, y + 4, 255, 255, 255, m_alpha*255, '', 0, text)
		
			for c_name, c_ref in pairs(m_active) do
				local _, text_h = renderer_measure_text(nil, c_ref.name)

				renderer_text(x + ((c_ref.avatar and not right_offset) and text_h or -5) + 10, y + height_offset, 255, 255, 255, m_alpha*c_ref.alpha*255, '', 0, c_ref.name)
		
				if c_ref.avatar ~= nil then
					renderer_texture(c_ref.avatar, x + (right_offset and w - 15 or 5), y + height_offset, text_h, text_h, 255, 255, 255, m_alpha*c_ref.alpha*255, 'f')
				end
		
				height_offset = height_offset + 15
			end

			dragging:drag(w, (3 + (15 * item_count(m_active))) * 2)

			if master_switch and item_count(m_active) > 0 and latest_item then
				m_alpha = m_alpha + frames; if m_alpha > 1 then m_alpha = 1 end
			else
				m_alpha = m_alpha - frames; if m_alpha < 0 then m_alpha = 0 end 
			end
		
			if is_menu_open then
				m_active[' '] = nil
			end
		end

		client_set_event_callback('paint', g_paint_handler)
	end,

	keybinds = function()
		local screen_size = { client_screen_size() }
		local screen_size = {
			screen_size[1] - screen_size[1] * cvar.safezonex:get_float(),
			screen_size[2] * cvar.safezoney:get_float()
		}

		local dragging = dragging_fn('Keybinds', screen_size[1] / 1.385, screen_size[2] / 2.5)

		local m_alpha, m_width, m_active = 0, nil, { }
		local hotkey_modes = { 'holding', 'toggled', 'disabled' }

		local elements = {
			rage = { 'aimbot', 'other' },
			aa = { 'anti-aimbot angles', 'fake lag', 'other' },
			legit = { 'weapon type', 'aimbot', 'triggerbot', 'other' },
			visuals = { 'player esp', 'colored models', 'other esp', 'effects' },
			misc = { 'miscellaneous', 'movement', 'settings' },
			skins = { 'knife options', 'glove options', 'weapon skin' },
			players = { 'players', 'adjustments' },
			config = { 'presets', 'lua' },
			lua = { 'a', 'b' }
		}

		local reference_if_exists = function(...)
			if pcall(ui_reference, ...) then
				 return true
			end
		end

		local create_item = function(data)
			local collected = { }

			local cname = data.custom_name
			local reference = { ui_reference(unpack(data.reference)) }
		
			for i=1, #reference do
				if i <= data.ui_offset then
					collected[i] = reference[i]
				end
			end
		
			cname = (cname and #tostring(cname) > 0) and cname or nil

			data.reference[3] = data.ui_offset == 2 and ui_name(collected[1]) or data.reference[3]

			m_hotkeys[cname or (data.reference[3] or '?')] = {
				reference = data.reference,

				ui_offset = data.ui_offset,
				custom_name = cname,
				custom_file = data.require,
				collected = collected
			}

			return true
		end
		
		local create_custom_item = function(pdata)
			local reference = pdata.reference

			if  reference == nil or elements[reference[1]:lower()] == nil or 
				not contains(elements[reference[1]:lower()], reference[2]:lower()) then
				return false
			end

			if reference_if_exists(unpack(reference)) then
				return create_item(pdata)
			else
				if pcall(require, pdata.require) and reference_if_exists(unpack(reference)) then
					return create_item(pdata)
				else
					local name = (pdata.require and #pdata.require > 0) and (pdata.require .. '.lua') or '-'

					client_color_log(216, 181, 121, ('[%s] \1\0'):format(script_name))
					client_color_log(155, 220, 220, ('Unable to reference hotkey: %s [ %s ]'):format(reference[3], name))
				end
			end

			return false
		end

		local g_paint_handler = function()
			local master_switch = ui_get(ms_keybinds)

			local is_menu_open = ui_is_menu_open()
			local frames = 8 * globals_frametime()
		
			local latest_item = false
			local maximum_offset = 66

			if m_hotkeys_update == true then
				m_hotkeys = { }
				m_active = { }

				for _, item in pairs((script_db.keybinds or { })) do
					create_custom_item({
						reference = item.reference,
						custom_name = item.custom_name,
						ui_offset = item.ui_offset or 1,
						require = item.require
					})
				end

				m_hotkeys_update = false
			end
		
			for c_name, c_data in pairs(m_hotkeys) do
				local item_active = true
				local c_ref = c_data.collected

				local items = item_count(c_ref)
				local state = { ui_get(c_ref[items]) }
		
				if items > 1 then
					item_active = ui_get(c_ref[1])
				end
		
				if item_active and state[2] ~= 0 and (state[2] == 3 and not state[1] or state[2] ~= 3 and state[1]) then
					latest_item = true
		
					if m_active[c_name] == nil then
						m_active[c_name] = {
							mode = '', alpha = 0, offset = 0, active = true
						}
					end
		
					local text_width = renderer_measure_text(nil, c_name)
		
					m_active[c_name].active = true
					m_active[c_name].offset = text_width
					m_active[c_name].mode = hotkey_modes[state[2]]
					m_active[c_name].alpha = m_active[c_name].alpha + frames
		
					if m_active[c_name].alpha > 1 then
						m_active[c_name].alpha = 1
					end
				elseif m_active[c_name] ~= nil then
					m_active[c_name].active = false
					m_active[c_name].alpha = m_active[c_name].alpha - frames
		
					if m_active[c_name].alpha <= 0 then
						m_active[c_name] = nil
					end
				end
		
				if m_active[c_name] ~= nil and m_active[c_name].offset > maximum_offset then
					maximum_offset = m_active[c_name].offset
				end
			end

			if is_menu_open and not latest_item then
				local case_name = 'Menu toggled'
				local text_width = renderer_measure_text(nil, case_name)
		
				latest_item = true
				maximum_offset = maximum_offset < text_width and text_width or maximum_offset
		
				m_active[case_name] = {
					active = true,
					offset = text_width,
					mode = '~',
					alpha = 1,
				}
			end
		
			local text = 'keybinds'
			local x, y = dragging:get()
			local r, g, b, a = get_bar_color()
			local height_offset = 22
			local w, h = 75 + maximum_offset, 50

			if m_width == nil then
				m_width = w;
			end

			m_width = solus_render.lerp(m_width, w, 0.115);
			w = round(m_width)
			
			solus_render.container(x, y + 2, w, 19, r, g, b, m_alpha*a, m_alpha)
			renderer_text(x - renderer_measure_text(nil, text) / 2 + w/2, y + 4, 255, 255, 255, m_alpha*255, '', 0, text )
		
			for c_name, c_ref in pairs(m_active) do
				local key_type = '[' .. (c_ref.mode or '?') .. ']'
		
				renderer_text(x + 5, y + height_offset, 255, 255, 255, m_alpha*c_ref.alpha*255, '', 0, c_name)
				renderer_text(x + w - renderer_measure_text(nil, key_type) - 5, y + height_offset, 255, 255, 255, m_alpha*c_ref.alpha*255, '', 0, key_type)
		
				height_offset = height_offset + round(15 * c_ref.alpha)
			end

			dragging:drag(w, (3 + (15 * item_count(m_active))) * 2)

			if master_switch and item_count(m_active) > 0 and latest_item then
				m_alpha = m_alpha + frames

				if m_alpha > 1 then 
					m_alpha = 1
				end
			else
				m_alpha = m_alpha - frames

				if m_alpha < 0 then
					m_alpha = 0
				end 
			end
		
			if is_menu_open then
				m_active['Menu toggled'] = nil
			end
		end
		

		m_hotkeys_create = create_custom_item

		client_set_event_callback('paint', g_paint_handler)
	end,



	antiaim = function()
        local note = notes 'a_wbantiaim'
        
        local gram_fyaw = gram_create(0, 2)
        local teleport_data = gram_create(0, 3)

		local m_exploit, m_fl, m_width = 0, 0, 0

        local ind_phase, ind_num, ind_time = 0, 0, 0
        local last_sent, current_choke = 0, 0
        local teleport, last_origin = 0
        local breaking_lc = 0

        local g_setup_command = function(c)
            local me = entity_get_local_player()
        
            if c.chokedcommands == 0 then
                local m_origin = vector(entity_get_origin(me))
        
                if last_origin ~= nil then
                    teleport = (m_origin-last_origin):length2dsqr()
        
                    gram_update(teleport_data, teleport, true)
                end
        
                gram_update(gram_fyaw, math_abs(anti_aim.get_desync(1)), true)
        
                last_sent = current_choke
                last_origin = m_origin
            end
        
            breaking_lc = 
                get_average(teleport_data) > 3200 and 1 or
                    (anti_aim.get_tickbase_shifting() > 0 and 2 or 0)
        
            current_choke = c.chokedcommands
        end

        local g_paint_handler = function()
            local me = entity_get_local_player()

            local state = ui_get(ms_antiaim) or ui_get(ms_lags_exploit)
            local _, _, _, a = get_bar_color()

            if me == nil or not entity_is_alive(me) then
                note.set_state(false)
                return
            end

            note.set_state(state)
            note.get(function(id)
                local x, y = client_screen_size() - 10, 8 + (25 * id)

                local ms_clr = {ui_get(ms_color)}
        
                local fr = globals_frametime() * 3.75
                local min_offset = 1200+math_max(0, get_average(teleport_data)-3800)
                local teleport_mt = math_abs(math_min(teleport-3800, min_offset) / min_offset * 100)

                local recharging = anti_aim.get_tickbase_shifting() == 0
				
                if ind_num ~= teleport_mt and ind_time < globals_realtime() then
                    ind_time = globals_realtime() + 0.005
                    ind_num = ind_num + (ind_num > teleport_mt and -1 or 1)
                end
        
                ind_phase = ind_phase + (breaking_lc == 1 and fr or -fr)
                ind_phase = ind_phase > 1 and 1 or ind_phase
                ind_phase = ind_phase < 0 and 0 or ind_phase
 
                m_exploit = solus_render.lerp(m_exploit, (breaking_lc == 2) and 1 or 0, 0.065);
                m_fl = solus_render.lerp(m_fl, (not recharging) and 1 or 0, 0.065);

                local r1, g1, b1 = get_bar_color()
                if ui_get(ms_lags_exploit) then
                if m_exploit > 0.01 then
                    local text = 'EXPLOITING';
                    local text_size = renderer_measure_text(nil, text);

                    local w = text_size + 8;
                    local h = 17;

                    x = x - w

                    local r, g, b = r1, g1, b1

                    solus_render.container_glow(x, y, w, h, r, g, b, a * m_exploit, m_exploit, r, g, b);
                    renderer_gradient(x, y + h - 1, w/2, 1, 0, 0, 0, 25 * m_exploit, r, g, b, 255 * m_exploit, true);
                    renderer_gradient(x + w/2 - 1, y + h - 1, w - w/2, 1, r, g, b, 255 * m_exploit, 0, 0, 0, 25 * m_exploit, true);

                    renderer_text(x + 4, y + 2, 255, 255 * m_exploit, 255 * m_exploit, 255 * m_exploit, '', 0, text)
                    x = x + w - (w + 5) * m_exploit
                end


                if m_fl > 0.01 then
                    local text = ('FL: %s'):format(
                        (function()
                            if tonumber(last_sent) < 10 then
                                return '\x20\x20' .. last_sent
                            end
    
                            return last_sent
                        end)()
                    )
    
                    local r, g, b = 255, 0, 0
                    
                    if ind_phase > 0.1 then
                        text = text .. ' | dst: \x20\x20\x20\x20\x20\x20\x20\x20\x20'
                        r, g, b = 124, 195, 13
                    end
    
                    local text_size = renderer_measure_text(nil, text);
    
                    local w = text_size + 8;
                    local h = 17;
    
                    x = x - w
    
                    solus_render.horizontal_container(x, y, w, h, r, g, b, a * m_fl, m_fl, r1, g1, b1)
                    renderer_text(x + 4, y + 2, 255, 255, 255, 255 * m_fl, '', 0, text)
                        if ind_phase > 0 then
                        renderer_gradient(
                            x + w - renderer_measure_text(nil, ' | dst: ') + 2, 
                            y + 6, math_min(100, ind_num) / 100 * 24, 5,
                            
                            ms_clr[1], ms_clr[2], ms_clr[3], m_fl * (ind_phase * 220),
                            ms_clr[1], ms_clr[2], ms_clr[3], m_fl * (ind_phase * 25),
    
                            true
                        )
                        end
                    x = x + w - (w + 5) * m_fl
                end
			end
                
                -- FAKE INDICATION
				if ui_get(ms_antiaim) then
                local lower_body = anti_aim.get_balance_adjust()
                local r, g, b = get_color(math_abs(anti_aim.get_desync()), 30)
				local r1, g1, b1 = get_bar_color()
        
                local timer = (lower_body.next_update - globals_curtime()) / 1.1 * 1
                local add_text = (lower_body.updating and timer >= 0) and '\x20\x20\x20\x20\x20' or ''
        
                local text = ('%sFAKE (%.1f°)'):format(add_text, get_average(gram_fyaw))
                local h, w = 17, renderer_measure_text(nil, text) + 8
        
                -- INDICATIN COLOR
                local dec = { r - (r/100 * 50), g - (g/100 * 50), b - (b/100 * 50) }
				
                x = x - w + 3
				solus_render.horizontal_container(x - 4 , y, w, h, r, g, b, a, 1.0, r1, g1, b1)
                renderer_text(x, y + 2, 255, 255, 255, 255, '', 0, text)
        
                if lower_body.updating and timer >= 0 then
                    renderer_circle_outline(x + 6, y + 8.5, 89, 119, 239, 255, 5, 0, timer, 2)
                end
			end
            end)
        end

        client_set_event_callback('setup_command', g_setup_command)
        client_set_event_callback('paint_ui', g_paint_handler)
	end,

    ilstate = function()
		local note = notes 'a_winput'
        local graphics = graphs()
		
        local formatting = (function(avg)
            if avg < 1 then return ('%.2f'):format(avg) end
            if avg < 10 then return ('%.1f'):format(avg) end
            return ('%d'):format(avg)
        end)

        local jmp_ecx = client.find_signature('engine.dll', '\xFF\xE1')
        local fnGetModuleHandle = ffi.cast('uint32_t(__fastcall*)(unsigned int, unsigned int, const char*)', jmp_ecx)
        local fnGetProcAddress = ffi.cast('uint32_t(__fastcall*)(unsigned int, unsigned int, uint32_t, const char*)', jmp_ecx)
        
        local pGetProcAddress = ffi.cast('uint32_t**', ffi.cast('uint32_t', client.find_signature('engine.dll', '\xFF\x15\xCC\xCC\xCC\xCC\xA3\xCC\xCC\xCC\xCC\xEB\x05')) + 2)[0][0]
        local pGetModuleHandle = ffi.cast('uint32_t**', ffi.cast('uint32_t', client.find_signature('engine.dll', '\xFF\x15\xCC\xCC\xCC\xCC\x85\xC0\x74\x0B')) + 2)[0][0]
        local BindExports = function(sModuleName, sFunctionName, sTypeOf) local ctype = ffi.typeof(sTypeOf) return function(...) return ffi.cast(ctype, jmp_ecx)(fnGetProcAddress(pGetProcAddress, 0, fnGetModuleHandle(pGetModuleHandle, 0, sModuleName), sFunctionName), 0, ...) end end
        
        local fnEnumDisplaySettingsA = BindExports("user32.dll", "EnumDisplaySettingsA", "int(__fastcall*)(unsigned int, unsigned int, unsigned int, unsigned long, void*)");
        local pLpDevMode = ffi.new("struct { char pad_0[120]; unsigned long dmDisplayFrequency; char pad_2[32]; }[1]")
        
        local gram_create = function(value, count) local gram = { }; for i=1, count do gram[i] = value; end return gram; end
        local gram_update = function(tab, value, forced) local new_tab = tab; if forced or new_tab[#new_tab] ~= value then table_insert(new_tab, value); table_remove(new_tab, 1); end; tab = new_tab; end
        local get_average = function(tab) local elements, sum = 0, 0; for k, v in pairs(tab) do sum = sum + v; elements = elements + 1; end return sum / elements; end
        
        local renderTime = client.timestamp()
        local lag_data = gram_create(0, 90)
        local fps_data = gram_create(0, 30)
        local g_frameRate, g_prev_frameRate = 0, 0
        
        local post_render, pre_render = function()
            renderTime = client.timestamp()
        end, function()
            gram_update(lag_data, client.timestamp() - renderTime)
        end
        
        client_set_event_callback('post_render', post_render)
        client_set_event_callback('pre_render', pre_render)

        fnEnumDisplaySettingsA(0, 4294967295, pLpDevMode[0])

		local g_paint_handler = function()
            g_frameRate = 0.9 * g_frameRate + (1.0 - 0.9) * globals_absoluteframetime()
            gram_update(fps_data, math_abs(g_prev_frameRate-(1/g_frameRate)), true)
            g_prev_frameRate = 1/g_frameRate

			local state = ui_get(ms_ieinfo)
			local _, _, _, a = get_bar_color()

      note.set_state(state)
			note.get(function(id)

                local r, g, b = get_bar_color()

                local avg = get_average(lag_data)
                local display_frequency = tonumber(pLpDevMode[0].dmDisplayFrequency)
				local text = ('%sms / %dhz'):format(formatting(avg), display_frequency)
		
                local interp = { get_color(15-avg, 15) }

				local h, w = 17, renderer_measure_text(nil, text) + 8
				local x, y = client_screen_size(), 6 + (25*id)
		
				x = x - w - 10

				solus_render.container_glow(x, y, w, h, r, g, b, a, 1.2, r, g, b)

                renderer_gradient(x, y+h - 1, (w/2), 1, 0, 0, 0, 25, interp[1], interp[2], interp[3], 255, true)
                renderer_gradient(x + w/2, y+h - 1, w-w/2, 1, interp[1], interp[2], interp[3], 255, 0, 0, 0, 25, true)

				renderer_text(x+4, y + 2, 255, 255, 255, 255, '', 0, text)

                x = x - w + 20

                local text = 'IO | '
                local sub = text .. '\x20\x20\x20\x20\x20\x20\x20'
                local h, w = 17, renderer_measure_text(nil, sub) + 8
                local ie_w = renderer_measure_text(nil, text) + 4

                local g_nValues_t = { 
                    avg, 1, 3, 
                    get_average(fps_data)/4, 0
                }

                local min_value, max_value = 
                    math_min(unpack(g_nValues_t)), 
                    math_max(unpack(g_nValues_t))

				solus_render.horizontal_container(x - 4, y, w, h, r, g, b, a, 1.0, r, g, b)
                renderer_text(x, y + 2, 255, 255, 255, 255, '', 0, sub)

                graphics:draw_histogram(g_nValues_t, 0, max_value, #g_nValues_t, {
                    -- x, y, w, h
                    x = x - 4 + ie_w,
                    y = y + 4, 
                    w = w - ie_w - 4,
                    h = h - 8,
            
                    sDrawBar = "gradient_fadein", -- "none", "fill", "gradient_fadeout", "gradient_fadein"
                    bDrawPeeks = false,
                    thickness = 1,
            
                    clr_1 = { r, g, b, 255 },
                    clr_2 = { 0, 127, 255, 255 },
                }, false)
			end)
		end

		client_set_event_callback('paint_ui', g_paint_handler)
    end,

	editor = function()
		local data_editor = function()
			local editor, editor_data, editor_cache, editor_callback = 
				ui_new_checkbox(menu_tab[1], menu_tab[2], 'Solus Data editor'), { }, { }, function() end
			
			for name, val in pairs(script_db) do
				if name ~= 'keybinds' then
					table_insert(editor_data, ui.new_label(menu_tab[1], menu_tab[2], name:upper()))
	ui.set_visible(editor, false)
					for sname, sval in pairs(val) do
						local sval_type = type(sval)

						local _action = {
							['string'] = function()
								local _cfunction
								local label, textbox = 
									ui.new_label(menu_tab[1], menu_tab[2], ('	  > %s \n %s:%s'):format(sname, name, sname)), 
									ui.new_textbox(menu_tab[1], menu_tab[2], ('%s:%s'):format(name, sname))
	
								ui_set(textbox, script_db[name][sname])
	
								_cfunction = function()
									script_db[name][sname] = ui_get(textbox)
									client_delay_call(0.01, function()
										_cfunction()
									end)
								end
	
								_cfunction()
	
								return { label, textbox }
							end,
	
							['boolean'] = function()
								local checkbox = ui_new_checkbox(menu_tab[1], menu_tab[2], ('	  > %s \n %s:%s'):format(sname, name, sname))
	
								ui_set(checkbox, sval)
								ui_set_callback(checkbox, function(c)
									script_db[name][sname] = ui_get(c)
								end)
	
								return { checkbox }
							end,
	
							['table'] = function()
								local slider = ui_new_slider(menu_tab[1], menu_tab[2], ('	  > %s \n %s:%s'):format(sname, name, sname), sval.min, sval.max, sval.init_val, true, nil, sval.scale)
	
								ui_set(slider, sval.value or sval.init_val)
								ui_set_callback(slider, function(c)
									script_db[name][sname].value = ui_get(c)
								end)
	
								return { slider }
							end
						}
	
						if _action[sval_type] ~= nil then
							for _, val in pairs(_action[sval_type]()) do
								table_insert(editor_data, val)
							end
						end
					end
				end
			end
	
			local pre_config_save = function()
				ui_set(editor, false)
	
		
				for _, ref in pairs(editor_data) do
					editor_cache[ref] = ui_get(ref)
				end
			end
		
			local post_config_save = function()
				ui_set(editor, false)
				
				for _, ref in pairs(editor_data) do
					if editor_cache[ref] ~= nil then
						ui_set(ref, editor_cache[ref])
						editor_cache[ref] = nil
					end
				end
			end
		
			client_set_event_callback('pre_config_save', function() pre_config_save() end)
			client_set_event_callback('post_config_save', function() post_config_save() end)
			client_set_event_callback('pre_config_load', function() pre_config_save() end)
			client_set_event_callback('post_config_load', function() post_config_save() end)
	
			editor_callback = function()
				local editor_active = ui_get(editor)
		
				for _, ref in pairs(editor_data) do
					ui_set_visible(ref, editor_active)
				end
			end
		
			ui_set_callback(editor, editor_callback)
			editor_callback()
		end
	
		local keybind_editor = function()
			local create_table = function(tbl)
				local new_table = { }
		
				for k in pairs(tbl) do
					table_insert(new_table, k)
				end
			
				table_sort(new_table, function(a, b) 
					return a:lower() < b:lower() 
				end)
		
				local new_table2 = { 
					'» Create new keybind'
				}
		
				for i=1, #new_table do
					table_insert(new_table2, new_table[i])
				end
		
				return new_table2
			end
		
			local generate_kb = function()
				local new_table = { }
				
				for id, hotkey in pairs(script_db.keybinds) do
					local custom_name = hotkey.custom_name
					custom_name = (custom_name and #tostring(custom_name) > 0) and custom_name or nil
	
					new_table[custom_name or (hotkey.reference[3] or '?')] = {
						hotkey_id = id,
						reference = hotkey.reference,
						custom_name = hotkey.custom_name,
						ui_offset = hotkey.ui_offset,
						require = hotkey.require
					}
				end
	
				return new_table
			end
			
			local hk_callback, listbox_callback
			local original_hk = {
				reference = { '', '', '' },
				custom_name = '',
				ui_offset = 1,
				require = ''
			}
	
			local offset_type = {
				'Basic',
				'Extended'
			}
	
			local new_hotkey = original_hk
			
			local hk_database = generate_kb()
			local hk_list = create_table(hk_database)
	
			local hk_editor = ui_new_checkbox(menu_tab[1], menu_tab[2], 'Solus Hotkey editor')
			local listbox = ui_new_listbox(menu_tab[1], menu_tab[2], 'Solus Keybinds', hk_list)
			ui.set_visible(hk_editor, false)
			local require = {
				ui_new_checkbox(menu_tab[1], menu_tab[2], 'Custom hotkey'),
		
				ui.new_label(menu_tab[1], menu_tab[2], 'File name (without ".lua")'),
				ui.new_textbox(menu_tab[1], menu_tab[2], 'solus:keybinds:required_file')
			}
		
			local custom_name = {
				ui_new_checkbox(menu_tab[1], menu_tab[2], 'Custom name'),
				ui.new_label(menu_tab[1], menu_tab[2], 'Original name'),
				ui.new_textbox(menu_tab[1], menu_tab[2], 'solus:keybinds:custom_name')
			}
	
			local reference = {
				ui.new_label(menu_tab[1], menu_tab[2], 'Reference'),
				ui.new_textbox(menu_tab[1], menu_tab[2], 'solus:keybinds:reference1'),
				ui.new_textbox(menu_tab[1], menu_tab[2], 'solus:keybinds:reference2'),
				ui.new_textbox(menu_tab[1], menu_tab[2], 'solus:keybinds:reference3')
			}
	
			local ui_offset = {
				ui.new_combobox(menu_tab[1], menu_tab[2], 'Hotkey type', offset_type),
				ui.new_hotkey(menu_tab[1], menu_tab[3], ('Example: %s'):format(offset_type[1])),
	
				ui_new_checkbox(menu_tab[1], menu_tab[3], ('Example: %s'):format(offset_type[2])),
				ui.new_hotkey(menu_tab[1], menu_tab[3], ' ', true),
	
				ui.new_combobox(menu_tab[1], menu_tab[3], ('Example: %s'):format(offset_type[2]), '-'),
				ui.new_hotkey(menu_tab[1], menu_tab[3], ' ', true),
			}
	
			local save_changes = ui_new_button(menu_tab[1], menu_tab[2], 'Save Changes', function()
				local selected = hk_list[ui_get(listbox)+1] or hk_list[1]
				local ui_offset = ui_get(ui_offset[1]) == offset_type[2] and 2 or 1
	
				local reference = { ui_get(reference[2]):lower(), ui_get(reference[3]):lower(), ui_get(reference[4]) }
				local custom_name = ui_get(custom_name[1]) and ui_get(custom_name[3]) or ''
	
				if selected ~= hk_list[1] then
					local cdata = hk_database[selected]
	
					if cdata ~= nil then
						script_db.keybinds[cdata.hotkey_id] = {
							ui_offset = ui_offset,
							reference = reference,
							require = ui_get(require[1]) and ui_get(require[3]):lower() or '',
							custom_name = custom_name
						}
					end
				else
					local can_create, item = true, {
						ui_offset = ui_offset,
						reference = reference,
						require = ui_get(require[1]) and ui_get(require[3]) or '',
						custom_name = custom_name
					}
	
					local item_ref = { 
						item.reference[1]:lower(),
						item.reference[2]:lower(),
						item.reference[3]:lower()
					}
	
					for id, val in pairs(script_db.keybinds) do
						local val_ref = { 
							val.reference[1]:lower(),
							val.reference[2]:lower(),
							val.reference[3]:lower()
						}
	
						if val_ref[1] == item_ref[1] and val_ref[2] == item_ref[2] and val_ref[3] == item_ref[3] then
							can_create = false
							break
						end
					end
	
					if can_create and m_hotkeys_create(item) then
						script_db.keybinds[#script_db.keybinds+1] = item
	
						client_color_log(216, 181, 121, ('[%s] \1\0'):format(script_name))
						client_color_log(255, 255, 255, 'Created hotkey \1\0')
						client_color_log(155, 220, 220, ('[ %s ]'):format(table_concat(item.reference, ' > ')))
					end
	
					if not can_create then
						client_color_log(216, 181, 121, ('[%s] \1\0'):format(script_name))
						client_color_log(255, 255, 255, 'Could\'nt create hotkey \1\0')
						client_color_log(155, 220, 220, '[ keybind already exists ]')
						error()
					end
				end
	
				m_hotkeys_update = true
	
				hk_database = generate_kb()
				hk_list = create_table(hk_database)
	
				ui_update(listbox, hk_list)
				
				listbox_callback(listbox)
				hk_callback()
			end)
	
			local delete_hk = ui_new_button(menu_tab[1], menu_tab[2], 'Delete Hotkey', function()
				local selected = hk_list[ui_get(listbox)+1] or hk_list[1]
	
				if selected ~= hk_list[1] then
					local cdata = hk_database[selected]
	
					script_db.keybinds[cdata.hotkey_id] = nil
	
					local new_db = { }
	
					for i=1, #script_db.keybinds do
						if script_db.keybinds[i] ~= nil then
							new_db[#new_db+1] = script_db.keybinds[i]
						end
					end
	
					script_db.keybinds = new_db
	
					client_color_log(216, 181, 121, ('[%s] \1\0'):format(script_name))
					client_color_log(255, 255, 255, 'Removed hotkey \1\0')
					client_color_log(155, 220, 220, ('[ %s ]'):format(table_concat(cdata.reference, ' > ')))
	
					m_hotkeys_update = true
	
					hk_database = generate_kb()
					hk_list = create_table(hk_database)
		
					ui_update(listbox, hk_list)
					
					listbox_callback(listbox)
					hk_callback()
					
				end
			end)
		
			hk_callback = function()
				local active = ui_get(hk_editor)
				local LBC = ui_get(listbox) == 0
		
				ui_set_visible(listbox, active)
		
				ui_set_visible(require[1], active and LBC)
				ui_set_visible(require[2], active and ui_get(require[1]) and LBC)
				ui_set_visible(require[3], active and ui_get(require[1]) and LBC)
		
				ui_set_visible(custom_name[1], active)
				ui_set_visible(custom_name[2], active and ui_get(custom_name[1]) and not LBC)
				ui_set_visible(custom_name[3], active and ui_get(custom_name[1]))
	
				ui_set_visible(reference[1], active)
				ui_set_visible(reference[2], active and LBC)
				ui_set_visible(reference[3], active and LBC)
				ui_set_visible(reference[4], active and LBC)
	
				ui_set_visible(save_changes, active)
				ui_set_visible(delete_hk, active and not LBC)
	
				for i=1, #ui_offset do
					ui_set_visible(ui_offset[i], active and LBC)
				end
			end
	
			listbox_callback = function(c)
				local local_bd = hk_database
				local selected = hk_list[ui_get(c)+1] or hk_list[1]
	
				local cdata = local_bd[selected]
	
				if cdata == nil then
					cdata = new_hotkey
				end
	
				local ext_data = {
					require = { #cdata.require > 0, cdata.require or '' },
					custom_name = { cdata.custom_name ~= '', ('Original name: %s'):format(cdata.reference[3]), cdata.custom_name },
	
					reference = { 
						('Reference: %s > %s (%d)'):format(cdata.reference[1], cdata.reference[2], cdata.ui_offset), 
						cdata.reference[1], cdata.reference[2], cdata.reference[3]
					},
	
					ui_offset = cdata.ui_offset
				}
	
				ui_set(reference[1], selected ~= hk_list[1] and ext_data.reference[1] or 'Reference')
	
				ui_set(require[1], ext_data.require[1])
				ui_set(require[3], ext_data.require[2])
			
				ui_set(custom_name[1], ext_data.custom_name[1])
				ui_set(custom_name[2], ext_data.custom_name[2])
				ui_set(custom_name[3], ext_data.custom_name[3])
	
				ui_set(reference[2], ext_data.reference[2])
				ui_set(reference[3], ext_data.reference[3])
				ui_set(reference[4], ext_data.reference[4])
	
				ui_set(ui_offset[1], offset_type[ext_data.ui_offset])
	
				hk_callback()
			end
	
			client_set_event_callback('pre_config_save', function() ui_set(hk_editor, false) end)
			client_set_event_callback('post_config_load', function() ui_set(hk_editor, false) end)
	
			ui_set_callback(hk_editor, hk_callback)
			ui_set_callback(listbox, listbox_callback)
			ui_set_callback(require[1], hk_callback)
			ui_set_callback(custom_name[1], hk_callback)
		
			hk_callback()
	
			return hk_editor
		end
	
		client_set_event_callback('console_input', function(e)
			local e = e:gsub(' ', '')
			local _action = {
				['solus:watermark:set_suffix'] = function()
					script_db.watermark.suffix = ''
					database.write(database_name, script_db)
		
					client_color_log(216, 181, 121, ('[%s] \1\0'):format(script_name))
					client_color_log(155, 220, 220, 'Suffix is now active')
	
					client_reload_active_scripts()
				end,
	
				['solus:watermark:unset_suffix'] = function()
					script_db.watermark.suffix = nil
					database.write(database_name, script_db)
		
					client_color_log(216, 181, 121, ('[%s] \1\0'):format(script_name))
					client_color_log(155, 220, 220, 'Suffix is now inactive')
	
					client_reload_active_scripts()
				end,
	
				['solus:reset'] = function()
					for name in pairs(script_db) do
						script_db[name] = name == 'keybinds' and script_db.keybinds or { }
					end
	
					database.write(database_name, script_db)
	
					client_color_log(216, 181, 121, ('[%s] \1\0'):format(script_name))
					client_color_log(255, 0, 0, 'Wiping data sectors')
	
					client_reload_active_scripts()
				end,
	
				['solus:keybinds:reset'] = function()
					script_db.keybinds = original_db.keybinds
	
					database.write(database_name, script_db)
	
					client_color_log(216, 181, 121, ('[%s] \1\0'):format(script_name))
					client_color_log(255, 0, 0, 'Wiping keybinds sector')
	
					client_reload_active_scripts()
				end
			}
	
			if _action[e] ~= nil then
				_action[e]()
	
				return true
			end
		end)
	
		data_editor()
		keybind_editor()
	end
}

ms_classes.watermark()
ms_classes.spectators()
ms_classes.keybinds()
ms_classes.antiaim()
ms_classes.ilstate()

client_delay_call(0.1, ms_classes.editor)
client_set_event_callback('shutdown', function()
	database.write(database_name, script_db)
end)

local ms_fade_callback = function()
	local active = ui_get(ms_palette)

	ui_set_visible(ms_rainbow_frequency, active ~= menu_palette[1] and active == menu_palette[2])
	ui_set_visible(ms_rainbow_split_ratio, active ~= menu_palette[1])
end

ui_set_callback(ms_palette, ms_fade_callback)
ms_fade_callback()


