//
//  RockProductV2.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-1.
//
//

#import <Foundation/Foundation.h>
#import "ProductVO.h"

typedef enum {
    kRockProductNotBuy = 0      // 0-未购买
    , kRockProductHasAddCart    // 1-已加入购物车
    , kRockProductHasBuy        // 2-已购买
    , kRockProductExpired       // 3-已过期
}OTSRockProductStatus;

@interface RockProductV2 : NSObject
@property (retain) ProductVO *prodcutVO;        // 商品详情
@property (retain) NSNumber *productAging;      // 商品时效(毫秒)
@property (retain) NSNumber *rockProductType;   //  商品是状态：0-未购买；1-已加入购物车；2-已购买；3-已过期

-(OTSRockProductStatus)getStatus;
-(void)updateMyExpTime;

// extra property
@property (retain) NSDate   *expireDate;

@end

