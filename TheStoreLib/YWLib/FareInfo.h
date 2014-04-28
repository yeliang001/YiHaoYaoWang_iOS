//
//  FareInfo.h
//  TheStoreApp
//
//  Created by LinPan on 13-9-13.
//
//  运费信息

#import <Foundation/Foundation.h>

@interface FareInfo : NSObject

@property (retain, nonatomic) NSString *totalReturnMoney;
@property (retain, nonatomic) NSString *totalCount;  //商品总数
@property (retain, nonatomic) NSString *totalMoney; //商品总价
@property (assign, nonatomic) BOOL isPos;   //是否支持pos刷卡
@property (assign, nonatomic) BOOL isCod;   //是否支持货到付款
@property (retain, nonatomic) NSString *goodsId; //商品id
@end
