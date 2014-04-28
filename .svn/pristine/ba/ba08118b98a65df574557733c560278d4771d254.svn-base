//
//  ObjectArraySender.m
//  TheStoreApp
//
//  Created by linyy on 11-2-2.
//  Copyright 2011 vsc. All rights reserved.
//

#import "ObjectArraySender.h"
#import "Trader.h"

@implementation ObjectArraySender

@synthesize trader;
@synthesize methodBodyArray;

-(id)initWithObjectArraySender:(ObjectArraySender *)anotherSender{

// added by: dong yiming at: 2012.5.24. reason: to obey apple's guideline
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    if(anotherSender!=nil){
        if(anotherSender.trader!=nil){
            [self setTrader:anotherSender.trader];
        }
        if(anotherSender.methodBodyArray!=nil){
            methodBodyArray=[[NSMutableArray alloc] initWithArray:anotherSender.methodBodyArray];
        }
        return self;
    }
    return nil;
}

-(void)dealloc{
    if(trader!=nil){
        [trader release];
    }
    if(methodBodyArray!=nil){
        //[methodBodyArray removeAllObjects];//tjs
        [methodBodyArray release];
    }
    [super dealloc];
}

@end
