//
//  DoTracking.m
//  TheStoreApp
//
//  Created by jiming huang on 12-6-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DoTracking.h"
#import "SystemService.h"
#import "GlobalValue.h"
#import "OTSServiceHelper.h"
#import <commoncrypto/CommonDigest.h>
@implementation DoTracking
//统计类型为1
+(void)doTracking:(NSString *)url
{
    [self otsDetatchMemorySafeNewThreadSelector:@selector(doTrackingWithURL:) toTarget:self withObject:url];
}

+(void)doTrackingWithURL:(NSString *)url
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    SystemService *service=[[SystemService alloc] init];
    @try {
        int result=[service doTracking:[GlobalValue getGlobalValueInstance].trader type:[NSNumber numberWithInt:1] url:url];
        
        DebugLog(@"====%d",result);

    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    [service release];
    [pool drain];
}
+(void)doTrackingLaunch:(int)launchType{
    [self otsDetatchMemorySafeNewThreadSelector:@selector(registerLaunchIphone:) toTarget:self withObject:[NSNumber numberWithInt:launchType]];
}
+(void)registerLaunchIphone:(NSNumber*)launchType
{
    NSAutoreleasePool * pool=[[NSAutoreleasePool alloc]init];
    NSString* type;
    switch ([launchType intValue]) {
        case 0:
            type = @"00";   // 正常启动
            break;
        case 1:
            type = @"01";   // 物流查询推送启动
            break;
        case 2:
            type = @"02";   // 活动推送启动
            break;
        case 3:
            type = @"03";   // 订单物流推送启动
            break;
        case 4:
            type = @"04";   // 其他推送启动
            break;
        default:
            break;
    }
    [[OTSServiceHelper sharedInstance]  registerLaunchInfo:[GlobalValue getGlobalValueInstance].trader iMei:@"" phoneNo:type];
    
    [pool drain];
}
//统计类型为2
+(void)doTrackingSecond:(NSString *)url
{
    [self otsDetatchMemorySafeNewThreadSelector:@selector(doTrackingWithURLSecond:) toTarget:self withObject:url];
}

+(void)doTrackingWithURLSecond:(NSString *)url
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    SystemService *service=[[SystemService alloc] init];
    @try {
        int result=[service doTracking:[GlobalValue getGlobalValueInstance].trader type:[NSNumber numberWithInt:2] url:url];

        DebugLog(@"====%d",result);

    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    [service release];
    [pool drain];
}

+(void)newThreadDoTracking:(NSString *)url type:(int)type
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    SystemService *service=[[SystemService alloc] init];
    @try {
        int result=[service doTracking:[GlobalValue getGlobalValueInstance].trader type:[NSNumber numberWithInt:type] url:url];

        DebugLog(@"====%d",result);

    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    [service release];
    [pool drain];
}
+(void)doJsTrackingWithParma:(JSTrackingPrama*)prama{
    @autoreleasepool {
        ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[prama toURL]];
        [request setRequestMethod:@"GET"];
        [request setUseCookiePersistence:NO];
        //cookie 构造
        // sessionId
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:@"tracker_msessionid" forKey:NSHTTPCookieName];
        [cookieProperties setObject:[GlobalValue getGlobalValueInstance].sessionID forKey:NSHTTPCookieValue];
        [cookieProperties setObject:@"tracker.yihaodian.com" forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
        [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
        NSHTTPCookie* cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
        // gu_id
        NSMutableDictionary *cookieProperties1 = [NSMutableDictionary dictionary];
        [cookieProperties1 setObject:@"global_user_sign" forKey:NSHTTPCookieName];
        [cookieProperties1 setObject:[GlobalValue getGlobalValueInstance].trader.deviceCode forKey:NSHTTPCookieValue];
        [cookieProperties1 setObject:@"tracker.yihaodian.com" forKey:NSHTTPCookieDomain];
        [cookieProperties1 setObject:@"/" forKey:NSHTTPCookiePath];
        [cookieProperties1 setObject:@"0" forKey:NSHTTPCookieVersion];
        NSHTTPCookie *cookie1 = [NSHTTPCookie cookieWithProperties:cookieProperties1];
        
        [request setRequestCookies:[NSMutableArray arrayWithObjects:cookie,cookie1,nil]];
        
        DebugLog(@"the cookie is:%@",[NSMutableArray arrayWithObjects:cookie,cookie1,nil]);
        [request startAsynchronous];
        
//        [request startSynchronous];
//        
//        NSError *error = [request error];
//        
//        if (!error) {
//            
//            NSString *response = [request responseString];
//            DebugLog(@"%@",response);
//            
//        }
    }
}

@end
