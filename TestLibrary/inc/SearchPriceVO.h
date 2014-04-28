//
//  SearchPriceVO.h
//  TheStoreApp
//
//  Created by jiming huang on 12-4-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchPriceVO : NSObject {
@private
    NSNumber *nid;//价格区间id
    NSString *name;//价格区间名称
    NSArray *childs;//子价格区间
}

@property(retain,nonatomic) NSNumber *nid;//价格区间id
@property(retain,nonatomic) NSString *name;//价格区间名称
@property(retain,nonatomic) NSArray *childs;//子价格区间
@end
