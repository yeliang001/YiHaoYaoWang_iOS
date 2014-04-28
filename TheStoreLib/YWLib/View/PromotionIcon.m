//
//  PromotionIcon.m
//  TheStoreApp
//
//  Created by LinPan on 14-1-20.
//
//

#import "PromotionIcon.h"
#import "YWConst.h"
@implementation PromotionIcon

- (id)initWithFrame:(CGRect)frame promitionType:(kYaoPromotionType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        [self setTitle:[self promotionFlagByPromotionType:type] forState:UIControlStateNormal];
//        self.titleLabel.textColor = [UIColor whiteColor];
        self.frame = CGRectMake(CGRectGetMinX(frame),CGRectGetMinY(frame), 20, 20);
//        self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        
        
        switch (type)
        {
            case kYaoPromotion_MEZ:case kYaoPromotion_MJZ:case kYaoPromotion_MZ:
                [self setBackgroundImage:[UIImage imageNamed:@"zeng24.png"] forState:UIControlStateNormal];
                break;
                
            case kYaoPromotion_MEJ:case kYaoPromotion_MJJ:case kYaoPromotion_MJ:
                [self setBackgroundImage:[UIImage imageNamed:@"jian24.png"] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        
    }
    return self;
}
- (NSString *)promotionFlagByPromotionType:(kYaoPromotionType)type
{
    switch (type)
    {
        case kYaoPromotion_MEZ:case kYaoPromotion_MJZ:case kYaoPromotion_MZ:
            return @"赠";
            
        case kYaoPromotion_MEJ:case kYaoPromotion_MJJ:case kYaoPromotion_MJ:
            return @"减";
        default:
            break;
    }
    
    return nil;
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
