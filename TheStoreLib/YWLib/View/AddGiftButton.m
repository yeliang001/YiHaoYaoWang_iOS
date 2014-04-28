//
//  AddGiftButton.m
//  TheStoreApp
//
//  Created by LinPan on 14-1-22.
//
//

#import "AddGiftButton.h"

@implementation AddGiftButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        [self setTitle:@"领取赠品" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -90, 0, 90)];
        
        UIImageView *accesseryIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow_right.png"]];
        accesseryIv.frame = CGRectMake(300, 13, 9, 13);
        [self addSubview:accesseryIv];
        [accesseryIv release];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-1, frame.size.width, 1)];
        [lineView setBackgroundColor: [UIColor colorWithString:@"#e5e5e5"]];
        [self addSubview: lineView];
        [lineView release];
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
