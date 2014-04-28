
#import "PhoneCartViewController.h"
#import "GlobalValue.h"
#import <QuartzCore/QuartzCore.h>
#import "CheckOrder.h"
#import "UserManage.h"
#import "AlertView.h"
#import "OTSLoadingView.h"
#import "OTSAlertView.h"
#import "OTSActionSheet.h"
#import "TheStoreAppAppDelegate.h"
#import "UIScrollView+OTS.h"
#import "CartCell.h"
#import "OTSProductDetail.h"
#import "PromotionViewController.h"
#import "CategoryProductsViewController.h"
#import "EditGoodsReceiver.h"
#import "YWLocalCatService.h"
#import "LocalCarInfo.h"
#import "YWProductService.h"
#import "ProductInfo.h"
#import "JSONKit.h"
#import "CartInfo.h"
#import "PromotionInfo.h"
#import "PromotionReduceView.h"
#import "AddGiftButton.h"
#import "GiftInfo.h"
#import "PromotionGiftCellView.h"
#import "ConditionInfo.h"

#import "mobidea4ec.h"

#define ACTION_SHEET_CHOOSE_COUNT   1
#define ACTION_SHEET_SETTLEMENT 2

#define ALERTVIEW_TAG_DELETE_CONFIRM    1
#define ALERTVIEW_TAG_ORDER_DISTRIBUTION 3
#define CAN_EDIT_CELL 2013
#define CANNOT_EDIT_CELL 2014

@interface PhoneCartViewController ()
@property (nonatomic, retain)PromotionViewController   *promotionVC;

@end

@implementation PhoneCartViewController
@synthesize cartTableView;
@synthesize promotionVC = _promotionVC;
@synthesize distributionError;


#pragma mark - ViewLife
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(void)dealloc
{
    
    [cartTableView release];
    [m_PickerView release];
    [_promotionVC release];
    [_localCartInfoArr release];
    [_cartInfo release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
-(void)viewWillAppear:(BOOL)animated
{
    DebugLog(@"－－－－> %s 开始",__func__);
    if (!_localCartInfoArr)
    {
        _localCartInfoArr = [[NSMutableArray alloc] init];
    }
    if (!_latestProductArr)
    {
        _latestProductArr = [[NSMutableArray alloc] init];
    }
    if (!_productStockArr)
    {
        _productStockArr = [[NSMutableArray alloc] init];
    }
    if (!_cartProductArr)
    {
        _cartProductArr = [[NSMutableArray alloc] init];
    }
    if (SharedDelegate.m_UpdateCart)
    {
        SharedDelegate.needCachedPromotion=YES;
        [self reloadCart];
    }
    
    if (!_selectedGiftList)
    {
        _selectedGiftList = [[NSMutableArray alloc] init];
    }
}


- (void)viewDidLoad
{  DebugLog(@"－－－－> %s 开始",__func__);
    [super viewDidLoad];
    [self initTitltBar];
    [self initCartInfoView];
    [self initCartTableView];
    [self initCartEmptyView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCart) name:@"cartload" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutHandle) name:OTS_USER_LOG_OUT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartDirectToOrder) name:@"CartDirectToOrder" object:nil];
}

#pragma mark - UI
-(void)initTitltBar
{
    UIImageView* tittleImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_bg.png"]];
    tittleImg.frame=CGRectMake(0, 0, 320, 44);
    tittleImg.userInteractionEnabled=YES;
    [self.view addSubview:tittleImg];
    [tittleImg release];
    
    editBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setBackgroundImage:[UIImage imageNamed:@"title_left_normal_btn_sel.png"] forState:UIControlStateHighlighted];
    
    [editBtn setTitle:@"修改" forState:UIControlStateNormal];
    editBtn.titleLabel.font=[UIFont boldSystemFontOfSize:13];
    editBtn.titleLabel.shadowColor=[UIColor darkGrayColor];
    editBtn.titleLabel.shadowOffset=CGSizeMake(1, -1);
    
    [editBtn setBackgroundImage:[UIImage imageNamed:@"title_left_normal_btn.png"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editBtn:) forControlEvents:UIControlEventTouchUpInside];
    editBtn.tag=1;
    editBtn.frame=CGRectMake(0, 0, 61, 44);
    [tittleImg addSubview:editBtn];
    
    UILabel* titLab=[[UILabel alloc] initWithFrame:CGRectMake(61, 0, 320-122, 44)];
    titLab.text=@"购物车";
    titLab.textAlignment=NSTextAlignmentCenter;
    titLab.shadowColor=[UIColor darkGrayColor];
    titLab.shadowOffset=CGSizeMake(1, -1);
    titLab.font=[UIFont boldSystemFontOfSize:20];
    titLab.textColor=[UIColor whiteColor];
    titLab.backgroundColor=[UIColor clearColor];
    [tittleImg addSubview:titLab];
    [titLab release];
    
    accountBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [accountBtn setBackgroundImage:[UIImage imageNamed:@"title_account.png"] forState:UIControlStateNormal];
    [accountBtn addTarget:self action:@selector(buyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [accountBtn setBackgroundImage:[UIImage imageNamed:@"title_account_sel.png"] forState:UIControlStateHighlighted];
    accountBtn.frame=CGRectMake(320-61, 0, 61, 44);
    [tittleImg addSubview:accountBtn];
    accountBtn.hidden=YES;
    editBtn.hidden=YES;
}

-(void)initCartInfoView
{
    UIFont*font13=[UIFont systemFontOfSize:13];
    UIColor*clearCol=[UIColor clearColor];
    UIView*cartInfo=[[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 58)];
    cartInfo.backgroundColor=[UIColor colorWithRed:(249.0/255.0) green:(249.0/255.0) blue:(249.0/255.0) alpha:1] ;
    [self.view addSubview:cartInfo];
    [cartInfo release];
    
    productsNum=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 28)];
    productsNum.font=font13;
    productsNum.text=@"共0件,0kg";
    productsNum.backgroundColor=[UIColor clearColor];
    [cartInfo addSubview:productsNum];
    [productsNum release];
    
    totalWeight = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 145, 28)];
    totalWeight.font=font13;
    totalWeight.textAlignment = NSTextAlignmentRight;
    totalWeight.backgroundColor = clearCol;
    totalWeight.text=@"立减: ¥ 0";
    [cartInfo addSubview:totalWeight];
    [totalWeight release];
    
    UILabel*billLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 28, 120, 28)];
    billLab.font=font13;
    billLab.backgroundColor=clearCol;
    billLab.textAlignment=NSTextAlignmentLeft;
    billLab.text = @"总计(未含运费):";
    [cartInfo addSubview:billLab];
    [billLab release];
    
    bill=[[UILabel alloc] initWithFrame:CGRectMake(100, 28, 100, 28)];
    bill.font=[UIFont systemFontOfSize:18];
    bill.backgroundColor=clearCol;
    bill.textColor=[UIColor colorWithRed:0.686 green:0.078 blue:0.01 alpha:1];
    bill.textAlignment=NSTextAlignmentRight;
    [cartInfo addSubview:bill];
    bill.adjustsFontSizeToFitWidth=YES;
    [bill release];
    
    UIView* redline=[[UIView alloc] initWithFrame:CGRectMake(0, 57, 320, 1)];
    redline.backgroundColor=[UIColor colorWithRed:0.686 green:0.078 blue:0.01 alpha:1];
    [cartInfo addSubview:redline];
    [redline release];
}

