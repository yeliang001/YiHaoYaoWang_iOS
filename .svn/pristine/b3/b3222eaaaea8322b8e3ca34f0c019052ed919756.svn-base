//
//  OTSGrouponDetail.m
//  yhd
//
//  Created by jiming huang on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define LEFT_WIDTH  768

#define THREAD_STATUS_GET_MORE_GROUPON  1

#define LEFT_SCROLLVIEW_SUB_VIEW    1

#define LOGIN_TAG   100
#define URL_BASE_MALL_NO_ONE                        @"http://m.1mall.com/mw/groupdetail/"
#define URL_BASE_STORE_NO_ONE                       @"http://m.yihaodian.com/mw/groupdetail/"

#import "OTSGrouponDetail.h"
#import "TopView.h"
#import "OTSLoadingView.h"
#import "GrouponVO.h"
#import "DataHandler.h"
#import "ProductVO.h"
#import "SDImageView+SDWebCache.h"
#import "GTMBase64.h"

@interface OTSGrouponDetail()

-(void)initGrouponDetail;
-(void)updateCurrentGroupon;
-(void)setUpThread:(BOOL)showLoading;
-(void)stopThread;

@end

@implementation OTSGrouponDetail

@synthesize m_InputDictionary;

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
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCancelGPS object:nil]; // 禁用本地的定位
    // Do any additional setup after loading the view from its nib.
    [self initGrouponDetail];
}

-(void)initGrouponDetail
{
    //根据传入参数获取需要的数据
    m_GrouponList=[[NSMutableArray alloc] initWithArray:[m_InputDictionary objectForKey:@"GrouponList"]];
    m_CurrentIndex=[[m_InputDictionary objectForKey:@"GrouponIndex"] intValue];
    m_CurrentGrouponVO=[m_GrouponList objectAtIndex:m_CurrentIndex];
    m_GrouponId=[[[m_GrouponList objectAtIndex:m_CurrentIndex] nid] intValue];
    m_GrouponTotalNumber=[[m_InputDictionary objectForKey:@"GrouponTotalNumber"] intValue];
    m_AreaId=[[m_InputDictionary objectForKey:@"AreaId"] intValue];
    m_CategoryId=[[m_InputDictionary objectForKey:@"CategoryId"] intValue];
    m_PageIndex=[[m_InputDictionary objectForKey:@"PageIndex"] intValue]+1;//+1表示m_PageIndex是下一页的索引
    m_CategoryArray=[[NSArray alloc] initWithArray:[m_InputDictionary objectForKey:@"CategoryList"]];
    
    
    // 需传入额外的areaId, categoryId, grouponId,设置 merchant_id
    JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_GroupDetail extraPrama:[NSNumber numberWithInt:m_AreaId], [NSNumber numberWithInt:m_CategoryId], nil]autorelease];
    [prama setMerchant_id:[NSString stringWithFormat:@"%@",m_CurrentGrouponVO.merchantId]];
    [DoTracking doJsTrackingWithParma:prama];
    
    CGFloat width=1024.0;
    CGFloat height=748.0;
    CGRect rect=self.view.frame;
    rect.size.width=width;
    rect.size.height=height;
    [self.view setFrame:rect];
    m_TopView=[[TopView alloc] initWithDefaultFrameWithFlag:FROM_GROUPON_DETAIL delegate:self];
    [self.view addSubview:m_TopView];
    [m_TopView handleCartChange:nil];
    
    //其他分类
    m_CategoryButton=[[UIButton alloc] initWithFrame:CGRectMake(width-114, 8, 98, 38)];
    [m_CategoryButton setBackgroundImage:[UIImage imageNamed:@"category_other.png"] forState:UIControlStateNormal];
    [m_CategoryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[m_CategoryButton titleLabel] setFont:[UIFont systemFontOfSize:18.0]];
    [m_CategoryButton setTitle:@"全部" forState:UIControlStateNormal];
    [m_CategoryButton addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_CategoryButton];
    
    OTSPopViewController *popViewController=[[OTSPopViewController alloc] initWithType:PopCategoryType];
    int i;
    for (i=0; i<[m_CategoryArray count]; i++) {
        NSNumber *categoryId=[[m_CategoryArray objectAtIndex:i] nid];
        NSString *categoryName=[[m_CategoryArray objectAtIndex:i] name];
        if ([categoryId intValue]==m_CategoryId) {
            [popViewController setCurrentIndex:i+1];
            [m_CategoryButton setTitle:categoryName forState:UIControlStateNormal];
            break;
        }
    }
    [popViewController setDataArray:m_CategoryArray];
    [popViewController setDelegate:self];
    m_WEPopoverController=[[WEPopoverController alloc] initWithContentViewController:popViewController];
    [popViewController release];
    [m_WEPopoverController setPopoverContentSize:CGSizeMake(245, 44.0*([m_CategoryArray count]+1))];
    if ([m_WEPopoverController respondsToSelector:@selector(setContainerViewProperties:)]) {
        [m_WEPopoverController setContainerViewProperties:[self popoverControllerViewProperties]];
    }
    
    m_CategoryLabel=[[UILabel alloc] initWithFrame:CGRectMake(LEFT_WIDTH, TOP_HEIGHT, width-LEFT_WIDTH, 44.0)];
    [m_CategoryLabel setBackgroundColor:[UIColor colorWithRed:253.0/255.0 green:253.0/255.0 blue:253.0/255.0 alpha:1.0]];
    NSString *title=[m_InputDictionary objectForKey:@"CategoryName"];
    [m_CategoryLabel setText:[NSString stringWithFormat:@"   %@",title]];
    [m_CategoryLabel setFont:[UIFont systemFontOfSize:18.0]];
    [self.view addSubview:m_CategoryLabel];
    
    UIView *hLine=[[UIView alloc] initWithFrame:CGRectMake(LEFT_WIDTH, TOP_HEIGHT+44.0, width-LEFT_WIDTH, 1)];
    [hLine setBackgroundColor:[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0]];
    [self.view addSubview:hLine];
    [hLine release];
    
    m_RightTableView=[[UITableView alloc] initWithFrame:CGRectMake(LEFT_WIDTH, TOP_HEIGHT+45.0, width-LEFT_WIDTH, height-TOP_HEIGHT-45.0)];
    [m_RightTableView setDelegate:self];
    [m_RightTableView setDataSource:self];
    [self.view addSubview:m_RightTableView];
    [m_RightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:m_CurrentIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    
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
    
    //刷新当前团购
    [self updateCurrentGroupon];
}

