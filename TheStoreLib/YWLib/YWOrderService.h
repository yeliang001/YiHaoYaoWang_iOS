//
//  YWOrderService.h
//  TheStoreApp
//
//  Created by LinPan on 13-9-12.
//
//

#import "YWBaseService.h"
@class ResultInfo;
@class OrderResultInfo;
@class OrderDetailInfo;
@interface YWOrderService : YWBaseService

- (OrderResultInfo *)checkOrder:(NSDictionary *)dic;

//获取我的订单列表
- (ResultInfo *)getMyOrder:(NSDictionary *)dic;
//获取我的订单的支付宝签证
- (NSString *)getOrderAlipaySign:(NSString *)orderId;
//获取订单的详细内容
- (OrderDetailInfo *)getOrderDetail:(NSString *)orderId;
//取消订单
- (BOOL)cancelOrder:(NSString *)orderId orderStatus:(NSString *)aOrderStaus;

//提交订单
- (ResultInfo *)submitOrder:(NSDictionary *)paramDic;
@end
