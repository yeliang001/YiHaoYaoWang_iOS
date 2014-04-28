//
//  HomePage.m
//  TheStoreApp
//
//  Created by jiming huang on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ScanResult.h"
#import "HomePage.h"
#import "MyStoreViewController.h"
#import "UserManage.h"
#import "CategoryViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ZBarReaderViewController.h"
#import "ZBarImageScanner.h"
#import "SystemService.h"
#import "UIDeviceHardware.h"
#import "TheStoreAppAppDelegate.h"
#import "MyOrder.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "Scan.h"
#import "AlertView.h"
#import "OTSAlertView.h"
#import "HotPointNewVO.h"
#import "OTSMaterialFLowVC.h"
#import "OTSSearchView.h"
#import "OTSAdModelAView.h"
#import "AdvertisingPromotionVO.h"
#import "OTSAdModelBView.h"
#import "NSString+MD5Addition.h"
#import "BrowseService.h"
#import "OTSProductDetail.h"
#import "BrandStoreViewController.h"
#import "TheStoreAppAppDelegate.h"
#import "CategoryProductsViewController.h"
#import "GTMBase64.h"
#import "GPSUtil.h"
#import "YWBaseService.h"
#import "ResponseInfo.h"
#import "AdFloorInfo.h"
#import "YWProductService.h"
#import "SpecialRecommendInfo.h"
#import "YWSearchService.h"
#import "YWLocalCatService.h"
#import "CategoryVO.h"
#import "YWSystemService.h"
#import "VersionInfo.h"
#import "YWUserLoginHelper.h"
#import "CategoryInfo.h"
#import "DataController.h"
#import "MyBrowse.h"
#import "ImageCache.h"
#import "RecommendViewController.h"


#define ALERT_TAG_FORCEUPDATE_TRUE 101			// 强制更新
#define ALERT_TAG_FORCEUPDATE_FALSE 102			// 非强制更新
#define ALERT_TAG_APP_FIRST_LAUNCH 105
#define ALERT_TAG_APP_START_LAUNCH 106
#define ALERT_TAG_APP_WAKE  107

#define VIEW_TAG_SEL_PROVINCE_BUTTON            1014
#define TAG_MODULE_IMAGE_VIEW                   1020
#define TAG_MODEL_A_TOP                         300
#define TAG_MODEL_B_TOP                         301
#define moduleTag 302
#define MODEAL_IMAGE_WIDTH  52
#define MODEAL_IMAGE_HEIGHT 52

@interface HomePage()

-(void)saveAdModulesToLocal:(AdvertisingPromotion *)adPromotion;
-(NSMutableDictionary *)getAdModulesFromLocal;
@end

@implementation HomePage

@synthesize m_CurrentProvinceStr,m_NewProvinceStr;
@synthesize modelATable;

#pragma mark    自动登录
//新线程自动登录
-(void)newThreadAutoLogin
{
    DebugLog(@"test520 自动登陆 newThreadAutoLogin");
    NSDictionary *paramDic = @{@"username" : [UserManageTool sharedInstance].GetUserName, @"password" : [UserManageTool sharedInstance].GetUserPass};
    DebugLog(@"自动登陆 %@",paramDic);
    [[YWUserLoginHelper sharedInstance] loginWithType:kYWLoginStore param:paramDic];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initHomePage];
}


//初始化数据
-(void)initData
{
	[[GlobalValue getGlobalValueInstance] setWidth:self.view.frame.size.width];
	[[GlobalValue getGlobalValueInstance] setHeight:self.view.frame.size.height];
	//首页搜索
    m_Search=[[Search alloc] init];
    [[NSBundle mainBundle] loadNibNamed:@"Search" owner:m_Search options:nil];
    isAnimStop=YES;
	[UIView setAnimationsEnabled:NO];
    //购物车数量
	if ([GlobalValue getGlobalValueInstance].token==nil)
    {
		LocalCartService *localCartServ=[[LocalCartService alloc] init];
        int cartNum = [localCartServ getLocalCartNumberFromSqlite3];
		[SharedDelegate clearCartNum];
		if (cartNum>0) {
            [SharedDelegate setCartNum:cartNum];
		}
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChanged" object:nil];
		[localCartServ release];
	}
	//获取省份字典和当前省份字串
	NSString *listPath=[[NSBundle mainBundle] pathForResource:@"ProvinceID" ofType:@"plist"];
	m_ProvinceDic=[[NSDictionary alloc] initWithContentsOfFile:listPath];
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *path=[paths objectAtIndex:0];
	NSString *filename=[path stringByAppendingPathComponent:@"SaveProvinceId.plist"];
	NSMutableArray *userProvinceArray=[[NSMutableArray alloc] initWithContentsOfFile:filename];
	self.m_CurrentProvinceStr=[OTSUtility safeObjectAtIndex:0 inArray:userProvinceArray];
    [userProvinceArray release];
    
    
    //获取缓存广告模块 -- 楼层广告
//    NSMutableDictionary *mDictionary=[self getAdModulesFromLocal];
//    NSNumber *provinceId=[mDictionary objectForKey:@"provinceId"];
    
    // 获取轮播图缓存
    Page* page = [self getPagesFromLocal];
    
    if (page && page.objList.count > 0)
    {
        hotTopFivePage = [page retain];
    }
    
    if (m_AdArray!=nil)
    {
        [m_AdArray release];
    }
    m_AdArray = [page.adFloorList retain];
    DebugLog(@"m_Adarray -- > %@",m_AdArray);
    
}

