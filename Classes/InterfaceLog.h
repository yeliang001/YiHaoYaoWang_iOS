//
//  InterfaceLogUtil.h
//  TheStoreApp
//
//  Created by towne on 12-9-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalValue.h"
#import "Sqlite3Handle.h"

@interface InterfaceLog:NSObject{
}

+(void) addInterfaceLog:(NSString *)methedname Lag:(NSNumber *)lag NetType:(NSString *)nettype;
+(NSString *) queryInterfaceLog;
+(NSString *) addColumn:(NSString *) name valtext:(NSString *) val;
+(NSString *) addColumn:(NSString *) name valint:(int) val;
+(NSString *) addColumn:(NSString *) name valdouble:(double) val;
@end
