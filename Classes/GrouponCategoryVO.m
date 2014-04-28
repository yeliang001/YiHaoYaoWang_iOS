//
//  GrouponCategoryVO.m
//  TheStoreApp
//
//  Created by jiming huang on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GrouponCategoryVO.h"

@implementation GrouponCategoryVO
@synthesize nid;
@synthesize name;
@synthesize count;

-(void)dealloc
{
    if (nid!=nil) {
        [nid release];
    }
    if (name!=nil) {
        [name release];
    }
    [super dealloc];
}
@end
