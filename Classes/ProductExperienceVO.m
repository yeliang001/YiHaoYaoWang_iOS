//
//  ProductExperienceVO.m
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import "ProductExperienceVO.h"


@implementation ProductExperienceVO

@synthesize content;
@synthesize contentFail;
@synthesize contentGood;
@synthesize createtime;
@synthesize ratingLog;
@synthesize userName;

-(void)dealloc{
    if(content!=nil){
        [content release];
    }
    if(contentFail!=nil){
        [contentFail release];
    }
    if(contentGood!=nil){
        [contentGood release];
    }
    if(createtime!=nil){
        [createtime release];
    }
    if(ratingLog!=nil){
        [ratingLog release];
    }
    if(userName!=nil){
        [userName release];
    }
    [super dealloc] ;
}

@end
