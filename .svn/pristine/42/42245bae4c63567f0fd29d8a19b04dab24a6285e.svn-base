//
//  CartVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartVO : NSObject {
@private
	NSMutableArray * buyItemList;
	NSMutableArray * gifItemtList;
    NSMutableArray * cashPromotionList;
    NSMutableArray * redemptionItemList;
	NSNumber * totalprice;
	NSNumber * totalquantity;
	NSNumber * totalsavedprice;
    NSNumber * totalWeight;
    NSNumber * cashAmount;//促销立减额
    /**
     * 是否是1号店购物车: 1 1号店、2 1号商城
     */
    NSNumber* isYiHaoDianCart;
    
    /**
     * 1号商城购物车的总金额
     */
    NSNumber* totalpriceMall;
    
    /**
     * 1号商场购物车的总数量
     */
    NSNumber* totalquantityMall;
    
    /**
     * 店中店购物袋集合
     */
    NSMutableArray* cartBagVOs; // 对象CartBagVO
    /**
     * n元n件活动列表
     * OptionalPromotionInCartVO
     */
    NSMutableArray* optionalPromotionList;
    NSNumber*   totalNeedPoint ;//需要的总积分数量
    NSNumber*   totalNeedPointMall ;//1号商城需要的总积分数量
    NSString* hasFreePromotion;//     是否有免费促销领取
    
    NSMutableArray * mobileGifItemtList;        //促销缓存 赠品
    NSMutableArray * mobileRedemptionItemList;  //促销缓存 换购
}
@property(retain,nonatomic)NSMutableArray * buyItemList;
@property(retain,nonatomic)NSMutableArray * gifItemtList;
@property(retain,nonatomic)NSMutableArray * cashPromotionList;
@property(retain,nonatomic)NSMutableArray * redemptionItemList;
@property(retain,nonatomic)NSNumber * totalprice;
@property(retain,nonatomic)NSNumber * totalquantity;
@property(retain,nonatomic)NSNumber * totalsavedprice;
@property(retain,nonatomic)NSNumber * totalWeight;
@property(retain,nonatomic)NSNumber * cashAmount;
@property(retain,nonatomic)NSNumber* isYiHaoDianCart;
@property(retain,nonatomic)NSNumber* totalpriceMall;
@property(retain,nonatomic)NSNumber* totalquantityMall;
@property(retain,nonatomic)NSMutableArray* cartBagVOs;
@property(retain,nonatomic)NSMutableArray* optionalPromotionList;
@property(nonatomic,retain)    NSNumber*   totalNeedPoint ;//需要的总积分数量
@property(nonatomic,retain)  NSNumber*   totalNeedPointMall ;//1号商城需要的总积分数量
@property(nonatomic,retain)    NSString *hasFreePromotion;//true or false
@property(nonatomic,retain) NSMutableArray * mobileGifItemtList;        //促销缓存 赠品
@property(nonatomic,retain) NSMutableArray * mobileRedemptionItemList;  //促销缓存 换购
-(NSUInteger)realtimeTotalQuantity;
-(float)realTotalPrice;

@end
