//
//  ViewController.m
//  yhd
//
//  Created by  on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "ProductListViewController.h"
#import "HotPointVO.h"
#import "HomeModuleVO.h"
#import "ImagePageControl.h"
#import "ImageScroll.h"
#import "TopView.h"
#import "Page.h"
#import "CategoryVO.h"
#import "HotPointVO.h"
#import "HotPointNewVO.h"
#import "ProductVO.h"
#import <QuartzCore/QuartzCore.h>
#import "ProvinceVO.h"
#import "SearchResultVO.h"
#import "PADCartViewController.h"
#import "ConnectUrl.h"
#import "SDImageView+SDWebCache.h"
//#import "MyPageControl.h"
#import "MyListViewController.h"
#import "AdImageView.h"
#import "LocalCartItemVO.h"
#import "ProductVO.h"
#import "CartItemVO.h"
#import "ImageScrollView.h"
//#import "GroupListViewController.h"
#import "UserService.h"
#import "CartService.h"
#import "UserManageTool.h"
#import "OTSGpsHelper.h"
#import "OTSGrouponHomePage.h"


#define  kCateViewTag 150
#define  kCateTableView2Tag 101

#define  kAdImageScrollViewTag 200
#define  kCateActivityViewTag 300
#define  kTimerTime 6

// define operation id keys
#define OPER_ID_KEY_HOME_HOT            @"OPER_ID_KEY_HOME_HOT"
#define OPER_ID_KEY_CATEGORY_1ST        @"OPER_ID_KEY_CATEGORY_1ST"
#define OPER_ID_KEY_PROVINCE            @"OPER_ID_KEY_PROVINCE"
#define OPER_ID_KEY_CATEGORY_3RD        @"OPER_ID_KEY_CATEGORY_3RD"
#define OPER_ID_KEY_CATEGORY_2AND3      @"OPER_ID_KEY_CATEGORY_2AND3"


@interface ViewController ()

@end

@implementation ViewController
@synthesize images,listData,selectedCateid,hotImages,rootCate1,rootCate2,rootCate3,cate2Dic;
@synthesize categories = _categories;

#pragma mark -
#pragma mark yhd Service
-(void)getRootCateService:(NSNumber *)rootCategoryId
{
    //@synchronized([self class])
    {
        //缓存分类数据 缓存时间为一天
        NSString *_KEY = [NSString stringWithFormat:@"%@_%@",rootCategoryId, [OTSUtility NSDateToNSStringDateV2:[NSDate date]]];
        Page *page = [OTSUtility getPagesFromLocal:@"CATEGORY" withKey:_KEY];
        
        if (!page) {
            page = [[OTSServiceHelper sharedInstance] getCategoryByRootCategoryId:[GlobalValue getGlobalValueInstance].trader
                                                                         mcsiteId:[NSNumber numberWithInt:1]
                                                                   rootCategoryId:rootCategoryId
                                                                      currentPage:[NSNumber numberWithInt:1]
                                                                         pageSize:[NSNumber numberWithInt:50]];
            [OTSUtility putPagesToLocal:page withPageName:@"CATEGORY" withKey:_KEY];
        }
        
        // tracking 统计
        JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_CategoryRoot extraPrama:@"1", rootCategoryId, nil]autorelease];
        [DoTracking doJsTrackingWithParma:prama];
        if ([rootCategoryId intValue] == 0)
        {
            [self performSelectorOnMainThread:@selector(handleRootCate:) withObject:page.objList waitUntilDone:YES];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(handleCate:) withObject:page.objList waitUntilDone:YES];
        }
    }
}
-(void)getCate2AndCate3ServicwByRootCategoryId:(NSNumber *)rootCategoryId{
    {
        NSArray* arr = [[OTSServiceHelper sharedInstance] getCategoryByRootCategoryId:[GlobalValue getGlobalValueInstance].trader
                                                                             mcsiteId:[NSNumber numberWithInt:1]
                                                                       rootCategoryId:rootCategoryId];
        // tracking 统计
        JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_CategoryRoot extraPrama:@"1", rootCategoryId, nil]autorelease];
        [DoTracking doJsTrackingWithParma:prama];
        
        if (arr != nil) {
            [self performSelectorOnMainThread:@selector(handleCate:) withObject:arr waitUntilDone:YES];
        }
    }
}
-(void)getCate3Service:(NSNumber *)rootCategoryId
{
    //@synchronized([self class])
    {
        //缓存分类数据 缓存时间为一天
        NSString *_KEY = [NSString stringWithFormat:@"%@_%@",rootCategoryId, [OTSUtility NSDateToNSStringDateV2:[NSDate date]]];
        Page *page = [OTSUtility getPagesFromLocal:@"CATEGORY" withKey:_KEY];
        if(!page)
        {
            page = [[OTSServiceHelper sharedInstance] getCategoryByRootCategoryId:[GlobalValue getGlobalValueInstance].trader
                                                                         mcsiteId:[NSNumber numberWithInt:1]
                                                                   rootCategoryId:rootCategoryId
                                                                      currentPage:[NSNumber numberWithInt:1]
                                                                         pageSize:[NSNumber numberWithInt:50]];
            [OTSUtility putPagesToLocal:page withPageName:@"CATEGORY" withKey:_KEY];
        }
        
        // tracking 统计
        JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_CategoryRoot extraPrama:@"1", rootCategoryId, nil]autorelease];
        [DoTracking doJsTrackingWithParma:prama];
        NSArray *array = nil;
        if (page.objList)
        {
            array = [NSArray arrayWithObjects:rootCategoryId, page.objList, nil];
        }
        else
        {
            array=[NSArray arrayWithObjects:rootCategoryId, [NSArray array], nil];
        }
        
        
        [self performSelectorOnMainThread:@selector(handleCate3:) withObject:array waitUntilDone:YES];
    }
}



//首页轮播大图
/*
 -(void)getHomeService:(NSNumber *)provinceId
 {
 //@synchronized([self class])
 {
 Page *page = [[OTSServiceHelper sharedInstance]
 getHomeHotPointListNew:[GlobalValue getGlobalValueInstance].trader
 provinceId:dataHandler.province.nid
 currentPage:[NSNumber numberWithInt:1]
 pageSize:[NSNumber numberWithInt:50]];
 
 if (page.objList)
 {
 [self performSelectorOnMainThread:@selector(handleHomePointList:) withObject:page.objList waitUntilDone:YES];
 }
 }
 }
 */


