//
//  IconDownloadSetting.m
//  TheStoreApp
//
//  Created by yuan jun on 12-12-20.
//
//

#import "IconDownloadSetting.h"
#import "SDDataCache.h"
@implementation IconDownloadSetting
+(BOOL)getIcondownloadSwitchStatus{
    NSNumber* num=[[NSUserDefaults standardUserDefaults] valueForKey:@"iconSwitch"];
    if (num.intValue) {
        return YES;
    }else{
        return NO;
    }
}
+(void)setIcondownloadSwithStatus:(BOOL)status{
    if (status) {
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:1] forKey:@"iconSwitch"];
    }else{
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:0] forKey:@"iconSwitch"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)initIconDownloadSetting{
    NSNumber* num=[[NSUserDefaults standardUserDefaults] valueForKey:@"iconSwitch"];
    if (num==nil) {
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:1] forKey:@"iconSwitch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+(void)setIcondownloadAlertHasShow{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:1] forKey:@"icondownSetting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSNumber*)getIcondownloadAlertHasShow{
   NSNumber* num= [[NSUserDefaults standardUserDefaults] objectForKey:@"icondownSetting"];
    return num;
}
//+(void)cleanIconCache{
//    [[SDDataCache sharedDataCache] clearMemory];
//    [[SDDataCache sharedDataCache] clearDisk];
//}
@end
