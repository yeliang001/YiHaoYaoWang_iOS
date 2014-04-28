//
//  GroupBuyHomePage.m
//  TheStoreApp
//
//  Created by jiming huang on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GroupBuyHomePage.h"
#import "GroupBuyService.h"
#import "BrowseService.h"
#import "GlobalValue.h"
#import "GrouponCategoryVO.h"
#import "GrouponVO.h"
#import "StrikeThroughLabel.h"
#import "GroupBuyProductDetail.h"
#import <QuartzCore/QuartzCore.h>
#import "DataController.h"
#import "AlertView.h"
#import "GrouponAreaVO.h"
#import "OTSAlertView.h"
#import "OTSActionSheet.h"
#import "OTSNaviAnimation.h"
#import "TheStoreAppAppDelegate.h"
#import "OTSLoadingView.h"
#import "UIScrollView+OTS.h"
#import "GrouponSortAttributeVO.h"
#import "OTSMfImageCache.h"
#import "NSData+Base64.h"
#import "GTMBase64.h"
#import "OTSServiceHelper.h"
#import "OTSImageView.h"
#import "DoTracking.h"
#define THREAD_STATUS_GET_CATEGORY                  1
#define THREAD_STATUS_GET_PRODUCT_LIST              2
#define THREAD_STATUS_GET_AREA_LIST                 3
#define THREAD_STATUS_GET_GROUPBUY_AREAR_ID         4

#define TAG_PRODUCT_IMAGE_VIEW                      100
#define TAG_UNSUPPORT_AREA_ALERTVIEW                101
#define TAG_AREA_NULL_ALERTVIEW                     102
#define TAG_CATEGORY_NULL_ALERTVIEW                 103

#define LOADMORE_HEIGHT                             40


#define URL_BASE_MALL_NO_ONE                        @"http://m.1mall.com/mw/groupdetail/"



@interface GroupBuyHomePage ()
{
    dispatch_queue_t _networkQueue;         // 网络请求队列
}
@property (nonatomic, retain)   UINib       *cellNib;
@property (retain)              UIImage     *groupBuyCellDefaultImage;
@property (retain) NSNumber *groupOnAreaID;
@property (retain) NSArray *categoryList;
- (void)setupSortFilterView;
@end


@implementation GroupBuyHomePage
@synthesize m_TableView, m_CurrentProducts
, m_sortTapeArray
, cellNib = _cellNib
, groupBuyCellDefaultImage = _groupBuyCellDefaultImage;
@synthesize groupOnAreaID = _groupOnAreaID;
@synthesize categoryList = _categoryList;



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
    
    _networkQueue  = dispatch_queue_create([[NSString stringWithFormat:@"%@.%@", [self.class description], self] UTF8String], NULL);
    
    self.cellNib = [UINib nibWithNibName:@"GroupBuyHomePageCell" bundle:nil];
    self.groupBuyCellDefaultImage = [UIImage imageNamed:@"defaultimg85.png"];
    
    [self setupSortFilterView];
    m_CurrentSelectedBtn=nil;
    m_CurrentCategoryIndex=0;
	
    m_PageIndex=1;
    m_FirstGetCategory=YES;
	hadSawCategoryDic=[[NSMutableDictionary alloc] init];
    m_LoadingMoreLabel=[[LoadingMoreLabel alloc] initWithFrame:CGRectMake(0, 0, 320, LOADMORE_HEIGHT)];
	[m_CategoryListView setScrollsToTop:NO];
	[m_TableView setScrollsToTop:YES];
    m_TableView.showsVerticalScrollIndicator = YES;
	
	if (m_refreshHeaderView == nil) {
		m_refreshHeaderView= [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - m_TableView.bounds.size.height, 320, m_TableView.bounds.size.height)];
		m_refreshHeaderView.delegate = self;
		[m_TableView addSubview:m_refreshHeaderView];
	}
	[m_refreshHeaderView refreshLastUpdatedDate];
    //从缓存获取团购分类
    self.categoryList = [self getCategoryListFromLocal];
    [self updateCategoryList];
    //获取位置
    [self getSelectedLocation];
	
	backView = [[BackToTopView alloc] init];
	backView.scrollScreenHeight = 367;
	[self.view addSubview:backView];
    
    //省份切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(provinceChanged:) name:@"ProvinceChanged" object:nil];
}

-(void)provinceChanged:(NSNotification *)notification
{
    NSString *string=[notification object];
    [m_LocationBtn setTitle:string forState:UIControlStateNormal];
    
    //根据省份名称获取省份id
	NSString *listPath=[[NSBundle mainBundle] pathForResource:@"ProvinceID" ofType:@"plist"];
	NSMutableDictionary *provinceDic=[[[NSMutableDictionary alloc] initWithContentsOfFile:listPath] autorelease];
    int provinceId=[[provinceDic objectForKey:string] intValue];
    [[GlobalValue getGlobalValueInstance] setProvinceId:[NSNumber numberWithInt:provinceId]];
    
    //获取团购地区ID
    m_CurrentState=THREAD_STATUS_GET_GROUPBUY_AREAR_ID;
    [self setUpThread:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//获取用户选择的位置信息
-(void)getSelectedLocation
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *filename=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"SaveProvinceId.plist"];
    NSMutableArray *theArray=[[NSMutableArray alloc] initWithContentsOfFile:filename];
    if ([theArray count]==0) {
        [m_LocationBtn setTitle:@"上海" forState:UIControlStateNormal];
    } else {
        [m_LocationBtn setTitle:[NSString stringWithFormat:@"%@",[theArray objectAtIndex:0]] forState:UIControlStateNormal];
    }
    [theArray release];
    //获取团购地区ID
    m_CurrentState=THREAD_STATUS_GET_GROUPBUY_AREAR_ID;
    [self setUpThread:YES];
}
#pragma mark 排序 sort yj