//首页轮播图
-(void)getHomeHotService
{
    //缓存轮播图数据 缓存时间为一天
    NSString * _KEY = [NSString stringWithFormat:@"p%@_%@",[OTSGpsHelper sharedInstance].provinceVO.nid,[OTSUtility NSDateToNSStringDateV2:[NSDate date]]];
    Page *page = [OTSUtility getPagesFromLocal:@"HOMEHOTPOINT" withKey:_KEY];
    if (!page) {
        page = [[OTSServiceHelper sharedInstance] getHomeHotPointListNew:[GlobalValue getGlobalValueInstance].trader provinceId:[OTSGpsHelper sharedInstance].provinceVO.nid currentPage:[NSNumber numberWithInt:1] pageSize:[NSNumber numberWithInt:50]];
        [OTSUtility putPagesToLocal:page withPageName:@"HOMEHOTPOINT" withKey:_KEY];
    }
    else
    {
        [self otsDetatchMemorySafeNewThreadSelector:@selector(threadsavehomehotpoint:) toTarget:self withObject:_KEY];
    }
    
    if (page.objList)
    {
        [self performSelectorOnMainThread:@selector(handleHomeHotPointList:) withObject:page.objList waitUntilDone:YES];
    }
}

-(void)threadsavehomehotpoint:(NSString *) key
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    Page *page = [[OTSServiceHelper sharedInstance] getHomeHotPointListNew:[GlobalValue getGlobalValueInstance].trader provinceId:[OTSGpsHelper sharedInstance].provinceVO.nid currentPage:[NSNumber numberWithInt:1] pageSize:[NSNumber numberWithInt:50]];
    [OTSUtility putPagesToLocal:page withPageName:@"HOMEHOTPOINT" withKey:key];
    [pool drain];
}

-(void)getProvinceService
{
    //@synchronized([self class])
    {
        NSArray *array = [[OTSServiceHelper sharedInstance] getAllProvince :[GlobalValue getGlobalValueInstance].trader];
        
        [self performSelectorOnMainThread:@selector(handleProvince:) withObject:array waitUntilDone:YES];
    }
}

#pragma mark -
-(void)doServiceWithOperationKey:(NSString*)aOperationKey withObject:(id)anObject
{
    if ([aOperationKey isEqualToString:OPER_ID_KEY_HOME_HOT])
    {
        [self doAction:@selector(getHomeHotService) withObject:anObject forKey:OPER_ID_KEY_HOME_HOT];
    }
    
    else if ([aOperationKey isEqualToString:OPER_ID_KEY_CATEGORY_1ST])
    {
        [self doAction:@selector(getRootCateService:) withObject:anObject forKey:OPER_ID_KEY_CATEGORY_1ST];
    }
    
    else if ([aOperationKey isEqualToString:OPER_ID_KEY_PROVINCE])
    {
        [self doAction:@selector(getProvinceService) withObject:anObject forKey:OPER_ID_KEY_PROVINCE];
    }
    
    else if ([aOperationKey isEqualToString:OPER_ID_KEY_CATEGORY_3RD])
    {
        [self doAction:@selector(getCate3Service:) withObject:anObject forKey:OPER_ID_KEY_CATEGORY_3RD];
    }
    else if ([aOperationKey isEqualToString:OPER_ID_KEY_CATEGORY_2AND3]){
        [self doAction:@selector(getCate2AndCate3ServicwByRootCategoryId:) withObject:anObject forKey:OPER_ID_KEY_CATEGORY_2AND3];
    }
}

#pragma mark - memory
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [images release];
    [hotImages release];
    [listData release];
    [cate2Dic release];
    [selectedCateid release];
    [rootCate1 release];
    [rootCate2 release];
    [rootCate3 release];
    
    [_categories release];
    
    [super dealloc];
}

#pragma mark - view management
- (void)viewDidLoad
{
    //http://ditu.google.cn/maps/geo?output=csv&key=abcdef&q=31.18,121.18
    NSLog(@"%@",[ConnectUrl getConnectUrlAddress]);
    
    JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_HomePage extraPramaDic:nil]autorelease];
    [DoTracking doJsTrackingWithParma:prama];
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleProVinceChange:)name:kNotifyProvinceChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppBecomeActive:)name:kNotifyAppBecomeActive object:nil];
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor=[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0];
    self.cate2Dic=[NSMutableDictionary dictionaryWithCapacity:1];
    self.categories=[NSMutableArray arrayWithCapacity:5];
    self.hotImages=[NSMutableArray arrayWithCapacity:5];
    self.images=[NSMutableArray arrayWithCapacity:5];
    topView=[[TopView alloc] initWithFrame:CGRectMake(0, 0,768,kTopHeight)];
    [self.view addSubview:topView];
    [topView release];
    
    cateTableView.alwaysBounceVertical =NO;
    
    imageScroll=[[ImageScroll alloc]initWithFrame:CGRectMake(500, 400, 240, 100) width:250 height:250];
    imageScroll.imageScrollDelegate=self;
    [self.view addSubview:imageScroll];
    [imageScroll release];
    
    if (dataHandler.screenWidth==768) {
        adImageScrollView.frame=CGRectMake(244, 71, 770,290);
    } else {
        topView.frame=CGRectMake(0, 0,1024,kTopHeight);
        cateTableView.frame=CGRectMake(0, kTopHeight-1, 236,743-kTopHeight);
        adImageScrollView.frame=CGRectMake(244, 69, 770,290);
        imageScroll.frame=CGRectMake(244,376, 770,300);
        [imageScroll setBgImage:[UIImage imageNamed:@"main_cuxiaobg.png"]];
        wuliuBut.frame=CGRectMake(244, 691, 177, 52);
        yaoyaoBut.frame=CGRectMake(442, 691, 177, 52);
        tuanBut.frame=CGRectMake(639, 691, 177, 52);
        cuxiaoBut.frame=CGRectMake(837, 691, 177, 52);
    }
    //--------判断是否自动登录-------------
    if ([[[UserManageTool sharedInstance] GetAutoLoginStatus] isEqualToString:@"1"]) {
        [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadAutoLogin) toTarget:self withObject:nil];
    }
    
    [self pushFrontViews];
}

#pragma mark - 自动登录
//新线程自动登录
-(void)newThreadAutoLogin
{
	[self newThreadAutoLoginWithObject:nil finishSelector:@selector(getSessionCartHandle:)];
}

