return function(url)
    local cydia = url:gmatch("cydia.saurik.com/package/(.+)/")()
    cydia = cydia or url:gmatch("cydia.saurik.com/package/(.+)")()
    if cydia then 
        return "cydia://package/" .. cydia
    end
end