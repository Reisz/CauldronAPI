--!!class CStringList extends CList module CCore @CStringList
--!The CStringList class provides a list of strings.
--!$see CString
CStringList = class("CStringList", CList)

--!!value function CStringList class CStringList @CStringList()
function CStringList:initialize(...)
    local list = {...}
    for i, v in ipairs(list) do
        list[i] = tostring(v)
    end
    CList.initialize(self, unpack(list))
end

--!!value function fromList class CStringList @CStringList.fromList
--!$static
function CStringList.static.fromList(list)
    assert(instanceOf(CList, list), "List not instance of CList")
    return CStringList(list:unpack())
end

--!!value function concat class CStringList @CStringList:concat
function CStringList:concat(sep, i, j)
    sep = sep or ""
    i = i or 1
    j = j or #self
    return table.concat(self, sep, i, j)
end

--!!value function find class CStringList @CStringList:find
function CStringList:find(value, plain)
    if plain then return CList.find(self, value) end
    for i,v in ipairs(self) do
        if string.find(v, value) then return i end
    end
    return nil
end

--!!value function findAll class CStringList @CStringList:findAll
function CStringList:findAll(value, plain)
    if plain then return CList.findAll(self, value) end
    local result = {}
    for i, v in ipairs(self) do
        if string.find(v, value) then table.insert(result, i) end
    end
    return unpack(result)
end

--!!value function insert class CStringList @CStringList:insert
function CStringList:insert(pos, value)
    if value == nil then
        value = pos
        pos = #self + 1
    end
    CList.insert(self, pos, tostring(value))
end
