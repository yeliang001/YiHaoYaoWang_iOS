//
//  SearchService.h
//  TheStoreApp
//
//  Created by linyy on 11-2-11.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheStoreService.h"
#import "Trader.h"
#import "MethodBody.h"
#import "Page.h"
#import "SearchResultVO.h"
#import "SearchParameterVO.h"

@interface SearchService:TheStoreService {	
}
/**
 * <h2>获取首页热门分类(关键字)</h2><br/>
 * <br/>
 * 功能点：1号店首页<br/>
 * 异常：服务器错误;Trader错误;<br/>
 * 返回：List<FacetValue><br/>
 * 必填参数：Trader, type<br/>
 * 返回值：FacetValue.id, FacetValue.name<br/>
 * @param trader
 * @param type 1表示热门分类 2表示热门关键字
 * @return 返回首页热门分类(关键字)
 */
-(NSArray*)getHomeHotElement:(Trader *)trader
                        type:(NSNumber*)type;
//获取相关搜索关键字(不带条数，用于快速购)
-(NSArray *)getSearchKeyWord:(Trader *)trader mcsiteid:(NSNumber *)mcsiteid keyword:(NSString *)keyword;
//获取搜索关联关键字(带条数)
-(NSArray *)getSearchKeyword:(Trader *)trader mcsiteId:(NSNumber *)mcsiteId keyword:(NSString *)keyword provinceId:(NSNumber *)provinceId;
//返回按关键字搜索的产品列表(用于快速购)
-(NSArray *)searchProductForList:(Trader *)trader mcsiteidList:(NSMutableArray *)mcsiteidList provinceIdList:(NSMutableArray *)provinceIdList keywordList:(NSMutableArray *)keywordList categoryIdList:(NSMutableArray *)categoryIdList brandIdList:(NSMutableArray *)brandIdList sortTypeList:(NSMutableArray *)sortTypeList currentPageList:(NSMutableArray *)currentPageList pageSizeList:(NSMutableArray *)pageSizeList;
//用户感兴趣的商品分类(用于快速购)
-(NSArray*)getUserInterestedProductsCategorys:(Trader *)trader;
//热门搜索关键字(用于快速购)
-(NSArray*)getHotSearchKeywords:(Trader*)trader;
//热门搜索关键字(用于购物单)
-(NSArray*)getHotSearchKeywords:(Trader *)trader categoryId:(NSNumber *)categoryId;
/*
 * @param filter "0"表示无, "01"表示促销, "02"表示有赠品, "03"表示新品, "012"表示促销、有赠品, "023"表示有赠品、新品, "013"表示促销、新品, "0123"表示促销、有赠品、新品 
 */

/**
 * <h2>登录状态下，根据搜索条件查询商品列表、筛选条件（包括品牌、导购属性、价格区间）</h2>
 * <br/>
 * 功能点：产品搜索列表页;<br/>
 * 异常：服务器错误;Trader错误;<br/>
 * 返回：SearchVO<br/>
 * 必填参数：trader,mcsiteid,provinceId,sortType,currentPage,pageSize,token<br/> 
 * 返回值：SearchResultVO
 * @param trader
 * @param mcsiteid 1表示1号店，2表示药网
 * @param provinceId 省份id
 * @param keyword 搜索关键字，""表示无
 * @param categoryId 分类id，0表示全部分类
 * @param brandId 品牌id，0表示无
 * @param attributes 导购属性，""表示无，多个导购属性用,隔开
 * @param priceRange 价格区间，""表示无，"10,100"表示10到100元，"10,"表示大于10，",100"表示小于100
 * @param filter "0"表示无，"01"表示促销，"02"表示有赠品，"03"表示新品，"012"表示促销、有赠品，
 * "023"表示有赠品、新品，"013"表示促销、新品，"0123"表示促销、有赠品、新品
 * @param sortType 0:不排序,1:按相关性排序,2:按销量倒序,3:按价格升序,4:按价格倒序,5:按好评度倒序,6:按上架时间倒序
 * @param currentPage 分页参数：当前页
 * @param pageSize 分页参数：每页显示条数
 * @param token 登录后的token
 * @return 返回商品列表、筛选条件
 */
-(SearchResultVO *)searchProduct:(Trader *)trader mcsiteId:(NSNumber *)mcsiteId provinceId:(NSNumber *)provinceId keyword:(NSString *)keyword categoryId:(NSNumber *)categoryId brandId:(NSNumber *)brandId attributes:(NSString *)attributes priceRange:(NSString *)priceRange filter:(NSString *)filter sortType:(NSNumber *)sortType currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize token:(NSString *)token;//已登录搜索


/**
 * <h2>未登录状态下，根据搜索条件查询商品列表、筛选条件（包括品牌、导购属性、价格区间）</h2>
 * <br/>
 * 功能点：产品搜索列表页;<br/>
 * 异常：服务器错误;Trader错误;<br/>
 * 返回：SearchVO<br/>
 * 必填参数：trader,mcsiteid,provinceId,sortType,currentPage,pageSize,token<br/> 
 * 返回值：SearchResultVO
 * @param trader
 * @param mcsiteid 1表示1号店，2表示药网
 * @param provinceId 省份id
 * @param keyword 搜索关键字，""表示无
 * @param categoryId 分类id，0表示全部分类
 * @param brandId 品牌id，0表示无
 * @param attributes 导购属性，""表示无，多个导购属性用,隔开
 * @param priceRange 价格区间，""表示无，"10,100"表示10到100元，"10,"表示大于10，",100"表示小于100
 * @param filter "0"表示无，"01"表示促销，"02"表示有赠品，"03"表示新品，"012"表示促销、有赠品，
 * "023"表示有赠品、新品，"013"表示促销、新品，"0123"表示促销、有赠品、新品
 * @param sortType 0:不排序,1:按相关性排序,2:按销量倒序,3:按价格升序,4:按价格倒序,5:按好评度倒序,6:按上架时间倒序
 * @param currentPage 分页参数：当前页
 * @param pageSize 分页参数：每页显示条数
 * @return 返回商品列表、筛选条件
 */
