//
//  OrderStatusTrackVO.h
//  TheStoreApp
//
//  Created by zhengchen on 11-12-6.
//  Copyright (c) 2011年 yihaodian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderStatusTrackVO : NSObject{
@private
    NSNumber * nid;//流水号
    NSNumber * oprNum;//订单处理的15个步骤，从1到15
    NSNumber * oprAttr;//属性，0表示事件，1表示状态
    NSString * oprCreatetime;//订单日志创建时间
    NSString * oprUpdatetime;//订单日志更新时间
    NSString * oprContent;//操作的内容
    NSString * oprOperator;//操作人
    NSString * oprPreEvent;//前提事件
    NSString * oprEvent;//触发事件
    NSString * oprRemark;//备注，可能包括配送员名称，电话，事发原因，站名
    NSNumber * orderId;//订单id
    NSString * orderCode;//订单号
    NSString * orderCreateTime;//订单创建时间
    NSNumber * orderPreStatus;//订单的前一个状态
    NSNumber * orderCurrentStatus;//订单的当前状态
}

@property(retain,nonatomic)NSNumber * nid;
@property(retain,nonatomic)NSNumber * oprNum;
@property(retain,nonatomic)NSNumber * oprAttr;
@property(retain,nonatomic)NSString * oprCreatetime;
@property(retain,nonatomic)NSString * oprUpdatetime;
@property(retain,nonatomic)NSString * oprContent;
@property(retain,nonatomic)NSString * oprOperator;
@property(retain,nonatomic)NSString * oprPreEvent;
@property(retain,nonatomic)NSString * oprEvent;
@property(retain,nonatomic)NSString * oprRemark;
@property(retain,nonatomic)NSNumber * orderId;
@property(retain,nonatomic)NSString * orderCode;
@property(retain,nonatomic)NSString * orderCreateTime;
@property(retain,nonatomic)NSNumber * orderPreStatus;
@property(retain,nonatomic)NSNumber * orderCurrentStatus;

@end
