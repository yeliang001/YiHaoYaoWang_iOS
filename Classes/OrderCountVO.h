//
//  OrderCountVO.h
//  TheStoreApp
//
//  Created by jiming huang on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderCountVO : NSObject {
@private
    NSNumber *type;//订单类型， 1为物流的订单，2为已完成交易的订单，3为取消的订单，4为正在处理的订单，5为历史的，0为全部的订单
    NSNumber *count;//订单数量
}
@property(nonatomic,retain) NSNumber *type;//订单类型， 1为物流的订单，2为已完成交易的订单，3为取消的订单，4为正在处理的订单，5为历史的，0为全部的订单
@property(nonatomic,retain) NSNumber *count;//订单数量
@end
