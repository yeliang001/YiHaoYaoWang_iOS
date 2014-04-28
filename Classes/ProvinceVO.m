//
//  ProvinceVO.m
//  ProtocolDemo
//
//  Created by vsc on 11-1-27.
//  Copyright 2011 vsc. All rights reserved.
//

#import "ProvinceVO.h"


@implementation ProvinceVO
@synthesize nid;
@synthesize provinceName;

-(void)dealloc{
    if(nid!=nil){
        [nid release];
    }
    if(provinceName!=nil){
        [provinceName release];
    }
    [super dealloc];
}

@end
