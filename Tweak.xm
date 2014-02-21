#import "L2ALuaBinding.h"

static L2ALuaBinding *lua;

static void reloadScripts(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    NSLog(@"L2A: reloading scripts");
    lua = nil;
    lua = [[L2ALuaBinding alloc] init];
}

%hook UIApplication
- (BOOL)openURL:(NSURL*)url
{
    NSString *newUrl = [lua modify:[url absoluteString]];
    NSLog(@"L2A: openUrl %@ -> %@", url, newUrl);
    return %orig([NSURL URLWithString:newUrl]);
}
- (BOOL)canOpenURL:(NSURL*)url
{
    NSString *newUrl = [lua modify:[url absoluteString]];
    NSLog(@"L2A: openUrl %@ -> %@", url, newUrl);
    return %orig([NSURL URLWithString:newUrl]);
}
%end

%ctor
{
    lua = [[L2ALuaBinding alloc] init];

    CFNotificationCenterRef r = CFNotificationCenterGetDarwinNotifyCenter();
    CFNotificationCenterAddObserver(r, NULL, &reloadScripts, (CFStringRef)@"com.efrederickson.link2app/reloadScripts", NULL, 0);
}