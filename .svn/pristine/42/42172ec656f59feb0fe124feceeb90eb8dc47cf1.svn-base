//
//  RockCouponVO.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-2.
//
//

#import <Foundation/Foundation.h>
#import "CouponVO.h"

typedef enum {
    kRockTicketNotAcceptted = 0     // 0-未领取
    , kRockTicketAcceptted          // 1-已领取
}OTSRockTicketStatus;

@interface RockCouponVO : NSObject
@property (retain) CouponVO     *couponVO;      // 抵用券详情
@property (retain) NSNumber     *activityId;    // 活动Id
@property (retain) NSNumber     *isReceived;    // 是否已领取 0-未领取；1-已领取


-(OTSRockTicketStatus)getStatus;

@end
