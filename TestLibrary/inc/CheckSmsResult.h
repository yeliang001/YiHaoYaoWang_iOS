//
//  CheckSmsResult.h
//  TheStoreApp
//
//  Created by yiming dong on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckSmsResult : NSObject
{
    NSNumber        *resultCode;
    NSString        *errorInfo;
}

@property(retain) NSNumber        *resultCode;
@property(retain) NSString        *errorInfo;
@end
