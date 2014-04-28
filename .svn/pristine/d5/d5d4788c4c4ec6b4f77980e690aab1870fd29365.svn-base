//
//  CartService.h
//  TheStoreApp
//
//  Created by linyy  on 11-2-12.
//  Updated by yangxd on 11-06-29  添加了多个商品加入购物车接口
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheStoreService.h"
#import "Trader.h"
#import "MethodBody.h"
#import "CartVO.h"
#import "AddProductResult.h"
#import "UpdateCartResult.h"
#import "NormResult.h"
#import "OptionalPromotionInCartVO.h"
#import "SeckillResultVO.h"
#import "CheckSecKillResult.h"


@interface CartService:TheStoreService{
}

//添加商品到购物车
-(int)addProduct:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId quantity:(NSNumber *)quantity;
-(int)addProduct:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId quantity:(NSNumber *)quantity promotionid:(NSString*)promotionid;
//添加多个商品到购物车
-(NSArray *)addProducts:(NSString *)token productIds:(NSMutableArray *)productIds merchantIds:(NSMutableArray *)merchantIds quantitys:(NSMutableArray *)quantitys;
//添加多个商品到购物车
-(NSArray *)addProducts:(NSString *)token productIds:(NSMutableArray *)productIds merchantIds:(NSMutableArray *)merchantIds quantitys:(NSMutableArray *)quantitys promotionids:(NSMutableArray*)promotionids;
//从购物车中删除所有商品
-(int)delAllProduct:(NSString *)token;
//从购物车中删除商品
-(int)delProduct:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId updateType:(NSNumber *)updateType promotionid:(NSString*)promotionid;
//从购物车中删除商品(部分)
-(int)delProducts:(NSString *)token productIds:(NSArray *)productIds merchantIds:(NSArray *)merchantIds promotionList:(NSArray *)promotionList;
//获取购物车
-(CartVO *)getSessionCart:(NSString *)token;
//更新购物车中商品数量
-(int)updateCartItemQuantity:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId quantity:(NSNumber *)quantity updateType:(NSNumber *)updateType;
//更新购物车中商品数量
-(int)updateCartItemQuantity:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId quantity:(NSNumber *)quantity updateType:(NSNumber *)updateType promotionid:(NSString *) promotionid;
/*
* 更新购物车活动列表
* @param token
* @param productIdList 商品列表
* @param promotionIdList 活动列表
* @param merchantIdList 商家列表
* @param quantityList 数量列表
* @param type 1-赠品，2-换购，3-满减
 */
-(int)updateCartPromotion:(NSString *)token productIdList:(NSMutableArray *)productIdList promotionIdList:(NSMutableArray *)promotionIdList merchantIdList:(NSMutableArray *)merchantIdList quantityList:(NSMutableArray *)quantityList type:(NSNumber *)type;

/**
 * <h2>添加产品到购物车</h2>
 * <br/>
 * 功能点：产品详细页面;热销列表页面;促销列表页面;搜索列表页面<br/>
 * 异常：服务器错误;Token错误;<br/>
 * 返回：AddProductResult<br/>
 * 必填参数：token,productId,merchantId,quantity,promotionId<br/> 
 * 返回值：同返回<br/> 
 * @param token
 * @param productId 商品号
 * @param merchantId 商家号
 * @param quantity 数量
 * @param promotionId 促销参数，非促销商品就传""
 * @return 返回添加产品到购物车结果
 */


-(AddProductResult *)addProductV2:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId quantity:(NSNumber *)quantity promotionid:(NSString*)promotionid;


/**
 * <h2>添加多个产品到购物车</h2>
 * <br/>
 * 功能点：产品详细页面;热销列表页面;促销列表页面;搜索列表页面<br/>
 * 异常：服务器错误;Token错误;<br/>
 * 返回：List<AddProductResult>
 * 必填参数：token,productIds,merchantIds,quantitys,promotionIds<br/> 
 * 返回值：同返回<br/> 
 * @param token
 * @param productIds商品号
 * @param merchantIds 商户号
 * @param quantitys 数量
 * @param promotionIds 促销参数，非促销商品就传""
 * @return 返回添加产品到购物车结果
 */
-(NSArray *)addProductsV2:(NSString *)token productIds:(NSMutableArray *)productIds merchantIds:(NSMutableArray *)merchantIds quantitys:(NSMutableArray *)quantitys promotionids:(NSMutableArray*)promotionids;

/**
 * <h2>更新购物车中产品数量</h2>
 * <br/>
 * </pre>
 * 功能点：购物车查看页面<br/>
 * 异常：服务器错误;Token错误;<br/>
 * 返回：Integer<br/>
 * 必填参数：token,productId,merchantId,quantity,updateType,promotionId<br/> 
 * 返回值：同返回<br/> 
 * @param token
 * @param productId
 * @param merchantId
 * @param quantity
 * @param updateType
 * @param promotionId 促销参数，没有就传""
 * @return 返回更新购物车中产品数量结果
 */
