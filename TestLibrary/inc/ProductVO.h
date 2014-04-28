//
//  ProductVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-1-19.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ProductRatingVO;



enum OTSProductType
{
    KOTSProductTypeNormal = 0
    , KOTSProductTypeShakeBuy       // 摇摇购
};


@interface ProductVO : NSObject {
@private
	NSString * advertisement;
	NSString * brandName;
	NSString * canBuy;
	NSString * cnName;
	NSString * code;
	NSString * description;
	NSString * enName;
	NSString * hotProductUrl;
	NSString * hotProductUrlForWinSys;
	NSNumber * maketPrice;
	NSNumber * merchantId;
	NSMutableArray * merchantIds;
	NSString * midleDefaultProductUrl;
	NSMutableArray * midleProductUrl;
	NSString * miniDefaultProductUrl;
	NSNumber * price;
	NSNumber * productId;
	ProductRatingVO * rating;
    NSNumber * shoppingCount;
    NSString * promotionId;
    NSNumber * promotionPrice;
    NSNumber * isYihaodian;//是否是1号店商家，0:否 1:是
    NSNumber * experienceCount;//商品的评价人数
    NSNumber * score;//商品的评价星级
    NSNumber * buyCount;//用户购买次数
    NSNumber * hasGift;//是否有赠品，0没有，1有
    NSNumber * stockNumber;//商品库存
    NSNumber * mobileProductType;//商品类型 1表示为1起摇商品
    NSNumber * rockJoinPeopleNum;//该商品的1起摇参加人数
    NSString * totalQuantityLimit;//商品的限制数量(赠品的限制数量)，根据限制类型来设置，若赠品类型为-1，则返回"限量当前库存xx个"，若为2则返回"每日限量xx个"，若为1则返回"限量xx个"
    NSNumber * quantity;//赠品的赠送数量
    NSNumber * isSoldOut;//赠品是否已售完
    NSNumber * isGift;//商品是否为赠品，1表示为赠品，0表示否，主要用于在订单中标识是否为赠品
    NSNumber * promotionSalePercent;//促销已售百分比=已销售数量/促销限制数量
}
@property(retain,nonatomic)NSString * advertisement;
@property(retain,nonatomic)NSString * brandName;
@property(retain,nonatomic)NSString * canBuy;
@property(retain,nonatomic)NSString * cnName;
@property(retain,nonatomic)NSString * code;
@property(retain,nonatomic)NSString * description;
@property(retain,nonatomic)NSString * enName;
@property(retain,nonatomic)NSString * hotProductUrl;
@property(retain,nonatomic)NSString * hotProductUrlForWinSys;
@property(retain,nonatomic)NSNumber * maketPrice;
@property(retain,nonatomic)NSNumber * merchantId;
@property(retain,nonatomic)NSMutableArray * merchantIds;
@property(retain,nonatomic)NSString * midleDefaultProductUrl;
@property(retain,nonatomic)NSMutableArray * midleProductUrl;
@property(retain,nonatomic)NSString * miniDefaultProductUrl;
@property(retain,nonatomic)NSNumber * price;
@property(retain,nonatomic)NSNumber * productId;
@property(retain,nonatomic)ProductRatingVO * rating;
@property(retain,nonatomic)NSNumber * shoppingCount;
@property(retain,nonatomic)NSString * promotionId;
@property(retain,nonatomic)NSNumber * promotionPrice;
@property(retain,nonatomic)NSNumber * isYihaodian;
@property(retain,nonatomic)NSNumber * experienceCount;
@property(retain,nonatomic)NSNumber * score;
@property(retain,nonatomic)NSNumber * buyCount;
@property(retain,nonatomic)NSNumber * hasGift;//是否有赠品，0没有，1有
@property(retain,nonatomic)NSNumber * stockNumber;//商品库存
@property(retain,nonatomic)NSNumber * mobileProductType;//商品类型 1表示为1起摇商品
@property(retain,nonatomic)NSNumber * rockJoinPeopleNum;//该商品的1起摇参加人数
@property(retain,nonatomic)NSString * totalQuantityLimit;//商品的限制数量(赠品的限制数量)，根据限制类型来设置，若赠品类型为-1，则返回"限量当前库存xx个"，若为2则返回"每日限量xx个"，若为1则返回"限量xx个"
@property(retain,nonatomic)NSNumber * quantity;//赠品的赠送数量
@property(retain,nonatomic)NSNumber * isSoldOut;//赠品是否已售完
@property(retain,nonatomic)NSNumber * isGift;//商品是否为赠品，1表示为赠品，0表示否，主要用于在订单中标识是否为赠品
@property(retain,nonatomic)NSNumber * promotionSalePercent;//促销已售百分比=已销售数量/促销限制数量
@end
