//
//  FavoriteService.m
//  TheStoreApp
//
//  Created by linyy on 11-2-12.
//  Copyright 2011 vsc. All rights reserved.
//

#import "FavoriteService.h"
#import "GlobalValue.h"
#import "OTSUtility.h"

@implementation FavoriteService

//添加一个产品到我的收藏
-(int)addFavorite:(NSString *)token tag:(NSString *)tag productId:(NSNumber *)productId
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addString:tag];
    [body addLong:productId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}
//从我的收藏删除一个产品
-(int)delFavorite:(NSString *)token productId:(NSNumber *)productId
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:productId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}
//获取我的收藏夹列表
-(Page *)getMyFavoriteList:(NSString *)token tag:(NSString *)tag currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addString:tag];
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

@end
