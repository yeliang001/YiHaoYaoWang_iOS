//
//  YWAddressService.m
//  TheStoreApp
//
//  Created by LinPan on 13-8-20.
//
//

#import "YWAddressService.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseQueue.h"
#import "GoodReceiverVO.h"
#import "GlobalValue.h"
#import "UserInfo.h"
#import "ResponseInfo.h"
#import "GoodReceiverVO.h"

#import "ResultInfo.h"
#import "YWConst.h"
@implementation AddressInfo

- (void)dealloc
{
    [_addressId release];
    [_addresssName release];
    
    [super dealloc];
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"name: %@, id:%@",_addresssName, _addressId];
}
@end




@implementation YWAddressService

- (NSMutableArray *)getAllProvince
{
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    /*
    NSString *query = @"Select province_id,province_name from province";
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self getAddressDBPath]];
    [queue inDatabase:^(FMDatabase *_db){
        FMResultSet *rs = [_db executeQuery:query];
        while ([rs next])
        {
            AddressInfo *addressInfo = [[AddressInfo alloc] init];
            
            NSString *pid = [rs stringForColumn:@"province_id"];
            NSString *pname = [rs stringForColumn:@"province_name"];
            
            addressInfo.addressId = pid;
            addressInfo.addresssName = pname;
            
            [resultList addObject:addressInfo];
            [addressInfo release];
        }
    }];*/
    
    ResponseInfo *response = [self startRequestWithMethod:@"address.store.get" param:nil];
    
    ResultInfo *result = [[ResultInfo alloc] init];
    result.bRequestStatus = response.isSuccessful;
    result.responseCode = response.statusCode;
    
    NSDictionary *dataDic = response.data;
    result.resultCode = dataDic[@"result"];
    
    NSArray *arr = dataDic[@"province_list"];
    for (NSDictionary *dic in arr)
    {
        NSString *pId = dic[@"provinceId"];
        NSString *pName = dic[@"provinceName"];
        
        AddressInfo *addressInfo = [[AddressInfo alloc] init];
        addressInfo.addressId = pId;
        addressInfo.addresssName = pName;
        
        [resultList addObject:addressInfo];
    }

    result.resultObject = resultList;
    
    DebugLog(@"Get all province %@",resultList);
    return [resultList autorelease];
}

//从本地数据库中获取城市名
- (NSMutableArray *)getCitiesByProvinceId:(NSString *)pid
{
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
/*
    NSString *query = @"Select city_id,city_name from city where province_id=?";
    DebugLog(@"getCity query %@, pid %@",query,pid);
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self getAddressDBPath]];
    [queue inDatabase:^(FMDatabase *_db){
        FMResultSet *rs = [_db executeQuery:query,pid];
        while ([rs next])
        {
            AddressInfo *addressInfo = [[AddressInfo alloc] init];
            
            NSString *pid = [rs stringForColumn:@"city_id"];
            NSString *pname = [rs stringForColumn:@"city_name"];
            
            addressInfo.addressId = pid;
            addressInfo.addresssName = pname;
            
            [resultList addObject:addressInfo];
            [addressInfo release];
        }
    }];
    */
    
    NSDictionary *paramDic = @{@"provinceid":pid};

    ResponseInfo *response = [self startRequestWithMethod:@"address.store.get" param:paramDic];
    
    ResultInfo *result = [[ResultInfo alloc] init];
    result.bRequestStatus = response.isSuccessful;
    result.responseCode = response.statusCode;
    
    NSDictionary *dataDic = response.data;
    result.resultCode = dataDic[@"result"];
    
    NSArray *arr = dataDic[@"city_list"];
    for (NSDictionary *dic in arr)
    {
        NSString *pId = dic[@"cityId"];
        NSString *pName = dic[@"cityName"];
        
        AddressInfo *addressInfo = [[AddressInfo alloc] init];
        addressInfo.addressId = pId;
        addressInfo.addresssName = pName;
        
        [resultList addObject:addressInfo];
    }
    
    result.resultObject = resultList;
    
    
    
    
    DebugLog(@"getCitiesByProvinceId %@",resultList);
    return [resultList autorelease];
}

