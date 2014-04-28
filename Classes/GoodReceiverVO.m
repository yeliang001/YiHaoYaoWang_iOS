//
//  GoodReceiverVO.m
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import "GoodReceiverVO.h"


@implementation GoodReceiverVO
@synthesize address1;
@synthesize cityId;
@synthesize cityName;
@synthesize countryId;
@synthesize countryName;
@synthesize countyId;
@synthesize countyName;
@synthesize defaultAddressId;
@synthesize nid;//收获地址Id
@synthesize mcsiteid;
@synthesize postCode;
@synthesize provinceId;
@synthesize provinceName;
@synthesize receiveName;
@synthesize receiverEmail;
@synthesize receiverMobile;
@synthesize receiverPhone;
@synthesize recordName;

-(NSString *)toXML
{
    NSMutableString *string=[[[NSMutableString alloc] initWithString:@"<com.yihaodian.mobile.vo.address.GoodReceiverVO>"] autorelease];
    if ([self address1]!=nil) {
        [string appendFormat:@"<address1>%@</address1>",[self address1]];
    }
    if ([self cityId]!=nil) {
        [string appendFormat:@"<cityId>%@</cityId>",[self cityId]];
    }
    if ([self cityName]!=nil) {
        [string appendFormat:@"<cityName>%@</cityName>",[self cityName]];
    }
    if ([self countryId]!=nil) {
        [string appendFormat:@"<countryId>%@</countryId>",[self countryId]];
    }
    if ([self countryName]!=nil) {
        [string appendFormat:@"<countryName>%@</countryName>",[self countryName]];
    }
    if ([self countyId]!=nil) {
        [string appendFormat:@"<countyId>%@</countyId>",[self countyId]];
    }
    if ([self countyName]!=nil) {
        [string appendFormat:@"<countyName>%@</countyName>",[self countyName]];
    }
    if ([self defaultAddressId]!=nil) {
        [string appendFormat:@"<defaultAddressId>%@</defaultAddressId>",[self defaultAddressId]];
    }
    if ([self nid]!=nil) {
        [string appendFormat:@"<id>%@</id>",[self nid]];
    }
    if ([self mcsiteid]!=nil) {
        [string appendFormat:@"<mcsiteid>%@</mcsiteid>",[self mcsiteid]];
    }
    if ([self postCode]!=nil) {
        [string appendFormat:@"<postCode>%@</postCode>",[self postCode]];
    }
    if ([self provinceId]!=nil) {
        [string appendFormat:@"<provinceId>%@</provinceId>",[self provinceId]];
    }
    if ([self provinceName]!=nil) {
        [string appendFormat:@"<provinceName>%@</provinceName>",[self provinceName]];
    }
    if ([self receiveName]!=nil) {
        [string appendFormat:@"<receiveName>%@</receiveName>",[self receiveName]];
    }
    if ([self receiverEmail]!=nil) {
        [string appendFormat:@"<receiverEmail>%@</receiverEmail>",[self receiverEmail]];
    }
    if ([self receiverMobile]!=nil) {
        [string appendFormat:@"<receiverMobile>%@</receiverMobile>",[self receiverMobile]];
    }
    if ([self receiverPhone]!=nil) {
        [string appendFormat:@"<receiverPhone>%@</receiverPhone>",[self receiverPhone]];
    }
    if ([self recordName]!=nil) {
        [string appendFormat:@"<recordName>%@</recordName>",[self recordName]];
    }
    [string appendString:@"</com.yihaodian.mobile.vo.address.GoodReceiverVO>"];
    return string;
}

-(void)dealloc{
    if(address1!=nil){
        [address1 release];
    }
    if(cityId!=nil){
        [cityId release];
    }
    if(cityName!=nil){
        [cityName release];
    }
    if(countryId!=nil){
        [countryId release];
    }
    if(countryName!=nil){
        [countryName release];
    }
    if(countyId!=nil){
        [countyId release];
    }
    if(countyName!=nil){
        [countyName release];
    }
    if(defaultAddressId!=nil){
        [defaultAddressId release];
    }
    if(nid!=nil){
        [nid release];
    }
    if(mcsiteid!=nil){
        [mcsiteid release];
    }
    if(postCode!=nil){
        [postCode release];
    }
    if(provinceId!=nil){
        [provinceId release];
    }
    if(provinceName!=nil){
        [provinceName release];
    }
    if(receiveName!=nil){
        [receiveName release];
    }
    if(receiverEmail!=nil){
        [receiverEmail release];
    }
    if(receiverMobile!=nil){
        [receiverMobile release];
    }
    if(receiverPhone!=nil){
        [receiverPhone release];
    }
    if(recordName!=nil){
        [recordName release];
    }
    
    [_invoiceInfo release];
    [_invoiceTitle release];
    [_invoiceType release];
    
    
    [super dealloc];
}


@end
