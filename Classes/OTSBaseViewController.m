//
//  OTSBaseViewController.m
//  TheStoreApp
//
//  Created by yiming dong on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSBaseViewController.h"
#import "OTSViewControllerManager.h"
#import "OTSLoadingView.h"
#import "OTSNaviAnimation.h"
#import "UIScrollView+OTS.h"
#import "TheStoreAppAppDelegate.h"
#import "OTSNavigationBar.h"
#import "MBProgressHUD.h"

@interface OTSBaseViewController ()

@end

@implementation OTSBaseViewController
@synthesize needQuitWhenLogOut, isFullScreen;
@synthesize loadingView = _loadingView;
@synthesize tag = _tag;


//为了适配iOS7
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000

- (void) viewDidLayoutSubviews
{
    if (ISIOS7)
    {
        CGRect viewBounds = self.view.bounds;
        CGFloat topBarOffset = self.topLayoutGuide.length;
        viewBounds.origin.y = topBarOffset * -1;
        self.view.bounds = viewBounds;
    }
}
#endif


-(void)handleUserLogOut
{
    if (needQuitWhenLogOut)     // 登出时退出，和账号相关的页面设置此属性为YES
    {
        [self removeSelf];
    }
}

-(void)pushVcViewToFront
{
    //issue #4778
    //*** Collection <CALayerArray: 0x1daa4720> was mutated while being enumerated.
    NSMutableArray  *controllerViews = [NSMutableArray array];
    NSArray *m_subviews  = [[self.view.subviews mutableCopy]autorelease];
    int i;
    for (i=0; i<m_subviews.count; i++) {
        UIView *subView = [OTSUtility safeObjectAtIndex:i inArray:m_subviews];
        if (subView!=nil && [[OTSViewControllerManager sharedInstance] controllerForView:subView]) {
            [controllerViews addObject:subView];
        }
    }
    
    for (i=0; i<controllerViews.count; i++) {
        UIView *subView = [OTSUtility safeObjectAtIndex:i inArray:controllerViews];
        if (subView != nil) {
            [self.view bringSubviewToFront:subView];
        }
    }
}




-(void)makeLoadingVisible:(id)aShowLoadingObj
{
    // ------ ONLINE CRASH FIX -------(By:dym)
    // <ISSUE #726>
    // Reason: -[NSPathStore2 showInView:]: unrecognized selector sent to instance 0xe64ec70
    if (![self.loadingView isKindOfClass:[OTSLoadingView class]]) {
        return;
    }
    // ------ ONLINE CRASH FIX END-------
    
    BOOL showLoading = [aShowLoadingObj boolValue];
    
    if (showLoading)
    {
        [self.loadingView showInView:self.view];
    }
    else
    {
        [self.loadingView blockView:self.view];
    }
    
    [self pushVcViewToFront];
}

-(void)hideLoadingView
{
    // ------ ONLINE CRASH FIX -------(By:dym)
    // <ISSUE #726>
    // Reason: -[NSPathStore2 showInView:]: unrecognized selector sent to instance 0xe64ec70
    if (![self.loadingView isKindOfClass:[OTSLoadingView class]]) {
        return;
    }
    // ------ ONLINE CRASH FIX END-------
    
    [self.loadingView hide];
}

-(void)showLoading:(BOOL)aWantShow
{
    [self performSelectorOnMainThread:@selector(makeLoadingVisible:) withObject:[NSNumber numberWithBool:aWantShow] waitUntilDone:YES];
}

-(void)showLoading
{
    [self showLoading:YES];
}

-(void)hideLoading
{
    [self performSelectorOnMainThread:@selector(hideLoadingView) withObject:nil waitUntilDone:YES];
}

-(void)showBarTip:(NSString*)aMessage
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = aMessage;
    hud.center = self.view.center;
	hud.margin = 14.f;
    hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:1];
}

-(void)showShortTip:(NSString*)aMessage
{
    [self showToastMessage:aMessage duration:1];
}

