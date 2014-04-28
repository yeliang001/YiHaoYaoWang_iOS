//
//  VerifyCodeVO.m
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import "VerifyCodeVO.h"


@implementation VerifyCodeVO

@synthesize codeUrl;
@synthesize tempToken;

-(void)dealloc{
    if(codeUrl!=nil){
        [codeUrl release];
    }
    if(tempToken!=nil){
        [tempToken release];
    }
    [super dealloc];
}

@end
