//
//  OTSWeRockService.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-1.
//
//

#import <Foundation/Foundation.h>
#import "TheStoreService.h"


@class RockGameVO;
@class RockGameFlowVO;
@class RockGameProductVO;
@class RockResultV2;
@class AddStorageBoxResult;
@class AddCouponByActivityIdResult;
@class CheckRockResultResult;
@class Page;
@class InviteeResult;
@class AwardsResult;
@class UpdateStroageBoxResult;
@interface OTSWeRockService : TheStoreService

+(OTSWeRockService*)myInstance;


typedef enum
{
    kCreateRockGameOK = 1
    , kCreateRockGameFailed = 0
    , kCreateRockGameServerError = -1
}OTSCreateRockGameResult;

#pragma mark - 你说我猜接口
//------------1
/**
 * <h2>创建一个游戏</h2><br/>
 * 功能点：摇摇购首页-要种游戏并点击开启游戏;<br/>
 * 必填参数：token<br/>
 * 返回值：Integer<br/>
 * @param token
 * @return 创建成功标示
 * 返回1：成功；0：失败；-1：服务器内部错误
 */
//public Integer createRockGame(String token);
-(int)createRockGame:(NSString*)aToken;


//------------2
/**
 * <h2>根据用户ID查询游戏</h2><br/>
 * 功能点：摇摇购首页或玩游戏页面;<br/>
 * 必填参数：token <br/>
 * 返回值：RockGameVO<br/>
 * @param token
 * @return 摇摇购游戏对象
 */
//public RockGameVO getRockGameByToken(String token);
//原来的getRockGameByToken(String token)接口修改为getRockGameByToken(String token,Integer type)新增type参数
//
//type为1时 查询游戏的同时会将当期活动的商品加入商品集合中，如果商品已经赠送成功过RockGameProductVO的isSended属性设置为true，图片将会亮起；为null或非1时，不查询商品

-(RockGameVO*)getRockGameByToken:(NSString*)aToken type:(NSNumber*)aType;


//------------3

/**
 * <h2>获取将要赠送的商品列表</h2><br/>
 * 功能点：摇摇购选择赠送商品页面;<br/>
 * 必填参数：token <br/>
 * 返回值：List<MobileCentralRockGameProductVO><br/>
 * @param token
 * @return 摇摇购赠送商品的集合
 */
//public List<RockGameProductVO> getPresentsByToken(String token);
-(NSArray*)getPresentsByToken:(NSString*)aToken;


//------------4
/**
 * <h2>创建一个游戏流程</h2><br/>
 * 功能点：玩游戏选择手机好友发送游戏;<br/>
 * 必填参数：token,rockGameFlowVO<br/>
 * 返回值：long<br/>
 * @param token
 * @param rockGameFlowVO	游戏流程对象
 * @return 非负数为创建的流程ID 负数表示失败
 */
//public long createRockGameFlow(String token,RockGameFlowVO RockGameFlowVO);

-(long)createRockGameFlow:(NSString*)aToken rockGameFlowVO:(RockGameFlowVO*)rockGameFlowVO;


//------------5
/**
 * <h2>获取游戏流程的题目</h2><br/>
 * 功能点：摇摇购玩游戏用户答题页面;<br/>
 * 必填参数：rockGameFlowID<br/>
 * 返回值：RockGameProductVO<br/>
 * @param rockGameFlowID	游戏流程ID
 * @return 游戏所赠送的商品对象
 */
//public RockGameProductVO getRockGameProductVO(Long rockGameFlowID);
-(RockGameProductVO*)getRockGameProductVO:(NSNumber*)rockGameFlowID;


//------------6
/**
 * <h2>检查答题结果</h2><br/>
 * 功能点：摇摇购玩游戏用户答题;<br/>
 * 必填参数：rockGameFlowID,rockGameProdID,resultCode<br/>
 * 返回值：CheckRockGameResult<br/>
 * @param rockGameFlowID	游戏流程ID
 * @param rockGameProdID	题目ID
 * @param resultCode	选择的结果
 * @return 检查答题结果的对象
 */
//public CheckRockGameResult checkResult(Long rockGameFlowID,Long rockGameProdID,String resultCode);
// wap 使用此接口，客户端不必实现



//------------7
/**
 * <h2>处理游戏流程</h2><br/>
 * 功能点：摇摇购玩游戏;<br/>
 * 必填参数：token,rockGameFlowID<br/>
 * 返回值：Integer<br/>
 * @param token
 * @param rockGameFlowID	游戏流程ID
 * @return 1：成功；0：失败；-1：服务器内部错误
 */
