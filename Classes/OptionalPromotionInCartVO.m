//
//  OptionalPromotionInCartVO.m
//  TheStoreApp
//
//  Created by towne on 13-1-14.
//
//  n元n件活动实体

#import "OptionalPromotionInCartVO.h"
#import "CartItemVO.h"
#import "UnionProductItemVO.h"
@implementation OptionalPromotionInCartVO

@synthesize promotionId,promotionLevelId,merchantId,merchantName,title,description,sumprice,productItems;
@synthesize conditionType;  //优惠条件
@synthesize conditionValue; //优惠条件值
@synthesize contentType;    //优惠内容类型
@synthesize contentValue;   //优惠内容值
@synthesize unionProductItemVOs;

-(NSString *)toXML
{
    NSMutableString *string=[[[NSMutableString alloc] initWithString:@"<com.yihaodian.mobile.vo.cart.OptionalPromotionInCartVO>"] autorelease];
    if ([self promotionId]!=nil) {
        [string appendFormat:@"<promotionId>%@</promotionId>",[self promotionId]];
    }
    if ([self promotionLevelId]!=nil) {
        [string appendFormat:@"<promotionLevelId>%@</promotionLevelId>",[self promotionLevelId]];
    }
    if ([self merchantId]!=nil) {
        [string appendFormat:@"<merchantId>%@</merchantId>",[self merchantId]];
    }
    if ([self merchantName]!=nil) {
        [string appendFormat:@"<merchantName>%@</merchantName>",[self merchantName]];
    }
    if ([self title]!=nil) {
        [string appendFormat:@"<title>%@</title>",[self title]];
    }
    if ([self description]!=nil) {
        [string appendFormat:@"<description>%@</description>",[self description]];
    }
    if ([self sumprice]!=nil) {
        [string appendFormat:@"<sumprice>%@</sumprice>",[self sumprice]];
    }
    if ([self conditionType]!=nil) {
        [string appendFormat:@"<conditionType>%@</conditionType>",[self conditionType]];
    }
    if ([self conditionValue]!=nil) {
        [string appendFormat:@"<conditionValue>%@</conditionValue>",[self conditionValue]];
    }
    if ([self contentType]!=nil) {
        [string appendFormat:@"<contentType>%@</contentType>",[self contentType]];
    }
    if ([self contentValue]!=nil) {
        [string appendFormat:@"<contentValue>%@</contentValue>",[self contentValue]];
    }
    if ([self productItems]!=nil) {
        [string appendString:@"<productItems>"];
        for (CartItemVO* aVO in [self productItems]) {
            [string appendFormat:@"%@",[aVO toXML]];
        }
        [string appendString:@"</productItems>"];
    }
    if ([self unionProductItemVOs]!=nil) {
        [string appendString:@"<unionProductItemVOs>"];
        for (UnionProductItemVO*unionVO  in [self unionProductItemVOs]) {
            [string appendFormat:@"%@",[unionVO toXML]];
        }
        [string appendString:@"</unionProductItemVOs>"];
    }
    [string appendString:@"</com.yihaodian.mobile.vo.cart.OptionalPromotionInCartVO>"];
    return string;
}
-(void)dealloc{
    OTS_SAFE_RELEASE(promotionId);
    OTS_SAFE_RELEASE(promotionLevelId);
    OTS_SAFE_RELEASE(merchantId);
    OTS_SAFE_RELEASE(merchantName);
    OTS_SAFE_RELEASE(title);
    OTS_SAFE_RELEASE(description);
    OTS_SAFE_RELEASE(sumprice);
    OTS_SAFE_RELEASE(productItems);
    OTS_SAFE_RELEASE(conditionType);
    OTS_SAFE_RELEASE(conditionValue);
    OTS_SAFE_RELEASE(contentType);
    OTS_SAFE_RELEASE(contentValue);
    OTS_SAFE_RELEASE(unionProductItemVOs);
    [super dealloc];
}

@end
