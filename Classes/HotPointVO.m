//
//  HotPointVO.m
//  TheStoreApp
//
//  Created by linyy on 11-6-22.
//  Copyright 2011年 vsc. All rights reserved.
//

#import "HotPointVO.h"
#import "ProductVO.h"

@implementation HotPointVO

@synthesize detailUrl;
@synthesize hotProduct;
@synthesize title;
@synthesize type;

-(void)dealloc{
    if(detailUrl!=nil){
        [detailUrl release];
    }
    if(hotProduct!=nil){
        [hotProduct release];
    }
    if(title!=nil){
        [title release];
    }
    if(type!=nil){
        [type release];
    }
    [super dealloc];
}

@end
