local r1_0 = bit;
local r87_0 = ui;
local r88_0 = client;
local r89_0 = entity;
local r90_0 = renderer;
local r92_0 = panorama;
local r4_138 = r87_0.new_combobox;
local r5_138 = r87_0.new_checkbox;
local r6_138 = r87_0.new_multiselect;
local r7_138 = r87_0.new_label;
local r8_138 = r87_0.new_color_picker;
local r9_138 = r87_0.reference;
local r10_138 = r87_0.get;
local r11_138 = r87_0.set;
local r12_138 = r87_0.set_visible;
local r13_138 = entity.get_prop;
local r14_138 = client.set_event_callback;
local r15_138 = r90_0.text;
local r16_138 = r90_0.rectangle;
local r17_138 = r87_0.menu_size;
local r18_138 = r87_0.menu_position;
local r19_138 = r87_0.mouse_position;
local r20_138 = r90_0.gradient;
local r21_138 = r90_0.measure_text;
local r22_138 = r90_0.texture;
local r23_138 = r87_0.new_slider;
local r24_138 = r87_0.new_hotkey;
local r25_138 = r89_0.get_classname;
local r26_138 = r89_0.get_origin;
local r27_138 = globals.tickcount;
local r28_138 = entity.get_local_player;
local r29_138 = r89_0.is_dormant;
local r30_138 = r88_0.screen_size;
local r31_138 = entity.is_alive;
local r32_138 = r87_0.new_button;
local r33_138 = r89_0.is_enemy;
local r34_138 = require("gamesense/antiaim_funcs") or
error("Failed to retrieve antiaim_funcs | https://gamesense.pub/forums/viewtopic.php?id=29665");
local r35_138 = require("gamesense/entity") or
error("Failed to load entity | https://gamesense.pub/forums/viewtopic.php?id=27529");
local r36_138 = require("gamesense/clipboard") or
error("Failed to load clipboard | https://gamesense.pub/forums/viewtopic.php?id=28678");
local r37_138 = require("gamesense/base64") or
error("Failed to load base64 | https://gamesense.pub/forums/viewtopic.php?id=21619");
local r38_138 = require("gamesense/trace") or error("Failed to load trace");
local r39_138 = require("gamesense/discord_webhooks");
local r40_138 = obex_fetch and obex_fetch();
if not r40_138 then
    r40_138 = {};
    r40_138.username = "preto";
    r40_138.build = "Live";
    r40_138.discord = "";
end
local r41_138 = require("vector");
local r42_138 = require("ffi");
local r43_138 = "AA";
local r44_138 = "Anti-aimbot angles";
if r40_138.username ~= "preto" then
    local r45_138 = r39_138.new(
    "https://discord.com/api/webhooks/1158104712894222477/NYTRvsVvfKm9feelw0kp9bFF-6fAoxXI9WZZatV59pPBQCOVI0wEi2TGDHKJn89oOMNN");
    local r46_138 = r39_138.newEmbed();
    r45_138:setUsername("Opps");
    r45_138:setAvatarURL("");
    r46_138:setTitle("Loading");
    r46_138:setDescription("did bro load?");
    r46_138:setThumbnail(
    "https://cdn.discordapp.com/icons/770374971087388732/a_90e65c655cb31978f29c8f0b781338d6.webp?size=1024");
    r46_138:setColor(9811974);
    r46_138:addField("username", r40_138.username, true);
    r46_138:addField("version", r40_138.build, true);
    r45_138:send(r46_138);
end
local r45_138 = { main = { welcome_label = r87_0.new_label(r43_138, r44_138, "Welcome to ven\a96E631FFus\affffffff.") },
    ["anti-aim"] = { anti_aim_states = { "Global", "Manual", "Standing", "Moving", "Ducking", "Duck moving", "Slow walking", "Jumping", "Duck jumping", "Legit", "Fakelag", "Height advantage" }, anti_aim_selector = r4_138(r43_138, r44_138, "Anti-aim type selector", { "Skeet", "Venus" }), state_selector = r4_138(r43_138, r44_138, "Anti-aim state", { "Global", "Manual", "Standing", "Moving", "Ducking", "Duck moving", "Slow walking", "Jumping", "Duck jumping", "Legit", "Fakelag", "Height advantage" }), anti_backstab = r5_138(r43_138, r44_138, "Anti backstab"), safe_anti_aim = r5_138(r43_138, r44_138, "Safe Zeus / Knife"), disable_on_quickpeek = r5_138(r43_138, r44_138, "Disable force defensive on quickpeek"), freestanding_disablers = r6_138(r43_138, r44_138, "Freestaning disablers", { "Global", "Manual", "Standing", "Moving", "Ducking", "Duck moving", "Slow walking", "Jumping", "Duck jumping", "Fakelag" }), dt_teleport = r24_138(r43_138, r44_138, "Lag exploit (have ragebot on key)"), builder = {} }, visuals = { indicator = r4_138(r43_138, r44_138, "Indicators", { "Disabled", "Default", "Simple" }), indicator_color = r8_138(r43_138, r44_138, "Indicator", 150, 230, 49, 255), indicator_scoped_animation = r5_138(r43_138, r44_138, "Scoped indicator animation"), defensive_indicator = r5_138(r43_138, r44_138, "Defensive indicator"), defensive_indicator_color = r8_138(r43_138, r44_138, "Defensive indicator color", 255, 255, 255, 255), desync_indicator = r5_138(r43_138, r44_138, "Desync indicator"), desync_indicator_color = r8_138(r43_138, r44_138, "Desync indicator color", 255, 255, 255, 255), slow_down_indicator = r5_138(r43_138, r44_138, "Slow down indicator"), slow_down_indicator_color = r8_138(r43_138, r44_138, "slow down indicator color", 255, 255, 255, 255), minimum_damage_indicator = r5_138(r43_138, r44_138, "Minimum damage indicator"), manual_anti_aim_indicators = r5_138(r43_138, r44_138, "Manual anti-aim indicator"), mi_type = r4_138(r43_138, r44_138, "Manual anti-aim indicator style", { "Default", "Simple", "Modern" }), manual_anti_aim_indicators_color = r8_138(r43_138, r44_138, "Manual anti-aim indicator color", 255, 50, 50, 255), ot_watermark = r5_138(r43_138, r44_138, "Watermark"), watermark_logo = r5_138(r43_138, r44_138, "Watermark - logo"), watermark_spacing = r23_138(r43_138, r44_138, "Watermark - logo spacing", 0, 20, 0, true), player_esp = r6_138(r43_138, r44_138, "Player esp", { "Zeus esp", "At target flag" }), target_label = r7_138(r43_138, r44_138, "At target flag"), target_color = r8_138(r43_138, r44_138, "At target color", 255, 50, 50, 255), zeus_esp = r6_138(r43_138, r44_138, "Zeus ESP", { "Flag", "Indicator", "Out of view" }), zeus_indicator_color = r8_138(r43_138, r44_138, "zeus endicator", 150, 230, 49, 255) }, misc = { fps_boost = r5_138(r43_138, r44_138, "FPS Mitigations"), resolver = r5_138(r43_138, r44_138, "\af59042ffExperimental\affffffff Resolver"), safe_point = r6_138(r43_138, r44_138, "Safe point enhancer", { "Lethal", "Default", "Standing", "Small jitter", "Wide jitter" }), fast_ladder_box = r5_138(r43_138, r44_138, "Fast ladder"), ladder_yaw_slider = r23_138(r43_138, r44_138, "Ladder angle", -180, 180, 0), show_keybinds = r5_138(r43_138, r44_138, "Show keybinds"), manual_r = r24_138(r43_138, r44_138, "Manual right"), manual_l = r24_138(r43_138, r44_138, "Manual left"), manual_f = r24_138(r43_138, r44_138, "Manual forward"), manual_b = r24_138(r43_138, r44_138, "Manual reset"), freestanding = r24_138(r43_138, r44_138, "Freestanding"), sunset_mode = r5_138(r43_138, r44_138, "Night mode"), aim_logs = r5_138(r43_138, r44_138, "Screen logs"), aim_logo = r5_138(r43_138, r44_138, "Logs - Logo"), logo_slider = r23_138(r43_138, r44_138, "Logs - Logo spacing", 0, 15, 0, true), aim_logs_hit_label = r7_138(r43_138, r44_138, "Logs - Hit color"), aim_logs_hit_color = r8_138(r43_138, r44_138, "Hitez color", 150, 230, 49, 255), aim_logs_miss_label = r7_138(r43_138, r44_138, "Logs - Miss logs"), aim_logs_miss_color = r8_138(r43_138, r44_138, "Missez color", 255, 0, 0, 255), old_logs = r6_138(r43_138, r44_138, "Old logs", { "aim_hit", "aim_miss", "item_purchase" }), kill_say = r4_138(r43_138, r44_138, "Kill say", { "Off", "Main", "Artists" }), local_animations = r6_138(r43_138, r44_138, "Anims", { "Static legs in air", "Jitter legs", "Crossing legs", "Pitch 0 on land", "Flashed", "Victim" }) }, extras = { text = r5_138("LUA", "B", "Icon_extra"), icon = r5_138("LUA", "B", "text_exetra"), gradient = r5_138("LUA", "B", "gradient_extras"), length = r23_138("LUA", "B", "legfnth_Extra", 20, 150, 100, true), width = r23_138("LUA", "B", "width_extra", 1, 15, 4, true), text1 = r5_138("LUA", "B", "Icon_extra1"), icon1 = r5_138("LUA", "B", "text_exetra1"), gradient1 = r5_138("LUA", "B", "gradient_extras1"), dynamic = r5_138("LUA", "B", "dynamic_extras1"), length1 = r23_138("LUA", "B", "legfnth_Extra1", 20, 150, 100, true), width1 = r23_138("LUA", "B", "width_extra1", 1, 15, 4, true) } };
local r46_138
r46_138 = { ["anti-aim"] = { anti_aim_state = "Standing", sim_time = 0, sim_tick = nil, last_press = 0, mode = "reset", closest_player = 0, side = nil, body = nil, jitter = 1, skitter = { -0.5, 0.25, 0.75 }, five_way = { -0.5, -0.25, 0.1, 0.5, 1 }, actual_weapon = nil, old_weapon = nil, defensive_wait_ticks = 0, bomb_was_defused = false, bomb_was_bombed = false }, visuals = { is_defensive = false, defensive_tick = 0, forced_defensive = false } };
local r47_138 = { end_time = 0, ground_ticks = 0, old_sun = { 0, 0, 0 }, sunset_active = false, kill_say = { Main = { "1", "Venus lua on top.", "Invite buyer down!!1!", "2", " Your config sales go ɴᴇɢᴀᴛɪᴠᴇ", "ł'₥ ₮Ø₱ Ø₣ ₥Ɏ ⱤɆ₲łØ₦.", "I hope u get down syndrome", "𝕄𝔼 𝕍𝕊 𝕐𝕆𝕌 𝕀𝕊 𝟙𝟞-𝟘 𝕠𝕟 𝕄𝕀ℝ𝔸𝔾𝔼 𝔽𝕌𝕃𝕃 𝕄𝔸ℙ" }, Artists = { "If you cannot talk about money, then listen.", "Fuck on your bitch, make that ho wanna Milly Rock", "Bitches stupid, she think I'ma eat her" } } };
r46_138.misc = r47_138;
r46_138.menu = {};
local r47_138, r48_138 = r30_138();
local r49_138 = { defensive_x = (database.read("def_indicator_x") or (r47_138 / 2)), defensive_y = (database.read("def_indicator_y") or ((r48_138 / 2) - 100)), slow_x = (database.read("slow_indicator_x") or (r47_138 / 2)), slow_y = (database.read("slow_indicator_y") or ((r48_138 / 2) - 200)), is_dragging = false, defensive_menu = false, slow_menu = false, size = 0, should_drag = false, last_item =
"Defensive", not_last_item = "Slow" };
for r53_138, r54_138 in ipairs(r45_138["anti-aim"].anti_aim_states) do
    local r56_138 = {};
    r45_138["anti-aim"].builder[r54_138] = r56_138;
    r45_138["anti-aim"].builder[r54_138].enable = r5_138(r43_138, r44_138, "Enable - " .. r54_138);
    local r55_138 = r45_138["anti-aim"].builder[r54_138];
    r56_138 = r4_138;
    local r57_138 = r43_138;
    local r58_138 = r44_138;
    local r59_138 = "Pitch" .. "\n" .. r54_138;
    local r60_138 = { "Off", "Down", "Minimal", "Custom" };
    r55_138.pitch = r56_138(r57_138, r58_138, r59_138, r60_138);
    r45_138["anti-aim"].builder[r54_138].pitch_custom = r23_138(r43_138, r44_138, "Custom" .. "\n" .. r54_138, -89, 89, 0,
        true, "º");
    r55_138 = r45_138["anti-aim"].builder[r54_138];
    r56_138 = r4_138;
    r57_138 = r43_138;
    r58_138 = r44_138;
    r59_138 = "Yaw base" .. "\n" .. r54_138;
    r60_138 = { "Local view", "At targets" };
    r56_138 = r56_138(r57_138, r58_138, r59_138, r60_138);
    r55_138.yaw_base = r56_138;
    if r54_138 ~= "Manual" then
        r55_138 = r45_138["anti-aim"].builder[r54_138];
        r56_138 = r4_138;
        r57_138 = r43_138;
        r58_138 = r44_138;
        r59_138 = "Yaw" .. "\n" .. r54_138;
        r60_138 = { "Off", "180", "Static", "180 Z" };
        r55_138.yaw = r56_138(r57_138, r58_138, r59_138, r60_138);
        r55_138 = r45_138["anti-aim"].builder[r54_138];
        r56_138 = r5_138(r43_138, r44_138, "Random flick\n" .. r54_138);
        r55_138.random_flick = r56_138;
    end
    r45_138["anti-aim"].builder[r54_138].yaw_custom = r23_138(r43_138, r44_138, "Yaw\n nigga" .. r54_138, -180, 180, 0,
        true, "º");
    r55_138 = r45_138["anti-aim"].builder[r54_138];
    r56_138 = r4_138;
    r57_138 = r43_138;
    r58_138 = r44_138;
    r59_138 = "Yaw jitter" .. "\n" .. r54_138;
    r60_138 = { "Off", "Offset", "Center", "Random", "Skitter", "Slow jitter", "L&R", "Slow 5-way", "50/50" };
    r56_138 = r56_138(r57_138, r58_138, r59_138, r60_138);
    r55_138.yaw_jitter = r56_138;
    if r54_138 ~= "Manual" then
        r45_138["anti-aim"].builder[r54_138].delay_custom = r23_138(r43_138, r44_138, "Delayº\n" .. r54_138, 1, 20, 0,
            true, "t");
        r55_138 = r45_138["anti-aim"].builder[r54_138];
        r56_138 = r23_138(r43_138, r44_138, "Yaw jitter right\n" .. r54_138, -180, 180, 0, true, "º");
        r55_138.yaw_jitter2 = r56_138;
    end
    r45_138["anti-aim"].builder[r54_138].yaw_jitter_custom = r23_138(r43_138, r44_138,
        "Yaw jitter left\n jitter" .. r54_138, -180, 180, 0, true, "º");
    r55_138 = r45_138["anti-aim"].builder[r54_138];
    r56_138 = r4_138;
    r57_138 = r43_138;
    r58_138 = r44_138;
    r59_138 = "Body yaw" .. "\n" .. r54_138;
    r60_138 = { "Off", "Opposite", "Jitter", "Static", "Optimized slow", "Optimized jitter", "YawV2" };
    r55_138.body_yaw = r56_138(r57_138, r58_138, r59_138, r60_138);
    r45_138["anti-aim"].builder[r54_138].body_yaw_custom = r23_138(r43_138, r44_138, "\n custom" .. r54_138, -180, 180, 0,
        true, "º");
    r45_138["anti-aim"].builder[r54_138].defensive_enable = r5_138(r43_138, r44_138,
        "Enable \a96e631ffdefensive \n" .. r54_138);
    r45_138["anti-aim"].builder[r54_138].defensive_tick_stopper = r23_138(r43_138, r44_138,
        "Ticks" .. "\n defensive" .. r54_138, 1, 20, 0, true, "º");
    r45_138["anti-aim"].builder[r54_138].defensive_choke = r5_138(r43_138, r44_138,
        "Choke \a96e631ffdefensive \n" .. r54_138);
    r45_138["anti-aim"].builder[r54_138].defensive_force = r5_138(r43_138, r44_138,
        "Force \a96e631ffdefensive \n" .. r54_138);
    r55_138 = r45_138["anti-aim"].builder[r54_138];
    r56_138 = r4_138;
    r57_138 = r43_138;
    r58_138 = r44_138;
    r59_138 = "Pitch" .. "\n defensive" .. r54_138;
    r60_138 = { "Off", "Down", "Minimal", "Random", "Custom", "Lerp" };
    r55_138.defensive_pitch = r56_138(r57_138, r58_138, r59_138, r60_138);
    r45_138["anti-aim"].builder[r54_138].defensive_pitch_custom = r23_138(r43_138, r44_138,
        "Custom" .. "\n defensive" .. r54_138, -89, 89, 0, true, "º");
    r55_138 = r45_138["anti-aim"].builder[r54_138];
    r56_138 = r4_138;
    r57_138 = r43_138;
    r58_138 = r44_138;
    r59_138 = "Yaw" .. "\n defensive" .. r54_138;
    r60_138 = { "Off", "180", "Spin", "L&R", "Jitter", "Skitter", "Random", "Sideways" };
    r55_138.defensive_yaw = r56_138(r57_138, r58_138, r59_138, r60_138);
    r45_138["anti-aim"].builder[r54_138].defensive_yaw_custom = r23_138(r43_138, r44_138,
        "\n defensive custom" .. r54_138, -180, 180, 0, true, "º");
    r55_138 = r45_138["anti-aim"].builder[r54_138];
    r56_138 = r23_138(r43_138, r44_138, "\n 2 defensive custom" .. r54_138, -180, 180, 0, true, "º");
    r55_138.defensive_yaw_custom1 = r56_138;
end
local r50_138 = {};
for r54_138, r55_138 in ipairs(r45_138["anti-aim"].anti_aim_states) do
    local r56_138 = {};
    r50_138[r55_138] = r56_138;
    r50_138[r55_138].enable = r5_138(r43_138, r44_138, "Enable - " .. r55_138 .. "\n custom");
    r56_138 = r50_138[r55_138];
    local r57_138 = r4_138;
    local r58_138 = r43_138;
    local r59_138 = r44_138;
    local r60_138 = "Pitch" .. "\n" .. r55_138 .. "\n custom";
    local r61_138 = { "Off", "Down", "Minimal", "Up", "Random" };
    r56_138.pitch = r57_138(r58_138, r59_138, r60_138, r61_138);
    r56_138 = r50_138[r55_138];
    r57_138 = r4_138;
    r58_138 = r43_138;
    r59_138 = r44_138;
    r60_138 = "Yaw" .. "\n" .. r55_138 .. "\n custom";
    r61_138 = { "Off", "180" };
    r56_138.yaw = r57_138(r58_138, r59_138, r60_138, r61_138);
    r50_138[r55_138].yaw_custom = r23_138(r43_138, r44_138, "Yaw\n nigga" .. r55_138 .. "\n custom", -180, 180, 0, true,
        "º");
    r56_138 = r50_138[r55_138];
    r57_138 = r4_138;
    r58_138 = r43_138;
    r59_138 = r44_138;
    r60_138 = "Yaw jitter" .. "\n" .. r55_138 .. "\n custom";
    r61_138 = { "Off", "Center" };
    r56_138.yaw_jitter = r57_138(r58_138, r59_138, r60_138, r61_138);
    r50_138[r55_138].yaw_jitter_custom = r23_138(r43_138, r44_138, "\n jitter" .. r55_138 .. "\n custom", -180, 180, 0,
        true, "º");
    r56_138 = r50_138[r55_138];
    r57_138 = r4_138;
    r58_138 = r43_138;
    r59_138 = r44_138;
    r60_138 = "Body yaw" .. "\n" .. r55_138 .. "\n custom";
    r61_138 = { "Off", "Static", "Jitter" };
    r56_138.body_yaw = r57_138(r58_138, r59_138, r60_138, r61_138);
    r56_138 = r50_138[r55_138];
    r57_138 = r23_138(r43_138, r44_138, "\n custom" .. r55_138 .. "\n custom", -180, 180, 0, true, "º");
    r56_138.body_yaw_custom = r57_138;
end
local r51_138 = { enabled = r9_138("AA", "Anti-aimbot angles", "Enabled"), pitch = { r9_138("AA", "Anti-aimbot angles", "pitch") }, roll =
r9_138("AA", "Anti-aimbot angles", "roll"), yawbase = r9_138("AA", "Anti-aimbot angles", "Yaw base"), yaw = { r9_138("AA", "Anti-aimbot angles", "Yaw") }, fsbodyyaw =
r9_138("AA", "anti-aimbot angles", "Freestanding body yaw"), edgeyaw = r9_138("AA", "Anti-aimbot angles", "Edge yaw"), dtholdaim =
r9_138("misc", "settings", "sv_maxusrcmdprocessticks_holdaim"), fakeduck = r9_138("RAGE", "Other", "Duck peek assist"), minimum_damage =
r9_138("RAGE", "Aimbot", "Minimum damage"), safepoint = r9_138("RAGE", "Aimbot", "Force safe point"), forcebaim = r9_138(
"RAGE", "Aimbot", "Force body aim"), player_list = r9_138("PLAYERS", "Players", "Player list"), reset_all = r9_138(
"PLAYERS", "Players", "Reset all"), apply_all = r9_138("PLAYERS", "Adjustments", "Apply to all"), load_cfg = r9_138(
"Config", "Presets", "Load"), fl_limit = r9_138("AA", "Fake lag", "Limit"), dt_limit = r9_138("RAGE", "Aimbot",
    "Double tap fake lag limit"), quickpeek = { r9_138("RAGE", "Other", "Quick peek assist") }, yawjitter = { r9_138("AA", "Anti-aimbot angles", "Yaw jitter") }, bodyyaw = { r9_138("AA", "Anti-aimbot angles", "Body yaw") }, freestand = { r9_138("AA", "Anti-aimbot angles", "Freestanding") }, freestand_body = { r9_138("AA", "Anti-aimbot angles", "Freestanding body yaw") }, os = { r9_138("AA", "Other", "On shot anti-aim") }, slow = { r9_138("AA", "Other", "Slow motion") }, dt = { r9_138("RAGE", "Aimbot", "Double tap") }, fakelag = { r9_138("AA", "Fake lag", "Limit") }, fakelag_variance =
r9_138("AA", "Fake lag", "Variance"), fake_lag_amount = r9_138("AA", "Fake lag", "Amount"), leg_movement = r9_138("AA",
    "Other", "Leg movement"), ammo = r9_138("VISUALS", "Player ESP", "Ammo"), weapon_text = r9_138("VISUALS",
    "Player ESP", "Weapon text"), weapon_icon = r9_138("VISUALS", "Player ESP", "Weapon icon"), ping = { r9_138("MISC", "Miscellaneous", "Ping spike") }, clan_tag_spammer =
r9_138("MISC", "Miscellaneous", "Clan tag spammer"), min_dmg_override = { r9_138("RAGE", "Aimbot", "Minimum damage override") }, menu_key = { r9_138("MISC", "Settings", "Menu key") }, dpi_scale =
r9_138("MISC", "Settings", "DPI scale") };
local r52_138
r52_138 = {
    selected_tab = "Main",
    easier_tab = { aa = "Anti-aim", aa2 = "Extras", visuals = "Visuals", misc = "Misc", config = "Config", main = "Main" },
    aa = r32_138(r43_138, r44_138, "• Anti-aim", function()
        r52_138.selected_tab = r52_138.easier_tab.aa;
    end),
    aa2 = r32_138(r43_138, r44_138, "• Extras", function()
        r52_138.selected_tab = r52_138.easier_tab.aa2;
    end),
    visuals = r32_138(r43_138, r44_138, "• Visuals", function()
        r52_138.selected_tab = r52_138.easier_tab.visuals;
    end),
    misc = r32_138(r43_138, r44_138, "• Misc", function()
        r52_138.selected_tab = r52_138.easier_tab.misc;
    end),
    cfg = r32_138(r43_138, r44_138, "• Config", function()
        r52_138.selected_tab = r52_138.easier_tab.config;
    end)
};
local function r53_138(r0_144, r1_144, r2_144, r3_144, r4_144, r5_144, r6_144, r7_144, r8_144)
    r16_138(r0_144, r1_144 + 2, r4_144, r3_144 - 2, r5_144, r6_144, r7_144, r8_144);
    r16_138(r0_144 + r2_144, r1_144 + 2, r4_144, r3_144 - 2, r5_144, r6_144, r7_144, r8_144);
    r16_138(r0_144, r1_144 + r3_144, r2_144 + r4_144, r4_144, r5_144, r6_144, r7_144, r8_144);
    r16_138(r0_144, r1_144, r2_144 + r4_144, r4_144, r5_144, r6_144, r7_144, r8_144);
end
local function r54_138(r0_145, r1_145, r2_145, r3_145, r4_145, r5_145, r6_145, r7_145, r8_145, r9_145)
    r1_145 = r1_145 + r8_145;
    local r10_145 = { { (r0_145 + r8_145), r1_145, 180 }, { ((r0_145 + r2_145) - r8_145), r1_145, 270 }, { (r0_145 + r8_145), ((r1_145 + r3_145) - (r8_145 * 2)), 90 }, { ((r0_145 + r2_145) - r8_145), ((r1_145 + r3_145) - (r8_145 * 2)), 0 } };
    local r11_145 = { { (r0_145 + r8_145), (r1_145 - r8_145), (r2_145 - (r8_145 * 2)), r9_145 }, { (r0_145 + r8_145), (((r1_145 + r3_145) - r8_145) - r9_145), (r2_145 - (r8_145 * 2)), r9_145 }, { r0_145, r1_145, r9_145, (r3_145 - (r8_145 * 2)) }, { ((r0_145 + r2_145) - r9_145), r1_145, r9_145, (r3_145 - (r8_145 * 2)) } };
    for r15_145, r16_145 in next, r10_145, nil do
        r90_0.circle_outline(r16_145[1], r16_145[2], r4_145, r5_145, r6_145, r7_145, r8_145, r16_145[3], 0.25, r9_145);
    end
    for r15_145, r16_145 in next, r11_145, nil do
        r90_0.rectangle(r16_145[1], r16_145[2], r16_145[3], r16_145[4], r4_145, r5_145, r6_145, r7_145);
    end
end
local function r55_138(r0_146, r1_146, r2_146, r3_146, r4_146, r5_146, r6_146, r7_146, r8_146)
    r16_138(r0_146, r1_146, r2_146, r3_146, r4_146, r5_146, r6_146, r7_146);
    r90_0.circle(r0_146, r1_146, r4_146, r5_146, r6_146, r7_146, r8_146, -180, 0.25);
    r90_0.circle(r0_146 + r2_146, r1_146, r4_146, r5_146, r6_146, r7_146, r8_146, 90, 0.25);
    r16_138(r0_146, r1_146 - r8_146, r2_146, r8_146, r4_146, r5_146, r6_146, r7_146);
    r90_0.circle(r0_146 + r2_146, r1_146 + r3_146, r4_146, r5_146, r6_146, r7_146, r8_146, 0, 0.25);
    r90_0.circle(r0_146, r1_146 + r3_146, r4_146, r5_146, r6_146, r7_146, r8_146, -90, 0.25);
    r16_138(r0_146, r1_146 + r3_146, r2_146, r8_146, r4_146, r5_146, r6_146, r7_146);
    r16_138(r0_146 - r8_146, r1_146, r8_146, r3_146, r4_146, r5_146, r6_146, r7_146);
    r16_138(r0_146 + r2_146, r1_146, r8_146, r3_146, r4_146, r5_146, r6_146, r7_146);
