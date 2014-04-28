//
//  BrowseService.m
//  TheStoreApp
//
//  Created by towne on 12-9-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BrowseService.h"
#import "FMResultSet.h"

@implementation BrowseService

- init
{
    if ((self = [super init]))
    {
    }
    return self;
}

- (ProductVO *)queryProductIdByInterface:(NSNumber *)productId provice:(NSNumber *)provinceId promote:(NSString *)promoteId
{
    if(!promoteId) {
        promoteId = @"";
    }
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[[GlobalValue getGlobalValueInstance].trader toXml]];
    [body addLong:productId];
    [body addLong:provinceId];
    [body addString:promoteId];
    NSObject *ret=[self getReturnObject:@"getProductDetail" methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[ProductVO class]]) {
        ProductVO *po=(ProductVO*)ret;
        return po;
    } else {
        return nil;
    }
}

//--------------接口与本地数据库联合更新product的状态--------------------
- (void)updateBrowseHistoryByInterface:(NSNumber *)provinceId
{
    NSMutableArray *localProducts = [[[NSMutableArray alloc]init] autorelease];
    NSMutableArray *productIds = [[[NSMutableArray alloc]init] autorelease];
    NSMutableArray *bpArray = [self queryBrowseHistory];
    for (id obj in bpArray) {
        if ([obj isKindOfClass:[ProductVO class]]) {
            ProductVO *product = obj;
            //只处理自营商品
            if([product.isYihaodian isEqualToNumber:[NSNumber numberWithInt:1]])
            [productIds addObject:[product productId]];
            [localProducts addObject:product];
        }
    }
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[[GlobalValue getGlobalValueInstance].trader toXml]];
    [body addArrayForLong:productIds];
    [body addLong:provinceId];
    NSObject *ret=[self getReturnObject:@"getProductDetails" methodBody:body];
    //--------如果省份provinceId查不到商品，将该id置为不能买
    if (ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray * po = (NSArray*)ret;
        for (int i=0; i<[po count]; i++) {
            ProductVO *vo = [po objectAtIndex:i];
            ProductVO *temProduct = [localProducts objectAtIndex:i];
            //只处理自营商品
            vo.isYihaodian = [NSNumber numberWithInt:1];
            if ([vo.productId isEqualToNumber:[NSNumber numberWithInt:0]]) {
//                vo.productId = [productIds objectAtIndex:i];
//                vo.canBuy = @"flase";
                temProduct.canBuy = @"flase";
            }
            else
            {
                temProduct.canBuy = @"true";
            }
            [self updateBrowseHistory:temProduct provice:provinceId];
        }
    }
}

//[NSString stringWithUTF8String:obj]  obj不能为NULL
/*
 - (NSString *) stringWithUTF8String:(char*)obj
 {
 if (nil==obj) {
 return @"";
 }
 else {
 return [NSString stringWithUTF8String:obj];
 }
 }
 */

- (ProductVO *)queryProductBrowseById:(NSNumber *)productId province:(NSNumber *)provinceId{
    
    ProductVO *product=[[ProductVO alloc]init];
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    NSString *query = @"SELECT ROW, productid,merchantid,cnname,minidefaultproducturl,maketprice,price,canbuy,score,experiencecount,shoppingcount,promotionid,promotionprice,hasgift,provinceid,modified_time,isYihaodian,mallURL FROM browse where productid=? and provinceid=?";
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    [queue inDatabase:^(FMDatabase *_db){
        FMResultSet *rs = [_db executeQuery:query,productId,provinceId];
        while ([rs next])
        {
            int productid = [rs intForColumn:@"productid"];
            int merchantid = [rs intForColumn:@"merchantid"];
            NSString *cnname = [rs stringForColumn:@"cnname"];
            NSString *minidefaultproducturl = [rs stringForColumn:@"minidefaultproducturl"];
            double maketprice = [rs doubleForColumn:@"maketprice"];
            double price = [rs doubleForColumn:@"price"];
            NSString *canbuy = [rs stringForColumn:@"canbuy"];
            int score = [rs intForColumn:@"score"];
            int experiencecount = [rs intForColumn:@"experiencecount"];
            int shoppingcount = [rs intForColumn:@"shoppingcount"];
            NSString *promotionid = [rs stringForColumn:@"promotionid"];
            double promotionPrice = [rs doubleForColumn:@"promotionPrice"];
            int hasGift = [rs intForColumn:@"hasGift"];
            int isYihaodian = [rs intForColumn:@"isYihaodian"];
            NSString *mallURL = [rs stringForColumn:@"mallURL"];
            
            product.productId=[NSNumber numberWithInt:productid];
            product.merchantId = [NSNumber numberWithInt:merchantid];
            product.cnName = cnname;
            product.miniDefaultProductUrl = minidefaultproducturl;
            product.maketPrice = [NSNumber numberWithDouble:maketprice];
            product.price = [NSNumber numberWithDouble:price];
            product.canBuy = canbuy;
            product.score = [NSNumber numberWithInt:score];
            product.experienceCount = [NSNumber numberWithInt:experiencecount];
            product.shoppingCount = [NSNumber numberWithInt:shoppingcount];
            product.promotionId = promotionid;
            product.promotionPrice = [NSNumber numberWithDouble:promotionPrice];
            product.hasGift = [NSNumber numberWithInt:hasGift];
            product.isYihaodian = [NSNumber numberWithInt:isYihaodian];
            product.mallDefaultURL = mallURL;
        }
    }];
    
    return [product autorelease];
}