//public Integer processGameFlow(String token,Long rockGameFlowID);
-(int)processGameFlow:(NSString*)aToken rockGameFlowID:(NSNumber*)rockGameFlowID;

/**
 * <h2>判断所选择的用户能否被邀请</h2><br/>
 * <br/>
 * 功能点：新版摇摇购游戏选择用户;<br/>
 * 异常：服务器错误;<br/>
 * 必填参数：phoneNum<br/>
 * 返回值：InviteeResult<br/>
 * @param phoneNum
 * @return
 */
//public InviteeResult isCanInviteeUser(Trader trader ,String phoneNum);

-(InviteeResult*)isCanInviteeUser:(Trader*)atrader PhoneNum:(NSString*)phoneNum;
#pragma mark - 一起摇接口
//------------8
/**
 * <h2>获取摇动手机后的结果(未登录)</h2><br/>
 * <br/>
 * 功能点：新版摇摇购;<br/>
 * 异常：服务器错误;token错误;<br/>
 * 必填参数：token,provinceId<br/>
 * 返回值：RockResultV2<br/>
 * @param trader
 * @param provinceId
 * @return 获取摇动手机后的结果
 */
//public RockResultV2 getRockResultV2(Trader trader, Long provinceId);相关VO

//2.2.1.2	获取摇一摇的结果(已登录)
/**
 * <h2>获取摇动手机后的结果(已登录)</h2><br/>
 * <br/>
 * 功能点：新版摇摇购;<br/>
 * 异常：服务器错误;token错误;<br/>
 * 必填参数：token,provinceId<br/>
 * 返回值：RockResultV2<br/>
 * @param token
 * @return 获取摇动手机后的结果
 */
//public RockResultV2 getRockResultV2(String token);

-(RockResultV2*)getRockResultV2:(Trader*)aTrader provinceId:(NSNumber*)provinceId token:(NSString*)aToken;

/**
 * <h2>获取摇动手机后的结果(未登录)</h2><br/>
 * <br/>
 * 功能点：新版摇摇购;<br/>
 * 异常：服务器错误;token错误;<br/>
 * 必填参数：trader,provinceId<br/>
 * 返回值：RockResultV2<br/>
 * @param trader
 * @param provinceId 省份id
 * @param lng 经度
 * @param lat 纬度
 * @return 获取摇动手机后的结果
 */
//public RockResultV2 getRockResultV3(Trader trader, Long provinceId,Double lng, Double lat);
-(RockResultV2*)getRockResultV3:(Trader*)trader provinceId:(NSNumber*)provinceId lng:(NSNumber*)lng lat:(NSNumber*)lat;

/**
 * <h2>获取摇动手机后的结果(已登录)</h2><br/>
 * <br/>
 * 功能点：新版摇摇购;<br/>
 * 异常：服务器错误;token错误;<br/>
 * 必填参数：token<br/>
 * 返回值：RockResultV2<br/>
 * @param token
 * @param lng 经度
 * @param lat 纬度
 * @return 获取摇动手机后的结果
 */
//public RockResultV2 getRockResultV3(String token,Double lng, Double lat);
-(RockResultV2*)getRockResultV3:(NSString*)token lng:(NSNumber*)lng lat:(NSNumber*)lat;

/**
 * <h2>查询摇一摇发奖结果</h2><br/>
 * <br/>
 * 功能点：新版摇摇购;<br/>
 * 异常：服务器错误;token错误;<br/>
 * 必填参数：trader(deviceCode)<br/>
 * 返回值：AwardsResult<br/>
 * @param trader
 * @return
 */
//public  AwardsResult getAwardsResults(Trader trader)
-(AwardsResult*)getAwardsResults:(Trader*)trader;

//------------9
/**
 * <h2>获取我的寄存箱</h2><br/>
 * <br/>
 * 功能点：新版摇摇购;<br/>
 * 异常：服务器错误;token错误;<br/>
 * 必填参数：token<br/>
 * 返回值：StorageBoxVO<br/>
 * @param token
 * @param type 0-表示查询全部；1-表示促销商品类型为未购买；2-促销商品类型为已购买
 * @param currentPage
 * @param pageSize
 * @return 同返回
 */
//public Page<StorageBoxVO> getMyStorageBoxList(String token,Integer type,Integer currentPage, Integer pageSize);
typedef enum
{
    kRockBoxQueryAll = 0
    , kRockBoxQueryNotBuy
    , kRockBoxQueryHasBuy
}OTSRockBoxQueryType;


