//
//  OrderCountVO.m
//  TheStoreApp
//
//  Created by jiming huang on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OrderCountVO.h"

@implementation OrderCountVO
@synthesize type;//订单类型， 1为物流的订单，2为已完成交易的订单，3为取消的订单，4为正在处理的订单，5为历史的，0为全部的订单
@synthesize count;//订单数量

-(void)dealloc
{
    if (type!=nil) {
        [type release];
        type=nil;
    }
    if (count!=nil) {
        [count release];
        count=nil;
    }
    [super dealloc];
}
@end
