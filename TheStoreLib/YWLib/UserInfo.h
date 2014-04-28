//
//  UserInfo.h
//  TheStoreApp
//
//  Created by LinPan on 13-8-14.
//
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (copy, nonatomic) NSString *telephone;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *loginMobile;
@property (copy, nonatomic) NSString *partnerType;
@property (copy, nonatomic) NSString *partnerName;
@property (copy, nonatomic) NSString *cellphone;
@property (copy, nonatomic) NSString *salt;
@property (copy, nonatomic) NSString *loginEmail;
@property (copy, nonatomic) NSString *isDeleted;
@property (copy, nonatomic) NSString *createDate;
@property (copy, nonatomic) NSString *userLevelStartTime;
@property (copy, nonatomic) NSString *userLevelId;
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *uid;  //跟name一样
@property (copy, nonatomic) NSString *modifyDate;
@property (copy, nonatomic) NSString *income;
@property (copy, nonatomic) NSString *enterCount;
@property (copy, nonatomic) NSString *openId;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *ipAddress;
@property (copy, nonatomic) NSString *userScore;
@property (copy, nonatomic) NSString *lastLoginTime;
@property (copy, nonatomic) NSString *registerIP;
@property (copy, nonatomic) NSString *nickName;
@property (copy, nonatomic) NSString *ecUserId;  //用户id
@property (copy, nonatomic) NSString *birthDay;
@property (copy, nonatomic) NSString *gender;
@property (copy, nonatomic) NSString *userLevelEndTime;
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *security;
@property (copy, nonatomic) NSString *imgUrl;
@property (copy, nonatomic) NSString *levelName;

@end
