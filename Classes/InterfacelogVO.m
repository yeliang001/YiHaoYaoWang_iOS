//
//  InterfaceLog.m
//  TheStoreApp
//
//  Created by towne on 12-9-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InterfacelogVO.h"

@implementation InterfacelogVO
@synthesize provinceid;
@synthesize methodname;
@synthesize count;
@synthesize avglag;
@synthesize minlag;
@synthesize maxlag;
@synthesize timeoutcount;
@synthesize nettype;
@synthesize created_date;
@synthesize modified_date;


-(void)dealloc{
    
    if(provinceid!=nil){
        [provinceid release];
    }
    if(methodname!=nil){
        [methodname release];
    }
    if(count!=nil){
        [count release];
    }
    if(avglag!=nil){
        [avglag release];
    }
    if(minlag!=nil){
        [minlag release];
    }
    if(maxlag!=nil){
        [maxlag release];
    }
    if(timeoutcount!=nil){
        [timeoutcount release];
    }
    if(nettype!=nil){
        [nettype release];
    }
    if(created_date!=nil){
        [created_date release];
    }
    if(modified_date!=nil){
        [modified_date release];
    }
    [super dealloc];
}

@end
