//
//  AddProductResult.m
//  TheStoreApp
//
//  Created by jiming huang on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AddProductResult.h"

@implementation AddProductResult
@synthesize resultCode;
@synthesize errorInfo;

-(BOOL)isSuccess
{
    return [resultCode intValue] == 1;
}

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
