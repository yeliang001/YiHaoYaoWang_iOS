//
//  OrderDetailInfo.m
//  TheStoreApp
//
//  Created by LinPan on 13-9-22.
//
//

#import "OrderDetailInfo.h"

//订单详情的数据
@implementation OrderDetailInfo

- (void)dealloc
{
    [_orderCancelTime release];
    [_splitOrderInfo release];
    [_userName release];
    [_confirmPayTime release];
    [_shipMethodId release];
    [_payMethodName release];
    [_orderDate release];
    [_orderFinishTime release];
    [_venderId release];
    [_orderId release];
    [_shipMethodName release];
    [_userId release];
    
    [_orderPackageArr release]; //订单中包裹数组，元素为OrderPackageInfo类
    [_orderContact release]; //订单联系人
    [_invoiceInfo release];  //发票信息
    
    [super dealloc];
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

- (NSString *)payStatusName
{
    // 支付状态 0没有支付1成功支付2支付失败3支付定金10%4线下收款确认5等待付款确认(银行汇款)
    NSString *name = @"";
    switch (_payStatus)
    {
        case 0:
            name = @"没有支付";
            break;
        case 1:
            name = @"支付成功";
            break;
        case 2:
            name = @"支付失败";
            break;
        case 3:
            name = @"支付定金";
            break;
        case 4:
            name = @"线下收款确认";
            break;
        case 5:
            name = @"等待付款确认";
            break;
        default:
            name = @"未知支付状态";
            break;
    }
    return name;
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
@end
