#import <Preferences/Preferences.h>

@interface L2ASettingsListController: PSListController {
}
@end

@implementation L2ASettingsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"L2ASettings" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
