//
//  OTSGrouponHomePage.m
//  yhd
//
//  Created by jiming huang on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define CATEGORY_HEIGHT     42

#define THREAD_STATUS_GET_CATEGORY  1
#define THREAD_STATUS_GET_PRODUCTS  2

#import "OTSGrouponHomePage.h"
#import "TopView.h"
#import "OTSServiceHelper.h"
#import "ProvinceVO.h"
#import "Page.h"
#import "GrouponCategoryVO.h"
#import "GrouponVO.h"
#import "OTSLoadingView.h"
#import "LoadingMoreLabel.h"
#import "OTSGrouponDetail.h"
#import "SDImageView+SDWebCache.h"
#import "UITableView+LoadingMore.h"
#import "GrouponSortAttributeVO.h"

@implementation OTSGrouponHomePage

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
    
    [self initGrouponHomePage];
}

-(void)initGrouponHomePage
{
    m_CurrentCategoryIndex=0;//默认分类：全部
    m_PageIndex=1;
    m_CachedDictionary=[[NSMutableDictionary alloc] init];
    m_SortType=0;
    
    CGFloat width=1024.0;
    CGFloat height=748.0;
    CGRect rect=self.view.frame;
    rect.size.width=width;
    rect.size.height=height;
    [self.view setFrame:rect];
    m_TopView=[[TopView alloc] initWithDefaultFrameWithFlag:FROM_GROUPON_HOMEPAGE];
    [self.view addSubview:m_TopView];
    [m_TopView handleCartChange:nil];
    
    //排序按钮
    m_SortButton=[[UIButton alloc] initWithFrame:CGRectMake(width-88, 8, 72, 38)];
    [m_SortButton setBackgroundImage:[UIImage imageNamed:@"sort_button.png"] forState:UIControlStateNormal];
    [m_SortButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[m_SortButton titleLabel] setFont:[UIFont systemFontOfSize:18.0]];
    [m_SortButton setTitle:@"默认" forState:UIControlStateNormal];
    [m_SortButton addTarget:self action:@selector(sortButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_SortButton];
    
    OTSPopViewController *popViewController=[[OTSPopViewController alloc] initWithType:PopSortType];
    [popViewController setDelegate:self];
    m_WEPopoverController=[[WEPopoverController alloc] initWithContentViewController:popViewController];
    [popViewController release];
    [m_WEPopoverController setPopoverContentSize:CGSizeMake(245, 220)];
    if ([m_WEPopoverController respondsToSelector:@selector(setContainerViewProperties:)]) {
        [m_WEPopoverController setContainerViewProperties:[self popoverControllerViewProperties]];
    }
    
    m_CategoryScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, TOP_HEIGHT, width, CATEGORY_HEIGHT)];
    [m_CategoryScrollView setAlwaysBounceHorizontal:YES];
    [m_CategoryScrollView setBackgroundColor:[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0]];
    [self.view addSubview:m_CategoryScrollView];
    
    //渐变色
