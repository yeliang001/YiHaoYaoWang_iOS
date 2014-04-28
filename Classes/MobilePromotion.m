//
//  MobilePromotion.m
//  TheStoreApp
//
//  Created by towne on 12-11-23.
//
//

#import "MobilePromotion.h"

@implementation MobilePromotion

@synthesize promotionGiftList;
@synthesize cashPromotionList;
@synthesize redemptionList;
@synthesize offerPromotionList;

-(void)dealloc
{
    OTS_SAFE_RELEASE(promotionGiftList);
    OTS_SAFE_RELEASE(cashPromotionList);
    OTS_SAFE_RELEASE(redemptionList);
    OTS_SAFE_RELEASE(offerPromotionList);
    [super dealloc];
}

@end
