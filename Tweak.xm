#import "L2ALuaBinding.h"

static L2ALuaBinding *lua;
static BOOL enabled = YES;

static void reloadScripts(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    NSLog(@"L2A: reloading scripts");
    lua = nil;
    lua = [[L2ALuaBinding alloc] init];

    NSDictionary *prefs = [NSDictionary 
        dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.efrederickson.link2app.settings.plist"];
    
    if ([prefs objectForKey:@"enabled"] != nil)
        enabled = [[prefs objectForKey:@"enabled"] boolValue];
    else
        enabled = YES;
}

%hook UIApplication
- (BOOL)openURL:(NSURL*)url
{
    if (enabled)
    {
        NSString *newUrl = [lua modify:[url absoluteString]];
        //if (url != newUrl)
        //    NSLog(@"L2A: openUrl %@ -> %@", url, newUrl);
        return %orig([NSURL URLWithString:newUrl]);
    }
    else
        return %orig;
}
- (BOOL)canOpenURL:(NSURL*)url
{
    if (enabled)
    {
        NSString *newUrl = [lua modify:[url absoluteString]];
        //if (url != newUrl)
        //    NSLog(@"L2A: canOpenUrl %@ -> %@", url, newUrl);
        return %orig([NSURL URLWithString:newUrl]);
    }
    else
        return %orig;
}
%end

%ctor
{
    lua = [[L2ALuaBinding alloc] init];

    CFNotificationCenterRef r = CFNotificationCenterGetDarwinNotifyCenter();
    CFNotificationCenterAddObserver(r, NULL, &reloadScripts, (CFStringRef)@"com.efrederickson.link2app/reloadScripts", NULL, 0);
}