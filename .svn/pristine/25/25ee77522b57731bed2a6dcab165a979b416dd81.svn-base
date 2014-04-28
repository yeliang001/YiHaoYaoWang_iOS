//
//  OTSTabBarController.h
//  TheStoreApp
//
//  Created by yiming dong on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchProvince.h"
#import "UserManage.h"
#import "JiePang.h"
#import "GroupBuyProductDetail.h"
@class OTSContainerViewController;

@interface OTSTabBarController : UITabBarController
{
    NSMutableArray *imgArray;
    NSMutableArray *selImgArray;
    NSMutableArray *tabViews;
    
    NSInteger currentIndex;
    BOOL        isLoaded;
    UIImageView *m_CartAnimationView;
}

@property(retain,nonatomic)NSMutableArray *imgArray;
@property(retain,nonatomic)NSMutableArray *selImgArray;

-(void)selectItemAtIndex:(NSInteger)index;
-(void)showAddCartAnimationWithDelegate:(id)delegate;
-(void)enterUserManageWithTag:(int)tag;
-(void)enterUserManageWithTag:(int)tag NewUser:(NSString*)username;//进入登录页面并且从新填用户名
-(void)enterOnlinePayWithOrderId:(int)orderId;
-(void)enterFilterWithSearchResultVO:(SearchResultVO *)searchResultVO condition:(NSMutableDictionary *)condition fromTag:(int)fromTag;
-(void)enterJiePangWithProductVO:(ProductVO *)productVO isExclusive:(BOOL)isExclusive;
-(void)enterGrouponDetailWithAreaId:(NSNumber *)areaId products:(NSArray *)products currentIndex:(int)index fromTag:(int)fromTag isFullScreen:(BOOL)isFullScreen;

//tabbar上直接添加viewcontroller
-(void)addViewController:(OTSBaseViewController *)viewController withAnimation:(CAAnimation *)animation;
//删除直接添加的viewcontroller
-(void)removeViewControllerWithAnimation:(CAAnimation *)animation;
////弹出没有安装支付宝安全支付插件提示
//-(void)showNoAlixSafePay;
////弹出没有安装支付宝钱包提示
//-(void)showNoAlixWallet;
////取消下载则转到支付页面
//-(void) chooseThePayMethod:(NSNumber *) gateway;

@end
