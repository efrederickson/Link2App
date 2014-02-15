local functions = { }
local enabled = { }

for line in io.lines("/Library/Link2App/selected_scripts") do
    enabled[line] = true
end

--print"loading plugins"
for file in lfs.dir"/Library/Link2App/Scripts/" do
    --print("considering " .. file)
    if file:sub(-4) == '.lua' and enabled[file] then
        local tbl = dofile("/Library/Link2App/Scripts/" .. file)
        print("loading file " .. "/Library/Link2App/Scripts/" .. file)
        if tbl then
            --print("file loaded!")
            table.insert(functions, tbl)
        else
            print("failed to load file :(")
        end
    end
end

-- block some "dangerous" stuff
io = nil
os.execute = nil
os.exit = nil
os.setlocale = nil
os.remove = nil
os.tmpname = nil
os.rename = nil
package = nil
lfs = nil
require = nil
-- todo: blacklist only bad lfs functions

return function(str)
    --print(str)
    for k, v in pairs(functions) do
        local mod = v(str)
        --print("mod: " .. mod)
        if mod and mod ~= str and mod:len() > 0 then return mod end
    end
    return str
end