//
//  FacetValue.m
//  TheStoreApp
//
//  Created by jiming huang on 12-4-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FacetValue.h"

@implementation FacetValue
@synthesize nid;
@synthesize name;
@synthesize num;

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
    if (num!=nil) {
        [num release];
        num=nil;
    }
    [super dealloc];
}
@end
