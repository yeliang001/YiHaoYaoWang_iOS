//
//  ProductExperienceVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ProductExperienceVO : NSObject {
@private
	NSString * content;
	NSString * contentFail;
	NSString * contentGood;
	NSDate * createtime;
	NSNumber * ratingLog;
	NSString * userName;
}
@property(retain,nonatomic)NSString * content;
@property(retain,nonatomic)NSString * contentFail;
@property(retain,nonatomic)NSString * contentGood;
@property(retain,nonatomic)NSDate * createtime;
@property(retain,nonatomic)NSNumber * ratingLog;
@property(retain,nonatomic)NSString * userName;
@end