//    CAGradientLayer *gradientLayer=[[CAGradientLayer alloc] init];
//    [gradientLayer setFrame:CGRectMake(0, 0, 2048, CATEGORY_HEIGHT)];
//    [gradientLayer setColors:[NSArray arrayWithObjects: (id)[[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0] CGColor], nil]];
//    [gradientLayer setStartPoint:CGPointMake(0.5,0.0)];
//    [gradientLayer setEndPoint:CGPointMake(0.5,1.0)];
//    [m_CategoryScrollView.layer addSublayer:gradientLayer];
//    [gradientLayer release];
    
    //分类选中图片
    UIImage *redButtonImg=[UIImage imageNamed:@"groupBuy_red_btn.png"];
    m_CurrentCategoryBg=[[UIImageView alloc] initWithImage:redButtonImg];
    
    m_GrouponTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, TOP_HEIGHT+CATEGORY_HEIGHT, width, height-TOP_HEIGHT-CATEGORY_HEIGHT)];
    [m_GrouponTableView setDelegate:self];
    [m_GrouponTableView setDataSource:self];
    [m_GrouponTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:m_GrouponTableView];
    
    //手势处理
    UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [m_GrouponTableView addGestureRecognizer:tapGes];
    [tapGes release];
    
    m_UnsupportView=[[UIView alloc] initWithFrame:CGRectMake(327, 220, 370, 230)];
    [self.view addSubview:m_UnsupportView];
    [m_UnsupportView setHidden:YES];
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(100, 0, 170, 170)];
    [imageView setImage:[UIImage imageNamed:@"groupon_null.png"]];
    [m_UnsupportView addSubview:imageView];
    [imageView release];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 200, 370, 30)];
    [label setText:@"很抱歉，当前地区不支持团购"];
    [label setFont:[UIFont systemFontOfSize:20.0]];
    [label setTextColor:[UIColor colorWithRed:34.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [m_UnsupportView addSubview:label];
    [label release];
    
    //下拉刷新控件
    if (m_RefreshHeaderView!=nil) {
        [m_RefreshHeaderView release];
    }
    m_RefreshHeaderView=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -100, 1024, 100)];
    m_RefreshHeaderView.delegate=self;
    [m_GrouponTableView addSubview:m_RefreshHeaderView];
    [m_RefreshHeaderView refreshLastUpdatedDate];
    
    
    //loading
    m_LoadingView=[[UIView alloc] initWithFrame:CGRectMake(0, 55, width, height-TOP_HEIGHT)];
    [m_LoadingView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:m_LoadingView];
    [m_LoadingView setHidden:YES];
    
    UIImageView *loadingImg=[[UIImageView alloc] initWithFrame:CGRectMake((width-75)/2, (height-TOP_HEIGHT-75)/2, 75, 75)];
    [loadingImg setImage:[UIImage imageNamed:@"activity_bg.png"]];
    [m_LoadingView addSubview:loadingImg];
    [loadingImg release];
    
    UIActivityIndicatorView *indicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator setFrame:CGRectMake((75-37)/2, (75-37)/2, 37, 37)];
   
    if ([indicator respondsToSelector:@selector(setColor:)]) {
         [indicator setColor:[UIColor whiteColor]];
    }
    
    [indicator startAnimating];
    [loadingImg addSubview:indicator];
    [indicator release];
    
    //获取团购分类
    m_ThreadStatus=THREAD_STATUS_GET_CATEGORY;
    [self setUpThread:YES];
}

#pragma mark - 排序
- (WEPopoverContainerViewProperties *)popoverControllerViewProperties {
	WEPopoverContainerViewProperties *props = [[WEPopoverContainerViewProperties alloc] autorelease];
	NSString *bgImageName = nil;
	CGFloat bgMargin = 0.0;
	CGFloat bgCapSize = 0.0;
	CGFloat contentMargin = 4.0;
	
	bgImageName = @"province_kuangbg.png";
	
	// These constants are determined by the popoverBg.png image file and are image dependent
	bgMargin = 4; // margin width of 13 pixels on all sides popoverBg.png (62 pixels wide - 36 pixel background) / 2 == 26 / 2 == 13 
	bgCapSize = 0; // ImageSize/2  == 62 / 2 == 31 pixels
	
	props.leftBgMargin = bgMargin;
	props.rightBgMargin = bgMargin;
	props.topBgMargin =6;// bgMargin;
	props.bottomBgMargin = bgMargin;
	props.leftBgCapSize = bgCapSize;
	props.topBgCapSize = bgCapSize;
	props.bgImageName = bgImageName;
	props.leftContentMargin = contentMargin;
	props.rightContentMargin =0;// contentMargin - 1; // Need to shift one pixel for border to look correct
	props.topContentMargin = 1;//contentMargin; 
	props.bottomContentMargin = contentMargin;
	
	props.arrowMargin = 35.0;
	
	props.upArrowImageName = @"popoverArrowUp.png";
	props.downArrowImageName = @"popoverArrowDown.png";
	props.leftArrowImageName = @"popoverArrowLeft.png";
	props.rightArrowImageName = @"popoverArrowRight.png";
	return props;
}

