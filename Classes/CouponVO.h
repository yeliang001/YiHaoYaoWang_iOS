//
//  CouponVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CouponVO : NSObject{
@private	
	NSNumber         *amount;
	NSDate           *beginTime;
	NSNumber         *defineType;
	NSDate           *expiredTime;
	NSNumber         *nid;
	NSNumber         *mcsiteid;
	NSString         *number;
	NSNumber         *threshOld;
    //迭代4增加的字段
    NSString         *description;      //抵用卷描述
    NSString         *detailDescription;//抵用卷详细描述
    NSString         *canUse;            //是否可用
    NSString         *checked;           //是否已保存到订单
}
@property(retain,nonatomic)NSNumber            *amount;
@property(retain,nonatomic)NSDate              *beginTime;
@property(retain,nonatomic)NSNumber            *defineType;
@property(retain,nonatomic)NSDate              *expiredTime;
@property(retain,nonatomic)NSNumber            *nid;
@property(retain,nonatomic)NSNumber            *mcsiteid;
@property(retain,nonatomic)NSString            *number;
@property(retain,nonatomic)NSNumber            *threshOld;
@property(retain,nonatomic)NSString            *description;
@property(retain,nonatomic)NSString            *detailDescription;
@property(retain,nonatomic)NSString            *canUse;
@property(retain,nonatomic)NSString            *checked;

@property BOOL  isUsed;

-(BOOL)isExpired;
@end
