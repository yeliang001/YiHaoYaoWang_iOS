//
//  OTSPadProductDetailVC.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-16.
//
//

#import "OTSPadProductDetailVC.h"
#import "OTSLineThroughLabel.h"
#import "TopView.h"
#import "CartView.h"
#import "OTSPadProductDetailView.h"
#import "UIView+LoadFromNib.h"
#import "OTSPadImageSliderView.h"
#import "OTSPadProductDetailInfoView.h"
#import "OTSGpsHelper.h"
#import "ProvinceVO.h"
#import "ProductRatingVO.h"

#import "OtsPadLoadingView.h"
#import "OTSPadProductDtMovingHeadView.h"
#import "ProductDescVO.h"
#import "OTSPadProductCommentView.h"
#import "OTSPadProductPromotionView.h"
#import "OTSPadProductSameCateView.h"
#import "OTSAddFavTipView.h"
#import "OTSPromoteProductItemView.h"
#import "ProductListTopView.h"
#import "OTSProductDtTab2View.h"
#import "MobilePromotion.h"

@implementation OTSCateInfo
@synthesize cateid = _cateid;
@synthesize cate1 = _cate1;
@synthesize cate2 = _cate2;
@synthesize cate3 = _cate3;
@synthesize listData = _listData;

- (void)dealloc
{
    [_cateid release];
    [_cate1 release];
    [_cate2 release];
    [_cate3 release];
    [_listData release];
    
    [super dealloc];
}

-(CategoryVO*)selectedCate
{
    CategoryVO *theCate = self.cate3;
    if (theCate == nil)
    {
        theCate = self.cate2 ? self.cate2 : self.cate1;
    }
    
    self.cateid = theCate.nid;
    return theCate;
}

-(NSNumber*)selectedCatID
{
    [self selectedCate];
    return self.cateid;
}

@end



// -------------------------------------------------------------------------
@interface OTSPadProductDetailVC ()
{
    BOOL        _isSubDetailVCShowing;
    CGPoint     _longPressDownPt;
    BOOL        _isHistoryRecorded;
}
@property (retain) TopView          *topView;
@property (retain) CartView         *cartView;
@property (retain) NSArray          *productDescriptions;
@property (retain) NSArray          *giftActivities;                // 赠品活动
@property (retain) NSArray          *exchangeBuyActivities;         // 换购活动
@property (retain) ProductVO        *productDetail;
@property (retain) ProductRatingVO  *ratingVO;
@property (retain) Page             *sameCatePage;
@property (retain) OtsPadLoadingView   *loadingView;
@property (nonatomic, retain) OTSPadProductDetailVC         *subDetailVC;
@property (nonatomic) BOOL                                  isDragging;
@property (nonatomic, retain)   UIView   *floatingItemView;
@property (nonatomic, retain)   ProductListTopView          *navigationView;

-(OTSPadProductDetailView*)rootView;

@end

@implementation OTSPadProductDetailVC
@synthesize topView = _topView;
@synthesize cartView = _cartView;
@synthesize product = _product;
@synthesize productDescriptions = _productDescriptions;
@synthesize productDetail = _productDetail;
@synthesize ratingVO = _ratingVO;
@synthesize sameCatePage = _sameCatePage;
@synthesize loadingView = _loadingView;
@synthesize sliderView = _sliderView;
@synthesize infoView = _infoView;
@synthesize subDetailVC = _subDetailVC;
@synthesize isPopped = _isPopped;
@synthesize isDragging = _isDragging;
@synthesize floatingItemView = _floatingItemView;
@synthesize navigationView = _navigationView;
@synthesize cateInfo = _cateInfo;
@synthesize exchangeBuyActivities = _exchangeBuyActivities;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    long long thisPtr = (long long)self;
    [[NSNotificationCenter defaultCenter] postNotificationName:PAD_NOTIFY_PRODUCT_DETAIL_VC_DEALLOC object:[NSNumber numberWithLongLong:thisPtr]];
    
    [_topView release];
    [_cartView release];
    [_product release];
    [_productDescriptions release];
    [_productDetail release];
    [_ratingVO release];
    [_sameCatePage release];
    [_loadingView release];
    [_sliderView release];
    [_infoView release];
    [_subDetailVC release];
    [_floatingItemView release];
    [_navigationView release];
    [_cateInfo release];
    [_exchangeBuyActivities release];
    
    [super dealloc];
}


