//
//  OrderVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-2-12.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CouponVO;
@class GoodReceiverVO;
@class GrouponVO;

@interface OrderVO : NSObject {
@private
	NSNumber * accountAmount;//账户抵扣
	CouponVO *	coupon;//使用的抵用券
	NSNumber * couponAmount;//抵用券抵扣
	NSNumber * deliveryAmount;//运费
	NSString * deliveryMethodForString;//送货方式
	NSString * expectReceiveDateTo;//预计送达时间
	GoodReceiverVO	* goodReceiver;//收货地址
	NSMutableArray * invoiceList;//发票列表
	NSNumber * orderAmount;//订单总金额
	NSString * orderCode;//订单编号
	NSString * orderCreateTime;//下单时间
	NSNumber * orderId;//订单Id
	NSMutableArray * orderItemList;//购买产品列表
	NSNumber * orderStatus;//订单状态编码
	NSString * orderStatusForString;//订单状态文字说明
	NSNumber * paymentAccount;//应付总金额
	NSString * paymentMethodForString;//付款方式
	NSNumber * productAmount;//产品金额
	NSNumber * productCount;//产品总数
	NSNumber * serialVersionUID;
    NSString * deliverStartDate;//期望配送开始时间
    NSString * deliverEndDate;//期望配送结束时间
    NSNumber * paymentSignal;//支付状况 1已支付 2未支付 3部分支付 4待审核
    NSArray * childOrderList;//子订单列表
    NSNumber * orderType;//订单类型 1普通订单 2团购订单
    GrouponVO * grouponVO;//团购信息
	NSNumber * orderTotalWeight; //商品总重量
	NSNumber * canIssuedInvoiceType; //能开发票的类型， 1为普通发票。2为3c发票。3为既有普通发票页有3c发票
}
@property(retain,nonatomic)NSNumber * accountAmount;//账户抵扣
@property(retain,nonatomic)CouponVO *	coupon;//使用的抵用券
@property(retain,nonatomic)NSNumber * couponAmount;//抵用券抵扣
@property(retain,nonatomic)NSNumber * deliveryAmount;//运费
@property(retain,nonatomic)NSString * deliveryMethodForString;//送货方式
@property(retain,nonatomic)NSString * expectReceiveDateTo;//预计送达时间
@property(retain,nonatomic)GoodReceiverVO	* goodReceiver;//收货地址
@property(retain,nonatomic)NSMutableArray * invoiceList;//发票列表
@property(retain,nonatomic)NSNumber * orderAmount;//订单总金额
@property(retain,nonatomic)NSString * orderCode;//订单编号
@property(retain,nonatomic)NSString * orderCreateTime;//下单时间
@property(retain,nonatomic)NSNumber * orderId;//订单Id
@property(retain,nonatomic)NSMutableArray * orderItemList;//购买产品列表
@property(retain,nonatomic)NSNumber * orderStatus;//订单状态编码
@property(retain,nonatomic)NSString * orderStatusForString;//订单状态文字说明
@property(retain,nonatomic)NSNumber * paymentAccount;//应付总金额
@property(retain,nonatomic)NSString * paymentMethodForString;//付款方式
@property(retain,nonatomic)NSNumber * productAmount;//产品金额
@property(retain,nonatomic)NSNumber * productCount;//产品总数
@property(retain,nonatomic)NSNumber * serialVersionUID;
@property(retain,nonatomic)NSString * deliverStartDate;//期望配送开始时间
@property(retain,nonatomic)NSString * deliverEndDate;//期望配送结束时间
@property(retain,nonatomic)NSNumber * paymentSignal;//支付状况 1已支付 2未支付 3部分支付 4待审核
@property(retain,nonatomic)NSArray * childOrderList;//子订单列表
@property(retain,nonatomic)NSNumber * orderType;//订单类型 1普通订单 2团购订单
@property(retain,nonatomic)GrouponVO * grouponVO;//团购信息
@property(retain,nonatomic)NSNumber * orderTotalWeight;//商品总重量
@property(retain,nonatomic)NSNumber * canIssuedInvoiceType; //能开发票的类型， 1为普通发票。2为3c发票。3为既有普通发票页有3c发票

@end
