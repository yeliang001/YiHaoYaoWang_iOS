//
//  GiftView.m
//  TheStoreApp
//
//  Created by LinPan on 14-1-16.
//
//

#import "GiftView.h"
#import "GiftInfo.h"
#import "SDImageView+SDWebCache.h"
@implementation GiftView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame gift:(GiftInfo *)gift
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor: [UIColor clearColor]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(frame), CGRectGetHeight(frame))];
        [self addSubview:imageView];
        [imageView release];
        [imageView setImageWithURL:[NSURL URLWithString: gift.giftImageStr]];
        UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetHeight(frame)+10, 10, CGRectGetWidth(frame)-CGRectGetHeight(frame)-10, CGRectGetHeight(frame)-20)];
        [nameLbl setBackgroundColor:[UIColor clearColor]];
        nameLbl.numberOfLines = 0;
        nameLbl.lineBreakMode = UILineBreakModeWordWrap;
        
        nameLbl.font = [UIFont systemFontOfSize:13];
        
        [self addSubview:nameLbl];
        [nameLbl release];
        
        NSString *nameStr;
        if (gift.quantity == 0)
        {
            nameStr = [NSString stringWithFormat:@"已赠完:%@",gift.giftName];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:nameStr];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,4)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(4,nameStr.length-4)];
            nameLbl.attributedText = str;
            [str release];
        }
        else
        {
             nameStr = [NSString stringWithFormat:@"赠:%@",gift.giftName];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:nameStr];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,2)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(2,nameStr.length-2)];
            nameLbl.attributedText = str;
            [str release];
        }
        
       
        
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
