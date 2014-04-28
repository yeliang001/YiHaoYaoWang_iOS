//
//  SearchResultVO.h
//  TheStoreApp
//
//  Created by jiming huang on 12-4-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchBrandVO.h"
#import "SearchPriceVO.h"
#import "Page.h"

@interface SearchResultVO : NSObject {
@private
    SearchBrandVO *searchBrandVO;//品牌
    NSArray *searchAttributes;//导购属性
    SearchPriceVO *searchPriceVO;//价格区间
    NSArray *searchCategorys;//筛选分类
    Page *page;//搜索出来的商品
}

@property(retain,nonatomic) SearchBrandVO *searchBrandVO;//品牌
@property(retain,nonatomic) NSArray *searchAttributes;//导购属性
@property(retain,nonatomic) SearchPriceVO *searchPriceVO;//价格区间
@property(retain,nonatomic) NSArray *searchCategorys;//筛选分类
@property(retain,nonatomic) Page *page;//搜索出来的商品

@end
