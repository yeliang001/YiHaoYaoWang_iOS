//
//  MobilePromotionVO.m
//  TheStoreApp
//
//  Created by jiming huang on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MobilePromotionVO.h"

@implementation MobilePromotionVO

@synthesize starteDate;
@synthesize endDate;
@synthesize promotionId;//促销活动id
@synthesize description;//促销活动描述
@synthesize title;//促销活动标题
@synthesize productVOList;//产品列表 list<ProductVO>
@synthesize canJoin;//是否可参加此促销活动 0表示不可参加，1表示可参加
@synthesize contentValue;//优惠内容值
@synthesize promotionLevelId;//促销级别Id
-(void)dealloc
{
    OTS_SAFE_RELEASE(starteDate);
    OTS_SAFE_RELEASE(endDate);
    if (promotionId!=nil) {
        [promotionId release];
        promotionId=nil;
    }
    if (description!=nil) {
        [description release];
        description=nil;
    }
    if (title!=nil) {
        [title release];
        title=nil;
    }
    if (productVOList!=nil) {
        [productVOList release];
        productVOList=nil;
    }
    if (canJoin!=nil) {
        [canJoin release];
        canJoin=nil;
    }
    OTS_SAFE_RELEASE(contentValue);
    OTS_SAFE_RELEASE(promotionLevelId);
    [super dealloc];
}
@end