- (void)getGrouponSortAttributeVOListOnNewThread{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    GroupBuyService *service=[[GroupBuyService alloc] init];
    @try {
        NSArray *tempArray=[service getGroupOnSortAttribute:[GlobalValue getGlobalValueInstance].trader AreaId:self.groupOnAreaID];
		if (m_sortTapeArray.count) {
			[m_sortTapeArray removeAllObjects];
		}
		if (tempArray.count) {
			[m_sortTapeArray addObjectsFromArray:tempArray];
		}
    } @catch (NSException * e) {
    } @finally {
		[m_SortFilterView reloadData];
    }
    [service release];
    [pool drain];
	
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
	
	if ([gestureRecognizer.view isEqual:m_SortCoverView]) {
		if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
			UISwipeGestureRecognizer*swipe=(UISwipeGestureRecognizer*)gestureRecognizer;
			if (swipe.direction==UISwipeGestureRecognizerDirectionRight&&b_IsShowSortFilter==YES) {
				[self showSortViewSwith];
			}
		}
		if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
			[self showSortViewSwith];
		}
	}
	if ([gestureRecognizer.view isEqual:m_TableView]) {
		if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
			UISwipeGestureRecognizer*swipe=(UISwipeGestureRecognizer*)gestureRecognizer;
			if (swipe.direction==UISwipeGestureRecognizerDirectionLeft&&b_IsShowSortFilter==NO){
				[self showSortViewSwith];
			}
		}
	}
	return YES;
	
}


- (void)setupSortFilterView
{
//	m_sortTapeArray=[[NSMutableArray alloc] initWithObjects:@"排序(默认)",@"人气最高",@"折扣最多",@"价格最低",@"最新发布",nil];
	self.m_sortTapeArray=[[[NSMutableArray alloc] init] autorelease];
	UIViewController* tabVC=SharedDelegate.tabBarController;


	m_SortCoverView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
	m_SortCoverView.backgroundColor=[UIColor clearColor];
	[tabVC.view  addSubview:m_SortCoverView];
	[m_SortCoverView release];
	m_SortCoverView.hidden=YES;
	
	
	
//手势识别
	UISwipeGestureRecognizer* ges=[[UISwipeGestureRecognizer alloc] init];
	ges.direction=UISwipeGestureRecognizerDirectionLeft;
	ges.delegate=self;
	[m_SortCoverView addGestureRecognizer:ges];
	[ges release];
    
	
	UISwipeGestureRecognizer* gesL=[[UISwipeGestureRecognizer alloc] init];
	gesL.direction=UISwipeGestureRecognizerDirectionLeft;
	gesL.delegate=self;	
	[m_TableView addGestureRecognizer:gesL];
	[gesL release];
	
	UISwipeGestureRecognizer* gesR=[[UISwipeGestureRecognizer alloc] init];
	gesR.direction=UISwipeGestureRecognizerDirectionRight;
	gesR.delegate=self;
	[m_SortCoverView addGestureRecognizer:gesR];
	[gesR release];
	
	UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc] init];
	tap.delegate=self;
	[m_SortCoverView addGestureRecognizer:tap];
	[tap release];
	
	b_IsShowSortFilter=NO;
	m_SortFilterView=[[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 20, 136, ScreenHeight) style:UITableViewStylePlain];
    m_SortFilterView.backgroundColor=[UIColor clearColor];
    m_SortFilterView.tableFooterView=[[[UIView alloc] init] autorelease];
    m_SortFilterView.delegate=self;
    m_SortFilterView.dataSource=self;
    m_SortFilterView.separatorColor=OTS_COLOR_FROM_RGB(0xd8d8d8);
    m_SortFilterView.scrollEnabled=NO;
    [m_SortFilterView setScrollsToTop:NO];
    [SharedDelegate.window addSubview:m_SortFilterView];
    [SharedDelegate.window insertSubview:m_SortFilterView belowSubview:tabVC.view];
    m_SortFilterView.hidden=YES;
    sortType=0;
    
	if (![SharedDelegate.window viewWithTag:1222]) {
		UIImageView*imgv=[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-136, 20, 136, ScreenHeight)];
		imgv.image=[UIImage imageNamed:@"groupSortBg.png"];
		imgv.tag=1222;
		[SharedDelegate.window addSubview:imgv];
		[SharedDelegate.window insertSubview:imgv belowSubview:m_SortFilterView];
		[imgv release];
		imgv.hidden=YES;
	}
	
}
- (void)refreshTableViewData{
    [m_refreshHeaderView setState:EGOOPullRefreshLoading];
    DebugLog(@"scrollView.contentInset.top :%f", m_TableView.contentInset.top);// it's always 0 here
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [m_TableView setContentOffset:CGPointMake(0, -60)];
    [UIView commitAnimations];
    if ([self respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
        [self egoRefreshTableHeaderDidTriggerRefresh:m_refreshHeaderView];
    }
}
-(void)moveLayer:(CALayer*)layer to:(CGPoint)point{ 
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
	animation.fromValue = [layer valueForKey:@"position"];  
	animation.toValue = [NSValue valueWithCGPoint:point];

    layer.position = point;   
	[layer addAnimation:animation forKey:@"position"]; 
}
- (IBAction)showSortViewSwith{
	UIViewController* tabVC=SharedDelegate.tabBarController;
	UIView*v=[SharedDelegate.window viewWithTag:1222];
	if (!b_IsShowSortFilter) {
		//排序显示
		b_IsShowSortFilter=YES;
		m_SortCoverView.hidden=NO;
		[m_SortFilterView setHidden:NO];
		v.hidden=NO;
		[self moveLayer:tabVC.view.layer to:CGPointMake(ScreenWidth/2-134, ScreenHeight/2)];
		[self moveLayer:m_SortFilterView.layer to:CGPointMake(387-134, ScreenHeight/2+(ScreenHeight-ApplicationHeight))];

	}else {
		//排序隐藏了
		b_IsShowSortFilter=NO;
		m_SortCoverView.hidden=YES;
		[self moveLayer:tabVC.view.layer to:CGPointMake(ScreenWidth/2, ScreenHeight/2)];
		[self moveLayer:m_SortFilterView.layer to:CGPointMake(380, ScreenHeight/2+(ScreenHeight-ApplicationHeight))];

		[self performSelector:@selector(cleanFilter) withObject:nil afterDelay:0.4];
	}
	 
}
- (void)cleanFilter{
	[m_SortFilterView setHidden:YES];
	UIView*v=[SharedDelegate.window viewWithTag:1222];
	v.hidden=YES;
}
#pragma mark Action相关部分
//返回1号店首页
-(IBAction)homePageBtnClicked:(id)sender
{
	HomePage *homePage = [SharedDelegate.tabBarController.viewControllers objectAtIndex:0];
	[homePage setUniqueScrollToTopFor:homePage->m_ScrollView];
    [self.view.superview.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:@"Reveal"];
    [self removeSelf];
}

-(IBAction)locationBtnClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddSwitchProvinceForTabBar" object:nil];
}