-(CGRect)screenRect
{
    CGRect screenRect = [UIScreen mainScreen].applicationFrame;
//    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
//    if (UIInterfaceOrientationIsPortrait(orientation))
    
    int width = screenRect.size.width;
    int height = screenRect.size.height;
    if (width < height)
    {
        screenRect.size.width = height;
        screenRect.size.height = width;
    }
    
    return screenRect;
}

-(OTSPadProductDetailView*)rootView
{
    if ([self.view isKindOfClass:[OTSPadProductDetailView class]])
    {
        return (OTSPadProductDetailView*)(self.view);
    }
    
    return nil;
}

- (id)retain
{
    id obj = [super retain];
    return obj;
}

- (oneway void)release
{
    [super release];
}

- (void)viewDidLoad
{
    [MobClick event:@"click_productdetail"];
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotifyAddToCart:)
                                                 name:PAD_NOTIFY_ADD_TO_CART_IN_DETAIL
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotifyAddToFav:)
                                                 name:PAD_NOTIFY_ADD_TO_FAV_IN_DETAIL
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotifyViewDetail:)
                                                 name:PAD_NOTIFY_VIEW_DETAIL_IN_DETAIL
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotifyCloseDetail:)
                                                 name:PAD_NOTIFY_CLOSE_DETAIL_IN_DETAIL
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotifySwipe:)
                                                 name:PAD_NOTIFY_SWIPE_IN_DETAIL
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotifyCloseLogin) name:@"kcloseloginview" object:nil];
    
    // loading view
    self.loadingView = [[[OtsPadLoadingView alloc] init] autorelease];
    
    
    CGRect screenRect = [self screenRect];
    self.view = [OTSPadProductDetailView viewFromNibWithOwner:self];
    
    CGRect productNameRc = self.rootView.productNameLabel.frame;
    self.rootView.delegate = self;
    //[self.rootView adjustContentSizeIfPopped];

    // info view
    self.infoView = [OTSPadProductDetailInfoView viewFromNibWithOwner:self];
    self.infoView.delegate = self;
    CGRect infoViewRc = self.infoView.frame;
    infoViewRc.origin.y = CGRectGetMaxY(productNameRc) + 10;
    infoViewRc.origin.x = productNameRc.origin.x + 400;
    self.infoView.frame = infoViewRc;
    
    [self.rootView.baseScrollView insertSubview:self.infoView belowSubview:self.rootView.tabView];
    
    
    // slider view
    self.sliderView = [OTSPadImageSliderView viewFromNibWithOwner:self];
    CGRect sliderViewRc = self.sliderView.frame;
    sliderViewRc.origin.y = CGRectGetMaxY(productNameRc) + 10;
    sliderViewRc.origin.x = productNameRc.origin.x;
    self.sliderView.frame = sliderViewRc;
    
    [self.rootView.baseScrollView addSubview:self.sliderView];
    
    // top view
    self.topView = [[[TopView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, kTopHeight)] autorelease];
    [self.view addSubview:self.topView];
    
    // 面包屑导航条
    self.navigationView = [[[ProductListTopView alloc] initWithFrame:CGRectMake(0, kTopHeight-2,1024,kProducrListTopHeight) type:kProductTopviewTypeCategory] autorelease];
    self.navigationView.cate1 = self.cateInfo.cate1;
    self.navigationView.cate2 = self.cateInfo.cate2;
    self.navigationView.cate3 = self.cateInfo.cate3;
    self.navigationView.cateid = self.cateInfo.selectedCatID;

    self.navigationView.listData = self.cateInfo.listData;
    self.navigationView.rootViewController = self;
    
    [self.navigationView fitTheUI];
    [self.view addSubview:self.navigationView];
    
    // cart view
    self.cartView = [[[CartView alloc] initWithFrame:CGRectMake(screenRect.size.width - kCartViewWidth, kTopHeight, kCartViewWidth, screenRect.size.height - kTopHeight)] autorelease];
    [self.view addSubview:self.cartView];
    
    // 浮层处理
    if (_isPopped)
    {
        self.topView.hidden = YES;
        self.navigationView.hidden = YES;
        self.rootView.naviBgIV.hidden = YES;
        self.rootView.closeBtn.hidden = NO;
        
        
        self.rootView.clipsToBounds = YES;
        
        //
        int offsetY = 95;
        int offsetX = 35;
        
        CGRect thisRc = self.rootView.baseScrollView.frame;
        thisRc.origin.y -= offsetY;
        self.rootView.baseScrollView.frame = thisRc;
        
        CGRect tabRc = self.rootView.tabView.frame;
        tabRc.origin.x -= offsetX;
        self.rootView.tabView.frame = tabRc;
        
        CGRect commentRc = self.rootView.commentView.frame;
        commentRc.origin.x -= offsetX;
        self.rootView.commentView.frame = commentRc;
        
        self.sliderView.frame = CGRectOffset(self.sliderView.frame, -offsetX, 0);
        self.infoView.frame = CGRectOffset(self.infoView.frame, -offsetX, 0);

        //
        
        
        CGRect cartRc = CGRectOffset(self.cartView.frame, -kCateDetailViewX, -55);
        self.cartView.frame = cartRc;
        
        //
        UISwipeGestureRecognizer *swipeGesture = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)] autorelease];
        swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
        [self.rootView addGestureRecognizer:swipeGesture];
        self.rootView.multipleTouchEnabled = YES;
    }
    
    if (self.product.isGiftProduct)
    {
        self.infoView.priceLbl = [self useLineThorughStyleWithLabel:self.infoView.priceLbl];
        self.infoView.marketPriceLbl.hidden = YES;
        self.rootView.movingHeadView.priceLabel = [self useLineThorughStyleWithLabel:self.rootView.movingHeadView.priceLabel];
    }
    
    //[self.rootView.tabView hidePromotionTab:self.product.isGiftProduct];
    
    // requesting data...
    [self requestDetail];
}

