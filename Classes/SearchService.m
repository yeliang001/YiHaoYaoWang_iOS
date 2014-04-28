  //
//  SearchService.m
//  TheStoreApp
//
//  Created by linyy on 11-2-11.
//  Copyright 2011 vsc. All rights reserved.
//

#import "SearchService.h"
#import "OTSUtility.h"

@implementation SearchService

// 获取热门搜索关键字（暂时用）
-(NSArray*)getHomeHotElement:(Trader *)trader type:(NSNumber*)type{
//    MethodBody *body=[[[MethodBody alloc] init] autorelease];
//    [body addObject:[trader toXml]];
//    [body addInteger:type];
//    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    NSMutableDictionary* paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setDictionary:[trader toParamDict]];
    if(type)
        [paramDict setObject:type forKey:@"type"];
    
    NSObject *ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) requestParameter:paramDict];
    [paramDict release];
    
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}

//获取相关搜索关键字(不带条数，用于快速购)
-(NSArray *)getSearchKeyWord:(Trader *)trader mcsiteid:(NSNumber *)mcsiteid keyword:(NSString *)keyword
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:mcsiteid];
    [body addString:keyword];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}
//获取搜索关联关键字(带条数)
-(NSArray *)getSearchKeyword:(Trader *)trader mcsiteId:(NSNumber *)mcsiteId keyword:(NSString *)keyword provinceId:(NSNumber *)provinceId
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:mcsiteId];
    [body addString:keyword];
    [body addLong:provinceId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}
//返回按关键字搜索的产品列表(用于快速购)
-(NSArray *)searchProductForList:(Trader *)trader mcsiteidList:(NSMutableArray *)mcsiteidList provinceIdList:(NSMutableArray *)provinceIdList keywordList:(NSMutableArray *)keywordList categoryIdList:(NSMutableArray *)categoryIdList brandIdList:(NSMutableArray *)brandIdList sortTypeList:(NSMutableArray *)sortTypeList currentPageList:(NSMutableArray *)currentPageList pageSizeList:(NSMutableArray *)pageSizeList
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addArrayForLong:mcsiteidList];
    [body addArrayForLong:provinceIdList];
    [body addArrayForString:keywordList];
    [body addArrayForLong:categoryIdList];
    [body addArrayForLong:brandIdList];
    [body addArrayForInt:sortTypeList];
    [body addArrayForInt:currentPageList];
    [body addArrayForInt:pageSizeList];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}

//用户感兴趣的商品分类(用于快速购)
-(NSArray*)getUserInterestedProductsCategorys:(Trader *)trader
{
    NSMutableDictionary* paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setDictionary: [trader toParamDict]];
    NSObject* ret = [self getReturnObject:CURRENT_METHOD_NAME(_cmd) requestParameter:paramDict];
    [paramDict release];
    
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}

//热门搜索关键字(用于快速购)
-(NSArray*)getHotSearchKeywords:(Trader*)trader
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}

//热门搜索关键字(用于购物单)
-(NSArray*)getHotSearchKeywords:(Trader *)trader categoryId:(NSNumber *)categoryId
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:categoryId];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }
}
/*
 * @param filter "0"表示无, "01"表示促销, "02"表示有赠品, "03"表示新品, "012"表示促销、有赠品, "023"表示有赠品、新品, "013"表示促销、新品, "0123"表示促销、有赠品、新品 
 */
