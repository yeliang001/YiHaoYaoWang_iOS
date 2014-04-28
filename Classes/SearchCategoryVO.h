//
//  SearchCategoryVO.h
//  TheStoreApp
//
//  Created by jiming huang on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchCategoryVO : NSObject {
@private
    NSNumber *categoryId;//分类id
    NSString *categoryName;//分类名称
    NSNumber *num;//该分类下商品数量
    NSNumber *level;//分类类型：1一级分类 2二级分类 3三级分类
    NSArray *childCategoryList;//子分类
}

@property(retain,nonatomic) NSNumber *categoryId;//分类id
@property(retain,nonatomic) NSString *categoryName;//分类名称
@property(retain,nonatomic) NSNumber *num;//该分类下商品数量
@property(retain,nonatomic) NSNumber *level;//分类类型：1一级分类 2二级分类 3三级分类
@property(retain,nonatomic) NSArray *childCategoryList;//子分类

@end
