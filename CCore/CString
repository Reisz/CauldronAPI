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

function string:arg(...)
    return self:gsub("(%%%d%d?)", _assign_args(self, {...}))
end

function string:split(split, plain, ignoreEmpty)
    local result, i = {}, 1

    while true do
        local newI = string.find(self, split, i, plain)
        if not newI then
            local sub = string.sub(self, i)
            if not (ignoreEmpty and #sub == 0) then
                table.insert(result, sub)
            end
            return CStringList(unpack(result))
        end
        local sub = string.sub(self, i, newI - 1)
        if not (ignoreEmpty and #sub == 0) then
            table.insert(result, sub)
        end
        i = newI + 1
    end
end