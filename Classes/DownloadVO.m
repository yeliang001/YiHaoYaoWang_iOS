//
//  DownloadVO.m
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import "DownloadVO.h"


@implementation DownloadVO

@synthesize canUpdate;
@synthesize downloadUrl;
@synthesize forceUpdate;
@synthesize remark;

-(void)dealloc{
    if(canUpdate!=nil){
        [canUpdate release];
    }
    if(downloadUrl!=nil){
        [downloadUrl release];
    }
    if(forceUpdate!=nil){
        [forceUpdate release];
    }
    if(remark!=nil){
        [remark release];
    }
    [super dealloc];
}

-(BOOL)isCanUpdate
{
    return [self.canUpdate isEqualToString:@"true"];
}

-(BOOL)isForceUpdate
{
    return [self.forceUpdate isEqualToString:@"true"];
}

@end
