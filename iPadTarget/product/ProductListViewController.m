//
//  ProductListViewController.m
//  yhd
//
//  Created by  on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProductListViewController.h"
#import "TopView.h"
#import "ProductView.h"
#import "ProductCell.h"
#import "Page.h"
#import "SearchResultVO.h"
#import "ProductVO.h"
#import "SDImageView+SDWebCache.h"
#import "ProductListTopView.h"
#import "CategoryVO.h"
#import "ProvinceVO.h"
#import "SearchAttributeVO.h"
#import "CartItemVO.h"
#import "CartVO+ProductCart.h"
#import <QuartzCore/QuartzCore.h>
#import "SearchBrandVO.h"
#import "SearchCategoryVO.h"
#import "SearchPriceVO.h"
#import "FacetValue.h"
#import "PriceRange.h"
#import "LocalCartItemVO.h"
#import "OTSGpsHelper.h"
#import "OtsPadLoadingView.h"
#import "OTSPadProductDetailVC.h"
#import "SearchParameterVO.h"
#import "WebViewController.h"
#import "GTMBase64.h"
//#define kCartViewWidth 64
//#define kCartViewWidthExtend 56
#define kCellHeight 262
#define  kActivityViewTag 150
#define  kNoFoundViewTag 151

#define kProCateTableViewTag 201
#define kProCateTableView2Tag 202
#define kProCate1TableViewTag 203
#define kProCate2TableViewTag 204

#define kSelectedCate1 210
#define kSelectedCate2 211
#define kSelectedCate1ToCate2 212

#define CateTableViewTextColor [UIColor colorWithRed:76.0/255 green:76.0/255 blue:76.0/255 alpha:1.0]

@interface ProductListViewController ()

-(void)updatePriceButtonImage:(UIButton*)aClickedButton;

@property(nonatomic, assign)BOOL            isDragging;
@property(nonatomic, retain)ProductView     *productDragView;
@property BOOL                              isPriceAscending;
@property(nonatomic, assign)UIButton        *lastSelectedButton;
@property(nonatomic, readonly)OtsPadLoadingView *loadingView;
@end

@implementation ProductListViewController
@synthesize listData,cateid,cate1,cate2,cate3,keyword,currentPopover,price,filter,sortType,currentPage,searchAttributes,attributes,butArray,categories,productListData,cate2Dic, productListType,searchBrandVO,searchPriceVO,brandId,activityID,activityTitle,isYihaodian;
@synthesize isDragging = _isDragging, productDragView = _productDragView;
@synthesize isPriceAscending = _isPriceAscending, lastSelectedButton = _lastSelectedButton;

@synthesize loadingView = _loadingView;

-(OtsPadLoadingView*)loadingView
{
    if (_loadingView == nil)
    {
        _loadingView = [[OtsPadLoadingView alloc] init];
    }
    
    return _loadingView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (productTableView!=nil) {
        productTableView.delegate=nil;
        productTableView.dataSource=nil;
    }
    OTS_SAFE_RELEASE(topView);
    OTS_SAFE_RELEASE(productListTopView);
    OTS_SAFE_RELEASE(cartView);
    OTS_SAFE_RELEASE(productListData);
    OTS_SAFE_RELEASE(cateid);
    OTS_SAFE_RELEASE(cate1);
    OTS_SAFE_RELEASE(cate2);
    OTS_SAFE_RELEASE(cate3);
    OTS_SAFE_RELEASE(listData);
    OTS_SAFE_RELEASE(categories);
    OTS_SAFE_RELEASE(cate2Dic);
    OTS_SAFE_RELEASE(cateView);
    OTS_SAFE_RELEASE(cateDetailView);
    if (cateTableView!=nil) {
        cateTableView.delegate=nil;
        cateTableView.dataSource=nil;
        [cateTableView release];
        cateTableView=nil;
    }
    OTS_SAFE_RELEASE(cateTableViewBgView);
    OTS_SAFE_RELEASE(keyword);
    OTS_SAFE_RELEASE(price);
    OTS_SAFE_RELEASE(filter);
    OTS_SAFE_RELEASE(sortType);
    OTS_SAFE_RELEASE(attributes);
    OTS_SAFE_RELEASE(brandId);
    OTS_SAFE_RELEASE(searchAttributes);
    OTS_SAFE_RELEASE(searchBrandVO);
    OTS_SAFE_RELEASE(searchPriceVO);
    OTS_SAFE_RELEASE(currentPopover);
    OTS_SAFE_RELEASE(priceBut);
    OTS_SAFE_RELEASE(filterBut);
    OTS_SAFE_RELEASE(salesBut);
    OTS_SAFE_RELEASE(evaluateBut);
    OTS_SAFE_RELEASE(defBut);
    OTS_SAFE_RELEASE(searcheLabel);
    OTS_SAFE_RELEASE(butBg);
    OTS_SAFE_RELEASE(currentPage);
    OTS_SAFE_RELEASE(butArray);
    OTS_SAFE_RELEASE(popTag);
    OTS_SAFE_RELEASE(activityID);
    OTS_SAFE_RELEASE(activityTitle);
    OTS_SAFE_RELEASE(_loadingView);
    OTS_SAFE_RELEASE(clearHistoryView);
    OTS_SAFE_RELEASE(isYihaodian);
    self.productDragView=nil;
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 修正 orientation 为landscape时的frame错误
    if (!UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]))
    {
        self.view.frame = CGRectMake(self.view.frame.origin.x
                                     , self.view.frame.origin.y
                                     , self.view.frame.size.height
                                     , self.view.frame.size.width);
    }
    
    self.isPriceAscending = YES;
    self.view.multipleTouchEnabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFilterChange:)name:kNotifyFilterChange object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleProVinceChange:)name:kNotifyProvinceChange object:nil];
    
    [dataHandler.filterDic removeAllObjects];
    dataHandler.filterDic=nil;
    dataHandler.filterDic=[NSMutableDictionary dictionaryWithCapacity:1];
    if (self.productListData == nil) {
        self.productListData=[NSMutableArray arrayWithCapacity:16];
    }
    self.cate2Dic=[NSMutableDictionary dictionaryWithCapacity:1];
    
    self.isYihaodian=[dataHandler.filterDic valueForKey:YihaodianOnly];
    if (self.isYihaodian==nil) {
        self.isYihaodian=[NSNumber numberWithInt:0];
        [dataHandler.filterDic setObject:self.isYihaodian forKey:YihaodianOnly];
    }
    
    if(dataHandler.screenWidth==768){
        topView=[[TopView alloc] initWithFrame:CGRectMake(0, 0,768,kTopHeight)];
        cartView=[[CartView alloc]initWithFrame:CGRectMake(1024-kCartViewWidth, kTopHeight,kCartViewWidth,748-kTopHeight)];
    }else {
        cartView=[[CartView alloc]initWithFrame:CGRectMake(1024-kCartViewWidth, kTopHeight,kCartViewWidth,748-kTopHeight)];
        topView=[[TopView alloc] initWithFrame:CGRectMake(0, 0,1024,kTopHeight)];
        //productListTopView=[[ProductListTopView alloc] initWithFrame:CGRectMake(0, kTopHeight-2,1024,kProducrListTopHeight)];
        //类型，0 默认列表(分类) 1，搜索列表 2，促销精选 3,首页轮播促销 4,浏览历史
        EOtsProductTopviewType proTopvewType = productListType;
//        switch (productListType) {
//            case 0:
//                proTopvewType = kProductTopviewTypeCategory;
//                break;
//            case 1:
//                proTopvewType = kProductTopviewTypeSearch;
//                break;
//            case 2:
//                proTopvewType = kProductTopviewTypePromotion;
//                break;
//            case 3:
//                proTopvewType = kProductTopviewTypePage;
//                break;
//            case 4:
//                proTopvewType = kProductTopviewTypeHistory;
//                break;
//            case 5:
//                proTopvewType = kProductTopviewTypeSearch;
//                break;
//            default:
//                break;
//        }
        productListTopView=[[ProductListTopView alloc] initWithFrame:CGRectMake(0, kTopHeight-2,1024,kProducrListTopHeight) type:proTopvewType];
        [productListTopView setCate1:self.cate1];
        [productListTopView setCate2:self.cate2];
        [productListTopView setCate3:self.cate3];
        [productListTopView setCateid:self.cateid];
        [productListTopView setListData:listData];
        [productListTopView setRootViewController:self];
        if (proTopvewType == kProductTopviewTypePage) {
            [productListTopView setActivityTitle:activityTitle];
        }
        [productListTopView fitTheUI];
        productTableView.frame=CGRectMake(0, kTopHeight+kProducrListTopHeight-2,960,748-kTopHeight-kProducrListTopHeight+2);
    }
    
    [self.view addSubview:topView];
    [self.view addSubview:cartView];
    cartView.cartViewDelegate=self;
    
    
    [self.view addSubview:productListTopView];
    [self.view sendSubviewToBack:productListTopView];
    
    // 在 productListTopView 上加载商品筛选
    [self loadProductListTop];
    
    viewNumInCell=4;
    self.price=@"";
    self.filter=@"";
    self.attributes=@"";
    self.sortType=[NSNumber numberWithInt:1];
    self.brandId=[NSNumber numberWithInt:0];
    self.currentPage=[NSNumber numberWithInt:1];
    //浏览历史
    if(productListType != ListType_History && productListType != ListType_orderProducts)
    {
        [self otsDetatchMemorySafeNewThreadSelector:@selector(getProductListService) toTarget:self withObject:nil];
        
        [self.loadingView showInView:self.view]; 
        
    }
    
    [self initConfirmClearHistoryView];
}

