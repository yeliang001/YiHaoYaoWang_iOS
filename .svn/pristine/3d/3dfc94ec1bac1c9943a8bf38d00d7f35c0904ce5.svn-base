//
//  SenderMethodBody.m
//  TheStoreApp
//
//  Created by linyy on 11-2-9.
//  Copyright 2011 vsc. All rights reserved.
//

#import "SenderMethodBody.h"


@implementation SenderMethodBody

@synthesize methodType;
@synthesize methodValue;

- (id)init{
	self = [super init];	// added by: dong yiming at: 2012.5.24. reason: to obey apple's guideline
	methodValue=[[NSMutableArray alloc]init];
	return self;
}

-(void)dealloc{
    if(methodType!=nil){
        [methodType release];
    }
    if(methodValue!=nil){
       // [methodValue removeAllObjects];//tjs
        [methodValue release];
    }
    [super dealloc];
}

@end
