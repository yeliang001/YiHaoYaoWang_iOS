//
//  TheStoreAppAppDelegate.m
//  TheStoreApp
//
//  Created by tianjsh on 11-2-15.
//  Updated by yangxd  on 11-06-27  添加返回首页时去除周年活动界面
//  Copyright 2011 vsc. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
//#import <Crashlytics/Crashlytics.h>
#import "Reachability.h"
#import "TheStoreAppAppDelegate.h"
#import "GlobalValue.h"
#import "PhoneCartViewController.h"
#import "More.h"
#import "MyBrowse.h"
#import "Homepage.h"
#import "Search.h"
#import "UserManage.h"
#import "Trader.h"
#import "ConnectAction.h"
#import "ShareToMicroBlog.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import "Scan.h"
#import "UIDevice+IdentifierAddition.h"
#import "OTSNaviAnimation.h"
#import "OTSLoadingView.h"
#import "MyStoreViewController.h"
#import "DoTracking.h"
//#import  <NdChannelLib/NdChannelLib.h>
//#import <Log/NDLogger.h>
#import "OTSNavigationController.h"
#import "UIView+VCManage.h"
#import "OTSViewControllerManager.h"
#import "OTSAlertView.h"
#import "OTSNaviAnimation.h"
#import "OTSContainerViewController.h"
#import "OTSMaterialFLowVC.h"
#import "OTSNNPiecesVC.h"
#import "OTSOnlinePayNotifier.h"
#import "OTSOnlinePayNotifyCanceller.h"
#import "LocalCartItemVO.h"
#import "CartService.h"
#import "CategoryViewController.h"
#import "WapViewController.h"
#import "OTSEverybodyWantsMe.h"
#import "SystemService.h"
#import "InterfaceLog.h"
#import "GPSUtil.h"
#import "ProvinceVO.h"
#import "OTSPhoneWeRockMainVC.h"
#import "OTSViewControllerManager.h"
#import "IconDownloadSetting.h"
#import "IconCacheViewController.h"
#import "RemoteNotify.h"
#import "URLScheme.h"
#import <commoncrypto/CommonDigest.h>
#import "PhoneSplash.h"
#import "GlobalValue.h"
#import "WeiboSDK.h"
#import "MobClick.h"
#import "YWLocalCatService.h"
#import "UserInfo.h"
#import "JSON.h"
#import "ResultInfo.h"
#import "YWLocalCatService.h"
#import "mobidea4ec.h"





//因为百分点sdk中加入了Reachability文件，所以把项目中的Reachability.m删除了，然后增加这个常量
//NSString *const kReachabilityChangedNotification = @"NetworkReachabilityChangedNotification";

#define LOCALCART_FILENAME @"localcart_data.dat"
#define ERROR_CONNECTION_FAILURE 3
#define WEB_ERROR_TAG 79
#define WEB_OTHER_ERROR_TAG 89
#define ICON_SHOW_TAG 99

#define TRACK_TYPE 0

#if (TRACK_TYPE == 0)
#define kTrackid @"8366231"
#define kTrackName @"appstore_iphone"

#elif (TRACK_TYPE == 1)
#define kTrackid @"9495060"
#define kTrackName @"同步助手_iphone"

#elif (TRACK_TYPE == 2)
#define kTrackid @"10107021978"
#define kTrackName @"91助手_iphone"

#elif (TRACK_TYPE == 3)
#define kTrackid @"10875922787"
#define kTrackName @"PP助手_iphone"

#elif (TRACK_TYPE == 4)
#define kTrackid @"10811229068"
#define kTrackName @"艾德思奇_iphone"

#elif (TRACK_TYPE==5)
#define kTrackid @"10958540151"
#define kTrackName @"快用_iphone"

#endif
@interface TheStoreAppAppDelegate ()
@property (retain) OTSPhoneWeRockMainVC     *rockVC;

//GPS
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKReverseGeocoder *mkreverseGeocoder;
@property (retain) NSTimer                      *heartBeatTimer;

-(void)initApplication;//初始化app
-(void)toTabPageIndex:(int)aIndex;
-(void)toTabPageIndex:(int)aIndex popToRoot:(BOOL)aIsPopToRoot;

@end
//

@implementation TheStoreAppAppDelegate
@synthesize m_UpdateCategory,m_UpdateCart;
@synthesize isVersionUpdate;
@synthesize m_GpsAlertDisAble;
@synthesize m_isAlertViewShowing;
@synthesize m_IsFirstLaunch;
@synthesize tabBarController, window, tabbarMaskVC, wapViewVC;
@synthesize rockVC = _rockVC;
@synthesize locationManager,mkreverseGeocoder;
@synthesize heartBeatTimer = _heartBeatTimer;
@synthesize needCachedPromotion;
int static cart_count = 0;//购物车起始总量



-(void)showInMask:(OTSBaseViewController*)aVC
{
    if (aVC)
    {
        [self.tabbarMaskVC removeSelf];
        self.tabbarMaskVC = [[[OTSContainerViewController alloc] init] autorelease];
        [window addSubview:self.tabbarMaskVC.view];
        
        [self.tabbarMaskVC pushVC:aVC animated:YES];
    }
    
}
-(void)popMask
{
    [self.tabbarMaskVC removeSelf];
}


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [ WeiboSDK registerApp:@"3598356152" ];
    [ WeiboSDK enableDebugMode:NO ];
    //Umeng
    //AppStore
//    [MobClick startWithAppkey:@"520b4ffe56240bdaa9092f00"];
    //91
//    [MobClick startWithAppkey:@"520b4ffe56240bdaa9092f00" reportPolicy:SEND_INTERVAL channelId:@"91"];
    //药店
    [MobClick startWithAppkey:@"520b4ffe56240bdaa9092f00" reportPolicy:SEND_INTERVAL   channelId:kYWChannel];

    
    //注册通知
    [self registerForRemoteNotification];
    
    [self initReachAbility];
    [[UIApplication sharedApplication] addObserver:self forKeyPath:@"applicationIconBadgeNumber" options:0 context:NULL];
    // Add the tab bar controller's view to the window and display.
	[UIWindow setAnimationsEnabled:NO];
	
	[self initApplication];
//    [window addSubview:tabBarController.view];
    window.rootViewController = tabBarController;
    [window makeKeyAndVisible];
    
    // start heart beat
    self.heartBeatTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateExpireTime) userInfo:nil repeats:YES];
    
    
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    // online pay notifier retrieve orders
    [OTSOnlinePayNotifier sharedInstance].appBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
    //DebugLog(@"app badge number:%d", [UIApplication sharedApplication].applicationIconBadgeNumber);
    
    [[OTSOnlinePayNotifier sharedInstance] retrieveOrders];
    NSDictionary*remoteNotification=[launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        RemoteNotify*remote=[RemoteNotify sharedRemoteNotify];
        remote.notifyDic=remoteNotification;
        if ([[remoteNotification valueForKey:@"pageid"] isEqualToString:@"topromotion"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"remoteRecived" object:self];
        }
    }
    [[PhoneSplash sharedInstance] showSplash];
    return YES;
}