-(void)initConfirmClearHistoryView
{
    clearHistoryView=[[UIView alloc] initWithFrame:CGRectMake(662 , 85, 290, 86)];
    [self.view addSubview:clearHistoryView];
    [clearHistoryView setHidden:YES];
    
    UIImageView *bg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 290, 86)];
    [bg setImage:[UIImage imageNamed:@"confirm_black_up.png"]];
    [clearHistoryView addSubview:bg];
    [bg release];
    
    UIButton *confirmBtn=[[UIButton alloc] initWithFrame:CGRectMake(7, 24, 275, 46)];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"confirm_red"] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"confirm_red_h"] forState:UIControlStateHighlighted];
    [confirmBtn setTitle:@"清空浏览历史" forState:UIControlStateNormal];
    [confirmBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [confirmBtn.titleLabel setFont:[confirmBtn.titleLabel.font fontWithSize:20.0]];
    [confirmBtn addTarget:self action:@selector(cleanHistoryClick:) forControlEvents:UIControlEventTouchUpInside];
    [clearHistoryView addSubview:confirmBtn];
    [confirmBtn release];
}


-(void)clearHistoryBtnClicked
{
    if (productListData && productListData.count>0) {
        if ([clearHistoryView isHidden]) {
            [clearHistoryView setHidden:NO];
        } else {
            [clearHistoryView setHidden:YES];
        }
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [topView setCartCount:dataHandler.cart.totalquantity.intValue];
    [cartView setCartCount:dataHandler.cart.totalquantity.intValue];
    
    [cartView reloadData];
    
    if(productListType == ListType_History){
        self.productListData=[dataHandler queryProductHistory];
        if (productListData==nil||productListData.count==0) {
            UIImageView *hisIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"proli_hisicon.png"]];
            [hisIcon setFrame:CGRectMake(310, 215, 417, 223)];
            [self.view addSubview:hisIcon];
            [hisIcon release];
            
            UIButton *backBut=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [backBut setImage:[UIImage imageNamed:@"proli_goshop1.png"] forState:UIControlStateNormal];
            [backBut setImage:[UIImage imageNamed:@"proli_goshop2.png"] forState:UIControlStateHighlighted];
            [backBut addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
            [backBut setFrame:CGRectMake(425, 500, 177, 46)];
            [self.view  addSubview:backBut];
        }
        [productTableView reloadData]; 
    }else if (productListType == ListType_orderProducts){
        [productTableView reloadData];
    }
    [MobClick beginLogPageView:@"product_list"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [clearHistoryView setHidden:YES];
    [self.productDragView removeFromSuperview];
    self.productDragView = nil;
    self.isDragging = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"product_list"];
}


-(void)back:(id)sender{
    CATransition *transition = [CATransition animation];
    transition.duration = OTSP_TRANS_DURATION;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type =kCATransitionFade; //@"cube";
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}


- (void)handleFilterChange:(NSNotification *)note{
    if (note.userInfo) {
        [filterBut setBackgroundImage:[UIImage imageNamed:@"proli_topfilter3.png"] forState:UIControlStateNormal];
        [filterBut setBackgroundImage:[UIImage imageNamed:@"proli_topfilter4.png"] forState:UIControlStateHighlighted];
        //在筛选条件只有1个且这个条件是一号店筛选的时候，为0就是没筛选
        if (note.userInfo.count==1) {
            NSString* key=[note.userInfo.allKeys objectAtIndex:0];
            if ([key isEqualToString:YihaodianOnly]&&[[note.userInfo valueForKey:YihaodianOnly] intValue]==0) {
                [filterBut setBackgroundImage:[UIImage imageNamed:@"proli_topfilter1.png"] forState:UIControlStateNormal];
                [filterBut setBackgroundImage:[UIImage imageNamed:@"proli_topfilter2.png"] forState:UIControlStateHighlighted];
            }
        }
    }else {
        [filterBut setBackgroundImage:[UIImage imageNamed:@"proli_topfilter1.png"] forState:UIControlStateNormal];
        [filterBut setBackgroundImage:[UIImage imageNamed:@"proli_topfilter2.png"] forState:UIControlStateHighlighted];
    }
}


//- (void)handleProVinceChange:(NSNotification *)note
//{
//    _needQuitWhenAppear = YES;
//}


