//
//  ConnectUrl.m
//  TheStoreApp
//
//  Created by linyy on 11-1-21.
//  Copyright 2011 vsc. All rights reserved.


#import "ConnectUrl.h"

#define TESTING_URL     @"http://192.168.8.132:80/centralmobile/servlet/CentralMobileFacadeServlet"             // testing环境
#define STAGING_URL     @"http://222.73.105.106:80/centralmobile/servlet/CentralMobileFacadeServlet"            // staging环境
#define PRODUCTION_URL  @"http://interface.m.yihaodian.com/centralmobile/servlet/CentralMobileFacadeServlet"    // 线上

#define URL_SETTING_KEY @"addr"

@implementation ConnectUrl

+(NSString *)getConnectUrlAddressWithType:(EOTSEnvironmentType) aEnvironmentType
{
	NSString* addr = [[NSUserDefaults standardUserDefaults] objectForKey:URL_SETTING_KEY];
	//NSLog(@">>>>>>>>>>>>>>++++++++>>>>>>>%@",addr);
    if (addr == nil)
    {
        addr = PRODUCTION_URL;
        [[NSUserDefaults standardUserDefaults] setValue:addr forKey:URL_SETTING_KEY];
    }
    return addr;

	
    switch (aEnvironmentType) 
    {
        case KOTSEnvironmentTesting:
            return TESTING_URL;
            break;
            
        case KOTSEnvironmentStaging:
            return STAGING_URL;
            break;
            
        case KOTSEnvironmentProduction:
            return PRODUCTION_URL;
            break;
            
        case KOTSEnvironmentEmergency:
            return EMERGENCY_URL;
            break;
            
        default:
            break;
    }
    
    return nil;
    
    //return @"http://192.168.130.161:8088/centralmobile/servlet/CentralMobileFacadeServlet";//张威
    //return @"http://211.144.198.139:80/centralmobile/servlet/CentralMobileFacadeServlet";//外网
    //return @"http://192.168.130.205:8080/centralmobile/servlet/CentralMobileFacadeServlet";
    //return @"http://192.168.128.233:8080/centralmobile/servlet/CentralMobileFacadeServlet";
    //return @"http://192.168.130.161:8080/centralmobile/servlet/CentralMobileFacadeServlet";
}

+(NSString *)getConnectUrlAddress
{
    return [self getConnectUrlAddressWithType:CURRENT_ENV];
    //return  PRODUCTION_URL;
//    return @"http://192.168.130.161:8088/centralmobile/servlet/CentralMobileFacadeServlet";
}

@end
