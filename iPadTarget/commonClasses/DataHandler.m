//
//  DataHandler.m
//  JyPay
//
//  Created by mxy on 11-10-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DataHandler.h"
#import "Page.h"

#import "ASIHTTPRequest.h"

#import "UIDevice+IdentifierAddition.h"
#import "NSObject+OTS.h"
#import "OTSServiceHelper.h"

#import "SynthesizeSingleton.h"
#import "ProvinceVO.h"
#import "CartVO.h"
#import "ProductVO.h"
#import "CartItemVO.h"
#import "CartVO+ProductCart.h"
#import "ErrorStrings.h"
#import "Reachability.h"
#import <CommonCrypto/CommonDigest.h>
#import "OtsErrorHandler.h"
#import "AddProductResult.h"
#import "GlobalValue.h"
#import "UpdateCartResult.h"
#import "OTSGpsHelper.h"

#define BOUNDRY @"0xKhTmLbOuNdArY"



@implementation DataHandler
@synthesize userDic,screenWidth,cateDic,provinceArray,cart,filterDic,categories,keyWord;
//SYNTHESIZE_SINGLETON_FOR_CLASS(DataHandler);


- init
{
    if ((self = [super init]))
    {
        screenWidth = 1024;
        self.cateDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"", @"cate1",@"", @"cate2",nil];
        self.filterDic=[NSMutableDictionary dictionaryWithCapacity:1];
        
        self.cart=[[[CartVO alloc]init]autorelease];
        self.cart.buyItemList=[NSMutableArray arrayWithCapacity:1];
        
        self.categories=[NSMutableArray arrayWithCapacity:1];
        
        sqlite3_stmt *statement;
        
        //sql存在否
        if (sqlite3_open([[self dataFilePath:kDataFilename] UTF8String], &database)
            != SQLITE_OK) {
            sqlite3_close(database);
            NSAssert(0, @"Failed to open database");
        }else {//存在
            NSString *query = @"SELECT ROW, productid,cnname,midlepicurl,minipicurl,price,canbuy,merchantId,provinceId,promotionPrice,promotionId FROM history  order by time desc";
            //查询语句能否成功
            if (sqlite3_prepare_v2( database, [query UTF8String],
                                   -1, &statement, nil) != SQLITE_OK){
                //不成功就移出老的sql，新建一个sql
                [[NSFileManager defaultManager] removeItemAtPath:[self dataFilePath:kDataFilename] error:nil];
                if (sqlite3_open([[self dataFilePath:kDataFilename] UTF8String], &database)
                    != SQLITE_OK) {
                    sqlite3_close(database);
                    NSAssert(0, @"Failed to open database");
                }
            }
        }
        
        char *errorMsg;
        
        NSString *createSQL = @"CREATE TABLE IF NOT EXISTS history (ROW INTEGER PRIMARY KEY autoincrement, productid INTEGER,cnname TEXT,midlepicurl TEXT,minipicurl TEXT,price TEXT,canbuy TEXT,merchantId,time text,provinceId INTEGER,promotionPrice TEXT,promotionId TEXT);";//添加省份ID ,provinceId INTEGER
        if (sqlite3_exec (database, [createSQL  UTF8String],
                          NULL, NULL, &errorMsg) != SQLITE_OK) {
            
            sqlite3_close(database);
            NSAssert1(0, @"Error creating table: %s", errorMsg);
        }
        
        NSString *createSQL2 = @"CREATE TABLE IF NOT EXISTS searchHistory (ROW INTEGER PRIMARY KEY autoincrement, name TEXT,time text);";
        if (sqlite3_exec (database, [createSQL2  UTF8String],
                          NULL, NULL, &errorMsg) != SQLITE_OK) {
            
            sqlite3_close(database);
            NSAssert1(0, @"Error creating table: %s", errorMsg);
        }
    }
    return self;
}
#pragma mark - 