-(void)updateExpireTime
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyWRInventoryCellUpdateTime object:nil];
}

// did receive local notification
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    DebugLog(@"== app did Receive Local Notification ==");
    
    //[[OTSOnlinePayNotifier sharedInstance] handleRecievedNotification:notification];
}


#pragma mark - kvo
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    if (object == [UIApplication sharedApplication]
        && [keyPath isEqualToString:@"applicationIconBadgeNumber"])
    {
        DebugLog(@"KVC-applicationIconBadgeNumber:%d", [UIApplication sharedApplication].applicationIconBadgeNumber);
    }
    //类似问题 crash #1414
    /*
     else
     {
     [super observeValueForKeyPath:keyPath ofObject:object
     change:change context:context];
     }*/
}

-(MyStoreViewController*)myStoreVC
{
    static MyStoreViewController* myStoreVC = nil;
    if (myStoreVC == nil)
    {
        myStoreVC = (MyStoreViewController*)[tabBarController.viewControllers objectAtIndex:3];
    }
    
    return myStoreVC;
}

-(void)syncMyStoreBadge
{
    [self performSelectorOnMainThread:@selector(doSyncMyStoreBadge) withObject:nil waitUntilDone:YES];
}

-(void)doSyncMyStoreBadge
{
    int notifyOrderCount = [OTSOnlinePayNotifier sharedInstance].notifyOrdersCount;
    NSString* badgeStr = nil;
    
    if (notifyOrderCount > 0)
    {
        badgeStr = [NSString stringWithFormat:@"%d" , notifyOrderCount];
    }
    
    [self myStoreVC].tabBarItem.badgeValue = badgeStr;
}

#pragma mark - 91 sdk delegate
- (void)NdUploadChannelIdDidFinished:(int)resultCode  sessionId:(NSString*)session errorDescription:(NSString*)description
{
    DebugLog(@"NdUploadChannelIdDidFinished -- resultCode:%d, sessionId:%@, errorDescription:%@", resultCode, session, description);
}

#pragma mark 初始化application
-(void)initApplication{
    // 获取sessionID
    NSDate* currentDate = [NSDate date];
    NSDate* formerDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"session_timeInterval"];
    NSTimeInterval time=[currentDate timeIntervalSinceDate:formerDate];
    if ((int)time/3600 >= 24 || formerDate == nil || (int)time == 0) {
        // 生成随机的session_id
//        NSString* orginStr = [NSString string];
//        for (int i = 0; i < 32; i++) {
//            int index = arc4random() % 10;
//            orginStr = [orginStr stringByAppendingFormat:@"%d",index];
//        }
//        const char *cStr = [orginStr UTF8String];
//        unsigned char result[CC_MD5_DIGEST_LENGTH];
//        CC_MD5( cStr, strlen(cStr), result );
//        NSString* str = [NSString stringWithFormat:
//                         @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
//                         result[0], result[1], result[2], result[3],
//                         result[4], result[5], result[6], result[7],
//                         result[8], result[9], result[10], result[11],
//                         result[12], result[13], result[14], result[15]
//                         ];
        
        // 生成随机的session_id,新方法，效率maybe会高些
        int NUMBER_OF_CHARS = 32;
        char data[NUMBER_OF_CHARS];
        for (int x=0;x<NUMBER_OF_CHARS;x++) {
            if(arc4random()%2){
                data[x] = (char)('A' + (arc4random_uniform(26)));
            }else{
                data[x] = (char)((arc4random() % 10) + '0');
            }
        }
        NSString* str = [[NSString alloc] initWithBytes:data length:NUMBER_OF_CHARS encoding:NSUTF8StringEncoding];
        DebugLog(@"%@,length:%d",str, str.length);
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"sessionID"];
        [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:@"session_timeInterval"];
        [[GlobalValue getGlobalValueInstance] setSessionID:str];
    }else{
        NSString* sessionIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
        [[GlobalValue getGlobalValueInstance] setSessionID:sessionIdStr];
    }
    DebugLog(@"the time is:%d\n sessionid is:%@",(int)time,[GlobalValue getGlobalValueInstance].sessionID);
    
	[[GlobalValue getGlobalValueInstance] setIsFirstLoad:YES];
    ShareToMicroBlog * share=[[ShareToMicroBlog alloc] init];//tjs
    [[GlobalValue getGlobalValueInstance] setMbService:share];//tjs
    [share release];
    
    [[GlobalValue getGlobalValueInstance] setLastRefreshTime:[NSDate date]];
    [[GlobalValue getGlobalValueInstance] setCateLeveltrackArray:[NSMutableArray array]];
    
	NSString * systemVersion = [[UIDevice currentDevice] systemVersion];
    NSBundle *bundle=[NSBundle mainBundle];
	NSString * appVersion = [NSString stringWithFormat:@"%@",[bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
	
    
	trader = [[Trader alloc] init];
	trader.clientAppVersion=[NSString stringWithString:appVersion];
    trader.clientSystem=@"iPhone";
    trader.clientVersion=[NSString stringWithString:systemVersion];
    
    trader.interfaceVersion=@"1.2.5";
    trader.protocolStr=@"HTTPXML";
    trader.traderName=@"iosSystem";
    trader.traderPassword=@"4JanEnE@";
    
    trader.unionKey = kTrackid;		// appstore
	trader.deviceCode=[NSString stringWithString:[[UIDevice currentDevice] uniqueDeviceIdentifier]];
    [[GlobalValue getGlobalValueInstance] setTrader:trader];
    [[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:NO];
    
    
    
    //获取省份位置
    NSDictionary* provinceDic = [[GPSUtil sharedInstance] getProvinceDic];
    NSString * plistProvince = [[GPSUtil sharedInstance] getProvinceFromPlist];
    if (plistProvince==nil)
    {
        m_IsFirstLaunch=YES;
        plistProvince = @"上海";
        NSMutableArray *array=[[NSMutableArray alloc]init];
        [array addObject:plistProvince];
        [[GPSUtil sharedInstance] saveProvinceToPlist:array];
        [array release];
    }
    else
    {
        m_IsFirstLaunch=NO;
    }
	NSNumber *proviceId = [[NSNumber alloc]initWithInt:[[provinceDic objectForKey:plistProvince] intValue]];
    
    
	if ([proviceId intValue]==0)
    {
        NSNumber *number=[[NSNumber alloc]initWithInt:1];
		[[GlobalValue getGlobalValueInstance]setProvinceId:number];
        [number release];
	}
    else
    {
        NSNumber *number=[[NSNumber alloc]initWithInt:[proviceId intValue]];
		[[GlobalValue getGlobalValueInstance]setProvinceId:number];
        [number release];
	}
    
    [proviceId release];
	cart_count=0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recevieopenBrowse) name:@"openBrowse" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterCartRoot) name:@"enterCart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWebErrorAlertView) name:@"showWebErrorAlertView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toCelebrateViewNotification:) name:@"ToCelebrateViewNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(provinceChanged:) name:@"ProvinceChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartChanged:) name:@"CartChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myStoreChanged:) name:@"MyStoreChanged" object:nil];
    //groupon jiepang
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddSubViewForGroupBuyMask:) name:@"AddSubViewForGroupBuyMask" object:nil];
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString * documentsDirectory = [paths objectAtIndex:0];
	NSString * appFile = [documentsDirectory stringByAppendingPathComponent:LOCALCART_FILENAME];
	[[GlobalValue getGlobalValueInstance] setLocalCartFileName:appFile];
    
    //[self performSelectorInBackground:@selector(reportAppOpenToAdMob) withObject:nil];
}


