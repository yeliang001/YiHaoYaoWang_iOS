//
//  MicroBlogService.h
//  TheStoreApp
//
//  Created by linyy on 11-7-15.
//  Copyright 2011 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ConnectAction;
@class ASIHTTPRequest;
@class ConnectAction;
@class LocationVO;
@class SyncVO;
@class StatusVO;

@interface MicroBlogService : NSObject <NSXMLParserDelegate>{
@private NSString * baseUrl;
@private ASIHTTPRequest * request;
@private ConnectAction * conn;
@private int actionResult;
@private int serializeAction;
@private NSXMLParser * parser;
@private NSString * currentResult;
//@private NSObject * serializeResult;
@private BOOL sendComplete;
@private NSData * resultData;
@private int connectedTimes;
@private int iResultValue;
}

-(int)shareCheck:(NSString *)userName password:(NSString *)password targetId:(long)targetId;//返回结果0为失败，1为成功
-(void)sharePublish:(NSString *)userName password:(NSString *)password 
		   targetId:(long)targetId comment:(NSString *)comment guid:(NSString *)guid syncs:(NSString *)syncs;
-(int)saveShow:(NSString *)aid userName:(NSString *)u orderCode:(NSString *)oid productId:(NSString *)pid
	merchantId:(NSString *)mid pronvinceId:(NSString *)vid gpsX:(NSString *)gx gpsY:(NSString *)gy
	  targetId:(NSString *)tid fromId:(NSString *)fid;
-(int)exists:(NSString *)aid userName:(NSString *)u orderCode:(NSString *)oid productId:(NSString *)pid 
 pronvinceId:(NSString *)vid;
-(LocationVO *)locations:(NSString *)userName password:(NSString *)password 
				targetId:(long)targetId pageNum:(long)pageNum count:(long)count query:(NSString *)query 
					city:(NSString *)city lon:(float)lon lat:(float)lat;//用户名 必填，密码 必填，微博类型 1-新浪 3-街旁 必填，
//页码 非必填，每页记录数 非必填，查询关键字 必填，地区 非必填，经度 必填，纬度 必填
-(SyncVO *)syncs:(NSString *)userName password:(NSString *)password targetId:(long)targetId;
-(StatusVO *)checkin:(NSString *)userName password:(NSString *)password 
			targetId:(long)targetId comment:(NSString *)comment guid:(NSString *)guid syncs:(NSString *)syncs;
@end

@interface MicroBlogService(private)

-(void)requestDone:(ASIHTTPRequest *)_request;
-(void)requestWentWrong:(ASIHTTPRequest *)_request;
-(void)doSerialize:(NSData *)xmlData;
-(void)requestDoneEntity:(ASIHTTPRequest *)_request;
-(void)requestWentWrongEntity:(ASIHTTPRequest *)_request;
-(NSObject *)parseEntity;
@end
