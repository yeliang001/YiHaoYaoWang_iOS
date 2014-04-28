//
//  JSTrackingPrama.h
//  TheStoreApp
//
//  Created by xuexiang on 13-1-11.
//
//

#import <Foundation/Foundation.h>

// !!!!!!!使用说明！！！！！！
//该类使用 -(id)initWithJSType:(JSTrackingType)type extraPrama:(id)firstOther, ... NS_REQUIRES_NIL_TERMINATION 方法进行初始化，另一个初始化方法现在不用
//传递的参数根据 type 后的注释。 其中 “设置”表示需设置该对应的属性：如[prama setProductId:aProductId];  "额外传入"的参数直接在初始化方法后传入：如 JSTrackingPrama* prama = [[JSTrackingPrama alloc]initWithJSType:EJStracking_XXX extraPrama:prama1, prama2, prama3, ..., nil]]; 需注意最后需要以nil 结尾。 另外参数的顺序必须以注释的为准。
typedef enum _JSTrackingType{
    EJStracking_HomePage = 0,
    EJStracking_CategoryRoot,           // 需传入额外mcsiteId，分类ID
    EJStracking_CategoryProductList,    // 需设置resultSum，额外传入三级分类ID, currentPage
    EJStracking_ProductDetail,          // 需设置 productId,merchantid
    EJStracking_Filiter,
    EJStracking_Search,                 // 需设置internalKeyWord,resultSum, 额外传入currentPage
    EJStracking_SearchAgain,            // 需设置internalKeyWord,resulrSum, 额外传入currentPage
    EJStracking_AddCart,                // 需设置productId, merchantid
    EJStracking_addCart_inCategory,     // 从分类进入添加进购物车
    EJStracking_addCart_inSearch,       // 从搜索进入购物车
    EJStracking_addCart_inDetail,       // 从详情也加入购物车，需设置productID
    EJStracking_AddFavourite,           // 需设置productId
    EJStracking_AddFavourite_inDetail,  // 需设置productId
    EJStrakcing_EnterCart,
    EJStracking_GroupLogo,              
    EJStracking_History,
    EJStracking_CheckOrder,
    EJStracking_SaveReciveToOrder,      // 需额外传入goodReceiverId
    EJStracking_CheckPayment,           // 需额外传入goodReceiverId (不合理)
    EJStracking_SavePayment,            // 需传入额外的methodID, gatewayId
    EJStracking_SaveCoupon,             // 需传入额外的couponNumber,merchantid
    EJStracking_SaveInvoice,            // 需传入额外的invoiceTitle,invoiceContent,invoiceAmount
    EJStracking_SubmitOrder,            // 需设置orderCode
    EJStracking_OrderDone,              // 奇了怪了，啥都不用传，找徐浥宁确认
    EJStracking_GroupList,              // 需传入额外的areaId, categoryId
    EJStracking_GroupDetail,            // 需传入额外的areaId, categoryId, grouponId
    EJStracking_CreatGroupOrder,        // 需传入额外的areaId，grouponId,serialId
    EJStracking_SubmitGroupOrder,       // 需设置orderCode,传入额外的areaId，grouponId,serialId，grouponId，quantity，receiverId，payByAccount，grouponRemarke，gateWayI。 有点多，蛋都碎一地了
    EJStracking_Login,
    EJStracking_Register,
    EJStracking_AD_HotPage,
    EJStracking_AD_Food,
    EJStracking_AD_General,
    EJStracking_AD_CE,
    EJStracking_keyWord_Food,
    EJStracking_keyWord_General,
    EJStracking_keyWord_CE,
    EJStracking_TopBrand,
    EJStracking_CrazyShopping,
    EJStracking_RockBuy,
    EJStracking_FavouriteList,
    EJStracking_Scan,
    EJStracking_MF                      // 物流查询
}JSTrackingType;

@interface JSTrackingPrama : NSObject

@property(nonatomic, retain)NSString* ieVersion;        // 客户端版本号
@property(nonatomic, retain)NSString* platform;         // iosSystem，ipadSystem
@property(nonatomic, retain)NSString* tracker_u;        // 渠道号
@property(nonatomic, retain)NSString* gu_id;            // 
@property(nonatomic, retain)NSString* merchant_id;      // 当前商家
@property(nonatomic, retain)NSString* session_id;       // 每24小时随机生成的一个id
@property(nonatomic, retain)NSString* exField10;        // device code,现在我们在通过cookie来传递
@property(nonatomic, retain)NSString* infoPreviousUrl;
@property(nonatomic, retain)NSString* infoTrackerSrc;
@property(nonatomic, retain)NSNumber* endUserId;        // 客户ID，客户端从.yihaodian.com或.1mall.com域下，yihaodian_uid字段
@property(nonatomic, retain)NSString* extField6;        // 暂不用传
@property(nonatomic, retain)NSString* cookie;           // 暂不用传
@property(nonatomic, retain)NSString* fee;              // 暂不用传
@property(nonatomic, retain)NSNumber* provinceId;
@property(nonatomic, retain)NSString* cityId;
@property(nonatomic, retain)NSString* infoPageId;       // 详情页pageID传1，其他不传
@property(nonatomic, retain)NSNumber* productId;
@property(nonatomic, retain)NSString* linkPosition;
@property(nonatomic, retain)NSString* buttonPosition;
@property(nonatomic, retain)NSString* attachedInfo;     // 暂不用传
@property(nonatomic, retain)NSString* jsoncallback;     // 暂不用传
@property(nonatomic, retain)NSString* url;
@property(nonatomic, retain)NSString* internalKeyWord;
@property(nonatomic, retain)NSNumber* resultSum;
@property(nonatomic, retain)NSString* orderCode;
@property(nonatomic, retain)NSString* URLstr;
@property(nonatomic, retain)NSMutableDictionary* otherPramaDic;
@property(nonatomic)JSTrackingType trackingType;
-(NSURL*)toURL;                                                             // 将所得参数转成请求的URL返回
-(id)initWithJSType:(JSTrackingType)type extraPramaDic:(NSMutableDictionary*)dic;                         // 已经没用的初始话方法          
-(id)initWithJSType:(JSTrackingType)type extraPrama:(id)firstOther, ... NS_REQUIRES_NIL_TERMINATION; // 初始化方法
@end
@interface NSMutableDictionary (JSTracking)
-(void)setSafeObject:(id)aObject forKey:(NSString*)nameStr;
@end