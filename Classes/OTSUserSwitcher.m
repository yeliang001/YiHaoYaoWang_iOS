//
//  OTSUserSwitcher.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-9-20.
//
//

#import "OTSUserSwitcher.h"
#import "GlobalValue.h"
#import "OTSServiceHelper.h"
#import "UserVO.h"
#import "GTMBase64.h"
#import "TheStoreAppAppDelegate.h"
#import "NSObject+OTS.h"
#import "DataHandler.h"

@interface OTSUserSwitcher ()
@property EOTSUserType  currentUserType;

-(void)requestSessionUser;  // 请求当前用户信息
-(void)switchUserWithType:(EOTSUserType)aUserType token:(NSString*)aToken;      // 切换当前用户类型
@end


@implementation OTSUserSwitcher
@synthesize mallToken = _mallToken;
@synthesize currentUser = _currentUser;
@synthesize currentUserType = _userType;
@dynamic storeToken;
@dynamic currentToken;

#pragma mark -
-(NSString*)storeToken
{
    return [GlobalValue getGlobalValueInstance].storeToken;
}

-(void)setStoreToken:(NSString *)storeToken
{
    [GlobalValue getGlobalValueInstance].storeToken = storeToken;
}

#pragma mark -
- (void)switchToMoreUser
{
    [self switchToMoreUserWithToken:self.mallToken];
}

- (void)switchToStoreUser
{
    [self switchToStoreUserWithToken:self.storeToken];
}

- (void)switchToMoreUserWithToken:(NSString*)aToken
{
    [self switchUserWithType:kUserOfMore token:aToken];
}

- (void)switchToStoreUserWithToken:(NSString*)aToken
{
    [self switchUserWithType:kUserOfStore token:aToken];
}

- (void)justSwitchToStoreUserWithToken:(NSString*)aToken
{
    if (aToken)
    {
        self.currentUserType = kUserOfStore;
        self.storeToken = aToken;
        
        [GlobalValue getGlobalValueInstance].nickName = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyStoreChanged" object:nil];
    }
}

-(void)switchUserWithType:(EOTSUserType)aUserType token:(NSString*)aToken
{
    if (aToken)
    {
        self.currentUserType = aUserType;
        aUserType == kUserOfStore ? (self.storeToken = aToken) : (self.mallToken = aToken);
        
        [self requestSessionUser];
        
        [GlobalValue getGlobalValueInstance].nickName = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_NAME_USER_TYPE_SWITCHED object:self.currentUser];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyStoreChanged" object:nil];
    }
}

- (NSString*)currentToken
{
    switch (self.currentUserType)
    {
        case kUserOfStore:
            return self.storeToken;
            break;
            
        case kUserOfMore:
            return self.mallToken;
            break;
            
        default:
            break;
    }
    
    return nil;
}

- (void)setCurrentToken:(NSString*)aNewToken
{
    switch (self.currentUserType)
    {
        case kUserOfStore:
            self.storeToken = aNewToken;
            break;
            
        case kUserOfMore:
            self.mallToken = aNewToken;
            break;
            
        default:
            break;
    }
}

-(void)requestSessionUser
{
    @synchronized([self class])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            self.currentUser = [[OTSServiceHelper sharedInstance] getMyYihaodianSessionUser:self.currentToken];
            
            if (self.currentUser != nil) {
                [[GlobalValue getGlobalValueInstance]setCurrentUser:self.currentUser];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //商城登录不在切换省份哦

//                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_NAME_USER_VO_UPDATED object:self.currentUser];
            });
        });
    }
}

-(NSString*)tokenFromCryptString:(NSString*)aCryptString
{
    NSData* tokenData = [GTMBase64 decodeString:aCryptString];
    return [[[NSString alloc] initWithData:tokenData encoding:NSUTF8StringEncoding] autorelease];
}

-(void)handleWapReuestString:(NSString*)aRequestString
{
    // SAMPLE: token=Y2I4YWU3NjgtNjRhOC00MDU4LTkzOTUtOWQyYzFhZDBjMjI3&yihaomallloginforclint=true
    
    if (aRequestString && aRequestString.length > 0)
    {
        DebugLog(@"requestString:%@", aRequestString);
        NSRange tokenParamRange = [aRequestString rangeOfString:@"token="];
        NSRange clientTypeParamRange = [aRequestString rangeOfString:@"&yihaomallloginforclint="];
        
        if (clientTypeParamRange.location != NSNotFound
            && tokenParamRange.location != NSNotFound
            && clientTypeParamRange.location > tokenParamRange.location)
        {
            int tokenValueLocation = tokenParamRange.location + tokenParamRange.length;
            NSRange tokenValueRange = NSMakeRange(tokenValueLocation, clientTypeParamRange.location - tokenValueLocation);
            NSString* tokenValueStr = [aRequestString substringWithRange:tokenValueRange];
            NSString* token = [self tokenFromCryptString:tokenValueStr];
            if (token == nil)
            {
                return; //token为nil，视为错误，返回
            }
            
            DebugLog(@"tokenValue:%@\ntoken:%@", tokenValueStr, token);
            
            NSString *restOfString = [aRequestString substringFromIndex:clientTypeParamRange.location + clientTypeParamRange.length];
            DebugLog(@"rest of string:%@", restOfString);
            
            //token为新的token
            if (token!=nil && ![token isEqualToString:@""] && ![token isEqualToString:[GlobalValue getGlobalValueInstance].token]) {
                //判断token类型
                [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadGetIfTokenIsAuthorized:) toTarget:self withObject:token];
            }
        }
    }
}

-(void)newThreadGetIfTokenIsAuthorized:(NSString *)token
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    NSString *theToken=[[[NSString alloc] initWithString:token] autorelease];
    NSNumber *result=[[OTSServiceHelper sharedInstance] getUserSitetypeAndAuth:theToken];
    if (result!=nil && ![result isKindOfClass:[NSNull class]]) {
        if ([result intValue]==1 || [result intValue]==2) {//1号店
            [self performSelectorOnMainThread:@selector(switchToStoreUserWithToken:) withObject:token waitUntilDone:NO];
//            [self changeProvinceForToken:token];//将token切换到当前省份
        } else if ([result intValue]==3) {//1号商城已授权
            [self performSelectorOnMainThread:@selector(switchToMoreUserWithToken:) withObject:token waitUntilDone:NO];
            [self changeProvinceForToken:token];//将token切换到当前省份
        } else {//1号商城未授权
            [self performSelectorOnMainThread:@selector(logout) withObject:nil waitUntilDone:NO];
        }
    } else {
        [self performSelectorOnMainThread:@selector(logout) withObject:nil waitUntilDone:NO];
    }
    [pool drain];
}

//将token切换到当前省份
-(void)changeProvinceForToken:(NSString *)token
{
    if ([[GlobalValue getGlobalValueInstance].provinceId intValue]!=1) {//当前省份为非上海
        [self performInThreadBlock:^{
            NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
            UserService *service=[[[UserService alloc] init] autorelease];
            int result=[service changeProvince:token provinceId:[GlobalValue getGlobalValueInstance].provinceId];
            DebugLog(@"%d",result);
            [pool drain];
        }];
    }
}

-(void)logout
{
    if ([GlobalValue getGlobalValueInstance].token!=nil) {
        if ([SharedDelegate respondsToSelector:@selector(logout)]) {
            [SharedDelegate performSelector:@selector(logout) withObject:nil];
        }
    }
}

#pragma mark - singleton methods
static OTSUserSwitcher *sharedInstance = nil;

+ (OTSUserSwitcher *)sharedInstance
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
@end
