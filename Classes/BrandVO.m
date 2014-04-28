//
//  BrandVO.m
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import "BrandVO.h"


@implementation BrandVO

@synthesize brandName;
@synthesize nid;//品牌Id

-(void)dealloc{
    if(brandName!=nil){
        [brandName release];
    }
    if(nid!=nil){
        [nid release];
    }
    [super dealloc];
}

@end
