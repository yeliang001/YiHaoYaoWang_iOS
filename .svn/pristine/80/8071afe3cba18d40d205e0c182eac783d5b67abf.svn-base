//
//  InnerMessageVO.m
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import "InnerMessageVO.h"
#import "UserVO.h"

@implementation InnerMessageVO

@synthesize content;
@synthesize creTime;
@synthesize nid;//站内信Id 
@synthesize isNew;
@synthesize mcsiteid;
@synthesize messageType;
@synthesize messageTypeString;
@synthesize sender;

-(void)dealloc{
    if(content!=nil){
        [content release];
    }
    if(creTime!=nil){
        [creTime release];
    }
    if(nid!=nil){
        [nid release];
    }
    if(isNew!=nil){
        [isNew release];
    }
    if(mcsiteid!=nil){
        [mcsiteid release];
    }
    if(messageType!=nil){
        [messageType release];
    }
    if(messageTypeString!=nil){
        [messageTypeString release];
    }
    if(sender!=nil){
        [sender release];
    }
    [super dealloc];
}

@end
