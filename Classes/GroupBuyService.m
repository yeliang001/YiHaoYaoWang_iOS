//
//  GroupBuyService.m
//  TheStoreApp
//
//  Created by jiming huang on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GroupBuyService.h"
#import "OTSUtility.h"

@implementation GroupBuyService

-(NSArray *)getGrouponCategoryList:(Trader *)trader areaId:(NSNumber *)areaId
{
    MethodBody * body = [[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:areaId];
    
    NSObject * ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret != nil && [ret isKindOfClass:[NSArray class]])
    {
        NSArray * po = (NSArray*)[ret retain];
        return [po autorelease];
    } else {
        return nil;
    }
}

-(Page *)getCurrentGrouponList:(Trader *)trader areaId:(NSNumber *)areaId categoryId:(NSNumber *)categoryId currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize
{
    MethodBody * body = [[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:areaId];
    [body addLong:categoryId];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    
    NSObject * ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret != nil && [ret isKindOfClass:[Page class]])
    {
        Page * po = (Page*)[ret retain];
        return [po autorelease];
    } else {
        return nil;
    }
}

-(NSArray *)getGrouponAreaList:(Trader *)trader
{
    NSMutableDictionary* paramDict = [[NSMutableDictionary alloc] initWithDictionary:[trader toParamDict]];
    NSObject* ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) requestParameter:paramDict];
    [paramDict release];
    
    if(ret != nil && [ret isKindOfClass:[NSArray class]])
    {
        NSArray * po = (NSArray*)[ret retain];
        return [po autorelease];
    } else {
        return nil;
    }
}

-(NSNumber *)getGrouponAreaIdByProvinceId:(Trader *)trader provinceId:(NSNumber *)provinceId
{
    NSMutableDictionary* paramDict = [[NSMutableDictionary alloc] initWithDictionary:[trader toParamDict]];
    if(provinceId)
        [paramDict setObject:provinceId forKey:@"provinceId"];
    NSObject* ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) requestParameter:paramDict];
    [paramDict release];
    
    if(ret != nil && [ret isKindOfClass:[NSNumber class]])
    {
        NSNumber * po = (NSNumber*)[ret retain];
        return [po autorelease];
    } else {
        return nil;
    }
}

-(GrouponVO *)getGrouponDetail:(Trader *)trader grouponId:(NSNumber *)grouponId areaId:(NSNumber *)areaId
{
    MethodBody * body = [[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:grouponId];
    [body addLong:areaId];
    
    NSObject * ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret != nil && [ret isKindOfClass:[GrouponVO class]])
    {
        GrouponVO * po = (GrouponVO*)[ret retain];
        return [po autorelease];
    } else {
        return nil;
    }
}

-(GrouponOrderVO *)createGrouponOrder:(NSString *)token grouponId:(NSNumber *)grouponId serialId:(NSNumber *)serialId areaId:(NSNumber *)areaId
{
    MethodBody * body = [[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:grouponId];
    [body addLong:serialId];
    [body addLong:areaId];
    
    NSObject * ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret != nil && [ret isKindOfClass:[GrouponOrderVO class]])
    {
        GrouponOrderVO * po = (GrouponOrderVO*)[ret retain];
        return [po autorelease];
    } else {
        return nil;
    }
}

-(GrouponOrderSubmitResult *)submitGrouponOrder:(NSString *)token grouponId:(NSNumber *)grouponId serialId:(NSNumber *)serialId quantity:(NSNumber *)quantity receiverId:(NSNumber *)receiverId payByAccount:(NSNumber *)payByAccount grouponRemarker:(NSString *)grouponRemarker areaId:(NSNumber *)areaId  gatewayId:(NSNumber *)gatewayId
{
    MethodBody * body = [[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:grouponId];
    [body addLong:serialId];
    [body addLong:quantity];
    [body addLong:receiverId];
    [body addDouble:payByAccount];
    [body addString:grouponRemarker];
    [body addLong:areaId];
    [body addLong:gatewayId];
    
    NSObject * ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret != nil && [ret isKindOfClass:[GrouponOrderSubmitResult class]])
    {
        GrouponOrderSubmitResult * po = (GrouponOrderSubmitResult*)[ret retain];
        return [po autorelease];
    } else {
        return nil;
    }
}

-(GrouponOrderVO *)getMyGrouponOrder:(NSString *)token orderId:(NSNumber *)orderId
{
    MethodBody * body = [[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLongLong:orderId];
    
    NSObject * ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret != nil && [ret isKindOfClass:[GrouponOrderVO class]])
    {
        GrouponOrderVO * po = (GrouponOrderVO*)[ret retain];
        return [po autorelease];
    } else {
        return nil;
    }
}

-(Page *)getMyGrouponList:(NSString *)token type:(NSNumber *)type currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize
{
    MethodBody * body = [[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addInteger:type];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    
    NSObject * ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret != nil && [ret isKindOfClass:[Page class]])
    {
        Page * po = (Page*)[ret retain];
        return [po autorelease];
    } else {
        return nil;
    }
}

-(int)saveGateWayToGrouponOrder:(NSString *)token orderId:(NSNumber *)orderId gatewayId:(NSNumber *)gatewayId
{
    MethodBody * body = [[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLongLong:orderId];
    [body addLong:gatewayId];
    NSObject * ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret != nil && [ret isKindOfClass:[NSNumber class]])
    {
        NSNumber * po = (NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}

-(int)updateOrderFinish:(NSString *)token orderId:(NSNumber *)orderId
{
    MethodBody * body = [[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLongLong:orderId];
    NSObject * ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret != nil && [ret isKindOfClass:[NSNumber class]])
    {
        NSNumber * po = (NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}

-(Page *)getCurrentGrouponList:(Trader *)trader areaId:(NSNumber *)areaId categoryId:(NSNumber *)categoryId sortAttrId:(NSNumber*)sortId currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize
{
    MethodBody * body = [[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:areaId];
    [body addLong:categoryId];
    
	[body addInteger:sortId];
    
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    
    NSObject * ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret != nil && [ret isKindOfClass:[Page class]])
    {
        Page * po = (Page*)[ret retain];
        return [po autorelease];
    } else {
        return nil;
    }
}

-(Page *)getCurrentGrouponList:(Trader *)trader areaId:(NSNumber *)areaId categoryId:(NSNumber *)categoryId sortType:(NSNumber*)sortType siteType:(NSNumber *)siteType currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize
{
    MethodBody * body = [[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:areaId];
    [body addLong:categoryId];
    [body addInteger:sortType];
    [body addInteger:siteType];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    
    NSObject * ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret != nil && [ret isKindOfClass:[Page class]])
    {
        Page * po = (Page*)[ret retain];
        return [po autorelease];
    } else {
        return nil;
    }
}

-(NSArray *)getGroupOnSortAttribute:(Trader *)trader AreaId:(NSNumber*)areaId{
    
    NSMutableDictionary* paramDict = [[NSMutableDictionary alloc] initWithDictionary:[trader toParamDict]];
    if(areaId)
        [paramDict setObject:areaId forKey:@"areaId"];
    
    NSObject* ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) requestParameter:paramDict];
    [paramDict release];

    if(ret != nil && [ret isKindOfClass:[NSArray class]])
    {
        NSArray * po = (NSArray*)[ret retain];
        return [po autorelease];
    } else {
        return nil;
    }
	
}

@end