//建立新线程
-(void)setUpNewThread
{
    //获取热销图
    [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadGetHotPage) toTarget:self withObject:nil];
    [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadGetAdultConfig) toTarget:self withObject:nil];
    //是否需要版本更新
    [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadVersionUpdate) toTarget:self withObject:nil];
    //自动登录
    if ([[[UserManageTool sharedInstance] GetAutoLoginStatus] isEqualToString:@"1"])
    {
        [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadAutoLogin) toTarget:self withObject:nil];
    }
    //
    //功能模块
//    [self otsDetatchMemorySafeNewThreadSelector:@selector(freshFunctionModules) toTarget:self withObject:nil];
}

//初始化首页UI
-(void)initHomePageUI
{
    //    [self.view setBackgroundColor:[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0]];
    CGFloat yValue=0.0;
    //logo栏
    UIImageView *titleView=[[UIImageView alloc]initWithFrame:CGRectMake(0,yValue,320,44)];
    [titleView setImage:[UIImage imageNamed:@"title_bg.png"]];
    [self.view addSubview:titleView];
    [titleView release];
    yValue+=44.0;
    
    UIImageView *logoDescribeView=[[UIImageView alloc]initWithFrame:CGRectMake(138,1,45,41)];
	logoDescribeView.image=[UIImage imageNamed:@"homepage_logo.png"];
//	[self.view addSubview:logoDescribeView];
	[logoDescribeView release];
    
    //logo栏-选择省份按钮
	UIButton *selectedProvince=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 61, 44)];
    [selectedProvince setTag:VIEW_TAG_SEL_PROVINCE_BUTTON];
    [selectedProvince setTitleEdgeInsets:UIEdgeInsetsMake(0, 11, 0, 0)];
    
	if(m_CurrentProvinceStr==nil || [m_CurrentProvinceStr isEqualToString:@""])
    {
        //如果未切换过省份
		[selectedProvince setTitle:@"上海" forState:UIControlStateNormal];
		self.m_CurrentProvinceStr=[[[NSString alloc] initWithString:@"上海"] autorelease];
	}
    else
    {
		[selectedProvince setTitle:m_CurrentProvinceStr forState:0];
	}
    [selectedProvince setBackgroundImage:[UIImage imageNamed:@"title_GPS_btn.png"] forState:UIControlStateNormal];
    [selectedProvince setBackgroundImage:[UIImage imageNamed:@"title_GPS_btn_sel.png"] forState:UIControlStateHighlighted];
	selectedProvince.titleLabel.font=[UIFont boldSystemFontOfSize:13.0];
    [selectedProvince.titleLabel setTextAlignment:NSTextAlignmentLeft];
	selectedProvince.titleLabel.shadowColor = [UIColor darkGrayColor];
	selectedProvince.titleLabel.shadowOffset = CGSizeMake(1.0, -1.0);
	[selectedProvince setTitleColor:[UIColor whiteColor] forState:0];
	[selectedProvince addTarget:self action:@selector(enterSwitchProvince) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:selectedProvince];
    [selectedProvince release];
	
    //搜索
	OTSSearchView *searchView=[[OTSSearchView alloc] initWithFrame:CGRectMake(0, yValue, 320, 40) delegate:m_Search];
    [self.view addSubview:searchView];
    [searchView release];
    yValue+=40.0;
    
    //scroll view
	m_ScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0,yValue,320,327)];
    if (iPhone5) {
        [m_ScrollView setFrame:CGRectMake(0,yValue,320,327+88)];
    }
	[m_ScrollView setBackgroundColor:[UIColor clearColor]];
    //    [m_ScrollView setDelaysContentTouches:NO];
    [m_ScrollView setShowsVerticalScrollIndicator:NO];
    [m_ScrollView setScrollsToTop:NO];
    [m_ScrollView setAlwaysBounceVertical:YES];
    [m_ScrollView setDelegate:self];
	[self.view addSubview:m_ScrollView];
    
    //下拉刷新控件
    if (m_RefreshHeaderView!=nil) {
        [m_RefreshHeaderView release];
    }
    m_RefreshHeaderView=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -m_ScrollView.bounds.size.height, 320, m_ScrollView.bounds.size.height)];
    m_RefreshHeaderView.delegate=self;
    [m_ScrollView addSubview:m_RefreshHeaderView];
    [m_RefreshHeaderView refreshLastUpdatedDate];
    
    //page view
    CGFloat yValueInScroll=0.0;
    m_PageView=[[OTSPageView alloc] initWithFrame:CGRectMake(0, yValueInScroll, 320, 120) delegate:self showStatusBar:YES sleepTime:5];
    [m_ScrollView addSubview:m_PageView];
    
    //yValueInScroll+=120.0;
    
    // 功能模块
    [self initFunctionModules];
    
    // 广告模块
    if (m_AdArray!=nil&&m_AdArray.count>0) {
        [self updateCMSModuleA];
    }
    
	[self setUniqueScrollToTopFor:m_ScrollView];
}

//首页初始化
-(void)initHomePage
{
	[self initData];
    [self initHomePageUI];
    [self setUpNewThread];
}

//刷新首页数据
-(void)refreshHomePageData
{
    //刷新热销图
    if (!isRefreshingHotPage && !isRefreshingAd) {
        isRefreshingHotPage=YES;
        isRefreshingAd = YES;
        [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadGetHotPage) toTarget:self withObject:nil];
    }
    //刷新广告模块
//    if (!isRefreshingAd) {
//        isRefreshingAd=YES;
//        [self otsDetatchMemorySafeNewThreadSelector:@selector(netThreadGetAdvertisementModel) toTarget:self withObject:nil];
//    }
    
    //功能模块写死了，不刷洗
//    [self otsDetatchMemorySafeNewThreadSelector:@selector(freshFunctionModules) toTarget:self withObject:nil];
}

