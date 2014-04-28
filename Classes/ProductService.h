//
//  ProductService.h
//  TheStoreApp
//
//  Created by linyy on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheStoreService.h"
#import "Trader.h"
#import "MethodBody.h"
#import "ProductVO.h"
#import "MobilePromotion.h"
#import "Page.h"
#import "RockResult.h"
#import "UpdateGiftResult.h"
#import "MobilePromotionDetailVO.h"

@class ProductDescVO;

@interface ProductService:TheStoreService 



-(Page*)getHotProductByActivityID:(Trader *)aTrader 
                       activityID:(NSNumber*)anActivityID 
                       provinceId:(NSNumber*)aProvinceId 
                      currentPage:(NSNumber *)aCurrentPage 
                         pageSize:(NSNumber *)aPageSize;

//根据父分类获取子分类
-(Page *)getCategoryByRootCategoryId:(Trader *)trader 
                            mcsiteId:(NSNumber *)mcsiteId 
                      rootCategoryId:(NSNumber *)rootCategoryId 
                         currentPage:(NSNumber *)currentPage 
                            pageSize:(NSNumber *)pageSize;
/**
 * @Title: getCategoryByRootCategoryId
 * @author guoyang
 * @Description: 根据一级分类查询二级分类和三级分类
 * @date 2013-5-14
 * @param trader
 * @param mcsiteId 站点ID
 * @param rootCategoryId 一级分类ID
 * @return 二级分类列表
 *         CategoryVO.childCategoryVOList 三级分类列表
 */
//public List<CategoryVO> getCategoryByRootCategoryId(Trader trader, Long mcsiteId,Long rootCategoryId)

-(NSArray*)getCategoryByRootCategoryId:(Trader*)trader mcsiteId:(NSNumber*)mcsiteId rootCategoryId:(NSNumber*)rootCategoryId;


//取得首页的热销图(废弃)
-(Page *)getHomeHotPointList:(Trader *)trader provinceId:(NSNumber *)provinceId currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize;
//取得首页的热销图(新)
-(Page *)getHomeHotPointListNew:(Trader *)trader provinceId:(NSNumber *)provinceId currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize;
//根据条形码获取产品详细信息
-(NSArray *)getProductByBarcode:(Trader *)trader barcode:(NSString *)barcode provinceId:(NSNumber *)provinceId;
//获取产品详细信息-基本信息
-(ProductVO	*)getProductDetail:(Trader *)trader productId:(NSNumber *)productId provinceId:(NSNumber *)provinceId;
//获取产品详细信息-基本信息
-(ProductVO	*)getProductDetail:(Trader *)trader productId:(NSNumber *)productId provinceId:(NSNumber *)provinceId promotionid:(NSString*) promotionid;
//获取产品详细信息-评论信息
-(ProductVO	*)getProductDetailComment:(Trader *)trader productId:(NSNumber *)productId provinceId:(NSNumber *)provinceId;
//获取产品详细信息-描述信息
-(ProductVO	*)getProductDetailDescription:(Trader *)trader productId:(NSNumber *)productId provinceId:(NSNumber *)provinceId;
//取得热销排行榜
-(Page *)getPromotionProductPage:(Trader *)trader provinceId:(NSNumber *)provinceId categoryId:(NSNumber *)categoryId currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize;
//获取用户感兴趣的商品
-(Page *)getMoreInterestedProducts:(Trader*)trader productId:(NSNumber*)productId provinceId:(NSNumber *)provinceId currentPage:(NSNumber*)currentPage pageSize:(NSNumber*)pageSize;
//获取赠品列表(用于商品详情)
-(NSArray *)getPromotionGiftList:(Trader*)trader provinceId:(NSNumber *)provinceId merchantIds:(NSArray *)merchantIds productIds:(NSArray *)productIds;
//获取赠品列表(用于购物车)
-(NSArray *)getPromotionGiftList:(NSString*)token merchantIds:(NSArray *)merchantIds productIds:(NSArray *)productIds;
//获取购物车满减活动列表
-(NSArray *)getCashPromotionList:(NSString*)token merchantIds:(NSArray *)merchantIds productIds:(NSArray *)productIds;
//获取购物车换购活动列表
-(NSArray *)getRedemptionPromotionList:(NSString*)token merchantIds:(NSArray *)merchantIds productIds:(NSArray *)productIds;

