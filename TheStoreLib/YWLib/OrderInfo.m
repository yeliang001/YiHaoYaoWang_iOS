//
//  OrderInfo.m
//  TheStoreApp
//
//  Created by LinPan on 13-9-13.
//
//
//  检查订单时返回的预提交订单 信息 ,确切的不是订单详情，是预提交订单

#import "OrderInfo.h"
#import "FareInfo.h"
#import "OrderPackageInfo.h"

@implementation OrderInfo

- (void)dealloc
{
    [_goodReceiver release];
    [_fareInfoArr release];
    [_orderPackageArr release];
    [_signInfo release];
    [_orderId release];
    [super dealloc];
}

//是否支持pos机付款
- (BOOL)isSupportPos
{
    //如果有第三方商品 那么就不能pos
    if (_isContainOtherProduct)
    {
        return NO;
    }
    
    for (FareInfo *fare in _fareInfoArr)
    {
        if (!fare.isPos)
        {
            return NO;
        }
    }
    
    return YES;
}

//是否支持货到付款
- (BOOL)isSupportCod
{
    //如果有第三方商品 那么就不能货
    if (_isContainOtherProduct)
    {
        return NO;
    }
    
    for (FareInfo *fare in _fareInfoArr)
    {
        if (!fare.isCod)
        {
            return NO;
        }
    }
    
    return YES;
}

//包含运费的总价
- (float)orderTotalMoney
{
    float totalMoney = 0.0;
    CGFloat promotionReductAmout = 0.0;//满减得钱
    for (OrderPackageInfo *package in _orderPackageArr)
    {
        NSString *moneyStr = package.allGoodsMoney;
        float money = [moneyStr floatValue];
        totalMoney += money;
        for (OrderProductDetail *product in package.packageProductArr)
        {
            promotionReductAmout += product.promotionAmount;
        }
    }
    return totalMoney + [_fare floatValue] - promotionReductAmout;
}
//不含运费的总价  不是促销满减之后的哦 就是原价
- (float)orderProductTotalPrice
{
    float totalPrice = 0.0;
    for (OrderPackageInfo *package in _orderPackageArr)
    {
        for (OrderProductDetail *product in package.packageProductArr)
        {
            float price = [product.productCount intValue] * [product.price floatValue];
            totalPrice += price;
        }
    }
    return totalPrice;
}

//订单的重量
- (float)orderTotalWeight
{
    float totalWeight = 0.0;
    for (OrderPackageInfo *package in _orderPackageArr)
    {
        for (OrderProductDetail *product in package.packageProductArr)
        {
            float weight = [product.productCount intValue] * [product.weight floatValue];
            totalWeight += weight;
        }
    }
    return totalWeight;
}

- (int)orderProductCount
{
    int total = 0;
    for (OrderPackageInfo *package in _orderPackageArr)
    {
        for (OrderProductDetail *product in package.packageProductArr)
        {
            int weight = [product.productCount intValue];
            total += weight;
        }
    }
    return total;
}


@end