#pragma mark - 其他分类
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

-(void)categoryButtonClicked:(id)sender
{
    [m_WEPopoverController presentPopoverFromRect:CGRectMake(0, 0, 2000, 45)  inView:self.view permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown) animated:YES];
}

-(void)categoryItemSelectedWithCategoryId:(NSNumber *)theCategoryId
{
    [m_WEPopoverController dismissPopoverAnimated:YES];
    [self switchToCategory:[theCategoryId intValue]];
    if ([theCategoryId intValue]==-1) {
        [m_CategoryButton setTitle:@"全部" forState:UIControlStateNormal];
    } else {
        int i;
        for (i=0; i<[m_CategoryArray count]; i++) {
            NSNumber *categoryId=[[m_CategoryArray objectAtIndex:i] nid];
            NSString *categoryName=[[m_CategoryArray objectAtIndex:i] name];
            if ([categoryId intValue]==[theCategoryId intValue]) {
                [m_CategoryButton setTitle:categoryName forState:UIControlStateNormal];
                break;
            }
        }
    }
}

//切换分类
-(void)switchToCategory:(int)theCategoryId
{
    //分类名称
    if (theCategoryId==-1) {
        [m_CategoryLabel setText:@"全部"];
    } else {
        int i;
        for (i=0; i<[m_CategoryArray count]; i++) {
            NSNumber *categoryId=[[m_CategoryArray objectAtIndex:i] nid];
            NSString *categoryName=[[m_CategoryArray objectAtIndex:i] name];
            if ([categoryId intValue]==theCategoryId) {
                [m_CategoryLabel setText:categoryName];
                break;
            }
        }
    }
    
    m_CategoryId=theCategoryId;
    m_PageIndex=1;
    m_ThreadStatus=THREAD_STATUS_GET_MORE_GROUPON;
    [self setUpThread:YES];
}


