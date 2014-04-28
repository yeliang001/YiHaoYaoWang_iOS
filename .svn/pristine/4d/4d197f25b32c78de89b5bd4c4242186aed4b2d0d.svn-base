//
//  LocalCart.m
//  TheStoreApp
//
//  Created by linyy on 11-7-6.
//  Copyright 2011年 vsc. All rights reserved.
//

#import "LocalCartService.h"
#import "LocalCartItemVO.h"
#import "ProductVO.h"
#import "TheStoreAppAppDelegate.h"
#import "FMResultSet.h"

@implementation LocalCartService

#pragma mark 获取本地购物车信息
-(NSMutableArray *)getLocalCartArrayWithFilePath:(NSString *)aFilePath {
    NSData * fileData = [[NSData alloc] initWithContentsOfFile:aFilePath];
    if([fileData length] < 2){
        [fileData release];
        return nil;
    }
    NSString * fileContent = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [fileData release];
    NSString * subbedStr = [NSString stringWithString:fileContent];
    localCartArray = [[NSMutableArray alloc] initWithCapacity:0];
    while ([subbedStr rangeOfString:@"\r\n"].length!=0) {
        NSString * currentLineStr = [subbedStr substringToIndex:[subbedStr rangeOfString:@"\r\n" options:NSLiteralSearch].location];
        LocalCartItemVO * localProductVO = [LocalCartItemVO alloc];
        NSArray *subStrs=[currentLineStr componentsSeparatedByString:@"\\\'"];
        int i;
        for (i=0; i<[subStrs count]-1; i++) {
            NSString *subStr=(NSString *)[subStrs objectAtIndex:i];
            switch (i) {
                case 0:
                    [localProductVO setProductId:subStr];
                    break;
                case 1:
                    [localProductVO setCnName:subStr];
                    break;
                case 2:
                    [localProductVO setPrice:subStr];
                    break;
                case 3:
                    [localProductVO setShoppingCount:subStr];
                    break;
                case 4:
                    [localProductVO setMiniDefaultProductUrl:subStr];
                    break;
                case 5:
                    [localProductVO setMerchantId:subStr];
                    break;
                case 6:
                    [localProductVO setQuantity:subStr];
                    break;
                case 7:
                    if ([subStr isEqualToString:@"(null)"]) {
                        [localProductVO setPromotionId:nil];
                    } else {
                        [localProductVO setPromotionId:subStr];
                    }
                    break;
                case 8:
                    if ([subStr isEqualToString:@"(null)"]) {
                        [localProductVO setPromotionPrice:nil];
                    } else {
                        [localProductVO setPromotionPrice:subStr];
                    }
                    break;
                case 9: {
                    [localProductVO setHasGift:subStr];
                    break;
                }
                case 10: {
                    localProductVO.mobileProductType = subStr;
                    break;
                }
                case 11:{
                    if ([subStr isEqualToString:@"(null)"]) {
                        [localProductVO setHasCash:nil];
                    }else{
                        [localProductVO setHasCash:subStr];
                    }
                }
                    break;
                case 12:{
                    if ([subStr isEqualToString:@"(null)"]) {
                        [localProductVO setHasRedemption:@"0"];
                    }else{
                        localProductVO.hasRedemption=subStr;
                    }
                }
                    break;
                default:
                    break;
            }
        }
        [localCartArray addObject:localProductVO];
        [localProductVO release];
        subbedStr=[subbedStr substringFromIndex:[subbedStr rangeOfString:@"\r\n"].location+2];
    }
    [fileContent release];
    return localCartArray;
}