-(void)swipeAction:(UISwipeGestureRecognizer *)aGesture
{
    [[NSNotificationCenter defaultCenter] postNotificationName:PAD_NOTIFY_SWIPE_IN_DETAIL object:nil];
}

-(UILabel*)useLineThorughStyleWithLabel:(UILabel*)aLabel
{
    if (aLabel)
    {
        CGRect priceRc = aLabel.frame;
        OTSLineThroughLabel* lineThroughLabel = [[[OTSLineThroughLabel alloc] init] autorelease];
        lineThroughLabel.frame = priceRc;
        lineThroughLabel.font = aLabel.font;
        UIView *priceSuperView = aLabel.superview;
        [aLabel removeFromSuperview];
        //self.infoView.priceLbl = lineThroughLabel;
        [priceSuperView addSubview:lineThroughLabel];
        
        return lineThroughLabel;
    }
    
    return nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.topView setCartCount:dataHandler.cart.totalquantity.intValue];
    [self.cartView setCartCount:dataHandler.cart.totalquantity.intValue];
    
    [self.cartView reloadData];
    [MobClick beginLogPageView:@"product_detail"];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"product_detail"];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft
            || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


#pragma mark - network request
-(void)requestDetail
{
    if (self.product == nil || self.product.productId == nil)
    {
        return;
    }
    
    if (self.product.isGiftProduct)
    {
        self.product.promotionId = nil;
    }
    
    //[self.loadingView showInView:self.view];
    [self performInThreadBlock:^{
        
         NSLog(@"isCanBuy:%@",self.product.canBuy);
        self.productDetail = [[OTSServiceHelper sharedInstance]
                              getProductDetail:[GlobalValue getGlobalValueInstance].trader
                              productId:self.product.productId
                              provinceId:[OTSGpsHelper sharedInstance].provinceVO.nid
                              promotionid:self.product.promotionId];
        NSLog(@"isCanBuy:%@",self.productDetail.canBuy);
        
    } completionInMainBlock:^{

        [self.loadingView hide];
        
        if (self.productDetail == nil || (self.productDetail.productId.intValue == 0 && self.productDetail.price.intValue == 0))
        {
            [OTSUtility alert:@"该商品暂时不可售"];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        // 需设置 productId ,merchant
        JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_ProductDetail extraPramaDic:nil]autorelease];
        [prama setProductId:[NSString stringWithFormat:@"%@",self.product.productId]];
        [prama setMerchant_id:[NSString stringWithFormat:@"%@", self.productDetail.merchantId]];
        [DoTracking doJsTrackingWithParma:prama];
        
        if (self.product.isGiftProduct && self.productDetail)
        {
            self.productDetail.isGift = self.product.isGift;
            self.productDetail.promotionId = self.product.promotionId;
            self.productDetail.promotionPrice = self.product.promotionPrice;
        }
        
        self.rootView.productNameLabel.text = self.productDetail.cnName;
        [self.rootView.movingHeadView updateWithProdut:self.productDetail];
        [self.sliderView updateUIWithProduct:self.productDetail];
        [self.infoView updateUIWithProduct:self.productDetail];
        
        // do extra request...
        [self requestPromotionActivities];
        [self requestDescription];
        [self requestComment];
        [self requestInterested];
        [self performInThreadBlock:^(){
            if (!self.productDetail.isGiftProduct) // 不是赠品
            {
                //_isHistoryRecorded = YES;
                //保存浏览历史
                if ([dataHandler queryProductHistoryById:self.productDetail.productId])
                {
                    [dataHandler updateHistory:self.productDetail];
                }
                else
                {
                    [dataHandler saveProductHistory:self.productDetail];
                }
            }
        }];

    }];
}

