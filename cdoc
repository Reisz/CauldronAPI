local args = {...}

-- help handler
if args[1] == "-h" or args[1] == "--help" then
    print("Usage: cdoc from [to]")
    print("from: Directory of the sources.")
    print("to:   Directory for the documentation.")
    print("      Defaults to: doc")
    print("Both are realtive to the current directory.")
    return
end

-- functions
local function split(s, split)
    local result, current = {}, {}
    local bytes = {s:byte(1, #s)}

    for _, v in ipairs(bytes) do
        if v == split then
            local new = string.char(unpack(current))
            if #new > 0 then table.insert(result, new) end
            current = {}
        else
            table.insert(current, v)
        end
    end

    local new = string.char(unpack(current))
    if #new > 0 then table.insert(result, new) end

    return result
end

local function printTable(tbl, depth, prefix) -- debug
    prefix = prefix or ""
    if depth == 0 then return end
    for i,v in pairs(tbl) do
        if type(v) == "table" then
            print(prefix, "[", i, "] = ", tostring(v))
            printTable(v, depth and depth - 1, prefix .. "  ")
        else
            print(prefix, "[", i, "] = ", tostring(v))
        end
    end
end

-- code
local from, to = shell.resolve(args[1]), shell.resolve(args[2] or "doc")

if not fs.exists(to) then
    fs.makeDir(to)
else
    print("Cleaning up target...")
    for _, v in ipairs(fs.list(to)) do
        fs.delete(fs.combine(to, v))
    end
end


print("Scanning files...")
local doc = fs.open(fs.combine(to, "_doc"), "w")

local function scanDir(dir)
    for _, v in ipairs(fs.list(dir)) do
        v = fs.combine(dir, v); print("  ", v)
        if fs.isDir(v) then
            scanDir(v)
        else
            local file = fs.open(v, "r")
            if not file then print("Error opening " .. string.format("%q", v)) end
            file.readAll():gsub("\n--!([^~][^\n]*\n)", doc.write)
            file.close()
        end
    end
end

scanDir(from)
doc.close()


print("Indexing input...")
doc = fs.open(fs.combine(to, "_doc"), "r")

local current = {}
local classes, values = {}, {}
local index, modules, default = {}, {}, {}
modules[default] = {}

local function module(m)
    local module = modules[m]
    if not module then
        modules[m] = {}
        module = modules[m]
    end
    return module
end

local function addDesc(desc)
    if not current.desc then current.desc = desc; return end
    current.desc = current.desc .. "\n" .. desc
end

local function parseAnchor(line, ref)
    local anchor = line:match("@(.+)$")
    if anchor then
        index[anchor] = ref
        line = line:sub(1, line:find("@(.+)$") - 1)
    end
    return line
end


local function parseClassDef(line)
    local parts = split(line, string.byte(" "))
    
    -- class name
    local name = parts[1]
    classes[name] = current
    print("  class ", parts[1])
    table.remove(parts, 1)
    
    -- super class
    if parts[1] == "extends" then
        table.remove(parts, 1)
        current.super = parts[1]
        table.remove(parts, 1)
    end
    
    -- mixin support TODO
    
    -- module
    if parts[1] == "module" then
        table.remove(parts, 1)
        module(parts[1])[name] = current
        table.remove(parts, 1)
    else
        modules[default][name] = current
    end
end

local function parseValueDef(line)
    local parts = split(line, string.byte(" "))
    
    -- type
    current.type = parts[1]
    table.remove(parts, 1)
    
    -- name
    values[parts[1]] = current
    table.remove(parts, 1)
    
    -- class
    if parts[1] == "class" then
        table.remove(parts, 1)
        current.class = parts[1]
        table.remove(parts, 1)
    end
end

local function parse(line, nr)
    if not line then return end
    local res
    
    -- class
    res = line:match("^!class%s+(.+)$")
    if res then
        current = {properties = {}, values = {}, subclasses = {}}
        res = parseAnchor(res, current)
        parseClassDef(res)
        return parse(doc.readLine(), nr + 1)
    end
    
    -- value
    res = line:match("^!value%s+(.+)$")
    if res then
        current = {properties = {}}
        res = parseAnchor(res, current)
        parseValueDef(res)
        return parse(doc.readLine(), nr + 1)
    end
    
    -- property
    local value
    res = line:match("^$(%w+)")
    if res then
        value = line:match("%s(.+)$") or ""
        current.properties[res] = value
        return parse(doc.readLine(), nr + 1)
    end
    
    -- description
    addDesc(line)
    return parse(doc.readLine(), nr + 1)
end

local success, value = pcall(parse, doc.readLine(), 1)
doc.close()

-- assign values
for i, v in pairs(values) do
    if v.class then
        if not classes[v.class] then print("! Could not find class ", v.class)
        else classes[v.class].values[i] = v end
    else
        default[i] = v
    end
    v.class = nil
end
values = nil

-- assign classes
for i, v in pairs(classes) do
    if v.super then
        if not index[v.super] then print("! Could not find class ", v.super)
        else
            v.superRef = index[v.super]
            index[v.super].subclasses[i] = v
        end
    end
end