-(IBAction)categoryButtonClicked:(id)sender
{
    UIButton *button=sender;
    if(m_CurrentSelectedBtn!=button) {
        //缓存4个属性
        NSNumber *oldKey=nil;
        if ([m_CurrentSelectedBtn tag]==0) {
            oldKey=[NSNumber numberWithInt:-1];
        } else {
            oldKey=[[self.categoryList objectAtIndex:[m_CurrentSelectedBtn tag]-1] nid];
        }
        NSMutableArray* tempArray=[[NSMutableArray alloc] init];
        NSMutableArray* tempProArray=[[NSMutableArray alloc] initWithArray:m_CurrentProducts];
        [tempArray addObject:tempProArray];
        [tempProArray release];
        [tempArray addObject:[NSNumber numberWithInt:m_ProductTotalNum]];
        [tempArray addObject:[NSNumber numberWithInt:m_PageIndex]];
        [tempArray addObject:[NSNumber numberWithFloat:[m_TableView contentOffset].y]];
        [hadSawCategoryDic setObject:tempArray forKey:oldKey];
        [tempArray release];
        
        //分类按钮动画
        [m_CurrentSelectedBtn setBackgroundImage:nil forState:UIControlStateNormal];
		[m_CurrentSelectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        m_CurrentSelectedBtn=button;
		[button setBackgroundImage:[UIImage imageNamed:@"groupBuy_red_btn.png"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        m_CurrentCategoryIndex=button.tag;
		if (m_CategoryListView.contentSize.width>320 && m_CategoryListView.contentOffset.x<=m_CategoryListView.contentSize.width-320) {
			if (button.frame.origin.x>m_CategoryListView.contentSize.width-320) {
				[m_CategoryListView setContentOffset:CGPointMake(m_CategoryListView.contentSize.width-320,0) animated:YES];
			} else {
				[m_CategoryListView setContentOffset:CGPointMake(button.frame.origin.x-3, 0) animated:YES];
			}
		}
		
        //获取团购商品列表
        NSNumber *newKey=nil;
        if (m_CurrentCategoryIndex == 0) {//全部分类
            newKey=[NSNumber numberWithInt:-1];
        } else {//其他分类
            newKey=[[self.categoryList objectAtIndex:m_CurrentCategoryIndex-1] nid];
        }
        if ([hadSawCategoryDic objectForKey:newKey] != nil) {//有缓存
//            if (m_CurrentProducts!=nil) {
//                [m_CurrentProducts release];
//            }
            self.m_CurrentProducts = [[[NSMutableArray alloc] initWithArray:[[hadSawCategoryDic objectForKey:newKey] objectAtIndex:0]] autorelease];
            m_ProductTotalNum=[[[hadSawCategoryDic objectForKey:newKey] objectAtIndex:1] intValue];
            m_PageIndex=[[[hadSawCategoryDic objectForKey:newKey] objectAtIndex:2] intValue];
            m_ScrollViewOffset=[[[hadSawCategoryDic objectForKey:newKey] objectAtIndex:3] floatValue];
            [m_TableView setContentOffset:CGPointMake(0, m_ScrollViewOffset)];
            [self updateProductTableView];
            [m_LoadingMoreLabel reset];
        } else {//无缓存
            m_PageIndex=1;
            m_CurrentState=THREAD_STATUS_GET_PRODUCT_LIST;
            [self setUpThread:YES];
        }
    }
}

-(void)updateCategoryList
{
    NSArray *mSubViews=[m_CategoryListView subviews];
    for (UIView *view in mSubViews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    if (self.categoryList==nil) {
        return;
    }
    //add sub views
    NSInteger buttonX=11;
    NSInteger buttonWidth=50;
    NSInteger buttonHeight=36;
    UIImage *redButtonImg=[UIImage imageNamed:@"groupBuy_red_btn.png"];
	
    //"全部"按钮
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(buttonX,0,buttonWidth,buttonHeight)];
    [button setTag:0];
    [button setBackgroundColor:[UIColor clearColor]];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setBackgroundImage:redButtonImg forState:UIControlStateNormal];
	m_CurrentSelectedBtn=button;
	
    [[button titleLabel] setFont:[UIFont systemFontOfSize:15.0]];
    [button setTitle:@"全部" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [m_CategoryListView addSubview:button];
    [button release];
    //其他按钮
    buttonX+=buttonWidth+3;
    NSInteger i;
    
    int catCount = self.categoryList.count;
    for (i=0; i<catCount; i++) {
        GrouponCategoryVO *categoryVO=[self.categoryList objectAtIndex:i];
        buttonWidth=0;
        buttonHeight=36;
        NSString *categoryName=[categoryVO name];
        switch ([categoryName length]) {
            case 2: {
                buttonWidth=50;
                break;
            }
            case 3:
                buttonWidth=58;
                break;
            case 4:
                buttonWidth=67;
                
                break;
            case 5: {
                buttonWidth=76;
                break;
            }
            default: {
                break;
            }
        }
        
        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(buttonX,0,buttonWidth,buttonHeight)];
        [button setTag:i+1];
        [button setBackgroundColor:[UIColor clearColor]];
       /* if ([[categoryVO nid] intValue]==101) {//掌上专享
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundImage:redButtonImg forState:UIControlStateNormal];
            m_CurrentSelectedBtn=button;
        } else {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setBackgroundImage:nil forState:UIControlStateNormal];
        }*/
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[button setBackgroundImage:nil forState:UIControlStateNormal];
		
		[[button titleLabel] setFont:[UIFont systemFontOfSize:15.0]];
        [button setTitle:categoryName forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [m_CategoryListView addSubview:button];
        [button release];
        
        buttonX+=buttonWidth+3;
        
        if (buttonX>320) {
            NSInteger contentWidth=buttonX+2;
            [m_CategoryListView setContentSize:CGSizeMake(contentWidth, 34)];
        } else {
            [m_CategoryListView setContentSize:CGSizeMake(320, 34)];
        }
    }
    [m_CategoryListView setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    //复位tableview
    [m_TableView setContentOffset:CGPointZero animated:NO];
}

-(void)updateProductTableView
{
    [m_TableView setContentSize:CGSizeMake(320, 100*[m_CurrentProducts count])];
    [m_LoadingMoreLabel reset];
    [m_TableView reloadData];
    
    //[self otsDetatchMemorySafeNewThreadSelector:@selector(downloadProductsImage) toTarget:self withObject:nil];
    
//    [self performInThreadBlock:^{
//        [self downloadProductsImage];
//    }];
    
    if (isReloading) {
        [self doneLoadingTableViewData];
    }
}

//不支持地区的团购
-(void)unsupportGroupBuyArea
{
    OTSAlertView *alert = [[OTSAlertView alloc]initWithTitle:nil message:@"不支持此地区的团购" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alert retainDelegate];
    
    [alert setTag:TAG_UNSUPPORT_AREA_ALERTVIEW];
    [alert show];
    [alert release];
    alert=nil;
}

-(void)grouponAreaIsNull
{
    OTSAlertView *alert = [[OTSAlertView alloc]initWithTitle:nil message:@"网络异常，请检查网络配置..." delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alert retainDelegate];
    
    [alert setTag:TAG_AREA_NULL_ALERTVIEW];
    [alert show];
    [alert release];
    alert=nil;
}

-(void)categoryListIsNull
{
    if (m_FirstGetCategory) {
        OTSAlertView *alert = [[OTSAlertView alloc]initWithTitle:nil message:@"网络异常，请检查网络配置..." delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert retainDelegate];
        
        [alert setTag:TAG_CATEGORY_NULL_ALERTVIEW];
        [alert show];
        [alert release];
        alert=nil;
        m_FirstGetCategory=NO;
    } else {
        [AlertView showAlertView:nil alertMsg:@"网络异常，请检查网络配置..." buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
    }
}

-(void)productListIsNull
{
    [AlertView showAlertView:nil alertMsg:@"网络异常，请检查网络配置..." buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
}

-(void)getMoreProduct
{
    m_CurrentState=THREAD_STATUS_GET_PRODUCT_LIST;
    [self setUpThread:NO];
}

#pragma mark 新线程获取网络数据
//新线程下载商品图片
//-(void)downloadProductsImage
//{
//    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
//    NSArray *theArray = [[NSArray alloc] initWithArray:m_CurrentProducts];
//
//    for(int i = 0;i < [theArray count];i++)
//    {
//        GrouponVO *grouponVO = [theArray objectAtIndex:i];
//        NSMutableString *fileName = [NSMutableString stringWithFormat:@"group_mini_%@",[grouponVO nid]];
//        
//        NSData* data = [DataController applicationDataFromFile:fileName];
//        if (data || grouponVO.miniImageUrl == nil)
//        {
//            continue;
//        }
//        
//		NSURL * productImgUrl = [NSURL URLWithString:grouponVO.miniImageUrl];
//		data = [NSData dataWithContentsOfURL:productImgUrl];
//		
//		[DataController writeApplicationData:data name:fileName];
//	}
//    
//    [theArray release];
//    [pool drain];
//}

#pragma mark 线程相关部分
//建立线程
-(void)setUpThread:(BOOL)showLoading 
{
	if (!m_ThreadIsRunning) 
    {
		m_ThreadIsRunning = YES;
		//[[NSNotificationCenter defaultCenter] postNotificationName:@"GrouponShowLoading" object:[NSNumber numberWithBool:showLoading]];
        
//        if (requestCoverView==nil) {
//            requestCoverView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
//            [self.view addSubview:requestCoverView];
//            requestCoverView.backgroundColor=[UIColor clearColor];
//            [requestCoverView release];
//        }else {
//            [self.view bringSubviewToFront:requestCoverView];
//        }
//        requestCoverView.hidden=NO;
        
        [self.loadingView blockView:self.view];
        
        if (showLoading)
        {   
            [self showLoading];
        }
        
		//[self otsDetatchMemorySafeNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
        [NSThread detachNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
//        dispatch_async(_networkQueue, ^{
//            [self startThread];
//        });
	}
}



//开启线程
-(void)startThread {
	while (m_ThreadIsRunning) {
		@synchronized(self) {
            switch (m_CurrentState) {
                case THREAD_STATUS_GET_GROUPBUY_AREAR_ID: {//获取团购地区id
                    
                    __block NSNumber *tempNumber = nil;

                    [self tryCatch:^{
                        tempNumber = [[OTSServiceHelper sharedInstance]
                                      getGrouponAreaIdByProvinceId:[GlobalValue getGlobalValueInstance].trader
                                      provinceId:[GlobalValue getGlobalValueInstance].provinceId];
                    }];
                    
                    self.groupOnAreaID = tempNumber;
                    self.groupOnAreaID = [self.groupOnAreaID isKindOfClass:[NSNull class]] ? nil : self.groupOnAreaID;
                    
                    BOOL isGroupOnAreaIdOK = (self.groupOnAreaID && self.groupOnAreaID.intValue != -99);
                    
                    if (isGroupOnAreaIdOK)
                    {
                        m_CurrentState = THREAD_STATUS_GET_CATEGORY;
                    }
                    else
                    {
                        [self stopThread];
                    }
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (self.groupOnAreaID == nil)
                        {
                            [self grouponAreaIsNull];
                        }
                        else if ([self.groupOnAreaID intValue] == -99)
                        {
                            [self unsupportGroupBuyArea];
                        }
                        
                    });
                }
                    break;
                    
                case THREAD_STATUS_GET_CATEGORY: {//获取团购分类列表
                    
                    __block NSArray *tempArray = nil;
                    
                    [self tryCatch:^{
                        
                        [self getGrouponSortAttributeVOListOnNewThread];
                        tempArray = [[OTSServiceHelper sharedInstance]
                                     getGrouponCategoryList:[GlobalValue getGlobalValueInstance].trader
                                     areaId:self.groupOnAreaID]; 
                    }];
                    
                    self.categoryList = tempArray;
                    self.categoryList = [self.categoryList isKindOfClass:[NSNull class]] ? nil : self.categoryList;
                    
                    if (self.categoryList == nil)
                    {
                        [self stopThread];
                    }
                    else
                    {
                        m_CurrentCategoryIndex=0;
                        m_PageIndex=1;
                        m_CurrentState = THREAD_STATUS_GET_PRODUCT_LIST;
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (self.categoryList)
                        {
                            [self saveCategoryListToLocal];
                        }
                        
                        if (self.categoryList == nil)
                        {
                            [self categoryListIsNull];
                        }
                        else
                        {
                            m_FirstGetCategory = NO;
                            [self updateCategoryList];
                        }
                        
                    });
                }
                    break;
                    
                case THREAD_STATUS_GET_PRODUCT_LIST: {//获取团购商品列表
                    
                    __block Page *tempPage = nil;
					NSNumber *categoryId = [NSNumber numberWithInt:-1];
                    
                    if (m_CurrentCategoryIndex > 0)
                    {
                        categoryId = [[OTSUtility safeObjectAtIndex:m_CurrentCategoryIndex - 1
                                                            inArray:self.categoryList ] nid];
                    }
                    
                    [self tryCatch:^{
                        
                        tempPage = [[OTSServiceHelper sharedInstance]
                                    getCurrentGrouponList:[GlobalValue getGlobalValueInstance].trader
                                    areaId:self.groupOnAreaID categoryId:categoryId
                                    sortType:[NSNumber numberWithInt:sortType]
                                    siteType:[NSNumber numberWithInt:0]
                                    currentPage:[NSNumber numberWithInt:m_PageIndex]
                                    pageSize:[NSNumber numberWithInt:10]];
                        [tempPage retain];
                        
                    }];
                    // 需传入额外的areaId, categoryId
                    JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_GroupList extraPrama:self.groupOnAreaID, categoryId, nil]autorelease];
                    [DoTracking doJsTrackingWithParma:prama];
                    
                    [self stopThread];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [tempPage autorelease];
                        tempPage = [tempPage isKindOfClass:[NSNull class]] ? nil : tempPage;
                        if (tempPage == nil)
                        {
                            [self productListIsNull];
                        }
                        else
                        {
							if (m_PageIndex == 1)
                            {
                                self.m_CurrentProducts = [NSMutableArray array];
							}
                            
                            [self.m_CurrentProducts addObjectsFromArray:tempPage.objList];
                            
							m_ProductTotalNum = tempPage.totalSize.intValue;
							m_PageIndex++;
                            [self updateProductTableView];
                        }
                        [m_LoadingMoreLabel reset];
                        
                    });
                }
                    break;
            
                default:
                    break;
            }
		}
	}
}

