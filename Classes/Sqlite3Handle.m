//
//  Sqlite3Delegate.m
//  TheStoreApp
//
//  Created by towne on 12-9-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Sqlite3Handle.h"

@interface Sqlite3Handle()
-(NSString*) dbPath;
@end

@implementation Sqlite3Handle
@synthesize database=_database;


-(NSString*) dbPath{
    NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *databaseFilePath = [documentsPaths objectAtIndex:0];
//    NSLog(@"databaseFilePath >>>>>>>>>>>>>>>>>>>>>>>> %@",databaseFilePath);
    return [databaseFilePath stringByAppendingPathComponent:kDataBase];
}

-(BOOL) openDB
{
    [_database close];
    _database = [FMDatabase databaseWithPath:self.dbPath];
    return [_database open];
}

-(void) closeDB
{
    [_database close];
    _database = nil;
}

////--------------获取数据库实例----------------
#pragma mark - singleton methods
static Sqlite3Handle *sharedInstance = nil;

+ (Sqlite3Handle *)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [[self alloc] init];
        }
    }
    
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release
{
}

- (id)autorelease
{
    return self;
}

- init
{
    if ((self = [super init]))
    {
        
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
        
        //接口日志
        NSString *createSQLinterfacelog = @"CREATE TABLE IF NOT EXISTS interfacelog (ROW INTEGER PRIMARY KEY autoincrement, provinceid INTEGER,methodname TEXT,count INTEGER,avglag TEXT,minlag TEXT,maxlag TEXT,timeoutcount INTEGER,nettype TEXT,created_date TEXT,modified_date TEXT);";
        
        //最近浏览
        NSString *createSQLbrowse = @"CREATE TABLE IF NOT EXISTS browse (ROW INTEGER PRIMARY KEY autoincrement, productid INTEGER,merchantid INTEGER,cnname TEXT,minidefaultproducturl TEXT,maketprice TEXT,price TEXT,canbuy TEXT,score TEXT,experiencecount TEXT,shoppingcount TEXT,promotionId TEXT,promotionPrice TEXT,provinceId INTEGER,hasgift INTEGER,modified_time TEXT);";
        
        //团购浏览
        NSString *createSQLgrouponbrowse = @"CREATE TABLE IF NOT EXISTS grouponbrowse (ROW INTEGER PRIMARY KEY autoincrement, nid INTEGER,productid INTEGER,merchantid INTEGER,name TEXT,miniImageUrl TEXT,saveCost TEXT,price TEXT,areaid INTEGER,categoryid INTEGER,peopleNumber INTEGER,sitetype INTEGER,mallURL TEXT,provinceId INTEGER,modified_time TEXT);";
        
        //本地购物车
        NSString *createSQLLocalCartItem = @"CREATE TABLE IF NOT EXISTS localcart (ROW INTEGER PRIMARY KEY autoincrement, productid INTEGER,merchantid INTEGER,cnname TEXT,minidefaultproducturl TEXT,price TEXT,quantity INTEGER,shoppingcount TEXT,promotionid TEXT,promotionprice TEXT,hasgift INTEGER,mobileproducttype TEXT,hascash TEXT,hasredemption TEXT,modified_time TEXT);";
        
        //增加字段 isYihaodian  mallDefaultURL grouponId
        NSString *checkNewStatsSQLbrowse = @"select isYihaodian from browse";
        
        NSString *upgradeSQLbrowse1 = @"alter table browse add isYihaodian INTEGER";
        NSString *upgradeSQLbrowse2 = @"alter table browse add mallURL TEXT";
        NSString *upgradeSQLbrowse3 = @"alter table browse add grouponId INTEGER";
        
        // 分类缓存
        NSString *createSQLCategoty = @"CREATE TABLE IF NOT EXISTS categoryIds (ROW INTEGER PRIMARY KEY autoincrement, nid INTEGER ,categoryName TEXT, rootId INTEGER);";
        
        __block int ix=0;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [queue inDatabase:^(FMDatabase *_db){
                [_db executeUpdate:createSQLinterfacelog];
            }];
            
            [queue inDatabase:^(FMDatabase *_db){
                [_db executeUpdate:createSQLbrowse];
            }];
            
            [queue inDatabase:^(FMDatabase *_db){
                [_db executeUpdate:createSQLgrouponbrowse];
            }];
            
            [queue inDatabase:^(FMDatabase *_db){
                [_db executeUpdate:createSQLLocalCartItem];
            }];
            
            [queue inDatabase:^(FMDatabase *_db){
                [_db executeUpdate:createSQLCategoty];
            }];
            
            [queue inDatabase:^(FMDatabase *_db){
                FMResultSet *rs = [_db executeQuery:checkNewStatsSQLbrowse];
                if (!rs) {
                    ix=1;
                }
            }];
            
            if (ix) {
                [queue inDatabase:^(FMDatabase *_db){
                    [_db executeUpdate:upgradeSQLbrowse1];
                    [_db executeUpdate:upgradeSQLbrowse2];
                    [_db executeUpdate:upgradeSQLbrowse3];
                }];
            }
     
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"ok~ sqlite3 init done");
            });
        });
    }
    return self;
}

@end
