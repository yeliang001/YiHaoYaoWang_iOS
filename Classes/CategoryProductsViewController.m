//
//  CategoryProductsViewController.m
//  TheStoreApp
//
//  Created by jun yuan on 12-9-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CategoryProductsViewController.h"
#import "GlobalValue.h"
//#import "CategoryVO.h"
#import "SDWebDataManager.h"
#import "OTSMfImageCache.h"
#import "OTSAlertView.h"
#import "CategoryProductCell.h"
#import "TheStoreAppAppDelegate.h"
#import "CategoryViewController.h"
#import "CategorySelectionCell.h"
#import "UITableView+LoadingMore.h"
#import "NSMutableArray+Stack.h"
#import "OTSProductDetail.h"
#import "OTSEverybodyWantsMe.h"
//#import "GTMBase64.h"
#import "SDImageView+SDWebCache.h"
#import "YWSearchService.h"
#import "SearchResultInfo.h"
#import "ProductInfo.h"
#import "CategoryInfo.h"
#import "YWLocalCatService.h"
#import "LocalCarInfo.h"
#import "UserInfo.h"
#import "YWBrowseService.h"
#import "GroupService.h"
#import "TuanCell.h"
#import "GiftInfo.h"
#import "ConditionInfo.h"
#import "PromotionInfo.h"
#import "LPPager.h"
#import "GiftView.h"

#define RED_TEXT_COLOR [UIColor colorWithRed:0.72 green:0.09 blue:0.07 alpha:1]
#define SORT_BY_DEFAULT 0    //对应默认排序
#define SORT_BY_TIME 1       //最新发布       
#define SORT_BY_PRICE_ASC 2  //价格最低
#define SORT_BY_PRICE_DESC 5 //价格最高  特殊处理，上传给服务器时要改为2 fuck
#define SORT_BY_COMMENT_DESC 3 //好评最高
#define SORT_BY_SALE  4        //销量最高


//#define GOODS_TAG 100
//#define MARKET_PRICE_TAG 105
//#define PRICE_TAG 101
//#define HAVE_GOODS_TAG 102
//#define BUTTON_TAG 103
//#define DEFAULT_IMAGE_TAG 104
//#define SHOPPING_COUNT_TAG 109

#define TABLEVIEW_NODECATEGOTY_CELL_HEIGHT 101
//#define LOADMORE_HEIGHT     40

#define ALERTVIEW_TAG_NET_EXCEPTION 300
//#define ALERTVIEW_TAG_OTHERS 302

#define BACKUPLEVEL  @"返回上级"
//#define URL_BASE_MALL_NO_ONE                        @"http://m.1mall.com/mw/product/"




@interface CategoryProductsViewController ()
@property(retain) NSMutableArray* selectionArray;
@property(retain) NSMutableArray* productsArray;//由网络获取的商品数据
@property(retain) NSMutableArray* trackCategoryIdArray;//实现一个stack，存储返回上级分类的id
@property(retain) NSMutableDictionary* trackCategoryDic;
//@property(nonatomic, retain)NSNumber* isDianzhongDian;
@property(nonatomic, retain)CartAnimation* cartAnimation;
@property(nonatomic)BOOL isCratAnimation;
@end

@implementation CategoryProductsViewController
@synthesize cateId;
//@synthesize promotionId;
@synthesize categoryTypeArray;
@synthesize titleText;
@synthesize titleLableText;


@synthesize isLastLevel;
//@synthesize isFailSatisfyFullDiscount;
@synthesize isCashPromotionList;
@synthesize selectionArray = _selectionArray;
@synthesize productsArray=_productsArray;
@synthesize trackCategoryIdArray=_trackCategoryIdArray;
@synthesize trackCategoryDic=_trackCategoryDic;
//@synthesize isDianzhongDian;
@synthesize cartAnimation;
@synthesize isCratAnimation;

#pragma mark - View Life

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    OTS_SAFE_RELEASE(m_backToTop);

    OTS_SAFE_RELEASE(titleText);
    OTS_SAFE_RELEASE(titleLableText);
    productsTable=nil;
    OTS_SAFE_RELEASE(cateId);

    OTS_SAFE_RELEASE(_productsArray);
    OTS_SAFE_RELEASE(buyQuantity);
    selectionTable=nil;
    OTS_SAFE_RELEASE(_selectionArray);
    OTS_SAFE_RELEASE(_trackCategoryIdArray);
    OTS_SAFE_RELEASE(_trackCategoryDic);
    selectionBG=nil;

    OTS_SAFE_RELEASE(m_FilterDictionary);
    OTS_SAFE_RELEASE(cartAnimation);

    cateBtn=nil;
    sortBtn=nil;
    sortArrow=nil;
    cateArrow=nil;
    OTS_SAFE_RELEASE(categoryTypeArray);
    OTS_SAFE_RELEASE(sortArray);

    [_promotion release];
    [_condition release];
    [_currentCategory release];
    
    
    _errorAlert.delegate = nil;
    [_errorAlert release];
    
    
    [super dealloc];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    sortType=SORT_BY_DEFAULT;
    m_CurrentPageIndex=1;
    if (_isTuangou)
    {
        sortArray = [[NSMutableArray alloc] initWithObjects:@"默认排序",@"最近发布",@"价格最低",@"价格最高", nil];
    }
    else
    {
        sortArray=[[NSMutableArray alloc] initWithObjects:@"默认排序",@"最近发布",@"价格最低",@"价格最高",@"好评最高",@"销量最高", nil];
    }
    self.productsArray = [NSMutableArray array];
    

    
