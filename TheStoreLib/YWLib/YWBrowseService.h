//
//  YWBrowseService.h
//  TheStoreApp
//
//  Created by LinPan on 13-9-29.
//
//

#import <Foundation/Foundation.h>
@class ProductInfo;
@interface YWBrowseService : NSObject

- (BOOL)saveBrowseHistory:(ProductInfo *)product;
- (BOOL)cleanHistoryByProductId:(NSString *)productId;
- (BOOL)cleanHistory;
- (NSMutableArray *)getHistoryBrowse;

@end