//刷新当前团购
-(void)updateCurrentGroupon
{
    GrouponVO *currentGrouponVO=m_CurrentGrouponVO;    
    NSString *urlStr;
    if ([GlobalValue getGlobalValueInstance].token == nil) {
        if ([currentGrouponVO.siteType intValue] == 2) {      // 一号商城商品
            urlStr = [URL_BASE_MALL_NO_ONE stringByAppendingFormat:@"%@/%d_%d",currentGrouponVO.nid,m_AreaId,40];
        }else {                                               // 自营商品
            urlStr = [URL_BASE_STORE_NO_ONE stringByAppendingFormat:@"%@/%d_%d",currentGrouponVO.nid,m_AreaId,40];
        }
        
    }else {
        // 对 token 进行base64加密
        NSData *b64Data = [GTMBase64 encodeData:[[GlobalValue getGlobalValueInstance].token dataUsingEncoding:NSUTF8StringEncoding]];
        NSString* b64Str = [[[NSString alloc] initWithData:b64Data encoding:NSUTF8StringEncoding] autorelease];
        if ([currentGrouponVO.siteType intValue] == 2) {      // 一号商城商品
            urlStr = [URL_BASE_MALL_NO_ONE stringByAppendingFormat:@"%@/%d_%@_%d",currentGrouponVO.nid,m_AreaId,b64Str,40];
        }else {
            urlStr = [URL_BASE_STORE_NO_ONE stringByAppendingFormat:@"%@/%d_%@_%d",currentGrouponVO.nid,m_AreaId,b64Str,40];
        }
        
    }
    
    if (webVC == nil) {
        // 清空cookie
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies]) {
            [storage deleteCookie:cookie];
        }
        webVC = [[WebViewController alloc] initWithFrame:CGRectMake(0, TOP_HEIGHT, LEFT_WIDTH, 748-TOP_HEIGHT) WapType:1 URL:urlStr];
        webVC.groupState = 1;
        if ([currentGrouponVO.siteType intValue] == 2) {
            webVC.isFirstToMallWeb = YES;
        }
        [self.view addSubview:webVC.view];
    } else {
        webVC.m_UrlString = urlStr;
        webVC.isNeededShowUrl = YES;
        [webVC loadURL];
    }
}

-(void)hideLoadingView
{
    [m_LoadingView setHidden:YES];
}

//获取更多团购
-(void)getMoreGroupon
{
    m_ThreadStatus=THREAD_STATUS_GET_MORE_GROUPON;
    [self setUpThread:NO];
}

//加载更多完成的处理，隐藏footview
-(void)loadingMoreFinished
{
    [m_RightTableView setTableFooterView:nil];
}

