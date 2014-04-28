//
//  Trader.h
//  ProtocolDemo
//
//  Created by vsc on 11-1-20.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Trader : NSObject {
@private
	NSString * clientAppVersion;
	NSString * clientSystem;
	NSString * clientTelnetPhone;
	NSString * clientVersion;
	NSString * interfaceVersion;
    NSNumber * latitude;
    NSNumber * longitude;
	NSString * protocolStr;//对应protocol属性
	NSString * provinceId;
    NSString * userToken;
	NSNumber * serialVersionUID;
	NSString * traderName;
	NSString * traderPassword;
	NSString * unionKey;
    NSString * deviceCode;
    NSString * deviceCodeNotEncrypt;
}
@property(retain,nonatomic)NSString * deviceCodeNotEncrypt;
@property(retain,nonatomic)NSString * clientAppVersion;
@property(retain,nonatomic)NSString * clientSystem;
@property(retain,nonatomic)NSString * clientTelnetPhone;
@property(retain,nonatomic)NSString * clientVersion;
@property(retain,nonatomic)NSString * interfaceVersion;
@property(retain,nonatomic)NSNumber * latitude;
@property(retain,nonatomic)NSNumber * longitude;
@property(retain,nonatomic)NSString * protocolStr;
@property(retain,nonatomic)NSString * provinceId;
@property(retain,nonatomic)NSString * userToken;
@property(retain,nonatomic)NSNumber * serialVersionUID;
@property(retain,nonatomic)NSString * traderName;
@property(retain,nonatomic)NSString * traderPassword;
@property(retain,nonatomic)NSString * unionKey;
@property(retain,nonatomic)NSString * deviceCode;


-(NSString *) toXml;

-(NSDictionary*)toParamDict;

@end
