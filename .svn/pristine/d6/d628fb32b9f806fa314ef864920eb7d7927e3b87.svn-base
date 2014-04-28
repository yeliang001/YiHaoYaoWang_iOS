//
//  OTSServiceHelper.h
//  TheStoreApp
//
//  Created by yiming dong on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  Description: === wrapper class for server interface ===

#import <Foundation/Foundation.h>

@class UserVO;
@class VerifyCodeVO;
@class LocationVO;
@class SyncVO;
@class StatusVO;
@class LocalCartItemVO;
@class GoodReceiverVO;
@class RockResult;
@class SearchResultVO;
@class ProductVO;
@class CartVO;
@class InnerMessageVO;
@class OrderV2;
@class OrderVO;
@class SavePayByAccountResult;
@class CheckSmsResult;
@class SendValidCodeResult;
@class NeedCheckResult;
@class GrouponVO;
@class GrouponOrderVO;
@class GrouponOrderSubmitResult;
@class Page;
@class DownloadVO;
@class Trader;
@class AddProductResult;
@class UpdateCartResult;
@class CouponCheckResult;
@class UpdateGiftResult;
@class SubmitOrderResult;
@class SaveGateWayToOrderResult;
@class CreateOrderResult;
@class AdvertisingPromotion;

#pragma mark - 获得单例
@interface OTSServiceHelper : NSObject
{
    NSArray*        serviceClasses;
    Class           theRespondClass;
}
+ (OTSServiceHelper *)sharedInstance;   // 获得单例
@end


#pragma mark - CentralMobileFacadeService
@interface  OTSServiceHelper (CentralMobileFacadeService)
-(int)registerLaunchInfo:(Trader *)trader iMei:(NSString *)iMei phoneNo:(NSString *)phoneNo;                        // 客户端启动注册消息
@end


#pragma mark - UserService
@interface OTSServiceHelper (UserService)

//切换省份
-(int)changeProvince:(NSString *)token 
          provinceId:(NSNumber *)provinceId;

//找回密码
-(int)findPasswordByEmail:(Trader *)trader 
                emailname:(NSString *)emailname 
               verifycode:(NSString *)verifycode 
                tempToken:(NSString *)tempToken;

//获取我的1号店用户信息
-(UserVO *)getMyYihaodianSessionUser:(NSString *)token;

//获取用户信息
-(UserVO *)getSessionUser:(NSString *)token;

//返回一个验证码url
-(VerifyCodeVO *)getVerifyCodeUrl:(Trader *)trader;

//用户登录并返回用户信息
-(NSString *)login:(Trader *)trader 
        provinceId:(NSNumber *)provinceId 
          username:(NSString *)username 
          password:(NSString *)password;

//退出登录
-(int)logout:(NSString *)token;

//修改用户密码
-(int)modifyPassword:(NSString *)token 
            username:(NSString *)username 
         oldpassword:(NSString *)oldpassword 
         newpassword:(NSString *)newpassword;

//用户注册
-(int)registerAct:(Trader *)trader 
         username:(NSString *)username 
         password:(NSString *)password 
       verifycode:(NSString *)verifycode 
        tempToken:(NSString *)tempToken;

-(NSString *)unionLogin:(Trader *)trader 
             provinceId:(NSNumber *)provinceId 
               userName:(NSString *)userName 
           realUserName:(NSString *)realUserName 
                 cocode:(NSString *)cocode;

-(NSArray *)updateCartProductUnlogin:(Trader *)trader 
                          productIds:(NSArray *)productIds 
                         merchantIds:(NSArray *)merchantIds 
                          provinceId:(NSNumber *)provinceId;
@end


#pragma mark - MicroBlogService
@interface OTSServiceHelper (MicroBlogService)
-(int)shareCheck:(NSString *)userName 
        password:(NSString *)password 
        targetId:(long)targetId;//返回结果0为失败，1为成功

-(void)sharePublish:(NSString *)userName 
           password:(NSString *)password 
           targetId:(long)targetId 
            comment:(NSString *)comment 
               guid:(NSString *)guid 
              syncs:(NSString *)syncs;

