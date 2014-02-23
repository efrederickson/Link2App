#import "L2ALuaBinding.h"

@interface UIApplication
+(id)sharedApplication;
- (BOOL)openURL:(NSURL*)url;
@end

static L2ALuaBinding *lua;
static BOOL overrideTwitter = YES;
static BOOL enabled = YES;

static void reloadScripts(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    NSLog(@"L2A: reloading scripts");
    [lua disposeOfLua];
    [lua createNewLua];

    NSDictionary *prefs = [NSDictionary 
        dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.efrederickson.link2app.settings.plist"];
    
    if ([prefs objectForKey:@"enabled"] != nil)
        enabled = [[prefs objectForKey:@"enabled"] boolValue];
    else
        enabled = YES;

    if ([prefs objectForKey:@"overrideTwitter"] != nil)
        overrideTwitter = [[prefs objectForKey:@"overrideTwitter"] boolValue];
    else
        overrideTwitter = YES;
}

%hook UIApplication
- (BOOL)openURL:(NSURL*)url
{
    if (enabled)
    {
        NSString *newUrl = [lua modify:[url absoluteString]];
        //NSLog(@"L2A: openUrl %@ -> %@", url, newUrl);
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

// IN-APP OVERRIDES
%hook T1WebViewController
- (BOOL)shouldStartLoadWithURL:(NSURL*)fp8 navigationType:(int)fp12
{
    NSString *url = fp8.absoluteString; // convert the NSURL into an NSString for easy manipulation
    if (enabled && overrideTwitter && [url hasPrefix:@"https://t.co"] == NO) // all twitter links seem to convert into a t.co, so we shall ignore those
    {
        lua = [[L2ALuaBinding alloc] init];
        NSString *newUrl = [lua modify:url];
        if (![newUrl isEqualToString:url])
        {
            [[%c(UIApplication) sharedApplication] openURL:[NSURL URLWithString:newUrl]];
        }
    }
    return %orig;
}
%end