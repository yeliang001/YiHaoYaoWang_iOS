//
//  YWSearchService.h
//  TheStoreApp
//
//  Created by LinPan on 13-8-5.
//
//

#import "YWBaseService.h"

@class SearchResultInfo;
@interface YWSearchService : YWBaseService

/**
 * 获取搜索结果，搜索结果是ProductInfo对象的数组，然后封装在SearchResultInfo对象中返回
 */
- (SearchResultInfo *)getSearchProductListWithParam:(NSDictionary *)paramDic;

/**
 * 返回 RelationWordInfo 对象的数组
 * RelationWordInfo 对象包括 关联词 和 该关联词的商品个数
 */
- (NSMutableArray *)getSearchKeyword:(NSDictionary *)paramDic;
@end
