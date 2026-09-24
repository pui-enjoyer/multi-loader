-- Motion Blur for GameSense
local ffi = require 'ffi'
local vector = require 'vector'

if not math.clamp then
    math.clamp = function(val, min, max) return math.min(math.max(val, min), max) end
end

if not pcall(ffi.sizeof, "CViewSetup") then
    ffi.cdef([[
        typedef struct { float x, y, z; } Vector;
        typedef int BOOL;
        typedef void* LPVOID;
        typedef unsigned long DWORD;
        typedef DWORD* PDWORD;
        typedef unsigned long ULONG_PTR;
        typedef ULONG_PTR SIZE_T;
        BOOL VirtualProtect(LPVOID lpAddress, SIZE_T dwSize, DWORD flNewProtect, PDWORD lpflOldProtect);
        LPVOID VirtualAlloc(LPVOID lpAddress, SIZE_T dwSize, DWORD flAllocationType, DWORD flProtect);
        typedef struct {
            int x; int x_old; int y; int y_old;
            int width; int width_old; int height; int height_old;
            char pad_0x0020[0x90];
            float fov; float viewmodel_fov;
            Vector origin; Vector angles;
            float m_nearZ; float m_farZ;
            float m_nearViewModelZ; float m_farViewModelZ;
            float m_aspectRatio;
            float m_nearBlurDepth; float m_nearFocusDepth;
            float m_farFocusDepth; float m_farBlurDepth;
            float m_nearBlurRadius; float m_farBlurRadius;
            float m_doFQuality; int m_motionBlurMode;
            float m_shutterTime;
            Vector m_shutterOpenPosition; Vector m_shutterOpenAngles;
            Vector m_shutterClosePosition; Vector m_shutterCloseAngles;
            float m_offCenterTop; float m_offCenterBottom;
            float m_offCenterLeft; float m_offCenterRight;
            int m_edgeBlur;
            char pad_0x00D0[0x7C];
        } CViewSetup;
    ]])
end

local get_pattern = {
    GetModuleHandlePtr = ffi.cast("void***", ffi.cast("uint32_t", client.find_signature("engine.dll", "\xFF\x15\xCC\xCC\xCC\xCC\x85\xC0\x74\x0B")) + 2)[0][0],
    GetProcAddressPtr = ffi.cast("void***", ffi.cast("uint32_t", client.find_signature("engine.dll", "\xFF\x15\xCC\xCC\xCC\xCC\xA3\xCC\xCC\xCC\xCC\xEB\x05")) + 2)[0][0],
    reinterpret_cast = function(addr, typestring)
        return function(...) return ffi.cast(typestring, client.find_signature("engine.dll", "\xFF\xE1"))(addr, ...) end
    end,
}

do
    get_pattern.fnGetModuleHandle = get_pattern.reinterpret_cast(get_pattern.GetModuleHandlePtr, "void*(__thiscall*)(void*, const char*)")
    get_pattern.fnGetProcAddress = get_pattern.reinterpret_cast(get_pattern.GetProcAddressPtr, "void*(__thiscall*)(void*, void*, const char*)")
    get_pattern.GetModuleHandle = get_pattern.fnGetModuleHandle
    get_pattern.GetProcAddress = get_pattern.fnGetProcAddress
    get_pattern.lib = { kernel32 = get_pattern.GetModuleHandle("kernel32.dll") }
    get_pattern.export = {
        kernel32 = {
            VirtualProtect = get_pattern.reinterpret_cast(get_pattern.GetProcAddress(get_pattern.lib.kernel32, "VirtualProtect"), "BOOL(__thiscall*)(void*, LPVOID, SIZE_T, DWORD, PDWORD)"),
            VirtualAlloc = get_pattern.reinterpret_cast(get_pattern.GetProcAddress(get_pattern.lib.kernel32, "VirtualAlloc"), "LPVOID(__thiscall*)(void*, LPVOID, SIZE_T, DWORD, DWORD)"),
        }
    }
end

local alive_refs = {}
local hooked_entries = {}

