//
//  OTSMfServant.m
//  TheStoreApp
//
//  Created by yiming dong on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSMfServant.h"

#import "OrderService.h"
#import "GlobalValue.h"
#import "Page.h"
#import "OrderItemVO.h"
#import "OrderCountVO.h"
#import "OTSOnlinePayNotifier.h"

#define DEFAULT_PAGE_NUM    1
#define MF_PAGE_SIZE        5



@implementation OTSMfServant
@synthesize orderPage, orderTrackDic, orderArr, isRequesting, totalGroupOrderCount;

-(id)init
{
    self = [super init];
    if (self)
    {
        self.orderTrackDic = [NSMutableDictionary dictionary];
        self.orderArr = [NSMutableArray arrayWithCapacity:MF_PAGE_SIZE * 2];

        totalGroupOrderCount = 0;
        currentPageNum = DEFAULT_PAGE_NUM;
    }
    
    return self;
}

#pragma mark -
-(BOOL)reachTotalSize
{
    return (orderPage == nil) || (orderPage && [self orderCount] >= totalSize);
}

-(void)requestOrderListPaged
{
    if (!self.isRequesting)
    {
        if (orderPage && [self reachTotalSize])
        {
            return;
        }
        
        self.isRequesting = YES;
        
        OrderService* service = [[[OrderService alloc] init] autorelease];
        
        if (orderPage && orderPage.currentPage)
        {
            currentPageNum = [orderPage.currentPage intValue];
            currentPageNum ++;
        }
        else
        {
            currentPageNum = DEFAULT_PAGE_NUM;
        }
        
        // 获取1号店的订单
        self.orderPage = [service getMyOrderListByToken:[GlobalValue getGlobalValueInstance].token  
                                                          type:[NSNumber numberWithInt:KOtsOrderTypeMaterialFlow]   // 物流订单
                                                    orderRange:[NSNumber numberWithInt:0]                           // 0为全部订单
                                                      siteType:[NSNumber numberWithInt:1]                           // 1为1号店
                                                   currentPage:[NSNumber numberWithInt:currentPageNum] 
                                                      pageSize:[NSNumber numberWithInt:MF_PAGE_SIZE]];
     
//        // 获取1号商城的订单数
//        NSArray* arr = [service getMyOrderCount:[GlobalValue getGlobalValueInstance].token 
//                                              orderRange:(NSNumber*)[NSNumber numberWithInt:0]                      // 0全部订单
//                                                siteType:(NSNumber*)[NSNumber numberWithInt:2]];                    // 2为1号商城
//        if (arr) {
//            for (OrderCountVO *countVO in arr) {
//                if ([countVO.type intValue] == 1) {
//                    self.totalGroupOrderCount = [countVO.count intValue];
//                    break;
//                }
//            }
//        }
//        self.totalGroupOrderCount = [OTSOnlinePayNotifier sharedInstance].mallMfOrderCount;
        
        Page* mfPage = [service getMyOrderListByToken:[GlobalValue getGlobalValueInstance].token
                                                   type:[NSNumber numberWithInt:KOtsOrderTypeMaterialFlow]   // 物流订单
                                             orderRange:[NSNumber numberWithInt:0]                           // 0为全部订单
                                               siteType:[NSNumber numberWithInt:2]                           // 2为1号商城
                                            currentPage:[NSNumber numberWithInt:1]
                                               pageSize:[NSNumber numberWithInt:1]];
        
        
        if (mfPage) {
            self.totalGroupOrderCount = [mfPage.totalSize intValue];
        }
        
        
        if (orderPage)
        {
            totalSize = [orderPage.totalSize intValue];
        }
       
        [self requestOrderDetailForCurrentPage];
        [self requestSubOrderStatusForCurrentPage];
        
        
        [orderArr addObjectsFromArray:orderPage.objList];
        
        self.isRequesting = NO;
    }
}

#pragma mark -
//-(Page*)requestOrderList
//{
//    OrderService* service = [[[OrderService alloc] init] autorelease];
//    self.orderPage = [service getMyOrderListByToken:[GlobalValue getGlobalValueInstance].token 
//                                        currentPage:[NSNumber numberWithInt:1] pageSize:[NSNumber numberWithInt:100]];
//    return orderPage;
//}

