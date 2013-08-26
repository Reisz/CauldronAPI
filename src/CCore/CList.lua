--!!class CList module CCore @CList
CList = class("CList")

local function _newindex_fun(tbl, key, val)
        if type(key) == "number" then
            tbl[key] = val
        end
end

function CList:initialize(...)
    for i, v in ipairs({...}) do
        table.insert(self, i, v)
    end
    
    getmetatable(self).__newindex = _newindex_fun
end

function CList.static.fromTable(tbl)
    return CList(unpack(tbl))
end

function CList:append(value) self:insert(value) end

function CList:at(pos) return self[pos] end

function CList:clear() while #self > 0 do self:remove() end end

function CList:contains(value)
    if self:find(value) then return true end
    return false
end

function CList:copy() return CList(unpack(self)) end

function CList:count(value)
    if not value then return #self end
    local result = 0
    for i, v in ipairs(self) do
        if v == value then result = result + 1 end
    end
    return result
end

function CList:endsWith(value)
    local last = #self
    if last == 0 then return false end
    return self[last] == value
end

function CList:find(value)
    for i,v in ipairs(self) do
        if v == value then return i end
    end
    return nil
end

function CList:findAll(value)
    local result = {}
    for i, v in ipairs(self) do
        if v == value then table.insert(result, i) end
    end
    return unpack(result)
end

function CList:first() return self[1] end

function CList:insert(pos, value)
    if value == nil then
        value = pos
        pos = #self + 1
    end
    table.insert(self, pos, value)
end

function CList:isEmpty() return #self == 0 end

function CList:last() return self[#self] end

function CList:length() return #self end

function CList:maxn() return table.maxn(self) end

function CList:remove(pos)
    pos = pos or #self
    return table.remove(self, pos)
end

function CList:removeAll(...)
    local input, result, offset = {...}, {}, 0
    table.sort(input)
    for _, v in ipairs(input) do 
        table.insert(result, self:remove(v - offset))
        offset = offset + 1
    end
    return unpack(result)
end

function CList:removeFirst() self:remove(1) end

function CList:removeLast() self:remove() end

function CList:sort(comp) table.sort(self, comp) end

function CList:startsWith(value) return self[1] == value end

function CList:takeAt(pos)
    local v = self[pos]
    self:remove(i)
    return v
end

function CList:takeFirst() return self:takeAt(1) end

function CList:takeLast() return self:takeAt(#self) end 

function CList:unpack() return unpack(self) end

function CList:value(pos, default)
    local result = self[pos]
    if result == nil then return default end
    return result
end

function CList:__tostring()
    return "CList[" .. #self .. "]: {" .. CStringList(self:unpack()):concat(", ") .. "}"
end

local function _dump_table(tbl)
    return "{",CStringList(unpack(tbl)):concat(", "), "}"
end

local function _dump_to_string(value)
    if type(value) == "string" then return string.format("%q", value) end
    if type(value) == "table" then
        return tostring(value), ": ", _dump_table(value)
    end
    return tostring(value)
end

function CList:__dump()
    print("CList[", #self, "]")
    for i, v in ipairs(self) do print("[", i, "] = ", _dump_to_string(v)) end
end
