//
//  YWLocalCatService.m
//  TheStoreApp
//
//  Created by LinPan on 13-8-24.
//
//

#import "YWLocalCatService.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "LocalCarInfo.h"

#define kDBPath  [self getAddressDBPath]

@implementation YWLocalCatService


#pragma mark 添加一条商品信息sqlite3
- (BOOL)saveLocalCartToDB:(LocalCarInfo *)localCarInfo
{
    __block BOOL result = NO;
    __block BOOL isExist = NO;


    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self getAddressDBPath]];
    
    NSString *sqlStr = @"select * from shoppingcar where product_id=?";
    [queue inDatabase:^(FMDatabase *_db){
        FMResultSet *rt = [_db executeQuery:sqlStr,localCarInfo.productId];
        isExist = [rt next];
        if (isExist)
        {
            //如果改商品已经存在了 就数量＋1
            NSString  *num = [rt stringForColumn:@"num"];
            
            int newNum = [num intValue] + [localCarInfo.num intValue];
            //更新
            NSString *update = @"UPDATE shoppingcar SET num=? WHERE product_id=?";
            result = [_db executeUpdate:update,[NSString stringWithFormat:@"%d",newNum],localCarInfo.productId];
        }
    }];
    if (isExist)
    {
        return result;
    }
    
    //商品不存在，则插入表中
    NSString *update = @"INSERT INTO shoppingcar (product_id,num,img,price,province_id,product_no,item_id)VALUES (?,?,?,?,?,?,?);";
    [queue inDatabase:^(FMDatabase *_db){
        result = [_db executeUpdate:update,/*@"123",@"1",@"http://adsf",@"10",@"110000",@"108"*/
                  localCarInfo.productId,
                  localCarInfo.num,
                  localCarInfo.imageUrlStr,
                  localCarInfo.price,
                  localCarInfo.provinceId,
                  localCarInfo.productNO,
                  localCarInfo.itemId
                  /*,
                  localCarInfo.uid*/
                  ];
    }];
    return result;
}

//更新购物车中商品数量
- (BOOL)updateProductNum:(NSString *)productId productNum:(int)num
{
    __block BOOL result = NO;
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self getAddressDBPath]];
    
    NSString *sqlStr = @"select * from shoppingcar where product_id=?";
    [queue inDatabase:^(FMDatabase *_db){
        FMResultSet *rt = [_db executeQuery:sqlStr,productId];
        if ([rt next])
        {
            //更新
            NSString *update = @"UPDATE shoppingcar SET num=? WHERE product_id=?";
            result = [_db executeUpdate:update,[NSString stringWithFormat:@"%d",num],productId];
        }
        
    }];

    return result;
}

#pragma mark 删除一条商品信息sqlite3
- (BOOL)deleteLocalCartByProductIdFromSqlite3:(NSString *)productId
{
    __block BOOL flag;
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:kDBPath];
    [queue inDatabase:^(FMDatabase *_db){
        NSString *sqlStr = @"delete from shoppingcar where product_id=?";
        flag = [_db executeUpdate:sqlStr,productId];
    }];
    return flag;
}


#pragma mark 清空本地购物车sqlite3
- (BOOL)cleanLocalCartByUid:(NSString *)uid
{
    __block BOOL flag;
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:kDBPath];
    [queue inDatabase:^(FMDatabase *_db){
        NSString *sqlStr = @"delete from shoppingcar where uid=?";
        flag = [_db executeUpdate:sqlStr,uid];
    }];
    return flag;
}

- (BOOL)cleanLocalCart
{
    __block BOOL flag;
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:kDBPath];
    [queue inDatabase:^(FMDatabase *_db){
        NSString *sqlStr = @"delete from shoppingcar";
        flag = [_db executeUpdate:sqlStr];
    }];
    return flag;
}


- (NSMutableArray *)getShoppingCart
{
    NSMutableArray *localArr = [[NSMutableArray alloc] init];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:kDBPath];
    [queue inDatabase:^(FMDatabase *_db){
        NSString *sqlStr = @"select * from shoppingcar";
        FMResultSet *rt = [_db executeQuery:sqlStr];
        while ([rt next])
        {
            LocalCarInfo *localCarInfo = [[LocalCarInfo alloc] initWithProductId:[rt stringForColumn:@"product_id"]
                                                                   shoppingCount:[rt stringForColumn:@"num"]
                                                                        imageUrl:[rt stringForColumn:@"img"]
                                                                           price:[rt stringForColumn:@"price"]
                                                                      provinceId:[rt stringForColumn:@"province_id"]
                                                                             uid:[rt stringForColumn:@"uid"]
                                                                       productNO:[rt stringForColumn:@"product_no"]
                                                                          itemId:[rt stringForColumn:@"item_id"]];
            
            [localArr addObject:localCarInfo];
            [localCarInfo release];
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

    return sqlPath;
}

@end
