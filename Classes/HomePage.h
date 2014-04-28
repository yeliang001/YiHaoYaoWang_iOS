//
//  HomePage.h
//  TheStoreApp
//
//  Created by jiming huang on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Page.h"
#import "ProductVO.h"
#import "ScanResult.h"
#import "ZBarSDK.h"
#import "MyOrder.h"
#import "MyFavorite.h"
#import "Search.h"
#import "ShareToMicroBlog.h"
#import "UserManageTool.h"
#import "OTSPageView.h"
#import "EGORefreshTableHeaderView.h"
#import "HomePageModelACell.h"


@class UserManage;
@class MyStoreViewController;
@class Search;
@class MyFavorite;
@class Scan;
@class AdvertisingPromotionVO;

@interface HomePage:OTSBaseViewController<UIActionSheetDelegate, UIWebViewDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,HomePageModelACellDelegate> {
    OTSPageView *m_PageView;
    
    NSString *m_NewProvinceStr;                             //选择的省份
    NSString *m_CurrentProvinceStr;                         //省份字符串，用于记录首页切换省份后选择的省份
    BOOL isChangingProvince;
    
    Page *hotTopFivePage;                                   //热销图
    BOOL isRefreshingHotPage;

    
    BOOL isAnimStop;
    
    NSMutableArray *m_AdArray;                              //广告列表
    NSString *m_UpdateTag;                                  //更新标记
    EGORefreshTableHeaderView *m_RefreshHeaderView;         //下拉刷新控件
    BOOL isRefreshingAd;
    NSMutableArray *modulesArray;                           //功能模块列表
//    UITableView* modelATable;                               //模块A的列表
@public
    NSDictionary *m_ProvinceDic;					        //省份字典
	UIScrollView *m_ScrollView;
    Search *m_Search;//搜索视图控制器
}
@property(retain,nonatomic)NSString * m_CurrentProvinceStr;
@property(retain,nonatomic)NSString * m_NewProvinceStr;
//ISSUE #4802 fix 
@property(retain,nonatomic)UITableView* modelATable; //模块A的列表

//药店参数 －－ Linpan






-(void)initHomePage;                                        //首页初始化
-(void)initData;

-(void)showAlertView:(NSString *) alertTitle alertMsg:(NSString *)alertMsg alertTag:(int)alertTag;	// 显示提示框
//关闭搜索相关界面
-(void)refreshAllForProvinceChanged;
-(void)enterSwitchProvince;
-(void)enterLogisticQuery;
-(void)initFunctionModules;
-(void)updateAdModules;
-(void)provinceChanged:(NSString *)provinceName;
-(void)appFirstLaunch;
-(void)appFirstLaunchFail;
-(void)appStartLaunch;
-(void)appWakeFromBackGround;
-(void)homePageSearchBarBecomeFirstResponder;
@end

