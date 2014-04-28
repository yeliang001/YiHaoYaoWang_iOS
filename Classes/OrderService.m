//
//  OrderService.m
//  TheStoreApp
//
//  Created by linyy on 11-2-12.
//  Copyright 2011 vsc. All rights reserved.
//	

#import "OrderService.h"
#import "GlobalValue.h"
#import "OTSUtility.h"

@implementation OrderService

//取消订单
-(int)cancelOrder:(NSString *)token orderId:(NSNumber *)orderId
{
    MethodBody *body = [[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLongLong:orderId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}
//创建结算中心订单
-(int)createSessionOrder:(NSString *)token
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}
//获取特定类型的我的订单列表
-(Page *)getMyOrderListByToken:(NSString *)token type:(NSNumber *)type currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addInteger:type];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[Page class]]) {
        Page *po=(Page*)ret;
        return po;
    } else {
        return nil;
    }
}

-(Page *)getMyOrderListByToken:(NSString *)token 
                   currentPage:(NSNumber *)currentPage 
                      pageSize:(NSNumber *)pageSize
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[Page class]]) {
        Page *po=(Page*)ret;
        return po;
    } else {
        return nil;
    }
}
-(Page *)getMyOrderListByToken:(NSString *)token 
                          type:(NSNumber *)type 
                    orderRange:(NSNumber *)orderRange
                      siteType:(NSNumber *)siteType
                   currentPage:(NSNumber *)currentPage 
                      pageSize:(NSNumber *)pageSize
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addInteger:type];
    [body addInteger:orderRange];
    [body addInteger:siteType];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[Page class]]) {
        Page *po=(Page*)ret;
        return po;
    } else {
        return nil;
    }
}
// 获取订单数量
-(NSArray*)getMyOrderCount:(NSString *)token orderRange:(NSNumber*)orderRange siteType:(NSNumber*)siteType{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addInteger:orderRange];
    [body addInteger:siteType];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}
 // 查询当前团购列表
-(Page*)getCurrentGrouponList:(Trader*)trader 
                       areaId:(NSNumber*)areaId 
                   categoryId:(NSNumber*)categoryId 
                     sortType:(NSNumber*)sortType 
                  currentPage:(NSNumber *)currentPage 
                     pageSize:(NSNumber *)pageSize
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:areaId];
    [body addLong:categoryId];
    [body addInteger:sortType];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[Page class]]) {
        Page *po=(Page*)ret;
        return po;
    } else {
        return nil;
    }
    
}

//获取订单详细信息
-(OrderV2 *)getOrderDetailByOrderIdEx:(NSString *)token orderId:(NSNumber *)orderId
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLongLong:orderId];
    DebugLog(@"CURRENT_METHOD_NAME(_cmd) %@",CURRENT_METHOD_NAME(_cmd));
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[OrderV2 class]]) {
        OrderV2 *po=(OrderV2*)ret;
        return po;
    } else {
        return nil;
    }
}
//获取结算中心订单
-(OrderVO *)getSessionOrder:(NSString *)token
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[OrderVO class]]) {
        OrderVO *po=(OrderVO*)ret;
        return po;
    } else {
        return nil;
    }
}
//重新购买订单
-(long)rebuyOrder:(NSString *)token orderId:(NSNumber *)orderId
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLongLong:orderId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po longValue];
    } else {
        return 0;
    }
}
//保存收货地址信息到订单
-(long)saveGoodReceiverToSessionOrder:(NSString *)token goodReceiverId:(NSNumber *)goodReceiverId
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:goodReceiverId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po longValue];
    } else {
        return 0;
    }
}
//保存收货地址到订单V2
-(SaveGoodReceiverResult *)saveGoodReceiverToSessionOrderV2:(NSString *)token
                                             goodReceiverId:(NSNumber *)goodReceiverId
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:goodReceiverId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[SaveGoodReceiverResult class]]) {
        SaveGoodReceiverResult *po=(SaveGoodReceiverResult *)ret;
        return po;
    } else {
        return nil;
    }
}
//保存发票到订单
-(long)saveInvoiceToSessionOrder:(NSString *)token invoiceTitle:(NSString *)invoiceTitle invoiceContent:(NSString *)invoiceContent invoiceAmount:(NSNumber *)invoiceAmount
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addString:invoiceTitle];
    [body addString:invoiceContent];
    [body addDouble:invoiceAmount];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po longValue];
    } else {
        return 0;
    }
}
//设置支付方式
-(long)savePaymentToSessionOrder:(NSString *)token methodid:(NSNumber *)methodid gatewayid:(NSNumber *)gatewayid
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:methodid];
    [body addLong:gatewayid];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po longValue];
    } else {
        return 0;
    }
}
//结算中心提交订单
-(long)submitOrder:(NSString *)token
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po longValue];
    } else {
        return 0;
    }
}
//结算中心提交订单
-(long long int)submitOrderEx:(NSString *)token
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po longLongValue];
    } else {
        return 0;
    }
}
-(NSMutableArray *)getOrderStatusHeader:(NSString *)token orderId:(NSNumber *)orderId
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLongLong:orderId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray *po=(NSMutableArray*)ret;
        return po;
    } else {
        return nil;
    }
}
-(Page *)getOrderStatusTrack:(NSString *)token orderId:(NSNumber *) orderId currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLongLong:orderId];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[Page class]]) {
        Page *po=(Page*)ret;
        return po;
    } else {
        return nil;
    }
}
-(NSArray *)getPaymentMethodsForSessionOrder:(NSString *)token
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}
-(NSArray *)getPaymentMethodsForSessionOrderV2:(NSString *)token{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}
-(NSString *)CUPSignature:(NSString *)token orderId:(NSString *)orderId
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addString:orderId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSString class]]) {
        NSString *po=(NSString*)ret;
        return po;
    } else {
        return nil;
    }
}

-(NSString *)aliPaySignature:(NSString *)token orderId:(NSString *)orderId
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addString:orderId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSString class]]) {
        NSString *po=(NSString*)ret;
        return po;
    } else {
        return nil;
    }
}

-(NSArray *)getMyOrderCount:(NSString *)token
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}

-(CreateOrderResult *)createSessionOrderV2:(NSString *)token
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[CreateOrderResult class]]) {
        CreateOrderResult *po=(CreateOrderResult*)ret;
        return po;
    } else {
        return nil;
    }
}

-(SubmitOrderResult *)submitOrderV2:(NSString *)token
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[SubmitOrderResult class]]) {
        SubmitOrderResult *po=(SubmitOrderResult *)ret;
        return po;
    } else {
        return nil;
    }
}

-(SaveGateWayToOrderResult *)saveGateWayToOrder:(NSString *)token orderId:(NSNumber *)orderId gateWayId:(NSNumber *)gateWayId
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    
    [body addToken:token];
    [body addLongLong:orderId];
    [body addLong:gateWayId];
    
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    
    if(ret && [ret isKindOfClass:[SaveGateWayToOrderResult class]]) {
        SaveGateWayToOrderResult *po=(SaveGateWayToOrderResult *)ret;
        return po;
    }
    
    return nil;
}

@end