- (NSString *)dataFilePath:(NSString *)fileName{
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths1 objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}
#pragma mark - // 检查网络状态
-(NSString *)checkNetWorkType {
    // 检查网络状态
	NSString *netType = nil;
	Reachability *r = [Reachability reachabilityWithHostName:@"interface.m.yihaodian.com"];
    switch ([r currentReachabilityStatus]) {
		case NotReachable:
			// 没有网络连接
			netType = @"no";
			break;
		case ReachableViaWWAN:
			// 使用3G网络
			netType = @"3G";
			break;
		case ReachableViaWiFi:
			// 使用WiFi网络
			netType = @"WiFi";
			break;
    }
	//NSLog(@"netType:%@",netType);
    return netType;
}
- (void)saveProvice
{
    [[OTSGpsHelper sharedInstance] saveProvince];
}

- (void)addProductToCart:(ProductVO*)product buyCount:(NSInteger)buyCount
{
    NSLog(@"%@, %@", product.totalQuantityLimit, product.promotionId);
    
    CartItemVO *cartItem = [self.cart containsProduct:product];
    // 如果购物车存在该商品，调用 update接口更新数量，效率比调用addproduct高一点点点点点
    if (cartItem)
    {
        cartItem.buyQuantityCopy = cartItem.buyQuantity;
        cartItem.buyQuantity = [NSNumber numberWithInt:[cartItem.buyQuantity intValue] + buyCount];
        
        if ([GlobalValue getGlobalValueInstance].token)
        {
            [self otsDetatchMemorySafeNewThreadSelector:@selector(addProductQuantity:) toTarget:self withObject:cartItem];
        }
        else
        {
            {
                NSInteger index = [self.cart.buyItemList indexOfObject:cartItem];
                [self.cart.buyItemList exchangeObjectAtIndex:0 withObjectAtIndex:index];
                self.cart.totalquantity=[NSNumber numberWithInt:[self.cart.totalquantity intValue]+buyCount];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartChange object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartReload object:nil];
            } 
        }
    }
    else
    {
        CartItemVO *cartItem=[[[CartItemVO alloc]init]autorelease];
        cartItem.product=product;
        cartItem.updateType=[NSNumber numberWithInt:0];
        cartItem.buyQuantity=[NSNumber numberWithInt:buyCount];
        
        if ([GlobalValue getGlobalValueInstance].token)
        {
            [self otsDetatchMemorySafeNewThreadSelector:@selector(addProduct:) toTarget:self withObject:cartItem];
        }
        else
        {
            {
                if (cart.buyItemList == nil)
                {
                    if (cart == nil)
                    {
                        self.cart = [[[CartVO alloc] init] autorelease];
                    }
                    
                    self.cart.buyItemList = [NSMutableArray arrayWithCapacity:buyCount];
                }
                
                [self.cart.buyItemList insertObject:cartItem atIndex:0];
                self.cart.totalquantity=[NSNumber numberWithInt:[self.cart.totalquantity intValue]+buyCount];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartChange object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartReload object:nil];
            }
        }
        
    }
}


- (void)updateProductQuantityToCart:(CartItemVO *)cartItem
{
    if ([GlobalValue getGlobalValueInstance].token)
    {
        [self otsDetatchMemorySafeNewThreadSelector:@selector(addProductQuantity:) toTarget:self withObject:cartItem];
    }
}