//下拉刷新停止
-(void)stopEgoRefresh
{
    if (!isRefreshingHotPage && !isRefreshingAd) {
        [m_RefreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:m_ScrollView];
    }
}


#pragma mark    热销图
//***** 轮播图 ************
-(void)newThreadGetHotPage {
    DebugLog(@"test520 自动登陆 newThreadGetHotPage");
    
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    
    //Linpan
    YWProductService *productSer = [[YWProductService alloc] init];
    Page *tempPage = [productSer getHomeSpcecialList];
    isRefreshingHotPage=NO;
    
    isRefreshingAd = NO;
    

    if (tempPage!=nil && ![tempPage isKindOfClass:[NSNull class]])
    {
        if (hotTopFivePage!=nil)
        {
            [hotTopFivePage release];
        }
        hotTopFivePage=[tempPage retain];
        for (int i=0; i<[hotTopFivePage.objList count]; i++)
        {
            NSString *fileName;
            NSString *hotProductImgUrlStr=((SpecialRecommendInfo *)[hotTopFivePage.objList objectAtIndex:i]).imageUrl;
            if (hotProductImgUrlStr==nil)
            {
                continue;
            }
            NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:hotProductImgUrlStr]];
            fileName=[hotProductImgUrlStr stringFromMD5];
            
            [DataController writeApplicationData:data name:fileName];
            [self savePagesToLocal:hotTopFivePage];
        }
        
        //楼层广告
        m_AdArray = [hotTopFivePage.adFloorList retain];
        [self performSelectorOnMainThread:@selector(updateHotPage) withObject:nil waitUntilDone:YES];
        
    }
    [self performSelectorOnMainThread:@selector(stopEgoRefresh) withObject:nil waitUntilDone:NO];

    
    [productSer release];
    
	[pool drain];
}

//刷新热销图
-(void)updateHotPage
{
    [self.view setUserInteractionEnabled:YES];
    [m_PageView reloadPageView];
    
    //焦点图和楼层一起了
    [self updateCMSModuleA];
}
-(void)savePagesToLocal:(Page*)aPage
{
    NSString *filename=[OTSUtility documentDirectoryWithFileName:@"SaveHotPages_130502.plist"];
    NSData* pageData = [NSKeyedArchiver archivedDataWithRootObject:aPage];
    [pageData writeToFile:filename atomically:NO];
}

-(Page*)getPagesFromLocal
{
    NSString *filename=[OTSUtility documentDirectoryWithFileName:@"SaveHotPages_130502.plist"];
    Page* aPage = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    return aPage;
}
#pragma mark    功能模块
-(void)saveModulesToLocal:(NSMutableArray*)adPromotion
{
    NSString *filename=[OTSUtility documentDirectoryWithFileName:@"saveModules_130502.plist"];
    NSData* arrData = [NSKeyedArchiver archivedDataWithRootObject:adPromotion];
    [arrData writeToFile:filename atomically:NO];
}

-(NSMutableArray*)getModulesFromLocal
{
    NSString *filename=[OTSUtility documentDirectoryWithFileName:@"saveModules_130502.plist"];
    NSMutableArray* objArr = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    return objArr;
}