-(void)initCartTableView
{
    cartTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 44+58, 320, self.view.frame.size.height-44-58) style:UITableViewStylePlain];
    cartTableView.delegate=self;
    cartTableView.dataSource=self;
    cartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:cartTableView];
    [cartTableView ScrollMeToTopOnly];
    tableFooter=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 170)];
    tableFooter.backgroundColor=[UIColor colorWithRed:(248.0/255.0) green:(248.0/255.0) blue:(248.0/255.0) alpha:1];
    m_CleanBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    m_CleanBtn.frame=CGRectMake(211, 15, 95, 32);
    [m_CleanBtn setBackgroundImage:[UIImage imageNamed:@"gray_btn.png"] forState:UIControlStateNormal];
    [m_CleanBtn setTitle:@"清空购物车" forState:UIControlStateNormal];
    [m_CleanBtn addTarget:self action:@selector(cleanCart) forControlEvents:UIControlEventTouchUpInside];
    m_CleanBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [m_CleanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m_CleanBtn.hidden=YES;
    [tableFooter addSubview:m_CleanBtn];
    
    submitBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitBtn.frame=CGRectMake(20, 5, 280, 40);
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"orange_long_btn.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(buyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitle:@"结算" forState:UIControlStateNormal];
    submitBtn.titleLabel.font=[UIFont boldSystemFontOfSize:20];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tableFooter addSubview:submitBtn];
    
    feeImageView=[[UIImageView alloc] initWithFrame:CGRectMake(52, 60, 216, 47)];
    feeImageView.image=[UIImage imageNamed:@"cart_fee.png"];
    [tableFooter addSubview:feeImageView];
    feeImageView.userInteractionEnabled=YES;
    
    showFeeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    showFeeBtn.frame=CGRectMake(216-15-8-13, 8, 30, 30);
    [showFeeBtn setImage:[UIImage imageNamed:@"cart_fee_show.png"] forState:UIControlStateNormal];
    [showFeeBtn setImage:[UIImage imageNamed:@"cart_fee_close.png"] forState:UIControlStateSelected];
    [feeImageView addSubview:showFeeBtn];
    
    UIButton* bu=[UIButton buttonWithType:UIButtonTypeCustom];
    bu.frame=CGRectMake(0, 0, 216, 47);
    [bu addTarget:self action:@selector(showFeeText:) forControlEvents:UIControlEventTouchUpInside];
    [feeImageView addSubview:bu];
    
    showFeeBtn.showsTouchWhenHighlighted=YES;
    cartTableView.tableFooterView=tableFooter;
    [feeImageView release];
    [tableFooter release];
}

- (void)initCartEmptyView
{
    emptyView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, 367)];
    emptyView.userInteractionEnabled=YES;
    emptyView.image=[UIImage imageNamed:@"cart_null.png"];
    [self.view addSubview:emptyView];
    [emptyView release];
    
    UIButton* historyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [historyBtn addTarget:self action:@selector(goBrowseing:) forControlEvents:UIControlEventTouchUpInside];
    [historyBtn setBackgroundImage:[UIImage imageNamed:@"browsebtn.png"] forState:UIControlStateNormal];
    historyBtn.frame=CGRectMake(61, 243, 90, 30);
    [emptyView addSubview:historyBtn];
    
    UIButton*favoriteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [favoriteBtn addTarget:self action:@selector(goFavoriteing:) forControlEvents:UIControlEventTouchUpInside];
    
    [favoriteBtn setBackgroundImage:[UIImage imageNamed:@"favoritebtn.png"] forState:UIControlStateNormal];
    favoriteBtn.frame=CGRectMake(172, 243, 90, 30);
    [emptyView addSubview:favoriteBtn];
}


#pragma mark - Request
-(void)refreshCart
{
    DebugLog(@"－－－－> %s 开始",__func__);
    
    //    if (!cartOnLoading)
    //    {
    //        m_TotalCash=0;
    //        m_TotalWeight=0;
    //    }
    accountBtn.enabled=NO;
    
    //将原来的数据置空
    [self.localCartInfoArr removeAllObjects];
    [self.latestProductArr removeAllObjects];
    [self.cartProductArr removeAllObjects];
    //    [_selectedGiftList removeAllObjects];
    _bSomeProductNoStock = NO;
    m_TotalCount = 0;
    m_TotalCash=0;
    m_TotalWeight=0;
    
    [self getLocalCartData];
    if (self.localCartInfoArr.count > 0)
    {
        [self getLatestProductInfo];
    }
    else
    {
        //把购物车中的商品为空，表示这商品不能买了
        //就当做没商品
        emptyView.hidden=NO;
    }
    if (self.latestProductArr.count > 0)
    {
        [self getProductsStock];
    }
    else
    {
        //把购物车中的商品发到服务器上检查之后返回 为空，表示这写商品不能买了
        //就当做没商品
        emptyView.hidden=NO;
    }
    //做过滤， 把3个数组合并一下，郁闷啊，傻逼的方式。。。。。服务器傻逼，不能怪我。。。
    //最后合成一个NSDictionary的数组
    //字典的结构：key：@“product” @“selectedCount” 对应的value：ProductInfo 对象，和数量
    
    m_TotalWeight = 0.0;
    m_TotalPrice = 0.0;
    
    
    NSMutableArray *buyList = [[NSMutableArray alloc] init];
    
    //把库存数据加入到productInfo 中的currentStock中去
    for (ProductInfo *pInfo in self.latestProductArr)
    {
        //把当前的库存信息存到productInfo中，因为之前没有这数据，后面获取再组装
        pInfo.currentStore = [self getProductStockByProductNo:pInfo.productNO];
        
        NSString *selectCount = [self getSelectCountByProductId:pInfo.productId];
        //根据限购规则验证一下
        selectCount = [NSString stringWithFormat:@"%d",[self caluShoppingCount:pInfo selectedCount:[selectCount intValue]]];
        
        NSDictionary *cartDic = @{@"product":pInfo,@"selectCount":selectCount};
        [self.cartProductArr addObject:cartDic];
        
        //计算总价格
        m_TotalPrice = m_TotalPrice + [pInfo.price floatValue] * [selectCount floatValue];
        //计算总重量
        m_TotalWeight = m_TotalWeight + [pInfo.weight floatValue] * [selectCount floatValue];
        
        
        //统计购物车数据给百分点
        NSDictionary *buyProduct = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:pInfo.productId,[NSNumber numberWithDouble:[pInfo.price doubleValue] ],[NSNumber numberWithInt:[selectCount intValue]],nil] forKeys:[NSArray arrayWithObjects:@"id",@"price",@"count",nil]];
        [buyList addObject:buyProduct];
    }
    
    //百分点
    [BfdAgent addCart:nil lst:buyList options:nil];

    [buyList release];
    
    
    [self performSelectorOnMainThread:@selector(getCartProductData) withObject:nil waitUntilDone:NO];
    
    
    DebugLog(@"－－－－> %s 结束",__func__);
}