//-(void)requestGiftActivities
//{
//    if (self.product == nil
//        || self.product.productId == nil
//        || self.product.isGiftProduct)
//    {
//        return;
//    }
//    
//    //[self.loadingView showInView:self.view];
//    [self performInThreadBlock:^{
//        
//        self.giftActivities = [[OTSServiceHelper sharedInstance]
//                              getPromotionGiftList:[GlobalValue getGlobalValueInstance].trader
//                               provinceId:[OTSGpsHelper sharedInstance].provinceVO.nid
//                               merchantIds:[NSArray arrayWithObject:self.product.merchantId]
//                               productIds:[NSArray arrayWithObject:self.product.productId]];
//        
//    } completionInMainBlock:^{
//
//        [self.loadingView hide];
//        [self.infoView updateUIWithGifts:self.giftActivities];
//        [self.rootView.promotionView updateWithGift:self.giftActivities];
//        
//        [self.rootView.tabView hidePromotionTab:(self.giftActivities.count <= 0)];
//        
//    }];
//}

-(void)requestPromotionActivities
{
    if (self.product == nil
        || self.product.productId == nil
        || self.product.isGiftProduct)
    {
        return;
    }
    
    __block MobilePromotion *promotionResult = nil;
    
    [self performInThreadBlock:^{
        
        promotionResult = [[OTSServiceHelper sharedInstance]
                               getMobilePromotion:[GlobalValue getGlobalValueInstance].trader
                               provinceId:[OTSGpsHelper sharedInstance].provinceVO.nid
                               merchantIds:[NSArray arrayWithObject:self.product.merchantId]
                               productIds:[NSArray arrayWithObject:self.product.productId]];
        
        [promotionResult retain];
        
    } completionInMainBlock:^{
        
        [self.loadingView hide];
        
//        if (promotionResult.redemptionList.count > 0)
//        {
//            self.exchangeBuyActivities = [NSMutableArray arrayWithObject:promotionResult.redemptionList[0]];
//        }
//        else
//        {
//            self.exchangeBuyActivities = nil;
//        }
//        
//        
//        if (promotionResult.promotionGiftList.count > 0)
//        {
//            self.giftActivities = [NSMutableArray arrayWithObject:promotionResult.promotionGiftList[0]];
//        }
//        else
//        {
//            self.giftActivities = nil;
//        }
        
        if (self.productDetail.isLandingPage)
        {
            self.exchangeBuyActivities = nil;
            self.giftActivities = nil;
        }
        else
        {
            self.exchangeBuyActivities = promotionResult.redemptionList;
            self.giftActivities = promotionResult.promotionGiftList;
        }
        
        
        [self.infoView updateUIWithExchangeBuys:self.exchangeBuyActivities];
        [self.infoView updateUIWithGifts:self.giftActivities];
        
        [self.rootView.promotionView updateWithGift:self.giftActivities exchangeBuys:self.exchangeBuyActivities];
        
        [self.rootView.tabView hidePromotionTab:(self.giftActivities.count <= 0 && self.exchangeBuyActivities.count <= 0)];
        
        [promotionResult release];
    }];
}