-(void)adjustModulesHeight{
    UIView*moduleView=[m_ScrollView viewWithTag:moduleTag];

    
    //8个模块被写死，所以不需要调整高度了－－－－ Linpan
    moduleView.frame=CGRectMake(0, 120, 320, 100);
    modelATable.frame=CGRectMake(0, 120+100, 320, 750*m_AdArray.count); //改为了4个模块，所以y ＝ 120 ＋ 100
    
    ///////1号店原版////////
    /*
    if (modulesArray.count==0) {
        moduleView.frame=CGRectMake(0, 120, 320, 113);
        modelATable.frame=CGRectMake(0, 120+120, 320, 750);
    }else{
        moduleView.frame=CGRectMake(0, 120, 320, 200);
        modelATable.frame=CGRectMake(0, 120+200, 320, 750);
    }
    */
    
}
-(void)initFunctionModules
{
    
    CGFloat yValueInScroll=120.0;
    UIView *moduleView=[[UIView alloc] initWithFrame:CGRectMake(0, yValueInScroll, 320, 100)];
    moduleView.tag=moduleTag;
    [m_ScrollView addSubview:moduleView];
    [moduleView release];
    
    CGFloat xValue=10;
//    xValue = 10;
    CGFloat yValue=10.0;
    int i;
    for (i=0; i< 5; i++)
    {
        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(xValue, yValue, MODEAL_IMAGE_WIDTH, MODEAL_IMAGE_HEIGHT)];
        [button setTag:100+i];
        NSString *moduleName;
        UIImage *image;
        switch (i)
        {
                
            case 0:
                moduleName=@"当季热销";
                image=[UIImage imageNamed:@"modelRecommed.png"];
                break;
                
            case 1:
                moduleName = @"浏览历史";
                image = [UIImage imageNamed:@"modelhistory.png"];
                break;
            case 2:
                moduleName = @"团购";
                image = [UIImage imageNamed:@"modeltuan.png"];
                break;
            case 3:
                moduleName=@"扫描";
                image=[UIImage imageNamed:@"modelscan.png"];
                break;
       
            case 4:
                moduleName=@"物流查询";
                image=[UIImage imageNamed:@"modelflow.png"];
                break;
            default:
                break;
        }
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(moduleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [moduleView addSubview:button];
        [button release];
        
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(xValue-13, yValue+53, MODEAL_IMAGE_WIDTH+26, 30)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:moduleName];
        [label setFont:[UIFont systemFontOfSize:14.0]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [moduleView addSubview:label];
        [label release];
        
//        if (i == 3)
//        {
//            xValue = 14.0;
//            yValue = 100.0;
//        }
//        else
//        {
//            xValue+=77.0;
            xValue += 10 + MODEAL_IMAGE_WIDTH;
//        }
        
    }
    modelATable=[[UITableView alloc]initWithFrame:CGRectMake(0, yValueInScroll+100, 320, 750) style:UITableViewStylePlain];
    modelATable.delegate=self;
    modelATable.dataSource=self;
    [m_ScrollView addSubview:modelATable];
    modelATable.scrollEnabled=NO;
    
    moduleView.frame=CGRectMake(0, 120, 320, 100);
    modelATable.frame=CGRectMake(0, 120/*+200*/, 320, 750); //这里控制高度是没有用，去这里改：adjustModulesHeight

    
//////////1号店原版，只固定上面4个模块，下面4个网络获取，现在改为全部写死  －－－ Linpan
/*
    CGFloat yValueInScroll=120.0;
    UIView *moduleView=[[UIView alloc] initWithFrame:CGRectMake(0, yValueInScroll, 320, 200)];
    moduleView.tag=moduleTag;
    [m_ScrollView addSubview:moduleView];
    [moduleView release];
    
    CGFloat xValue=14.0;
    CGFloat yValue=8.0;
    int i;
    for (i=0; i<4; i++)
    {
        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(xValue, yValue, MODEAL_IMAGE_WIDTH, MODEAL_IMAGE_HEIGHT)];
        [button setTag:100+i];
        NSString *moduleName;
        UIImage *image;
        switch (i)
        {
            case 0:
                moduleName=@"1起摇";
                image=[UIImage imageNamed:@"modelshake.png"];
                break;
            case 1:
                moduleName=@"1号团";
                image=[UIImage imageNamed:@"modelgroupon.png"];
                break;
            case 2:
                moduleName=@"扫描";
                image=[UIImage imageNamed:@"modelscan.png"];
                break;
            case 3:
                moduleName=@"物流查询";
                image=[UIImage imageNamed:@"modelflow.png"];
                break;
            default:
                break;
        }
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(moduleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [moduleView addSubview:button];
        [button release];
        
        if (i == 0)
        {
            UIImageView* secretImage = [[UIImageView alloc] initWithFrame:CGRectMake(38, 0, 54, 23)];
            [secretImage setImage:[UIImage imageNamed:@"tips.png"]];
            [moduleView addSubview:secretImage];
            [secretImage release];
        }
        

        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(xValue-13, yValue+60, MODEAL_IMAGE_WIDTH+26, 30)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:moduleName];
        [label setFont:[UIFont systemFontOfSize:14.0]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [moduleView addSubview:label];
        [label release];
        
        xValue+=77.0;
    }
    modelATable=[[UITableView alloc]initWithFrame:CGRectMake(0, yValueInScroll+200, 320, 750) style:UITableViewStylePlain];
    modelATable.delegate=self;
    modelATable.dataSource=self;
    [m_ScrollView addSubview:modelATable];
    modelATable.scrollEnabled=NO;

    if (modulesArray && modulesArray.count > 0)
    {
        [self updateModules];
    }
 */
    
}

//点击模块
-(void)moduleBtnClicked:(id)sender
{
    UIButton *  button=(UIButton*)sender;
    int index=[button tag]-100;
    switch (index)
    {
            
        case 0:
        {
            //热门推荐
            [self removeSubControllerClass:[RecommendViewController class]];
            RecommendViewController *recommendVC = [[[RecommendViewController alloc] initWithNibName:@"RecommendViewController" bundle:nil] autorelease];
            [self pushVC: recommendVC animated:YES];
            break;
            
        }
            
        case 1:
        {
            //历史记录
            [self removeSubControllerClass:[MyBrowse class]];
            MyBrowse *browse=[[[MyBrowse alloc]initWithNibName:@"MyBrowse" bundle:nil] autorelease];
            [self pushVC:browse animated:YES];
            break;
        }
            
        case 4:
        {
            //物流查询
            [self enterLogisticQuery];
            break;
        }
        case 3:
        {
            //扫描
            [self removeSubControllerClass:[Scan class]];
            Scan *scan=[[[Scan alloc] initWithNibName:@"Scan" bundle:nil] autorelease];
            [self pushVC:scan animated:NO];
            break;
        }
        case 2:
        {
            //团购
            [self enterIntoGroupList];
             break;
        }
            
        default:
            break;
    }
}

//刷新模块A列表
-(void)updateCMSModuleA
{
    UIView*moduleView=[m_ScrollView viewWithTag:moduleTag];
    CGFloat yValueInScroll=120+moduleView.frame.size.height;
    [modelATable reloadData];
    [self adjustModulesHeight];
    int  increace = m_AdArray.count;
    [m_ScrollView setContentSize:CGSizeMake(320, yValueInScroll+increace*250.0)];
}


