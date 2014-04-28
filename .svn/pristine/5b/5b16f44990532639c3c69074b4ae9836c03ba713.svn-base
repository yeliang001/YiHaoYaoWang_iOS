//
//  PaymentMethodVO.m
//  TheStoreApp
//
//  Created by jiming huang on 11-12-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PaymentMethodVO.h"

@implementation PaymentMethodVO

@synthesize methodId;//支付方式id
@synthesize methodName;//支付方式名称
@synthesize gatewayId;//支付网关id，仅支付方式id为网上支付时有效
@synthesize gatewayName;//支付网关名称，仅支付方式id为网上支付时有效
@synthesize gatewayImageUrl;//支付网关图片地址，仅支付方式id为网上支付时有效
@synthesize isDefaultPaymentMethod;//是否默认支付方式，TRUE 是， FALSE 否
@synthesize reverse;//保留字段
@synthesize paymentType;//支付方式类型
@synthesize errorInfo;
@synthesize isSupport;

-(void)dealloc{
    if (methodId!=nil) {
        [methodId release];
    }
    if (methodName!=nil) {
        [methodName release];
    }
    if (gatewayId!=nil) {
        [gatewayId release];
    }
    if (gatewayName!=nil) {
        [gatewayName release];
    }
    if (gatewayImageUrl!=nil) {
        [gatewayImageUrl release];
    }
    if (isDefaultPaymentMethod!=nil) {
        [isDefaultPaymentMethod release];
    }
    if (reverse!=nil) {
        [reverse release];
    }
    if (paymentType!=nil) {
        [paymentType release];
    }
    if (errorInfo != nil) {
        [errorInfo release];
    }
    if (isSupport != nil) {
        [isSupport release];
    }
    [super dealloc];
}
@end
