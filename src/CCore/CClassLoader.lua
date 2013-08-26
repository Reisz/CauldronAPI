CClassLoader = class("CClassLoader")
C_ENUM(CClassLoader, "Type", CEnum{"Cauldron", "Application"})

function CClassLoader.static.prepare(name, tpe, module)
    _G[name] = CClassLoader.getLoader(name, tpe, module)
end

function CClassLoader.static.getLoader(name, tpe, module)
    return function(...)
        CClassLoader.load(name, tpe, module)
        return _G[name](...)
    end
end

function CClassLoader.static.load(name, tpe, module)
    tpe = tpe or CClassLoader.Application
    module = module or ""
    if tpe == CClassLoader.Cauldron then
        shell.run(Cauldron.libraryPath(module .. "/" .. name .. ".lua"))
    elseif tpe == CClassLoader.Application then
        shell.run(CCoreApplication.applicationDirPath() .. module .. "/" .. name .. ".lua")
    end
end