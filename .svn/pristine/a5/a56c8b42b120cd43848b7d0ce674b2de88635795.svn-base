//
//  InterfaceLog.m
//  TheStoreApp
//
//  Created by towne on 12-9-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define CLOSING_WITH_TICK @"'＞"
#define START_TABLE       @"＜table name='"
#define END_TABLE         @"＜/table＞"
#define START_ROW         @"＜row＞"
#define END_ROW           @"＜/row＞"
#define START_COL         @"＜col name='"
#define END_COL           @"＜/col＞"

#import "InterfaceLog.h"
#import "FMResultSet.h"
#import "FMDatabaseQueue.h"
@implementation InterfaceLog

- init
{
    if ((self = [super init])){
    }
    return self;
}

//---------------obj不能为NULL---------------------------

- (NSString *) stringWithUTF8String:(char*)obj
{
    if (nil==obj) {
        return @"";
    }
    else {
        return [NSString stringWithUTF8String:obj];
    }
}

/**
 * 获得所有的日志字符串
 *
 * @return
 */
+(NSString *)queryInterfaceLog
{
    NSMutableArray *arr=[NSMutableArray arrayWithCapacity:2];
    NSString *query = @"SELECT ROW,provinceid,methodname,count,avglag,minlag,maxlag,timeoutcount,nettype,created_date,modified_date FROM interfacelog";
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    [queue inDatabase:^(FMDatabase *_db){
        FMResultSet *rs = [_db executeQuery:query];
        while ([rs next])
        {
            [arr addObject:START_ROW];
            [arr addObject:[InterfaceLog addColumn:@"provinceid" valint:[rs intForColumnIndex:1]]];
            [arr addObject:[InterfaceLog addColumn:@"methodname" valtext:[rs stringForColumnIndex:2]]];
            [arr addObject:[InterfaceLog addColumn:@"count" valint:[rs intForColumnIndex:3]]];
            [arr addObject:[InterfaceLog addColumn:@"avglag" valdouble:[rs doubleForColumnIndex:4]]];
            [arr addObject:[InterfaceLog addColumn:@"minlag" valdouble:[rs doubleForColumnIndex:5]]];
            [arr addObject:[InterfaceLog addColumn:@"maxlag" valdouble:[rs doubleForColumnIndex:6]]];
            [arr addObject:[InterfaceLog addColumn:@"timeoutcount" valint:[rs intForColumnIndex:7]]];
            [arr addObject:[InterfaceLog addColumn:@"nettype" valtext:[rs stringForColumnIndex:8]]];
            [arr addObject:[InterfaceLog addColumn:@"created_date" valtext:[rs stringForColumnIndex:9]]];
            [arr addObject:[InterfaceLog addColumn:@"modified_date" valtext:[rs stringForColumnIndex:10]]];
            [arr addObject:END_ROW];
        }
        //----------发送以后删除表纪录----------
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [queue inDatabase:^(FMDatabase *_db){
                NSString *sqlStr = @"delete from interfacelog";
                [_db executeUpdate:sqlStr];
            }];
        });
    }];
    return [arr componentsJoinedByString: @""];
}

+ (NSString *) stringWithUTF8String:(char*)obj
{
    if (nil==obj) {
        return @"";
    }
    else {
        return [NSString stringWithUTF8String:obj];
    }
}

+(NSString *) addColumn:(NSString *) name valtext:(NSString *) val
{
    NSMutableString* stg = [NSString stringWithFormat:@"%@%@%@%@%@",START_COL,name,CLOSING_WITH_TICK,val,END_COL];
    return stg;
}

+(NSString *) addColumn:(NSString *) name valint:(int) val
{
    NSString * _val = [NSString stringWithFormat:@"%d", val];
    NSMutableString* stg = [NSString stringWithFormat:@"%@%@%@%@%@",START_COL,name,CLOSING_WITH_TICK,_val,END_COL];
    return stg;
}

+(NSString *) addColumn:(NSString *) name valdouble:(double) val
{
    NSString * _val = [NSString stringWithFormat:@"%f", val];
    NSMutableString* stg = [NSString stringWithFormat:@"%@%@%@%@%@",START_COL,name,CLOSING_WITH_TICK,_val,END_COL];
    return stg;
}

/**
 * 新增接口时间记录
 *
 * @param methedName
 * @param lag
 * @param netType
 */
+(void)addInterfaceLog:(NSString *)methedname Lag:(NSNumber *)lag NetType:(NSString *)nettype;
{
    
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[_handle dbPath]];
    NSNumber *provinceId = [GlobalValue getGlobalValueInstance].provinceId;
    NSString *query = @"SELECT ROW,count,timeoutCount,avglag,minlag,maxlag FROM interfacelog where provinceid=? and methodname=? and nettype=?";
    
    __block int rowcount = 0;
    __block int count = 0;
    __block int timeoutcount = 0;
    __block double avglag = 0.0;
    __block double minlag = 0.0;
    __block double maxlag = 0.0;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [queue inDatabase:^(FMDatabase *_db){
            FMResultSet *rs = [_db executeQuery:query,provinceId,methedname,nettype];
            while ([rs next])
            {
                rowcount = [rs intForColumnIndex:0];
                count = [rs intForColumnIndex:1];
                timeoutcount = [rs intForColumnIndex:2];
                avglag = [rs doubleForColumnIndex:3];
                minlag = [rs doubleForColumnIndex:4];
                maxlag =  [rs doubleForColumnIndex:5];
            }
            
            //--------------计算平均延时-----------------------
            double lagdouble = [lag doubleValue];
            if ([lag doubleValue] < 0)
            {
                timeoutcount++;
            }
            else
            {
                avglag = (avglag*count+++lagdouble)/(count);
            }
            if (lagdouble-maxlag>0)
            {
                maxlag = lagdouble;
            }
            if (lagdouble-minlag<0){
                minlag = lagdouble;
            }
            
            if (rowcount) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [queue inDatabase:^(FMDatabase *_db){
                        NSString *update = @"update interfacelog set modified_date=?,count=?,avglag=?,minlag=?,maxlag=?,timeoutcount=? where provinceid=? and methodname=? and nettype=?";
                        NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
                        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
                        [_db executeUpdate:update,
                         dateString,
                         [NSNumber numberWithInt:count],
                         [NSNumber numberWithDouble:avglag],
                         [NSNumber numberWithDouble:minlag],
                         [NSNumber numberWithDouble:maxlag],
                         [NSNumber numberWithInt:timeoutcount],
                         provinceId,
                         methedname,
                         nettype
                         ];
                    }];
                });
            }
            
            else
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [queue inDatabase:^(FMDatabase *_db){
                        NSString *update = @"insert into interfacelog (provinceid,methodname,count,avglag,minlag,maxlag,timeoutcount,nettype,created_date,modified_date) values (?,?,?,?,?,?,?,?,?,?)";
                        NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
                        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
                        [_db executeUpdate:update,
                         provinceId,
                         methedname,
                         [NSNumber numberWithInt:count],
                         lag,
                         lag,
                         lag,
                         [NSNumber numberWithInt:timeoutcount],
                         nettype,
                         dateString,
                         dateString
                         ];
                    }];
                });
            }
        }];
    });
}

-(void) dealloc
{
    [super dealloc];
}

@end
