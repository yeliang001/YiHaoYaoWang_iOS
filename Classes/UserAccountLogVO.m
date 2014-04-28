//
//  UserAccountLogVO.m
//  TheStoreApp
//
//  Created by xuexiang on 12-7-11.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UserAccountLogVO.h"


@implementation UserAccountLogVO

@synthesize createTime;
@synthesize accountType;
@synthesize money;
@synthesize accountStatus;
@synthesize accountRemark;

-(void)dealloc{
	if (createTime != nil) {
		[createTime release];
	}
	if (accountType != nil) {
		[accountType release];
	}
	if (money != nil) {
		[money release];
	}
	if (accountStatus != nil) {
		[accountStatus release];
	}
	if (accountRemark != nil) {
		[accountRemark release];
	}
	[super dealloc];
}

@end