//    m_IsOriginal=YES;
    self.selectionArray = [NSMutableArray array];
    if (isCashPromotionList)
    {
        self.trackCategoryIdArray = [NSMutableArray array];
    }
    else{
        self.trackCategoryIdArray = [NSMutableArray arrayWithArray:[GlobalValue getGlobalValueInstance].cateLeveltrackArray];
    }
    
    self.trackCategoryDic = [NSMutableDictionary dictionary];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissSelection) name:CATE_DISSMISS_SELECTION object:nil];
    
    //团购中省份切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(provinceChanged:) name:@"ProvinceChanged" object:nil];
    
    
    self.view.backgroundColor=[UIColor whiteColor];

    cartAnimation = [[CartAnimation alloc] init:self.view];
    [cartAnimation setDelegate:self];
    isCratAnimation = YES;

    [self initTop];
    [self inittable];
    [self setUniqueScrollToTopFor:productsTable];
    [self sendRequset];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI
- (void)inittable
{
    productsTable=[[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cateBtnBG.frame), 320, self.view.frame.size.height-CGRectGetMaxY(cateBtnBG.frame)-49) style:UITableViewStylePlain];
    productsTable.delegate=self;
    productsTable.dataSource=self;
    [self.view addSubview:productsTable];
    [productsTable release];
    productsTable.hidden=YES;
    
    NSLog(@">>> %@",productsTable);
    
    selectionBG=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cateBtnBG.frame), 320, self.view.frame.size.height-CGRectGetMaxY(cateBtnBG.frame))];
    [self.view addSubview:selectionBG];
    [selectionBG release];
    selectionBG.hidden=YES;
    
    selectionBTN=[[UIButton alloc] initWithFrame:CGRectMake(0, 200, 320, self.view.frame.size.height-84-200)];
    selectionBTN.backgroundColor=[UIColor blackColor];
    [selectionBTN addTarget:self action:@selector(dismissSelection) forControlEvents:UIControlEventTouchUpInside];
    selectionBTN.alpha=0.6;
    [selectionBG addSubview:selectionBTN];
    [selectionBTN release];
    
    selectionTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 200) style:UITableViewStylePlain];
    selectionTable.backgroundColor=[UIColor whiteColor];
    selectionTable.backgroundView.backgroundColor=[UIColor whiteColor];
    selectionTable.dataSource=self;
    selectionTable.delegate=self;
    [selectionBG addSubview:selectionTable];
    selectionTable.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [selectionTable release];
    
    m_backToTop = [[BackToTopView alloc] init];
	[self.view addSubview:m_backToTop];
}

