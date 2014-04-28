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
	NSNumber * amount;
	NSDate * beginTime;
	NSNumber * defineType;
	NSDate * expiredTime;
	NSNumber * nid;
	NSNumber * mcsiteid;
	NSString * number;
	NSNumber * threshOld;
}
@property(retain,nonatomic)NSNumber * amount;
@property(retain,nonatomic)NSDate * beginTime;
@property(retain,nonatomic)NSNumber * defineType;
@property(retain,nonatomic)NSDate * expiredTime;
@property(retain,nonatomic)NSNumber * nid;
@property(retain,nonatomic)NSNumber * mcsiteid;
@property(retain,nonatomic)NSString * number;
@property(retain,nonatomic)NSNumber * threshOld;
@end
