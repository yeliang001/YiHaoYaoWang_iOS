//
//  PaymentMethodError.h
//  TheStoreApp
//
//  Created by xuexiang on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentMethodError : NSObject
{
@private
    /**
     * 当前订单是否支持
     */
    NSNumber* errorCode;
    /**
     * 不支持的原因
     */
    NSString* errorInfo;
}
@property(nonatomic, retain)NSNumber* errorCode;
@property(nonatomic, retain)NSString* errorInfo;
@end

/*
 当isSupport等于true为可用的支付方式反之为不可用、不可用时PaymentMethodError中存储不可用的编码和详细信息、具体不可用原因编码和描述如下
 301 : 防欺诈检查不可用
 302 : 货到付款商品检查不通过(比如敏感商品)
 303 : 收货地址检查不通过（比如不支持）
 304 : TODO (与357重复)特定分类抵用券检查不通过
 305 : 一号店自营部分的订单金额检查不通过
 350 : 支付方式参数错误
 351 : 不可使用的支付方式
 352 : 不可使用COD
 353 : 不可使用POS
 354 : 金额限制导致不可使用COD，POS
 355 : 礼品卡订单不可使用万里通
 356 : 金额限制导致不可使用银行转账
 357 : 分类抵用券导致不可使用COD，POS
 358 : 礼品卡订单不可使用万隆卡
 359 : 礼品卡订单不可使用手机卡
 360 : 支付宝用户登录只能使用支付宝
 361 : 订单应付金额为负数
 暂时只用到301-305，之外的暂统一定为其他原因
*/