-(int)saveShow:(NSString *)aid 
      userName:(NSString *)u 
     orderCode:(NSString *)oid 
     productId:(NSString *)pid 
    merchantId:(NSString *)mid 
   pronvinceId:(NSString *)vid 
          gpsX:(NSString *)gx 
          gpsY:(NSString *)gy 
      targetId:(NSString *)tid 
        fromId:(NSString *)fid;

-(int)exists:(NSString *)aid 
    userName:(NSString *)u 
   orderCode:(NSString *)oid 
   productId:(NSString *)pid 
 pronvinceId:(NSString *)vid;

-(LocationVO *)locations:(NSString *)userName 
                password:(NSString *)password 
                targetId:(long)targetId 
                 pageNum:(long)pageNum 
                   count:(long)count 
                   query:(NSString *)query 
                    city:(NSString *)city 
                     lon:(float)lon 
                     lat:(float)lat;//用户名 必填，密码 必填，微博类型 1-新浪 3-街旁 必填，
//页码 非必填，每页记录数 非必填，查询关键字 必填，地区 非必填，经度 必填，纬度 必填

-(SyncVO *)syncs:(NSString *)userName 
        password:(NSString *)password 
        targetId:(long)targetId;

-(StatusVO *)checkin:(NSString *)userName 
            password:(NSString *)password 
            targetId:(long)targetId 
             comment:(NSString *)comment 
                guid:(NSString *)guid 
               syncs:(NSString *)syncs;
@end


#pragma mark - LocalCartService
@interface OTSServiceHelper (LocalCartService)
-(NSData *)generateASingleTipWithLocalCartItemVO:(LocalCartItemVO *)aLocalTipVO;		// 创建本地购物车

-(void)appendToExistsFileWithFilePath:(NSString *)aFilePath 
                                 item:(LocalCartItemVO *)aLocalTipVO;	// 添加一条商品信息

-(int)getLocalCartNumberWithFilePath:(NSString *)aFilePath;				// 获取本地所有商品总数

-(float)getLocalCartTotalPriceWithFilePath:(NSString *)aFilePath;		// 获取本地所有商品总价

-(void)cleanLocalCartWithFilePath:(NSString *)aFilePath;			// 清空本地购物车

-(void)deleteLocalCartWithFilePath:(NSString *)aFilePath 
                              item:(LocalCartItemVO *)aLocalTipVO;		// 删除一条商品信息

-(void)deleteLocalCartWithFilePath:(NSString *)aFilePath 
                         productId:(NSNumber *)productId;

-(void)updateLocalCartWithFilePath:(NSString *)aFilePath 
                              item:(LocalCartItemVO *)aLocalTipVO;		// 更新一条商品信息

-(NSMutableArray *)getLocalCartArrayWithFilePath:(NSString *)aFilePath;			// 获取本地购物车信息

-(void)cleanLocalCartArray;		// 清空本地商品数组

-(NSMutableArray *)getLocalCartProductIdsWithFilePath:(NSString *)aFilePath;

-(NSMutableArray *)getLocalCartMerchantIdsWithFilePath:(NSString *)aFilePath;

-(void)changeLocalCartWithFilePath:(NSString *)aFilePath 
                     productVOList:(NSArray *)productVOList;
@end

#pragma mark - AddressService
@interface OTSServiceHelper (AddressService)
//删除收获地址
-(int)deleteGoodReceiverByToken:(NSString *)token 
                 goodReceiverId:(NSNumber *)goodReceiverId;

//获取1号店支持的所有的省份
-(NSArray *)getAllProvince:(Trader *)trader;

//根据省份ID，获取1号店支持的所有的市/区县
-(NSArray *)getCityByProvinceId:(Trader *)trader 
                     provinceId:(NSNumber *)provinceId;

//根据市/区县ID，获取1号店支持的所有的地区
-(NSArray *)getCountyByCityId:(Trader *)trader 
                       cityId:(NSNumber *)cityId;

