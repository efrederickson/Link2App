#import <UIKit/UIKit.h>
#import "L2ATableViewCell.h"

@class L2ATableViewCell;

@interface L2AScript : NSObject
@property (nonatomic, assign) L2ATableViewCell *cell;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *directory;
@property (nonatomic, assign, getter=isSelected) BOOL selected;
    
+ (L2AScript *)scriptWithPath:(NSString*)path;
- (id)initWithPath:(NSString*)path;
@end