#pragma mark    admob
-(void)applicationDidFinishLaunching:(UIApplication *)application {
	//[self performSelectorInBackground:@selector(reportAppOpenToAdMob) withObject:nil];
}

- (NSString *)hashedISU {
	NSString *result = nil;
	NSString *isu = [[UIDevice currentDevice] uniqueDeviceIdentifier];
	if(isu) {
		unsigned char digest[16];
		NSData *data = [isu dataUsingEncoding:NSASCIIStringEncoding];
		CC_MD5([data bytes], [data length], digest);
		result = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
				  digest[0], digest[1],
				  digest[2], digest[3],
				  digest[4], digest[5],
				  digest[6], digest[7],
				  digest[8], digest[9],
				  digest[10], digest[11],
				  digest[12], digest[13],
				  digest[14], digest[15]];
		result = [result uppercaseString];
	}
	return result;
}

- (void)reportAppOpenToAdMob {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
																		NSUserDomainMask, YES) objectAtIndex:0];
	NSString *appOpenPath = [documentsDirectory stringByAppendingPathComponent:@"admob_app_open"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if(![fileManager fileExistsAtPath:appOpenPath]) {
		NSString *appOpenEndpoint = [NSString stringWithFormat:@"http://a.admob.com/f0?isu=%@&md5=1&app_id=%@", [self hashedISU], @"427457043"];
        
        DebugLog(@"====%@",appOpenEndpoint);
        
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:appOpenEndpoint]];
		NSURLResponse *response;
		NSError *error = nil;
		NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		if((!error) && ([(NSHTTPURLResponse *)response statusCode] == 200) && ([responseData length] > 0)) {
            
			[fileManager createFileAtPath:appOpenPath contents:nil attributes:nil]; // successful report, mark it as such
		}
    }
	
	[pool drain];
}


#pragma mark 设置数量
-(void)setCartNum:(int)cartNumber {
	[UIView setAnimationsEnabled:NO];
	CartNum *cartNum=[[CartNum alloc] init];
	UIViewController *view=[tabBarController.viewControllers objectAtIndex:2];//获得购物车
	[cartNum init:view];
    int curCount=cart_count+cartNumber;
    if (curCount>0 && curCount<10) {
        if (cart_count==0 || cart_count>=100) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CarNumNotNullNotification" object:nil];
        }
    } else if (curCount>=10 && curCount<100) {
        if (cart_count==0 || (cart_count>0&&cart_count<10)) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CarNumNotNullLongNotification" object:nil];
        }
    } else if (curCount>=100) {
        if (cart_count==0 || (cart_count>=10&&cart_count<100)) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CarNumNotNullNotification" object:nil];
        }
    }
    
	cart_count=curCount;
    
    [cartNum setCartNum:[NSString stringWithFormat:@"%d",cart_count]];
    
	[cartNum release];
	[UIView setAnimationsEnabled:YES];
}

#pragma mark 清空购物车显示数量
-(void)clearCartNum{
	CartNum *cartNum=[[CartNum alloc] init];
	UIViewController *view=[tabBarController.viewControllers objectAtIndex:2];//获得购物车
	[cartNum init:view];
	cart_count=0;
    [cartNum setCartNum:nil];
	[cartNum release];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"CarNumNullNotification" object:nil];
    

}

-(void)toCelebrateViewNotification:(NSNotification *)notification
{
    NSString *url=[notification object];
    //进入主页
    [self toTabPageIndex:0];
    
    [(HomePage *)[tabBarController.viewControllers objectAtIndex:0] returntoHomePage];
    [(HomePage *)[tabBarController.viewControllers objectAtIndex:0] enterCelebrateView:url];
}


#pragma mark - 标准导航
#if defined (STANDARD_NAVIGATION_ENABLED)
-(void)standardNaviPushFromVC:(UIViewController*)aFromVC toVC:(UIViewController*)aToVC
{
    UINavigationController* nv = aFromVC.navigationController;
    if (nv == nil)
    {
        nv = [[[UINavigationController alloc] initWithRootViewController:aFromVC] autorelease];
    }
    
    [nv pushViewController:aToVC animated:YES];
}

-(void)standardNaviPopVC:(UIViewController*)aViewController
{
    [aViewController.navigationController popViewControllerAnimated:YES];
}

-(void)standardNaviPopToRootVC:(UIViewController *)aViewController
{
    [aViewController.navigationController popToRootViewControllerAnimated:YES];
}

-(UIViewController*)currentTabSelectedVC
{
    return [((OTSNavigationController*)tabBarController.selectedViewController) getRootVC];;
}

-(id)instanceWithNibByClassName:(NSString*)aClassName
{
    if (aClassName == nil || [aClassName length] <= 0)
    {
        return nil;
    }
    
    Class theClass = NSClassFromString(aClassName);
    if (theClass == nil)
    {
        return nil;
    }
    
    return [[[theClass alloc] initWithNibName:aClassName bundle:nil] autorelease];;
}

-(void)standardVC:(UIViewController*)aFromVC presentModalVC:(UIViewController*)aToVC
{
    [aFromVC presentModalViewController:aToVC animated:YES];
}

-(void)standardDismissModalVC:(UIViewController*)aVC
{
    [aVC dismissModalViewControllerAnimated:YES];
}

#endif

-(void)provinceChanged:(NSNotification *)notification
{
    NSString *provinceName=[notification object];
    m_UpdateHomePage=YES;
    m_UpdateCategory=YES;
    m_UpdateCart=YES;
    [(HomePage*)[tabBarController.viewControllers objectAtIndex:0] provinceChanged:provinceName];
}

-(void)cartChanged:(NSNotification *)notification
{
    m_UpdateCart=YES;
}

-(void)myStoreChanged:(NSNotification *)notification
{
    m_UpdateMyStore=YES;
}

-(void)AddSubViewForGroupBuyMask:(NSNotification *)notification
{
    UIView *view=[notification object];
    CGRect rect=[view frame];
    rect.size.height=480.0;
    [view setFrame:rect];
    
    CATransition *animation=[CATransition animation];
	[animation setDuration:0.3f];
	[animation setTimingFunction:UIViewAnimationCurveEaseInOut];
	[animation setType:kCATransitionMoveIn];
	[animation setSubtype: kCATransitionFromTop];
	[self.tabbarMaskVC.view.layer addAnimation:animation forKey:@"Reveal"];
    [self.tabbarMaskVC.view addSubview:view];
}