#pragma mark    返回首页主页面
-(void)returntoHomePage {
    [self.view setUserInteractionEnabled:YES];
    [m_ScrollView setScrollEnabled:YES];
	[UIView setAnimationsEnabled:NO];

    [self setUniqueScrollToTopFor:m_ScrollView];
    [self removeSubControllerClass:[BrandStoreViewController class]];
    [self removeAllMyVC];
    [m_ScrollView setContentOffset:CGPointZero animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResignFirstResponderFromHomepage" object:self];
}

#pragma mark tableview 新的model A
-(void)keywordBtnSelceted:(UIButton*)button type:(int)type{
    NSString *keyword=[button titleForState:UIControlStateNormal];
    if (keyword!=nil)
    {
        SearchResult *searchResult=[[[SearchResult alloc] initWithKeyword:keyword fromTag:FROM_AD_MODEL] autorelease];
        [self pushVC:searchResult animated:YES];
    }
}

#pragma mark - 楼层图片点击事件入口
-(void)promotionTapcell:(HomePageModelACell*)cell withIdenty:(int)tag
{
    
    AdFloorInfo *floor = [OTSUtility safeObjectAtIndex:cell.tag inArray:m_AdArray];
    if (floor == nil)
    {
        return;
    }
    
    SpecialRecommendInfo *specialRecommentInfo = floor.productList[tag];
    if (specialRecommentInfo.type == kYaoSpecialProduct)
    {
        //进入商品页面
        [self enterIntoProductView:specialRecommentInfo.productId];
    }
    else if (specialRecommentInfo.type == kYaoSpecialBrand)
    {
        //品牌页面
        [self showAlertView:@"" alertMsg:@"暂无品牌页面" alertTag:12312];
        
    }
    else if (specialRecommentInfo.type == kYaoSpecialCatagory)
    {
        [self enterIntoCategoryList:specialRecommentInfo.catalogId];
    }
}

//进入商品页面
- (void)enterIntoProductView:(NSUInteger)productId
{
    OTSProductDetail *productDetail=[[[OTSProductDetail alloc] initWithProductId:productId promotionId:nil fromTag:PD_FROM_CATEGORY] autorelease];
    [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
    [self pushVC:productDetail animated:YES];
}


- (void)enterIntoCategoryList:(NSUInteger )cid
{
    //分类列表
    CategoryProductsViewController*cateProduct=[[[CategoryProductsViewController alloc] init] autorelease] ;
    cateProduct.cateId = [NSString stringWithFormat:@"%d", cid];
    
//构造一个根分类，从这里进去，分类里面显示根分类
    CategoryInfo *categoryInfo = [[CategoryInfo alloc] init];
    categoryInfo.cid = @"-1";
    categoryInfo.name = @"全部分类";
    cateProduct.currentCategory = categoryInfo;
    
    cateProduct.titleText=@"全部分类";
    cateProduct.isLastLevel=YES;
    [self pushVC:cateProduct animated:YES fullScreen:YES];
}
- (void)enterIntoGroupList
{
    //分类列表
    CategoryProductsViewController*cateProduct=[[[CategoryProductsViewController alloc] init] autorelease] ;
//    cateProduct.cateId = [NSString stringWithFormat:@"%d", cid];
    cateProduct.isTuangou = YES;
    //构造一个根分类，从这里进去，分类里面显示根分类
    CategoryInfo *categoryInfo = [[CategoryInfo alloc] init];
    categoryInfo.cid = @"-1";
    categoryInfo.name = @"全部分类";
    cateProduct.currentCategory = categoryInfo;
    
    cateProduct.titleText=@"全部分类";
    cateProduct.isLastLevel=YES;
    
    
    [self pushVC:cateProduct animated:YES fullScreen:YES];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DebugLog(@" m_AdArray.count--> %d", m_AdArray.count);
    return m_AdArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250.0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identify=@"cell";
    HomePageModelACell* cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil)
    {
        cell=[[[HomePageModelACell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
    }
    cell.delegate=self;

    DebugLog(@"m_array -> %@",m_AdArray);
    AdFloorInfo *floor = m_AdArray[indexPath.row];
    if (floor && [floor isKindOfClass:[AdFloorInfo class]])
    {
        NSLog(@"floor.keywordList  %@   %@",floor.keywordList,floor.title);
        
        cell.keywordsArray = floor.keywordList;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.tag=indexPath.row;
        
        if (floor.productList.count >= 1)
        {
            SpecialRecommendInfo *product = floor.productList[0];
            [cell loadBigImg:product.imageUrl title:product.name subTitle:product.name];
        }
        
        if (floor.productList.count >= 2)
        {
            SpecialRecommendInfo *product1 = floor.productList[1];
            [cell loadFistImg:product1.imageUrl title:product1.name subTitle:product1.name];
        }
        
        if (floor.productList.count >= 3)
        {
            SpecialRecommendInfo *product2 = floor.productList[2];
            [cell loadsecondImg:product2.imageUrl title:product2.name subTitle:product2.name];
        }
        
        [cell loadTitleImage:floor.titleImgUrl];
        
        
        int style= 1;
        NSString* tit=floor.title;
//        if (tit!=nil&&[tit isKindOfClass:[NSString class]]&&tit.length>0) {
            [cell freshCell:indexPath.row style:style title:tit];
//        }
    }
    return cell;
    
}
#pragma mark --

//在tabbar上选择第一个时调用此方法 -----linpan 2013-7-13
//刷新广告模块
-(void)updateAdModules
{
    //刷新广告模块 
    if (!isRefreshingAd)
    {
        isRefreshingAd=YES;
        [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadGetHotPage) toTarget:self withObject:nil];
    }
}

-(void)saveAdModulesToLocal:(AdvertisingPromotion *)adPromotion
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"SaveAdModule.plist"];
    
    NSMutableDictionary *mDictionary=[adPromotion dictionaryFromVO];
    
    if ([GlobalValue getGlobalValueInstance].provinceId)
    {
        [mDictionary setObject:[GlobalValue getGlobalValueInstance].provinceId forKey:@"provinceId"];
    }
    [mDictionary writeToFile:filename atomically:NO];
}

-(NSMutableDictionary *)getAdModulesFromLocal
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"SaveAdModule.plist"];
    NSMutableDictionary *mDictionary=[[[NSMutableDictionary alloc] initWithContentsOfFile:filename] autorelease];
    return mDictionary;
}




