return function(url)
    local imdb = url:gmatch("imdb.com/title/([^/]+)/")()
    if imdb then
        return "imdb://title/" .. imdb
    end
end