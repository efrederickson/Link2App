return function(url)
    local imdb = url:gmatch("imdb.com/title/([^/]+)/")()
    return "imdb://title/" .. imdb
end