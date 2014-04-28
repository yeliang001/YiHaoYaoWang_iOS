//
//  OrderInfo.h
//  TheStoreApp
//
//  Created by LinPan on 13-9-13.
//
//  提交购物车之后返回的检查订单详细
//  检查订单之后再提交订单返回也是这个对象

#import <Foundation/Foundation.h>
@class GoodReceiverVO;
@class FareInfo;
@interface OrderInfo : NSObject


@property (retain, nonatomic) GoodReceiverVO *goodReceiver; //收获地址
@property (retain, nonatomic) NSString *fare;  //运费
@property (retain, nonatomic) NSMutableArray *fareInfoArr; //运费的详细信息，返回数组，对应多个商品 见运费类:fareInfo
@property (assign, nonatomic) BOOL isMustInvoice;//是否必须发票  0必须开 1可开可不开
@property (assign, nonatomic) BOOL isMedicalInstrument; //是不是医疗器械，如果是的话就只开医疗器械发票
@property (assign, nonatomic) BOOL isContainOtherProduct;//是否包含第三方商品，如果有不能货到付款
@property (assign, nonatomic) BOOL isContainTJProduct; //是否包含体检类商品，如果有，那么发票信息必须是 服务类
@property (retain, nonatomic) NSMutableArray *orderPackageArr; //订单中的包裹列表  见包裹类：OrderPackageInfo

@property (copy, nonatomic) NSString *signInfo; //确认下单之后返回的订单中的签名信息，用于支付宝付款
@property (copy, nonatomic) NSString *orderId; //

//是否支持pos机付款
- (BOOL)isSupportPos;
//是否支持货到付款
- (BOOL)isSupportCod;

//不含运费
- (float)orderProductTotalPrice;
//整个订单的价格
- (float)orderTotalMoney;
//订单的重量
- (float)orderTotalWeight;
//商品总数
- (int)orderProductCount;

@end
