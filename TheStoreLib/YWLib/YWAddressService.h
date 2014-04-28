//
//  YWAddressService.h
//  TheStoreApp
//
//  Created by LinPan on 13-8-20.
//
//

#import <Foundation/Foundation.h>
#import "YWBaseService.h"
#import "GoodReceiverVO.h"

@class ResultInfo;


#define kAddressDB @"yw_address.sqlite"

//省，市，区 的对应model类
@interface AddressInfo : NSObject

@property (copy, nonatomic) NSString *addresssName;
@property (copy, nonatomic) NSString *addressId;

@end




@interface YWAddressService : YWBaseService

- (NSMutableArray *)getCountiesByCityId:(NSString *)cityId;
- (NSMutableArray *)getCitiesByProvinceId:(NSString *)pid;
- (NSMutableArray *)getAllProvince;

- (ResultInfo *)addNewGoodReceiver:(GoodReceiverVO *)recevic;
- (ResultInfo *)updateGoodReceiver:(GoodReceiverVO *)recevice;
- (BOOL)deleteGoodRecevicer:(NSString *)addressId;
- (NSMutableArray *)getMyGoodRecevicer;
@end