//刷新团购列表
-(void)updateGrouponList
{
    if (m_PageIndex==1) {
        m_CurrentGrouponVO=[m_GrouponList objectAtIndex:0];
        m_GrouponId=[[m_CurrentGrouponVO nid] intValue];
        m_CurrentIndex=0;
        [self updateCurrentGroupon];
        [m_RightTableView reloadData];
        [m_RightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    } else {
        [m_RightTableView reloadData];
    }
    m_PageIndex++;
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

#pragma mark    线程相关
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
                case THREAD_STATUS_GET_MORE_GROUPON: {
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                    Page *tempPage=[[OTSServiceHelper sharedInstance] getCurrentGrouponList:[GlobalValue getGlobalValueInstance].trader areaId:[NSNumber numberWithInt:m_AreaId] categoryId:[NSNumber numberWithInt:m_CategoryId] sortType:[NSNumber numberWithInt:0] siteType:[NSNumber numberWithInt:0] currentPage:[NSNumber numberWithInt:m_PageIndex] pageSize:[NSNumber numberWithInt:9]];
                    if (tempPage==nil || [tempPage isKindOfClass:[NSNull class]]) {
                        [self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常，请检查网络配置..." waitUntilDone:NO];
                    } else {
                        if (m_PageIndex==1) {
                            [m_GrouponList removeAllObjects];
                        }
                        [m_GrouponList addObjectsFromArray:[tempPage objList]];
                        
                        m_GrouponTotalNumber=[[tempPage totalSize] intValue];
                        [self performSelectorOnMainThread:@selector(updateGrouponList) withObject:nil waitUntilDone:NO];
                    }
                    [self performSelectorOnMainThread:@selector(loadingMoreFinished) withObject:nil waitUntilDone:NO];
                    [self stopThread];
                    [pool drain];
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

#pragma mark tableView的datasource和delegate
-(void)tableView:(UITableView * )tableView didSelectRowAtIndexPath:(NSIndexPath * )indexPath {
    m_CurrentGrouponVO=[m_GrouponList objectAtIndex:[indexPath row]];
    m_GrouponId=[[m_CurrentGrouponVO nid] intValue];
    m_CurrentIndex=indexPath.row;
    [self updateCurrentGroupon];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [m_GrouponList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GrouponVO *grouponVO=[m_GrouponList objectAtIndex:[indexPath row]];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"GrouponListCell"];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GrouponListCell"] autorelease];
        CGFloat width=1024.0;
        UIView *backgroundView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, width-LEFT_WIDTH, 180.0)];
        [backgroundView setBackgroundColor:[UIColor colorWithRed:1.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
        [cell setSelectedBackgroundView:backgroundView];
        [backgroundView release];
        //商品名称
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, 994-LEFT_WIDTH, 65)];
        [label setTag:1];
        [label setNumberOfLines:2];
        [label setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:label];
        [label release];
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(10, 73, 130, 83)];
        [view.layer setBorderWidth:1.0];
        [view.layer setBorderColor:[[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0] CGColor]];
        [view setBackgroundColor:[UIColor whiteColor]];
        [cell addSubview:view];
        [view release];
        
        //商品图片
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 120, 73)];
        [imageView setTag:2];
        [view addSubview:imageView];
        [imageView release];
        
        //价格
        label=[[UILabel alloc] initWithFrame:CGRectMake(150, 65, 110, 29)];
        [label setTag:3];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor colorWithRed:213.0/255.0 green:0.0 blue:17.0/255.0 alpha:1.0]];
        [label setFont:[UIFont boldSystemFontOfSize:20.0]];
        [cell addSubview:label];
        [label release];
        
        //折扣
        label=[[UILabel alloc] initWithFrame:CGRectMake(150, 94, 110, 20)];
        [label setTag:4];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
        
        //原价
        label=[[UILabel alloc] initWithFrame:CGRectMake(150, 114, 110, 20)];
        [label setTag:5];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
        
        //已购买件数
        label=[[UILabel alloc] initWithFrame:CGRectMake(150, 134, 110, 29)];
        [label setTag:6];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:16.0]];
        [cell addSubview:label];
        [label release];
    }
    //商品名称
    UILabel *label=(UILabel *)[cell viewWithTag:1];
    [label setText:[grouponVO name]];
    
    //商品图片
    UIImageView *imageView=(UIImageView *)[cell viewWithTag:2];
    [imageView setImageWithURL:[NSURL URLWithString:[grouponVO miniImageUrl]] refreshCache:NO placeholderImage:[UIImage imageNamed:@"grouponcell_null.png"]];
    
    //价格
    label=(UILabel *)[cell viewWithTag:3];
    NSString *text=[NSString stringWithFormat:@"￥%.2f",[[grouponVO price] floatValue]];
    [label setText:[self removeZeroForString:text]];
    
    //折扣
    label=(UILabel *)[cell viewWithTag:4];
    [label setText:[NSString stringWithFormat:@"折扣: %.1f折",[[grouponVO discount] floatValue]]];
    
    //原价
    label=(UILabel *)[cell viewWithTag:5];
    text=[NSString stringWithFormat:@"原价:￥%.2f",[[[grouponVO productVO] maketPrice] floatValue]];
    [label setText:[self removeZeroForString:text]];
    
    //购买件数
    label=(UILabel *)[cell viewWithTag:6];
    [label setText:[NSString stringWithFormat:@"%d件已购买",[[grouponVO peopleNumber] intValue]]];
    
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    cell.accessoryType=UITableViewCellAccessoryNone;
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180.0;
}

//设置行按钮样式
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row]==[m_GrouponList count]-1 && [m_GrouponList count]<m_GrouponTotalNumber) {
        [tableView loadingMoreWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45) target:self selector:@selector(getMoreGroupon) type:UITableViewLoadingMoreForeIpad];
    }
}

-(void)releaseMyResource
{
    if (m_TopView!=nil) {
        [m_TopView release];
        m_TopView=nil;
    }
    if (m_CategoryButton!=nil) {
        [m_CategoryButton release];
        m_CategoryButton=nil;
    }
    if (m_WEPopoverController!=nil) {
        [m_WEPopoverController release];
        m_WEPopoverController=nil;
    }
    if (m_RightTableView!=nil) {
        [m_RightTableView release];
        m_RightTableView=nil;
    }
    if (m_CategoryLabel!=nil) {
        [m_CategoryLabel release];
        m_CategoryLabel=nil;
    }
    if (m_InputDictionary!=nil) {
        [m_InputDictionary release];
        m_InputDictionary=nil;
    }
    if (m_GrouponList!=nil) {
        [m_GrouponList release];
        m_GrouponList=nil;
    }
    m_CurrentGrouponVO=nil;
    if (webVC!=nil) {
        [webVC release];
        webVC=nil;
    }
    if (m_CategoryArray!=nil) {
        [m_CategoryArray release];
        m_CategoryArray=nil;
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
- (void)dealloc{
    [self releaseMyResource];
    [super dealloc];
}

@end
