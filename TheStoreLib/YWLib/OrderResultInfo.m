//
//  OrderResultInfo.m
//  TheStoreApp
//
//  Created by LinPan on 13-9-12.
//
//

#import "OrderResultInfo.h"


@implementation OrderResultInfo

- (void)dealloc
{
    [_orderInfo release];
    [super dealloc];
}

- (BOOL)isNoAddress
{
    return self.resultCode == 43 || self.resultCode == 42;
}

@end
