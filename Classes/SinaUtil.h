//
//  SinaUtil.h
//  testPost
//
//  Created by tianjsh on 11-3-20.
//  Copyright 2010 vsc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"

#define kOAuthConsumerKey				@"356866357"		//Your Sina OAuth Key
#define kOAuthConsumerSecret			@"5905214414e9e8a5aa50cb17bd499210"		//Your Sina OAuth Secret

@interface SinaUtil : NSObject {
	NSString *username;//用户名
	NSString *password;//密码
	NSString *responseString;
}
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;

-(void)postString:(NSString *)status withUrl:(NSURL *)url;//提交分享
-(NSURL *)getAuthUrlWithData;//获得验证
-(void)getUserInformation;//保存用户名
@end
