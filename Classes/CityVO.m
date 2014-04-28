//
//  CityVO.m
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import "CityVO.h"


@implementation CityVO

@synthesize cityName;
@synthesize nid;//市/区县Id

-(void)dealloc{
    if(cityName!=nil){
        [cityName release];
    }
    if(nid!=nil){
        [nid release];
    }
    [super dealloc];
}

@end
