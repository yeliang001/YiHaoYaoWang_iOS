//
//  OrderService.h
//  TheStoreApp
//
//  Created by linyy on 11-2-12.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheStoreService.h"
#import "Trader.h"
#import "MethodBody.h"
#import "OrderV2.h"
#import "Page.h"
#import "CreateOrderResult.h"
#import "SubmitOrderResult.h"
#import "SaveGoodReceiverResult.h"
#import "SaveGateWayToOrderResult.h"

typedef enum _EOtsOrderType
{
    KOtsOrderTypeDefault            = 0     // 已完成交易 +  取消 + 正在进行
    , KOtsOrderTypeMaterialFlow     = 1     // 物流
    , KOtsOrderTypeCompleted        = 2     // 已完成交易
    , KOtsOrderTypeCanceld          = 3     // 取消
    , KOtsOrderTypeProceeding       = 4     // 正在进行
    , KOtsOrderTypeHistory          = 5     // 历史
}EOtsOrderType;


#define kProcessing 0 //处理中的订单
#define kCanceled   1 //已经取消的订单
#define kCompleted  2 //已经完成的订单


@interface OrderService:TheStoreService{
}

//取消订单
-(int)cancelOrder:(NSString *)token orderId:(NSNumber *)orderId;

//创建结算中心订单
-(int)createSessionOrder:(NSString *)token;

//获取特定类型的我的订单列表
-(Page *)getMyOrderListByToken:(NSString *)token 
                          type:(NSNumber *)type 
                   currentPage:(NSNumber *)currentPage 
                      pageSize:(NSNumber *)pageSize;

-(Page *)getMyOrderListByToken:(NSString *)token 
                   currentPage:(NSNumber *)currentPage 
                      pageSize:(NSNumber *)pageSize;

//获取订单详细信息
-(OrderV2 *)getOrderDetailByOrderIdEx:(NSString *)token orderId:(NSNumber *)orderId;

//获取结算中心订单
-(OrderVO *)getSessionOrder:(NSString *)token;
//重新购买订单
-(long)rebuyOrder:(NSString *)token orderId:(NSNumber *)orderId;
//保存收货地址信息到订单
-(long)saveGoodReceiverToSessionOrder:(NSString *)token goodReceiverId:(NSNumber *)goodReceiverId;
//保存收货地址到订单V2
-(SaveGoodReceiverResult *)saveGoodReceiverToSessionOrderV2:(NSString *)token
                                             goodReceiverId:(NSNumber *)goodReceiverId;
//保存发票到订单
-(long)saveInvoiceToSessionOrder:(NSString *)token invoiceTitle:(NSString *)invoiceTitle invoiceContent:(NSString *)invoiceContent invoiceAmount:(NSNumber *)invoiceAmount;
//设置支付方式
-(long)savePaymentToSessionOrder:(NSString *)token methodid:(NSNumber *)methodid gatewayid:(NSNumber *)gatewayid;
//结算中心提交订单
-(long)submitOrder:(NSString *)token;
//结算中心提交订单
-(long long int)submitOrderEx:(NSString *)token;
-(NSMutableArray *)getOrderStatusHeader:(NSString *)token orderId:(NSNumber *)orderId;

-(Page *)getOrderStatusTrack:(NSString *)token 
                     orderId:(NSNumber *) orderId 
                 currentPage:(NSNumber *)currentPage 
                    pageSize:(NSNumber *)pageSize;

-(NSArray *)getPaymentMethodsForSessionOrder:(NSString *)token;
-(NSArray *)getPaymentMethodsForSessionOrderV2:(NSString *)token;
-(NSString *)CUPSignature:(NSString *)token orderId:(NSString *)orderId;
-(NSString *)aliPaySignature:(NSString *)token orderId:(NSString *)orderId;
-(NSArray *)getMyOrderCount:(NSString *)token;

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

/**
 * <h2>获取我的订单列表</h2>
 * <br/>
 * 功能点：我的1号店我的订单列表;<br/>
 * 异常：服务器错误;Token错误;<br/> 
 * 返回：List<OrderVO><br/> 
 * 必填参数：token,type,currentPage,pageSize<br/> 
 * @param token
 * @param type 1为物流的订单，2为已完成交易的订单，3为取消的订单，4为正在进行的订单，0为2+3+4的订单
 * @param orderRange 0为全部订单，1为普通订单，2为团购订单
 * @param siteType 0为全部站点，1为1号店，2为1号商场
 * @param currentPage
 * @param pageSize
 * @return 返回获取我的订单列表
 */
-(Page *)getMyOrderListByToken:(NSString *)token 
                          type:(NSNumber *)type 
                    orderRange:(NSNumber *)orderRange
                      siteType:(NSNumber *)siteType
                   currentPage:(NSNumber *)currentPage 
                      pageSize:(NSNumber *)pageSize;

/**
 * 获取我的订单数量
 * <br/>
 * 功能点：获取我的订单数量;<br/>
 * 异常：服务器错误;Token错误;<br/>  
 * @param token
 * @param orderRange 0为全部订单，1为普通订单，2为团购订单
 * @param siteType 0为全部站点，1为1号店，2为1号商场,3区分一号店和一号商城的数量
 * @return 订单数量
 * orderCountVO.type 订单类型 siteType=0/1/2时：type=1为物流的订单，2为已完成交易的订单，3为取消的订单，4为正在进行的订单，5为历史的，0为全部的订单
 当入参为3时：一号店订单状态（11为物流的订单，12为已完成交易的订单，13为取消的订单，14为正在进行的订单）
 一号商城订单（21为物流的订单，22为已完成交易的订单，23为取消的订单，24为正在进行的订单）<br/>
 *         orderCountVO.count 订单数<br/>
//public List<OrderCountVO> getMyOrderCount(String token, Integer orderRange, Integer siteType);
*/
-(NSArray*)getMyOrderCount:(NSString *)token 
                orderRange:(NSNumber*)orderRange 
                  siteType:(NSNumber*)siteType;

/**
 * <h2>查询当期团购列表(包含排序功能)</h2><br/>
 * <br/>
 * 功能点：团购首页;<br/>
 * 异常：服务器错误;Trader错误;<br/>
 * 返回：GrouponVO<br/>
 * 必填参数：trader,areaId,categoryId,currentPage,pageSize<br/> 
 * 返回值：<br/> 
 * @param trader
 * @param areaId 地区id
 * @param categoryId 0-其他；1-1号团独享；2-食品 ；3-居家 ；4-电器 ；5-时尚 ；6-健康服务 ；7-爱名品 ；8-会员专享；
 * @param sortType 0-默认的排序列表；1-人气最高；2-折扣最多；3-价格最低；4-最新发布；
 * @param siteType 0为全部站点，1为1号店，2为1号商场
 * @param currentPage
 * @param pageSize
 * @return 返回当期团购列表
 */
//public Page<GrouponVO> getCurrentGrouponList(Trader trader, Long areaId, Long categoryId,Integer sortType, Integer siteType, Integer currentPage, Integer pageSize);

-(Page*)getCurrentGrouponList:(Trader*)trader 
                       areaId:(NSNumber*)areaId 
                   categoryId:(NSNumber*)categoryId 
                     sortType:(NSNumber*)sortType 
                  currentPage:(NSNumber*)currentPage 
                     pageSize:(NSNumber*)pageSize;

@end
