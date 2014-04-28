//
//  MyOrder.h
//  TheStoreApp
//
//  Created by jiming huang on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshTablePullUp.h"
#import "OTSBaseViewController.h"

@class LoadingMoreLabel;
@class OTSChangePayButton;

@interface MyOrder : OTSBaseViewController<UITableViewDelegate,UITableViewDataSource,RefreshTablePullUpDelegate> {
    IBOutlet UIScrollView *m_ScrollView;
    IBOutlet UIView *m_TypeView;
//    IBOutlet UIView *emptyView;
    LoadingMoreLabel *m_LoadingMoreLabel;
    
    int m_ThreadStatus;
    BOOL m_ThreadRunning;
    
    int m_OrderType;//订单类型
    int m_PageIndex;//页面索引
    int m_OrderTotalNum;//订单总数量
    NSMutableArray *m_AllOrders;//所有订单
    
    int m_CurrentTypeIndex;//当前类型按钮的索引值
    
    RefreshTablePullUp *_RefreshPullUp;  //上拉刷新控件
    BOOL _reloading;
    BOOL _showRefreshPullUp;               //48小时以上的订单显示上拉刷新控键
    BOOL _refreashShowAll;                 //刷新所有订单
    NSMutableArray     *_48TempOrders;    //存储当前pageIndex中过了48小时的订单
    int maxPage;							// 最多多少页正确数据
    
}

@property(nonatomic, retain) OTSChangePayButton     *changePayBtn;

-(void)initMyOrder;
-(void)updateMyOrder;
-(void)setUpThread:(BOOL)showLoading;
-(void)stopThread;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
