local vector = require("vector") or error("reload script or cheat")
local master_switch = ui.new_checkbox("Lua", "B", "Excellent camera")
local smooth_all = ui.new_checkbox("Lua", "B", "Smooth all axes")
local xy_smooth = ui.new_slider("Lua", "B", "Camera smooth x & y", 1, 10000, 10)
local camera_smooth = ui.new_slider("Lua", "B", "Excellent camera smooth", 1, 10000, 3)
local fd_fix = ui.new_checkbox("Lua", "B", "Fix fake-duck animation")
local fd = ui.reference("Rage", "Other", "Duck peek assist")
local Thirdperson = {ui.reference("Visuals", "Effects", "Force third person (alive)")}
local eye_record = {}
local smoothed_eye = vector(0, 0, 0)
local last_eye_z = nil
local prev_air = false
local xy_value = 0
local z_value = 0
client.set_event_callback("override_view", function(view)
    local lp = entity.get_local_player()
    if not ui.get(master_switch) or not lp or not entity.is_alive(lp) then
        return
    end
    local fd_fix_detected = ui.get(fd_fix) and not air and not prev_air and ui.get(fd) == true
    local velocity = vector(entity.get_prop(lp, "m_vecVelocity"))
    local eye = vector(client.eye_position())
    eye_record[globals.tickcount()] = eye
    if #eye_record > 10000 then
        table.remove(eye_record, globals.tickcount() - 501)
    end
    for i = 1, 10000 do
        if eye_record[globals.tickcount() - i] ~= nil and i <= ui.get(xy_smooth) then
            smoothed_eye.x = (smoothed_eye.x + eye_record[globals.tickcount() - i].x) / 2
            smoothed_eye.y = (smoothed_eye.y + eye_record[globals.tickcount() - i].y) / 2
        end
    end
    for i = 1, 10000 do
        if eye_record[globals.tickcount() - i] ~= nil and i <= ui.get(camera_smooth) then
            smoothed_eye.z = (smoothed_eye.z + eye_record[globals.tickcount() - i].z) / 2
        end
    end
    smoothed_eye.x, smoothed_eye.y = (smoothed_eye.x + eye.x) / 2, (smoothed_eye.y + eye.y) / 2
    if velocity.z == 1 or velocity.z == 0 then
        smoothed_eye.z = eye.z
    else
        smoothed_eye.z = (smoothed_eye.z + eye.z) / 2
    end
    local flags = entity.get_prop(lp, "m_fFlags")
    local air = bit.band(flags, 1) == 0
    local cam_ang = vector(client.camera_angles())
    local dist = cvar.cam_idealdist:get_float()
    local yaw_rad = math.rad(cam_ang.y)
    local pitch_rad = math.rad(cam_ang.x)
    local direction = vector(math.cos(pitch_rad) * math.cos(yaw_rad), math.cos(pitch_rad) * math.sin(yaw_rad), -math.sin(pitch_rad))
    local lengthsqr = math.sqrt(direction.x ^ 2 + direction.y ^ 2 + direction.z ^ 2)
    direction.x = direction.x / lengthsqr
    direction.y = direction.y / lengthsqr
    direction.z = direction.z / lengthsqr
    local new_eye = eye
    new_eye.z = smoothed_eye.z
    if ui.get(smooth_all) then
        new_eye.x = smoothed_eye.x
        new_eye.y = smoothed_eye.y
    end
    local target = vector(new_eye.x - direction.x * dist, new_eye.y - direction.y * dist, new_eye.z - direction.z * dist)
    local fraction, idx = 1, -1
    fraction, idx = client.trace_line(idx, new_eye.x, new_eye.y, new_eye.z, target.x, target.y, target.z)
    local traced_dist = dist
    if fraction < 1 and idx == 0 then
        traced_dist = dist * fraction - 12.5
    end
    if ui.get(Thirdperson[2]) then
        view.x = new_eye.x - direction.x * traced_dist
        view.y = new_eye.y - direction.y * traced_dist
        if not fd_fix_detected then
            view.z = new_eye.z - direction.z * traced_dist
        end
    end
    prev_air = air
end)
client.set_event_callback("paint_ui",function()
    ui.set_visible(smooth_all, ui.get(master_switch))
    ui.set_visible(camera_smooth, ui.get(master_switch))
    ui.set_visible(xy_smooth, ui.get(master_switch) and ui.get(smooth_all))
    ui.set_visible(fd_fix, ui.get(master_switch))
end)
