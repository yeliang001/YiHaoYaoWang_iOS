//
//  RockProductVO.m
//  TheStoreApp
//
//  Created by yiming dong on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RockProductVO.h"
#import "ProductVO.h"

@implementation RockProductVO
@synthesize productVO, rockJoinPeopleNum,rockPeopleNumLimit;

-(void)dealloc
{
    [productVO release];
    [rockJoinPeopleNum release];
    [rockPeopleNumLimit release];
    
    [super dealloc];
}
@end
