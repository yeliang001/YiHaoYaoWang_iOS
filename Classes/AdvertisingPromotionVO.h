//
//  AdvertisingPromotionVO.h
//  TheStoreApp
//
//  Created by jiming huang on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvertisingPromotionVO : NSObject {
@private
    NSString *title; // 广告名称
    NSArray *keywordList;//List<String>关键字列表
    NSNumber *advertisingType;//模块类型，1表示模块A向左，2表示模块A向右，0表示模块B
    NSArray *hotPointNewVOList;//List<HotPointNewVO>对应活动列表(如果为模块A则第一个默认显示为大图活动；如果为模块B则第一个显示模块B的logo和名称、第二个默认显示为商品位促销活动)
    
}

@property(nonatomic,retain) NSString *title; // 广告名称
@property(nonatomic,retain) NSArray *keywordList;//List<String>关键字列表
@property(nonatomic,retain) NSNumber *advertisingType;//模块类型，1表示模块A向左，2表示模块A向右，0表示模块B
@property(nonatomic,retain) NSArray *hotPointNewVOList;//List<HotPointNewVO>对应活动列表(如果为模块A则第一个默认显示为大图活动；如果为模块B则第一个显示模块B的logo和名称、第二个默认显示为商品位促销活动)

-(NSMutableDictionary *)dictionaryFromVO;
+(id)voFromDictionary:(NSMutableDictionary *)mDictionary;
@end
