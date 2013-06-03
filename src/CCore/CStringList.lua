--!!module CCore
--!!class CStringList extends CList @CStringList
--!The CStringList class provides a list of strings.
--!$see CString
CStringList = class("CStringList", CList)

--!!member function nil CStringList(string ...) @CStringList()
function CStringList:initialize(...)
    local list = {...}
    for i, v in ipairs(list) do
        list[i] = tostring(v)
    end
    CList.initialize(self, unpack(list))
end

--!!member function CStringList.fromList(CList list) @CStringList.fromList
--!$static
function CStringList.static.fromList(list)
    assert(instanceOf(CList, list), "List not instance of CList")
    return CStringList(list:unpack())
end

--!!member function string CStringList:concat(string separator, int i, int j) @CStringList:concat
function CStringList:concat(sep, i, j)
    sep = sep or ""
    i = i or 1
    j = j or #self
    return table.concat(self, sep, i, j)
end

--!!member function int CStringList:find(string value, bool plain) @CStringList:find
function CStringList:find(value, plain)
    if plain then return CList.find(self, value) end
    for i,v in ipairs(self) do
        if string.find(v, value) then return i end
    end
    return nil
end

--!!member function int, ... CStringList:findAll(string value, bool plain) @CStringList:findAll
function CStringList:findAll(value, plain)
    if plain then return CList.findAll(self, value) end
    local result = {}
    for i, v in ipairs(self) do
        if string.find(v, value) then table.insert(result, i) end
    end
    return unpack(result)
end

--!!member function nil CStringList:insert(int pos, string value) @CStringList:insert
function CStringList:insert(pos, value)
    if value == nil then
        value = pos
        pos = #self + 1
    end
    CList.insert(self, pos, tostring(value))
end
