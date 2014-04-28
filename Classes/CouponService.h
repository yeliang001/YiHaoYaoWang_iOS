//
//  CouponService.h
//  TheStoreApp
//
//  Created by linyy on 11-2-12.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheStoreService.h"
#import "Trader.h"
#import "MethodBody.h"
#import "CouponCheckResult.h"
@class Page;

@interface CouponService:TheStoreService{
}

//获取我的抵用券
-(Page *)getMyCouponList:(NSString *)token
             currentPage:(NSNumber *)currentPage
                pageSize:(NSNumber *)pageSize;


typedef enum
{
    kCouponTypeAll = 0      // 0:所有
    , kCouponTypeUnused     // 1:未使用
    , kCouponTypeUsed       // 2：已使用
    , kCouponTypeExpired    // 3：已过期
}OTSCouponType;

//我的1号店查询抵用卷
-(Page *)getMyCouponList:(NSString *)token
                    type:(int)currentType
             currentPage:(NSNumber *)currentPage
                pageSize:(NSNumber *)pageSize;

//订单查询可用抵用卷
-(Page *)getCouponListForSessionOrder:(NSString *)token
                          currentPage:(NSNumber *)currentPage 
                             pageSize:(NSNumber *)pageSize;

//保存抵用券到订单
-(CouponCheckResult *) saveCouponToSessionOrderV2:(NSString *)token 
                                     couponNumber:(NSString *)couponNumber;

//获取验证码
-(CouponCheckResult *) getCouponCheckCode:(NSString *)token 
                                   mobile:(NSString *)mobile;

//验证码验证
-(CouponCheckResult *) verifyCouponCheckCode:(NSString *)token
                                      mobile:(NSString *)mobile
                                   checkCode:(NSString *)checkCode;

//删除订单抵用卷
-(CouponCheckResult *) deleteCouponFromSessionOrder:(NSString *)token;

@end