//从本地数据库获取地区名
- (NSMutableArray *)getCountiesByCityId:(NSString *)cityId
{
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
  /*  NSString *query = @"Select county_id,county_name from county where city_id=?";
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self getAddressDBPath]];
    [queue inDatabase:^(FMDatabase *_db){
        FMResultSet *rs = [_db executeQuery:query,cityId];
        while ([rs next])
        {
            AddressInfo *addressInfo = [[AddressInfo alloc] init];
            
            NSString *pid = [rs stringForColumn:@"county_id"];
            NSString *pname = [rs stringForColumn:@"county_name"];
            
            addressInfo.addressId = pid;
            addressInfo.addresssName = pname;
            
            [resultList addObject:addressInfo];
            [addressInfo release];
        }
    }];*/
    
    
    NSDictionary *paramDic = @{@"cityid":cityId};
    
    ResponseInfo *response = [self startRequestWithMethod:@"address.store.get" param:paramDic];
    
    ResultInfo *result = [[ResultInfo alloc] init];
    result.bRequestStatus = response.isSuccessful;
    result.responseCode = response.statusCode;
    
    NSDictionary *dataDic = response.data;
    result.resultCode = dataDic[@"result"];
    
    NSArray *arr = dataDic[@"county_list"];
    for (NSDictionary *dic in arr)
    {
        NSString *pId = dic[@"countyId"];
        NSString *pName = dic[@"countyName"];
        
        AddressInfo *addressInfo = [[AddressInfo alloc] init];
        addressInfo.addressId = pId;
        addressInfo.addresssName = pName;
        
        [resultList addObject:addressInfo];
    }
    
    result.resultObject = resultList;
    
    
    DebugLog(@"getCountiesByCityId %@",resultList);
    return [resultList autorelease];
}
//本地数据库路径
- (NSString *)getAddressDBPath
{
//    NSString *path  = [[NSBundle mainBundle] pathForResource:@"yw_address" ofType:@"sqlite"];
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
//    return path;
}

- (ResultInfo *)addNewGoodReceiver:(GoodReceiverVO *)recevice
{
    ResultInfo *result = [[ResultInfo alloc] init];
    
    NSDictionary *dic = @{@"userid": [GlobalValue getGlobalValueInstance].userInfo.ecUserId,
                          @"username":[GlobalValue getGlobalValueInstance].userInfo.uid,
                          @"realname":recevice.receiveName,
                          @"postcode":@"000000",
                          @"address":recevice.address1,
                          @"tel":recevice.receiverPhone.length>0 ?recevice.receiverPhone : @"",
                          @"mobile":recevice.receiverMobile.length>0 ?recevice.receiverMobile : @"",
                          @"province":[recevice.provinceId stringValue],
                          @"city":[recevice.cityId stringValue],
                          @"county":[recevice.countyId stringValue],
                          @"email":@"0@0.com",
                          @"isdefault":@"0",//[recevice.defaultAddressId stringValue],//1是默认地址 0 不是
                          @"addresstype": @"0", // 0 是普通地址，1 是一键下单地址
                          @"provincename":recevice.provinceName,
                          @"cityname":recevice.cityName,
                          @"countyname":recevice.countyName,
                          @"token":[GlobalValue getGlobalValueInstance].ywToken,};
    ResponseInfo *response = [self startRequestWithMethod:@"add.address" param:dic];
    
    NSDictionary *dataDic = response.data;
    
    result.responseCode = response.statusCode;
    result.bRequestStatus = response.isSuccessful;
    result.resultCode = [dataDic[@"result"] intValue];
    
    
    if (response.isSuccessful && response.statusCode == 200)
    {
        
        DebugLog(@"addNewAddress %@",dataDic);
        
        if ([dataDic[@"result"] intValue] == 1)
        {
            result.resultObject = dataDic[@"addressid"];
        }
    }
    return [result autorelease];
}