-(void)addProduct:(CartItemVO *)cartItem
{
    
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
//    AddProductResult *result = [[OTSServiceHelper sharedInstance] addProductV2:[GlobalValue getGlobalValueInstance].token
//                                                                     productId:cartItem.product.productId
//                                                                    merchantId:cartItem.product.merchantId
//                                                                      quantity:cartItem.buyQuantity
//                                                                   promotionid:cartItem.product.promotionId];
    AddProductResult *result = [[OTSServiceHelper sharedInstance] addSingleProduct:[GlobalValue getGlobalValueInstance].token productId:cartItem.product.productId merchantId:cartItem.product.merchantId quantity:cartItem.buyQuantity promotionid:cartItem.product.promotionId];
    
    if (result)
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:cartItem, @"cartItem", result ,@"result", nil];
        [self performSelectorOnMainThread:@selector(handleAddProduct:) withObject:dic waitUntilDone:YES];
    }
    else
    {
        [[OtsErrorHandler sharedInstance] alertNilObject];
    }
    
    [pool drain];
    
}
-(void)addProductQuantity:(CartItemVO *)cartItem
{
    NSAssert(cartItem, @"cart item is nil");
    NSString *promotionId = cartItem.product.realPromotionID;
    
//    UpdateCartResult *updateCartResult = [[OTSServiceHelper sharedInstance] updateCartItemQuantityV2:[GlobalValue getGlobalValueInstance].token
//                                                                                           productId:cartItem.product.productId
//                                                                                          merchantId:cartItem.product.merchantId
//                                                                                            quantity:cartItem.buyQuantity
//                                                                                          updateType:cartItem.updateType
//                                                                                         promotionId:promotionId];
    UpdateCartResult* updateCartResult;
    // 区分是否促销商品更新数量
    if (promotionId && ![promotionId isEqualToString:@""]) {
        updateCartResult = [[OTSServiceHelper sharedInstance]updateLandingpageProductQuantity:[GlobalValue getGlobalValueInstance].token productId:cartItem.product.productId merchantId:cartItem.product.merchantId quantity:cartItem.buyQuantity promotionId:promotionId];
    }else{
        updateCartResult = [[OTSServiceHelper sharedInstance]updateNormalProductQuantity:[GlobalValue getGlobalValueInstance].token productId:cartItem.product.productId merchantId:cartItem.product.merchantId quantity:cartItem.buyQuantity];
    }
    [self performSelectorOnMainThread:@selector(handleAddProductQuantity:) withObject:updateCartResult waitUntilDone:YES];
    
//    updateCartResult = updateCartResult ? updateCartResult : (UpdateCartResult*)[NSNull null];
//    [[NSNotificationCenter defaultCenter] postNotificationName:PAD_NOTIFY_ADD_PRODUCT_RESULT object:[NSArray arrayWithObjects:updateCartResult, cartItem, nil]];
}


//加入购物车，购物车中没有
-(void)handleAddProduct:(NSDictionary *)resultDic
{
    AddProductResult *result = [resultDic objectForKey:@"result"];
    if ([result isSuccess])
    {
        [self otsDetatchMemorySafeNewThreadSelector:@selector(getSessionCart) toTarget:self withObject:nil];
    }
    else
    {
        [[OtsErrorHandler sharedInstance] alert:result.errorInfo];
    }
}

-(void)showInfo:(NSString *)info
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:info delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}


//添加数量 ，购车中已存在
-(void)handleAddProductQuantity:(UpdateCartResult *)updateCartResult
{
    if (updateCartResult==nil || [updateCartResult isKindOfClass:[NSNull class]])
    {
        [[OtsErrorHandler sharedInstance] alertNilObject];
    }
    else
    {
        // 更新数量成功后刷新购物车，虽然觉得这样做很慢，但是侧栏要刷新数据。木有办法对不对，除非扩充缓存支持增加数量等，但是木有时间了啊啊啊。
        // 由于内存cart被破坏
        if ([[updateCartResult resultCode] intValue] !=1)
        {
            [[OtsErrorHandler sharedInstance] alert:[updateCartResult errorInfo]];
        }
        
        [self otsDetatchMemorySafeNewThreadSelector:@selector(getSessionCart) toTarget:self withObject:nil];
    }
}

- (void)delProductFromCart:(CartItemVO *)cartItem{
    
    if ([GlobalValue getGlobalValueInstance].token) {
        [self otsDetatchMemorySafeNewThreadSelector:@selector(delProduct:) toTarget:self withObject:cartItem];
    }
}

-(void)resetCart
{
    DataHandler *singleton = [DataHandler sharedDataHandler];
    [singleton.cart.buyItemList  removeAllObjects];
    [singleton.cart.gifItemtList removeAllObjects];
    [singleton.cart.redemptionItemList removeAllObjects];
    singleton.cart.totalprice = [NSNumber numberWithInt:0];
    singleton.cart.totalquantity = [NSNumber numberWithInt:0];
    singleton.cart.totalsavedprice = [NSNumber numberWithInt:0];
    singleton.cart.totalWeight = [NSNumber numberWithInt:0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartChange object:nil];
}