-(UpdateCartResult *)updateCartItemQuantityV2:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId quantity:(NSNumber *)quantity updateType:(NSNumber *)updateType promotionId:(NSString *)promotionId;

/**
 * <h2>添加n元n件活动到购物车</h2>
 * <br/>
 * 功能点：n元n件活动详情页添加商品到购物车<br/>
 * 异常：服务器错误;Token错误;<br/>
 * 返回：AddOrDeletePromotionResult:NormResult(
 * 1:成功;
 * 0:失败;
 )
 * <br/>
 * @param token
 * @param promotionIds (活动ID)
 * @param promotionLevelIDs (活动层级ID)
 * @param productIds (商品ID)
 * @param promotionGiftMerchantIDs (商户号)
 * @param promotionGiftNums (商品数量)
 * @return 返回添加或删除n元n件活动到购物车结果
 */
-(NormResult *)addOptional:(NSString *)token promotionIds:(NSMutableArray *)promotionIds promotionLevelIDs:(NSMutableArray *)promotionLevelIDs productIds:(NSMutableArray *)productIds promotionGiftMerchantIDs:(NSMutableArray *)promotionGiftMerchantIDs promotionGiftNums:(NSMutableArray *)promotionGiftNums;

/**
 * <h2>删除购物车中的n元n件活动</h2>
 * <br/>
 * 功能点：购物车列表删除活动<br/>
 * 异常：服务器错误;Token错误;<br/>
 * 返回：AddOrDeletePromotionResult:NormResult(
 * 1:成功;
 * 0:失败;
 )
 * <br/>
 * 必填参数：token,promotionIds,promotionLevelIDs,productIds,promotionGiftMerchantIDs,promotionGiftNums,operation<br/>
 * 返回值：同返回<br/>
 * @param token
 * @param promotionIds (活动ID)
 * @param promotionLevelIDs (活动层级ID)
 * @param productIds (商品ID)
 * @param promotionGiftMerchantIDs (商户号)
 * @param promotionGiftNums (商品数量)
 * @return 返回添加或删除n元n件活动到购物车结果
 */
-(NormResult *)deleteOptional:(NSString *)token promotionIds:(NSMutableArray *)promotionIds promotionLevelIDs:(NSMutableArray *)promotionLevelIDs productIds:(NSMutableArray *)productIds promotionGiftMerchantIDs:(NSMutableArray *)promotionGiftMerchantIDs promotionGiftNums:(NSMutableArray *)promotionGiftNums;

-(AddOrDeletePromotionResult*)deleteOptional:(NSString*)token optionalPromotionInCartVO:(OptionalPromotionInCartVO*)aoptionalPromotionInCartVO;
/**
 * <h2>查询购物车中是否存在指定的n元n件活动</h2>
 * <br/>
 * 功能点：n元n件活动详情页添加商品到购物车<br/>
 * 异常：服务器错误;Token错误;<br/>
 * 返回：ExistOptionalResult(
 * 1:存在;
 * 0:不存在;
 * -1:服务器错误
 )
 * <br/>
 * 必填参数：token,provinceId,promotionId,promotionLevelId<br/>
 * 返回值：同返回<br/>
 * @param token
 * @param provinceId (省份ID)
 * @param promotionId (活动ID)
 * @param promotionLevelId (活动层级ID)
 * @return 返回查询购物车中是否存在指定的n元n件活动结果
 */
-(NormResult *)isExistOptionalInCart:(NSString *)token provinceId:(NSNumber*)provinceId promotionId:(NSNumber*)promotionId promotionLevelId:(NSNumber*)promotionLevelId;

/**
 * <h2>替换n元n件活动到购物车</h2>
 * <br/>
 * 功能点：n元n件活动详情页添加商品到购物车<br/>
 * 异常：服务器错误;Token错误;<br/>
 * 返回：UpadtePromotionResult:NormResult(
 * 1:成功;
 * 0:失败;
 )
 * <br/>
 * 必填参数：token,promotionIds,promotionLevelIDs,productIds,promotionGiftMerchantIDs,promotionGiftNums<br/>
 * 返回值：同返回<br/>
 * @param token
 * @param promotionIds (活动ID)
 * @param promotionLevelIDs (活动层级ID)
 * @param productIds (商品ID)
 * @param promotionGiftMerchantIDs (商户号)
 * @param promotionGiftNums (商品数量)
 * @return 返回替换n元n件活动到购物车结果
 */
