//
//  SearchResult.m
//  TheStoreApp
//
//  Created by jiming huang on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define THREAD_STAGUS_SEARCH    1
#define THREAD_STAGUS_ADD_CART  2


#define SORT_BY_DEFAULT 0    //对应默认排序
#define SORT_BY_TIME 1       //最新发布
#define SORT_BY_PRICE_ASC 2  //价格最低
#define SORT_BY_PRICE_DESC 5 //价格最高  特殊处理，上传给服务器时要改为2 fuck
#define SORT_BY_COMMENT_DESC 3 //好评最高
#define SORT_BY_SALE  4        //销量最高


#define FLAG_CATEGORY   1
#define FLAG_SORT       2

#define ALERTVIEW_TAG_DELETE_CONFIRM    1

#import "SearchResult.h"
#import "SearchBar.h"
#import "SearchResultVO.h"
#import "GlobalValue.h"
#import "OTSServiceHelper.h"
#import "DoTracking.h"
#import "AlertView.h"
#import "OTSUtility.h"
#import "ProductVO.h"
#import "DataController.h"
#import "NSString+MD5Addition.h"
#import "BackToTopView.h"
#import "HomePage.h"
#import "TheStoreAppAppDelegate.h"
#import "SearchCategoryVO.h"
#import "CategoryProductCell.h"
#import "UITableView+LoadingMore.h"
#import "LocalCartItemVO.h"
#import "Scan.h"
#import "SearchService.h"
#import "SearchKeywordVO.h"
#import "OTSProductDetail.h"
#import "GTMBase64.h"
#import "ProductService.h"
#import "BrowseService.h"
#import "SDImageView+SDWebCache.h"
#define URL_BASE_MALL_NO_ONE                        @"http://m.1mall.com/mw/product/"

#import "YWSearchService.h"
#import "SearchResultInfo.h"
#import "ProductInfo.h"
#import "CategoryInfo.h"
#import "RelationWordInfo.h"
#import "YWLocalCatService.h"
#import "LocalCarInfo.h"
#import "UserInfo.h"
#import "RecommendView.h"
#import "mobidea4ec.h"


@interface SearchResult ()
@property(nonatomic, retain)NSNumber* isDianzhongDian;
@property(nonatomic, retain)CartAnimation* cartAnimation;

-(void)initSearchResult;
-(void)initSearchHistory;
-(void)initUI;
-(void)initData;
-(void)searchWhenConditionChanged;
-(void)saveSearchKeyword;
-(void)initSearchRelation;
-(void)closeSearchHistoryAndRelationView;
-(void)setUpThreadWithStatus:(int)status showLoading:(BOOL)showLoading;
-(void)stopThread;
-(void)newThreadSearchProduct:(NSString *)keyword;
-(void)newThreadAddCart;
-(void)startAnimation;

@end

@implementation SearchResult
@synthesize isDianzhongDian;
@synthesize cartAnimation;

-(id)initWithKeyword:(NSString *)keyword fromTag:(SearchResultFromTag)fromTag
{
    self=[super initWithNibName:@"SearchResult" bundle:nil];
    if (self!=nil) {
        m_Keyword=[[NSString alloc] initWithString:keyword];
        m_FromTag=fromTag;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSearchResult];
    [self initSearchHistory];
    [self initSearchRelation];
    [self initRecommendView];
    
}

//初始化推荐信息
- (void)initRecommendView
{
    _recommendView = [[RecommendView alloc] initWithFrame:CGRectMake(0, self.view.height-230, 320, 215)];
    [self.view addSubview:_recommendView];
    _recommendView.delegate = self;
    _recommendView.hidden = YES;
    
    [BfdAgent recommend:self recommendType:kRCSearch options:nil];
}

-(void)initSearchResult
{
    //初始化ui
    [self initUI];
    
    //数据初始化
    [self initData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterConditionChanged:) name:@"SearchFilterConditionChanged" object:nil];
    
    //搜索
    m_DoTrackingFlag=1;//一次搜索
    [self setUpThreadWithStatus:THREAD_STAGUS_SEARCH showLoading:YES];
}

//初始化ui
-(void)initUI
{
    //筛选
//    [m_FilterButton setBackgroundImage:[UIImage imageNamed:@"title_cate_btn.png"] forState:UIControlStateNormal];
//    [m_FilterButton setBackgroundImage:[UIImage imageNamed:@"title_cate_btn_sel.png"] forState:UIControlStateHighlighted];
//    [m_FilterButton setEnabled:NO];
    
    //搜索bar
    m_SearchBar=[[SearchBar alloc] initWithFrame:CGRectMake(60, 8, 200, 28)];
    [m_SearchBar setPlaceholder:@"请输入搜索关键字"];
    [m_SearchBar setDelegate:self];
    [m_SearchBar setText:m_Keyword];
    [self.view addSubview:m_SearchBar];
    
    //分类、排序
    if (m_SelectionBackGroundButton!=nil)
    {
        [m_SelectionBackGroundButton removeFromSuperview];
        [m_SelectionBackGroundButton release];
    }
    m_SelectionBackGroundButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 83, 320, self.view.frame.size.height-83.0)];
    [m_SelectionBackGroundButton setBackgroundColor:[UIColor blackColor]];
    [m_SelectionBackGroundButton setAlpha:0.5];
    [m_SelectionBackGroundButton addTarget:self action:@selector(selectionBlackBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_SelectionBackGroundButton];
    [m_SelectionBackGroundButton setHidden:YES];
    
    [self.view addSubview:m_SelectionTableView];
    [m_SelectionTableView setHidden:YES];
    
    //table view
    [m_TableView setFrame:CGRectMake(0, 83, 320, self.view.frame.size.height-83.0)];
    
    //空态页面
    [m_NullView setFrame:CGRectMake(0, 83, 320, self.view.frame.size.height-83.0-215)];
    
    //回到顶部
    if (m_BackToTopView!=nil)
    {
        [m_BackToTopView release];
    }
	m_BackToTopView=[[BackToTopView alloc] init];
	[m_BackToTopView setScrollScreenHeight:self.view.frame.size.height-83.0];
    [self.view addSubview:m_BackToTopView];
	
	[[SharedDelegate homePage] setUniqueScrollToTopFor:m_TableView];
}

//重置ui
-(void)resetUI
{
    //搜索bar
    [m_SearchBar resignFirstResponder];
    [m_SearchBar setText:m_Keyword];
    
    [self closeSearchHistoryAndRelationView];
    
    //分类、排序
    [m_CategoryButton setTitle:@"全部分类" forState:UIControlStateNormal];
    [m_SortButton setTitle:@"默认排序" forState:UIControlStateNormal];
    [self selectionBlackBtnClicked:nil];
    
    //筛选
//    [m_FilterButton setBackgroundImage:[UIImage imageNamed:@"title_cate_btn.png"] forState:UIControlStateNormal];
//    [m_FilterButton setBackgroundImage:[UIImage imageNamed:@"title_cate_btn_sel.png"] forState:UIControlStateHighlighted];
    
    //tableview
    [m_TableView setContentOffset:CGPointZero];
}

