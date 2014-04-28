//
//  ProductService.m
//  TheStoreApp
//
//  Created by linyy on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import "ProductService.h"
#import "GlobalValue.h"
#import "OTSUtility.h"

@implementation ProductService

// Page<ProductVO> getHotProductByActivityID(Trader trader, java.lang.Long activityID, java.lang.Long provinceId, java.lang.Integer currentPage, java.lang.Integer pageSize)
-(Page*)getHotProductByActivityID:(Trader *)aTrader 
                       activityID:(NSNumber*)anActivityID 
                       provinceId:(NSNumber*)aProvinceId 
                      currentPage:(NSNumber *)aCurrentPage 
                         pageSize:(NSNumber *)aPageSize
{
    MethodBody *body = [[[MethodBody alloc] init] autorelease];
    [body addObject:[aTrader toXml]];
    
    [body addLongLong:anActivityID];
    [body addLong:aProvinceId];
    [body addInteger:aCurrentPage];
    [body addInteger:aPageSize];
    
    NSObject *ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    
    if(ret!=nil && [ret isKindOfClass:[Page class]]) 
    {
        Page *po=(Page*)ret;
        return po;
    } 
        
    return nil;
}

//根据父分类获取子分类
-(Page *)getCategoryByRootCategoryId:(Trader *)trader mcsiteId:(NSNumber *)mcsiteId rootCategoryId:(NSNumber *)rootCategoryId currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:mcsiteId];
    [body addLong:rootCategoryId];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[Page class]]) {
        Page *po=(Page*)ret;
        return po;
    } else {
        return nil;
    }
}
// 从一级分类直接获取2，3级分类的新接口
-(NSArray*)getCategoryByRootCategoryId:(Trader*)trader mcsiteId:(NSNumber*)mcsiteId rootCategoryId:(NSNumber*)rootCategoryId{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:mcsiteId];
    [body addLong:rootCategoryId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}

//取得首页的热销图(废弃)
-(Page *)getHomeHotPointList:(Trader *)trader provinceId:(NSNumber *)provinceId currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:provinceId];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[Page class]]) {
        Page *po=(Page*)ret;
        return po;
    } else {
        return nil;
    }
}

//取得首页的热销图(新)
-(Page *)getHomeHotPointListNew:(Trader *)trader provinceId:(NSNumber *)provinceId currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:provinceId];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[Page class]]) {
        Page *po=(Page*)ret;
        return po;
    } else {
        return nil;
    }
}

//根据条形码获取产品详细信息
-(NSArray *)getProductByBarcode:(Trader *)trader barcode:(NSString *)barcode provinceId:(NSNumber *)provinceId
{
    if ([barcode hasPrefix:@"PID_"]) {
        NSArray *ss=[barcode componentsSeparatedByString:@"_"];
        if ([ss count]==3) {
            [[GlobalValue getGlobalValueInstance].trader setUnionKey:(NSString*)[ss objectAtIndex:1]];
        }
    } else if([barcode hasPrefix:@"BID_"]){
        NSArray *ss=[barcode componentsSeparatedByString:@"_"];
        if ([ss count]==5) {
            [[GlobalValue getGlobalValueInstance].trader setUnionKey:(NSString*)[ss objectAtIndex:1]];
        }
    }
    
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addString:barcode];
    [body addLong:provinceId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}
