//
//  RockResultV2.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-1.
//
//

#import <Foundation/Foundation.h>


typedef enum {
    kRockResultPromotion = 0    // 0-促销商品
    , kRockResultTicket         // 1-抵用券
    , kRockResultGame           // 2-游戏
    , kRockResultNormal         // 3-普通商品
    , kRockResultGroupon        // 4-团购商品列表
    , kRockResultPrize          // 5-奖品列表
    , kRockResultSale           // 6-特价商品列表
}OTSRockResultType;

@interface RockResultV2 : NSObject
@property (retain) NSNumber         *resultType; // 0-促销商品；1-抵用券；2-游戏；3-普通商品；4-团购商品列表；5-奖品列表；6-特价商品列表

@property (retain) NSMutableArray   *couponVOList;  // 抵用券列表, item type = RockCouponVO
@property (retain) NSMutableArray   *rockProductV2List; // 促销商品列表, item type = RockProductV2
@property (retain) NSMutableArray   *productVOList; // 普通商品列表, item type = ProductVO
@property (retain) NSMutableArray   *prizeProductVOList;//特价商品列表
@property (retain) NSMutableArray   *grouponVOList; // 团购商品列表
-(OTSRockResultType)getResultType;
-(BOOL)isValid;

@end