- (void)initTop
{
    CGFloat yValue = 0.0;
    
    UIImageView* topNav=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    topNav.userInteractionEnabled=YES;
    topNav.image=[UIImage imageNamed:@"title_bg.png"];
    [self.view addSubview:topNav];
    [topNav release];
    UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 44)];
    titleLabel.font=[UIFont boldSystemFontOfSize:20];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.shadowColor=[UIColor darkGrayColor];
    titleLabel.text = titleLableText==nil?@"商品列表":@"满减列表";
    titleLabel.shadowOffset=CGSizeMake(1, -1);
    titleLabel.backgroundColor=[UIColor clearColor];
    [topNav addSubview:titleLabel];
    [titleLabel release];
    UIButton* backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(0,0,61,44);
    backBtn.titleLabel.font=[UIFont boldSystemFontOfSize:13];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"title_left_btn.png"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"title_left_btn_sel.png"] forState:UIControlStateHighlighted];
    backBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 4, 0, 0);
    backBtn.titleLabel.shadowColor=[UIColor darkGrayColor];
    backBtn.titleLabel.shadowOffset=CGSizeMake(1, -1);
    
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [topNav addSubview:backBtn];
    
    yValue += 44;
    
    
    if (_isTuangou)
    {
        //logo栏-选择省份按钮
        selectedProvince = [[UIButton alloc]initWithFrame:CGRectMake(259, 0, 61, 44)];
        [selectedProvince setTitleEdgeInsets:UIEdgeInsetsMake(0, 11, 0, 0)];
        
        NSString *currentProvince = [self getSelectedLocation];
        
        if(currentProvince == nil || [currentProvince isEqualToString:@""])
        {
            //如果未切换过省份
            [selectedProvince setTitle:@"上海" forState:UIControlStateNormal];
        }
        else
        {
            [selectedProvince setTitle:currentProvince forState:0];
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
    }
    
    //如果是促销详情，有赠品就显示赠品栏
    if (_promotion.gifts && _promotion.gifts.count > 0)
    {
        UIView *giftView = [[UIView alloc] initWithFrame:CGRectMake(0, yValue, 320, 100)];
        giftView.backgroundColor = [UIColor darkGrayColor];
        [self.view addSubview:giftView];
        [giftView release];
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        titleLbl.backgroundColor = [UIColor clearColor];
        titleLbl.font = [UIFont systemFontOfSize:13];
        titleLbl.textColor = [UIColor whiteColor];
        titleLbl.text = [NSString stringWithFormat:@"%@(赠品在购物车中领取)",[_condition promotionStringByPromotionType:_promotion.promotionType]];
        [giftView addSubview:titleLbl];
        [titleLbl release];
        
        //把该梯度下对应的赠品取出来
        NSMutableArray *giftInThisPromotion = [[NSMutableArray alloc] init];
        for (GiftInfo *gift in _promotion.gifts)
        {
            if (gift.schemeId == _condition.conditionId)
            {
                [giftInThisPromotion addObject:gift];
            }
        }

        
        NSMutableArray *giftViewArr = [[[NSMutableArray alloc] init] autorelease];
        for (GiftInfo *gift in giftInThisPromotion)
        {
            GiftView *singleGiftView = [[GiftView alloc] initWithFrame:CGRectMake(0, 0, 140, 60) gift:gift];
            [giftViewArr addObject:singleGiftView];
            [singleGiftView release];
        }
        [giftInThisPromotion release];

        LPPager *giftPageView = [[LPPager alloc] initWithFrame:CGRectMake(0, 20, 320, 80) viewArr:giftViewArr gapX:10];
        giftPageView.backgroundColor = [UIColor clearColor];
        [giftView addSubview:giftPageView];
        [giftPageView release];
        
        yValue += 100;
    }
    
    //分类 排序的背景
    cateBtnBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, yValue, 320, 40)];
    cateBtnBG.image=[UIImage imageNamed:@"sort_unsel.png"];
    [self.view addSubview:cateBtnBG];
    cateBtnBG.userInteractionEnabled=YES;
    [cateBtnBG release];
    UIImageView* line=[[UIImageView alloc] initWithFrame:CGRectMake(160, 0, 1, 40)];
    line.image=[UIImage imageNamed:@"cate_selection_line.png"];
    [cateBtnBG addSubview:line];
    [line release];
    
    //分类按钮
    NSString* defaultCatetitle= titleText;
    if ([defaultCatetitle hasPrefix:@"全部"])
    {
        defaultCatetitle=@"全部分类";
    }
    else
    {
        defaultCatetitle=titleText;
    }
    NSMutableString* cateTilte=[NSMutableString stringWithString:defaultCatetitle];
    if (cateTilte.length>5) {
        cateTilte=[NSMutableString stringWithFormat:@"%@... ",[cateTilte substringToIndex:5]];
    }
    
    cateBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    cateBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [cateBtn setBackgroundImage:[UIImage imageNamed:@"sort_unsel.png"] forState:UIControlStateNormal];
    [cateBtn setBackgroundImage:[UIImage imageNamed:@"cate_sort_sel.png"] forState:UIControlStateHighlighted];
    cateBtn.tag=0;
    [cateBtn setTitle:cateTilte forState:UIControlStateNormal];
    [cateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cateBtn.frame=CGRectMake(0, 0, 160, 40);
    [cateBtn addTarget:self action:@selector(cateSelectClick:) forControlEvents:UIControlEventTouchUpInside];
    [cateBtnBG addSubview:cateBtn];
    
    cateArrow=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cate_arrow_down"]];
    cateArrow.frame=CGRectMake(160-30, 15, 15, 15);
    cateArrow.center=CGPointMake(160-30, 20);
    [cateBtn addSubview:cateArrow];
    [cateArrow release];
    
    
    //排序按钮
    sortBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sortBtn.frame=CGRectMake(160, 0, 160, 40);
    sortBtn.tag=0;
    sortBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [sortBtn setBackgroundImage:[UIImage imageNamed:@"sort_unsel.png"] forState:UIControlStateNormal];
    [sortBtn setBackgroundImage:[UIImage imageNamed:@"cate_sort_sel.png"] forState:UIControlStateHighlighted];
    [sortBtn setTitle:[sortArray objectAtIndex:0] forState:UIControlStateNormal];
    [sortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sortBtn addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
    [cateBtnBG addSubview:sortBtn];
    sortArrow=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cate_arrow_down"]];
    sortArrow.frame=CGRectMake(160-30, 15, 15, 15);
    sortArrow.center=CGPointMake(160-30, 20);
    [sortBtn addSubview:sortArrow];
    [sortArrow release];
    
    ////////团购增加
    if (_isTuangou)
    {
        titleLabel.text = @"团购";
        cateBtn.enabled = NO;
    }
    //促销
    if (_promotion)
    {
        titleLabel.text = @"活动详情";
    }
}

//获取用户选择的位置信息
-(NSString *)getSelectedLocation
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *filename=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"SaveProvinceId.plist"];
    NSMutableArray *theArray=[[[NSMutableArray alloc] initWithContentsOfFile:filename] autorelease] ;
    if ([theArray count]==0)
    {
        return @"上海";
    }
    else
    {
        return [NSString stringWithFormat:@"%@",[theArray objectAtIndex:0]];
    }
}
-(void)enterSwitchProvince
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddSwitchProvinceForTabBar" object:nil];
}

