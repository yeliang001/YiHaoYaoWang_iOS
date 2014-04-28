//
//  DeviceUtil.m
//  TheStoreApp
//
//  Created by zhengchen on 11-11-24.
//  Copyright (c) 2011年 yihaodian. All rights reserved.
//

#import "DeviceUtil.h"
#import "UIDeviceHardware.h"

@implementation DeviceUtil

+(BOOL) supportCarmera {
    UIDeviceHardware * hardWareServ=[[UIDeviceHardware alloc] init] ;
	NSString * deviceString =[hardWareServ platformString]; 
    BOOL ret = YES;
    if ([deviceString isEqualToString:@"iPhone 1G"] ) {
        ret = NO;
    }
    if ([deviceString isEqualToString:@"iPhone 3G"] ) {
        ret = NO;
    }
    if ([deviceString isEqualToString:@"iPod Touch 1G"] ) {
        ret = NO;
    }
    if ([deviceString isEqualToString:@"iPod Touch 2G"] ) {
        ret = NO;
    }
    if ([deviceString isEqualToString:@"iPod Touch 3G"] ) {
        ret = NO;
    }
    if ([deviceString isEqualToString:@"iPad"] ) {
        ret = NO;
    }
    if ([deviceString isEqualToString:@"Simulator"] ) {
        ret = NO;
    }
    [hardWareServ release];
    return ret;
}

+(BOOL) supportSMS{
    UIDeviceHardware * hardWareServ=[[UIDeviceHardware alloc] init];
	NSString * deviceString =[hardWareServ platformString]; 
    BOOL ret = NO;
    if ([deviceString hasPrefix:@"iPhone"] ) {
        ret = YES;
    }
    if ([deviceString hasPrefix:@"Verizon iPhone"] ) {
        ret =  YES;
    }
    [hardWareServ release];
    return ret;
}
@end
