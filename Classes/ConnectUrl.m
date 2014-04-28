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
#if 1
	NSString* addr = [[NSUserDefaults standardUserDefaults] objectForKey:URL_SETTING_KEY];
    if (addr == nil)
    {
        addr = PRODUCTION_URL;
        [[NSUserDefaults standardUserDefaults] setValue:addr forKey:URL_SETTING_KEY];
    }
    return addr;
#endif
	
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
}

+(NSString *)getConnectUrlAddress
{
    return [self getConnectUrlAddressWithType:CURRENT_ENV];
//    return  STAGING_URL;
//    return @"http://192.168.130.161:8088/centralmobile/servlet/CentralMobileFacadeServlet";
//    return EMERGENCY_232URL;
//    return PRODUCTION_URL;
//    return TESTING_URL;
//      return @"http://10.161.192.139:8080/centralmobile/servlet/CentralMobileFacadeServlet";
//      return @"http://10.161.193.29:8080/centralmobile/servlet/CentralMobileFacadeServlet";
//    return @"http://10.161.164.85:8088/centralmobile/servlet/CentralMobileFacadeServlet";
//    return @"http://10.161.164.173:8080/centralmobile-1.0.0-SNAPSHOT/servlet/CentralMobileFacadeServlet";
//      return @"http://10.161.164.29:8080/centralmobile-1.0.0-SNAPSHOT/servlet/CentralMobileFacadeServlet";
//    return EMERGENCY_DEV_80URL;
//    return @"http://10.161.144.22:8080/centralmobile/servlet/CentralMobileFacadeServlet";
    //return EMERGENCY_144_22URL;
}

+(NSString*)descriptionForEnviorenment
{
    NSString* addr = [self getConnectUrlAddress];
    
    if ([addr isEqualToString:TESTING_URL])
    {
        return @"测试";
    }
    
    else if ([addr isEqualToString:STAGING_URL])
    {
        return @"STAGING";
    }
    
    else if ([addr isEqualToString:PRODUCTION_URL])
    {
        return @"PRODUCTION";
    }
    
    else if ([addr isEqualToString:EMERGENCY_URL])
    {
        return @"EMERGENCY";
    }
    else if ([addr isEqualToString:EMERGENCY_144_22URL])
    {
        return @"144_22Emergency";
    }
    else if ([addr isEqualToString:EMERGENCY_DEV_80URL])
    {
        return @"80DevEmergency";
    }
    
    return @"未知";
}

@end