-(NormResult *)updateOptional:(NSString *) token promotionIds:(NSMutableArray*)promotionIds promotionLevelIDs:(NSMutableArray*)promotionLevelIDs productIds:(NSMutableArray*)productIds promotionGiftMerchantIDs:(NSMutableArray*)promotionGiftMerchantIDs promotionGiftNums:(NSMutableArray*)promotionGiftNums;

/**
 *秒杀检查库存
 *@prarm token
 *@prarm token
 *@prarm token
 *@prarm token
 @return 检查库存
 */
-(SeckillResultVO *) preSeckillProduct:(NSString *) token provinceId:(NSNumber*) provinceId promotionId:(NSString *) promotionId productId:(NSNumber*) productId;

/**
 * 秒杀功能
 * @prarm  token
 * @param  productId       产品编号
 * @param  merchantOrderId 商户订单ID
 * @param  provinceId
 * @return 空表示秒杀不成功 其他成功添加购物车
 */
-(SeckillResultVO *) seckillProduct:(NSString *) token provinceId:(NSNumber*) provinceId promotionId:(NSString *) promotionId productId:(NSNumber*) productId;

/**
 * 检查商品是否为秒杀，如果为秒杀商品则返回活动开始结束时间和商品是否可以秒杀
 * @param promotionId
 * @param provinceId
 * @param productId
 * @return CheckSecKillResult
 */
-(CheckSecKillResult*) checkIfSecKill:(Trader *) trader promotionId:(NSString *)promotionId provinceId:(NSNumber *) provinceId productId:(NSNumber *)productId;

/**
 * 检查一列landingpage促销商品是否为秒杀
 * @param promotionIdList
 * @param productIdList
 * @param provinceId
 * @return
 */
-(NSArray *) checkIfSecKillForList:(Trader*) trader promotionIdList:(NSMutableArray *) promotionIdList productIdList:(NSMutableArray *)productIdList provinceId:(NSNumber *) provinceId;

#pragma mark 轻量接口
/**
 所有单个商品的添加以及删除接口，在内部区分调用landingpage，促销，以及普通商品
 */
-(AddProductResult*)addSingleProduct:(NSString*)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId quantity:(NSNumber *)quantity promotionid:(NSString*)promotionid;

-(int)deleteSingleProduct:(NSString*)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId  promotionid:(NSString*)promotionid;
/**
 * @param token
 * @param siteType 1:1号店  2:1号商城  3:1号店和1号商城
 * @return 购物车商品个数
 *         Key: “YHD_COUNT”  value:一号店商品个数
 *           Key：“1MALL_COUNT” value: 商城商品个数
 public Map<String,Integer> countSessionCart(String token,Integer siteType);

 */
-(int)countSessionCart:(NSString*)token siteType:(NSNumber*)type;
/**
 * 添加普通商品到购物车
 * @param token
 * @param productId 产品id
 * @param merchantId 商家id
 * @param quantity 数量
 * @return
 public AddProductResult addNormalProduct(String token, Long productId, Long merchantId, Long quantity);
 */

-(AddProductResult*)addNormalProduct:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId quantity:(NSNumber *)quantity ;

/**
 * 批量添加普通商品到购物车
 * @param token
 * @param productIds 产品id
 * @param merchantIds 商家id
 * @param quantitys 数量
 * @return
 public AddProductResult addNormalProducts(String token,List<Long> productIds,List<Long> merchantIds, List<Long> quantitys);
 */
-(AddProductResult*)addNormalProducts:(NSString *)token productIds:(NSMutableArray *)productIds merchantIds:(NSMutableArray *)merchantIds quantitys:(NSMutableArray *)quantitys;
/**
 * 添加促销商品（赠品、换购、满减）到购物车
 * @param token
 * @param productId 产品id
 * @param merchantId 商家id
 * @param quantity 数量
 * @param promotionId 促销条件（必填且不能为null、""），当promotionId包含normal时，调用此接口
 * @return
 public AddProductResult addPromotionProduct(String token, Long productId, Long merchantId, Long quantity, String promotionId);
 */
-(AddProductResult*)addPromotionProduct:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId quantity:(NSNumber *)quantity promotionid:(NSString*)promotionid;
/**
 * 添加landingpage促销商品到购物车
 * @param token
 * @param productId 产品id
 * @param merchantId 商家id
 * @param quantity 数量
 * @param promotionId 促销条件（必填且不能为null、""），当promotionId包含landingpage时，调用此接口
 * @return
 public AddProductResult addLandingpageProduct(String token, Long productId, Long merchantId, Long quantity, String promotionId);
 */
-(AddProductResult*)addLandingpageProduct:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId quantity:(NSNumber *)quantity promotionid:(NSString*)promotionid;




/*
 AddProductResult addLandingpageProducts(String token, List<Long> productIds, List<Long> merchantIds, List<Long> quantitys, List<String> promotionIds);

 */
