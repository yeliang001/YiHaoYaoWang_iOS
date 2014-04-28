//
//  UIDeviceHardware.m
//  NuclearRadiationDetection
//
//  Created by linyy on 11-4-11.
//  Copyright 2011 vsc. All rights reserved.
//

#import "UIDeviceHardware.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation UIDeviceHardware

+(NSString*)staticPlatform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    
    NSString * platformStr = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    
    free(machine);
    return platformStr;
}

- (NSString *) platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString * platformStr = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platformStr;
}

- (NSString *) platformString{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    return platform;
}
/*
 @implementation UIDevice (Hardware)
 
 #pragma mark sysctlbyname utils
 + (NSString *) getSysInfoByName:(char *)typeSpecifier
 {
 size_t size;
 sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
 char *answer = malloc(size);
 sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
 NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
 free(answer);
 return results;
 }
 
 + (NSString *) platform
 {
 return [self getSysInfoByName:"hw.machine"];
 }
 
 #pragma mark sysctl utils
 + (NSUInteger) getSysInfo: (uint) typeSpecifier
 {
 size_t size = sizeof(int);
 int results;
 int mib[2] = {CTL_HW, typeSpecifier};
 sysctl(mib, 2, &results, &size, NULL, 0);
 return (NSUInteger) results;
 }
 
 + (NSUInteger) cpuFrequency
 {
 return [self getSysInfo:HW_CPU_FREQ];
 }
 
 + (NSUInteger) busFrequency
 {
 return [self getSysInfo:HW_BUS_FREQ];
 }
 
 + (NSUInteger) totalMemory
 {
 return [self getSysInfo:HW_PHYSMEM];
 }
 
 + (NSUInteger) userMemory
 {
 return [self getSysInfo:HW_USERMEM];
 }
 
 + (NSUInteger) maxSocketBufferSize
 {
 return [self getSysInfo:KIPC_MAXSOCKBUF];
 }
 @end
 */
@end
