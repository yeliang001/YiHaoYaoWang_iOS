//
//  ConditionInfo.m
//  TheStoreApp
//
//  Created by LinPan on 14-1-8.
//
//

#import "ConditionInfo.h"


//促销时的促销条件
@implementation ConditionInfo


- (NSString *)promotionStringByPromotionType:(kYaoPromotionType)type
{
    switch (type)
    {
        case kYaoPromotion_MEJ:
            return [NSString stringWithFormat:@"满%d元减%d元",_requirement,_reward];

        case kYaoPromotion_MEZ:
            return [NSString stringWithFormat:@"满%d元赠%d件,赠完为止",_requirement,_reward];

        case kYaoPromotion_MJZ:
            return [NSString stringWithFormat:@"满%d件赠%d件,赠完为止",_requirement,_reward];
        case kYaoPromotion_MJJ:
            return [NSString stringWithFormat:@"满%d件减%d元",_requirement,_reward];
        default:
            break;
    }
    
    return nil;
}

- (NSString *)promotionFlagByPromotionType:(kYaoPromotionType)type
{
    switch (type)
    {
        case kYaoPromotion_MEZ:case kYaoPromotion_MJZ:
            return @"赠";
            
        case kYaoPromotion_MEJ:case kYaoPromotion_MJJ:
            return @"减";
        default:
            break;
    }
    
    return nil;
}

@end