//获取产品详细信息-基本信息
-(ProductVO	*)getProductDetail:(Trader *)trader productId:(NSNumber *)productId provinceId:(NSNumber *)provinceId
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:productId];
    [body addLong:provinceId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[ProductVO class]]) {
        ProductVO *po=(ProductVO*)ret;
        return po;
    } else {
        return nil;
    }
}
//获取产品详细信息-基本信息
-(ProductVO	*)getProductDetail:(Trader *)trader productId:(NSNumber *)productId provinceId:(NSNumber *)provinceId promotionid:(NSString*) promotionid
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:productId];
    [body addLong:provinceId];
    [body addString:promotionid];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[ProductVO class]]) {
        ProductVO *po=(ProductVO*)ret;
        return po;
    } else {
        return nil;
    }
}
//获取产品详细信息-评论信息
-(ProductVO	*)getProductDetailComment:(Trader *)trader productId:(NSNumber *)productId provinceId:(NSNumber *)provinceId
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:productId];
    [body addLong:provinceId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[ProductVO class]]) {
        ProductVO *po=(ProductVO*)ret;
        return po;
    } else {
        return nil;
    }
}
//获取产品详细信息-描述信息
-(ProductVO	*)getProductDetailDescription:(Trader *)trader productId:(NSNumber *)productId provinceId:(NSNumber *)provinceId
{
//    MethodBody *body=[[[MethodBody alloc] init] autorelease];
//    [body addObject:[trader toXml]];
//    [body addLong:productId];
//    [body addLong:provinceId];
//    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    NSMutableDictionary* paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setDictionary: [trader toParamDict]];
    if(provinceId)
        [paramDict setObject:provinceId forKey:@"provinceId"];
    if(productId)
        [paramDict setObject:productId forKey:@"productId"];
    
    NSObject* ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) requestParameter:paramDict];
    [paramDict release];
    
    if(ret!=nil && [ret isKindOfClass:[ProductVO class]]) {
        ProductVO *po=(ProductVO*)ret;
        return po;
    } else {
        return nil;
    }
}
//取得热销排行榜
-(Page *)getPromotionProductPage:(Trader *)trader provinceId:(NSNumber *)provinceId categoryId:(NSNumber *)categoryId currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:provinceId];
    [body addLong:categoryId];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[Page class]]) {
        Page *po=(Page*)ret;
        return po;
    } else {
        return nil;
    }
}
//获取用户感兴趣的商品
-(Page *)getMoreInterestedProducts:(Trader*)trader productId:(NSNumber*)productId provinceId:(NSNumber *)provinceId currentPage:(NSNumber*)currentPage pageSize:(NSNumber*)pageSize
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:productId];
    [body addLong:provinceId];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[Page class]]) {
        Page *po=(Page*)ret;
        return po;
    } else {
        return nil;
    }
}
//获取赠品列表(用于商品详情)
-(NSArray *)getPromotionGiftList:(Trader*)trader provinceId:(NSNumber *)provinceId merchantIds:(NSArray *)merchantIds productIds:(NSArray *)productIds
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:provinceId];
    [body addArrayForLong:merchantIds];
    [body addArrayForLong:productIds];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}
//获取赠品列表(用于购物车)
-(NSArray *)getPromotionGiftList:(NSString*)token merchantIds:(NSArray *)merchantIds productIds:(NSArray *)productIds
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addArrayForLong:merchantIds];
    [body addArrayForLong:productIds];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}

//领取赠品
-(int)updateGiftProducts:(NSString *)token giftProductIdList:(NSArray *)giftProductIdList promotionIdList:(NSArray *)promotionIdList merchantIdList:(NSArray *)merchantIdList quantityList:(NSArray *)quantityList
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addArrayForLong:giftProductIdList];
    [body addArrayForString:promotionIdList];
    [body addArrayForLong:merchantIdList];
    [body addArrayForLong:quantityList];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}

-(int)updateCartPromotion:(NSString *)token giftProductIdList:(NSArray *)giftProductIdList promotionIdList:(NSArray *)promotionIdList merchantIdList:(NSArray *)merchantIdList quantityList:(NSArray *)quantityList Type:(int)promotionType{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addArrayForLong:giftProductIdList];
    [body addArrayForString:promotionIdList];
    [body addArrayForLong:merchantIdList];
    [body addArrayForLong:quantityList];
    [body addInteger:[NSNumber numberWithInt:promotionType]];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSNumber class]]) {
        NSNumber *po=(NSNumber*)ret;
        return [po intValue];
    } else {
        return 0;
    }
}
//获取1起摇商品列表 Page<RockProductVO>
-(Page *)getRockProductList:(Trader *)trader provinceId:(NSNumber *)provinceId currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:provinceId];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[Page class]]) {
        Page *po=(Page*)ret;
        return po;
    } else {
        return nil;
    }
}
//摇动手机
-(NSString *)rockRock:(Trader *)trader provinceId:(NSNumber *)provinceId promotionId:(NSString *)promotionId productId:(NSNumber *)productId lng:(NSNumber *)lng lat:(NSNumber *)lat token:(NSString *)token
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:provinceId];
    [body addString:promotionId];
    [body addLong:productId];
    [body addDouble:lng];
    [body addDouble:lat];
    
    token ? [body addToken:token] : [body addString:token];     // 避免token为nil时传递tokenIsNull引发服务器异常 -- dym
    
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSString class]]) {
        NSString *po=(NSString*)ret;
        return po;
    } else {
        return nil;
    }
}
//获取摇动手机后的匹配结果
-(RockResult *)getRockResult:(Trader *)trader provinceId:(NSNumber *)provinceId promotionId:(NSString *)promotionId productId:(NSNumber *)productId
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:provinceId];
    [body addString:promotionId];
    [body addLong:productId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[RockResult class]]) {
        RockResult *po=(RockResult*)ret;
        return po;
    } else {
        return nil;
    }
}

