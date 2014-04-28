//
//  YWFavoriteService.h
//  TheStoreApp
//
//  Created by LinPan on 13-8-17.
//
//

#import "YWBaseService.h"
@class FavoriteResultInfo;
@interface YWFavoriteService : YWBaseService


- (NSInteger)addFavorite:(NSDictionary *)paramDic;
- (FavoriteResultInfo *)getMyFavoriteList:(NSDictionary *)paramDic;
- (BOOL)delFavorite:(NSDictionary *)paramDic;
@end