//数据初始化
-(void)initData
{
    cartAnimation=[[CartAnimation alloc] init:self.view];
    [cartAnimation setDelegate:self];
    m_CategoryId=0;
    m_BrandId=0;
    if (m_Attributes!=nil) {
        [m_Attributes release];
    }
    m_Attributes=[[NSString alloc] initWithString:@""];
    if (m_PriceRange!=nil) {
        [m_PriceRange release];
    }
    m_PriceRange=[[NSString alloc] initWithString:@""];
    if (m_Filter!=nil) {
        [m_Filter release];
    }
    m_Filter=[[NSString alloc] initWithString:@"0"];
    m_SortType=SORT_BY_SALE;
    m_CurrentPageIndex=1;
    m_IsOriginal=YES;
    self.isDianzhongDian = [NSNumber numberWithInt:0];
    if (m_SortArray!=nil) {
        [m_SortArray release];
    }
    m_SortArray=[[NSArray alloc] initWithObjects:@"默认排序",@"最近发布",@"价格最低",@"价格最高",@"好评最高",@"销量最高", nil];
    if (m_ProductArray!=nil) {
        [m_ProductArray release];
    }
    m_ProductArray=[[NSMutableArray alloc] initWithCapacity:0];
    m_ProductTotalCount=0;
    if (m_FilterDictionary!=nil) {
        [m_FilterDictionary release];
        m_FilterDictionary=nil;
    }
    
    m_AnimateStop=YES;
    
    
    ///////
    m_CategoryArray = [[self getCateFromLocalByRootId:@"-1"] retain];
}

//通过关键字搜索
-(void)searchByKeyword:(NSString *)keyword
{
    if (m_Keyword!=nil) {
        [m_Keyword release];
    }
    m_Keyword=[[NSString alloc] initWithString:keyword];
    
    [self initData];
    [m_TableView setHidden:YES];
    [self resetUI];
    
    [self setUpThreadWithStatus:THREAD_STAGUS_SEARCH showLoading:YES];
    
    [self saveSearchKeyword];
}

////分类、排序、筛选条件改变后搜索
//-(void)searchWhenConditionChanged
//{
//    m_CurrentPageIndex=1;
//    m_ProductTotalCount=0;
//    if (m_ProductArray!=nil) {
//        [m_ProductArray removeAllObjects];
//    }
//    [m_TableView setHidden:YES];
//    [m_TableView setContentOffset:CGPointZero];
//    
//    //分类、排序
//    [self selectionBlackBtnClicked:nil];
//    
//    [self setUpThreadWithStatus:THREAD_STAGUS_SEARCH showLoading:YES];
//}

//加载更多
-(void)getMoreProduct
{
    [self setUpThreadWithStatus:THREAD_STAGUS_SEARCH showLoading:NO];
}

#pragma mark - 搜索历史
-(void)initSearchHistory
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *filename=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"SearchHistory.plist"];
	NSMutableArray *mArray=[[NSMutableArray alloc] initWithContentsOfFile:filename];
    if (mArray!=nil && [mArray count]!=0) {
        m_SearchHistoryArray=[[NSMutableArray alloc] initWithArray:mArray];
    } else {
        m_SearchHistoryArray=[[NSMutableArray alloc] init];
    }
    [mArray release];
}

-(IBAction)clearAllHistory:(id)sender
{
    UIAlertView *alert=[[OTSAlertView alloc]initWithTitle:nil message:@"确定要清空历史记录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alert setTag:ALERTVIEW_TAG_DELETE_CONFIRM];
    [alert show];
    [alert release];
}

-(IBAction)scanBtnClicked:(id)sender
{
    [m_SearchBar resignFirstResponder];
    [self closeSearchHistoryAndRelationView];
    Scan *scan=[[[Scan alloc] initWithNibName:@"Scan" bundle:nil] autorelease];
    [self pushVC:scan animated:YES];
}

//保存搜索关键字
-(void)saveSearchKeyword
{
    NSString *keyWord=[[NSString alloc] initWithString:m_Keyword];
    int i;
    for (i=0;i<[m_SearchHistoryArray count];i++) {
        NSString *text=[m_SearchHistoryArray objectAtIndex:i];
        if ([text isEqualToString:keyWord]) {
            [m_SearchHistoryArray removeObject:text];
        }
    }
    [m_SearchHistoryArray insertObject:keyWord atIndex:0];
    [keyWord release];
    [m_HistoryTableView reloadData];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *filename=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"SearchHistory.plist"];
    [m_SearchHistoryArray writeToFile:filename atomically:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchHistoryChanged" object:nil];
}

//清空搜索历史
-(void)clearSearchHistory
{
    if (m_SearchHistoryArray!=nil) {
        [m_SearchHistoryArray removeAllObjects];
    }
    [m_HistoryTableView reloadData];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *filename=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"SearchHistory.plist"];
    [m_SearchHistoryArray writeToFile:filename atomically:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchHistoryChanged" object:nil];
	[m_SearchBar resignFirstResponder];
    [self closeSearchHistoryAndRelationView];
}

-(void)closeSearchHistoryAndRelationView
{
    if ([m_HistoryView superview]!=nil) {
        [m_HistoryView removeFromSuperview];
    }
    if ([m_RelationTableView superview]!=nil) {
        [m_RelationTableView removeFromSuperview];
    }
}

-(void)showSearchView:(UISearchBar *)searchBar keyword:(NSString *)keyword
{
    if ([keyword length]>0) {//相关关键字
        if ([m_HistoryView superview]!=nil) {
            [m_HistoryView removeFromSuperview];
        }
        if ([m_RelationTableView superview]==nil) {
            [m_RelationTableView setFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44.0)];
            [self.view addSubview:m_RelationTableView];
        }
		if (![[keyword substringWithRange:NSMakeRange(0, 1)] isEqualToString:@" "] && !m_GettingKeywords) {
			m_GettingKeywords=YES;
			[self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadGetRelationKeyWords:) toTarget:self withObject:keyword];
		}
	} else {//搜索历史
        if ([m_RelationTableView superview]!=nil) {
            [m_RelationTableView removeFromSuperview];
        }
        if ([m_HistoryView superview]==nil) {
            [m_HistoryView setFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44.0)];
            [m_HistoryTableView setFrame:CGRectMake(0, 40, 320, self.view.frame.size.height-84.0)];
            [m_HistoryBlackView setFrame:CGRectMake(0, 40, 320, self.view.frame.size.height-84.0)];
            [self.view addSubview:m_HistoryView];
        }
        if (m_SearchHistoryArray==nil || [m_SearchHistoryArray count]==0) {
            [m_HistoryTableView setHidden:YES];
            [m_HistoryBlackView setHidden:NO];
        } else {
            [m_HistoryTableView setHidden:NO];
            [m_HistoryBlackView setHidden:YES];
        }
        
        //清空关联关键字table
        if (m_SearchRelationArray!=nil) {
            [m_SearchRelationArray release];
        }
		m_SearchRelationArray=nil;
		[m_RelationTableView reloadData];
	}
}

//搜索历史黑色背景
-(IBAction)blackBtnClicked:(id)sender
{
    [m_SearchBar resignFirstResponder];
    [self closeSearchHistoryAndRelationView];
}