-(void)getSessionCartHandle:(CartVO *)cartVO
{
    
    [[DataHandler sharedDataHandler] setCart:cartVO];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartChange object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartCacheChange object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [topView setCartCount:dataHandler.cart.totalquantity.intValue];
    topView.addressLabel.text=[OTSGpsHelper sharedInstance].provinceVO.provinceName;
    [MobClick beginLogPageView:@"home"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"home"];
}

- (void)loadAdImageScrollView{
    
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)gestureRecognizer {
    [self closeCateView];
    
}


-(IBAction)openFavoriteView:(id)sender{
    if ([GlobalValue getGlobalValueInstance].token) {
        CATransition *transition = [CATransition animation];
        transition.duration = OTSP_TRANS_DURATION;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type =kCATransitionFade; 
        transition.subtype = kCATransitionFromRight;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        MyListViewController *temp=[[MyListViewController alloc] initWithNibName:@"MyListViewController" bundle:nil];
        temp.mIsLoadingFavourite=YES;
        [self.navigationController pushViewController:temp animated:NO];
        [temp release];
        
        JSTrackingPrama* prama = [[JSTrackingPrama alloc]initWithJSType:EJStracking_FavouriteList extraPrama:nil];
        [DoTracking doJsTrackingWithParma:prama];
    }
    else
    {
        mIsLoadingFavourite=YES;
        mloginViewController = [[LoginViewController alloc]init];
        mloginViewController.delegate = self;
        DataHandler * datehandle = [DataHandler sharedDataHandler];
        [mloginViewController setMcart:datehandle.cart];
        if (datehandle.cart.totalquantity!=0)
        {
            [mloginViewController setMneedToAddInCart:YES];
        }
        UIView * newview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
        [self.view addSubview:newview];
        [newview setBackgroundColor:[UIColor grayColor]];
        [newview setAlpha:0.5];
        [newview setTag:kLoginViewTag];
        
        mloginViewController.view.tag = kRealLoginViewTag;
        [self.view addSubview:mloginViewController.view];
        [mloginViewController.view setFrame:CGRectMake(1024, 0, 1024, 768)];
        [self moveToLeftSide:mloginViewController.view];
        [newview release];
        //UISwipeGestureRecognizer
        UISwipeGestureRecognizer * swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromLogin:)];
        swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
        [mloginViewController.view addGestureRecognizer:swipeGes];
        [swipeGes release];
    }
}


-(IBAction)openHistroy:(id)sender{
    
    CATransition *transition = [CATransition animation];
    transition.duration = OTSP_TRANS_DURATION;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type =kCATransitionFade; 
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    ProductListViewController *myController = 
    [[ProductListViewController alloc]initWithNibName:nil bundle:nil] ;
    myController.cateid=[NSNumber numberWithInt:0];
    //myController.keyword=textField.text;
    myController.productListType=4;
    myController.listData = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject: listData]];
    
    [self.navigationController pushViewController:myController animated:NO];
    [myController release];
    [MobClick event:@"history"];
    
    JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_History extraPramaDic:nil]autorelease];
    [DoTracking doJsTrackingWithParma:prama];
}

-(IBAction)openPromotion:(id)sender{  // 打开团购
    [MobClick event:@"click_groupon"];
    CATransition *transition = [CATransition animation];
    transition.duration = OTSP_TRANS_DURATION;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type =kCATransitionFade; 
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    OTSGrouponHomePage *myController=[[OTSGrouponHomePage alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:myController animated:NO];
    [myController release];
    
    //点1号团数据统计
    JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_GroupLogo extraPramaDic:nil]autorelease];
    [DoTracking doJsTrackingWithParma:prama];
}

-(IBAction)openTrack:(id)sender{
    if ([GlobalValue getGlobalValueInstance].token) {
        CATransition *transition = [CATransition animation];
        transition.duration = OTSP_TRANS_DURATION;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type =kCATransitionFade; 
        transition.subtype = kCATransitionFromRight;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        MyListViewController *temp=[[MyListViewController alloc] initWithNibName:@"MyListViewController" bundle:nil];
        //temp.mIsLoadingFavourite=YES;
        [self.navigationController pushViewController:temp animated:NO];
        [temp release];
    }
    else
    {
        mIsLoadingFavourite=NO;
        mloginViewController = [[LoginViewController alloc]init];
        mloginViewController.delegate = self;
        DataHandler * datehandle = [DataHandler sharedDataHandler];
        [mloginViewController setMcart:datehandle.cart];
        if (datehandle.cart.totalquantity!=0)
        {
            [mloginViewController setMneedToAddInCart:YES];
        }
        UIView * newview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
        [self.view addSubview:newview];
        [newview setBackgroundColor:[UIColor grayColor]];
        [newview setAlpha:0.5];
        [newview setTag:kLoginViewTag];
        
        mloginViewController.view.tag = kRealLoginViewTag;
        [self.view addSubview:mloginViewController.view];
        [mloginViewController.view setFrame:CGRectMake(1024, 0, 1024, 768)];
        [self moveToLeftSide:mloginViewController.view];
        [newview release];
        //UISwipeGestureRecognizer
        UISwipeGestureRecognizer * swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromLogin:)];
        swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
        [mloginViewController.view addGestureRecognizer:swipeGes];
        [swipeGes release];
    }
    
}

- (void)handleSwipeFromLogin:(UISwipeGestureRecognizer *)gestureRecognizer {
    [self loginclosed]; 
}

-(void)search:(id)sender
{
    [SharedPadDelegate goSearch:sender];
}

//进入购物车
- (void)openCartViewController
{
    [SharedPadDelegate enterCart];
}

