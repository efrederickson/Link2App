return function(url)
    local numberedVineUser = url:gmatch("vine.co/u/(.+)")()
    if numberedVineUser then 
        return "vine://user/" .. numberedVineUser
    end
end

--[[
Other known URL types include:
vine://user-id/
vine://tw/user/
vine://post/
vine://tag/

-user, tw/user, user-id are all function the same from what i can tell?
-tag will search hashtags, though i dont believe the user will encounter a web URL like this
-post will link directly to a post, given the correct post "ID", which isn't in the URL
	but rather under the meta tag "twitter:app:url:iphone"
-this will not work for users that have their own page, with a custom name, as its not numbered.
-there are some more URLs button they dont seem to do anything, so i wont bother listing them

]]
