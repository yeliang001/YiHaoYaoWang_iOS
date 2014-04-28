//
//  CartService.m
//  TheStoreApp
//
//  Created by linyy on 11-2-12.
//  Updated by yangxd on 11-06-29  添加了多个商品加入购物车接口
//  Copyright 2011 vsc. All rights reserved.
//

#import "CartService.h"
#import "OTSUtility.h"
#define YHD_COUNT @"YHD_COUNT"
#define MALL_COUNT @"1MALL_COUNT"
#import "GlobalValue.h"
@implementation CartService

//添加商品到购物车
-(int)addProduct:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId quantity:(NSNumber *)quantity
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:productId];
    [body addLong:merchantId];
    [body addLong:quantity];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]])
    {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}
//添加商品到购物车
-(int)addProduct:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId quantity:(NSNumber *)quantity promotionid:(NSString*)promotionid
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:productId];
    [body addLong:merchantId];
    [body addLong:quantity];
    [body addString:promotionid];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]])
    {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}
//添加多个商品到购物车
-(NSArray *)addProducts:(NSString *)token productIds:(NSMutableArray *)productIds merchantIds:(NSMutableArray *)merchantIds quantitys:(NSMutableArray *)quantitys
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addArrayForLong:productIds];
    [body addArrayForLong:merchantIds];
    [body addArrayForLong:quantitys];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}
//添加多个商品到购物车
-(NSArray *)addProducts:(NSString *)token productIds:(NSMutableArray *)productIds merchantIds:(NSMutableArray *)merchantIds quantitys:(NSMutableArray *)quantitys promotionids:(NSMutableArray*)promotionids
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addArrayForLong:productIds];
    [body addArrayForLong:merchantIds];
    [body addArrayForLong:quantitys];
    [body addArrayForString:promotionids];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}
//从购物车中删除所有商品
-(int)delAllProduct:(NSString *)token
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}


//从购物车中删除商品(部分)
-(int)delProducts:(NSString *)token productIds:(NSArray *)productIds merchantIds:(NSArray *)merchantIds promotionList:(NSArray *)promotionList
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addArrayForLong:productIds];
    [body addArrayForLong:merchantIds];
    [body addArrayForString:promotionList];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po integerValue];
    } else {
        return 0;
    }
}

//从购物车中删除商品
-(int)delProduct:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId updateType:(NSNumber *)updateType promotionid:(NSString*)promotionid
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:productId];
    [body addLong:merchantId];
    [body addInteger:updateType];
    [body addString:promotionid];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}
//获取购物车
-(CartVO *)getSessionCart:(NSString *)token
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[CartVO class]]) {
        CartVO *po=(CartVO*)ret;
        return po;
    } else {
        return nil;
    }
}
//更新购物车中产品数量
-(int)updateCartItemQuantity:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId quantity:(NSNumber *)quantity updateType:(NSNumber *)updateType
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:productId];
    [body addLong:merchantId];
    [body addLong:quantity];
    [body addInteger:updateType];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}


//更新购物车中产品数量
-(int)updateCartItemQuantity:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId quantity:(NSNumber *)quantity updateType:(NSNumber *)updateType promotionid:(NSString *) promotionid
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:productId];
    [body addLong:merchantId];
    [body addLong:quantity];
    [body addInteger:updateType];
    [body addString:promotionid];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}

/** 更新购物车活动列表*/
-(int)updateCartPromotion:(NSString *)token productIdList:(NSMutableArray *)productIdList promotionIdList:(NSMutableArray *)promotionIdList merchantIdList:(NSMutableArray *)merchantIdList quantityList:(NSMutableArray *)quantityList type:(NSNumber *)type
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addArrayForLong:productIdList];
    [body addArrayForString:promotionIdList];
    [body addArrayForLong:merchantIdList];
    [body addArrayForLong:quantityList];
    [body addInteger:type];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po integerValue];
    } else {
        return 0;
    }
}