//领取赠品
-(int)updateGiftProducts:(NSString *)token giftProductIdList:(NSArray *)giftProductIdList promotionIdList:(NSArray *)promotionIdList merchantIdList:(NSArray *)merchantIdList quantityList:(NSArray *)quantityList;
//领取促销活动接口 1-赠品，2-换购，3-满减
-(int)updateCartPromotion:(NSString *)token giftProductIdList:(NSArray *)giftProductIdList promotionIdList:(NSArray *)promotionIdList merchantIdList:(NSArray *)merchantIdList quantityList:(NSArray *)quantityList Type:(int)promotionType;
//获取1起摇商品列表 Page<RockProductVO>
-(Page *)getRockProductList:(Trader *)trader provinceId:(NSNumber *)provinceId currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize;
//摇动手机
-(NSString *)rockRock:(Trader *)trader provinceId:(NSNumber *)provinceId promotionId:(NSString *)promotionId productId:(NSNumber *)productId lng:(NSNumber *)lng lat:(NSNumber *)lat token:(NSString *)token;
//获取摇动手机后的匹配结果
-(RockResult *)getRockResult:(Trader *)trader provinceId:(NSNumber *)provinceId promotionId:(NSString *)promotionId productId:(NSNumber *)productId;

/**
 * <h2>修改购物车中的赠品</h2>
 * <br/>
 * 功能点：购物车查看页面<br/>
 * 异常：服务器错误;Token错误;<br/>
 * 返回：UpdateGiftResult<br/> 
 * 必填参数：token,giftProductIdList,promotionIdList,merchantIdList,quantityList<br/> 
 * 返回值：同返回<br/> 
 * @param token
 * @param giftProductIdList  待保存的赠品列表
 * @param promotionIdList 对应giftProductIdList中的数据表示赠品的promotionId
 * @param merchantIdList 对应giftProductIdList中的数据表示赠品的merchantId
 * @param quantityList 对应giftProductIdList中的数据表示赠品的数量
 * @return 
 */
-(UpdateGiftResult *)updateGiftProductsV2:(NSString *)token giftProductIdList:(NSArray *)giftProductIdList promotionIdList:(NSArray *)promotionIdList merchantIdList:(NSArray *)merchantIdList quantityList:(NSArray *)quantityList;


/**
 * <h2>获取产品详细信息-描述信息</h2>
 * <br/>
 * 功能点：产品详细页;<br/>
 * 异常：服务器错误;Trader错误;<br/>
 * 返回：List<ProductDescVO><br/>
 * 必填参数：trader,productId,provinceId<br/>
 * ProductDescVO.tabType 1-产品描述 2-规格参数 3-包装清单 4-售后服务<br/>
 * @param trader
 * @param productId
 * @return 返回获取产品详细信息-描述信息
 */
-(NSArray*)getProductDetailDescriptionV2:(Trader *)aTrader
                                     productId:(NSNumber *)aProductId
                                    provinceId:(NSNumber *)aProvinceId;

-(NSArray*)getProductDetails:(Trader *)aTrader
                  productIds:(NSArray *)productIds provinceId:(NSNumber *)provinceId;

//**获取商品详情页促销活动（包含赠品、换购、满减）
-(MobilePromotion*) getMobilePromotion:(Trader *) aTrader provinceId:(NSNumber *)provinceId merchantIds:(NSArray *)merchantIds productIds:(NSArray *)productIds;

//**首页商品促销查询详情
-(MobilePromotionDetailVO*) getPromotionDetailPageVO:(Trader *) aTrader promotionId:(NSNumber*)promotionId promotionLevelId:(NSNumber*)promotionLevelId provinceId:(NSNumber*)provinceId type:(NSNumber*)type currentPage:(NSNumber*)currentPage pageSize:(NSNumber*)pageSize token:(NSString *)token;
@end