#pragma mark - 关联关键字
-(void)initSearchRelation
{
    m_GetKeywordsService=[[SearchService alloc] init];
}

//新线程获取关联关键字
-(void)newThreadGetRelationKeyWords:(NSString *)word
{
    
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    
    YWSearchService *searchSer = [[YWSearchService alloc] init];
    
    NSDictionary *paramDic = @{@"word" : word,@"minScore":@"1",@"count":@"10"};
    
     NSArray *tempArray = [searchSer getSearchKeyword:paramDic];
    
    m_GettingKeywords=NO;
    if (m_SearchRelationArray!=nil)
    {
        [m_SearchRelationArray release];
    }
    if (tempArray==nil || [tempArray isKindOfClass:[NSNull class]])
    {
		m_SearchRelationArray=nil;
    }
    else
    {
        m_SearchRelationArray=[tempArray retain];
    }
	[self performSelectorOnMainThread:@selector(updateRelationTableView) withObject:nil waitUntilDone:NO];
	[pool drain];
}

//刷新关联关键字显示
-(void)updateRelationTableView
{
	[m_RelationTableView reloadData];
}

#pragma mark - action相关
//返回
-(IBAction)returnBtnClicked:(id)sender
{
    [self hideLoading];
	[[SharedDelegate homePage] setUniqueScrollToTopFor:[SharedDelegate homePage]->m_ScrollView];
    if (m_FromTag==FROM_HOMEPAGE) {//通过首页搜索不是直接通过关键字进
        //[SharedDelegate homePageSearchBarBecomeFirstResponder];
        // 需求变更，返回不在设置为焦点。BUG号：0103911
    }
    [self.view.superview.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:@"Reveal"];
    [self removeSelf];
}

//筛选
-(IBAction)filterBtnClicked:(id)sender
{
    if (m_LoadingMore) {
        return;
    }
    [m_SearchBar resignFirstResponder];
    //加入筛选
    [SharedDelegate enterFilterWithSearchResultVO:m_OriginalSearchResultVO condition:m_FilterDictionary fromTag:FROM_SEARCH];
    //[DoTracking doTracking:@"searchFilter"];//点筛选按钮统计
    // tracking 统计
    JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_Filiter extraPramaDic:nil]autorelease];
    [DoTracking doJsTrackingWithParma:prama];
}

//取消
-(IBAction)cancelBtnClicked:(id)sender
{
    
    [m_CancelButton setHidden:YES];
    [m_SearchBar resignFirstResponder];
    [self closeSearchHistoryAndRelationView];
}