- (void)loadProductListTop{
    // 筛选排序的按钮
    if (productListType == 0 || productListType == 1 || productListType == 5) {
        if (butBg!=nil) {
            [butBg release];
        }
        butBg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"proli_butbg.png"]];
        [butBg setFrame:CGRectMake(453, 7, 99, 35)];
        [productListTopView addSubview:butBg];
        
        defBut=[[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [defBut setTitle:@"默认"  forState:UIControlStateNormal];
        [defBut setTitleColor:kBlackColor forState:UIControlStateNormal];
        [defBut setTitleColor:kRedColor forState:UIControlStateSelected];
        defBut.selected=YES;
        defBut.titleLabel.font=[defBut.titleLabel.font fontWithSize:17];
        [defBut addTarget:self action:@selector(defClick:) forControlEvents:UIControlEventTouchUpInside];
        [defBut setFrame:CGRectMake(460, 1, 85,40)];
        [productListTopView addSubview:defBut];
        
        salesBut=[[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [salesBut setImage:[UIImage imageNamed:@"proli_topxl1.png"] forState:UIControlStateNormal];
        [salesBut setImage:[UIImage imageNamed:@"proli_topxl2.png"] forState:UIControlStateHighlighted];
        [salesBut setImage:[UIImage imageNamed:@"proli_topxl2.png"] forState:UIControlStateSelected];
        [salesBut addTarget:self action:@selector(salesClick:) forControlEvents:UIControlEventTouchUpInside];
        [salesBut setFrame:CGRectMake(568, 11, 49,19)];
        [productListTopView addSubview:salesBut];
        
        priceBut=[[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [priceBut setTitle:@"价格"  forState:UIControlStateNormal];
        [priceBut setTitleColor:kBlackColor forState:UIControlStateNormal];
        
        [priceBut setImage:[UIImage imageNamed:@"priceSortAsc@2x.png"] forState:UIControlStateNormal];
        
        [priceBut addTarget:self action:@selector(priceClick:) forControlEvents:UIControlEventTouchUpInside];
        [priceBut setFrame:CGRectMake(660, 11, 49,19)];
        [productListTopView addSubview:priceBut];
        
        
        evaluateBut=[[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [evaluateBut setImage:[UIImage imageNamed:@"proli_toppj1.png"] forState:UIControlStateNormal];
        [evaluateBut setImage:[UIImage imageNamed:@"proli_toppj2.png"] forState:UIControlStateHighlighted];
        [evaluateBut setImage:[UIImage imageNamed:@"proli_toppj2.png"] forState:UIControlStateSelected];
        
        [evaluateBut addTarget:self action:@selector(evaluateClick:) forControlEvents:UIControlEventTouchUpInside];
        [evaluateBut setFrame:CGRectMake(750, 11, 49,19)];
        [productListTopView addSubview:evaluateBut];
        
        filterBut=[[UIButton buttonWithType:UIButtonTypeCustom] retain];
        
        
        if (dataHandler.filterDic==nil||dataHandler.filterDic.count==0) {
            [filterBut setBackgroundImage:[UIImage imageNamed:@"proli_topfilter1.png"] forState:UIControlStateNormal];
            [filterBut setBackgroundImage:[UIImage imageNamed:@"proli_topfilter2.png"] forState:UIControlStateHighlighted];
        }else {
            [filterBut setBackgroundImage:[UIImage imageNamed:@"proli_topfilter3.png"] forState:UIControlStateNormal];
            [filterBut setBackgroundImage:[UIImage imageNamed:@"proli_topfilter4.png"] forState:UIControlStateHighlighted];
            if (dataHandler.filterDic.count==1) {
                NSString* key=[dataHandler.filterDic.allKeys objectAtIndex:0];
                if ([key isEqualToString:YihaodianOnly]&&[[dataHandler.filterDic valueForKey:YihaodianOnly] intValue]==0) {
                    [filterBut setBackgroundImage:[UIImage imageNamed:@"proli_topfilter1.png"] forState:UIControlStateNormal];
                    [filterBut setBackgroundImage:[UIImage imageNamed:@"proli_topfilter2.png"] forState:UIControlStateHighlighted];
                }
            }

        }
        
        [filterBut setBackgroundImage:[UIImage imageNamed:@"proli_topfilter5.png"] forState:UIControlStateDisabled];
        [filterBut addTarget:self action:@selector(filterClick:) forControlEvents:UIControlEventTouchUpInside];
        [filterBut setFrame:CGRectMake(820, 5, 65,31)];
        [productListTopView addSubview:filterBut];
        
        if (popTag!=nil) {
            [popTag release];
        }
        popTag=[[UIView alloc]initWithFrame:CGRectMake(730, 5, 243,35)];
        [productListTopView addSubview:popTag];
        [productListTopView sendSubviewToBack:popTag];
        self.butArray=[NSArray arrayWithObjects:defBut,salesBut,priceBut,evaluateBut, nil];
    }
    // 浏览历史增加清空按钮
    else if(productListType == 4)
    {
        
        cleanHistory=[[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [cleanHistory setImage:[UIImage imageNamed:@"clear.png"] forState:UIControlStateNormal];
        [cleanHistory setImage:[UIImage imageNamed:@"clear_down.png"] forState:UIControlStateHighlighted];
        [cleanHistory setImage:[UIImage imageNamed:@"clear_down.png"] forState:UIControlStateSelected];
        
        
        [cleanHistory addTarget:self action:@selector(clearHistoryBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [cleanHistory setFrame:CGRectMake(900, 7, 30,30)];
        [productListTopView addSubview:cleanHistory];
    }
    
}
-(void)search:(id)sender{
    UITextField *textField=(UITextField *)sender;
    self.keyword=textField.text;
    self.cateid=[NSNumber numberWithInt:0];
    //    if(cate1){
    //        [cate1 release];
    //    }
    //    self.cate1=nil;
    //    if(cate2){
    //        [cate2 release];
    //    }
    //    self.cate2=nil;
    //    if(cate3){
    //        [cate3 release];
    //    }
    //    self.cate3=nil;
    for (UIView *subview  in productListTopView.subviews) {
        [subview removeFromSuperview];
    }
    productListType=1;
    [self loadProductListTop];
    [dataHandler.filterDic removeAllObjects];
    dataHandler.filterDic=nil;
    dataHandler.filterDic=[NSMutableDictionary dictionaryWithCapacity:1];
    [self reloadListData];
}

-(void)updataButSelected:(UIButton *)sender
{
    [self updatePriceButtonImage:sender];
    
    for (UIButton *but in butArray) {
        if (but==sender) {
            but.selected=YES;
            
            CGRect rect=butBg.frame;
            rect.origin.x=but.frame.origin.x-(rect.size.width-but.frame.size.width)/2;
            [UIView animateWithDuration:kShowRootCateDuration
                             animations:^{
                                 
                                 butBg.frame = rect;
                             }
                             completion:^(BOOL finished){
                                 
                             }];
            
        }else {
            but.selected=NO;
        }
    }
    
    self.lastSelectedButton = sender;
}
-(void)defClick:(UIButton *)sender{
    if (isLoadFinish) {
        if ([sortType intValue]!=1) {
            self.sortType=[NSNumber numberWithInt:1];
            [self updataButSelected:sender];
            [self reloadListData];
        }
    }
}

-(void)cleanHistoryClick:(UIButton *)sender
{
    [clearHistoryView setHidden:YES];
    
    if (productListData && productListData.count>0) {
        [self performInThreadBlock:^(){
            
            [dataHandler deleteProductHistory];
            self.productListData=[dataHandler queryProductHistory];
            
        } completionInMainBlock:^(){
            
            [productTableView reloadData];
            
            UIImageView *hisIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"proli_hisicon.png"]];
            [hisIcon setFrame:CGRectMake(310, 215, 417, 223)];
            [self.view addSubview:hisIcon];
            [hisIcon release];
            
            UIButton *backBut=[UIButton buttonWithType:UIButtonTypeCustom];
            
            [backBut setImage:[UIImage imageNamed:@"proli_goshop1.png"] forState:UIControlStateNormal];
            [backBut setImage:[UIImage imageNamed:@"proli_goshop2.png"] forState:UIControlStateHighlighted];
            [backBut addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
            [backBut setFrame:CGRectMake(425, 500, 177, 46)];
            [self.view  addSubview:backBut];
        }];
    }
}

-(void)salesClick:(UIButton *)sender{
    if (isLoadFinish) {
        if ([sortType intValue]!=2) {
            self.sortType=[NSNumber numberWithInt:2];
            [self updataButSelected:sender];
            [self reloadListData];
        }
    }
}
-(void)evaluateClick:(UIButton *)sender{
    if (isLoadFinish) {
        if ([sortType intValue]!=5) {
            self.sortType=[NSNumber numberWithInt:5];
            [self updataButSelected:sender];
            [self reloadListData];
        }
    }
}

-(void)updatePriceButtonImage:(UIButton*)aClickedButton
{
    if (aClickedButton == priceBut)
    {
        if (self.isPriceAscending)
        {
            [priceBut setImage:[UIImage imageNamed:@"priceSortAscRed@2x.png"] forState:UIControlStateSelected];
        }
        else
        {
            [priceBut setImage:[UIImage imageNamed:@"priceSortDescRed@2x.png"] forState:UIControlStateSelected];
        }
    }
    else
    {
        if (self.isPriceAscending)
        {
            [priceBut setImage:[UIImage imageNamed:@"priceSortAsc@2x.png"] forState:UIControlStateNormal];
        }
        else
        {
            [priceBut setImage:[UIImage imageNamed:@"priceSortDesc@2x.png"] forState:UIControlStateNormal];
        }
    }
}

-(void)priceClick:(UIButton *)sender
{
    if (isLoadFinish) {
        if (self.lastSelectedButton == sender)
        {
            if (self.isPriceAscending)
            {
                self.isPriceAscending = NO;
            }
            else
            {
                self.isPriceAscending = YES;
            }
        }
        
        self.sortType = self.isPriceAscending ? [NSNumber numberWithInt:3] : [NSNumber numberWithInt:4];
        
        [self updataButSelected:sender];
        [self reloadListData];
    }
}


-(void)filterClick:(UIButton *)sender
{
    // tracking 统计
    JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_Filiter extraPramaDic:nil]autorelease];
    [DoTracking doJsTrackingWithParma:prama];
    
    [self updataButSelected:sender];
    self.sortType=[NSNumber numberWithInt:1];
    PopViewController *pop = [PopViewController alloc] ;
    pop.popDelegate = self;
    pop.type = 1;
    [[pop initWithNibName:nil bundle:nil]autorelease];
    pop.view.backgroundColor=[UIColor clearColor];
    
    
    if (searchAttributes)
    {
        pop.listData=[NSMutableArray arrayWithArray: searchAttributes];
    }
    else
    {
        pop.listData=[NSMutableArray arrayWithCapacity:2];
    }
    
    if (searchPriceVO)
    {
        [pop.listData insertObject:@"价格"  atIndex:0];
        pop.searchPriceVO=searchPriceVO;
    }
    
    if (searchBrandVO) {
        
        [pop.listData insertObject: @"品牌" atIndex:0 ];
        pop.searchBrandVO=searchBrandVO;
    }
    //插入1号店单选
    [pop.listData insertObject:YihaodianOnly atIndex:0];
    
    UINavigationController *nav = [[[UINavigationController alloc]initWithRootViewController:pop] autorelease];
    nav.navigationBarHidden=YES;
    
   	self.currentPopover = [[[WEPopoverController alloc] initWithContentViewController:nav] autorelease];
	self.currentPopover.popoverContentSize = CGSizeMake(243.0,282);
    if ([self.currentPopover respondsToSelector:@selector(setContainerViewProperties:)]) {
        [self.currentPopover setContainerViewProperties:[self improvedContainerViewProperties]];
    }
    
    [self.currentPopover presentPopoverFromRect:popTag.bounds  inView:popTag permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown) animated:YES];
}


-(void)reloadListData{
    
    [productListData removeAllObjects];
    self.currentPage = [NSNumber numberWithInt:1];
    [self otsDetatchMemorySafeNewThreadSelector:@selector(getProductListService) toTarget:self withObject:nil];
    
    [self.loadingView showInView:self.view];
}

#pragma mark -
#pragma mark WEPopover set
- (WEPopoverContainerViewProperties *)improvedContainerViewProperties {
	
	WEPopoverContainerViewProperties *props = [[WEPopoverContainerViewProperties alloc] autorelease];
	NSString *bgImageName = nil;
	CGFloat bgMargin = 0.0;
	CGFloat bgCapSize = 0.0;
	CGFloat contentMargin = 4.0;
	
	bgImageName = @"filter_bg.png";
	
	// These constants are determined by the popoverBg.png image file and are image dependent
	bgMargin = 4; // margin width of 13 pixels on all sides popoverBg.png (62 pixels wide - 36 pixel background) / 2 == 26 / 2 == 13
	bgCapSize = 0; // ImageSize/2  == 62 / 2 == 31 pixels
	
	props.leftBgMargin = bgMargin;
	props.rightBgMargin = bgMargin;
	props.topBgMargin = 8;
	props.bottomBgMargin = bgMargin;
	props.leftBgCapSize = bgCapSize;
	props.topBgCapSize = bgCapSize;
	props.bgImageName = bgImageName;
	props.leftContentMargin = contentMargin-1;
	props.rightContentMargin = contentMargin - 1; // Need to shift one pixel for border to look correct
	props.topContentMargin =2;// contentMargin;
	props.bottomContentMargin = contentMargin;
	
	props.arrowMargin = -5.0;
	
	props.upArrowImageName = @"popoverArrowUp.png";
	props.downArrowImageName = @"popoverArrowDown.png";
	props.leftArrowImageName = @"popoverArrowLeft.png";
	props.rightArrowImageName = @"popoverArrowRight.png";
	return props;
}

#pragma mark -
#pragma mark CartView Delegate
- (void)openCartViewController
{
    [SharedPadDelegate enterCart];
}

#pragma mark -
#pragma mark pop Delegate
- (void)popItemSelected:(NSNumber *)brandid attribute:(NSString *) attribute priceRange:(NSString *)priceRange
{
    
    self.attributes = attribute;
    self.brandId = brandid;
    self.price = priceRange;
    self.isYihaodian=[dataHandler.filterDic valueForKey:YihaodianOnly];
    if (self.isYihaodian==nil) {
        [dataHandler.filterDic setObject:[NSNumber numberWithInt:0] forKey:YihaodianOnly];
        self.isYihaodian=[dataHandler.filterDic valueForKey:YihaodianOnly];
    }
    [self reloadListData];
}

-(NSString*)attributesFilterString
{
    return attributes;
}

- (void)popClose{
    [self.currentPopover dismissPopoverAnimated:YES];
}

#pragma mark -
#pragma mark handel UIPanGestureRecognizer 手势处理
-(void)handelTap:(UIPanGestureRecognizer*)gestureRecognizer
{
    if (self.isDragging)
    {
        return;
    }
    //获取平移手势对象在self.view的位置点，并将这个点作为self.aView的center,这样就实现了拖动的效果(175, 210, 37, 32)
    ProductView *selectedPv= (ProductView *)gestureRecognizer.view;
    CGPoint curPoint = [gestureRecognizer locationInView:selectedPv];
    //DebugLog(@"%f,%f",curPoint.x,curPoint.y);
    if ( curPoint.x>195&&curPoint.x<195+37&&curPoint.y>223&&curPoint.y<223+32) {
        if(![selectedPv.product.canBuy isEqualToString:@"true"]){
            return;
        }
        CGRect rect= cartView.frame;
        if (rect.size.width==kCartViewWidth) {
            rect.size.width+=kCartViewWidthExtend;
            rect.origin.x-=kCartViewWidthExtend;
            cartView.frame =rect;
            
        }
        
        [self cartAddProduct:selectedPv.product];
        
    }
    else
    {
        if (productListType!=4)
        {
            NSString *urlStr = @"http://m.1mall.com/mw/product/";
            NSNumber *grouponId = selectedPv.product.productId;
            NSNumber *areaId = [GlobalValue getGlobalValueInstance].provinceId;
            if ([GlobalValue getGlobalValueInstance].token == nil) {
                urlStr = [urlStr stringByAppendingFormat:@"%@/%@/?osType=%d",grouponId,areaId,40];
            } else {
                // 对 token 进行base64加密
                NSData *b64Data = [GTMBase64 encodeData:[[GlobalValue getGlobalValueInstance].token dataUsingEncoding:NSUTF8StringEncoding]];
                NSString *b64Str = [[[NSString alloc] initWithData:b64Data encoding:NSUTF8StringEncoding] autorelease];
                urlStr = [urlStr stringByAppendingFormat:@"%@/%@/?osType=%d&token=%@",grouponId,areaId,40,b64Str];
            }
            if (selectedPv.product.isYihaodian && selectedPv.product.isYihaodian.intValue==0) {
                WebViewController* web=[[WebViewController alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) WapType:4 URL:urlStr];
                web.isFirstToMallWeb=YES;
                [web customSizeWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                [self.view addSubview:web.view];
                return;
            }
        }

        //开始
        CATransition *transition = [CATransition animation];
        transition.duration = OTSP_TRANS_DURATION;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade; //@"cube";
        transition.subtype = kCATransitionFromRight;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        
        OTSPadProductDetailVC *vc = [[[OTSPadProductDetailVC alloc] init] autorelease];
        vc.product = selectedPv.product;
        DebugLog(@"productId:%@",vc.product.productId);
        //设置promotionID 为nil 显示一号店价钱 从浏览历史进入
        if(productListType == 4){
            [vc.product setPromotionId:nil];
        }
        OTSCateInfo *cateInfo = [[[OTSCateInfo alloc] init] autorelease];
        cateInfo.cate1 = cate1;
        cateInfo.cate2 = cate2;
        cateInfo.cate3 = cate3;
        cateInfo.listData = listData;
        vc.cateInfo = cateInfo;
        
        [self.navigationController pushViewController:vc animated:NO];
    }
}

-(void)cartAddProduct:(ProductVO*)aProduct
{
    if (aProduct)
    {
        [topView setCartCount:dataHandler.cart.totalquantity.intValue];
        [cartView setCartCount:dataHandler.cart.totalquantity.intValue];
        
        int minCount = 1;
        if ([aProduct.shoppingCount intValue] > minCount) {
            minCount = [aProduct.shoppingCount intValue];
        }
        [dataHandler addProductToCart:aProduct buyCount:minCount];
        //[cartView reloadData];
        [MobClick event:@"click_addcart"];
        
        // 加入购物车统计
        JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_AddCart extraPramaDic:nil]autorelease];
        [prama setProductId:aProduct.productId];
        [prama setMerchant_id:[NSString stringWithFormat:@"%@",aProduct.merchantId]];
        [DoTracking doJsTrackingWithParma:prama];
    }
}


-(void)handelLongPress:(UIPanGestureRecognizer*)gestureRecognizer
{
    CGPoint curPoint = [gestureRecognizer locationInView:self.view];
    ProductView *selectedPv= (ProductView *)gestureRecognizer.view;
    DebugLog(@"handelLongPress---%f",curPoint.x);
    if (selectedPv.product.isYihaodian!=nil&&selectedPv.product.isYihaodian.intValue==0) {
        return;
    }
    //开始
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan)
    {
        if (!self.isDragging)
        {
            self.isDragging = YES;
            
            self.productDragView = [[[ProductView alloc] initWithFrame:CGRectMake(200, 200, 256,282) product:selectedPv.product ispop:YES productListType:productListType] autorelease];
            self.productDragView.center=curPoint;
            
            [self.view addSubview:self.productDragView];
            //[productView release];
            oldViewRect = self.productDragView.frame;
            
            CGRect rect= cartView.frame;
            if (rect.size.width == kCartViewWidth)
            {
                rect.size.width += kCartViewWidthExtend;
                rect.origin.x -= kCartViewWidthExtend;
                cartView.frame = rect;
            }
        }
    }
    
    else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded)
    {
        if (curPoint.x > 1024 - kCartViewWidth - kCartViewWidthExtend && curPoint.x < 1022)
        {
            //dataHandler.cart.totalquantity=[NSNumber numberWithInt:[dataHandler.cart.totalquantity intValue]+1];
            if([selectedPv.product.canBuy isEqualToString:@"true"])
            {
                
                [topView setCartCount:dataHandler.cart.totalquantity.intValue];
                [cartView setCartCount:dataHandler.cart.totalquantity.intValue];
                
                [dataHandler addProductToCart:selectedPv.product buyCount:1];
                [MobClick event:@"drag_cart"];
                [self.productDragView removeFromSuperview];
                
                // 加入购物车统计
                JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_AddCart extraPramaDic:nil]autorelease];
                [prama setProductId:selectedPv.product.productId];
                [prama setMerchant_id:[NSString stringWithFormat:@"%@",selectedPv.product.merchantId]];
                [DoTracking doJsTrackingWithParma:prama];
            }
            else
            {
                [self animateView:oldViewRect view:self.productDragView];
                if (![dataHandler.cart.totalquantity intValue])
                {
                    CGRect rect= cartView.frame;
                    if (rect.size.width==kCartViewWidth+kCartViewWidthExtend) {
                        rect.size.width-=kCartViewWidthExtend;
                        rect.origin.x+=kCartViewWidthExtend;
                        cartView.frame =rect;
                    }
                }
            }
            
            //[cartView reloadData];
        }
        else
        {
            [self animateView:oldViewRect view:self.productDragView];
            CGRect rect= cartView.frame;
            if (rect.size.width==kCartViewWidth+kCartViewWidthExtend)
            {
                rect.size.width-=kCartViewWidthExtend;
                rect.origin.x+=kCartViewWidthExtend;
                cartView.frame =rect;
                
            }
            
        }
        
        self.isDragging = NO;
    }
    
    else
    {
        self.productDragView.center=curPoint;
    }
}


// animate home view to side rect
- (void)animateView:(CGRect)newViewRect view:(UIView *)view{
    [UIView animateWithDuration:0.5
                     animations:^{
                         view.frame = newViewRect;
                     }
                     completion:^(BOOL finished){
                         
                         [view removeFromSuperview];
                     }];
}

#pragma mark -
#pragma mark yhd Service
-(void)getAttributesList{
    NSString* token=nil;
    SearchResultVO *result = nil;
    if ([GlobalValue getGlobalValueInstance].token==nil) {
        token=@"";
    }else{
        token=[GlobalValue getGlobalValueInstance].token;
    }
    
    SearchParameterVO*sParam=[[SearchParameterVO alloc] init];
    [sParam setKeyword:keyword];
    [sParam setCategoryId:cateid];
    [sParam setBrandId:brandId];
    [sParam setAttributes:attributes];
    [sParam setPriceRange:price];
    [sParam setFilter:filter];
    [sParam setSortType:sortType];    
    result=[[OTSServiceHelper sharedInstance] searchAttributesOnly:[GlobalValue getGlobalValueInstance].trader provinceId:[OTSGpsHelper sharedInstance].provinceVO.nid mcsiteid:[NSNumber numberWithInt:1] isDianzhongdian:self.isYihaodian searchParameterVO:sParam  token:token];

}

-(void)getProductListService
{
    //促销精选
    if (productListType == 2)
    {
        //缓存轮播图数据 缓存时间为一天
//        NSString * _KEY = [OTSUtility NSDateToNSStringDateV2:[NSDate date]];
//        
//        Page *page = [OTSUtility getPagesFromLocal:@"PROMOTIONPRODUCT" withKey:_KEY];
//        if (!page) {
         Page*  page = [[OTSServiceHelper sharedInstance] getPromotionProductPage:[GlobalValue getGlobalValueInstance].trader provinceId:[OTSGpsHelper sharedInstance].provinceVO.nid categoryId:[NSNumber numberWithInt:0] currentPage:currentPage pageSize:[NSNumber numberWithInt:16]];
//            [OTSUtility putPagesToLocal:page withPageName:@"PROMOTIONPRODUCT" withKey:_KEY];
//        }
        if (page)
        {
            [self performSelectorOnMainThread:@selector(handlePromotionList:) withObject:page waitUntilDone:YES];
        }
        
    }
    
    //进入首页轮播大图
    else if (productListType==3) {
        //  根据cmspage, cmscolumn 获取促销商品
        //缓存轮播图数据 缓存时间为一天 key 加上省份
        NSString *_KEY = [NSString stringWithFormat:@"p%@_a%@_%@",[OTSGpsHelper sharedInstance].provinceVO.nid,activityID, [OTSUtility NSDateToNSStringDateV2:[NSDate date]]];
        Page *page = [OTSUtility getPagesFromLocal:@"CMSPAGE" withKey:_KEY];
        if (!page) {
            page = [[OTSServiceHelper sharedInstance] getCmsPageList:[GlobalValue getGlobalValueInstance].trader provinceId:[OTSGpsHelper sharedInstance].provinceVO.nid activityId:activityID currentPage:currentPage pageSize:[NSNumber numberWithInt:500]];
            [OTSUtility putPagesToLocal:page withPageName:@"CMSPAGE" withKey:_KEY];
        }
        else {
            [self otsDetatchMemorySafeNewThreadSelector:@selector(threadsavecmspage:) toTarget:self withObject:_KEY];
        }

        if (page)
        {
            [self performSelectorOnMainThread:@selector(handleHotProductList:) withObject:page waitUntilDone:YES];
        }
        
    }
    else
    {
        SearchResultVO *result = nil;
        
        DebugLog(@"brandId:%@, price:%@ attributes:%@ ", brandId, price, attributes);
        NSString* token =nil;
        if ([GlobalValue getGlobalValueInstance].token)
        {
            //sortType 0:不排序,1:按相关性排序,2:按销量倒序,3:按价格升序,4:按价格倒序,5:按好评度倒序,6:按上架时间倒序
            token=[GlobalValue getGlobalValueInstance].token;
        }
        else
        {
            token=@"";
        }
        SearchParameterVO*sParam=[[SearchParameterVO alloc] init];
        [sParam setKeyword:keyword];
        [sParam setCategoryId:cateid];
        [sParam setBrandId:brandId];
        [sParam setAttributes:attributes];
        [sParam setPriceRange:price];
        [sParam setFilter:filter];
        [sParam setSortType:sortType];

        result=[[OTSServiceHelper sharedInstance] searchProductsOnly:[GlobalValue getGlobalValueInstance].trader provinceId:[OTSGpsHelper sharedInstance].provinceVO.nid mcsiteid:[NSNumber numberWithInt:1] isDianzhongdian:self.isYihaodian searchParameterVO:sParam currentPage:currentPage
                                                                             pageSize:[NSNumber numberWithInt:16] token:token];
        [self performSelectorOnMainThread:@selector(handleProductList:) withObject:result waitUntilDone:YES];
    }
}

-(void)threadsavecmspage:(NSString *) key
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    Page *page = [[OTSServiceHelper sharedInstance] getCmsPageList:[GlobalValue getGlobalValueInstance].trader provinceId:[OTSGpsHelper sharedInstance].provinceVO.nid activityId:activityID currentPage:currentPage pageSize:[NSNumber numberWithInt:500]];
    [OTSUtility putPagesToLocal:page withPageName:@"CMSPAGE" withKey:key];
    [pool drain];
}

