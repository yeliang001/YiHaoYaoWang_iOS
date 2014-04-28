//
//  CouponVO.m
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import "CouponVO.h"


@implementation CouponVO

@synthesize amount;
@synthesize beginTime;
@synthesize defineType;
@synthesize expiredTime;
@synthesize nid;
@synthesize mcsiteid;
@synthesize number;
@synthesize threshOld;
@synthesize description;
@synthesize detailDescription;
@synthesize canUse;
@synthesize checked;
@synthesize isUsed = _isUsed;

-(void)dealloc{
    if(amount!=nil){
        [amount release];
    }
    if(beginTime!=nil){
        [beginTime release];
    }
    if(defineType!=nil){
        [defineType release];
    }
    if(expiredTime!=nil){
        [expiredTime release];
    }
    if(nid!=nil){
        [nid release];
    }
    if(mcsiteid!=nil){
        [mcsiteid release];
    }
    if(number!=nil){
        [number release];
    }
    if(threshOld!=nil){
        [threshOld release];
    }
    if(description!=nil){
        [description release];
    }
    if(detailDescription!=nil){
        [detailDescription release];
    }
    if(canUse!=nil){
        [canUse release];
    }
    if(checked!=nil){
        [checked release];
    }

    [super dealloc];
}

-(BOOL)isExpired
{
    NSDate *now = [NSDate date];
    if (self.expiredTime && [now compare:self.expiredTime] == NSOrderedDescending)
    {
        return YES;
    }
    
    return NO;
}

@end
