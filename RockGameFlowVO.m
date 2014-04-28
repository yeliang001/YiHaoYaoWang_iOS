//
//  RockGameFlowVO.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-2.
//
//

#import "RockGameFlowVO.h"

@implementation RockGameFlowVO
@synthesize nid = _nid;
@synthesize userId = _userId;
@synthesize rockGameId = _rockGameId;
@synthesize provinceId = _provinceId;
@synthesize inviteeName = _inviteeName;
@synthesize inviteePhone = _inviteePhone;
@synthesize presentId = _presentId;
@synthesize audioUrl = _audioUrl;
@synthesize flowStatus = _flowStatus;
@synthesize couponId = _couponId;
@synthesize createTime = _createTime;
@synthesize updateTime = _updateTime;
@synthesize commonRockResultVO = _commonRockResultVO;

- (void)dealloc
{
    [_nid release];
    [_userId release];
    [_rockGameId release];
    [_provinceId release];
    [_inviteeName release];
    [_inviteePhone release];
    [_presentId release];
    [_audioUrl release];
    [_flowStatus release];
    [_couponId release];
    [_createTime release];
    [_updateTime release];
    [_commonRockResultVO release];
    
    [super dealloc];
}

-(NSString*)toXml{
    NSMutableString *string=[[[NSMutableString alloc] initWithString:@"<com.yihaodian.mobile.vo.promotion.RockGameFlowVO>"] autorelease];
    if (_nid!=nil) {
        [string appendFormat:@"<nid>%@</nid>",_nid];
    }
    if (_userId!=nil) {
        [string appendFormat:@"<userId>%@</userId>",_userId];
    }
    if (_rockGameId!=nil) {
        [string appendFormat:@"<rockGameId>%@</rockGameId>",_rockGameId];
    }
    if (_provinceId!=nil) {
        [string appendFormat:@"<provinceId>%@</provinceId>",_provinceId];
    }
    if (_inviteeName!=nil) {
        [string appendFormat:@"<inviteeName>%@</inviteeName>",_inviteeName];
    }
    if (_inviteePhone!=nil) {
        [string appendFormat:@"<inviteePhone>%@</inviteePhone>",_inviteePhone];
    }
    if (_presentId!=nil) {
        [string appendFormat:@"<presentId>%@</presentId>",_presentId];
    }
    if (_audioUrl!=nil) {
        [string appendFormat:@"<audioUrl>%@</audioUrl>",_audioUrl];
    }
    if (_flowStatus!=nil) {
        [string appendFormat:@"<flowStatus>%@</flowStatus>",_flowStatus];
    }
    if (_couponId!=nil) {
        [string appendFormat:@"<couponId>%@</couponId>",_couponId];
    }
    if (_createTime!=nil) {
        [string appendFormat:@"<createTime>%@</createTime>",_createTime];
    }
    if (_updateTime!=nil) {
        [string appendFormat:@"<updateTime>%@</updateTime>",_updateTime];
    }
    if (_commonRockResultVO!=nil) {
        [string appendFormat:@"<commonRockResultVO>%@</commonRockResultVO>",_commonRockResultVO];
    }
    [string appendString:@"</com.yihaodian.mobile.vo.promotion.RockGameFlowVO>"];
    return string;
}
@end