-(void)showError:(NSString *)errorInfo
{
    [AlertView showAlertView:nil alertMsg:errorInfo buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
}



#pragma mark    物流查询
-(void)enterLogisticQuery
{
    if ([GlobalValue getGlobalValueInstance].ywToken==nil)
    {
        [SharedDelegate enterUserManageWithTag:11];
        return;
    }
    
    NSAutoreleasePool * pool=[[NSAutoreleasePool alloc] init];
    
    [self removeSubControllerClass:[OTSMaterialFLowVC class]];
    
    OTSMaterialFLowVC* vc = [[[OTSMaterialFLowVC alloc] init] autorelease];
    [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
    [self pushVC:vc animated:YES];
//	[self setUniqueScrollToTopFor:(UIScrollView*)(vc.tv)];
    [pool drain];
}


#pragma mark 切换省份
//省份已切换
-(void)provinceChanged:(NSString *)provinceName
{
    self.m_NewProvinceStr = provinceName;
    [self refreshAllForProvinceChanged];
}

-(void)appFirstLaunch
{
    NSString *gpsProvinceStr=[GlobalValue getGlobalValueInstance].gpsProvinceStr;
    UIAlertView *alertView=[[OTSAlertView alloc] initWithTitle:@"收货省份选择" message:@"因各省份所售商品不同，请根据你的收货地址选择相应的省份" delegate:self cancelButtonTitle:@"其他省份" otherButtonTitles:[NSString stringWithFormat:@"选择%@",gpsProvinceStr], nil];
    [alertView setTag:ALERT_TAG_APP_FIRST_LAUNCH];
    [alertView show];
    [SharedDelegate setM_isAlertViewShowing:YES];
    [SharedDelegate setM_IsFirstLaunch:NO];
    [alertView release];
}

-(void)appFirstLaunchFail
{
    [self enterSwitchProvince];
}

-(void)alertChangeProvince:(int)alertTage
{
    NSString *gpsProvinceStr=[GlobalValue getGlobalValueInstance].gpsProvinceStr;
    NSString *message=[NSString stringWithFormat:@"定位到你当前在%@\n需要更换收货省份吗？",gpsProvinceStr];
    UIAlertView *alertView=[[OTSAlertView alloc] initWithTitle:@"省份切换" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:[NSString stringWithFormat:@"更换"], nil];
	[alertView setTag:alertTage];
    [alertView show];
    [SharedDelegate setM_isAlertViewShowing:YES];
    [alertView release];
}

-(void)appStartLaunch
{
    [self alertChangeProvince:ALERT_TAG_APP_START_LAUNCH];
}

-(void)appWakeFromBackGround
{
    [self alertChangeProvince:ALERT_TAG_APP_WAKE];
}

-(void)homePageSearchBarBecomeFirstResponder
{
    [m_Search.m_HomePageSearchBar becomeFirstResponder];
}

#pragma mark 切换省份
//省份切换刷新所有
-(void)refreshAllForProvinceChanged
{
    UIButton *selProvinceBtn=(UIButton *)[self.view viewWithTag:VIEW_TAG_SEL_PROVINCE_BUTTON];
    [selProvinceBtn setTitle:m_NewProvinceStr forState:UIControlStateNormal];
    
    NSNumber *selectedProvinceID=[[NSNumber alloc] initWithInt:[[m_ProvinceDic objectForKey:m_NewProvinceStr] intValue]];
    [[GlobalValue getGlobalValueInstance] setProvinceId:selectedProvinceID];
    [selectedProvinceID release];
    
    NSMutableArray *array=[[NSMutableArray alloc] init];
    [array addObject:m_NewProvinceStr];
    [[GPSUtil sharedInstance] saveProvinceToPlist:array];
    [array release];
    
    NSNumber* provinceId = [GlobalValue getGlobalValueInstance].provinceId;
    if (provinceId)
    {
        NSString* keyStr = [provinceId stringValue];
        NSArray* provinces = [m_ProvinceDic allKeysForObject:keyStr];
        NSString* provinceStr = [OTSUtility safeObjectAtIndex:0 inArray:provinces];
        self.m_CurrentProvinceStr = provinceStr;
    }

    
	//切换省份
    if (!isChangingProvince)
    {
		isChangingProvince=YES;
	}
    
    //更新省份对商品不影响 所以去掉
//    [self refreshHomePageData];
    
    [[GlobalValue getGlobalValueInstance] setLastRefreshTime:[NSDate date]];
}

-(void)newThreadUptBrowse:(NSNumber *)province
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    BrowseService *bServ=[[BrowseService alloc] init];
    @try {
        [bServ updateBrowseHistoryByInterface:province];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    [bServ release];
    [pool drain];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefleshImmediately" object:nil];
}

-(void)newThreadChangeProvince
{
//    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
//    UserService *service=[[[UserService alloc] init] autorelease];
//    NSString *token=[GlobalValue getGlobalValueInstance].token;
//    int provinceId=[[GlobalValue getGlobalValueInstance].provinceId intValue];
//    if (token!=nil)
//    {
//        int result=[service changeProvince:token provinceId:[NSNumber numberWithInt:provinceId]];
//        if (1==result) {
//            CartService* cser=[[CartService alloc] init];
//            int ProNumber = [cser countSessionCart:[GlobalValue getGlobalValueInstance].token siteType:[NSNumber numberWithInt:1]];
//            
//            [SharedDelegate clearCartNum];
//            if (ProNumber > 0)
//            {
//                [SharedDelegate setCartNum:ProNumber];
//            }
//            [cser release];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChanged" object:nil];
//		}
//        else
//        {
//            [self performSelectorOnMainThread:@selector(changeProvinceShow) withObject:nil waitUntilDone:NO];
//        }
//    }
//    else
//    {
//        Trader *trader=[GlobalValue getGlobalValueInstance].trader;
//        LocalCartService *tempLocalCartSer=[[[LocalCartService alloc] init] autorelease];
//        NSArray *SYNdates = [tempLocalCartSer getLocalCartSynDateFromSqlite3];
//        NSArray *productIds = [SYNdates objectAtIndex:0];
//        NSArray *merchantIds = [SYNdates objectAtIndex:1];
//        if (productIds!=nil && [productIds count]>0) {
//            __block NSArray *tempArray;
//            [self performInThreadBlock:^(){
//                tempArray = [[service updateCartProductUnlogin:trader productIds:productIds merchantIds:merchantIds provinceId:[NSNumber numberWithInt:provinceId]] retain];
//                [tempLocalCartSer changeLocalCartItemToSqlite3:tempArray];
//            } completionInMainBlock:^(){
//                int cartNum = [tempLocalCartSer getLocalCartNumberFromSqlite3];
//                [SharedDelegate clearCartNum];
//                if (cartNum>0) {
//                    [SharedDelegate setCartNum:cartNum];
//                }
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChanged" object:nil];
//                [tempArray release];
//            }];
//        }
//    }
//    isChangingProvince=NO;
//    [pool drain];
}

-(void)changeProvinceShow
{
    UIAlertView * tempAlt = [[OTSAlertView alloc]initWithTitle:nil message:@"切换省份失败"delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [tempAlt show];
    [tempAlt release];
    tempAlt = nil;
}

-(void)enterSwitchProvince
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ResignFirstResponderFromHomepage" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddSwitchProvinceForTabBar" object:nil];
}

-(void)switchToGPSProvince
{
    //crash -[NSPlaceholderString initWithString:]: nil argument
    
    
    NSString *mGpsProStr = @"";
    if ([GlobalValue getGlobalValueInstance].gpsProvinceStr) {
        mGpsProStr=[GlobalValue getGlobalValueInstance].gpsProvinceStr;
    }
    self.m_NewProvinceStr = mGpsProStr;
    if (m_NewProvinceStr == nil || m_CurrentProvinceStr == nil) {
        [self changeProvinceShow];
    }
    else if (![m_NewProvinceStr isEqualToString:m_CurrentProvinceStr]) {
        [self refreshAllForProvinceChanged];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"ProvinceChanged" object:mGpsProStr];
    }
}

