//
//  GrouponOrderVO.m
//  TheStoreApp
//
//  Created by jiming huang on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GrouponOrderVO.h"

@implementation GrouponOrderVO

@synthesize grouponVO;
@synthesize userVO;
@synthesize pmVOList;
@synthesize orderVO;
@synthesize hasError;
@synthesize errorInfo;

-(void)dealloc
{
    if (grouponVO!=nil) {
        [grouponVO release];
    }
    if (userVO!=nil) {
        [userVO release];
    }
    if (pmVOList!=nil) {
        [pmVOList release];
    }
    if (orderVO!=nil) {
        [orderVO release];
    }
    if (hasError!=nil) {
        [hasError release];
    }
    if (errorInfo!=nil) {
        [errorInfo release];
    }
    [super dealloc];
}
@end
