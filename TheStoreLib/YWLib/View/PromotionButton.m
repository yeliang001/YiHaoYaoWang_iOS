//
//  PromotionButton.m
//  TheStoreApp
//
//  Created by LinPan on 14-1-15.
//
//

#import "PromotionButton.h"
#import "ConditionInfo.h"
#import "PromotionInfo.h"
@implementation PromotionButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame promotion:(PromotionInfo *)promotion condition:(ConditionInfo *)condition
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.promotion = promotion;
        self.condition = condition;
        
        
        
        [self setBackgroundColor:[UIColor colorWithString:@"fffccc"]];
        CALayer *layer = [self layer];
        [layer setBorderWidth:1.0];
        [layer setBorderColor:[UIColor whiteColor /*colorWithString:@"D9D9D9"*/].CGColor];
        
        NSString *title = [condition promotionStringByPromotionType:promotion.promotionType];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithString:@"a4a4a4"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        
        UIImageView *accesseryIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow_right.png"]];
        accesseryIv.frame = CGRectMake(280, 13, 9, 13);
        [self addSubview:accesseryIv];
        [accesseryIv release];
        
        UIButton *promotionIcon = [UIButton buttonWithType:UIButtonTypeCustom];
//        promotionIcon.backgroundColor = [UIColor redColor];
//        [promotionIcon setTitle:[condition promotionFlagByPromotionType:promotion.promotionType] forState:UIControlStateNormal];
//        promotionIcon.titleLabel.textColor = [UIColor whiteColor];
        promotionIcon.frame = CGRectMake(10, 7, 26, 26);
        promotionIcon.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        
        
        switch (promotion.promotionType)
        {
            case kYaoPromotion_MEZ:case kYaoPromotion_MJZ:
                [promotionIcon setBackgroundImage:[UIImage imageNamed:@"zeng30.png"] forState:UIControlStateNormal];
                break;
                
            case kYaoPromotion_MEJ:case kYaoPromotion_MJJ:
                [promotionIcon setBackgroundImage:[UIImage imageNamed:@"jian30.png"] forState:UIControlStateNormal];
                break;

            default:
                break;
        }
        
        
        [self addSubview:promotionIcon];
    }
    
    return self;
}

- (void)dealloc
{
    [_promotion release];
    [_condition release];
    [super dealloc];
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
