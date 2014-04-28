//
//  CouponService.m
//  TheStoreApp
//
//  Created by linyy on 11-2-12.
//  Copyright 2011 vsc. All rights reserved.
//

#import "CouponService.h"
#import "GlobalValue.h"
#import "OTSUtility.h"

@implementation CouponService

//获取我的抵用券
-(Page *)getMyCouponList:(NSString *)token currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[Page class]]) {
        Page *po=(Page*)ret;
        return po;
    } else {
        return nil;
    }
}

//我的1号店查询抵用卷
-(Page *)getMyCouponList:(NSString *)token type:(int)currentType currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addInteger:[NSNumber numberWithInt:currentType]];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[Page class]]) {
        Page *po=(Page*)ret;
        return po;
    } else {
        return nil;
    }
}

//订单查询可用抵用卷
-(Page *)getCouponListForSessionOrder:(NSString *)token currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[Page class]]) {
        Page *po=(Page*)ret;
        return po;
    } else {
        return nil;
    }
}

//保存抵用券到订单
-(CouponCheckResult *) saveCouponToSessionOrderV2:(NSString *)token couponNumber:(NSString *)couponNumber
{
    MethodBody *body = [[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addString:couponNumber];
    NSObject *ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if (ret!=nil && [ret isKindOfClass:[CouponCheckResult class]]) {
        CouponCheckResult *vo = (CouponCheckResult*)ret;
        return vo;
    }else
    {
        return nil;
    }
}

//获取验证码
-(CouponCheckResult *) getCouponCheckCode:(NSString *)token 
                                   mobile:(NSString *)mobile{
    MethodBody *body = [[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addString:mobile];
    NSObject *ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if (ret!=nil && [ret isKindOfClass:[CouponCheckResult class]]) {
        CouponCheckResult *vo = (CouponCheckResult*)ret;
        return vo;
    }else
    {
        return nil;
    }
}

//验证码验证
-(CouponCheckResult *) verifyCouponCheckCode:(NSString *)token
                                      mobile:(NSString *)mobile
                                   checkCode:(NSString *)checkCode{
    MethodBody *body = [[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addString:mobile];
    [body addString:checkCode];
    NSObject *ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if (ret!=nil && [ret isKindOfClass:[CouponCheckResult class]]) {
        CouponCheckResult *vo = (CouponCheckResult*)ret;
        return vo;
    }else
    {
        return nil;
    }
}

//删除订单抵用卷
-(CouponCheckResult *) deleteCouponFromSessionOrder:(NSString *)token
{
    MethodBody *body = [[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    NSObject *ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if (ret!=nil && [ret isKindOfClass:[CouponCheckResult class]]) {
        CouponCheckResult *vo = (CouponCheckResult*)ret;
        return vo;
    }else
    {
        return nil;
    }
}

@end
