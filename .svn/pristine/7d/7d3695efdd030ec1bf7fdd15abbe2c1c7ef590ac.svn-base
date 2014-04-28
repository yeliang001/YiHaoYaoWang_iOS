//
//  UserManager.m
//  TheStoreApp
//
//  Created by towne on 12-6-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserManageTool.h"

@implementation UserManageTool
static UserManageTool *shareInstance = nil;
@synthesize m_dicUserManager;

- (id)init
{
    self = [super init];
    if (self) 
    {
        
        NSArray * UserManagerPlistPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * docDirectory = [UserManagerPlistPath objectAtIndex:0];
        m_UserManagerPlistPath= [[NSString alloc]initWithString:[docDirectory stringByAppendingPathComponent:PLIST_USERMANAGER]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:m_UserManagerPlistPath]) 
        {
            m_dicUserManager = [[NSMutableDictionary alloc ] initWithContentsOfURL:[NSURL fileURLWithPath:m_UserManagerPlistPath]];
            m_bFileExist = YES;
        }
        else
        {
            m_dicUserManager  = [[NSMutableDictionary alloc] init];

            NSMutableDictionary*tempdic  = [NSMutableDictionary dictionary];
            [tempdic setObject:@"" forKey:KEY_USER_NAME];
            [tempdic setObject:@"" forKey:KEY_THEONESTOREACCOUNT];
            [tempdic setObject:@"" forKey:KEY_USER_PASS];
            [tempdic setObject:[NSNumber numberWithInt:1] forKey:KEY_REMEMBER];
            [tempdic setObject:@""    forKey:KEY_COCODE];
            [tempdic setObject:@""      forKey:KEY_UNIONLOGIN];
            [tempdic setObject:@""      forKey:KEY_NICKNAME];
            [tempdic setObject:@""      forKey:KEY_USERIMG];
            [tempdic setObject:@"1" forKey:KEY_AUTOLOGSTATUS];
            [m_dicUserManager setObject:tempdic forKey:KEY];
            m_bFileExist = NO;
        }
        
    }
    return self;
}

- (void)AddOrUpdate:(NSString *)uuid 
           withName:(NSString *)username
withTheOneStoreAccount:(NSString *)account
           withPass:(NSString *)userpass
     withRememberme:(NSNumber *)rememberme
         withCocode:(NSString *)cocode
     withUnionlogin:(NSString *)unionlogin
       withNickname:(NSString *)nickname
        withUserimg:(NSString *)userimg
        withAutoLoginStatus:(NSString *)autologinstatus
     withNeedToSave:(BOOL) bNeedSave
{
    NSMutableDictionary * UserNode = [[[NSMutableDictionary alloc] init] autorelease];
    [UserNode setObject:username forKey:KEY_USER_NAME];
    [UserNode setObject:account forKey:KEY_THEONESTOREACCOUNT];
    [UserNode setObject:userpass forKey:KEY_USER_PASS];
    [UserNode setObject:rememberme forKey:KEY_REMEMBER];
    [UserNode setObject:cocode    forKey:KEY_COCODE];
    [UserNode setObject:unionlogin      forKey:KEY_UNIONLOGIN];
    [UserNode setObject:nickname      forKey:KEY_NICKNAME];
    
    if (userimg)
    {
        [UserNode setObject:userimg      forKey:KEY_USERIMG];
    }
    
    [UserNode setObject:autologinstatus forKey:KEY_AUTOLOGSTATUS];
    [m_dicUserManager setObject:UserNode forKey:uuid];
    if ((0 < [m_dicUserManager count]) && bNeedSave) 
    {
        DebugLog(@"path: %@", m_UserManagerPlistPath);
        m_bFileExist = [m_dicUserManager writeToFile:m_UserManagerPlistPath atomically:YES];
    }
    
}

- (void)Del:(NSString *)uuid withNeedToSave:(BOOL) bNeedSave
{
    
    NSMutableDictionary *UserNode = [m_dicUserManager objectForKey:uuid];
    
    if (nil != UserNode) 
    {   
        [m_dicUserManager removeObjectForKey:uuid];
        
        if (bNeedSave) 
        {
            m_bFileExist = [m_dicUserManager writeToFile:m_UserManagerPlistPath atomically:YES];
        }
    }
}

- (void)UpdateFiled : (NSString *)uuid withFiledKey:(NSString *)key withValue:(NSObject *)val withNeedToSave:(BOOL) bNeedSave{
    NSMutableDictionary *node = [m_dicUserManager objectForKey:uuid];
    if (nil != node) 
    {
        [node setObject:val forKey:key];
    }
    if (bNeedSave) 
    {
        m_bFileExist = [m_dicUserManager writeToFile:m_UserManagerPlistPath atomically:YES];
    }
}

- (NSDictionary *)GetUser
{
    return [m_dicUserManager objectForKey:KEY];
}

- (NSString *)GetUserName
{
    return [[m_dicUserManager objectForKey:KEY] objectForKey:KEY_USER_NAME];
}

- (NSString *)GetTheOneStoreAccount
{
    return [[m_dicUserManager objectForKey:KEY] objectForKey:KEY_THEONESTOREACCOUNT];
}

- (NSString *)GetUserPass
{
    return [[m_dicUserManager objectForKey:KEY] objectForKey:KEY_USER_PASS];
}

- (NSNumber *)GetRemberStatus
{
    return  [[m_dicUserManager objectForKey:KEY] objectForKey:KEY_REMEMBER];
}

- (NSString *)GetCocode
{
    return [[m_dicUserManager objectForKey:KEY] objectForKey:KEY_COCODE];
}

- (void)SetUnionLogin:(NSString*)aUnionLoginStr
{
    [[m_dicUserManager objectForKey:KEY] setObject:aUnionLoginStr forKey:KEY_UNIONLOGIN];
}

- (NSString *)GetUnionLogin
{
    return [[m_dicUserManager objectForKey:KEY] objectForKey:KEY_UNIONLOGIN];
}

- (NSString *)GetNickName
{
    return [[m_dicUserManager objectForKey:KEY] objectForKey:KEY_NICKNAME];
}

- (NSString *)GetUserImg
{
    return [[m_dicUserManager objectForKey:KEY] objectForKey:KEY_USERIMG];
}

- (NSString *)GetAutoLoginStatus
{
    return [[m_dicUserManager objectForKey:KEY] objectForKey:KEY_AUTOLOGSTATUS];
}
- (void)setAutoLoginStatus:(NSString*)status{
    [[m_dicUserManager objectForKey:KEY] setObject:status forKey:KEY_AUTOLOGSTATUS];
}

- (void)setRemenberStatus:(NSNumber*)status{
    [[m_dicUserManager objectForKey:KEY] setObject:status forKey:KEY_REMEMBER];
}

+ (UserManageTool *) sharedInstance{
    @synchronized(self){
        if (shareInstance == nil) {
            shareInstance = [[self alloc] init];
        }
        return (shareInstance);
    }
}

-(oneway void) release {
    
}

-(id)autorelease
{
    return self;
}

-(id)retain
{
    return  self;
}

- (void)dealloc
{
    if (nil != m_dicUserManager) 
    {
        [m_dicUserManager writeToFile:m_UserManagerPlistPath atomically:YES];
        [m_dicUserManager removeAllObjects];
    }
    [super dealloc];
}
@end
