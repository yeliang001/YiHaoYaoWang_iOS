//
//  FavoriteVO.m
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import "FavoriteVO.h"
#import "ProductVO.h"

@implementation FavoriteVO

@synthesize nid;//收藏产品Id
@synthesize mcsiteid;
@synthesize product;

-(void)dealloc{
    if(nid!=nil){
        [nid release];
    }
    if(mcsiteid!=nil){
        [mcsiteid release];
    }
    if(product!=nil){
        [product release];
    }
    [super dealloc];
}

@end