#pragma mark -
#pragma mark ImageScrollDelegate
-(void)enterCMSPage:(HotPointNewVO *)hotPointNewVO
{
    NSString* promotionId = hotPointNewVO.promotionId ? [NSString stringWithFormat:@"%@",hotPointNewVO.promotionId] : hotPointNewVO.topicId;
    JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_AD_HotPage extraPrama:promotionId,nil]autorelease];
    [DoTracking doJsTrackingWithParma:prama];
    
    int type=[hotPointNewVO.type intValue];
    if (type==3) {//团购首页
        [MobClick event:@"click_groupon"];
        CATransition *transition = [CATransition animation];
        transition.duration = OTSP_TRANS_DURATION;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type =kCATransitionFade; 
        transition.subtype = kCATransitionFromRight;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        OTSGrouponHomePage *myController=[[OTSGrouponHomePage alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:myController animated:NO];
        [myController release];
    } else {
        NSArray *firstSplit = [hotPointNewVO.detailUrl componentsSeparatedByString:@"/"]; 
        NSString *activityIDStr=[firstSplit lastObject];
        long long activityIDL=[activityIDStr longLongValue];
        
        CATransition *transition = [CATransition animation];
        transition.duration = OTSP_TRANS_DURATION;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type =kCATransitionFade; 
        transition.subtype = kCATransitionFromRight;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        ProductListViewController *myController = 
        [[ProductListViewController alloc]initWithNibName:nil bundle:nil] ;
        myController.cateid=[NSNumber numberWithInt:0];
        
        myController.activityID=[NSNumber numberWithLongLong:activityIDL];// [NSNumber numberWithLongLong:2012080201];
        myController.activityTitle=hotPointNewVO.title;
        myController.productListType=3;
        myController.listData = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:listData]];
        
        [self.navigationController pushViewController:myController animated:NO];
        [myController release];
        [MobClick event:@"show_promotion"];
    }
}
#pragma mark -
#pragma mark handel UIPanGestureRecognizer 手势处理
-(void)handelTap:(UIPanGestureRecognizer*)gestureRecognizer{
    AdImageView *selectedImage= (AdImageView *)gestureRecognizer.view;
    [self enterCMSPage:selectedImage.hotPointNewVO];
}
#pragma mark - logindelegate
-(void)loginclosed
{
    [UIView animateWithDuration:OTSP_TRANS_DURATION animations:^{
        mloginViewController.view.frame = CGRectMake(1024, 0, 1024, 768);
    }
                     completion:^(BOOL finished)
     {
         [[self.view viewWithTag:kLoginViewTag] removeFromSuperview];
         [mloginViewController.view removeFromSuperview];
     }];
}
-(void)loginsucceed
{
    [UIView animateWithDuration:OTSP_TRANS_DURATION animations:^{
        mloginViewController.view.frame = CGRectMake(1024, 0, 1024, 768);
    }
                     completion:^(BOOL finished)
     {
         [[self.view viewWithTag:kLoginViewTag] removeFromSuperview];
         [mloginViewController.view removeFromSuperview];
     }];
    CATransition *transition = [CATransition animation];
    transition.duration = OTSP_TRANS_DURATION;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type =kCATransitionFade; 
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    MyListViewController *temp=[[MyListViewController alloc] initWithNibName:@"MyListViewController" bundle:nil];
    temp.mIsLoadingFavourite=mIsLoadingFavourite;
    [self.navigationController pushViewController:temp animated:NO];
    [temp release];
}

#pragma mark -
#pragma mark cellDelegate

// 打开二三级分类大页面
- (void)openCateView:(CategoryVO *)cate{
    
    
    UIView* cateView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, dataHandler.screenWidth, dataHandler.screenWidth==768?1024:768)];
    cateView.tag=kCateViewTag;
    cateView.backgroundColor=[UIColor clearColor];
    CGRect rect=cateView.frame;
    UIView *cateBg=[[UIView alloc]initWithFrame:rect];
    cateBg.backgroundColor=[UIColor grayColor];
    cateBg.alpha=0.4;
    [cateView addSubview:cateBg];
    [cateBg release];
    [self.view addSubview:cateView];
    [cateView release];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeCateView)];
    [cateBg addGestureRecognizer:tapGes];
    [tapGes release];
    
    rect.size.width-=kCateDetailViewX;
    rect.origin.x+=dataHandler.screenWidth;
    cateDetailView=[[UIView alloc]initWithFrame:rect];
    cateDetailView.backgroundColor=[UIColor whiteColor];
    [cateView addSubview:cateDetailView];
    [cateDetailView release];
    UIView *cateTop=[[UIView alloc]initWithFrame:CGRectMake(0, 16, rect.size.width, 45)];
    cateTop.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"cate_topbg.png"]];
    [cateDetailView addSubview:cateTop];
    [cateTop release];
    //NSLog(@"rect=%f=%f=%f=%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    UIButton *closeBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeBut setImage:[UIImage imageNamed:@"cate_topcancel.png"] forState:UIControlStateNormal];
    [closeBut setImage:[UIImage imageNamed:@"cate_topcancel.png"] forState:UIControlStateHighlighted];
    [closeBut addTarget:self action:@selector(closeCateView) forControlEvents:UIControlEventTouchUpInside];
    [closeBut setFrame:CGRectMake(rect.size.width-46, 7, 30, 30)];//
    [cateTop addSubview:closeBut];
    
    UILabel *cateNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0, 3, 270.0, 39.0) ];
    cateNameLabel.textColor =[UIColor whiteColor]; 
    cateNameLabel.text=[cate.categoryName stringByAppendingString:@"〉"];
    UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
    cateNameLabel.font=font;
    cateNameLabel.backgroundColor=[UIColor clearColor];
    [cateTop addSubview:cateNameLabel];
    [cateNameLabel release];
    
    //    UIButton *moreBut=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [moreBut setImage:[UIImage imageNamed:@"cate_more1.png"] forState:UIControlStateNormal];
    //    [moreBut setImage:[UIImage imageNamed:@"cate_more2.png"] forState:UIControlStateHighlighted];
    //    [moreBut addTarget:self action:@selector(closeCateView) forControlEvents:UIControlEventTouchUpInside];
    //    [moreBut setFrame:CGRectMake(25, 670, 112, 43)];//
    //    [cateDetailView addSubview:moreBut];
    
    
    rootCate1 = cate;
    
    //[self otsDetatchMemorySafeNewThreadSelector:@selector(getRootCateService:) toTarget:self withObject:rootCate1.nid];
    //[self doServiceWithOperationKey:OPER_ID_KEY_CATEGORY_1ST withObject:rootCate1.nid];
    [self doServiceWithOperationKey:OPER_ID_KEY_CATEGORY_2AND3 withObject:rootCate1.nid];
    
    UIImageView *activityBg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"activity_bg.png"]];
    activityBg.tag=kCateActivityViewTag;
    activityBg.frame=CGRectMake((cateDetailView.frame.size.width-75)/2,(cateDetailView.frame.size.height-75)/2, 75, 75);
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = CGRectMake(25,25, 25.0f, 25.0f);
    [activityBg addSubview:activityView];
    [activityView release];
    
    [cateDetailView  addSubview:activityBg];
    [activityBg release];
    [activityView startAnimating];
    
    [self moveToLeftSide:cateDetailView];
    
    //UISwipeGestureRecognizer
    UISwipeGestureRecognizer * swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [cateDetailView addGestureRecognizer:swipeGes];
    [swipeGes release];
    //[MobClick event:@"category_1"];
}
#pragma mark -
#pragma mark cell2Delegate
// 打开产品列表
- (void)openProductList:(CategoryVO *)cate2 cate3:(CategoryVO *)cate3{
    rootCate2=cate2;
    rootCate3=cate3;
    if (cate3) {
        self.selectedCateid=cate3.nid;
    }else {
        self.selectedCateid=cate2.nid;
    }
    [self closeCateView];
    //[MobClick event:@"show_category"];
    
}
#pragma mark -
#pragma mark notify AppBecomeActive
-(void)handleAppBecomeActive:(NSNotification *)note
{
    if (images==nil||images.count==0||hotImages==nil||hotImages.count==0)
    {
        //[self otsDetatchMemorySafeNewThreadSelector:@selector(getHomeHotService) toTarget:self withObject:nil];
        [self doServiceWithOperationKey:OPER_ID_KEY_HOME_HOT withObject:nil];
    }
    
    if (listData == nil || listData.count == 0)
    {
        //[self otsDetatchMemorySafeNewThreadSelector:@selector(getRootCateService:) toTarget:self withObject:[NSNumber numberWithInt:0]];
        [self doServiceWithOperationKey:OPER_ID_KEY_CATEGORY_1ST withObject:[NSNumber numberWithInt:0]];
    }
    
    if (dataHandler.provinceArray==nil||dataHandler.provinceArray.count==0)
    {
        //[self otsDetatchMemorySafeNewThreadSelector:@selector(getProvinceService) toTarget:self withObject:nil];
        [self doServiceWithOperationKey:OPER_ID_KEY_PROVINCE withObject:nil];
    }
    
}
#pragma mark -
#pragma mark notify ProVinceChange
-(void)handleProVinceChange:(NSNotification *)note{
    ProvinceVO *province=[note.userInfo objectForKey:@"province"];
    if(province){
        [self doServiceWithOperationKey:OPER_ID_KEY_HOME_HOT withObject:nil];
    }
}

