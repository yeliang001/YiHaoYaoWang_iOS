//
//  CartVO.m
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import "CartVO.h"
#import "CartItemVO.h"
#import "ProductVO.h"


@implementation CartVO

@synthesize buyItemList;
@synthesize gifItemtList;
@synthesize cashPromotionList;
@synthesize redemptionItemList;
@synthesize totalprice;
@synthesize totalquantity;
@synthesize totalsavedprice;
@synthesize totalWeight;
@synthesize cashAmount;
@synthesize isYiHaoDianCart;
@synthesize totalpriceMall;
@synthesize totalquantityMall;
@synthesize cartBagVOs;
@synthesize optionalPromotionList;
@synthesize totalNeedPoint ;//需要的总积分数量
@synthesize totalNeedPointMall ;//1号商城需要的总积分数量
@synthesize hasFreePromotion;
@synthesize mobileGifItemtList;
@synthesize mobileRedemptionItemList;

-(NSUInteger)realtimeTotalQuantity
{
    NSUInteger total = 0;
    
    if (self.buyItemList)
    {
        for (CartItemVO* cartItem in self.buyItemList)
        {
            total += [cartItem.buyQuantity intValue];
        }
    }
    
    return total;
}

-(float)realTotalPrice
{
    float total = 0.f;
    if (self.buyItemList)
    {
        for (CartItemVO* cartItem in self.buyItemList)
        {
            float price = [cartItem.product.realPrice floatValue];
            total += [cartItem.buyQuantity intValue] * price;
        }
    }
    
    return total;
}

-(void)dealloc{
    if(buyItemList!=nil){
        [buyItemList removeAllObjects];
        [buyItemList release];
    }
    if(gifItemtList!=nil){
        [gifItemtList removeAllObjects];
        [gifItemtList release];
    }
    if(totalprice!=nil){
        [totalprice release];
    }
    if(totalquantity!=nil){
        [totalquantity release];
    }
    if(totalsavedprice!=nil){
        [totalsavedprice release];
    }
    if (totalWeight!=nil) {
        [totalWeight release];
        totalWeight=nil;
    }
    OTS_SAFE_RELEASE(cashPromotionList);
    OTS_SAFE_RELEASE(redemptionItemList);
    OTS_SAFE_RELEASE(cashAmount);
    
    OTS_SAFE_RELEASE(isYiHaoDianCart);
    OTS_SAFE_RELEASE(totalpriceMall);
    OTS_SAFE_RELEASE(totalquantityMall);
    OTS_SAFE_RELEASE(cartBagVOs);
    OTS_SAFE_RELEASE(optionalPromotionList);
    OTS_SAFE_RELEASE(totalNeedPoint);
    OTS_SAFE_RELEASE(totalNeedPointMall);
    OTS_SAFE_RELEASE(hasFreePromotion);
    OTS_SAFE_RELEASE(mobileGifItemtList);
    OTS_SAFE_RELEASE(mobileRedemptionItemList);
    [super dealloc];
}

@end