-(void)getSessionCart
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    CartVO *cartVO = [[OTSServiceHelper sharedInstance] getSessionCart:[GlobalValue getGlobalValueInstance].token];
    
    [self performSelectorOnMainThread:@selector(handleCart:) withObject:cartVO waitUntilDone:YES];
    
    
    [pool drain];
    
}

-(void)handleCart:(CartVO *)cartVO{
    if (cartVO) {
        self.cart= cartVO;
        if (cart.buyItemList&&cart.buyItemList.count>1) {
            NSInteger index=self.cart.buyItemList.count-1;
            [self.cart.buyItemList exchangeObjectAtIndex:0 withObjectAtIndex:index];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartChange object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartCacheChange object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartReload object:nil];
    }
    
}

-(void)delProduct:(CartItemVO *)cartItem
{
    //--------------删除promotion商品---------------------------
    if (!cartItem.product.promotionId) {
        cartItem.product.promotionId = @"";
    }
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
//    [[OTSServiceHelper sharedInstance] delProduct:[GlobalValue getGlobalValueInstance].token productId:cartItem.product.productId merchantId:cartItem.product.merchantId updateType:cartItem.updateType promotionid:cartItem.product.promotionId];
    int result = [[OTSServiceHelper sharedInstance]deleteSingleProduct:[GlobalValue getGlobalValueInstance].token productId:cartItem.product.productId merchantId:cartItem.product.merchantId promotionid:cartItem.product.promotionId];
    
    [self performSelectorOnMainThread:@selector(handleDelProductResult:) withObject:[NSNumber numberWithInt:result] waitUntilDone:YES];
    [pool drain];
}
-(void)handleDelProductResult:(NSNumber*)result{
    if ([result intValue] == 1)
    {
        [self otsDetatchMemorySafeNewThreadSelector:@selector(getSessionCart) toTarget:self withObject:nil];
    }
    else
    {
        [[OtsErrorHandler sharedInstance] alert:@"删除失败"];
    }
}
//static NSArray *bankVOArray=nil;
//获取支付列表
- (NSArray*)paymentBankList{
    NSLog(@"%@",[GlobalValue getGlobalValueInstance].trader);
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    Page* page = [service getBankVOList:[GlobalValue getGlobalValueInstance].trader
                                   name:@"" type:[NSNumber numberWithInt:-1]
                            currentPage:[NSNumber numberWithInt:1]
                               pageSize:[NSNumber numberWithInt:20]];
    NSArray* temp = page.objList;
    NSLog(@"%@",page);
    return temp;
}

#pragma mark - 本地购物车
-(void)localCartProduct:(ProductVO *)product addCount:(int)count
{
    CartItemVO *cartItem=[self.cart containsProduct:product];
    int oldCount=[cartItem.buyQuantity intValue];
    if (cartItem!=nil) {
        cartItem.buyQuantity=[NSNumber numberWithInt:oldCount+count];
    } else {
        CartItemVO *cartItem=[[[CartItemVO alloc]init]autorelease];
        cartItem.product=product;
        cartItem.updateType=[NSNumber numberWithInt:0];
        cartItem.buyQuantity=[NSNumber numberWithInt:count];
        
        if (cart.buyItemList==nil) {
            if (cart==nil) {
                self.cart=[[[CartVO alloc] init] autorelease];
            }
            self.cart.buyItemList=[NSMutableArray arrayWithCapacity:count];
        }
        
        [self.cart.buyItemList addObject:cartItem];
    }
    self.cart.totalquantity=[NSNumber numberWithInt:[self.cart.totalquantity intValue]+count];
    if ([product.promotionPrice doubleValue]>0.0001) {
        self.cart.totalprice=[NSNumber numberWithDouble:[self.cart.totalprice doubleValue]+[product.promotionPrice doubleValue]*count];
    } else {
        self.cart.totalprice=[NSNumber numberWithDouble:[self.cart.totalprice doubleValue]+[product.price doubleValue]*count];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartChange object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartReload object:nil];
}

