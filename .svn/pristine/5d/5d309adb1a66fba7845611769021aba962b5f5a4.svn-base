//
//  OTSUnionLoginHelper.h
//  TheStoreApp
//
//  Created by yiming dong on 12-8-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTSUnionLoginHelper : NSObject

@property(retain) NSString     *userNameSina;
@property(retain) NSString     *userNameQQ;
@property(retain) NSString     *userNameAli;
@property(retain) NSString     *userNameTaobao;

+ (OTSUnionLoginHelper *)sharedInstance;


// called when web view did finish loading, change user name field in web view
-(void)handleQQLoginWithWebView:(UIWebView*)aWebView;
-(void)handleSinaLoginWithWebView:(UIWebView*)aWebView;
-(void)handleAliLoginWithWebView:(UIWebView*)aWebView  isAliUserName:(BOOL)aIsAliUserName;

// called when web view should start request login, record the user name
-(void)saveQQUserNameFromWebView:(UIWebView*)aWebView;
-(void)saveSinaUserNameFromWebView:(UIWebView*)aWebView;
-(void)saveAliUserNameFromWebView:(UIWebView*)aWebView isAliUserName:(BOOL)aIsAliUserName;
@end
