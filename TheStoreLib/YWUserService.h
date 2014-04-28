//
//  YWUserService.h
//  TheStoreApp
//
//  Created by LinPan on 13-8-14.
//
//

#import <Foundation/Foundation.h>
#import "YWBaseService.h"
@class UserInfo;
@class LoginResultInfo;
@class RegistResultInfo;
@interface YWUserService : YWBaseService

- (LoginResultInfo *)login:(NSDictionary *)paramDic;
- (RegistResultInfo *)regist:(NSDictionary *)paramDic;
- (UserInfo *)getUserInfo:(NSDictionary *)paramDic;
- (LoginResultInfo *)loginUnion:(NSDictionary *)paramDic;
@end
