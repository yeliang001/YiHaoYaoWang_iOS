//
//  OrderVO.m
//  ProtocolDemo
//
//  Created by vsc on 11-2-12.
//  Copyright 2011 vsc. All rights reserved.
//

#import "OrderVO.h"
#import "OrderItemVO.h"
@implementation OrderVO

@synthesize accountAmount;//账户抵扣
@synthesize	coupon;//使用的抵用券
@synthesize couponAmount;//抵用券抵扣
@synthesize deliveryAmount;//运费
@synthesize deliveryMethodForString;//送货方式
@synthesize expectReceiveDateTo;//预计送达时间
@synthesize goodReceiver;//收货地址
@synthesize invoiceList;//发票列表
@synthesize orderAmount;//订单总金额
@synthesize orderCode;//订单编号
@synthesize orderCreateTime;//下单时间
@synthesize orderId;//订单Id
@synthesize orderItemList;//购买产品列表
@synthesize orderStatus;//订单状态编码
@synthesize orderStatusForString;//订单状态文字说明
@synthesize paymentAccount;//应付总金额
@synthesize paymentMethodForString;//付款方式
@synthesize productAmount;//产品金额
@synthesize productCount;//产品总数
@synthesize serialVersionUID;
@synthesize deliverStartDate;//期望配送开始时间
@synthesize deliverEndDate;//期望配送结束时间
@synthesize paymentSignal;//支付状况 1已支付 2未支付 3部分支付 4待审核
@synthesize childOrderList;//子订单列表
@synthesize orderType;//订单类型 1普通订单 2团购订单
@synthesize grouponVO;//团购信息
@synthesize orderTotalWeight;//商品总重量
@synthesize canIssuedInvoiceType; //发票类型
@synthesize merchantName;//商家名称
@synthesize siteType = _siteType;
@synthesize cashAmount; //促销立减金额
@synthesize isYihaodian;
@synthesize isFresh;
@synthesize cardAmount;
@synthesize needPoint;
-(void)dealloc{
    
    [_siteType release];
    
    if(accountAmount!=nil){
        [accountAmount release];
    }
    if(coupon!=nil){
        [coupon release];
    }
    if(couponAmount!=nil){
        [couponAmount release];
    }
    if(deliveryAmount!=nil){
        [deliveryAmount release];
    }
    if(deliveryMethodForString!=nil){
        [deliveryMethodForString release];
    }
    if(expectReceiveDateTo!=nil){
        [expectReceiveDateTo release];
    }
    if(goodReceiver!=nil){
        [goodReceiver release];
    }
    if(invoiceList!=nil){
        [invoiceList release];
    }
    if(orderAmount!=nil){
        [orderAmount release];
    }
    if(orderCode!=nil){
        [orderCode release];
    }
    if(orderCreateTime!=nil){
        [orderCreateTime release];
    }
    if(orderId!=nil){
        [orderId release];
    }
    if(orderItemList!=nil){
        [orderItemList release];
    }
    if(orderStatus!=nil){
        [orderStatus release];
    }
    if(orderStatusForString!=nil){
        [orderStatusForString release];
    }
    if(paymentAccount!=nil){
        [paymentAccount release];
    }
    if(paymentMethodForString!=nil){
        [paymentMethodForString release];
    }
    if(productAmount!=nil){
        [productAmount release];
    }
    if(productCount!=nil){
        [productCount release];
    }
    if(serialVersionUID!=nil){
        [serialVersionUID release];
    }
    if(deliverStartDate!=nil) {
        [deliverStartDate release];
    }
    if (deliverEndDate!=nil) {
        [deliverEndDate release];
    }
    if (paymentSignal!=nil) {
        [paymentSignal release];
    }
    if (childOrderList!=nil) {
        [childOrderList release];
    }
    if (orderType!=nil) {
        [orderType release];
    }
    if (grouponVO!=nil) {
        [grouponVO release];
    }
	if (orderTotalWeight != nil) {
		[orderTotalWeight release];
		orderTotalWeight = nil;
	}
    if (canIssuedInvoiceType!=nil) {
        [canIssuedInvoiceType release];
        canIssuedInvoiceType=nil;
    }
    if (merchantName!=nil) {
        [merchantName release];
        merchantName=nil;
    }
    OTS_SAFE_RELEASE(cashAmount);
    
    [_lefthours release];
    [_leftminite release];
    OTS_SAFE_RELEASE(isYihaodian);
    OTS_SAFE_RELEASE(isFresh);
    OTS_SAFE_RELEASE(cardAmount);
    OTS_SAFE_RELEASE(needPoint);
    [super dealloc];
}
/*
 功能:计算总共商品的总数
 productCount:这个字段只表示了商品的种类数
 */
