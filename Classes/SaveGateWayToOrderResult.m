//
//  SaveGateWayToOrderResult.m
//  TheStoreApp
//
//  Created by jiming huang on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SaveGateWayToOrderResult.h"

@implementation SaveGateWayToOrderResult

@synthesize resultCode,errorInfo;

-(void)dealloc
{
    if (resultCode!=nil) {
        [resultCode release];
        resultCode=nil;
    }
    if (errorInfo!=nil) {
        [errorInfo release];
        errorInfo=nil;
    }
    [super dealloc];
}

@end
