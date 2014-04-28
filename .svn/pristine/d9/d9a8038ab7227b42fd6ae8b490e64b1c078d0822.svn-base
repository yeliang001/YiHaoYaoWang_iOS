//
//  OTSMfServant.h
//  TheStoreApp
//
//  Created by yiming dong on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Page;
@class OrderV2;
@class OrderStatusTrackVO;


@interface OTSMfServant : NSObject
{
    NSUInteger      currentPageNum;
 @public
    int             totalSize;
    int             totalGroupOrderCount;
}
@property(retain)Page                   *orderPage;
@property(retain)NSMutableArray         *orderArr;
@property(retain)NSMutableDictionary    *orderTrackDic;
@property int   totalGroupOrderCount;
@property BOOL  isRequesting;
-(void)requestOrderListPaged;

//-(Page*)requestOrderList;                   // 请求订单列表
-(void)requestOrderDetailForCurrentPage;            // 获得currentPage的所有订单详情
-(void)requestSubOrderStatusForCurrentPage;                 // 请求currentPage的所有子订单的状态
-(Page*)requestOrderStatus:(long long int)aOrderId;   // 请求指定id订单子状态
-(BOOL)reachTotalSize;

-(BOOL)hasOrder;
-(BOOL)currentPageHasOrder;
-(OrderV2*)orderForIndex:(NSUInteger)aIndex;    // 获得指定index的订单
-(NSUInteger)orderCount;                        // 获得订单总数


-(NSArray*)statusListForOrder:(OrderV2*)aOrder;
-(OrderStatusTrackVO*)statusForOrderId:(long long int)aOrderId AtIndex:(NSUInteger)aIndex; // 指定订单指定index的状态
-(NSUInteger)statusCountForOrderId:(long long int)aOrderId;   // 指定id订单的状态数量

@end
