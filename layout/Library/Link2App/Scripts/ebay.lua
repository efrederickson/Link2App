return function(url)
    local item = url:gmatch("ebay.com/itm/[^/]+/(%d+)")()
    local search = url:gmatch("ebay.com/sch/[^&]+&_nkw=([%w_+]+)")()
    if item then
        return "ebay://launch?itm=" .. item
    elseif search then
        return "ebay://sch/i.html?_nkw=" .. search
    end
end