-(AddProductResult*)addLandingpageProducts:(NSString *)token productIds:(NSArray *)productId merchantIds:(NSArray *)merchantId quantitys:(NSArray *)quantity promotionids:(NSArray *)promotionid;

/**
 * 添加X元Y件商品到购物车
 * @param token
 * @param productIds 产品id
 * @param merchantIds 商家id
 * @param quantitys 数量
 * @param promotionIds 促销条件（必填且不能为null、""），当promotionId包含optional时，调用此接口
 * @return
 public AddProductResult addOptionalProduct(String token,List<Long> productIds,List<Long> merchantIds, List<Long> quantitys, List<String> promotionIds);
 */
-(AddProductResult*)addOptionalProduct:(NSString *)token productIds:(NSMutableArray *)productIds merchantIds:(NSMutableArray *)merchantIds quantitys:(NSMutableArray *)quantitys promotionIds:(NSMutableArray*)promotionIds;
/**
 * 更新普通商品数量
 * @param token
 * @param productId 产品id
 * @param merchantId 商家id
 * @param quantity 数量
 * @return
 public UpdateCartResult updateNormalProductQuantity(String token, Long productId, Long merchantId, Long quantity);
 */
-(UpdateCartResult*)updateNormalProductQuantity:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId quantity:(NSNumber *)quantity ;
/**
 * 更新landingpage商品数量
 * @param token
 * @param productId 产品id
 * @param merchantId 商家id
 * @param quantity 数量
 * @return
 public UpdateCartResult updateLandingpageProductQuantity(String token, Long productId, Long merchantId, Long quantity, String promotionId);
 */
-(UpdateCartResult*)updateLandingpageProductQuantity:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId quantity:(NSNumber *)quantity promotionId:(NSString*)promotionId;
/**
 * 删除普通商品
 * @param token
 * @param productId 产品id
 * @param merchantId 商家id
 * @return
 public Integer deleteNormalProduct(String token, Long productId, Long merchantId);
 */
-(int)deleteNormalProduct:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId;
/**
 * 删除促销商品（赠品、满减、换购）
 * @param token
 * @param productId 产品id
 * @param merchantId 商家id
 * @param promotionId 促销条件（必填且不能为null、""），当promotionId包含normal时，调用此接口
 * @return
 public Integer deletePromotionProduct(String token, Long productId, Long merchantId, String promotionId);
 */
-(int)deletePromotionProduct:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId promotionId:(NSString*)promotionId;
/**
 * 删除landingpage商品
 * @param token
 * @param productId 产品id
 * @param merchantId 商家id
 * @param promotionId 促销条件（必填且不能为null、""），当promotionId包含landingpage时，调用此接口
 * @return
 public Integer deleteLandingpageProduct(String token, Long productId, Long merchantId, String promotionId);
 */
-(int)deleteLandingpageProduct:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId promotionId:(NSString*)promotionId;
/**
 * 删除X元Y件商品
 * @param token
 * @param productIds 产品id
 * @param merchantIds 商家id
 * @param quantitys 数量
 * @param promotionIds 促销条件（必填且不能为null、""），当promotionId包含optional时，调用此接口
 * @return
 public Integer deleteOptionalProduct(String token, List<Long> productIds, List<Long> merchantIds, List<Long> quantitys, List<String> promotionIds);
 */
-(int)deleteOptionalProduct:(NSString *)token productIds:(NSMutableArray *)productIds merchantIds:(NSMutableArray *)merchantIds quantitys:(NSMutableArray *)quantitys promotionIds:(NSMutableArray*)promotionIds;
/**
 * 复选框批量删除商品
 * @param token
 * @param map
 *   key1="normalProduct"，value=List<CartInputVO>，其中productId、merchantId为必填项
 *   key2="landingpageProduct"，value=List<CartInputVO>，其中productId、merchantId、promotionCondition为必填项
 * @return
 由于目前central限制，复选框批量删除商品，只能支持到删除普通商品、landingpage商品，X元Y件删除请调用deleteOptionalProduct。后续接入shopping service后再支持该功能。
 key3="optionalProduct"，value=List<CartInputVO>，其中productId、merchantId、promotionCondition、quantity为必填项
 
 public Integer deleteProducts(String token, Map<String, Object> map);
 */

/**
 * 查询购物车赠品列表
 * @param token
 * @return
 public List<MobilePromotionVO> getGiftList(String token);
 */
-(NSArray*)getGiftList:(NSString*)token;
/**
 * 查询购物车满减列表
 * @param token
 * @return
 public List<MobilePromotionVO> getCashList(String token);
 */
-(NSArray*)getCashList:(NSString*)token;

/**
 * 查询购物车换购列表
 * @param token
 * @return
 public List<MobilePromotionVO> getRedemptionList(String token);
 */
-(NSArray*)getRedemptionList:(NSString*)token;

@end
