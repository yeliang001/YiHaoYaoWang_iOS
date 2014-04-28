//
//  BrowseService.h
//  TheStoreApp
//
//  Created by towne on 12-9-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sqlite3Handle.h"
#import "ProductVO.h"
#import "GrouponVO.h"
#import "Trader.h"
#import "MethodBody.h"
#import "TheStoreService.h"
#import "GlobalValue.h"

@interface BrowseService : TheStoreService

- (ProductVO *)queryProductIdByInterface:(NSNumber *)productId provice:(NSNumber *)provinceId promote:(NSString *)promoteId;
- (void)updateBrowseHistoryByInterface:(NSNumber *)provinceId;
- (ProductVO *)queryProductBrowseById:(NSNumber *)productId province:(NSNumber *)provinceId;
- (GrouponVO *)getGrouponById:(NSNumber *)grouponId;
- (BOOL)saveBrowseHistory:(ProductVO *)product province:(NSNumber *)provinceId;
- (NSMutableArray *)queryBrowseHistory;
- (BOOL)updateBrowseHistory:(ProductVO *)product provice:(NSNumber *)provinceId;

- (BOOL)saveGrouponBrowseHistory:(GrouponVO *)groupon province:(NSNumber *)provinceId;
- (BOOL)updateGrouponBrowseHistory:(GrouponVO *)groupon provice:(NSNumber *)provinceId;

- (BOOL)savefkToBrowse:(NSNumber *)grouponid;
- (BOOL)deleteBrowseHistory;
- (BOOL)deleteGrouponBrowseHistory;
- (int)queryBrowseHistoryByIdCount:(NSNumber *)productId;
- (int)queryGrouponBrowseHistoryByIdCount:(NSNumber *)grouponId;
- (BOOL)deleteBrowseHistoryById:(NSNumber *)productId;
- (BOOL)deleteGrouponBrowseHistoryById:(NSNumber *)nid;
- (BOOL)deleteBrowseHistoryByGrouponId:(NSNumber *)nid;
@end