-(NSNumber*)totalProductQuantity
{
    NSInteger total = 0;
    for(OrderItemVO* itemVo in orderItemList)
    {
        total += [itemVo.buyQuantity integerValue];
    }
    return [NSNumber numberWithInteger:total];
}
-(int)calculatedHours
{
    int hours = [_lefthours intValue];
    int minutes = [_leftminite intValue];
    if (minutes > 0)    // 分钟不为0，小时++
    {
        hours++;
    }
    
    return hours;
}

-(int)calculatedMinutes
{
    return [_lefthours intValue] * 60 + [_leftminite intValue];
}

-(BOOL)isGroupBuyOrder
{
    return [orderType intValue] == 2;
}


-(NSUInteger)packageCount
{
    return [childOrderList count];
}

-(BOOL)isPayWhenGoodsArriving
{
    return [paymentMethodForString rangeOfString:@"货到"].location != NSNotFound;
}

-(BOOL)isFreshOrder
{
    return self.isFresh && [self.isFresh intValue] == 1;
}

-(NSString*)createOrderLocalTime{
    NSDate* date=[self createDate];
    NSTimeZone* zone=[NSTimeZone localTimeZone];
    int offset=[zone secondsFromGMTForDate:date];
    NSDate* localDate=[date dateByAddingTimeInterval:offset];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *destDateString = [dateFormatter stringFromDate:localDate];
    
    [dateFormatter release];
    
    return destDateString;
}

-(NSDate*)createDate
{
    //2012-05-07 16:18:17.0 CST
    NSString* strDateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString* strDate = self.orderCreateTime;
    NSDate *createDate = nil;
    if (strDate && [strDate length] >= [strDateFormat length])
    {
        strDate = [strDate substringToIndex:[strDateFormat length]];
        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:strDateFormat];
        
        createDate = [dateFormatter dateFromString:strDate];
    }
    
    return createDate;
}

-(BOOL)isCreatedInHours:(int)aHours
{
    NSDate* createDate = [self createDate];
    if (createDate)
    {
        NSTimeInterval interval = -[createDate timeIntervalSinceNow];
        //DebugLog(@"dateStr:%@, date:%@, interval from now:%f", orderCreateTime, createDate, interval);
        
        if (interval / 3600 < aHours)
        {
            return YES;
        }
    }
    
    return NO;
}

-(BOOL)isUnpayedUsingOnlineBank
{
    //DebugLog(@"orderStatusForString:%@, paymentMethodForString:%@", orderStatusForString, paymentMethodForString);
    return [orderStatusForString isEqualToString:OTS_ORDER_VO_STATUS_STR_WAIT_SETTLEMENT]
    && [paymentMethodForString isEqualToString:@"网上支付"];
}

// 判断是否有物流查询条件：不为网上支付，或为网上支付并已支付
-(BOOL)hasMeterialFlow
{
    return ![paymentMethodForString isEqualToString:@"网上支付"] || [self hasPayedOnline];
}

-(BOOL)hasPayedOnline
{
    return [paymentMethodForString isEqualToString:@"网上支付"]
    && ![orderStatusForString isEqualToString:OTS_ORDER_VO_STATUS_STR_WAIT_SETTLEMENT]
    && ![orderStatusForString isEqualToString:OTS_ORDER_VO_STATUS_STR_CANCELED];
}

-(BOOL)needToPayedOnline
{
    return [paymentMethodForString isEqualToString:@"网上支付"]
    && [orderStatusForString isEqualToString:OTS_ORDER_VO_STATUS_STR_WAIT_SETTLEMENT];
}

-(BOOL)isCanceled
{
    return [orderStatusForString isEqualToString:OTS_ORDER_VO_STATUS_STR_CANCELED];
}

@end
