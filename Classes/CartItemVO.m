//
//  CartItemVO.m
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import "CartItemVO.h"
#import "ProductVO.h"

@implementation CartItemVO

@synthesize buyQuantity, buyQuantityCopy = _buyQuantityCopy;
@synthesize product;
@synthesize updateType, grossWeight;
@synthesize cashPromotionName,cashPromotionAmount;
@synthesize needPoint;

-(NSString *)toXML
{
    NSMutableString *string=[[[NSMutableString alloc] initWithString:@"<com.yihaodian.mobile.vo.cart.CartItemVO>"] autorelease];
    if ([self buyQuantity]!=nil) {
        [string appendFormat:@"<buyQuantity>%@</buyQuantity>",[self buyQuantity]];
    }
    if ([self buyQuantityCopy]!=nil) {
        [string appendFormat:@"<buyQuantityCopy>%@</buyQuantityCopy>",[self buyQuantityCopy]];
    }
    if ([self product]!=nil) {
        [string appendFormat:@"<product>%@</product>",[[self product]toXML]];
    }
    if ([self updateType]!=nil) {
        [string appendFormat:@"<updateType>%@</updateType>",[self updateType]];
    }
    if ([self grossWeight]!=nil) {
        [string appendFormat:@"<grossWeight>%@</grossWeight>",[self grossWeight]];
    }
    if ([self cashPromotionName]!=nil) {
        [string appendFormat:@"<cashPromotionName>%@</cashPromotionName>",[self cashPromotionName]];
    }
    if ([self cashPromotionAmount]!=nil) {
        [string appendFormat:@"<cashPromotionAmount>%@</cashPromotionAmount>",[self cashPromotionAmount]];
    }
    [string appendString:@"</com.yihaodian.mobile.vo.cart.CartItemVO>"];
    return string;
}
-(void)dealloc
{
    [_buyQuantityCopy release];
    
    if(buyQuantity!=nil){
        [buyQuantity release];
    }
    if(product!=nil){
        [product release];
    }
    if(updateType!=nil){
        [updateType release];
    }
    
    [grossWeight release];
    
    OTS_SAFE_RELEASE(cashPromotionName);
    OTS_SAFE_RELEASE(cashPromotionAmount);
    OTS_SAFE_RELEASE(needPoint);
    [super dealloc];
}

@end
