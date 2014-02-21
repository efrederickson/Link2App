return function(url)
    if url:sub(1, 7) == 'mailto:' then
        local ret = "googlegmail://co?to="
        url = url:sub(8)
        local to = url:gmatch("(.-)%?")()
        if not to then
            return ret .. url
        end
        ret = ret .. to
        local other = url:gmatch("%?(.+)")()
        --print(other)
        return ret .. "&" .. other
    end
end