//根据限购规则计算现在选择的数量是不是正确 ，返回正确选择数量
- (NSInteger)caluShoppingCount:(ProductInfo *)product selectedCount:(NSInteger)selectedCount
{
    
    NSInteger caluCount = selectedCount;
    //起购或者限购 判断
    NSInteger maxCount = [product.currentStore intValue];
    NSInteger minCount = 1;
    if (product.limitCount > 0)
    {
        maxCount = product.limitCount < maxCount ? product.limitCount : maxCount;
    }
    
    if (product.leastCount)
    {
        minCount = product.leastCount;
    }
    
    //判断选择的商品是不是有问题
    if (selectedCount > maxCount)
    {
        //如果大于最大值
        caluCount = maxCount;
    }
    if (selectedCount < minCount)
    {
        //如果小于最小值
        caluCount = minCount;
        
        //注意： 如果该商品是有起购限制的（最少买2件）而现在不符合这个要求，那么就自动修改这个购买数量，满足最小值，但是修改数量的同时也要修改购物车的总金额
        _cartInfo.money += [product.price floatValue] * (caluCount - selectedCount);
        
    }
    
    return caluCount;
}

- (void)getCartProductData
{
    cartOnLoading = NO;
    [self hideLoading];
    //    [self refreshTableFooter];
    [self refreshCartNum];
    [self requsetSuccess];
}


//从本地购物车中 通过productId来获取该商品的购买数量
- (NSString *)getSelectCountByProductId:(NSString *)productId
{
    for (LocalCarInfo *localCart in self.localCartInfoArr)
    {
        if ([localCart.productId isEqualToString:productId])
        {
            return localCart.num;
        }
    }
    return nil;
}

- (NSString *)getProductStockByProductNo:(NSString *)aProductNo
{
    for (NSDictionary *dic in self.productStockArr)
    {
        NSString *productNo = dic[@"productNo"];
        if ([productNo isEqualToString:aProductNo])
        {
            return dic[@"stock"];
        }
    }
    return nil;
}





//获取本地购物车的－－药网
-(void)getLocalCartData
{
    DebugLog(@"－－－－> %s 开始",__func__);
    YWLocalCatService *carService = [[YWLocalCatService  alloc] init];
    self.localCartInfoArr = [carService getShoppingCart];
    DebugLog(@"－－－－> %s 结束",__func__);
}

