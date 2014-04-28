//
//  ConnectUrl.h
//  TheStoreApp
//
//  Created by linyy on 11-1-21.
//  Copyright 2011 vsc. All rights reserved.
//	用于得到连接url的工厂

#import <Foundation/Foundation.h>


typedef enum _EOTSEnvironmentType
{
    KOTSEnvironmentTesting = 0      // TESTING环境
    , KOTSEnvironmentStaging        // STAGING环境
    , KOTSEnvironmentProduction     // PRODUCTION环境
    , KOTSEnvironmentEmergency      // 应急环境，可以自行设置url
}
EOTSEnvironmentType;

@interface ConnectUrl : NSObject
+(NSString *)getConnectUrlAddress;
+(NSString*)descriptionForEnviorenment;
@end

#define CURRENT_ENV     KOTSEnvironmentProduction  // 设置当前环境参数

#define EMERGENCY_URL    @"http://192.168.128.233:8080/centralmobile/servlet/CentralMobileFacadeServlet"// 应急环境URL
#define EMERGENCY_144_22URL @"http://10.161.144.22:8080/centralmobile/servlet/CentralMobileFacadeServlet"
#define EMERGENCY_DEV_80URL @"http://10.161.164.80:8080/centralmobile-1.0.0-SNAPSHOT/servlet/CentralMobileFacadeServlet"