- (BOOL)saveBrowseHistory:(ProductVO *)product province:(NSNumber *)provinceId
{
    __block BOOL result = NO;
    
    if (!product||[product isKindOfClass:[NSNull class]] ) {
        return 0;
    }
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
    
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    NSString *update = @"INSERT OR REPLACE INTO browse (productid,merchantid,cnname,minidefaultproducturl,maketprice,price,canbuy,score,experiencecount,shoppingcount,promotionid,promotionprice,hasgift,provinceid,modified_time,isYihaodian,mallURL)VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    [queue inDatabase:^(FMDatabase *_db){
        result = [_db executeUpdate:update,
                  product.productId,
                  product.merchantId,
                  product.cnName,
                  product.miniDefaultProductUrl,
                  product.maketPrice,
                  product.price,
                  product.canBuy,
                  product.score,
                  product.experienceCount,
                  product.shoppingCount,
                  product.promotionId,
                  product.promotionPrice,
                  product.hasGift,
                  provinceId,
                  dateString,
                  product.isYihaodian,
                  product.mallDefaultURL
                  ];
        
    }];
    return result;
}

- (int)queryBrowseHistoryByIdCount:(NSNumber *)productId
{
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    NSString *query = @"SELECT count(ROW) FROM browse where productid=?";
    __block int rowcount = 0;
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    [queue inDatabase:^(FMDatabase *_db){
        FMResultSet *rs = [_db executeQuery:query,productId];
        while ([rs next])
        {
            rowcount = [rs intForColumnIndex:0];
        }
    }];
    
    return rowcount;
}

- (int)queryGrouponBrowseHistoryByIdCount:(NSNumber *)grouponId
{
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    NSString *query = @"SELECT count(ROW) FROM grouponbrowse where nid=?";
    __block int rowcount = 0;
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    [queue inDatabase:^(FMDatabase *_db){
        FMResultSet *rs = [_db executeQuery:query,grouponId];
        while ([rs next])
        {
            rowcount = [rs intForColumnIndex:0];
        }
    }];
    
    return rowcount;
}


- (NSMutableArray *)queryBrowseHistory
{
    //只取最近20个，不分页显示
    NSMutableArray *array1= [[NSMutableArray alloc]init];
    NSString *query = @"SELECT ROW, productid,merchantid,cnname,minidefaultproducturl,maketprice,price,canbuy,score,experiencecount,shoppingcount,promotionid,promotionprice,hasgift,provinceid,modified_time,isYihaodian,mallURL,grouponId,modified_time FROM browse order by modified_time desc limit 20";
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    [queue inDatabase:^(FMDatabase *_db){
        FMResultSet *rs = [_db executeQuery:query];
        while ([rs next])
        {
            if ([rs stringForColumn:@"grouponId"]) {
                int grouponId = [rs intForColumn:@"grouponId"];
                GrouponVO *groupon = [self getGrouponById:[NSNumber numberWithInt:grouponId]];
                [array1 addObject:groupon];
            }
            else
            {
                ProductVO *product=[[ProductVO alloc]init];
                int productid= [rs intForColumnIndex:1];
                int merchantid = [rs intForColumnIndex:2];
                NSString *cnname= [rs stringForColumnIndex:3];
                NSString *minidefaultproducturl= [rs stringForColumnIndex:4];
                double maketprice = [rs doubleForColumnIndex:5];
                double price = [rs doubleForColumnIndex:6];
                NSString *canbuy = [rs stringForColumnIndex:7];
                int score = [rs intForColumnIndex:8];
                int experiencecount = [rs intForColumnIndex:9];
                int shoppingcount = [rs intForColumnIndex:10];
                NSString *promotionid = [rs stringForColumnIndex:11];
                double promotionPrice= [rs doubleForColumnIndex:12];
                int hasGift = [rs intForColumnIndex:13];
                int isYihaodian = [rs intForColumnIndex:16];
                NSString *mallURL = [rs stringForColumnIndex:17];
                
                product.productId=[NSNumber numberWithInt:productid];
                product.merchantId = [NSNumber numberWithInt:merchantid];
                product.cnName = cnname;
                product.miniDefaultProductUrl = minidefaultproducturl;
                product.maketPrice = [NSNumber numberWithFloat:maketprice];
                product.price = [NSNumber numberWithFloat:price];
                product.canBuy = canbuy;
                product.score = [NSNumber numberWithInt:score];
                product.experienceCount = [NSNumber numberWithInt:experiencecount];
                product.shoppingCount = [NSNumber numberWithInt:shoppingcount];
                product.promotionId = promotionid;
                product.promotionPrice = [NSNumber numberWithFloat:promotionPrice];
                product.hasGift = [NSNumber numberWithInt:hasGift];
                product.isYihaodian = [NSNumber numberWithInt:isYihaodian];
                product.mallDefaultURL = mallURL;
                [array1 addObject:product];
                [product release];
            }
        }
    }];
    return [array1 autorelease];
}


