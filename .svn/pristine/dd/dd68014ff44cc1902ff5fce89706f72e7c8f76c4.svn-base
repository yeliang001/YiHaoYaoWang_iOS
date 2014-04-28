//
//  CategoryVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CategoryVO : NSObject <NSCoding>{
@private
	NSString * categoryName;
	NSNumber * nid;//分类Id
    NSNumber *fatherId;//父分类id
    NSArray *childCategoryVOList;//一级分类关键字列表
    NSString *categoryPicUrl;//1级分类图片地址
    NSString *advCode;//广告code(相当于父分类id)
}
@property(nonatomic, retain) NSNumber *nid;//分类id
@property(nonatomic, retain) NSString *categoryName;//分类名称
@property(nonatomic, retain) NSNumber *fatherId;//父分类id
@property(nonatomic, retain) NSArray *childCategoryVOList;//一级分类关键字列表
@property(nonatomic, retain) NSString *categoryPicUrl;//1级分类图片地址
@property(nonatomic, retain) NSString *advCode;//广告code(相当于父分类id)
@end