//获取所有的收货地址列表
-(NSArray *)getGoodReceiverListByToken:(NSString *)token;

//添加新的收获地址
-(int)insertGoodReceiverByToken:(NSString *)token 
                 goodReceiverVO:(GoodReceiverVO *)goodReceiverVO;

//更新收货地址信息
-(int)updateGoodReceiverByToken:(NSString *)token 
                 goodReceiverVO:(GoodReceiverVO *)goodReceiverVO;

-(int)insertGoodReceiverByToken:(NSString *)token 
                 goodReceiverVO:(GoodReceiverVO *)goodReceiverVO 
                           lngs:(NSArray *)lngs 
                           lats:(NSArray *)lats;

-(int)updateGoodReceiverByToken:(NSString *)token 
                 goodReceiverVO:(GoodReceiverVO *)goodReceiverVO 
                           lngs:(NSArray *)lngs 
                           lats:(NSArray *)lats;
@end

#pragma mark - ProductService
@interface OTSServiceHelper (ProductService)

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

//取得首页的热销图(废弃)
-(Page *)getHomeHotPointList:(Trader *)trader 
                  provinceId:(NSNumber *)provinceId 
                 currentPage:(NSNumber *)currentPage 
                    pageSize:(NSNumber *)pageSize;

//取得首页的热销图(新)
-(Page *)getHomeHotPointListNew:(Trader *)trader 
                  provinceId:(NSNumber *)provinceId 
                 currentPage:(NSNumber *)currentPage 
                    pageSize:(NSNumber *)pageSize;

//根据条形码获取产品详细信息
-(NSArray *)getProductByBarcode:(Trader *)trader 
                        barcode:(NSString *)barcode 
                     provinceId:(NSNumber *)provinceId;

//获取产品详细信息-基本信息
-(ProductVO	*)getProductDetail:(Trader *)trader 
                     productId:(NSNumber *)productId 
                    provinceId:(NSNumber *)provinceId;

//获取产品详细信息-基本信息
-(ProductVO	*)getProductDetail:(Trader *)trader 
                     productId:(NSNumber *)productId 
                    provinceId:(NSNumber *)provinceId 
                   promotionid:(NSString*) promotionid;

//获取产品详细信息-评论信息
-(ProductVO	*)getProductDetailComment:(Trader *)trader 
                            productId:(NSNumber *)productId 
                           provinceId:(NSNumber *)provinceId;

//获取产品详细信息-描述信息
-(ProductVO	*)getProductDetailDescription:(Trader *)trader 
                                productId:(NSNumber *)productId 
                               provinceId:(NSNumber *)provinceId;

//取得热销排行榜
-(Page *)getPromotionProductPage:(Trader *)trader 
                      provinceId:(NSNumber *)provinceId 
                      categoryId:(NSNumber *)categoryId 
                     currentPage:(NSNumber *)currentPage 
                        pageSize:(NSNumber *)pageSize;

//获取用户感兴趣的商品
-(Page *)getMoreInterestedProducts:(Trader*)trader 
                         productId:(NSNumber*)productId 
                        provinceId:(NSNumber*)provinceId 
                       currentPage:(NSNumber*)currentPage 
                          pageSize:(NSNumber*)pageSize;

//获取赠品列表(用于商品详情)
-(NSArray *)getPromotionGiftList:(Trader*)trader 
                      provinceId:(NSNumber *)provinceId 
                     merchantIds:(NSArray *)merchantIds 
                      productIds:(NSArray *)productIds;

//获取赠品列表(用于购物车)
-(NSArray *)getPromotionGiftList:(NSString*)token 
                     merchantIds:(NSArray *)merchantIds 
                      productIds:(NSArray *)productIds;

//领取赠品
-(int)updateGiftProducts:(NSString *)token 
       giftProductIdList:(NSArray *)giftProductIdList 
         promotionIdList:(NSArray *)promotionIdList 
          merchantIdList:(NSArray *)merchantIdList 
            quantityList:(NSArray *)quantityList;