- (ResultInfo *)updateGoodReceiver:(GoodReceiverVO *)recevice
{
    ResultInfo *result = [[ResultInfo alloc] init];
    
    NSDictionary *dic = @{  @"userid": [GlobalValue getGlobalValueInstance].userInfo.ecUserId,
                            @"username":[GlobalValue getGlobalValueInstance].userInfo.uid,
                            @"addressid":[recevice.nid stringValue],
                            @"realname":recevice.receiveName,
                            @"postcode":@"000000",
                            @"address":recevice.address1,
                            @"tel":recevice.receiverPhone.length>0 ?recevice.receiverPhone : @"",
                            @"mobile":recevice.receiverMobile.length>0 ?recevice.receiverMobile : @"",
                            @"province":[recevice.provinceId stringValue],
                            @"city":[recevice.cityId stringValue],
                            @"county":[recevice.countyId stringValue],
                            @"email":@"0@0.com",
                            @"isdefault":@"0",//[recevice.defaultAddressId stringValue],//1是默认地址 0 不是
                            @"addresstype": @"0", // 0 是普通地址，1 是一键下单地址
                            @"provincename":recevice.provinceName,
                            @"cityname":recevice.cityName,
                            @"countyname":recevice.countyName,
                            @"token":[GlobalValue getGlobalValueInstance].ywToken,};
    
    ResponseInfo *response = [self startRequestWithMethod:@"update.address" param:dic];
    
    NSDictionary *dataDic = response.data;
    result.responseCode = response.statusCode;
    result.bRequestStatus = response.isSuccessful;
    result.resultCode = [dataDic[@"result"] intValue];
    
    return [result autorelease];
//    if (response.isSuccessful && response.statusCode == 200)
//    {
//       
//        DebugLog(@"updateGoodReceiver %@",dataDic);
//        if ([dataDic[@"result"] intValue] == 1)
//        {
//           
//        }
//    }
//    return NO;
}


- (BOOL)deleteGoodRecevicer:(NSString *)addressId
{
    NSDictionary *dic = @{  @"addressid":addressId,
                            @"token":[GlobalValue getGlobalValueInstance].ywToken,
                            @"userid": [GlobalValue getGlobalValueInstance].userInfo.ecUserId,
                            @"username":[GlobalValue getGlobalValueInstance].userInfo.uid};
                            
    ResponseInfo *response = [self startRequestWithMethod:@"delete.address" param:dic];
    if (response.isSuccessful && response.statusCode == 200)
    {
        NSDictionary *dataDic = response.data;
        DebugLog(@"delete address %@",dataDic);
        if ([dataDic[@"result"] intValue] == 1)
        {
            return YES;
        }
    }
    
    return NO;
}

- (NSMutableArray *)getMyGoodRecevicer
{
    NSDictionary *dic = @{  @"flag" : @"1",
                            @"token":[GlobalValue getGlobalValueInstance].ywToken,
                            @"userid": [GlobalValue getGlobalValueInstance].userInfo.ecUserId,
                            @"username":[GlobalValue getGlobalValueInstance].userInfo.uid};
    
    ResponseInfo *response = [self startRequestWithMethod:@"get.address.list" param:dic];
    
    if (response.isSuccessful && response.statusCode == 200)
    {
        NSDictionary *dataDic = response.data;
        DebugLog(@"delete address %@",dataDic);
        if ([dataDic[@"result"] intValue] == 1)
        {
            
            NSMutableArray *resultList = [[NSMutableArray alloc] init];
            
            NSMutableArray *addressDicList = dataDic[@"address_list"];
            for (NSDictionary *dic in addressDicList)
            {
                GoodReceiverVO *recevice = [[GoodReceiverVO alloc] init];
                recevice.address1 = dic[@"address"];
                recevice.cityId = [NSNumber numberWithInt:[dic[@"city"] intValue]];
                recevice.cityName = dic[@"cityName"];
                recevice.countryId = [NSNumber numberWithInt:0];
                recevice.countryName = @"中国";
                recevice.countyId = [NSNumber numberWithInt:[dic[@"county"] intValue]];
                recevice.countyName = dic[@"countyName"];
                recevice.nid = [NSNumber numberWithInt:[dic[@"id"] intValue]];
                recevice.postCode = dic[@"postCode"];
                recevice.provinceId = [NSNumber numberWithInt:[dic[@"province"] intValue]];
                recevice.provinceName = dic[@"provinceName"];
                recevice.receiveName = dic[@"realName"];
                recevice.receiverEmail =   dic[@"email"];
                recevice.receiverMobile = ValidValue(dic[@"mobile"]);
                recevice.receiverPhone = ValidValue(dic[@"tel"]);
                
                [resultList addObject:recevice];
                [recevice release];
            }
            
            return [resultList autorelease];
        }
    }
    
    return nil;
}




@end