-(void)handleProductList:(SearchResultVO *)result
{
    //    UIView *activityView = [self.view viewWithTag:kActivityViewTag];
    //    if (activityView)
    //    {
    //        [activityView removeFromSuperview];
    //    }
    [self.loadingView hide];
    productTableView.tableFooterView = nil;
    if (result==nil) {
        isLoadFinish = YES;
        [self showError:@"网络异常，请检查网络配置..."];
        return;
    }
    
    UIView *noFoundView = [self.view viewWithTag:kNoFoundViewTag];
    if (noFoundView)
    {
        [noFoundView removeFromSuperview];
    }
    
    Page *page=result.page;
//    self.searchAttributes= result.searchAttributes;
//    if (result.searchPriceVO.childs.count > 0) { // 通过价格筛选后的result所搜组没有返回对应的searchPriceVO, 现在依然采用第一次的VO
//        self.searchPriceVO=result.searchPriceVO;
//    }
//    self.searchBrandVO=result.searchBrandVO;
    
    if (page.objList.count > 0)
    {
        [self.productListData addObjectsFromArray: [NSArray arrayWithArray: page.objList]];
        isLoadFinish = YES;
        
    }
    else
    {
        isLoadFinish = NO;
    }
    
    [productTableView reloadData];
    //productTableView.tableFooterView = nil;
    
    //没有搜索结果
    if (productListData.count==0) {
        UIView *noFoundView=[[UIView alloc]initWithFrame:CGRectMake(335,223, 290, 240)];
        noFoundView.tag=kNoFoundViewTag;
        UIImageView *noFoundImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"proli_nofound.png"]];
        
        noFoundImageView.frame=CGRectMake((290-164)/2,0, 164, 167);
        [noFoundView addSubview:noFoundImageView];
        [noFoundImageView release];
        
        UILabel *noFoundLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 290.0, 30.0) ];
        noFoundLabel.textColor = kBlackColor;
        noFoundLabel.textAlignment=NSTextAlignmentCenter;
        noFoundLabel.backgroundColor=[UIColor clearColor];
        noFoundLabel.font=[noFoundLabel.font fontWithSize:19.0];
        if (productListType==1 || productListType == 5) {
            noFoundLabel.text=@"很抱歉，暂时未搜索到商品";
        }else {
            noFoundLabel.text=@"很抱歉，没有符合条件的商品";
        }
        
        [noFoundView insertSubview:noFoundLabel atIndex:1];
        [noFoundLabel release];
        
        [self.view addSubview:noFoundView];
        [noFoundView release];
    }
    if (productListType==1 || productListType == 5) {
        int total=0;
        if (page.totalSize) {
            total=[page.totalSize intValue];
        }
        //searcheLabel.text=[NSString stringWithFormat: @"共搜索到%i个商品",total];
        [productListTopView.searchLabel setText:[NSString stringWithFormat: @"共搜索到%i个商品",total]];
    }
    
    switch (self.productListType) {
        case ListType_Category:{
            JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_CategoryProductList extraPrama:cateid, currentPage, nil]autorelease];
            [prama setResultSum:page.totalSize];
            [DoTracking doJsTrackingWithParma:prama];
        }
            break;
        case ListType_Search:{
            JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_Search extraPrama:currentPage, nil]autorelease];
            [prama setResultSum:page.totalSize];
            [prama setInternalKeyWord:keyword];
            [DoTracking doJsTrackingWithParma:prama];
        }
            break;
        default:
            break;
    }
    [self performInThreadBlock:^{
        SearchParameterVO*sParam=[[SearchParameterVO alloc] init];
        [sParam setKeyword:keyword];
        [sParam setCategoryId:cateid];
        [sParam setBrandId:brandId];
        [sParam setAttributes:attributes];
        [sParam setPriceRange:price];
        [sParam setFilter:filter];
        [sParam setSortType:sortType];
        NSString*token=[GlobalValue getGlobalValueInstance].token;
        if (token==nil) {
            token=@"";
        }

       SearchResultVO* attributesVO=[[OTSServiceHelper sharedInstance] searchAttributesOnly:[GlobalValue getGlobalValueInstance].trader provinceId:[GlobalValue getGlobalValueInstance].provinceId mcsiteid: [NSNumber numberWithInt:1]isDianzhongdian:[NSNumber numberWithInt:0] searchParameterVO:sParam token:token];
        self.searchAttributes= attributesVO.searchAttributes;
            if (attributesVO.searchPriceVO.childs.count > 0) { // 通过价格筛选后的result所搜组没有返回对应的searchPriceVO, 现在依然采用第一次的VO
                self.searchPriceVO=attributesVO.searchPriceVO;
           }
            self.searchBrandVO=attributesVO.searchBrandVO;
    } completionInMainBlock:^{
        if ([price isEqualToString:@""] && [filter isEqualToString:@""] && [attributes isEqualToString:@""] && [brandId intValue]==0 && [productListData count]==0) {
            [filterBut setEnabled:NO];
        } else {
            [filterBut setEnabled:YES];
        }
    }];
}
-(void)handlePromotionList:(Page *)page
{
    
    //    UIView *activityView=[self.view viewWithTag:kActivityViewTag];
    //    if (activityView) {
    //        [activityView removeFromSuperview];
    //    }
    [self.loadingView hide];
    
    UIView *noFoundView=[self.view viewWithTag:kNoFoundViewTag];
    if (noFoundView) {
        [noFoundView removeFromSuperview];
    }
    if (page.objList.count>0) {
        int total=[page.pageSize intValue]*[page.currentPage intValue];
        if (total<[page.totalSize intValue]+16) {
            if (total>[page.totalSize intValue]) {
                NSRange range;
                range.length=[page.totalSize intValue]+16-total;
                range.location=0;
                [self.productListData addObjectsFromArray:[ page.objList subarrayWithRange:range]];
            }else {
                [self.productListData addObjectsFromArray: [NSArray arrayWithArray: page.objList ]];
            }
            
            
            [productTableView reloadData];
            isLoadFinish=YES;
        }else {
            isLoadFinish=NO;
        }
        
    }else {
        
        isLoadFinish=NO;
    }
    if ([page.totalSize intValue]<=[page.currentPage intValue]*16) {
        productTableView.tableFooterView=nil;
    }
    if (productListData.count==0) {
        UIView *noFoundView=[[UIView alloc]initWithFrame:CGRectMake(335,223, 290, 240)];
        noFoundView.tag=kNoFoundViewTag;
        UIImageView *noFoundImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"proli_nofound.png"]];
        
        noFoundImageView.frame=CGRectMake((290-164)/2,0, 164, 167);
        [noFoundView addSubview:noFoundImageView];
        [noFoundImageView release];
        
        UILabel *noFoundLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 290.0, 30.0) ];
        noFoundLabel.textColor = kBlackColor;
        noFoundLabel.textAlignment=NSTextAlignmentCenter;
        noFoundLabel.backgroundColor=[UIColor clearColor];
        noFoundLabel.font=[noFoundLabel.font fontWithSize:19.0];
        noFoundLabel.text=@"很抱歉，没有符合条件的商品";
        [noFoundView insertSubview:noFoundLabel atIndex:1];
        [noFoundLabel release];
        
        [self.view addSubview:noFoundView];
        [noFoundView release];
    }
    
    
    // DebugLog(@"handleProductList==%@",array);
    
    
}

