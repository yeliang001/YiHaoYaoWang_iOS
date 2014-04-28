//
//  MobilePromotionVO.h
//  TheStoreApp
//
//  Created by jiming huang on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MobilePromotionVO : NSObject {
@private
    NSDate * starteDate; /*促销活动开始时间*/
    NSDate * endDate;    /*促销活动结束时间*/
    NSNumber *promotionId;//促销活动id
    NSString *description;//促销活动描述
    NSString *title;//促销活动标题
    NSArray *productVOList;//产品列表 list<ProductVO>
    NSNumber *canJoin;//是否可参加此促销活动 0表示不可参加，1表示可参加
    NSNumber *contentValue;//优惠内容值
    NSNumber *promotionLevelId;//促销级别Id
}

@property(retain,nonatomic) NSDate * starteDate; /*促销活动开始时间*/
@property(retain,nonatomic) NSDate * endDate;    /*促销活动结束时间*/
@property(retain,nonatomic) NSNumber *promotionId;//促销活动id
@property(retain,nonatomic) NSString *description;//促销活动描述
@property(retain,nonatomic) NSString *title;//促销活动标题
@property(retain,nonatomic) NSArray *productVOList;//产品列表 list<ProductVO>
@property(retain,nonatomic) NSNumber *canJoin;//是否可参加此促销活动 0表示不可参加，1表示可参加
@property(retain,nonatomic) NSNumber *contentValue;//优惠内容值
@property(retain,nonatomic) NSNumber *promotionLevelId;//促销级别Id
@end