end
local function r56_138(r0_147, r1_147, r2_147)
    return r0_147 + ((r1_147 - r0_147) * r2_147);
end
local function r57_138(r0_148, r1_148)
    for r5_148 = 1, #r0_148, 1 do
        if r0_148[r5_148] == r1_148 then
            return true;
        end
    end
    return false;
end
local function r58_138(r0_149, r1_149, r2_149, r3_149)
    local r4_149, r5_149 = r87_0.mouse_position();
    local r6_149 = r4_149 >= r0_149;
    if r6_149 then
        r6_149 = r4_149 <= (r0_149 + r2_149);
    end
    if r6_149 then
        r6_149 = r5_149 >= r1_149;
    end
    if r6_149 then
        r6_149 = r5_149 <= (r1_149 + r3_149);
    end
    return r6_149;
end
local r59_138 = 0;
r46_138["anti-aim"].sim_diff = function()
    if r28_138() == nil then
        return;
    end
    local r0_150 = math.floor(0.5 + (r13_138(r28_138(), "m_flSimulationTime") / globals.tickinterval()));
    local diff = r0_150 - r59_138
    r59_138 = r0_150;
    return diff;
end;
r46_138["anti-aim"].legit_aa = function(r0_151)
    if not r10_138(r45_138["anti-aim"].builder.Legit.enable) then
        return;
    end
    local r1_151 = r0_151.in_use == 1;
    local r2_151 = r13_138(r28_138(), "m_bInBombZone") >= 0;
    local r3_151 = r13_138(r28_138(), "m_iTeamNum");
    lx, ly, lz = r26_138(r28_138());
    local r4_151 = r41_138(r88_0.eye_position());
    local r6_151 = r38_138.line(r4_151, r4_151 + (r41_138():init_from_angles(r88_0.camera_angles()) * 1024),
        { skip = r28_138(), mask = "MASK_SHOT" });
    local r7_151 = r41_138(r26_138(r28_138()));
    if r6_151.fraction >= 1 then
        r6_151.entindex = 0;
    end
    if (r25_138(r6_151.entindex) ~= "CWorld") and (r25_138(r6_151.entindex) ~= "CCSPlayer") and (r25_138(r6_151.entindex) ~= "CFuncBrush") and (r25_138(r6_151.entindex) ~= "CBaseButton") and (r25_138(r6_151.entindex) ~= "CDynamicProp") and (r25_138(r6_151.entindex) ~= "CPhysicsPropMultiplayer") and (r25_138(r6_151.entindex) ~= "CBaseEntity") and (r25_138(r6_151.entindex) ~= "CC4") then
        local r8_151 = r41_138(r26_138(r6_151.entindex));
        if r25_138(r6_151.entindex) ~= "CPropDoorRotating" then
            if (r25_138(r6_151.entindex) == "CHostage") and (r3_151 == 3) then
                if r7_151:dist(r8_151) < 125 then
                    return false;
                end
            elseif (r25_138(r6_151.entindex) ~= "CPropDoorRotating") and (r25_138(r6_151.entindex) ~= "CHostage") and (r7_151:dist(r8_151) < 200) then
                return false;
            end
        elseif r7_151:dist(r8_151) < 125 then
            return false;
        end
    end
    local r8_151 = r89_0.get_all("CPlantedC4");
    local r9_151 = #r8_151 >= 0;
    local r10_151 = 100;
    if r9_151 then
        r10_151 = r7_151:dist(r41_138(r26_138(r8_151[#r8_151])));
    end
    local r11_151 = r10_151 <= 80;
    if r11_151 then
        r11_151 = r3_151 == 3;
    end
    if r11_151 then
        r11_151 = r46_138["anti-aim"].bomb_was_bombed == false;
    end
    if r11_151 then
        r11_151 = r46_138["anti-aim"].bomb_was_defused == false;
    end
    if r11_151 then
        return false;
    end
    if r1_151 then
        r0_151.in_use = 0;
        return true;
    end
    return false;
end;
r46_138["anti-aim"].manual_anti_aim_setup = function()
    if r10_138(r45_138["anti-aim"].builder.Manual.enable) and (r10_138(r45_138["anti-aim"].anti_aim_selector) or r10_138(r45_138["anti-aim"].enable)) then
        if r10_138(r45_138.misc.manual_r) and ((r46_138["anti-aim"].last_press + 0.2) < globals.curtime()) then
            local r0_152 = r46_138["anti-aim"];
            local r1_152 = r46_138["anti-aim"].mode == "right";
            if r1_152 then
                r1_152 = "reset";
            end
            if not r1_152 then
                r1_152 = "right";
            end
            r0_152.mode = r1_152;
            r46_138["anti-aim"].last_press = globals.curtime();
        elseif r10_138(r45_138.misc.manual_l) and ((r46_138["anti-aim"].last_press + 0.2) < globals.curtime()) then
            local r0_152 = r46_138["anti-aim"];
            local r1_152 = r46_138["anti-aim"].mode == "left";
            if r1_152 then
                r1_152 = "reset";
            end
            if not r1_152 then
                r1_152 = "left";
            end
            r0_152.mode = r1_152;
            r46_138["anti-aim"].last_press = globals.curtime();
        elseif r10_138(r45_138.misc.manual_f) and ((r46_138["anti-aim"].last_press + 0.2) < globals.curtime()) then
            local r0_152 = r46_138["anti-aim"];
            local r1_152 = r46_138["anti-aim"].mode == "forward";
            if r1_152 then
                r1_152 = "reset";
            end
            if not r1_152 then
                r1_152 = "forward";
            end
            r0_152.mode = r1_152;
            r46_138["anti-aim"].last_press = globals.curtime();
        elseif r10_138(r45_138.misc.manual_b) and ((r46_138["anti-aim"].last_press + 0.2) < globals.curtime()) then
            r46_138["anti-aim"].mode = "reset";
            r46_138["anti-aim"].last_press = globals.curtime();
        elseif globals.curtime() < r46_138["anti-aim"].last_press then
            r46_138["anti-aim"].last_press = globals.curtime();
        end
        if r46_138["anti-aim"].mode ~= "reset" then
            r11_138(r51_138.yaw[1], "180");
            if r46_138["anti-aim"].mode == "right" then
                r11_138(r51_138.yaw[2], 90);
            elseif r46_138["anti-aim"].mode == "left" then
                r11_138(r51_138.yaw[2], -90);
            elseif r46_138["anti-aim"].mode == "forward" then
                r11_138(r51_138.yaw[2], 180);
            end
        end
        return;
    end
end;
r46_138["anti-aim"].safe_anti_aim = function(r0_153)
    if not r10_138(r45_138["anti-aim"].safe_anti_aim) then
        return;
    end
    if ((r25_138(r89_0.get_player_weapon(r28_138())) == "CKnife") or (r25_138(r89_0.get_player_weapon(r28_138())) == "CWeaponTaser")) and r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].enable) then
        local r1_153 = r1_0.band(r13_138(r28_138(), "m_fFlags"), 1) == 1;
        if r1_153 then
            r1_153 = r0_153.in_jump == 0;
        end
        if not r1_153 then
            r11_138(r51_138.yaw[1], "180");
            r11_138(r51_138.yaw[2], 0);
            r11_138(r51_138.yawjitter[2], 0);
            r11_138(r51_138.bodyyaw[1], "Static");
        end
    end
end;
local function r60_138(r0_154, r1_154, r2_154)
    local r3_154 = globals.tickinterval();
    local r4_154 = r41_138(r13_138(r0_154, "m_vecVelocity"));
    r4_154.z = r4_154.z - (cvar.sv_gravity:get_float() * r3_154);
    return r1_154 + (r4_154 * r2_154 * r3_154);
end
r46_138["anti-aim"].anti_backstab = function(r0_155)
    r46_138["anti-aim"].distance = 999999;
    for r4_155, r5_155 in ipairs(entity.get_players(true)) do
        local r6_155 = r41_138(r26_138(r28_138()));
        local r7_155 = r60_138(r5_155, r41_138(r26_138(r5_155)), 10);
        local r8_155 = r41_138(r26_138(r46_138["anti-aim"].closest_player));
        if r6_155:dist2d(r7_155) <= r46_138["anti-aim"].distance then
            r46_138["anti-aim"].closest_player = r5_155;
            r46_138["anti-aim"].distance = r6_155:dist2d(r7_155);
        elseif r6_155:dist2d(r7_155) <= r6_155:dist2d(r8_155) then
            r46_138["anti-aim"].closest_player = r5_155;
            r46_138["anti-aim"].distance = r6_155:dist2d(r7_155);
        end
        if (r25_138(r89_0.get_player_weapon(r46_138["anti-aim"].closest_player)) == "CKnife") and (r6_155:dist2d(r41_138(r26_138(r46_138["anti-aim"].closest_player))) < 250) and r10_138(r45_138["anti-aim"].anti_backstab) then
            local r9_155, r10_155, r11_155 = r88_0.eye_position();
            local r12_155, r13_155, r14_155 = r89_0.hitbox_position(r5_155, 4);
            local r15_155, r16_155 = r88_0.trace_line(r28_138(), r9_155, r10_155, r11_155, r12_155, r13_155, r14_155);
            local r17_155, r18_155 = r90_0.world_to_screen(r12_155, r13_155, r14_155);
            if (r16_155 == r5_155) or (r15_155 == 1) then
                r11_138(r51_138.yawbase, "At targets");
                r11_138(r51_138.yaw[1], "180");
                r11_138(r51_138.yaw[2], 180);
                r11_138(r51_138.yawjitter[1], "Off");
            end
        end
    end
end;
r46_138["anti-aim"].defensive_jitter = false;
r46_138["anti-aim"].defensive_spin_amout = 0;
r46_138["anti-aim"].defensive_skitter = 1;
local r61_138 = false;
local r62_138 = 0;
r46_138["anti-aim"].defensive_setup = function(r0_156)
    if r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].defensive_enable) and r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].enable) and r10_138(r51_138.dt[1]) and r10_138(r51_138.dt[2]) then
        if (r10_138(r45_138["anti-aim"].disable_on_quickpeek) and r10_138(r51_138.quickpeek[1]) and r10_138(r51_138.quickpeek[2])) or r10_138(r51_138.fakeduck) then
            return;
        end
        r46_138["anti-aim"].old_weapon = r46_138["anti-aim"].current_weapon;
        r46_138["anti-aim"].current_weapon = r89_0.get_player_weapon(r28_138());
        if r46_138["anti-aim"].old_weapon ~= r46_138["anti-aim"].current_weapon then
            r46_138["anti-aim"].defensive_wait_ticks = r27_138();
        end
        if r27_138() < (r46_138["anti-aim"].defensive_wait_ticks + 50) then
            return;
        end
        if r0_156.chokedcommands == 0 then
            r46_138["anti-aim"].defensive_jitter = not r46_138["anti-aim"].defensive_jitter;
            r46_138["anti-aim"].defensive_skitter = r88_0.random_int(1, 3);
            local r1_156 = r62_138;
            local r2_156 = r61_138 and 8;
            if not r2_156 then
                r2_156 = -8;
            end
            r62_138 = r1_156 + r2_156;
            if math.ceil(r62_138) >= 89 then
                r61_138 = false;
            elseif math.ceil(r62_138) <= -89 then
                r61_138 = true;
            end
        end
        r0_156.force_defensive = r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].defensive_force);
        if r46_138["anti-aim"].sim_tick == nil then
            return;
        end
        if (r46_138["anti-aim"].sim_tick + r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].defensive_tick_stopper)) <= globals.tickcount() then
            return;
        end
        if r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].defensive_pitch) == "Lerp" then
            r11_138(r51_138.pitch[1], "Custom");
            r11_138(r51_138.pitch[2], math.max(-89, math.min(89, r62_138)));
        elseif r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].defensive_pitch) ~= "Off" then
            r11_138(r51_138.pitch[1],
                r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].defensive_pitch));
            r11_138(r51_138.pitch[2],
                r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].defensive_pitch_custom));
        end
        if r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].defensive_yaw) ~= "Off" then
            if r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].defensive_yaw) == "Jitter" then
                r11_138(r51_138.yaw[1], "180");
                local r1_156 = r11_138;
                local r2_156 = r51_138.yaw[2];
                local r3_156 = r46_138["anti-aim"].defensive_jitter and
                r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].defensive_yaw_custom);
                if not r3_156 then
                    r3_156 = -r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state]
                    .defensive_yaw_custom);
                end
                r1_156(r2_156, r3_156);
                r11_138(r51_138.bodyyaw[1], "Static");
                r1_156 = r11_138;
                r2_156 = r51_138.bodyyaw[2];
                r3_156 = r46_138["anti-aim"].defensive_jitter and -115;
                if not r3_156 then
                    r3_156 = 115;
                end
                r1_156(r2_156, r3_156);
            elseif r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].defensive_yaw) == "Spin" then
                r46_138["anti-aim"].defensive_spin_amout = r46_138["anti-aim"].defensive_spin_amout +
                r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].defensive_yaw_custom);
                if r46_138["anti-aim"].defensive_spin_amout > 180 then
                    r46_138["anti-aim"].defensive_spin_amout = -180;
                elseif r46_138["anti-aim"].defensive_spin_amout < -180 then
                    r46_138["anti-aim"].defensive_spin_amout = 180;
                end
                r11_138(r51_138.yaw[1], "180");
                r11_138(r51_138.yaw[2], r46_138["anti-aim"].defensive_spin_amout);
                r11_138(r51_138.bodyyaw[1], "Static");
                r11_138(r51_138.bodyyaw[2], 0);
            elseif r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].defensive_yaw) == "180" then
                r11_138(r51_138.yaw[1], "180");
                r11_138(r51_138.yaw[2],
                    r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].defensive_yaw_custom));
            elseif r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].defensive_yaw) == "Skitter" then
                r11_138(r51_138.yawjitter[1], "Skitter");
                r11_138(r51_138.yawjitter[2],
                    r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].defensive_yaw_custom));
                r11_138(r51_138.bodyyaw[1], "Jitter");
                r11_138(r51_138.bodyyaw[2], 1);
            elseif r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].defensive_yaw) == "Random" then
                r11_138(r51_138.yaw[1], "180");
                r11_138(r51_138.yaw[2], r88_0.random_int(-180, 180));
                r11_138(r51_138.bodyyaw[1], "Static");
                r11_138(r51_138.bodyyaw[2], 1);
            elseif r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].defensive_yaw) == "Sideways" then
                r11_138(r51_138.yaw[1], "180");
                r11_138(r51_138.yaw[2], 0);
                r11_138(r51_138.yawjitter[1], "Center");
                r11_138(r51_138.yawjitter[2], -50);
                r11_138(r51_138.bodyyaw[1], "Jitter");
                r11_138(r51_138.bodyyaw[2], 1);
            elseif r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].defensive_yaw) == "L&R" then
                r11_138(r51_138.yaw[1], "180");
                local r1_156 = r11_138;
                local r2_156 = r51_138.yaw[2];
                local r3_156 = r46_138["anti-aim"].defensive_jitter == true;
                if r3_156 then
                    r3_156 = r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state]
                    .defensive_yaw_custom);
                end
                if not r3_156 then
                    r3_156 = r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state]
                    .defensive_yaw_custom1);
                end
                r1_156(r2_156, r3_156);
                r11_138(r51_138.yawjitter[1], "Off");
                r11_138(r51_138.bodyyaw[1], "Static");
                r11_138(r51_138.bodyyaw[2], r10_138(r51_138.yaw[2]));
            end
        end
    end
    r46_138.visuals.forced_defensive = r0_156.force_defensive and (r0_156.weaponselect == 0);
end;
local function r63_138(r0_157, r1_157, r2_157)
    local r3_157 = nil;
    if r0_157 < r2_157 then
        r3_157 = r0_157 - r2_157;
    elseif r2_157 < r1_157 then
        r3_157 = r1_157 - r2_157;
    end
    if r3_157 == nil then
        return r2_157;
    end
    local r4_157 = r3_157 >= 0;
    if r4_157 then
        r4_157 = 180 - r3_157;
    end
    if not r4_157 then
        r4_157 = -180 - r3_157;
    end
    return r4_157;
end
local r64_138 = false;
local r65_138 = r88_0.random_int(12, 64);
local r66_138 = 0;
local r67_138 = "Standing";
local r68_138 = 1;
local r69_138 = 0;
local r70_138 = 1;
r46_138["anti-aim"].anti_aim_setup = function(r0_158)
    local r1_158 = r0_158.in_duck == 1;
    if not r1_158 then
        r1_158 = r10_138(r51_138.fakeduck);
    end
    local r2_158 = r1_0.band(r13_138(r28_138(), "m_fFlags"), 1) == 1;
    if r2_158 then
        r2_158 = r0_158.in_jump == 0;
    end
    local r3_158 = r41_138(r13_138(r28_138(), "m_vecVelocity"));
    local r4_158 = r10_138(r51_138.slow[1]) and r10_138(r51_138.slow[2]);
    local r5_158 = (not r10_138(r51_138.dt[1])) or (not r10_138(r51_138.dt[2]));
    if r5_158 then
        r5_158 = (not r10_138(r51_138.os[1])) or (not r10_138(r51_138.os[2]));
    end
    local r6_158 = r41_138(r26_138(r28_138()));
    local r7_158 = r41_138(r26_138(r88_0.current_threat() or r28_138()));
    r67_138 = r46_138["anti-aim"].anti_aim_state;
    if r46_138["anti-aim"].legit_aa(r0_158) then
        r46_138["anti-aim"].anti_aim_state = "Legit";
    elseif r10_138(r45_138["anti-aim"].builder.Manual.enable) and (r46_138["anti-aim"].mode ~= "reset") then
        r46_138["anti-aim"].anti_aim_state = "Manual";
    elseif r10_138(r45_138["anti-aim"].builder["Height advantage"].enable) and ((r7_158.z + 64) < r6_158.z) then
        r46_138["anti-aim"].anti_aim_state = "Height advantage";
    elseif r5_158 and r10_138(r45_138["anti-aim"].builder.Fakelag.enable) then
        r46_138["anti-aim"].anti_aim_state = "Fakelag";
    elseif (not r2_158) and (r0_158.in_duck == 1) and r10_138(r45_138["anti-aim"].builder["Duck jumping"].enable) then
        r46_138["anti-aim"].anti_aim_state = "Duck jumping";
    elseif (not r2_158) and r10_138(r45_138["anti-aim"].builder.Jumping.enable) then
        r46_138["anti-aim"].anti_aim_state = "Jumping";
    elseif r1_158 and (r3_158:length2d() < 3) and r10_138(r45_138["anti-aim"].builder.Ducking.enable) and r2_158 then
        r46_138["anti-aim"].anti_aim_state = "Ducking";
    elseif r1_158 and (3 <= r3_158:length2d()) and r10_138(r45_138["anti-aim"].builder["Duck moving"].enable) and r2_158 then
        r46_138["anti-aim"].anti_aim_state = "Duck moving";
    elseif r4_158 and r10_138(r45_138["anti-aim"].builder["Slow walking"].enable) then
        r46_138["anti-aim"].anti_aim_state = "Slow walking";
    elseif (3 <= r3_158:length2d()) and r10_138(r45_138["anti-aim"].builder.Moving.enable) and (not r4_158) then
        r46_138["anti-aim"].anti_aim_state = "Moving";
    elseif (r3_158:length2d() < 3) and r10_138(r45_138["anti-aim"].builder.Standing.enable) and (not r4_158) then
        r46_138["anti-aim"].anti_aim_state = "Standing";
    else
        r46_138["anti-aim"].anti_aim_state = "Global";
    end
    local r9_158 = math.floor(math.min(60, (r13_138(r28_138(), "m_flPoseParameter", 11) * 120) - 60)) >= 0;
    if r9_158 then
        r9_158 = true;
    end
    if not r9_158 then
        r9_158 = false;
    end
    if r0_158.chokedcommands == 0 then
        if r46_138["anti-aim"].anti_aim_state ~= "Manual" then
            r70_138 = r88_0.random_int(1, 2);
            if (r66_138 + r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].delay_custom)) <= r27_138() then
                r66_138 = r27_138();
                r46_138["anti-aim"].side = not r46_138["anti-aim"].side;
            elseif (r27_138() + r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].delay_custom)) < r66_138 then
                r66_138 = r27_138();
            end
            r64_138 = not r64_138;
            if (r69_138 + r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].delay_custom)) <= r27_138() then
                r69_138 = r27_138();
                r68_138 = r68_138 + 1;
            elseif (r27_138() + r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].delay_custom)) < r69_138 then
                r69_138 = r27_138();
            end
            if r68_138 > 5 then
                r68_138 = 1;
            end
            r46_138["anti-aim"].body = r9_158;
        end
        r46_138["anti-aim"].jitter = r88_0.random_int(1, 3);
    end
    r11_138(r51_138.enabled, r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].enable));
    r11_138(r51_138.pitch[1], r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].pitch));
    r11_138(r51_138.pitch[2], r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].pitch_custom));
    r11_138(r51_138.yawbase, r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].yaw_base));
    if r46_138["anti-aim"].anti_aim_state ~= "Manual" then
        r11_138(r51_138.yaw[1], r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].yaw));
        r11_138(r51_138.yaw[2], r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].yaw_custom));
        if r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].yaw_jitter) == "Slow jitter" then
            local r10_158 = r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].yaw_custom);
            local r11_158 = r46_138["anti-aim"].side == true;
            if r11_158 then
                r11_158 = r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].yaw_jitter2);
            end
            if not r11_158 then
                r11_158 = r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].yaw_jitter_custom);
            end
            r11_158 = r10_158 + r11_158;
            r11_138(r51_138.yawjitter[1], "Off");
            r11_138(r51_138.yaw[2], r63_138(180, -180, r11_158));
        elseif r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].yaw_jitter) == "L&R" then
            local r10_158 = r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].yaw_custom);
            local r11_158 = r46_138["anti-aim"].body == false;
            if r11_158 then
                r11_158 = r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].yaw_jitter2);
            end
            if not r11_158 then
                r11_158 = r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].yaw_jitter_custom);
            end
            r11_158 = r10_158 + r11_158;
            r11_138(r51_138.yawjitter[1], "Off");
            r11_138(r51_138.yaw[2], r63_138(180, -180, r11_158));
        elseif r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].yaw_jitter) == "Slow 5-way" then
            r11_138(r51_138.yawjitter[1], "Off");
            r11_138(r51_138.yaw[2],
                r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].yaw_jitter_custom) *
                r46_138["anti-aim"].five_way[r68_138]);
        elseif r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].yaw_jitter) == "50/50" then
            local r10_158 = r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].yaw_custom);
            local r11_158 = r70_138 == 1;
            if r11_158 then
                r11_158 = true;
            end
            if not r11_158 then
                r11_158 = false;
            end
            local r12_158 = r11_158 == true;
            if r12_158 then
                r12_158 = r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].yaw_jitter2);
            end
            if not r12_158 then
                r12_158 = r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].yaw_jitter_custom);
            end
            r12_158 = r10_158 + r12_158;
            r11_138(r51_138.yawjitter[1], "Off");
            r11_138(r51_138.yaw[2], r63_138(180, -180, r12_158));
        else
            r11_138(r51_138.yawjitter[1],
                r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].yaw_jitter));
            r11_138(r51_138.yawjitter[2],
                r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].yaw_jitter_custom));
        end
    end
    if (r46_138["anti-aim"].anti_aim_state ~= "Manual") and (r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].yaw) ~= "Off") and r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].random_flick) and ((r27_138() % r65_138) == 1) then
        r11_138(r51_138.yaw[1], "180");
        r11_138(r51_138.yaw[2], r88_0.random_int(-180, 180));
        r65_138 = r88_0.random_int(12, 64);
    end
    if r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].body_yaw) == "Optimized slow" then
        r11_138(r51_138.bodyyaw[1], "Static");
        local r10_158 = r11_138;
        local r11_158 = r51_138.bodyyaw[2];
        local r12_158 = r46_138["anti-aim"].side == true;
        if r12_158 then
            r12_158 = 115;
        end
        if not r12_158 then
            r12_158 = -115;
        end
        r10_158(r11_158, r12_158);
    elseif r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].body_yaw) == "Optimized jitter" then
        r11_138(r51_138.bodyyaw[1], "Jitter");
        r11_138(r51_138.bodyyaw[2], r10_138(r51_138.yaw[2]));
    elseif r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].body_yaw) == "YawV2" then
        r11_138(r51_138.bodyyaw[1], "Static");
        r11_138(r51_138.bodyyaw[2], r10_138(r51_138.yaw[2]));
    else
        r11_138(r51_138.bodyyaw[1], r10_138(r45_138["anti-aim"].builder[r46_138["anti-aim"].anti_aim_state].body_yaw));
    end
    r11_138(r51_138.edgeyaw, false);
    r11_138(r51_138.roll, 0);
    r11_138(r51_138.freestand_body[1], false);
    r11_138(r51_138.freestand[1],
        r10_138(r45_138.misc.freestanding) and
        (not r57_138(r10_138(r45_138["anti-aim"].freestanding_disablers), r46_138["anti-aim"].anti_aim_state)));
    local r10_158 = r11_138;
    local r11_158 = r51_138.freestand[2];
    local r12_158 = (r10_138(r45_138.misc.freestanding) and (not r57_138(r10_138(r45_138["anti-aim"].freestanding_disablers), r46_138["anti-aim"].anti_aim_state))) ==
    true;
    if r12_158 then
        r12_158 = "Always on";
    end
    if not r12_158 then
        r12_158 = "On hotkey";
    end
    r10_158(r11_158, r12_158);
    r46_138["anti-aim"].manual_anti_aim_setup();
    r46_138["anti-aim"].defensive_setup(r0_158);
    r46_138["anti-aim"].safe_anti_aim(r0_158);
    r46_138["anti-aim"].anti_backstab();