local function hook_vtable(vtable, index, callback, typedef)
    local old = ffi.new("DWORD[1]")
    get_pattern.export.kernel32.VirtualProtect(vtable + index, 4, 0x40, old)
    local original = vtable[index]
    vtable[index] = ffi.cast("intptr_t", ffi.cast(typedef, callback))
    get_pattern.export.kernel32.VirtualProtect(vtable + index, 4, old[0], old)
    alive_refs[#alive_refs + 1] = callback
    hooked_entries[#hooked_entries + 1] = {vtable = vtable, index = index, original = original, old = old}
    return ffi.cast(typedef, original)
end

local function unhook_all()
    for _, h in ipairs(hooked_entries) do
        get_pattern.export.kernel32.VirtualProtect(h.vtable + h.index, 4, 0x40, h.old)
        h.vtable[h.index] = h.original
        get_pattern.export.kernel32.VirtualProtect(h.vtable + h.index, 4, h.old[0], h.old)
    end
    hooked_entries = {}
    alive_refs = {}
end

local function get_vfunc(interface, index, typedef)
    return ffi.cast(typedef, ffi.cast("void***", interface)[0][index])
end

local MB = {
    MotionBlurValues = {[0] = 0, 0, 0, 0},
    MotionBlurViewPortValues = {[0] = 0, 0, 0, 0},
    History = {
        LastTimeUpdate = 0,
        RotationMotionBlurUntil = 0,
        PreviousAngles = vector(0, 0, 0),
        PreviousPosition = vector(0, 0, 0)
    },
    DrawSSROriginal = nil,
    FullFrameFBTexture = nil,
    MotionBlurMaterial = nil,
    GetFullFrameActualWidth = nil,
    GetFullFrameActualHeight = nil,
    GetMaterialName = nil,
    FindMotionMaterialVar = nil,
    SetMotionVectorComponent = nil,
    SetMotionViewPortVectorComponent = nil,
    UpdateFrame = true,
    RenderContext = nil,
    HooksSetup = false,
    PreRenderHook = false,
    PreRenderOriginal = nil,
    EnginePostMat = nil,
    MotionBlurMatGS = nil,
    NextResetEnginePost = false,
}

local UI = {
    Enabled = ui.new_checkbox("LUA", "A", "Motion Blur"),
    MethodStyle = ui.new_combobox("LUA", "A", "Style", "Effects(Prefer)", "Post"),
    LocketScreen = ui.new_checkbox("LUA", "A", "Lock Screen"),
    ForwardMotionBlur = ui.new_checkbox("LUA", "A", "Forward Motion Blur"),
    Strength = ui.new_slider("LUA", "A", "Strength", 0, 25, 5),
    RollIntensity = ui.new_slider("LUA", "A", "Roll Intensity", 0, 100, 20),
    FailingIntensity = ui.new_slider("LUA", "A", "Failing Intensity", 0, 5, 5),
    RotationIntensity = ui.new_slider("LUA", "A", "Rotation Intensity", 0, 100, 20),
    FallingMinimized = ui.new_slider("LUA", "A", "Falling Minimized", 0, 30, 10),
    FallingMaximized = ui.new_slider("LUA", "A", "Falling Maximized", 0, 30, 10),
    SwitchPersonBetween = ui.new_slider("LUA", "A", "Switch Timer", 0, 100, 50),
    FastCornerFramerate = ui.new_slider("LUA", "A", "Fast Corner FPS", 10, 300, 150),
    SlowCornerFramerate = ui.new_slider("LUA", "A", "Slow Corner FPS", 10, 299, 60),
    IgnoreMaterials = ui.new_multiselect("LUA", "A", "Ignore Materials", "dev/lumcompare", "dev/blurfilterx_nohdr", "dev/blurfiltery_nohdr", "dev/downsample_non_hdr"),
}

local function update_visibility()
    local e = ui.get(UI.Enabled)
    ui.set_visible(UI.LocketScreen, e and ui.get(UI.MethodStyle) == "Post")
    ui.set_visible(UI.ForwardMotionBlur, e)
    ui.set_visible(UI.MethodStyle, e)
    ui.set_visible(UI.Strength, e)
    ui.set_visible(UI.RollIntensity, e)
    ui.set_visible(UI.FailingIntensity, e)
    ui.set_visible(UI.RotationIntensity, e)
    ui.set_visible(UI.FallingMinimized, e)
    ui.set_visible(UI.FallingMaximized, e)
    ui.set_visible(UI.SwitchPersonBetween, e)
    ui.set_visible(UI.FastCornerFramerate, e)
    ui.set_visible(UI.SlowCornerFramerate, e)
    ui.set_visible(UI.IgnoreMaterials, e and ui.get(UI.MethodStyle) == "Effects(Prefer)")
end

ui.set_callback(UI.Enabled, update_visibility)
ui.set_callback(UI.MethodStyle, update_visibility)

local function deg_to_rad(deg) return deg * math.pi / 180 end

local function to_forward(angles)
    local sa = vector(math.sin(deg_to_rad(angles.x)), math.sin(deg_to_rad(angles.y)))
    local ca = vector(math.cos(deg_to_rad(angles.x)), math.cos(deg_to_rad(angles.y)))
    return vector(ca.x * ca.y, ca.x * sa.y, -sa.x)
end

local function to_right(angles)
    local sa = vector(math.sin(deg_to_rad(angles.x)), math.sin(deg_to_rad(angles.y)), math.sin(deg_to_rad(angles.z)))
    local ca = vector(math.cos(deg_to_rad(angles.x)), math.cos(deg_to_rad(angles.y)), math.cos(deg_to_rad(angles.z)))
    return vector(sa.z * sa.x * ca.y * -1 + ca.z * sa.y, sa.z * sa.x * sa.y * -1 + -1 * ca.z * ca.y, -1 * sa.z * ca.x)
end

local function adjust_angles(angles)
    while angles.x > 89 do angles.x = angles.x - 180 end
    while angles.x < -89 do angles.x = angles.x + 180 end
    while angles.y < -180 do angles.y = angles.y + 360 end
    while angles.y > 180 do angles.y = angles.y - 360 end
    angles.z = 0
    return angles
end

local function contains_valid_integer(array, abs_val)
    for _, data in pairs(array) do
        local v = abs_val and math.abs(data) or data
        if v > 0 then return true end
    end
    return false
end

local function reset_array(array, size)
    for i = 0, size do array[i] = 0 end
end

local function calculate_motion_blur(CViewSetup)
    local lp = entity.get_local_player()
    if not ui.get(UI.Enabled) or not lp or not entity.is_alive(lp) or not CViewSetup or CViewSetup == ffi.NULL then
        return
    end

    local vo = vector(CViewSetup.origin.x, CViewSetup.origin.y, CViewSetup.origin.z)
    local va = vector(CViewSetup.angles.x, CViewSetup.angles.y, CViewSetup.angles.z)
    local vp = vector(CViewSetup.x, CViewSetup.y)
    local vs = vector(CViewSetup.width, CViewSetup.height)
    local cv = adjust_angles(va)
    local tb = globals.realtime() - MB.History.LastTimeUpdate
    local pd = MB.History.PreviousPosition - vo
    local fd = to_forward(va)
    local rd = to_right(va)

    if pd:length() > 30 and tb >= 0.5 then
        reset_array(MB.MotionBlurValues, #MB.MotionBlurValues)
    elseif tb > (1 / 15) then
        reset_array(MB.MotionBlurValues, #MB.MotionBlurValues)
    elseif pd:length() > 50 then
        MB.History.RotationMotionBlurUntil = globals.realtime() + (ui.get(UI.SwitchPersonBetween) / 100)
    else
        local hf = CViewSetup.fov
        local ms = ui.get(UI.Strength)
        local fi = ui.get(UI.FailingIntensity)
        local ri = ui.get(UI.RollIntensity) / 100
        local sdm = rd:dot(pd)
        local fmin = ui.get(UI.FallingMinimized)
        local fmax = ui.get(UI.FallingMaximized)
        local vdm = fd:dot(pd)
        local fm = ui.get(UI.ForwardMotionBlur)
        local rot = ui.get(UI.RotationIntensity) / 100
        local ffps = ui.get(UI.FastCornerFramerate)
        local sfps = ui.get(UI.SlowCornerFramerate)
        local fminoff = math.min(fmin, fmax)
        local fmaxoff = math.max(fmin, fmax)
        local cfp = tb > 0 and (1 / tb) or 0
        local vf = (CViewSetup.m_aspectRatio <= 0) and CViewSetup.fov or (CViewSetup.fov / CViewSetup.m_aspectRatio)
        local mf = math.clamp(((cfp - sfps) / (ffps - sfps)), 0, 1)

        if fm then
            MB.MotionBlurValues[2] = vdm
        else
            MB.MotionBlurValues[2] = vdm * math.abs(fd.z)
        end

        local vya = MB.History.PreviousAngles.y + cv.y
        local vydo = MB.History.PreviousAngles.y - cv.y
        if (vydo > 180 or vydo < -180) and (vya > -180 and vya < 180) then
            vydo = MB.History.PreviousAngles.y + cv.y
        end

        local yda = vydo + (sdm / 3)
        if vydo < 0 then
            yda = math.clamp(yda, vydo, 0)
        else
            yda = math.clamp(yda, 0, vydo)
        end

        local hyr = yda / hf
        local prp = 1 - ((1 - math.abs(fd.z)) * (1 - math.abs(fd.z)))
        local pda = MB.History.PreviousAngles.x - cv.x
        local vpdo = MB.History.PreviousAngles.x - cv.x
        MB.MotionBlurValues[0] = hyr * (1 - (math.abs(cv.x) / 90))

        if cv.x > 0 then
            pda = vpdo - ((vdm / 2) * prp)
        else
            pda = vpdo + ((vdm / 2) * prp)
        end

        if vpdo < 0 then
            pda = math.clamp(pda, vpdo, 0)
        else
            pda = math.clamp(pda, 0, vpdo)
        end

        MB.MotionBlurValues[3] = hyr
        MB.MotionBlurValues[1] = pda / vf
        MB.MotionBlurValues[3] = MB.MotionBlurValues[3] * ((math.abs(cv.x) / 90) * (math.abs(cv.x) / 90) * (math.abs(cv.x) / 90))

        if tb > 0 then
            MB.MotionBlurValues[2] = MB.MotionBlurValues[2] / (tb * 30)
        else
            MB.MotionBlurValues[2] = 0
        end

        cvar.mat_motion_blur_strength:set_float(ms)
        cvar.mat_motion_blur_falling_intensity:set_float(fi)
        cvar.mat_motion_blur_falling_min:set_float(fminoff)
        cvar.mat_motion_blur_rotation_intensity:set_float(rot)
        cvar.mat_motion_blur_falling_max:set_float(fmaxoff)
        cvar.mat_motion_blur_forward_enabled:set_int(fm and 1 or 0)

        local fv2 = math.abs(MB.MotionBlurValues[2])
        local fmin2 = fm and 0 or fminoff
        local fd2 = math.max(fmaxoff - fmin2, 1)
        local clamped2 = math.clamp((fv2 - fmin2) / fd2, 0, 1)
        MB.MotionBlurValues[3] = (MB.MotionBlurValues[3] * (ri * ms)) * mf
        MB.MotionBlurValues[1] = (MB.MotionBlurValues[1] * (rot * ms)) * mf
        MB.MotionBlurValues[0] = (MB.MotionBlurValues[0] * (rot * ms)) * mf
        MB.MotionBlurValues[2] = ((clamped2 * (MB.MotionBlurValues[2] >= 0 and 1 or -1)) / 400) * (fi * ms) * mf
    end

    MB.History.LastTimeUpdate = globals.realtime()
    MB.History.PreviousPosition = vo
    MB.History.PreviousAngles = cv

    if globals.realtime() < MB.History.RotationMotionBlurUntil then
        reset_array(MB.MotionBlurValues, #MB.MotionBlurValues)
    elseif globals.realtime() >= MB.History.RotationMotionBlurUntil then
        MB.History.RotationMotionBlurUntil = 0
    end

    if not MB.GetFullFrameActualWidth or not MB.GetFullFrameActualHeight then
        if MB.FullFrameFBTexture and MB.FullFrameFBTexture ~= ffi.NULL then
            local iff = ffi.cast("void***", MB.FullFrameFBTexture)
            MB.GetFullFrameActualWidth = ffi.cast("int(__thiscall*)(void*)", iff[0][3])
            MB.GetFullFrameActualHeight = ffi.cast("int(__thiscall*)(void*)", iff[0][4])
        end
    end

    if MB.GetFullFrameActualWidth and MB.GetFullFrameActualHeight then
        local fw = MB.GetFullFrameActualWidth(MB.FullFrameFBTexture)
        local fh = MB.GetFullFrameActualHeight(MB.FullFrameFBTexture)
        MB.MotionBlurViewPortValues[0] = (vp.x + (vp.x > 0 and 1 or 0)) / (fw - 1)
        MB.MotionBlurViewPortValues[1] = (vp.y + (vp.y > 0 and 1 or 0)) / (fh - 1)
        MB.MotionBlurViewPortValues[3] = (vp.x + vs.x + (vp.x < (fw - 1) and -1 or 0)) / (fw - 1)
        MB.MotionBlurViewPortValues[2] = (vp.y + vs.y + (vp.y < (fh - 1) and -1 or 0)) / (fh - 1)
        for i, d in pairs(MB.MotionBlurViewPortValues) do
            if d >= 1 then MB.MotionBlurViewPortValues[i] = 2
            elseif d <= 0 then MB.MotionBlurViewPortValues[i] = -1 end
        end
    end
end

local function draw_motion_blur(this, IMaterial, DestX, DestY, Width, Height, SrcTextureX0, SrcTextureY0, SrcTextureX1, SrcTextureY1, SrcTextureWidth, SrcTextureHeight, ClientRenderable, nXDice, nYDice)
    ClientRenderable = ClientRenderable or ffi.NULL
    nXDice = nXDice or 1
    nYDice = nYDice or 1
    local lp = entity.get_local_player()
    if not ui.get(UI.Enabled) or not lp or not entity.is_alive(lp) or not MB.MotionBlurMaterial or MB.MotionBlurMaterial == ffi.NULL or not contains_valid_integer(MB.MotionBlurValues, true) then
        return false
    end

    local imm = ffi.cast("void***", MB.MotionBlurMaterial)
    if not MB.FindMotionMaterialVar or MB.FindMotionMaterialVar == ffi.NULL then
        MB.FindMotionMaterialVar = ffi.cast("void*(__thiscall*)(void*, const char*, bool*, bool)", imm[0][11])
        return false
    end

    local mbi = MB.FindMotionMaterialVar(MB.MotionBlurMaterial, "$MotionBlurInternal", ffi.NULL, false)
    local mbvi = MB.FindMotionMaterialVar(MB.MotionBlurMaterial, "$MotionBlurViewportInternal", ffi.NULL, false)

    if mbi ~= ffi.NULL and (not MB.SetMotionVectorComponent or MB.SetMotionVectorComponent == ffi.NULL) then
        local imv = ffi.cast("void***", mbi)
        MB.SetMotionVectorComponent = ffi.cast("void(__thiscall*)(void*, float, int)", imv[0][26])
        return false
    end

    if mbvi ~= ffi.NULL and (not MB.SetMotionViewPortVectorComponent or MB.SetMotionViewPortVectorComponent == ffi.NULL) then
        local imvv = ffi.cast("void***", mbvi)
        MB.SetMotionViewPortVectorComponent = ffi.cast("void(__thiscall*)(void*, float, int)", imvv[0][26])
        return false
    end

    local sx, sy = client.screen_size()
    local ss = vector(sx, sy)
    local ls = ui.get(UI.LocketScreen)
    local ms = ui.get(UI.MethodStyle)

    MB.SetMotionVectorComponent(mbi, MB.MotionBlurValues[3], 3)
    MB.SetMotionVectorComponent(mbi, MB.MotionBlurValues[2], 2)
    MB.SetMotionVectorComponent(mbi, MB.MotionBlurValues[1], 1)
    MB.SetMotionVectorComponent(mbi, MB.MotionBlurValues[0], 0)
    MB.SetMotionViewPortVectorComponent(mbvi, MB.MotionBlurViewPortValues[3], 3)
    MB.SetMotionViewPortVectorComponent(mbvi, MB.MotionBlurViewPortValues[2], 2)
    MB.SetMotionViewPortVectorComponent(mbvi, MB.MotionBlurViewPortValues[1], 1)
    MB.SetMotionViewPortVectorComponent(mbvi, MB.MotionBlurViewPortValues[0], 0)
 
 
    local args = {
        RenderSize = (ls or ms ~= "Post") and ss or vector(Width, Height),
        DestPosition = (ls or ms ~= "Post") and vector(0, 0) or vector(DestX, DestY),
        DiceSizePercentage = (ls or ms ~= "Post") and vector(1, 1) or vector(nXDice, nYDice),
        TextureSize = (ls or ms ~= "Post") and ss or vector(SrcTextureWidth, SrcTextureHeight),
        TextureEndPosition = (ls or ms ~= "Post") and ss or vector(SrcTextureX1, SrcTextureY1),
        TextureStartPosition = (ls or ms ~= "Post") and vector(0, 0) or vector(SrcTextureX0, SrcTextureY0)
    }

    cvar.mat_postprocess_enable:set_int(0)

    if type(this) == "cdata" and MB.DrawSSROriginal then
        MB.DrawSSROriginal(this, MB.MotionBlurMaterial, args.DestPosition.x, args.DestPosition.y, args.RenderSize.x, args.RenderSize.y, args.TextureStartPosition.x, args.TextureStartPosition.y, args.TextureEndPosition.x, args.TextureEndPosition.y, args.TextureSize.x, args.TextureSize.y, ClientRenderable, args.DiceSizePercentage.x, args.DiceSizePercentage.y)
    end

    return true
end

local function draw_ssr_cb(this, IMaterial, DestX, DestY, Width, Height, SrcTextureX0, SrcTextureY0, SrcTextureX1, SrcTextureY1, SrcTextureWidth, SrcTextureHeight, Renderable, nXDice, nYDice)
    local ctx = (this == ffi.NULL) and MB.RenderContext or this
    if not MB.GetMaterialName or MB.GetMaterialName == ffi.NULL then
        local imp = ffi.cast("void***", IMaterial)
        MB.GetMaterialName = ffi.cast("const char*(__thiscall*)(void*)", imp[0][0])
        return
    end
    local ms = ui.get(UI.MethodStyle)
    local mn = ffi.string(MB.GetMaterialName(IMaterial))
    if ms == "Post" then
        if MB.DrawSSROriginal then
            MB.DrawSSROriginal(ctx, IMaterial, DestX, DestY, Width, Height, SrcTextureX0, SrcTextureY0, SrcTextureX1, SrcTextureY1, SrcTextureWidth, SrcTextureHeight, Renderable, nXDice, nYDice)
        end
    elseif ms == "Effects(Prefer)" then
        pcall(function()
            if MB.UpdateFrame then
                MB.UpdateFrame = false
                draw_motion_blur(ctx, IMaterial, DestX, DestY, Width, Height, SrcTextureX0, SrcTextureY0, SrcTextureX1, SrcTextureY1, SrcTextureWidth, SrcTextureHeight, Renderable, nXDice, nYDice)
            end
        end)
        local ign = ui.get(UI.IgnoreMaterials)
        local skip = false
        for _, name in pairs(ign) do
            if name == mn then skip = true break end
        end
        if not skip and mn ~= "dev/engine_post" then
            if MB.DrawSSROriginal then
                MB.DrawSSROriginal(ctx, IMaterial, DestX, DestY, Width, Height, SrcTextureX0, SrcTextureY0, SrcTextureX1, SrcTextureY1, SrcTextureWidth, SrcTextureHeight, Renderable, nXDice, nYDice)
            end
        end
    end
end

local function pre_render_cb(this, edx, CViewSetup)
    if MB.PreRenderOriginal then
        MB.PreRenderOriginal(this, edx, CViewSetup)
    end
    pcall(function() calculate_motion_blur(CViewSetup) end)
    MB.UpdateFrame = true
    local ms = ui.get(UI.MethodStyle)
    if ms == "Post" then
        if MB.RenderContext and MB.RenderContext ~= ffi.NULL then
            local ir = draw_motion_blur(MB.RenderContext)
            if ir then
                MB.NextResetEnginePost = true
                cvar.mat_postprocess_enable:set_int(1)
                if MB.EnginePostMat and MB.MotionBlurMatGS then
                    materialsystem.override_material(MB.EnginePostMat, MB.MotionBlurMatGS)
                end
            elseif not ir and MB.NextResetEnginePost then
                MB.NextResetEnginePost = false
                if MB.EnginePostMat then
                    MB.EnginePostMat:reload()
                end
            end
        end
    elseif ms == "Effects(Prefer)" then
        if MB.NextResetEnginePost then
            MB.NextResetEnginePost = false
            if MB.EnginePostMat then
                MB.EnginePostMat:reload()
            end
        end
    end
end

local function setup_pre_render_hook()
    if MB.PreRenderHook then return end
    local ci = client.create_interface("client.dll", "VClient018")
    if not ci then return end
    local cv = ffi.cast("uintptr_t**", ci)[0]
    local ca = ffi.cast("void***", cv[10] + ffi.cast("unsigned long", 0x5))[0][0]
    local av = ffi.cast("int**", ca)
    local pv = ffi.cast("intptr_t**", av)[0]
    MB.PreRenderOriginal = hook_vtable(pv, 30, pre_render_cb, "void(__fastcall*)(void*, void*, CViewSetup*)")
    MB.PreRenderHook = true
end

local function setup_draw_ssr_hook()
    if MB.HooksSetup then return end
    local ms = client.create_interface("materialsystem.dll", "VMaterialSystem080")
    if not ms then return end
    local gr = get_vfunc(ms, 115, "void*(__thiscall*)(void*)")
    local rc = gr(ms)
    if not rc or rc == ffi.NULL then return end
    MB.RenderContext = rc
    local rv = ffi.cast("void***", rc)
    local dv = ffi.cast("intptr_t**", rv)[0]
    MB.DrawSSROriginal = hook_vtable(dv, 114, draw_ssr_cb, "void(__thiscall*)(void*, void*, int, int, int, int, float, float, float, float, int, int, void*, int, int)")

    if not MB.FullFrameFBTexture then
        local ft = get_vfunc(ms, 91, "void*(__thiscall*)(void*, const char*, const char*, bool, int)")
        MB.FullFrameFBTexture = ft(ms, "_rt_FullFrameFB", "RenderTargets", true, 0)
    end
    if not MB.MotionBlurMaterial then
        local fm = get_vfunc(ms, 84, "void*(__thiscall*)(void*, const char*, const char*, bool, const char*)")
        MB.MotionBlurMaterial = fm(ms, "dev/motion_blur", "RenderTargets", true, "")
    end
    if not MB.EnginePostMat then
        MB.EnginePostMat = materialsystem.find_material("dev/engine_post", true)
    end
    if not MB.MotionBlurMatGS then
        MB.MotionBlurMatGS = materialsystem.find_material("dev/motion_blur", true)
    end
    MB.HooksSetup = true
end

client.set_event_callback("run_command", function()
    setup_pre_render_hook()
    setup_draw_ssr_hook()
update_visibility()
end)

client.set_event_callback("shutdown", function()
    unhook_all()
    cvar.mat_motion_blur_strength:set_float(0)
    cvar.mat_postprocess_enable:set_int(1)
end)

update_visibility()