//停止线程
-(void)stopThread 
{
	m_ThreadIsRunning = NO;
	m_CurrentState = -1;
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"GrouponHideLoading" object:nil];
    //[[OTSGlobalLoadingView sharedInstance] hide];
    //requestCoverView.hidden=YES;
    
    [self.loadingView hide];
}

#pragma mark alertView相关delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch ([alertView tag]) {
        case TAG_UNSUPPORT_AREA_ALERTVIEW: {
            [self homePageBtnClicked:nil];
            break;
        }
        case TAG_AREA_NULL_ALERTVIEW: {
            [self homePageBtnClicked:nil];
            break;
        }
        case TAG_CATEGORY_NULL_ALERTVIEW: {
            [self homePageBtnClicked:nil];
            break;
        }
        default:
            break;
    }
}
#pragma mark 下拉刷新操作

- (void)reloadTableViewDataSource{
	m_CurrentState = THREAD_STATUS_GET_PRODUCT_LIST;
	[self setUpThread:NO];
	isReloading = YES;
}

- (void)doneLoadingTableViewData{
	isReloading = NO;
	[m_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:m_TableView];
}

#pragma mark scrollView相关delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[backView scrollViewDidScroll:scrollView];
	[m_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
	if (m_CurrentProducts==nil || [m_CurrentProducts count]>=m_ProductTotalNum) {
        return;
    }
    [m_LoadingMoreLabel scrollViewDidScroll:scrollView selector:@selector(getMoreProduct) target:self];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[backView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
	[m_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)theScrollView{
	[backView scrollViewDidEndDecelerating:theScrollView];
}
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
	[backView scrollViewShouldScrollToTop:scrollView];
	return YES;
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return isReloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed
}

#pragma mark tableView相关delegate和datasource
-(id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView==m_SortFilterView)
    {
		static NSString*sortIdent=@"sort";
		UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:sortIdent];
		if (cell==nil) {
			cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sortIdent]autorelease];
		}
		//issue #4791
		GrouponSortAttributeVO* vo=(GrouponSortAttributeVO*)[m_sortTapeArray objectAtIndex:indexPath.row];
        if ([vo isKindOfClass:[GrouponSortAttributeVO class]]) {
            cell.textLabel.text=vo.attrName;
        }
		if (sortType==indexPath.row) {
			cell.textLabel.textColor=[UIColor colorWithRed:192.0/255.0 green:0.0/255.0 blue:13.0/255.0 alpha:1];
			cell.accessoryView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redCheckMark.png"]] autorelease];
		}else {
			cell.textLabel.textColor=OTS_COLOR_FROM_RGB(0x333333);
			cell.accessoryView=nil;
		}
		cell.textLabel.font=[UIFont systemFontOfSize:14];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		return cell ;
	}
    
    NSInteger index=[indexPath row];
    if (m_CurrentProducts==nil||[m_CurrentProducts count]==0) 
    {
        return [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 50)] autorelease];
    }
    
    else if (([m_CurrentProducts count]<m_ProductTotalNum) 
             && (index==[m_CurrentProducts count])) 
    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"loadMore"];
        if (cell==nil) {
            cell=[[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, LOADMORE_HEIGHT)] autorelease];
            [cell setBackgroundColor:[UIColor whiteColor]];
            [cell addSubview:m_LoadingMoreLabel];
        }
        return cell;
    }
    
    // NOTICE:other type cell returned, the rest is group on cell
    
    UITableViewCell * cell = [[_cellNib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    
    GrouponVO *grouponVO=[m_CurrentProducts objectAtIndex:index];
    
    //团购商品图片
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
//    NSString *fileName = [NSString stringWithFormat:@"group_mini_%@",[grouponVO nid]];
    [[cell viewWithTag:10086] removeFromSuperview];
    
//    OTSNetworkImageView* localIV = [[[OTSNetworkImageView alloc] initWithFrame:imageView.frame fileName:fileName defaultImage:self.groupBuyCellDefaultImage imageUrl:grouponVO.miniImageUrl] autorelease];
    OTSImageView* localIV=[[[OTSImageView alloc] initWithFrame:imageView.frame] autorelease];
    [localIV loadImgUrl:grouponVO.miniImageUrl];
//    [localIV setImageWithURL:[NSURL URLWithString:grouponVO.miniImageUrl] refreshCache:NO placeholderImage:[UIImage imageNamed:@"defaultimg85.png"]];
    
//    [OTSMfImageCache tryLooseWeight];
//    UIImage* catchedImage = [OTSMfImageCache imageForKey:fileName];
//    if (catchedImage)
//    {
//        localIV.image = catchedImage;
//    }
//    else
//    {
//        [localIV loadCached:YES];
//    }
    
    localIV.tag = 10086;
    [cell addSubview:localIV];
    [imageView removeFromSuperview];
    
    //团购商品名称
 //   [grouponVO setSiteType:[NSNumber numberWithInt:2]];
    
    NSString *name=[NSString stringWithFormat:@"【专享】%@",[grouponVO name]];
    NSString *nameStr;
    UILabel *label=(UILabel*)[cell viewWithTag:101];
    UIImageView *the1MallImage=(UIImageView *)[cell viewWithTag:107];
    if ([[grouponVO categoryId] intValue]==101) {//掌上专享
        //[label setText:name];
        //[the1MallImage setHidden:NO];
        nameStr = name;
    } else {
       // [label setText:[grouponVO name]];
       // [the1MallImage setHidden:YES];
        nameStr = [grouponVO name];
    }
    [the1MallImage setHidden:YES];
    [label setText:nameStr];
    // 不区分1mall商品和1号店商品
//    if ([grouponVO.siteType intValue] == 2) {
//        [the1MallImage setHidden:NO];
//        [label setText:[NSString stringWithFormat:@"    %@",nameStr]];
//    }else {
//        [the1MallImage setHidden:YES];
//        [label setText:nameStr];
//    }
    //团购价格label
    label=(UILabel*)[cell viewWithTag:102];
    [label setText:[NSString stringWithFormat:@"￥%.2f",[[grouponVO price] floatValue]]];
    //原价label
    CGFloat oldPrice=[[[grouponVO productVO] price] floatValue];
    int productNumber=0;
    if ([grouponVO peopleNumber]!=nil) {
        productNumber=[[grouponVO peopleNumber] intValue];
    }
    if (oldPrice > 0) {
        StrikeThroughLabel *oldPriceLabel=(StrikeThroughLabel *)[cell viewWithTag:103];
        [oldPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",oldPrice]];
    }
    
    //购买数量label
    label=(UILabel*)[cell viewWithTag:106];
    [label setText:[NSString stringWithFormat:@"%d件已购买",productNumber]];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView==m_SortFilterView) {
		return m_sortTapeArray.count;
	}
    if (m_CurrentProducts==nil || [m_CurrentProducts count]==0) {
        return 0;
    } else if ([m_CurrentProducts count]<m_ProductTotalNum) {
        return [m_CurrentProducts count]+1;
    } else {
        return [m_CurrentProducts count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView==m_SortFilterView) {
		return 40;
	}
    if (m_CurrentProducts==nil || [m_CurrentProducts count]==0) {
        return 0;
    } else if ([indexPath row]<[m_CurrentProducts count]) {
        return 100;
    } else {
        return LOADMORE_HEIGHT;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中颜色
//------如果筛选露出，则不触发点击 yj	 //
//	if (b_IsShowSortFilter) {	 //
//		[self showSortViewSwith];//
//		return;	                 //
//	}							 //
//-----
	if (tableView==m_SortFilterView) {
        m_PageIndex=1;
		GrouponSortAttributeVO*vo=(GrouponSortAttributeVO*)[m_sortTapeArray objectAtIndex:indexPath.row];
		sortType=[vo.attrId intValue];
		[m_SortFilterView reloadData];
		[self refreshTableViewData];
		[self showSortViewSwith];
		NSString* sortBtnTit=[vo.attrName  substringToIndex:2];
		[m_sortBtn setTitle:sortBtnTit forState:UIControlStateNormal];
        [hadSawCategoryDic removeAllObjects];
		return;
	}
    if (m_CurrentProducts==nil || [m_CurrentProducts count]==0) {
        return;
    } else if ([m_CurrentProducts count]<m_ProductTotalNum && [indexPath row]==[m_CurrentProducts count]) {
        return;
    } 
    else 
    {
        GrouponVO *grouponVO=[m_CurrentProducts objectAtIndex:[indexPath row]];
        if ([grouponVO.siteType intValue] == 2) {               // 一号商城商品
            //更新团购最新浏览信息
            [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadAddGrouponBrowse:) toTarget:self withObject:grouponVO];
            NSString *urlStr;
            if ([GlobalValue getGlobalValueInstance].token == nil) {
                urlStr = [URL_BASE_MALL_NO_ONE stringByAppendingFormat:@"%@/%@_%d",grouponVO.nid,self.groupOnAreaID,30];
            }else {
                // 对 token 进行base64加密
                NSData *b64Data = [GTMBase64 encodeData:[[GlobalValue getGlobalValueInstance].token dataUsingEncoding:NSUTF8StringEncoding]];
                NSString* b64Str = [[[NSString alloc] initWithData:b64Data encoding:NSUTF8StringEncoding] autorelease];
                
                urlStr = [URL_BASE_MALL_NO_ONE stringByAppendingFormat:@"%@/%@_%@_%d",grouponVO.nid,self.groupOnAreaID,b64Str,30];
                
            }
            grouponVO.mallURL = urlStr;
            DebugLog(@"enterWap -- url is:\n%@",urlStr);
            [SharedDelegate enterWap:1 invokeUrl:urlStr isClearCookie:YES];
        }else {                                                 // 自营团购商品
            [SharedDelegate enterGrouponDetailWithAreaId:self.groupOnAreaID products:m_CurrentProducts currentIndex:indexPath.row fromTag:FROM_GROUPON_HOMEPAGE_TO_DETAIL isFullScreen:YES];
        }
    }
}

#pragma mark    团购分类数据缓存
-(NSArray *)getCategoryListFromLocal
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"SaveGrouponCategory.plist"];
    NSMutableArray *mArray=[[[NSMutableArray alloc] initWithContentsOfFile:filename] autorelease];
    if (mArray!=nil && [mArray count]>0) {
        NSMutableArray *returnMArray=[[[NSMutableArray alloc] init] autorelease];
        for (NSMutableDictionary *mDictionary in mArray) {
            GrouponCategoryVO *categoryVO=[[GrouponCategoryVO alloc] init];
            NSNumber *categoryId=[NSNumber numberWithInt:[[mDictionary objectForKey:@"grouponCategoryId"] intValue]];
            [categoryVO setNid:categoryId];
            NSString *categoryName=[NSString stringWithFormat:@"%@",[mDictionary objectForKey:@"grouponCategoryName"]];
            [categoryVO setName:categoryName];
            NSNumber *categoryCount=[NSNumber numberWithInt:[[mDictionary objectForKey:@"grouponCategoryCount"] intValue]];
            [categoryVO setCount:categoryCount];
            [returnMArray addObject:categoryVO];
            [categoryVO release];
        }
        return returnMArray;
    } else {
        return nil;
    }
}