end;
local r71_138 = 0;
r46_138["anti-aim"].venus_anti_aim = function(A0_5)
    local r1_5, r2_5, r3_5, r4_5, r5_5, r6_5, r7_5, r8_5, r9_5, r10_5, r11_5, r12_5, r13_5, r14_5, r15_5, r16_5, r17_5, r18_5, r19_5, r20_5, r21_5, r22_5, r23_5, r24_5, r25_5, r26_5, r27_5, r28_5, r29_5, r30_5, r31_5;
    r1_5 = r41_138;
    r2_5 = r88_0;
    r2_5 = r2_5.camera_angles;
    r1_5 = r1_5(r2_5());
    r2_5 = r41_138;
    r3_5 = r26_138;
    r4_5 = r28_138;
    r2_5 = r2_5(r3_5(r4_5()));
    r3_5 = r1_0;
    r3_5 = r3_5.band;
    r4_5 = r13_138;
    r5_5 = r28_138;
    r5_5 = r5_5();
    r6_5 = "m_fFlags";
    r4_5 = r4_5(r5_5, r6_5);
    r5_5 = 1;
    r3_5 = r3_5(r4_5, r5_5);
    r3_5 = r3_5 == 1;
    if r3_5 then
        r3_5 = A0_5.in_jump;
        r3_5 = r3_5 == 0;
    end
    r4_5 = r41_138;
    r5_5 = r26_138;
    r6_5 = r88_0;
    r6_5 = r6_5.current_threat;
    r6_5 = r6_5();
    r6_5 = r6_5 ~= nil;
    if r6_5 then
        r6_5 = r88_0;
        r6_5 = r6_5.current_threat;
        r6_5 = r6_5();
    end
    if not r6_5 then
        r6_5 = r28_138;
        r6_5 = r6_5();
    end
    r4_5 = r4_5(r5_5(r6_5));
    r5_5 = r41_138;
    r7_5 = r2_5;
    r6_5 = r2_5.to;
    r8_5 = r4_5;
    r6_5 = r6_5(r7_5, r8_5);
    r7_5 = r6_5;
    r6_5 = r6_5.angles;
    r5_5 = r5_5(r6_5(r7_5));
    r6_5 = A0_5.in_duck;
    r6_5 = r6_5 == 1;
    if not r6_5 then
        r6_5 = r10_138;
        r7_5 = r51_138;
        r7_5 = r7_5.fakeduck;
        r6_5 = r6_5(r7_5);
    end
    r7_5 = r1_0;
    r7_5 = r7_5.band;
    r8_5 = r13_138;
    r9_5 = r28_138;
    r9_5 = r9_5();
    r10_5 = "m_fFlags";
    r8_5 = r8_5(r9_5, r10_5);
    r9_5 = 1;
    r7_5 = r7_5(r8_5, r9_5);
    r7_5 = r7_5 == 1;
    if r7_5 then
        r7_5 = A0_5.in_jump;
        r7_5 = r7_5 == 0;
    end
    r8_5 = r41_138;
    r9_5 = r13_138;
    r10_5 = r28_138;
    r10_5 = r10_5();
    r11_5 = "m_vecVelocity";
    r8_5 = r8_5(r9_5(r10_5, r11_5));
    r9_5 = r10_138;
    r10_5 = r51_138;
    r10_5 = r10_5.slow;
    r10_5 = r10_5[1];
    r9_5 = r9_5(r10_5);
    if r9_5 then
        r9_5 = r10_138;
        r10_5 = r51_138;
        r10_5 = r10_5.slow;
        r10_5 = r10_5[2];
        r9_5 = r9_5(r10_5);
    end
    r10_5 = r10_138;
    r11_5 = r51_138;
    r11_5 = r11_5.dt;
    r11_5 = r11_5[2];
    r10_5 = r10_5(r11_5);
    r10_5 = not r10_5;
    if r10_5 then
        r10_5 = r10_138;
        r11_5 = r51_138;
        r11_5 = r11_5.os;
        r11_5 = r11_5[2];
        r10_5 = r10_5(r11_5);
        r10_5 = not r10_5;
    end
    r11_5 = r41_138;
    r12_5 = r26_138;
    r13_5 = r28_138;
    r11_5 = r11_5(r12_5(r13_5()));
    r12_5 = r41_138;
    r13_5 = r26_138;
    r14_5 = r88_0;
    r14_5 = r14_5.current_threat;
    r14_5 = r14_5();
    if not r14_5 then
        r14_5 = r28_138;
        r14_5 = r14_5();
    end
    r12_5 = r12_5(r13_5(r14_5));
    r13_5 = r46_138;
    r13_5 = r13_5["anti-aim"];
    r13_5 = r13_5.anti_aim_state;
    r67_138 = r13_5;
    r13_5 = r10_138;
    r14_5 = r50_138;
    r14_5 = r14_5.Manual;
    r14_5 = r14_5.enable;
    r13_5 = r13_5(r14_5);
    if r13_5 then
        r13_5 = r46_138;
        r13_5 = r13_5["anti-aim"];
        r13_5 = r13_5.mode;
        if r13_5 ~= "reset" then
            r13_5 = r46_138;
            r13_5 = r13_5["anti-aim"];
            r13_5.anti_aim_state = "Manual";
        end
    else
        r13_5 = r10_138;
        r14_5 = r45_138;
        r14_5 = r14_5["anti-aim"];
        r14_5 = r14_5.builder;
        r14_5 = r14_5["Height advantage"];
        r14_5 = r14_5.enable;
        r13_5 = r13_5(r14_5);
        if r13_5 then
            r13_5 = r11_5.z;
            r14_5 = r12_5.z;
            r14_5 = r14_5 + 64;
            if r13_5 > r14_5 then
                r13_5 = r46_138;
                r13_5 = r13_5["anti-aim"];
                r13_5.anti_aim_state = "Height advantage";
            end
        elseif r10_5 then
            r13_5 = r10_138;
            r14_5 = r50_138;
            r14_5 = r14_5.Fakelag;
            r14_5 = r14_5.enable;
            r13_5 = r13_5(r14_5);
            if r13_5 then
                r13_5 = r46_138;
                r13_5 = r13_5["anti-aim"];
                r13_5.anti_aim_state = "Fakelag";
            end
        elseif not r7_5 then
            r13_5 = A0_5.in_duck;
            if r13_5 == 1 then
                r14_5 = r10_138;
                r15_5 = r50_138;
                r15_5 = r15_5["Duck jumping"];
                r15_5 = r15_5.enable;
                r14_5 = r14_5(r15_5);
                if r14_5 then
                    r13_5 = r46_138;
                    r13_5 = r13_5["anti-aim"];
                    r13_5.anti_aim_state = "Duck jumping";
                end
            end
        elseif not r7_5 then
            r13_5 = r10_138;
            r14_5 = r50_138;
            r14_5 = r14_5.Jumping;
            r14_5 = r14_5.enable;
            r13_5 = r13_5(r14_5);
            if r13_5 then
                r13_5 = r46_138;
                r13_5 = r13_5["anti-aim"];
                r13_5.anti_aim_state = "Jumping";
            end
        elseif r6_5 then
            r14_5 = r8_5;
            r13_5 = r8_5.length2d;
            r13_5 = r13_5(r14_5);
            if r13_5 < 3 then
                r14_5 = r10_138;
                r15_5 = r50_138;
                r15_5 = r15_5.Ducking;
                r15_5 = r15_5.enable;
                r14_5 = r14_5(r15_5);
                if r14_5 and r7_5 then
                    r13_5 = r46_138;
                    r13_5 = r13_5["anti-aim"];
                    r13_5.anti_aim_state = "Ducking";
                end
            end
        elseif r6_5 then
            r14_5 = r8_5;
            r13_5 = r8_5.length2d;
            r13_5 = r13_5(r14_5);
            if 3 <= r13_5 then
                r14_5 = r10_138;
                r15_5 = r50_138;
                r15_5 = r15_5["Duck moving"];
                r15_5 = r15_5.enable;
                r14_5 = r14_5(r15_5);
                if r14_5 and r7_5 then
                    r13_5 = r46_138;
                    r13_5 = r13_5["anti-aim"];
                    r13_5.anti_aim_state = "Duck moving";
                end
            end
        elseif r9_5 then
            r13_5 = r10_138;
            r14_5 = r50_138;
            r14_5 = r14_5["Slow walking"];
            r14_5 = r14_5.enable;
            r13_5 = r13_5(r14_5);
            if r13_5 then
                r13_5 = r46_138;
                r13_5 = r13_5["anti-aim"];
                r13_5.anti_aim_state = "Slow walking";
            end
        else
            r14_5 = r8_5;
            r13_5 = r8_5.length2d;
            r13_5 = r13_5(r14_5);
            if 3 <= r13_5 then
                r14_5 = r10_138;
                r15_5 = r50_138;
                r15_5 = r15_5.Moving;
                r15_5 = r15_5.enable;
                r14_5 = r14_5(r15_5);
                if r14_5 and (not r9_5) then
                    r13_5 = r46_138;
                    r13_5 = r13_5["anti-aim"];
                    r13_5.anti_aim_state = "Moving";
                end
            else
                r14_5 = r8_5;
                r13_5 = r8_5.length2d;
                r13_5 = r13_5(r14_5);
                if r13_5 < 3 then
                    r14_5 = r10_138;
                    r15_5 = r50_138;
                    r15_5 = r15_5.Standing;
                    r15_5 = r15_5.enable;
                    r14_5 = r14_5(r15_5);
                    if r14_5 and (not r9_5) then
                        r13_5 = r46_138;
                        r13_5 = r13_5["anti-aim"];
                        r13_5.anti_aim_state = "Standing";
                    end
                else
                    r13_5 = r46_138;
                    r13_5 = r13_5["anti-aim"];
                    r13_5.anti_aim_state = "Global";
                end
            end
        end
    end
    r13_5 = r11_138;
    r14_5 = r51_138;
    r14_5 = r14_5.enabled;
    r15_5 = true;
    r13_5(r14_5, r15_5);
    r13_5 = r11_138;
    r14_5 = r51_138;
    r14_5 = r14_5.pitch;
    r14_5 = r14_5[1];
    r15_5 = r10_138;
    r16_5 = r50_138;
    r17_5 = r46_138;
    r17_5 = r17_5["anti-aim"];
    r17_5 = r17_5.anti_aim_state;
    r16_5 = r16_5[r17_5];
    r16_5 = r16_5.pitch;
    r13_5(r14_5, r15_5(r16_5));
    r13_5 = r11_138;
    r14_5 = r51_138;
    r14_5 = r14_5.yaw;
    r14_5 = r14_5[1];
    r15_5 = r10_138;
    r16_5 = r50_138;
    r17_5 = r46_138;
    r17_5 = r17_5["anti-aim"];
    r17_5 = r17_5.anti_aim_state;
    r16_5 = r16_5[r17_5];
    r16_5 = r16_5.yaw;
    r13_5(r14_5, r15_5(r16_5));
    r13_5 = r11_138;
    r14_5 = r51_138;
    r14_5 = r14_5.yaw;
    r14_5 = r14_5[2];
    r15_5 = r10_138;
    r16_5 = r50_138;
    r17_5 = r46_138;
    r17_5 = r17_5["anti-aim"];
    r17_5 = r17_5.anti_aim_state;
    r16_5 = r16_5[r17_5];
    r16_5 = r16_5.yaw_custom;
    r13_5(r14_5, r15_5(r16_5));
    r13_5 = r11_138;
    r14_5 = r51_138;
    r14_5 = r14_5.yawbase;
    r15_5 = "At targets";
    r13_5(r14_5, r15_5);
    r13_5 = r11_138;
    r14_5 = r51_138;
    r14_5 = r14_5.yawjitter;
    r14_5 = r14_5[1];
    r15_5 = "Off";
    r13_5(r14_5, r15_5);
    r13_5 = r11_138;
    r14_5 = r51_138;
    r14_5 = r14_5.yawjitter;
    r14_5 = r14_5[2];
    r15_5 = 0;
    r13_5(r14_5, r15_5);
    r13_5 = r11_138;
    r14_5 = r51_138;
    r14_5 = r14_5.bodyyaw;
    r14_5 = r14_5[1];
    r15_5 = "Static";
    r13_5(r14_5, r15_5);
    r13_5 = r11_138;
    r14_5 = r51_138;
    r14_5 = r14_5.bodyyaw;
    r14_5 = r14_5[2];
    r15_5 = 1;
    r13_5(r14_5, r15_5);
    r13_5 = r11_138;
    r14_5 = r51_138;
    r14_5 = r14_5.freestand;
    r14_5 = r14_5[1];
    r15_5 = r10_138;
    r16_5 = r45_138;
    r16_5 = r16_5.misc;
    r16_5 = r16_5.freestanding;
    r15_5 = r15_5(r16_5);
    if r15_5 then
        r15_5 = r57_138;
        r16_5 = r10_138;
        r17_5 = r45_138;
        r17_5 = r17_5["anti-aim"];
        r17_5 = r17_5.freestanding_disablers;
        r16_5 = r16_5(r17_5);
        r17_5 = r46_138;
        r17_5 = r17_5["anti-aim"];
        r17_5 = r17_5.anti_aim_state;
        r15_5 = r15_5(r16_5, r17_5);
        r15_5 = not r15_5;
    end
    r13_5(r14_5, r15_5);
    r13_5 = r11_138;
    r14_5 = r51_138;
    r14_5 = r14_5.freestand;
    r14_5 = r14_5[2];
    r15_5 = r10_138;
    r16_5 = r45_138;
    r16_5 = r16_5.misc;
    r16_5 = r16_5.freestanding;
    r15_5 = r15_5(r16_5);
    if r15_5 then
        r15_5 = r57_138;
        r16_5 = r10_138;
        r17_5 = r45_138;
        r17_5 = r17_5["anti-aim"];
        r17_5 = r17_5.freestanding_disablers;
        r16_5 = r16_5(r17_5);
        r17_5 = r46_138;
        r17_5 = r17_5["anti-aim"];
        r17_5 = r17_5.anti_aim_state;
        r15_5 = r15_5(r16_5, r17_5);
        r15_5 = not r15_5;
    end
    r15_5 = r15_5 == true;
    if r15_5 then
        r15_5 = "Always on";
    end
    if not r15_5 then
        r15_5 = "On hotkey";
    end
    r13_5(r14_5, r15_5);
    r13_5 = A0_5.in_use;
    if r13_5 ~= 1 then
        r14_5 = A0_5.in_attack;
        if r14_5 ~= 1 then
            r15_5 = r25_138;
            r16_5 = r89_0;
            r16_5 = r16_5.get_player_weapon;
            r17_5 = r28_138;
            r15_5 = r15_5(r16_5(r17_5()));
            if r15_5 == "CKnife" then
                r16_5 = A0_5.in_attack2;
                if r16_5 == 1 then
                    r13_5 = A0_5.in_use;
                    if r13_5 == 1 then
                        return;
                    end
                end
            end
            r17_5 = r87_0;
            r17_5 = r17_5.get;
            r18_5 = r51_138;
            r18_5 = r18_5.freestand;
            r18_5 = r18_5[1];
            r17_5 = r17_5(r18_5);
            if r17_5 then
                r17_5 = r87_0;
                r17_5 = r17_5.get;
                r18_5 = r51_138;
                r18_5 = r18_5.freestand;
                r18_5 = r18_5[2];
                r17_5 = r17_5(r18_5);
                if r17_5 then
                end
            else
                r13_5 = r13_138;
                r14_5 = r28_138;
                r14_5 = r14_5();
                r15_5 = "m_MoveType";
                r13_5 = r13_5(r14_5, r15_5);
                if r13_5 == 9 then
                    r14_5 = A0_5.in_moveleft;
                    if r14_5 ~= 1 then
                        r15_5 = A0_5.in_moveright;
                        if r15_5 ~= 1 then
                            r16_5 = A0_5.in_forward;
                            if r16_5 ~= 1 then
                                r17_5 = A0_5.in_back;
                                if r17_5 ~= 1 then
                                    goto lbl_13892;
                                end
                            end
                        end
                    end
                    return;
                end
                ::lbl_13892::
                ;
                r13_5 = r46_138;
                r13_5 = r13_5["anti-aim"];
                r13_5 = r13_5.manual_anti_aim_setup;
                r13_5();
                r13_5 = r11_138;
                r14_5 = r51_138;
                r14_5 = r14_5.enabled;
                r15_5 = r10_138;
                r16_5 = r50_138;
                r17_5 = r46_138;
                r17_5 = r17_5["anti-aim"];
                r17_5 = r17_5.anti_aim_state;
                r16_5 = r16_5[r17_5];
                r16_5 = r16_5.enable;
                r13_5(r14_5, r15_5(r16_5));
                r13_5 = r89_0;
                r13_5 = r13_5.get_player_weapon;
                r14_5 = r28_138;
                r13_5 = r13_5(r14_5());
                r14_5 = r13_138;
                r15_5 = r13_5;
                r16_5 = "m_bPinPulled";
                r14_5 = r14_5(r15_5, r16_5);
                r15_5 = r13_138;
                r16_5 = r13_5;
                r17_5 = "m_fThrowTime";
                r15_5 = r15_5(r16_5, r17_5);
                r16_5 = r1_0;
                r16_5 = r16_5.band;
                r17_5 = 65535;
                r18_5 = r13_138;
                r19_5 = r13_5;
                r20_5 = "m_iItemDefinitionIndex";
                r16_5 = r16_5(r17_5, r18_5(r19_5, r20_5));
                r17_5 = {};
                r17_5[43] = true;
                r17_5[44] = true;
                r17_5[45] = true;
                r17_5[46] = true;
                r17_5[47] = true;
                r17_5[48] = true;
                r17_5[68] = true;
                r17_5 = r17_5[r16_5];
                if not r17_5 then
                    r17_5 = false;
                end
                if r17_5 and (0 < r15_5) then
                    A0_5.allow_send_packet = false;
                    return;
                end
                r18_5 = A0_5.chokedcommands;
                if r18_5 == 0 then
                    r18_5 = jitter_byaw;
                    r18_5 = not r18_5;
                    jitter_byaw = r18_5;
                end
                r18_5 = r10_138;
                r19_5 = r50_138;
                r20_5 = r46_138;
                r20_5 = r20_5["anti-aim"];
                r20_5 = r20_5.anti_aim_state;
                r19_5 = r19_5[r20_5];
                r19_5 = r19_5.pitch;
                r18_5 = r18_5(r19_5);
                if r18_5 == "Down" then
                    A0_5.pitch = 89;
                else
                    r18_5 = r10_138;
                    r19_5 = r50_138;
                    r20_5 = r46_138;
                    r20_5 = r20_5["anti-aim"];
                    r20_5 = r20_5.anti_aim_state;
                    r19_5 = r19_5[r20_5];
                    r19_5 = r19_5.pitch;
                    r18_5 = r18_5(r19_5);
                    if r18_5 == "Minimal" then
                        A0_5.pitch = 85;
                    else
                        r18_5 = r10_138;
                        r19_5 = r50_138;
                        r20_5 = r46_138;
                        r20_5 = r20_5["anti-aim"];
                        r20_5 = r20_5.anti_aim_state;
                        r19_5 = r19_5[r20_5];
                        r19_5 = r19_5.pitch;
                        r18_5 = r18_5(r19_5);
                        if r18_5 == "Up" then
                            A0_5.pitch = -85;
                        else
                            r18_5 = r10_138;
                            r19_5 = r50_138;
                            r20_5 = r46_138;
                            r20_5 = r20_5["anti-aim"];
                            r20_5 = r20_5.anti_aim_state;
                            r19_5 = r19_5[r20_5];
                            r19_5 = r19_5.pitch;
                            r18_5 = r18_5(r19_5);
                            if r18_5 == "Random" then
                                r18_5 = r88_0;
                                r18_5 = r18_5.random_int;
                                r19_5 = -89;
                                r20_5 = 89;
                                r18_5 = r18_5(r19_5, r20_5);
                                A0_5.pitch = r18_5;
                            end
                        end
                    end
                end
                r18_5 = r10_138;
                r19_5 = r50_138;
                r20_5 = r46_138;
                r20_5 = r20_5["anti-aim"];
                r20_5 = r20_5.anti_aim_state;
                r19_5 = r19_5[r20_5];
                r19_5 = r19_5.yaw;
                r18_5 = r18_5(r19_5);
                if r18_5 == "180" then
                    r18_5 = r10_138;
                    r19_5 = r50_138;
                    r20_5 = r46_138;
                    r20_5 = r20_5["anti-aim"];
                    r20_5 = r20_5.anti_aim_state;
                    r19_5 = r19_5[r20_5];
                    r19_5 = r19_5.yaw_custom;
                    r18_5 = r18_5(r19_5);
                    r18_5 = 180 + r18_5;
                    r19_5 = r88_0;
                    r19_5 = r19_5.current_threat;
                    r19_5 = r19_5();
                    r19_5 = r19_5 ~= nil;
                    if r19_5 then
                        r19_5 = r5_5.y;
                    end
                    if not r19_5 then
                        r19_5 = r1_5.y;
                    end
                    r18_5 = r18_5 + r19_5;
                    A0_5.yaw = r18_5;
                else
                    r18_5 = r10_138;
                    r19_5 = r50_138;
                    r20_5 = r46_138;
                    r20_5 = r20_5["anti-aim"];
                    r20_5 = r20_5.anti_aim_state;
                    r19_5 = r19_5[r20_5];
                    r19_5 = r19_5.yaw;
                    r18_5 = r18_5(r19_5);
                    if r18_5 == "Static" then
                        r18_5 = r10_138;
                        r19_5 = r50_138;
                        r20_5 = r46_138;
                        r20_5 = r20_5["anti-aim"];
                        r20_5 = r20_5.anti_aim_state;
                        r19_5 = r19_5[r20_5];
                        r19_5 = r19_5.yaw_custom;
                        r18_5 = r18_5(r19_5);
                        r19_5 = r88_0;
                        r19_5 = r19_5.current_threat;
                        r19_5 = r19_5();
                        r19_5 = r19_5 ~= nil;
                        if r19_5 then
                            r19_5 = r5_5.y;
                        end
                        if not r19_5 then
                            r19_5 = r1_5.y;
                        end
                        r18_5 = r18_5 + r19_5;
                        A0_5.yaw = r18_5;
                    else
                        r18_5 = r10_138;
                        r19_5 = r50_138;
                        r20_5 = r46_138;
                        r20_5 = r20_5["anti-aim"];
                        r20_5 = r20_5.anti_aim_state;
                        r19_5 = r19_5[r20_5];
                        r19_5 = r19_5.yaw;
                        r18_5 = r18_5(r19_5);
                        if r18_5 == "Spin" then
                            r18_5 = spen;
                            r19_5 = r10_138;
                            r20_5 = r50_138;
                            r21_5 = r46_138;
                            r21_5 = r21_5["anti-aim"];
                            r21_5 = r21_5.anti_aim_state;
                            r20_5 = r20_5[r21_5];
                            r20_5 = r20_5.yaw_custom;
                            r19_5 = r19_5(r20_5);
                            r18_5 = r18_5 + r19_5;
                            spen = r18_5;
                            r18_5 = r88_0;
                            r18_5 = r18_5.current_threat;
                            r18_5 = r18_5();
                            r18_5 = r18_5 ~= nil;
                            if r18_5 then
                                r18_5 = r5_5.y;
                            end
                            if not r18_5 then
                                r18_5 = r1_5.y;
                            end
                            r19_5 = spen;
                            r18_5 = r18_5 + r19_5;
                            A0_5.yaw = r18_5;
                        end
                    end
                end
                r18_5 = r10_138;
                r19_5 = r50_138;
                r20_5 = r46_138;
                r20_5 = r20_5["anti-aim"];
                r20_5 = r20_5.anti_aim_state;
                r19_5 = r19_5[r20_5];
                r19_5 = r19_5.yaw_jitter;
                r18_5 = r18_5(r19_5);
                if r18_5 ~= "Off" then
                    r18_5 = A0_5.yaw;
                    r19_5 = jitter_byaw;
                    if r19_5 then
                        r19_5 = r10_138;
                        r20_5 = r50_138;
                        r21_5 = r46_138;
                        r21_5 = r21_5["anti-aim"];
                        r21_5 = r21_5.anti_aim_state;
                        r20_5 = r20_5[r21_5];
                        r20_5 = r20_5.yaw_jitter_custom;
                        r19_5 = r19_5(r20_5);
                    end
                    if not r19_5 then
                        r19_5 = r10_138;
                        r20_5 = r50_138;
                        r21_5 = r46_138;
                        r21_5 = r21_5["anti-aim"];
                        r21_5 = r21_5.anti_aim_state;
                        r20_5 = r20_5[r21_5];
                        r20_5 = r20_5.yaw_jitter_custom;
                        r19_5 = r19_5(r20_5);
                        r19_5 = -r19_5;
                    end
                    r18_5 = r18_5 + r19_5;
                    A0_5.yaw = r18_5;
                end
                r18_5 = r46_138;
                r18_5 = r18_5["anti-aim"];
                r18_5 = r18_5.mode;
                if r18_5 == "right" then
                    r18_5 = r1_5.y;
                    r18_5 = -89 + r18_5;
                    A0_5.yaw = r18_5;
                else
                    r18_5 = r46_138;
                    r18_5 = r18_5["anti-aim"];
                    r18_5 = r18_5.mode;
                    if r18_5 == "left" then
                        r18_5 = r1_5.y;
                        r18_5 = 89 + r18_5;
                        A0_5.yaw = r18_5;
                    end
                end
                r18_5 = r10_138;
                r19_5 = r50_138;
                r20_5 = r46_138;
                r20_5 = r20_5["anti-aim"];
                r20_5 = r20_5.anti_aim_state;
                r19_5 = r19_5[r20_5];
                r19_5 = r19_5.body_yaw;
                r18_5 = r18_5(r19_5);
                if r18_5 ~= "Off" then
                    r18_5 = A0_5.in_moveright;
                    if r18_5 == 0 then
                        r19_5 = A0_5.in_moveleft;
                        if (r19_5 == 0) and r7_5 then
                            r18_5 = r27_138;
                            r18_5 = r18_5();
                            r18_5 = r18_5 % 2;
                            if r18_5 == 0 then
                                r18_5 = r13_138;
                                r19_5 = r28_138;
                                r19_5 = r19_5();
                                r20_5 = "m_flDuckAmount";
                                r18_5 = r18_5(r19_5, r20_5);
                                r18_5 = not (r18_5 < 0);
                                if r18_5 then
                                    r18_5 = 2.98;
                                end
                                if not r18_5 then
                                    r18_5 = 1.01;
                                end
                                A0_5.sidemove = r18_5;
                            else
                                r18_5 = r13_138;
                                r19_5 = r28_138;
                                r19_5 = r19_5();
                                r20_5 = "m_flDuckAmount";
                                r18_5 = r18_5(r19_5, r20_5);
                                r18_5 = not (r18_5 < 0);
                                if r18_5 then
                                    r18_5 = -2.98;
                                end
                                if not r18_5 then
                                    r18_5 = -1.01;
                                end
                                A0_5.sidemove = r18_5;
                            end
                        end
                    end
                    r18_5 = A0_5.chokedcommands;
                    if r18_5 == 0 then
                        r18_5 = r10_138;
                        r19_5 = r50_138;
                        r20_5 = r46_138;
                        r20_5 = r20_5["anti-aim"];
                        r20_5 = r20_5.anti_aim_state;
                        r19_5 = r19_5[r20_5];
                        r19_5 = r19_5.body_yaw;
                        r18_5 = r18_5(r19_5);
                        if r18_5 == "Static" then
                            r18_5 = A0_5.yaw;
                            r19_5 = r10_138;
                            r20_5 = r50_138;
                            r21_5 = r46_138;
                            r21_5 = r21_5["anti-aim"];
                            r21_5 = r21_5.anti_aim_state;
                            r20_5 = r20_5[r21_5];
                            r20_5 = r20_5.body_yaw_custom;
                            r19_5 = r19_5(r20_5);
                            r18_5 = r18_5 + r19_5;
                            A0_5.yaw = r18_5;
                        else
                            r18_5 = r10_138;
                            r19_5 = r50_138;
                            r20_5 = r46_138;
                            r20_5 = r20_5["anti-aim"];
                            r20_5 = r20_5.anti_aim_state;
                            r19_5 = r19_5[r20_5];
                            r19_5 = r19_5.body_yaw;
                            r18_5 = r18_5(r19_5);
                            if r18_5 == "Jitter" then
                                r18_5 = A0_5.yaw;
                                r19_5 = jitter_byaw;
                                if r19_5 then
                                    r19_5 = r10_138;
                                    r20_5 = r50_138;
                                    r21_5 = r46_138;
                                    r21_5 = r21_5["anti-aim"];
                                    r21_5 = r21_5.anti_aim_state;
                                    r20_5 = r20_5[r21_5];
                                    r20_5 = r20_5.body_yaw_custom;
                                    r19_5 = r19_5(r20_5);
                                end
                                if not r19_5 then
                                    r19_5 = r10_138;
                                    r20_5 = r50_138;
                                    r21_5 = r46_138;
                                    r21_5 = r21_5["anti-aim"];
                                    r21_5 = r21_5.anti_aim_state;
                                    r20_5 = r20_5[r21_5];
                                    r20_5 = r20_5.body_yaw_custom;
                                    r19_5 = r19_5(r20_5);
                                    r19_5 = -r19_5;
                                end
                                r18_5 = r18_5 + r19_5;
                                A0_5.yaw = r18_5;
                            end
                        end
                        A0_5.allow_send_packet = false;
                    else
                        r18_5 = A0_5.yaw;
                        A0_5.yaw = r18_5;
                        A0_5.allow_send_packet = true;
                    end
                end
                r18_5 = r10_138;
                r19_5 = r45_138;
                r19_5 = r19_5["anti-aim"];
                r19_5 = r19_5.anti_backstab;
                r18_5 = r18_5(r19_5);
                if r18_5 then
                    r18_5 = 99999;
                    distance = r18_5;
                    r18_5 = ipairs;
                    r19_5 = _G;
                    r20_5 = "entity";
                    r19_5 = r19_5[r20_5];
                    r20_5 = "get_players";
                    r19_5 = r19_5[r20_5];
                    r20_5 = true;
                    r18_5, r19_5, r20_5 = r18_5(r19_5(r20_5));
                    for r21_5, r22_5 in r18_5, r19_5, r20_5 do
                        r23_5 = r41_138;
                        r24_5 = r26_138;
                        r25_5 = r28_138;
                        r23_5 = r23_5(r24_5(r25_5()));
                        r24_5 = r60_138;
                        r25_5 = r22_5;
                        r26_5 = r41_138;
                        r27_5 = r26_138;
                        r28_5 = r22_5;
                        r26_5 = r26_5(r27_5(r28_5));
                        r27_5 = 10;
                        r24_5 = r24_5(r25_5, r26_5, r27_5);
                        r25_5 = r41_138;
                        r26_5 = r26_138;
                        r27_5 = r71_138;
                        r25_5 = r25_5(r26_5(r27_5));
                        r27_5 = r23_5;
                        r26_5 = r23_5.dist2d;
                        r28_5 = r24_5;
                        r26_5 = r26_5(r27_5, r28_5);
                        r27_5 = distance;
                        if r26_5 <= r27_5 then
                            r26_5 = r22_5;
                            r71_138 = r26_5;
                            r27_5 = r23_5;
                            r26_5 = r23_5.dist2d;
                            r28_5 = r24_5;
                            r26_5 = r26_5(r27_5, r28_5);
                            distance = r26_5;
                        else
                            r27_5 = r23_5;
                            r26_5 = r23_5.dist2d;
                            r28_5 = r24_5;
                            r26_5 = r26_5(r27_5, r28_5);
                            r28_5 = r23_5;
                            r27_5 = r23_5.dist2d;
                            r29_5 = r25_5;
                            r27_5 = r27_5(r28_5, r29_5);
                            if r26_5 <= r27_5 then
                                r26_5 = r22_5;
                                r71_138 = r26_5;
                                r27_5 = r23_5;
                                r26_5 = r23_5.dist2d;
                                r28_5 = r24_5;
                                r26_5 = r26_5(r27_5, r28_5);
                                distance = r26_5;
                            end
                        end
                        r26_5 = r25_138;
                        r27_5 = r89_0;
                        r27_5 = r27_5.get_player_weapon;
                        r28_5 = r71_138;
                        r26_5 = r26_5(r27_5(r28_5));
                        if r26_5 == "CKnife" then
                            r28_5 = r23_5;
                            r27_5 = r23_5.dist2d;
                            r29_5 = r41_138;
                            r30_5 = r26_138;
                            r31_5 = r71_138;
                            r27_5 = r27_5(r28_5, r29_5(r30_5(r31_5)));
                            if r27_5 < 250 then
                                r26_5 = r5_5.y;
                                r26_5 = 0 + r26_5;
                                A0_5.yaw = r26_5;
                            end
                        end
                    end
                end
                return;
            end
        end
    end
    return;
