//
//  SearchResultVO.m
//  TheStoreApp
//
//  Created by jiming huang on 12-4-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SearchResultVO.h"

@implementation SearchResultVO
@synthesize searchBrandVO;//品牌
@synthesize searchAttributes;//导购属性
@synthesize searchPriceVO;//价格区间
@synthesize searchCategorys;//筛选分类
@synthesize page;//搜索出来的商品
@synthesize searchSiteTypeVO;

-(void)dealloc
{
    if (searchBrandVO!=nil) {
        [searchBrandVO release];
        searchBrandVO=nil;
    }
    if (searchAttributes!=nil) {
        [searchAttributes release];
        searchAttributes=nil;
    }
    if (searchPriceVO!=nil) {
        [searchPriceVO release];
        searchPriceVO=nil;
    }
    if (searchCategorys!=nil) {
        [searchCategorys release];
        searchCategorys=nil;
    }
    if (page!=nil) {
        [page release];
        page=nil;
    }
    if (searchSiteTypeVO!=nil) {
        [searchSiteTypeVO release];
        searchSiteTypeVO = nil;
    }
    [super dealloc];
}
@end