//分类
-(IBAction)categoryBtnClicked:(id)sender
{
    if (m_CategoryArray==nil || [m_CategoryArray count]==0 || m_LoadingMore) {
        return;
    }
    if (m_Flag==FLAG_CATEGORY && !m_SelectionTableView.isHidden) {
        [m_SelectionTableView setHidden:YES];
        [m_SelectionBackGroundButton setHidden:YES];
        [m_CategoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [m_CategoryArrow setImage:[UIImage imageNamed:@"cate_arrow_down.png"]];
    } else {
        m_Flag=FLAG_CATEGORY;
        [m_SelectionBackGroundButton setHidden:NO];
        [m_SelectionTableView setHidden:NO];
        CGFloat height=40*([m_CategoryArray count]+1);
        if (height>self.view.frame.size.height-83.0) {
            height=self.view.frame.size.height-83.0;
        }
        [m_SelectionTableView setFrame:CGRectMake(0, 83, 320, height)];
        [m_SelectionTableView reloadData];
        [m_CategoryButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [m_CategoryArrow setImage:[UIImage imageNamed:@"cate_arrow_up.png"]];
    }
    [m_SortButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_SortArrow setImage:[UIImage imageNamed:@"cate_arrow_down.png"]];
}

//排序
-(IBAction)sortBtnClicked:(id)sender
{
    if (m_LoadingMore) {
        return;
    }
    if (m_Flag==FLAG_SORT && !m_SelectionTableView.isHidden) {
        [m_SelectionTableView setHidden:YES];
        [m_SelectionBackGroundButton setHidden:YES];
        [m_SortButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [m_SortArrow setImage:[UIImage imageNamed:@"cate_arrow_down.png"]];
    } else {
        m_Flag=FLAG_SORT;
        [m_SelectionBackGroundButton setHidden:NO];
        [m_SelectionTableView setHidden:NO];
        CGFloat height=40*[m_SortArray count];
        if (height>self.view.frame.size.height-83.0) {
            height=self.view.frame.size.height-83.0;
        }
        [m_SelectionTableView setFrame:CGRectMake(0, 83, 320, height)];
        [m_SelectionTableView reloadData];
        [m_SortButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [m_SortArrow setImage:[UIImage imageNamed:@"cate_arrow_up.png"]];
    }
    [m_CategoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_CategoryArrow setImage:[UIImage imageNamed:@"cate_arrow_down.png"]];
}

//筛选、排序黑色背景
-(void)selectionBlackBtnClicked:(id)sender
{
    [m_SelectionTableView setHidden:YES];
    [m_SelectionBackGroundButton setHidden:YES];
    [m_CategoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_CategoryArrow setImage:[UIImage imageNamed:@"cate_arrow_down.png"]];
    [m_SortButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_SortArrow setImage:[UIImage imageNamed:@"cate_arrow_down.png"]];
}

//进入商品详情
-(void)enterProductDetail:(ProductInfo *)productVO
{
    OTSProductDetail *productDetail=[[[OTSProductDetail alloc] initWithProductId:[productVO.productId longLongValue] promotionId:nil fromTag:PD_FROM_SEARCH] autorelease];
    [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
    [self pushVC:productDetail animated:YES];
}

//分类、排序进行搜索
-(void)searchBySelectionWithIndex:(int)index
{
    if (m_Flag==FLAG_CATEGORY)
    {
        if (index==0)
        {
            m_CategoryId=0;
            //分类按钮文字
            [m_CategoryButton setTitle:@"全部分类" forState:UIControlStateNormal];
        }
        else
        {
//            SearchCategoryVO *searchCategoryVO=[OTSUtility safeObjectAtIndex:index-1 inArray:m_CategoryArray];
            CategoryInfo *categoryInfo = m_CategoryArray[index -1];
            m_CategoryId=[categoryInfo.cid intValue];
            //分类按钮文字
            NSString * cateTilte = categoryInfo.name;
            if (cateTilte.length>5)
            {
                cateTilte=[NSMutableString stringWithFormat:@"%@... ",[cateTilte substringToIndex:5]];
            }
            [m_CategoryButton setTitle:cateTilte forState:UIControlStateNormal];
        }
        
        
    } else if (m_Flag==FLAG_SORT) {
        //搜索条件
        switch (index)
        {
            case 0:
                m_SortType=SORT_BY_DEFAULT;
                break;
            case 1:
                m_SortType=SORT_BY_TIME;
                break;
            case 2:
                m_SortType=SORT_BY_PRICE_ASC;
                break;
            case 3:
                m_SortType=SORT_BY_PRICE_DESC;
                break;
            case 4:
                m_SortType = SORT_BY_COMMENT_DESC;
                break;
            case 5:
                m_SortType=SORT_BY_SALE;
                break;
            default:
                break;
        }
        //排序按钮文字
        [m_SortButton setTitle:[OTSUtility safeObjectAtIndex:index inArray:m_SortArray] forState:UIControlStateNormal];
    }
    
    //重新搜索
    [self searchWhenConditionChanged];
}

//加入购物车
-(void)accessoryButtonTap:(UIControl *)button withEvent:(UIEvent *)event
{

    
    NSIndexPath *indexPath=[m_TableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:m_TableView]];//获得NSIndexPath
    m_ClickedIndex=indexPath.row;
	ProductInfo *productVO=[OTSUtility safeObjectAtIndex:m_ClickedIndex inArray:m_ProductArray];
    
    //如果是系列品， 直接进入页面
    if ([productVO isSeriesProductInProductList])
    {
        [self tableView:m_TableView didSelectRowAtIndexPath:indexPath];
        return;
    }

    [UIView setAnimationsEnabled:YES];
    if (productVO.stockNum > 0 )
    {
        YWLocalCatService *localCatService = [[YWLocalCatService alloc] init];
        LocalCarInfo *localCart = [[LocalCarInfo alloc] initWithProductId:productVO.productId
                                                            shoppingCount:@"1"
                                                                 imageUrl:productVO.mainImg3
                                                                    price:productVO.price
                                                               provinceId:[[GlobalValue getGlobalValueInstance].provinceId stringValue]
                                                                      uid:[GlobalValue getGlobalValueInstance].userInfo.ecUserId
                                                                productNO:productVO.productNO
                                                                   itemId:productVO.itemId];
        
        BOOL result = [localCatService saveLocalCartToDB:localCart];
        
        if (result)
        {
            
            [self performSelectorOnMainThread:@selector(showBuyProductAnimationWithSelectedIndex:) withObject:[NSNumber numberWithInt:m_ClickedIndex] waitUntilDone:NO];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(showInfo:) withObject:@"加入购物车失败" waitUntilDone:NO];
        }
    }
    else
    {
        [AlertView showAlertView:nil alertMsg:@"很抱歉,该商品已经卖光啦!你可以收藏商品,下次购买" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
    }

}

#pragma mark - 线程相关
-(void)setUpThreadWithStatus:(int)status showLoading:(BOOL)showLoading
{
    if (!m_ThreadRunning)
    {
        m_ThreadRunning=YES;
        m_ThreadStatus=status;
        if (showLoading)
        {
            [self showLoading:YES];
        }
        [self otsDetatchMemorySafeNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
    }
}

-(void)startThread
{
    while (m_ThreadRunning)
    {
        @synchronized(self)
        {
            switch (m_ThreadStatus)
            {
                case THREAD_STAGUS_SEARCH:
                {//搜索
                    [self newThreadSearchProduct:m_Keyword];
                    [self stopThread];
                    break;
                }
                case THREAD_STAGUS_ADD_CART:
                {//加入购物车
                    [self newThreadAddCart];
                    [self stopThread];
                    break;
                }
                default:
                    break;
            }
        }
	}
}

-(void)stopThread
{
    m_ThreadStatus=-1;
    m_ThreadRunning=NO;
    [self hideLoading];
}

//新线程搜索
-(void)newThreadSearchProduct:(NSString *)keyword
{
    
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];

    

    YWSearchService *searchSer = [[YWSearchService alloc] init];
    SearchResultInfo *searchResult = nil;
    @try
    {
        NSString *sort = @"";
        NSString *isDesc = @"";
        //如果是按价格降序来排序的话：sort＝2 其他的sort为对应的值, 对于现在请求参数，我只能：呵呵，fuck。。。
        if (m_SortType == 5)
        {
            sort = @"2";
            isDesc = @"0";  //fuck， 这个用2个字段来排序真tmd傻逼，如果价格降序，那么 isDesc＝0 草，，，降序好歹为1才对的上名字啊。。。。。
        }
        else
        {
            sort = [NSString stringWithFormat:@"%d",m_SortType];
            isDesc = @"1";
        }
        
        NSDictionary *paramDic = @{@"province":[GlobalValue getGlobalValueInstance].provinceId ,
        @"pagesize":@"10",
        @"pageindex":[NSString stringWithFormat:@"%d",m_CurrentPageIndex],
//        @"catalogId":[NSString stringWithFormat:@"%d",m_CategoryId],
        @"keyword":keyword,
        @"sort":sort,
        @"isDesc" : isDesc};
    
        DebugLog(@"开始搜索");
       searchResult = [searchSer getSearchProductListWithParam:paramDic];
       DebugLog(@"搜索完成");
    }
    @catch (NSException *exception)
    {
    }
    @finally {
        if (searchResult.responseCode == 200)
        {
         
             
            
            if (m_LoadingMore)
            {
                [m_ProductArray addObjectsFromArray:searchResult.productList];
            }
            else
            {
                if (m_ProductArray != nil)
                {
                    [m_ProductArray release];
                }
                m_ProductArray = [searchResult.productList retain];
            }
            
            
            m_ProductTotalCount = searchResult.totalCount;
            m_CurrentPageIndex++;
            
            if (searchResult.productList.count  >0)
            {
                DebugLog(@"去 updateTableView");
                [self performSelectorOnMainThread:@selector(updateTableView) withObject:nil waitUntilDone:NO];
            }
            else
            {
                DebugLog(@"去 searchResultNull");
                [self performSelectorOnMainThread:@selector(searchResultNull) withObject:nil waitUntilDone:NO];
            }
        }
        else
        {
            DebugLog(@"显示网络异常");
            [self performSelectorOnMainThread:@selector(showInfo:) withObject:@"网络异常，请检查网络配置..." waitUntilDone:NO];
        }
        [m_TableView performSelectorOnMainThread:@selector(setTableFooterView:) withObject:nil waitUntilDone:NO];
        m_LoadingMore=NO;
        m_IsOriginal=NO;
        
    }
    [searchSer release];
    DebugLog(@"stopThread");
    [self stopThread];
    [pool drain];
    
}

//新线程加入购物车
-(void)newThreadAddCart
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	ProductVO *productVO=[OTSUtility safeObjectAtIndex:m_ClickedIndex inArray:m_ProductArray];
	int buyQuantity=1;
    if (productVO.shoppingCount!=nil && [productVO.shoppingCount intValue]>1) {
		buyQuantity=[productVO.shoppingCount intValue];  
	}
	
	if ([GlobalValue getGlobalValueInstance].token!=nil) {
		CartService *cServ=[[[CartService alloc] init] autorelease];
		AddProductResult *result=[cServ addSingleProduct:[GlobalValue getGlobalValueInstance].token productId:[NSNumber numberWithInt:[productVO.productId intValue]] merchantId:[NSNumber numberWithInt:[productVO.merchantId intValue]] quantity:[NSNumber numberWithInt:buyQuantity] promotionid:productVO.promotionId];
        if (result!=nil && ![result isKindOfClass:[NSNull class]]) {
            if ([[result resultCode] intValue]==1) {//成功
                //[self performSelectorOnMainThread:@selector(showBuyProductAnimation) withObject:nil waitUntilDone:NO];
                [self performSelectorOnMainThread:@selector(showBuyProductAnimationWithSelectedIndex:) withObject:[NSNumber numberWithInt:m_ClickedIndex] waitUntilDone:NO];
            } else {
                [self performSelectorOnMainThread:@selector(showInfo:) withObject:[result errorInfo] waitUntilDone:NO];
            }
        } else {
            [self performSelectorOnMainThread:@selector(showInfo:) withObject:@"网络异常，请检查网络配置..." waitUntilDone:NO];
        }
	} else {
        ProductService* helper= [[ProductService alloc] init];
        ProductVO*product =[helper getProductDetail:[GlobalValue getGlobalValueInstance].trader productId:productVO.productId provinceId:[GlobalValue getGlobalValueInstance].provinceId promotionid:productVO.promotionId];
        [helper release];

		LocalCartItemVO *localCartItemVO=[[LocalCartItemVO alloc] initWithProductVO:product quantity:[NSString stringWithFormat:@"%d", buyQuantity]];
        [SharedDelegate addProductToLocal:localCartItemVO];
		//[self performSelectorOnMainThread:@selector(showBuyProductAnimation) withObject:nil waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(showBuyProductAnimationWithSelectedIndex:) withObject:[NSNumber numberWithInt:m_ClickedIndex] waitUntilDone:YES];
		[localCartItemVO release];
	}
    [pool drain];
}

#pragma mark - 购物车动画
-(void)showBuyProductAnimation {
    [self startAnimation];
    ProductVO *productVO=[OTSUtility safeObjectAtIndex:m_ClickedIndex inArray:m_ProductArray];
	int buyQuantity=1;
    if (productVO.shoppingCount!=nil && [productVO.shoppingCount intValue]>1) {
		buyQuantity=[productVO.shoppingCount intValue];  
	}
    [SharedDelegate setCartNum:buyQuantity];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChanged" object:nil];
}

-(void)showBuyProductAnimationWithSelectedIndex:(NSNumber*)row{

    
    //////////
    ProductInfo *productVO=[OTSUtility safeObjectAtIndex:m_ClickedIndex inArray:m_ProductArray];

    NSString* imageURLStr = [productVO productImageUrl];
    
    // 算出对应的图片坐标
    UITableViewCell* cell = [m_TableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row.intValue inSection:0]];
    CGPoint point = cell.imageView.center;
    point = [cell.imageView convertPoint:point toView:self.view];
    
    UIImageView* imageV = [[[UIImageView alloc]init]autorelease];
    [imageV setImageWithURL:[NSURL URLWithString:imageURLStr] refreshCache:NO placeholderImage:[UIImage imageNamed:@"defaultimg76"]];
    [cartAnimation beginCartAnimationWithProductImageView:imageV point:point];
    
    [SharedDelegate setCartNum:1];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChanged" object:nil];
    
    if (m_AnimateStop) {
        [SharedDelegate showAddCartAnimationWithDelegate:self];
		m_AnimateStop=NO;
	}
    
}

-(void)startAnimation {
	if (m_AnimateStop) {
		[SharedDelegate showAddCartAnimationWithDelegate:self];
		m_AnimateStop=NO;
	}
}

-(void)animationFinished
{
    m_AnimateStop=YES;
}

//刷新tableview
-(void)updateTableView
{
    if (m_CategoryArray==nil || [m_CategoryArray count]==0) {
        [m_CategoryButton setEnabled:NO];
        [m_CategoryArrow setHidden:YES];
    } else {
        [m_CategoryButton setEnabled:YES];
        [m_CategoryArrow setHidden:NO];
    }
    [m_NullView setHidden:YES];
    [m_TableView setHidden:NO];
    [m_TableView reloadData];
    
//    [m_FilterButton setEnabled:YES];
    
    //百分点推荐的显示
    _recommendView.hidden = YES;
    
    
}

//搜索结果为空
-(void)searchResultNull
{
    if (m_CategoryArray==nil || [m_CategoryArray count]==0)
    {
        [m_CategoryButton setEnabled:NO];
        [m_CategoryArrow setHidden:YES];
    } else {
        [m_CategoryButton setEnabled:YES];
        [m_CategoryArrow setHidden:NO];
    }
    [m_NullView setHidden:NO];
    [m_TableView setHidden:YES];
    if (m_IsOriginal) {
        [m_FilterButton setEnabled:NO];
    }
    
    
    //百分点推荐的显示
    _recommendView.hidden = NO;

    
    nullIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchresult_null.png"]];
    nullIV.frame = CGRectMake(108, 12, 105, 104);
    
    nullLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 129, 320, 20)];
    nullLbl.text = @"很抱歉，没有找到相关商品";
    nullLbl.textAlignment = UITextAlignmentCenter;
    nullLbl.textColor = [UIColor lightGrayColor];
    
    [m_NullView addSubview:nullLbl];
    [m_NullView addSubview: nullIV];
    
    [nullIV release];
    [nullLbl release];
    
    if (!iPhone5)
    {
        nullLbl.frame = CGRectMake(0, 75, 320, 20);
        nullIV.frame = CGRectMake(130, 12, 60, 60);
    }
    
    
}