-(void)newThreadAddGrouponBrowse:(GrouponVO *)groupon
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    BrowseService *bServ=[[[BrowseService alloc] init] autorelease];
    int rowcount = [bServ queryGrouponBrowseHistoryByIdCount:groupon.nid];
    @try {
        if (rowcount) {
            //存在则更新
            [bServ updateGrouponBrowseHistory:groupon provice:PROVINCE_ID];
            
        }
        else {
            [bServ saveGrouponBrowseHistory:groupon province:PROVINCE_ID];
        }
        [bServ savefkToBrowse:groupon.nid];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefleshImmediately" object:nil];
    [pool drain];
}

-(void)saveCategoryListToLocal
{
    NSString *fileName=@"SaveGrouponCategory.plist";
    NSMutableArray *mArray=[[NSMutableArray alloc]init];
    for (GrouponCategoryVO *categoryVO in self.categoryList) {
        NSMutableDictionary *mDictionary=[[NSMutableDictionary alloc] init];
        [mDictionary setObject:[NSString stringWithFormat:@"%@",[categoryVO nid]] forKey:@"grouponCategoryId"];
        [mDictionary setObject:[NSString stringWithFormat:@"%@",[categoryVO name]] forKey:@"grouponCategoryName"];
        [mDictionary setObject:[NSString stringWithFormat:@"%@",[categoryVO count]] forKey:@"grouponCategoryCount"];
        [mArray addObject:mDictionary];
        [mDictionary release];
    }
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:fileName];
    [mArray writeToFile:filename atomically:NO];
    [mArray release];
}