-(void)guidePageClicked:(id)sender
{
    UIButton *button=sender;
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    [animation setType:kCATransitionPush];
    [animation setSubtype: kCATransitionFromRight];
    [button.layer addAnimation:animation forKey:@"Reveal"];
    
    if ([button tag]==0) {
        [button setTag:1];
        [button setBackgroundImage:[UIImage imageNamed:@"shopList_guide_two.png"] forState:UIControlStateNormal];
    } else {
        [button removeFromSuperview];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
    //百分点
   
    [BfdAgent appWillResignActive];
    
    
    DebugLog(@"applicationWillResignActive");
    //打开支付宝app home 时候再调用 1号店app 会异常
    NSString * onlineAlixPayOrderId = [GlobalValue getGlobalValueInstance].alixpayOrderId;
    if (onlineAlixPayOrderId) {
        BOOL isFromOrderDetail  = [GlobalValue getGlobalValueInstance].isFromOrderDetailForAlix;
        BOOL isFromOrderSuccess = [GlobalValue getGlobalValueInstance].isFromOrderSuccessForAlix;
        BOOL isFromOrderGROUPDetail = [GlobalValue getGlobalValueInstance].isFromOrderGROUPDetailForAlix;
        BOOL isFromMyOrder = [GlobalValue getGlobalValueInstance].isFromMyOrder;
        DebugLog(@"onlineAlixPayOrderId >>>>> %qi",[onlineAlixPayOrderId longLongValue]);
        [self performBlock:^(){
            MyStoreViewController * controller =  (MyStoreViewController *)[SharedDelegate.tabBarController.viewControllers objectAtIndex:3];
            [SharedDelegate enterMyStoreWithUpdate:NO];
            [controller removeAllMyVC];
            if (isFromOrderDetail) {
                [controller enterOrderDetail:onlineAlixPayOrderId];
                [[GlobalValue getGlobalValueInstance] setIsFromOrderDetailForAlix:NO];
            }
            else if (isFromOrderGROUPDetail && !isFromMyOrder && !isFromOrderSuccess)
            {
//                [controller unionPaytoGroupBuyOrderDetail:onlineAlixPayOrderId isFromMall:NO];
//                [[GlobalValue getGlobalValueInstance] setIsFromOrderGROUPDetailForAlix:NO];
            }
            else if(isFromOrderSuccess)
            {
                [controller enterOrderSubmitOKVC:onlineAlixPayOrderId];
                [[GlobalValue getGlobalValueInstance] setIsFromOrderSuccessForAlix:NO];
            }
            else
            {
                [controller removeSubControllerClass:[MyOrder class]];
                MyOrder *myOrder=[[[MyOrder alloc]initWithNibName:@"MyOrder" bundle:nil] autorelease];
                [controller.view addSubview:myOrder.view];
            }
            [[GlobalValue getGlobalValueInstance] setAlixpayOrderId:nil];
        } afterDelay:0.5];
    }
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    DebugLog(@"applicationDidEnterBackground");

    [[OTSOnlinePayNotifyCanceller sharedInstance] stopAll];
    
//    [self reportinterfaceLog];
    
//    if (isVersionUpdate)
//    {
//        exit(0);
//    }
}

-(void)reportinterfaceLog
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString * log = [InterfaceLog queryInterfaceLog];
        [SharedDelegate insertAppErrorLog:log methodName:@"iReport:"];
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    DebugLog(@"applicationWillEnterForeground");
//    [[PhoneSplash sharedInstance] delayRemove:[NSNumber numberWithInt:0.5]];
    [[OTSOnlinePayNotifyCanceller sharedInstance] startAll];
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //百分点
     [BfdAgent appDidBecomeActive];
    
    
    DebugLog(@"applicationDidBecomeActive");
    //是否启用GPS定位功能，若用户选择否 则在本次应用生命周期内不弹出GPS定位窗口
    if (!m_GpsAlertDisAble) {
        [self startUpdatingCurrentLocation];
    }
    
    //刷新广告模块
//    [(HomePage*)[tabBarController.viewControllers objectAtIndex:0] updateAdModules];
    
    [self syncMyStoreBadge];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    DebugLog(@"applicationWillTerminate");
}
#pragma mark iconDownLoaderSwitch
-(void)initReachAbility{
    //监听网络环境发生改变
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netTypeChanged:) name:ReachAbilityNetStatusChanged object:nil];
//    
//    hostReach = [[Reachability reachabilityWithHostName:@"interface.m.yihaodian.com"] retain];
//    [hostReach startNotifier];
//    
//    
     [GlobalValue getGlobalValueInstance].shouldDownLoadIcon=YES;
    
//    [self updateReachStatus:hostReach];
//    [IconDownloadSetting initIconDownloadSetting];
}

-(void)netTypeChanged:(NSNotification*)notify{
    [self updateReachStatus:hostReach];
}
-(void)updateReachStatus:(Reachability*)currentReach{
    NetworkStatus netStatus= [currentReach currentReachabilityStatus];
    if (netStatus==ReachableViaWWAN)
    {
        DebugLog(@"3G打开了");
        
        NSNumber* iconSetting= [IconDownloadSetting getIcondownloadAlertHasShow];
        
        //iconsetting为1的时候，表示已经弹出过提示框
        if (iconSetting!=nil&&iconSetting.intValue==1)
        {
            [GlobalValue getGlobalValueInstance].shouldDownLoadIcon=[IconDownloadSetting getIcondownloadSwitchStatus];
        }
        else
        {
            //表示需要弹框
            [self iconAlertShow];
            //弹框完了，置为1
            [IconDownloadSetting setIcondownloadAlertHasShow];
        }
    }else if(netStatus==ReachableViaWiFi){
        [GlobalValue getGlobalValueInstance].shouldDownLoadIcon=YES;
    }
}

-(void)iconAlertShow
{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"节省流量" message:@"检测到您在2G/3G环境下，可以关闭商品图片以节省流量" delegate:self cancelButtonTitle:@"暂时不要" otherButtonTitles:@"设置", nil];
    alert.tag=ICON_SHOW_TAG;
    [alert show];
    [alert release];
}
#pragma mark remote notification
-(void)registerForRemoteNotification{
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    DebugLog(@"收到推送消息++++++++&&&&&********   %@",userInfo);
    if (application.applicationState==UIApplicationStateActive) {
        return;
    }
    if (wapViewVC!=nil) {
        [wapViewVC gotoSuper];
    }
    [tabBarController removeViewControllerWithAnimation:[OTSNaviAnimation animationFade]];
    RemoteNotify* remote= [RemoteNotify sharedRemoteNotify];
    remote.notifyDic=userInfo;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"remoteRecived" object:nil];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    DebugLog(@"deviceToken: %@", deviceToken);
    NSString *sr = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    sr = [sr stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[GlobalValue getGlobalValueInstance] setDeviceToken:sr];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DebugLog(@"-----\n\n\n\n%@\n\n\n\n\n---------\n",error);
}

#pragma mark -
-(HomePage*)homePage
{
    return (HomePage*)[tabBarController.viewControllers objectAtIndex:0];
}