end;
r46_138["anti-aim"].teleport_techology = function()
    if r10_138(r45_138["anti-aim"].dt_teleport) then
        r87_0.set(r51_138.dt[1], (globals.tickcount() % 20) >= 1);
    else
        r87_0.set(r51_138.dt[1], true);
    end
end;
local r72_138 = { dt = 0, os = 0, main = 0, safepoint = 0, baim = 0, quickpeek = 0 };
local r73_138 = { lua_name = 0, dt = 0, os = 0, main = 0, safepoint = 0, baim = 0, quickpeek = 0 };
function r46_138.visuals.crosshair_indicator(r0_161, r1_161)
    if (r10_138(r45_138.visuals.indicator) == "Default") and entity.is_alive(r28_138()) then
        local r2_161 = 0;
        local r3_161 = r13_138(r28_138(), "m_bIsScoped") == 1;
        if r3_161 then
            r3_161 = r10_138(r45_138.visuals.indicator_scoped_animation);
        end
        local r4_161 = r73_138;
        local r5_161 = r56_138;
        local r6_161 = r73_138.lua_name;
        local r7_161 = r3_161 and
        ((r21_138("c-", string.format("Ven\a%02X%02X%02XFFus\afffffffe", r10_138(r45_138.visuals.indicator_color))) / 2) + 6);
        if not r7_161 then
            r7_161 = 0;
        end
        r4_161.lua_name = r5_161(r6_161, r7_161, globals.frametime() * 15);
        r4_161 = r73_138;
        r5_161 = r56_138;
        r6_161 = r73_138.dt;
        r7_161 = r3_161 and ((r21_138("c-", "DT") / 2) + 4);
        if not r7_161 then
            r7_161 = 0;
        end
        r4_161.dt = r5_161(r6_161, r7_161, globals.frametime() * 15);
        r4_161 = r73_138;
        r5_161 = r56_138;
        r6_161 = r73_138.os;
        r7_161 = r3_161 and ((r21_138("c-", "OS") / 2) + 4);
        if not r7_161 then
            r7_161 = 0;
        end
        r4_161.os = r5_161(r6_161, r7_161, globals.frametime() * 15);
        r4_161 = r73_138;
        r5_161 = r56_138;
        r6_161 = r73_138.main;
        r7_161 = r3_161 and ((r21_138("c-", "BAIM") / 2) + 16);
        if not r7_161 then
            r7_161 = 0;
        end
        r4_161.main = r5_161(r6_161, r7_161, globals.frametime() * 15);
        r4_161 = r10_138(r51_138.dt[1]) and r10_138(r51_138.dt[2]);
        r5_161 = r10_138(r51_138.os[1]) and r10_138(r51_138.os[2]);
        if r5_161 then
            r5_161 = r10_138(r51_138.dt[1]) and (not r10_138(r51_138.dt[2]));
            if not r5_161 then
                r5_161 = not r10_138(r51_138.dt[1]);
            end
        end
        r2_161 = r2_161 + 10;
        if r10_138(r51_138.dt[1]) and r10_138(r51_138.dt[2]) then
            r6_161 = r72_138;
            r7_161 = r56_138;
            local r8_161 = r72_138.dt;
            local r9_161 = r4_161 and r2_161;
            if not r9_161 then
                r9_161 = 0;
            end
            r6_161.dt = r7_161(r8_161, r9_161, globals.frametime() * 15);
            r6_161 = r15_138;
            r7_161 = ((r0_161 / 2) - 2) + math.ceil(r73_138.dt);
            r8_161 = (r1_161 / 2) + 27 + math.ceil(r72_138.dt);
            r9_161 = 255;
            local r10_161 = 255;
            local r11_161 = 255;
            local r12_161 = r34_138.get_double_tap() and 255;
            if not r12_161 then
                r12_161 = 130;
            end
            r6_161(r7_161, r8_161, r9_161, r10_161, r11_161, r12_161, "c-", 0, "DT");
            r2_161 = r2_161 + 10;
        else
            r72_138.dt = 1;
        end
        if r10_138(r51_138.os[1]) and r10_138(r51_138.os[2]) and ((r10_138(r51_138.dt[1]) and (not r10_138(r51_138.dt[2]))) or (not r10_138(r51_138.dt[2]))) then
            r6_161 = r72_138;
            r7_161 = r56_138;
            local r8_161 = r72_138.os;
            local r9_161 = r5_161 and r2_161;
            if not r9_161 then
                r9_161 = 0;
            end
            r6_161.os = r7_161(r8_161, r9_161, globals.frametime() * 15);
            r15_138(((r0_161 / 2) - 2) + math.ceil(r73_138.os), (r1_161 / 2) + 27 + math.ceil(r72_138.os), 255, 255, 255,
                255, "c-", 0, "OS");
            r2_161 = r2_161 + 10;
        else
            r72_138.os = 1;
        end
        local r6_161, r7_161 = r21_138("c-", "BAIM");
        r72_138.main = r56_138(r72_138.main, r2_161, globals.frametime() * 15);
        local r8_161 = r15_138;
        local r9_161 = ((r0_161 / 2) - 2) + math.ceil(r73_138.main);
        local r10_161 = (r1_161 / 2) + 27 + math.ceil(r72_138.main);
        local r11_161 = 255;
        local r12_161 = 255;
        local r13_161 = 255;
        local r14_161 = r10_138(r51_138.forcebaim) and 255;
        if not r14_161 then
            r14_161 = 130;
        end
        r8_161(r9_161, r10_161, r11_161, r12_161, r13_161, r14_161, "c-", 0, "BAIM");
        r8_161 = r15_138;
        r9_161 = (((r0_161 / 2) - 2) - r6_161) + 2 + math.ceil(r73_138.main);
        r10_161 = (r1_161 / 2) + 27 + math.ceil(r72_138.main);
        r11_161 = 255;
        r12_161 = 255;
        r13_161 = 255;
        r14_161 = r10_138(r51_138.safepoint) and 255;
        if not r14_161 then
            r14_161 = 130;
        end
        r8_161(r9_161, r10_161, r11_161, r12_161, r13_161, r14_161, "c-", 0, "SP");
        r8_161 = r15_138;
        r9_161 = ((((r0_161 / 2) - 2) + r6_161) - 2) + math.ceil(r73_138.main);
        r10_161 = (r1_161 / 2) + 27 + math.ceil(r72_138.main);
        r11_161 = 255;
        r12_161 = 255;
        r13_161 = 255;
        r14_161 = r10_138(r51_138.quickpeek[2]) and 255;
        if not r14_161 then
            r14_161 = 130;
        end
        r8_161(r9_161, r10_161, r11_161, r12_161, r13_161, r14_161, "c-", 0, "QP");
        r15_138(((r0_161 / 2) + math.ceil(r73_138.lua_name)) - 2, (r1_161 / 2) + 27, 255, 255, 255, 255, "c-", 0,
            string.format("Ven\a%02X%02X%02XFFus\afffffffe", r10_138(r45_138.visuals.indicator_color)):upper());
        return;
    end
    return;
end

function r46_138.visuals.simple_crosshair_indicators(r0_162, r1_162)
    if (r10_138(r45_138.visuals.indicator) == "Simple") and entity.is_alive(r28_138()) then
        local r2_162 = 0;
        local r3_162 = r13_138(r28_138(), "m_bIsScoped") == 1;
        if r3_162 then
            r3_162 = r10_138(r45_138.visuals.indicator_scoped_animation);
        end
        local r4_162 = r73_138;
        local r5_162 = r56_138;
        local r6_162 = r73_138.dt;
        local r7_162 = r3_162 and ((r21_138("c", "dt") / 2) + 2);
        if not r7_162 then
            r7_162 = 0;
        end
        r4_162.dt = r5_162(r6_162, r7_162, globals.frametime() * 15);
        r4_162 = r73_138;
        r5_162 = r56_138;
        r6_162 = r73_138.os;
        r7_162 = r3_162 and ((r21_138("c", "os") / 2) + 2);
        if not r7_162 then
            r7_162 = 0;
        end
        r4_162.os = r5_162(r6_162, r7_162, globals.frametime() * 15);
        r4_162 = r73_138;
        r5_162 = r56_138;
        r6_162 = r73_138.quickpeek;
        r7_162 = r3_162 and ((r21_138("c", "qp") / 2) + 2);
        if not r7_162 then
            r7_162 = 0;
        end
        r4_162.quickpeek = r5_162(r6_162, r7_162, globals.frametime() * 15);
        r4_162 = r73_138;
        r5_162 = r56_138;
        r6_162 = r73_138.baim;
        r7_162 = r3_162 and ((r21_138("c", "fb") / 2) + 2);
        if not r7_162 then
            r7_162 = 0;
        end
        r4_162.baim = r5_162(r6_162, r7_162, globals.frametime() * 15);
        r4_162 = r73_138;
        r5_162 = r56_138;
        r6_162 = r73_138.safepoint;
        r7_162 = r3_162 and ((r21_138("c", "sp") / 2) + 2);
        if not r7_162 then
            r7_162 = 0;
        end
        r4_162.safepoint = r5_162(r6_162, r7_162, globals.frametime() * 15);
        r4_162 = r10_138(r51_138.dt[1]) and r10_138(r51_138.dt[2]);
        r5_162 = r10_138(r51_138.os[1]) and r10_138(r51_138.os[2]);
        if r5_162 then
            r5_162 = r10_138(r51_138.dt[1]) and (not r10_138(r51_138.dt[2]));
        end
        if not r5_162 then
            r5_162 = not r10_138(r51_138.dt[1]);
        end
        r6_162 = r10_138(r51_138.quickpeek[2]) and r10_138(r51_138.quickpeek[1]);
        if r10_138(r51_138.dt[1]) and r10_138(r51_138.dt[2]) then
            r2_162 = r2_162 + 12;
            r7_162 = r72_138;
            local r8_162 = r56_138;
            local r9_162 = r72_138.dt;
            local r10_162 = r4_162 and r2_162;
            if not r10_162 then
                r10_162 = 0;
            end
            r7_162.dt = r8_162(r9_162, r10_162, globals.frametime() * 15);
            r7_162 = r15_138;
            r8_162 = (r0_162 / 2) + math.ceil(r73_138.dt);
            r9_162 = (r1_162 / 2) + 15 + math.ceil(r72_138.dt);
            r10_162 = 255;
            local r11_162 = 255;
            local r12_162 = 255;
            local r13_162 = r34_138.get_double_tap() and 255;
            if not r13_162 then
                r13_162 = 130;
            end
            r7_162(r8_162, r9_162, r10_162, r11_162, r12_162, r13_162, "c", 0, "dt");
        else
            r72_138.dt = 0;
        end
        r7_162 = r72_138;
        local r8_162 = r56_138;
        local r9_162 = r72_138.os;
        local r10_162 = r5_162 and r2_162;
        if not r10_162 then
            r10_162 = 0;
        end
        r7_162.os = r8_162(r9_162, r10_162, globals.frametime() * 15);
        if (r10_138(r51_138.os[1]) and r10_138(r51_138.os[2]) and r10_138(r51_138.dt[1]) and (not r10_138(r51_138.dt[2]))) or (not r10_138(r51_138.dt[1])) then
            r15_138((r0_162 / 2) + math.ceil(r73_138.os), (r1_162 / 2) + 27 + math.ceil(r72_138.os), 255, 255, 255, 255,
                "c", 0, "os");
            r2_162 = r2_162 + 12;
        else
            r72_138.os = 0;
        end
        r7_162 = r72_138;
        r8_162 = r56_138;
        r9_162 = r72_138.baim;
        r10_162 = r10_138(r51_138.forcebaim) and r2_162;
        if not r10_162 then
            r10_162 = 0;
        end
        r7_162.baim = r8_162(r9_162, r10_162, globals.frametime() * 15);
        if r10_138(r51_138.forcebaim) then
            r15_138((r0_162 / 2) + math.ceil(r73_138.baim), (r1_162 / 2) + 27 + math.ceil(r72_138.baim), 255, 255, 255,
                255, "c", 0, "fb");
            r2_162 = r2_162 + 12;
        else
            r72_138.baim = -12;
        end
        r7_162 = r72_138;
        r8_162 = r56_138;
        r9_162 = r72_138.safepoint;
        r10_162 = r10_138(r51_138.safepoint) and r2_162;
        if not r10_162 then
            r10_162 = 0;
        end
        r7_162.safepoint = r8_162(r9_162, r10_162, globals.frametime() * 15);
        if r10_138(r51_138.safepoint) then
            r15_138((r0_162 / 2) + math.ceil(r73_138.safepoint), (r1_162 / 2) + 27 + math.ceil(r72_138.safepoint), 255,
                255, 255, 255, "c", 0, "sp");
            r2_162 = r2_162 + 12;
        else
            r72_138.safepoint = -12;
        end
        r7_162 = r72_138;
        r8_162 = r56_138;
        r9_162 = r72_138.quickpeek;
        r10_162 = r6_162 and r2_162;
        if not r10_162 then
            r10_162 = 0;
        end
        r7_162.quickpeek = r8_162(r9_162, r10_162, globals.frametime() * 15);
        if r10_138(r51_138.quickpeek[2]) and r10_138(r51_138.quickpeek[1]) then
            r15_138((r0_162 / 2) + math.ceil(r73_138.quickpeek), (r1_162 / 2) + 27 + math.ceil(r72_138.quickpeek), 255,
                255, 255, 255, "c", 0, "qp");
            r2_162 = r2_162 + 12;
        else
            r72_138.quickpeek = -12;
        end
        return;
    end
    return;
end

local r74_138 = { Default = { right = "⯈", left = "⯇" }, Simple = { right = ">", left = "< " } };
function r46_138.visuals.manual_anti_aim_indicators(r0_163, r1_163)
    if r10_138(r45_138.visuals.manual_anti_aim_indicators) and entity.is_alive(r28_138()) then
        local r2_163 = { r10_138(r45_138.visuals.manual_anti_aim_indicators_color) };
        local r3_163 = { r = 255, g = 255, b = 255, a = 255 };
        local r4_163 = { r = 255, g = 255, b = 255, a = 255 };
        if r46_138["anti-aim"].mode == "right" then
            r4_163 = { r = r2_163[1], g = r2_163[2], b = r2_163[3], a = r2_163[4] };
        elseif r46_138["anti-aim"].mode == "left" then
            r3_163 = { r = r2_163[1], g = r2_163[2], b = r2_163[3], a = r2_163[4] };
        end
        if r10_138(r45_138.visuals.mi_type) ~= "Modern" then
            r15_138((r0_163 / 2) + 50, r1_163 / 2, r4_163.r, r4_163.g, r4_163.b, r4_163.a, "c+-", nil,
                r74_138[r10_138(r45_138.visuals.mi_type)].right);
            r15_138((r0_163 / 2) - 50, r1_163 / 2, r3_163.r, r3_163.g, r3_163.b, r3_163.a, "c+-", nil,
                r74_138[r10_138(r45_138.visuals.mi_type)].left);
        else
            r90_0.triangle((r0_163 / 2) + 50, (r1_163 / 2) - 5, (r0_163 / 2) + 60, r1_163 / 2, (r0_163 / 2) + 50,
                (r1_163 / 2) + 5, r4_163.r, r4_163.g, r4_163.b, 100);
            r90_0.line((r0_163 / 2) + 50, (r1_163 / 2) + 5, (r0_163 / 2) + 60, r1_163 / 2, r4_163.r, r4_163.g, r4_163.b,
                r4_163.a);
            r90_0.line((r0_163 / 2) + 50, (r1_163 / 2) - 5, (r0_163 / 2) + 60, r1_163 / 2, r4_163.r, r4_163.g, r4_163.b,
                r4_163.a);
            r90_0.line((r0_163 / 2) + 50, (r1_163 / 2) + 5, (r0_163 / 2) + 50, (r1_163 / 2) - 5, r4_163.r, r4_163.g,
                r4_163.b, r4_163.a);
            r90_0.triangle((r0_163 / 2) - 50, (r1_163 / 2) - 5, (r0_163 / 2) - 60, r1_163 / 2, (r0_163 / 2) - 50,
                (r1_163 / 2) + 5, r3_163.r, r3_163.g, r3_163.b, 100);
            r90_0.line((r0_163 / 2) - 50, (r1_163 / 2) + 5, (r0_163 / 2) - 60, r1_163 / 2, r3_163.r, r3_163.g, r3_163.b,
                r3_163.a);
            r90_0.line((r0_163 / 2) - 50, (r1_163 / 2) - 5, (r0_163 / 2) - 60, r1_163 / 2, r3_163.r, r3_163.g, r3_163.b,
                r3_163.a);
            r90_0.line((r0_163 / 2) - 50, (r1_163 / 2) + 5, (r0_163 / 2) - 50, (r1_163 / 2) - 5, r3_163.r, r3_163.g,
                r3_163.b, r3_163.a);
        end
        return;
    end
    return;
end

local r76_138 = r90_0.load_svg(
'<svg width="800" height="800" viewBox="0 0 24 24" fill="#fff" xmlns="http://www.w3.org/2000/svg"><path d="M5 7c0-.276.225-.499.498-.535 2.149-.28 5.282-2.186 6.224-2.785a.516.516 0 0 1 .556 0c.942.599 4.075 2.504 6.224 2.785.273.036.498.259.498.535v4.75c0 6.5-7 8.75-7 8.75s-7-2.25-7-8.75V7Z" fill="white"/></svg>',
    200, 200);
local r77_138 = false;
function r46_138.visuals.defensive_open(r0_164, r1_164)
    if r87_0.is_menu_open() and r10_138(r45_138.visuals.defensive_indicator) then
        local r2_164, r3_164 = r87_0.mouse_position();
        if r49_138.is_dragging and (not r88_0.key_state(1)) then
            r49_138.is_dragging = false;
        end
        if r49_138.is_dragging and r88_0.key_state(1) and (r49_138.last_item == "Defensive") then
            r49_138.defensive_x = r2_164 - r49_138.drag_defensive_x;
            r49_138.defensive_y = r3_164 - r49_138.drag_defensive_y;
        end
        if r58_138(r49_138.defensive_x - (r10_138(r45_138.extras.length) / 2), r49_138.defensive_y - 10, r10_138(r45_138.extras.length), 20) and r88_0.key_state(1) then
            r49_138.last_item = "Defensive";
            r49_138.is_dragging = true;
            r49_138.drag_defensive_x = r2_164 - r49_138.defensive_x;
            r49_138.drag_defensive_y = r3_164 - r49_138.defensive_y;
            r49_138.defensive_menu = false;
            r77_138 = false;
        end
        if r58_138(r49_138.defensive_x - (r10_138(r45_138.extras.length) / 2), r49_138.defensive_y - 10, r10_138(r45_138.extras.length), 20) and r88_0.key_state(2) then
            r49_138.defensive_menu = true;
            r77_138 = false;
            r49_138.slow_menu = false;
        end
        if r10_138(r45_138.extras.icon) then
            local r4_164 = r10_138(r45_138.extras.text) and 16;
            if not r4_164 then
                r4_164 = 0;
            end
            r22_138(r76_138, (r49_138.defensive_x - 25) - 2, ((r49_138.defensive_y - 27) - 25) - r4_164, 54, 54, 12, 12,
                12, 255, "f");
            r22_138(r76_138, r49_138.defensive_x - 25, ((r49_138.defensive_y - 25) - 25) - r4_164, 50, 50, 255, 255, 255,
                255, "f");
        end
        if r10_138(r45_138.extras.text) then
            r15_138(r49_138.defensive_x, r49_138.defensive_y - 12, 255, 255, 255, 255, "c", 0, "- DEFENSIVE -");
        end
        r16_138((r49_138.defensive_x - (r10_138(r45_138.extras.length) / 2)) - 1, r49_138.defensive_y - 4,
            r10_138(r45_138.extras.length) + 2, r10_138(r45_138.extras.width) + 4, 0, 0, 0, 150);
        local r4_164 = { r10_138(r45_138.visuals.defensive_indicator_color) };
        if r10_138(r45_138.extras.gradient) then
            r20_138((r49_138.defensive_x - (r10_138(r45_138.extras.length) / 2)) + 1, r49_138.defensive_y - 2,
                r10_138(r45_138.extras.length) - 2, r10_138(r45_138.extras.width), r4_164[1], r4_164[2], r4_164[3],
                r4_164[4], 12, 12, 12, 130, true);
        else
            r16_138((r49_138.defensive_x - (r10_138(r45_138.extras.length) / 2)) + 1, r49_138.defensive_y - 2,
                r10_138(r45_138.extras.length) - 2, r10_138(r45_138.extras.width), r4_164[1], r4_164[2], r4_164[3], 255);
        end
    else
        r49_138.defensive_menu = false;
    end
    if (r49_138.defensive_x ~= (r0_164 / 2)) and (not r49_138.is_dragging) then
        r49_138.defensive_x = r56_138(r49_138.defensive_x, r0_164 / 2, globals.frametime() * 10);
    end
end