-(void)handleHomeHotPointList:(NSArray *)array
{
    NSMutableArray *arrayLong = [NSMutableArray array];
    NSMutableArray *arraySquare = [NSMutableArray array];
    
    for (HotPointNewVO *hotnew in array) {
        //0-长形
        if ([hotnew.ipadPicType isEqualToNumber:[NSNumber numberWithInt:0]]) {
            [arrayLong addObject:hotnew];
        }
        //1-方形
        if ([hotnew.ipadPicType isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [arraySquare addObject:hotnew];
        }
    }
    
    //--------更新HotPointVO -> HotPointNewVO  ------------------
    //长形轮播图
    int n = [arrayLong count];
    if (n>0) {
        //--------------------接口返回时更新UI-----------------------------------
        if (adImageScrollView.subviews) {
            for (UIView *subView in adImageScrollView.subviews) {
                if ([subView isKindOfClass:[AdImageView class]]) {
                    [subView removeFromSuperview];
                    subView=nil;
                }
            }
        }
        [hotImages removeAllObjects];
        for(int i=0;i<n ;i++){
            HotPointNewVO *hot=[arrayLong objectAtIndex:i];
            NSURL *url=[NSURL URLWithString:hot.picUrl];
            if (url == nil) {
                url = [NSURL URLWithString:@""];
            }
            [hotImages addObject:url];
            
            AdImageView *adImageView=[[AdImageView alloc]initWithFrame:CGRectMake(770*i, 0, 770,290)];
            adImageView.userInteractionEnabled=YES;
            [adImageView setImageWithURL:url refreshCache:YES];
            [adImageView setHotPointNewVO:hot];
            [adImageScrollView addSubview:adImageView];
            [adImageView release];
            
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handelTap:)];
            [adImageView addGestureRecognizer:tapGes];
            [tapGes release];
        }
    }

    adImageScrollView.contentSize=CGSizeMake(770*n, 200);
    adImageScrollView.tag=kAdImageScrollViewTag;
    adImageScrollView.clipsToBounds = YES;
    adImageScrollView.scrollEnabled = YES;
    adImageScrollView.showsHorizontalScrollIndicator = NO;
    adImageScrollView.showsVerticalScrollIndicator = NO;
    adImageScrollView.directionalLockEnabled = YES;
    adImageScrollView.pagingEnabled = YES;
    adImageScrollView.delegate=self;
    int w=n*40-25;
    if (myPageControl) {
        [myPageControl removeFromSuperview];
        myPageControl=nil;
    }
    myPageControl =[[ImagePageControl alloc] initWithFrame:CGRectMake((770-w)/2+244,340,w,30) total:n];
    
    [myPageControl setSelectedNum:1];
    [self.view addSubview:myPageControl];
    [myPageControl release];
    if (timer) {
        if ([timer isValid]) {
            [timer invalidate];
            timer=nil;
        }
    }
    timer=[[NSTimer scheduledTimerWithTimeInterval:kTimerTime target:self selector:@selector(adImageViewAnimate:) userInfo:nil  repeats:YES] retain];
    
    ////////////////////////////
    
    //    NSRange range;
    //    range.location=n;
    //    range.length=array.count-n;
    //NSLog(@"handleHomeHotPointList finished==%@",array);
    //--------------------接口返回时更新UI-----------------------------------
//    if (images) {
//        [images removeAllObjects];
//    }
    //方形滚动条
    if (imageScroll && [arraySquare count]>0) {
        self.images = arraySquare;
        [imageScroll removeAllImage];
        [imageScroll setImagePoints:images imageSize:CGSizeMake(250, 250)];
    }
    [self pushFrontViews];
}

-(void)pushFrontViews
{
    [self.view bringSubviewToFront:topView];
    
    UIView *loginBgView = [self.view viewWithTag:kLoginViewTag];
    if (loginBgView)
    {
        [self.view bringSubviewToFront:loginBgView];
    }
    
    UIView *loginView = [self.view viewWithTag:kRealLoginViewTag];
    if (loginView)
    {
        [self.view bringSubviewToFront:loginView];
    }
}

