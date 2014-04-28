//
//  OTSProductDetail.m
//  TheStoreApp
//
//  Created by jiming huang on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define THREAD_STATUS_GET_PRODUCT_DETAIL    1
#define THREAD_STATUS_GET_DESCRIPTION  2
#define THREAD_STATUS_GET_COMMENT   3
#define THREAD_STATUS_GET_STOCK 4

#define ACTION_SHEET_SHARE  1

#define kViewTagSeriesBack 111
#define kViewTagSeries     112
#define kViewTagMinus 113
#define kViewTagAdd 114
#define kViewTagCountLbl 115
#define kSeriesButtonBaseTag 888


#import "OTSProductDetail.h"
#import "ProductService.h"
#import "GlobalValue.h"
#import "SDImageView+SDWebCache.h"
#import "StrikeThroughLabel.h"
#import "OTSTabView.h"
#import "ProductVO.h"
#import "OTSUtility.h"
#import "OTSProductImagesView.h"
#import "OTSAnimationTableView.h"
#import "OTSInterestedProducts.h"
#import "OTSNaviAnimation.h"
#import "OTSProductDescriptionView.h"
#import "OTSProductCommentView.h"
#import "OTSProductCommentViewV2.h"
#import "BrowseService.h"
#import "TheStoreAppAppDelegate.h"
#import "OTSShare.h"
#import "CategoryProductsViewController.h"
#import "OTSNNPiecesVC.h"
#import "GTMBase64.h"

#import "YWProductService.h"
#import "ProductInfo.h"
#import "YWFavoriteService.h"
#import "UserInfo.h"
#import "CommentInfo.h"
#import "YWBrowseService.h"
#import "SeriesButton.h"
#import "YWLocalCatService.h"
#import "LocalCarInfo.h"
#import "PromotionInfo.h"
#import "ConditionInfo.h"
#import "Gift.h"
#import "CategoryInfo.h"
#import "PromotionButton.h"

#import "mobidea4ec.h"
#import "RecommendView.h"

@interface OTSProductDetail()

-(void)initProductDetail;
-(void)setUpThread:(BOOL)showLoading;
-(void)stopThread;
-(void)newThreadGetProductDetail;
-(void)newThreadGetDescription;
-(void)newThreadGetComment;
@end

@implementation OTSProductDetail
@synthesize promotionPrice = _promotionPrice;
@synthesize pointIn;
@synthesize superVC;


#pragma mark - View lifecycle

-(id)initWithProductVO:(ProductInfo *)productVo fromTag:(OTSProductDetailFromTag)fromTag{
    self=[super init];
    if (self) {
        m_ProductDetailVO=[productVo retain];
        m_FromTag=fromTag;
    }
    return self;
}
-(id)initWithProductId:(long)productId promotionId:(NSString *)promotionId fromTag:(OTSProductDetailFromTag)fromTag
{
    self=[super init];
    if (self!=nil) {
        m_ProductId=productId;
        if (promotionId==nil)
        {
            m_PromotionId=[[NSString alloc] initWithString:@""];
        } else {
            m_PromotionId=[[NSString alloc] initWithString:promotionId];
        }
        m_FromTag=fromTag;
    }
    return self;
}

-(id)initWithBarcode:(NSString *)barcode fromTag:(OTSProductDetailFromTag)fromTag
{
    self=[super init];
    if (self!=nil)
    {
        _barcode = [barcode retain];
        m_PromotionId=[[NSString alloc] initWithString:@""];
        m_FromTag=fromTag;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //百分点
    if (m_PromotionId)
    {
        [BfdAgent visit:nil itemId:m_PromotionId options:nil];
    }
    
    
    // Do any additional setup after loading the view from its nib.
    _seriesButtonArr = [[NSMutableArray alloc] init];
    [self initProductDetail];
}


-(void)releaseResource
{
    OTS_SAFE_RELEASE(m_PromotionId);
    OTS_SAFE_RELEASE(m_ProductDetailVO);
    OTS_SAFE_RELEASE(m_InterestedProducts);
    OTS_SAFE_RELEASE(m_ScrollView);
    OTS_SAFE_RELEASE(m_TabView);
}

- (void)viewDidUnload
{
    [self releaseResource];
    [super viewDidUnload];
}

-(void)dealloc
{
    [self releaseResource];
    [_promotionPrice release];
    [superVC release];
    [_barcode release];
    
    _alertView.delegate = nil;
    [_alertView release];
    [super dealloc];
}




#pragma mark - UI Action

-(void)initProductDetail
{

    [self.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    //标题栏
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [imageView setImage:[UIImage imageNamed:@"title_bg.png"]];
    [self.view addSubview:imageView];
    [imageView release];
    
    UIButton *returnBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 61, 44)];
    [returnBtn setBackgroundImage:[UIImage imageNamed:@"title_left_btn.png"] forState:UIControlStateNormal];
    [returnBtn setBackgroundImage:[UIImage imageNamed:@"title_left_btn_sel.png"] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(returnBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    [returnBtn release];
    
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 44)];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setText:@"商品简介"];
    [title setTextColor:[UIColor whiteColor]];
    [title setFont:[UIFont boldSystemFontOfSize:20.0]];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setShadowColor:[UIColor darkGrayColor]];
    [title setShadowOffset:CGSizeMake(1, -1)];
    [self.view addSubview:title];
    [title release];
    //不是积分则请求数据
    if (!pointIn)
    {
        m_ThreadStatus=THREAD_STATUS_GET_PRODUCT_DETAIL;
        [self setUpThread:YES];
    }
    else
    {
        [self updateProductDetail];
    }
}

//返回按钮
-(void)returnBtnClicked:(id)sender
{
    [self.view.superview.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:@"Reveal"];
    [self removeSelf];
//    [self popSelfAnimated:YES];
    if ([superVC isKindOfClass:[PhoneCartViewController class]]) {
        [superVC viewWillAppear:YES];
    }
    if (m_FromTag==PD_FROM_SCAN) {
        [SharedDelegate enterHomePageRoot];
    }
}

