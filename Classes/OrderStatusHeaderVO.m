//
//  OrderStatusHeaderVO.m
//  TheStoreApp
//
//  Created by zhengchen on 11-12-6.
//  Copyright (c) 2011年 yihaodian. All rights reserved.
//

#import "OrderStatusHeaderVO.h"

@implementation OrderStatusHeaderVO


@synthesize nid;
@synthesize soid;
@synthesize expressNbr;
@synthesize distId;
@synthesize distSuppCompName;
@synthesize distSuppLinkMan;
@synthesize distSuppPhone;
@synthesize distSuppMobile;
@synthesize distSuppAddr;
@synthesize queryUrl;

-(void) dealloc{
    OTS_SAFE_RELEASE(nid);
    OTS_SAFE_RELEASE(soid);
    OTS_SAFE_RELEASE(expressNbr);
    OTS_SAFE_RELEASE(distId);
    OTS_SAFE_RELEASE(distSuppCompName);
    OTS_SAFE_RELEASE(distSuppLinkMan);
    OTS_SAFE_RELEASE(distSuppPhone);
    OTS_SAFE_RELEASE(distSuppMobile);
    OTS_SAFE_RELEASE(distSuppAddr);
    OTS_SAFE_RELEASE(queryUrl);
    [super dealloc];
}

@end
