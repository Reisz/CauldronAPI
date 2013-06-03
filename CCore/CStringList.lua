--!!class CStringList extends CList
--!The CStringList class provides a list of strings.
--!@see CString
CStringList = class("CStringList", CList)

--!!function nil CStringList(string ...)
function CStringList:initialize(...)
    local list = {...}
    for i, v in ipairs(list) do
        list[i] = tostring(v)
    end
    CList.initialize(self, unpack(list))
end

--!!function CStringList.fromList(CList list)
--!@static
function CStringList.static.fromList(list)
    assert(instanceOf(CList, list), "List not instance of CList")
    return CStringList(list:unpack())
end

--!!function string CStringList:concat(string separator, int i, int j)
function CStringList:concat(sep, i, j)
    sep = sep or ""
    i = i or 1
    j = j or #self
    return table.concat(self, sep, i, j)
end

--!!function int CStringList:find(string value, bool plain)
function CStringList:find(value, plain)
    if plain then return CList.find(self, value) end
    for i,v in ipairs(self) do
        if string.find(v, value) then return i end
    end
    return nil
end

--!!function int, ... CStringList:findAll(string value, bool plain)
function CStringList:findAll(value, plain)
    if plain then return CList.findAll(self, value) end
    local result = {}
    for i, v in ipairs(self) do
        if string.find(v, value) then table.insert(result, i) end
    end
    return unpack(result)
end

--!!function nil CStringList:insert(int pos, string value)
function CStringList:insert(pos, value)
    if value == nil then
        value = pos
        pos = #self + 1
    end
    CList.insert(self, pos, tostring(value))
end
