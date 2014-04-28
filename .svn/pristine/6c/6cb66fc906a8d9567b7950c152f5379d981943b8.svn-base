//
//  OTSBaseViewController.h
//  TheStoreApp
//
//  Created by yiming dong on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define ApplicationHeight [UIScreen mainScreen].applicationFrame.size.height
#define ApplicationWidth [UIScreen mainScreen].applicationFrame.size.width

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@class OTSLoadingView;
@class OTSNavigationBar;

@interface OTSBaseViewController : UIViewController

@property BOOL needQuitWhenLogOut;
@property(nonatomic)BOOL            isFullScreen;   // 是否全屏模式
@property(nonatomic, retain)OTSLoadingView  *loadingView;
@property(nonatomic, assign)int             tag; // 替代view的tag



-(void)removeSubControllerClass:(Class)aViewControllerClass;  // 将指定vc类的view从自身view移除，并反注册该类
-(void)removeSelf;                              // 最终的remove方法，递归移除自身vc
-(void)removeAllMyVC;                           // 把自身view上的所有vc移除，显示自己的页面
-(void)removeAllMyVcExceptVcClass:(Class)aExceptedVcClass;

-(void)pushVC:(OTSBaseViewController*)aViewController animated:(BOOL)aIsAnimated;
-(void)pushVC:(OTSBaseViewController*)aViewController animated:(BOOL)aIsAnimated fullScreen:(BOOL)aFullScreen;
-(void)popSelfAnimated:(BOOL)aIsAnimated;

+(int)tagForRootViewByClass:(Class)aViewControllerClass;
-(int)tagForRootView;

-(void)showLoading:(BOOL)aWantShow;
-(void)showLoading;
-(void)hideLoading;
-(void)blockViewForRect:(CGRect)rect;

-(void)showBarTip:(NSString*)aMessage;
-(void)showShortTip:(NSString*)aMessage;
-(void)showLongTip:(NSString*)aMessage;

-(void)sendSmsTo:(NSArray *)aRecipients
            body:(NSString*)aBody
        delegate:(id<MFMessageComposeViewControllerDelegate>)aDelegate;


-(void)setUniqueScrollToTopFor:(UIScrollView*)aScrollView;
-(void)strechViewToBottom:(UIView*)aView;
@end

// View Controller View Tag
typedef enum _EOTSVCTag
{
    KOTSVCTag_BEGIN = 100000    // 开始标志
    
    , KOTSVCTag_AccountBalance
    , KOTSVCTag_Activity
    , KOTSVCTag_AdvertisementDetail
    , KOTSVCTag_AdvertisementList
    , KOTSVCTag_ASIAutorotatingViewController
    , KOTSVCTag_Cart
    , KOTSVCTag_CategoryDetail
    , KOTSVCTag_CheckOrder
    , KOTSVCTag_EditGoodsReceiver
    , KOTSVCTag_Filter                          // 10
    , KOTSVCTag_Gift
    , KOTSVCTag_GoodReceiver
    , KOTSVCTag_GroupBuyCheckOrder
    , KOTSVCTag_GroupBuyGuide
    , KOTSVCTag_GroupBuyHomePage
    , KOTSVCTag_GroupBuyMyGroupBuy
    , KOTSVCTag_GroupBuyOrderDetail
    , KOTSVCTag_GroupBuyProductDetail
    , KOTSVCTag_GroupBuyTabBar
    , KOTSVCTag_HomePage                        // 20
    , KOTSVCTag_Invoice
    , KOTSVCTag_JiePang
    , KOTSVCTag_ManualInput
    , KOTSVCTag_More
    , KOTSVCTag_MyFavorite
    , KOTSVCTag_MyBrowse
    , KOTSVCTag_MyMessage
    , KOTSVCTag_MyOrder
    , KOTSVCTag_MyStoreViewController
    , KOTSVCTag_NoteViewController
    , KOTSVCTag_OnlinePay                       // 30
    , KOTSVCTag_OrderDetail
    , KOTSVCTag_OrderDone
    , KOTSVCTag_OTSRockBuyHelpVC
    , KOTSVCTag_OTSRockBuyVC
    , KOTSVCTag_OTSSecurityValidationVC
    , KOTSVCTag_PackageTracking
    , KOTSVCTag_ProductDetail
    , KOTSVCTag_PromotionDetail
    , KOTSVCTag_Scan
    , KOTSVCTag_ScanResult                      // 40
    , KOTSVCTag_Search
    , KOTSVCTag_ShareActionSheet
    , KOTSVCTag_ShareOrder
    , KOTSVCTag_ShoppingList
    , KOTSVCTag_SwitchProvince
    , KOTSVCTag_UseHelp
    , KOTSVCTag_UserManage
    , KOTSVCTag_ZBarHelpController
    , KOTSVCTag_ZBarReaderViewController
    , KOTSVCTag_OTSContainerViewController
	, KOTSVCTag_BalanceDetailedUse
    , KOTSVCTag_OTSOrderMfVC
    , KOTSVCTag_OTSMaterialFLowVC
    , KOTSVCTag_OTSMyCoupon
    , KOTSVCTag_OTSUseCoupon
    , KOTSVCTag_OTSCouponRule
    , KOTSVCTag_OTSOrderSubmitOKVC
    , KOTSVCTAG_OTSCouponSecValidate
    , KOTSVCTAG_OTSCategoryViewController
    , KOTSVCTAG_OTSCategoryProductsViewController
    , KOTSVCTAG_SearchResult
    , KOTSVCTAG_BindViewController
    , KOTSVCTAG_OTSProductDetail
    , KOTSVCTAG_OTSNNPiecesVC
    // 1起摇V2
    , KOTSVCTAG_OTSPhoneWeRockMainVC
    , KOTSVCTAG_OTSPhoneWeRockInventoryVC
    , KOTSVCTAG_OTSPhoneWeRockRuleVC
    , KOTSVCTAG_OTSPhoneWeRockGameVC
    //游戏
    ,KOTSVCTAG_GameViewController
    ,KOTSVCTAG_GameRecViewController
    ,KOTSVCTAG_GameFinishViewController
    , KOTSVCTag_END         // 结束标志
}EOTSVCTag;
