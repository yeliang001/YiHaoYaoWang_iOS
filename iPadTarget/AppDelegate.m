//
//  AppDelegate.m
//  yhd
//
//  Created by  on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ProvinceVO.h"
#import "DataHandler.h"
#import "CartItemVO.h"
#import "CartVO.h"
#import "OTSServiceHelper.h"
#import "LocalCartItemVO.h"
#import "ProductVO.h"
#import "MobClick.h"
#import "PADCartViewController.h"
#import "ProductListViewController.h"
#import "GlobalValue.h"
#import "Trader.h"
#import "OTSGpsHelper.h"
#import "DownloadVO.h"
#import "OtspOrderConfirmVC.h"
#import "OTSGrouponDetail.h"
#import "MyListViewController.h"
#import "URLSchemeForPad.h"
//#import "CentralMobileFacadeService.h"
#define LAST_RUN_VERSION_KEY        @"last_run_version_of_application"
static BOOL firstActive = YES;

@implementation CLLocationManager (TemporaryHack)

//- (void)hackLocationFix
//{
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:31.22 longitude:120.222];
//    [[self delegate] locationManager:self didUpdateToLocation:location fromLocation:nil];     
//}
//
//- (void)startUpdatingLocation
//{
//    [self performSelector:@selector(hackLocationFix) withObject:nil afterDelay:0.1];
//}
@end
@implementation AppDelegate

@synthesize window = _window;
//@synthesize viewController = _viewController;
@synthesize navigationController=_navigationController;
@synthesize defaultProductImg = _defaultProductImg;
@synthesize isVersionUpdate = _isVersionUpdate;
@synthesize isFirstLaunchCart = _isFirstLaunchCart;
@synthesize isGpsAlertDisAble = _isGpsAlertDisAble;
//@synthesize province;

-(id)init
{
    return [super init];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_window release];
    [_navigationController release];
    
    [locationManager stopUpdatingLocation];
    locationManager.delegate=nil;
    [locationManager release];
    
    [m_Geocoder cancel];
    m_Geocoder.delegate=nil;
    [m_Geocoder release];
    
    //[province release];
    
    [super dealloc];
}

- (BOOL) isFirstLoad{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastRunVersion = [defaults objectForKey:LAST_RUN_VERSION_KEY];
    
    if (!lastRunVersion) {
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        return YES;
        // App is being run for first time
    }
    else if (![lastRunVersion isEqualToString:currentVersion]) {
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        return YES;
        // App has been updated since last run
    }
    return NO;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 获取sessionID
    NSDate* currentDate = [NSDate date];
    NSDate* formerDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"session_timeInterval"];
    NSTimeInterval time=[currentDate timeIntervalSinceDate:formerDate];
    if ((int)time/3600 >= 24 || formerDate == nil || (int)time == 0) {
        // 生成随机的session_id
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
    
    self.defaultProductImg = [UIImage imageNamed:@"productDefault"];
    
    Trader *trader = [[[Trader alloc] init] autorelease];
    trader.unionKey = kTrackid;
    
    [[GlobalValue getGlobalValueInstance] setTrader:trader];
    
    [self getCurrentProvinceId];
    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    //友盟统计
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithAppkey:@"5008ff08527015247700003b" reportPolicy:REALTIME channelId:kTrackName];
//    [MobClick checkUpdate];//自动更新提示
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(handleProVinceChange:)
                                                  name:kNotifyProvinceChange object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(cancelGPS) name:kNotifyCancelGPS object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(mallCartChanged:) name:kNotifyMallCartChange object:nil];

    //1mall&1store token切换后，更新session购物车和省份
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleProVinceChange:) name:NOTIFY_NAME_USER_VO_UPDATED object:nil];
    
    [self otsDetatchMemorySafeNewThreadSelector:@selector(registerLaunchInfo) toTarget:self withObject:nil];
    [self checkVersionUpdate];
    
    self.isFirstLaunchCart = YES;

    return YES;
}

-(void)checkVersionUpdate
{
    __block DownloadVO * downloadVO = nil;
    [self performInThreadBlock:^{
    
        downloadVO = [[OTSServiceHelper sharedInstance] getClientApplicationDownloadUrl:[GlobalValue getGlobalValueInstance].trader];
        [GlobalValue getGlobalValueInstance].downloadVO = downloadVO;
        
    } completionInMainBlock:^{
    
        if (downloadVO && downloadVO.isCanUpdate)
        {
            
            if (downloadVO.isForceUpdate)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:[NSString stringWithFormat:@"%@", downloadVO.remark] delegate:self cancelButtonTitle:@"更新" otherButtonTitles:nil];
                [alert show];
                alert.tag = 7788;
                [alert release];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:[NSString stringWithFormat:@"%@", downloadVO.remark] delegate:self cancelButtonTitle:@"稍后" otherButtonTitles:@"更新", nil];
                [alert show];
                alert.tag = 7789;
                [alert release];
            }
        }
    
    }];
}