//获取1起摇商品列表 Page<RockProductVO>
-(Page *)getRockProductList:(Trader *)trader 
                 provinceId:(NSNumber *)provinceId 
                currentPage:(NSNumber *)currentPage 
                   pageSize:(NSNumber *)pageSize;

//摇动手机
-(NSString *)rockRock:(Trader *)trader 
           provinceId:(NSNumber *)provinceId 
          promotionId:(NSString *)promotionId 
            productId:(NSNumber *)productId 
                  lng:(NSNumber *)lng lat:(NSNumber *)lat 
                token:(NSString *)token;

//获取摇动手机后的匹配结果
-(RockResult *)getRockResult:(Trader *)trader 
                  provinceId:(NSNumber *)provinceId 
                 promotionId:(NSString *)promotionId 
                   productId:(NSNumber *)productId;

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
@end

#pragma mark - SearchService
@interface OTSServiceHelper (SearchService)
//获取相关搜索关键字(不带条数，用于快速购)
-(NSArray *)getSearchKeyWord:(Trader *)trader 
                    mcsiteid:(NSNumber *)mcsiteid 
                     keyword:(NSString *)keyword;

//获取搜索关联关键字(带条数)
-(NSArray *)getSearchKeyword:(Trader *)trader 
                    mcsiteId:(NSNumber *)mcsiteId 
                     keyword:(NSString *)keyword 
                  provinceId:(NSNumber *)provinceId;

//返回按关键字搜索的产品列表(用于快速购)
-(NSArray *)searchProductForList:(Trader *)trader 
                    mcsiteidList:(NSMutableArray *)mcsiteidList 
                  provinceIdList:(NSMutableArray *)provinceIdList 
                     keywordList:(NSMutableArray *)keywordList 
                  categoryIdList:(NSMutableArray *)categoryIdList 
                     brandIdList:(NSMutableArray *)brandIdList 
                    sortTypeList:(NSMutableArray *)sortTypeList 
                 currentPageList:(NSMutableArray *)currentPageList 
                    pageSizeList:(NSMutableArray *)pageSizeList;

//用户感兴趣的商品分类(用于快速购)
-(NSArray*)getUserInterestedProductsCategorys:(Trader *)trader;

//热门搜索关键字(用于快速购)
-(NSArray*)getHotSearchKeywords:(Trader*)trader;

//热门搜索关键字(用于购物单)
-(NSArray*)getHotSearchKeywords:(Trader *)trader categoryId:(NSNumber *)categoryId;
/*
 * @param filter "0"表示无, "01"表示促销, "02"表示有赠品, "03"表示新品, "012"表示促销、有赠品, "023"表示有赠品、新品, "013"表示促销、新品, "0123"表示促销、有赠品、新品 
 */
-(SearchResultVO *)searchProduct:(Trader *)trader 
                        mcsiteId:(NSNumber *)mcsiteId 
                      provinceId:(NSNumber *)provinceId 
                         keyword:(NSString *)keyword 
                      categoryId:(NSNumber *)categoryId 
                         brandId:(NSNumber *)brandId 
                      attributes:(NSString *)attributes 
                      priceRange:(NSString *)priceRange 
                          filter:(NSString *)filter 
                        sortType:(NSNumber *)sortType 
                     currentPage:(NSNumber *)currentPage 
                        pageSize:(NSNumber *)pageSize 
                           token:(NSString *)token;//已登录搜索

-(SearchResultVO *)searchProduct:(Trader *)trader 
                        mcsiteId:(NSNumber *)mcsiteId 
                      provinceId:(NSNumber *)provinceId 
                         keyword:(NSString *)keyword 
                      categoryId:(NSNumber *)categoryId 
                         brandId:(NSNumber *)brandId 
                      attributes:(NSString *)attributes 
                      priceRange:(NSString *)priceRange 
                          filter:(NSString *)filter 
                        sortType:(NSNumber *)sortType 
                     currentPage:(NSNumber *)currentPage 
                        pageSize:(NSNumber *)pageSize;//未登录搜索