#pragma mark 是否支持屏幕自动旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

//成人用品分类的配置
- (void)newThreadGetAdultConfig
{
    YWSystemService *ser = [[YWSystemService alloc] init];
    [GlobalValue getGlobalValueInstance].bShowAdultCategory = [ser isShowAdultCategory];
}


#pragma mark 版本更新
//获得版本更新数据
-(void)newThreadVersionUpdate {
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];

	YWSystemService * sServ = [[YWSystemService alloc]init] ;
	@try {
        
      VersionInfo *version = [sServ checkVersion];
      [self performSelectorOnMainThread:@selector(doVersionUpdate:) withObject:version waitUntilDone:NO];

	}
	@catch (NSException * e) {
	}
	@finally {
//         [sServ release];
		[pool drain];
	}
}
//版本更新
-(void)doVersionUpdate:(VersionInfo *)version
{
    VersionInfo *downloadVO = [version retain];
    
    [[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:YES];
	if (downloadVO != nil)
    {   //接口读取正常情况
		if ([downloadVO needUpdate])
        {   //有更新情况
			[[GlobalValue getGlobalValueInstance] setDownloadVO:downloadVO];
			if ([downloadVO mustUpdate])
            {
                //强制更新情况
				[self showAlertView:@"更新提示" alertMsg:[NSString stringWithFormat:@"%@", downloadVO.versionDesc] alertTag:ALERT_TAG_FORCEUPDATE_TRUE];
			}
            else if (![downloadVO mustUpdate])
            {
                //非强制更新情况
				[self showAlertView:@"更新提示" alertMsg:[NSString stringWithFormat:@"%@", downloadVO.versionDesc] alertTag:ALERT_TAG_FORCEUPDATE_FALSE];
			}
		}
	}
    [downloadVO release];
}



#pragma mark   焦点图pageview相关delegate
- (void)pageView:(OTSPageView *)pageView pageChangedTo:(NSIndexPath *)indexPath{
}

- (void)pageView:(OTSPageView *)pageView didTouchOnPage:(NSIndexPath *)indexPath{
    NSInteger index = [indexPath row];
    if (index>=[hotTopFivePage.objList count])
    {
        return;
    }
    
    
    SpecialRecommendInfo *recommendInfo = [hotTopFivePage.objList objectAtIndex:index];
    if (recommendInfo.type == kYaoSpecialBrand)
    {
         [self showAlertView:@"" alertMsg:@"品牌页面暂时没有" alertTag:12321];
    }
    else if (recommendInfo.type == kYaoSpecialCatagory)
    {
        [self enterIntoCategoryList:recommendInfo.catalogId];
    }
    else if (recommendInfo.type == kYaoSpecialProduct)
    {
        [self enterIntoProductView:recommendInfo.productId];
    }
}

- (UIView *)pageView:(OTSPageView *)pageView pageAtIndexPath:(NSIndexPath *)indexPath{
    UIImageView *imageView=[[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, pageView.frame.size.width, pageView.frame.size.height)] autorelease];
    NSInteger i=[indexPath row];
    if (i>=[hotTopFivePage.objList count]) {
        imageView.image = [UIImage imageNamed:@"defaultimg320x120.png"];
    }
    else
    {
    
    //用于药店修改 Linpan
//        NSString *fileName=[((HotPointNewVO *)[hotTopFivePage.objList objectAtIndex:i]).picUrl stringFromMD5];
//        UIImage *image=[ImageCache getImageFromFile:fileName];
        
        NSString *fileName=[((SpecialRecommendInfo *)[hotTopFivePage.objList objectAtIndex:i]).imageUrl stringFromMD5];
        UIImage *image=[ImageCache getImageFromFile:fileName];
        if (image != nil) {
            imageView.image = image;
        } else {
            imageView.image = [UIImage imageNamed:@"defaultimg320x120.png"];
        }
    }
    return imageView;
}