//根据购物车的数据 请求最新的商品信息
- (void)getLatestProductInfo
{DebugLog(@"－－－－> %s 开始",__func__);
    NSMutableArray *jsonArr = [[[NSMutableArray alloc] init] autorelease];
    NSString *ids = @"";
    for (int i = 0; i < self.localCartInfoArr.count; i++)
    {
        LocalCarInfo *cart = self.localCartInfoArr[i];
        ids = [ids stringByAppendingString:cart.productId];
        
        if (i != self.localCartInfoArr.count - 1)
        {
            ids = [ids stringByAppendingString:@","];
        }
        
        ////为了促销功能加入的，要组成一个json
        NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
        [json setObject:cart.productId==nil?@"":cart.productId forKey:@"id"];
        [json setObject:cart.num==nil ? @"" : cart.num forKey:@"productcount"];
        [json setObject:cart.productNO==nil?@"":cart.productNO forKey:@"productno"];
        [json setObject:cart.price==nil? @"":cart.price forKey:@"originalprice"];
        [json setObject:@"0.0" forKey:@"moneyback"];
        [json setObject:@"ZSP" forKey:@"materialtype"]; // 物料类型[ZSP:商品,ZZP:赠品]
        [json setObject:@"" forKey:@"promotionid"];
        [json setObject:@"" forKey:@"weight"];
        [json setObject:@"" forKey:@"bigcatalogid"];
        [json setObject:@"1" forKey:@"saletype"];// 销售类型[0普通 1团购 2抢购]
        [json setObject:@"0" forKey:@"status"];// 态状0是选中，-1是没有选中
        [json setObject:cart.itemId==nil? @"":cart.itemId forKey:@"itemid"];
        [json setObject:@"" forKey:@"venderid"];
        [json setObject:@"1" forKey:@"itemtype"];// 商品类型1普通商品,3套餐,6赠品,7换购
        
        [jsonArr addObject:json];
        [json release];
        
    }
    
    //如果有赠品，把赠品也组成json数组加入
    if (_selectedGiftList.count > 0)
    {
        NSLog(@"已经有选择的赠品了！！！！！！！！！！！");
        
        ids = [ids stringByAppendingString:@","];
        
        for (NSInteger i = 0; i < _selectedGiftList.count; ++i)
        {
            GiftInfo *gift = _selectedGiftList[i];
            ids = [ids stringByAppendingString:[NSString stringWithFormat:@"%d", gift.itemId]];
            if (i != _selectedGiftList.count - 1)
            {
                ids = [ids stringByAppendingString:@","];
            }
            
            ////为了促销功能加入的，要组成一个json
            NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
            [json setObject:[NSString stringWithFormat:@"%d",gift.itemId] forKey:@"id"];
            [json setObject:[NSString stringWithFormat:@"%d",gift.selectedCount] forKey:@"productcount"];
            [json setObject:@"" forKey:@"productno"];
            [json setObject:[NSString stringWithFormat:@"%lf",gift.price] forKey:@"originalprice"];
            [json setObject:@"0.0" forKey:@"moneyback"];
            [json setObject:@"ZZP" forKey:@"materialtype"]; // 物料类型[ZSP:商品,ZZP:赠品]
            [json setObject:[NSString stringWithFormat:@"%d",gift.promotionId] forKey:@"promotionid"];
            [json setObject:@"" forKey:@"weight"];
            [json setObject:@"" forKey:@"bigcatalogid"];
            [json setObject:@"1" forKey:@"saletype"];// 销售类型[0普通 1团购 2抢购]
            [json setObject:@"0" forKey:@"status"];// 态状0是选中，-1是没有选中
            [json setObject:@"" forKey:@"itemid"];
            [json setObject:@"" forKey:@"venderid"];
            [json setObject:@"6" forKey:@"itemtype"];// 商品类型1普通商品,3套餐,6赠品,7换购
            
            [jsonArr addObject:json];
            [json release];
        }
    }
    
    NSDictionary *dic = @{@"ids":ids,
                          @"flag":@"4",
                          @"shopcartdata":[jsonArr JSONString],
                          @"province" : [GlobalValue getGlobalValueInstance].provinceId
                          };
    
    
    YWProductService *pSer = [[YWProductService alloc] init];
    _cartInfo = [[pSer getProductDetailList:dic] retain];
    self.latestProductArr = _cartInfo.productList;
    
    //mb的，现在要把这个商品列表中把赠品拿出来，草
    for (GiftInfo *gift in _selectedGiftList)
    {
        for (ProductInfo *product in self.latestProductArr)
        {
            if ([product.productId intValue] == gift.itemId)
            {
                gift.detailProduct = product;
            }
        }
    }
    //然后剔除latesProductArr 中的赠品
    for (GiftInfo *gift in _selectedGiftList)
    {
        if (gift.detailProduct)
        {
            [self.latestProductArr removeObject:gift.detailProduct];
        }
    }
    
    //为每个有促销的商品寻找对应的促销信息
    for (ProductInfo *product in self.latestProductArr)
    {
        for (PromotionInfo *promotion in _cartInfo.promotionList)
        {
            if (!promotion.satisfy)
            {
                //如果这么促销是不满足的，就不要去找主商品了
                continue;
            }
            
            BOOL bIn = NO;
            for (NSString *itemId in promotion.productItemIdArr)
            {
                if ([product.productNO isEqualToString:itemId])
                {
                    bIn = YES;
                    break;
                }
            }
            
            //如果是这个商品的促销，就把id告诉product
            if (bIn)
            {
                if (promotion.promotionType == kYaoPromotion_MJ ||
                    promotion.promotionType == kYaoPromotion_MJJ ||
                    promotion.promotionType == kYaoPromotion_MEJ)
                {
                    product.promotionIdOfReduce = promotion.promotionId;
                    
                    NSLog(@"找到了商品 %@ 的满减促销id %d",product.name,product.promotionIdOfReduce);
                }
                
                else if (promotion.promotionType == kYaoPromotion_MZ ||
                         promotion.promotionType == kYaoPromotion_MJZ ||
                         promotion.promotionType == kYaoPromotion_MEZ)
                {
                    product.promotionIdOfGift = promotion.promotionId;
                    
                    NSLog(@"找到了商品 %@ 的满赠促销id %d",product.name,product.promotionIdOfGift);
                }
            }
        }
    }
    
    //把每个promotion中的对应商品找出来，然后存到promotion中的productArr中
    for (PromotionInfo *promotion in _cartInfo.promotionList)
    {
        for (NSString *itemId in promotion.productItemIdArr)
        {
            for (ProductInfo *product in _latestProductArr)
            {
                if ([itemId isEqualToString:product.productNO])
                {
                    [promotion.productArr addObject:product];
                }
            }
        }
    }
    
    //重新获取数据之后 确定下已经选择的赠品是不是还是满足条件，不满足促销条件的赠品就移除
    [self checkSelectedGiftList];
    
    //遍历promotion 然后去遍历已选择的赠品，然后找到改promotion下面的赠品，确定这个promotion下的赠品已经选择了几个
    for (PromotionInfo *promotion in _cartInfo.promotionList)
    {
        NSInteger selectedGiftCountInThisPromotion = 0;
        
        for (GiftInfo *gift in _selectedGiftList)
        {
            if (promotion.promotionId == gift.promotionId)
            {
                selectedGiftCountInThisPromotion += gift.selectedCount;
            }
        }
        
        promotion.selectedGiftCount = selectedGiftCountInThisPromotion;
    }
    
    
    m_TotalCount = [self.latestProductArr count];
    
    DebugLog(@"－－－－> %s 结束",__func__);
}

//获取商品的库存信息
- (void)getProductsStock
{
    DebugLog(@"－－－－> %s 开始",__func__);
    NSString *productnos = @"";
    for (int i = 0; i < self.latestProductArr.count; i++)
    {
        ProductInfo *product = self.latestProductArr[i];
        productnos = [productnos stringByAppendingString:product.productNO];
        if (i != self.latestProductArr.count - 1)
        {
            productnos = [productnos stringByAppendingString:@","];
        }
    }
    NSDictionary *dic = @{@"productnos":productnos,@"flag":@"2",@"province":[GlobalValue getGlobalValueInstance].provinceId};
    YWProductService *pSer = [[[YWProductService alloc] init] autorelease];
    self.productStockArr = [pSer getProductInStock:dic];
    DebugLog(@"－－－－> %s 结束",__func__);
}


//检查赠品列表里面的赠品是不是还符合要求
//如果满赠的促销不满足了，那么promotion中的Gifts的赠品列表是空的
//判断一下，_selectedGiftList中的商品还在不在promotion的Gifts里面，不在表示这个赠品已经不满足了，应该移除
- (void)checkSelectedGiftList
{
    
    NSMutableArray *deletingGiftList = [[NSMutableArray alloc] init];
    
    for (GiftInfo *gift in _selectedGiftList)
    {
        BOOL bIn = NO;
        
        //然后遍历promotionList 看看这个赠品还存在吗？ 不存在肯定不满足促销
        for (PromotionInfo *promotion in _cartInfo.promotionList)
        {
            if (promotion.satisfy)
            {
                //如果这么促销是不满足的  把这个促销的赠品从选择的赠品数组中移除
                for (GiftInfo *giftOrigin in promotion.gifts)
                {
                    //必须是同一个促销下的
                    if ([gift.giftId isEqualToString:giftOrigin.giftId] && gift.promotionId == promotion.promotionId)
                    {
                        bIn = YES;
                    }
                }
                
            }
        }
        
        if (!bIn)
        {
            //需要删除的
            [deletingGiftList addObject:gift];
        }
        
    }
    
    for (GiftInfo *deletingGift in deletingGiftList)
    {
        
//        //删除之前 把promotion 中的selectedGiftCount更新下
//        for (PromotionInfo *promotion in _cartInfo.promotionList)
//        {
//            if (promotion.promotionId == deletingGift.promotionId)
//            {
//                if (promotion.selectedGiftCount >= deletingGift.selectedCount)
//                {
//                    promotion.selectedGiftCount -= deletingGift.selectedCount;
//                }
//                else
//                {
//                    promotion.selectedGiftCount = 0;
//                }
//            }
//        }

        //赠品数组中gift
        [_selectedGiftList removeObject:deletingGift];
    }
    
    [deletingGiftList release];
}




