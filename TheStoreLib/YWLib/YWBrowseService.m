//
//  YWBrowseService.m
//  TheStoreApp
//
//  Created by LinPan on 13-9-29.
//
//  浏览历史

#import "YWBrowseService.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "ProductInfo.h"
#import "NSString+Common.h"
#define kTableName @"recentlybrowse"


@implementation YWBrowseService

#pragma mark 添加一条商品信息sqlite3
- (BOOL)saveBrowseHistory:(ProductInfo *)product
{
    __block BOOL result = NO;
    __block BOOL isExist = NO;
    
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self getAddressDBPath]];
    
    NSString *sqlStr = @"select * from recentlybrowse where product_id=?";
    [queue inDatabase:^(FMDatabase *_db){
        FMResultSet *rt = [_db executeQuery:sqlStr,product.productId];
        isExist = [rt next];
        if (isExist)
        {
            //更新
            NSString *update = @"UPDATE recentlybrowse SET browse_time=? WHERE product_id=?";
            result = [_db executeUpdate:update,[NSString stringWithDate:[NSDate date] formater:@"yyyy-MM-dd HH:mm:ss"],product.productId];
        }
    }];
    if (isExist)
    {
        return result;
    }
    
    //商品不存在，则插入表中
    NSString *update = @"INSERT INTO recentlybrowse (product_no,product_id,product_name,price,img,browse_time,yao_type)VALUES (?,?,?,?,?,?,?);";
    [queue inDatabase:^(FMDatabase *_db){
        result = [_db executeUpdate:update,/*@"123",@"1",@"http://adsf",@"10",@"110000",@"108"*/
                  product.productNO,
                  product.productId,
                  product.name,
                  product.price,
                  product.mainImg3,
                  [NSString stringWithDate:[NSDate date] formater:@"yyyy-MM-dd HH:mm:ss"],
                  product.prescription
                  ];
    }];
    return result;
}



#pragma mark 删除一条商品信息sqlite3
//- (BOOL)deleteLocalCartByProductIdFromSqlite3:(NSString *)productId
//{
//    __block BOOL flag;
//    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:kDBPath];
//    [queue inDatabase:^(FMDatabase *_db){
//        NSString *sqlStr = @"delete from shoppingcar where product_id=?";
//        flag = [_db executeUpdate:sqlStr,productId];
//    }];
//    return flag;
//}
//
//
//#pragma mark 清空本地购物车sqlite3
- (BOOL)cleanHistoryByProductId:(NSString *)productId
{
    __block BOOL flag;
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self getAddressDBPath]];
    [queue inDatabase:^(FMDatabase *_db){
        NSString *sqlStr = @"delete from recentlybrowse where product_id =?";
        flag = [_db executeUpdate:sqlStr,productId];
    }];
    return flag;
}
//
- (BOOL)cleanHistory
{
    __block BOOL flag;
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self getAddressDBPath]];
    [queue inDatabase:^(FMDatabase *_db){
        NSString *sqlStr = @"delete from recentlybrowse";
        flag = [_db executeUpdate:sqlStr];
    }];
    return flag;
}
//
//
- (NSMutableArray *)getHistoryBrowse
{
    NSMutableArray *localArr = [[NSMutableArray alloc] init];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self getAddressDBPath]];
    [queue inDatabase:^(FMDatabase *_db){
        NSString *sqlStr = @"select * from recentlybrowse order by browse_time desc limit 20";
        FMResultSet *rt = [_db executeQuery:sqlStr];
        while ([rt next])
        {
            ProductInfo *product = [[ProductInfo alloc] init];
            product.productId = [rt stringForColumn:@"product_id"];
            product.productNO = [rt stringForColumn:@"product_no"];
            product.name = [rt stringForColumn:@"product_name"];
            product.price = [rt stringForColumn:@"price"];
            product.productImageUrl = [rt stringForColumn:@"img"];
            product.prescription = [rt stringForColumn:@"yao_type"];
            
            [localArr addObject:product];
            [product release];
        }
    }];
    
    return [localArr autorelease];
}

//本地数据库路径
- (NSString *)getAddressDBPath
{
    //把工程中的数据库拷到docoument下
    NSFileManager*fileManager =[NSFileManager defaultManager];
    NSError*error;
    NSArray*paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString*documentsDirectory =[paths objectAtIndex:0];
    
    NSString*sqlPath =[documentsDirectory stringByAppendingPathComponent:@"yw_address.sqlite"];
    
    if([fileManager fileExistsAtPath:sqlPath] == NO)
    {
        NSString*resourcePath =[[NSBundle mainBundle] pathForResource:@"yw_address" ofType:@"sqlite"];
        [fileManager copyItemAtPath:resourcePath toPath:sqlPath error:&error];
    }
    
    DebugLog(@"数据库path %@",sqlPath);
    return sqlPath;
}

@end