//添加收藏
-(void)favoriteBtnClicked:(id)sender
{
    
    if ([GlobalValue getGlobalValueInstance].ywToken==nil)
    {
        [SharedDelegate enterUserManageWithTag:0];
	}
    else
    {
        if (!m_AddingFavorite)
        {
            
            [self showLoading:YES];
            
            m_AddingFavorite=YES;
            
            __block NSInteger result;
            
            [self performInThreadBlock:^{
                NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                
                YWFavoriteService *favSer = [[YWFavoriteService alloc] init];
                
                NSDictionary *dic = @{@"pid":m_ProductDetailVO.productId,
                                      @"userid":[GlobalValue getGlobalValueInstance].userInfo.ecUserId,
                                      @"username":[GlobalValue getGlobalValueInstance].userInfo.uid, //操。。。uid 其实就是名字
                                      @"sellerid":m_ProductDetailVO.sellerId,
                                      @"price":m_ProductDetailVO.price,
                                      @"token":[GlobalValue getGlobalValueInstance].ywToken,
                                      @"productimgurl":m_ProductDetailVO.mainImg3
                                    };
                result = [favSer addFavorite:dic];
                
                [pool drain];
            }completionInMainBlock:^{
                
                [self hideLoading];
                
                [TheStoreAppAppDelegate showFavoriteTipWithState:result inView:self.view productId:m_ProductDetailVO.productId];
                m_AddingFavorite=NO;
                
                //屎一样的代码，有点乱，别怪哥， 就这样。。。我不想整理了，凑活着看把
                if (result == 1 || result == 9)
                {
                    ((UIButton *)sender).selected = YES;
                }
                
                
            }];
        }
    }
}