-(UpdateGiftResult *)updateGiftProductsV2:(NSString *)token giftProductIdList:(NSArray *)giftProductIdList promotionIdList:(NSArray *)promotionIdList merchantIdList:(NSArray *)merchantIdList quantityList:(NSArray *)quantityList
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addArrayForLong:giftProductIdList];
    [body addArrayForString:promotionIdList];
    [body addArrayForLong:merchantIdList];
    [body addArrayForLong:quantityList];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[UpdateGiftResult class]]) {
        UpdateGiftResult *po=(UpdateGiftResult *)ret;
        return po;
    } else {
        return nil;
    }
}

-(NSArray*)getProductDetailDescriptionV2:(Trader *)aTrader
                                     productId:(NSNumber *)aProductId
                                    provinceId:(NSNumber *)aProvinceId
{
//    MethodBody *body = [[[MethodBody alloc] init] autorelease];
//    [body addObject:[aTrader toXml]];
//    [body addLong:aProductId];
//    [body addLong:aProvinceId];
//    
//    NSObject *ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    
    NSMutableDictionary* paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setDictionary: [aTrader toParamDict]];
    if(aProductId)
        [paramDict setObject:aProductId forKey:@"productId"];
    if(aProvinceId)
    [paramDict setObject:aProductId forKey:@"provinceId"];
    
    NSObject* ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) requestParameter:paramDict];
    [paramDict release];
    
    if(ret && [ret isKindOfClass:[NSArray class]])
    {
        NSArray *po = (NSArray*)ret;
        return po;
    }
    
    return nil;
}

-(NSArray*)getProductDetails:(Trader *)aTrader
                  productIds:(NSArray *)productIds provinceId:(NSNumber *)provinceId
{
    MethodBody *body = [[[MethodBody alloc] init] autorelease];
    [body addObject:[aTrader toXml]];
    [body addArrayForLong:productIds];
    [body addLong:provinceId];
    
    NSObject *ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    
    if(ret && [ret isKindOfClass:[NSArray class]])
    {
        NSArray *po = (NSArray*)ret;
        return po;
    }
    
    return nil;
}

//**获取商品详情页促销活动（包含赠品、换购、满减）
-(MobilePromotion*) getMobilePromotion:(Trader *) aTrader provinceId:(NSNumber *)provinceId merchantIds:(NSArray *)merchantIds productIds:(NSArray *)productIds
{
    MethodBody *body = [[[MethodBody alloc] init] autorelease];
    [body addObject:[aTrader toXml]];
    [body addLong:provinceId];
    [body addArrayForLong:merchantIds];
    [body addArrayForLong:productIds];
    NSObject* ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[MobilePromotion class]]) {
        MobilePromotion *po=(MobilePromotion*)ret;
        return po;
    } else {
        return nil;
    }
}

//获取购物车满减活动列表
-(NSArray *)getCashPromotionList:(NSString*)token merchantIds:(NSArray *)merchantIds productIds:(NSArray *)productIds
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addArrayForLong:merchantIds];
    [body addArrayForLong:productIds];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}

//获取购物车换购活动列表
-(NSArray *)getRedemptionPromotionList:(NSString*)token merchantIds:(NSArray *)merchantIds productIds:(NSArray *)productIds;
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addToken:token];
    [body addArrayForLong:merchantIds];
    [body addArrayForLong:productIds];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}

//**首页商品促销查询详情
-(MobilePromotionDetailVO*) getPromotionDetailPageVO:(Trader *) aTrader promotionId:(NSNumber*)promotionId promotionLevelId:(NSNumber*)promotionLevelId provinceId:(NSNumber*)provinceId type:(NSNumber*)type currentPage:(NSNumber*)currentPage pageSize:(NSNumber*)pageSize token:(NSString *)token
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[aTrader toXml]];
    [body addLong:promotionId];
    [body addLong:promotionLevelId];
    [body addLong:provinceId];
    [body addInteger:type];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[MobilePromotionDetailVO class]]) {
        MobilePromotionDetailVO *po=(MobilePromotionDetailVO*)ret;
        return po;
    } else {
        return nil;
    }
}

#pragma mark 轻量接口
/**
 * 查询购物车赠品列表
 * @param token
 * @return
 public List<MobilePromotionVO> getGiftList(String token);
 */

/**
 * 查询购物车满减列表
 * @param token
 * @return
 public List<MobilePromotionVO> getCashList(String token);
 */

/**
 * 查询购物车换购列表
 * @param token
 * @return
 public List<MobilePromotionVO> getRedemptionList(String token);
 */

@end
