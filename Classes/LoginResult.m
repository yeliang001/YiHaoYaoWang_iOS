//
//  LoginResult.m
//  TheStoreApp
//
//  Created by jiming huang on 12-9-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginResult.h"

@implementation LoginResult
@synthesize resultCode,errorInfo,token;

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
    if (token!=nil) {
        [token release];
        token=nil;
    }
    [super dealloc];
}
@end