//分享
-(void)shareBtnClicked:(id)sender
{
    OTSActionSheet *sheet=[[OTSActionSheet alloc] initWithTitle:nil 
                                                      delegate:self 
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"分享到新浪微博",/*@"分享到街旁",*/@"短信转发",nil];
    [sheet setTag:ACTION_SHEET_SHARE];
	[sheet showInView:self.view];
	[sheet showInView:[UIApplication sharedApplication].keyWindow];
	[sheet release];
}
//原价购买进入
-(void)cashBuyClick
{
    OTSProductDetail *productDetail=[[[OTSProductDetail alloc] initWithProductVO:m_ProductDetailVO fromTag:m_FromTag] autorelease];
    productDetail.pointIn=YES;
    [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
    [self pushVC:productDetail animated:YES];
}

#pragma mark 系列品的操作

//显示系列品选项
- (void)showSeriesView:(id)sender
{
    NSInteger seriesOff = 60;
    
    UIView* cateView=[[UIView alloc]initWithFrame:self.view.frame];
    cateView.backgroundColor=[UIColor clearColor];
    cateView.tag = kViewTagSeriesBack;
    [self.view addSubview:cateView];
    [cateView release];
    
    CGRect rect = cateView.frame;
    UIView *cateBg=[[UIView alloc]initWithFrame:rect];
    cateBg.backgroundColor=[UIColor grayColor];
    cateBg.alpha=0.4;
    [cateView addSubview:cateBg];
    [cateBg release];
    
    UIView *seriesView = [[UIView alloc] initWithFrame:CGRectMake(self.view.width, 0, self.view.width-seriesOff, self.view.height)];
    seriesView.tag = kViewTagSeries;
    [seriesView setBackgroundColor:[UIColor whiteColor]];
    [cateView addSubview:seriesView];
    [seriesView release];
    
    UIView *cateTop=[[UIView alloc]initWithFrame:CGRectMake(0, 16, self.view.width-seriesOff, 45)];
    cateTop.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"cate_topbg.png"]];
    [seriesView addSubview:cateTop];
    [cateTop release];
    
    UIButton *closeBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeBut setImage:[UIImage imageNamed:@"cate_topcancel.png"] forState:UIControlStateNormal];
    [closeBut setImage:[UIImage imageNamed:@"cate_topcancel.png"] forState:UIControlStateHighlighted];
    [closeBut addTarget:self action:@selector(closeSeriesView) forControlEvents:UIControlEventTouchUpInside];
    [closeBut setFrame:CGRectMake(10, 7, 30, 30)];//
    [cateTop addSubview:closeBut];
    
    //内容的ScrollView
    UIScrollView *seriesSv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cateTop.frame), seriesView.width, seriesView.height - CGRectGetMaxY(cateTop.frame))];
    seriesSv.scrollEnabled = YES;
    seriesSv.bounces = YES;
    seriesSv.showsVerticalScrollIndicator = NO;
    [seriesView addSubview:seriesSv];
    [seriesSv release];
    
    CGFloat yValue = 0.0;
    
    //商品图片
    OTSImageView *imageView=[[OTSImageView alloc] initWithFrame:CGRectMake(80, 10, 100, 100)];
    [imageView loadImgUrl:m_ProductDetailVO.mainImg3];
    [seriesSv addSubview:imageView];
    [imageView release];
    
    UIImageView *lineIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_redline.png"]];
    lineIv.frame = CGRectMake(0, 120,seriesView.width, 2);
    [seriesSv addSubview:lineIv];
    [lineIv release];
    yValue = 122;
    
    //选项
    for (NSInteger j = 0; j < m_ProductDetailVO.seriesNames.count; ++j)
    {
        NSString *name = m_ProductDetailVO.seriesNames[j];
        
        UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, yValue+10, [self caluLalelWidth:name height:20.0]+5, 20)];
        nameLbl.font = [UIFont systemFontOfSize:15];
        nameLbl.text = [NSString stringWithFormat:@"%@:",name];
        [seriesSv addSubview:nameLbl];
        [nameLbl release];
        
        UILabel *selectNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLbl.frame), yValue+10, 170, 20)];
        selectNameLbl.textColor = [UIColor redColor];
        selectNameLbl.font = [UIFont systemFontOfSize:15];
        selectNameLbl.text = [NSString stringWithFormat:@"请选择%@",name];
        selectNameLbl.tag =  kSeriesButtonBaseTag+j;
        [seriesSv addSubview:selectNameLbl];
        [selectNameLbl release];
        yValue += 30;
        
        //buttons
        NSArray *attriArr = [m_ProductDetailVO.seriesValues[name] componentsSeparatedByString:@","];
        NSMutableArray *attriButtonArr = [[NSMutableArray alloc] init]; //把这个属性的的所有button存这里
        [attriButtonArr addObject:[NSNull class]]; //第一个用来存之后选择的button，现在占位
        
        CGFloat xOff = 10.0; //button 一开始缩进10
        CGFloat xValue = xOff;
        for (int i = 0; i < attriArr.count; ++i)
        {
            SeriesButton *button = [SeriesButton buttonWithType:UIButtonTypeCustom];
            button.index = j;
            button.seriesName = name; //做标记
            
            [button setTitle:attriArr[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button addTarget:self action:@selector(selectAttri:) forControlEvents:UIControlEventTouchUpInside];

            //计算坐标
            CGFloat gapX = 10; //间隔
            CGFloat gapY = 5;
            CGFloat h = 30.0;
            CGFloat w = [self caluLalelWidth:attriArr[i] height:h]+20;
            if ( xValue + w + gapX > seriesView.width )
            {
                //换行
                xValue = xOff;
                yValue += h+gapY;
            }
            CGFloat x = xValue + gapX;
            xValue = x+w;
            CGFloat y = yValue + gapY;
            if (i == attriArr.count-1)
            {
                yValue += h;
            }
            
            button.frame = CGRectMake(x,y,w,h);
            [seriesSv addSubview:button];
            
            [attriButtonArr addObject:button];
        }
        [_seriesButtonArr addObject:attriButtonArr];
        [attriButtonArr release];
    }
    
    //减少
    UIButton *minusBtn =[[UIButton alloc] initWithFrame:CGRectMake(10, yValue + 30, 30, 30)];
    [minusBtn setBackgroundImage:[UIImage imageNamed:@"minus_enable.png"] forState:UIControlStateNormal];
    [minusBtn addTarget:self action:@selector(minusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [seriesSv addSubview:minusBtn];
    minusBtn.tag = kViewTagMinus;
    [minusBtn setEnabled:NO];
    [minusBtn release];
    
    UIButton *countBtn =[[UIButton alloc] initWithFrame:CGRectMake(50, yValue + 30, 44, 30)];
    [countBtn.layer setBorderWidth:1.0];
    [countBtn.layer setBorderColor:[[UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1.0] CGColor]];
    [countBtn setTitle:@"1" forState:UIControlStateNormal];
    [countBtn setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [countBtn addTarget:self action:@selector(countBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    countBtn.tag = kViewTagCountLbl;
    [seriesSv addSubview:countBtn];
    [countBtn release];
    
    //增加
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(104, yValue + 30, 30, 30)];
    addBtn.tag = kViewTagAdd;
    [addBtn setBackgroundImage:[UIImage imageNamed:@"add_enable.png"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [seriesSv addSubview:addBtn];
    [addBtn release];
    
    UIButton *addCartBtn=[[UIButton alloc] initWithFrame:CGRectMake(150, yValue + 26, 100, 39)];
    [addCartBtn setBackgroundImage:[UIImage imageNamed:@"orange_btn.png"] forState:UIControlStateNormal];
    [[addCartBtn titleLabel] setFont:[UIFont boldSystemFontOfSize:17.0]];
    if (!m_ProductDetailVO.isOTC)
    {
        [addCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    }
    [addCartBtn addTarget:self action:@selector(addCartBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [seriesSv addSubview:addCartBtn];
    [addCartBtn release];

    yValue += 100;
    
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeSeriesView)];
    swip.direction = UISwipeGestureRecognizerDirectionRight;
    [cateView addGestureRecognizer:swip];
    [swip release];
    
    
    seriesSv.contentSize = CGSizeMake(seriesSv.width, yValue);
    
    [UIView animateWithDuration:0.3 animations:^{
    
        seriesView.frame = CGRectMake(seriesOff, 0, self.view.width-seriesOff, self.view.height);
    
    }];
    
    
}

//关闭系列品页面
- (void)closeSeriesView
{
    UIView *backView = [self.view viewWithTag:kViewTagSeriesBack];
    UIView *seriesView = [self.view viewWithTag:kViewTagSeries];
    [UIView animateWithDuration:0.3 animations:^{
        
        seriesView.frame = CGRectMake(self.view.width, 0, seriesView.frame.size.width, seriesView.frame.size.height);
        
    } completion:^(BOOL finished){
    
        [backView removeFromSuperview];
        [_seriesButtonArr removeAllObjects];
    }];

}

//选择属性时的处理  //如果你要修改，就直接删掉把，自己写 比看我这个更容易。。。。。。。。我这个不仅仅用于2个属性。适合任何多的属性////方法比较烂，估计你看的会想屎
- (void)selectAttri:(id)sender
{
    SeriesButton *seriesBtn = sender;
    seriesBtn.selected = YES;
    
    UILabel *selectedLbl = (UILabel *)[self.view viewWithTag:kSeriesButtonBaseTag+seriesBtn.index];
    selectedLbl.text = seriesBtn.titleLabel.text;
    
    //之前的不选中
    SeriesButton *oldSelectedBtn = ((NSMutableArray *)_seriesButtonArr[seriesBtn.index])[0];
    if (![oldSelectedBtn isEqual:[NSNull class]])
    {
        oldSelectedBtn.selected = NO;
    }
    //把选中的放到数组第一个
    [_seriesButtonArr[seriesBtn.index] replaceObjectAtIndex:0 withObject:seriesBtn];
    
    //下面开始计算其他属性的库存
    //更改其他button的状态
    for (int i = 0 ; i < _seriesButtonArr.count; ++i)
    {
        NSMutableArray *attriArr =_seriesButtonArr[i];
        
        if (i != seriesBtn.index)
        {
            //获取其他已经选中的属性  最后要通过这些属性去查找其库存
            NSMutableArray *flagArr = [[[NSMutableArray alloc] init] autorelease];
            for (int k = 0; k < _seriesButtonArr.count; ++k)
            {
                NSMutableArray *attriArr =_seriesButtonArr[k];
                if (i != k)
                {
                    if (![attriArr[0] isEqual:[NSNull class]])
                    {
                        SeriesButton *seletcedBtn = attriArr[0];
                        [flagArr addObject:seletcedBtn.titleLabel.text];
                    }
                }
            }
            
            [flagArr addObject:[NSNull class]];
            
            //其他属性的button确定有没有库存
            for (NSInteger j = 1; j < attriArr.count; ++j)
            {
                SeriesButton *sBtn = attriArr[j];
                [flagArr replaceObjectAtIndex:flagArr.count-1 withObject:sBtn.titleLabel.text];
                sBtn.enabled = [self getSeriesProductStockByFlagArr:flagArr] == 0? NO : YES;
            }
        }
    }
    
    seriesBtn.selected = YES;
}

#pragma mark 促销的操作
- (void)showPromotionDetail:(id)sender
{
    PromotionButton *promotionBtn = ((PromotionButton *)sender);
    //分类列表
    CategoryProductsViewController*cateProduct=[[[CategoryProductsViewController alloc] init] autorelease] ;
//    cateProduct.cateId = [NSString stringWithFormat:@"%d", cid];
    
    //构造一个根分类，从这里进去，分类里面显示根分类
    CategoryInfo *categoryInfo = [[CategoryInfo alloc] init];
    categoryInfo.cid = @"-1";
    categoryInfo.name = @"全部分类";
    cateProduct.currentCategory = categoryInfo;
    cateProduct.titleText=@"全部分类";
    cateProduct.isLastLevel=YES;
    
    cateProduct.condition = promotionBtn.condition;
    cateProduct.promotion = promotionBtn.promotion;
    [self pushVC:cateProduct animated:YES fullScreen:YES];
}


- (NSInteger)getSeriesProductStockByFlagArr:(NSArray *)flagArr
{
    SeriesProductInfo *product = [self getSeriesProductByFlagArr:flagArr];
    if (product)
    {
        return product.stock;
    }
    return nil;
}

- (SeriesProductInfo *)getSeriesProductByFlagArr:(NSArray *)flagArr
{
    for (SeriesProductInfo *p in m_ProductDetailVO.seriesProducts)
    {
        NSArray *attirArr = [p.seriesFlag componentsSeparatedByString:@","];
        NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", flagArr];
        NSArray *resultArr = [attirArr filteredArrayUsingPredicate:thePredicate];
        if (resultArr.count == 0)
        {
            return p;
        }
    }
    
    return nil;
}


//计算label宽度
- (CGFloat)caluLalelWidth:(NSString *)string height:(CGFloat)h
{
    CGSize sizeName = [string sizeWithFont:[UIFont systemFontOfSize:15]
                       
                          constrainedToSize:CGSizeMake(MAXFLOAT, h)];
    
    return sizeName.width;
}
//serieseView 点击操作

- (void)minusBtnClicked:(id)sender
{
    UIButton *countBtn =  (UIButton *)[self.view viewWithTag:kViewTagCountLbl];
    NSInteger count = [countBtn.titleLabel.text intValue];
    count--;
    [countBtn setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
    if (count == 1)
    {
        [(UIButton *)sender setEnabled:NO];
    }
}

- (void)addBtnClicked:(id)sender
{
    UIButton *countBtn =  (UIButton *)[self.view viewWithTag:kViewTagCountLbl];
    NSInteger count = [countBtn.titleLabel.text intValue];
    count++;
    [countBtn setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
    
    UIButton *minBtn =  (UIButton *)[self.view viewWithTag:kViewTagMinus];
    minBtn.enabled = YES;
    
}
- (void)countBtnClicked:(id)sender
{
    
}

- (void)addCartBtnClicked:(id)sender
{
    
    NSMutableArray *flagArr = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < _seriesButtonArr.count; ++i)
    {
        SeriesButton *selectedBtn = _seriesButtonArr[i][0];
        if ([selectedBtn isEqual:[NSNull class]])
        {
            NSString * name = m_ProductDetailVO.seriesNames[i];
            [self.loadingView showTipInView:self.view title:[NSString stringWithFormat:@"请选择%@",name]];
            return;
        }
        
        [flagArr addObject:selectedBtn.titleLabel.text];
    }
    
    
    //获得这个系列商品
    SeriesProductInfo *product = [self getSeriesProductByFlagArr:flagArr];
    
    __block BOOL result = NO;
    __block NSInteger quantity = 0;
    [self performInThreadBlock:^{
        
        
        UIButton *countBtn = (UIButton *)[self.view viewWithTag:kViewTagCountLbl];
        quantity = [[countBtn titleForState:UIControlStateNormal] intValue];
        YWLocalCatService *localCatService = [[YWLocalCatService alloc] init];
        LocalCarInfo *localCart = [[LocalCarInfo alloc] initWithProductId:[NSString stringWithFormat:@"%d",product.itemId]
                                                            shoppingCount:[NSString stringWithFormat:@"%d",quantity]
                                                                 imageUrl:m_ProductDetailVO.mainImg3
                                                                    price:m_ProductDetailVO.price
                                                               provinceId:[[GlobalValue getGlobalValueInstance].provinceId stringValue]
                                                                      uid:[GlobalValue getGlobalValueInstance].userInfo.ecUserId
                                                                productNO:m_ProductDetailVO.productNO
                                                                   itemId:m_ProductDetailVO.itemId];
        
        result = [localCatService saveLocalCartToDB:localCart];
        [localCatService release];
        [localCart release];
        
    }completionInMainBlock:^{
        if (result)
        {
            [self.loadingView showTipInView:self.view title:@"加入购物车成功"];
            [SharedDelegate setCartNum:quantity];
        }
        else
        {
             [self.loadingView showTipInView:self.view title:@"加入购物车失败"];
        }
        
    }];

}

#pragma mark - ProductView Delegate
- (void)showSeriesView  //productView 中点了加入购物车的代理
{
    [self showSeriesView:nil];
}

#pragma mark  电话咨询
- (void)callPhone
{
    UIActionSheet *actionSheet=[[OTSActionSheet alloc] initWithTitle:@"客服工作时间 : 每日 9:00-21:00" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"400-007-0958", nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    actionSheet.tag = 100001;
    [actionSheet release];
}


-(void)updateProductDetail
{
    //收藏
    favoriteBtn=[[UIButton alloc] initWithFrame:CGRectMake(240, 0, 40, 44)];
    [favoriteBtn setBackgroundImage:[UIImage imageNamed:@"title_favorite_no.png"] forState:UIControlStateNormal];
    [favoriteBtn setBackgroundImage:[UIImage imageNamed:@"title_favorite_no_sel.png"] forState:UIControlStateHighlighted];
    [favoriteBtn setBackgroundImage:[UIImage imageNamed:@"title_favorite_noline.png"] forState:UIControlStateSelected];
    
    [favoriteBtn addTarget:self action:@selector(favoriteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:favoriteBtn];
    [favoriteBtn release];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%ld", m_ProductId],[GlobalValue getGlobalValueInstance].userInfo.ecUserId]])
    {
        DebugLog(@"已经收藏");
        favoriteBtn.selected = YES;
    }
    else
    {
        DebugLog(@"未收藏");
        favoriteBtn.selected = NO;
    }
    
    
    
    //分享
    UIButton *shareBtn=[[UIButton alloc] initWithFrame:CGRectMake(280, 0, 40, 44)];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"title_shared_noline.png"] forState:UIControlStateNormal];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"title_shared_noline_sel.png"] forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    [shareBtn release];
    
    m_ScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44.0)];
    [m_ScrollView setDelegate:self];
    [m_ScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:m_ScrollView];
    [m_ScrollView setContentSize:CGSizeMake(320, 796)];
    
    NSInteger yValue = 0;
    
    //顶部
    OTSProductView *topView=[[OTSProductView alloc] initWithFrame:CGRectMake(0, 0, 320, 270) productVO:m_ProductDetailVO fromTag:m_FromTag];
    topView.delegate=self;
    topView.pointProduct=2;

    [topView refreshView];
    [m_ScrollView addSubview:topView];
    [topView release];
    yValue = 270;

    
    //系列品
    if ([m_ProductDetailVO isSeriesProductInProductDetail])  //在详情页里面，这样才是系列品，在列表页面里是＝＝3表示系列品。。。就这么写吧，不要抱怨，能写注释就不错了
    {
        UIButton *seriesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [seriesBtn setBackgroundColor:[UIColor colorWithString:@"FFF68F"]];
        seriesBtn.frame = CGRectMake(10, yValue+5, 300, 40);
        CALayer *layer = [seriesBtn layer];
        [layer setBorderWidth:1.0];
        [layer setBorderColor:[UIColor whiteColor /*colorWithString:@"D9D9D9"*/].CGColor];

        NSString *title = [NSString stringWithFormat:@"请选择: %@",[m_ProductDetailVO.seriesNames componentsJoinedByString:@"/"]];
        [seriesBtn setTitle:title forState:UIControlStateNormal];
        [seriesBtn setTitleColor:[UIColor colorWithString:@"C4C4C4"] forState:UIControlStateNormal];
        seriesBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [seriesBtn addTarget:self action:@selector(showSeriesView:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *accesseryIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow_right.png"]];
        accesseryIv.frame = CGRectMake(280, 13, 9, 13);
        [seriesBtn addSubview:accesseryIv];
        [accesseryIv release];
        [m_ScrollView addSubview:seriesBtn];
        
        yValue += 45;
    }
    
    //促销
    yValue += 5;
    for (int i = 0; i < m_ProductDetailVO.promotions.count; ++i)
    {
        PromotionInfo *promotion = m_ProductDetailVO.promotions[i];
        
        for (ConditionInfo *condition in promotion.conditions)
        {
         
            PromotionButton *promotionBtn = [[PromotionButton alloc] initWithFrame:CGRectMake(10, yValue, 300, 40) promotion:promotion condition:condition];
            [promotionBtn addTarget:self action:@selector(showPromotionDetail:) forControlEvents:UIControlEventTouchUpInside];
            [m_ScrollView addSubview:promotionBtn];
            [promotionBtn release];
        
            promotionBtn.tag = i;
            
            yValue += 39;
        }
    }

    
    
    //tab切换
    NSArray *titles;
//    if ([m_ProductDetailVO.hasGift intValue]==1 || m_ProductDetailVO.isJoinCash || m_ProductDetailVO.offerName.length>0)
//    {
        titles=[NSArray arrayWithObjects:@"商品介绍", @"同类推荐", @"最佳搭配", nil];
//    }
//    else
//    {
//        titles=[NSArray arrayWithObjects:@"商品介绍",/* @"同类推荐",*/ nil];
//    }
    m_TabView=[[OTSTabView alloc] initWithFrame:CGRectMake(0, yValue+10, 320, 37) titles:titles imgtabs:nil delegate:self];
    [m_ScrollView addSubview:m_TabView];
    
    //商品图片
    UIView *imagesView=[[OTSProductImagesView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(m_TabView.frame)+37 , 320, 190) productVO:m_ProductDetailVO];
    [m_ScrollView addSubview:imagesView];
    [imagesView release];
    _productPicturesView = imagesView;
    
    //商品详情、评价详情
    UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(m_TabView.frame)+37+191, 320, 103) style:UITableViewStyleGrouped];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setBackgroundView:nil];
    [tableView setScrollEnabled:NO];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    //为了适配iOS7
    if (ISIOS7)
    {
        tableView.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 1.f)] autorelease];
    }
    [m_ScrollView addSubview:tableView];
    [tableView release];
    
    
    //同类推荐
    _sameProductsView = [[RecommendView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(m_TabView.frame)+27 , 320, 190) dontShowTitle:YES ];  //CGRectMake(0, CGRectGetMaxY(tableView.frame)+10, 320, 0)];
    [m_ScrollView addSubview:_sameProductsView];
    _sameProductsView.delegate = self;
    _sameProductsView.hidden = YES;
    [_sameProductsView release];

    [self getRecommend:kRCLike];
//    [BfdAgent recommend:self recommendType:kRCLike options:nil];
    
    
    //推荐商品
    _recommendProductsView = [[RecommendView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(m_TabView.frame)+27 , 320, 190) dontShowTitle:YES];   //CGRectMake(0, CGRectGetMaxY(_sameProductsView.frame)+10, 320, 0)];
    [m_ScrollView addSubview:_recommendProductsView];
    _recommendProductsView.delegate = self;
    _recommendProductsView.hidden = YES;
    [_recommendProductsView release];

    [self performSelector:@selector(getRecommend:) withObject:kRCPartner afterDelay:1.0]; //加个延迟试试  不加延迟，那么跟上面的百分点的请求 就几乎是同时发送的，获取的结果是一样的
    
    
    
    m_ScrollView.contentSize = CGSizeMake(320, CGRectGetMaxY(tableView.frame));
    
    
    [m_ScrollView bringSubviewToFront:m_TabView];
}