#pragma mark - UI Action

-(void)logOutHandle
{
    emptyView.hidden=NO;
}

//直接进入检查订单
-(void)cartDirectToOrder
{
    m_DirectToOrder=YES;
}

- (void)doReloadCart
{
    [self showMainView];
    if (!cartOnLoading)
    {
        cartOnLoading = YES;
        [self.loadingView showInView:[UIApplication sharedApplication].keyWindow];
        [self otsDetatchMemorySafeNewThreadSelector:@selector(refreshCart) toTarget:self withObject:nil];
    }
    
}

-(void)reloadCart
{
    [self performSelectorOnMainThread:@selector(doReloadCart) withObject:nil waitUntilDone:NO];
}
-(void)detailToCart
{
    if (SharedDelegate.m_UpdateCart)
    {
        [self reloadCart];
    }
}

-(void)refreshCartInfo
{
    totalWeight.text=[NSString stringWithFormat:@"立减: ¥ %.2f",m_TotalPrice - _cartInfo.money];;
    int giftTotalCount=0;
    for (GiftInfo *gift in _selectedGiftList)
    {
        NSInteger giftCount = gift.selectedCount;
        giftTotalCount += giftCount;
    }
    if (giftTotalCount>0) {
        productsNum.text=[NSString stringWithFormat:@"共%d件(%d件赠品) %.2f kg",m_TotalCount+giftTotalCount,giftTotalCount,m_TotalWeight];
    }else{
        productsNum.text=[NSString stringWithFormat:@"共%d件 %.2f kg",m_TotalCount,m_TotalWeight];
    }
    
    bill.frame=CGRectMake(200, 28, 105, 28);
    
    bill.text=[NSString stringWithFormat:@"¥ %.2f",_cartInfo.money];
}

-(void)reSizeTableFooter:(CGRect)promotionTableFrame
{
    NSLog(@"底部增加 ：%f",promotionTableFrame.size.height);
    //    promotionTable.frame=promotionTableFrame;
    //    promotionTable.hidden=NO;
    NSLog(@"底部view %@",   NSStringFromCGRect(tableFooter.frame));
    m_CleanBtn.frame=CGRectMake(211, promotionTableFrame.size.height+5, 95, 32);
    submitBtn.frame=CGRectMake(20, promotionTableFrame.size.height+5, 280, 40);
    feeImageView.frame=CGRectMake(52, promotionTableFrame.size.height+60, 216, feeImageView.frame.size.height);
    NSLog(@"%@",NSStringFromCGRect(feeImageView.frame));
    tableFooter.frame=CGRectMake(0, 0, 320, promotionTableFrame.size.height + 170 /*promotionTableFrame.size.height+73+feeImageView.frame.size.height*/);
    cartTableView.tableFooterView = nil;
    cartTableView.tableFooterView = tableFooter;
    
    NSLog(@"底部view222 %@",   NSStringFromCGRect(tableFooter.frame));
    //    [cartTableView setContentOffset:CGPointMake(0,) animated:YES];
}
//显示满百免邮说明
-(void)showFeeText:(UIButton*)button
{
    
    CGRect rect=tableFooter.frame;
    float h=rect.size.height;
    float promotiontableHeight;
    //    if (!m_HasGift&&!m_hasRePromtion&&!m_hasCash)
    //    {
    promotiontableHeight=0;
    //    }
    //    else
    //    {
    //        promotiontableHeight=promotionTable.frame.size.height;
    //    }
    if (!button.selected)
    {
        button.selected=YES;
        feeImageView.frame=CGRectMake(52, feeImageView.top /*promotiontableHeight+60*/, 216, 303);
        feeImageView.image=[UIImage imageNamed:@"cart_fee_detail.png"];
        tableFooter.frame=CGRectMake(0, 0, 320, h+303-47);
    }
    else
    {
        feeImageView.frame=CGRectMake(52, feeImageView.top /*promotiontableHeight+60*/, 216, 47);
        feeImageView.image=[UIImage imageNamed:@"cart_fee.png"];
        tableFooter.frame=CGRectMake(0, 0, 320, h-303+47);
        button.selected=NO;
    }
    //    submitBtn.frame=CGRectMake(20, promotiontableHeight+5, 280, 40);
    //    m_CleanBtn.frame=CGRectMake(211, promotiontableHeight+5, 95, 32);
    
    cartTableView.tableFooterView=tableFooter;
    CGFloat height = cartTableView.contentSize.height - cartTableView.bounds.size.height;
    if (height<0)
    {
        height=0;
    }
    [cartTableView setContentOffset:CGPointMake(0, height) animated:YES];
}

