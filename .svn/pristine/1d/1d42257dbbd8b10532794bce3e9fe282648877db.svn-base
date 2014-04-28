//
//  AdvertisingPromotion.h
//  TheStoreApp
//
//  Created by jiming huang on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvertisingPromotion : NSObject {
@private
    NSArray *advertisingPromotionVOList;//模块列表
    NSNumber *isUpdate;//是否更新  0-未更新 ；1-已更新
    NSString *updateTag;//更新标记
}

@property(nonatomic,retain) NSArray *advertisingPromotionVOList;//模块列表
@property(nonatomic,retain) NSNumber *isUpdate;//后台是否更新  0-未更新 ；1-已更新
@property(nonatomic,retain) NSString *updateTag;//更新标记

-(NSMutableDictionary *)dictionaryFromVO;
+(id)voFromDictionary:(NSMutableDictionary *)mDictionary;
@end
