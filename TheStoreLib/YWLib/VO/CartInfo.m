//
//  CartInfo.m
//  TheStoreApp
//
//  Created by LinPan on 14-1-21.
//
//

#import "CartInfo.h"
#import "PromotionInfo.h"
@implementation CartInfo

- (void)dealloc
{
    [_productList release];
    [_promotionList release];
    [super dealloc];
}

- (BOOL)hasGift
{
    for (PromotionInfo *promotion in _promotionList)
    {
        NSInteger type;
        if  (promotion.promotionType > 0)
        {
            type = promotion.promotionType;
        }
        else
        {
            type = promotion.promotionCategory;
        }
        
        
        if (type == kYaoPromotion_MEZ ||
            type == kYaoPromotion_MJZ ||
            type == kYaoPromotion_MZ)
        {
            return YES;
        }
    }
    
    return NO;
}

- (NSMutableArray *)getPromotionOfReduce
{
    NSMutableArray *resultArr = [[[NSMutableArray alloc] init] autorelease];
    for (PromotionInfo *promotion in _promotionList)
    {
        NSInteger type = promotion.promotionType;
        if (type <= 0)
        {
            type = promotion.promotionCategory;
        }
        
        if (type == kYaoPromotion_MJ ||
            type == kYaoPromotion_MJJ ||
            type == kYaoPromotion_MEJ)
        {
            [resultArr addObject:promotion];
        }
    }
    
    return resultArr;
}

- (NSMutableArray *)getPromotionOfGift
{
    NSMutableArray *resultArr = [[[NSMutableArray alloc] init] autorelease];
    for (PromotionInfo *promotion in _promotionList)
    {
        
        NSInteger type = promotion.promotionType;
        if (type <= 0)
        {
            type = promotion.promotionCategory;
        }
        
        if (type == kYaoPromotion_MZ ||
            type == kYaoPromotion_MJZ ||
            type == kYaoPromotion_MEZ)
        {
            [resultArr addObject:promotion];
        }
    }
    
    return resultArr;
}
@end
