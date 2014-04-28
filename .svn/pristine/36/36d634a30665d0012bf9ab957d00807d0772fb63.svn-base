//
//  OTSUserSwitcher.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-9-20.
//
//  

#import <Foundation/Foundation.h>

@class UserVO;

// 用户类型
typedef enum
{
    kUserOfStore = 0     // 1号店用户
    , kUserOfMore      // 1号商城用户
}EOTSUserType;

// class: OTSUserSwitcher
// description：用于1号店和1号商城之间的账户切换
@interface OTSUserSwitcher : NSObject

@property(copy) NSString *mallToken;    // 1号商城token
@property(copy) NSString *storeToken;   // 1号店token

@property(copy) NSString *currentToken; // 当前token, 根据用户类型返回
@property(retain) UserVO *currentUser;  // 保存当前用户vo
@property(readonly) EOTSUserType  currentUserType; // 当前用户类型


// 获得单实例
+ (OTSUserSwitcher *)sharedInstance;    

// 切换到1商城用户
- (void)switchToMoreUser;

// 切换到1商城用户
// aToken : 1号商城用户token
- (void)switchToMoreUserWithToken:(NSString*)aToken;

// 切换到1号店用户
- (void)switchToStoreUser;

//切换到1号店用户，不重新获取用户信息
- (void)justSwitchToStoreUserWithToken:(NSString*)aToken;

// 切换到1号店用户
// aToken : 1号店用户token
- (void)switchToStoreUserWithToken:(NSString*)aToken;

// 处理1号商城跳转的requestString
-(void)handleWapReuestString:(NSString*)aRequestString;

//将token切换到当前省份
-(void)changeProvinceForToken:(NSString *)token;
@end

#define NOTIFY_NAME_USER_TYPE_SWITCHED  @"NOTIFY_NAME_USER_TYPE_SWITCHED"   // 用户类型切换通知
#define NOTIFY_NAME_USER_VO_UPDATED  @"NOTIFY_NAME_USER_VO_UPDATED"   // 用户VO更新通知