#pragma mark - Request
- (void)sendRequset
{
    if (isLoadingMore)
    {
//        return;
    }
    else
    {
        [self showLoading:YES];
    }
    
    if (_isTuangou)
    {
        [self requestGroupList];
    }
    else
    {
        [self otsDetatchMemorySafeNewThreadSelector:@selector(requestData) toTarget:self withObject:nil];
    }
    
}

- (void)requestGroupList
{
    GroupService *groupSer = [[GroupService alloc] init];
    
    NSString *sort = @"";
    NSString *isDesc = @"";
    if (sortType == 5)  //如果是按价格降序来排序的话：sort＝2 其他的sort为对应的值, 对于现在请求参数，我只能：呵呵，fuck。。。
    {
        sort = @"2";
        isDesc = @"0";  //fuck， 这个用2个字段来排序真tmd傻逼，如果价格降序，
    }
    else
    {
        sort = [NSString stringWithFormat:@"%d",sortType];
        isDesc = @"1";
    }
    
    NSDictionary *paramDic = @{@"province":[GlobalValue getGlobalValueInstance].provinceId,
                               @"pagesize":@"10",
                               @"pageindex":[NSString stringWithFormat:@"%d", m_CurrentPageIndex],
                               @"sort":sort,
                               @"isDesc":isDesc
                               };
    
    __block ResultInfo *result  = nil;
    
    [self performInThreadBlock:^{
        result = [groupSer getGroupList:paramDic];
    } completionInMainBlock:^{
        
        if (result.resultCode == 1)
        {
            if (isLoadingMore)
            {
                [self.productsArray addObjectsFromArray: (NSMutableArray *)result.resultObject];
            }
            else
            {
                self.productsArray = result.resultObject;
            }
            m_ProductTotalCount = result.recordCount;
            
            [self updateProductsTable];
        }
        else
        {
            [self showError:result.errorStr];
        }
        
        
        [self hideLoading];
        [self hideLoadingMore];
    }];
}

- (void)requestData
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    
    YWSearchService *searchSer = [[YWSearchService alloc] init];
    
    NSString *sort = @"";
    NSString *isDesc = @"";
    //如果是按价格降序来排序的话：sort＝2 其他的sort为对应的值, 对于现在请求参数，我只能：呵呵，fuck。。。
    if (sortType == 5)
    {
        sort = @"2";
        isDesc = @"0";  //fuck， 这个用2个字段来排序真tmd傻逼，如果价格降序，那么 isDesc＝0 草，，，降序好歹为1才对的上名字啊。。。。。
    }
    else
    {
        sort = [NSString stringWithFormat:@"%d",sortType];
        isDesc = @"1";
    }
    NSDictionary * tempDic= @{@"province":[GlobalValue getGlobalValueInstance].provinceId,
                               @"pagesize":@"10",
                               @"pageindex":[NSString stringWithFormat:@"%d", m_CurrentPageIndex],
//                               @"catalogId":cateId,
                               @"sort":sort,
                               @"isDesc":isDesc};
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithDictionary:tempDic];
    if(_promotion)
    {
        [paramDic setObject:[NSString stringWithFormat:@"%d",_promotion.promotionId] forKey:@"activityid"];
    }
    else
    {
        [paramDic setObject:cateId forKey:@"catalogId"];
    }
   
    
    SearchResultInfo *searchResult = [searchSer getSearchProductListWithParam:paramDic];
    if (searchResult.bRequestStatus)
    {
        if (searchResult.productList && searchResult.productList.count > 0)
        {
            if (isLoadingMore)
            {
                [self.productsArray addObjectsFromArray:searchResult.productList];
            }
            else
            {
                self.productsArray = searchResult.productList;
            }
            m_ProductTotalCount = searchResult.totalCount;
            [self performSelectorOnMainThread:@selector(updateProductsTable) withObject:nil waitUntilDone:[NSThread isMainThread]];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(categoryProductIsNull) withObject:nil waitUntilDone:NO];
        }
    }
    else
    {
        [self performSelectorOnMainThread:@selector(showNetErrer) withObject:nil waitUntilDone:NO];
    }
    [self performSelectorOnMainThread:@selector(hideLoadingMore) withObject:nil waitUntilDone:NO];
    
    [searchSer release];
    
    
    [pool drain];
}