- (void)getRecommend:(NSString *)type
{
    
    NSDictionary *opt = @{@"iid": [NSString stringWithFormat:@"%ld",m_ProductId]};
    
    [BfdAgent recommend:self recommendType:type options:opt];
}

//商品简介为空
-(void)showNotFindProduct
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:@"无法打开商品简介" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    
    _alertView = [alertView retain];
    [alertView release];
}

//进入商品描述
-(void)enterProductDescribe
{
    OTSProductDescriptionView *descriptionView=[[OTSProductDescriptionView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) productVO:m_ProductDetailVO];
    [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
    [self.view addSubview:descriptionView];
    [descriptionView release];
}



//进入评价详情

-(void)enterCommentDetail
{
    OTSProductCommentView *commentView=[[OTSProductCommentView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) productVO:m_ProductDetailVO];
    [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
    [self.view addSubview:commentView];
    [commentView release];
}
 

#pragma mark - 线程
-(void)setUpThread:(BOOL)showLoading
{
    if (!m_ThreadRunning)
    {
        m_ThreadRunning=YES;
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
        @synchronized(self) {
            switch (m_ThreadStatus)
            {
                case THREAD_STATUS_GET_PRODUCT_DETAIL:
                {
                    [self newThreadGetProductDetail];
                    [self stopThread];
                    break;
                }
                case THREAD_STATUS_GET_DESCRIPTION:
                {//获取商品描述进入商品描述
                    [self newThreadGetDescription];
                    [self performSelectorOnMainThread:@selector(enterProductDescribe) withObject:nil waitUntilDone:NO];
                    [self stopThread];
                    break;
                }
                case THREAD_STATUS_GET_COMMENT:
                {//获取商品评论进入商品评论
                    [self newThreadGetComment];
                    [self performSelectorOnMainThread:@selector(enterCommentDetail) withObject:nil waitUntilDone:NO];
                    [self stopThread];
                    break;
                }
                case THREAD_STATUS_GET_STOCK:
                {
                    
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
    [self hideLoading];
}

-(void)newThreadGetProductDetail
{

    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    YWProductService *pServ=[[YWProductService alloc] init];
    ProductInfo *tempProductVO = nil;
    @try {
        
        
        NSDictionary *param;
        if (_barcode)
        {
            param = @{@"barcode":_barcode, @"flag":@"5",@"province":[GlobalValue getGlobalValueInstance].provinceId};
        }
        else
        {
            param = @{@"itemcode":[NSString stringWithFormat:@"%ld", m_ProductId], @"flag":@"3",@"province":[GlobalValue getGlobalValueInstance].provinceId};
        }
        
        tempProductVO = [pServ getProductDetail:param];
        
        
    }
    @catch (NSException *exception) {
    }
    @finally {
        if (m_ProductDetailVO!=nil)
        {
            [m_ProductDetailVO release];
        }
        if (tempProductVO!=nil && ![tempProductVO isKindOfClass:[NSNull class]] /*&& tempProductVO.name!=nil && ![tempProductVO.name isEqualToString:@""]*/)
        {
            m_ProductDetailVO=[tempProductVO retain];
                        
            if (m_ProductDetailVO)
            {
                //商品详细获取之后再获取库存
                [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadGetStock) toTarget:self withObject:nil];
            }

            //加入最新浏览
            [self otsDetatchMemorySafeNewThreadSelector:@selector(newThreadAddBrowse) toTarget:self withObject:nil];
        }
        else
        {
            m_ProductDetailVO=nil;
            [self performSelectorOnMainThread:@selector(showNotFindProduct) withObject:nil waitUntilDone:NO];
        }
    }
    [pServ release];
    [pool drain];
    
}

//获取商品库存
- (void)newThreadGetStock
{
    //获取商品库存
    NSMutableArray *stockArr;
    NSDictionary *dic = @{@"productnos":m_ProductDetailVO.productNO,@"flag":@"2",@"province":[GlobalValue getGlobalValueInstance].provinceId};
    YWProductService *pSer = [[[YWProductService alloc] init] autorelease];
    stockArr = [pSer getProductInStock:dic];
    if (stockArr.count > 0)
    {
        NSDictionary *stockDic = stockArr[0];
        m_ProductDetailVO.currentStore = stockDic[@"stock"];
    }
    else
    {
         m_ProductDetailVO.currentStore = @"0";
    }
    
    
    //库存获取之后 再更新UI
    [self performSelectorOnMainThread:@selector(updateProductDetail) withObject:nil waitUntilDone:NO];
}


-(void)newThreadGetDescription
{
    /*
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    ProductService *describeServ=[[[ProductService alloc] init] autorelease];
    ProductVO *tempDescriptionVO=nil;
    @try {
        tempDescriptionVO=[describeServ getProductDetailDescription:[GlobalValue getGlobalValueInstance].trader productId:m_ProductDetailVO.productId provinceId:[GlobalValue getGlobalValueInstance].provinceId];
    }
    @catch (NSException *exception) {
    }
    @finally {
        if (tempDescriptionVO!=nil && ![tempDescriptionVO isKindOfClass:[NSNull class]]) {
            [m_ProductDetailVO setDescription:tempDescriptionVO.description];
        } else {
            [m_ProductDetailVO setDescription:@"对不起，此产品没有描述信息！"];
        }
    }
    [pool drain];
     */
    
}

-(void)newThreadGetComment
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    YWProductService *pServ=[[[YWProductService alloc] init] autorelease];
//    ProductVO *detailCommentVO=nil;
    NSDictionary *commentDic ;
    @try
    {
        NSDictionary *dic = @{@"pageindex" : @"1",@"pagesize":@"20",@"id":m_ProductDetailVO.productId,@"itemcode":m_ProductDetailVO.itemId/*productId*/ };
        commentDic = [pServ getProductCommentList:dic];
       
//        detailCommentVO=[pServ getProductDetailComment:[GlobalValue getGlobalValueInstance].trader productId:m_ProductDetailVO.productId provinceId:[GlobalValue getGlobalValueInstance].provinceId];
    }
    @catch (NSException *exception) {
    }
    @finally {
//        if (detailCommentVO!=nil && ![detailCommentVO isKindOfClass:[NSNull class]]) {
//            [m_ProductDetailVO setRating:detailCommentVO.rating];
//        } else {
//            [m_ProductDetailVO setRating:nil];
//        }
        
         m_ProductDetailVO.commentList = commentDic[@"commentlist"];
        NSDictionary *commentClassDic = commentDic[@"commentclass"];
        m_ProductDetailVO.goodComment = [commentClassDic[@"good"] floatValue];
        m_ProductDetailVO.midComment = [commentClassDic[@"middle"] floatValue];
        m_ProductDetailVO.badComment = [commentClassDic[@"bad"] floatValue];
        m_ProductDetailVO.totalScore = [commentClassDic[@"totalscore"] floatValue];
    }
    [pool drain];
}

-(void)newThreadAddBrowse
{
    
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    YWBrowseService *bServ=[[[YWBrowseService alloc] init] autorelease];
//    int rowcount = [bServ queryBrowseHistoryByIdCount:[NSNumber numberWithLong:m_ProductId]];
    @try {
//        if (rowcount) {
//            //productid存在则更新
//            [bServ updateBrowseHistory:m_ProductDetailVO provice:PROVINCE_ID];
//        }
//        else {
//            [bServ saveBrowseHistory:m_ProductDetailVO province:PROVINCE_ID];
//        }
        
        [bServ saveBrowseHistory:m_ProductDetailVO];
        
    }
    @catch (NSException *exception) {
     
    }
    @finally {
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefleshImmediately" object:nil];
    [pool drain];
     
}

#pragma mark - UITableView相关
-(void)tableView:(UITableView * )tableView didSelectRowAtIndexPath:(NSIndexPath * )indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch ([indexPath row]) {
        case 0: {//商品详情
//            if ([m_ProductDetailVO description]==nil || [[m_ProductDetailVO description] length]==0) {
//                m_ThreadStatus=THREAD_STATUS_GET_DESCRIPTION;
//                [self setUpThread:YES];
//            } else {
                [self enterProductDescribe];
//            }
            break;
        }
        case 1:
        {
            //评价详情
            if (m_ProductDetailVO.commentList.count == 0)
            {
                m_ThreadStatus=THREAD_STATUS_GET_COMMENT;
                [self setUpThread:YES];
            }
            else
            {
                [self enterCommentDetail];
            }
            break;
        }
        default:
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
    UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    [cell setBackgroundColor:[UIColor whiteColor]];
    switch (indexPath.row) {
        case 0:
            [[cell textLabel] setText:@"商品详情"];
            break;
        case 1:
            [[cell textLabel] setText:@"评价详情"];
            break;
        default:
            break;
    }
    [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

#pragma mark - UIScrollView相关delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (scrollView.contentOffset.y>270.0) {
//        [m_TabView setFrame:CGRectMake(0, scrollView.contentOffset.y, 320, 37)];
//    } else {
//        [m_TabView setFrame:CGRectMake(0, 270.0, 320, 37)];
//    }
}

#pragma mark - UIActionSheet相关delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch ([actionSheet tag])
    {
        case ACTION_SHEET_SHARE:
        {
            if (buttonIndex==0)
            {
//                [[OTSShare sharedInstance] shareToBlogWithProduct:m_ProductDetailVO delegate:self];
                
                ////微博登真机再测试 需要安装微博客户端之后才可以
                WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]];
  
                request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                @"Other_Info_1": [NSNumber numberWithInt:123],
                @"Other_Info_2": @[@"obj1", @"obj2"],
                @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
                
                [WeiboSDK sendRequest:request];
            }/*
            else if (buttonIndex==1)
            {
                [[OTSShare sharedInstance] shareToJiePangWithProduct:m_ProductDetailVO delegate:self];
            }*/
            else if (buttonIndex==1)
            {
                [[OTSShare sharedInstance] shareToMessageWithProduct:m_ProductDetailVO delegate:self];
            }
            break;
        }
        default:
            
            switch (buttonIndex)
            {
                case 0:
                    {
                    UIDeviceHardware *hardware=[[UIDeviceHardware alloc] init];
                    //判断设备是否iphone
                    NSRange range = [[hardware platformString] rangeOfString:@"iPhone"];
                    if (range.length <= 0)
                    {
                        [[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:YES];
                        [AlertView showAlertView:nil alertMsg:@"您的设备不支持此项功能,感谢您对1号药店的支持!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
                    }
                    else
                    {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000070958"]];
                    }
                    [hardware release];
                    break;
            }
            default:
                break;
            }

            break;
    }
}

- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    message.text = [NSString stringWithFormat:@"我在1号药店发现了%@,只要%@元，快来抢购吧！http://111.com.cn 手机购药更优惠!", m_ProductDetailVO.name,m_ProductDetailVO.price];
    return message;
}





#pragma mark - UIAlerViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self returnBtnClicked:nil];
}

#pragma mark - OTSTabView相关delegate
-(void)tabClickedAtIndex:(NSNumber *)index
{
    switch ([index intValue])
    {
        case 0: {
            CGFloat yValue= CGRectGetMinY(m_TabView.frame);
            if (m_ScrollView.contentSize.height-m_ScrollView.frame.size.height<yValue) {
                yValue=m_ScrollView.contentSize.height-m_ScrollView.frame.size.height;
            }
            [m_ScrollView setContentOffset:CGPointMake(0, yValue) animated:YES];
            
            
            
            
            _recommendProductsView.hidden = YES;
            _sameProductsView.hidden = YES;
            _productPicturesView.hidden = NO;
            
            break;
        }
        case 1: {
            CGFloat yValue=563.0;
            if (m_ScrollView.contentSize.height-m_ScrollView.frame.size.height<yValue) {
                yValue=m_ScrollView.contentSize.height-m_ScrollView.frame.size.height;
            }
            [m_ScrollView setContentOffset:CGPointMake(0, yValue) animated:YES];
            
            
            _recommendProductsView.hidden = YES;
            _sameProductsView.hidden = NO;
            _productPicturesView.hidden = YES;
            
            break;
        }
        case 2: {
            CGFloat yValue=m_ScrollView.contentSize.height-m_ScrollView.frame.size.height;
            [m_ScrollView setContentOffset:CGPointMake(0, yValue) animated:YES];
            
            
            _recommendProductsView.hidden = NO;
            _sameProductsView.hidden = YES;
            _productPicturesView.hidden = YES;
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - OTSAnimationTableView相关delegate
-(void)promotionTableSizeChanged:(OTSAnimationTableView *)animationTableView
{
    CGFloat yValue=608+animationTableView.frame.size.height;
    [m_InterestedProducts setFrame:CGRectMake(0, yValue, 320, m_InterestedProducts.frame.size.height)];
    [m_ScrollView setContentSize:CGSizeMake(320, yValue+m_InterestedProducts.frame.size.height)];
}

-(void)enterCashList:(MobilePromotionVO *)mobilePromotionVO
{
    CategoryProductsViewController *cateProduct = [[[CategoryProductsViewController alloc] init] autorelease] ;
    [cateProduct setCateId:@"0"/*[NSNumber numberWithInt:0]*/];
    [cateProduct setTitleLableText:mobilePromotionVO.title];
    [cateProduct setTitleText:@"全部"];
    [cateProduct setCanJoin:[mobilePromotionVO canJoin]];
    [cateProduct setPromotionId:mobilePromotionVO.promotionId];
    [cateProduct setIsCashPromotionList:YES];
    [cateProduct setIsFailSatisfyFullDiscount:YES];
    [self pushVC:cateProduct animated:YES fullScreen:YES];
}

-(void)enterNNList:(MobilePromotionVO *)mobilePromotionVO
{
    [self removeSubControllerClass:[OTSNNPiecesVC class]];
    OTSNNPiecesVC* vc = [[[OTSNNPiecesVC alloc] init] autorelease];
    [vc setPromotionId:mobilePromotionVO.promotionId];
    [vc setPromotionLevelId:mobilePromotionVO.promotionLevelId];
    [vc setNnpiecesTitle:mobilePromotionVO.title];
    [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
    [self pushVC:vc animated:YES];
}

#pragma mark - OTSInterestedProducts相关delegate
-(void)interestedProductClicked:(ProductVO *)productVO
{
    if (!productVO.isYihaodian.intValue) {
        NSString *urlStr = @"http://m.1mall.com/mw/product/";
        NSNumber *productId = productVO.productId;
        NSNumber *areaId = [GlobalValue getGlobalValueInstance].provinceId;
        if ([GlobalValue getGlobalValueInstance].token == nil) {
            urlStr = [urlStr stringByAppendingFormat:@"%@/%@/?osType=%d",productId,areaId,30];
        } else {
            // 对 token 进行base64加密
            NSData *b64Data = [GTMBase64 encodeData:[[GlobalValue getGlobalValueInstance].token dataUsingEncoding:NSUTF8StringEncoding]];
            NSString *b64Str = [[[NSString alloc] initWithData:b64Data encoding:NSUTF8StringEncoding] autorelease];
            urlStr = [urlStr stringByAppendingFormat:@"%@/%@/?osType=%d&token=%@",productId,areaId,30,b64Str];
        }
        DebugLog(@"enterWap -- url is:\n%@",urlStr);
        [SharedDelegate enterWap:1 invokeUrl:urlStr isClearCookie:NO];

    }else{
        OTSProductDetail *productDetail=[[[OTSProductDetail alloc] initWithProductId:[productVO.productId longValue] promotionId:productVO.promotionId fromTag:PD_FROM_OTHER] autorelease];
        productDetail.superVC=self;
        [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
        [self pushVC:productDetail animated:YES];
    }
}

-(void)interestedProductIsNull:(OTSInterestedProducts *)interestedProducts;
{
    [m_ScrollView setContentSize:CGSizeMake(320, m_ScrollView.contentSize.height-225)];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//
/**
 收到一个来自微博客户端程序的请求
 收到微博的请求后,第三方应用应该按照请求类型进行处理,处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}
/**
 收到一个来自微博客户端程序的响应 收到微博的响应后,第三方应用可以通过响应类型、响应的数据和 [WBBaseResponse
 userInfo] 中的数据完成自己的功能 @param response 具体的响应对象 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    
}


#pragma mark - 百分点
- (void)mobidea_Recs:(NSError *)error feedback:(id)feedback
{
    
    if ([feedback isKindOfClass:[NSArray class]])
    {
        
        NSString *errorStr = [error description];
        NSString *rid = [errorStr substringWithRange:NSMakeRange(errorStr.length-40-1, 40)];
        DebugLog(@"%@",rid);
        
        NSMutableArray *productLists = [[NSMutableArray alloc] init];
        
        
        NSArray *result = (NSArray *)feedback;
        for (NSDictionary *dic in result)
        {
            ProductInfo *product = [[ProductInfo alloc] init];
            product.productId = [NSString stringWithFormat:@"%d",[dic[@"iid"] integerValue]];
            product.productImageUrl = dic[@"img"];
            product.price = [NSString stringWithFormat:@"%.2f", [dic[@"price"] floatValue]];
            product.marketPrice = [NSString stringWithFormat:@"%.2f", [dic[@"mktp"] floatValue]];
            product.name = dic[@"name"];
            
            [productLists addObject:product];
            [product release];
        }
        
        
        
        
        if ([rid isEqualToString:kRCLike])
        {
            [_sameProductsView updateRecommendProducts:productLists];
        }
        else
        {
            [_recommendProductsView updateRecommendProducts:productLists];
        }
        
        
        [productLists release];

    }
}


- (void)selectedRecommendProduct:(ProductInfo *)product
{
    //反馈
    [BfdAgent feedback:nil recommendId:kRCScan itemId:product.productId options:nil];
    
    OTSProductDetail *productDetail=[[[OTSProductDetail alloc] initWithProductId:[product.productId longLongValue] promotionId:nil fromTag:PD_FROM_SEARCH] autorelease];
    [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
    [self pushVC:productDetail animated:YES];
    
}



@end
