//
//  SearchResult.h
//  TheStoreApp
//
//  Created by jiming huang on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

typedef enum {
    FROM_HOMEPAGE=1,//直接从首页搜索进入
    FROM_AD_MODEL,//广告模块关键字进入
    FROM_URLSCHEME
} SearchResultFromTag;

#import <UIKit/UIKit.h>
#import "CartAnimation.h"
#import "mobidea4ec.h"
#import "RecommendView.h"
@class SearchBar;
@class SearchResultVO;
@class BackToTopView;
@class SearchService;
@class RecommendView;

@interface SearchResult : OTSBaseViewController<UISearchBarDelegate, CartAnimationDelegate,mobideaRecProtocol,recommendViewDelegate> {
@private
    SearchBar *m_SearchBar;
    IBOutlet UIButton *m_FilterButton;
    IBOutlet UIButton *m_CancelButton;
    IBOutlet UIButton *m_CategoryButton;
    IBOutlet UIButton *m_SortButton;
    IBOutlet UIImageView *m_CategoryArrow;
    IBOutlet UIImageView *m_SortArrow;
    IBOutlet UITableView *m_TableView;
    IBOutlet UIView *m_NullView;
    UIButton *m_SelectionBackGroundButton;
    IBOutlet UITableView *m_SelectionTableView;
    BackToTopView *m_BackToTopView;
    IBOutlet UITableView *m_RelationTableView;
    IBOutlet UIView *m_HistoryView;
    IBOutlet UITableView *m_HistoryTableView;
    IBOutlet UIButton *m_HistoryBlackView;
    
    //线程
    BOOL m_ThreadRunning;
    int m_ThreadStatus;
    
    //搜索参数
    NSString *m_Keyword;//关键字
    int m_CategoryId;//分类id
    int m_BrandId;//品牌id
    NSString *m_Attributes;//属性
    NSString *m_PriceRange;//价格区间
    NSString *m_Filter;//筛选
    int m_SortType;//排序类型
    int m_CurrentPageIndex;//当前第几页
    
    BOOL m_IsOriginal;//是否是最初的搜索结果
    SearchResultVO *m_OriginalSearchResultVO;//最初的搜索结果，用来获取筛选、排序信息
    SearchResultVO *m_SearchResultVO;//搜索结果
    
    NSArray *m_CategoryArray;//所有分类
    NSArray *m_SortArray;//所有排序
    
    NSMutableArray *m_ProductArray;//搜索结果array
    int m_ProductTotalCount;//搜索结果总数量
    
    NSMutableDictionary *m_FilterDictionary;//筛选条件
    
    BOOL m_AnimateStop;//购物车动画是否结束
    
    int m_Flag;//标识，分类或排序
    SearchResultFromTag m_FromTag;
    
    int m_DoTrackingFlag;//搜索统计flag，1为从一次搜索，2为二次搜索
    
    BOOL m_LoadingMore;//是否正在加载更多
    int m_ClickedIndex;//点击加入购物车商品索引
    
    //搜索历史
    NSMutableArray *m_SearchHistoryArray;
    //关键字
    NSArray *m_SearchRelationArray;
    BOOL m_GettingKeywords;
    SearchService *m_GetKeywordsService;
    
    
    RecommendView *_recommendView;
    UIImageView *nullIV;
    UILabel *nullLbl;
    
}

-(id)initWithKeyword:(NSString *)keyword fromTag:(SearchResultFromTag)fromTag;
@end
