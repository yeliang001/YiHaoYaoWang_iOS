//
//  AddressService.m
//  TheStoreApp
//
//  Created by linyy on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import "AddressService.h"
#import "OTSUtility.h"

@implementation AddressService

//删除收获地址
-(int)deleteGoodReceiverByToken:(NSString *)token goodReceiverId:(NSNumber *)goodReceiverId
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:goodReceiverId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}

-(void)foo
{
    [OTSUtility getInterfaceNameFromSelector:_cmd];
}

//获取1号店支持的所有的省份
-(NSArray *)getAllProvince:(Trader *)trader
{
    NSMutableDictionary* paramDict = [[NSMutableDictionary alloc] initWithDictionary:[trader toParamDict]];
    NSObject *ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) requestParameter:paramDict];
    [paramDict release];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}
//根据省份ID，获取1号店支持的所有的市/区县
-(NSArray *)getCityByProvinceId:(Trader *)trader provinceId:(NSNumber *)provinceId
{
    NSMutableDictionary* paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setDictionary:[trader toParamDict]];
    if(provinceId)
        [paramDict setObject:provinceId forKey:@"provinceId"];
    
    NSObject* ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) requestParameter:paramDict];
    [paramDict release];
    
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}
//根据市/区县ID，获取1号店支持的所有的地区
-(NSArray *)getCountyByCityId:(Trader *)trader cityId:(NSNumber *)cityId
{
    NSMutableDictionary* paramDict = [[NSMutableDictionary alloc] initWithDictionary:[trader toParamDict]];
    if(cityId)
        [paramDict setObject:cityId forKey:@"cityId"];
    NSObject* ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) requestParameter:paramDict];
    [paramDict release];
    
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}

//获取所有的收货地址列表
-(NSArray *)getGoodReceiverListByToken:(NSString *)token
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}
//添加新的收获地址
-(int)insertGoodReceiverByToken:(NSString *)token goodReceiverVO:(GoodReceiverVO *)goodReceiverVO
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addGoodReceiverVO:goodReceiverVO];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}
//更新收货地址信息
-(int)updateGoodReceiverByToken:(NSString *)token goodReceiverVO:(GoodReceiverVO *)goodReceiverVO
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addGoodReceiverVO:goodReceiverVO];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}
//添加新的收货地址(上海、北京)
-(int)insertGoodReceiverByToken:(NSString *)token goodReceiverVO:(GoodReceiverVO *)goodReceiverVO lngs:(NSArray *)lngs lats:(NSArray *)lats
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addGoodReceiverVO:goodReceiverVO];
    [body addArrayForDouble:lngs];
    [body addArrayForDouble:lats];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}
//更新收货地址信息(上海、北京)
-(int)updateGoodReceiverByToken:(NSString *)token goodReceiverVO:(GoodReceiverVO *)goodReceiverVO lngs:(NSArray *)lngs lats:(NSArray *)lats
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addGoodReceiverVO:goodReceiverVO];
    [body addArrayForDouble:lngs];
    [body addArrayForDouble:lats];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}
@end