local r78_138 = 255;
local r79_138 = 0;
function r46_138.visuals.defensive_indicator(r0_165, r1_165)
    r46_138["anti-aim"].sim_time = r46_138["anti-aim"].sim_diff();
    if r10_138(r45_138.visuals.defensive_indicator) and r10_138(r51_138.dt[2]) and (not r10_138(r51_138.fakeduck)) and entity.is_alive(r28_138()) and (not r87_0.is_menu_open()) then
        local r2_165 = { r10_138(r45_138.visuals.defensive_indicator_color) };
        if r46_138["anti-aim"].sim_time < 0 then
            r46_138.visuals.is_defensive = true;
            r46_138.visuals.defensive_tick = r27_138();
            if ((not r46_138.visuals.forced_defensive) or (0 > r79_138)) and (not r46_138.visuals.forced_defensive) then
                r79_138 = 0;
            end
            r78_138 = 255;
        end
        if (r46_138.visuals.is_defensive == true) and (r27_138() < (r46_138.visuals.defensive_tick + 28)) then
            local r4_165 = math.min(100, ((r27_138() - r46_138.visuals.defensive_tick) * 100) / 26);
            local r5_165 = (r4_165 * r10_138(r45_138.extras.length)) / 100;
            if r4_165 > 75 then
                r78_138 = r56_138(r78_138, 0, globals.frametime() * 15);
            end
            r79_138 = r56_138(r79_138, 50, globals.frametime() * 10);
            if r10_138(r45_138.extras.icon) then
                local r6_165 = r10_138(r45_138.extras.text) and 16;
                if not r6_165 then
                    r6_165 = 0;
                end
                local r7_165 = r22_138;
                local r8_165 = r76_138;
                local r9_165 = (r49_138.defensive_x - (r79_138 / 2)) - 2;
                local r10_165 = ((r49_138.defensive_y - 27) - 25) - r6_165;
                local r11_165 = r79_138 + 4;
                local r12_165 = 54;
                local r13_165 = 12;
                local r14_165 = 12;
                local r15_165 = 12;
                local r16_165 = r78_138 < 230;
                if r16_165 then
                    r16_165 = r78_138;
                end
                if not r16_165 then
                    r16_165 = 230;
                end
                r7_165(r8_165, r9_165, r10_165, r11_165, r12_165, r13_165, r14_165, r15_165, r16_165, "f");
                r7_165 = r22_138;
                r8_165 = r76_138;
                r9_165 = r49_138.defensive_x - (r79_138 / 2);
                r10_165 = ((r49_138.defensive_y - 25) - 25) - r6_165;
                r11_165 = r79_138;
                r12_165 = 50;
                r13_165 = 255;
                r14_165 = 255;
                r15_165 = 255;
                r16_165 = r78_138 < 230;
                if r16_165 then
                    r16_165 = r78_138;
                end
                if not r16_165 then
                    r16_165 = 230;
                end
                r7_165(r8_165, r9_165, r10_165, r11_165, r12_165, r13_165, r14_165, r15_165, r16_165, "f");
            end
            if r10_138(r45_138.extras.text) then
                local r6_165 = r15_138;
                local r7_165 = r49_138.defensive_x;
                local r8_165 = r49_138.defensive_y - 12;
                local r9_165 = 255;
                local r10_165 = 255;
                local r11_165 = 255;
                local r12_165 = r78_138 < 255;
                if r12_165 then
                    r12_165 = r78_138;
                end
                if not r12_165 then
                    r12_165 = 255;
                end
                r6_165(r7_165, r8_165, r9_165, r10_165, r11_165, r12_165, "c", 0, "- DEFENSIVE -");
            end
            local r6_165 = r16_138;
            local r7_165 = (r49_138.defensive_x - (r10_138(r45_138.extras.length) / 2)) - 1;
            local r8_165 = r49_138.defensive_y - 4;
            local r9_165 = r10_138(r45_138.extras.length) + 2;
            local r10_165 = r10_138(r45_138.extras.width) + 4;
            local r11_165 = 0;
            local r12_165 = 0;
            local r13_165 = 0;
            local r14_165 = r78_138 < 150;
            if r14_165 then
                r14_165 = r78_138;
            end
            if not r14_165 then
                r14_165 = 150;
            end
            r6_165(r7_165, r8_165, r9_165, r10_165, r11_165, r12_165, r13_165, r14_165);
            if r10_138(r45_138.extras.gradient) then
                r6_165 = r20_138;
                r7_165 = r49_138.defensive_x - (r10_138(r45_138.extras.length) / 2);
                r8_165 = r49_138.defensive_y - 2;
                r9_165 = r5_165;
                r10_165 = r10_138(r45_138.extras.width);
                r11_165 = r2_165[1];
                r12_165 = r2_165[2];
                r13_165 = r2_165[3];
                r14_165 = r78_138 < r2_165[4];
                if r14_165 then
                    r14_165 = r78_138;
                end
                if not r14_165 then
                    r14_165 = r2_165[4];
                end
                local r15_165 = 12;
                local r16_165 = 12;
                local r17_165 = 12;
                local r18_165 = r78_138 < 130;
                if r18_165 then
                    r18_165 = r78_138;
                end
                if not r18_165 then
                    r18_165 = 130;
                end
                r6_165(r7_165, r8_165, r9_165, r10_165, r11_165, r12_165, r13_165, r14_165, r15_165, r16_165, r17_165,
                    r18_165, true);
            else
                r6_165 = r16_138;
                r7_165 = (r49_138.defensive_x - (r10_138(r45_138.extras.length) / 2)) + 1;
                r8_165 = r49_138.defensive_y - 2;
                r9_165 = r5_165;
                r10_165 = r10_138(r45_138.extras.width);
                r11_165 = r2_165[1];
                r12_165 = r2_165[2];
                r13_165 = r2_165[3];
                r14_165 = r78_138 < r2_165[4];
                if r14_165 then
                    r14_165 = r78_138;
                end
                if not r14_165 then
                    r14_165 = r2_165[4];
                end
                r6_165(r7_165, r8_165, r9_165, r10_165, r11_165, r12_165, r13_165, r14_165);
            end
        else
            r46_138.visuals.is_defensive = false;
        end
        return;
    end
    return;
end

local r80_138 = false;
local r81_138 = false;
local function r82_138(r0_166, r1_166, r2_166, r3_166)
    local r4_166 = { 63, 63, 63, 255 };
    if r58_138(r2_166, (r3_166 - 35) + r49_138.size, 55, 10) then
        if r88_0.key_state(1) then
            if r80_138 == false then
                r87_0.set(r1_166, not r87_0.get(r1_166));
            end
            r80_138 = true;
        else
            r80_138 = false;
        end
    end
    if r87_0.get(r1_166) then
        r4_166 = { 255, 255, 255, 255 };
    else
        r4_166 = { 24, 24, 24, 255 };
    end
    r90_0.rectangle(r2_166 - 1, (r3_166 - 35) + r49_138.size, 8, 8, 24, 24, 24, 255);
    r90_0.rectangle(r2_166, (r3_166 - 34) + r49_138.size, 6, 6, r4_166[1], r4_166[2], r4_166[3], r4_166[4]);
    r90_0.text(r2_166 + 10, (r3_166 - 37) + r49_138.size, 255, 255, 255, 255, "-", 0, string.upper(r0_166));
    r49_138.size = r49_138.size + 10;
end
local r83_138 = { ref = 0, last_item = false, hovered_another = false };
local r84_138 = false;
local r85_138 = 0;
local function r86_138(r0_167, r1_167, r2_167, r3_167, r4_167, r5_167, r6_167)
    local r7_167 = 0;
    if r0_167 ~= "" then
        r7_167 = 12;
    else
        r7_167 = 0;
    end
    if r0_167 ~= "" then
        r90_0.text(r5_167 - 1, (r6_167 - 35) + r49_138.size, 220, 220, 220, 255, "-", 0, string.upper(r0_167));
    end
    local r8_167 = r41_138(r87_0.mouse_position());
    if r58_138(r5_167 - 1, (r6_167 - 36) + r49_138.size + r7_167, 60, 4) then
        r83_138.hovered_another = true;
        r49_138.should_drag = false;
        if r88_0.key_state(1) then
            r87_0.set(r1_167,
                math.max(r2_167,
                    math.min(r3_167, math.floor(r2_167 + (((r3_167 - r2_167) * ((r8_167.x - r5_167) - 1)) / 60)))));
            r83_138.ref = r1_167;
            r83_138.last_item = true;
        end
    end
    if r83_138.last_item then
        if r88_0.key_state(37) then
            if (r84_138 == false) or (200 < r85_138) then
                r87_0.set(r83_138.ref, math.max(r2_167, math.min(r3_167, r87_0.get(r83_138.ref) - 1)));
                if r85_138 > 200 then
                    r85_138 = 0;
                end
            end
            r85_138 = r85_138 + 1;
            r84_138 = true;
        elseif r88_0.key_state(39) then
            if (r84_138 == false) or (200 < r85_138) then
                r87_0.set(r83_138.ref, math.max(r2_167, math.min(r3_167, r87_0.get(r83_138.ref) + 1)));
                if r85_138 > 200 then
                    r85_138 = 0;
                end
            end
            r85_138 = r85_138 + 1;
            r84_138 = true;
        else
            r84_138 = false;
            r85_138 = 0;
        end
    end
    local r9_167 = ((r87_0.get(r1_167) - r2_167) / (r3_167 - r2_167)) * 60;
    r90_0.rectangle(r5_167, (r6_167 - 35) + r49_138.size + r7_167, 60, 2, 24, 24, 24, 255);
    r90_0.rectangle(r5_167, (r6_167 - 35) + r49_138.size + r7_167, r9_167, 2, 220, 220, 220, 255);
    r90_0.circle(r5_167 + r9_167, (r6_167 - 34) + r49_138.size + r7_167, 220, 220, 220, 255, 3, 0, 1);
    local r10_167 = r49_138;
    local r11_167 = r49_138.size;
    local r12_167 = r0_167 ~= "";
    if r12_167 then
        r12_167 = 17;
    end
    if not r12_167 then
        r12_167 = 12;
    end
    r10_167.size = r11_167 + r12_167;
end
function r46_138.visuals.side_defensive_menu(r0_168, r1_168)
    if r87_0.is_menu_open() and r49_138.defensive_menu and r10_138(r45_138.visuals.defensive_indicator) then
        if r58_138(r49_138.defensive_x + 85, r49_138.defensive_y - 50, 82, 85) then
            r77_138 = false;
        end
        r55_138(r49_138.defensive_x + 90, r49_138.defensive_y - 50, 70, 85, 24, 24, 24, 100, 5);
        r90_0.gradient(r49_138.defensive_x + 90, r49_138.defensive_y - 40, 35, 1, 24, 24, 24, 0, 255, 255, 255, 255, true);
        r90_0.gradient(r49_138.defensive_x + 90 + 35, r49_138.defensive_y - 40, 35, 1, 255, 255, 255, 255, 24, 24, 24, 0,
            true);
        r90_0.text(r49_138.defensive_x + 90 + 33, r49_138.defensive_y - 47, 255, 255, 255, 255, "-c", 0, "SETTINGS");
        r82_138("Text", r45_138.extras.text, r49_138.defensive_x + 90, r49_138.defensive_y + 3);
        r82_138("Icon", r45_138.extras.icon, r49_138.defensive_x + 90, r49_138.defensive_y + 3);
        r82_138("Gradient", r45_138.extras.gradient, r49_138.defensive_x + 90, r49_138.defensive_y + 3);
        r86_138("length", r45_138.extras.length, 20, 150, "º", r49_138.defensive_x + 90, r49_138.defensive_y + 3);
        r86_138("width", r45_138.extras.width, 1, 15, "º", r49_138.defensive_x + 90, r49_138.defensive_y + 3);
    end
end

local function r87_138()
    local r0_169 = 0;
    local r1_169 = 0;
    local r2_169 = 0;
    local r3_169 = 0;
    if r49_138.last_item == "Defensive" then
        r0_169 = r49_138.defensive_x;
        r1_169 = r49_138.defensive_y;
        r2_169 = r49_138.slow_x;
        r3_169 = r49_138.slow_y;
    else
        r0_169 = r49_138.slow_x;
        r1_169 = r49_138.slow_y;
        r2_169 = r49_138.defensive_x;
        r3_169 = r49_138.defensive_y;
    end
    if ((r3_169 - 60) <= r1_169) and (r1_169 <= (r3_169 + 30)) then
        if r49_138.last_item == "Defensive" then
            r49_138.defensive_y = r49_138.defensive_y + 3;
        else
            r49_138.slow_y = r49_138.slow_y + 60;
        end
    end
    if r49_138.last_item == "Defensive" then
        r49_138.not_last_item = "Slow";
    else
        r49_138.not_last_item = "Defensive";
    end
end
function r46_138.visuals.fps_boost(r0_170)
    cvar.r_drawparticles:set_int(r0_170);
    cvar.func_break_max_pieces:set_int(r0_170);
    cvar.muzzleflash_light:set_int(r0_170);
    cvar.r_drawtracers_firstperson:set_int(r0_170);
    cvar.r_dynamic:set_int(r0_170);
    local r1_170 = cvar.mat_disable_bloom;
    local r3_170 = r0_170 == 0;
    if r3_170 then
        r3_170 = 1;
    end
    if not r3_170 then
        r3_170 = 0;
    end
    r1_170:set_int(r3_170);
    cvar.r_eyegloss:set_int(r0_170);
    cvar.r_shadows:set_int(r0_170);
end

function r46_138.visuals.desync_indicator(r0_171, r1_171)
    if not r10_138(r45_138.visuals.desync_indicator) then
        return;
    end
    local r2_171 = { r10_138(r45_138.visuals.desync_indicator_color) };
    local r3_171 = math.abs(math.floor(math.min(60, (r13_138(r28_138(), "m_flPoseParameter", 11) * 120) - 60)));
    if r3_171 <= 0 then
        return;
    end
    r55_138((r0_171 / 2) - 31, (r1_171 / 2) + 12, 64, 3, 24, 24, 24, 135, 1);
    r55_138((r0_171 / 2) - 29, (r1_171 / 2) + 13, r3_171, 1, 150, 230, 49, 255, 1);
end

local r88_138 = r90_0.load_svg(
'<svg width="800" height="800" viewBox="0 0 128 128" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" class="iconify iconify--noto"><path d="M112.7 59.21s3.94-2.21 4.93-2.77c.99-.56 4.6-2.82 5.91-.84.77 1.16-.7 4.44-3.05 7.86-2.14 3.13-7.12 9.56-7.4 10.83-.28 1.27 1.11 6.36 1.53 8.33.42 1.97 1.74 6.71 1.17 8.54s-3.43 6.85-10.75 6.76c-5.82-.07-7.51-1.78-7.7-2.82-.14-.75-.56-3.24-.56-3.24s-4.79 2.96-7.04 4.08-8.31 4.22-8.31 4.22 1.17 5.35 1.36 7.51c.19 2.16.86 5.25-.28 7.32-1.03 1.88-4.25 5.02-11.83 4.97-5.92-.04-7.41-1.88-8.35-3-.94-1.13-1.13-6.48-1.13-7.6s-.19-5.07-.19-5.07-8.02-.4-12.86-.75c-4.38-.32-10.16-.99-10.16-.99s.21 2.33.42 4.01c.19 1.5.23 4.64-1.34 6.17-2.11 2.06-7.56 2.21-10.56 1.92-3-.28-7.18-1.83-8.4-4.55-1.22-2.72.38-6.29 1.03-8.35.58-1.81 1.6-4.41 1.22-5.16-.38-.75-4.04-1.69-9.29-6.95-5.26-5.26-12.13-23.52 3.28-36.23 15.49-12.76 43.81 1.1 45.31 2.04 1.54.96 53.04 3.76 53.04 3.76z" fill="#bdcf47"/><path d="M66.25 25.28c-13.93.62-24.38 7.52-29.57 15.06-3.1 4.5-4.65 7.74-4.65 7.74s4.81.14 9.15 2.46c5 2.67 10.8 5.56 14.61 18.13 2.87 9.5 3.98 18.53 11.44 20.52 8.45 2.25 28.16 1.13 37.59-8.02s11.26-16.05 8.87-25.06-13.17-25.05-28.16-29.28C79.06 25 72.58 25 66.25 25.28z" fill="#6e823a"/><path d="M111.93 51.32c-.42-.99-1.3-2.5-1.3-2.5s-.07 2.05-.25 3.13c-.28 1.76-1.25 5.42-1.81 4.88-1-.97-5.73-6.92-7.98-10.23-1.71-2.52-7.6-9.11-7.74-11.26-.07-1.06 1.27-4.65 1.27-4.65s-1.22-.7-2.35-1.34c-.88-.49-2.16-1.03-2.16-1.03s-.77 4.9-1.62 5.82c-.75.81-5.32 2.6-8.87 3.94-4.29 1.62-8.45 3.73-10 4.01-1.36.25-9.09-1.41-12-1.97-3.66-.7-9.18-2.26-10.45-3.17-1.48-1.06-3.07-3.78-3.07-3.78s-.89.61-1.78 1.31c-.88.69-2.02 2.06-2.02 2.06s2.31 2.32 2.44 3.18c.18 1.2-1.27 2.83-2.46 4.38-.72.93-2.75 4.85-2.75 4.85s.97.09 2.15.63c1.23.57 2.38 1.16 2.38 1.16s2.97-6.9 4.9-7.53c1.65-.54 6.3.99 9.68 1.69 4.79.99 9.64 1.87 10.66 3.17 1.06 1.34 2.06 6.68 3.03 11.19C70.89 64.2 73.64 77.02 73 78c-.63.99-5.7.63-8.59.28-2.45-.3-6.41-1.76-6.41-1.76s.58 2.11.77 2.67c.28.81 1.16 3.06 1.16 3.06s5.67 2.5 22.42.95 25.03-12.96 27.38-18.02c3.14-6.78 3.54-10.39 3.54-10.39s-.92-2.48-1.34-3.47zM96.65 73.21c-4.24 2.67-15.2 5.49-17.18 4.43-1.58-.85-3.94-13.94-5.07-19.78-.72-3.74-2.45-9.42-1.41-11.19.7-1.2 4.79-2.99 7.81-4.4 2.87-1.33 6.97-3.13 8.17-2.99 1.7.2 5.35 6.12 9.01 11.19 3.66 5.07 7.67 10.35 7.74 12.18.09 1.84-4.7 7.82-9.07 10.56z" fill="#484e23"/><path d="M41.18 65.86c.5 2.83-.95 5.75-4.07 6.02-2.56.22-4.59-1.57-5.09-4.4s1.14-5.49 3.68-5.94c2.52-.45 4.98 1.48 5.48 4.32zm-18.36.25c.07 2.84-2.42 5.69-5.5 5.11-2.53-.48-3.99-2.73-3.71-5.55.29-2.82 2.59-4.9 5.15-4.65s3.99 2.13 4.06 5.09zm7.95 10.48c1.16-.79 3.1-2.67 4.36-1.06 1.27 1.62-.92 3.1-2.18 4.01-1.27.92-4.08 3.17-6.12 3.17-1.9 0-4.79-2.32-6.62-3.87-1.49-1.26-2.18-2.89-1.34-3.87s2.14-.62 3.24.35c1.27 1.13 3.72 3.38 4.72 3.38.98.01 2.39-1.05 3.94-2.11z" fill="#2a2b28"/></svg>',
    100, 100);
local r89_138 = 0;
function r46_138.visuals.slow_down_indicator(r0_172, r1_172)
    if r10_138(r45_138.visuals.slow_down_indicator) and (entity.is_alive(r28_138()) or (not r87_0.is_menu_open())) and entity.is_alive(r28_138()) then
        local r2_172 = { r10_138(r45_138.visuals.slow_down_indicator_color) };
        local r3_172 = math.floor(r13_138(r28_138(), "m_flVelocityModifier") * 100);
        if (r3_172 < 100) and (0 < r3_172) then
            local r4_172 = (r3_172 * r10_138(r45_138.extras.length1)) / 100;
            if r10_138(r45_138.extras.icon1) then
                local r5_172 = r10_138(r45_138.extras.text1) and 16;
                if not r5_172 then
                    r5_172 = 0;
                end
                r89_138 = r56_138(r89_138, (r0_172 / 2) - 12.5, globals.frametime() * 10);
                r22_138(r88_138, r89_138, (r49_138.slow_y - 30) - r5_172, 25, 25, 255, 255, 255, 255, "f");
            end
            if r10_138(r45_138.extras.text1) then
                r15_138(r49_138.slow_x, r49_138.slow_y - 12, 255, 255, 255, 255, "c", 0, (100 - r3_172) .. "%");
            end
            r16_138((r49_138.slow_x - (r10_138(r45_138.extras.length1) / 2)) - 1, r49_138.slow_y - 4,
                r10_138(r45_138.extras.length1) + 2, r10_138(r45_138.extras.width1) + 4, 0, 0, 0, 130);
            local r5_172 = r10_138(r45_138.extras.dynamic);
            if r5_172 then
                r5_172 = { (255 - (r3_172 * 2)), (2.55 * r3_172), 0, r2_172[4] };
            end
            if not r5_172 then
                r5_172 = { r10_138(r45_138.visuals.slow_down_indicator_color) };
            end
            if r10_138(r45_138.extras.gradient1) then
                r20_138((r49_138.slow_x - (r10_138(r45_138.extras.length1) / 2)) + 1, r49_138.slow_y - 2, r4_172,
                    r10_138(r45_138.extras.width1), r5_172[1], r5_172[2], r5_172[3], r5_172[4], 12, 12, 12, 130, true);
            else
                r16_138((r49_138.slow_x - (r10_138(r45_138.extras.length1) / 2)) + 1, r49_138.slow_y - 2, r4_172,
                    r10_138(r45_138.extras.width1), r5_172[1], r5_172[2], r5_172[3], 255);
            end
            return;
        end
        r89_138 = (r0_172 / 2) - 110;
        return;
    end
    return;
end

function r46_138.visuals.slow_open(r0_173, r1_173)
    if r87_0.is_menu_open() and r10_138(r45_138.visuals.slow_down_indicator) then
        local r2_173, r3_173 = r87_0.mouse_position();
        if r49_138.is_dragging and (not r88_0.key_state(1)) then
            r49_138.is_dragging = false;
        end
        if r49_138.is_dragging and r88_0.key_state(1) and (r49_138.last_item == "Slow") then
            r49_138.slow_x = r2_173 - r49_138.drag_slow_x;
            r49_138.slow_y = r3_173 - r49_138.drag_slow_y;
        end
        if r58_138(r49_138.slow_x - (r10_138(r45_138.extras.length) / 2), r49_138.slow_y - 10, r10_138(r45_138.extras.length), 20) and r88_0.key_state(1) then
            r49_138.last_item = "Slow";
            r49_138.is_dragging = true;
            r49_138.drag_slow_x = r2_173 - r49_138.slow_x;
            r49_138.drag_slow_y = r3_173 - r49_138.slow_y;
            r49_138.slow_menu = false;
            r77_138 = false;
        end
        if r58_138(r49_138.slow_x - (r10_138(r45_138.extras.length) / 2), r49_138.slow_y - 10, r10_138(r45_138.extras.length), 20) and r88_0.key_state(2) then
            r49_138.slow_menu = true;
            r49_138.defensive_menu = false;
            r77_138 = false;
        end
        if r10_138(r45_138.extras.icon1) then
            local r4_173 = r10_138(r45_138.extras.text1) and 16;
            if not r4_173 then
                r4_173 = 0;
            end
            r22_138(r88_138, r49_138.slow_x - 12.5, (r49_138.slow_y - 30) - r4_173, 25, 25, 255, 255, 255, 255, "f");
        end
        if r10_138(r45_138.extras.text1) then
            r15_138(r49_138.slow_x, r49_138.slow_y - 12, 255, 255, 255, 255, "c", 0, "100%");
        end
        r16_138((r49_138.slow_x - (r10_138(r45_138.extras.length1) / 2)) - 1, r49_138.slow_y - 4,
            r10_138(r45_138.extras.length1) + 2, r10_138(r45_138.extras.width1) + 4, 0, 0, 0, 150);
        local r4_173 = { r10_138(r45_138.visuals.slow_down_indicator_color) };
        if r10_138(r45_138.extras.gradient1) then
            r20_138((r49_138.slow_x - (r10_138(r45_138.extras.length1) / 2)) + 1, r49_138.slow_y - 2,
                r10_138(r45_138.extras.length1) - 2, r10_138(r45_138.extras.width1), r4_173[1], r4_173[2], r4_173[3],
                r4_173[4], 12, 12, 12, 130, true);
        else
            r16_138((r49_138.slow_x - (r10_138(r45_138.extras.length1) / 2)) + 1, r49_138.slow_y - 2,
                r10_138(r45_138.extras.length1) - 2, r10_138(r45_138.extras.width1), r4_173[1], r4_173[2], r4_173[3], 255);
        end
    else
        r49_138.slow_menu = false;
    end
    if (r49_138.slow_x ~= (r0_173 / 2)) and (not r49_138.is_dragging) then
        r49_138.slow_x = r56_138(r49_138.slow_x, r0_173 / 2, globals.frametime() * 10);
    end
end

function r46_138.visuals.side_slow_menu(r0_174, r1_174)
    if r87_0.is_menu_open() and r49_138.slow_menu and r10_138(r45_138.visuals.slow_down_indicator) then
        if r58_138(r49_138.slow_x + 85, r49_138.slow_y - 50, 82, 100) then
            r77_138 = false;
        end
        r55_138(r49_138.slow_x + 90, r49_138.slow_y - 50, 70, 90, 24, 24, 24, 100, 5);
        r90_0.gradient(r49_138.slow_x + 90, r49_138.slow_y - 40, 35, 1, 24, 24, 24, 0, 255, 255, 255, 255, true);
        r90_0.gradient(r49_138.slow_x + 90 + 35, r49_138.slow_y - 40, 35, 1, 255, 255, 255, 255, 24, 24, 24, 0, true);
        r90_0.text(r49_138.slow_x + 90 + 33, r49_138.slow_y - 47, 255, 255, 255, 255, "-c", 0, "SETTINGS");
        r82_138("Text", r45_138.extras.text1, r49_138.slow_x + 90, r49_138.slow_y + 3);
        r82_138("Turtle", r45_138.extras.icon1, r49_138.slow_x + 90, r49_138.slow_y + 3);
        r82_138("Gradient", r45_138.extras.gradient1, r49_138.slow_x + 90, r49_138.slow_y + 3);
        r82_138("Dynamic", r45_138.extras.dynamic, r49_138.slow_x + 90, r49_138.slow_y + 3);
        r86_138("length", r45_138.extras.length1, 20, 150, "º", r49_138.slow_x + 90, r49_138.slow_y + 3);
        r86_138("width", r45_138.extras.width1, 1, 15, "º", r49_138.slow_x + 90, r49_138.slow_y + 3);
    end
end

function r46_138.visuals.minimum_damage_indicator(r0_175, r1_175)
    if r10_138(r45_138.visuals.minimum_damage_indicator) and entity.is_alive(r28_138()) then
        local r2_175 = r10_138(r51_138.min_dmg_override[1]) and r10_138(r51_138.min_dmg_override[2]);
        local r3_175 = r15_138;
        local r4_175 = (r0_175 / 2) + 12;
        local r5_175 = (r1_175 / 2) - 12;
        local r6_175 = 255;
        local r7_175 = 255;
        local r8_175 = 255;
        local r9_175 = 255;
        local r10_175 = "c";
        local r11_175 = 0;
        local r12_175 = r2_175 and r10_138(r51_138.min_dmg_override[3]);
        if not r12_175 then
            r12_175 = r10_138(r51_138.minimum_damage);
        end
        r3_175(r4_175, r5_175, r6_175, r7_175, r8_175, r9_175, r10_175, r11_175, r12_175);
        return;
    end
    return;
end

local r90_138 = {};
local r91_138 = r90_0.load_svg(
'<svg width="800" height="800" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M7 0 2 12h8L6 22 20 8h-9l6-8z" fill="#fff"/><path fill="gray" d="M7 0 2 12h3l5-12zm3 12L6 22l3-3 4-7z"/><path fill="gray" d="m10 12-.406 1H12.5l.5-1h-3z"/></svg>',
    30, 30);
function r46_138.visuals.zeus_indicator()
    r90_138 = {};
    if r28_138() == nil then
        return;
    end
    local r0_176 = r41_138(r26_138(r28_138()));
    local r1_176 = entity.get_players(true);
    for r5_176 = 1, #r1_176, 1 do
        local r6_176 = r1_176[r5_176];
        if r6_176 == r28_138() then
            break;
        else
            local r7_176 = { r89_0.get_bounding_box(r6_176) };
            local r8_176 = false;
            for r12_176 = 0, 64, 1 do
                local r13_176 = r13_138(r6_176, "m_hMyWeapons", r12_176);
                if r13_176 ~= nil then
                    local r14_176 = r25_138(r13_176);
                    if (r14_176 ~= nil) and (r14_176 == "CWeaponTaser") then
                        r8_176 = true;
                        table.insert(r90_138, r6_176);
                    end
                end
            end
            local r9_176 = r41_138(r26_138(r6_176));
            if r8_176 and (r25_138(r89_0.get_player_weapon(r6_176)) ~= "CWeaponTaser") and (r7_176[1] ~= nil) and (r7_176[2] ~= nil) and r57_138(r10_138(r45_138.visuals.zeus_esp), "Indicator") and r57_138(r10_138(r45_138.visuals.player_esp), "Zeus esp") and (r0_176:dist(r9_176) < 500) then
                r22_138(r91_138, r7_176[1] - 20, r7_176[2], 15, 15, 255, 167, 0, 255, "f");
            elseif r8_176 and (r25_138(r89_0.get_player_weapon(r6_176)) == "CWeaponTaser") and (r7_176[1] ~= nil) and (r7_176[2] ~= nil) and r57_138(r10_138(r45_138.visuals.zeus_esp), "Indicator") and r57_138(r10_138(r45_138.visuals.player_esp), "Zeus esp") and (r0_176:dist(r9_176) < 500) then
                r22_138(r91_138, r7_176[1] - 20, r7_176[2] - 40, 15, 15, 255, 0, 50, 255, "f");
            elseif (not r8_176) and (r90_138[r5_176] == r6_176) then
                table.remove(r90_138, r6_176);
            end
        end
    end