@end

#pragma mark - SystemService
@interface OTSServiceHelper (SystemService)
//更新客户端程序，判断是否有新的客户端并传递下载地址
-(DownloadVO *)getClientApplicationDownloadUrl:(Trader *)trader;

//数据统计
-(int)doTracking:(Trader *)trader 
            type:(NSNumber *)type 
             url:(NSString *)theUrl;

//获取首页功能模块
-(NSArray *)getHomeModuleList:(Trader *)trader;
@end

#pragma mark - FeedbackService
@interface OTSServiceHelper (FeedbackService)
//保存用户反馈
-(int)addFeedback:(NSString *)token 
  feedbackcontext:(NSString *)feedbackContext;
@end

#pragma mark - CartService
@interface OTSServiceHelper (CartService)
//添加商品到购物车
-(int)addProduct:(NSString *)token 
       productId:(NSNumber *)productId 
      merchantId:(NSNumber *)merchantId 
        quantity:(NSNumber *)quantity;

-(int)addProduct:(NSString *)token 
       productId:(NSNumber *)productId 
      merchantId:(NSNumber *)merchantId 
        quantity:(NSNumber *)quantity 
     promotionid:(NSString*)promotionid;

//添加多个商品到购物车
-(NSArray *)addProducts:(NSString *)token 
             productIds:(NSMutableArray *)productIds 
            merchantIds:(NSMutableArray *)merchantIds 
              quantitys:(NSMutableArray *)quantitys;

//添加多个商品到购物车
-(NSArray *)addProducts:(NSString *)token 
             productIds:(NSMutableArray *)productIds 
            merchantIds:(NSMutableArray *)merchantIds 
              quantitys:(NSMutableArray *)quantitys 
           promotionids:(NSMutableArray*)promotionids;

//从购物车中删除所有商品
-(int)delAllProduct:(NSString *)token;

//从购物车中删除商品
-(int)delProduct:(NSString *)token 
       productId:(NSNumber *)productId 
      merchantId:(NSNumber *)merchantId 
      updateType:(NSNumber *)updateType 
     promotionid:(NSString*)promotionid;

//获取购物车
-(CartVO *)getSessionCart:(NSString *)token;

//更新购物车中商品数量
-(int)updateCartItemQuantity:(NSString *)token 
                   productId:(NSNumber *)productId 
                  merchantId:(NSNumber *)merchantId 
                    quantity:(NSNumber *)quantity 
                  updateType:(NSNumber *)updateType;

//更新购物车中商品数量
-(int)updateCartItemQuantity:(NSString *)token 
                   productId:(NSNumber *)productId 
                  merchantId:(NSNumber *)merchantId 
                    quantity:(NSNumber *)quantity 
                  updateType:(NSNumber *)updateType 
                 promotionid:(NSString *) promotionid;

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



-(AddProductResult *)addProductV2:(NSString *)token
                        productId:(NSNumber *)productId
                       merchantId:(NSNumber *)merchantId
                         quantity:(NSNumber *)quantity
                      promotionid:(NSString*)promotionid;


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
-(NSArray *)addProductsV2:(NSString *)token
               productIds:(NSMutableArray *)productIds
              merchantIds:(NSMutableArray *)merchantIds
                quantitys:(NSMutableArray *)quantitys
             promotionids:(NSMutableArray*)promotionids;

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
-(UpdateCartResult *)updateCartItemQuantityV2:(NSString *)token
                                    productId:(NSNumber *)productId
                                   merchantId:(NSNumber *)merchantId
                                     quantity:(NSNumber *)quantity
                                   updateType:(NSNumber *)updateType
                                  promotionId:(NSString *)promotionId;

@end

#pragma mark - FavoriteService
@interface OTSServiceHelper (FavoriteService)
//添加一个产品到我的收藏
-(int)addFavorite:(NSString *)token 
              tag:(NSString *)tag 
        productId:(NSNumber *)productId;
