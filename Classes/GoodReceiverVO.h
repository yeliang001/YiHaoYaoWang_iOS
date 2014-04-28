//
//  GoodReceiverVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GoodReceiverVO : NSObject {
@private
	NSString * address1;
	NSNumber * cityId;
	NSString * cityName;
	NSNumber * countryId;
	NSString * countryName;
	NSNumber * countyId;
	NSString * countyName;
	NSNumber * defaultAddressId;
	NSNumber * nid;//收获地址Id
	NSNumber * mcsiteid;
	NSString * postCode;
	NSNumber * provinceId;
	NSString * provinceName;
	NSString * receiveName;
	NSString * receiverEmail;
	NSString * receiverMobile;
	NSString * receiverPhone;
	NSString * recordName;
}
@property(retain,nonatomic)NSString * address1;
@property(retain,nonatomic)NSNumber * cityId;
@property(retain,nonatomic)NSString * cityName;
@property(retain,nonatomic)NSNumber * countryId;
@property(retain,nonatomic)NSString * countryName;
@property(retain,nonatomic)NSNumber * countyId;
@property(retain,nonatomic)NSString * countyName;
@property(retain,nonatomic)NSNumber * defaultAddressId;
@property(retain,nonatomic)NSNumber * nid;//收获地址Id
@property(retain,nonatomic)NSNumber * mcsiteid;
@property(retain,nonatomic)NSString * postCode;
@property(retain,nonatomic)NSNumber * provinceId;
@property(retain,nonatomic)NSString * provinceName;
@property(retain,nonatomic)NSString * receiveName;
@property(retain,nonatomic)NSString * receiverEmail;
@property(retain,nonatomic)NSString * receiverMobile;
@property(retain,nonatomic)NSString * receiverPhone;
@property(retain,nonatomic)NSString * recordName;

@property(retain,nonatomic)NSString * invoiceTitle; //发票title ，fuck，sb订单的地址信息中有这个字段
@property(retain,nonatomic)NSString * invoiceType;  //
@property(retain,nonatomic)NSString * invoiceInfo; 

-(NSString *)toXML;

@end
