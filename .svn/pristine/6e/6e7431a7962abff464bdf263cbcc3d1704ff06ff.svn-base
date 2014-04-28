//
//  RemoteNotify.m
//  TheStoreApp
//
//  Created by yuan jun on 13-1-14.
//
//

#import "RemoteNotify.h"
#import "TheStoreAppAppDelegate.h"
#import "GlobalValue.h"
#import "OrderDetail.h"
#import "OTSNaviAnimation.h"
#import "DoTracking.h"
#define Username @"un"
#define Pageid @"pid"
#define Ordercode @"oc"
#define Promotionid  @"pi"
#define Tracking @"1"
#define Promotion @"2"
#define Orderdetail @"3"
#define Home @"4"
@implementation RemoteNotify
/*
 物流查询	pageid=totracking,ordercode=订单号,username=登录账号
 活动	pageid= topromotion, promotionid=活动ID
 订单详情	pageid= toorderdetail,ordercode=订单号,username=登录账号
 其它	pageid= tohome
 */
@synthesize notifyDic;
-(void)dealloc{
    [notifyDic release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

static RemoteNotify*notify=nil;
-(id)init{
    if (self=[super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNotifyDetail:) name:@"remoteRecived" object:nil];
    }
    return self;
}
+(id)sharedRemoteNotify{
    @synchronized(self){
        if (notify==nil) {
            notify=[[self alloc] init];
        }
    }
    return notify;
}
-(void)showNotifyDetail:(NSNotification*)notify{
    DebugLog(@"进入了remotenotify里面&&&&########$$$$$\n\n%@",notifyDic);
    if (notifyDic==nil) {
        return;
    }
    //开启新线程判断是否在自动登录
    [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadJugdeAccount:) toTarget:self withObject:notify];
}
-(void)newThreadJugdeAccount:(NSNotification*)notify{
    @autoreleasepool {
        NSDate* date=[NSDate date];
        while ([OTSUserLoginHelper sharedInstance].isLogging){
            DebugLog(@"循环中。。。。。。。。");
            //当不在登录中，责跳出循环
            if (![OTSUserLoginHelper sharedInstance].isLogging) {
                break;
            }
            //超过15秒，跳出循环
            NSDate*date1=[NSDate date];
            if ([date1 timeIntervalSinceDate:date]>15) {
                break;
            }
        }
        [self performSelectorOnMainThread:@selector(doNotifyThing:) withObject:notify waitUntilDone:NO];
    }
}

-(void)doNotifyThing:(NSNotification*)notify{
    NSString* pageid=[notifyDic objectForKey:Pageid];
    NSString* userName=[notifyDic objectForKey:Username];
    NSString* promotionid=[notifyDic objectForKey:Promotionid];
    //    NSString*locName=[[UserManageTool sharedInstance] GetUserName];
    
    //    if ([GlobalValue getGlobalValueInstance].userName==nil) {
    //        isCurrentAccount=[userName isEqualToString:locName];
    //    }else{
    isCurrentAccount=[userName isEqualToString:[GlobalValue getGlobalValueInstance].userName];
    //    }
    
    id object=[notify object];
    DebugLog(@"from  class &&&&&&%@\n\n\n %@",[[object class] description],notifyDic);
    if ([object isKindOfClass:[HomePage class]]) {
        if ([pageid isEqualToString:Tracking]){
            [self trackNofity:userName];
        }
    }else if ([object isKindOfClass:[MyStoreViewController class]]){
        if ([pageid isEqualToString:Orderdetail]) {
            [self oderNotify:userName];
        }
    }else if([object isKindOfClass:[TheStoreAppAppDelegate class]]){
        if ([pageid isEqualToString:Promotion]){
            [self cmsNofity:promotionid];
        }
    }else{
        if ([pageid isEqualToString:Orderdetail]) {
            [self oderNotify:userName];
        }else if ([pageid isEqualToString:Home]){
            [self couponNotify];
        }else if ([pageid isEqualToString:Tracking]){
            [self trackNofity:userName];
        }else if ([pageid isEqualToString:Promotion]){
            [self cmsNofity:promotionid];
        }
    }

}
-(void)cmsNofity:(NSString*)promotionId{
    [self toTabIndex:0];
    HomePage*homepage=(HomePage*)[SharedDelegate.tabBarController.viewControllers objectAtIndex:0];
    [homepage enterCelebrateView:[NSString stringWithFormat:@"http://m.yihaodian.com/mw/cms/%@/30/%@",promotionId,[GlobalValue getGlobalValueInstance].provinceId]];
    notifyDic=nil;
    [DoTracking doTrackingLaunch:2];
}
-(void)trackNofity:(NSString*)userName{
    if (isCurrentAccount) {
        [self toTabIndex:0];
        [SharedDelegate enterHomePageRoot];
        HomePage*homepage=(HomePage*)[SharedDelegate.tabBarController.viewControllers objectAtIndex:0];
        [homepage enterLogisticQuery];
    }else{
        [SharedDelegate logout];
        [SharedDelegate.tabBarController enterUserManageWithTag:11 NewUser:userName];
    }
    [DoTracking doTrackingLaunch:1];
    notifyDic=nil;
}
-(void)couponNotify{
    [self toTabIndex:0];
    [SharedDelegate enterHomePageRoot];
    notifyDic=nil;
    [DoTracking doTrackingLaunch:4];
}
-(void)oderNotify:(NSString*)userName{
    if (isCurrentAccount) {
        [self toTabIndex:3];
        MyStoreViewController*mystore=(MyStoreViewController*)[SharedDelegate.tabBarController.viewControllers objectAtIndex:3];
        [mystore enterOrder];
    }else{
        [SharedDelegate logout];
        [SharedDelegate.tabBarController enterUserManageWithTag:13 NewUser:userName];
    }
    notifyDic=nil;
    [DoTracking doTrackingLaunch:3];
}
-(void)toTabIndex:(int)pageIndex{
    TheStoreAppAppDelegate* appDelegate=(TheStoreAppAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.tabBarController.selectedIndex = pageIndex;
    [appDelegate.tabBarController selectItemAtIndex:pageIndex];
}
@end