//从我的收藏删除一个产品
-(int)delFavorite:(NSString *)token 
        productId:(NSNumber *)productId;

//获取我的收藏夹列表
-(Page *)getMyFavoriteList:(NSString *)token 
                       tag:(NSString *)tag 
               currentPage:(NSNumber *)currentPage 
                  pageSize:(NSNumber *)pageSize;
@end


#pragma mark - CouponService
@interface OTSServiceHelper (CouponService)
//获取我的抵用券
-(Page *)getMyCouponList:(NSString *)token
             currentPage:(NSNumber *)currentPage
                pageSize:(NSNumber *)pageSize;

//我的1号店查询抵用卷
-(Page *)getMyCouponList:(NSString *)token
                    type:(int)currentType
             currentPage:(NSNumber *)currentPage
                pageSize:(NSNumber *)pageSize;

//订单查询可用抵用卷
-(Page *)getCouponListForSessionOrder:(NSString *)token
                          currentPage:(NSNumber *)currentPage
                             pageSize:(NSNumber *)pageSize;

//保存抵用券到订单
-(CouponCheckResult *) saveCouponToSessionOrderV2:(NSString *)token
                                     couponNumber:(NSString *)couponNumber;

//获取验证码
-(CouponCheckResult *) getCouponCheckCode:(NSString *)token
                                   mobile:(NSString *)mobile;

//验证码验证
-(CouponCheckResult *) verifyCouponCheckCode:(NSString *)token
                                      mobile:(NSString *)mobile
                                   checkCode:(NSString *)checkCode;

//删除订单抵用卷
-(CouponCheckResult *) deleteCouponFromSessionOrder:(NSString *)token;
@end


#pragma mark - MessageService
@interface OTSServiceHelper (MessageService)
//根据消息ID删除全部消息
-(int)deleteMessageById:(NSString *)token 
              messageId:(NSNumber *)messageId;

//获取消息详细信息
-(InnerMessageVO *)getMessageDetailById:(NSString *)token 
                              messageId:(NSNumber *)messageId;
//获取消息列表
-(Page *)getMessageList:(NSString *)token 
            messageType:(NSNumber *)messageType 
            currentPage:(NSNumber *)currentPage 
               pageSize:(NSNumber *)pageSize;

//获取未读消息数量
-(int)getUnreadMessageCount:(NSString *)token;
@end

#pragma mark - OrderService
@interface OTSServiceHelper (OrderService)
//取消订单
-(int)cancelOrder:(NSString *)token 
          orderId:(NSNumber *)orderId;

//创建结算中心订单
-(int)createSessionOrder:(NSString *)token;

//获取特定类型的我的订单列表
-(Page *)getMyOrderListByToken:(NSString *)token 
                          type:(NSNumber *)type 
                   currentPage:(NSNumber *)currentPage 
                      pageSize:(NSNumber *)pageSize;

//获取订单详细信息
-(OrderV2 *)getOrderDetailByOrderIdEx:(NSString *)token 
                              orderId:(NSNumber *)orderId;

//获取结算中心订单
-(OrderVO *)getSessionOrder:(NSString *)token;

//重新购买订单
-(int)rebuyOrder:(NSString *)token 
         orderId:(NSNumber *)orderId;

//保存收货地址信息到订单
-(int)saveGoodReceiverToSessionOrder:(NSString *)token 
                      goodReceiverId:(NSNumber *)goodReceiverId;

//保存发票到订单
-(int)saveInvoiceToSessionOrder:(NSString *)token 
                   invoiceTitle:(NSString *)invoiceTitle 
                 invoiceContent:(NSString *)invoiceContent 
                  invoiceAmount:(NSNumber *)invoiceAmount;

//设置支付方式
-(int)savePaymentToSessionOrder:(NSString *)token 
                       methodid:(NSNumber *)methodid 
                      gatewayid:(NSNumber *)gatewayid;

//结算中心提交订单
-(int)submitOrder:(NSString *)token;