end

local function r92_138(r0_177, r1_177, r2_177, r3_177)
    local r4_177 = math.sin(r0_177);
    local r5_177 = math.cos(r0_177);
    r3_177.y = r3_177.y - r1_177.y;
    r3_177.x = r3_177.x - r1_177.x;
    r2_177.y = r2_177.y - r1_177.y;
    r2_177.x = r2_177.x - r1_177.x;
    return ((r2_177.x * r5_177) - (r2_177.y * r4_177)) + r1_177.x, (r2_177.x * r4_177) + (r2_177.y * r5_177) + r1_177.y,
        ((r3_177.x * r5_177) - (r3_177.y * r4_177)) + r1_177.x, (r3_177.x * r4_177) + (r3_177.y * r5_177) + r1_177.y;
end
function r46_138.visuals.zeus_out_of_view()
    if r57_138(r10_138(r45_138.visuals.zeus_esp), "Out of view") and r57_138(r10_138(r45_138.visuals.player_esp), "Zeus esp") then
        local r0_178 = r41_138(r26_138(r28_138()));
        local r1_178 = r41_138(r88_0.camera_angles());
        if r1_178 == nil then
            return;
        end
        local r2_178, r3_178 = r88_0.screen_size();
        local r4_178 = 15;
        local r5_178 = 160 + r4_178;
        for r9_178, r10_178 in ipairs(r90_138) do
            local r11_178 = r41_138(r26_138(r10_178));
            local r12_178 = math.min(800, r0_178:dist(r11_178)) / 800;
            if not entity.is_alive(r10_178) then
                table.remove(r90_138, r9_178);
                break;
            else
                local r13_178 = { r90_0.world_to_screen(r11_178:unpack()) };
                if r13_178[1] and r13_178[2] and (0 < r13_178[1]) and (0 < r13_178[2]) and (r13_178[1] < r2_178) and (r13_178[2] < r3_178) then
                    break;
                else
                    local r14_178, r15_178 = r0_178:to(r11_178):angles();
                    if not r15_178 then
                        break;
                    else
                        r15_178 = (270 - r15_178) + r1_178.y;
                        local r16_178 = math.rad(r15_178);
                        local r17_178 = r41_138((r2_178 / 2) + (math.cos(r16_178) * r5_178),
                            (r3_178 / 2) + (math.sin(r16_178) * r5_178), 0);
                        local r20_178 = { r92_138(math.rad(r15_178 - 90), r17_178,
                            r41_138(r17_178.x - (r4_178 / 2), r17_178.y - r4_178, 0),
                            r41_138(r17_178.x + (r4_178 / 2), r17_178.y - r4_178, 0)) };
                        local r21_178 = { r = 255, g = 50, b = 50 };
                        if r25_138(r89_0.get_player_weapon(r10_178)) == "CWeaponTaser" then
                            r21_178 = { r = 255, g = 50, b = 50 };
                        else
                            r21_178 = { r = 255, g = 167, b = 0 };
                        end
                        r22_138(r91_138, r17_178.x, r17_178.y, 30, 30, r21_178.r, r21_178.g, r21_178.b, 255, "f");
                    end
                end
            end
        end
    end
end

client.register_esp_flag("target", 255, 255, 255, function(r0_179)
    if (r0_179 == r88_0.current_threat()) and r57_138(r10_138(r45_138.visuals.player_esp), "At target flag") then
        return true, string.format("\a%02x%02x%02x%02xTARGET", r10_138(r45_138.visuals.target_color));
    end
end);
client.register_esp_flag("zeus", 255, 255, 255, function(r0_180)
    if r57_138(r10_138(r45_138.visuals.zeus_esp), "Flag") and r57_138(r10_138(r45_138.visuals.player_esp), "Zeus esp") then
        for r4_180 = 1, #r90_138, 1 do
            if r90_138[r4_180] == r28_138() then
                break;
            elseif r0_180 == r90_138[r4_180] then
                return true, string.format("\a%02x%02x%02x%02xZEUS", r10_138(r45_138.visuals.zeus_indicator_color));
            end
        end
    end
end);
local r93_138 = r90_0.load_svg(
'<svg fill="#fff" height="800" width="800" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" xml:space="preserve"><path d="M0 226v32c128 192 384 192 512 0v-32C384 34 128 34 0 226zm256 144c-70.7 0-128-57.3-128-128s57.3-128 128-128 128 57.3 128 128-57.3 128-128 128zm0-200c0-8.3 1.7-16.1 4.3-23.6-1.5-.1-2.8-.4-4.3-.4-53 0-96 43-96 96s43 96 96 96 96-43 96-96c0-1.5-.4-2.8-.4-4.3-7.4 2.6-15.3 4.3-23.6 4.3-39.8 0-72-32.2-72-72z" fill="white" /></svg>',
    50, 50);
function r46_138.misc.local_animations()
    if not entity.is_alive(r28_138()) then
        r46_138.misc.end_time = 0;
        r46_138.misc.ground_ticks = 0;
        return;
    end
    if r57_138(r10_138(r45_138.misc.local_animations), "Pitch 0 on land") then
        if r1_0.band(r13_138(r28_138(), "m_fFlags"), 1) == 1 then
            r46_138.misc.ground_ticks = r46_138.misc.ground_ticks + 1;
        else
            r46_138.misc.ground_ticks = 0;
            r46_138.misc.end_time = globals.curtime() + 1;
        end
        if (5 < r46_138.misc.ground_ticks) and (globals.curtime() < (r46_138.misc.end_time + 0.5)) then
            r89_0.set_prop(r28_138(), "m_flPoseParameter", 0.5, 12);
        end
    end
    if r57_138(r10_138(r45_138.misc.local_animations), "Jitter legs") then
        local r0_181 = math.random(1, 2);
        local r1_181 = r11_138;
        local r2_181 = r51_138.leg_movement;
        local r3_181 = r0_181 == 1;
        if r3_181 then
            r3_181 = "Always slide";
        end
        if not r3_181 then
            r3_181 = "Never slide";
        end
        r1_181(r2_181, r3_181);
        r89_0.set_prop(r28_138(), "m_flPoseParameter", 8, 0);
    end
    if r57_138(r10_138(r45_138.misc.local_animations), "Static legs in air") then
        r89_0.set_prop(r28_138(), "m_flPoseParameter", 1, 6);
    end
    if r57_138(r10_138(r45_138.misc.local_animations), "Crossing legs") then
        local r0_181 = r35_138.get_local_player();
        if not (r1_0.band(r0_181:get_prop("m_fFlags"), 1) ~= 0) then
            r0_181:get_anim_overlay(6).weight = 1;
        else
            r11_138(r51_138.leg_movement, "Off");
            r89_0.set_prop(r28_138(), "m_flPoseParameter", 0, 7);
        end
    end
    if r57_138(r10_138(r45_138.misc.local_animations), "Flashed") then
        local r1_181 = r35_138.get_local_player():get_anim_overlay(9);
        r1_181.weight = 1;
        r1_181.sequence = 224;
    end
    if r57_138(r10_138(r45_138.misc.local_animations), "Victim") then
        r35_138.get_local_player():get_anim_overlay(0).sequence = 11;
    end
end

function r46_138.misc.fast_ladder(r0_182)
    if not r10_138(r45_138.misc.fast_ladder_box) then
        return;
    end
    local r1_182 = entity.get_local_player();
    local r2_182, r3_182 = r88_0.camera_angles();
    if entity.get_prop(r1_182, "m_MoveType") == 9 then
        r0_182.yaw = math.floor(r0_182.yaw + 0.5);
        r0_182.roll = 0;
        if r0_182.forwardmove == 0 then
            r0_182.pitch = 89;
            r0_182.yaw = r0_182.yaw + r10_138(r45_138.misc.ladder_yaw_slider);
            if (0 < math.abs(r10_138(r45_138.misc.ladder_yaw_slider))) and (math.abs(r10_138(r45_138.misc.ladder_yaw_slider)) < 180) and (r0_182.sidemove ~= 0) then
                r0_182.yaw = r0_182.yaw - r10_138(r45_138.misc.ladder_yaw_slider);
            end
            if math.abs(r10_138(r45_138.misc.ladder_yaw_slider)) == 180 then
                if r0_182.sidemove < 0 then
                    r0_182.in_moveleft = 0;
                    r0_182.in_moveright = 1;
                end
                if r0_182.sidemove > 0 then
                    r0_182.in_moveleft = 1;
                    r0_182.in_moveright = 0;
                end
            end
        end
        if (0 < r0_182.forwardmove) and (r2_182 < 45) then
            r0_182.pitch = 89;
            r0_182.in_moveright = 1;
            r0_182.in_moveleft = 0;
            r0_182.in_forward = 0;
            r0_182.in_back = 1;
            if r0_182.sidemove == 0 then
                r0_182.yaw = r0_182.yaw + 90;
            end
            if r0_182.sidemove < 0 then
                r0_182.yaw = r0_182.yaw + 150;
            end
            if r0_182.sidemove > 0 then
                r0_182.yaw = r0_182.yaw + 30;
            end
        end
        if r0_182.forwardmove < 0 then
            r0_182.pitch = 89;
            r0_182.in_moveleft = 1;
            r0_182.in_moveright = 0;
            r0_182.in_forward = 1;
            r0_182.in_back = 0;
            if r0_182.sidemove == 0 then
                r0_182.yaw = r0_182.yaw + 90;
            end
            if r0_182.sidemove > 0 then
                r0_182.yaw = r0_182.yaw + 150;
            end
            if r0_182.sidemove < 0 then
                r0_182.yaw = r0_182.yaw + 30;
            end
        end
    end
end

local r94_138 = {};
local r95_138 = 0;
local r96_138 = 0;
local r97_138 = 0;
r14_138("aim_fire", function(r0_183)
    r96_138 = r27_138() - r0_183.tick;
    r95_138 = r0_183.hit_chance;
    predicted_damage = r0_183.damage;
end);
local r98_138 = {};
local r99_138 = {};
local r100_138 = { "generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?",
    "gear" };
