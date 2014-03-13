--[[
Taken and combined with URL information from an email

We did not release any documentation for the url scheme yet, but that is really a good idea. Anyway, here is a list of the most used urls:

foap://app/user?uuid=ecc5e76ce434428f97665502f8392561
foap://app/user?username=knutigro
- https://www.foap.com/community/profiles/janin8
- https://www.foap.com/community/profiles/sadiekimble

foap://app/explore
foap://app/explore?tags=surf
- https://www.foap.com/market/tags/sky

foap://app/photo?uuid=5d265013693f467ab450d5f063b366c5
- https://www.foap.com/market/photos/537b4856bad34e1e8c2cf71d051218f1

foap://app/mission?uuid=c12b26020747425ca884d3482390abcf
foap://app/missions
- foap doesn't use the uuid in the title, just the mission name...

foap://app/brand?uuid=5a39df0d25994851878147a4c8f47200
]]

return function(url)
    local username = url:gmatch("foap.com/community/profiles/(.+)")() -- extract username
    local tag      = url:gmatch("foap.com/market/tags/(.+)")()
    local photo    = url:gmatch("foap.com/market/photos/(.+)")()
    if username then
        return "foap://app/user?username=" .. username
    elseif tag then
        return "foap://app/explore?tags=" .. tag
    elseif photo then
        return "foap://app/photo?uuid=" .. photo
    end
end