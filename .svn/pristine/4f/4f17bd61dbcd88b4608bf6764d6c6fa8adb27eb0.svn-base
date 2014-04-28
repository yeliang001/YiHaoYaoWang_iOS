//
//  LocationVO.m
//  TheStoreApp
//
//  Created by yangxd on 11-7-14.
//  Copyright 2011 vsc. All rights reserved.
//

#import "LocationVO.h"

@implementation LocationVO

@synthesize hasMore;
@synthesize province;
@synthesize list;

-(void)dealloc{
    if(list != nil){
        //[list removeAllObjects];
        [list release];
    }
    if(hasMore != nil){
        [hasMore release];
    }
    if(province != nil){
        [province release];
    }
    [super dealloc];
}
@end
