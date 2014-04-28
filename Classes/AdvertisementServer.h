//
//  AdvertisementServer.h
//  TheStoreApp
//
//  Created by jiming huang on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheStoreService.h"
#import "MethodBody.h"
#import "Trader.h"
#import "Page.h"
#import "AdvertisingPromotion.h"

@interface AdvertisementServer : TheStoreService {
    
}
-(Page *)getAdvertisementList:(Trader *)trader provinceId:(NSNumber *)provinceId currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize;

/**
 * <h2>获取广告促销列表</h2><br/>
 * <br/>
 * 功能点：首页;<br/>
 * 异常：服务器错误;Trader错误;<br/>
 * 必填参数：trader,provinceId,updateTag<br/>
 * 返回值：AdvertisingPromotion<br/>
 * @param trader
 * @param provinceId 省份id
 * @param updateTag 更新标记
 * @return 获取广告促销列表
 */
-(AdvertisingPromotion *)getCmsAdvertisingPromotion:(Trader *)trader provinceId:(NSNumber *)provinceId updateTag:(NSString *)updateTag;

/**
 * <h2>通过Type查询广告详情</h2><br/>
 * <br/>
 * 功能点：查询不同类型的广告信息<br/>
 * 异常：服务器错误;<br/>
 * 返回：Page<HotPointNewVO><br/>
 * 必填参数：trader,provinceId,type,currentPage,pageSize<br/>
 * 返回值：Page<HotPointNewVO><br/>
 * @param trader
 * @param provinceId 抵用券活动Id
 * @param type 类型 1-品牌旗舰
 * @param currentPage 当前页
 * @param pageSize 每页数目
 * @return
 */
-(Page *)getAdvertisingPromotionVOByType:(Trader *)trader provinceId:(NSNumber*)provinceId type:(NSNumber*)type currentPage:(NSNumber*)currentPage pageSize:(NSNumber*)pageSize;
@end
