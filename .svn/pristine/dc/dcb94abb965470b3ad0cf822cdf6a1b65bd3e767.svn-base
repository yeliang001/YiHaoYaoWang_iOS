//
//  BaseViewController.h
//  JieYinPay
//
//  Created by mxy on 11-10-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataHandler.h"

#import "ASIHTTPRequest.h"

#import "OTSOperationEngine.h"
//#import "Trader.h"

#import "UIDevice+IdentifierAddition.h"
#import "NSObject+OTS.h"
#import "OTSServiceHelper.h"
#import "UITableView+LoadingMore.h"
#import "GlobalValue.h"
#import "DoTracking.h"



#define  kVersion @"1.0"
#define  kResponseOK @"1000"

#define THREAD_STATUS_SUBMIT_ORDER  1
#define THREAD_STATUS_CANCEL_ORDER  2
#define THREAD_STATUS_GET_MY_ORDER  3
#define THREAD_STATUS_GET_ORDER_DETAIL  4
#define THREAD_STATUS_GET_MY_FAVORITE   5
#define THREAD_STATUS_GET_SESSION_USER  6
#define THREAD_STATUS_GET_GOOD_RECEIVER 7
#define THREAD_STATUS_LOGOUT    8
#define THREAD_STATUS_ADD_PRODUCTS_TO_CART  9
#define THREAD_STATUS_GET_SESSION_CART 10
#define THREAD_STATUS_LOGIN 11
#define THREAD_STATUS_UNION_LOGIN   12
#define THREAD_STATUS_GET_VERIFY_CODE   13
#define THREAD_STATUS_REGISTE   14
#define THREAD_STATUS_REBUY_TO_CART 15

@class OTSNavigationBar;
@class LoginViewController;


@interface BaseViewController : UIViewController <UIAlertViewDelegate>{
    DataHandler     *dataHandler;
    NSMutableData   *receivedData;
    
    BOOL m_ThreadRunning;
    int m_ThreadStatus;
    NSMutableDictionary *m_Dictionary;
    SEL m_FinishSEL;
}
@property (nonatomic, retain)  NSMutableData *receivedData;
@property (readonly)DataHandler     *dataHandler;
@property (nonatomic, retain)   LoginViewController     *loginVC;
@property(nonatomic, retain)    UIView                  *semiTransBgView;

-(int)doAction:(SEL)aSelector withObject:(id)anObject forKey:(NSString*)anOperKey;
-(void)setUpThreadWithStatus:(int)status showLoading:(BOOL)showLoading withObject:(NSMutableDictionary *)object finishSelector:(SEL)selector;
-(void)stopThread;
-(void)showError:(NSString *)error;
//获取用户信息
-(void)newThreadGetMyOrderWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector;
//获取用户信息
-(void)newThreadGetSessionUserWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector;
//加入购物车
-(void)newThreadAddCartWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector;
//获取购物车
-(void)newThreadGetSessionCartWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector;
//获取验证码
-(void)newThreadGetVerifyCodeWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector;
//登录
-(BOOL)newThreadLoginWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector;
//自动登录
-(void)newThreadAutoLoginWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector;
//获取我的收藏
-(void)newThreadGetMyFavoriteWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector;
//获取收货地址
-(void)newThreadGetGoodReceiverWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector;
//退出登录
-(void)newThreadLogoutWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector;
//获取订单详情
-(void)newThreadGetOrderDetailWithObject:(NSMutableDictionary *)object finishSelector:(SEL)selector;


-(void)moveHoverView:(UIView*)aView inOrOut:(BOOL)aInOrOut;
-(void)moveHoverView:(UIView*)aView inOrOut:(BOOL)aInOrOut offsetY:(int)aOffsetY;
-(void)moveHoverView:(UIView*)aView inOrOut:(BOOL)aInOrOut offsetX:(int)aOffsetX offsetY:(int)aOffsetY;
-(void)moveActionCompleted:(BOOL)isMoveIn view:(UIView*)aView;
-(BOOL)loginIfNeeded;
-(void)popLoginView;
@end
