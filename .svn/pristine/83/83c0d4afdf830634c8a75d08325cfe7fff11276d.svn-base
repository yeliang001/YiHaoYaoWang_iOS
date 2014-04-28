//
//  OTSUnionLoginHelper.m
//  TheStoreApp
//
//  Created by yiming dong on 12-8-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSUnionLoginHelper.h"

#define OTS_UNION_LOGIN_USER_NAME_SINA      @"ots_union_login_user_name_sina"
#define OTS_UNION_LOGIN_USER_NAME_QQ        @"ots_union_login_user_name_qq"
#define OTS_UNION_LOGIN_USER_NAME_ALI       @"ots_union_login_user_name_ali"
#define OTS_UNION_LOGIN_USER_NAME_TAOBAO    @"ots_union_login_user_name_taobao"

@implementation OTSUnionLoginHelper
@dynamic userNameQQ
, userNameAli
, userNameSina
, userNameTaobao;

#pragma mark -
-(NSString*)userNameSina
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:OTS_UNION_LOGIN_USER_NAME_SINA];
}

-(void)setUserNameSina:(NSString *)userNameSina
{
    userNameSina = userNameSina ? userNameSina : @"";
    [[NSUserDefaults standardUserDefaults] setObject:userNameSina forKey:OTS_UNION_LOGIN_USER_NAME_SINA];
}

-(NSString*)userNameQQ
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:OTS_UNION_LOGIN_USER_NAME_QQ];
}

-(void)setUserNameQQ:(NSString *)userNameQQ
{
    userNameQQ = userNameQQ ? userNameQQ : @"";
    [[NSUserDefaults standardUserDefaults] setObject:userNameQQ forKey:OTS_UNION_LOGIN_USER_NAME_QQ];
}

-(NSString*)userNameAli
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:OTS_UNION_LOGIN_USER_NAME_ALI];
}

-(void)setUserNameAli:(NSString *)userNameAli
{
    userNameAli = userNameAli ? userNameAli : @"";
    [[NSUserDefaults standardUserDefaults] setObject:userNameAli forKey:OTS_UNION_LOGIN_USER_NAME_ALI];
}

-(NSString*)userNameTaobao
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:OTS_UNION_LOGIN_USER_NAME_TAOBAO];
}

-(void)setUserNameTaobao:(NSString *)userNameTaobao
{
    userNameTaobao = userNameTaobao ? userNameTaobao : @"";
    [[NSUserDefaults standardUserDefaults] setObject:userNameTaobao forKey:OTS_UNION_LOGIN_USER_NAME_TAOBAO];
}


#pragma mark -
-(void)handleQQLoginWithWebView:(UIWebView*)aWebView
{
    NSString* userName = self.userNameQQ;
    if (userName && [userName length] > 0)
    {
        NSString* jsStr = [NSString stringWithFormat:@"document.getElementById('u').value = '%@'", userName];
        [aWebView stringByEvaluatingJavaScriptFromString:jsStr];
    }
}

-(void)handleSinaLoginWithWebView:(UIWebView*)aWebView
{
    NSString* userName = self.userNameSina;
    if (userName && [userName length] > 0)
    {
        NSString* jsStr = [NSString stringWithFormat:@"document.getElementById('userId').value = '%@'", userName];
        [aWebView stringByEvaluatingJavaScriptFromString:jsStr];
    }
}

-(void)handleAliLoginWithWebView:(UIWebView*)aWebView isAliUserName:(BOOL)aIsAliUserName
{
    NSString* userName = aIsAliUserName ? self.userNameAli : self.userNameTaobao;
    
    if (userName && [userName length] > 0)
    {
        NSString* jsStr = [NSString stringWithFormat:@"document.getElementsByName('logonId')[0].value = '%@'", userName];
        [aWebView stringByEvaluatingJavaScriptFromString:jsStr];
    } 
}

#pragma mark -

-(void)saveQQUserNameFromWebView:(UIWebView*)aWebView
{
    NSString* userName = [aWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('u').value"];
    self.userNameQQ = userName;
}

-(void)saveSinaUserNameFromWebView:(UIWebView*)aWebView
{
    NSString* userName = [aWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('userId').value"];
    self.userNameSina = userName;
}

-(void)saveAliUserNameFromWebView:(UIWebView*)aWebView isAliUserName:(BOOL)aIsAliUserName
{
    NSString* userName = [aWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('logonId')[0].value"];
    DebugLog(@"save ali username:%@", userName);
    
    if (aIsAliUserName)
    {
        self.userNameAli = userName;
    }
    else
    {
        self.userNameTaobao = userName;
    }
    
}

#pragma mark - singleton methods
static OTSUnionLoginHelper *sharedInstance = nil;

+ (OTSUnionLoginHelper *)sharedInstance
{ 
    @synchronized(self) 
    { 
        if (sharedInstance == nil) 
        { 
            sharedInstance = [[self alloc] init]; 
        } 
    } 
    
    return sharedInstance; 
} 

+ (id)allocWithZone:(NSZone *)zone 
{ 
    @synchronized(self) 
    { 
        if (sharedInstance == nil) 
        { 
            sharedInstance = [super allocWithZone:zone]; 
            return sharedInstance; 
        } 
    } 
    
    return nil; 
} 

- (id)copyWithZone:(NSZone *)zone 
{ 
    return self; 
} 

- (id)retain 
{ 
    return self; 
} 

- (NSUInteger)retainCount 
{ 
    return NSUIntegerMax; 
} 

- (oneway void)release
{ 
} 

- (id)autorelease 
{ 
    return self; 
}

#pragma mark - deprecated
#pragma mark - helper
//-(void)replaceString:(NSString*)anOriginString 
//          withString:(NSString*)aNewString 
//           forString:(NSMutableString*)aParentString
//{
//    if (aParentString && anOriginString && aNewString)
//    {
//        [aParentString replaceOccurrencesOfString:anOriginString withString:aNewString options:NSLiteralSearch range:NSMakeRange(0, [aParentString length])];
//    }
//}
//
//#pragma mark -
//-(NSString*)htmlModifiedForQQLoginWithOriginalHtml:(NSData*)aHtmlData
//{
//    NSString *theHtmlStr = [[NSString alloc] initWithBytes:aHtmlData.bytes length:aHtmlData.length encoding:NSUTF8StringEncoding];
//    
//    NSString* userName = self.userNameQQ;
//    
//    if (userName && theHtmlStr)
//    {
//        NSString* searchString = @"<input type=\"text\" class=\"inputstyle\" id=\"u\" name=\"u\" value=\"";
//        
//        NSString* replaceString = [NSString stringWithFormat:@"%@%@", searchString, userName];
//        // NSString* userNameKeyWordStr2 = @"<input type=\"text\" class=\"inputstyle\" id=\"u\" name=\"u\" value=\"101@qq.com";
//        
//        
//        //自定义一个编码方式 
//        //NSStringEncoding enc=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//        
//        //将字符串按上面的编码方式转换编码
//        
//        
//        NSMutableString* newHtmlStr = [NSMutableString stringWithString:theHtmlStr];
//        
//        [self replaceString:searchString withString:replaceString forString:newHtmlStr];
//        
//        return newHtmlStr;
//    }
//    
//    return theHtmlStr;
//}
//
//// called after html for login page has been retrieved, modify the html, change user name field
//-(NSString*)htmlModifiedForALiLoginWithOriginalHtml:(NSData*)aHtmlData
//{
//    return nil;
//}

@end