#pragma mark 清空本地商品数组
-(void)cleanLocalCartArray{
    if(localCartArray != nil){
        [localCartArray release];
    }
}
#pragma mark 创建本地购物车
-(NSData *)generateASingleTipWithLocalCartItemVO:(LocalCartItemVO *)aLocalTipVO{
    if(aLocalTipVO==nil){
        return nil;
    }
    if([aLocalTipVO.cnName rangeOfString:@"\r\n"].length!=0){
        aLocalTipVO.cnName=[aLocalTipVO.cnName stringByReplacingOccurrencesOfString:@"\r\n" withString:@" "];
    }
    NSString * dataStr=[NSString stringWithFormat:
                        @"%@\\\'%@\\\'%@\\\'%@\\\'%@\\\'%@\\\'%@\\\'%@\\\'%@\\\'%@\\\'%@\\\'%@\\\'%@\\\'\r\n",
                        aLocalTipVO.productId,aLocalTipVO.cnName,aLocalTipVO.price,aLocalTipVO.shoppingCount,
                        aLocalTipVO.miniDefaultProductUrl,aLocalTipVO.merchantId,aLocalTipVO.quantity,aLocalTipVO.promotionId,aLocalTipVO.promotionPrice,aLocalTipVO.hasGift, aLocalTipVO.mobileProductType,aLocalTipVO.hasCash,aLocalTipVO.hasRedemption];
    NSData * returnData=[NSData dataWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding]];
    return returnData;
}
#pragma mark 添加一条商品信息
-(void)appendToExistsFileWithFilePath:(NSString *)aFilePath item:(LocalCartItemVO *)aLocalTipVO{
    BOOL haveSameRecord = NO;
    NSMutableArray * productList = [self getLocalCartArrayWithFilePath:aFilePath];
    if(productList == nil){
        return;
    }
    NSMutableData * writer = [[NSMutableData alloc] initWithCapacity:0];
    for(LocalCartItemVO * localProductVO in productList) {
        if([localProductVO.productId isEqualToString:aLocalTipVO.productId]) {
            haveSameRecord = YES;
            int quantity = [localProductVO.quantity intValue] + [aLocalTipVO.quantity intValue];
            [localProductVO setQuantity:[NSString stringWithFormat:@"%d",quantity]];
        }
        [writer appendData:[self generateASingleTipWithLocalCartItemVO:localProductVO]];
    }
    if(!haveSameRecord){
        [writer appendData:[self generateASingleTipWithLocalCartItemVO:aLocalTipVO]];
    }
    [writer writeToFile:aFilePath atomically:NO];
    [self cleanLocalCartArray];
    [writer release];
}

#pragma mark 添加一条商品信息sqlite3
- (BOOL)saveLocalCartToSqlite3:(LocalCartItemVO *)aLocalTipVO;
{
    __block BOOL result = NO;
    if (!aLocalTipVO||[aLocalTipVO isKindOfClass:[NSNull class]]||aLocalTipVO.cnName.length==0) {
        return 0;
    }
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
    
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    NSString *update = @"INSERT OR REPLACE INTO localcart (productid,merchantid,cnname,minidefaultproducturl,price,quantity,shoppingcount,promotionid,promotionprice,hasgift,mobileproducttype,hascash,hasredemption,modified_time)VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    [queue inDatabase:^(FMDatabase *_db){
        result = [_db executeUpdate:update,
                  aLocalTipVO.productId,
                  aLocalTipVO.merchantId,
                  aLocalTipVO.cnName,
                  aLocalTipVO.miniDefaultProductUrl,
                  aLocalTipVO.price,
                  aLocalTipVO.quantity,
                  aLocalTipVO.shoppingCount,
                  aLocalTipVO.promotionId,
                  aLocalTipVO.promotionPrice,
                  aLocalTipVO.hasGift,
                  aLocalTipVO.mobileProductType,
                  aLocalTipVO.hasCash,
                  aLocalTipVO.hasRedemption,
                  dateString
                  ];
    }];
    return result;
}

#pragma mark 删除一条商品信息sqlite3
- (BOOL)deleteLocalCartByProductIdFromSqlite3:(NSNumber *)productId
{
    __block BOOL flag;
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    [queue inDatabase:^(FMDatabase *_db){
        NSString *sqlStr = @"delete from localcart where productid=?";
        flag = [_db executeUpdate:sqlStr,productId];
    }];
    return flag;
    
}

#pragma mark 清空本地购物车sqlite3
- (BOOL)cleanLocalCartFromSqlite3
{
    __block BOOL flag;
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    [queue inDatabase:^(FMDatabase *_db){
        NSString *sqlStr = @"delete from localcart";
        flag = [_db executeUpdate:sqlStr];
    }];
    return flag;
}

#pragma mark 获取本地所有商品总数sqlite3
-(int)getLocalCartNumberFromSqlite3
{
    __block int totalquantity=0;
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    NSString *query = @"select sum(quantity) from localcart";
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    [queue inDatabase:^(FMDatabase *_db){
        FMResultSet *rs = [_db executeQuery:query];
        while ([rs next])
        {
            totalquantity = [rs intForColumnIndex:0];
        }
    }];
    
    return totalquantity;
}

