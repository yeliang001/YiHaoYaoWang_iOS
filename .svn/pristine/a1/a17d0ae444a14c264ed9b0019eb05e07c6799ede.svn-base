//
//  DoTracking.h
//  TheStoreApp
//
//  Created by jiming huang on 12-6-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSTrackingPrama.h"

@interface DoTracking : NSObject {
}
+(void)doTracking:(NSString *)url;//类型为1
+(void)doTrackingSecond:(NSString *)url;//类型为2
+(void)newThreadDoTracking:(NSString *)url type:(int)type;
+(void)doTrackingLaunch:(int)launchType;//iphone启动统计  launchType标识启动方式: 0:iphone正常启动，1:iphone物流查询推送启动，2:iphone活动启动，3:iphone订单物流推送启动，4:iphone其他推送启动
+(void)doJsTrackingWithParma:(JSTrackingPrama*)prama;
@end
