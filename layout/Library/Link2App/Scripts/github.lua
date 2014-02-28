return function(url)
    local isGH = url:gmatch("(github%.com.*)")()
    if isGH then
        return "ioc://" .. isGH
    end
end