//结算中心提交订单
-(int)submitOrderEx:(NSString *)token;

/**
 * <h2>结算中心提交订单</h2>
 * <br/>
 * 功能点：结算中心页面提交订单; <br/>
 * 异常：服务器错误;Token错误;订单不存在<br/>
 * 返回：SubmitOrderResult<br/>
 * 必填参数：token<br/>
 * 返回值：同返回
 * @param token
 * @return 返回结算中心提交订单结果
 */
-(SubmitOrderResult *)submitOrderV2:(NSString *)token;

-(NSMutableArray *)getOrderStatusHeader:(NSString *)token 
                                orderId:(NSNumber *)orderId;

-(Page *)getOrderStatusTrack:(NSString *)token 
                     orderId:(NSNumber *) orderId 
                 currentPage:(NSNumber *)currentPage 
                    pageSize:(NSNumber *)pageSize;

-(NSArray *)getPaymentMethodsForSessionOrder:(NSString *)token;

-(NSString *)CUPSignature:(NSString *)token 
                  orderId:(NSString *)orderId;



/**
 * <h2>创建结算中心订单</h2>
 * <br/>
 * 功能点：购物车页面购买; <br/>
 * 异常：服务器错误;Token错误;<br/>
 * 返回：CreateOrderResult<br/>
 * 必填参数：token<br/>
 * 返回值：同返回<br/>
 * @param token
 * @return 返回创建结算中心订单
 */
-(CreateOrderResult *)createSessionOrderV2:(NSString *)token;

/**
 * <h2>保存网关到订单</h2><br/>
 * <br/>
 * 功能点：订单支付;<br/>
 * 异常：服务器错误;Trader错误;<br/>
 * 返回：SaveGateWayToOrderResult<br/>
 * 必填参数：token,orderId,gateWayId<br/>
 * 返回值：<br/>
 * @param token
 * @param orderId 订单Id
 * @param gateWayId 网关Id
 * @return SaveGateWayToOrderResult
 */
-(SaveGateWayToOrderResult *)saveGateWayToOrder:(NSString *)token orderId:(NSNumber *)orderId gateWayId:(NSNumber *)gateWayId;

@end

#pragma mark - PayService
@interface OTSServiceHelper (PayService)
-(Page *)getBankVOList:(Trader *)trader 
                  name:(NSString *)name 
                  type:(NSNumber *)type 
           currentPage:(NSNumber *)currentPage 
              pageSize:(NSNumber *)pageSize;


#pragma mark - 余额支付

/**
 * 余额支付是否需要短信验证
 *
 * @param aPayByAccount 余额支付的金额
 * @return resultCode=1时，mobile首先取用户资料库手机号，没有则取收货地址手机号，再没有返回""表示需要用户手动输入手机号。
 * resultCode=2时，mobile为用户绑定的短信验证手机号
 */
-(NeedCheckResult *)needSmsCheck:(NSString *)aToken 
                    payByAccount:(NSNumber*)aPayByAccount;


/**
 * 发送余额验证的短信
 *
 * @param mobile 接收短信的手机号
 * @return resultCode=0时，errorInfo为失败信息。
 */
-(SendValidCodeResult *)sendValidCodeToUserBindMobile:(NSString *)aToken 
                                               mobile:(NSString *)aMobile;

/**
 * 发送余额验证的短信
 *
 * @param validCode 验证码
 * @return resultCode=0时，errorInfo为失败信息。
 */
-(CheckSmsResult *)checkSms:(NSString *)aToken 
                  validCode:(NSString *)aValidCode;

/**
 * 余额支付
 *
 * @param payByAccount      余额支付金额
 * @param validCode         验证码
 * @param type              type=1表示普通商品余额支付，type=2表示团购余额支付
 * @return resultCode=0时，errorInfo为失败信息。
 */
-(SavePayByAccountResult *)savePayByAccount:(NSString *)aToken 
                               payByAccount:(NSNumber*)aPayByAccount 
                                  validCode:(NSString*)aValidCode 
                                       type:(NSNumber*)aType;
