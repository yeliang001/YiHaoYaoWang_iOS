//
//  AddressService.h
//  TheStoreApp
//
//  Created by linyy on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheStoreService.h"
#import "Trader.h"
#import "MethodBody.h"

@interface AddressService:TheStoreService {
}
//删除收获地址
-(int)deleteGoodReceiverByToken:(NSString *)token goodReceiverId:(NSNumber *)goodReceiverId;
//获取1号店支持的所有的省份
-(NSArray *)getAllProvince:(Trader *)trader;
//根据省份ID，获取1号店支持的所有的市/区县
-(NSArray *)getCityByProvinceId:(Trader *)trader provinceId:(NSNumber *)provinceId;
//根据市/区县ID，获取1号店支持的所有的地区
-(NSArray *)getCountyByCityId:(Trader *)trader cityId:(NSNumber *)cityId;
//获取所有的收货地址列表
-(NSArray *)getGoodReceiverListByToken:(NSString *)token;
//添加新的收获地址
-(int)insertGoodReceiverByToken:(NSString *)token goodReceiverVO:(GoodReceiverVO *)goodReceiverVO;
//更新收货地址信息
-(int)updateGoodReceiverByToken:(NSString *)token goodReceiverVO:(GoodReceiverVO *)goodReceiverVO;
-(int)insertGoodReceiverByToken:(NSString *)token goodReceiverVO:(GoodReceiverVO *)goodReceiverVO lngs:(NSArray *)lngs lats:(NSArray *)lats;
-(int)updateGoodReceiverByToken:(NSString *)token goodReceiverVO:(GoodReceiverVO *)goodReceiverVO lngs:(NSArray *)lngs lats:(NSArray *)lats;
@end