-(void)enterITunesToUpdate
{
    [GlobalValue getGlobalValueInstance].downloadVO = nil;
    self.isVersionUpdate = YES;
    
    NSURL * iTunesUrl = [NSURL URLWithString:@"http://itunes.apple.com/cn/app/id427457043?mt=8&ls=1"];
    [[UIApplication	sharedApplication] openURL:iTunesUrl];
}

//获取省份id
-(void)getCurrentProvinceId
{
    [GlobalValue getGlobalValueInstance].provinceId = [OTSGpsHelper sharedInstance].provinceVO.nid;
//    NSBundle *bundle=[NSBundle mainBundle];
//	NSString *listPath=[bundle pathForResource:@"ProvinceID" ofType:@"plist"];//获得资源文件路径
//	NSDictionary* provinceDic=[[NSDictionary alloc] initWithContentsOfFile:listPath];//获得内容
//	
//	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//	NSString *path=[paths objectAtIndex:0];
//	NSString *filename=[path stringByAppendingPathComponent:@"SaveProvinceId.plist"]; 
//	NSMutableArray *userArray=[[NSMutableArray alloc] initWithContentsOfFile:filename];
//    if (userArray==nil) {
//        NSMutableArray *array=[[NSMutableArray alloc]init];
//        [array addObject:@"上海"];
//        [array writeToFile:filename  atomically:NO];
//        [array release];
//        [[GlobalValue getGlobalValueInstance] setProvinceId:[NSNumber numberWithInt:1]];
//    } else {
//    }
//	NSNumber *proviceId = [[NSNumber alloc]initWithInt:[[provinceDic objectForKey:[userArray objectAtIndex:0]] intValue]];
//    [provinceDic release];
//    [userArray release];
//	
//	[[GlobalValue getGlobalValueInstance] setProvinceId:proviceId];
    
}

-(void)registerLaunchInfo
{
    NSAutoreleasePool * pool=[[NSAutoreleasePool alloc]init];
   
   [[OTSServiceHelper sharedInstance]  registerLaunchInfo:[GlobalValue getGlobalValueInstance].trader iMei:@"" phoneNo:@"0000000000"];
   
    [pool drain];
}

- (void)enterCart
{
    int i;
    for (i=0; i<[self.navigationController.viewControllers count]; i++)
    {
        UIViewController *viewController=[self.navigationController.viewControllers objectAtIndex:i];
        if ([viewController isKindOfClass:[PADCartViewController class]])
        {
            [viewController removeFromParentViewController];
            break;
        }
    }
    [self.navigationController.view.layer addAnimation:[OTSNaviAnimation transactionFade] forKey:nil];
    PADCartViewController *cartViewController=[[[PADCartViewController alloc] init] autorelease];
    [cartViewController setNeedShowTips:self.isFirstLaunchCart];
    [self.navigationController pushViewController:cartViewController animated:NO];
    
//    JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStrakcing_EnterCart extraPrama:nil]autorelease];
//    [DoTracking doJsTrackingWithParma:prama];
}

-(void)goSearch:(id)sender
{
    UITextField *textField=(UITextField *)sender;
    
    [self.navigationController.view.layer addAnimation:[OTSNaviAnimation transactionFade] forKey:nil];
    
    ProductListViewController *myController =
    [[[ProductListViewController alloc]initWithNibName:nil bundle:nil] autorelease];
    myController.cateid = [NSNumber numberWithInt:0];
    myController.keyword = textField.text;
    myController.productListType = 1;
    
    [self.navigationController pushViewController:myController animated:NO];
}
-(void)goSearchWithKeyWords:(NSString*)str productListType:(NSUInteger)ListType{
    [self.navigationController.view.layer addAnimation:[OTSNaviAnimation transactionFade] forKey:nil];
    
    ProductListViewController *myController =
    [[[ProductListViewController alloc]initWithNibName:nil bundle:nil] autorelease];
    myController.cateid = [NSNumber numberWithInt:0];
    myController.keyword = str;
    myController.productListType = ListType;
    
    [self.navigationController pushViewController:myController animated:NO];
}
//发送错误日志
-(void)insertAppErrorLog:(NSString *)errorLog methodName:(NSString *)methodName
{
}

