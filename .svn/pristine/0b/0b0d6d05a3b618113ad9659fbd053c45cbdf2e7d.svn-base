//
//  RockResult.m
//  TheStoreApp
//
//  Created by jiming huang on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RockResult.h"

@implementation RockResult

@synthesize resultCode;//0:匹配失败 1:匹配成功
@synthesize hasError;//"true"or"false"
@synthesize errorInfo;
@synthesize distanceList;//匹配成功的距离列表 List<Double>
@synthesize userNameList;//匹配成功的用户名列表 List<string>
@synthesize rockJoinPeopleNum;//1起摇参加人数
@synthesize promotionSalePercent;//促销已售百分比=已销售数量/促销限制数量
-(void)dealloc
{
    if (resultCode!=nil) {
        [resultCode release];
        resultCode=nil;
    }
    if (hasError!=nil) {
        [hasError release];
        hasError=nil;
    }
    if (errorInfo!=nil) {
        [errorInfo release];
        errorInfo=nil;
    }
    if (distanceList!=nil) {
        [distanceList release];
        distanceList=nil;
    }
    if (userNameList!=nil) {
        [userNameList release];
        userNameList=nil;
    }
    if (rockJoinPeopleNum!=nil) {
        [rockJoinPeopleNum release];
        rockJoinPeopleNum=nil;
    }
    if (promotionSalePercent!=nil) {
        [promotionSalePercent release];
        promotionSalePercent=nil;
    }
    [super dealloc];
}
@end
