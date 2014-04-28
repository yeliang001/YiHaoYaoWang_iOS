//
//  SystemService.h
//  TheStoreApp
//
//  Created by linyy on 11-2-11.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheStoreService.h"
#import "Trader.h"
#import "MethodBody.h"
#import "DownloadVO.h"
#import "Page.h"

@interface SystemService:TheStoreService{
}

//更新客户端程序，判断是否有新的客户端并传递下载地址
-(DownloadVO *)getClientApplicationDownloadUrl:(Trader *)trader;
//数据统计
-(int)doTracking:(Trader *)trader type:(NSNumber *)type url:(NSString *)theUrl;
//获取首页功能模块
-(NSArray *)getHomeModuleList:(Trader *)trader;
-(Page *)getQualityAppList:(Trader *)trader currentPage:(NSNumber*)currentPage pageSize:(NSNumber*)pageSize;
-(void)insertAppErrorLog:(Trader *)trader errorLog:(NSString *)errorLog token:(NSString *)token;
@end
