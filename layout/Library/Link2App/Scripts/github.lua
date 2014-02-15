return function(url)
    local isGH = url:gmatch("http[s](://github%.com.*)")()
    if isGH then
        return "ioc" .. isGH
    end
end