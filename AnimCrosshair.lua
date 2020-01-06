local function DEG2RAD(x) return x * math.pi / 180 end
local function RAD2DEG(x) return x * 180 / math.pi end

ICvar.FindVar("crosshair"):SetBool(false)

local Screen = IEngine.GetScreenSize()
local rainbow = 0.0
local rotationdegree = 0.0

local function hsv2rgb(h, s, v, a)
    local r, g, b
  
    local i = math.floor(h * 6);
    local f = h * 6 - i;
    local p = v * (1 - s);
    local q = v * (1 - f * s);
    local t = v * (1 - (1 - f) * s);
  
    i = i % 6
  
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end
  
    return r * 255, g * 255, b * 255, a * 255
end

local function DrawCH(x, y, size)
    local frametime = IGlobalVars.frametime
    local a = size / 60
    local gamma = math.atan(a / a)
    rainbow = rainbow + (frametime * 0.5)
    if rainbow > 1.0 then rainbow = 0.0 end
    if rotationdegree > 89 then rotationdegree = 0 end

    for i = 0, 4 do  
        local p_0 = (a * math.sin(DEG2RAD(rotationdegree + (i * 90))))
        local p_1 = (a * math.cos(DEG2RAD(rotationdegree + (i * 90))))
        local p_2 =((a / math.cos(gamma)) * math.sin(DEG2RAD(rotationdegree + (i * 90) + RAD2DEG(gamma))))
        local p_3 =((a / math.cos(gamma)) * math.cos(DEG2RAD(rotationdegree + (i * 90) + RAD2DEG(gamma))))
        Render.Line(x, y, x + p_0, y - p_1, Color.new(hsv2rgb(rainbow, 1, 1, 1)), 1)
        --Render.Line(x + p_0, y - p_1, x + p_2, y - p_3, Color.new(255, 255, 255, 255), 1) -- Censored
    end
    rotationdegree = rotationdegree + (frametime * 150)
end

local function Render()
    if Utils.IsLocal() == false then 
        return
    end

    DrawCH(Screen.x / 2, Screen.y / 2, 600) 
end

Hack.RegisterCallback("PaintTraverse", Render)