- (NSInteger)numberOfPagesInPageView:(OTSPageView *)pageView {
    if (hotTopFivePage==nil || hotTopFivePage.objList==nil)
    {
        return 1;
    }
    return [hotTopFivePage.objList count];
}


#pragma mark EGORefreshTableHeaderView相关delegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
    [self refreshHomePageData];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
	return isRefreshingHotPage;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
	return [NSDate date];
}

#pragma mark    scrollView相关delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==m_ScrollView) {
        [m_RefreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (scrollView==m_ScrollView) {
        [m_RefreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark    alertView的delegate
//点击alertView完成按钮进行的操作
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	switch (alertView.tag) {
		case ALERT_TAG_FORCEUPDATE_FALSE://非强制更新
			if (buttonIndex == 1)
            {
                NSString* updateAppUrl=[GlobalValue getGlobalValueInstance].downloadVO.updateUrl;
                if (updateAppUrl==nil)
                {
//                    updateAppUrl = @"http://itunes.apple.com/cn/app/id427457043?mt=8&ls=1";
                }
				NSURL * iTunesUrl = [NSURL URLWithString:updateAppUrl];
				[[UIApplication	sharedApplication] openURL:iTunesUrl];
                [[GlobalValue getGlobalValueInstance] setDownloadVO:nil];
                [SharedDelegate setIsVersionUpdate:YES];
			}
			break;
		case ALERT_TAG_FORCEUPDATE_TRUE://强制更新
			if (buttonIndex == 0)
            {
                NSString* updateAppUrl=[GlobalValue getGlobalValueInstance].downloadVO.updateUrl;
                if (updateAppUrl==nil)
                {
//                    updateAppUrl=@"http://itunes.apple.com/cn/app/id427457043?mt=8&ls=1";
                }
				NSURL * iTunesUrl = [NSURL URLWithString:updateAppUrl];
				[[UIApplication	sharedApplication] openURL:iTunesUrl];
                [[GlobalValue getGlobalValueInstance] setDownloadVO:nil];
                [SharedDelegate setIsVersionUpdate:YES];
			}
			break;
        case ALERT_TAG_APP_FIRST_LAUNCH: {
            if (buttonIndex==0) {
                [self enterSwitchProvince];
            } else if (buttonIndex==1) {
                [self switchToGPSProvince];
            }
            break;
        }
        case ALERT_TAG_APP_START_LAUNCH: {
            if (buttonIndex==1) {
                [self switchToGPSProvince];
            }
            break;
        }
        case ALERT_TAG_APP_WAKE: {
            if (buttonIndex==1) {
                [self switchToGPSProvince];
				[SharedDelegate enterHomePageRoot];
            }
            break;
        }
		default:
			break;
	}
    [[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:NO];
    [SharedDelegate setM_isAlertViewShowing:NO];
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
	for( UIView * view in alertView.subviews ) {
		if([view isKindOfClass:[UILabel class]]) {
			UILabel* label = (UILabel*) view;
			if ((alertView.tag ==  ALERT_TAG_APP_WAKE)||(alertView.tag == ALERT_TAG_APP_START_LAUNCH) ||(alertView.tag == ALERT_TAG_APP_FIRST_LAUNCH)) {
				label.textAlignment = NSTextAlignmentCenter;
			} else {
				label.textAlignment = NSTextAlignmentLeft;
			}
		}
	}
}

//显示提示框
-(void)showAlertView:(NSString *) alertTitle alertMsg:(NSString *)alertMsg alertTag:(int)alertTag {
	[[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:YES];
    UIAlertView * alert;
    if (alertTag == ALERT_TAG_FORCEUPDATE_TRUE)
    {
        alert = [[OTSAlertView alloc]initWithTitle:alertTitle message:alertMsg delegate:self cancelButtonTitle:@"更新" otherButtonTitles:nil];
    }
    else if (alertTag == ALERT_TAG_FORCEUPDATE_FALSE)
    {
        alert = [[OTSAlertView alloc]initWithTitle:alertTitle message:alertMsg delegate:self cancelButtonTitle:@"稍后" otherButtonTitles:@"更新", nil];
    }
    else
    {
        alert = [[OTSAlertView alloc]initWithTitle:alertTitle message:alertMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
    }
    alert.tag = alertTag;
	[alert show];
	[alert release];
	alert = nil;
}


#pragma mark    取消加载view
-(void)releaseResource
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    OTS_SAFE_RELEASE(modulesArray);
    OTS_SAFE_RELEASE(m_ScrollView);
    OTS_SAFE_RELEASE(m_ProvinceDic);
    OTS_SAFE_RELEASE(m_CurrentProvinceStr);
    OTS_SAFE_RELEASE(m_NewProvinceStr);
    OTS_SAFE_RELEASE(hotTopFivePage);
    OTS_SAFE_RELEASE(m_Search);
    OTS_SAFE_RELEASE(m_UpdateTag);
    OTS_SAFE_RELEASE(m_RefreshHeaderView);
    OTS_SAFE_RELEASE(m_PageView);
}
-(void)viewDidUnload
{
	[self releaseResource];
    [super viewDidUnload];
}
- (void)dealloc {
	[self releaseResource];
    OTS_SAFE_RELEASE(m_AdArray);
    OTS_SAFE_RELEASE(modelATable);
    [super dealloc];
}
@end

