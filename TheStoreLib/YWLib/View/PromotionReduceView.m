//
//  PromotionReduceView.m
//  TheStoreApp
//
//  Created by LinPan on 14-1-21.
//
//

#import "PromotionReduceView.h"
#import "PromotionIcon.h"
@implementation PromotionReduceView

- (id)initWithFrame:(CGRect)frame promotionDesc:(NSString *)desc promotionResult:(NSString *)result
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        PromotionIcon *promotionIcon = [[PromotionIcon alloc] initWithFrame:CGRectMake(10, 10, 18, 18) promitionType:kYaoPromotion_MJ];
        [self addSubview:promotionIcon];
        [promotionIcon release];
        
        UILabel *promotionDescLbl = [[UILabel alloc] initWithFrame:CGRectMake(38, 5, 320 - 38, 15)];
        promotionDescLbl.backgroundColor = [UIColor clearColor];
        promotionDescLbl.font = [UIFont systemFontOfSize:13];
        promotionDescLbl.text = desc;
        [self addSubview:promotionDescLbl];
        [promotionDescLbl release];
        
        UILabel *promotionResultLbl = [[UILabel alloc] initWithFrame:CGRectMake(38, 23, 320-38, 15)];
        promotionResultLbl.backgroundColor = [UIColor clearColor];
        promotionResultLbl.font = [UIFont systemFontOfSize:11];
        promotionResultLbl.text = result;
        promotionResultLbl.textColor = [UIColor redColor];
        [self addSubview:promotionResultLbl];
        [promotionResultLbl release];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-1, frame.size.width, 1)];
        [lineView setBackgroundColor:[UIColor colorWithString:@"#E5E5E5"]];
        [self addSubview:lineView];
        [lineView release];
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
    // Drawing code
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    CGContextMoveToPoint (context, 0, rect.size.height);
//    CGContextAddLineToPoint (context, rect.size.width, rect.size.height);
//    CGContextAddLineToPoint (context, 160, 150);
    
    // Closing the path connects the current point to the start of the current path.
//    CGContextClosePath(context);
    // And stroke the path
//    [[UIColor lightGrayColor] setStroke];
//}


@end