//弹框信息
-(void)showInfo:(NSString *)info
{
    [AlertView showAlertView:nil alertMsg:info buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
}

#pragma mark - NSNotification
//-(void)filterConditionChanged:(NSNotification *)notification
//{
//    //搜索条件
//    NSMutableDictionary *dictionary=[notification object];
//    if (m_FilterDictionary!=nil) {
//        [m_FilterDictionary release];
//    }
//    m_FilterDictionary=[dictionary retain];
//    
//    BOOL hasFilter=NO;//是否有筛选条件
//    
//    NSNumber *brandId=[dictionary objectForKey:@"brandId"];
//    if (brandId==nil) {
//        m_BrandId=0;
//    } else {
//        m_BrandId=[brandId intValue];
//        if (m_BrandId!=0) {
//            hasFilter=YES;
//        }
//    }
//    
//    NSString *attributes=[dictionary objectForKey:@"attributes"];
//    if (m_Attributes!=nil) {
//        [m_Attributes release];
//    }
//    if (attributes==nil) {
//        m_Attributes=[[NSString alloc] initWithString:@""];
//    } else {
//        m_Attributes=[[NSString alloc] initWithString:attributes];
//        if (![m_Attributes isEqualToString:@""]) {
//            hasFilter=YES;
//        }
//    }
//    
//    NSString *priceRange=[dictionary objectForKey:@"priceRange"];
//    if (m_PriceRange!=nil) {
//        [m_PriceRange release];
//    }
//    if (priceRange==nil) {
//        m_PriceRange=[[NSString alloc] initWithString:@""];
//    } else {
//        m_PriceRange=[[NSString alloc] initWithString:priceRange];
//        if (![m_PriceRange isEqualToString:@""]) {
//            hasFilter=YES;
//        }
//    }
//    
//    NSString *promotionType=[dictionary objectForKey:@"promotionType"];
//    if (m_Filter!=nil) {
//        [m_Filter release];
//    }
//    if (promotionType==nil) {
//        m_Filter=[[NSString alloc] initWithString:@"0"];
//    } else {
//        m_Filter=[[NSString alloc] initWithString:promotionType];
//        if (![m_Filter isEqualToString:@"0"]) {
//            hasFilter=YES;
//        }
//    }
//    
//    self.isDianzhongDian = [dictionary objectForKey:@"merchantType"];
//    if (isDianzhongDian && isDianzhongDian.intValue != 0) {
//        hasFilter = YES;
//    }else{
//        self.isDianzhongDian = [NSNumber numberWithInt:0];
//    }
//    
//    //筛选按钮图片
//    if (hasFilter) {
//        [m_FilterButton setBackgroundImage:[UIImage imageNamed:@"title_cate_btn.png"] forState:UIControlStateNormal];
//    } else {
//        [m_FilterButton setBackgroundImage:[UIImage imageNamed:@"title_cate_btn.png"] forState:UIControlStateNormal];
//    }
//    [m_FilterButton setBackgroundImage:[UIImage imageNamed:@"title_cate_btn_sel.png"] forState:UIControlStateHighlighted];
//    //重新搜索
//    [self searchWhenConditionChanged];
//}

#pragma mark UIScrollView相关delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[m_BackToTopView scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
	[m_BackToTopView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)theScrollView{
	[m_BackToTopView scrollViewShouldScrollToTop:theScrollView];
	return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[m_BackToTopView scrollViewDidScroll:scrollView];
    
    //滑动关联table和历史table收起键盘
    if (scrollView==m_HistoryTableView || scrollView==m_RelationTableView) {
        [m_SearchBar resignFirstResponder];
    }
}

#pragma mark UITableView相关delegate和dataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==m_RelationTableView || tableView==m_HistoryTableView) {
		return 45;
    } else if (tableView==m_TableView) {
        return 100;
    } else if (tableView==m_SelectionTableView) {
        return 40;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView==m_RelationTableView)
    {
        //关联关键字
		if ([m_SearchRelationArray count]!=0)
        {
			RelationWordInfo *keyWordVO=[OTSUtility safeObjectAtIndex:[indexPath row] inArray:m_SearchRelationArray];
            m_DoTrackingFlag=2;
            [self searchByKeyword:[keyWordVO relationWord]];
		}
    }
    else if (tableView==m_HistoryTableView)
    {
        //历史列表
        if ([indexPath row]<[m_SearchHistoryArray count])
        {
            NSString *keyWord=[OTSUtility safeObjectAtIndex:[indexPath row] inArray:m_SearchHistoryArray];
            m_DoTrackingFlag=2;
            [self searchByKeyword:keyWord];
        }
    }
    else if (tableView==m_TableView)
    {
        ProductInfo *productVO = [OTSUtility safeObjectAtIndex:indexPath.row inArray:m_ProductArray];
//        if (productVO.isYihaodian && productVO.isYihaodian.intValue == 0)
//        {
            //更新最近浏览信息
//            [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadAddBrowse:) toTarget:self withObject:productVO];
//            DebugLog(@"enter 1mall!!!!!");
//            NSString *urlStr;
//            NSString* landingPageId;
//            if (productVO.promotionId) {
//                landingPageId = productVO.promotionId;
//            }else{
//                landingPageId = @"";
//            }
//            if ([GlobalValue getGlobalValueInstance].token == nil) {
//                urlStr = [URL_BASE_MALL_NO_ONE stringByAppendingFormat:@"%@/%@/%@?osType=30",productVO.productId,[GlobalValue getGlobalValueInstance].provinceId,landingPageId];
//            }else {
//                // 对 token 进行base64加密
//                NSData *b64Data = [GTMBase64 encodeData:[[GlobalValue getGlobalValueInstance].token dataUsingEncoding:NSUTF8StringEncoding]];
//                NSString* b64Str = [[[NSString alloc] initWithData:b64Data encoding:NSUTF8StringEncoding] autorelease];
//                
//                urlStr = [URL_BASE_MALL_NO_ONE stringByAppendingFormat:@"%@/%@/%@?token=%@&osType=30",productVO.productId,[GlobalValue getGlobalValueInstance].provinceId,landingPageId,b64Str];
//                
//            }
//            DebugLog(@"enterWap -- url is:\n%@",urlStr);
//            [SharedDelegate enterWap:3 invokeUrl:urlStr isClearCookie:YES];
//        }
//        else
//        {
            [self enterProductDetail:productVO];
//        }
        
    } else if (tableView==m_SelectionTableView)
    {
        [self searchBySelectionWithIndex:indexPath.row];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==m_RelationTableView)
    {
		if ([m_SearchRelationArray count]==0)
        {
			return 1;
		}
        else
        {
			return [m_SearchRelationArray count];
		}
    }
    else if (tableView==m_HistoryTableView)
    {
        return [m_SearchHistoryArray count]+1;
    }
    else if (tableView==m_TableView)
    {
        return [m_ProductArray count];
    }
    else if (tableView==m_SelectionTableView)
    {
        if (m_Flag==FLAG_CATEGORY) {
            return [m_CategoryArray count]+1;
        } else if (m_Flag==FLAG_SORT) {
            return [m_SortArray count];
        } else {
            return 0;
        }
    }
	return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==m_RelationTableView)
    {//关联关键字列表
		UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SearchRelationCell"];
		if (cell==nil)
        {
			cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SearchRelationCell"] autorelease];
            [cell setBackgroundColor:[UIColor whiteColor]];
		}
		if ([m_SearchRelationArray count]==0)
        {
			if ([indexPath row]==0) {
				[[cell textLabel] setText:@"无结果"];
				[[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
				[[cell detailTextLabel] setText:@""];
			}
		}
        else
        {
//			SearchKeywordVO *keyWordVO=[OTSUtility safeObjectAtIndex:[indexPath row] inArray:m_SearchRelationArray];
            RelationWordInfo *keyWordVO=[OTSUtility safeObjectAtIndex:[indexPath row] inArray:m_SearchRelationArray];
			[[cell textLabel] setText:keyWordVO.relationWord];
			[[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
//			[[cell detailTextLabel] setText:[NSString stringWithFormat:@"约%d条商品",keyWordVO.count]];
			[[cell detailTextLabel] setFont:[UIFont systemFontOfSize:15.0]];
		}
		return cell;
	}
    else if (tableView==m_HistoryTableView)
    {
        //历史列表
		UITableViewCell *cell;
		if ([indexPath row]<[m_SearchHistoryArray count])
        {
			cell=[tableView dequeueReusableCellWithIdentifier:@"SearchHistoryCell"];
            if (cell==nil) {
                cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchHistoryCell"] autorelease];
                [cell setBackgroundColor:[UIColor whiteColor]];
            }
            [[cell textLabel] setText:[OTSUtility safeObjectAtIndex:[indexPath row] inArray:m_SearchHistoryArray]];
			[[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
		} else {
            cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
            [cell setBackgroundColor:[UIColor whiteColor]];
            UIButton *clearBtn=[[UIButton alloc] initWithFrame:CGRectMake(105, 4, 110, 36)];
            [clearBtn setBackgroundImage:[UIImage imageNamed:@"gray_btn.png"] forState:UIControlStateNormal];
            [clearBtn setTitle:@"清空历史记录" forState:0];
            [clearBtn setTag:100];
            [clearBtn setTitleColor:[UIColor blackColor] forState:0];
            [clearBtn addTarget:self action:@selector(clearAllHistory:) forControlEvents:UIControlEventTouchUpInside];
            [clearBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [cell addSubview:clearBtn];
            [clearBtn release];
        }
		return cell;
    }
    else if (tableView==m_TableView)
    {
        CategoryProductCell *cell=(CategoryProductCell*)[tableView dequeueReusableCellWithIdentifier:@"SearchResultCell"];
        if (cell==nil)
        {
            cell=[[[CategoryProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchResultCell"] autorelease];
        }
        ProductInfo *productVO=(ProductInfo*)[OTSUtility safeObjectAtIndex:[indexPath row] inArray:m_ProductArray];
        
        // 商品名称
        cell.productNameLbl.text = productVO.name;
        [cell.the1MallLogo setHidden:YES];
   
        

        // 商品价格
        cell.priceLbl.text = [NSString stringWithFormat:@"￥%.2f", [productVO.price floatValue]];
        [cell.shoppingCountLbl setText:@"(0)"];

        
        if ([productVO.prescription intValue] == 14 || productVO.prescription.intValue == 16)
        {
            //如果是处方药
            [cell.operateBtn setFrame:CGRectMake(280, 38, 23, 19)];
            [cell.operateBtn setImage:[UIImage imageNamed:@"1mall_eye.png"] forState:0];
            [cell.operateBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [cell.operateBtn setUserInteractionEnabled:NO];
        }
        else
        {
            [cell.operateBtn setUserInteractionEnabled:YES];
            [cell.operateBtn addTarget:self action:@selector(accessoryButtonTap:withEvent:) forControlEvents:UIControlEventTouchUpInside];
            cell.operateBtn.frame=CGRectMake(270, 8, 50, 85);
            if (/*[productVO.canBuy isEqualToString:@"true"]*/ [productVO.status intValue] == 8 && productVO.stockNum > 0 )
            {
                [cell.operateBtn setImage:[UIImage imageNamed:@"product_cart.png"] forState:0];
            }
            else
            {
                [cell.operateBtn setImage:[UIImage imageNamed:@"product_cart_ni.png"] forState:0];
            }
        }
        
    
        [cell.giftLogo setHidden:YES];

        
        cell.imageView.image=[UIImage imageNamed:@"img_default.png"];

        [cell downloadImage:productVO.productImageUrl];
        
        
        //促销
        [cell showGift:productVO.hasGift];
        [cell showReduce:productVO.hasReduce];
        
        
        return cell;
        
        
        
        
        
/*
        //商品名称
        if (productVO.isYihaodian && productVO.isYihaodian.intValue == 0)
        {
            cell.productNameLbl.text = [NSString stringWithFormat:@"    %@",productVO.cnName];
            [cell.the1MallLogo setHidden:NO];
        }else{
            cell.productNameLbl.text = productVO.cnName;
            [cell.the1MallLogo setHidden:YES];
        }
        
        //市场价格
        //cell.marketPriceLbl.text=[NSString stringWithFormat:@"￥%.2f",[productVO.maketPrice floatValue]];
        //商品价格
        cell.priceLbl.text=[NSString stringWithFormat:@"￥%.2f",[productVO.price floatValue]];
        //促销信息
//        cell.hasCashLbl.text = productVO.hasCash;
        //商品库存
        NSString *canBuyStr;
        if ([productVO.canBuy isEqualToString:@"true"])
        {
            canBuyStr=@"有货";
        } else {
            canBuyStr=@"已售完";
        }
        if (productVO.experienceCount!=nil) {
            [cell.shoppingCountLbl setText:[NSString stringWithFormat:@"(%@)",productVO.experienceCount]];
        } else {
            [cell.shoppingCountLbl setText:@"(0)"];
        }
        for (NSUInteger i=0; i<5; i++) {
            UIImageView *subView=(UIImageView *)[cell.contentView viewWithTag:1000+i];
            if (i<[[productVO score] intValue]) {
                subView.image=[UIImage imageNamed:@"pentagon_Yellow.png"];
            }
        }
        cell.canBuyLbl.text=canBuyStr;
        //操作按钮
        if (productVO.isYihaodian && productVO.isYihaodian.intValue == 0) {
            [cell.operateBtn setFrame:CGRectMake(280, 38, 23, 19)];
            [cell.operateBtn setImage:[UIImage imageNamed:@"1mall_eye.png"] forState:0];
            [cell.operateBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [cell.operateBtn setUserInteractionEnabled:NO];
        }else{
            [cell.operateBtn setUserInteractionEnabled:YES];
            [cell.operateBtn addTarget:self action:@selector(accessoryButtonTap:withEvent:) forControlEvents:UIControlEventTouchUpInside];
            cell.operateBtn.frame=CGRectMake(270, 8, 50, 85);
            if ([productVO.canBuy isEqualToString:@"true"]) {
                [cell.operateBtn setImage:[UIImage imageNamed:@"product_cart.png"] forState:0];
            } else {
                [cell.operateBtn setImage:[UIImage imageNamed:@"product_cart_ni.png"] forState:0];
            }
        }
        
        //有赠品
        if ([[productVO hasGift] intValue]==1) {
            [cell.giftLogo setHidden:NO];
        } else {
            [cell.giftLogo setHidden:YES];
        }
        //商品图片
        cell.imageView.image=[UIImage imageNamed:@"defaultimg85.png"];
        if (productVO!=nil) {
            [cell downloadImage:productVO.miniDefaultProductUrl];
        }
        return cell;*/
    }
    else if (tableView==m_SelectionTableView)
    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (cell==nil)
        {
            cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectionCell"] autorelease];
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 40)];
            [imageView setTag:1];
            [imageView setImage:[UIImage imageNamed:@"cate_selection_arrow.png"]];
            [cell addSubview:imageView];
            [imageView release];
        }
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:16.0]];
        if (m_Flag==FLAG_CATEGORY)
        {
            if (indexPath.row==0)
            {
                [cell.textLabel setText:@"    全部分类"];
            }
            else
            {
//                SearchCategoryVO *searchCategoryVO=[OTSUtility safeObjectAtIndex:indexPath.row-1 inArray:m_CategoryArray];
                CategoryInfo *categoryInfo = m_CategoryArray[indexPath.row -1];
                
                [cell.textLabel setText:[NSString stringWithFormat:@"    %@",categoryInfo.name]];
            }
            
            int selectedIndex=0;
            if (m_CategoryId==0)
            {
                selectedIndex=0;
            }
            else
            {
                int i;
                for (i=0; i<[m_CategoryArray count]; i++)
                {
//                    SearchCategoryVO *searchCategoryVO=[OTSUtility safeObjectAtIndex:i inArray:m_CategoryArray];
                    CategoryInfo *categoryInfo = m_CategoryArray[i];
                    if ([categoryInfo.cid intValue]==m_CategoryId)
                    {
                        selectedIndex=i+1;
                        break;
                    }
                }
            }
            
            UIImageView *imageView=(UIImageView*)[cell viewWithTag:1];
            if (indexPath.row==selectedIndex)
            {
                [imageView setHidden:NO];
            }
            else
            {
                [imageView setHidden:YES];
            }
        } else if (m_Flag==FLAG_SORT) {
            [cell.textLabel setText:[NSString stringWithFormat:@"    %@",[OTSUtility safeObjectAtIndex:indexPath.row inArray:m_SortArray]]];
            int selectedIndex=0;
            switch (m_SortType) {
                case SORT_BY_DEFAULT:
                    selectedIndex=0;
                    break;
                case SORT_BY_SALE:
                    selectedIndex=1;
                    break;
                case SORT_BY_PRICE_ASC:
                    selectedIndex=2;
                    break;
                case SORT_BY_PRICE_DESC:
                    selectedIndex=3;
                    break;
                case SORT_BY_TIME:
                    selectedIndex=4;
                    break;
                default:
                    break;
            }
            UIImageView *imageView=(UIImageView*)[cell viewWithTag:1];
            if (indexPath.row==selectedIndex) {
                [imageView setHidden:NO];
            } else {
                [imageView setHidden:YES];
            }
        } else {
        }
        
        return cell;
    } else {
        UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==m_TableView)
    {
        if (indexPath.row==[m_ProductArray count]-1 && [m_ProductArray count]<m_ProductTotalCount)
        {
            if (!m_LoadingMore)
            {
                 m_LoadingMore=YES;
                
                [tableView loadingMoreWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40) target:self selector:@selector(getMoreProduct) type:UITableViewLoadingMoreForeIphone];
            }
        }
    }
}

#pragma mark - UIAlertView相关delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case ALERTVIEW_TAG_DELETE_CONFIRM:
            if (buttonIndex==1) {
                [self clearSearchHistory];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - UISearchBar相关delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [m_CancelButton setHidden:NO];
    [self showSearchView:m_SearchBar keyword:m_Keyword];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [m_CancelButton setHidden:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (m_Keyword!=nil) {
        [m_Keyword release];
    }
    m_Keyword=[[NSString alloc] initWithString:searchText];
    [self showSearchView:searchBar keyword:m_Keyword];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *keyword=[searchBar text];
    if (!keyword || [[keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]<1) {
        [AlertView showAlertView:nil alertMsg:@"搜索字段为空，请重新输入" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
        [searchBar resignFirstResponder];
        [self closeSearchHistoryAndRelationView];
        //关闭分类、排序
        [self selectionBlackBtnClicked:nil];
    } else {
        m_DoTrackingFlag=2;//二次搜索
        [self searchByKeyword:keyword];
    }
}


-(void)newThreadAddBrowse:(ProductVO *)productVO
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    BrowseService *bServ=[[[BrowseService alloc] init] autorelease];
    int rowcount = [bServ queryBrowseHistoryByIdCount:productVO.productId];
    @try {
        if (rowcount) {
            //productid存在则更新
            [bServ updateBrowseHistory:productVO provice:PROVINCE_ID];
        }
        else {
            [bServ saveBrowseHistory:productVO province:PROVINCE_ID];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefleshImmediately" object:nil];
    [pool drain];
}


-(void)releaseResource
{
    OTS_SAFE_RELEASE(m_SearchBar);
    OTS_SAFE_RELEASE(m_FilterButton);
    OTS_SAFE_RELEASE(m_CancelButton);
    OTS_SAFE_RELEASE(m_CategoryButton);
    OTS_SAFE_RELEASE(m_SortButton);
    OTS_SAFE_RELEASE(m_CategoryArrow);
    OTS_SAFE_RELEASE(m_SortArrow);
    OTS_SAFE_RELEASE(m_TableView);
    OTS_SAFE_RELEASE(m_NullView);
    OTS_SAFE_RELEASE(m_SelectionBackGroundButton);
    OTS_SAFE_RELEASE(m_SelectionTableView);
    OTS_SAFE_RELEASE(m_BackToTopView);
    OTS_SAFE_RELEASE(m_RelationTableView);
    OTS_SAFE_RELEASE(m_HistoryView);
    OTS_SAFE_RELEASE(m_HistoryTableView);
    OTS_SAFE_RELEASE(m_HistoryBlackView);
    OTS_SAFE_RELEASE(m_Keyword);
    OTS_SAFE_RELEASE(m_Attributes);
    OTS_SAFE_RELEASE(m_PriceRange);
    OTS_SAFE_RELEASE(m_Filter);
    OTS_SAFE_RELEASE(m_OriginalSearchResultVO);
    OTS_SAFE_RELEASE(m_SearchResultVO);
    OTS_SAFE_RELEASE(m_CategoryArray);
    OTS_SAFE_RELEASE(m_SortArray);
    OTS_SAFE_RELEASE(m_ProductArray);
    OTS_SAFE_RELEASE(m_FilterDictionary);
    OTS_SAFE_RELEASE(m_SearchHistoryArray);
    OTS_SAFE_RELEASE(m_SearchRelationArray);
    OTS_SAFE_RELEASE(m_GetKeywordsService);
    OTS_SAFE_RELEASE(isDianzhongDian);
    OTS_SAFE_RELEASE(cartAnimation);
}

- (void)viewDidUnload
{
    [self releaseResource];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc
{
    [self releaseResource];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




////////////药网加 获取本地分类
- (NSMutableArray*)getCateFromLocalByRootId:(NSString *)aRootId
{
    
    NSString *filename=[OTSUtility documentDirectoryWithFileName:@"SaveRootCate_130508.plist"];
    NSMutableArray *cateArr = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    DebugLog(@"cate from Local %@",cateArr);
    if (cateArr.count > 0)
    {
        NSMutableArray *resultArr = [NSMutableArray arrayWithArray:cateArr];
        [self filterCategory:resultArr rootId:aRootId];
        DebugLog(@"filer cate %@",resultArr);
        return resultArr;
    }
    return nil;
}
- (void)filterCategory:(NSMutableArray *)categoryArr rootId:(NSString *)aRootId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.parentId == %@",aRootId];
    [categoryArr filterUsingPredicate:predicate];
}


#pragma mark - 百分点
- (void)mobidea_Recs:(NSError *)error feedback:(id)feedback
{
    if ([feedback isKindOfClass:[NSArray class]])
    {
        NSMutableArray *productList = [[NSMutableArray alloc] init];
        
        NSArray *result = (NSArray *)feedback;
        for (NSDictionary *dic in result)
        {
            ProductInfo *product = [[ProductInfo alloc] init];
            product.productId = [NSString stringWithFormat:@"%d",[dic[@"iid"] integerValue]];
            product.productImageUrl = dic[@"img"];
            product.price = [NSString stringWithFormat:@"%.2f", [dic[@"price"] floatValue]];
            product.marketPrice = [NSString stringWithFormat:@"%.2f", [dic[@"mktp"] floatValue]];
            product.name = dic[@"name"];
            
            [productList addObject:product];
            [product release];
        }
        
        
        [_recommendView updateRecommendProducts:productList];
    }
}

#pragma mark - RecommendView Delegate
- (void)selectedRecommendProduct:(ProductInfo *)product
{
    [BfdAgent feedback:nil recommendId:kRCSearch itemId:product.productId options:nil];
    
    [self enterProductDetail:product];
}




@end
