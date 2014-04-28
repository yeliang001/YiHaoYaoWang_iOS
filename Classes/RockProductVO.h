//
//  RockProductVO.h
//  TheStoreApp
//
//  Created by yiming dong on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProductVO;

@interface RockProductVO : NSObject
{
    ProductVO           *productVO;                 // 摇摇购商品
    NSNumber            *rockJoinPeopleNum;         // 该商品的摇摇购参加人数
    NSNumber            *rockPeopleNumLimit;        // 该商品的摇摇购匹配限制人数
}
@property(retain)ProductVO           *productVO;
@property(retain)NSNumber            *rockJoinPeopleNum;
@property(retain)NSNumber            *rockPeopleNumLimit;
@end
