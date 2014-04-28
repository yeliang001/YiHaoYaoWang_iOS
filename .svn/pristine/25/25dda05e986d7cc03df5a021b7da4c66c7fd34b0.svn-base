//
//  FavoriteService.h
//  TheStoreApp
//
//  Created by linyy on 11-2-12.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheStoreService.h"
#import "Trader.h"
#import "MethodBody.h"
#import "Page.h"

@interface FavoriteService:TheStoreService{
}

//添加一个产品到我的收藏
-(int)addFavorite:(NSString *)token tag:(NSString *)tag productId:(NSNumber *)productId;
//从我的收藏删除一个产品
-(int)delFavorite:(NSString *)token productId:(NSNumber *)productId;
//获取我的收藏夹列表
-(Page *)getMyFavoriteList:(NSString *)token tag:(NSString *)tag currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize;
@end
