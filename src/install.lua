local args = {...}

if args[1] == "-h" or args[1] == "--help" then
    print "Usage: install [OPTIONS]"
    print "OPTIONS: -s <y/n> or --startup <YES/no>"
    print "            Install startup script."
    print "         -d DIR or --direcoty DIR"
    print "            Use DIR as target directory."
    print "         --doc <y/n> / <YES/no>"
    print "            Keep documentation comments."
    return
end

-- prepare environment
local version, vstring = -1, "PreAlpha"
local thisProgram = shell.getRunningProgram()
local source, dir = string.sub(thisProgram, 1, #thisProgram - #string.match(thisProgram, "/[^/]+$") + 1)
local startup, doc

shell.setDir("")

while #args > 0 do
    if args[1] == "-s" or args[1] == "--startup" then table.remove(args, 1)
        if args[1] == "n" or args[1] == "N" or args[1] == "no" then startup = false
        else startup = true end
		
    elseif args[1] == "-d" or args[1] == "--directory" then table.remove(args, 1)
        local input = args[1]
        if input then
			dir = shell.resolve(input)
			if input ~= dir or dir == "Cauldron" then dir = nil end
		end
		
    elseif args[1] == "--doc" then table.remove(args, 1)
        if args[1] == "n" or args[1] == "N" or args[1] == "no" then doc = false
        else doc = true end end
		
    table.remove(args, 1)
end 

local function install(name)
    from, to = source .. name, dir .. name
	if fs.exists(to) then fs.delete(to) end
    fs.copy(from, to)
end

local function advancedInput(message, default)
    if type(default) ~= "string" then default = "" end

    local _, y = term.getCursorPos()
    term.clearLine()
    term.setCursorPos(1, y)
    term.write(message)
    
    local input = default
    while true do
        term.clearLine()
        term.setCursorPos(1, y)
        term.write(message)
        term.write(input)

        local e, p = os.pullEvent()
        if e == "char" then
            input = input .. p
        elseif e == "key" then
            if p == 14 then -- backspace
                input = string.sub(input, 1, #input - 1)
            elseif p == 28 then -- enter
				term.setCursorPos(1, y + 1)
                return input
            end
        end
    end
end

-- prepare terminal
term.setTextColor(colors.white)
term.setBackgroundColor(colors.black)

-- user interaction
if not dir then
    local input = advancedInput("Choose an install path > ", "CLibs")
    dir = shell.resolve(input)
    while #input == 0 or input ~= dir or dir == "Cauldron" do -- make sure that the input can be used
        write("Invalid Path!\n")
		local _, y = term.getCursorPos()
		term.setCursorPos(1, y - 2)
        input = advancedInput("Choose an install path > ", "CLibs")
        dir = shell.resolve(input)
    end
end

if not startup then
    local ans = advancedInput("Install the startup script <Y/n> ")
    if ans == "n" or ans == "N" then startup = false else startup = true end
end

-- install
write("\nStarting setup...\n\n")
fs.makeDir(dir)
if not string.find(dir, "^/") then dir = "/" .. dir end
if not string.find(dir, "/$") then dir = dir .. "/" end

write("Cauldron")
    local fileC = fs.open("Cauldron", "w")
    local fileM = fs.open(source .. "main.lua", "r")

    if not fileC or not fileM then
        write('\nFailed to open the file "Cauldron", setup will exit now.\n')
        return
    end
    
    fileC.write(string.format(fileM.readAll(), version, vstring, dir))
    fileC.close(); fileM.close()
write(". ok\n")

write("Loader")
	install("middleclass.lua"); write(".")
	install("CEnum.lua"); write(".")
    if startup then
        if fs.exists("startup") then fs.delete("startup") end
        fs.copy(source .. "start.lua", "startup")
        write(".")
    end
write(" ok\n")

write("Modules")
    install("CCore"); write(".")
write(" ok\n")

write("Applications")
    install("CApps");
    local fileC = fs.open("Cauldron", "a")
    for _, v in ipairs(fs.list(dir .. "CApps")) do
        fileC.writeLine('shell.setAlias("' .. v .. '", "/' .. dir .. 'CApps/' .. v .. '/main.lua")')
        write(".")
    end
    fileC.close()
write(" ok\n")

write("\nFinished installation!\n")