- (void)addToCartRequest:(int)currentRow
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    ProductInfo * productVO = [self.productsArray objectAtIndex:currentRow];
    // 设置购买数量
    if (buyQuantity!=nil)
    {
        [buyQuantity release];
    }
    
    buyQuantity = [[NSNumber alloc] initWithInt:1];
    
    
    
    YWLocalCatService *localCatService = [[YWLocalCatService alloc] init];
    LocalCarInfo *localCart = [[LocalCarInfo alloc] initWithProductId:productVO.productId
                                                        shoppingCount:[NSString stringWithFormat:@"%d",[buyQuantity intValue]]
                                                             imageUrl:productVO.mainImg3
                                                                price:productVO.price
                                                           provinceId:[[GlobalValue getGlobalValueInstance].provinceId stringValue]
                                                                  uid:[GlobalValue getGlobalValueInstance].userInfo.ecUserId
                                                             productNO: productVO.productNO
                                                                itemId:productVO.itemId];
  
    
    
    BOOL result = [localCatService saveLocalCartToDB:localCart];
    
    if (result)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChanged" object:nil];
        [self performSelectorOnMainThread:@selector(showBuyProductAnimationWithSelectedIndex:) withObject:[NSNumber numberWithInt:currentRow] waitUntilDone:NO];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(showError:) withObject:@"加入购物失败" waitUntilDone:NO];
    }
    [localCatService release];
    [localCart release];
    
    [pool drain];
}

-(void)getMoreProduct
{
    m_CurrentPageIndex++;
    isLoadingMore=YES;
    [self sendRequset];
}


#pragma mark UIAction
//省份已切换
-(void)provinceChanged:(NSString *)provinceName
{
    [selectedProvince setTitle:provinceName forState:UIControlStateNormal];
    [self sendRequset];
}

-(void)updateProductsTable
{
    [self hideLoading];
    productsTable.hidden = NO;
    nullImg.hidden = YES;
    [productsTable reloadData];
    if (m_CurrentPageIndex==1)
    {
        [productsTable scrollRectToVisible:CGRectMake(0, 0, 320, 200) animated:NO];
    }
    
        DebugLog(@">>> %@",productsTable);
}

-(void)hideLoadingMore
{
    [productsTable setTableFooterView:nil];
    isLoadingMore=NO;
}

- (void)categoryProductIsNull
{
    [self hideLoading];
    if (nullImg==nil)
    {
        nullImg=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cateBtnBG.frame), 320, 329)];
        nullImg.image=[UIImage imageNamed:@"cate_product_null"];
        [self.view addSubview:nullImg];
        [self.view insertSubview:nullImg belowSubview:selectionBG];
        [nullImg release];
    }
    nullImg.hidden=NO;
}

-(void)updateSelectionTable
{
    [self.selectionArray removeAllObjects];
    if (cateBtn.tag==0&&sortBtn.tag==1)
    {
        sortArrow.image=[UIImage imageNamed:@"cate_arrow_up"];
        cateArrow.image=[UIImage imageNamed:@"cate_arrow_down"];
        [self.selectionArray addObjectsFromArray: sortArray];
        selectionBG.hidden=NO;
//        promoteBar.hidden = YES;
    }
    else if (cateBtn.tag==1&&sortBtn.tag==0)
    {
        
        NSMutableArray * categoryList = [self getCateFromLocalByRootId:self.currentCategory.cid];
        NSMutableArray *tempCateArr = [[NSMutableArray alloc] init];
        if ([_currentCategory.cid intValue] != -1)
        {
            //不是第一级
            CategoryInfo *category = [[CategoryInfo alloc] init];
            category.name = BACKUPLEVEL;
            [tempCateArr addObject:category];
            [category release];
        }
        
        CategoryInfo *category = [[CategoryInfo alloc] init];
        category.name = @"全部";
        [tempCateArr addObject:category];
        [category release];
        
        [tempCateArr addObjectsFromArray:categoryList];
        self.categoryTypeArray = tempCateArr;
        [tempCateArr release];
        
        
        
        [self.selectionArray addObjectsFromArray: self.categoryTypeArray];
        selectionBG.hidden=NO;
//        promoteBar.hidden = YES;
        selectionType=0;
        
        cateArrow.image=[UIImage imageNamed:@"cate_arrow_up"];
        sortArrow.image=[UIImage imageNamed:@"cate_arrow_down"];
    }
    else
    {
        cateArrow.image=[UIImage imageNamed:@"cate_arrow_down"];
        sortArrow.image=[UIImage imageNamed:@"cate_arrow_down"];
        selectionBG.hidden=YES;
//        promoteBar.hidden = NO;
    }
    [selectionTable reloadData];
}

