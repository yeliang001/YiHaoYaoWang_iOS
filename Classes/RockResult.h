//
//  RockResult.h
//  TheStoreApp
//
//  Created by jiming huang on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RockResult : NSObject {
@private
    NSNumber *resultCode;//0:匹配失败 1:匹配成功
    NSString *hasError;//"true"or"false"
    NSString *errorInfo;
    NSMutableArray *distanceList;//匹配成功的距离列表 List<Double>
    NSMutableArray *userNameList;//匹配成功的用户名列表 List<string>
    NSNumber *rockJoinPeopleNum;//1起摇参加人数
    NSNumber *promotionSalePercent;//促销已售百分比=已销售数量/促销限制数量
}

@property(retain,nonatomic) NSNumber *resultCode;//0:匹配失败 1:匹配成功
@property(retain,nonatomic) NSString *hasError;//"true"or"false"
@property(retain,nonatomic) NSString *errorInfo;
@property(retain,nonatomic) NSMutableArray *distanceList;//匹配成功的距离列表 List<Double>
@property(retain,nonatomic) NSMutableArray *userNameList;//匹配成功的用户名列表 List<string>
@property(retain,nonatomic) NSNumber *rockJoinPeopleNum;//1起摇参加人数
@property(retain,nonatomic) NSNumber *promotionSalePercent;//促销已售百分比=已销售数量/促销限制数量

@end