- (void)refreshTableFooter
{
    //主要在这里显示促销的信息
    
    for (UIView *subView in [tableFooter subviews])
    {
        if ([subView isKindOfClass:[PromotionReduceView class]] || [subView isKindOfClass:[AddGiftButton class]] || [subView isKindOfClass:[PromotionGiftCellView class]])
        {
            [subView removeFromSuperview];
        }
    }
    
    //满减信息
    CGFloat yValue = 0.0;
    for (PromotionInfo *promotion in _cartInfo.getPromotionOfReduce)
    {
        
        NSString *promotionResult = promotion.promotionResult;
        //        if (promotion.promotionResult.length == 0)
        //        {
        //            ConditionInfo *condictInfo = promotion.conditions[0];
        //            CGFloat needMoney = condictInfo.requirement-promotion.totalMoneyInPromotion;
        //            promotionResult = [NSString stringWithFormat:@"活动商品还差%.2f便可参加促销", needMoney];
        //        }
        PromotionReduceView *reduceView = [[PromotionReduceView alloc] initWithFrame:CGRectMake(0, yValue, 320, 40)
                                                                       promotionDesc:promotion.promotionDesc
                                                                     promotionResult:promotionResult];
        
        [tableFooter addSubview:reduceView];
        [reduceView release];
        yValue += 40;
    }
    
    //选择赠品button
    if (_cartInfo.hasGift)
    {
        AddGiftButton *addGiftBtn = [[AddGiftButton alloc] initWithFrame:CGRectMake(0, yValue, 320, 40)];
        [addGiftBtn addTarget:self action:@selector(enterSelectGift:) forControlEvents:UIControlEventTouchUpInside];
        [tableFooter addSubview:addGiftBtn];
        [addGiftBtn release];
        
        yValue += 40;
    }
    
    //赠品
    for (NSInteger i = 0; i < _selectedGiftList.count; ++i)
    {
        GiftInfo *gift = _selectedGiftList[i];
        PromotionGiftCellView *giftView = [[PromotionGiftCellView alloc] initWithFrame:CGRectMake(0, yValue, 320, 40) giftName:gift.giftName count:gift.selectedCount];
        giftView.gift = gift;
        [giftView addTarget:self action:@selector(deletingGift:) index:i];
        [tableFooter addSubview:giftView];
        [giftView release];
        
        yValue += 40;
    }
    
    [self reSizeTableFooter:CGRectMake(0, 0, 0, yValue)];
}

-(void)refreshCartNum
{
    [SharedDelegate clearCartNum];
    if (m_TotalCount)
    {
        [SharedDelegate setCartNum:m_TotalCount];
    }
}

-(void)requsetSuccess
{
    DebugLog(@"－－－－> %s 开始",__func__);
    cartOnLoading=NO;
    if (m_TotalCount > 0)
    {
        emptyView.hidden=YES;
        if (!cartTableView.editing)
        {
            accountBtn.hidden=NO;
        }
        editBtn.hidden=NO;
        cartTableView.hidden=NO;
    }
    else
    {
        [self.loadingView hide];
        emptyView.hidden=NO;
        if (cartTableView.editing)
        {
            if (editBtn.tag==0)
            {
                [self editBtn:editBtn];
            }
        }
        cartTableView.hidden=YES;
        accountBtn.hidden=YES;
        editBtn.hidden=YES;
    }
    accountBtn.enabled=YES;

    [cartTableView reloadData];
    [self refreshTableFooter];
    [self refreshCartInfo];
    
    
    if (m_DirectToOrder)
    {
        m_DirectToOrder=NO;
		[self performSelector:@selector(buyBtnClick) withObject:nil afterDelay:0];
	}
}


-(void)countButtonTap:(UIControl *)button withEvent:(UIEvent *)event {
    NSIndexPath *indexPath=[cartTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:cartTableView]];//获得NSIndexPath
    if (indexPath==nil)
    {
        return;
    }
    else
    {
        m_CurrentIndex=[indexPath row];//获得选择的第几行
        [self setProductCount];
    }
}

//选择购买商品数量
-(void)setProductCount
{
    //点击进入地区选择
    m_ActionSheet = [[OTSActionSheet alloc]initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
                                                delegate:self
                                       cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                       otherButtonTitles:nil];
    [m_ActionSheet setTag:ACTION_SHEET_CHOOSE_COUNT];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(18, 5, 50, 30)];//取消按钮
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"red_short_btn.png"] forState:0];
    [cancelBtn addTarget:self action:@selector(closeActionSheet) forControlEvents:1];
    [cancelBtn setTitle:@"取消" forState:0];
    [m_ActionSheet addSubview:cancelBtn];
    [cancelBtn release];
    
    UIButton *finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(252, 5, 50, 30)];//完成按钮
    [finishBtn setBackgroundImage:[UIImage imageNamed:@"red_short_btn.png"] forState:0];
    [finishBtn addTarget:self action:@selector(finishBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [finishBtn setTitle:@"完成" forState:0];
    [m_ActionSheet addSubview:finishBtn];
    [finishBtn release];
    if (m_PickerView==nil) {
        m_PickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 320, 216)];
        m_PickerView.dataSource=self;
        m_PickerView.delegate=self;
        m_PickerView.showsSelectionIndicator=YES;
    }
    [m_ActionSheet addSubview:m_PickerView];
    [self initPickerView:m_PickerView];
    
    [m_ActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    [UIView setAnimationsEnabled:NO];
    [m_ActionSheet release];
    [m_PickerView reloadAllComponents];
}

-(void)initPickerView:(UIPickerView *)pickerView
{
    [pickerView reloadComponent:0];
    NSMutableDictionary *mDictionary = [OTSUtility safeObjectAtIndex:m_CurrentIndex inArray:self.cartProductArr];
    int currentCount = [mDictionary[@"selectCount"] intValue];
    int minCount = [self getProductMinCountAtIndex:m_CurrentIndex];
    if (currentCount - minCount >= 0)
    {
        [pickerView selectRow:currentCount-minCount inComponent:0 animated:YES];
    }
}

