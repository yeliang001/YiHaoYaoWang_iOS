//
//  OptionalPromotionInCartVO.h
//  TheStoreApp
//
//  Created by towne on 13-1-14.
//
//

#import <Foundation/Foundation.h>

@interface OptionalPromotionInCartVO : NSObject{

@private
    NSNumber * promotionId;          //活动id
    NSNumber * promotionLevelId;     //活动层级id
    NSNumber * merchantId;           //商家id
    NSString * merchantName;         //商家名称
    NSString * title;                //活动名称
    NSString * description;          //活动描述
    NSNumber * sumprice  ;           //总价
    NSMutableArray * productItems;   //List for CartItemVO
    
    NSNumber * conditionType; //优惠条件
	
	NSNumber * conditionValue; //优惠条件值
	
	NSNumber * contentType; //优惠内容类型
	
	NSNumber * contentValue; //优惠内容值
    NSMutableArray *unionProductItemVOs;//list for UnionProductItemVO 此对象用来删除nn商品
}

@property(nonatomic,retain) NSNumber * promotionId;          //活动id
@property(nonatomic,retain) NSNumber * promotionLevelId;     //活动层级id

@property(nonatomic,retain) NSNumber * merchantId;           //商家id

@property(nonatomic,retain) NSString * merchantName;         //商家名称

@property(nonatomic,retain) NSString * title;                //活动名称

@property(nonatomic,retain) NSString * description;          //活动描述

@property(nonatomic,retain) NSNumber * sumprice  ;           //总价
@property(nonatomic,retain) NSMutableArray * productItems;   //List for CartItemVO

@property(nonatomic,retain) NSNumber * conditionType; //优惠条件

@property(nonatomic,retain) NSNumber * conditionValue; //优惠条件值

@property(nonatomic,retain) NSNumber * contentType; //优惠内容类型

@property(nonatomic,retain) NSNumber * contentValue; //优惠内容值
@property(nonatomic,retain)NSMutableArray *unionProductItemVOs;
-(NSString *)toXML;
 


@end