-(void)requestDescription
{
    //[self.loadingView showInView:self.view];
    [self performInThreadBlock:^{
    
        self.productDescriptions = [[OTSServiceHelper sharedInstance]
                                      getProductDetailDescriptionV2:[GlobalValue getGlobalValueInstance].trader
                                      productId:self.product.productId
                                      provinceId:[OTSGpsHelper sharedInstance].provinceVO.nid];
        
    } completionInMainBlock:^{

        [self.loadingView hide];
        
        if (self.productDescriptions.count < 4)
        {
            return; // 信息不足
        }
        
        NSMutableString *htmlStr = [NSMutableString string];
        
        [htmlStr appendString:@"<p><img src='pdHtmlTabSpecifyS.png'></p>"];
        ProductDescVO *productDes = [self.productDescriptions objectAtIndex:1];
        [htmlStr appendString:productDes.tabDetail];
        
        [htmlStr appendString:@"<p><img src='pdHtmlTabPackListS.png'></p>"];
        productDes = [self.productDescriptions objectAtIndex:2];
        [htmlStr appendString:productDes.tabDetail];
        
        [htmlStr appendString:@"<p><img src='pdHtmlTabServiceS.png'></p>"];
        productDes = [self.productDescriptions objectAtIndex:3];
        [htmlStr appendString:productDes.tabDetail];
        
        [htmlStr appendString:@"<p><img src='pdHtmlTabDescriptionS.png'></p>"];
        productDes = [self.productDescriptions objectAtIndex:0];
        [htmlStr appendString:productDes.tabDetail];
        
//        for (ProductDescVO *productDes in self.productDescriptions)
//        {
//            [htmlStr appendString:productDes.tabDetail];
//            [htmlStr appendString:@"<p><img src='pdStar@2x.png'></p>"];
//        }
        
        NSString *finalHtmlStr = [self htmlWithCssFromHtml:htmlStr];
        
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        [self.rootView.webView loadHTMLString:finalHtmlStr baseURL:baseURL];
    }];
}

-(void)requestComment
{
    //[self.loadingView showInView:self.view];
    [self performInThreadBlock:^{
        
        ProductVO *product = [[OTSServiceHelper sharedInstance]
                              getProductDetailComment:[GlobalValue getGlobalValueInstance].trader
                              productId:self.product.productId
                              provinceId:[OTSGpsHelper sharedInstance].provinceVO.nid];
        
        self.ratingVO = product.rating;
        
    } completionInMainBlock:^{
        [self.loadingView hide];
        [self.rootView.commentView updateWithRating:self.ratingVO];
        [self.infoView.seeCommentBtn
         setTitle:[NSString stringWithFormat:@"(已有%d人评价)", [self.ratingVO.totalExperiencesCount intValue]]
         forState:UIControlStateNormal];
        
//        self.rootView.tabView.tabLabel2.text = [NSString stringWithFormat:@"商品评价(%d)", [self.ratingVO.totalExperiencesCount intValue]];
        
    }];
}

