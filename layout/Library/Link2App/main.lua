local PLUGINS = "/Library/Link2App/Scripts/"

local functions = { }
local enabled = { }

for line in io.lines("/Library/Link2App/selected_scripts") do 
    -- also allows for ordering of plugins
    -- and comments for lines starting with #
    if line:sub(1, 1) ~= '#' and line:len() > 0 then
        enabled[line] = true

        --print("Loading file: " .. PLUGINS .. line)
        local result, func = pcall(dofile, PLUGINS .. line)
        if result and func then
            table.insert(functions, func)
        else
            print("Error loading script: " .. func)
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