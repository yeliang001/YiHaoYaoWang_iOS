//
//  SearchKeywordVO.m
//  TheStoreApp
//
//  Created by jiming huang on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SearchKeywordVO.h"

@implementation SearchKeywordVO
@synthesize keyword;//关键字
@synthesize resultCount;//结果数
@synthesize categoryIdList;//分类id列表
@synthesize categoryNameList;//分类名称列表

-(void)dealloc
{
    if (keyword!=nil) {
        [keyword release];
        keyword=nil;
    }
    if (resultCount!=nil) {
        [resultCount release];
        resultCount=nil;
    }
    if (categoryIdList!=nil) {
        [categoryIdList release];
        categoryIdList=nil;
    }
    if (categoryNameList!=nil) {
        [categoryNameList release];
        categoryNameList=nil;
    }
    [super dealloc];
}
@end