- (BOOL)savefkToBrowse:(NSNumber *)grouponid
{
    __block BOOL result = NO;
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    NSString *selectGroupon = @"select count(ROW) from browse where grouponid=?";
    NSString *insertFK = @"INSERT INTO browse (grouponid,modified_time)VALUES (?,?);";
    NSString *updateTime = @"update browse set modified_time=? where grouponid=?";
    __block int rsnull=0;
    [queue inDatabase:^(FMDatabase *_db){
        FMResultSet *rs = [_db executeQuery:selectGroupon,grouponid];
        while ([rs next])
        {
            rsnull = [rs intForColumnIndex:0];
        }
    }];
    if (rsnull==0) {
        [queue inDatabase:^(FMDatabase *_db){
            result = [_db executeUpdate:insertFK,
                      grouponid,
                      dateString
                      ];
        }];
    }
    else
    {
        [queue inDatabase:^(FMDatabase *_db){
            result = [_db executeUpdate:updateTime,
                      dateString,
                      grouponid
                      ];
        }];
    }
    return result;
}

- (GrouponVO *)getGrouponById:(NSNumber *)grouponId
{
    GrouponVO *groupon= [[GrouponVO alloc]init] ;
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    NSString *query = @"SELECT ROW, nid,productid,merchantid,name,miniImageUrl,saveCost,price,areaid,categoryid,peopleNumber,sitetype,mallURL FROM grouponbrowse where nid=? ";
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    [queue inDatabase:^(FMDatabase *_db){
        FMResultSet *rs = [_db executeQuery:query,grouponId];
        while ([rs next])
        {
            int nid = [rs intForColumn:@"nid"];
            int productid = [rs intForColumn:@"productid"];
            int merchantid = [rs intForColumn:@"merchantid"];
            NSString *name = [rs stringForColumn:@"name"];
            NSString *miniImageUrl = [rs stringForColumn:@"miniImageUrl"];
            double saveCost = [rs doubleForColumn:@"saveCost"];
            double price = [rs doubleForColumn:@"price"];
            int areaid = [rs intForColumn:@"areaid"];
            int categoryid = [rs intForColumn:@"categoryid"];
            int peopleNumber = [rs intForColumn:@"peopleNumber"];
            int sitetype = [rs intForColumn:@"sitetype"];
            NSString *mallURL = [rs stringForColumn:@"mallURL"];
            
            groupon.nid = [NSNumber numberWithInt:nid];
            groupon.productId=[NSNumber numberWithInt:productid];
            groupon.merchantId = [NSNumber numberWithInt:merchantid];
            groupon.name = name;
            groupon.miniImageUrl = miniImageUrl;
            groupon.saveCost = [NSNumber numberWithDouble:saveCost];
            groupon.price = [NSNumber numberWithDouble:price];
            groupon.areaId = [NSNumber numberWithInt:areaid];
            groupon.categoryId = [NSNumber numberWithInt:categoryid];
            groupon.peopleNumber = [NSNumber numberWithInt:peopleNumber];
            groupon.siteType = [NSNumber numberWithInt:sitetype];
            groupon.mallURL = mallURL;
        }
    }];
    
    return [groupon autorelease];
}