// 网络异常提示
-(void)showNetAlert:(NSInteger)theTag {
    [[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:YES];
	UIAlertView * alertView = [[OTSAlertView alloc] initWithTitle:nil message:@"网络异常,请检查网络配置..." delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
    
    _errorAlert = [alertView retain];
    
	alertView.tag = theTag;
	[alertView show];
	[alertView release];
	alertView = nil;
}

-(void)showNetErrer
{
    [self hideLoading];
    [self showNetAlert:ALERTVIEW_TAG_NET_EXCEPTION];
}


-(void)showError:(NSString *)error
{
    [AlertView showAlertView:nil alertMsg:error buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
}


#pragma mark action
- (void)backClick:(id)sender
{
    NSMutableArray * cateLeveltrackArray = [GlobalValue getGlobalValueInstance].cateLeveltrackArray;
    [cateLeveltrackArray pop];
    
    [self popSelfAnimated:YES];
}

- (void)dismissSelection{
    sortBtn.tag=0;
    cateBtn.tag=0;
    [cateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sortArrow.image=[UIImage imageNamed:@"cate_arrow_down"];
    cateArrow.image=[UIImage imageNamed:@"cate_arrow_down"];
    selectionBG.hidden=YES;
    
}

- (void)cateSelectClick:(UIButton*)sender{
    [self popupSelectionTable];
}

//点击分类按钮
-(void)popupSelectionTable
{
    if (cateBtn.tag)
    {
        cateBtn.tag=0;
        [cateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
    {
        cateBtn.tag=1;
        if (sortBtn.tag==1)
        {
            sortBtn.tag=0;
            [sortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [cateBtn setTitleColor:RED_TEXT_COLOR forState:UIControlStateNormal];
        
        
        //分类列表出来前就确定 currentCategory
        if (!_bSelectAllCategory && [_currentCategory.parentId intValue] != -2 && _currentCategory.parentId.length > 0)
        {
            self.currentCategory = [self getCategoryByCid:_currentCategory.parentId];
        }
        
    }
    selectionBTN.frame=CGRectMake(0, 280, 320, self.view.frame.size.height-84-280);
    selectionTable.frame=CGRectMake(0, 0, 320, self.view.frame.size.height-84-SharedDelegate.tabBarController.tabBar.frame.size.height);
    [self updateSelectionTable];
}

-(void)sortClick:(UIButton*)sender
{
    if (sortBtn.tag)
    {
        sortBtn.tag=0;
        [sortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
    {
        sortBtn.tag=1;
        if (cateBtn.tag==1)
        {
            cateBtn.tag=0;
            [cateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        [sortBtn setTitleColor:RED_TEXT_COLOR forState:UIControlStateNormal];
    }
    selectionBTN.frame=CGRectMake(0, 200, 320, self.view.frame.size.height-84-200);
    selectionTable.frame=CGRectMake(0, 0, 320, self.view.frame.size.height-84-SharedDelegate.tabBarController.tabBar.frame.size.height);
    switch (sortType)
    {
        case SORT_BY_DEFAULT:
            selectionType=0;
            break;
        case SORT_BY_SALE:
            selectionType=1;
            break;
        case SORT_BY_PRICE_ASC:
            selectionType=2;
            break;
        case SORT_BY_PRICE_DESC:
            selectionType=3;
            break;
        case SORT_BY_TIME:
            selectionType=4;
            break;
        default:
            break;
    }

    [self updateSelectionTable];
}



-(void)accessoryButtonTap:(UIControl *)button withEvent:(UIEvent *)event{
	NSIndexPath *indexPath=[productsTable indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:productsTable]];//获得NSIndexPath
    int currentRow=[indexPath row];//获得选择的第几行
    ProductInfo * productVO = [self.productsArray objectAtIndex:currentRow];
	if (indexPath==nil)
    {
		return;
	}
    else if ([productVO isSeriesProductInProductList])
    {
        
        [self tableView:productsTable didSelectRowAtIndexPath:indexPath];
    }
    else
    {
		if (productVO.stockNum > 0)
        {
            [self addToCartRequest:currentRow];
		}
        else
        {
			[[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:YES];
			UIAlertView * alert = [[OTSAlertView alloc] initWithTitle:nil message:@"很抱歉,该商品已经卖光啦!你可以收藏商品,下次购买" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
			alert.tag = 0;
			[alert show];
			[alert release];
			alert = nil;
		}

	}
}

// creat by yj
-(void)cateTableAnimation:(NSInteger)type
{
    if (type)
    {
        [selectionTable.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:nil];
    }else{
        [selectionTable.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:nil];
    }

}


#pragma mark - Delegate

#pragma mark AlertDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag==0)
    {
        return;
    }
    CategoryViewController* cateVC= (CategoryViewController*)[ SharedDelegate.tabBarController.viewControllers objectAtIndex:1];
    [cateVC enterTopCategory:YES];
}



#pragma mark  scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	m_backToTop.scrollScreenHeight = 367;
	[m_backToTop scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)theScrollView{
	[m_backToTop scrollViewDidEndDecelerating:theScrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)theScrollView willDecelerate:(BOOL)decelerate{
	[m_backToTop scrollViewDidEndDragging:theScrollView willDecelerate:decelerate];
    
}
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
	[m_backToTop scrollViewShouldScrollToTop:scrollView];
	return YES;
}
#pragma mark table Delegate
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == productsTable)
    {
        if (_isTuangou)
        {
            ProductInfo *productInfo = (ProductInfo *)[self.productsArray objectAtIndex:indexPath.row];
            
            static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
            
            TuanCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
            
            if (cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"TuanCell" owner:nil options:nil] objectAtIndex:0];
            }
            
            cell.productNameLbl.text = productInfo.groupTitle;
            cell.nowPriceLbl.text = [NSString stringWithFormat:@"¥%.2f",productInfo.priceGroup];
            cell.oldPriceLbl.text = [NSString stringWithFormat:@"¥%.2f",productInfo.priceOriginal];
            cell.priceOffLbl.text = [NSString stringWithFormat:@"%.1f折",productInfo.priceGroup / productInfo.priceOriginal * 10];
            cell.buyedCountLbl.text = [NSString stringWithFormat:@"%d人已购买",productInfo.soldAmmont];
            [cell.productImgView setImage:[UIImage imageNamed:@"defaultimg320x120.png"]];
            [cell.productImgView setImageWithURL:[NSURL URLWithString:[productInfo getGroupImage]]];
            return cell;
            
        }
        else
        {
            static NSString*identify=@"cateProductCell";
            CategoryProductCell*cell=(CategoryProductCell*)[tableView dequeueReusableCellWithIdentifier:identify];
            
            if (cell==nil)
            {
                cell=[[[CategoryProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
            }
            
            ProductInfo *productVO = (ProductInfo *)[self.productsArray objectAtIndex:indexPath.row];
            
            
            cell.productNameLbl.text = productVO.name;
            [cell.the1MallLogo setHidden:YES];
            
            // 商品价格
            cell.priceLbl.text = [NSString stringWithFormat:@"￥%.2f", [productVO.price floatValue]];

            if ([productVO isOTC])
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
                if (/*[productVO.canBuy isEqualToString:@"true"]*/ [productVO isOnSale] && [productVO stockNum] > 0)
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

            
        }
    }
    else
    {
        //顶部分类和排序table
        static NSString*identify=@"selectionCell";
        CategorySelectionCell*cell=(CategorySelectionCell*)[tableView dequeueReusableCellWithIdentifier:identify];
        if (cell==nil)
        {
            cell=[[[CategorySelectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
        }
        
        if (cateBtn.tag)
        {
            CategoryInfo *cateVo=(CategoryInfo *)[self.selectionArray objectAtIndex:indexPath.row];

            cell.cateNameLab.text = [NSString stringWithFormat:@"%@",cateVo.name];
            
            CGSize titleSize = [cell.cateNameLab.text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:14] constrainedToSize:CGSizeMake(MAXFLOAT, 0)];
            [cell.cateproduct setFrame:CGRectMake(40+titleSize.width, 0, 100, 40)];
            cell.cateproduct.text = @"";
            
            if ([self.trackCategoryIdArray count] < 3)
            {
                [cell setShowNextCate:YES];
            }
            else
            {
                [cell setShowNextCate:NO];
            }
            
            if ([cateVo.name isEqualToString:BACKUPLEVEL]) {
                [cell setShowUpBack:YES];
                [cell setShowNextCate:NO];
                [cell setShowCatePro:NO];
            }
            else if([cateVo.name hasPrefix:@"全部"]){
                [cell setShowUpBack:NO];
                [cell setShowNextCate:NO];
                [cell setShowCatePro:NO];
            }
            else
            {
                [cell setShowUpBack:NO];
                //[cell setShowNextCate:YES];
            }
        }
        else
        {
            NSString* string=[self.selectionArray objectAtIndex:indexPath.row];
            cell.cateNameLab.text=string;
            [cell setShowUpBack:NO];
            [cell setShowNextCate:NO];
            [cell setShowCatePro:NO];
        }
        
        //显示选中箭头
        if (indexPath.row==selectionType)
        {
            [cell setShowArrow:YES];
        }else
        {
            [cell setShowArrow:NO];
        }
        
//        //满减列表 不显示下级箭头
//        if (isCashPromotionList) {
//            [cell setShowNextCate:NO];
//        }
        
        return cell;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==productsTable)
    {
        return self.productsArray.count;
    } else {
        return self.selectionArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==productsTable)
    {
        if (_isTuangou)
        {
            return 115;
        }
        
        return TABLEVIEW_NODECATEGOTY_CELL_HEIGHT;
    }
    else
    {
        return 45;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView==productsTable)
    {

            if (indexPath.row==self.productsArray.count)
            {
                return;
            }
            ProductInfo *productVO = [self.productsArray objectAtIndex:indexPath.row];
            
            
            OTSProductDetail *productDetail=[[[OTSProductDetail alloc] initWithProductId:[productVO.productId longLongValue] promotionId:nil fromTag:PD_FROM_CATEGORY] autorelease];
            [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
            [self pushVC:productDetail animated:YES];
    }
    else
    {
//        m_IsOriginal=YES;
        if (cateBtn.tag)
        {
            
            OTS_SAFE_RELEASE(m_FilterDictionary);
            
            CategoryInfo *catevo=[categoryTypeArray objectAtIndex:indexPath.row];
            
            if ([catevo.name hasPrefix:@"全部"])
            {
                //如果是全部或者返回上一级
                [cateBtn setTitle:@"全部分类" forState:UIControlStateNormal];
                
                _bSelectAllCategory = YES;
                [self reloadProductsTable];
            }
            else if([catevo.name hasPrefix:BACKUPLEVEL])
            {
                //如果是上一级
                _bSelectAllCategory = NO;
                [cateBtn setTitle:@"全部分类" forState:UIControlStateNormal];
                
                if ([_currentCategory.parentId intValue] != -2)
                {
                    self.currentCategory = [self getCategoryByCid:_currentCategory.parentId];
                }
                
                [self updateSelectionTable];
                [self cateTableAnimation:indexPath.row];
            }
            else
            {                
                _bSelectAllCategory = NO;
                self.currentCategory = catevo;
                cateId = catevo.cid;
                //如果不是全部或者返回上一级
                if (![self hasSonCategory:catevo.cid])
                {
                    //如果没有下一级,就刷新商品列表
                    [cateBtn setTitle:catevo.name forState:UIControlStateNormal];
                    [self reloadProductsTable];
                }
                else
                {
                    self.currentCategory = catevo;
                    [self updateSelectionTable];
                    [self cateTableAnimation:indexPath.row];
                }
            }

        }
        else
        {
            NSString* sort=[sortArray objectAtIndex:indexPath.row];
            if ([sort isEqualToString:@"默认排序"])
            {
                sortType=SORT_BY_DEFAULT;
                selectionType=0;
            }
            else if ([sort isEqualToString:@"最近发布"])
            {
                sortType=SORT_BY_TIME;
                selectionType=1;
            }
            else if ([sort isEqualToString:@"价格最低"])
            {
                sortType=SORT_BY_PRICE_ASC;
                selectionType=2;
            }
            else if ([sort isEqualToString:@"价格最高"])
            {
                sortType=SORT_BY_PRICE_DESC;
                selectionType=3;
            }
            else if ([sort isEqualToString:@"好评最高"])
            {
                sortType=SORT_BY_COMMENT_DESC;
                selectionType=4;
            }
            else if ([sort isEqualToString:@"销量最高"])
            {
                sortType = SORT_BY_SALE;
                selectionType = 5;
            }
            
            [sortBtn setTitle:sort forState:UIControlStateNormal];
            [self reloadProductsTable];
        }
    }
}

-(void)reloadProductsTable
{
//    promoteBar.hidden = NO;
    m_CurrentPageIndex=1;
    [self.productsArray removeAllObjects];
    [productsTable reloadData];
    productsTable.hidden=YES;
    [self sendRequset];
    selectionBG.hidden=YES;
    [self showLoading:YES];
    [self dismissSelection];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==productsTable)
    {
        if (indexPath.row >= [self.productsArray count]-2 && [self.productsArray count]<m_ProductTotalCount)
        {
            if (!isLoadingMore)
            {
                [tableView loadingMoreWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40) target:self selector:@selector(getMoreProduct) type:UITableViewLoadingMoreForeIphone];
                isLoadingMore = YES;
            }
        }
    }
}



#pragma mark depretaMethod
#pragma mark    购物车动画

-(void)showBuyProductAnimationWithSelectedIndex:(NSNumber*)row{
    
    ProductInfo * productVO = [self.productsArray objectAtIndex:row.intValue];
    NSString* imageURLStr = [productVO productImageUrl];
    
    // 算出对应的图片坐标
    UITableViewCell* cell = [productsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row.intValue inSection:0]];
    CGPoint point = cell.imageView.center;
    point = [cell.imageView convertPoint:point toView:self.view];
    
    UIImageView* imageV = [[[UIImageView alloc]init]autorelease];
    [imageV setImageWithURL:[NSURL URLWithString:imageURLStr] refreshCache:NO placeholderImage:[UIImage imageNamed:@"defaultimg76"]];
    
    [cartAnimation beginCartAnimationWithProductImageView:imageV point:point];
    
    // 更新购物车数字
    [SharedDelegate setCartNum:[buyQuantity intValue]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChanged" object:nil];
    
    if (isCratAnimation)
    {
		isCratAnimation=NO;
        [SharedDelegate showAddCartAnimationWithDelegate:self];
	}
    
    
}
-(void) animationFinished{
    isCratAnimation = YES;
}


#pragma mark - Category Action

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

- (BOOL)hasSonCategory:(NSString *)cid
{
    
    NSArray *cateList = [self getCateFromLocalByRootId:cid];
    if (cateList.count > 0)
    {
        return YES;
    }
    return NO;
}
- (CategoryInfo *)getCategoryByCid:(NSString *)cid
{
    NSString *filename=[OTSUtility documentDirectoryWithFileName:@"SaveRootCate_130508.plist"];
    NSMutableArray *cateArr = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    for (CategoryInfo *cate in cateArr)
    {
        if ([cate.cid isEqualToString:cid])
        {
            return cate;
        }
    }
    return nil;
}

- (void)initCategoryListFromProductList:(BOOL)flag
{
    NSMutableArray * categoryList = [self getCateFromLocalByRootId:flag? self.currentCategory.parentId : self.currentCategory.cid];
    NSMutableArray *tempCateArr = [[NSMutableArray alloc] init];
    if ([_currentCategory.cid intValue] != -1)
    {
        //不是第一级
        CategoryInfo *category = [[CategoryInfo alloc] init];
        category.name = BACKUPLEVEL;
        [tempCateArr addObject:category];
        [category release];
    }
    
    CategoryInfo *category = [[CategoryInfo alloc] init];
    category.name = @"全部";
    [tempCateArr addObject:category];
    [category release];
    
    [tempCateArr addObjectsFromArray:categoryList];
    self.categoryTypeArray = tempCateArr;
    [tempCateArr release];
}
@end