-(PhoneCartViewController*)shoppingCart
{
    return (PhoneCartViewController*)[tabBarController.viewControllers objectAtIndex:2];
}

-(void)refreshCart
{
    DebugLog(@"refreshCart");
    [[self shoppingCart] refreshCart];
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods
- (void)tabBarController:(UITabBarController *)tabBar didSelectViewController:(UIViewController *)viewController
{
    //[self testUpdateBadge];
    
    [window removeSubControllerClass:[OTSContainerViewController class]];
    //商品列表的关闭筛选
    [[NSNotificationCenter defaultCenter] postNotificationName:CATE_DISSMISS_SELECTION object:nil];
    
	// 首页
	if (viewController == [tabBarController.viewControllers objectAtIndex:0])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"closeSearchHistoryAndRelationView" object:nil];
        
//		if (temporaryIndex!=[tabBar selectedIndex] && !m_UpdateHomePage)
//        {
//            [[OTSGlobalLoadingView sharedInstance] hide];
//            //[[NSNotificationCenter defaultCenter] postNotificationName:@"MainWindowHideLoading" object:nil];
//		}
//        else
//        {
            m_UpdateHomePage=NO;
			[((HomePage*)(viewController)) returntoHomePage];
            
//            [((OTSBaseViewController*)viewController) removeSubControllerClass:[OTSMaterialFLowVC class]];
//            [((OTSBaseViewController*)viewController) removeSubControllerClass:[OTSNNPiecesVC class]];
//		}
        //刷新广告模块
        [(HomePage*)[tabBarController.viewControllers objectAtIndex:0] updateAdModules];
        
		[tabBarController selectItemAtIndex:0];
        
	}
    
	// 分类
	if (viewController==[tabBarController.viewControllers objectAtIndex:1])
    {
//        if (temporaryIndex!=[tabBar selectedIndex] && !m_UpdateCategory)
//        {
//            [[OTSGlobalLoadingView sharedInstance] hide];
//            
//        }
//        else
//        {
            m_UpdateCategory=NO;
            //点击分类 清空level 列表
            [[GlobalValue getGlobalValueInstance].cateLeveltrackArray removeAllObjects];
            CategoryViewController *viewC= (CategoryViewController *)viewController;
            [viewC enterTopCategory:YES];
            [viewC refreshCategory];
//        }
        [tabBarController selectItemAtIndex:1];
	}
	// 购物车
	if (viewController==[tabBarController.viewControllers objectAtIndex:2]) {
		if (tabBarController.selectedIndex!=temporaryIndex && !m_UpdateCart)
        {
            [[OTSGlobalLoadingView sharedInstance] hide];
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"MainWindowHideLoading" object:nil];
		}
        else
        {
            if (m_UpdateCart)
            {
                [(PhoneCartViewController *)viewController doReloadCart];
            }
			[(PhoneCartViewController *)viewController showMainViewFromTabbarMaskAnimated:NO];

		}
        [tabBarController selectItemAtIndex:2];
	}
    // 我的1号店
	if (viewController==[tabBarController.viewControllers objectAtIndex:3])
    {
        DebugLog(@"===> clicked %@",[NSDate date]);
        
        if ([GlobalValue getGlobalValueInstance].ywToken!=nil)
        {
            if (tabBarController.selectedIndex!=temporaryIndex && !m_UpdateMyStore)
            {
                [[OTSGlobalLoadingView sharedInstance] hide];
            }
            else
            {
                m_UpdateMyStore=NO;
                [(MyStoreViewController *)viewController updateMyStore];
            }
            
            [(MyStoreViewController *)viewController removeAllMyVC];
        }
        else
        {
            [SharedDelegate enterUserManageWithTag:13];
        }
        [tabBarController selectItemAtIndex:3];
        DebugLog(@"===> end clicked %@",[NSDate date]);
        
        
        
// 1号店原版 
//        if ([GlobalValue getGlobalValueInstance].token!=nil)
//        {
//            if (tabBarController.selectedIndex!=temporaryIndex && !m_UpdateMyStore)
//            {
//                [[OTSGlobalLoadingView sharedInstance] hide];
//            }
//            else
//            {
//                m_UpdateMyStore=NO;
//                [(MyStoreViewController *)viewController updateMyStore];
//            }
//        }
//        else
//        {
//            [SharedDelegate enterUserManageWithTag:13];
//        }
//        [tabBarController selectItemAtIndex:3];
	}
	// 更多
	if (viewController == [tabBarController.viewControllers objectAtIndex:4]) {
//		if (temporaryIndex ==[tabBar selectedIndex])
//        {
			[(More *)viewController showMainView];
			[viewController.view setUserInteractionEnabled:YES];
//		}
//        else
//        {
            [[OTSGlobalLoadingView sharedInstance] hide];
//        }
		[tabBarController selectItemAtIndex:4];
	}
}

- (BOOL)tabBarController:(UITabBarController *)tabBar shouldSelectViewController:(UIViewController *)viewController {
    temporaryIndex=tabBarController.selectedIndex;
    return YES;
}

//进入分类
-(void)enterCategory
{
    [self toTabPageIndex:1];
}

//---------打开最近浏览页面------------
-(void)recevieopenBrowse
{
    [self toTabPageIndex:4];
    More *obj = [tabBarController.viewControllers objectAtIndex:4];
    [obj removeSubControllerClass:[MyBrowse class]];
    MyBrowse *browse=[[[MyBrowse alloc]initWithNibName:@"MyBrowse" bundle:nil] autorelease];
    browse->_isfromcart = YES;
    [obj pushVC:browse animated:YES];
}

//---------打开我的收藏页面------------
-(void)enterMyFavorite:(FavoriteFromTag)fromTag
{
    if ([GlobalValue getGlobalValueInstance].token!=nil)
    {
        [self toTabPageIndex:3];
        MyStoreViewController *obj = [tabBarController.viewControllers objectAtIndex:3];
        [obj removeSubControllerClass:[MyFavorite class]];
        MyFavorite *myFavorite=[[[MyFavorite alloc]initWithNibName:@"MyFavorite" bundle:nil] autorelease];
        myFavorite->fromTag = fromTag;
        [obj pushVC:myFavorite animated:YES];
    }
    else
    {
        if (fromTag == FROM_CART_TO_FAVORITE)
        {
            [SharedDelegate enterUserManageWithTag:12];
        } else if (fromTag == FROM_HOMEPAGE_TO_FAVORITE) {
            [SharedDelegate enterUserManageWithTag:15];
        }
    }
}

//进入街旁
-(void)enterJiePangWithProductVO:(ProductVO *)productVO isExclusive:(BOOL)isExclusive
{
    [tabBarController enterJiePangWithProductVO:productVO isExclusive:(BOOL)isExclusive];
}

//进入团购详情
-(void)enterGrouponDetailWithAreaId:(NSNumber *)areaId products:(NSArray *)products currentIndex:(int)index fromTag:(int)fromTag isFullScreen:(BOOL)isFullScreen
{
    [tabBarController enterGrouponDetailWithAreaId:areaId products:products currentIndex:index fromTag:fromTag isFullScreen:isFullScreen];
}

