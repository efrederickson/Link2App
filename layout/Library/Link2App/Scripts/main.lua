local functions = { }

--print"loading plugins"
for file in lfs.dir"/Library/Link2App/Scripts/" do
    --print("considering " .. file)
    --if lfs.attributes(file,"mode")== "file" then
        if file ~= '.' and file ~= '..' and file ~= 'main.lua' then
            local tbl = dofile("/Library/Link2App/Scripts/" .. file)
            print("loading file " .. "/Library/Link2App/Scripts/" .. file)
            if tbl then
                --print("file loaded!")
                table.insert(functions, tbl)
            else
                print("failed to load file :(")
            end
        end
    --end
end

io = nil
os.execute = nil
lfs = nil
-- todo: blacklist only bad lfs functions

return function(str)
    --print(str)
    for k, v in pairs(functions) do
        local mod = v(str)
        --print("mod: " .. mod)
        if mod and mod ~= str then return mod end
    end
    return str
end