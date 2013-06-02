CObject = class("CObject")
local _private = setmetatable({}, {__mode = "k"})

local _tableFind = function(tbl, value)
    for i, v in pairs(tbl) do
        if v == value then return i end
    end
end

local _tableRemove = function(tbl, value)
    table.remove(tbl, _tableFind(tbl, value))
end

function CObject:initialize(parent)
    assert(instanceOf(CObject, parent) or parent == nil, "parent must be CObject or nil")
    
    _private[self] = {
        parent = parent,
        children = CList(),
        name = ""
    }
    
    if parent then
        _private[parent].children:insert(self) -- backref from parent
    end
end

function CObject:children() return _private[self].children:copy() end

function CObject:objectName() return _private[self].name end

function CObject:parent() return _private[self].parent end

function CObject:setObjectName(name) _private[self].name = name end

function CObject:setParent(parent)
    assert(instanceOf(CObject, parent) or parent == nil, "parent must be CObject or nil")
    
    if _private[self].parent then
        local pChildren = _private[_private[self].parent].children
        pChildren:remove(pChildren:find(self))
    end
    
    _private[self].parent = parent
    
    if parent then
        _private[parent].children:insert(self) -- backref from parent
    end
end
