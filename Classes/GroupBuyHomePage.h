//
//  GroupBuyHomePage.h
//  TheStoreApp
//
//  Created by jiming huang on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Page.h"
#import "GroupBuyService.h"
#import "GroupBuyProductDetail.h"
#import "LoadingMoreLabel.h"
#import "EGORefreshTableHeaderView.h"
#import "BackToTopView.h"

@interface GroupBuyHomePage : OTSBaseViewController
< UIGestureRecognizerDelegate
, UITableViewDelegate
, UITableViewDataSource
, EGORefreshTableHeaderDelegate>
{
    IBOutlet UIButton *m_LocationBtn;//
    IBOutlet UIScrollView *m_CategoryListView;//
	IBOutlet UIButton *m_sortBtn;
    IBOutlet UITableView *m_TableView;//
    bool m_ThreadIsRunning;
    NSInteger m_CurrentState;
    
    NSInteger m_CurrentCategoryIndex;
    
    
    NSMutableArray *m_CurrentProducts;				//所有的显示的商品
    NSInteger m_PageIndex;							//页面索引
    NSInteger m_ProductTotalNum;					//所有的商品总数
    CGFloat m_ScrollViewOffset;                     //偏移量
	NSMutableDictionary *hadSawCategoryDic;			//缓存已看过分类信息
    
    UIButton *m_CurrentSelectedBtn;
    BOOL m_FirstGetCategory;
    
    LoadingMoreLabel *m_LoadingMoreLabel;
	
	EGORefreshTableHeaderView *m_refreshHeaderView; //顶部下拉刷新
	BOOL isReloading;
    //排序相关
    BOOL b_IsShowSortFilter;
	UITableView* m_SortFilterView;
	int sortType;
	UIView* m_SortCoverView;
	BackToTopView *backView;
	NSMutableArray *m_sortTapeArray;
    
   // UIView* requestCoverView;//loading中止用户操作
}
@property(nonatomic, readonly)UITableView           *m_TableView;//
@property(nonatomic, retain)NSMutableArray          *m_CurrentProducts;
@property(nonatomic, retain)NSMutableArray          *m_sortTapeArray;


- (IBAction)showSortViewSwith;
-(void)getSelectedLocation;
-(IBAction)homePageBtnClicked:(id)sender;
-(IBAction)locationBtnClicked:(id)sender;
-(void)setUpThread:(BOOL)showLoading;
-(void)stopThread;
-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData;
-(void)updateProductTableView;
-(void)updateCategoryList;
-(NSArray *)getCategoryListFromLocal;
-(void)saveCategoryListToLocal;
@end
