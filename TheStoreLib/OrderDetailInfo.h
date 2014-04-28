//
//  OrderDetailInfo.h
//  TheStoreApp
//
//  Created by LinPan on 13-9-22.
//
//

#import <Foundation/Foundation.h>
#import "OrderContact.h"
#import "InvoiceInfo.h"

//订单详情的数据
@interface OrderDetailInfo : NSObject


@property (copy, nonatomic) NSString *orderCancelTime;
@property (copy, nonatomic) NSString *splitOrderInfo; //仓库信息
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *confirmPayTime;
@property (assign, nonatomic) float theFei;
@property (copy, nonatomic) NSString *shipMethodId; //配送方式 1:药网自提 2:物流配送
@property (copy, nonatomic) NSString *shipMethodName;// 配送方式名称
@property (assign, nonatomic) NSInteger payMethodId;//0货到付款 1网上支付 3pos机刷卡 
@property (assign, nonatomic) NSInteger orderStatus;//0:"待审核";1: "审核通过";5: "已完成";6:"超时系统取消"; 7: "主动取消";9:"电话通知客服取消";10:"准备配送";11："未通过审核取消";相当于取消订单;12:订单拒收
@property (assign, nonatomic) float orderPriceCount;// 商品总金额（不含运费，不含优惠金额）
@property (copy, nonatomic) NSString *payMethodName;
@property (assign, nonatomic) float theAllMoney;
@property (assign, nonatomic) float useBalance; //使用多少账户余额
@property (copy, nonatomic) NSString *orderDate;
@property (copy, nonatomic) NSString *orderFinishTime;
@property (copy, nonatomic) NSString *venderId;
@property (copy, nonatomic) NSString *orderId;
@property (assign, nonatomic) NSInteger payStatus;// 支付状态 0没有支付1成功支付2支付失败3支付定金10%4线下收款确认5等待付款确认(银行汇款)
@property (copy, nonatomic) NSString *userId;


@property (retain, nonatomic) NSMutableArray *orderPackageArr; //订单中包裹数组，元素为OrderPackageInfo类
@property (retain, nonatomic) OrderContact *orderContact; //订单联系人
@property (retain, nonatomic) InvoiceInfo *invoiceInfo;  //发票信息



//需要支付宝付款
- (BOOL)needPayByAlipay;
//可以被取消
- (BOOL)canBeCanceled;

- (NSString *)payStatusName;
- (NSString *)orderStatusName;
@end