-(void)handleRootCate:(NSArray *)array
{
    NSLog(@"handleRootCate finished");
    self.listData=array;//[NSMutableArray arrayWithArray: array];
    
    [cateTableView reloadData];
}

-(void)handleCate:(NSArray *)array
{
    //  NSLog(@"handleCate finished==%@",categories);
    self.categories = array;
    if (cateDetailView) {
        UIView *activityView=[cateDetailView viewWithTag:kCateActivityViewTag];
        if (activityView) {
            [activityView removeFromSuperview];
        }
        
        UITableView *cateTableView2=[[UITableView alloc]initWithFrame:CGRectMake(0, 60,cateDetailView.frame.size.width,kCateTable2Height) style:UITableViewStylePlain];
        cateTableView2.separatorStyle=UITableViewCellSeparatorStyleNone;
        cateTableView2.tag=kCateTableView2Tag;
        cateTableView2.delegate=self;
        cateTableView2.dataSource=self;
        [cateDetailView addSubview:cateTableView2];
        [cateTableView2 release];
    }
    
//    for (CategoryVO *cate in _categories)
//    {
//        //[self otsDetatchMemorySafeNewThreadSelector:@selector(getCate3Service:) toTarget:self withObject:cate.nid];
//        [self doServiceWithOperationKey:OPER_ID_KEY_CATEGORY_3RD withObject:cate.nid];
//    }
    
    
}
-(void)handleCate3:(NSArray *)array
{
    
    
    [cate2Dic setObject:[array objectAtIndex:1] forKey:[array objectAtIndex:0]];
    if (cateDetailView) {
        UITableView *cateTableView2=(UITableView *)[cateDetailView viewWithTag:kCateTableView2Tag];
        [cateTableView2 reloadData];
    }
    
    
}


-(void)handleProvince:(NSArray *)array{
    
    dataHandler.provinceArray=array;
    
    
}

-(void)adImageViewAnimate:(NSTimer*)theTimer{
    adImageScrollViewCount++;
    if (adImageScrollViewCount*770>=adImageScrollView.contentSize.width) {
        adImageScrollViewCount=0;
    }
    if (adImageScrollViewCount==0) {
        [adImageScrollView setContentOffset:CGPointMake(adImageScrollViewCount*770, 0) ];
    }else {
        [adImageScrollView setContentOffset:CGPointMake(adImageScrollViewCount*770, 0) animated:YES];
    }
    
    
    [myPageControl setSelectedNum:adImageScrollViewCount+1];
}

