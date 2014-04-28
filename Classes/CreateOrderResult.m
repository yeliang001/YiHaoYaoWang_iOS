//
//  CreateOrderResult.m
//  TheStoreApp
//
//  Created by jiming huang on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CreateOrderResult.h"

@implementation CreateOrderResult

@synthesize resultCode,errorInfo,productList;

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
    if (productList!=nil) {
        [productList release];
        productList=nil;
    }
    [super dealloc];
}
@end
