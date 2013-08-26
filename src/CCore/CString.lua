CString = {}

local function _find_next_arg_index(s, from)
    while from <= 99 do
        if s:find("%%" .. from) then return from end
        from = from + 1;
    end
    return nil
end

local _arg_mt = {
    __index = function(_, key)
        return key
    end
}

local function _assign_args(s, args)
    local current, result = 0, setmetatable({}, _arg_mt)
    for _,v in ipairs(args) do
        current = _find_next_arg_index(s, current + 1)
        if not current then
            print("string.arg: Could not find markers for all arguments. (CauldronAPI)") 
            return result
        end
        result["%" .. current] = v
    end
    return result
end

function CString.arg(s, ...)
    return s:gsub("(%%%d%d?)", _assign_args(s, {...}))
end

function CString.split(s, split, plain, ignoreEmpty)
    local result, i = CStringList(), 1

    while true do
        local newI = string.find(s, split, i, plain)
        if not newI then
            local sub = string.sub(s, i)
            if not (ignoreEmpty and #sub == 0) then result:append(sub) end
            return result
        else
            local sub = string.sub(s, i, newI - 1)
            if not (ignoreEmpty and #sub == 0) then result:append(sub) end
            i = newI + 1
        end
    end
end