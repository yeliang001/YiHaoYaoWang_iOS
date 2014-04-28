//
//  SearchCategoryVO.m
//  TheStoreApp
//
//  Created by jiming huang on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SearchCategoryVO.h"

@implementation SearchCategoryVO
@synthesize categoryId;//分类id
@synthesize categoryName;//分类名称
@synthesize num;//该分类下商品数量
@synthesize level;//分类类型：1一级分类 2二级分类 3三级分类
@synthesize childCategoryList;//子分类

-(void)dealloc
{
    if (categoryId!=nil) {
        [categoryId release];
        categoryId=nil;
    }
    if (categoryName!=nil) {
        [categoryName release];
        categoryName=nil;
    }
    if (num!=nil) {
        [num release];
        num=nil;
    }
    if (level!=nil) {
        [level release];
        level=nil;
    }
    if (childCategoryList!=nil) {
        [childCategoryList release];
        childCategoryList=nil;
    }
    [super dealloc];
}
@end
