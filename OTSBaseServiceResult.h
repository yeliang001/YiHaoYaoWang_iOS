//
//  OTSBaseServiceResult.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-2.
//
//

#import <Foundation/Foundation.h>

@interface OTSBaseServiceResult : NSObject
@property (retain) NSNumber         *resultCode;    // 0: failed,  1: succeeded
@property (copy) NSString           *errorInfo;


-(BOOL)isSuccess;

@end



typedef enum
{
    kWrCheckRockResultOK                = 1
    , kWrCheckRockResultInBox           = -1
    , kWrCheckRockResultHasTheTicket    = -2
    , kWrCheckRockResultInCart          = -3
}OTSCheckRockResultResultCode;
// 判断摇出的商品是否未结算
@interface CheckRockResultResult : OTSBaseServiceResult
@end

typedef enum
{
    kWrAddCouponResultSuccess           = 1
    , kWrAddCouponResultActNotFound     = -1
    , kWrAddCouponResultActNotBegin     = -2
    , kWrAddCouponResultActIsOver       = -3
    , kWrAddCouponResultReachMax        = -4
    , kWrAddCouponResultPlsRockTicket   = -5
    , kWrAddCouponResultReachLimit      = -6
    , kWrAddCouponResultFailed          = -7
}OTSAddCouponByActivityResultCode;
// 通过活动Id添加抵用券到用户
@interface AddCouponByActivityIdResult : OTSBaseServiceResult
@end


// 添加商品或抵用券到我的寄存箱
@interface AddStorageBoxResult : OTSBaseServiceResult
@end

@interface InviteeResult  : OTSBaseServiceResult
@end

@interface CommonRockResultVO : OTSBaseServiceResult
@end

@interface PushMappingResult : OTSBaseServiceResult

@end