@end

#pragma mark - GroupBuyService
@interface OTSServiceHelper (GroupBuyService)

-(NSArray *)getGrouponCategoryList:(Trader *)trader 
                            areaId:(NSNumber *)areaId;

-(Page *)getCurrentGrouponList:(Trader *)trader 
                        areaId:(NSNumber *)areaId 
                    categoryId:(NSNumber *)categoryId 
					sortAttrId:(NSNumber*)sortId
                   currentPage:(NSNumber *)currentPage 
                      pageSize:(NSNumber *)pageSize;

-(NSArray *)getGroupOnSortAttribute:(Trader *)trader AreaId:(NSNumber*)areaId;

-(NSArray *)getGrouponAreaList:(Trader *)trader;

-(NSNumber *)getGrouponAreaIdByProvinceId:(Trader *)trader 
                               provinceId:(NSNumber *)provinceId;

-(GrouponVO *)getGrouponDetail:(Trader *)trader 
                     grouponId:(NSNumber *)grouponId 
                        areaId:(NSNumber *)areaId;

-(GrouponOrderVO *)createGrouponOrder:(NSString *)token 
                            grouponId:(NSNumber *)grouponId 
                             serialId:(NSNumber *)serialId 
                               areaId:(NSNumber *)areaId;

-(GrouponOrderSubmitResult *)submitGrouponOrder:(NSString *)token 
                                      grouponId:(NSNumber *)grouponId 
                                       serialId:(NSNumber *)serialId 
                                       quantity:(NSNumber *)quantity 
                                     receiverId:(NSNumber *)receiverId 
                                   payByAccount:(NSNumber *)payByAccount 
                                grouponRemarker:(NSString *)grouponRemarker 
                                         areaId:(NSNumber *)areaId 
                                      gatewayId:(NSNumber *)gatewayId;

-(GrouponOrderVO *)getMyGrouponOrder:(NSString *)token 
                             orderId:(NSNumber *)orderId;

-(Page *)getMyGrouponList:(NSString *)token 
                     type:(NSNumber *)type 
              currentPage:(NSNumber *)currentPage 
                 pageSize:(NSNumber *)pageSize;

-(int)saveGateWayToGrouponOrder:(NSString *)token 
                        orderId:(NSNumber *)orderId 
                      gatewayId:(NSNumber *)gatewayId;
@end




#pragma mark - AdvertisementServer
@interface OTSServiceHelper (AdvertisementServer)

-(Page *)getAdvertisementList:(Trader *)trader 
                   provinceId:(NSNumber *)provinceId 
                  currentPage:(NSNumber *)currentPage
                     pageSize:(NSNumber *)pageSize;
/**
 * <h2>获取广告促销列表</h2><br/>
 * <br/>
 * 功能点：首页;<br/>
 * 异常：服务器错误;Trader错误;<br/>
 * 必填参数：trader,provinceId,updateTag<br/>
 * 返回值：AdvertisingPromotion<br/>
 * @param trader
 * @param provinceId 省份id
 * @param updateTag 更新标记
 * @return 获取广告促销列表
 */
-(AdvertisingPromotion *)getCmsAdvertisingPromotion:(Trader *)trader provinceId:(NSNumber *)provinceId updateTag:(NSString *)updateTag;
@end

#pragma mark - PromotionService
@interface OTSServiceHelper (PromotionService)
-(Page*)getCmsPageList:(Trader *)aTrader 
            provinceId:(NSNumber*)aProvinceId 
            activityId:(NSNumber*)aActivityId 
           currentPage:(NSNumber*)aCurrentPage 
              pageSize:(NSNumber*)aPageSize;

-(Page*)getCmsColumnList:(Trader *)aTrader 
              provinceId:(NSNumber*)aProvinceId 
               cmsPageId:(NSNumber*)aCmsPageId 
                    type:(NSString*)aType
             currentPage:(NSNumber*)aCurrentPage 
                pageSize:(NSNumber*)aPageSize;
@end