-(void)requestOrderDetailForCurrentPage
{
    if (orderPage && orderPage.objList)
    {
        int orderCount = [orderPage.objList count];
        for (int i = 0; i< orderCount; i++)
        {
            NSAutoreleasePool* thePool = [[NSAutoreleasePool alloc] init];
            
            OrderV2* theOrder = [orderPage.objList objectAtIndex:i];
            OrderService* service = [[[OrderService alloc] init] autorelease];
            OrderV2* orderDetail = [service getOrderDetailByOrderIdEx:[GlobalValue getGlobalValueInstance].token  orderId:theOrder.orderId];
            if (orderDetail)
            {
                [orderPage.objList replaceObjectAtIndex:i withObject:orderDetail];
            }
            
            [thePool drain];
        }
    }
}


-(void)requestSubOrderStatusForCurrentPage
{
    if ([self currentPageHasOrder])
    {
        for (OrderV2* ord in orderPage.objList)
        {
            NSAutoreleasePool* thePool = [[NSAutoreleasePool alloc] init];
            
            if (ord)
            {
                if (ord.childOrderList)
                {
                    for (OrderV2* subOrd in ord.childOrderList)
                    {
                        [self requestOrderStatus:[subOrd.orderId longLongValue]];
                    }
                }
                else
                {
                    [self requestOrderStatus:[ord.orderId longLongValue]];
                }
            }
            
            [thePool drain];
        }
    }

}

-(Page*)requestOrderStatus:(long long int)aOrderId
{
        
        OrderService* service = [[[OrderService alloc] init] autorelease];
        
        Page * page = [service getOrderStatusTrack:[GlobalValue getGlobalValueInstance].token 
                                           orderId:[NSNumber numberWithLongLong:aOrderId] 
                                       currentPage:[NSNumber numberWithInt:1] 
                                          pageSize:[NSNumber numberWithInt:100]];
        
        if (page)
        {
            [orderTrackDic setObject:page forKey:[NSNumber numberWithLongLong:aOrderId]];
        }
        
        return page;
    
}


#pragma mark -

-(BOOL)hasOrder
{
    return [orderArr count] > 0;
}

-(BOOL)currentPageHasOrder
{
    return orderPage && orderPage.objList && [orderPage.objList count] > 0;
}

-(OrderV2*)orderForIndex:(NSUInteger)aIndex
{
    return [orderArr objectAtIndex:aIndex];
}

-(NSUInteger)orderCount
{
    return [orderArr count];
}

-(Page*)statusListForOrderId:(long long int)aOrderId
{
    return [orderTrackDic objectForKey:[NSNumber numberWithLongLong:aOrderId]];
}


-(NSArray*)statusListForOrder:(OrderV2*)aOrder
{
    if (aOrder)
    {
        NSMutableArray* statusList = [NSMutableArray array];
        
        if (aOrder.childOrderList)
        {
            for (OrderV2* subOrd in aOrder.childOrderList)
            {
                Page* subOrderStatusList = [self statusListForOrderId:[subOrd.orderId longLongValue]];
                if (subOrderStatusList)
                {
                    [statusList addObject:subOrderStatusList];
                }
            }
        }
        else
        {
            Page* theOrderStatusList = [self statusListForOrderId:[aOrder.orderId longLongValue]];
            if (theOrderStatusList)
            {
                [statusList addObject:theOrderStatusList];
            }
        }
        
        return statusList;
    }
    
    return nil;
}



-(OrderStatusTrackVO*)statusForOrderId:(long long int)aOrderId AtIndex:(NSUInteger)aIndex
{
    Page* statusList = [self statusListForOrderId:aOrderId];
    if (statusList && statusList.objList && aIndex < [statusList.objList count])
    {
        return [statusList.objList objectAtIndex:aIndex];
    }
    
    return nil;
}

-(NSUInteger)statusCountForOrderId:(long long int)aOrderId
{
    Page* statusList = [self statusListForOrderId:aOrderId];
    if (statusList && statusList.objList)
    {
        return [statusList.objList count];
    }
    
    return 0;
}

#pragma mark -
-(void)dealloc
{
    [orderPage release];
    [orderTrackDic release];
    [orderArr release];
        
    [super dealloc];
}

@end