-(SearchResultVO *)searchProduct:(Trader *)trader mcsiteId:(NSNumber *)mcsiteId provinceId:(NSNumber *)provinceId keyword:(NSString *)keyword categoryId:(NSNumber *)categoryId brandId:(NSNumber *)brandId attributes:(NSString *)attributes priceRange:(NSString *)priceRange filter:(NSString *)filter sortType:(NSNumber *)sortType currentPage:(NSNumber *)currentPage pageSize:(NSNumber *)pageSize;//未登录搜索

/**搜索（未登陆）
 * <h2>根据搜索条件查询商品列表、筛选条件（包括品牌、导购属性、价格区间）、促销活动ID</h2>
 * <br/>
 * 功能点：产品搜索列表页;<br/>
 * 异常：服务器错误;Trader错误;<br/>
 * 返回：SearchVO<br/>
 * 必填参数：trader,mcsiteid,provinceId,sortType,currentPage,pageSize,token<br/>
 * 返回值：SearchResultVO
 * @param trader
 * @param provinceId 省份id
 * @param mcsiteid 1-1号店，2-药网
 * @param isDianzhongdian 1-店中店商品,2-1号店商品,0-所有商品
 * @param searchParameterVO 搜索参数VO
 * @param currentPage 分页参数：当前页
 * @param pageSize 分页参数：每页显示条数
 * @return 返回商品列表、筛选条件
 */
-(SearchResultVO *)searchProduct:(Trader *)trader provinceId:(NSNumber *)provinceId mcsiteid:(NSNumber *)mcsiteid isDianzhongdian:(NSNumber*)isDianzhongdian searchParameterVO:(SearchParameterVO*)searchParameterVO currentPage:(NSNumber*)currentPage pageSize:(NSNumber*)pageSize;
/**搜索（已登录）
 * <h2>根据搜索条件查询商品列表、筛选条件（包括品牌、导购属性、价格区间）、促销活动ID</h2>
 * <br/>
 * 功能点：产品搜索列表页;<br/>
 * 异常：服务器错误;Trader错误;<br/>
 * 返回：SearchVO<br/>
 * 必填参数：trader,mcsiteid,provinceId,sortType,currentPage,pageSize<br/>
 * 返回值：SearchResultVO
 * @param trader
 * @param provinceId 省份id
 * @param mcsiteid 1-1号店，2-药网
 * @param isDianzhongdian 1-店中店商品,2-1号店商品,0-所有商品
 * @param searchParameterVO 搜索参数VO
 * @param currentPage 分页参数：当前页
 * @param pageSize 分页参数：每页显示条数
 * @param token 登录后的token
 * @return 返回商品列表、筛选条件
 */
-(SearchResultVO *)searchProduct:(Trader *)trader provinceId:(NSNumber *)provinceId mcsiteid:(NSNumber *)mcsiteid isDianzhongdian:(NSNumber*)isDianzhongdian searchParameterVO:(SearchParameterVO*)searchParameterVO currentPage:(NSNumber*)currentPage pageSize:(NSNumber*)pageSize token:(NSString*)token;
#pragma mark -新接口
 /**
 * 调用搜索接口，仅返回类目树
 * @param trader
 * @param provinceId
 * @param mcsiteid
 * @param isDianzhongdian
 * @param searchParameterVO
 * @param currentPage
 * @param pageSize
 * @param token
 * @return
 */

//public List<SearchCategoryVO> searchCategorysOnly(Trader trader,Long provinceId,Long mcsiteid,int isDianzhongdian,SearchParameterVO searchParameterVO,Integer currentPage, Integer pageSize,
//                                                  String token){……}
//
- (NSArray*)searchCategorysOnly:(Trader *)trader provinceId:(NSNumber *)provinceId mcsiteid:(NSNumber *)mcsiteid isDianzhongdian:(NSNumber*)isDianzhongdian searchParameterVO:(SearchParameterVO*)searchParameterVO token:(NSString*)token;
///**
// * 获取导购属性
// */
//public SearchResultVO searchAttributesOnly(Trader trader,Long provinceId,Long mcsiteid,int isDianzhongdian,SearchParameterVO searchParameterVO,Integer currentPage, Integer pageSize,
//                                           String token){
//
- (SearchResultVO*)searchAttributesOnly:(Trader *)trader provinceId:(NSNumber *)provinceId mcsiteid:(NSNumber *)mcsiteid isDianzhongdian:(NSNumber*)isDianzhongdian searchParameterVO:(SearchParameterVO*)searchParameterVO token:(NSString*)token;

//    /**
//     * 获取产品信息
//     */
//    public SearchResultVO searchProductsOnly(Trader trader,Long provinceId,Long mcsiteid,int isDianzhongdian,SearchParameterVO searchParameterVO,Integer currentPage, Integer pageSize,
//                                             String token){

- (SearchResultVO*)searchProductsOnly:(Trader *)trader provinceId:(NSNumber *)provinceId mcsiteid:(NSNumber *)mcsiteid isDianzhongdian:(NSNumber*)isDianzhongdian searchParameterVO:(SearchParameterVO*)searchParameterVO currentPage:(NSNumber*)currentPage pageSize:(NSNumber*)pageSize token:(NSString*)token;


@end
