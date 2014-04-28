//
//  OTSOrderMfServant.m
//  TheStoreApp
//
//  Created by yiming dong on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSOrderMfServant.h"
#import "OrderV2.h"
#import "OrderService.h"
#import "GlobalValue.h"

@implementation OTSOrderMfServant
@synthesize statusTrackPage, statusHeaders;

-(OrderV2*)requestDetailForOrder:(OrderV2*)aOrder
{
    if (aOrder)
    {
        OrderService* service = [[[OrderService alloc] init] autorelease];
        return [service getOrderDetailByOrderIdEx:[GlobalValue getGlobalValueInstance].token  orderId:aOrder.orderId];
    }
    
    return nil;
}


-(Page*)requestOrderStatus:(long long int)aOrderId
{
    OrderService* service = [[[OrderService alloc] init] autorelease];
    
    Page * page = [service getOrderStatusTrack:[GlobalValue getGlobalValueInstance].token 
                                       orderId:[NSNumber numberWithLongLong:aOrderId] 
                                   currentPage:[NSNumber numberWithInt:1] 
                                      pageSize:[NSNumber numberWithInt:100]];
    self.statusTrackPage = page;
    
    return page;
}

-(NSArray*)requestOrderStatusHeader:(long long int)aOrderId
{
    OrderService* service = [[[OrderService alloc] init] autorelease];
    self.statusHeaders = [service getOrderStatusHeader:[GlobalValue getGlobalValueInstance].token orderId:[NSNumber numberWithLongLong:aOrderId]];
    
    return statusHeaders;
}

-(void)dealloc
{
    [statusTrackPage release];
    [statusHeaders release];
    
    [super dealloc];
}

@end
