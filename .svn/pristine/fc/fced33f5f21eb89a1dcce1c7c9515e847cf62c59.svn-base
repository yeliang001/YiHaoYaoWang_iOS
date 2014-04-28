//
//  SinaUtil.h
//  testPost
//
//  Created by tianjsh on 11-3-20.
//  Copyright 2010 vsc. All rights reserved.
//

#import "SinaUtil.h"
#import "StringUtil.h"

@implementation SinaUtil
@synthesize username, password;
#pragma mark  分享微博
-(void)postString:(NSString *)status withUrl:(NSURL *)url{
	NSString *postString = [NSString stringWithFormat:@"%@",
                            [status encodeAsURIComponent]];
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
	[request setDelegate:self];
	[self getUserInformation];
    NSString* auth = [NSString stringWithFormat:@"%@:%@", username, password];
    NSString* basicauth = [NSString stringWithFormat:@"Basic %@", [NSString base64encode:auth]];
	[request addRequestHeader:@"Authorization" value:basicauth];
	[request addPostValue:postString forKey:@"status"];
	[request startSynchronous];
	
	[request release];		
}
#pragma mark 得到验证
-(NSURL *)getAuthUrlWithData{
	NSString* aURL =@"http://api.t.sina.com.cn/statuses/update.json";
	NSString *URL = (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)aURL, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8);
	NSURL *finalURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@source=%@", 
											URL,
											([URL rangeOfString:@"?"].location != NSNotFound) ? @"&" : @"?" , 
											kOAuthConsumerKey]];	
    [aURL release];
    [URL release];
	return finalURL;
}
#pragma mark 保持用户信息
-(void)getUserInformation{
	NSUserDefaults *userInformation = [NSUserDefaults standardUserDefaults];
	username = [userInformation valueForKey:@"userName"];
	password = [userInformation valueForKey:@"userPwd"];
	if([username length] < 1 && [password length] <1)
	{
		username = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];//Your Weibo Acount;
		password = [[NSUserDefaults standardUserDefaults]objectForKey:@"userpw"];//Your Weibo Secret;
	}
}
@end
