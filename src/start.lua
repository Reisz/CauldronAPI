shell.run("Cauldron")
term.setTextColor(colors.lightGray)
print(Cauldron, " loaded")
if fs.exists("cstart") and not fs.isDir("cstart") then
    term.setTextColor(colors.white)
    shell.run("cstart")
end
