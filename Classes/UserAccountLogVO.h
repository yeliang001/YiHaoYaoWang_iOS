//
//  UserAccountLogVO.h
//  TheStoreApp
//
//  Created by xuexiang on 12-7-11.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+OTS.h"


@interface UserAccountLogVO : NSObject {
	NSString *createTime;
	NSString *accountType;
	NSNumber *money;
	NSString *accountStatus;
	NSString *accountRemark;
}
@property(nonatomic, retain)NSString *createTime;
@property(nonatomic, retain)NSString *accountType;
@property(nonatomic, retain)NSNumber *money;
@property(nonatomic, retain)NSString *accountStatus;
@property(nonatomic, retain)NSString *accountRemark;

@end