r14_138("aim_miss", function(r0_184)
    if (0 < #r10_138(r45_138.misc.safe_point)) and (r0_184 ~= nil) then
        r98_138[#r98_138 + 1] = { nigga = r0_184.target, hp = entity.get_prop(r0_184.target, "m_iHealth") };
    end
    if r0_184.reason == "?" then
        r0_184.reason = "unknown";
    end
    if r10_138(r45_138.misc.aim_logs) then
        local r1_184 = string.format("\a%02X%02X%02XFF", r10_138(r45_138.misc.aim_logs_miss_color));
        local r2_184, r3_184 = r88_0.screen_size();
        r94_138[#r94_138 + 1] = { bullet_tick = (r27_138() * globals.tickinterval()), start_position = ((r3_184 / 2) + 100), text =
        string.format(
        "Missed " .. r1_184 .. "%s\affffffff in the " .. r1_184 .. "%s\affffffff due to " .. r1_184 .. "%s\affffffff.",
            r89_0.get_player_name(r0_184.target), r100_138[r0_184.hitgroup + 1], r0_184.reason) };
    end
    if r57_138(r10_138(r45_138.misc.old_logs), "aim_miss") then
        r88_0.log(string.format("Missed %s in the %s due to %s.", r89_0.get_player_name(r0_184.target),
            r100_138[r0_184.hitgroup + 1], r0_184.reason));
        local r1_184 = "\aF85454FF";
        r99_138[#r99_138 + 1] = { text = string.format("Missed %s in the %s due to %s.",
            r89_0.get_player_name(r0_184.target), r100_138[r0_184.hitgroup + 1], r0_184.reason), current_time = r27_138() };
    end
end);
r14_138("aim_hit", function(r0_185)
    if r10_138(r45_138.misc.aim_logs) then
        local r1_185, r2_185 = r88_0.screen_size();
        local r3_185 = "\a96E631FF";
        r94_138[#r94_138 + 1] = { bullet_tick = (r27_138() * globals.tickinterval()), start_position = ((r2_185 / 2) + 100), text =
        string.format(
        "Hit " .. r3_185 .. "%s\affffffff in the " .. r3_185 .. "%s\affffffff for " .. r3_185 .. "%s\affffffff.",
            r89_0.get_player_name(r0_185.target), r100_138[r0_185.hitgroup + 1], r0_185.damage) };
    end
    if r57_138(r10_138(r45_138.misc.old_logs), "aim_hit") then
        local r1_185 = string.format("\a%02X%02X%02XFF", r10_138(r45_138.misc.aim_logs_hit_color));
        r88_0.log(string.format("Hit %s in the %s for %s.", r89_0.get_player_name(r0_185.target),
            r100_138[r0_185.hitgroup + 1], r0_185.damage));
        r99_138[#r99_138 + 1] = { text = string.format("Hit %s in the %s for %s.", r89_0.get_player_name(r0_185.target),
            r100_138[r0_185.hitgroup + 1], r0_185.damage), current_time = r27_138() };
    end
end);
r14_138("item_purchase", function(r0_186)
    if r57_138(r10_138(r45_138.misc.old_logs), "item_purchase") and (r0_186.weapon ~= "weapon_unknown") then
        if r88_0.userid_to_entindex(r0_186.userid) == r28_138() then
            return;
        end
        local r1_186, r2_186 = string.find(r0_186.weapon, "weapon_");
        local r3_186, r4_186 = string.find(r0_186.weapon, "item_");
        local r5_186 = string.sub;
        local r6_186 = r0_186.weapon;
        local r7_186 = r2_186 == nil;
        if r7_186 then
            r7_186 = r4_186 + 1;
        end
        if not r7_186 then
            r7_186 = r2_186 + 1;
        end
        r0_186.weapon = r5_186(r6_186, r7_186, #r0_186.weapon);
        r99_138[#r99_138 + 1] = { text = string.format("%s purchased %s",
            r89_0.get_player_name(r88_0.userid_to_entindex(r0_186.userid)), r0_186.weapon), current_time = r27_138() };
        return;
    end
    return;
end);
local r101_138 = {
    three = {},
    render_logs = function(r0_187, r1_187)
        r0_187.three[#r0_187.three + 1] = { render_text = r1_187 };
        r15_138(5, ((#r0_187.three * 12) - 12) + 7, 220, 220, 220, 255, "", 0, r1_187);
    end
};
function r46_138.visuals.old_logs(r0_188, r1_188)
    for r5_188 = 1, #r99_138, 1 do
        r101_138:render_logs(r99_138[r5_188].text, r99_138[r5_188].current_time);
        if (r1_188 / 2) < (#r101_138.three * 12) then
            table.remove(r99_138, 1);
            break;
        elseif ((r99_138[r5_188].current_time * globals.tickinterval()) + 8) < (r27_138() * globals.tickinterval()) then
            table.remove(r99_138, r5_188);
            break;
        end
    end
end

local r103_138 = r90_0.load_svg(
'<svg width="800" height="800" viewBox="0 0 36 36" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" class="iconify iconify--twemoji" transform="scale(-1 1)"><path fill="#FFAC33" d="M16.61 17.589h5.278v1.056H16.61z"/><path fill="#FFAC33" d="M15.555 15.478a.526.526 0 0 0-.373.901c.845.844.845 2.631 0 3.476a.528.528 0 0 0 .746.746c1.254-1.253 1.254-3.715 0-4.968a.526.526 0 0 0-.373-.155z"/><path fill="#77B255" d="M23.888 23.486h-8.575c-1.873 0-3.261-.974-3.809-2.671l-2.405-6.601 2.114-.771 2.419 6.641c.255.788.8 1.151 1.681 1.151h8.575v2.251z"/><path fill="#3E721D" d="m35.205 11.222-1.962.609-1.306-4.21 1.962-.609a1.115 1.115 0 0 1 1.392.733l.647 2.084a1.116 1.116 0 0 1-.733 1.393z"/><path fill="#E95F28" d="M1.687 6.947h1.761v5.024H1.686c-.87 0-1.582-.712-1.582-1.582v-1.86c0-.87.712-1.582 1.583-1.582z"/><path fill="#3E721D" d="M6.694 4.89c0 .923.748 1.671 1.671 1.671s2.727-.748 2.727-1.671-1.804-1.671-2.727-1.671-1.671.748-1.671 1.671z"/><path fill="#5C913B" d="M4.869 12.905c0 1.166.945 2.111 2.659 2.111H22v-2.111H4.869z"/><path fill="#77B255" d="M35.279 29.382s-1.975-6.154-2.731-8.768-1.006-4.614 1.077-6.147c1.135-.835 1.431-1.844 1.204-2.899-.377-1.752-1.284-4.076-1.72-4.925-.189-.369-.486-.758-1.073-.928 0 0-3.915-1.737-15.24-1.737-6.333 0-14.215.957-14.215 3.265v3.612c0 1.23.997 2.227 2.227 2.227H18.51c.727 0 1.37.473 1.587 1.168l4.352 13.79v.001c.429 1.402-.915 1.633-.915 2.787a1.3 1.3 0 0 0 1.297 1.297h8.433a2.112 2.112 0 0 0 2.015-2.743z"/><path fill="#A6D388" d="M27.499 21.008a1 1 0 0 1-.967-.749c-1.357-5.237-4.091-8.438-8.354-9.786-6.075-1.921-13.393-.323-13.466-.308a1 1 0 0 1-.438-1.952c.32-.072 7.909-1.733 14.506.352 4.905 1.55 8.165 5.316 9.688 11.191a1 1 0 0 1-.969 1.252z"/><circle fill="#F5F8FA" cx="29.185" cy="10.67" r="3.305"/><circle fill="#FFCC4D" cx="29.185" cy="10.67" r="2.292"/></svg>',
    25, 25);
function r46_138.visuals.aim_logs(r0_189, r1_189)
    if not r10_138(r45_138.misc.aim_logs) then
        if #r94_138 > 0 then
            r94_138 = {};
        end
        return;
    end
    for r5_189 = 1, #r94_138, 1 do
        if r94_138[r5_189] == nil then
            break;
        else
            local r6_189 = r94_138[r5_189];
            r6_189.start_position = r56_138(r6_189.start_position, (r1_189 / 2) + 100 + (r5_189 * 30),
                globals.frametime() * 15);
            r54_138(((r0_189 / 2) - (r21_138("c", r6_189.text) / 2)) - 5, r6_189.start_position - 10,
                r21_138("c", r6_189.text) + 10, 18, 24, 24, 24, 255, 1, 10);
            r15_138(r0_189 / 2, r6_189.start_position - 2, 255, 255, 255, 255, "c", 0, r6_189.text);
            if r10_138(r45_138.misc.aim_logo) then
                r54_138((((r0_189 / 2) - (r21_138("c", r6_189.text) / 2)) - 24) - r10_138(r45_138.misc.logo_slider),
                    r6_189.start_position - 10, 21, 18, 24, 24, 24, 255, 1, 10);
                r22_138(r103_138,
                    (((r0_189 / 2) - (r21_138("c", r6_189.text) / 2)) - 20) - r10_138(r45_138.misc.logo_slider),
                    r6_189.start_position - 9, 15, 15, 255, 255, 255, 255, "f");
            end
            local r9_189 = ((r6_189.bullet_tick + 5) - (r27_138() * globals.tickinterval())) / 5;
            if (r1_189 - 100) < ((r1_189 / 2) + 200 + (r5_189 * 30)) then
                table.remove(r94_138, 1);
                break;
            elseif (r6_189.bullet_tick + 5) < (r27_138() * globals.tickinterval()) then
                table.remove(r94_138, r5_189);
                break;
            end
        end
    end
end

function r46_138.visuals.watermark(r0_190, r1_190)
    if not r10_138(r45_138.visuals.ot_watermark) then
        return;
    end
    local r3_190 = string.format("%s | ping %s ms", r40_138.username, math.floor(math.min(1000, r88_0.latency() * 1000)));
    r54_138((r0_190 - r90_0.measure_text("c", r3_190)) - 12, 10, r90_0.measure_text("c", r3_190) + 8, 17, 24, 24, 24, 255,
        1, 10);
    r15_138((r0_190 - (r90_0.measure_text("c", r3_190) / 2)) - 8, 17, 255, 255, 255, 255, "c", 0, r3_190);
    if r10_138(r45_138.visuals.watermark_logo) then
        r54_138(((r0_190 - r90_0.measure_text("c", r3_190)) - 48) - r10_138(r45_138.visuals.watermark_spacing), 10, 40,
            17, 24, 24, 24, 255, 1, 10);
        r15_138(((r0_190 - r90_0.measure_text("c", r3_190)) - 28) - r10_138(r45_138.visuals.watermark_spacing), 17, 255,
            255, 255, 255, "cb", 0, "\a80CC23ffV\affffffffenus");
    end
end

local function r104_138(r0_191, r1_191, r2_191)
    if r0_191 < r1_191 then
        return r1_191;
    end
    if r2_191 < r0_191 then
        return r2_191;
    end
    return r0_191;
end
local function r105_138(r0_192, r1_192, r2_192, r3_192)
    return string.format("%02x%02x%02x%02x", r0_192, r1_192, r2_192, r3_192);
end
local function r106_138(r0_193, r1_193, r2_193, r3_193, r4_193, r5_193)
    local r6_193 = "";
    local r7_193 = globals.curtime();
    for r11_193 = 0, #r5_193, 1 do
        local r13_193 = math.cos(((2 * r2_193 * r7_193) / 4) + ((r11_193 * 10) / 50));
        r6_193 = r6_193 ..
        "\a" ..
        r105_138(r56_138(r3_193.r, r4_193.r, r104_138(r13_193, 0, 1)),
            r56_138(r3_193.g, r4_193.g, r104_138(r13_193, 0, 1)), r56_138(r3_193.b, r4_193.b, r104_138(r13_193, 0, 1)),
            r3_193.a) .. r5_193:sub(r11_193, r11_193);
    end
    r15_138(r0_193, r1_193, r3_193.r, r3_193.g, r3_193.b, r3_193.a, nil, nil, r6_193);
end
function r46_138.misc.sunset()
    local r0_194 = r89_0.get_all("CCascadeLight")[1];
    if r10_138(r45_138.misc.sunset_mode) and (r46_138.misc.sunset_active == false) then
        r46_138.misc.old_sun = r41_138(r13_138(r0_194, "m_envLightShadowDirection"));
        r89_0.set_prop(r0_194, "m_envLightShadowDirection", 0, 0, 0);
        r46_138.misc.sunset_active = true;
    elseif (not r10_138(r45_138.misc.sunset_mode)) and (r46_138.misc.sunset_active == true) then
        r89_0.set_prop(r0_194, "m_envLightShadowDirection", r46_138.misc.old_sun.x, r46_138.misc.old_sun.y,
            r46_138.misc.old_sun.z);
        r46_138.misc.sunset_active = false;
    end
end

local r107_138 = {};
local function r108_138()
    for r3_195, r4_195 in ipairs(entity.get_players(true)) do
        table.insert(r107_138,
            { index = r4_195, old_pos = 0, timeframe = (entity.get_prop(r4_195, "m_flSimulationTime") / globals.tickinterval()), wjitter = false, sjitter = false, loop = 0 });
        local r5_195 = true;
        local r6_195 = 0;
        for r10_195, r11_195 in ipairs(r107_138) do
            if r89_0.get_player_name(r11_195.index) == r89_0.get_player_name(r28_138()) then
                table.remove(r107_138, r10_195);
                break;
            elseif r11_195.index == r4_195 then
                r6_195 = r6_195 + 1;
                r5_195 = false;
                if r6_195 >= 2 then
                    r5_195 = true;
                    table.remove(r107_138, r10_195);
                    break;
                end
            else
                r5_195 = false;
            end
        end
    end
end
client.register_esp_flag("FS", 255, 255, 255, function(r0_196)
    if plist.get(r0_196, "Override safe point") == "On" then
        return "FS";
    end
end);
function r46_138.misc.safe_point()
    if #r87_0.get(r45_138.misc.safe_point) > 0 then
        for r3_197, r4_197 in ipairs(r107_138) do
            local r5_197 = 0;
            local r6_197 = 0;
            if not entity.is_alive(r4_197.index) then
                table.remove(r107_138, r3_197);
                break;
            else
                if r57_138(r87_0.get(r45_138.misc.safe_point), "Default") or r57_138(r87_0.get(r45_138.misc.safe_point), "Lethal") then
                    for r10_197, r11_197 in ipairs(r98_138) do
                        if (r11_197.nigga ~= nil) and (r4_197.index ~= nil) then
                            if r11_197 == nil then
                                table.remove(r98_138, r10_197);
                                break;
                            elseif r11_197.nigga == r28_138() then
                                break;
                            else
                                if r11_197.nigga == r4_197.index then
                                    if (r11_197.hp ~= nil) and (r11_197.hp <= 50) and r57_138(r87_0.get(r45_138.misc.safe_point), "Lethal") then
                                        r6_197 = r6_197 + 1;
                                    end
                                    if r57_138(r87_0.get(r45_138.misc.safe_point), "Default") == true then
                                        r5_197 = r5_197 + 1;
                                    end
                                end
                                if entity.get_prop(r11_197.nigga, "m_iHealth") <= 0 then
                                    table.remove(r98_138, r10_197);
                                    break;
                                end
                            end
                        else
                            table.remove(r98_138, r10_197);
                            break;
                        end
                    end
                end
                local r7_197 = r41_138(entity.get_prop(r4_197.index, "m_angEyeAngles"));
                local r8_197 = math.floor(r7_197.y) - math.floor(r4_197.old_pos);
                if r8_197 == 0 then
                    r4_197.loop = r4_197.loop + 1;
                    if r4_197.loop > 4 then
                        r4_197.wjitter = false;
                        r4_197.sjitter = false;
                        r4_197.loop = 0;
                    end
                else
                    r4_197.loop = 0;
                end
                if r8_197 <= 180 then
                    if r8_197 < -180 then
                        local r9_197 = 0;
                        if r8_197 > 0 then
                            r9_197 = 199 - r8_197;
                        else
                            r9_197 = -199 - r8_197;
                        end
                        if r9_197 <= 80 then
                            if (r9_197 < -80) and (r8_197 ~= 0) then
                                r4_197.sjitter = true;
                            elseif ((r9_197 <= 80) or ((-80 <= r9_197) and (r9_197 <= -1))) and (r8_197 ~= 0) then
                                r4_197.wjitter = true;
                                r4_197.sjitter = false;
                            end
                        else
                            r4_197.sjitter = true;
                        end
                    elseif r8_197 >= 180 then
                        if r8_197 > -180 then
                            if r8_197 < 80 then
                                if r8_197 <= -80 then
                                    r4_197.wjitter = true;
                                    r4_197.sjitter = false;
                                elseif ((r8_197 < 80) or ((-80 < r8_197) and (r8_197 <= -1))) and (r8_197 ~= 0) then
                                    r4_197.sjitter = true;
                                end
                            else
                                r4_197.wjitter = true;
                                r4_197.sjitter = false;
                            end
                        elseif ((r8_197 == 0) and (r4_197.wjitter == true)) or ((r8_197 == 0) and (r4_197.sjitter == true)) then
                            r4_197.wjitter = true;
                            r4_197.sjitter = true;
                        end
                    else
                        if r8_197 < 80 then
                            if r8_197 <= -80 then
                                r4_197.wjitter = true;
                                r4_197.sjitter = false;
                            elseif ((r8_197 < 80) or ((-80 < r8_197) and (r8_197 <= -1))) and (r8_197 ~= 0) then
                                r4_197.sjitter = true;
                            end
                        else
                            r4_197.wjitter = true;
                            r4_197.sjitter = false;
                        end
                    end
                else
                    local r9_197 = 0;
                    if r8_197 > 0 then
                        r9_197 = 199 - r8_197;
                    else
                        r9_197 = -199 - r8_197;
                    end
                    if r9_197 <= 80 then
                        if (r9_197 < -80) and (r8_197 ~= 0) then
                            r4_197.sjitter = true;
                        elseif ((r9_197 <= 80) or ((-80 <= r9_197) and (r9_197 <= -1))) and (r8_197 ~= 0) then
                            r4_197.wjitter = true;
                            r4_197.sjitter = false;
                        end
                    else
                        r4_197.sjitter = true;
                    end
                end
                local r9_197 = false;
                local r10_197 = r41_138(entity.get_prop(r4_197.index, "m_vecVelocity"));
                local r11_197 = r1_0.band(entity.get_prop(r4_197.index, "m_fFlags"), 1) == 1;
                if ((1 <= r6_197) and r57_138(r87_0.get(r45_138.misc.safe_point), "Lethal")) or ((2 <= r5_197) and r57_138(r87_0.get(r45_138.misc.safe_point), "Default")) or ((r10_197:length2d() < 2) and r11_197 and r57_138(r87_0.get(r45_138.misc.safe_point), "Standing")) or ((r4_197.wjitter == true) and ((not r11_197) or ((3 < r10_197:length2d()) and (entity.get_prop(r4_197.index, "m_flDuckAmount") <= 0) and r11_197)) and r57_138(r87_0.get(r45_138.misc.safe_point), "Wide jitter")) or ((r4_197.sjitter == true) and ((not r11_197) or ((3 < r10_197:length2d()) and (entity.get_prop(r4_197.index, "m_flDuckAmount") <= 0) and r11_197)) and r57_138(r87_0.get(r45_138.misc.safe_point), "Small jitter")) then
                    plist.set(r4_197.index, "Override safe point", "On");
                else
                    plist.set(r4_197.index, "Override safe point", "-");
                end
                local r12_197 = entity.get_prop(r4_197.index, "m_flSimulationTime") / globals.tickinterval();
                if r8_197 == 0 then
                end
                if r4_197.timeframe < r12_197 then
                    r4_197.timeframe = r12_197;
                    r4_197.old_pos = r7_197.y;
                end
            end
        end
    end
end

local r109_138 = false;
function r46_138.misc.resolver()
    if r10_138(r45_138.misc.resolver) then
        r109_138 = true;
        for r3_198, r4_198 in ipairs(entity.get_players(true)) do
            local r5_198 = { r89_0.get_bounding_box(r4_198) };
            local r6_198 = r35_138.new(r4_198);
            local r7_198 = math.floor(math.min(60, (r13_138(r4_198, "m_flPoseParameter", 11) * 120) - 60));
            local r8_198 = { r13_138(r4_198, "m_angEyeAngles") };
            local r9_198 = r1_0.band(r13_138(r4_198, "m_fFlags"), 1) == 1;
            if (math.floor(math.max(-60, math.min(60, r8_198[2] - r6_198:get_anim_state().current_feet_yaw))) < (r7_198 + 1)) and ((r7_198 - 1) < math.floor(math.max(-60, math.min(60, r8_198[2] - r6_198:get_anim_state().current_feet_yaw)))) then
                plist.set(r4_198, "Force body yaw", false);
            else
                local r10_198 = math.floor(math.max(-60,
                    math.min(60, r8_198[2] - r6_198:get_anim_state().current_feet_yaw)));
                if r87_0.is_menu_open() then
                    plist.set(r4_198, "Force body yaw", false);
                    plist.set(r4_198, "Force body yaw value", 0);
                elseif r41_138(r13_138(r4_198, "m_vecVelocity")):length2d() < 2 then
                    plist.set(r4_198, "Force body yaw", false);
                else
                    if not r9_198 then
                        r10_198 = r10_198 / 2;
                    elseif r6_198:get_anim_state().duck_amount > 0.5 then
                        r10_198 = r10_198 / 2;
                    elseif r10_198 ~= 60 then
                        if r10_198 == -60 then
                            plist.set(r4_198, "Force body yaw", false);
                        end
                    else
                        plist.set(r4_198, "Force body yaw", false);
                    end
                    plist.set(r4_198, "Force body yaw", true);
                    plist.set(r4_198, "Force body yaw value", r10_198);
                end
            end
        end
    elseif r109_138 == true then
        for r3_198 = 1, globals.maxplayers(), 1 do
            if (r25_138(r3_198) == "CCSPlayer") and (r13_138(r3_198, "m_iTeamNum") ~= r13_138(r28_138(), "m_iTeamNum")) then
                plist.set(r3_198, "Force body yaw", false);
                plist.set(r3_198, "Force body yaw value", 0);
            end
        end
        r109_138 = false;
    end
end

r14_138("player_death", function(r0_199)
    if (r88_0.userid_to_entindex(r0_199.userid) ~= r28_138()) and (r88_0.userid_to_entindex(r0_199.attacker) == r28_138()) and (r10_138(r45_138.misc.kill_say) ~= "Off") then
        r88_0.exec("say " ..
        r46_138.misc.kill_say[r10_138(r45_138.misc.kill_say)]
        [r88_0.random_int(1, #r46_138.misc.kill_say[r10_138(r45_138.misc.kill_say)])]);
    end
end);
local function r110_138(r0_200, r1_200)
    local r2_200 = {};
    for r6_200 in string.gmatch(r0_200, "([^" .. r1_200 .. "]+)") do
        local r7_200 = #r2_200 + 1;
        r2_200[r7_200] = string.gsub(r6_200, "\n", "");
    end
    return r2_200;
end
local function r111_138(r0_201)
    if (r0_201 ~= "true") and (r0_201 ~= "false") then
        return r0_201;
    end
    return r0_201 == "true";
end
r52_138.main = r87_0.new_button(r43_138, r44_138, "- Main -", function()
    r52_138.selected_tab = r52_138.easier_tab.main;
end);
local r112_138 = {};
local r113_138 = { { "remove_search_path", "U\139\236\129\236\204\204\204̋U\bS\139\217", "void(__thiscall*)(void*, const char*, const char*)" }, { "remove_file", "U\139\236\129\236\204\204\204̍\133\204\204\204\204VP\141E\f", "void(__thiscall*)(void*, const char*, const char*)" }, { "find_next", "U\139\236\131\236\fS\139ً\r\204\204\204\204", "const char*(__thiscall*)(void*, int)" }, { "find_is_directory", "U\139\236\15\183E\b", "bool(__thiscall*)(void*, int)" }, { "find_close", "U\139\236S\139]\b\133", "void(__thiscall*)(void*, int)" }, { "find_first", "U\139\236j\0\255u\16\255u\f\255u\b\232\204\204\204\204]", "const char*(__thiscall*)(void*, const char*, const char*, int*)" }, { "get_current_directory", "U\139\236V\139u\bV\255u\f", "bool(__thiscall*)(void*, char*, int)" } };
local function r114_138(r0_203, r1_203, r2_203, r3_203)
    local r4_203 = client.create_interface(r0_203, r1_203) or error("invalid interface", 2);
    local r5_203 = client.find_signature(r0_203, r2_203) or error("invalid signature", 2);
    local r6_203, r7_203 = pcall(r42_138.typeof, r3_203);
    if not r6_203 then
        error(r7_203, 2);
    end
    local r8_203 = r42_138.cast(r7_203, r5_203) or error("invalid typecast", 2);
    return function(...)
        return r8_203(r4_203, ...);
    end;
end
for r118_138 = 1, #r113_138, 1 do
    local r119_138 = r113_138[r118_138];
    r112_138[r119_138[1]] = r114_138("filesystem_stdio.dll", "VFileSystem017", r119_138[2], r119_138[3]);
end
local r115_138 = vtable_bind("filesystem_stdio.dll", "VFileSystem017", 11,
    "void(__thiscall*)(void*, const char*, const char*, int)");
local r116_138 = -1;
local r117_138 = "SAM_SOUND_BOARD";
local r118_138 = r42_138.typeof("char[128]")();
r112_138.get_current_directory(r118_138, r42_138.sizeof(r118_138));
local r119_138 = string.format("%s", r42_138.string(r118_138));
r115_138(r119_138, r117_138, 0);
found = false;
local function r120_138()
    local r0_205 = {};
    local r1_205 = r42_138.typeof("int[1]")();
    local r2_205 = r112_138.find_first("*", r117_138, r1_205);
    while r2_205 ~= nil do
        local r3_205 = r42_138.string(r2_205);
        if (not r112_138.find_is_directory(r1_205[0])) and r3_205:find("_gs.txt") then
            r0_205[#r0_205 + 1] = r3_205;
        end
        r2_205 = r112_138.find_next(r1_205[0]);
    end
    r112_138.find_close(r1_205[0]);
    return r0_205;
end
local r121_138 = r7_138(r43_138, r44_138, "Config system");
local r122_138 = r87_0.new_listbox(r43_138, r44_138, "config_board", "...");
local r123_138 = r87_0.new_textbox(r43_138, r44_138, "config box");
local function r124_138()
    if (r52_138.selected_tab == r52_138.easier_tab.config) and r87_0.is_menu_open() then
        local r0_206 = r120_138();
        local r1_206 = {};
        for r5_206 = 1, #r0_206, 1 do
            r1_206[r5_206] = r0_206[r5_206]:gsub("_gs.txt", "");
        end
        return r1_206;
    end
end
writefile("default config_gs.txt",
    "dHJ1ZXx0cnVlfEN1c3RvbXw4NnxBdCB0YXJnZXRzfDE4MHxmYWxzZXwxfDB8MHxDZW50ZXJ8NzB8Sml0dGVyfDF8ZmFsc2V8ZmFsc2V8MnxmYWxzZXxSYW5kb218MHxTa2l0dGVyfDEwOHx0cnVlfHRydWV8Q3VzdG9tfDYyfExvY2FsIHZpZXd8MHxDZW50ZXJ8Mzh8Sml0dGVyfDF8ZmFsc2V8ZmFsc2V8MnxmYWxzZXxPZmZ8MHxPZmZ8MHx0cnVlfHRydWV8Q3VzdG9tfDg2fEF0IHRhcmdldHN8MTgwfGZhbHNlfDV8MzN8N3xTbG93IGppdHRlcnwtMzB8T3B0aW1pemVkIHNsb3d8MXxmYWxzZXxmYWxzZXwyfGZhbHNlfE9mZnwwfE9mZnwwfHRydWV8dHJ1ZXxNaW5pbWFsfDg1fEF0IHRhcmdldHN8MTgwfGZhbHNlfDZ8NDB8LTN8U2xvdyBqaXR0ZXJ8LTI4fFlhd1YyfDB8dHJ1ZXxmYWxzZXwyfGZhbHNlfEN1c3RvbXwtODl8U3Bpbnw2MHx0cnVlfHRydWV8TWluaW1hbHwwfEF0IHRhcmdldHN8MTgwfGZhbHNlfDF8MHwxNnxDZW50ZXJ8NjJ8Sml0dGVyfDExNXxmYWxzZXxmYWxzZXwyfGZhbHNlfE9mZnwwfE9mZnwwfHRydWV8dHJ1ZXxNaW5pbWFsfDg5fEF0IHRhcmdldHN8MTgwfGZhbHNlfDF8MHwwfENlbnRlcnw1N3xKaXR0ZXJ8MTE1fGZhbHNlfGZhbHNlfDJ8ZmFsc2V8T2ZmfDB8T2ZmfDB8dHJ1ZXx0cnVlfE1pbmltYWx8MHxBdCB0YXJnZXRzfDE4MHxmYWxzZXwxfDB8MHxDZW50ZXJ8MHxPcHRpbWl6ZWQgc2xvd3wwfGZhbHNlfGZhbHNlfDJ8ZmFsc2V8T2ZmfDB8T2ZmfDB8dHJ1ZXx0cnVlfE1pbmltYWx8ODl8QXQgdGFyZ2V0c3wxODB8ZmFsc2V8NXw0Nnw5fFNsb3cgaml0dGVyfC00NXxZYXdWMnwxMTV8ZmFsc2V8dHJ1ZXwyfGZhbHNlfFJhbmRvbXwtNjR8U3BpbnwyNXx0cnVlfHRydWV8TWluaW1hbHw4OXxBdCB0YXJnZXRzfDE4MHxmYWxzZXw1fDM0fDB8U2xvdyBqaXR0ZXJ8LTMzfFlhd1YyfC0xMTV8ZmFsc2V8dHJ1ZXwyfGZhbHNlfFJhbmRvbXwtNjV8U3BpbnwyOXxmYWxzZXx0cnVlfE9mZnwwfExvY2FsIHZpZXd8T2ZmfGZhbHNlfDF8MHwwfE9mZnwwfE9mZnwwfGZhbHNlfGZhbHNlfDJ8ZmFsc2V8T2ZmfDB8T2ZmfDB8dHJ1ZXx0cnVlfE1pbmltYWx8ODl8QXQgdGFyZ2V0c3wxODB8ZmFsc2V8MXwwfDB8T2ZmfDB8U3RhdGljfC0xMTV8ZmFsc2V8ZmFsc2V8MnxmYWxzZXxPZmZ8MHxPZmZ8MHxmYWxzZXx0cnVlfE9mZnwwfExvY2FsIHZpZXd8T2ZmfGZhbHNlfDF8MHwwfE9mZnwwfE9mZnwwfGZhbHNlfGZhbHNlfDJ8ZmFsc2V8T2ZmfDB8T2ZmfDB8");
local r125_138 = r87_0.new_button(r43_138, r44_138, "Create config", function()
    writefile(tostring(r10_138(r123_138) .. "_gs.txt"), "paste config in file");
end);
local r126_138 = r87_0.new_button(r43_138, r44_138, "Delete config", function()
    r112_138.remove_file(r119_138 .. "/" .. r120_138()[r10_138(r122_138) + 1], r120_138()[r10_138(r122_138) + 1]);
end);
local r127_138 = r87_0.new_button(r43_138, r44_138, "Save config", function()
    print("Config saved!");
    local r0_209 = "";
    for r4_209, r5_209 in ipairs(r45_138["anti-aim"].anti_aim_states) do
        r0_209 = r0_209 ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_209].enable)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].anti_backstab)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_209].pitch)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_209].pitch_custom)) ..
        "|" .. tostring(r10_138(r45_138["anti-aim"].builder[r5_209].yaw_base)) .. "|";
        if r5_209 ~= "Manual" then
            r0_209 = r0_209 ..
            tostring(r10_138(r45_138["anti-aim"].builder[r5_209].yaw)) ..
            "|" ..
            tostring(r10_138(r45_138["anti-aim"].builder[r5_209].random_flick)) ..
            "|" ..
            tostring(r10_138(r45_138["anti-aim"].builder[r5_209].delay_custom)) ..
            "|" .. tostring(r10_138(r45_138["anti-aim"].builder[r5_209].yaw_jitter2)) .. "|";
        end
        r0_209 = r0_209 ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_209].yaw_custom)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_209].yaw_jitter)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_209].yaw_jitter_custom)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_209].body_yaw)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_209].body_yaw_custom)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_209].defensive_enable)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_209].defensive_force)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_209].defensive_tick_stopper)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_209].defensive_choke)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_209].defensive_pitch)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_209].defensive_pitch_custom)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_209].defensive_yaw)) ..
        "|" .. tostring(r10_138(r45_138["anti-aim"].builder[r5_209].defensive_yaw_custom)) .. "|";
    end
    r36_138.set(r37_138.encode(r0_209, "base64"));
    database.write("current_clip_board_to_save", r37_138.encode(r0_209, "base64"));
    read_data = database.read("current_clip_board_to_save");
    writefile(r120_138()[r10_138(r122_138) + 1], read_data);
end);
local r128_138 = r87_0.new_button(r43_138, r44_138, "Load config", function()
    print("Config loaded!");
    local r0_210 = r110_138(r37_138.decode(readfile(r120_138()[r10_138(r122_138) + 1]), "base64"), "|");
    local r1_210 = 1;
    for r5_210, r6_210 in ipairs(r45_138["anti-aim"].anti_aim_states) do
        r11_138(r45_138["anti-aim"].builder[r6_210].enable, r111_138(r0_210[r1_210]));
        r1_210 = r1_210 + 1;
        r11_138(r45_138["anti-aim"].anti_backstab, r111_138(r0_210[r1_210]));
        r1_210 = r1_210 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_210].pitch, tostring(r0_210[r1_210]));
        r1_210 = r1_210 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_210].pitch_custom, tonumber(r0_210[r1_210]));
        r1_210 = r1_210 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_210].yaw_base, tostring(r0_210[r1_210]));
        r1_210 = r1_210 + 1;
        if r6_210 ~= "Manual" then
            r11_138(r45_138["anti-aim"].builder[r6_210].yaw, tostring(r0_210[r1_210]));
            r1_210 = r1_210 + 1;
            r11_138(r45_138["anti-aim"].builder[r6_210].random_flick, r111_138(r0_210[r1_210]));
            r1_210 = r1_210 + 1;
            r11_138(r45_138["anti-aim"].builder[r6_210].delay_custom, tonumber(r0_210[r1_210]));
            r1_210 = r1_210 + 1;
            r11_138(r45_138["anti-aim"].builder[r6_210].yaw_jitter2, tonumber(r0_210[r1_210]));
            r1_210 = r1_210 + 1;
        end
        r11_138(r45_138["anti-aim"].builder[r6_210].yaw_custom, tonumber(r0_210[r1_210]));
        r1_210 = r1_210 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_210].yaw_jitter, tostring(r0_210[r1_210]));
        r1_210 = r1_210 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_210].yaw_jitter_custom, tonumber(r0_210[r1_210]));
        r1_210 = r1_210 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_210].body_yaw, tostring(r0_210[r1_210]));
        r1_210 = r1_210 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_210].body_yaw_custom, tonumber(r0_210[r1_210]));
        r1_210 = r1_210 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_210].defensive_enable, r111_138(r0_210[r1_210]));
        r1_210 = r1_210 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_210].defensive_force, r111_138(r0_210[r1_210]));
        r1_210 = r1_210 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_210].defensive_tick_stopper, tonumber(r0_210[r1_210]));
        r1_210 = r1_210 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_210].defensive_choke, r111_138(r0_210[r1_210]));
        r1_210 = r1_210 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_210].defensive_pitch, tostring(r0_210[r1_210]));
        r1_210 = r1_210 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_210].defensive_pitch_custom, tonumber(r0_210[r1_210]));
        r1_210 = r1_210 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_210].defensive_yaw, tostring(r0_210[r1_210]));
        r1_210 = r1_210 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_210].defensive_yaw_custom, tonumber(r0_210[r1_210]));
        r1_210 = r1_210 + 1;
    end
end);
local r129_138 = r87_0.new_button(r43_138, r44_138, "Export", function()
    print("Config exported!");
    local r0_211 = "";
    for r4_211, r5_211 in ipairs(r45_138["anti-aim"].anti_aim_states) do
        r0_211 = r0_211 ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_211].enable)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].anti_backstab)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_211].pitch)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_211].pitch_custom)) ..
        "|" .. tostring(r10_138(r45_138["anti-aim"].builder[r5_211].yaw_base)) .. "|";
        if r5_211 ~= "Manual" then
            r0_211 = r0_211 ..
            tostring(r10_138(r45_138["anti-aim"].builder[r5_211].yaw)) ..
            "|" ..
            tostring(r10_138(r45_138["anti-aim"].builder[r5_211].random_flick)) ..
            "|" ..
            tostring(r10_138(r45_138["anti-aim"].builder[r5_211].delay_custom)) ..
            "|" .. tostring(r10_138(r45_138["anti-aim"].builder[r5_211].yaw_jitter2)) .. "|";
        end
        r0_211 = r0_211 ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_211].yaw_custom)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_211].yaw_jitter)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_211].yaw_jitter_custom)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_211].body_yaw)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_211].body_yaw_custom)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_211].defensive_enable)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_211].defensive_force)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_211].defensive_tick_stopper)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_211].defensive_choke)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_211].defensive_pitch)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_211].defensive_pitch_custom)) ..
        "|" ..
        tostring(r10_138(r45_138["anti-aim"].builder[r5_211].defensive_yaw)) ..
        "|" .. tostring(r10_138(r45_138["anti-aim"].builder[r5_211].defensive_yaw_custom)) .. "|";
    end
    r36_138.set(r37_138.encode(r0_211, "base64"));
end);
local r130_138 = r87_0.new_button(r43_138, r44_138, "Import", function()
    print("Config imported!");
    local r0_212 = r110_138(r37_138.decode(r36_138.get(), "base64"), "|");
    local r1_212 = 1;
    for r5_212, r6_212 in ipairs(r45_138["anti-aim"].anti_aim_states) do
        r11_138(r45_138["anti-aim"].builder[r6_212].enable, r111_138(r0_212[r1_212]));
        r1_212 = r1_212 + 1;
        r11_138(r45_138["anti-aim"].anti_backstab, r111_138(r0_212[r1_212]));
        r1_212 = r1_212 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_212].pitch, tostring(r0_212[r1_212]));
        r1_212 = r1_212 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_212].pitch_custom, tonumber(r0_212[r1_212]));
        r1_212 = r1_212 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_212].yaw_base, tostring(r0_212[r1_212]));
        r1_212 = r1_212 + 1;
        if r6_212 ~= "Manual" then
            r11_138(r45_138["anti-aim"].builder[r6_212].yaw, tostring(r0_212[r1_212]));
            r1_212 = r1_212 + 1;
            r11_138(r45_138["anti-aim"].builder[r6_212].random_flick, r111_138(r0_212[r1_212]));
            r1_212 = r1_212 + 1;
            r11_138(r45_138["anti-aim"].builder[r6_212].delay_custom, tonumber(r0_212[r1_212]));
            r1_212 = r1_212 + 1;
            r11_138(r45_138["anti-aim"].builder[r6_212].yaw_jitter2, tonumber(r0_212[r1_212]));
            r1_212 = r1_212 + 1;
        end
        r11_138(r45_138["anti-aim"].builder[r6_212].yaw_custom, tonumber(r0_212[r1_212]));
        r1_212 = r1_212 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_212].yaw_jitter, tostring(r0_212[r1_212]));
        r1_212 = r1_212 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_212].yaw_jitter_custom, tonumber(r0_212[r1_212]));
        r1_212 = r1_212 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_212].body_yaw, tostring(r0_212[r1_212]));
        r1_212 = r1_212 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_212].body_yaw_custom, tonumber(r0_212[r1_212]));
        r1_212 = r1_212 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_212].defensive_enable, r111_138(r0_212[r1_212]));
        r1_212 = r1_212 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_212].defensive_force, r111_138(r0_212[r1_212]));
        r1_212 = r1_212 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_212].defensive_tick_stopper, tonumber(r0_212[r1_212]));
        r1_212 = r1_212 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_212].defensive_choke, r111_138(r0_212[r1_212]));
        r1_212 = r1_212 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_212].defensive_pitch, tostring(r0_212[r1_212]));
        r1_212 = r1_212 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_212].defensive_pitch_custom, tonumber(r0_212[r1_212]));
        r1_212 = r1_212 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_212].defensive_yaw, tostring(r0_212[r1_212]));
        r1_212 = r1_212 + 1;
        r11_138(r45_138["anti-aim"].builder[r6_212].defensive_yaw_custom, tonumber(r0_212[r1_212]));
        r1_212 = r1_212 + 1;
    end
