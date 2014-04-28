//
//  CentralMobileFacadeService.m
//  TheStoreApp
//
//  Created by yangxd on 11-06-08.
//  Copyright 2011 vsc. All rights reserved.
//
//

#import "CentralMobileFacadeService.h"
#import "OTSUtility.h"

@implementation CentralMobileFacadeService

#pragma mark 客户端启动注册消息
-(int)registerLaunchInfo:(Trader *)trader iMei:(NSString *)iMei phoneNo:(NSString *)phoneNo {
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addString:iMei];
    [body addString:phoneNo];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}
-(NSArray*)getStartupPicVOList:(Trader*) trader Size:(NSString*)size SiteType:(NSNumber*)type{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addString:size];
    [body addLong:type];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        return (NSArray*)ret;
    } else {
        return nil;
    }

}
@end


