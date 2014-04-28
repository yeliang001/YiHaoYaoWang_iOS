//
//  RegistResultInfo.m
//  TheStoreApp
//
//  Created by LinPan on 13-8-15.
//
//

#import "RegistResultInfo.h"

@implementation RegistResultInfo
- (void)dealloc
{
    [_userInfo release];
    [_errorInfo release];
    [_security release];
    [_token release];
    [super dealloc];
}
@end
