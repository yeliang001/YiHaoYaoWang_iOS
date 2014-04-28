//
//  UserManager.h
//  TheStoreApp
//
//  Created by towne on 12-6-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PLIST_USERMANAGER @"TheUserManager.plist"
#define KEY     @"Key"
#define KEY_USER_NAME @"UserName"
#define KEY_THEONESTOREACCOUNT @"TheOneStoreAccount"
#define KEY_USER_PASS @"UserPass"
#define KEY_REMEMBER  @"RememberMe"
#define KEY_COCODE    @"Cocode"
#define KEY_UNIONLOGIN  @"UnionLogin"
#define KEY_NICKNAME  @"NickName"
#define KEY_USERIMG   @"UserImg"
#define KEY_AUTOLOGSTATUS @"AutoLoginStatus"


@interface UserManageTool : NSObject
{
    NSString * m_UserManagerPlistPath;
    NSMutableDictionary * m_dicUserManager;
    bool m_bFileExist;
}

@property(nonatomic,retain) NSMutableDictionary *m_dicUserManager;

- (void)AddOrUpdate:(NSString *)uuid 
           withName:(NSString *)username
           withTheOneStoreAccount:(NSString *)account
           withPass:(NSString *)userpass
           withRememberme:(NSNumber *)rememberme
           withCocode:(NSString *)cocode
           withUnionlogin:(NSString *)unionlogin
           withNickname:(NSString *)nickname
           withUserimg:(NSString *)userimg
           withAutoLoginStatus:(NSString *)autologinstatus
           withNeedToSave:(BOOL) bNeedSave;

- (void)Del:(NSString *)uuid withNeedToSave:(BOOL) bNeedSave;

- (void)UpdateFiled : (NSString *)uuid withFiledKey:(NSString *)key withValue:(NSObject *)val withNeedToSave:(BOOL) bNeedSave;

+ (UserManageTool *) sharedInstance;

- (NSDictionary *)GetUser;

- (NSString *)GetUserName;

- (NSString *)GetTheOneStoreAccount;

- (NSString *)GetUserPass;

- (NSNumber *)GetRemberStatus;

- (NSString *)GetCocode;

- (NSString *)GetUnionLogin;

- (NSString *)GetNickName;

- (NSString *)GetUserImg;

- (NSString *)GetAutoLoginStatus;

@end
