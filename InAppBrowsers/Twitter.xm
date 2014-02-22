#import "../L2ALuaBinding.h"

@interface UIApplication
+(id)sharedApplication;
- (BOOL)openURL:(NSURL*)url;
@end

%hook T1WebViewController
- (BOOL)shouldStartLoadWithURL:(NSURL*)fp8 navigationType:(int)fp12
{
    //NSLog(@"L2A: startLoadWithURL: %@", fp8);
    NSString *url = fp8.absoluteString; // convert the NSURL into an NSString for easy manipulation
    if ([url hasPrefix:@"https://t.co"] == NO) // all twitter links seem to convert into a t.co, so we shall ignore those
    {
        L2ALuaBinding *lua = [[L2ALuaBinding alloc] init];
        NSString *newUrl = [lua modify:url];
        if (![newUrl isEqualToString:url])
        {
            [[%c(UIApplication) sharedApplication] openURL:[NSURL URLWithString:newUrl]];
        }
    }
    return %orig;
}
%end