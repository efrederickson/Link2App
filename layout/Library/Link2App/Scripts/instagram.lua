--[[ example instagram urls for testing purposes
instagram.com/p/i405DYCXTI
http://instagram.com/p/j8OC5kEcEM/
instagram.com/sudsak
]]

return function(url)
    local username = url:gmatch("instagram.com/([%w_]+)")() -- extract username
    local statusid = url:gmatch("instagram.com/p/(%w+)")()
    if username and not statusid then
        return "instagram://user?username=" .. username
    elseif statusid then
        return "instagram://media?id=" .. statusid
    end
end