//
//  RegistResultInfo.h
//  TheStoreApp
//
//  Created by LinPan on 13-8-15.
//
//

#import "ResultInfo.h"
@class UserInfo;

@interface RegistResultInfo : ResultInfo

@property(nonatomic,assign) int resultCode;
@property(nonatomic,copy) NSString *errorInfo;
@property(nonatomic,copy) NSString *token;
@property(nonatomic,copy) NSString *security;
@property(nonatomic,retain) UserInfo *userInfo;
@end
