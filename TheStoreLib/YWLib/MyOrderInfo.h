//
//  MyOrderInfo.h
//  TheStoreApp
//
//  Created by LinPan on 13-9-18.
//
//
//  我的订单列表中订单info，跟OrderInfo 不一样，OrderInfo是预提交时的订单详细  PS：fuck。。。


#import <Foundation/Foundation.h>

@interface MyOrderInfo : NSObject

@property (retain, nonatomic) NSMutableArray *productInfoArr; //我的订单列表中的商品信息  数组 , 里面元素：OrderProductInfo
@property (assign, nonatomic) NSInteger packageCount;         //包裹数量
@property (retain, nonatomic) NSString *orderDate;            //订单日期
@property (retain, nonatomic) NSString *orderId;              //
@property (assign, nonatomic) NSInteger payMethodId;          // 0 货到付款  1 支付宝 2 POS刷卡
@property (assign, nonatomic) NSInteger orderStatus;          //订单状态  0待审核 1审核通过 5已完成 6超时系统取消 7主动取消 9电话通知客服取消 10准备配送 11未通过审核取消 12订单拒收
@property (assign, nonatomic) float theAllMoney;              //总价
@property (assign, nonatomic) NSInteger productNum;           //商品数量
@property (retain, nonatomic) NSString *payMethodName;        //付款方式的名称
@property (assign, nonatomic) NSInteger payStatus;            //付款状态  1是付款成功 其他的都是没有成功

@property (retain, nonatomic) NSMutableArray *orderPackageArr; //订单中的包裹信息


// 返回订单状态的名称
- (NSString *)orderStatusName;
//需要显示支付宝支付
- (BOOL)needPayByAlipay;
- (BOOL)canBeCanceled;                                        


@end




/**
 *我订单列表中的订单里面的商品信息
 */
@interface OrderProductInfo : NSObject

@property (copy, nonatomic) NSString *productName;
@property (copy, nonatomic) NSString *productId;
@property (copy, nonatomic) NSString *orderId;
@property (copy, nonatomic) NSString *productPicture;
@property (copy, nonatomic) NSString *packageId;
@property (assign, nonatomic) NSInteger prescription;

//是不是处方药
- (BOOL) isOTC;

@end