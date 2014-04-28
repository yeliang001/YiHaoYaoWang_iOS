//
//  PaymentMethodError.m
//  TheStoreApp
//
//  Created by xuexiang on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PaymentMethodError.h"

@implementation PaymentMethodError

@synthesize errorCode;
@synthesize errorInfo;

-(void)dealloc{
    if (errorCode != nil) {
        [errorCode release];
    }
    if (errorInfo != nil) {
        [errorInfo release];
    }
    [super dealloc];
}
@end
