//
//  MyFavorite.h
//  TheStoreApp
//
//  Created by zhengchen on 11-12-1.
//  Copyright (c) 2011年 yihaodian. All rights reserved.
//
typedef enum {
    FROM_CART_TO_FAVORITE=1,
    FROM_HOMEPAGE_TO_FAVORITE=2
} FavoriteFromTag;

#import <UIKit/UIKit.h>
#import "Page.h"
#import "FavoriteVO.h"
#import "StrikeThroughLabel.h"
#import "BackToTopView.h"
@interface MyFavorite : OTSBaseViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIWebViewDelegate>{

    BOOL running;//开启线程
    NSInteger currentState;// 当前线程状态
    Page* myFavoritePage;
    int favoriteCellNum; //最大的收藏数
    int m_ShowPageCount;
    int delProductId;
    NSInteger currentActionIndex;
    FavoriteVO *favoriteVo;//收藏VO
    
    UIImageView *noProductView;
    
	BOOL isAnimStop;								// 是否可以启动其他动画
	UIButton *editBtn;
	BackToTopView *backView;
    BOOL m_LoadingMore;
@public
	UITableView *m_TableView;
    FavoriteFromTag fromTag;

}

@property NSInteger currentState;
@property int delProductId;
@property(retain)Page* myFavoritePage;  // 此成员变量可能由多个线程同时读写，故使用线程安全属性 --- dym.12.06.12.

@property(retain, nonatomic) NSMutableArray *favoriteList; 


-(void)setUpThread:(BOOL)showLoading;
-(void)startThread;
-(void)stopThread;
#pragma mark 显示收藏Sheet列表
-(void)showSheetView;
-(void)initFavoriteTableView;
-(void)startAnimation;                      // 开始动画
@end