-(void)handleHotProductList:(Page *)page
{
    
    //    UIView *activityView=[self.view viewWithTag:kActivityViewTag];
    //    if (activityView) {
    //        [activityView removeFromSuperview];
    //    }
    
    UIView *noFoundView=[self.view viewWithTag:kNoFoundViewTag];
    if (noFoundView) {
        [noFoundView removeFromSuperview];
    }
    
    [self performInThreadBlock:^{
        
        if (page.objList.count>0) {
            //----------------从CmsColumnVO获取商品------------------------
            Page *_pagecmscolumn = nil;
            for (CmsPageVO *_cmspage in page.objList) {
                //缓存促销列表数据 缓存时间为一天
                NSString *_KEY = [NSString stringWithFormat:@"p%@_c%@_t%@_%@",[OTSGpsHelper sharedInstance].provinceVO.nid,[_cmspage.nid stringValue],_cmspage.type,[OTSUtility NSDateToNSStringDateV2:[NSDate date]]];
                _pagecmscolumn = [OTSUtility getPagesFromLocal:@"CMSCOLUMN" withKey:_KEY];
                if (!_pagecmscolumn) {
                    _pagecmscolumn = [[OTSServiceHelper sharedInstance] getCmsColumnList:[GlobalValue getGlobalValueInstance].trader provinceId:[OTSGpsHelper sharedInstance].provinceVO.nid cmsPageId:_cmspage.nid type:_cmspage.type currentPage:[NSNumber numberWithInt:1] pageSize:[NSNumber numberWithInt:500]];
                    [OTSUtility putPagesToLocal:_pagecmscolumn withPageName:@"CMSCOLUMN" withKey:_KEY];
                }
                else
                {
                    [self otsDetatchMemorySafeNewThreadSelector:@selector(threadsavecmscolumn:) toTarget:self withObject:page];
                }
  
                for (CmsColumnVO *_cmscolumn in _pagecmscolumn.objList) {
                    [self.productListData addObjectsFromArray:[NSArray arrayWithArray:_cmscolumn.productList]];
                }
            }
            
            //--------促销商品不分页----------
            isLoadFinish = NO;
            
        }else {
            
            isLoadFinish=NO;
        }
        
    } completionInMainBlock:^{
        
        [self.loadingView hide];
        [productTableView reloadData];
        
        if (productListData.count==0) {
            UIView *noFoundView=[[UIView alloc]initWithFrame:CGRectMake(335,223, 290, 240)];
            noFoundView.tag=kNoFoundViewTag;
            UIImageView *noFoundImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"proli_nofound.png"]];
            
            noFoundImageView.frame=CGRectMake((290-164)/2,0, 164, 167);
            [noFoundView addSubview:noFoundImageView];
            [noFoundImageView release];
            
            UILabel *noFoundLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 290.0, 30.0) ];
            noFoundLabel.textColor = kBlackColor;
            noFoundLabel.textAlignment=NSTextAlignmentCenter;
            noFoundLabel.backgroundColor=[UIColor clearColor];
            noFoundLabel.font=[noFoundLabel.font fontWithSize:19.0];
            noFoundLabel.text=@"很抱歉，没有符合条件的商品";
            [noFoundView insertSubview:noFoundLabel atIndex:1];
            [noFoundLabel release];
            
            [self.view addSubview:noFoundView];
            [noFoundView release];
        }
        
    }];
    
}