-(void)localCartProduct:(ProductVO *)product setCount:(int)count
{
    CartItemVO *cartItem=[self.cart containsProduct:product];
    int oldCount=[cartItem.buyQuantity intValue];
    if (cartItem!=nil) {
        cartItem.buyQuantity=[NSNumber numberWithInt:count];
    } else {
        CartItemVO *cartItem=[[[CartItemVO alloc]init]autorelease];
        cartItem.product=product;
        cartItem.updateType=[NSNumber numberWithInt:0];
        cartItem.buyQuantity=[NSNumber numberWithInt:count];
        
        if (cart.buyItemList==nil) {
            if (cart==nil) {
                self.cart=[[[CartVO alloc] init] autorelease];
            }
            self.cart.buyItemList=[NSMutableArray arrayWithCapacity:count];
        }
        
        [self.cart.buyItemList addObject:cartItem];
    }
    
    self.cart.totalquantity=[NSNumber numberWithInt:[self.cart.totalquantity intValue]+count-oldCount];
    if ([product.promotionPrice doubleValue]>0.0001) {
        self.cart.totalprice=[NSNumber numberWithDouble:[self.cart.totalprice doubleValue]+[product.promotionPrice doubleValue]*(count-oldCount)];
    } else {
        self.cart.totalprice=[NSNumber numberWithDouble:[self.cart.totalprice doubleValue]+[product.price doubleValue]*(count-oldCount)];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartChange object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartReload object:nil];
}

-(void)deleteLocalCartItem:(CartItemVO *)cartItemVO
{
    CartItemVO *cartItem=[self.cart containsProduct:cartItemVO.product];
    if (cartItem!=nil) {
        NSInteger index=[self.cart.buyItemList indexOfObject:cartItem];
        [self.cart.buyItemList removeObjectAtIndex:index];
    }
    self.cart.totalquantity=[NSNumber numberWithInt:[self.cart.totalquantity intValue]-[cartItem.buyQuantity intValue]];
    if ([cartItemVO.product.promotionPrice doubleValue]>0.0001) {
        self.cart.totalprice=[NSNumber numberWithDouble:[self.cart.totalprice doubleValue]-[cartItemVO.product.promotionPrice doubleValue]*[cartItem.buyQuantity intValue]];
    } else {
        self.cart.totalprice=[NSNumber numberWithDouble:[self.cart.totalprice doubleValue]-[cartItemVO.product.price doubleValue]*[cartItem.buyQuantity intValue]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartChange object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartReload object:nil];
}

-(void)clearLocalCart
{
    self.cart.buyItemList=nil;
    self.cart.totalquantity=[NSNumber numberWithInt:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartChange object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartReload object:nil];
}

#pragma mark - sqlite3
//添加区域Id
- (void)saveProductHistory:(ProductVO *)product {
    
	//char *errorMsg;
	char *update = "INSERT OR REPLACE INTO history ( productid,cnname,midlepicurl,minipicurl,price ,canbuy,merchantId,time,provinceId,promotionPrice,promotionId)VALUES (?,?,?,?,?,?,?,?,?,?,?);";
    
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK) {
		//sqlite3_bind_int(stmt, 1, 1);
		sqlite3_bind_int(stmt, 1, [product.productId intValue]);
		sqlite3_bind_text(stmt, 2, [product.cnName==nil?@"":product.cnName UTF8String] , -1, NULL);
        sqlite3_bind_text(stmt, 3, [product.midleDefaultProductUrl==nil?@"":product.midleDefaultProductUrl UTF8String] , -1, NULL);
        sqlite3_bind_text(stmt, 4, [product.miniDefaultProductUrl==nil?@"":product.miniDefaultProductUrl UTF8String] , -1, NULL);
        sqlite3_bind_text(stmt,5,[[NSString stringWithFormat:@"%f",[product.price floatValue] ]  UTF8String] , -1, NULL); 
        sqlite3_bind_text(stmt, 6, [product.canBuy==nil?@"":product.canBuy UTF8String] , -1, NULL);
		sqlite3_bind_int(stmt, 7, [product.merchantId intValue]);
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
        [dateFormat release];
        sqlite3_bind_text(stmt, 8, [dateString UTF8String] , -1, NULL);
        sqlite3_bind_int(stmt, 9, [[OTSGpsHelper sharedInstance].provinceVO.nid intValue]);
        sqlite3_bind_text(stmt, 10, [[NSString stringWithFormat:@"%@",product.promotionPrice] UTF8String], -1, NULL);
        NSString *promotionId = product.realPromotionID;
        
        sqlite3_bind_text(stmt, 11, [[NSString stringWithFormat:@"%@",promotionId] UTF8String],-1,NULL);
	}
	if (sqlite3_step(stmt) != SQLITE_DONE)
        //	NSAssert1(0, @"Error updating table: %s", errorMsg);
        sqlite3_finalize(stmt);
	
}