//取消
-(void)closeActionSheet
{
    [m_ActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

//完成
-(void)finishBtnClicked:(id)sender
{
    [m_ActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    NSMutableDictionary *mDictionary=
    [OTSUtility safeObjectAtIndex:m_CurrentIndex inArray:self.cartProductArr];
    int currentCount=[[mDictionary objectForKey:@"selectCount"] intValue];
    //    ProductInfo *aproduct=[mDictionary objectForKey:@"product"];
    NSInteger selectedRow=[m_PickerView selectedRowInComponent:0];
    int minCount=[self getProductMinCountAtIndex:m_CurrentIndex];
    m_ProductCount=minCount+selectedRow;
    if (currentCount==m_ProductCount)
    {
        return;
    }
    
    [self updateLocalProductCount];
    
}

-(void)updateLocalProductCount
{
    
    NSDictionary *dic = self.cartProductArr[m_CurrentIndex];
    ProductInfo *productInfo = dic[@"product"];
    YWLocalCatService *localCarSer = [[YWLocalCatService alloc] init];
    [localCarSer updateProductNum:productInfo.productId productNum:m_ProductCount];
    [localCarSer release];
    
    [self refreshCart];
}


-(void)cleanCart
{
    UIAlertView *alert=[[OTSAlertView alloc] initWithTitle:nil message:@"确认要全部删除购物车里的商品？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认删除", nil];
    [alert setTag:ALERTVIEW_TAG_DELETE_CONFIRM];
    [alert show];
    [alert release];
}


//编辑/完成
-(void)editBtn:(UIButton*)button
{
    if ([button tag] == 1) {
        [self enterEditStatus];
    } else {
        [self exitEditStatus];
    }
}

//进入编辑状态
-(void)enterEditStatus
{
    [editBtn setBackgroundImage:[UIImage imageNamed:@"title_left_done.png"] forState:UIControlStateNormal];
    [editBtn setTitle:@"" forState:UIControlStateNormal];
    [editBtn setBackgroundImage:[UIImage imageNamed:@"title_left_done_sel.png"] forState:UIControlStateHighlighted];
    [editBtn setTag:0];
    
    
    [cartTableView setEditing:YES];
    [cartTableView reloadData];
    //    promotionTable.userInteractionEnabled=NO ;
    [accountBtn setHidden:YES];
    [submitBtn setHidden:YES];
    [m_CleanBtn setHidden:NO];
}

//退出编辑状态
-(void)exitEditStatus
{
    [editBtn setBackgroundImage:[UIImage imageNamed:@"title_left_normal_btn.png"] forState:UIControlStateNormal];
    [editBtn setBackgroundImage:[UIImage imageNamed:@"title_left_normal_btn_sel.png"] forState:UIControlStateHighlighted];
    [editBtn setTitle:@"修改" forState:UIControlStateNormal];
    [editBtn setTag:1];
    
    [cartTableView setEditing:NO];
    //    promotionTable.userInteractionEnabled=YES ;
    [cartTableView reloadData];
    [accountBtn setHidden:NO];
    [submitBtn setHidden:NO];
    [m_CleanBtn setHidden:YES];
}


-(int)getProductMinCountAtIndex:(int)index
{
    //返回该索引商品的最小购买数
    NSDictionary *dic = self.cartProductArr[index];
    ProductInfo *product = dic[@"product"];
    
    NSInteger minCount = 1;
    
    //如果起购
    if (product.leastCount > 0)
    {
        minCount = product.leastCount;
    }
    return minCount;
}






//最近浏览
-(void)goBrowseing:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openBrowse" object:nil];
}

//我的收藏
-(void)goFavoriteing:(id)sender
{
    if ([GlobalValue getGlobalValueInstance].ywToken != nil)
    {
        MyFavorite *myFavorite = [[[MyFavorite alloc]initWithNibName:@"MyFavorite" bundle:nil] autorelease];
        myFavorite->fromTag = FROM_CART_TO_FAVORITE;
        [self pushVC:myFavorite animated:YES];
    }
    else
    {
        [SharedDelegate enterUserManageWithTag:12];
    }
}
//显示购物车主view
-(void)showMainViewFromTabbarMaskAnimated:(BOOL)aAnimated
{
    [self showMainView];
    if (aAnimated) {
        [SharedDelegate.tabBarController removeViewControllerWithAnimation:[OTSNaviAnimation animationPushFromLeft]];
    } else {
        [SharedDelegate.tabBarController removeViewControllerWithAnimation:nil];
    }
}

-(void)showMainView
{
    [self removeAllMyVC];
    if (cartTableView.editing)
    {
        editBtn.tag=0;
        [self editBtn:editBtn];
    }
    
    //从vc移除已失效，许聪tabbar上面去移除
    [cartTableView ScrollMeToTopOnly];
}

-(void)buyBtnClick
{
    if ([GlobalValue getGlobalValueInstance].ywToken==nil)
    {
        [SharedDelegate enterUserManageWithTag:100];
    }
    else
    {
        [self enterCheckOrder];
    }
}

//进入检查订单
-(void)enterCheckOrder
{
    
    if ([GlobalValue getGlobalValueInstance].ywToken!=nil)
    {
        [self enterCheckOrder:m_HasAddress];
    }
    else
    {
        [SharedDelegate enterUserManageWithTag:100];
    }
}
//
-(void)enterCheckOrderByAddress
{
    [self enterCheckOrder:m_HasAddress];
}
-(void)enterCheckOrder:(BOOL)hasAddress
{
    if (hasAddress)
    {
        [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
    }
    
    if (_bSomeProductNoStock)
    {
        [self showError:@"存在缺货商品，请删除后重新下单"];
        return;
    }
    
    
    [self removeSubControllerClass:[CheckOrder class]];
    
    CheckOrder* checkOrderVC = [[[CheckOrder alloc]initWithNibName:@"CheckOrder" bundle:nil] autorelease];
    [checkOrderVC setM_HasAddress:hasAddress];
    //    [checkOrderVC setM_UserSelectedGiftArray:m_SelectedGift];
    //    if ([self.distributionArray count] > 0) {
    //        [checkOrderVC setDistributionArray:distributionArray];
    //        [checkOrderVC setDistributionError:distributionError];
    //    }
    checkOrderVC.isFullScreen = YES;
    checkOrderVC.orderProducts = self.cartProductArr;//yao wang
    checkOrderVC.selectedGiftList = _selectedGiftList;
    checkOrderVC.cartInfo = _cartInfo;
    //    [GlobalValue getGlobalValueInstance].currentOrderProductList = self.cartProductArr;//当前要处理的订单商品，在checkorder 时 选地址回来，orderProductList 会丢，所以存一份全剧变量
    
    
    [SharedDelegate.tabBarController addViewController:checkOrderVC withAnimation:[OTSNaviAnimation animationPushFromRight]];
    [checkOrderVC->m_ScrollView ScrollMeToTopOnly];
}

//跳转到地址列表页
-(void)enterGoodsReceiverList
{
    GoodReceiver* goodRecieverVC = [[[GoodReceiver alloc]initWithNibName:@"GoodReceiver" bundle:nil] autorelease];
    [goodRecieverVC setM_FromTag:FROM_CHECK_ORDER];
    [goodRecieverVC setIsFromCart:YES];
    [goodRecieverVC setBackToCart:YES];
    //    [goodRecieverVC setM_SelectedGift:m_SelectedGift];
    [goodRecieverVC setM_DefaultReceiverId:nil];
    [self pushVC:goodRecieverVC animated:YES fullScreen:YES];
}

- (void)enterSelectGift:(id)sender
{
    self.promotionVC = [[[PromotionViewController alloc] init] autorelease];
    self.promotionVC.giftPromotionList = [_cartInfo getPromotionOfGift];
    self.promotionVC.selectedGiftList = _selectedGiftList;
    //    self.promotionVC.selectedGiftArray = m_SelectedGift;
    //    self.promotionVC.cartProductArray = m_ProductArray;
    
    TheStoreAppAppDelegate* delegate=(TheStoreAppAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.tabBarController.view.layer addAnimation:[OTSNaviAnimation animationMoveInFromTop] forKey:@"Reveal"];
    [delegate.tabBarController.view addSubview:self.promotionVC.view];
}

- (void)deletingGift:(id)sender
{
    UIButton *view = (UIButton *)sender;
    [_selectedGiftList removeObjectAtIndex:view.tag];
    
    [self doReloadCart];
}



#pragma mark error
-(void)toastShowString:(NSString *)string
{
    [self.loadingView showTipInView:self.view title:string];
    
    [UIView setAnimationsEnabled:NO];
}

-(void)showError:(NSString *)error
{
    [self.loadingView hide];
    [AlertView showAlertView:nil alertMsg:error buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
}


-(void)addError:(NSString*)error{
    [self.loadingView hide];
    [AlertView showAlertView:nil alertMsg:error buttonTitles:nil
                    alertTag:ALERTVIEW_TAG_COMMON];
}
-(void)netError
{
    cartOnLoading=NO;
    [self.loadingView hide];
    [AlertView showAlertView:nil alertMsg:@"网络异常，请检查网络配置..." buttonTitles:nil
                    alertTag:ALERTVIEW_TAG_COMMON];
}

#pragma mark - Delegate
#pragma mark alert delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch ([alertView tag]) {
        case ALERTVIEW_TAG_DELETE_CONFIRM:
            if (buttonIndex==1)
            {
                YWLocalCatService *service=[[YWLocalCatService alloc] init];
                [service cleanLocalCart];
                [service release];
                [self refreshCart];
            }
            break;
        default:
            break;
    }
}



-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch ([actionSheet tag]) {
        case ACTION_SHEET_CHOOSE_COUNT: {
            break;
        }
        case ACTION_SHEET_SETTLEMENT: {
            if (buttonIndex==1)
            {
                [self enterCheckOrder];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark table datasource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cartProductArr count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CartCell*cell=[tableView dequeueReusableCellWithIdentifier:@"CartCell"];
    if (cell==nil)
    {
        cell=[[[CartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CartCell"] autorelease];
    }
    cell.mountBtn.hidden = NO;
    cell.priceHeadLabel.hidden = NO;
    cell.tag = CAN_EDIT_CELL;
    ProductInfo *productVO = nil;
    NSString *count;
    cell.promotionLab.hidden=YES;
    // cell复用的初始化
    [cell.NNArrow setImage:[UIImage imageNamed:@""]];
    [cell setBackgroundView:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    
    
    //商品
    [cell.mountBtn setBackgroundImage:[UIImage imageNamed:@"cart_number.png"] forState:UIControlStateNormal];
    [cell.mountBtn setEnabled:YES];
    
    NSMutableDictionary *mDictionary=[OTSUtility safeObjectAtIndex:[indexPath row] inArray:self.cartProductArr];
    productVO=[mDictionary objectForKey:@"product"];
    count=[mDictionary objectForKey:@"selectCount"];
    cell.giftLabel.hidden=YES;
    
    //如果当前库存小于最小起购值 就缺货
    if ([productVO.currentStore intValue] < [self getProductMinCountAtIndex:indexPath.row]) // == 0)
    {
        _bSomeProductNoStock = YES;
        [cell.mountBtn setTitle:@"已缺货" forState:UIControlStateNormal];
        [cell.mountBtn setTitle:@"已缺货" forState:UIControlStateDisabled];
        [cell.mountBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cell.mountBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [cell.mountBtn setTitle:[NSString stringWithFormat:@"%@",count] forState:UIControlStateNormal];
        [cell.mountBtn setTitle:[NSString stringWithFormat:@"%@",count] forState:UIControlStateDisabled];
        [cell.mountBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell.mountBtn addTarget:self action:@selector(countButtonTap:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.seckillLab.hidden = YES;
    [cell.mountBtn setEnabled:YES];
    
    cell.productId = productVO.productId;
    //图片
    [cell downloadProductIcon:[productVO.mainImg4 isKindOfClass:[NSNull class]] ? nil : productVO.mainImg4];
    cell.tittleLabel.text=productVO.name;
    [cell.priceLab setText:[NSString stringWithFormat:@"￥%.2f",[[productVO price] floatValue]]];
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == cartTableView)
    {
        return YES;
    }
    return NO;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==cartTableView) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==cartTableView)
    {
        [self performInThreadBlock:^(){
            //从本地购物车删除
            NSMutableDictionary *mDictionary = [OTSUtility safeObjectAtIndex:indexPath.row inArray:self.cartProductArr];
            ProductInfo *productVO=[mDictionary objectForKey:@"product"];
            NSString *productId=[productVO productId];
            YWLocalCatService *service=[[YWLocalCatService alloc] init];
            [service deleteLocalCartByProductIdFromSqlite3:productId];
            [service release];
            
            //百分点统计
            [BfdAgent rmCart:nil itemId:[productVO productId] options:nil];
            
            //数据源也要删除对应的
            [self.cartProductArr removeObjectAtIndex:indexPath.row];
            
        } completionInMainBlock:^(){
            //重新获取本地购物车
            [self refreshCart];
        }];
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (tableView==cartTableView)
    {
        m_CurrentIndex=[indexPath row];
        
        NSDictionary *dic = self.cartProductArr[m_CurrentIndex];
        ProductInfo *productInfo = dic[@"product"];
        
        OTSProductDetail *productDetail=[[[OTSProductDetail alloc] initWithProductId:[productInfo.productId longLongValue] promotionId:nil fromTag:PD_FROM_OTHER] autorelease];
        productDetail.superVC=self;
        [self pushVC:productDetail animated:YES fullScreen:NO];
    }
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (tableView==cartTableView)
    {
        if (indexPath.section!=4)
        {
            return 102.0;
        }else
            return 44;
    }else {
        return 44;
    }
}

#pragma mark pickerView相关delegate和datasource
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *dic = self.cartProductArr[m_CurrentIndex];
    ProductInfo *product = dic[@"product"];
    
    NSInteger minCount = 1;
    //如果起购
    if (product.leastCount > 0)
    {
        minCount = product.leastCount;
    }
    return [NSString stringWithFormat:@"%d",row+minCount];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSDictionary *dic = self.cartProductArr[m_CurrentIndex];
    ProductInfo *product = dic[@"product"];
    
    NSInteger maxCount = [product.currentStore intValue];
    NSInteger minCount = 1;
    
    //如果有限购
    if (product.limitCount > 0)
    {
        maxCount = product.limitCount < [product.currentStore intValue] ?  product.limitCount : [product.currentStore intValue];
    }
    //如果起购
    if (product.leastCount > 0)
    {
        minCount = product.leastCount;
    }
    return  maxCount - minCount + 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 90;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