-(void)requestInterested
{
    //[self.loadingView showInView:self.view];
    
    [self performInThreadBlock:^{
        
        self.sameCatePage = [[OTSServiceHelper sharedInstance]
                             getMoreInterestedProducts:[GlobalValue getGlobalValueInstance].trader
                             productId:self.product.productId
                             provinceId:[OTSGpsHelper sharedInstance].provinceVO.nid
                             currentPage:[NSNumber numberWithInt:1]
                             pageSize:[NSNumber numberWithInt:100]];
        
    } completionInMainBlock:^{

        [self.loadingView hide];
        [self.rootView.sameCateView updateWithPage:self.sameCatePage];
    }];
}

-(void)requestAddToFav:(ProductVO*)aProduct
{
    if (aProduct == nil)
    {
        return;
    }
    
    if ([self loginIfNeeded])
    {
        //[self.loadingView showInView:self.view];
        
        __block int result = 0;
        [self performInThreadBlock:^{
            
            result = [[OTSServiceHelper sharedInstance]
                      addFavorite:[GlobalValue getGlobalValueInstance].token
                      tag:@""
                      productId:aProduct.productId];
            NSLog(@"reustul is %i",result);//0失败，1成功，-1产品已存在。
            
        } completionInMainBlock:^{

            [self.loadingView hide];
            
            NSDictionary *resultHandleDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                             @"收藏成功", [NSNumber numberWithInt:1]
                                             , @"收藏失败", [NSNumber numberWithInt:0]
                                             , @"商品已收藏", [NSNumber numberWithInt:-1]
                                             , nil];
            NSString *resultStr = [resultHandleDic objectForKey:[NSNumber numberWithInt:result]];
            if (resultStr)
            {
                //[OTSUtility alert:resultStr];
                OTSAddFavTipView *tip = [OTSAddFavTipView viewFromNibWithOwner:self];
                [tip showAboveView:self.infoView.addToFavBtn text:resultStr];
            }

        }];
    }
}



-(void)requestAddToCart:(ProductVO*)aProduct
{
    if (aProduct)
    {
        [self.topView setCartCount:dataHandler.cart.totalquantity.intValue];
        [self.cartView setCartCount:dataHandler.cart.totalquantity.intValue];
        
        [dataHandler addProductToCart:aProduct buyCount:aProduct.purchaseAmount];
        
        [self moveCartViewToLeft];
        
        //[cartView reloadData];
        [MobClick event:@"detail_addcart"];
        
        JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_addCart_inDetail extraPramaDic:nil]autorelease];
        [prama setProductId:aProduct.productId];
        [prama setMerchant_id:[NSString stringWithFormat:@"%@",aProduct.merchantId]];
        [DoTracking doJsTrackingWithParma:prama];
    }
}

#pragma mark - handle notification
-(void)handleNotifyAddToCart:(NSNotification*)aNotification
{
    if (_isSubDetailVCShowing)
    {
        return;
    }
    
    ProductVO *product = aNotification.object;
    [self requestAddToCart:product];
}

-(void)handleNotifyAddToFav:(NSNotification*)aNotification
{
    if (_isSubDetailVCShowing)
    {
        return;
    }
    
    ProductVO *product = aNotification.object;
    [self requestAddToFav:product];
    
    JSTrackingPrama* prama = [[JSTrackingPrama alloc]initWithJSType:EJStracking_AddFavourite_inDetail extraPrama:nil];
    [prama setProductId:product.productId];
    [DoTracking doJsTrackingWithParma:prama];
}

