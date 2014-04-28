//
//  MobilePromotionDetailVO.m
//  TheStoreApp
//
//  Created by towne on 13-1-14.
//
//

#import "MobilePromotionDetailVO.h"

@implementation MobilePromotionDetailVO

@synthesize pageProductVOList;
@synthesize conditionValue;

-(void)dealloc
{
    OTS_SAFE_RELEASE(pageProductVOList);
    OTS_SAFE_RELEASE(conditionValue);
    [super dealloc];
}

@end
