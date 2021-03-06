//
//  OTSTabBarController.m
//  TheStoreApp
//
//  Created by yiming dong on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define UNIONPAY1MALL 203

//#define SAFEPAY       123   //快捷支付
//#define ALIPAY        124   //支付钱包    

#import "OTSTabBarController.h"
#import <QuartzCore/QuartzCore.h>
#import "OTSNaviAnimation.h"
#import "GlobalValue.h"
#import "OTSNavigationController.h"
#import "OTSLoadingView.h"
#import "UserManage.h"
#import "OTSContainerViewController.h"
#import "UIView+VCManage.h"
#import "TheStoreAppAppDelegate.h"

@interface OTSTabBarController ()

@end

@implementation OTSTabBarController
@synthesize imgArray;
@synthesize selImgArray;

-(UINavigationController*)navigationControllerWithRootControllerByClassName:(NSString*)aClassName
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
    
    if ([theClass isSubclassOfClass:[UIViewController class]]) 
    {
        UIViewController* rootVC = [[[theClass alloc] initWithNibName:aClassName bundle:nil] autorelease];
        OTSNavigationController* theNC = [[[OTSNavigationController alloc] initWithRootViewController:rootVC] autorelease];
        return theNC;
    }
    
    return nil;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    if (isLoaded)
    {
        return;
    }
    
    isLoaded = YES;
        
    int vcCount = [self.viewControllers count];
    
    imgArray=[[NSMutableArray alloc] initWithCapacity:vcCount];
    selImgArray=[[NSMutableArray alloc] initWithCapacity:vcCount];
    tabViews = [[NSMutableArray alloc] initWithCapacity:vcCount];
    
    [imgArray addObject:[UIImage imageNamed:@"tabbar_homepage_unsel.png"]];
    [imgArray addObject:[UIImage imageNamed:@"tabbar_category_unsel.png"]];
    [imgArray addObject:[UIImage imageNamed:@"tabbar_cart_unsel.png"]];
    [imgArray addObject:[UIImage imageNamed:@"tabbar_store_unsel.png"]];
    [imgArray addObject:[UIImage imageNamed:@"tabbar_more_unsel.png"]];
    
    [selImgArray addObject:[UIImage imageNamed:@"tabbar_homepage_sel.png"]];
    [selImgArray addObject:[UIImage imageNamed:@"tabbar_category_sel.png"]];
    [selImgArray addObject:[UIImage imageNamed:@"tabbar_cart_sel.png"]];
    [selImgArray addObject:[UIImage imageNamed:@"tabbar_store_sel.png"]];
    [selImgArray addObject:[UIImage imageNamed:@"tabbar_more_sel.png"]];
    
    m_CartAnimationView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 50)];
    [m_CartAnimationView setImage:[UIImage imageNamed:@"cart_animation.png"]];

    //为了适配iOS7
//    int startIndex;
//    if (kCFCoreFoundationVersionNumber>=kCFCoreFoundationVersionNumber_iPhoneOS_5_0 )//&& !ISIOS7)
//    { 
//        startIndex=1;
//    }
//    else
//    {
//        startIndex=0;
//    }
    for (int i=0; i<vcCount; i++)
    {
        UIView *subView=[self.tabBar.subviews objectAtIndex:ISIOS7? 0+i : 1+i];  //可能iOS7 之后是tabbar 中的item是在subviews里面从0开始  之前从1开始
        UIImageView *imgView=[[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 50)] autorelease];
        [imgView setImage:[imgArray objectAtIndex:i]];
        [subView addSubview:imgView];
        [tabViews addObject:imgView];
        
        if (i==2)
        {
            [imgView addSubview:m_CartAnimationView];
            [m_CartAnimationView setAlpha:0.0f];
        }
    }
    
    currentIndex = 0;
    
    [[tabViews objectAtIndex:currentIndex] setImage:[selImgArray objectAtIndex:0]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartNumNull) name:@"CarNumNullNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartNumNotNull) name:@"CarNumNotNullNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartNumNotNullLong) name:@"CarNumNotNullLongNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSubView:) name:@"AddSubViewForTabBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSwitchProvince:) name:@"AddSwitchProvinceForTabBar" object:nil];
    //将tabBar的玻璃遮罩变透明
    IF_IOS5_OR_GREATER([[self tabBar] setSelectionIndicatorImage:[UIImage imageNamed:@"transparent.png"]];)
}

-(UIImageView*)customViewForIndex:(NSUInteger)aIndex
{
    return (UIImageView*)[tabViews objectAtIndex:aIndex];
}

-(void)selectItemAtIndex:(NSInteger)index
{
    if (currentIndex == index) 
    {
        return;
    }
    
    [[self customViewForIndex:currentIndex] setImage:[imgArray objectAtIndex:currentIndex]];
    [[self customViewForIndex:index] setImage:[selImgArray objectAtIndex:index]];
    
    currentIndex = index;
}

