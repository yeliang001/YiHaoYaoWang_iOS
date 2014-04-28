//
//  NSObject+OTS.h
//  TheStoreApp
//
//  Created by yiming dong on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -

void RunBlockAfterDelay(NSTimeInterval delay, void (^block)(void));

@interface NSObject (OTS)

// 延时执行
- (void)otsPerformBlock:(void (^)(void))block 
             afterDelay:(NSTimeInterval)delay;

// 开新线程(内存安全)
-(void)otsDetatchMemorySafeNewThreadSelector:(SEL)aSelector 
                                    toTarget:(id)aTarget 
                                  withObject:(id)anArgument;

@end