#pragma mark 获取本地所有商品总价sqlite3
-(float)getLocalCartTotalPriceFromSqlite3
{
    __block float totalprice=0.0;
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    NSString *query = @"select sum(price*quantity) from localcart";
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    [queue inDatabase:^(FMDatabase *_db){
        FMResultSet *rs = [_db executeQuery:query];
        while ([rs next])
        {
            //totalprice = [rs intForColumnIndex:0];
            totalprice = [rs doubleForColumnIndex:0];   // bug fixed. 本地购物车总价显示错误，丢失小数点后的位数
            
        }
    }];
    return totalprice;
}

#pragma mark 查询本地数据库是否有相同的productid,有则更新数量，没有则插入sqlite3
- (void)queryLocalCartByIdCountFromSqlite3:(LocalCartItemVO *)aLocalTipVO
{
    __block int rscount = 0;
    __block int rsquantity = 0;
    
    if (!aLocalTipVO||[aLocalTipVO isKindOfClass:[NSNull class]]||aLocalTipVO.cnName.length==0){
        return;
    }
    
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    NSString *query = @"select count(row),quantity from localcart where productid = ?";
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [queue inDatabase:^(FMDatabase *_db){
            FMResultSet *rs = [_db executeQuery:query,aLocalTipVO.productId];
            if ([rs next])
            {
                rscount = [rs intForColumnIndex:0];
                rsquantity = [rs intForColumnIndex:1];
            }
        }];
        
        int _quan = rsquantity==0?rscount:rsquantity;
        
        if(_quan)
        {
            int quantity = [aLocalTipVO.quantity intValue] + _quan;
            [aLocalTipVO setQuantity:[NSString stringWithFormat:@"%d",quantity]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self updateLocalCartItemToSqlite3:aLocalTipVO];
            });
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self saveLocalCartToSqlite3:aLocalTipVO];
            });
        }
        
    });
}

//#pragma mark 获取同步购物车得数据 sqlite3
- (NSMutableArray *) getLocalCartSynDateFromSqlite3
{
    __block NSMutableArray *arrayPD= [[NSMutableArray alloc]init];  //商品IDS
    __block NSMutableArray *arrayMC= [[NSMutableArray alloc]init];  //商家IDS
    __block NSMutableArray *arrayPO= [[NSMutableArray alloc]init];  //促销IDS
    __block NSMutableArray *arrayQT= [[NSMutableArray alloc]init];  //数量IDS
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    NSString *query = @"select productid,merchantid,promotionid,quantity from localcart";
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    [queue inDatabase:^(FMDatabase *_db){
        FMResultSet *rs = [_db executeQuery:query];
        while ([rs next])
        {
            int productid = [rs intForColumnIndex:0];
            int merchantid =[rs intForColumnIndex:1];
            NSString* promotionId = [rs stringForColumnIndex:2];
            int quantity = [rs intForColumnIndex:3];
            [arrayPD addObject:[NSNumber numberWithInt:productid]];
            [arrayMC addObject:[NSNumber numberWithInt:merchantid]];
            if(promotionId!=nil){
                [arrayPO addObject:promotionId];
            } else {
                [arrayPO addObject:@""];
            }
            [arrayQT addObject:[NSNumber numberWithInt:quantity]];
        }
    }];
    NSMutableArray *array1= [[NSMutableArray alloc]init];
    [array1 addObject:arrayPD];
    [array1 addObject:arrayMC];
    [array1 addObject:arrayPO];
    [array1 addObject:arrayQT];
    [arrayPD release];
    [arrayMC release];
    [arrayPO release];
    [arrayQT release];
    return [array1 autorelease];
}


