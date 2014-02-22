#import <UIKit/UIKit.h>
#import "L2AScript.h"

@class L2AScript;

@interface L2ATableViewCell : UITableViewCell
@property (nonatomic, retain) UILabel *orderLabel;
@property (nonatomic, assign) L2AScript *script;
@end