-(void)showLongTip:(NSString*)aMessage
{
    [self showToastMessage:aMessage duration:3];
}

- (void)showToastMessage:(NSString *) message duration:(int)duration
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = message;
    hud.square = YES;
    hud.center = self.view.center;
	hud.margin = 14.f;
    hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:duration];
}

//显示blockview
-(void)blockViewForRect:(CGRect)rect
{
    NSArray *array=[NSArray arrayWithObjects:[NSNumber numberWithInt:rect.origin.x], [NSNumber numberWithInt:rect.origin.y], [NSNumber numberWithInt:rect.size.width], [NSNumber numberWithInt:rect.size.height], nil];
    [self performSelectorOnMainThread:@selector(doBlockViewForRect:) withObject:array waitUntilDone:YES];
}

//主线程显示blockview
-(void)doBlockViewForRect:(NSArray *)array
{
    if (![self.loadingView isKindOfClass:[OTSLoadingView class]]) {
        return;
    }
    CGFloat xValue=[[OTSUtility safeObjectAtIndex:0 inArray:array] floatValue];
    CGFloat yValue=[[OTSUtility safeObjectAtIndex:1 inArray:array] floatValue];
    CGFloat widthValue=[[OTSUtility safeObjectAtIndex:2 inArray:array] floatValue];
    CGFloat heightValue=[[OTSUtility safeObjectAtIndex:3 inArray:array] floatValue];
    CGRect rect=CGRectMake(xValue, yValue, widthValue, heightValue);
    [self.loadingView blockView:self.view rect:rect];
    [self pushVcViewToFront];
}

#pragma mark - sms
-(void)sendSmsTo:(NSArray *)aRecipients
            body:(NSString*)aBody
        delegate:(id<MFMessageComposeViewControllerDelegate>)aDelegate
{
    
    if ([MFMessageComposeViewController canSendText])
    {   // 不是iphone提示用户
        
		MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
        controller.recipients = aRecipients;
		controller.body = aBody;
		controller.messageComposeDelegate = aDelegate;
		[self presentModalViewController:controller animated:YES];
	}
	else
    {
        [[[[OTSAlertView alloc] initWithTitle:@"" message:@"您的设备不支持此项功能,感谢您对1号药店的支持!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease] show];
    }
}

#pragma mark -
-(void)extraInit
{
    [[OTSViewControllerManager sharedInstance] registerController:self];
    
    self.loadingView = [[[OTSLoadingView alloc] init] autorelease];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserLogOut) name:OTS_USER_LOG_OUT object:nil];
}

-(id)init
{
    self = [super init];
    if (self)
    {
        //[self extraInit];     // since the designated initializer is initWithNibName:bundle:,do extra init there --- dym
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self extraInit];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self extraInit];
    }
    return self;
}

- (oneway void)release
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(release) withObject:nil waitUntilDone:NO];
    }
    else
    {
        [super release];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    OTS_SAFE_RELEASE(_loadingView);
    
    //[self removeSelf];
    
    [super dealloc];
}

#pragma mark - covinience method

-(void)setUniqueScrollToTopFor:(UIScrollView*)aScrollView
{
    if (aScrollView && [aScrollView isDescendantOfView:self.view])
    {
        [aScrollView ScrollMeToTopOnly];
    }
}

-(void)strechViewToBottom:(UIView*)aView
{
    if (aView && aView.superview)
    {
        CGRect newRc = aView.frame;
        newRc.size.height += aView.superview.frame.size.height - CGRectGetMaxY(newRc);
        aView.frame = newRc;
    }
}

