//
//  DymAppDelegate.m
//  TestLibrary
//
//  Created by yiming dong on 12-6-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DymAppDelegate.h"

#import "DymViewController.h"
#import "ASIHTTPRequest.h"


#import "UIDevice+IdentifierAddition.h"
#import "NSObject+OTS.h"
#import "OTSServiceHelper.h"

#import "Page.h"
#import "CategoryVO.h"
#import "OTSUtility.h"

@implementation DymAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[[DymViewController alloc] initWithNibName:@"DymViewController_iPhone" bundle:nil] autorelease];
    } else {
        self.viewController = [[[DymViewController alloc] initWithNibName:@"DymViewController_iPad" bundle:nil] autorelease];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    // 服务器接口调用方法都是同步联网方法，所以必须放到子线程中执行，以免阻塞UI
    [self otsDetatchMemorySafeNewThreadSelector:@selector(testLibMethod) toTarget:self withObject:nil];
    
    m_CurrentCategoryId = [NSNumber numberWithInt:0]; //0级分类
    
    return YES;
}

//测试用户登录
-(void)testUserService
{
    NSLog(@"traderName: %@", [GlobalValue getGlobalValueInstance].traderName);
    NSString* loginResult = [[OTSServiceHelper sharedInstance] login:[GlobalValue getGlobalValueInstance].trader 
                                provinceId:[NSNumber numberWithInt:1] 
                                  username:@"101@qq.com" 
                                  password:@"111111"];
    
    NSLog(@"loginResult %@", loginResult);
    
    [GlobalValue getGlobalValueInstance].token=loginResult;
    
    int result = [[OTSServiceHelper sharedInstance] registerAct:[GlobalValue getGlobalValueInstance].trader  username:@"102@qq.com" password:@"111111" verifycode:@"tser" tempToken:nil];
    
    NSLog(@"register Result %d", result);
}

// 获取用户地址列表
-(void)testAddressService
{
    NSArray *userAddresses = [[OTSServiceHelper sharedInstance] getGoodReceiverListByToken:[GlobalValue getGlobalValueInstance].token];
    
    NSLog(@"userAddresses %@", userAddresses);

}

-(void)testPaymentMethodsForSessionOrder
{
    NSArray * arr = [[OTSServiceHelper sharedInstance] getPaymentMethodsForSessionOrder:[GlobalValue getGlobalValueInstance].token];
    
    NSLog(@"arr %@", arr);
}



-(void)testCategory
{
//    -(Page *)getCategoryByRootCategoryId:(Trader *)trader 
//mcsiteId:(NSNumber *)mcsiteId 
//rootCategoryId:(NSNumber *)rootCategoryId 
//currentPage:(NSNumber *)currentPage 
//pageSize:(NSNumber *)pageSize;
    
    Page* page = [[OTSServiceHelper sharedInstance] getCategoryByRootCategoryId:[GlobalValue getGlobalValueInstance].trader mcsiteId:[NSNumber numberWithInt:1] rootCategoryId:m_CurrentCategoryId currentPage:[NSNumber numberWithInt:1] pageSize:[NSNumber numberWithInt:50]];
    
    for (CategoryVO* cate in page.objList)
    {
        NSLog(@"cate id:%@", cate.nid);
    }
    
    m_CurrentCategoryId = ((CategoryVO*)([page.objList objectAtIndex:0])).nid;
    
    page = [[OTSServiceHelper sharedInstance] getCategoryByRootCategoryId:[GlobalValue getGlobalValueInstance].trader mcsiteId:[NSNumber numberWithInt:1] rootCategoryId:m_CurrentCategoryId currentPage:[NSNumber numberWithInt:1] pageSize:[NSNumber numberWithInt:50]];
    
    for (CategoryVO* cate in page.objList)
    {
        NSLog(@"cate id:%@", cate.nid);
    }
}

//测试ASIHttp
-(void)testASI
{
    ASIHTTPRequest* req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com.hk/"]];
    [req startSynchronous];
    
    DebugLog(@"%@", [req responseString]);
}

-(void)testLibMethod
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    //[self testASI];
    [self testUserService];
    
    [self testCategory];
    
    [self testPaymentMethodsForSessionOrder];
    
    [OTSUtility testiPadInterface];
    
    // 延时执行，验证token有效性
    [self performSelector:@selector(testAddressService) withObject:nil
               afterDelay:3];
    
    [[NSRunLoop currentRunLoop] run];
    
    [self performSelectorOnMainThread:@selector(handleTestFinished) withObject:nil waitUntilDone:YES];
    
    
    [pool drain];
}


-(void)handleTestFinished
{
    NSLog(@"test finished!");
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}




@end