-(void)threadsavecmscolumn:(Page *) _page
{
    Page *_pagecmscolumn = nil;
    for (CmsPageVO *_cmspage in _page.objList) {
        //缓存促销列表数据 缓存时间为一天
        NSString *_KEY = [NSString stringWithFormat:@"p%@_c%@_t%@_%@",[OTSGpsHelper sharedInstance].provinceVO.nid,[_cmspage.nid stringValue],_cmspage.type,[OTSUtility NSDateToNSStringDateV2:[NSDate date]]];
        _pagecmscolumn = [OTSUtility getPagesFromLocal:@"CMSCOLUMN" withKey:_KEY];
        if (!_pagecmscolumn) {
            _pagecmscolumn = [[OTSServiceHelper sharedInstance] getCmsColumnList:[GlobalValue getGlobalValueInstance].trader provinceId:[OTSGpsHelper sharedInstance].provinceVO.nid cmsPageId:_cmspage.nid type:_cmspage.type currentPage:[NSNumber numberWithInt:1] pageSize:[NSNumber numberWithInt:500]];
            [OTSUtility putPagesToLocal:_pagecmscolumn withPageName:@"CMSCOLUMN" withKey:_KEY];
            [self.productListData removeAllObjects];
            for (CmsColumnVO *_cmscolumn in _pagecmscolumn.objList) {
                [self.productListData addObjectsFromArray:[NSArray arrayWithArray:_cmscolumn.productList]];
            }
        }
    }
    [self performSelectorOnMainThread:@selector(handleCMSProductList:) withObject:nil waitUntilDone:YES];
}