-(AddProductResult *)addProductV2:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId quantity:(NSNumber *)quantity promotionid:(NSString*)promotionid
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:productId];
    [body addLong:merchantId];
    [body addLong:quantity];
    [body addString:promotionid];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[AddProductResult class]])
    {
        AddProductResult *po=(AddProductResult *)ret;
        return po;
    } else {
        return nil;
    }
}


-(NSArray *)addProductsV2:(NSString *)token productIds:(NSMutableArray *)productIds merchantIds:(NSMutableArray *)merchantIds quantitys:(NSMutableArray *)quantitys promotionids:(NSMutableArray*)promotionids
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addArrayForLong:productIds];
    [body addArrayForLong:merchantIds];
    [body addArrayForLong:quantitys];
    [body addArrayForString:promotionids];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}

-(UpdateCartResult *)updateCartItemQuantityV2:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId quantity:(NSNumber *)quantity updateType:(NSNumber *)updateType promotionId:(NSString *)promotionId
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:productId];
    [body addLong:merchantId];
    [body addLong:quantity];
    [body addInteger:updateType];
    [body addString:promotionId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[UpdateCartResult class]]) {
        UpdateCartResult *po=(UpdateCartResult*)ret;
        return po;
    } else {
        return nil;
    }
}

//* <h2>添加n元n件活动到购物车</h2>
-(NormResult *)addOptional:(NSString *)token promotionIds:(NSMutableArray *)promotionIds promotionLevelIDs:(NSMutableArray *)promotionLevelIDs productIds:(NSMutableArray *)productIds promotionGiftMerchantIDs:(NSMutableArray *)promotionGiftMerchantIDs promotionGiftNums:(NSMutableArray *)promotionGiftNums
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addArrayForLong:promotionIds];
    [body addArrayForLong:promotionLevelIDs];
    [body addArrayForLong:productIds];
    [body addArrayForLong:promotionGiftMerchantIDs];
    [body addArrayForInt:promotionGiftNums];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NormResult class]]) {
        NormResult *po=(NormResult*)ret;
        return po;
    } else {
        return nil;
    }
}

//* <h2>删除购物车中的n元n件活动</h2>
-(NormResult *)deleteOptional:(NSString *)token promotionIds:(NSMutableArray *)promotionIds promotionLevelIDs:(NSMutableArray *)promotionLevelIDs productIds:(NSMutableArray *)productIds promotionGiftMerchantIDs:(NSMutableArray *)promotionGiftMerchantIDs promotionGiftNums:(NSMutableArray *)promotionGiftNums
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addArrayForLong:promotionIds];
    [body addArrayForLong:promotionLevelIDs];
    [body addArrayForLong:productIds];
    [body addArrayForLong:promotionGiftMerchantIDs];
    [body addArrayForInt:promotionGiftNums];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NormResult class]]) {
        NormResult *po=(NormResult*)ret;
        return po;
    } else {
        return nil;
    }
}
-(AddOrDeletePromotionResult*)deleteOptional:(NSString*)token optionalPromotionInCartVO:(OptionalPromotionInCartVO*)aoptionalPromotionInCartVO{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addObject:[aoptionalPromotionInCartVO toXML]];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[AddOrDeletePromotionResult class]]) {
        AddOrDeletePromotionResult *po=(AddOrDeletePromotionResult*)ret;
        return po;
    } else {
        return nil;
    }
}

//* <h2>查询购物车中是否存在指定的n元n件活动</h2>
-(NormResult *)isExistOptionalInCart:(NSString *)token provinceId:(NSNumber*)provinceId promotionId:(NSNumber*)promotionId promotionLevelId:(NSNumber*)promotionLevelId
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:provinceId];
    [body addLong:promotionId];
    [body addLong:promotionLevelId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NormResult class]]) {
        NormResult *po=(NormResult*)ret;
        return po;
    } else {
        return nil;
    }
}

