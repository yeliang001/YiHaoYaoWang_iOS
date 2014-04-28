//
//  YWLocalCatService.h
//  TheStoreApp
//
//  Created by LinPan on 13-8-24.
//
//

#import "YWBaseService.h"


@class LocalCarInfo;
@interface YWLocalCatService : YWBaseService

- (BOOL)saveLocalCartToDB:(LocalCarInfo *)localCarInfo;
- (BOOL)deleteLocalCartByProductIdFromSqlite3:(NSString *)productId;
#pragma mark 清空本地购物车sqlite3
- (BOOL)cleanLocalCartByUid:(NSString *)uid;
- (BOOL)cleanLocalCart;
- (NSMutableArray *)getShoppingCart;
- (BOOL)updateProductNum:(NSString *)productId productNum:(int)num;
@end