#pragma mark 更新一条商品信息sqlite3
- (BOOL)updateLocalCartItemToSqlite3:(LocalCartItemVO *)aLocalTipVO
{
    __block BOOL flag;
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    if (!aLocalTipVO||[aLocalTipVO isKindOfClass:[NSNull class]]||aLocalTipVO.cnName.length==0 ) {
        return 0;
    }
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
    
    NSString *update = @"update localcart set modified_time=?,merchantid=?,cnname=?,minidefaultproducturl=?,price=?,quantity=?,shoppingcount=?,promotionid=?,promotionprice=?,hasgift=?,mobileproducttype=?,hascash=?,hasredemption=? where productid=?";
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    [queue inDatabase:^(FMDatabase *_db){
        flag = [_db executeUpdate:update,
                dateString,
                aLocalTipVO.merchantId,
                aLocalTipVO.cnName,
                aLocalTipVO.miniDefaultProductUrl,
                aLocalTipVO.price,
                aLocalTipVO.quantity,
                aLocalTipVO.shoppingCount,
                aLocalTipVO.promotionId,
                aLocalTipVO.promotionPrice,
                aLocalTipVO.hasGift,
                aLocalTipVO.mobileProductType,
                aLocalTipVO.hasCash,
                aLocalTipVO.hasRedemption,
                aLocalTipVO.productId
                ];
    }];
    return flag;
}

#pragma mark 切换省份后，剔除出本地购物车中接口不支持的商品sqlite3
- (void)changeLocalCartItemToSqlite3:(NSArray *)productVOList
{
    NSMutableArray *productIds = [[[NSMutableArray alloc] init] autorelease];
    for (int i =0; i < [productVOList count]; i++) {
        NSNumber* cur_pid =  ((ProductVO *)[productVOList objectAtIndex:i]).productId;
        [productIds addObject:[NSString stringWithFormat:@"%d",[cur_pid intValue]]];
    };
    NSString * NotIn = @"(";
    for (int i =0; i < [productIds count]; i++) {
        if (i< [productIds count] - 1) {
            NotIn = [NotIn stringByAppendingFormat:@"%@,", [productIds objectAtIndex:i]];
        }
        else
        {
            NotIn = [NotIn stringByAppendingFormat:@"%@)", [productIds objectAtIndex:i]];
        }
    }
    NSString *query = @"delete from localcart where productid not in ";
    query = [query stringByAppendingFormat:@"%@",NotIn];
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    [queue inDatabase:^(FMDatabase *_db){
        NSString *sqlStr = query;
        [_db executeUpdate:sqlStr];
    }];
}

#pragma mark 查询所有本地购物车sqlite3
- (NSMutableArray *)queryLocalCartFromSqlite3
{
    NSMutableArray *array1= [[NSMutableArray alloc]init];
    NSString *query = @"SELECT ROW, productid,merchantid,cnname,minidefaultproducturl,price,quantity,shoppingcount,promotionid,promotionprice,hasgift,mobileproducttype,hascash,hasredemption FROM localcart";
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    [queue inDatabase:^(FMDatabase *_db){
        FMResultSet *rs = [_db executeQuery:query];
        while ([rs next])
        {
            LocalCartItemVO *aLocalTipVO=[[LocalCartItemVO alloc]init];
            int      productid= [rs intForColumnIndex:1];
            int      merchantid = [rs intForColumnIndex:2];
            NSString *cnname= [rs stringForColumnIndex:3];
            NSString *minidefaultproducturl= [rs stringForColumnIndex:4];
            double   price = [rs doubleForColumnIndex:5];
            int      quantity = [rs intForColumnIndex:6];
            int      shoppingcount = [rs intForColumnIndex:7];
            NSString *promotionid = [rs stringForColumnIndex:8];
            double   promotionPrice= [rs doubleForColumnIndex:9];
            NSString *mobileproducttype = [rs stringForColumnIndex:10];
            int      hasGift = [rs intForColumnIndex:11];
            NSString *hascash = [rs stringForColumnIndex:12];
            NSString *hasredemption = [rs stringForColumnIndex:13];
            
            aLocalTipVO.productId= [NSString stringWithFormat:@"%d",productid];
            aLocalTipVO.merchantId = [NSString stringWithFormat:@"%d",merchantid];
            aLocalTipVO.cnName = cnname;
            aLocalTipVO.miniDefaultProductUrl = minidefaultproducturl;
            aLocalTipVO.price = [NSString stringWithFormat:@"%f",price];
            aLocalTipVO.quantity = [NSString stringWithFormat:@"%d",quantity];
            aLocalTipVO.shoppingCount = [NSString stringWithFormat:@"%d",shoppingcount];
            aLocalTipVO.promotionId = promotionid;
            aLocalTipVO.promotionPrice = [NSString stringWithFormat:@"%f",promotionPrice];
            aLocalTipVO.mobileProductType = mobileproducttype;
            aLocalTipVO.hasGift = [NSString stringWithFormat:@"%d",hasGift];
            aLocalTipVO.hasCash = hascash;
            aLocalTipVO.hasRedemption = hasredemption;
            
            [array1 addObject:aLocalTipVO];
            [aLocalTipVO release];
        }
    }];
    return [array1 autorelease];
}