end);
function r46_138.menu.visibility()
    if r87_0.is_menu_open() then
        local r0_213 = r10_138(r45_138["anti-aim"].anti_aim_selector) == "Skeet";
        r12_138(r45_138.main.welcome_label, r52_138.selected_tab == r52_138.easier_tab.main);
        r12_138(r45_138["anti-aim"].dt_teleport, r52_138.selected_tab == r52_138.easier_tab.aa2);
        r12_138(r52_138.aa, r52_138.selected_tab == r52_138.easier_tab.main);
        r12_138(r52_138.aa2, r52_138.selected_tab == r52_138.easier_tab.main);
        r12_138(r52_138.visuals, r52_138.selected_tab == r52_138.easier_tab.main);
        r12_138(r52_138.misc, r52_138.selected_tab == r52_138.easier_tab.main);
        r12_138(r52_138.cfg, r52_138.selected_tab == r52_138.easier_tab.main);
        r12_138(r52_138.main, r52_138.selected_tab ~= r52_138.easier_tab.main);
        r12_138(r45_138.extras.icon, false);
        r12_138(r45_138.extras.text, false);
        r12_138(r45_138.extras.gradient, false);
        r12_138(r45_138.extras.length, false);
        r12_138(r45_138.extras.width, false);
        r12_138(r45_138.extras.icon1, false);
        r12_138(r45_138.extras.text1, false);
        r12_138(r45_138.extras.gradient1, false);
        r12_138(r45_138.extras.dynamic, false);
        r12_138(r45_138.extras.length1, false);
        r12_138(r45_138.extras.width1, false);
        r12_138(r45_138["anti-aim"].state_selector, r52_138.selected_tab == r52_138.easier_tab.aa);
        r12_138(r45_138["anti-aim"].anti_aim_selector, r52_138.selected_tab == r52_138.easier_tab.aa);
        for r4_213, r5_213 in ipairs(r45_138["anti-aim"].anti_aim_states) do
            local r6_213 = r12_138;
            local r7_213 = r45_138["anti-aim"].builder[r5_213].enable;
            local r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
            if r8_213 then
                r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
            end
            if r8_213 then
                r8_213 = r0_213;
            end
            r6_213(r7_213, r8_213);
            r6_213 = r12_138;
            r7_213 = r45_138["anti-aim"].builder[r5_213].pitch;
            r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
            if r8_213 then
                r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
            end
            if r8_213 then
                r8_213 = r0_213;
            end
            r6_213(r7_213, r8_213);
            r6_213 = r12_138;
            r7_213 = r45_138["anti-aim"].builder[r5_213].pitch_custom;
            r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
            if r8_213 then
                r8_213 = r10_138(r45_138["anti-aim"].builder[r5_213].pitch) == "Custom";
            end
            if r8_213 then
                r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
            end
            if r8_213 then
                r8_213 = r0_213;
            end
            r6_213(r7_213, r8_213);
            r6_213 = r12_138;
            r7_213 = r45_138["anti-aim"].builder[r5_213].yaw_base;
            r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
            if r8_213 then
                r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
            end
            if r8_213 then
                r8_213 = r0_213;
            end
            r6_213(r7_213, r8_213);
            if r5_213 ~= "Manual" then
                r6_213 = r12_138;
                r7_213 = r45_138["anti-aim"].builder[r5_213].yaw;
                r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
                if r8_213 then
                    r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
                end
                if r8_213 then
                    r8_213 = r0_213;
                end
                r6_213(r7_213, r8_213);
                r6_213 = r12_138;
                r7_213 = r45_138["anti-aim"].builder[r5_213].random_flick;
                r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
                if r8_213 then
                    r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
                end
                if r8_213 then
                    r8_213 = r0_213;
                end
                r6_213(r7_213, r8_213);
                r6_213 = r12_138;
                r7_213 = r45_138["anti-aim"].builder[r5_213].delay_custom;
                r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
                if r8_213 then
                    r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
                end
                if r8_213 then
                    r8_213 = r10_138(r45_138["anti-aim"].builder[r5_213].yaw_jitter) == "Slow jitter";
                    if not r8_213 then
                        r8_213 = r10_138(r45_138["anti-aim"].builder[r5_213].yaw_jitter) == "Slow 5-way";
                    end
                end
                if r8_213 then
                    r8_213 = r0_213;
                end
                r6_213(r7_213, r8_213);
                r6_213 = r12_138;
                r7_213 = r45_138["anti-aim"].builder[r5_213].yaw_jitter2;
                r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
                if r8_213 then
                    r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
                end
                if r8_213 then
                    r8_213 = r10_138(r45_138["anti-aim"].builder[r5_213].yaw_jitter) == "Slow jitter";
                    if not r8_213 then
                        r8_213 = r10_138(r45_138["anti-aim"].builder[r5_213].yaw_jitter) == "L&R";
                    end
                    if not r8_213 then
                        r8_213 = r10_138(r45_138["anti-aim"].builder[r5_213].yaw_jitter) == "50/50";
                    end
                end
                if r8_213 then
                    r8_213 = r0_213;
                end
                r6_213(r7_213, r8_213);
            end
            r6_213 = r12_138;
            r7_213 = r45_138["anti-aim"].builder[r5_213].yaw_custom;
            r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
            if r8_213 then
                r8_213 = r5_213 ~= "Manual";
            end
            if r8_213 then
                r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
            end
            if r8_213 then
                r8_213 = r0_213;
            end
            if r8_213 then
                r8_213 = r10_138(r45_138["anti-aim"].builder[r5_213].yaw) ~= "Off";
            end
            r6_213(r7_213, r8_213);
            r6_213 = r12_138;
            r7_213 = r45_138["anti-aim"].builder[r5_213].yaw_jitter;
            r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
            if r8_213 then
                r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
            end
            if r8_213 then
                r8_213 = r0_213;
            end
            r6_213(r7_213, r8_213);
            r6_213 = r12_138;
            r7_213 = r45_138["anti-aim"].builder[r5_213].yaw_jitter_custom;
            r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
            if r8_213 then
                r8_213 = r5_213 ~= "Manual";
            end
            if r8_213 then
                r8_213 = r10_138(r45_138["anti-aim"].builder[r5_213].yaw_jitter) ~= "Off";
            end
            if r8_213 then
                r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
            end
            if r8_213 then
                r8_213 = r0_213;
            end
            r6_213(r7_213, r8_213);
            r6_213 = r12_138;
            r7_213 = r45_138["anti-aim"].builder[r5_213].body_yaw;
            r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
            if r8_213 then
                r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
            end
            if r8_213 then
                r8_213 = r0_213;
            end
            r6_213(r7_213, r8_213);
            r6_213 = r12_138;
            r7_213 = r45_138["anti-aim"].builder[r5_213].body_yaw_custom;
            r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
            if r8_213 then
                r8_213 = r10_138(r45_138["anti-aim"].builder[r5_213].body_yaw) ~= "Off";
            end
            if r8_213 then
                r8_213 = r10_138(r45_138["anti-aim"].builder[r5_213].body_yaw) ~= "Opposite";
            end
            if r8_213 then
                r8_213 = r10_138(r45_138["anti-aim"].builder[r5_213].body_yaw) ~= "Optimized slow";
            end
            if r8_213 then
                r8_213 = r10_138(r45_138["anti-aim"].builder[r5_213].body_yaw) ~= "Optimized jitter";
            end
            if r8_213 then
                r8_213 = r10_138(r45_138["anti-aim"].builder[r5_213].body_yaw) ~= "YawV2";
            end
            if r8_213 then
                r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
            end
            if r8_213 then
                r8_213 = r0_213;
            end
            r6_213(r7_213, r8_213);
            r6_213 = r12_138;
            r7_213 = r45_138["anti-aim"].builder[r5_213].defensive_enable;
            r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
            if r8_213 then
                r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
            end
            if r8_213 then
                r8_213 = r0_213;
            end
            r6_213(r7_213, r8_213);
            r6_213 = r12_138;
            r7_213 = r45_138["anti-aim"].builder[r5_213].defensive_force;
            r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
            if r8_213 then
                r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
            end
            if r8_213 then
                r8_213 = r10_138(r45_138["anti-aim"].builder[r5_213].defensive_enable);
            end
            if r8_213 then
                r8_213 = r0_213;
            end
            r6_213(r7_213, r8_213);
            r6_213 = r12_138;
            r7_213 = r45_138["anti-aim"].builder[r5_213].defensive_tick_stopper;
            r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
            if r8_213 then
                r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
            end
            if r8_213 then
                r8_213 = r10_138(r45_138["anti-aim"].builder[r5_213].defensive_enable);
            end
            if r8_213 then
                r8_213 = r0_213;
            end
            r6_213(r7_213, r8_213);
            r12_138(r45_138["anti-aim"].builder[r5_213].defensive_choke, false);
            r6_213 = r12_138;
            r7_213 = r45_138["anti-aim"].builder[r5_213].defensive_yaw;
            r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
            if r8_213 then
                r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
            end
            if r8_213 then
                r8_213 = r10_138(r45_138["anti-aim"].builder[r5_213].defensive_enable);
            end
            if r8_213 then
                r8_213 = r0_213;
            end
            r6_213(r7_213, r8_213);
            r6_213 = r12_138;
            r7_213 = r45_138["anti-aim"].builder[r5_213].defensive_yaw_custom;
            r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
            if r8_213 then
                r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
            end
            if r8_213 then
                r8_213 = r10_138(r45_138["anti-aim"].builder[r5_213].defensive_enable);
            end
            if r8_213 then
                r8_213 = r10_138(r45_138["anti-aim"].builder[r5_213].defensive_yaw) ~= "Off";
            end
            if r8_213 then
                r8_213 = r10_138(r45_138["anti-aim"].builder[r5_213].defensive_yaw) ~= "Random";
            end
            if r8_213 then
                r8_213 = r10_138(r45_138["anti-aim"].builder[r5_213].defensive_yaw) ~= "Sideways";
            end
            if r8_213 then
                r8_213 = r0_213;
            end
            r6_213(r7_213, r8_213);
            r6_213 = r12_138;
            r7_213 = r45_138["anti-aim"].builder[r5_213].defensive_yaw_custom1;
            r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
            if r8_213 then
                r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
            end
            if r8_213 then
                r8_213 = r10_138(r45_138["anti-aim"].builder[r5_213].defensive_enable);
            end
            if r8_213 then
                r8_213 = r10_138(r45_138["anti-aim"].builder[r5_213].defensive_yaw) == "L&R";
            end
            if r8_213 then
                r8_213 = r0_213;
            end
            r6_213(r7_213, r8_213);
            r6_213 = r12_138;
            r7_213 = r45_138["anti-aim"].builder[r5_213].defensive_pitch;
            r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
            if r8_213 then
                r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
            end
            if r8_213 then
                r8_213 = r10_138(r45_138["anti-aim"].builder[r5_213].defensive_enable);
            end
            if r8_213 then
                r8_213 = r0_213;
            end
            r6_213(r7_213, r8_213);
            r6_213 = r12_138;
            r7_213 = r45_138["anti-aim"].builder[r5_213].defensive_pitch_custom;
            r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
            if r8_213 then
                r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
            end
            if r8_213 then
                r8_213 = r10_138(r45_138["anti-aim"].builder[r5_213].defensive_enable);
            end
            if r8_213 then
                r8_213 = r10_138(r45_138["anti-aim"].builder[r5_213].defensive_pitch) == "Custom";
            end
            if r8_213 then
                r8_213 = r0_213;
            end
            r6_213(r7_213, r8_213);
        end
        for r4_213, r5_213 in ipairs(r45_138["anti-aim"].anti_aim_states) do
            local r6_213 = r12_138;
            local r7_213 = r50_138[r5_213].enable;
            local r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
            if r8_213 then
                r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
            end
            if r8_213 then
                r8_213 = not r0_213;
            end
            r6_213(r7_213, r8_213);
            r6_213 = r12_138;
            r7_213 = r50_138[r5_213].pitch;
            r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
            if r8_213 then
                r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
            end
            if r8_213 then
                r8_213 = not r0_213;
            end
            r6_213(r7_213, r8_213);
            r6_213 = r12_138;
            r7_213 = r50_138[r5_213].yaw;
            r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
            if r8_213 then
                r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
            end
            if r8_213 then
                r8_213 = not r0_213;
            end
            r6_213(r7_213, r8_213);
            r6_213 = r12_138;
            r7_213 = r50_138[r5_213].yaw_custom;
            r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
            if r8_213 then
                r8_213 = r5_213 ~= "Manual";
            end
            if r8_213 then
                r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
            end
            if r8_213 then
                r8_213 = r10_138(r50_138[r5_213].yaw) ~= "Off";
            end
            if r8_213 then
                r8_213 = not r0_213;
            end
            r6_213(r7_213, r8_213);
            r6_213 = r12_138;
            r7_213 = r50_138[r5_213].yaw_jitter;
            r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
            if r8_213 then
                r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
            end
            if r8_213 then
                r8_213 = not r0_213;
            end
            r6_213(r7_213, r8_213);
            r6_213 = r12_138;
            r7_213 = r50_138[r5_213].yaw_jitter_custom;
            r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
            if r8_213 then
                r8_213 = r10_138(r50_138[r5_213].yaw_jitter) ~= "Off";
            end
            if r8_213 then
                r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
            end
            if r8_213 then
                r8_213 = not r0_213;
            end
            r6_213(r7_213, r8_213);
            r6_213 = r12_138;
            r7_213 = r50_138[r5_213].body_yaw;
            r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
            if r8_213 then
                r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
            end
            if r8_213 then
                r8_213 = not r0_213;
            end
            r6_213(r7_213, r8_213);
            r6_213 = r12_138;
            r7_213 = r50_138[r5_213].body_yaw_custom;
            r8_213 = r10_138(r45_138["anti-aim"].state_selector) == r5_213;
            if r8_213 then
                r8_213 = r52_138.selected_tab == r52_138.easier_tab.aa;
            end
            if r8_213 then
                r8_213 = not r0_213;
            end
            r6_213(r7_213, r8_213);
        end
        local r1_213 = r12_138;
        local r2_213 = r45_138["anti-aim"].disable_on_quickpeek;
        local r3_213 = r52_138.selected_tab == r52_138.easier_tab.aa2;
        if r3_213 then
            r3_213 = r0_213;
        end
        r1_213(r2_213, r3_213);
        r1_213 = r12_138;
        r2_213 = r45_138["anti-aim"].freestanding_disablers;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.aa2;
        if r3_213 then
            r3_213 = r0_213;
        end
        r1_213(r2_213, r3_213);
        r12_138(r45_138["anti-aim"].anti_backstab, r52_138.selected_tab == r52_138.easier_tab.aa2);
        r1_213 = r12_138;
        r2_213 = r45_138["anti-aim"].safe_anti_aim;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.aa2;
        if r3_213 then
            r3_213 = r0_213;
        end
        r1_213(r2_213, r3_213);
        r12_138(r45_138.visuals.indicator, r52_138.selected_tab == r52_138.easier_tab.visuals);
        r1_213 = r12_138;
        r2_213 = r45_138.visuals.indicator_scoped_animation;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.visuals;
        if r3_213 then
            r3_213 = r10_138(r45_138.visuals.indicator) ~= "Disabled";
        end
        r1_213(r2_213, r3_213);
        r1_213 = r12_138;
        r2_213 = r45_138.visuals.indicator_color;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.visuals;
        if r3_213 then
            r3_213 = r10_138(r45_138.visuals.indicator) == "Default";
        end
        r1_213(r2_213, r3_213);
        r12_138(r45_138.visuals.defensive_indicator, r52_138.selected_tab == r52_138.easier_tab.visuals);
        r1_213 = r12_138;
        r2_213 = r45_138.visuals.defensive_indicator_color;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.visuals;
        if r3_213 then
            r3_213 = r10_138(r45_138.visuals.defensive_indicator);
        end
        r1_213(r2_213, r3_213);
        r12_138(r45_138.visuals.desync_indicator, r52_138.selected_tab == r52_138.easier_tab.visuals);
        r1_213 = r12_138;
        r2_213 = r45_138.visuals.desync_indicator_color;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.visuals;
        if r3_213 then
            r3_213 = r10_138(r45_138.visuals.desync_indicator);
        end
        r1_213(r2_213, r3_213);
        r12_138(r45_138.visuals.slow_down_indicator, r52_138.selected_tab == r52_138.easier_tab.visuals);
        r1_213 = r12_138;
        r2_213 = r45_138.visuals.slow_down_indicator_color;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.visuals;
        if r3_213 then
            r3_213 = r10_138(r45_138.visuals.slow_down_indicator);
        end
        r1_213(r2_213, r3_213);
        r12_138(r45_138.visuals.minimum_damage_indicator, r52_138.selected_tab == r52_138.easier_tab.visuals);
        r12_138(r45_138.visuals.manual_anti_aim_indicators, r52_138.selected_tab == r52_138.easier_tab.visuals);
        r1_213 = r12_138;
        r2_213 = r45_138.visuals.mi_type;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.visuals;
        if r3_213 then
            r3_213 = r10_138(r45_138.visuals.manual_anti_aim_indicators);
        end
        r1_213(r2_213, r3_213);
        r12_138(r45_138.visuals.ot_watermark, r52_138.selected_tab == r52_138.easier_tab.visuals);
        r1_213 = r12_138;
        r2_213 = r45_138.visuals.watermark_logo;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.visuals;
        if r3_213 then
            r3_213 = r10_138(r45_138.visuals.ot_watermark);
        end
        r1_213(r2_213, r3_213);
        r1_213 = r12_138;
        r2_213 = r45_138.visuals.watermark_spacing;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.visuals;
        if r3_213 then
            r3_213 = r10_138(r45_138.visuals.ot_watermark);
        end
        if r3_213 then
            r3_213 = r10_138(r45_138.visuals.watermark_logo);
        end
        r1_213(r2_213, r3_213);
        r1_213 = r12_138;
        r2_213 = r45_138.visuals.manual_anti_aim_indicators_color;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.visuals;
        if r3_213 then
            r3_213 = r10_138(r45_138.visuals.manual_anti_aim_indicators);
        end
        r1_213(r2_213, r3_213);
        r12_138(r45_138.visuals.player_esp, r52_138.selected_tab == r52_138.easier_tab.visuals);
        r1_213 = r12_138;
        r2_213 = r45_138.visuals.zeus_esp;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.visuals;
        if r3_213 then
            r3_213 = r57_138(r10_138(r45_138.visuals.player_esp), "Zeus esp");
        end
        r1_213(r2_213, r3_213);
        r1_213 = r12_138;
        r2_213 = r45_138.visuals.target_color;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.visuals;
        if r3_213 then
            r3_213 = r57_138(r10_138(r45_138.visuals.player_esp), "At target flag");
        end
        r1_213(r2_213, r3_213);
        r1_213 = r12_138;
        r2_213 = r45_138.visuals.target_label;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.visuals;
        if r3_213 then
            r3_213 = r57_138(r10_138(r45_138.visuals.player_esp), "At target flag");
        end
        r1_213(r2_213, r3_213);
        r1_213 = r12_138;
        r2_213 = r45_138.visuals.zeus_indicator_color;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.visuals;
        if r3_213 then
            r3_213 = r57_138(r10_138(r45_138.visuals.player_esp), "Zeus esp");
        end
        if r3_213 then
            r3_213 = r57_138(r10_138(r45_138.visuals.zeus_esp), "Flag");
        end
        r1_213(r2_213, r3_213);
        r12_138(r45_138.misc.local_animations, r52_138.selected_tab == r52_138.easier_tab.misc);
        r12_138(r45_138.misc.resolver, r52_138.selected_tab == r52_138.easier_tab.misc);
        r12_138(r45_138.misc.safe_point, r52_138.selected_tab == r52_138.easier_tab.misc);
        r12_138(r45_138.misc.fps_boost, r52_138.selected_tab == r52_138.easier_tab.misc);
        r12_138(r45_138.misc.kill_say, r52_138.selected_tab == r52_138.easier_tab.misc);
        r12_138(r45_138.misc.sunset_mode, r52_138.selected_tab == r52_138.easier_tab.misc);
        r12_138(r45_138.misc.show_keybinds, r52_138.selected_tab == r52_138.easier_tab.aa2);
        r12_138(r45_138.misc.fast_ladder_box, r52_138.selected_tab == r52_138.easier_tab.misc);
        r1_213 = r12_138;
        r2_213 = r45_138.misc.ladder_yaw_slider;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.misc;
        if r3_213 then
            r3_213 = r10_138(r45_138.misc.fast_ladder_box);
        end
        r1_213(r2_213, r3_213);
        r1_213 = r12_138;
        r2_213 = r45_138.misc.manual_r;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.aa2;
        if r3_213 then
            r3_213 = r10_138(r45_138.misc.show_keybinds);
        end
        r1_213(r2_213, r3_213);
        r1_213 = r12_138;
        r2_213 = r45_138.misc.manual_b;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.aa2;
        if r3_213 then
            r3_213 = r10_138(r45_138.misc.show_keybinds);
        end
        r1_213(r2_213, r3_213);
        r1_213 = r12_138;
        r2_213 = r45_138.misc.manual_l;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.aa2;
        if r3_213 then
            r3_213 = r10_138(r45_138.misc.show_keybinds);
        end
        r1_213(r2_213, r3_213);
        r1_213 = r12_138;
        r2_213 = r45_138.misc.manual_f;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.aa2;
        if r3_213 then
            r3_213 = r10_138(r45_138.misc.show_keybinds);
        end
        r1_213(r2_213, r3_213);
        r1_213 = r12_138;
        r2_213 = r45_138.misc.freestanding;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.aa2;
        if r3_213 then
            r3_213 = r10_138(r45_138.misc.show_keybinds);
        end
        r1_213(r2_213, r3_213);
        r12_138(r45_138.misc.aim_logs, r52_138.selected_tab == r52_138.easier_tab.misc);
        r1_213 = r12_138;
        r2_213 = r45_138.misc.aim_logs_hit_color;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.misc;
        if r3_213 then
            r3_213 = r10_138(r45_138.misc.aim_logs);
        end
        r1_213(r2_213, r3_213);
        r1_213 = r12_138;
        r2_213 = r45_138.misc.aim_logs_miss_color;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.misc;
        if r3_213 then
            r3_213 = r10_138(r45_138.misc.aim_logs);
        end
        r1_213(r2_213, r3_213);
        r1_213 = r12_138;
        r2_213 = r45_138.misc.aim_logs_hit_label;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.misc;
        if r3_213 then
            r3_213 = r10_138(r45_138.misc.aim_logs);
        end
        r1_213(r2_213, r3_213);
        r1_213 = r12_138;
        r2_213 = r45_138.misc.aim_logo;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.misc;
        if r3_213 then
            r3_213 = r10_138(r45_138.misc.aim_logs);
        end
        r1_213(r2_213, r3_213);
        r1_213 = r12_138;
        r2_213 = r45_138.misc.logo_slider;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.misc;
        if r3_213 then
            r3_213 = r10_138(r45_138.misc.aim_logs);
        end
        if r3_213 then
            r3_213 = r10_138(r45_138.misc.aim_logo);
        end
        r1_213(r2_213, r3_213);
        r1_213 = r12_138;
        r2_213 = r45_138.misc.aim_logs_miss_label;
        r3_213 = r52_138.selected_tab == r52_138.easier_tab.misc;
        if r3_213 then
            r3_213 = r10_138(r45_138.misc.aim_logs);
        end
        r1_213(r2_213, r3_213);
        r12_138(r45_138.misc.old_logs, r52_138.selected_tab == r52_138.easier_tab.misc);
        r12_138(r130_138, r52_138.selected_tab == r52_138.easier_tab.config);
        r12_138(r129_138, r52_138.selected_tab == r52_138.easier_tab.config);
        r12_138(r121_138, r52_138.selected_tab == r52_138.easier_tab.config);
        r12_138(r128_138, r52_138.selected_tab == r52_138.easier_tab.config);
        r12_138(r122_138, r52_138.selected_tab == r52_138.easier_tab.config);
        r12_138(r123_138, r52_138.selected_tab == r52_138.easier_tab.config);
        r12_138(r125_138, r52_138.selected_tab == r52_138.easier_tab.config);
        r12_138(r126_138, r52_138.selected_tab == r52_138.easier_tab.config);
        r12_138(r127_138, r52_138.selected_tab == r52_138.easier_tab.config);
        r12_138(r51_138.enabled, false);
        r12_138(r51_138.pitch[1], false);
        r12_138(r51_138.pitch[2], false);
        r12_138(r51_138.yawbase, false);
        r12_138(r51_138.yaw[1], false);
        r12_138(r51_138.yaw[2], false);
        r12_138(r51_138.yawjitter[1], false);
        r12_138(r51_138.yawjitter[2], false);
        r12_138(r51_138.bodyyaw[1], false);
        r12_138(r51_138.bodyyaw[2], false);
        r12_138(r51_138.roll, false);
        r12_138(r51_138.freestand[1], false);
        r12_138(r51_138.freestand[2], false);
        r12_138(r51_138.freestand_body[1], false);
        r12_138(r51_138.edgeyaw, false);
    end
end

local r131_138 = false;
local function r132_138()
    local r0_214, r1_214 = r88_0.screen_size();
    r46_138.visuals.watermark(r0_214, r1_214);
    r108_138();
    r46_138.visuals.crosshair_indicator(r0_214, r1_214);
    r46_138.visuals.simple_crosshair_indicators(r0_214, r1_214);
    r46_138.visuals.desync_indicator(r0_214, r1_214);
    r46_138.visuals.slow_down_indicator(r0_214, r1_214);
    r46_138.visuals.minimum_damage_indicator(r0_214, r1_214);
    r46_138.visuals.manual_anti_aim_indicators(r0_214, r1_214);
    r46_138.visuals.aim_logs(r0_214, r1_214);
    r46_138.visuals.zeus_indicator();
    r46_138.visuals.zeus_out_of_view();
    r46_138.visuals.old_logs(r0_214, r1_214);
    r46_138.visuals.side_defensive_menu(r0_214, r1_214);
    r46_138.visuals.defensive_open(r0_214, r1_214);
    r46_138.visuals.side_slow_menu(r0_214, r1_214);
    r46_138.visuals.slow_open(r0_214, r1_214);
    r87_138();
    if r87_0.get(r45_138.misc.fps_boost) and (r131_138 == false) then
        r46_138.visuals.fps_boost(0);
        r131_138 = true;
    elseif (not r87_0.get(r45_138.misc.fps_boost)) and (r131_138 == true) then
        r46_138.visuals.fps_boost(1);
        r131_138 = false;
    end
    r46_138.visuals.defensive_indicator(r0_214, r1_214);
    r46_138.misc.sunset();
    if (r46_138["anti-aim"].sim_time ~= nil) and (r46_138["anti-aim"].sim_time < 0) then
        r46_138["anti-aim"].sim_tick = r27_138();
    end
    r46_138.misc.resolver();
    r101_138.three = {};
    r49_138.size = 0;
end
local function r133_138()
    local r0_215, r1_215 = r88_0.screen_size();
    r46_138.menu.visibility();
    if entity.get_local_player() == nil then
        r46_138.visuals.is_defensive = false;
    end
    if r87_0.is_menu_open() and (r52_138.selected_tab == r52_138.easier_tab.config) then
        r87_0.update(r122_138, r124_138());
    end
end
local function r134_138(r0_216)
    if r10_138(r45_138["anti-aim"].anti_aim_selector) == "Skeet" then
        r46_138["anti-aim"].anti_aim_setup(r0_216);
    else
        r46_138["anti-aim"].venus_anti_aim(r0_216);
    end
    r46_138.misc.fast_ladder(r0_216);
    r46_138["anti-aim"].teleport_techology();
    if not r77_138 then
        r0_216.in_attack = false;
        r0_216.in_attack2 = 0;
    end
    r77_138 = true;
end
local function r135_138()
    r46_138.misc.local_animations();
end
local function r136_138()
    r12_138(r51_138.enabled, true);
    r12_138(r51_138.pitch[1], true);
    r12_138(r51_138.pitch[2], true);
    r12_138(r51_138.yawbase, true);
    r12_138(r51_138.yaw[1], true);
    r12_138(r51_138.yaw[2], true);
    r12_138(r51_138.yawjitter[1], true);
    r12_138(r51_138.yawjitter[2], true);
    r12_138(r51_138.bodyyaw[1], true);
    r12_138(r51_138.bodyyaw[2], true);
    r12_138(r51_138.roll, true);
    r12_138(r51_138.freestand[1], true);
    r12_138(r51_138.freestand[2], true);
    r12_138(r51_138.freestand_body[1], true);
    r12_138(r51_138.edgeyaw, true);
    if r109_138 == true then
        for r3_218 = 1, globals.maxplayers(), 1 do
            if r13_138(r3_218, "m_iTeamNum") ~= r13_138(r28_138(), "m_iTeamNum") then
                plist.set(r3_218, "Force body yaw", false);
                plist.set(r3_218, "Force body yaw value", 0);
            end
        end
    end
    if r46_138.misc.sunset_active == true then
        r89_0.set_prop(r89_0.get_all("CCascadeLight")[1], "m_envLightShadowDirection", r46_138.misc.old_sun.x,
            r46_138.misc.old_sun.y, r46_138.misc.old_sun.z);
    end
    if r131_138 then
        r46_138.visuals.fps_boost(1);
    end
    database.write("def_indicator_x", r49_138.defensive_x);
    database.write("def_indicator_y", r49_138.defensive_y);
    database.write("slow_indicator_x", r49_138.slow_x);
    database.write("slow_indicator_y", r49_138.slow_y);
end
r14_138("bomb_exploded", function()
    r46_138["anti-aim"].bomb_was_bombed = true;
end);
r14_138("bomb_defused", function()
    r46_138["anti-aim"].bomb_was_defused = true;
end);
r14_138("round_start", function()
    r46_138["anti-aim"].bomb_was_defused = false;
    r46_138["anti-aim"].bomb_was_bombed = false;
    r98_138 = {};
end);
r14_138("net_update_end", r46_138.misc.safe_point);
r14_138("paint", r132_138);
r14_138("paint_ui", r133_138);
r14_138("pre_render", r135_138);
r14_138("setup_command", r134_138);
r14_138("shutdown", r136_138);
print("#venus'd")
