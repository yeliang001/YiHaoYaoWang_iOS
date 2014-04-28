//
//  OTSGrouponHomePage.h
//  yhd
//
//  Created by jiming huang on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CartView.h"
#import "EGORefreshTableHeaderView.h"
#import "WEPopoverController.h"
#import "OTSPopViewController.h"

@class TopView;

@interface OTSGrouponHomePage : BaseViewController<CartViewDelegate,UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,OTSPopViewControllerDelegate> {
    TopView *m_TopView;
    UIScrollView *m_CategoryScrollView;
    UITableView *m_GrouponTableView;
    UIView *m_UnsupportView;
    WEPopoverController *m_WEPopoverController;
    UIButton *m_SortButton;
    
    NSNumber *m_AreaId;
    int m_CurrentCategoryIndex;//当前分类列表索引
    NSArray *m_CategoryList;//所有分类
    int m_PageIndex;//当前页数
    NSMutableArray *m_GrouponList;//团购列表
    UIButton *m_CurrentSelectedBtn;//当前选中的分类按钮
    UIImageView *m_CurrentCategoryBg;
    int m_ProductTotalNum;
    NSMutableDictionary *m_CachedDictionary;
    CGFloat m_TableViewOffset;
    EGORefreshTableHeaderView *m_RefreshHeaderView;
    BOOL isRefreshingGroupon;
    int m_SortType;
    
    UIView *m_LoadingView;
}

-(void)initGrouponHomePage;
-(void)setUpThread:(BOOL)showLoading;
-(void)stopThread;
@end