- (BOOL)updateBrowseHistory:(ProductVO *)product provice:(NSNumber *)provinceId;
{
    __block BOOL flag;
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    if (!product||[product isKindOfClass:[NSNull class]] ) {
        return 0;
    }
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
    
    NSString *update = @"update browse set modified_time=?,provinceId=?,merchantid=?,cnname=?,minidefaultproducturl=?,maketprice=?,price=?,canbuy=?,score=?,experiencecount=?,shoppingcount=?,promotionid=?,promotionprice=?,hasgift=?,isYihaodian=?,mallURL=? where productid=?";
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    [queue inDatabase:^(FMDatabase *_db){
        flag = [_db executeUpdate:update,
                dateString,
                provinceId,
                product.merchantId,
                product.cnName,
                product.miniDefaultProductUrl,
                product.maketPrice,
                product.price,
                product.canBuy,
                product.score,
                product.experienceCount,
                product.shoppingCount,
                product.promotionId,
                product.promotionPrice,
                product.hasGift,
                product.isYihaodian,
                product.mallDefaultURL,
                product.productId
                ];
    }];
    return flag;
}

- (BOOL)deleteBrowseHistory
{
    __block BOOL flag;
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    [queue inDatabase:^(FMDatabase *_db){
        NSString *sqlStr = @"delete from browse";
        flag = [_db executeUpdate:sqlStr];
    }];
    return flag;
}

- (BOOL)deleteGrouponBrowseHistory
{
    __block BOOL flag;
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    [queue inDatabase:^(FMDatabase *_db){
        NSString *sqlStr = @"delete from grouponbrowse";
        flag = [_db executeUpdate:sqlStr];
    }];
    return flag;
}

- (BOOL)deleteBrowseHistoryById:(NSNumber *)productId
{
    __block BOOL flag;
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    [queue inDatabase:^(FMDatabase *_db){
        NSString *sqlStr = @"delete from browse where productid=?";
        flag = [_db executeUpdate:sqlStr,productId];
    }];
    return flag;
}

- (BOOL)deleteBrowseHistoryByGrouponId:(NSNumber *)nid
{
    __block BOOL flag;
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    [queue inDatabase:^(FMDatabase *_db){
        NSString *sqlStr = @"delete from browse where grouponId=?";
        flag = [_db executeUpdate:sqlStr,nid];
    }];
    return flag;
}


- (BOOL)deleteGrouponBrowseHistoryById:(NSNumber *)nid
{
    __block BOOL flag;
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    [queue inDatabase:^(FMDatabase *_db){
        NSString *sqlStr = @"delete from grouponbrowse where nid=?";
        flag = [_db executeUpdate:sqlStr,nid];
    }];
    return flag;
}


//团购历史
- (BOOL)saveGrouponBrowseHistory:(GrouponVO *)groupon province:(NSNumber *)provinceId
{
    __block BOOL result = NO;
    
    if (!groupon||[groupon isKindOfClass:[NSNull class]] ) {
        return 0;
    }
    //自营团购取的是middleImageUrl，这里做适配
    if (!groupon.miniImageUrl) {
        groupon.miniImageUrl = groupon.middleImageUrl;
    }
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
    
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    NSString *update = @"INSERT OR REPLACE INTO grouponbrowse (nid,productid,merchantid,name,miniImageUrl,saveCost,price,areaid,categoryid,peopleNumber,sitetype,mallURL,provinceId,modified_time)VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    [queue inDatabase:^(FMDatabase *_db){
        result = [_db executeUpdate:update,
                  groupon.nid,
                  groupon.productId,
                  groupon.merchantId,
                  groupon.name,
                  groupon.miniImageUrl,
                  groupon.saveCost,
                  groupon.price,
                  groupon.areaId,
                  groupon.categoryId,
                  groupon.peopleNumber,
                  groupon.siteType,
                  groupon.mallURL,
                  provinceId,
                  dateString
                  ];
        
    }];
    return result;
}

- (BOOL)updateGrouponBrowseHistory:(GrouponVO *)groupon provice:(NSNumber *)provinceId
{
    __block BOOL flag;
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    if (!groupon||[groupon isKindOfClass:[NSNull class]] ) {
        return 0;
    }
    //自营团购取的是middleImageUrl，这里做适配
    if (!groupon.miniImageUrl) {
        groupon.miniImageUrl = groupon.middleImageUrl;
    }
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
    
    
    NSString *update = @"update grouponbrowse set modified_time=?,provinceId=?,productid=?,merchantid=?,name=?,miniImageUrl=?,saveCost=?,price=?,areaid=?,categoryid=?,peopleNumber=?,sitetype=?,mallURL=?,provinceId=? where nid=?";
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    [queue inDatabase:^(FMDatabase *_db){
        flag = [_db executeUpdate:update,
                dateString,
                provinceId,
                groupon.productId,
                groupon.merchantId,
                groupon.name,
                groupon.miniImageUrl,
                groupon.saveCost,
                groupon.price,
                groupon.areaId,
                groupon.categoryId,
                groupon.peopleNumber,
                groupon.siteType,
                groupon.mallURL,
                provinceId,
                groupon.nid
                ];
    }];
    return flag;
}

-(void) dealloc
{
    [super dealloc];
}

@end