- (void)sortItemSelectedWithVO:(GrouponSortAttributeVO *)sortVO
{
    [m_WEPopoverController dismissPopoverAnimated:YES];
    NSString *title=[[sortVO attrName] substringWithRange:NSMakeRange(0, 2)];
    [m_SortButton setTitle:title forState:UIControlStateNormal];
    m_PageIndex=1;
    m_SortType=[[sortVO attrId] intValue];
    m_ThreadStatus=THREAD_STATUS_GET_PRODUCTS;
    [self setUpThread:YES];
}

-(void)sortButtonClicked:(id)sender
{
    [m_WEPopoverController presentPopoverFromRect:CGRectMake(0, 0, 2000, 45)  inView:self.view permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown) animated:YES];
}

//刷新团购分类列表
-(void)updateCategoryList
{
    for (UIView *view in [m_CategoryScrollView subviews]) {
        if ([view isKindOfClass:[UIButton class]] || [view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    NSInteger buttonX=5;
    NSInteger buttonWidth=95;
    NSInteger buttonHeight=40;
    
    //"全部"按钮
    [m_CategoryScrollView addSubview:m_CurrentCategoryBg];
    [m_CurrentCategoryBg setFrame:CGRectMake(buttonX,(CATEGORY_HEIGHT-buttonHeight)/2,buttonWidth,buttonHeight)];
    
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(buttonX,(CATEGORY_HEIGHT-buttonHeight)/2,buttonWidth,buttonHeight)];
    [button setTag:0];
    [button setBackgroundColor:[UIColor clearColor]];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	m_CurrentSelectedBtn=button;
    [[button titleLabel] setFont:[button.titleLabel.font fontWithSize:17.0]];
    [button setTitle:@"全部团购" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [m_CategoryScrollView addSubview:button];
    [button release];
    buttonX+=buttonWidth+3;
    
    //其他按钮
    int i;
    for (i=0; i<[m_CategoryList count]; i++) {
        GrouponCategoryVO *categoryVO=[m_CategoryList objectAtIndex:i];
        NSString *categoryName=[categoryVO name];
        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(buttonX,(CATEGORY_HEIGHT-buttonHeight)/2,buttonWidth,buttonHeight)];
        [button setTag:i+1];
        [button setBackgroundColor:[UIColor clearColor]];
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[button setBackgroundImage:nil forState:UIControlStateNormal];
		
		[[button titleLabel] setFont:[button.titleLabel.font fontWithSize:17.0]];
        [button setTitle:categoryName forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [m_CategoryScrollView addSubview:button];
        [button release];
        
        buttonX+=buttonWidth+3;
    }
    [m_CategoryScrollView setContentSize:CGSizeMake(buttonX, CATEGORY_HEIGHT)];
}

//不支持地区的团购
-(void)unsupportGroupon
{
    [m_TopView setSearchHidden:NO];
    [m_SortButton setHidden:YES];
    [m_CategoryScrollView setHidden:YES];
    [m_GrouponTableView setHidden:YES];
    [m_UnsupportView setHidden:NO];
}

//刷新团购列表
-(void)updateGrouponList
{
    @synchronized(self) {
        [m_GrouponTableView reloadData];
    }
}

-(void)hideFooterView
{
    [m_GrouponTableView setTableFooterView:nil];
}

//点击分类按钮
-(void)categoryButtonClicked:(id)sender
{
    UIButton *button=sender;
    if(m_CurrentSelectedBtn!=button) {
        //缓存4个属性
        NSNumber *oldKey=nil;
        if ([m_CurrentSelectedBtn tag]==0) {
            oldKey=[NSNumber numberWithInt:-1];
        } else {
            oldKey=[[m_CategoryList objectAtIndex:[m_CurrentSelectedBtn tag]-1] nid];
        }
        NSMutableArray* tempArray=[[NSMutableArray alloc] init];
        NSMutableArray* tempProArray=[[NSMutableArray alloc] initWithArray:m_GrouponList];
        [tempArray addObject:tempProArray];
        [tempProArray release];
        [tempArray addObject:[NSNumber numberWithInt:m_ProductTotalNum]];
        [tempArray addObject:[NSNumber numberWithInt:m_PageIndex]];
        [tempArray addObject:[NSNumber numberWithFloat:[m_GrouponTableView contentOffset].y]];
        [m_CachedDictionary setObject:tempArray forKey:oldKey];
        [tempArray release];
        
        //分类按钮动画
        [UIView animateWithDuration:0.2 animations:^{
            [m_CurrentCategoryBg setFrame:button.frame];
            [m_CurrentSelectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } completion:^(BOOL finished){
        }];
        
        m_CurrentSelectedBtn=button;
        m_CurrentCategoryIndex=button.tag;
		if (m_CategoryScrollView.contentSize.width>1024 && m_CategoryScrollView.contentOffset.x<=m_CategoryScrollView.contentSize.width-1024) {
			if (button.frame.origin.x>m_CategoryScrollView.contentSize.width-320) {
				[m_CategoryScrollView setContentOffset:CGPointMake(m_CategoryScrollView.contentSize.width-1024,0) animated:YES];
			} else {
				[m_CategoryScrollView setContentOffset:CGPointMake(button.frame.origin.x-3, 0) animated:YES];
			}
		}
		
        //获取团购商品列表
        NSNumber *newKey=nil;
        if (m_CurrentCategoryIndex==0) {//全部分类
            newKey=[NSNumber numberWithInt:-1];
        } else {//其他分类
            newKey=[[m_CategoryList objectAtIndex:m_CurrentCategoryIndex-1] nid];
        }
        if ([m_CachedDictionary objectForKey:newKey]!=nil) {//有缓存
            if (m_GrouponList!=nil) {
                [m_GrouponList release];
            }
            m_GrouponList=[[NSMutableArray alloc] initWithArray:[[m_CachedDictionary objectForKey:newKey] objectAtIndex:0]];
            m_ProductTotalNum=[[[m_CachedDictionary objectForKey:newKey] objectAtIndex:1] intValue];
            m_PageIndex=[[[m_CachedDictionary objectForKey:newKey] objectAtIndex:2] intValue];
            m_TableViewOffset=[[[m_CachedDictionary objectForKey:newKey] objectAtIndex:3] floatValue];
            [m_GrouponTableView setContentOffset:CGPointMake(0, m_TableViewOffset)];
            [self updateGrouponList];
        } else {//无缓存
            m_PageIndex=1;
            m_ThreadStatus=THREAD_STATUS_GET_PRODUCTS;
            [self setUpThread:NO];
        }
    } else {
        m_PageIndex=1;
        m_ThreadStatus=THREAD_STATUS_GET_PRODUCTS;
        [self setUpThread:NO];
    }
}

-(void)hideLoadingView
{
    [m_LoadingView setHidden:YES];
}

//加载更多
-(void)getMoreGroupon
{
    m_ThreadStatus=THREAD_STATUS_GET_PRODUCTS;
    [self setUpThread:NO];
}

//下拉刷新停止
-(void)stopEgoRefresh
{
    [m_RefreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:m_GrouponTableView];
}

-(void)setUpThread:(BOOL)showLoading
{
    if (!m_ThreadRunning) {
        if (showLoading) {
            [self.view bringSubviewToFront:m_LoadingView];
            [m_LoadingView setHidden:NO];
        }
        m_ThreadRunning=YES;
        [self otsDetatchMemorySafeNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
    }
}

-(void)startThread
{
    while (m_ThreadRunning) {
		@synchronized(self) {
            switch (m_ThreadStatus) {
                case THREAD_STATUS_GET_CATEGORY: {
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                    NSNumber *tempNumber=[[OTSServiceHelper sharedInstance] getGrouponAreaIdByProvinceId:[GlobalValue getGlobalValueInstance].trader provinceId:[GlobalValue getGlobalValueInstance].provinceId];
                    if (m_AreaId!=nil) {
                        [m_AreaId release];
                    }
                    if (tempNumber==nil || [tempNumber isKindOfClass:[NSNull class]]) {
                        m_AreaId=nil;
                        [self stopThread];
                        [self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常，请检查网络配置..." waitUntilDone:NO];
                    } else if ([tempNumber intValue]==-99) {
                        m_AreaId=nil;
                        [self stopThread];
                        [self performSelectorOnMainThread:@selector(unsupportGroupon) withObject:nil waitUntilDone:NO];
                    } else {
                        m_AreaId=[tempNumber retain];
                        //获取团购分类
                        NSArray *tempArray=[[OTSServiceHelper sharedInstance] getGrouponCategoryList:[GlobalValue getGlobalValueInstance].trader areaId:m_AreaId];
                        if (m_CategoryList!=nil) {
                            [m_CategoryList release];
                        }
                        if (tempArray==nil || [tempArray isKindOfClass:[NSNull class]]) {
                            m_CategoryList=nil;
                            [self stopThread];
                            [self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常，请检查网络配置..." waitUntilDone:NO];
                        } else {
                            m_CategoryList=[tempArray retain];
                            m_ThreadStatus=THREAD_STATUS_GET_PRODUCTS;
                            [self performSelectorOnMainThread:@selector(updateCategoryList) withObject:nil waitUntilDone:NO];
                        }
                    }
                    
                    [pool drain];
                    break;
                }
                case THREAD_STATUS_GET_PRODUCTS: {
                    isRefreshingGroupon=YES;
                    NSNumber *categoryId=nil;
                    if (m_CurrentCategoryIndex==0) {
                        categoryId=[NSNumber numberWithInt:-1];
                    } else {
                        categoryId=[[m_CategoryList objectAtIndex:m_CurrentCategoryIndex-1] nid];
                    }
                    //团购缓存数据 缓存时间为一天
//                    NSString *_KEY = [NSString stringWithFormat:@"%@_%@_%d_%@",m_AreaId,categoryId,m_PageIndex,[OTSUtility NSDateToNSStringDateV2:[NSDate date]]];
//                    Page *tempPage = [OTSUtility getPagesFromLocal:@"GROUPONLIST" withKey:_KEY];
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                    
//                    if (!tempPage && isRefreshingGroupon) {
                       Page* tempPage=[[OTSServiceHelper sharedInstance] getCurrentGrouponList:[GlobalValue getGlobalValueInstance].trader areaId:m_AreaId categoryId:categoryId sortType:[NSNumber numberWithInt:m_SortType] siteType:[NSNumber numberWithInt:0] currentPage:[NSNumber numberWithInt:m_PageIndex] pageSize:[NSNumber numberWithInt:9]];
                        isRefreshingGroupon=NO;
//                        [OTSUtility putPagesToLocal:page withPageName:@"GROUPONLIST" withKey:_KEY];
//                    }

                    [self performSelectorOnMainThread:@selector(stopEgoRefresh) withObject:nil waitUntilDone:NO];
                    if (tempPage==nil || [tempPage isKindOfClass:[NSNull class]]) {
                        [self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常，请检查网络配置..." waitUntilDone:NO];
                    } else {
                        if (m_PageIndex==1) {
                            if (m_GrouponList!=nil) {
                                [m_GrouponList release];
                            }
                            m_GrouponList=[[NSMutableArray alloc] init];
                        }
                        [m_GrouponList addObjectsFromArray:[tempPage objList]];
                        m_ProductTotalNum=[[tempPage totalSize] intValue];
                        m_PageIndex++;
                        [self performSelectorOnMainThread:@selector(updateGrouponList) withObject:nil waitUntilDone:NO];
                    }
                    [self performSelectorOnMainThread:@selector(hideFooterView) withObject:nil waitUntilDone:NO];
                    [self stopThread];
                    
                    // 需传入额外的areaId, categoryId
                    JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_GroupList extraPrama:m_AreaId, categoryId, nil]autorelease];
                    [DoTracking doJsTrackingWithParma:prama];
                    
                    [pool drain];
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
    m_ThreadRunning=NO;
    m_ThreadStatus=-1;
    [self performSelectorOnMainThread:@selector(hideLoadingView) withObject:nil waitUntilDone:NO];
}

-(NSString *)removeZeroForString:(NSString *)string
{
    if ([string hasSuffix:@"0"]) {
        string=[string substringToIndex:string.length-1];
        if ([string hasSuffix:@".0"]) {
            string=[string substringToIndex:string.length-2];
        }
    }
    return string;
}

-(void)handleTap:(UIPanGestureRecognizer*)gestureRecognizer
{
    CGPoint currentPoint=[gestureRecognizer locationInView:gestureRecognizer.view];
    int index;
    if (currentPoint.x<1024/3) {
        index=0;
    } else if (currentPoint.x>1024/3 && currentPoint.x<1024*2/3) {
        index=1;
    } else {
        index=2;
    }
    
    NSIndexPath *indexPath=[m_GrouponTableView indexPathForRowAtPoint:currentPoint];
	if (indexPath==nil) {
		return;
	} else {
        if ([indexPath row]*3+index>=[m_GrouponList count]) {
            return;
        }
        //动画
        CATransition *transition=[CATransition animation];
        transition.duration=OTSP_TRANS_DURATION;
        transition.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type=kCATransitionFade; 
        transition.subtype=kCATransitionFromRight;
        transition.delegate=self;
        
        OTSGrouponDetail *grouponDetail=[[OTSGrouponDetail alloc] initWithNibName:@"OTSGrouponDetail" bundle:nil];
        NSMutableDictionary *dictionary=[NSMutableDictionary dictionary];
        //地区id
        [dictionary setObject:[NSNumber numberWithInt:[m_AreaId intValue]] forKey:@"AreaId"];
        //团购列表
        [dictionary setObject:[NSArray arrayWithArray:m_GrouponList] forKey:@"GrouponList"];
        //当前团购索引
        [dictionary setObject:[NSNumber numberWithInt:[indexPath row]*3+index] forKey:@"GrouponIndex"];
        //团购总数
        [dictionary setObject:[NSNumber numberWithInt:m_ProductTotalNum] forKey:@"GrouponTotalNumber"];
        //分页索引
        [dictionary setObject:[NSNumber numberWithInt:m_PageIndex] forKey:@"PageIndex"];
        //分类id
        NSNumber *categoryId=nil;
        if (m_CurrentCategoryIndex==0) {
            categoryId=[NSNumber numberWithInt:-1];
        } else {
            categoryId=[[m_CategoryList objectAtIndex:m_CurrentCategoryIndex-1] nid];
        }
        [dictionary setObject:[NSNumber numberWithInt:[categoryId intValue]] forKey:@"CategoryId"];
        //分类名称
        [dictionary setObject:[NSString stringWithString:[m_CurrentSelectedBtn titleForState:UIControlStateNormal]] forKey:@"CategoryName"];
        [dictionary setObject:[NSArray arrayWithArray:m_CategoryList] forKey:@"CategoryList"];
        [grouponDetail setM_InputDictionary:dictionary];
        [self.navigationController pushViewController:grouponDetail animated:NO];
        [grouponDetail release];
    }
    //友盟统计
    [MobClick event:@"click_groupbuy"];
}

#pragma mark tableView的datasource和delegate
-(void)tableView:(UITableView * )tableView didSelectRowAtIndexPath:(NSIndexPath * )indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中颜色
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count=[m_GrouponList count]/3;
    if ([m_GrouponList count]%3!=0) {
        count++;
    }
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int startIndex=[indexPath row]*3;
    int endIndex=[indexPath row]*3+2;
    if (endIndex>[m_GrouponList count]-1) {
        endIndex=[m_GrouponList count]-1;
    }
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"GrouponCell"];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GrouponCell"] autorelease];
        CGFloat xValue=0.0;
        CGFloat yValue=0.0;
        CGFloat width=1024.0/3.0;
        CGFloat height=(748.0-TOP_HEIGHT-CATEGORY_HEIGHT)/2.0;
        int i;
        for (i=0; i<3; i++) {
            UIImageView *mainView=[[UIImageView alloc] initWithFrame:CGRectMake(xValue, yValue, width, height)];
            [mainView setTag:100+i];
            [mainView.layer setBorderWidth:0.5];
            [mainView.layer setBorderColor:[[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0] CGColor]];
            [mainView setImage:[UIImage imageNamed:@"groupon_cell.png"]];
            [cell addSubview:mainView];
            [mainView release];
            [mainView setUserInteractionEnabled:YES];
            [mainView setHidden:YES];
            
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(51.0, 29.0, 240.0, 150.0)];
            [imageView setTag:1];
            [imageView setUserInteractionEnabled:NO];
            [mainView addSubview:imageView];
            [imageView release];
            
            //价格
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(45.0, 190, 130, 54.0)];
            [label setTag:2];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setFont:[UIFont boldSystemFontOfSize:25.0]];
            [label setTextColor:[UIColor colorWithRed:213.0/255.0 green:0.0 blue:17.0/255.0 alpha:1.0]];
            [label setAdjustsFontSizeToFitWidth:YES];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setUserInteractionEnabled:NO];
            [mainView addSubview:label];
            [label release];
            
            //原价
            label=[[UILabel alloc] initWithFrame:CGRectMake(190.0, 190, 105, 18)];
            [label setTag:3];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setFont:[UIFont systemFontOfSize:15.0]];
            [label setAdjustsFontSizeToFitWidth:YES];
            [label setUserInteractionEnabled:NO];
            [mainView addSubview:label];
            [label release];
            
            //折扣
            label=[[UILabel alloc] initWithFrame:CGRectMake(190.0, 208, 105, 18)];
            [label setTag:4];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setFont:[UIFont systemFontOfSize:15.0]];
            [label setAdjustsFontSizeToFitWidth:YES];
            [label setUserInteractionEnabled:NO];
            [mainView addSubview:label];
            [label release];
            
            //已购买件数
            label=[[UILabel alloc] initWithFrame:CGRectMake(190.0, 226, 105, 18)];
            [label setTag:5];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setFont:[UIFont systemFontOfSize:15.0]];
            [label setAdjustsFontSizeToFitWidth:YES];
            [mainView addSubview:label];
            [label release];
            
            //团购名称
            label=[[UILabel alloc] initWithFrame:CGRectMake(45.0, 245.0, 250.0, 75)];
            [label setTag:6];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setNumberOfLines:2];
            [label setFont:[UIFont systemFontOfSize:17.0]];
            [label setAdjustsFontSizeToFitWidth:YES];
            [mainView addSubview:label];
            [label release];
            
            xValue+=width;
        }
    }
    int j;
    for (j=startIndex; j<=startIndex+2; j++) {
        int buttonIndex=j-startIndex+100;
        UIImageView *mainView=(UIImageView *)[cell viewWithTag:buttonIndex];
        if (j<=endIndex) {
            [mainView setHidden:NO];
            GrouponVO *grouponVO=[m_GrouponList objectAtIndex:j];
            
            //商品图片
            UIImageView *imageView=(UIImageView *)[mainView viewWithTag:1];
            [imageView setImageWithURL:[NSURL URLWithString:[grouponVO miniImageUrl]] refreshCache:NO placeholderImage:[UIImage imageNamed:@"grouponcell_null.png"]];
            
            //价格
            UILabel *label=(UILabel *)[mainView viewWithTag:2];
            NSString *text=[NSString stringWithFormat:@"￥%.2f",[[grouponVO price] floatValue]];
            [label setText:[self removeZeroForString:text]];
            
            //原价
            label=(UILabel *)[mainView viewWithTag:3];
            text=[NSString stringWithFormat:@"原价:￥%.2f",[[[grouponVO productVO] maketPrice] floatValue]];
            [label setText:[self removeZeroForString:text]];
            
            //折扣
            label=(UILabel *)[mainView viewWithTag:4];
            [label setText:[NSString stringWithFormat:@"折扣: %.1f折",[[grouponVO discount] floatValue]]];
            
            //购买件数
            label=(UILabel *)[mainView viewWithTag:5];
            [label setText:[NSString stringWithFormat:@"%d件已购买",[[grouponVO peopleNumber] intValue]]];
            
            //团购名称
            label=(UILabel *)[mainView viewWithTag:6];
            [label setText:[grouponVO name]];
        } else {
            [mainView setHidden:YES];
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (748.0-TOP_HEIGHT-CATEGORY_HEIGHT)/2;
}

//设置行按钮样式
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    int count=[m_GrouponList count]/3;
    if ([m_GrouponList count]%3!=0) {
        count++;
    }
    if ([indexPath row]==count-1 && [m_GrouponList count]<m_ProductTotalNum) {
        [tableView loadingMoreWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45) target:self selector:@selector(getMoreGroupon) type:UITableViewLoadingMoreForeIpad];
    }
}