//清空购物车数量
-(void)clearCartNum
{
}

-(void)syncMyStoreBadge
{
    
}
-(void)logout
{
    
}

//处理 URLScheme
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    self.isGpsAlertDisAble  = YES;
    DebugLog(@"the url is:%@, the sourceAPP is:%@",[url absoluteString], sourceApplication);
    [[URLSchemeForPad sharedScheme]parseWithURL:url];
    return YES;
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if (_isVersionUpdate)
    {
        exit(0);
    }
    
    if ([GlobalValue getGlobalValueInstance].token==nil)
    {
        //保存本地购物车
        int i = 0;
        NSString *localCartPath = [[DataHandler sharedDataHandler] dataFilePath:kLocalCartFilename];


        for (CartItemVO *cartItem in [DataHandler sharedDataHandler].cart.buyItemList)
        {
            LocalCartItemVO *localCartItem = [[LocalCartItemVO alloc]initWithProductVO:cartItem.product quantity:[NSString stringWithFormat:@"%@", cartItem.buyQuantity]];
            
            if (i==0) {
                 NSData *data= [[OTSServiceHelper sharedInstance] generateASingleTipWithLocalCartItemVO:localCartItem];
             
                [data writeToFile:localCartPath atomically:YES];
               
            }
            else {
                 [[OTSServiceHelper sharedInstance] appendToExistsFileWithFilePath:[[DataHandler sharedDataHandler] dataFilePath:kLocalCartFilename]  item:localCartItem];
            }
            [localCartItem release];

            i++;
            
        }
       
        if (i==0 && [[NSFileManager defaultManager] fileExistsAtPath:localCartPath])
        {
            [[OTSServiceHelper sharedInstance] cleanLocalCartWithFilePath:localCartPath];
        }
        
        DebugLog(@"file==%@",[[DataHandler sharedDataHandler] dataFilePath:kLocalCartFilename]);
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (!firstActive)
    {
        [self otsDetatchMemorySafeNewThreadSelector:@selector(registerLaunchInfo) toTarget:self withObject:nil];
    }
    firstActive = NO;
    
    //是否启用GPS定位功能，若用户选择否 则在本次应用生命周期内不弹出GPS定位窗口
    if (!_isGpsAlertDisAble) {
        [self startUpdatingCurrentLocation];
    }
    
    if ([[DataHandler sharedDataHandler].checkNetWorkType isEqualToString:@"no"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"  message:@"网络好像有点问题，请检查网络设置"   delegate:nil  cancelButtonTitle:@"确定"  otherButtonTitles:nil];  
        [alert show];  
        [alert release]; 
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyAppBecomeActive object:nil];
    }
    
    //获取本地购物车
    if ([GlobalValue getGlobalValueInstance].token==nil) {
        NSArray *array=[[OTSServiceHelper sharedInstance] getLocalCartArrayWithFilePath:[[DataHandler sharedDataHandler] dataFilePath:kLocalCartFilename]];
        int totalCount=0;
        double totalPrice=0.0;
        
        [[DataHandler sharedDataHandler].cart.buyItemList removeAllObjects];
        [[DataHandler sharedDataHandler].cart.gifItemtList removeAllObjects];
        [[DataHandler sharedDataHandler].cart.redemptionItemList removeAllObjects];
        
        for (LocalCartItemVO *localCartItem in array) {
            CartItemVO *cartItem=[localCartItem changeToCartItemVO];
            [[DataHandler sharedDataHandler].cart.buyItemList addObject:cartItem];
            
            totalCount+=[localCartItem productCount];
            if ([cartItem.product.promotionPrice doubleValue]>0.0001) {
                totalPrice+=[cartItem.product.promotionPrice doubleValue]*[cartItem.buyQuantity intValue];
            } else {
                totalPrice+=[cartItem.product.price doubleValue]*[cartItem.buyQuantity intValue];
            }
        }
        
        [DataHandler sharedDataHandler].cart.totalquantity=[NSNumber numberWithInt:totalCount];
        [DataHandler sharedDataHandler].cart.totalprice=[NSNumber numberWithDouble:totalPrice];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartChange object:nil];
    }
}

