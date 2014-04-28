//
//  SearchKeywordVO.h
//  TheStoreApp
//
//  Created by jiming huang on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchKeywordVO : NSObject {
@private
    NSString *keyword;//关键字
    NSNumber *resultCount;//结果数
    NSArray *categoryIdList;//分类id列表
    NSArray *categoryNameList;//分类名称列表
}

@property(retain,nonatomic) NSString *keyword;//关键字
@property(retain,nonatomic) NSNumber *resultCount;//结果数
@property(retain,nonatomic) NSArray *categoryIdList;//分类id列表
@property(retain,nonatomic) NSArray *categoryNameList;//分类名称列表

@end
