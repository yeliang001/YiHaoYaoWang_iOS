//
//  GrouponAreaVO.m
//  TheStoreApp
//
//  Created by jiming huang on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GrouponAreaVO.h"

@implementation GrouponAreaVO

@synthesize nid;
@synthesize name;
@synthesize provinceId;

-(void)dealloc
{
    if (nid!=nil) {
        [nid release];
    }
    if (name!=nil) {
        [name release];
    }
    if (provinceId!=nil) {
        [provinceId release];
    }
    [super dealloc];
}
@end