// * <h2>替换n元n件活动到购物车</h2>
-(NormResult *)updateOptional:(NSString *) token promotionIds:(NSMutableArray*)promotionIds promotionLevelIDs:(NSMutableArray*)promotionLevelIDs productIds:(NSMutableArray*)productIds promotionGiftMerchantIDs:(NSMutableArray*)promotionGiftMerchantIDs promotionGiftNums:(NSMutableArray*)promotionGiftNums
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addArrayForLong:promotionIds];
    [body addArrayForLong:promotionLevelIDs];
    [body addArrayForLong:productIds];
    [body addArrayForLong:promotionGiftMerchantIDs];
    [body addArrayForInt:promotionGiftNums];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NormResult class]]) {
        NormResult *po=(NormResult*)ret;
        return po;
    } else {
        return nil;
    }
}

/**
 *秒杀检查库存
 * @prarm  token
 * @param  productId       产品编号
 * @param  merchantOrderId 商户订单ID
 * @param  provinceId
 * @return 检查库存
 */

-(SeckillResultVO *) preSeckillProduct:(NSString *) token provinceId:(NSNumber*) provinceId promotionId:(NSString *) promotionId productId:(NSNumber*) productId
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:provinceId];
    [body addString:promotionId];
    [body addLong:productId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[SeckillResultVO class]])
    {
        SeckillResultVO *po=(SeckillResultVO *)ret;
        return po;
    } else {
        return nil;
    }
}


/**
 * 秒杀功能
 * @prarm  token
 * @param  productId       产品编号
 * @param  merchantOrderId 商户订单ID
 * @param  provinceId
 * @return 空表示秒杀不成功 其他成功添加购物车
 */
-(SeckillResultVO *) seckillProduct:(NSString *) token provinceId:(NSNumber*) provinceId promotionId:(NSString *) promotionId productId:(NSNumber*) productId;
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:provinceId];
    [body addString:promotionId];
    [body addLong:productId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[SeckillResultVO class]])
    {
        SeckillResultVO *po=(SeckillResultVO *)ret;
        return po;
    } else {
        return nil;
    }
}

/**
 * 检查商品是否为秒杀，如果为秒杀商品则返回活动开始结束时间和商品是否可以秒杀
 * @param promotionId
 * @param provinceId
 * @param productId
 * @return CheckSecKillResult
 */
-(CheckSecKillResult*) checkIfSecKill:(Trader *) trader promotionId:(NSString *)promotionId provinceId:(NSNumber *) provinceId productId:(NSNumber *)productId
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addString:promotionId];
    [body addLong:provinceId];
    [body addLong:productId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[CheckSecKillResult class]])
    {
        CheckSecKillResult *po=(CheckSecKillResult *)ret;
        return po;
    } else {
        return nil;
    }
}

/**
 * 检查一列landingpage促销商品是否为秒杀
 * @param promotionIdList
 * @param productIdList
 * @param provinceId
 * @return
 */
-(NSArray *) checkIfSecKillForList:(Trader*) trader promotionIdList:(NSMutableArray *) promotionIdList productIdList:(NSMutableArray *)productIdList provinceId:(NSNumber *) provinceId
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addArrayForString:promotionIdList];
    [body addArrayForLong:productIdList];
    [body addLong:provinceId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}


#pragma mark - 购物车轻量接口

-(AddProductResult*)addSingleProduct:(NSString*)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId quantity:(NSNumber *)quantity promotionid:(NSString*)promotionid{
    AddProductResult*result=nil;
    if ([promotionid isEqualToString:@""]||promotionid==nil) {
       result=[self addNormalProduct:token productId:productId merchantId:merchantId quantity:quantity];
        return result;
    }else{
        if ([promotionid rangeOfString:@"landingpage"].location!=NSNotFound) {
            result=[self addLandingpageProduct:token productId:productId merchantId:merchantId quantity:quantity promotionid:promotionid];
            return result;
        }else if([promotionid rangeOfString:@"normal"].location!=NSNotFound){
            result=[self addPromotionProduct:token productId:productId merchantId:merchantId quantity:quantity promotionid:promotionid];
            return result;
        }
    }
    return nil;
}