#pragma mark -
-(void)releaseMyResoures
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    OTS_SAFE_RELEASE(m_sortTapeArray);

    OTS_SAFE_RELEASE(m_CurrentProducts);

    OTS_SAFE_RELEASE(m_LoadingMoreLabel);
    OTS_SAFE_RELEASE(m_refreshHeaderView);
    OTS_SAFE_RELEASE(hadSawCategoryDic);
	OTS_SAFE_RELEASE(backView);
    
    // release outlet
    OTS_SAFE_RELEASE(m_LocationBtn);
    OTS_SAFE_RELEASE(m_CategoryListView);
    OTS_SAFE_RELEASE(m_sortBtn);
    if (m_SortFilterView!=nil) {
        [m_SortFilterView setDelegate:nil];
        [m_SortFilterView setDataSource:nil];
        [m_SortFilterView release];
        m_SortFilterView=nil;
    }
    if (m_TableView!=nil) {
        [m_TableView setDelegate:nil];
        [m_TableView setDataSource:nil];
        [m_TableView release];
        m_TableView=nil;
    }
    OTS_SAFE_RELEASE(_cellNib);
    OTS_SAFE_RELEASE(_groupBuyCellDefaultImage);
    m_CurrentSelectedBtn=nil;
	// remove vc

    [OTSMfImageCache cleanUp]; // NOTICE: u have to do this, otherwise cache will not be cleaned up.
    
    //ISSUE #4788 EXC_BAD_ACCESS
    if (_networkQueue)
    {
        dispatch_release(_networkQueue);
        _networkQueue = NULL;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseMyResoures];
}

-(void)dealloc
{
    [self releaseMyResoures];
    
    [_groupOnAreaID release];
    [_categoryList release];
    
    [super dealloc];
}

@end
