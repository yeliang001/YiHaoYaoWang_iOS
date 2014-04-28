//
//  YWProductService.h
//  TheStoreApp
//
//  Created by LinPan on 13-7-22.
//
//

#import "YWBaseService.h"
@class SpecialRecommendInfo;
@class Page;
@class ProductInfo;
@class CommentInfo;
@class CartInfo;
@interface YWProductService : YWBaseService

/**
 *获取首页的数据
 *得到轮播图的对象数组 和 楼层的对象数组，保存在Page对象中返回
 *轮播图 数组中对应的对象为：SpecialRecommendInfo
 *楼层的对象：AdFloorInfo
 *楼层中推荐的商品的对象为：SpecialRecommendInfo
 */
- (Page *)getHomeSpcecialList;

/**
 *获取分类的接口
 *返回的结果为 CategoryInfo 的数组，最后通过Page封装，返回page对象
 */
- (Page *)getCategory;


/**
 *获取商品详情，返回 ProductInfo 对象
 */
- (ProductInfo *)getProductDetail:(NSDictionary *)paramDic;


/**
 *返回商品的评论信息，返回对象为 字典对象
 *commentlist-> 评论数组
 *commentclass-> 好/中/差评 比重数据的字典
 */
- (NSDictionary *)getProductCommentList:(NSDictionary *)paramDic;


/**
 *购物车中要获取所有商品的数组，把所有商品组成json 作为参数给服务器，获取对应的库存信息
 *库存信息是一个字典， productNo 标示商品  stock 标示该商品的数量
 */
- (NSMutableArray *)getProductInStock:(NSDictionary *)paramDic; //商品的库存商品返回数组

/**
 *
 */
- (CartInfo *)getProductDetailList:(NSDictionary *)paramDic; //获取多个商品详细

@end
