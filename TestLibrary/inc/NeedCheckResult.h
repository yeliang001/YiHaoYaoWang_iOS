//
//  NeedCheckResult.h
//  TheStoreApp
//
//  Created by yiming dong on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NeedCheckResult : NSObject
{
    NSNumber        *resultCode;    // 0-不需要短信验证；1-需要短信验证未绑定；2-需要短信验证已绑定
    NSString        *mobile;        // 手机号
}

@property(retain) NSNumber        *resultCode;
@property(retain) NSString        *mobile;

@end
