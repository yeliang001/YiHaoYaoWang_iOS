//
//  OrderPackageInfo.h
//  TheStoreApp
//
//  Created by LinPan on 13-9-13.
//
//

#import <Foundation/Foundation.h>
@class ProductInfo;

/**
订单包裹中每个商品的详细
*/
@interface OrderProductDetail : NSObject
@property (retain, nonatomic) NSString *productId;     //商品
@property (retain, nonatomic) NSString *productStatus; //商品状态 0正常 1不正常 2取消
@property (retain, nonatomic) NSString *productCount;  //商品数量
@property (retain, nonatomic) NSString *goodsId;       //可能是itemid，tmd，傻逼啊，各种id
@property (retain, nonatomic) NSString *productNo;     //cnm,不知道是什么了，哪来这么多编号
@property (retain, nonatomic) NSString *weight;        //商品的重量
@property (retain, nonatomic) NSString *productName;
@property (retain, nonatomic) NSString *brandName;     //品牌名字
@property (retain, nonatomic) NSString *catelogName;   //分类名字
@property (retain, nonatomic) NSString *price;         //价格
@property (retain, nonatomic) NSString *catelogId;     //分类id
@property (retain, nonatomic) NSString *backMoney;
@property (retain, nonatomic) NSString *userName;
@property (retain, nonatomic) NSString *userId;
@property (retain, nonatomic) NSString *productMarque; //产品型号
@property (retain, nonatomic) NSString *brandId;
@property (retain, nonatomic) NSString *venderId;     //商品卖家id
@property (retain, nonatomic) NSString *splitLogs;    //包裹物流状态
@property (assign, nonatomic) NSInteger goodsType; //16是处方药
@property (assign, nonatomic) CGFloat promotionAmount;//该商品满减得钱

//处方药－》YES  
- (BOOL)isOTC;

@end


/**
 订单包裹信息
*/
@interface OrderPackageInfo : NSObject


@property (retain, nonatomic) NSString *venderId; //卖家Id
@property (retain, nonatomic) NSString *weight;
@property (retain, nonatomic) NSString *allGoodsMoney;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *packageId;
@property (retain, nonatomic) NSArray *packageProductArr; //包裹中商品数组
@property (retain, nonatomic) NSMutableArray *splitLogArr; //包裹物流记录的数组
//包裹中满减的金额
- (CGFloat)getRedeceMoneyByPromotion;

@end
