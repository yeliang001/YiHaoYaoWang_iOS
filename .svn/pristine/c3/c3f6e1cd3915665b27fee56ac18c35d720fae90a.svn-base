//
//  TheStoreService.h
//  TheStoreApp
//
//  Created by zhengchen on 11-11-23.
//  Copyright (c) 2011年 yihaodian. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "XStream.h"
#import "ASIHTTPRequest.h"
@class MethodBody;
@class Trader;
@class InterfaceLog;

@interface TheStoreService:NSObject<ASIHTTPRequestDelegate> {
    NSURL *url;
    NSData *resultData;
    ASIHTTPRequest *request;
}

+(TheStoreService*) defaultService;
// 功能:POST方式请求数据
-(NSObject*) getReturnObject:(NSString *) methodName methodBody:(MethodBody*) methodBody;

// 功能:GET方式请求数据
-(NSObject*)getReturnObject:(NSString *)methodName
           requestParameter:(NSMutableDictionary*)paramDict;
@end