-(int)deleteSingleProduct:(NSString*)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId  promotionid:(NSString*)promotionid{
    int result=0;
    if ([promotionid isEqualToString:@""]||promotionid==nil) {
        result=[self deleteNormalProduct:token productId:productId merchantId:merchantId];
    }else{
        if ([promotionid rangeOfString:@"normal"].location!=NSNotFound) {
            result=[self deletePromotionProduct:token productId:productId merchantId:merchantId promotionId:promotionid];
        }
        if ([promotionid rangeOfString:@"landingpage"].location!=NSNotFound) {
            result=[self deleteLandingpageProduct:token productId:productId merchantId:merchantId promotionId:promotionid];
        }
    }
    return result;
}

-(int)countSessionCart:(NSString*)token siteType:(NSNumber*)type{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addInteger:type];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSMutableDictionary class]]) {
        NSDictionary*po=(NSDictionary*)ret;
        return [[po valueForKey:YHD_COUNT] intValue];
    }
    return 0;
}
/**
 * 添加普通商品到购物车
 * @param token
 * @param productId 产品id
 * @param merchantId 商家id
 * @param quantity 数量
 * @return
public AddProductResult addNormalProduct(String token, Long productId, Long merchantId, Long quantity);
 */
-(AddProductResult*)addNormalProduct:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId quantity:(NSNumber *)quantity {
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:productId];
    [body addLong:merchantId];
    [body addLong:quantity];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[AddProductResult class]])
    {
        AddProductResult *po=(AddProductResult*)ret;
        return po ;
    } else {
        return nil;
    }
}

/**
 * 批量添加普通商品到购物车
 * @param token
 * @param productIds 产品id
 * @param merchantIds 商家id
 * @param quantitys 数量
 * @return
public AddProductResult addNormalProducts(String token,List<Long> productIds,List<Long> merchantIds, List<Long> quantitys);
 */
-(AddProductResult*)addNormalProducts:(NSString *)token productIds:(NSMutableArray *)productIds merchantIds:(NSMutableArray *)merchantIds quantitys:(NSMutableArray *)quantitys{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addArrayForLong:productIds];
    [body addArrayForLong:merchantIds];
    [body addArrayForLong:quantitys];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[AddProductResult class]]) {
        AddProductResult *po=(AddProductResult*)ret;
        return po;
    } else {
        return nil;
    }
}

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
-(AddProductResult*)addPromotionProduct:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId quantity:(NSNumber *)quantity promotionid:(NSString*)promotionid{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:productId];
    [body addLong:merchantId];
    [body addLong:quantity];
    [body addString:promotionid];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[AddProductResult class]])
    {
        AddProductResult *po=(AddProductResult*)ret;
        return po ;
    } else {
        return nil;
    }
}

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
-(AddProductResult*)addLandingpageProduct:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId quantity:(NSNumber *)quantity promotionid:(NSString*)promotionid{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:productId];
    [body addLong:merchantId];
    [body addLong:quantity];
    [body addString:promotionid];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[AddProductResult class]])
    {
        AddProductResult *po=(AddProductResult*)ret;
        return po ;
    } else {
        return nil;
    }
}

-(AddProductResult*)addLandingpageProducts:(NSString *)token productIds:(NSArray *)productIds merchantIds:(NSArray *)merchantIds quantitys:(NSArray *)quantitys promotionids:(NSArray *)promotionIds{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addArrayForLong:productIds];
    [body addArrayForLong:merchantIds];
    [body addArrayForLong:quantitys];
    [body addArrayForString:promotionIds];
    NSObject *ret=[self:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[AddProductResult class]]) {
        AddProductResult *po=(AddProductResult*)ret;
        return po;
    } else {
        return nil;
    }
}
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
-(AddProductResult*)addOptionalProduct:(NSString *)token productIds:(NSMutableArray *)productIds merchantIds:(NSMutableArray *)merchantIds quantitys:(NSMutableArray *)quantitys promotionIds:(NSMutableArray*)promotionIds{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addArrayForLong:productIds];
    [body addArrayForLong:merchantIds];
    [body addArrayForLong:quantitys];
    [body addArrayForString:promotionIds];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[AddProductResult class]]) {
        AddProductResult *po=(AddProductResult*)ret;
        return po;
    } else {
        return nil;
    }
}