-(void)handleNotifyViewDetail:(NSNotification*)aNotification
{
    ProductVO *product = aNotification.object;
    
    if (!_isPopped)
    {
        [self enterDetailWithProduct:product];
    }
}

-(void)enterDetailWithProduct:(ProductVO*)aProduct
{
    if (aProduct)
    {
        CGRect oldVCRc = CGRectZero;
        
        if (_isSubDetailVCShowing)
        {
            [self.subDetailVC.view removeFromSuperview];
            oldVCRc = self.subDetailVC.view.frame;
        }
        
        self.subDetailVC = [[[OTSPadProductDetailVC alloc] init] autorelease];
        self.subDetailVC.product = aProduct;
        self.subDetailVC.isPopped = YES;
        
        if (_isSubDetailVCShowing)
        {
            self.subDetailVC.view.frame = oldVCRc;
            [self.view addSubview:self.subDetailVC.view];
        }
        else
        {
            [self moveHoverView:self.subDetailVC.view inOrOut:YES offsetY:kTopHeight];
            
            if (self.semiTransBgView.gestureRecognizers.count <= 0)
            {
                UITapGestureRecognizer *swipeGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)] autorelease];
                [self.semiTransBgView addGestureRecognizer:swipeGesture];
            }
        }
        
        _isSubDetailVCShowing = YES;
        //[self.rootView bringSubviewToFront:self.cartView];
    }
}

-(void)handleNotifyCloseDetail:(NSNotification*)aNotification
{
    [self moveHoverView:self.subDetailVC.view inOrOut:NO offsetY:0];
    
    _isSubDetailVCShowing = NO;
}

-(void)handleNotifySwipe:(NSNotification*)aNotification
{
    if (!_isPopped)
    {
        [self handleNotifyCloseDetail:nil];
    }
}


-(void)handleNotifyCloseLogin
{
    [self popLoginView];
}

#pragma mark - helper
-(NSString*)cssString
{    
    NSString *cssStr = @"@charset \"utf-8\";.standard{background: url(http://image.yihaodianimg.com/images/v2/standard_rebg.gif) repeat; color: #333333;}.standard dt{background:#DDDDDD; font-weight: bold; height: 22px; line-height: 22px; text-indent: 22px;}.standard dd{height: 22px; line-height: 22px; overflow: hidden; text-indent: 10px;}.standard label{float: left; text-indent: 22px; width: 20%;}.standard dd label{border-right: 1px solid #CCCCCC;}";
    
    return [NSString stringWithFormat:@"<style type='text/css'>%@</style>", cssStr];
}

-(NSString*)htmlWithCssFromHtml:(NSString*)aHtml
{
    if (aHtml)
    {
        
        NSString *cssTagStr = [self cssString];
        return [NSString stringWithFormat:@"<html><head>%@</head><body>%@</body></html>", cssTagStr, aHtml];
    }
    
    return nil;
}

-(void)moveCartViewToLeft
{
    CGRect rect = self.cartView.frame;
    if (rect.size.width==kCartViewWidth)
    {
        rect.size.width += kCartViewWidthExtend;
        rect.origin.x -= kCartViewWidthExtend;
        self.cartView.frame =rect;
    }
}

-(void)moveCartViewToRight
{
    CGRect rect= self.cartView.frame;
    if (rect.size.width==kCartViewWidth+kCartViewWidthExtend)
    {
        rect.size.width-=kCartViewWidthExtend;
        rect.origin.x+=kCartViewWidthExtend;
        self.cartView.frame =rect;
    }
}

-(void)seePromotionAction:(id)sender
{
    [self.rootView.tabView selectTabIndex:kPadProdDetailTabPromotion];
    [self scrollToTabIndex];
}

-(void)seeCommentAction:(id)sender
{
    [self.rootView.tabView selectTabIndex:kPadProdDetailTabComment];
    [self scrollToTabIndex];
}