-(SearchResultVO *)searchProduct:(Trader *)trader mcsiteId:(NSNumber *)mcsiteId provinceId:(NSNumber *)provinceId keyword:(NSString *)keyword categoryId:(NSNumber *)categoryId brandId:(NSNumber *)brandId attributes:(NSString *)attributes priceRange:(NSString *)priceRange filter:(NSString *)filter sortType:(NSNumber *)sortType currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize token:(NSString *)token//已登录搜索
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:mcsiteId];
    [body addLong:provinceId];
    [body addString:keyword];
    [body addLong:categoryId];
    [body addLong:brandId];
    [body addString:attributes];
    [body addString:priceRange];
    [body addString:filter];
    [body addInteger:sortType];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[SearchResultVO class]]) {
        SearchResultVO *po=(SearchResultVO*)ret;
        return po;
    } else {
        return nil;
    }
}
-(SearchResultVO *)searchProduct:(Trader *)trader mcsiteId:(NSNumber *)mcsiteId provinceId:(NSNumber *)provinceId keyword:(NSString *)keyword categoryId:(NSNumber *)categoryId brandId:(NSNumber *)brandId attributes:(NSString *)attributes priceRange:(NSString *)priceRange filter:(NSString *)filter sortType:(NSNumber *)sortType currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize//未登录搜索
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:mcsiteId];
    [body addLong:provinceId];
    [body addString:keyword];
    [body addLong:categoryId];
    [body addLong:brandId];
    [body addString:attributes];
    [body addString:priceRange];
    [body addString:filter];
    [body addInteger:sortType];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[SearchResultVO class]]) {
        SearchResultVO *po=(SearchResultVO*)ret;
        return po;
    } else {
        return nil;
    }
}
// 未登陆搜索
-(SearchResultVO *)searchProduct:(Trader *)trader provinceId:(NSNumber *)provinceId mcsiteid:(NSNumber *)mcsiteid isDianzhongdian:(NSNumber*)isDianzhongdian searchParameterVO:(SearchParameterVO*)searchParameterVO currentPage:(NSNumber*)currentPage pageSize:(NSNumber*)pageSize
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:provinceId];
    [body addLong:mcsiteid];
    [body addInteger:isDianzhongdian];
    [body addSearchParameterVO:searchParameterVO];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[SearchResultVO class]]) {
        SearchResultVO *po=(SearchResultVO*)ret;
        return po;
    } else {
        return nil;
    }
}
// 已登陆搜索
-(SearchResultVO *)searchProduct:(Trader *)trader provinceId:(NSNumber *)provinceId mcsiteid:(NSNumber *)mcsiteid isDianzhongdian:(NSNumber*)isDianzhongdian searchParameterVO:(SearchParameterVO*)searchParameterVO currentPage:(NSNumber*)currentPage pageSize:(NSNumber*)pageSize token:(NSString*)token
{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:provinceId];
    [body addLong:mcsiteid];
    [body addInteger:isDianzhongdian];
    [body addSearchParameterVO:searchParameterVO];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[SearchResultVO class]]) {
        SearchResultVO *po=(SearchResultVO*)ret;
        return po;
    } else {
        return nil;
    }
}
#pragma mark 新搜索
-(NSArray*)searchCategorysOnly:(Trader *)trader provinceId:(NSNumber *)provinceId mcsiteid:(NSNumber *)mcsiteid isDianzhongdian:(NSNumber*)isDianzhongdian searchParameterVO:(SearchParameterVO*)searchParameterVO token:(NSString*)token{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:provinceId];
    [body addLong:mcsiteid];
    [body addInteger:isDianzhongdian];
    [body addSearchParameterVO:searchParameterVO];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[NSArray class]]) {
        NSArray *po=(NSArray*)ret;
        return po;
    } else {
        return nil;
    }

}
///**
// * 获取导购属性
// */
//public SearchResultVO searchAttributesOnly(Trader trader,Long provinceId,Long mcsiteid,int isDianzhongdian,SearchParameterVO searchParameterVO,Integer currentPage, Integer pageSize,
//                                           String token){
//
- (SearchResultVO*)searchAttributesOnly:(Trader *)trader provinceId:(NSNumber *)provinceId mcsiteid:(NSNumber *)mcsiteid isDianzhongdian:(NSNumber*)isDianzhongdian searchParameterVO:(SearchParameterVO*)searchParameterVO token:(NSString*)token{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:provinceId];
    [body addLong:mcsiteid];
    [body addInteger:isDianzhongdian];
    [body addSearchParameterVO:searchParameterVO];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[SearchResultVO class]]) {
        SearchResultVO *po=(SearchResultVO*)ret;
        return po;
    } else {
        return nil;
    }

}

//    /**
//     * 获取产品信息
//     */
//    public SearchResultVO searchProductsOnly(Trader trader,Long provinceId,Long mcsiteid,int isDianzhongdian,SearchParameterVO searchParameterVO,Integer currentPage, Integer pageSize,
//                                             String token){

- (SearchResultVO*)searchProductsOnly:(Trader *)trader provinceId:(NSNumber *)provinceId mcsiteid:(NSNumber *)mcsiteid isDianzhongdian:(NSNumber*)isDianzhongdian searchParameterVO:(SearchParameterVO*)searchParameterVO currentPage:(NSNumber*)currentPage pageSize:(NSNumber*)pageSize token:(NSString*)token{
    MethodBody *body=[[[MethodBody alloc] init] autorelease];
    [body addObject:[trader toXml]];
    [body addLong:provinceId];
    [body addLong:mcsiteid];
    [body addInteger:isDianzhongdian];
    [body addSearchParameterVO:searchParameterVO];
    [body addInteger:currentPage];
    [body addInteger:pageSize];
    [body addToken:token];
    NSObject *ret=[self getReturnObject:CURRENT_METHOD_NAME(_cmd) methodBody:body];
    if(ret!=nil && [ret isKindOfClass:[SearchResultVO class]]) {
        SearchResultVO *po=(SearchResultVO*)ret;
        return po;
    } else {
        return nil;
    }

}

@end