#pragma mark 获取一条商品信息sqlite3
- (LocalCartItemVO *)queryLocalCartItemByIdFromSqlite3:(NSNumber *)productId
{
    LocalCartItemVO *aLocalTipVO=[[LocalCartItemVO alloc]init];
    NSString *query = @"SELECT ROW, productid,merchantid,cnname,minidefaultproducturl,price,quantity,shoppingcount,promotionid,promotionprice,hasgift,mobileproducttype,hascash,hasredemption FROM localcart where productid=?";
    Sqlite3Handle *_handle = [Sqlite3Handle sharedInstance];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_handle.dbPath];
    [queue inDatabase:^(FMDatabase *_db){
        FMResultSet *rs = [_db executeQuery:query,productId];
        if ([rs next])
        {
            int      productid= [rs intForColumnIndex:1];
            int      merchantid = [rs intForColumnIndex:2];
            NSString *cnname= [rs stringForColumnIndex:3];
            NSString *minidefaultproducturl= [rs stringForColumnIndex:4];
            double   price = [rs doubleForColumnIndex:5];
            int      quantity = [rs intForColumnIndex:6];
            int      shoppingcount = [rs intForColumnIndex:7];
            NSString *promotionid = [rs stringForColumnIndex:8];
            double   promotionPrice= [rs doubleForColumnIndex:9];
            NSString *mobileproducttype = [rs stringForColumnIndex:10];
            int      hasGift = [rs intForColumnIndex:11];
            NSString *hascash = [rs stringForColumnIndex:12];
            NSString *hasredemption = [rs stringForColumnIndex:13];
            
            aLocalTipVO.productId= [NSString stringWithFormat:@"%d",productid];
            aLocalTipVO.merchantId = [NSString stringWithFormat:@"%d",merchantid];
            aLocalTipVO.cnName = cnname;
            aLocalTipVO.miniDefaultProductUrl = minidefaultproducturl;
            aLocalTipVO.price = [NSString stringWithFormat:@"%f",price];
            aLocalTipVO.quantity = [NSString stringWithFormat:@"%d",quantity];
            aLocalTipVO.shoppingCount = [NSString stringWithFormat:@"%d",shoppingcount];
            aLocalTipVO.promotionId = promotionid;
            aLocalTipVO.promotionPrice = [NSString stringWithFormat:@"%f",promotionPrice];
            aLocalTipVO.mobileProductType = mobileproducttype;
            aLocalTipVO.hasGift = [NSString stringWithFormat:@"%d",hasGift];
            aLocalTipVO.hasCash = hascash;
            aLocalTipVO.hasRedemption = hasredemption;
        }
    }];
    
    return [aLocalTipVO autorelease];
}


