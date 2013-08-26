CEnum = class("CEnum")

function CEnum:initialize(tbl)
    for i,v in pairs(tbl) do
        if type(i) == "number" then
            if type(v) ~= "string" then error("Enum tables may only contain strings or string-indexed values!", 3) end
            self[v] = {}
        elseif type(i) == "string" then
            self[i] = { value = v }
        else
            error("Enum tables may only contain strings or string-indexed values!", 3)
        end
    end
end

function C_ENUM(class, name, enum)
    if not subclassOf(Object, class) then error("Invalid argument 1 of C_ENUM: requested subclass of Object, got " .. tostring(class), 2) end
    if not instanceOf(CEnum, enum) then error("Invalid argument 2 of C_ENUM: requested CEnum, got " .. enum, 2) end
    class.static[name] = enum
    for i,v in pairs(enum) do
        if class.static[i] then error("Index " .. i .. " of " .. class .. " is already taken.", 2) end
        class.static[i] = v
    end
end