-(Page*)getMyStorageBoxList:(NSString*)aToken
                          type:(NSNumber*)type
                   currentPage:(NSNumber*)currentPage
                      pageSize:(NSNumber*)pageSize;


//------------10
/**
 * <h2>添加商品或抵用券到我的寄存箱</h2><br/>
 * <br/>
 * 功能点：新版摇摇购;<br/>
 * 异常：服务器错误;token错误;<br/>
 * 必填参数：token,type<br/>
 * 返回值：AddStorageBoxResult<br/>
 * @param token
 * @param productId 商品Id
 * @param promotionId 促销Id
 * @param couponNumber 抵用券编码
 * @param type 1-促销商品；2-抵用券
 * @return 同返回
 */
//public AddStorageBoxResult  addStorageBox(String token,Long productId,String promotionId,String couponNumber,Integer type,Long couponActiveId);

typedef enum
{
    kRockBoxAddProduct = 1      // 1-促销商品
    , kRockBoxAddTicket         // 2-抵用券
}OTSRockBoxAddType;

-(AddStorageBoxResult*)addStorageBox:(NSString*)aToken
                           productId:(NSNumber*)productId
                         promotionId:(NSString*)promotionId
                            couponNumber:(NSString*)couponNumber
                                type:(NSNumber*)type
                      couponActiveId:(NSNumber *)couponActiveId;


//------------11
/**
 * <h2>通过活动Id添加抵用券到用户</h2><br/>
 * <br/>
 * 功能点：新版摇一摇通过活动Id添加抵用券到用户;<br/>
 * 异常：服务器错误;Token错误;<br/>
 * 返回：AddCouponByActivityIdResult<br/>
 * 必填参数：token,activityId<br/>
 * 返回值：AddCouponByActivityIdResult<br/>
 * 1：成功
 * -1：没找到活动
 * -2：活动尚未开始
 * -3：活动已经结束
 * -4：活动已经达到最大发放数量
 * -5：请先摇中抵用券
 * -6：用户已经达到该活动限领张数
 * -7：抵用券发放失败
 * @param token
 * @param activityId 抵用券活动Id
 * @return
 */
//public AddCouponByActivityIdResult addCouponByActivityId(String token,Long activityId);



-(AddCouponByActivityIdResult*)addCouponByActivityId:(NSString*)aToken
                                          activityId:(NSNumber*)activityId;


//------------12
/**
 * <h2>判断摇出的商品是否未结算</h2><br/>
 * <br/>
 * 功能点：新版摇摇购;<br/>
 * 异常：服务器错误;token错误;<br/>
 * 必填参数：token,productId,promotionId<br/>
 * 返回值：CheckRockResultResult<br/>
 * 1：成功
 * -1：您寄存箱中存在仍未结算的该商品，请重摇！
 * -2：您已经摇中过该抵用券，请重摇！
 * -3：您购物车中存在仍未结算的该商品，请重摇！
 * @param token
 * @param productId
 * @param promotionId
 * @param type 1：商品；2：抵用券
 * @param couponActiveId 抵用券活动Id
 * @return
 */
//public CheckRockResultResult checkRockResult(String token ,Long productId,String promotionId,Integer type,Long couponActiveId);

typedef enum
{
    kWrCheckRockProduct = 1
    , kWrCheckRockTicket = 2
}OTSCheckRockType;

-(CheckRockResultResult*)checkRockResult:(NSString*)aToken
                               productId:(NSNumber*)productId
                             promotionId:(NSString*)promotionId
                                    type:(NSNumber*)type
                          couponActiveId:(NSNumber*)couponActiveId;

/**
 * 更新寄存箱中商品的状态
 * @param token
 * @param promotionId 促销Id
 * @param productId 商品Id
 * @param productStatus '商品状态 0-可售；1-已加入购物车；2-已购买；3-已过期'
 */
//public UpdateStroageBoxResult updateStroageBoxProductType(String token , List<String> promotionIdList , List<Long> productIdList, Integer productStatus);

-(UpdateStroageBoxResult*)updateStroageBoxProductType:(NSString*)token promotionIdList:(NSMutableArray*)promotionIdList productIdList:(NSMutableArray*)productIdList productStatus:(NSNumber*)productStatus;

/**
 *  清空购物车更新用户已购买商品状态为可售、提交订单更新所有已加入购物车状态为已购买
 * @param token
 * @param 1-清空购物车；2-提交订单
 * @return
 */
//public UpdateStroageBoxResult updateStroageBoxProductForDelAll(String token,Integer type);

-(UpdateStroageBoxResult*)updateStroageBoxProductForDelAll:(NSString*)token type:(NSNumber*)type;
@end