/**
 * 更新普通商品数量
 * @param token
 * @param productId 产品id
 * @param merchantId 商家id
 * @param quantity 数量
 * @return
public UpdateCartResult updateNormalProductQuantity(String token, Long productId, Long merchantId, Long quantity);
 */
-(UpdateCartResult*)updateNormalProductQuantity:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId quantity:(NSNumber *)quantity {
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:productId];
    [body addLong:merchantId];
    [body addLong:quantity];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[UpdateCartResult class]])
    {
        UpdateCartResult *po=(UpdateCartResult*)ret;
        return po ;
    } else {
        return nil;
    }
}
/**
 * 更新landingpage商品数量
 * @param token
 * @param productId 产品id
 * @param merchantId 商家id
 * @param quantity 数量
 * @return
public UpdateCartResult updateLandingpageProductQuantity(String token, Long productId, Long merchantId, Long quantity, String promotionId);
 */
-(UpdateCartResult*)updateLandingpageProductQuantity:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId quantity:(NSNumber *)quantity promotionId:(NSString*)promotionId{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:productId];
    [body addLong:merchantId];
    [body addLong:quantity];
    [body addString:promotionId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[UpdateCartResult class]])
    {
        UpdateCartResult *po=(UpdateCartResult*)ret;
        return po ;
    } else {
        return nil;
    }
}
/**
 * 删除普通商品
 * @param token
 * @param productId 产品id
 * @param merchantId 商家id
 * @return
public Integer deleteNormalProduct(String token, Long productId, Long merchantId);
 */
-(int)deleteNormalProduct:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId{
        MethodBody *body=[[[MethodBody alloc] init] autorelease];
        [body addToken:token];
        [body addLong:productId];
        [body addLong:merchantId];
        NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
        if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
            NSNumber *po=(NSNumber*)ret;
            return [po intValue];
        } else {
            return 0;
        }
}
/**
 * 删除促销商品（赠品、满减、换购）
 * @param token
 * @param productId 产品id
 * @param merchantId 商家id
 * @param promotionId 促销条件（必填且不能为null、""），当promotionId包含normal时，调用此接口
 * @return
public Integer deletePromotionProduct(String token, Long productId, Long merchantId, String promotionId);
 */
-(int)deletePromotionProduct:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId promotionId:(NSString*)promotionId{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:productId];
    [body addLong:merchantId];
    [body addString:promotionId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}
/**
 * 删除landingpage商品
 * @param token
 * @param productId 产品id
 * @param merchantId 商家id
 * @param promotionId 促销条件（必填且不能为null、""），当promotionId包含landingpage时，调用此接口
 * @return
public Integer deleteLandingpageProduct(String token, Long productId, Long merchantId, String promotionId);
 */
-(int)deleteLandingpageProduct:(NSString *)token productId:(NSNumber *)productId merchantId:(NSNumber *)merchantId promotionId:(NSString*)promotionId{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addLong:productId];
    [body addLong:merchantId];
    [body addString:promotionId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}

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
-(int)deleteOptionalProduct:(NSString *)token productIds:(NSMutableArray *)productIds merchantIds:(NSMutableArray *)merchantIds quantitys:(NSMutableArray *)quantitys promotionIds:(NSMutableArray*)promotionIds{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addArrayForLong:productIds];
    [body addArrayForLong:merchantIds];
    [body addArrayForLong:quantitys];
    [body addArrayForString:promotionIds];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return nil;
    }
}
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
-(NSArray*)getGiftList:(NSString*)token{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    }else{
        return nil;
    }
}
/**
 * 查询购物车满减列表
 * @param token
 * @return
 public List<MobilePromotionVO> getCashList(String token);
 */
-(NSArray*)getCashList:(NSString*)token{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    }else{
        return nil;
    }
}

/**
 * 查询购物车换购列表
 * @param token
 * @return
 public List<MobilePromotionVO> getRedemptionList(String token);
 */
-(NSArray*)getRedemptionList:(NSString*)token{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    }else{
        return nil;
    }
}


@end
