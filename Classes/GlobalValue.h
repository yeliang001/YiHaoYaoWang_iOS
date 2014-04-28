//
//  GlobalValue.h
//  TheStoreApp
//
//  Created by linyy on 11-2-22.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Page.h"
#import "VersionInfo.h"
@class Trader;
@class DownloadVO;
@class ShareToMicroBlog;
@class UserVO;
@class UserInfo;
@class OrderInfo;

@interface GlobalValue : NSObject {
	NSString * token;
	NSNumber * provinceId;
    NSString * gpsProvinceStr;
	NSNumber * orderId;
	Trader * trader;
	NSNumber * status;
	NSNumber * errorType;
	NSString * errorString;
	NSString * userName;
	NSString * userPassword;
	NSNumber * myStoreIndex;
    NSArray * categoryTitles;
	NSString * toActivityFromPage;
    NSNumber * toOrderFromPage;
	NSNumber * toJiePangFromPage;
	VersionInfo * downloadVO;	// 是否需要版本更新
	BOOL isFirstInCategory;		// 是否第一次进入分类
	BOOL isNeedReload;			// 从地址返回是否需要刷新
	BOOL isFirstLoad;			
    BOOL haveAlertViewInShow;
	BOOL isFromMyOrder;
	Page *hotPage;
    NSString * sinaUserName;
    NSString * sinaPassword;
	NSString * jiePangUserName;
    NSString * jiePangPassword;
    ShareToMicroBlog * mbService;
	CGFloat width;
	CGFloat height;
	NSString * localCartFileName;
    NSDate * lastRefreshTime;//上次刷新时间
    NSString * nickName;
    NSString * userImg;
    BOOL isUnionLogin;
    //** 跟踪分类筛选的层级
    NSMutableArray* cateLeveltrackArray;
    BOOL shouldDownLoadIcon;//3G下图片下载的开关
    NSString* deviceToken;
    UserVO* currentUser;
    NSString* sessionID;
    NSString* alixpayOrderId;//跳转到支付宝app时记住ID
    BOOL isFromOrderDetailForAlix;//记住跳转支付包app的页面
    BOOL isFromOrderGROUPDetailForAlix;//记住跳转支付包app的页面
    BOOL isFromOrderSuccessForAlix;//记住跳转支付包app的页面

}  
+(GlobalValue *)getGlobalValueInstance;

@property(retain, nonatomic) NSString *ywToken; //药店的token
@property(retain, nonatomic) UserInfo *userInfo; //药店中的记录登陆的用户
@property(assign, nonatomic) NSInteger currentRepertory;//当前仓库号
@property(retain, nonatomic) NSMutableArray *currentOrderProductList; //当前要处理的订单商品，在checkorder 时 选地址回来，orderProductList 会丢，所以存一份全剧变量
@property(retain, nonatomic) OrderInfo *alipayingOrder; //正用支付宝支付的订单内容




@property(copy)NSString * storeToken;   // 1号店token
@property(readonly)NSString * token;    // 当前token，可能为 1号店 或 1号商城 药店中废弃

@property(nonatomic,retain)NSNumber * provinceId;
@property(nonatomic,retain)NSString * gpsProvinceStr;
@property(nonatomic,retain)NSNumber * orderId;
@property(nonatomic,retain)Trader * trader;
@property(nonatomic,retain)VersionInfo * downloadVO;
@property(nonatomic,retain)NSNumber * status;
@property(nonatomic,retain)NSNumber * errorType;
@property(nonatomic,retain)NSString * errorString;
@property(nonatomic,retain)NSString * userName;
@property(nonatomic,retain)NSString * userPassword;
@property(nonatomic,retain)NSNumber * myStoreIndex;
@property(nonatomic,retain)NSString * toActivityFromPage;
@property(nonatomic,retain)NSNumber * toOrderFromPage;
@property(nonatomic,retain)NSNumber * toJiePangFromPage;
@property(nonatomic, retain)NSArray * categotyTitles;
@property(nonatomic)BOOL isFirstInCategory;
@property(nonatomic)BOOL isNeedReload;
@property(nonatomic)BOOL isFirstLoad;
@property(nonatomic)BOOL isFromMyOrder;
@property(nonatomic)BOOL haveAlertViewInShow;
@property(nonatomic,retain)Page *hotPage;
@property(nonatomic,retain)NSString * sinaUserName;
@property(nonatomic,retain)NSString * sinaPassword;
@property(nonatomic,retain)NSString * jiePangUserName;
@property(nonatomic,retain)NSString * jiePangPassword;
@property(nonatomic,retain)ShareToMicroBlog * mbService;
@property(nonatomic)CGFloat width;
@property(nonatomic)CGFloat height;
@property(nonatomic,retain)NSString * localCartFileName;
@property(nonatomic,retain)NSDate * lastRefreshTime;
@property(nonatomic,retain)NSString * nickName;
@property(nonatomic,retain)NSString * userImg;
@property(nonatomic)BOOL isUnionLogin;

@property(retain) NSArray                   *bankVOList;
@property(nonatomic,retain) NSMutableArray* cateLeveltrackArray;
@property(nonatomic,assign)BOOL shouldDownLoadIcon;
@property(nonatomic, retain)NSString* deviceToken;

@property(nonatomic,retain)UserVO* currentUser;
@property(nonatomic,retain)NSString* sessionID;
@property(nonatomic,retain)NSString * alixpayOrderId;
@property(nonatomic)BOOL isFromOrderDetailForAlix;
@property(nonatomic)BOOL isFromOrderGROUPDetailForAlix;
@property(nonatomic)BOOL isFromOrderSuccessForAlix;

@property(assign, nonatomic) BOOL bShowAdultCategory;

//用于选择服务器的ip
@property(assign, nonatomic) NSInteger hostIndex;


+(BOOL) useVirtualService;
@end