//定位
-(void)startUpdatingCurrentLocation
{
    locationManager= [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    isGetlocation=NO;
    [locationManager startUpdatingLocation];
}

-(void)getSessionCart
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    CartVO *cart = [[OTSServiceHelper sharedInstance] getSessionCart:[GlobalValue getGlobalValueInstance].token];
    
    [self performSelectorOnMainThread:@selector(handleCart:) withObject:cart waitUntilDone:YES];
    
    
    [pool drain];

}
-(void)mallCartChanged:(NSNotification*)notify{
    __block CartVO *cart=nil;
    [self performInThreadBlock:^{
        cart = [[[OTSServiceHelper sharedInstance] getSessionCart:[GlobalValue getGlobalValueInstance].token] retain];

    } completionInMainBlock:^{
        [self handleCart:cart];
        [cart release];
    }];
}

-(void)handleCart:(CartVO *)cart{
    if (cart) {
        [DataHandler sharedDataHandler].cart= cart;
        //打开省份的时候 点击购物车屏蔽
        UIButton * cartBTN = (UIButton *)[self.window viewWithTag:10015];
        [cartBTN setEnabled:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartChange object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartCacheChange object:nil];
    }
    
}

-(void)handleLoginSucceed{
    //读取服务端购物车
    [self performSelector:@selector(getCart) withObject:nil afterDelay:1 ];
}

-(void)getCart{
    //读取服务端购物车
    [self otsDetatchMemorySafeNewThreadSelector:@selector(getSessionCart) toTarget:self withObject:nil ];
}


#pragma mark - notify
-(void)handleUserChanged:(NSNotification *)note{
    //调用省份切换接口
    if ([GlobalValue getGlobalValueInstance].token) {
        [self otsDetatchMemorySafeNewThreadSelector:@selector(changeProvince) toTarget:self withObject:nil];
    }
}

-(void)handleProVinceChange:(NSNotification *)note{
    //调用省份切换接口
    if ([GlobalValue getGlobalValueInstance].token) {
        [self otsDetatchMemorySafeNewThreadSelector:@selector(changeProvince) toTarget:self withObject:nil];
    }
    
    //回到首页/购物车
    CATransition *transition = [CATransition animation];
    transition.duration = OTSP_TRANS_DURATION;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type =kCATransitionFade; //@"cube";
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [SharedPadDelegate.navigationController.view.layer addAnimation:transition forKey:nil];
    
    UIViewController *viewController=[SharedPadDelegate.navigationController topViewController];
    if ([viewController isKindOfClass:[OtspOrderConfirmVC class]]) {
        [SharedPadDelegate.navigationController popViewControllerAnimated:NO];
    }
    if ([viewController isKindOfClass:[OTSGrouponDetail class]]) {
        sleep(0.1);
    }
    else {
        [SharedPadDelegate.navigationController popToRootViewControllerAnimated:NO];
    }
}

-(void)changeProvince
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    [[OTSServiceHelper sharedInstance] changeProvince:[GlobalValue getGlobalValueInstance].token provinceId:[GlobalValue getGlobalValueInstance].provinceId];
    
    [self performSelectorOnMainThread:@selector(handleChangeProvince) withObject:nil waitUntilDone:YES];
    
    [pool drain];
}

-(void)handleChangeProvince{
    
    //打开省份的时候 点击购物车屏蔽
    UIButton * cartBTN = (UIButton *)[self.window viewWithTag:10015];
    [cartBTN setEnabled:NO];
    
    [self otsDetatchMemorySafeNewThreadSelector:@selector(getSessionCart) toTarget:self withObject:nil];
}
-(void)cancelGPS{
    [locationManager stopUpdatingLocation];
    [m_Geocoder cancel];
}

#pragma mark - CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation {
    
    
    //DebugLog(@"%g==%g",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
   
    if (!isGetlocation) {
        
        isGetlocation=YES;
        m_Geocoder=[[MKReverseGeocoder alloc] initWithCoordinate:[newLocation coordinate]];
        [m_Geocoder setDelegate:self];
        [m_Geocoder start];
    }
 

    [locationManager stopUpdatingLocation];
    locationManager.delegate=nil;
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
   // DebugLog(@"locationManagerdidFail");
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"  message:@"定位失败"   delegate:nil  cancelButtonTitle:@"确定"  otherButtonTitles:nil];  
//    [alert show];  
//    [alert release]; 
    [locationManager stopUpdatingLocation];
    locationManager.delegate=nil;
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{  
   
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"  message:@"检测地区失败"   delegate:nil  cancelButtonTitle:@"确定"  otherButtonTitles:nil];  
//    [alert show];  
//    [alert release]; 
    [m_Geocoder cancel];
    m_Geocoder.delegate=nil;
   // DebugLog(@"MKReverseGeocoder has failed."); 


}

