//
//  GrouponSortAttributeVO.m
//  TheStoreApp
//
//  Created by zhengchen on 12-8-6.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GrouponSortAttributeVO.h"


@implementation GrouponSortAttributeVO
@synthesize attrId,attrName;
-(void)dealloc{
	OTS_SAFE_RELEASE(attrId);
	OTS_SAFE_RELEASE(attrName);
	[super dealloc];
}
@end
