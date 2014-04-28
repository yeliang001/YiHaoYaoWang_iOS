//
//  SplitLogInfo.m
//  TheStoreApp
//
//  Created by LinPan on 13-9-28.
// 
//  物流信息

#import "SplitLogInfo.h"

@implementation SplitLogInfo

- (void)dealloc
{
    [_logTime release];
    [_note release];
    [_operatorUser release];
    [_orderId release];
    [_status release];
    [super dealloc];
}

@end
