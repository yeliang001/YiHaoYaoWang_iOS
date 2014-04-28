//
//  ProductVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-1-19.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MerchantInfoVO.h"
@class ProductRatingVO;



enum OTSProductType
{
    KOTSProductTypeNormal = 0
    , KOTSProductTypeShakeBuy       // 摇摇购
};


@interface ProductVO : NSObject <NSCoding>{
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
	
	NSNumber * merchantId;
	NSMutableArray * merchantIds;
	NSString * midleDefaultProductUrl;
	NSMutableArray * midleProductUrl;
	NSString * miniDefaultProductUrl;
    NSMutableArray *product600x600Url;//增加3个字段
    NSMutableArray *product380x380Url;
    NSMutableArray *product80x80Url;
    
    NSNumber * maketPrice;
	NSNumber * price;
    NSNumber * promotionPrice;
    
	NSNumber * productId;
	ProductRatingVO * rating;
    NSNumber * shoppingCount;
    NSString * promotionId;
    
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
    NSString * stockDesc;   // 库存信息
    
    NSString * hasCash;        //满减活动  ""或者NULL表示没有满减活动其他表示满减活动的名称
    NSNumber * hasRedemption ; //是否参加换购活动  0-否；1-是
    
    NSMutableArray * colorList;            // 系列产品所有尺寸属性集合,数组对象为SeriesColorVO
    NSMutableArray * sizeList;             // 系列商品集合,数组对象为nsstring
    NSMutableArray * seriesProductVOList;  // 系列商品集合,数组对象为SeriesProductVO
    NSNumber * famousSalePrice;            // 名品特卖价格
    MerchantInfoVO * merchantInfoVO;       // 商家信息
	NSString* isMingPin;                   // 0-非名品特卖；1-名品特卖（空表示不是特价商品取商城价）
	NSNumber* mingPinRemainTimes;          // 距离名品特卖结束时间(毫秒)
    
    NSString * mallDefaultURL;             // website 店中店地址
    NSString * offerName;//N元n件活动名称
    NSNumber * isFresh;  //是否生鲜商品  1-是，0-不是
    NSNumber * cmsPointProduct;//CMS积分兑换商品 1-是、0-不是
    NSNumber * activitypoint ;//商品需要的积分
    NSDate   * startTime; //促销开始时间
    NSDate   * endTime;   //促销结束时间
    NSString * canSecKill;     //商品是否能够秒杀(非数据库值)
    NSString * ifSecKill;      //商品是否是秒杀(非数据库值)
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
@property(copy,nonatomic)NSString * midleDefaultProductUrl;
@property(retain,nonatomic)NSMutableArray * midleProductUrl;
@property(retain,nonatomic)NSString * miniDefaultProductUrl;
@property(retain,nonatomic) NSMutableArray *product600x600Url;
@property(retain,nonatomic) NSMutableArray *product380x380Url;
@property(retain,nonatomic) NSMutableArray *product80x80Url;
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
@property(retain,nonatomic)NSString * stockDesc;
@property(retain,nonatomic)NSString * hasCash;           //满减
@property(retain,nonatomic)NSNumber * hasRedemption;     //换购
@property(retain,nonatomic)NSMutableArray * colorList;            // 系列产品所有尺寸属性集合,数组对象为SeriesColorVO
@property(retain,nonatomic)NSMutableArray * sizeList;             // 系列商品集合,数组对象为nsstring
@property(retain,nonatomic)NSMutableArray * seriesProductVOList;  // 系列商品集合,数组对象为SeriesProductVO
@property(retain,nonatomic)NSNumber * famousSalePrice;            // 名品特卖价格
@property(retain,nonatomic)MerchantInfoVO * merchantInfoVO;       // 商家信息
@property(retain,nonatomic)NSString* isMingPin;                   // 0-非名品特卖；1-名品特卖（空表示不是特价商品取商城价）
@property(retain,nonatomic)NSNumber* mingPinRemainTimes;          // 距离名品特卖结束时间(毫秒)

@property(retain,nonatomic)NSString * mallDefaultURL;            // website 店中店地址
@property(retain,nonatomic)NSString * offerName;//N元n件活动名称
@property(retain,nonatomic)NSNumber * isFresh;  //是否生鲜商品  1-是，0-不是
@property(retain,nonatomic)NSNumber * cmsPointProduct;//CMS积分兑换商品 1-是、0-不是
@property(retain,nonatomic)NSNumber * activitypoint ;//商品需要的积分
@property(retain,nonatomic)NSDate   * startTime; //促销开始时间
@property(retain,nonatomic)NSDate   * endTime;   //促销结束时间
@property(retain,nonatomic)NSString * canSecKill;     //商品是否能够秒杀
@property(retain,nonatomic)NSString * ifSecKill;      //商品是否是秒杀


// extra property
@property NSUInteger        purchaseAmount; // 本次购买数量

-(ProductVO*)clone;
-(NSString*)miniURL;
-(NSString *)toXML;

-(BOOL)isInPromotion;
-(BOOL)isLandingPage;
-(BOOL)isCanBuy;
-(BOOL)isGiftProduct;
-(BOOL)isProductSoldOut;
-(BOOL)isJoinCash;
-(BOOL)isJoinRedemption;
-(BOOL)isLandingpage;
-(BOOL)isFreshProduct;   //是否生鲜商品
-(BOOL)isSeckillProduct; //是否秒杀商品
-(BOOL)ifSeckillProduct;  //是否是秒杀商品，非时间判断
-(BOOL)canSecKillProduct; //能否秒杀
-(BOOL)SeckillEnd;       //秒杀结束
-(NSString *)SeckillCountdown; // 秒杀倒计时

-(NSNumber*)realPrice;
-(NSString*)priceStringTrimZero:(NSNumber*)aPrice;
-(NSString*)realPromotionID;
-(BOOL)isTheSameWithProduct:(ProductVO*)aProductVO;
-(NSMutableDictionary *)dictionaryFromVO;
+(id)voFromDictionary:(NSMutableDictionary *)mDictionary;
@end
