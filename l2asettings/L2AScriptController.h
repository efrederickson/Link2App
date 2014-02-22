/*
Stolen, with shame, and modified from Cylinder, therefore it's probably under the GPL
 */

#import <Preferences/PSViewController.h>
#import "L2AScript.h"

@interface L2AScriptController : PSViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView *_tableView;
	NSMutableArray *_scripts;
    NSMutableArray *_selectedScripts;
    BOOL _initialized;
}
@property (nonatomic, retain) NSMutableArray *scripts;
@property (nonatomic, retain) NSMutableArray *selectedScripts;
- (id)initForContentSize:(CGSize)size;
- (id)view;
- (NSString*)navigationTitle;
- (void)refreshList;
@end