//
//  ShareToMicroBlog.h
//  TheStoreApp
//
//  Created by linyy on 11-7-21.
//  Copyright 2011 vsc. All rights reserved.
//	功能点，在晒单页面登录后，分享新浪微博发送一个NSNumber型的0，街旁为1
//

typedef enum _ShareToMicroBlogType{
	ShareToSina=1,
	ShareToJiePang=3,
} ShareToMicroBlogType;

#import <Foundation/Foundation.h>

@class MicroBlogService;
@class LocationVO;
@class SyncVO;
@class StatusVO;

@interface ShareToMicroBlog : NSObject <UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>{
	UITextField * userPassword;						//输入秘密框
	UITextField * userName;							//输入用户名框
	UIAlertView * jiePangAlert;						//街旁警告框
	UIAlertView * sinaAlert;						//新浪警告框
    MicroBlogService * blogService;
    UITextView * shareText;
	UILabel * contentLength;
	NSString * content;
	ShareToMicroBlogType currentBlog;
	LocationVO * locationVO;
	long myCount;
	long myPageNum;
	NSString * myQuery;
	float myLat;
	float myLon;
	NSString * myCity;
    BOOL isFromGroupon;                             //传入参数
    BOOL isExclusive;                               //传入参数，是否是掌上专享
}

@property(nonatomic,retain)LocationVO * locationVO;
@property(nonatomic)BOOL isFromGroupon;
@property(nonatomic)BOOL isExclusive;

-(void)shareProduct:(NSString *)pName price:(NSString *)pPrice productId:(NSString *)pId blogType:(ShareToMicroBlogType) blogType;
-(void)shareOrder:(NSString *)pName price:(NSString *)pPrice productId:(NSString *)pId blogType:(ShareToMicroBlogType) blogType;
-(void)shareMessage:(NSString *)messageContent blogType:(ShareToMicroBlogType) blogType;
-(void)showBlogAlertView:(ShareToMicroBlogType)blogType;
-(void)shareBlog:(NSString *)_content blogType:(ShareToMicroBlogType)blogType;
-(void)showLoginView:(ShareToMicroBlogType)blogType;
-(BOOL)landUser:(NSString *)name pass:(NSString *)password blogType:(ShareToMicroBlogType) blogType;
-(void)getLocationsOnShow:(ShareToMicroBlogType)blogType pageNum:(long)pageNum count:(long)count 
					  query:(NSString *)query city:(NSString *)city lon:(float)lon lat:(float)lat;
-(LocationVO *)getLocations:(ShareToMicroBlogType)blogType pageNum:(long)pageNum count:(long)count 
					  query:(NSString *)query city:(NSString *)city lon:(float)lon lat:(float)lat;
-(SyncVO *)getSynchronousVO:(NSString *)name password:(NSString *)password blogType:(ShareToMicroBlogType)blogType;
-(StatusVO *)checkin:(NSString *)name password:(NSString *)password 
			blogType:(ShareToMicroBlogType)blogType comment:(NSString *)comment guid:(NSString *)guid syncs:(NSString *)syncs;
-(void)saveShow:(NSString *)aid userName:(NSString *)u orderCode:(NSString *)oid 
	  productId:(NSString *)pid merchantId:(NSString *)mid pronvinceId:(NSString *)vid 
		   gpsX:(NSString *)gx gpsY:(NSString *)gy targetId:(NSString *)tid fromId:(NSString *)fid;
-(void)sharePublish:(NSString *)name password:(NSString *)password 
		   targetId:(long)targetId comment:(NSString *)comment guid:(NSString *)guid syncs:(NSString *)syncs;
#pragma mark 自己编辑框中输入的话，调用该方法
-(void)shareInThread;
-(void)shareInThreadFail;
-(NSMutableArray *)readFile:(ShareToMicroBlogType)blogType;
@end

@interface ShareToMicroBlog(private)

-(void)showBlog:(ShareToMicroBlogType)blogType;
-(void)closeKeyBoard:(id)sender;
-(void)getLocationsInThread;

-(void)writeFile:(ShareToMicroBlogType)blogType;
#pragma mark 自动登录调用该方法
-(void)landInThread;
-(void)landInThreadFail;
@end
