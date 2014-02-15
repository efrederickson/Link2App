#import "L2ALuaBinding.h"

static L2ALuaBinding *lua;

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
}