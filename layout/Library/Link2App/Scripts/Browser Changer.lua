-- Browser changer (Safari -> Google Chrome)
-- rpetrich has a list of "mappings" for different browsers.
-- You can use that file to change this to redirect to your preferred browser
--https://github.com/rpetrich/BrowserChooser/blob/master/layout/Library/Application%20Support/BrowserChooser/mapping.plist

return function(url)
    if url:sub(1, 5) == 'http:' then
        return "googlechrome:" .. url:sub(6)
    end
    if url:sub(1, 6) == 'https:' then
        return "googlechromes:" .. url:sub(7)
    end
end