#pragma mark -
#pragma mark scrollView Delegate Methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (timer) {
        if ([timer isValid]) {
            [timer invalidate];
        }
        
    }
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.tag==kAdImageScrollViewTag) {
        if (!decelerate) {
            if (scrollView.tag==kAdImageScrollViewTag) {
                CGPoint offset = scrollView.contentOffset;
                CGRect bounds = scrollView.frame;
                [myPageControl setSelectedNum:offset.x / bounds.size.width+1];
                adImageScrollViewCount=offset.x / bounds.size.width;
                if (timer) {
                    [timer release];
                    timer=nil;
                }
                timer=[[NSTimer scheduledTimerWithTimeInterval:kTimerTime target:self selector:@selector(adImageViewAnimate:) userInfo:nil  repeats:YES] retain];
            }
        }
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag==kAdImageScrollViewTag) {
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.frame;
        [myPageControl setSelectedNum:offset.x / bounds.size.width+1];
        adImageScrollViewCount=offset.x / bounds.size.width;
        if (timer) {
            [timer release];
            timer=nil;
        }
        timer=[[NSTimer scheduledTimerWithTimeInterval:kTimerTime target:self selector:@selector(adImageViewAnimate:) userInfo:nil  repeats:YES] retain];
    }
}
#pragma mark -
#pragma mark Table Data Source Methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag==kCateTableView2Tag) {
        return 0.0;
    }
    return 61.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIImageView *headView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 236,61)];
    headView.image=[UIImage imageNamed:@"main_catetop.png"];
    //headView.backgroundColor=[UIColor colorWithRed:164.0/255.0 green:164.0/255.0 blue:164.0/255.0 alpha:1.0];
    
    //    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 236.0, 45.0) ];
    //    label1.textColor = [UIColor whiteColor];  
    //    label1.backgroundColor=[UIColor clearColor];
    //    label1.font=[label1.font fontWithSize:22.0];
    //    label1.textAlignment=NSTextAlignmentCenter;
    //    label1.text=@"所有商品分类";
    //    [headView insertSubview:label1 atIndex:1];
    //    [label1 release];
    
    
    return [headView autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //BookCell *cell=(BookCell *) [self tableView: tableView cellForRowAtIndexPath: indexPath];
    if (tableView.tag==kCateTableView2Tag) {
        Cate2Cell *cell=(Cate2Cell *) [self tableView: tableView cellForRowAtIndexPath: indexPath];
        return cell.height;
    }
    return kCateTableCellHeight;
}
- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==kCateTableView2Tag) {
        return [self.categories  count];
    }
    return [self.listData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (tableView.tag==kCateTableView2Tag) {
        static NSString *CustomCellIdentifier = @"Cate2CellIdentifier ";
        
        Cate2Cell *cell=[Cate2Cell alloc];
        NSUInteger row = [indexPath row];
        
        cell.cate2= [self.categories   objectAtIndex:row];
        //cell.cate3Array=[cate2Dic objectForKey:cell.cate2.nid];
        cell.cate3Array = cell.cate2.childCategoryVOList;
        cell.cellDelegate=self;
        [[cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellIdentifier]autorelease];
        int x=190;
        int y=30;
        if (cell.cate3Array)
        {
            //int i=0;
            for (int i=0;i<cell.cate3Array.count;i++) {
                if ([[cell.cate3Array objectAtIndex:i] isKindOfClass:[CategoryVO class]]) {
                    
                    
                    CategoryVO *cate3=[cell.cate3Array objectAtIndex:i];
                    UIButton *cate3But=[UIButton buttonWithType:UIButtonTypeCustom];
                    cate3But.layer.cornerRadius = 8;
                    cate3But.layer.masksToBounds = YES;
                    cate3But.tag=i;
                    [cate3But setTitleColor:kBlackColor forState:UIControlStateNormal];
                    [cate3But setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                    //NSLog(@"cate3==%@",cate3);
                    [cate3But setTitle:cate3.categoryName forState:UIControlStateNormal];
                    [cate3But setBackgroundImage:[UIImage imageNamed:@"cate_butbg.png"] forState:UIControlStateHighlighted];
                    [cate3But addTarget:cell action:@selector(cate3Click:) forControlEvents:UIControlEventTouchUpInside];
                    
                    UIFont *font=[UIFont fontWithName:kCellButFontname size:kCellButFontsize];
                    CGSize size =[cate3.categoryName sizeWithFont:font constrainedToSize:CGSizeMake(260, 30)];
                    cate3But.titleLabel.font=font;
                    if (x+size.width>870) {
                        x=190;
                        y+=40;
                    }
                    [cate3But setFrame:CGRectMake(x, y, size.width+4, 30.0)];//
                    [cell addSubview:cate3But];
                    x+=size.width+20;
                }
                // i++;
            }
        }
        else
        {
//            UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//            activityView.frame = CGRectMake(440.f, 27.0f, 25.0f, 25.0f);
//            [cell insertSubview:activityView atIndex:1];
//            [activityView startAnimating];
//            [activityView release];
            
        }
        
        UIImageView *lineView=[[UIImageView alloc] initWithFrame:CGRectMake(175, 30, 1, y)];
        lineView.image=[UIImage imageNamed:@"cate_line.png"];
        [cell insertSubview:lineView atIndex:1];
        [lineView release];
        
        UIImageView *kuangView1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cate_kuang1.png"]];
        [kuangView1 setFrame:CGRectMake(25.0, 20, 873,25)];
        [cell addSubview:kuangView1];
        [kuangView1 release];
        
        UIImageView *kuangView2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cate_kuang2.png"]];
        [kuangView2 setFrame:CGRectMake(25.0, 45, 873,y-1)];
        [cell addSubview:kuangView2];
        [kuangView2 release];
        
        UIImageView *kuangView3=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cate_kuang3.png"]];
        [kuangView3 setFrame:CGRectMake(25.0, 44+y, 873,1)];
        [cell addSubview:kuangView3];
        [kuangView3 release];
        
        
        [cell sendSubviewToBack:kuangView1];
        [cell sendSubviewToBack:kuangView2];
        [cell sendSubviewToBack:kuangView3];
        cell.height=45+y;
        
        return cell;
        
    }
    static NSString *CustomCellIdentifier = @"CateCellIdentifier ";
    
    CateCell *cell=[CateCell alloc];
    NSUInteger row = [indexPath row];
    cell.cate = [self.listData   objectAtIndex:row];
    cell.cellDelegate=self;
    [[cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellIdentifier]autorelease];
    if (row%2==0) {
        cell.isEven=YES;
        cell.contentView.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    }else {
        cell.contentView.backgroundColor=[UIColor whiteColor];
    }
    
    //类别名
    cell.cateNameLabel.text=cell.cate.categoryName;
    
    
    
    UIImageView *cateImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat: @"cate_%i.png",row]]];
    [cateImage setFrame:CGRectMake(25.0, 17, 25,25)];
    //    NSString *urlString=[cellDic objectForKey:@"avatarurl"];
    //    NSURL *url=[NSURL URLWithString:urlString];
    //    //NSData *imageData=[NSData dataWithContentsOfURL:url];
    //    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 42,42)];
    //    if(url) [imageView setImageWithURL:url];
    
    [cell addSubview:cateImage];
    
    [cateImage release];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    if (tableView.tag==kCateTableView2Tag) {
    //        return;
    //    }
    //    
    //    NSUInteger row = [indexPath row];
    //    CategoryVO *cate = [self.listData  objectAtIndex:row];
    //    
    //    UIView* cateView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, dataHandler.screenWidth, dataHandler.screenWidth==768?1024:768)];
    //    cateView.tag=kCateViewTag;
    //    cateView.backgroundColor=[UIColor clearColor];
    //    CGRect rect=cateView.frame;
    //    UIView *cateBg=[[UIView alloc]initWithFrame:rect];
    //     cateBg.backgroundColor=[UIColor grayColor];
    //    cateBg.alpha=0.4;
    //    [cateView addSubview:cateBg];
    //    [cateBg release];
    //    [self.view addSubview:cateView];
    //    [cateView release];
    //    
    //    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeCateView)];
    //    [cateBg addGestureRecognizer:tapGes];
    //    [tapGes release];
    //
    //    
    //    
    //    rect.size.width-=kCateDetailViewX;
    //    rect.origin.x+=dataHandler.screenWidth;
    //    cateDetailView=[[UIView alloc]initWithFrame:rect];
    //    cateDetailView.backgroundColor=[UIColor whiteColor];
    //    [cateView addSubview:cateDetailView];
    //    [cateDetailView release];
    //    UIView *cateTop=[[UIView alloc]initWithFrame:CGRectMake(0, 16, rect.size.width, 45)];
    //    cateTop.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"cate_topbg.png"]];
    //    [cateDetailView addSubview:cateTop];
    //    [cateTop release];
    //    //NSLog(@"rect=%f=%f=%f=%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    //    UIButton *closeBut=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [closeBut setImage:[UIImage imageNamed:@"cate_topcancel.png"] forState:UIControlStateNormal];
    //    [closeBut setImage:[UIImage imageNamed:@"cate_topcancel.png"] forState:UIControlStateHighlighted];
    //    [closeBut addTarget:self action:@selector(closeCateView) forControlEvents:UIControlEventTouchUpInside];
    //    [closeBut setFrame:CGRectMake(rect.size.width-46, 7, 30, 30)];//
    //    [cateTop addSubview:closeBut];
    //    
    //    UILabel *cateNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0, 3, 270.0, 39.0) ];
    //    cateNameLabel.textColor =[UIColor whiteColor]; 
    //    cateNameLabel.text=[cate.categoryName stringByAppendingString:@"〉"];
    //    cateNameLabel.font=[cateNameLabel.font fontWithSize:20.0];
    //    cateNameLabel.backgroundColor=[UIColor clearColor];
    //    [cateTop addSubview:cateNameLabel];
    //    [cateNameLabel release];
    //    
    ////    UIButton *moreBut=[UIButton buttonWithType:UIButtonTypeCustom];
    ////    [moreBut setImage:[UIImage imageNamed:@"cate_more1.png"] forState:UIControlStateNormal];
    ////    [moreBut setImage:[UIImage imageNamed:@"cate_more2.png"] forState:UIControlStateHighlighted];
    ////    [moreBut addTarget:self action:@selector(closeCateView) forControlEvents:UIControlEventTouchUpInside];
    ////    [moreBut setFrame:CGRectMake(25, 670, 112, 43)];//
    ////    [cateDetailView addSubview:moreBut];
    //    
    //    
    //    rootCate1 = [self.listData objectAtIndex:row];
    //    
    //    [self otsDetatchMemorySafeNewThreadSelector:@selector(getRootCateService:) toTarget:self withObject:rootCate1.nid];
    //      
    //    [self moveToLeftSide:cateDetailView];
    
    
}
- (void)closeCateView{
    [self moveToRightSide:cateDetailView];
}
// move view to left side
- (void)moveToLeftSide:(UIView *)view{
    
    [self animateHomeViewToSide:CGRectMake(kCateDetailViewX, view.frame.origin.y, view.frame.size.width, view.frame.size.height) view:view];
}


