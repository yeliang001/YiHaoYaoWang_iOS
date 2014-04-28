//
//  SearchPriceVO.m
//  TheStoreApp
//
//  Created by jiming huang on 12-4-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SearchPriceVO.h"

@implementation SearchPriceVO
@synthesize nid;//价格区间id
@synthesize name;//价格区间名称
@synthesize childs;//子价格区间

-(void)dealloc
{
    if (nid!=nil) {
        [nid release];
        nid=nil;
    }
    if (name!=nil) {
        [name release];
        name=nil;
    }
    if (childs!=nil) {
        [childs release];
        childs=nil;
    }
    [super dealloc];
}
@end