- (void)saveProductHistory2:(NSNumber *)productid cnname:(NSString *)cnname midlepicurl:(NSString *)midlepicurl minipicurl:(NSString *)minipicurl price:(NSNumber *)price canbuy:(NSString *)canbuy{
    char *update = "INSERT OR REPLACE INTO history ( productid,cnname,midlepicurl,minipicurl,price ,canbuy,)VALUES (?,?,?,?,?,?);";
    
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK) {
		
		sqlite3_bind_int(stmt, 1, [productid intValue]);
		sqlite3_bind_text(stmt, 2, [cnname==nil?@"":cnname UTF8String] , -1, NULL);
        sqlite3_bind_text(stmt, 3, [midlepicurl==nil?@"":midlepicurl UTF8String] , -1, NULL);
        sqlite3_bind_text(stmt, 4, [minipicurl==nil?@"":minipicurl UTF8String] , -1, NULL);
        sqlite3_bind_double(stmt,5, [price doubleValue]);
        sqlite3_bind_text(stmt, 6, [canbuy==nil?@"":canbuy UTF8String] , -1, NULL);
		
        
	}
	if (sqlite3_step(stmt) != SQLITE_DONE)
        //	NSAssert1(0, @"Error updating table: %s", errorMsg);
        sqlite3_finalize(stmt);
	
}



- (NSMutableArray *)queryProductHistory{
    NSMutableArray *array=[NSMutableArray arrayWithCapacity:2]; 
    NSString *query = [NSString stringWithFormat:@"SELECT ROW, productid,cnname,midlepicurl,minipicurl,price,canbuy,merchantId,promotionPrice,promotionId FROM history WHERE provinceId = %d order by time desc",[[OTSGpsHelper sharedInstance].provinceVO.nid intValue]];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2( database, [query UTF8String],
                           -1, &statement, nil) == SQLITE_OK) {
		//sqlite3_bind_text(statement, 1, [bookid UTF8String] , -1, NULL);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            ProductVO *product=[[ProductVO alloc]init]; 
            //int row = sqlite3_column_int(statement, 0);
            int productid= sqlite3_column_int(statement, 1);
            char *cnname= (char *)sqlite3_column_text(statement, 2);
            char *midlepicurl= (char *)sqlite3_column_text(statement, 3);
            char *minipicurl= (char *)sqlite3_column_text(statement, 4);
            char *price= (char *)sqlite3_column_text(statement, 5);
            char *canbuy= (char *)sqlite3_column_text(statement, 6);
            int merchantId= sqlite3_column_int(statement, 7);
            char *promotionPrice= (char *)sqlite3_column_text(statement, 8);
            char *promotionId=(char *)sqlite3_column_text(statement, 9);
            product.productId=[NSNumber numberWithInt:productid];
            if (cnname == NULL) {
                product.cnName=@"";
            } else {
                product.cnName=[NSString stringWithUTF8String:cnname];
            }
            product.midleDefaultProductUrl=[NSString stringWithUTF8String:midlepicurl];
            product.miniDefaultProductUrl=[NSString stringWithUTF8String:minipicurl];
            product.price=[NSNumber numberWithFloat:[[NSString stringWithUTF8String:price] floatValue]];
            product.canBuy=[NSString stringWithUTF8String:canbuy ];
            product.merchantId=[NSNumber numberWithInt:merchantId];
            product.promotionPrice=[NSNumber numberWithFloat:[[NSString stringWithUTF8String:promotionPrice] floatValue]];
            product.promotionId=[NSString stringWithUTF8String:promotionId];
            [array addObject:product];
            [product release];
        }
        sqlite3_finalize(statement);
		
    } 
    
	return array;
}


