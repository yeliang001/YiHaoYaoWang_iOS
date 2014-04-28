//
//  SystemService.m
//  TheStoreApp
//
//  Created by linyy on 11-2-11.
//  Copyright 2011 vsc. All rights reserved.
//

#import "SystemService.h"
#import "OTSUtility.h"

@implementation SystemService

//更新客户端程序，判断是否有新的客户端并传递下载地址
-(DownloadVO *)getClientApplicationDownloadUrl:(Trader *)trader
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[DownloadVO class]]) {
        DownloadVO *po=(DownloadVO*)ret;
        return po;
    } else {
        return nil;
    }
}
//数据统计
-(int)doTracking:(Trader *)trader type:(NSNumber *)type url:(NSString *)theUrl
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addInteger:type];
    [body addString:theUrl];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]])
    {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}
//获取首页功能模块
-(NSArray *)getHomeModuleList:(Trader *)trader
{
    NSMutableDictionary* paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setDictionary:[trader toParamDict]];
    NSObject *ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd)
                         requestParameter:paramDict];
    [paramDict release];
    
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}
-(Page *)getQualityAppList:(Trader *)trader currentPage:(NSNumber*)currentPage pageSize:(NSNumber*)pageSize{
    
    NSMutableDictionary* paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setDictionary:[trader toParamDict]];
    if(currentPage)
        [paramDict setObject:currentPage forKey:@"currentPage"];
    if(pageSize)
        [paramDict setObject:pageSize forKey:@"pageSize"];
    
    NSObject *ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd)
                         requestParameter:paramDict];
    [paramDict release];
    if(ret != nil && [ret isKindOfClass:[Page class]])
    {
        Page * po = (Page*)[ret retain];
        return [po autorelease];
    } else {
        return nil;
    }
}

-(void)insertAppErrorLog:(Trader *)trader errorLog:(NSString *)errorLog token:(NSString *)token
{
// temporarily disabled
    return;
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addString:errorLog];
    [body addString:@""];
    [body addString:token];    
    [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
}
@end
