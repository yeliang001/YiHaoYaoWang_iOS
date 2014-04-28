//
//  GroupBuyService.h
//  TheStoreApp
//
//  Created by jiming huang on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheStoreService.h"
#import "MethodBody.h"
#import "Trader.h"
#import "Page.h"
#import "GrouponVO.h"
#import "GrouponOrderVO.h"
#import "GrouponOrderSubmitResult.h"
@interface GroupBuyService : TheStoreService {
}

-(NSArray *)getGrouponCategoryList:(Trader *)trader areaId:(NSNumber *)areaId;
-(Page *)getCurrentGrouponList:(Trader *)trader areaId:(NSNumber *)areaId categoryId:(NSNumber *)categoryId currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize;
-(NSArray *)getGrouponAreaList:(Trader *)trader;
-(NSNumber *)getGrouponAreaIdByProvinceId:(Trader *)trader provinceId:(NSNumber *)provinceId;
-(GrouponVO *)getGrouponDetail:(Trader *)trader grouponId:(NSNumber *)grouponId areaId:(NSNumber *)areaId;
-(GrouponOrderVO *)createGrouponOrder:(NSString *)token grouponId:(NSNumber *)grouponId serialId:(NSNumber *)serialId areaId:(NSNumber *)areaId;
-(GrouponOrderSubmitResult *)submitGrouponOrder:(NSString *)token grouponId:(NSNumber *)grouponId serialId:(NSNumber *)serialId quantity:(NSNumber *)quantity receiverId:(NSNumber *)receiverId payByAccount:(NSNumber *)payByAccount grouponRemarker:(NSString *)grouponRemarker areaId:(NSNumber *)areaId gatewayId:(NSNumber *)gatewayId;
-(GrouponOrderVO *)getMyGrouponOrder:(NSString *)token orderId:(NSNumber *)orderId;
-(Page *)getMyGrouponList:(NSString *)token type:(NSNumber *)type currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize;
-(int)saveGateWayToGrouponOrder:(NSString *)token orderId:(NSNumber *)orderId gatewayId:(NSNumber *)gatewayId;
-(int)updateOrderFinish:(NSString *)token orderId:(NSNumber *)orderId;

/**
 * <h2>查询当期团购列表(包含排序功能)</h2><br/>
 * <br/>
 * 功能点：团购首页;<br/>
 * 异常：服务器错误;Trader错误;<br/>
 * 返回：GrouponVO<br/>
 * 必填参数：trader,areaId,categoryId,currentPage,pageSize<br/> 
 * 返回值：<br/> 
 * @param trader
 * @param areaId 地区id
 * @param categoryId 0-其他；1-1号团独享；2-食品 ；3-居家 ；4-电器 ；5-时尚 ；6-健康服务 ；7-爱名品 ；8-会员专享；
 * @param sortType 0-默认的排序列表；1-人气最高；2-折扣最多；3-价格最低；4-最新发布；
 * @param currentPage
 * @param pageSize
 * @return 返回当期团购列表
 */
-(Page *)getCurrentGrouponList:(Trader *)trader areaId:(NSNumber *)areaId categoryId:(NSNumber *)categoryId sortAttrId:(NSNumber*)sortId currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize;

/**
 * <h2>查询当期团购列表(包含排序功能)</h2><br/>
 * <br/>
 * 功能点：团购首页;<br/>
 * 异常：服务器错误;Trader错误;<br/>
 * 返回：GrouponVO<br/>
 * 必填参数：trader,areaId,categoryId,currentPage,pageSize<br/> 
 * 返回值：<br/> 
 * @param trader
 * @param areaId 地区id
 * @param categoryId 0-其他；1-1号团独享；2-食品 ；3-居家 ；4-电器 ；5-时尚 ；6-健康服务 ；7-爱名品 ；8-会员专享；
 * @param sortType 0-默认的排序列表；1-人气最高；2-折扣最多；3-价格最低；4-最新发布；
 * @param siteType 0为全部站点，1为1号店，2为1号商场
 * @param currentPage
 * @param pageSize
 * @return 返回当期团购列表
 */
-(Page *)getCurrentGrouponList:(Trader *)trader areaId:(NSNumber *)areaId categoryId:(NSNumber *)categoryId sortType:(NSNumber*)sortType siteType:(NSNumber *)siteType currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize;

/**
 * <h2>获取团购排序属性列表</h2><br/>
 * <br/>
 * 功能点：团购首页;<br/>
 * 异常：服务器错误;Trader错误;<br/>
 * 返回：List<GrouponSortAttributeVO><br/>
 * 必填参数：trader,areaId<br/> 
 * 返回值：<br/> 
 * @param trader
 * @return 返回团购排序属性列表
 */
-(NSArray *)getGroupOnSortAttribute:(Trader *)trader AreaId:(NSNumber*)areaId;
@end