- (ProductVO *)queryProductHistoryById:(NSNumber *)productId{
    ProductVO *product=nil;
    NSString *query = [NSString stringWithFormat:@"SELECT ROW, productid,cnname,midlepicurl,minipicurl,price,canbuy,merchantId,promotionPrice,promotionPrice,promotionId FROM history where productid=? and provinceId=%@",[OTSGpsHelper sharedInstance].provinceVO.nid];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2( database, [query UTF8String],
                           -1, &statement, nil) == SQLITE_OK) {
		sqlite3_bind_int(statement, 1, [productId intValue]);
        if (sqlite3_step(statement) == SQLITE_ROW) {
            product=[[ProductVO alloc]init]; 
            //int row = sqlite3_column_int(statement, 0);
            int productid= sqlite3_column_int(statement, 1);
            char *cnname= (char *)sqlite3_column_text(statement, 2);
            char *midlepicurl= (char *)sqlite3_column_text(statement, 3);
            char *minipicurl= (char *)sqlite3_column_text(statement, 4);
            char *price= (char *)sqlite3_column_text(statement, 5);
            char *canbuy= (char *)sqlite3_column_text(statement, 6);
            int merchantId= sqlite3_column_int(statement, 7);
            char *promotionPrice=(char*)sqlite3_column_text(statement, 8);
            char *promotionId=(char*)sqlite3_column_text(statement, 9);
            //char *time= (char *)sqlite3_column_text(statement, 8);
            product.productId=[NSNumber numberWithInt:productid];
            if (cnname == NULL) {
                product.cnName = @"";
            } else {
                product.cnName=[NSString stringWithUTF8String:cnname];
            }
            product.midleDefaultProductUrl=[NSString stringWithUTF8String:midlepicurl];
            product.miniDefaultProductUrl=[NSString stringWithUTF8String:minipicurl];
            product.price=[NSNumber numberWithFloat:[[NSString stringWithUTF8String:price] floatValue]];
            product.canBuy=[NSString stringWithUTF8String:canbuy ];
            product.merchantId=[NSNumber numberWithInt:merchantId];
            product.promotionPrice=[NSNumber numberWithFloat:[[NSString stringWithString:[NSString stringWithUTF8String:promotionPrice]] floatValue]];
            product.promotionId=[NSString stringWithUTF8String:promotionId];
        }
        sqlite3_finalize(statement);
		
    } 
    
	return [product autorelease];
}


