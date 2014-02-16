return function(url)
    if url:sub(1, 5) == 'http:' then
        return "googlechrome:" .. url:sub(6)
    end
    if url:sub(1, 6) == 'https:' then
        return "googlechromes:" .. url:sub(7)
    end
end