- (void)updateProvinceInfo:(NSString *)provinceName provinceNameValueDic:(NSDictionary *)aNameValueDic
{
//    [OTSGpsHelper sharedInstance].provinceVO = [[[ProvinceVO alloc] init] autorelease];
//    [OTSGpsHelper sharedInstance].provinceVO.provinceName = provinceName;
//    id provinceId = [aNameValueDic objectForKey:[OTSGpsHelper sharedInstance].provinceVO.provinceName];
//    
//    [OTSGpsHelper sharedInstance].provinceVO.nid = [NSNumber numberWithInt:[provinceId intValue]];
//    
//    for (id key in aNameValueDic.allKeys)
//    {
//        id obj = [aNameValueDic objectForKey:key];
//        DebugLog(@"obj:%@, key:%@", obj, key);
//    }
//    
//    DebugLog(@"---\ndic:%@\n\nname:%@\n\nid:%@", aNameValueDic
//          , [OTSGpsHelper sharedInstance].provinceVO.provinceName
//          , [OTSGpsHelper sharedInstance].provinceVO.nid);
}

-(NSString*)convertProvinceFromEnglishToChinese:(NSString*)aProvinceName
{
    NSCharacterSet* characterSet= [NSCharacterSet uppercaseLetterCharacterSet];
    //    英文字符集，表示使用英文环境
    if ([aProvinceName rangeOfCharacterFromSet:characterSet].location!=NSNotFound) {
        if ([aProvinceName isEqualToString:@"Shanghai"]) {
            aProvinceName= @"上海";
        } else if ([aProvinceName  isEqualToString:@"Beijing"]) {
            aProvinceName=  @"北京";
        } else if ([aProvinceName  isEqualToString:@"Tianjin"]) {
            aProvinceName=  @"天津";
        } else if ([aProvinceName isEqualToString:@"Hebei"]) {
            aProvinceName=  @"河北";
        } else if ([aProvinceName  isEqualToString:@"Jiangsu"]) {
            aProvinceName=  @"江苏";
        } else if ([aProvinceName  isEqualToString:@"Zhejiang"]) {
            aProvinceName=  @"浙江";
        } else if ([aProvinceName  isEqualToString:@"Chongqing"]) {
            aProvinceName=  @"重庆";
        } else if ([aProvinceName  isEqualToString:@"Neimenggu"]) {
            aProvinceName=  @"内蒙古";
        } else if ([aProvinceName  isEqualToString:@"Liaoning"]) {
            aProvinceName=  @"辽宁";
        } else if ([aProvinceName  isEqualToString:@"Jilin"]) {
            aProvinceName=  @"吉林";
        } else if ([aProvinceName  isEqualToString:@"Heilongjiang"]) {
            aProvinceName=  @"黑龙江";
        } else if ([aProvinceName  isEqualToString:@"Sichuan"]) {
            aProvinceName=  @"四川";
        } else if ([aProvinceName  isEqualToString:@"Anhui"]) {
            aProvinceName=  @"安徽";
        } else if ([aProvinceName isEqualToString:@"Fujian"]) {
            aProvinceName=  @"福建";
        } else if ([aProvinceName  isEqualToString:@"Jiangxi"]) {
            aProvinceName=  @"江西";
        } else if ([aProvinceName  isEqualToString:@"Shandong"]) {
            aProvinceName=  @"山东";
        } else if ([aProvinceName  isEqualToString:@"Henan"]) {
            aProvinceName=  @"河南";
        } else if ([aProvinceName  isEqualToString:@"Hubei"]) {
            aProvinceName=  @"湖北";
        } else if ([aProvinceName  isEqualToString:@"Hunan"]) {
            aProvinceName=  @"湖南";
        } else if ([aProvinceName  isEqualToString:@"Guangdong"]) {
            aProvinceName=  @"广东";
        } else if ([aProvinceName  isEqualToString:@"Guangxi"]) {
            aProvinceName=  @"广西";
        } else if ([aProvinceName  isEqualToString:@"Hainan"]) {
            aProvinceName=  @"海南";
        } else if ([aProvinceName  isEqualToString:@"Guizhou"]) {
            aProvinceName=  @"贵州";
        } else if ([aProvinceName  isEqualToString:@"Yunnan"]) {
            aProvinceName=  @"云南";
        } else if ([aProvinceName  isEqualToString:@"Xizang"]) {
            aProvinceName=  @"西藏";
        } else if ([aProvinceName  isEqualToString:@"Shaanxi"]) {
            aProvinceName=  @"陕西";
        } else if ([aProvinceName  isEqualToString:@"Gansu"]) {
            aProvinceName=  @"甘肃";
        } else if ([aProvinceName isEqualToString:@"Qinghai"]) {
            aProvinceName=  @"青海";
        } else if ([aProvinceName isEqualToString:@"Xinjiang"]) {
            aProvinceName=  @"新疆";
        } else if ([aProvinceName isEqualToString:@"Ningxia"]) {
            aProvinceName=  @"宁夏";
        } else if ([aProvinceName isEqualToString:@"Taiwan"]) {
            aProvinceName=  @"台湾";
        } else if ([aProvinceName isEqualToString:@"Shanxi"]) {
            aProvinceName=  @"山西";
        } else {
            aProvinceName=  @"上海";
        }
    }

    return aProvinceName;
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    NSString*localCityName = placemark.administrativeArea;
    localCityName = [self convertProvinceFromEnglishToChinese:localCityName];

    localCityName = [localCityName stringByReplacingOccurrencesOfString:@"省" withString:@""];
    localCityName = [localCityName stringByReplacingOccurrencesOfString:@"市" withString:@""];
    
    NSDictionary *provinceNameValueDic = [[OTSGpsHelper sharedInstance] provinceNameValueDic];
    NSString * gpsProvinceId = [provinceNameValueDic objectForKey:localCityName];
    
    ProvinceVO* gpsProvince = [[[ProvinceVO alloc] init] autorelease];
    gpsProvince.provinceName = localCityName;
    gpsProvince.nid = [NSNumber numberWithInt:[gpsProvinceId intValue]];
    [OTSGpsHelper sharedInstance].gpsProvinceVO = gpsProvince;
    
    for (NSString *provinceName in [provinceNameValueDic allKeys])
    {
        if ([localCityName  hasPrefix:provinceName])
        {
            NSDictionary *setDic = [[OTSGpsHelper sharedInstance] provinceSetDic];
            
            if (!isAlertViewShowing)
            {
                if (setDic)
                {
                    if (![provinceName isEqualToString:[setDic objectForKey:@"provincename"]]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收货省份选择"  message:[NSString stringWithFormat:@"定位到你当前在%@，需要更换收货省份吗？",provinceName]   delegate:self  cancelButtonTitle:@"取消"  otherButtonTitles:@"更换",nil]; 
                        
                        [alert show];  
                        isAlertViewShowing = YES;
                        [alert release];

                        [self updateProvinceInfo:provinceName provinceNameValueDic:provinceNameValueDic]; 

                    }
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收货省份选择"  message:@"因各省份所售商品不同，请根据你的收货地址选择省份。"   delegate:self  cancelButtonTitle:@"其他省份"  otherButtonTitles:[NSString stringWithFormat:@"进入%@",provinceName],nil]; 
                    alert.tag=500;
                    [alert show];  
                    isAlertViewShowing = YES;
                    [alert release];
                    
                    [self updateProvinceInfo:provinceName provinceNameValueDic:provinceNameValueDic]; 
                }
            }
            break;
        }
    }
    [m_Geocoder cancel];
    m_Geocoder.delegate=nil;

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 7788 && buttonIndex == 0)
    {
        [self enterITunesToUpdate];
    }
    else if (alertView.tag == 7789 && buttonIndex == 1)
    {
        [self enterITunesToUpdate];
    }
    
    else
    {
        if (buttonIndex==1)
        {
            [[OTSGpsHelper sharedInstance] saveProvince:[OTSGpsHelper sharedInstance].gpsProvinceVO];
            
            [GlobalValue getGlobalValueInstance].provinceId = [OTSGpsHelper sharedInstance].provinceVO.nid;
            
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[OTSGpsHelper sharedInstance].provinceVO,@"province", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyProvinceChange object:nil userInfo:dic];
            [self.navigationController.view.layer addAnimation:[OTSNaviAnimation transactionFade] forKey:nil];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
        else
        {
            if (alertView.tag == 500)
            {
                //先关闭再弹出
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyDismissPopOverProvince object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyProvincePop object:nil];
            }
        }
    }
    
    isAlertViewShowing = NO;
}

@end