#pragma mark scrollView相关delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (m_GrouponList==nil || [m_GrouponList count]>=m_ProductTotalNum) {
        return;
    }
    if (scrollView==m_GrouponTableView) {
        [m_RefreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (scrollView==m_GrouponTableView) {
        [m_RefreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark EGORefreshTableHeaderView相关delegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
    m_PageIndex=1;
    m_ThreadStatus=THREAD_STATUS_GET_PRODUCTS;
    [self setUpThread:NO];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
	return isRefreshingGroupon;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
	return [NSDate date];
}

-(void)releaseMyResource
{
    if (m_TopView!=nil) {
        [m_TopView release];
        m_TopView=nil;
    }
    if (m_CategoryScrollView!=nil) {
        [m_CategoryScrollView release];
        m_CategoryScrollView=nil;
    }
    if (m_GrouponTableView!=nil) {
        [m_GrouponTableView release];
        m_GrouponTableView=nil;
    }
    if (m_UnsupportView!=nil) {
        [m_UnsupportView release];
        m_UnsupportView=nil;
    }
    if (m_WEPopoverController!=nil) {
        [m_WEPopoverController release];
        m_WEPopoverController=nil;
    }
    if (m_SortButton!=nil) {
        [m_SortButton release];
        m_SortButton=nil;
    }
    if (m_AreaId!=nil) {
        [m_AreaId release];
        m_AreaId=nil;
    }
    if (m_CategoryList!=nil) {
        [m_CategoryList release];
        m_CategoryList=nil;
    }
    if (m_GrouponList!=nil) {
        [m_GrouponList release];
        m_GrouponList=nil;
    }
    m_CurrentSelectedBtn=nil;
    if (m_CurrentCategoryBg!=nil) {
        [m_CurrentCategoryBg release];
        m_CurrentCategoryBg=nil;
    }
    if (m_CachedDictionary!=nil) {
        [m_CachedDictionary release];
        m_CachedDictionary=nil;
    }
    if (m_RefreshHeaderView!=nil) {
        [m_RefreshHeaderView release];
        m_RefreshHeaderView=nil;
    }
    if (m_LoadingView!=nil) {
        [m_LoadingView release];
        m_LoadingView=nil;
    }
}

- (void)viewDidUnload
{
    [self releaseMyResource];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc
{
    [self releaseMyResource];
    [super dealloc];
}

@end