- (void)updateTimeHistory:(NSNumber *)productId{
    
	//char *errorMsg;
	NSString *update =[NSString stringWithFormat:@"update history set time=? where productid=? and provinceId=%@;",[OTSGpsHelper sharedInstance].provinceVO.nid] ;
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2(database, [update UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
        sqlite3_bind_text(stmt, 1, [dateString UTF8String] , -1, NULL);
		sqlite3_bind_int(stmt, 2, [productId intValue] );
        [dateFormat release];
	}
	if (sqlite3_step(stmt) != SQLITE_DONE)
		//NSAssert1(0, @"Error updating table: %s", errorMsg);
        sqlite3_finalize(stmt);
	
}

- (void)updateHistory:(ProductVO *)product{
    
	//char *errorMsg;
	NSString *update =[NSString stringWithFormat:@"update history set time=? ,price=? , canbuy=? ,promotionPrice=? where productid=? and provinceId=%@;",[OTSGpsHelper sharedInstance].provinceVO.nid] ;
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2(database, [update UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
        sqlite3_bind_text(stmt, 1, [dateString UTF8String] , -1, NULL);
        sqlite3_bind_text(stmt,2,[[NSString stringWithFormat:@"%f",[product.price floatValue] ]  UTF8String] , -1, NULL);
        sqlite3_bind_text(stmt, 3, [product.canBuy==nil?@"":product.canBuy UTF8String] , -1, NULL);
        sqlite3_bind_text(stmt, 4, [[NSString stringWithFormat:@"%@",product.promotionPrice] UTF8String], -1, NULL);
		sqlite3_bind_int(stmt, 5, [product.productId intValue]);
        [dateFormat release];
	}
	if (sqlite3_step(stmt) != SQLITE_DONE)
		//NSAssert1(0, @"Error updating table: %s", errorMsg);
        sqlite3_finalize(stmt);
	
}

- (void)saveSearchHistory:(NSString *)name{
    
	char *update = "INSERT OR REPLACE INTO searchHistory (name,time)VALUES (?,?);";
    
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK) {
		
		
		sqlite3_bind_text(stmt, 1, [name UTF8String] , -1, NULL);
        
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
        
        sqlite3_bind_text(stmt, 2, [dateString UTF8String] , -1, NULL);
        [dateFormat release];
	}
	if (sqlite3_step(stmt) != SQLITE_DONE)
        //	NSAssert1(0, @"Error updating table: %s", errorMsg);
        sqlite3_finalize(stmt);
	
}

- (NSMutableArray *)querySearchHistory{
    NSMutableArray *array=[NSMutableArray arrayWithCapacity:2]; 
    NSString *query = @"SELECT ROW, name FROM searchHistory order by time desc";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2( database, [query UTF8String],
                           -1, &statement, nil) == SQLITE_OK) {
		//sqlite3_bind_text(statement, 1, [bookid UTF8String] , -1, NULL);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //int row = sqlite3_column_int(statement, 0);
            
            char *name= (char *)sqlite3_column_text(statement, 1);
            
            
            [array addObject:[NSString stringWithUTF8String:name]];
        }
        sqlite3_finalize(statement);
		
    } 
    
	return array;
    
	
}
- (NSString *)querySearchHistoryByName:(NSString *)name{
    
    NSString *key=nil;
    NSString *query = @"SELECT ROW, name FROM searchHistory where name=?";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2( database, [query UTF8String],
                           -1, &statement, nil) == SQLITE_OK) {
		sqlite3_bind_text(statement, 1, [name UTF8String] , -1, NULL);
        if (sqlite3_step(statement) == SQLITE_ROW) {
            
            
            char *cnname= (char *)sqlite3_column_text(statement, 1);
            key=[NSString stringWithUTF8String:cnname];
            
        }
        sqlite3_finalize(statement);
		
    } 
    
	return key;
}

- (void)updateTimeSearchHistory:(NSString *)name{
    char *update = "update searchHistory set time=? where name=?;";
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK) {
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
        sqlite3_bind_text(stmt, 1, [dateString UTF8String] , -1, NULL);
		sqlite3_bind_text(stmt, 2, [name UTF8String] , -1, NULL);
        [dateFormat release];
	}
	if (sqlite3_step(stmt) != SQLITE_DONE)
		//NSAssert1(0, @"Error updating table: %s", errorMsg);
        sqlite3_finalize(stmt);
	
}
- (void)deleteSearchHistory{
    
	char *update = "delete from searchHistory;";
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK) {
	}
	if (sqlite3_step(stmt) != SQLITE_DONE)
		//NSAssert1(0, @"Error updating table: %s", errorMsg);
        sqlite3_finalize(stmt);
    
}

- (void)deleteProductHistory{
    
	char *update = "delete from history;";
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK) {
	}
	if (sqlite3_step(stmt) != SQLITE_DONE)
		//NSAssert1(0, @"Error updating table: %s", errorMsg);
        sqlite3_finalize(stmt);
    
}

-(BOOL)writeData:(NSData *)data toFile:(NSString *)fileName
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    if (!documentsDirectory) {
        return NO;
    }
    NSString *appFile=[documentsDirectory stringByAppendingPathComponent:fileName];
    return ([data writeToFile:appFile atomically:NO]);
}
-(NSData *)dataFromFile:(NSString *)fileName
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString *appFile=[documentsDirectory stringByAppendingPathComponent:fileName];
    NSData *data=[[[NSData alloc] initWithContentsOfFile:appFile] autorelease];
    return data;
}


- (void)dealloc {
    [userDic release];
    [cateDic release];
    
    [filterDic release];
    [provinceArray release];
    [cart release];
    [keyWord release];
    [super dealloc];
}

#pragma mark - singleton methods
static DataHandler *sharedInstance = nil;

+ (DataHandler *)sharedDataHandler
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

@end

@implementation NSString(MD5Addition)

- (NSString *) stringFromMD5{
    
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return [outputString autorelease];
}

@end