#pragma mark 清空本地购物车
-(void)cleanLocalCartWithFilePath:(NSString *)aFilePath {
    if(aFilePath == nil){
        return;
    }
    NSString * dataStr = @"";
    NSData * returnData = [NSData dataWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding]];
    [returnData writeToFile:aFilePath atomically:NO];
    if ([SharedDelegate respondsToSelector:@selector(clearCartNum)]) {
        [SharedDelegate performSelector:@selector(clearCartNum) withObject:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChanged" object:nil];
    
    
}
#pragma mark 获得本地所有商品总数
-(int)getLocalCartNumberWithFilePath:(NSString *)aFilePath {
    int result=0;
    NSMutableArray * productList = [self getLocalCartArrayWithFilePath:aFilePath];
    if(productList == nil){
        return 0;
    }
    for(LocalCartItemVO * localProductVO in productList) {
        result += [localProductVO.quantity intValue];
    }
    [self cleanLocalCartArray];
    return result;
}
#pragma mark 获取本地所有商品总价
-(float)getLocalCartTotalPriceWithFilePath:(NSString *)aFilePath {
    float result = 0.0f;
    NSMutableArray * productList = [self getLocalCartArrayWithFilePath:aFilePath];
    if(productList == nil){
        return result;
    }
    for(LocalCartItemVO * localProductVO in productList)
    {
        if(localProductVO.promotionId==nil || [localProductVO.promotionId isEqualToString:@""]){
            result += [localProductVO.price floatValue] * [localProductVO.quantity floatValue];
        } else {
            result += [localProductVO.promotionPrice floatValue] * [ localProductVO.quantity floatValue];
        }
    }
    [self cleanLocalCartArray];
    return result;
}
#pragma mark 删除一条商品信息
-(void)deleteLocalCartWithFilePath:(NSString *)aFilePath item:(LocalCartItemVO *)aLocalTipVO {
    NSMutableArray * productList = [self getLocalCartArrayWithFilePath:aFilePath];
    if(productList == nil){
        return;
    }
    NSMutableData * writer = [[NSMutableData alloc] initWithCapacity:0];
    for(LocalCartItemVO * localProductVO in productList){
        if(![localProductVO.productId isEqualToString:aLocalTipVO.productId]){
            [writer appendData:[self generateASingleTipWithLocalCartItemVO:localProductVO]];
        }
    }
    [writer writeToFile:aFilePath atomically:NO];
    [self cleanLocalCartArray];
    [writer release];
}

-(void)deleteLocalCartWithFilePath:(NSString *)aFilePath productId:(NSNumber *)productId {
    NSMutableArray * productList = [self getLocalCartArrayWithFilePath:aFilePath];
    if(productList == nil){
        return;
    }
    NSString *prductIdStr=[NSString stringWithFormat:@"%@",productId];
    NSMutableData * writer = [[NSMutableData alloc] initWithCapacity:0];
    for(LocalCartItemVO * localProductVO in productList){
        if(![localProductVO.productId isEqualToString:prductIdStr]){
            [writer appendData:[self generateASingleTipWithLocalCartItemVO:localProductVO]];
        }
    }
    [writer writeToFile:aFilePath atomically:NO];
    [self cleanLocalCartArray];
    [writer release];
}

#pragma mark 更新一条商品信息
-(void)updateLocalCartWithFilePath:(NSString *)aFilePath item:(LocalCartItemVO *)aLocalTipVO{
    NSMutableArray * lVOArray=[self getLocalCartArrayWithFilePath:aFilePath];
    if(lVOArray==nil){
        return;
    }
    NSMutableData * writer=[[NSMutableData alloc] initWithCapacity:0];
    for(LocalCartItemVO * localVO in lVOArray){
        if([localVO.productId isEqualToString:aLocalTipVO.productId]){
            [writer appendData:[self generateASingleTipWithLocalCartItemVO:aLocalTipVO]];
        }
		else{
			[writer appendData:[self generateASingleTipWithLocalCartItemVO:localVO]];
		}
    }
    [writer writeToFile:aFilePath atomically:NO];
    [self cleanLocalCartArray];
    [writer release];
}

-(NSMutableArray *)getLocalCartProductIdsWithFilePath:(NSString *)aFilePath
{
    NSMutableArray *productList=[self getLocalCartArrayWithFilePath:aFilePath];
    NSMutableArray *productIds=[[[NSMutableArray alloc] init] autorelease];
    for (LocalCartItemVO *localProductVO in productList) {
        [productIds addObject:localProductVO.productId];
    }
    return productIds;
}

-(NSMutableArray *)getLocalCartMerchantIdsWithFilePath:(NSString *)aFilePath
{
    NSMutableArray *productList=[self getLocalCartArrayWithFilePath:aFilePath];
    NSMutableArray *merchantIds=[[[NSMutableArray alloc] init] autorelease];
    for (LocalCartItemVO *localProductVO in productList) {
        [merchantIds addObject:localProductVO.merchantId];
    }
    return merchantIds;
}

-(void)changeLocalCartWithFilePath:(NSString *)aFilePath productVOList:(NSArray *)productVOList
{
    NSMutableArray *localProductVOList=[self getLocalCartArrayWithFilePath:aFilePath];
    NSMutableData *writer=[[NSMutableData alloc] initWithCapacity:0];
    for (LocalCartItemVO *localProductVO in localProductVOList) {
        for (ProductVO *productVO in productVOList) {
            if ([localProductVO.productId intValue]==[productVO.productId intValue]) {
                [writer appendData:[self generateASingleTipWithLocalCartItemVO:localProductVO]];
                break;
            }
        }
    }
    [writer writeToFile:aFilePath atomically:NO];
    [self cleanLocalCartArray];
    [writer release];
}

@end