-(void)handleCMSProductList:(Page *)page
{
    [productTableView reloadData];

}

#pragma mark -
#pragma mark Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [clearHistoryView setHidden:YES];
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView.tag<kProCateTableViewTag) {
        //分类列表收回
        CGRect rect=productListTopView.cateTableViewBgView.frame;
        if (rect.origin.x==0) {
            rect.origin.x-=kCateTableWidth;
            [UIView animateWithDuration:kShowRootCateDuration
                             animations:^{
                                 
                                 productListTopView.cateTableViewBgView.frame = rect;
                             }
                             completion:^(BOOL finished){
                                 
                             }];
        }
        //购物车收回
        CGRect cartRect= cartView.frame;
        if (cartRect.size.width==kCartViewWidth+kCartViewWidthExtend) {
            cartRect.size.width-=kCartViewWidthExtend;
            cartRect.origin.x+=kCartViewWidthExtend;
            cartView.frame =cartRect;
            
        }
        
        
    }
}

#pragma mark -
#pragma mark Table Data Source Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (tableView.tag==kProCateTableViewTag) {
    //        return kCateTableCellHeight;
    //    }
    //    if (tableView.tag==kProCateTableView2Tag) {
    //        Cate2Cell *cell=(Cate2Cell *) [self tableView: tableView cellForRowAtIndexPath: indexPath];
    //        return cell.height;
    //    }
    //    if (tableView.tag == kProCate1TableViewTag || tableView.tag == kProCate2TableViewTag) {
    //        return 44;
    //    }
    return kCellHeight;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    //    if (tableView.tag==kProCateTableViewTag) {
    //        return self.listData.count;
    //    }
    //    if (tableView.tag==kProCateTableView2Tag) {
    //        return [self.categories  count];
    //    }
    //    if (tableView.tag == kProCate1TableViewTag) {
    //        return cate1Array.count;
    //    }
    //    if (tableView.tag == kProCate2TableViewTag) {
    //        return cate2Array.count;
    //    }
    int total=self.productListData.count;
    int n=self.productListData.count%viewNumInCell;
    return n==0?total/viewNumInCell:(total/viewNumInCell+1);
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CustomCellIdentifier = @"ProductCellCellIdentifier ";
    
    ProductCell *   cell = [[[ProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellIdentifier]autorelease] ;
    
    NSUInteger row = [indexPath row];
    NSRange theRange;
    theRange.location =row*viewNumInCell;
    if ((row+1)*viewNumInCell>productListData.count) {
        theRange.length = productListData.count-row*viewNumInCell;
    }else {
        theRange.length = viewNumInCell;
    }
    if (theRange.length>4) {
        return  cell;
    }
    cell.viewArray = [productListData subarrayWithRange:theRange];
    int i=0;
    for (ProductVO *product in cell.viewArray) {
        ProductView *cellPv=[[ProductView alloc]initWithFrame:CGRectMake(i*240, 0, 240,kCellHeight) product:product ispop:NO productListType:productListType];
        cellPv.delegate = self;
        if (product.hasGift.intValue) {
            UIImageView* giftLogo = [[UIImageView alloc]initWithFrame:CGRectMake(-2, 15, 66, 21)];
            [giftLogo setImage:[UIImage imageNamed:@"havefree"]];
            [giftLogo setBackgroundColor:[UIColor clearColor]];
            [cellPv addSubview:giftLogo];
            [giftLogo release];
        }
//        if (cell.viewArray.count<viewNumInCell) {
//            if (i==cell.viewArray.count-1) {
//                [cellPv setLast];
//            }
//        }
        [cell addSubview:cellPv];
        [cellPv release];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handelTap:)];
        [cellPv addGestureRecognizer:tapGes];
        [tapGes release];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handelLongPress:)];
        longPress.minimumPressDuration=kLongPressTime;
        [cellPv addGestureRecognizer:longPress];
        [longPress release];
        i++;
    }
    
    return cell;
}