// move view to right side
- (void)moveToRightSide:(UIView *)view {
    
    [self animateHomeViewToSide:CGRectMake(dataHandler.screenWidth,view.frame.origin.y, view.frame.size.width, view.frame.size.height) view:view];
}

// animate home view to side rect
- (void)animateHomeViewToSide:(CGRect)newViewRect view:(UIView *)view{
    [UIView animateWithDuration:kShowCateDetailDuration
                     animations:^{
                         view.frame = newViewRect;
                     } 
                     completion:^(BOOL finished){
                         
                         UIView *cateView=[self.view viewWithTag:kCateViewTag];
                         if (view.frame.origin.x==dataHandler.screenWidth) {
                             [cateView removeFromSuperview];
                             cateDetailView=nil;
                             if (selectedCateid) {
                                 CATransition *transition = [CATransition animation];
                                 transition.duration = OTSP_TRANS_DURATION;
                                 transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                 transition.type =kCATransitionFade; //@"cube";
                                 transition.subtype = kCATransitionFromRight;
                                 transition.delegate = self;
                                 [self.navigationController.view.layer addAnimation:transition forKey:nil];
                                 ProductListViewController *myController = 
                                 [[ProductListViewController alloc]initWithNibName:nil bundle:nil] ;
                                 myController.cateid=selectedCateid;
                                 myController.keyword=@"";
                                 myController.cate1=rootCate1;
                                 myController.cate2=rootCate2;
                                 myController.cate3=rootCate3;
                                 
                                 // myController.listData=[[NSArray alloc] initWithArray:listData copyItems:YES];
                                 NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject: listData]];
                                 myController.listData =array;
                                 
                                 [self.navigationController pushViewController:myController animated:NO];
                                 [myController release];
                                 selectedCateid=nil;
                             }
                         }
                     }];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    cateTableView=nil;
    wuliuBut=nil;
    cuxiaoBut=nil;
    yaoyaoBut=nil;
    tuanBut=nil;
    //adImageScrollView=nil;
    
    topView=nil;
    imageScroll=nil;
    imageScroll2=nil;
    //myPageControl=nil;
    cateDetailView=nil;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
										 duration:(NSTimeInterval)duration {     
    
    //CGRect bounds = [UIScreen mainScreen].bounds;
    //NSLog(@"UIScreen bounds: %@", NSStringFromCGRect(bounds));
    if (interfaceOrientation == UIInterfaceOrientationPortrait 
        || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        
        dataHandler.screenWidth=768;
        topView.frame=CGRectMake(0, 0,768,kTopHeight);
        cateTableView.frame=CGRectMake(0, 50, 236, 698);
    }else{
        
        dataHandler.screenWidth=1024;
        topView.frame=CGRectMake(0, 0,1024,kTopHeight);
        cateTableView.frame=CGRectMake(0, kTopHeight-1, 236,743-kTopHeight);
        adImageScrollView.frame=CGRectMake(244, 69, 770,290);
        imageScroll.frame=CGRectMake(244, 376, 770,300);
        [imageScroll setBgImage:[UIImage imageNamed:@"main_cuxiaobg.png"]];
        //        imageScroll2.frame=CGRectMake(244, 476, 770,217);
        //        [imageScroll2 setBgImage:[UIImage imageNamed:@"main_newbg.png"]];
        wuliuBut.frame=CGRectMake(244, 691, 177, 52);
        yaoyaoBut.frame=CGRectMake(442, 691, 177, 52);
        tuanBut.frame=CGRectMake(639, 691, 177, 52);
        cuxiaoBut.frame=CGRectMake(837, 691, 177, 52);
        
        
    }
}
#pragma mark - JSAnimatedImagesViewDelegate Methods

- (NSUInteger)animatedImagesNumberOfImages:(JSAnimatedImagesView *)animatedImagesView
{
    return hotImages.count;
}

- (UIImage *)animatedImagesView:(JSAnimatedImagesView *)animatedImagesView imageAtIndex:(NSUInteger)index
{
    
    int i= index + 1;
    [myPageControl setSelectedNum:i];
    //[animatedView bringSubviewToFront:animatedImagesViewLabel];
    //return [UIImage imageNamed:[NSString stringWithFormat:@"image%d.jpg", index + 1]];
    return [UIImage imageNamed:[images objectAtIndex:index]];
}
- (NSURL *)animatedImagesViewWithUrl:(JSAnimatedImagesView *)animatedImagesView imageAtIndex:(NSUInteger)index{
    int i= index + 1;
    [myPageControl setSelectedNum:i];
    return [hotImages objectAtIndex:index];
}
//#pragma mark -
//#pragma mark CLLocationManagerDelegate Methods
//- (void)locationManager:(CLLocationManager *)manager 
//    didUpdateToLocation:(CLLocation *)newLocation 
//           fromLocation:(CLLocation *)oldLocation {
//    
//    
//    localLatitude = newLocation.coordinate.latitude;
//    locaLongitude=newLocation.coordinate.longitude;
//    NSLog(@"%g==%g",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
//    [locationManager stopUpdatingLocation];
//    locationManager.delegate=nil;
//    
//   
//}
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
//    NSLog(@"locationManagerdidFail");
// 
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"  message:@"定位失败"   delegate:nil  cancelButtonTitle:@"确定"  otherButtonTitles:nil];  
//    [alert show];  
//    [alert release]; 
//}

@end
