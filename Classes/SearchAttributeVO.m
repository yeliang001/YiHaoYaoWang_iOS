//
//  SearchAttributeVO.m
//  TheStoreApp
//
//  Created by jiming huang on 12-4-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SearchAttributeVO.h"

@implementation SearchAttributeVO
@synthesize attrId;//导购属性id
@synthesize attrName;//导购属性名称
@synthesize attrChilds;//子导购属性

-(void)dealloc
{
    if (attrId!=nil) {
        [attrId release];
        attrId=nil;
    }
    if (attrName!=nil) {
        [attrName release];
        attrName=nil;
    }
    if (attrChilds!=nil) {
        [attrChilds release];
        attrChilds=nil;
    }
    [super dealloc];
}
@end
