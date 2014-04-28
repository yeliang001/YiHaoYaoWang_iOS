//
//  PromotionService.h
//  TheStoreApp
//
//  Created by yiming dong on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheStoreService.h"

@class Page;

@interface PromotionService : TheStoreService

-(Page*)getCmsPageList:(Trader *)aTrader provinceId:(NSNumber*)aProvinceId activityId:(NSNumber*)aActivityId currentPage:(NSNumber*)aCurrentPage pageSize:(NSNumber*)aPageSize;


//Page<CmsColumnVO> getCmsColumnList(Trader trader,
//                                   java.lang.Long provinceId,
//                                   java.lang.Long cmsPageId,
//                                   java.lang.String type,
//                                   java.lang.Integer currentPage,
//                                   java.lang.Integer pageSize)

//参数：
//trader -
//provinceId - 省份id
//cmsPageId - cms活动id
//type - 掌上配置的CMS 2：PC配置的CMS

-(Page*)getCmsColumnList:(Trader *)aTrader 
              provinceId:(NSNumber*)aProvinceId 
               cmsPageId:(NSNumber*)aCmsPageId 
                    type:(NSString*)aType
             currentPage:(NSNumber*)aCurrentPage 
                pageSize:(NSNumber*)aPageSize;

@end