#pragma mark -
-(void)setRootViewTag
{
    if (self.view)
    {
        self.view.tag = [self tagForRootView];
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loadingView = [[[OTSLoadingView alloc] init] autorelease];
    [self setRootViewTag];
    
    
    
    if (isFullScreen)
    {
        CGRect appBounds = [UIScreen mainScreen].applicationFrame;
        appBounds.origin.y = 0;
        self.view.frame = appBounds;
    }
    else
    {
        float sh = [UIScreen mainScreen].applicationFrame.size.height;
        float tabH = SharedDelegate.tabBarController.tabBar.frame.size.height;
        CGRect thisRc = self.view.frame;
        thisRc.size.height = sh - tabH;
        self.view.frame = thisRc;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [self setRootViewTag];
}

#pragma mark -

-(void)removeViewFromSuperView:(UIView*)aView
{
    [aView removeFromSuperview];
    [[OTSViewControllerManager sharedInstance] unregisterControllerWithView:aView];
}

-(void)removeSelfViewFromSuperView
{
    [self removeViewFromSuperView:self.view];
}

-(void)setView:(UIView *)view
{
    DebugLog(@"class name:%@", [[self class] description]);
    [super setView:view];
    
    if (view)
    {
        if (view.tag == 0)
        {
            view.tag = [self tagForRootView];
        }
    }
}

-(void)removeAllMyVC
{
    for (UIView* sub in self.view.subviews)
    {
        if (sub && sub.tag > KOTSVCTag_BEGIN && sub.tag < KOTSVCTag_END)
        {
            [[[OTSViewControllerManager sharedInstance] controllerForView:sub] removeSelf];
        }
    }
}

-(void)removeAllMyVcExceptVcClass:(Class)aExceptedVcClass
{
    for (UIView* sub in self.view.subviews)
    {
        if (sub && sub.tag > KOTSVCTag_BEGIN && sub.tag < KOTSVCTag_END)
        {
            OTSBaseViewController* vc = [[OTSViewControllerManager sharedInstance] controllerForView:sub];
            if (![vc isKindOfClass:aExceptedVcClass])
            {
                [vc removeSelf];
            }
        }
    }
}


-(void)pushVC:(OTSBaseViewController*)aViewController animated:(BOOL)aIsAnimated fullScreen:(BOOL)aFullScreen
{
    aViewController.isFullScreen = aFullScreen;
    
    if (aViewController && aViewController.view)
    {
        if (aIsAnimated)
        {
            [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:OTS_VIEW_ANIM_KEY];
        }
        
        [self viewWillDisappear:aIsAnimated];
        [aViewController viewWillAppear:aIsAnimated];
        
        [self.view addSubview:aViewController.view];
        
        [aViewController viewDidAppear:aIsAnimated];
        [self viewDidDisappear:aIsAnimated];
    }
}

-(void)pushVC:(OTSBaseViewController*)aViewController animated:(BOOL)aIsAnimated
{
    [self pushVC:aViewController animated:aIsAnimated fullScreen:NO];
}


-(void)popSelfAnimated:(BOOL)aIsAnimated
{
    if (aIsAnimated)
    {
        [self.view.superview.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:OTS_VIEW_ANIM_KEY];
    }
    
    OTSBaseViewController* superVC = nil;
    
    UIView *superView = self.view.superview;
    if (superView)
    {
        superVC = [[OTSViewControllerManager sharedInstance] controllerForView:superView];
    }
    
    [self viewWillDisappear:aIsAnimated];
    [superVC viewWillAppear:aIsAnimated];
    
    [self removeSelf];
    
    [superVC viewDidAppear:aIsAnimated];
    [self viewDidDisappear:aIsAnimated];
}


-(void)removeSelf
{
    DebugLog(@"[%@, 0x%x] removeSelf", [self class], (int)self);
    
    [self removeAllMyVC];
    
    [self removeSelfViewFromSuperView];
}


-(void)removeSubControllerClass:(Class)aViewControllerClass
{
    DebugLog(@"=====>>removeSubControllerClass start!");
    
    int theTag = [OTSBaseViewController tagForRootViewByClass:aViewControllerClass];
    
    DebugLog(@"theTag:%d class:%@", theTag, [aViewControllerClass description]);
    //    for (UIView* v in self.view.subviews)
    //    {
    //        DebugLog(@"sub view tag:%d class:%@", v.tag, [[v class] description]);
    //    }
    
    UIView* theView = [self.view viewWithTag:theTag];
    
    if (theView && theView != self.view)
    {
        OTSBaseViewController* ctrl = [[OTSViewControllerManager sharedInstance] controllerForView:theView];
        if (ctrl)
        {
            [ctrl removeSelf];
        }
    }
    DebugLog(@"=====>>removeSubControllerClass finished!");
}

#pragma mark -
-(int)tagForRootView
{
    return [OTSBaseViewController tagForRootViewByClass:[self class]];
}

+(int)tagForRootViewByClass:(Class)aViewControllerClass
{
    NSString* classNameStr = [aViewControllerClass description];
    EOTSVCTag retTag = KOTSVCTag_BEGIN;
    
    if ([classNameStr isEqualToString:@"AccountBalance"])
    {
        retTag = KOTSVCTag_AccountBalance;
    }
    
    else if ([classNameStr isEqualToString:@"Activity"])
    {
        retTag = KOTSVCTag_Activity;
    }
    
    else if ([classNameStr isEqualToString:@"AdvertisementDetail"])
    {
        retTag = KOTSVCTag_AdvertisementDetail;
    }
    
    else if ([classNameStr isEqualToString:@"AdvertisementList"])
    {
        retTag = KOTSVCTag_AdvertisementList;
    }
    
    else if ([classNameStr isEqualToString:@"ASIAutorotatingViewController"])
    {
        retTag = KOTSVCTag_ASIAutorotatingViewController;
    }
    
    else if ([classNameStr isEqualToString:@"PhoneCartViewController"])
    {
        retTag = KOTSVCTag_Cart;
    }
    
    else if ([classNameStr isEqualToString:@"CategoryDetail"])
    {
        retTag = KOTSVCTag_CategoryDetail;
    }
    
    else if ([classNameStr isEqualToString:@"CheckOrder"])
    {
        retTag = KOTSVCTag_CheckOrder;
    }
    
    else if ([classNameStr isEqualToString:@"EditGoodsReceiver"])
    {
        retTag = KOTSVCTag_EditGoodsReceiver;
    }
    
    else if ([classNameStr isEqualToString:@"Filter"])
    {
        retTag = KOTSVCTag_Filter;
    }
    
    else if ([classNameStr isEqualToString:@"Gift"])
    {
        retTag = KOTSVCTag_Gift;
    }
    
    else if ([classNameStr isEqualToString:@"GoodReceiver"])
    {
        retTag = KOTSVCTag_GoodReceiver;
    }
    
    else if ([classNameStr isEqualToString:@"GroupBuyCheckOrder"])
    {
        retTag = KOTSVCTag_GroupBuyCheckOrder;
    }
    
    else if ([classNameStr isEqualToString:@"GroupBuyGuide"])
    {
        retTag = KOTSVCTag_GroupBuyGuide;
    }
    
    else if ([classNameStr isEqualToString:@"GroupBuyHomePage"])
    {
        retTag = KOTSVCTag_GroupBuyHomePage;
    }
    
    else if ([classNameStr isEqualToString:@"GroupBuyMyGroupBuy"])
    {
        retTag = KOTSVCTag_GroupBuyMyGroupBuy;
    }
    
    else if ([classNameStr isEqualToString:@"GroupBuyOrderDetail"])
    {
        retTag = KOTSVCTag_GroupBuyOrderDetail;
    }
    
    else if ([classNameStr isEqualToString:@"GroupBuyProductDetail"])
    {
        retTag = KOTSVCTag_GroupBuyProductDetail;
    }
    
    else if ([classNameStr isEqualToString:@"GroupBuyTabBar"])
    {
        retTag = KOTSVCTag_GroupBuyTabBar;
    }
    
    else if ([classNameStr isEqualToString:@"HomePage"])
    {
        retTag = KOTSVCTag_HomePage;
    }
    
    else if ([classNameStr isEqualToString:@"Invoice"])
    {
        retTag = KOTSVCTag_Invoice;
    }
    
    else if ([classNameStr isEqualToString:@"JiePang"])
    {
        retTag = KOTSVCTag_JiePang;
    }
    
    else if ([classNameStr isEqualToString:@"ManualInput"])
    {
        retTag = KOTSVCTag_ManualInput;
    }
    
    else if ([classNameStr isEqualToString:@"More"])
    {
        retTag = KOTSVCTag_More;
    }
    
    else if ([classNameStr isEqualToString:@"MyFavorite"])
    {
        retTag = KOTSVCTag_MyFavorite;
    }
    
    else if ([classNameStr isEqualToString:@"MyBrowse"])
    {
        retTag = KOTSVCTag_MyBrowse;
    }
    
    else if ([classNameStr isEqualToString:@"MyMessage"])
    {
        retTag = KOTSVCTag_MyMessage;
    }
    
    else if ([classNameStr isEqualToString:@"MyOrder"])
    {
        retTag = KOTSVCTag_MyOrder;
    }
    
    else if ([classNameStr isEqualToString:@"MyStoreViewController"])
    {
        retTag = KOTSVCTag_MyStoreViewController;
    }
    
    else if ([classNameStr isEqualToString:@"NoteViewController"])
    {
        retTag = KOTSVCTag_NoteViewController;
    }
    
    else if ([classNameStr isEqualToString:@"OnlinePay"])
    {
        retTag = KOTSVCTag_OnlinePay;
    }
    
    else if ([classNameStr isEqualToString:@"OrderDetail"])
    {
        retTag = KOTSVCTag_OrderDetail;
    }
    
    else if ([classNameStr isEqualToString:@"OrderDone"])
    {
        retTag = KOTSVCTag_OrderDone;
    }
    
    else if ([classNameStr isEqualToString:@"OTSRockBuyHelpVC"])
    {
        retTag = KOTSVCTag_OTSRockBuyHelpVC;
    }
    
    else if ([classNameStr isEqualToString:@"OTSRockBuyVC"])
    {
        retTag = KOTSVCTag_OTSRockBuyVC;
    }
    
    else if ([classNameStr isEqualToString:@"OTSSecurityValidationVC"])
    {
        retTag = KOTSVCTag_OTSSecurityValidationVC;
    }
    
    else if ([classNameStr isEqualToString:@"PackageTracking"])
    {
        retTag = KOTSVCTag_PackageTracking;
    }
    
    else if ([classNameStr isEqualToString:@"ProductDetail"])
    {
        retTag = KOTSVCTag_ProductDetail;
    }
    
    else if ([classNameStr isEqualToString:@"PromotionDetail"])
    {
        retTag = KOTSVCTag_PromotionDetail;
    }
    
    else if ([classNameStr isEqualToString:@"Scan"])
    {
        retTag = KOTSVCTag_Scan;
    }
    
    else if ([classNameStr isEqualToString:@"ScanResult"])
    {
        retTag = KOTSVCTag_ScanResult;
    }
    
    else if ([classNameStr isEqualToString:@"Search"])
    {
        retTag = KOTSVCTag_Search;
    }
    
    else if ([classNameStr isEqualToString:@"ShareActionSheet"])
    {
        retTag = KOTSVCTag_ShareActionSheet;
    }
    
    else if ([classNameStr isEqualToString:@"ShareOrder"])
    {
        retTag = KOTSVCTag_ShareOrder;
    }
    
    else if ([classNameStr isEqualToString:@"ShoppingList"])
    {
        retTag = KOTSVCTag_ShoppingList;
    }
    
    else if ([classNameStr isEqualToString:@"SwitchProvince"])
    {
        retTag = KOTSVCTag_SwitchProvince;
    }
    
    else if ([classNameStr isEqualToString:@"UseHelp"])
    {
        retTag = KOTSVCTag_UseHelp;
    }
    
    else if ([classNameStr isEqualToString:@"UserManage"])
    {
        retTag = KOTSVCTag_UserManage;
    }
    
    else if ([classNameStr isEqualToString:@"ZBarHelpController"])
    {
        retTag = KOTSVCTag_ZBarHelpController;
    }
    
    else if ([classNameStr isEqualToString:@"ZBarReaderViewController"])
    {
        retTag = KOTSVCTag_ZBarReaderViewController;
    }
    
    else if ([classNameStr isEqualToString:@"OTSContainerViewController"])
    {
        retTag = KOTSVCTag_OTSContainerViewController;
    }
    
	else if ([classNameStr isEqualToString:@"BalanceDetailedUse"])
	{
		retTag = KOTSVCTag_BalanceDetailedUse;
	}
    
    else if ([classNameStr isEqualToString:@"OTSOrderMfVC"])
	{
		retTag = KOTSVCTag_OTSOrderMfVC;
	}
    
    else if ([classNameStr isEqualToString:@"OTSMaterialFLowVC"])
	{
		retTag = KOTSVCTag_OTSMaterialFLowVC;
	}
    
    else if ([classNameStr isEqualToString:@"MyCoupon"])
	{
		retTag = KOTSVCTag_OTSMyCoupon;
	}
    
    else if ([classNameStr isEqualToString:@"UseCoupon"])
	{
		retTag = KOTSVCTag_OTSUseCoupon;
	}
    
    else if ([classNameStr isEqualToString:@"CouponRule"])
	{
		retTag = KOTSVCTag_OTSCouponRule;
	}
    
    else if ([classNameStr isEqualToString:@"OTSOrderSubmitOKVC"])
	{
		retTag = KOTSVCTag_OTSOrderSubmitOKVC;
	}
    
    else if ([classNameStr isEqualToString:@"CouponSecValidate"])
    {
        retTag = KOTSVCTAG_OTSCouponSecValidate;
    }
    
    else if ([classNameStr isEqualToString:@"CategoryViewController"])
    {
        retTag = KOTSVCTAG_OTSCategoryViewController;
    }
    
    else if ([classNameStr isEqualToString:@"CategoryProductsViewController"])
    {
        retTag = KOTSVCTAG_OTSCategoryProductsViewController;
    }
    
    else if ([classNameStr isEqualToString:@"SearchResult"])
    {
        retTag = KOTSVCTAG_SearchResult;
    }
    else if ([classNameStr isEqualToString:@"BindViewController"])
    {
        retTag = KOTSVCTAG_BindViewController;
    }
    else if ([classNameStr isEqualToString:@"OTSProductDetail"])
    {
        retTag = KOTSVCTAG_OTSProductDetail;
    }
    else if ([classNameStr isEqualToString:@"OTSNNPiecesVC"])
    {
        retTag = KOTSVCTAG_OTSNNPiecesVC;
    }
    
    // 1起摇V2
    else if ([classNameStr isEqualToString:@"OTSPhoneWeRockMainVC"])
    {
        retTag = KOTSVCTAG_OTSPhoneWeRockMainVC;
    }
    
    else if ([classNameStr isEqualToString:@"OTSPhoneWeRockInventoryVC"])
    {
        retTag = KOTSVCTAG_OTSPhoneWeRockInventoryVC;
    }
    
    else if ([classNameStr isEqualToString:@"OTSPhoneWeRockRuleVC"])
    {
        retTag = KOTSVCTAG_OTSPhoneWeRockRuleVC;
    }
    
    else if ([classNameStr isEqualToString:@"OTSPhoneWeRockGameVC"])
    {
        retTag = KOTSVCTAG_OTSPhoneWeRockGameVC;
    }
    
    else if ([classNameStr isEqualToString:@"GameViewController"])
    {
        retTag = KOTSVCTAG_GameViewController;
    }
    
    else if ([classNameStr isEqualToString:@"GameRecViewController"])
    {
        retTag = KOTSVCTAG_GameRecViewController;
    }
    
    else if ([classNameStr isEqualToString:@"GameFinishViewController"])
    {
        retTag = KOTSVCTAG_GameFinishViewController;
    }
    
    
    return retTag;
}

@end