-(void)enterUserManageWithTag:(int)tag
{
    [tabBarController enterUserManageWithTag:tag];
}

//-(void)enterFilterWithSearchResultVO:(SearchResultVO *)searchResultVO condition:(NSMutableDictionary *)condition fromTag:(int)fromTag
//{
//    [tabBarController enterFilterWithSearchResultVO:searchResultVO condition:condition fromTag:fromTag];
//}

-(void)enterOnlinePayWithOrderId:(int)orderId
{
    [tabBarController enterOnlinePayWithOrderId:orderId];
}

-(void)homePageSearchBarBecomeFirstResponder
{
    [self toTabPageIndex:0];
    [(HomePage*)[tabBarController.viewControllers objectAtIndex:0] homePageSearchBarBecomeFirstResponder];
}

/*
 - (void)addLocalProductItem:(LocalCartItemVO *)localProductVO
 {
 NSData * data = [[NSData alloc] initWithContentsOfFile:[GlobalValue getGlobalValueInstance].localCartFileName];
 LocalCartService *service=[[LocalCartService alloc] init];
 if ([data length] < 2) {
 [[service generateASingleTipWithLocalCartItemVO:localProductVO]
 writeToFile:[GlobalValue getGlobalValueInstance].localCartFileName atomically:NO];
 } else {
 [service appendToExistsFileWithFilePath:[GlobalValue getGlobalValueInstance].localCartFileName item:localProductVO];
 }
 [service release];
 [data release];
 }
 */

//- (void)addLocalProductItemToSqlite3:(LocalCartItemVO *)localProductVO
//{
//    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
//    LocalCartService *service=[[[LocalCartService alloc] init] autorelease];
//    [service queryLocalCartByIdCountFromSqlite3:localProductVO];
//    [pool drain];
//}

// 添加商品到本地
-(void)addProductToLocal:(LocalCartItemVO *)localCartItemVO
{

    //写数据库
//    [self otsDetatchMemorySafeNewThreadSelector:@selector(addLocalProductItemToSqlite3:) toTarget:self withObject:localCartItemVO];
    
    
}

//-(BOOL)isItemInLocalCart:(LocalCartItemVO*)aCartItem
//{
//    BOOL isInCart = NO;
//    LocalCartService* service = [[[LocalCartService alloc] init] autorelease];
//    //    NSArray *items = [service getLocalCartArrayWithFilePath:[GlobalValue getGlobalValueInstance].localCartFileName];
//    NSArray *items = [service queryLocalCartFromSqlite3];
//    
//    for (LocalCartItemVO *theItem in items)
//    {
//        if ([theItem.productId longLongValue] == [aCartItem.productId longLongValue])
//        {
//            isInCart = YES;
//            break;
//        }
//    }
//    
//    return isInCart;
//}





-(void)logout
{
    [(MyStoreViewController*)[tabBarController.viewControllers objectAtIndex:3] logout];
}

-(void)toTabPageIndex:(int)aIndex
{
    tabBarController.selectedIndex = aIndex;
	//User_frontselectedIndexTwo = aIndex;
    [tabBarController selectItemAtIndex:aIndex];
}

-(void)toTabPageIndex:(int)aIndex popToRoot:(BOOL)aIsPopToRoot
{
    tabBarController.selectedIndex = aIndex;
    [tabBarController selectItemAtIndex:aIndex];
    
    if (aIsPopToRoot)
    {
        [((OTSBaseViewController*)tabBarController.selectedViewController) removeAllMyVC];
    }
}

-(void)enterMyStoreWithUpdate:(BOOL)update
{
    [self toTabPageIndex:3];
    if (update) {
        [(MyStoreViewController *)[tabBarController.viewControllers objectAtIndex:3] updateMyStore];
    }
}

-(void)enterHomePageRoot
{
    [self toTabPageIndex:0];
    [(HomePage*)[tabBarController.viewControllers objectAtIndex:0] returntoHomePage];
}

-(void)enterCartRoot
{
    [self toTabPageIndex:2];
	if (m_UpdateCart) {
        [(PhoneCartViewController *)[tabBarController.viewControllers objectAtIndex:2] refreshCart];
    }
    [(PhoneCartViewController *)[tabBarController.viewControllers objectAtIndex:2] showMainViewFromTabbarMaskAnimated:NO];
}

-(void)enterCartWithUpdate:(BOOL)update
{
    if (update)
    {
        [(PhoneCartViewController *)[tabBarController.viewControllers objectAtIndex:2] refreshCart];
    }
    
    [(PhoneCartViewController *)[tabBarController.viewControllers objectAtIndex:2] showMainViewFromTabbarMaskAnimated:NO];
    
    [self toTabPageIndex:2];
}

-(void)enterCartWithTipInView:(NSString *)string

{
    [(PhoneCartViewController *)[tabBarController.viewControllers objectAtIndex:2] showMainViewFromTabbarMaskAnimated:NO];
    [self toTabPageIndex:2];
    [(PhoneCartViewController *)[tabBarController.viewControllers objectAtIndex:2] toastShowString:string];
}

//首页物流
-(void)enterHomePageLogistic
{
    [self toTabPageIndex:0];
    [(HomePage*)[tabBarController.viewControllers objectAtIndex:0] enterLogisticQuery];
}

-(void)showAddCartAnimationWithDelegate:(id)delegate
{
    [tabBarController showAddCartAnimationWithDelegate:delegate];
}

//发送错误日志
-(void)insertAppErrorLog:(NSString *)errorLog methodName:(NSString *)methodName
{
    if (![methodName isEqualToString:@"insertAppErrorLog"]) {
        DebugLog(@"!!!!!!ERROR!!!!!!!  %@  %@",methodName,errorLog);
        [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadInsertAppErrorLog:) toTarget:self withObject:[NSString stringWithFormat:@"%@｜%@",methodName,errorLog]];
    }
}

-(void)newThreadInsertAppErrorLog:(NSString *)errorLog
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    SystemService *service=[[SystemService alloc] init];
    [service insertAppErrorLog:[GlobalValue getGlobalValueInstance].trader errorLog:errorLog token:[GlobalValue getGlobalValueInstance].token];
    [service release];
    [pool drain];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

