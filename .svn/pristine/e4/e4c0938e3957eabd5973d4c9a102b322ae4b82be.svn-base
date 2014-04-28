//
//  StorageBoxVO.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-2.
//
//

#import <Foundation/Foundation.h>
#import "RockProductV2.h"
#import "RockCouponVO.h"


typedef enum {
    kRockBoxItemProduct = 1     // 1-促销商品
    , kRockBoxItemTicket        // 2-抵用券
}OTSRockBoxItemType;


@interface StorageBoxVO : NSObject
@property (retain) NSNumber             *type;              // 寄存箱商品类型 1-促销商品；2-抵用券
@property (retain) RockProductV2        *rockProductV2;     // 促销商品
@property (retain) RockCouponVO         *rockCouponVO;      // 抵用券


-(OTSRockBoxItemType)getItemType;
-(NSDate*)expireTime;

// 这种判定方式有可能存在问题
-(BOOL)isTheSame:(StorageBoxVO*)aStorageBox;
@end