-(void)cartNumNull
{
    
}

-(void)cartNumNotNull
{
}

-(void)cartNumNotNullLong
{
}

-(void)naviToView:(UIView*)aView
{
    if (aView)
    {
        CGRect rect = [aView frame];
        rect.origin.y = 20.0;
        rect.size.height = self.view.frame.size.height;
        [aView setFrame:rect];
        
        [self.view.layer addAnimation:[OTSNaviAnimation animationMoveInFromTop] forKey:@"Reveal"];
        [self.view addSubview:aView];
    }
}

-(void)addSubView:(NSNotification *)notification
{
    UIView *view=[notification object];
    [self naviToView:view];
}

-(void)addSwitchProvince:(NSNotification *)notification
{
    
    [self performInThreadBlock:^(){
        [SharedDelegate setM_GpsAlertDisAble:YES];
    } completionInMainBlock:^(){
        SwitchProvince *switchProvince=[[[SwitchProvince alloc] initWithNibName:@"SwitchProvince" bundle:nil] autorelease];
        [self naviToView:switchProvince.view];
    }];
}

-(void)enterUserManageWithTag:(int)tag NewUser:(NSString*)username{
    UserManage *userManage=[[[UserManage alloc] initWithNibName:@"UserManage" bundle:nil] autorelease];
    [userManage setLoginview];
    [userManage setLoginviewUserName:username];
    [userManage mysetCallTag:[NSNumber numberWithInt:tag]];
    if (tag==kEnterLoginFromGrouponDetail || tag==kEnterLoginFromWeRock) {
        [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
    } else {
        [self.view.layer addAnimation:[OTSNaviAnimation animationMoveInFromTop] forKey:@"Reveal"];
    }
    [userManage.view setFrame:CGRectMake(0, ScreenHeight-ApplicationHeight, ApplicationWidth, ApplicationHeight)];
    [self.view addSubview:userManage.view];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AccountAutoRetrieve" object:nil];

}
//进入登入页面
-(void)enterUserManageWithTag:(int)tag
{
    
    UserManage *userManage = [[[UserManage alloc] initWithNibName:@"UserManage" bundle:nil] autorelease];

    [userManage setLoginview];
    [userManage mysetCallTag:[NSNumber numberWithInt:tag]];
    if (tag==kEnterLoginFromGrouponDetail || tag==kEnterLoginFromWeRock)
    {
        [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
    } else
    {
        [self.view.layer addAnimation:[OTSNaviAnimation animationMoveInFromTop] forKey:@"Reveal"];
    }
    [userManage.view setFrame:CGRectMake(0, ScreenHeight-ApplicationHeight, ApplicationWidth, ApplicationHeight)];
    [self.view addSubview:userManage.view];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AccountAutoRetrieve" object:nil];
    
}

-(void)enterOnlinePayWithOrderId:(int)orderId
{
    OnlinePay *onlinePay=[[[OnlinePay alloc] initWithNibName:@"OnlinePay" bundle:nil] autorelease];
    onlinePay.orderId=[NSNumber numberWithInt:orderId];
    onlinePay.isFromWap=YES;
    onlinePay.isFromMyGroupon=YES;
    onlinePay.isFromOrder=YES;
    onlinePay.isFullScreen=YES;
    onlinePay.gatewayId=[NSNumber numberWithInt:UNIONPAY1MALL];
    [self naviToView:onlinePay.view];
}

//-(void)showNoAlixSafePay
//{
//    UIAlertView *alert=[[OTSAlertView alloc] initWithTitle:@"提示" message:@"您尚未安装支付宝客户端，或版本过低。1、建议您点击重选，选择支付宝网页支付。2、下载或更新支付宝客户端（耗时较长）。" delegate:self cancelButtonTitle:@"安装" otherButtonTitles:@"重选", nil];
//    [alert setTag:SAFEPAY];
//	[alert show];
//	[alert release];
//}

//-(void)showNoAlixWallet
//{
//    UIAlertView *alert=[[OTSAlertView alloc] initWithTitle:@"提示" message:@"您尚未安装支付宝客户端，或版本过低。1、建议您点击重选，选择支付宝网页支付。2、下载或更新支付宝客户端（耗时较长）。" delegate:self cancelButtonTitle:@"安装" otherButtonTitles:@"重选", nil];
//    [alert setTag:ALIPAY];
//	[alert show];
//	[alert release];
//}

//-(void) chooseThePayMethod:(NSNumber *) gateway;
//{
//    [SharedDelegate.tabBarController removeViewControllerWithAnimation:nil];
//    MyStoreViewController * controller = (MyStoreViewController *)[SharedDelegate.tabBarController.viewControllers objectAtIndex:3];
//    [controller enterChoosePayMethod:gateway];
//}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//	
//        switch ([alertView tag]) {
//            case SAFEPAY:
//                if (buttonIndex==1) {
//                    [self chooseThePayMethod:[NSNumber numberWithInt:421]];
//                    
//                } else if (buttonIndex==0) {
//                    NSString * URLString = @"http://itunes.apple.com/cn/app/id535715926?mt=8";
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
//                }
//                break;
//            case ALIPAY:
//                if (buttonIndex==1) {
//                    [self chooseThePayMethod:[NSNumber numberWithInt:421]];
//                } else if (buttonIndex==0) {
//                    NSString * URLString = @"http://itunes.apple.com/cn/app/id333206289?mt=8";
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
//                }
//                break;
//            default:
//                break;
//        }
//}

//-(void)enterFilterWithSearchResultVO:(SearchResultVO *)searchResultVO condition:(NSMutableDictionary *)condition fromTag:(int)fromTag
//{
//    Filter *filter=[[[Filter alloc] initWithNibName:@"Filter" bundle:nil] autorelease];
//    [filter setM_SearchResultVO:searchResultVO];
//    [filter setM_SelectedConditions:condition];
//    [filter setM_FromTag:fromTag];
//    [self naviToView:filter.view];
//}

//主线程加载街旁
-(void)enterJiePangWithProductVO:(ProductVO *)productVO isExclusive:(BOOL)isExclusive
{
    JiePang *jiePang=[[[JiePang alloc] initWithNibName:@"JiePang" bundle:nil] autorelease];
    [jiePang setSelectedProduct:productVO];
    [jiePang setIsExclusive:isExclusive];
    [self naviToView:jiePang.view];
}

-(void)enterGrouponDetailWithAreaId:(NSNumber *)areaId products:(NSArray *)products currentIndex:(int)index fromTag:(int)fromTag isFullScreen:(BOOL)isFullScreen
{
    GroupBuyProductDetail *grouponDetail=[[[GroupBuyProductDetail alloc] initWithNibName:@"GroupBuyProductDetail" bundle:nil] autorelease];
    [grouponDetail setM_AreaId:areaId];
    [grouponDetail setM_Products:products];
    [grouponDetail setM_CurrentIndex:index];
    [grouponDetail setM_FromTag:fromTag];
    [grouponDetail setIsFullScreen:YES];
    [self addViewController:grouponDetail withAnimation:[OTSNaviAnimation animationPushFromRight]];
}

#pragma mark - 购物车动画
-(void)showAddCartAnimationWithDelegate:(id)delegate
{
    [UIView animateWithDuration:0.75f animations:^{[m_CartAnimationView setAlpha:1.0f];} completion:^(BOOL finished){
        [UIView animateWithDuration:0.25f animations:^{[m_CartAnimationView setAlpha:0.0f];} completion:^(BOOL finished){
            [UIView animateWithDuration:0.75f animations:^{[m_CartAnimationView setAlpha:1.0f];} completion:^(BOOL finished){
                [UIView animateWithDuration:0.25f animations:^{[m_CartAnimationView setAlpha:0.0f];} completion:^(BOOL finished){
                    if ([delegate respondsToSelector:@selector(animationFinished)]) {
                        [delegate performSelector:@selector(animationFinished) withObject:nil];
                    }
                }];
            }];
        }];
    }];
}

#pragma mark - tabbar上view controller
//tabbar上直接添加viewcontroller
-(void)addViewController:(OTSBaseViewController *)viewController withAnimation:(CAAnimation *)animation
{
    [self.view removeSubControllerClass:[OTSContainerViewController class]];
    OTSContainerViewController *containerViewController=[[[OTSContainerViewController alloc] init] autorelease];
    [containerViewController.view setFrame:[UIScreen mainScreen].applicationFrame];
    [containerViewController.view addSubview:viewController.view];
    
    [self.view.layer addAnimation:animation forKey:@"Reveal"];
    [self.view addSubview:containerViewController.view];
}

//删除直接添加的viewcontroller
-(void)removeViewControllerWithAnimation:(CAAnimation *)animation
{
    [self.view.layer addAnimation:animation forKey:@"Reveal"];
    [self.view removeSubControllerClass:[OTSContainerViewController class]];
}

#pragma mark -
-(void)cleanUp
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (imgArray!=nil) {
        [imgArray release];
        imgArray=nil;
    }
    if (selImgArray!=nil) {
        [selImgArray release];
        selImgArray=nil;
    }
    if (tabViews!=nil) {
        [tabViews release];
        tabViews=nil;
    }
    if (m_CartAnimationView!=nil) {
        [m_CartAnimationView release];
        m_CartAnimationView=nil;
    }
}

-(void)viewDidUnload
{
    [self cleanUp];
    
    [super viewDidUnload];
}

- (void)dealloc 
{
    [self cleanUp];
    
    [super dealloc];
}

@end