-(void)showWebErrorAlertView {
    if(![GlobalValue getGlobalValueInstance].haveAlertViewInShow) {
        [[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:YES];
        UIAlertView * alert = [[OTSAlertView alloc] initWithTitle:nil message:@"网络异常，请检查网络配置..." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.tag=WEB_ERROR_TAG;
        [alert show];
        [alert release];
        alert = nil;
    }
}

-(void)showWebOtherErrorAlertView {
    if(![GlobalValue getGlobalValueInstance].haveAlertViewInShow) {
        [[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:YES];
        UIAlertView * alert = [[OTSAlertView alloc] initWithTitle:nil message:[GlobalValue getGlobalValueInstance].errorString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.tag=WEB_OTHER_ERROR_TAG;
        [alert show];
        [alert release];
        alert = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if(alertView.tag==WEB_ERROR_TAG){
	}
    if (alertView.tag==ICON_SHOW_TAG) {
        if (buttonIndex==1) {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            [self toTabPageIndex:4];
            More *obj = [tabBarController.viewControllers objectAtIndex:4];
            IconCacheViewController* cacheSetting=[[IconCacheViewController alloc] init];
            [obj pushVC:cacheSetting animated:YES fullScreen:YES];
            [cacheSetting release];
        }
    }
    [[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:NO];
}

#pragma mark    导航
-(NSString *)provinceFromString:(NSString *)string
{
    if ([string length]<1) {
        return @"上海";
    }
    NSString *endString=[string substringWithRange:NSMakeRange([string length]-1, 1)];
    if ([endString isEqualToString:@"省"] || [endString isEqualToString:@"市"]) {
        NSString *subString=[string substringWithRange:NSMakeRange(0, [string length]-1)];
        return subString;
    }
    if ([string isEqualToString:@"Shanghai"]) {
        return @"上海";
    } else if ([string isEqualToString:@"Beijing"]) {
        return @"北京";
    } else if ([string isEqualToString:@"Tianjin"]) {
        return @"天津";
    } else if ([string isEqualToString:@"Hebei"]) {
        return @"河北";
    } else if ([string isEqualToString:@"Jiangsu"]) {
        return @"江苏";
    } else if ([string isEqualToString:@"Zhejiang"]) {
        return @"浙江";
    } else if ([string isEqualToString:@"Chongqing"]) {
        return @"重庆";
    } else if ([string isEqualToString:@"Neimenggu"]) {
        return @"内蒙古";
    } else if ([string isEqualToString:@"Liaoning"]) {
        return @"辽宁";
    } else if ([string isEqualToString:@"Jilin"]) {
        return @"吉林";
    } else if ([string isEqualToString:@"Heilongjiang"]) {
        return @"黑龙江";
    } else if ([string isEqualToString:@"Sichuan"]) {
        return @"四川";
    } else if ([string isEqualToString:@"Anhui"]) {
        return @"安徽";
    } else if ([string isEqualToString:@"Fujian"]) {
        return @"福建";
    } else if ([string isEqualToString:@"Jiangxi"]) {
        return @"江西";
    } else if ([string isEqualToString:@"Shandong"]) {
        return @"山东";
    } else if ([string isEqualToString:@"Henan"]) {
        return @"河南";
    } else if ([string isEqualToString:@"Hubei"]) {
        return @"湖北";
    } else if ([string isEqualToString:@"Hunan"]) {
        return @"湖南";
    } else if ([string isEqualToString:@"Guangdong"]) {
        return @"广东";
    } else if ([string isEqualToString:@"Guangxi"]) {
        return @"广西";
    } else if ([string isEqualToString:@"Hainan"]) {
        return @"海南";
    } else if ([string isEqualToString:@"Guizhou"]) {
        return @"贵州";
    } else if ([string isEqualToString:@"Yunnan"]) {
        return @"云南";
    } else if ([string isEqualToString:@"Xizang"]) {
        return @"西藏";
    } else if ([string isEqualToString:@"Shaanxi"]) {
        return @"陕西";
    } else if ([string isEqualToString:@"Gansu"]) {
        return @"甘肃";
    } else if ([string isEqualToString:@"Qinghai"]) {
        return @"青海";
    } else if ([string isEqualToString:@"Xinjiang"]) {
        return @"新疆";
    } else if ([string isEqualToString:@"Ningxia"]) {
        return @"宁夏";
    } else if ([string isEqualToString:@"Taiwan"]) {
        return @"台湾";
    } else if ([string isEqualToString:@"Shanxi"]) {
        return @"山西";
    } else {
        return @"上海";
    }
}


-(void)updateCurrentLocation:(CLLocationCoordinate2D *) newLocation
{
    NSNumber * lat=[NSNumber numberWithDouble:newLocation->latitude];
    NSNumber * lon=[NSNumber numberWithDouble:newLocation->longitude];
    [[GlobalValue getGlobalValueInstance].trader setLatitude:lat];
    [[GlobalValue getGlobalValueInstance].trader setLongitude:lon];
}


#pragma mark - CLLocationManagerDelegate Methods
- (void)startUpdatingCurrentLocation
{
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    [locationManager setDelegate:self];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    m_Getlocation=NO;
    [locationManager startUpdatingLocation];
}

- (void)stopUpdatingCurrentLocation
{
    [locationManager stopUpdatingLocation];
    locationManager.delegate=nil;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    currentUserCoordinate = [newLocation coordinate];
    [self updateCurrentLocation:&(currentUserCoordinate)];
    [self performCoordinateGeocode];
    [self stopUpdatingCurrentLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    DebugLog(@"%@", error);
    // stop updating
    [self stopUpdatingCurrentLocation];
    //使用省份切换 只切换一次
    /****
     if (!m_IsFirstAddSwitch) {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"AddSwitchProvinceForTabBar" object:nil];
     m_IsFirstAddSwitch = YES;
     }
     */
}

-(void) performCoordinateGeocode
{
    CLLocationCoordinate2D coord =  currentUserCoordinate;
    DebugLog(@"xyn DEBUG  coord.latitude %f",coord.latitude);
    DebugLog(@"xyn DEBUG  coord.longitude %f",coord.longitude);
    
    //百分点
    [BfdAgent position:nil latitude:coord.latitude longitude:coord.longitude options:nil];
    
    
    if (!m_Getlocation) {
        m_Getlocation = YES;
        self.mkreverseGeocoder = [[[MKReverseGeocoder alloc] initWithCoordinate:coord] autorelease];
        mkreverseGeocoder.delegate = self;
        [mkreverseGeocoder start];
    }
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    
    [self handlePlacemarks:placemark];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    [mkreverseGeocoder cancel];
    mkreverseGeocoder.delegate=nil;
    /***
     [[NSNotificationCenter defaultCenter] postNotificationName:@"AddSwitchProvinceForTabBar" object:nil];
     **/
}

-(void)handlePlacemarks:(MKPlacemark *)placemark
{
    // parse 解析前缀  local 本地存储前缀
    NSString *parseCityName = nil;
    parseCityName =  [NSString stringWithFormat:@"%@",[[placemark addressDictionary] objectForKey:@"State"]];
    NSString *localProvince=[[GPSUtil sharedInstance] getProvinceFromPlist];
    if (parseCityName && [parseCityName length]>0)
    {
        parseCityName = [self provinceFromString:parseCityName];
        [[GlobalValue getGlobalValueInstance] setGpsProvinceStr:parseCityName];
        ProvinceVO* gpsProvince = [[[ProvinceVO alloc] init] autorelease];
        gpsProvince.provinceName = parseCityName;
        NSDictionary* provinceDic = [[GPSUtil sharedInstance] getProvinceDic];
        NSNumber *proviceId = [[[NSNumber alloc]initWithInt:[[provinceDic objectForKey:parseCityName] intValue]] autorelease];
        gpsProvince.nid = proviceId;
        [GPSUtil sharedInstance].gpsProvinceVO = gpsProvince;
    }
    //避免重复弹筐
    if (!m_isAlertViewShowing) {
        if (parseCityName) {
            if (m_IsFirstLaunch&&![parseCityName isEqualToString:localProvince]) {
                [self performInMainBlock:^(){
                    [(HomePage*)[tabBarController.viewControllers objectAtIndex:0] appFirstLaunch];
                }];
                
            } else {
                if (![parseCityName isEqualToString:localProvince]) {
                    [self performInMainBlock:^(){
                        [(HomePage*)[tabBarController.viewControllers objectAtIndex:0] appStartLaunch];
                    }];
                }
            }
        }
    }
}


#pragma mark -网页
-(void)enterWap:(NSInteger)waptype invokeUrl:(NSString*)invokeUrl isClearCookie:(BOOL)isClearCookie{
    // 清空cookie
    if (isClearCookie) {
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies]) {
            //            DebugLog(@"%@",cookie.domain);
            if ([cookie.domain rangeOfString:@"m.1mall.com"].location!=NSNotFound) {
                [storage deleteCookie:cookie];
            }
        }
    }
    //    [window removeSubControllerClass:[WapViewController class]];
    wapViewVC=[[WapViewController alloc] init];
    wapViewVC.wapType=waptype;
    wapViewVC.urlString=invokeUrl;
    wapViewVC.isFirstLoadWeb = YES;
    wapViewVC.isFullScreen = YES;
    [window.layer addAnimation:[OTSNaviAnimation animationMoveInFromBottom] forKey:@"Reveal"];
    [window addSubview:wapViewVC.view];
}
#pragma mark - 进入摇购界面
//1起摇
-(void)enterRockBuy
{
    OTSPhoneWeRockMainVC * theVC = [[[OTSPhoneWeRockMainVC alloc] initWithNibName:@"OTSPhoneWeRockMainVC" bundle:nil]autorelease];
    
    if ([_rockVC retainCount] > 1)
    {
        
        [_rockVC release];
    }
    // 将摇摇购也改变成现在通用的通过tabbar的方式加上去。 蛋疼死了，什么时候才能用官方的 navigation 方式啊啊啊啊！！！
    self.rockVC = theVC;
    CGRect rect = self.rockVC.view.frame;
    rect.origin.y = 0;
    self.rockVC.view.frame = rect;
    [tabBarController addViewController:self.rockVC withAnimation:[OTSNaviAnimation animationPushFromRight]];
    //    [window.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
    //    [window addSubview:self.rockVC.view];
}

#pragma mark - 方便方法
+(void)showFavoriteTipWithState:(int)aFavoriteState inView:(UIView*)aView productId:(NSString *)productId
{
	NSString* tipStr = nil;
    
	switch (aFavoriteState)
    {
		case 1:	//收藏成功
            tipStr = @"收藏成功";
			break;
            
		case 9://商品已收藏
            tipStr = @"商品已收藏";
			break;
            
		default:
            tipStr = @"收藏失败";
			break;
	}
    
    //把收藏信息存本地。。。。。哎。。。
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@%@",productId,[GlobalValue getGlobalValueInstance].userInfo.ecUserId]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[OTSGlobalLoadingView sharedInstance] showTipInView:aView title:tipStr];
}

-(UIImageView*)checkMarkView
{
    UIImageView* checkMarkView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filter_tick.png"]] autorelease];
    CGRect checkMarkRect = checkMarkView.frame;
    checkMarkRect.size = CGSizeMake(13, 14);
    checkMarkView.frame = checkMarkRect;
    
    return checkMarkView;
}

-(CGRect)screenRectHasTabBar:(BOOL)aHasTabBar statusBar:(BOOL)aHasStatusBar
{
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGRect newRect = screenRect;
    
    int statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    int tabBarHeight = tabBarController.tabBar.frame.size.height;
    
    if (aHasStatusBar)
    {
        newRect.origin.y = statusHeight;
        newRect.size.height -= statusHeight;
    }
    
    if (aHasTabBar)
    {
        newRect.size.height -= tabBarHeight;
    }
    
    return newRect;
}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    OTS_SAFE_RELEASE(trader);
    OTS_SAFE_RELEASE(window);
    OTS_SAFE_RELEASE(tabBarController);
    OTS_SAFE_RELEASE(tabbarMaskVC);
    OTS_SAFE_RELEASE(wapViewVC);
    
    [locationManager stopUpdatingLocation];
    locationManager.delegate=nil;
    [locationManager release];
    
    [mkreverseGeocoder cancel];
    mkreverseGeocoder.delegate=nil;
    [mkreverseGeocoder release];
    
    [_rockVC release];
    
    [_heartBeatTimer invalidate];
    [_heartBeatTimer release];
    
    [super dealloc];
}





- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self ];
}


#pragma mark - URL types
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    DebugLog(@"the url is:%@, the sourceAPP is:%@",[url absoluteString], sourceApplication);
    
    //支付宝登录返回的
    if (url != nil && [[url host] compare:@"safepay"] == 0)
    {
        NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
		SBJsonParser * parser = [[SBJsonParser alloc] init];
		NSDictionary * jsonQuery = [parser objectWithString:query];
        NSLog(@"=====>>>>>> %@",jsonQuery);
        [parser release];
        
        ResultInfo *aliResult = [[[ResultInfo alloc] init] autorelease];
        NSDictionary * jsonMemo = [jsonQuery objectForKey:@"memo"];
        if (jsonMemo)
        {
            NSInteger *statusCode = [[jsonMemo objectForKey:@"ResultStatus"] intValue];
//            NSString *statusMessage = [jsonMemo objectForKey:@"memo"];
            aliResult.resultCode = statusCode;
            
            NSString *auth_code;
            NSString *alipay_user_id;
            NSString *resultString = [jsonMemo objectForKey:@"result"];
            NSArray *arr = [resultString componentsSeparatedByString:@"\""];
            NSLog(@"arr==> %@",arr);
            if (arr.count >= 4)
            {
                auth_code = arr[1];
                alipay_user_id = arr[3];
                NSDictionary *resultDic = @{@"auth_code":auth_code,@"alipay_user_id":alipay_user_id};
                aliResult.resultObject = resultDic;
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kYaoNitifyAlipayLogin object:aliResult];
        
        return YES;
	}
    
    m_GpsAlertDisAble = YES;
    
     return [ WeiboSDK handleOpenURL:url delegate:self ];
}

#pragma mark - weibo
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = @"分享结果";
        
        NSString *resultStr = @"";
        if (response.statusCode == 0)
        {
            //分享成功
            resultStr = @"分享成功";
        }
        else
        {
            resultStr = @"分享失败";
        }
        
        
//        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",
//                             response.statusCode, response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:resultStr
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
//        [[OTSGlobalLoadingView sharedInstance] showTipInView:self.window title:resultStr];
        
        
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *title = @"认证结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",
                             response.statusCode, [(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}



@end

