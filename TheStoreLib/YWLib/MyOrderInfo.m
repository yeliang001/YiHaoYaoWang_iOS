//
//  MyOrderInfo.m
//  TheStoreApp
//
//  Created by LinPan on 13-9-18.
//
//  我的订单列表中订单详细，跟OrderInfo 不一样，OrderInfo是预提交时的订单详细  PS：fuck。。。

#import "MyOrderInfo.h"

@implementation MyOrderInfo

- (void)dealloc
{
    [_productInfoArr release];
    [_orderDate release];
    [_orderId release];
    [_payMethodName release];
    [_orderPackageArr release];
    [super dealloc];
}


- (NSString *)orderStatusName
{
    NSString *nameStr = @"";
    switch (_orderStatus) {
        case 0:
            nameStr = @"待审核";
            break;
        case 1:
            nameStr = @"审核通过";
            break;
        case 5:
            nameStr = @"已完成";
            break;
        case 6:
            nameStr = @"超时系统取消";
            break;
        case 7:
            nameStr = @"主动取消";
            break;
        case 9:
            nameStr = @"电话通知客服取消";
            break;
        case 10:
            nameStr = @"准备配送";
            break;
        case 11:
            nameStr = @"未通过审核取消";
            break;
        case 12:
            nameStr = @"订单拒收";
            break;
        default:
            nameStr = @"订单状态未知";
            break;
    }
    return nameStr;
}

- (BOOL)needPayByAlipay
{
    //订单未付款 付款方式为网上支付 并且待审核 需要显示去支付宝支付
    return (_payStatus != 1 && _payMethodId == 1 && _orderStatus == 0);
}

- (BOOL)canBeCanceled
{
    //订单待审核或者审核通过 可以取消
    return (_orderStatus == 0 || _orderStatus == 1);
}

@end



//我订单列表中的订单里面的商品信息
@implementation OrderProductInfo

- (void)dealloc
{
    [_productId release];
    [_productName  release];
    [_orderId release];
    [_productPicture release];
    [_packageId release];
    [super dealloc];
}
- (BOOL)isOTC
{
    if (_prescription == 16)
    {
        return YES;
    }
    
    return NO;
}

@end