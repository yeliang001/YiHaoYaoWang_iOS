//
//  GrouponOrderSubmitResult.m
//  TheStoreApp
//
//  Created by jiming huang on 12-2-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GrouponOrderSubmitResult.h"

@implementation GrouponOrderSubmitResult

@synthesize orderId;//订单id
@synthesize hasError;//是否有错误
@synthesize errorInfo;//错误提示信息

-(void)dealloc
{
    if (orderId!=nil) {
        [orderId release];
    }
    if (hasError!=nil) {
        [hasError release];
    }
    if (errorInfo!=nil) {
        [errorInfo release];
    }
    [super dealloc];
}
@end
