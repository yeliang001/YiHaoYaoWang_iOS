//
//  OTSOrderMfServant.h
//  TheStoreApp
//
//  Created by yiming dong on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderV2;
@class Page;

@interface OTSOrderMfServant : NSObject
{
    Page*  statusTrackPage;
    NSArray*  statusHeaders;
}
-(OrderV2*)requestDetailForOrder:(OrderV2*)aOrder;
-(Page*)requestOrderStatus:(long long int)aOrderId;
-(NSArray*)requestOrderStatusHeader:(long long int)aOrderId;

@property(retain)Page*  statusTrackPage;
@property(retain)NSArray*  statusHeaders;
@end
