#import "L2ATableViewCell.h"

// Based off of some cylinder code...

#define MARGIN 0
#define IMAGE_PADDING 10

@implementation L2ATableViewCell
@synthesize orderLabel=_orderLabel, script=_script;
    
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _orderLabel = [[UILabel alloc] init];
        _orderLabel.font = [_orderLabel.font fontWithSize:16];
        _orderLabel.textColor = [UIColor colorWithRed:0.1 green:.3 blue:0.7 alpha:1];
        _orderLabel.backgroundColor = UIColor.clearColor;
    }
    return self;
}
    
- (void) layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.contentView.frame;
    CGFloat width = 44;
    self.imageView.frame = CGRectMake(IMAGE_PADDING, IMAGE_PADDING, width - IMAGE_PADDING*2, frame.size.height-1 - IMAGE_PADDING*2);
    self.textLabel.frame = CGRectMake(width + MARGIN, self.textLabel.frame.origin.y, frame.size.width - width*2 - 2*MARGIN, self.textLabel.frame.size.height);
    self.detailTextLabel.frame = CGRectMake(width + MARGIN, self.detailTextLabel.frame.origin.y, frame.size.width - width*2 - 2*MARGIN, self.detailTextLabel.frame.size.height);
    self.orderLabel.frame = CGRectMake(self.frame.size.width - 44, self.textLabel.frame.origin.y, 44, 44);
    [self addSubview:self.orderLabel];
}
@end