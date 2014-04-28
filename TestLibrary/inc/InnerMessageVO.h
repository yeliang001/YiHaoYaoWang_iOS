//
//  InnerMessageVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserVO;

@interface InnerMessageVO : NSObject {
@private
	NSString * content;
	NSDate * creTime;
	NSNumber * nid;//站内信Id 
	NSNumber * isNew;
	NSNumber * mcsiteid;
	NSNumber * messageType;
	NSString * messageTypeString;
	UserVO * sender;
}
@property(retain,nonatomic)NSString * content;
@property(retain,nonatomic)NSDate * creTime;
@property(retain,nonatomic)NSNumber * nid;//站内信Id 
@property(retain,nonatomic)NSNumber * isNew;
@property(retain,nonatomic)NSNumber * mcsiteid;
@property(retain,nonatomic)NSNumber * messageType;
@property(retain,nonatomic)NSString * messageTypeString;
@property(retain,nonatomic)UserVO * sender;
@end
