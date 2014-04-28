//
//  PaymentMethodVO.h
//  TheStoreApp
//
//  Created by jiming huang on 11-12-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentMethodVO : NSObject {
@private
    NSNumber *methodId;//支付方式id
    NSString *methodName;//支付方式名称
    NSNumber *gatewayId;//支付网关id，仅支付方式id为网上支付时有效
    NSString *gatewayName;//支付网关名称，仅支付方式id为网上支付时有效
    NSString *gatewayImageUrl;//支付网关图片地址，仅支付方式id为网上支付时有效
    NSString *isDefaultPaymentMethod;//是否默认支付方式，TRUE 是， FALSE 否
    NSString *reverse;//保留字段
    NSNumber *paymentType;//支付方式类型，1为网上支付、2为货到付款、5为货到刷卡
}
@property(retain,nonatomic)NSNumber *methodId;//支付方式id
@property(retain,nonatomic)NSString *methodName;//支付方式名称
@property(retain,nonatomic)NSNumber *gatewayId;//支付网关id，仅支付方式id为网上支付时有效
@property(retain,nonatomic)NSString *gatewayName;//支付网关名称，仅支付方式id为网上支付时有效
@property(retain,nonatomic)NSString *gatewayImageUrl;//支付网关图片地址，仅支付方式id为网上支付时有效
@property(retain,nonatomic)NSString *isDefaultPaymentMethod;//是否默认支付方式，TRUE 是， FALSE 否
@property(retain,nonatomic)NSString *reverse;//保留字段
@property(retain,nonatomic)NSNumber *paymentType;//支付方式类型
@end