-(void)handleAddToCartFromProductView:(id)sender
{
    if (![sender isKindOfClass:[ProductView class]])
    {
        return;
    }
    ProductView* productView = (ProductView*)sender;
    DebugLog(@"isCanBuy:%@",productView.product.canBuy);
    [self cartAddProduct:((ProductView*)sender).product];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (tableView.tag==kProCateTableViewTag||tableView.tag==kProCateTableView2Tag||tableView.tag==kProCate1TableViewTag||tableView.tag==kProCate2TableViewTag) {
    //        return;
    //    }
    int total=[self.productListData count]/4;
    if (indexPath.row == total - 1 && total > 3)
    {
        if (isLoadFinish)
        {
            if (productTableView.tableFooterView == nil)
            {
                UIView *footSpinnerView = [[UIView alloc] initWithFrame:CGRectMake(0,0 , 960, 45)];
                
                UIActivityIndicatorView *activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
                activityView.frame = CGRectMake(440.f, 10.0f, 25.0f, 25.0f);
                
                [footSpinnerView  insertSubview:activityView atIndex:1];
                [activityView startAnimating];
                
                UILabel *label1 = [[[UILabel alloc] initWithFrame:CGRectMake(470,5, 100, 35)] autorelease];
                //label1.textColor = [UIColor colorWithRed:240.0f/255.0f green:107.0f/255.0f blue:35.0f/255.0f alpha:1.0];
                
                label1.text=@"正在加载";
                label1.textAlignment=NSTextAlignmentCenter;
                label1.font=[label1.font fontWithSize:18.0];
                label1.backgroundColor=[UIColor clearColor];
                [footSpinnerView insertSubview:label1 atIndex:1];
                
                productTableView.tableFooterView = footSpinnerView;
                [footSpinnerView release];
            }
            
            isLoadFinish = NO;
            self.currentPage = [NSNumber numberWithInt:[currentPage intValue] + 1];
            [self otsDetatchMemorySafeNewThreadSelector:@selector(getProductListService) toTarget:self withObject:nil];
        }
        
    }
    else
    {
        //        productTableView.tableFooterView=nil;
    }
    
}
//- (void)closeCateView{
//    [self moveToRightSide:cateDetailView];
//}
// move view to left side
- (void)moveToLeftSide:(UIView *)view{
    
    [self animateViewToSide:CGRectMake(kCateDetailViewX, view.frame.origin.y, view.frame.size.width, view.frame.size.height) view:view];
}


// move view to right side
- (void)moveToRightSide:(UIView *)view {
    
    [self animateViewToSide:CGRectMake(dataHandler.screenWidth,view.frame.origin.y, view.frame.size.width, view.frame.size.height) view:view];
}

// animate home view to side rect
- (void)animateViewToSide:(CGRect)newViewRect view:(UIView *)view{
    [UIView animateWithDuration:kShowCateDetailDuration
                     animations:^{
                         view.frame = newViewRect;
                     }
                     completion:^(BOOL finished){
                         
                         //UIView *cateView=[self.view viewWithTag:kCateViewTag];
                         if (view.frame.origin.x==dataHandler.screenWidth) {
                             if(cateView){
                                 [cateView removeFromSuperview];
                             }
                             if (cateid) {
                                 [self reloadListData];
                                 
                             }
                         }
                     }];
}

- (void)viewDidUnload
{
    OTS_SAFE_RELEASE(topView);
    OTS_SAFE_RELEASE(productListTopView);
    OTS_SAFE_RELEASE(cartView);
    OTS_SAFE_RELEASE(cateView);
    OTS_SAFE_RELEASE(cateDetailView);
    OTS_SAFE_RELEASE(cateTableView);
    OTS_SAFE_RELEASE(cateTableViewBgView);
    OTS_SAFE_RELEASE(currentPopover);
    OTS_SAFE_RELEASE(priceBut);
    OTS_SAFE_RELEASE(filterBut);
    OTS_SAFE_RELEASE(salesBut);
    OTS_SAFE_RELEASE(evaluateBut);
    OTS_SAFE_RELEASE(defBut);
    OTS_SAFE_RELEASE(cleanHistory);
    OTS_SAFE_RELEASE(searcheLabel);
    OTS_SAFE_RELEASE(butBg);
    OTS_SAFE_RELEASE(butArray);
    OTS_SAFE_RELEASE(popTag);
    self.productDragView = nil;
    OTS_SAFE_RELEASE(_loadingView);
    [super viewDidUnload];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
										 duration:(NSTimeInterval)duration {
    // UIInterfaceOrientation interfaceOrientation = self.interfaceOrientation;
	//DebugLog(@"touzi-------willAnimateRotationToInterfaceOrientation----");
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait
        || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        DebugLog(@"yhd-------Portrait=======");
        dataHandler.screenWidth=768;
        
    }else{
        DebugLog(@"yhd-------left=======");
        dataHandler.screenWidth=1024;
        topView.frame=CGRectMake(0, 0,1024,kTopHeight);
        cartView.frame=CGRectMake(1024-kCartViewWidth, 100,kCartViewWidth,748-100);
        productTableView.frame=CGRectMake(0, 95,960,748-95);
        
    }
}

@end
