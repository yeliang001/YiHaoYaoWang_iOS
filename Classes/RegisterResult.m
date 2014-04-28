//
//  RegisterResult.m
//  TheStoreApp
//
//  Created by jiming huang on 12-9-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegisterResult.h"

@implementation RegisterResult
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
