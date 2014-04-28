//
//  CentralMobileFacadeService.h
//  TheStoreApp
//
//  Created by yangxd on 11-06-08.
//  Copyright 2011 vsc. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "TheStoreService.h"
#import "Trader.h"
#import "MethodBody.h"

@interface CentralMobileFacadeService:TheStoreService {
}

-(int)registerLaunchInfo:(Trader *)trader iMei:(NSString *)iMei phoneNo:(NSString *)phoneNo;                        // 客户端启动注册消息


-(NSArray*)getStartupPicVOList:(Trader*) trader Size:(NSString*)size SiteType:(NSNumber*)type;
/**
* <h2>客户单启动界面<h2><br/>
* <br/>
* 功能点：<br/>
* 异常：服务器错误；trader错误
* 返回：启动图片信息实体类
* 必填参数：Trader, size , siteType
* 返回值：同返回
* @param trader
* @param size 尺寸
* @param siteType 1-一号店；2-一号商城
* @return 同返回
public List<StartupPicVO> getStartupPicVOList(Trader trader , String size,long siteType);
*/

@end