-(void)scrollToTabIndex
{
    float offsetY = self.infoView.frame.size.height - 10;
    [self.rootView.baseScrollView setContentOffset:CGPointMake(0, offsetY) animated:YES];
    
}

#pragma mark - drag add cart

-(void)handelLongPress:(UILongPressGestureRecognizer*)aGesture
{
//    if (_isPopped)
//    {
//        return;
//    }
    
    OTSPromoteProductItemView *view = (OTSPromoteProductItemView *)aGesture.view;
    ProductVO *product = view.product;
    if (!product.isCanBuy || product.isGiftProduct || product.isJoinRedemption)
    {
        return;
    }
    
    CGPoint pt = [aGesture locationInView:self.view];
    
    switch (aGesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            
            
            if (product.isCanBuy)
            {
                UIImage *canbuyImageBg = [UIImage imageNamed:@"pdItemDragBg@2x.png"];
                self.floatingItemView = [[[UIImageView alloc] initWithImage:canbuyImageBg] autorelease];
            }
            else
            {
                UIImage *disabledImageBg = [UIImage imageNamed:@"pdItemDragCantBuyBg@2x.png"];
                self.floatingItemView = [[[UIImageView alloc] initWithImage:disabledImageBg] autorelease];
            }
            //CGRect floatingRc = self.floatingItemView.frame;
            
           OTSPromoteProductItemView *itemMirror = [OTSPromoteProductItemView viewFromNibWithOwner:self];
            [itemMirror updateWithProduct:product];
            
            CGRect mirrorRc = itemMirror.frame;
            mirrorRc.origin.x = (self.floatingItemView.frame.size.width - itemMirror.frame.size.width) *.5f;
            if (product.isCanBuy)
            {
                mirrorRc.origin.y = (self.floatingItemView.frame.size.height - itemMirror.frame.size.height) *.5f;
            }
            else
            {
                mirrorRc.origin.y = self.floatingItemView.frame.size.height - itemMirror.frame.size.height - 16;
            }
            
            itemMirror.frame = mirrorRc;
            [self.floatingItemView addSubview:itemMirror];
            
            self.floatingItemView.center = pt;
            //self.floatingItemView.layer.opacity = .6f;
            
            [self.view addSubview:self.floatingItemView];
            
            _longPressDownPt = pt;
            
            [self moveCartViewToLeft];
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            CGPoint thePoint = pt;
            if (_isPopped)
            {
                thePoint.x += kCateDetailViewX;
            }
            
            int maxX = 1022;
            int minX = 1024 - kCartViewWidth - kCartViewWidthExtend;
            if (thePoint.x > minX && thePoint.x < maxX && product.isCanBuy)
            {
                product.purchaseAmount = 1;
                [self requestAddToCart:product];
                
                [self.floatingItemView removeFromSuperview];
                
                [MobClick event:@"drag_cart"];
            }
            else
            {
                [UIView animateWithDuration:.5f animations:^{
                    
                    self.floatingItemView.center = _longPressDownPt;
                    
                } completion:^(BOOL completed){
                    
                    [self.floatingItemView removeFromSuperview];
                    
                }];
                
                [self moveCartViewToRight];
            }
        }
            break;
            
        default:
        {
            self.floatingItemView.center = pt;
        }
            break;
    }
    
}

- (BOOL)loginIfNeeded
{
    if ([GlobalValue getGlobalValueInstance].token == nil)
    {
        self.loginVC = [[[LoginViewController alloc] init] autorelease];
        [self.loginVC setMcart:[DataHandler sharedDataHandler].cart];
        if (self.loginVC.mcart.totalquantity != 0)
        {
            [self.loginVC setMneedToAddInCart:YES];
        }
        
        if (!_isPopped)
        {
            [self moveHoverView:self.loginVC.view inOrOut:YES];
        }
        else
        {
            [self moveHoverView:self.loginVC.view inOrOut:YES offsetX:0 offsetY:0];
        }
        
        return NO;
    }
    
    return YES;
}

@end
