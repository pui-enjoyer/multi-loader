--dtfix by desiredboy--
local dtPeekFix = ui.new_checkbox("RAGE", "other", "Fix defensive in peek")
local dtReleaseLag = ui.new_checkbox("RAGE", "other", "Lag on DT release")
local dtLagDuration = ui.new_slider("RAGE", "other", "Lag duration (ticks)", 1, 16, 8)
local dtBreakLCMode = ui.new_combobox("RAGE", "other", "Break LC method", {"Safe (no movement)", "Force defensive only"})

local function vec_3( _x, _y, _z ) 
	return { x = _x or 0, y = _y or 0, z = _z or 0 } 
end

local function ticks_to_time()
	return globals.tickinterval( ) * 16
end 

local refs = {
    dt = {ui.reference("RAGE", "Aimbot", "Double tap")},
    fd = ui.reference("RAGE", "Other", "Duck peek assist")
}

local was_dt_active = false
local release_ticks_remaining = 0
local original_move_data = { forward = 0, side = 0 }

local function player_will_peek( )
	local enemies = entity.get_players( true )
	if not enemies then
		return false
	end
	
	local eye_position = vec_3( client.eye_position( ) )
	local velocity_prop_local = vec_3( entity.get_prop( entity.get_local_player( ), "m_vecVelocity" ) )
	local predicted_eye_position = vec_3( eye_position.x + velocity_prop_local.x * ticks_to_time( predicted ), eye_position.y + velocity_prop_local.y * ticks_to_time( predicted ), eye_position.z + velocity_prop_local.z * ticks_to_time( predicted ) )

	for i = 1, #enemies do
		local player = enemies[ i ]
		
		local velocity_prop = vec_3( entity.get_prop( player, "m_vecVelocity" ) )
		
		
		local origin = vec_3( entity.get_prop( player, "m_vecOrigin" ) )
		local predicted_origin = vec_3( origin.x + velocity_prop.x * ticks_to_time(), origin.y + velocity_prop.y * ticks_to_time(), origin.z + velocity_prop.z * ticks_to_time() )
		
		
		entity.get_prop( player, "m_vecOrigin", predicted_origin )
		
		
		local head_origin = vec_3( entity.hitbox_position( player, 0 ) )
		local predicted_head_origin = vec_3( head_origin.x + velocity_prop.x * ticks_to_time(), head_origin.y + velocity_prop.y * ticks_to_time(), head_origin.z + velocity_prop.z * ticks_to_time() )
		local trace_entity, damage = client.trace_bullet( entity.get_local_player( ), predicted_eye_position.x, predicted_eye_position.y, predicted_eye_position.z, predicted_head_origin.x, predicted_head_origin.y, predicted_head_origin.z )
		
		
		entity.get_prop( player, "m_vecOrigin", origin )
		
		
		if damage > 0 then
			return true
		end
	end
	
	return false
end

local function on_paint()
    --                     ,            
    if release_ticks_remaining > 0 then
        local screen_w, screen_h = client.screen_size()
        renderer.text(screen_w / 2, screen_h - 100, 255, 0, 0, 255, "c", 0, "Breaking LC: " .. release_ticks_remaining)
    end
end

client.set_event_callback("pre_render", function()
    local dt_active = ui.get(refs.dt[1]) and ui.get(refs.dt[2])
    
    --                     DT
    if was_dt_active and not dt_active and ui.get(dtReleaseLag) then
        release_ticks_remaining = ui.get(dtLagDuration)
    end
    
    --                                DT
    was_dt_active = dt_active
end)

client.set_event_callback("paint", on_paint)

client.set_event_callback("setup_command", function(cmd)
    local dt_active = ui.get(refs.dt[1]) and ui.get(refs.dt[2])
    local current_mode = ui.get(dtBreakLCMode)
    
    --                 fix defensive in peek
    if ui.get(dtPeekFix) and dt_active then
        if player_will_peek() then
            cmd.force_defensive = true
        else
            cmd.force_defensive = false
        end
    end
    
    
    if release_ticks_remaining > 0 then
        --                                                      
        if release_ticks_remaining == ui.get(dtLagDuration) then
            original_move_data.forward = cmd.forwardmove
            original_move_data.side = cmd.sidemove
        end
        
                if current_mode == "Safe (no movement)" then
            --                                  ,                  
            cmd.allow_send_packet = false
            
            
            cmd.forwardmove = original_move_data.forward
            cmd.sidemove = original_move_data.side
        else -- "Force defensive only"
            --                           force_defensive
            cmd.force_defensive = true
            cmd.allow_send_packet = false
        end
        
        release_ticks_remaining = release_ticks_remaining - 1
    end
end)


local function handle_menu_visibility()
    local enabled = ui.get(dtReleaseLag)
    ui.set_visible(dtLagDuration, enabled)
    ui.set_visible(dtBreakLCMode, enabled)
end

ui.set_callback(dtReleaseLag, handle_menu_visibility)
handle_menu_visibility()


client.set_event_callback("shutdown", function()
    release_ticks_remaining = 0
end)
