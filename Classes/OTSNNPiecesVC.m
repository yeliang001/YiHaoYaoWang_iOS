//
//  OTSNNPiecesVC.m
//  TheStoreApp
//
//  Created by towne on 13-1-14.
//
//

#import "OTSNNPiecesVC.h"
#import "OTSNaviAnimation.h"
#import "OTSNNPiecesTableCell.h"
#import "ProductVO.h"
#import "ProductService.h"
#import "CartService.h"
#import "GlobalValue.h"
//#import "MBProgressHUD.h"
#import "OTSLoadingView.h"
#import "UITableView+LoadingMore.h"
#import "NormResult.h"
#import "TheStoreAppAppDelegate.h"
#import "OTSProductDetail.h"
#import "DoTracking.h"

#define  TOPVIEWHIGHT    60.0
#define  OPERATIONHIGHT  120.0
#define  NOTFINDNNPIECES   @"无法打开N元N件列表"

@interface OTSNNPiecesVC ()
@property(nonatomic,retain) OTSNNPiecesTopView *topView;
@property(nonatomic,retain) UITableView *listTableView;
@property(nonatomic,retain) UIView  *mainView;
@property(nonatomic,retain) NSMutableArray *productsArray; //由网络获取的促销商品数据
@property(nonatomic,retain) MobilePromotionDetailVO *promotionDVO;
@property(nonatomic,retain) NormResult * isExistOptional; //购物车中是否有n元n购
@end

@implementation OTSNNPiecesVC
@synthesize topView;
@synthesize listTableView;
@synthesize mainView;
@synthesize productsArray;
@synthesize promotionDVO;
@synthesize isExistOptional;
@synthesize topviewproductsArray;
@synthesize promotionId;
@synthesize promotionLevelId;
@synthesize nnpiecesTitle;
@synthesize showCart;
@synthesize fromCart;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidUnload
{
    self.listTableView = nil;
    self.mainView = nil;
    self.productsArray = nil;
    self.promotionDVO = nil;
    self.isExistOptional = nil;
    self.topviewproductsArray = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    self.listTableView = nil;
    self.mainView = nil;
    self.productsArray = nil;
    self.promotionDVO = nil;
    self.isExistOptional = nil;
    self.topviewproductsArray = nil;
    
    self.promotionId = nil;
    self.promotionLevelId = nil;
    self.nnpiecesTitle = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self inittitletop];
    [self inittable];
    [self requestAsync];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetNNPiecesTop) name:@"resetNNPiecesTop" object:nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)inittitletop
{
    [self.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    //返回
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
    
    //标题栏
	UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(85, 0, 150, 44)];
	[title setText:self.nnpiecesTitle];
	[title setBackgroundColor:[UIColor clearColor]];
	title.textColor = [UIColor whiteColor];
	[title setTextAlignment:NSTextAlignmentCenter];
	[title setNumberOfLines:2];
	title.font = [UIFont boldSystemFontOfSize:18.0];
	title.shadowColor = [UIColor darkGrayColor];
	title.shadowOffset = CGSizeMake(1.0, -1.0);
    [self.view addSubview:title];
    [title release];
    
    currentPageIndex = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nnpiecesLoadStatus) name:@"NNPiecesLoad" object:nil];
    
    self.mainView = [[[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44.0)] autorelease];
    [self.view addSubview:self.mainView];
    
    if([self.topviewproductsArray count] == 0){
        self.topviewproductsArray = [[[NSMutableArray alloc] init] autorelease];
    }
    else
        self.fromCart = YES;
}

-(void)inittable
{
    self.listTableView = [[[UITableView alloc] init] autorelease];
    [self.listTableView setBackgroundColor:[UIColor clearColor]];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    [self.view addSubview:self.listTableView];
}


-(void)requestAsync{
    
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.mode = MBProgressHUDAnimationFade;
    //    hud.labelText = @"正在加载";
    if (!isLoadingMore) {
        [self showLoading];
    }
    
    [self performInThreadBlock:^(){
        NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
        ProductService *pServ=[[[ProductService alloc] init] autorelease];
        NSNumber * pagesize = [NSNumber numberWithInt:10];
        NSNumber * type = [NSNumber numberWithInt:2];
        NSNumber * currentpage = [NSNumber numberWithInt:currentPageIndex];
        //        self.promotionId= [NSNumber numberWithInt:60163];
        //        self.promotionLevelId = [NSNumber numberWithInt:56035];
        self.promotionDVO= [pServ getPromotionDetailPageVO:[GlobalValue getGlobalValueInstance].trader promotionId:self.promotionId promotionLevelId:self.promotionLevelId provinceId:[GlobalValue getGlobalValueInstance].provinceId type:type currentPage:currentpage pageSize:pagesize token:[GlobalValue getGlobalValueInstance].token];
        
        if (isLoadingMore) {
            [self.productsArray addObjectsFromArray:[[self.promotionDVO pageProductVOList] objList]];
        }else {
            [self.productsArray removeAllObjects];
            self.productsArray = [[self.promotionDVO pageProductVOList] objList];
        }
        productTotalCount = [[self.promotionDVO.pageProductVOList totalSize] intValue];
        [pool drain];
    } completionInMainBlock:^(){
        
        [self hideLoading];
        
        if(!isLoadingMore)
        {
            if (self.productsArray) {
                [self updateTopScrollView];
            }
            else
            {
                [self showBarTip:NOTFINDNNPIECES];
            }
        }
        [self.listTableView reloadData];
        [self hideLoadingMore];
    }];
}

-(void)hideLoadingMore
{
    [self.listTableView setTableFooterView:nil];
    isLoadingMore=NO;
}

-(void)showInfo:(NSString *)info
{
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    [self hideLoading];
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:info delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    [self.view.superview.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:@"Reveal"];
    //    [self removeSelf];
    //    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

//重置n元n件顶部数组
-(void)resetNNPiecesTop
{
    [self.topviewproductsArray removeAllObjects];
    [self updateTopScrollView];
}

//登录以后刷新&&加满以后刷新
-(void)nnpiecesLoadStatus
{
    //这里需要动态的判断一下购物车是否存在n元n件活动
    [self showLoading];
    [self performInThreadBlock:^(){
        NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
        CartService *service = [[[CartService alloc] init] autorelease];
        self.isExistOptional = [service isExistOptionalInCart:[GlobalValue getGlobalValueInstance].token provinceId:[GlobalValue getGlobalValueInstance].provinceId promotionId:self.promotionId promotionLevelId:self.promotionLevelId];
        [pool drain];
    } completionInMainBlock:^(){
        self.fromCart = NO;
        [self hideLoading];
        [self updateTopScrollView];
    }];
}

//登录以后刷新&&加满以后刷新
-(void)nnpiecesLoadStatus:(NSString *)tips
{
    //这里需要动态的判断一下购物车是否存在n元n件活动
    [self showLoading];
    [self performInThreadBlock:^(){
        NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
        CartService *service = [[[CartService alloc] init] autorelease];
        self.isExistOptional = [service isExistOptionalInCart:[GlobalValue getGlobalValueInstance].token provinceId:[GlobalValue getGlobalValueInstance].provinceId promotionId:self.promotionId promotionLevelId:self.promotionLevelId];
        [pool drain];
    } completionInMainBlock:^(){
        self.fromCart = NO;
        [self hideLoading];
        [self updateTopScrollView];
        if (tips) {
            [self showShortTip:tips];
        }
    }];
}


//加载更多
-(void)getMoreProduct
{
    currentPageIndex++;
    isLoadingMore=YES;
    [self requestAsync];
}


-(void)setTableView:(NSNumber *) hight
{
    [self.listTableView setFrame:CGRectMake(0, OPERATIONHIGHT+[hight floatValue], self.view.frame.size.width, self.view.frame.size.height-OPERATIONHIGHT - [hight floatValue])];
    [self.listTableView reloadData];
}

#pragma mark  OTSNNPiecesTopProductsDelegate
-(void)iNNPiecesProductClicked:(NSNumber *)index
{
    DebugLog(@"iNNPiecesProductClicked");
    [self.topviewproductsArray removeObjectAtIndex:[index integerValue]];
    [self updateTopScrollView];
}

-(void)iNNPiecesProductIsNull
{
    DebugLog(@"iNNPiecesProductIsNull");
}

-(void)iNNPiecesProductIsInOperation:(NSNumber *) hight;
{
    
    [self setTableView:hight];
    //    CGRect frame = CGRectMake(0, OPERATIONHIGHT+[hight floatValue], self.view.frame.size.width, self.view.frame.size.height - OPERATIONHIGHT - [hight floatValue]);
    //    [UIView beginAnimations:@"Curl" context:nil];//动画开始
    //    [UIView setAnimationDuration:2];
    //    [UIView setAnimationDelegate:self];
    //    int y = (self.view.frame.size.height - OPERATIONHIGHT - [hight floatValue] )/2;
    //    self.listTableView.layer.position = CGPointMake(self.view.frame.size.width / 2, y);
    //    [UIView commitAnimations];
    [self.listTableView.layer addAnimation:[OTSNaviAnimation animationFade] forKey:nil];
}

-(void)setLine:(NSNumber *) hight
{
    // add a line to list table
    UIView *line = [self.view viewWithTag:2013];
    [line removeFromSuperview];
    CGRect lineRc = CGRectMake(0, OPERATIONHIGHT+[hight floatValue], self.listTableView.frame.size.width, 1);
    
    line = [[[UIView alloc] initWithFrame:lineRc] autorelease];
    line.backgroundColor = [UIColor lightGrayColor];
    line.tag = 2013;
    [self.view addSubview:line];
}


-(void)iNNPiecesAddToCart
{
    __block AddProductResult * __normResult = nil;
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.mode = MBProgressHUDAnimationFade;
    //    hud.labelText = @"正在加载";
    [self showLoading];
    [self performInThreadBlock:^(){
        NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
        NSMutableArray * promIDS = [[[NSMutableArray alloc]init] autorelease];
//        NSMutableArray * promLevIDS = [[[NSMutableArray alloc]init] autorelease];
        NSMutableArray * productIDS = [[[NSMutableArray alloc]init] autorelease];
        NSMutableArray * productMercIDS = [[[NSMutableArray alloc]init] autorelease];
        NSMutableArray * productNumIDS = [[[NSMutableArray alloc]init] autorelease];
        
        if ([GlobalValue getGlobalValueInstance].token != nil){
            for (int i =0; i<[self.topviewproductsArray count]; i++) {
                ProductVO *vo = [self.topviewproductsArray objectAtIndex:i];
                [promIDS addObject:vo.promotionId];
//                [promLevIDS addObject:vo.promotionLevelId];
                [productIDS addObject:vo.productId];
                [productMercIDS addObject:vo.merchantId];
                [productNumIDS addObject:[NSNumber numberWithInt:1]];
                
                // 分别统计每个产品加入购物车
                JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_AddCart extraPramaDic:nil] autorelease];
                [prama setProductId:vo.productId];
                [prama setMerchant_id:[NSString stringWithFormat:@"%@",vo.merchantId]];
                [DoTracking doJsTrackingWithParma:prama];
            }
            CartService *cServ=[[[CartService alloc] init] autorelease];
            __normResult=[[cServ addOptionalProduct:[GlobalValue getGlobalValueInstance].token productIds:productIDS merchantIds:productMercIDS quantitys:productNumIDS promotionIds:promIDS] retain];
            
//            __normResult = [[cServ addOptional:[GlobalValue getGlobalValueInstance].token promotionIds:promIDS promotionLevelIDs:promLevIDS productIds:productIDS promotionGiftMerchantIDs:productMercIDS promotionGiftNums:productNumIDS] retain];
        }
        
        
        [pool drain];
    } completionInMainBlock:^(){
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        [self hideLoading];
        if ([GlobalValue getGlobalValueInstance].token == nil)
        {
            [SharedDelegate enterUserManageWithTag:14];
            
        }
        else if (__normResult==nil || [__normResult isKindOfClass:[NSNull class]]) {
            
            [self showInfo:@"网络异常，请检查网络配置..."];
            
        }
        else if([[__normResult resultCode] intValue]==1)
        {
            //更新购物车
//            __block CartVO *carVo;
            __block int ProNumber;
            [self performInThreadBlock:^(){
                NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                CartService *service = [[[CartService alloc] init] autorelease];
//                carVo = [(CartVO*)[service getSessionCart:[GlobalValue getGlobalValueInstance].token] retain];
                ProNumber = [service countSessionCart:[GlobalValue getGlobalValueInstance].token siteType: [NSNumber numberWithInt:1]];

                [pool drain];
            } completionInMainBlock:^(){
//                int ProNumber = 0;
//                if (carVo && ![carVo isKindOfClass:[NSNull class]])
//                {
//                    ProNumber = [carVo.totalquantity intValue];
//                }
                [SharedDelegate clearCartNum];
                if (ProNumber > 0)
                {
                    [SharedDelegate setCartNum:ProNumber];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChanged" object:nil];
//                OTS_SAFE_RELEASE(carVo);
                self.showCart = YES;
                [self nnpiecesLoadStatus:@"加入成功"];
            }];
        }
        else
        {
            [self showBarTip:[__normResult errorInfo]];
        }
        OTS_SAFE_RELEASE(__normResult);
    }];
}

-(void)iNNPiecesUpdateToCart
{
    __block AddProductResult * __normResult = nil;
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.mode = MBProgressHUDAnimationFade;
    //    hud.labelText = @"正在加载";
    [self showLoading];
    [self performInThreadBlock:^(){
        NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
        NSMutableArray * promIDS = [[[NSMutableArray alloc]init] autorelease];
//        NSMutableArray * promLevIDS = [[[NSMutableArray alloc]init] autorelease];
        NSMutableArray * productIDS = [[[NSMutableArray alloc]init] autorelease];
        NSMutableArray * productMercIDS = [[[NSMutableArray alloc]init] autorelease];
        NSMutableArray * productNumIDS = [[[NSMutableArray alloc]init] autorelease];
        
        if ([GlobalValue getGlobalValueInstance].token != nil){
            for (int i =0; i<[self.topviewproductsArray count]; i++) {
                ProductVO *vo = [self.topviewproductsArray objectAtIndex:i];
                [promIDS addObject:[NSString stringWithFormat:@"%@_%@_optional",promotionId,promotionLevelId]];
//                [promLevIDS addObject:self.promotionLevelId];
                [productIDS addObject:vo.productId];
                [productMercIDS addObject:vo.merchantId];
                [productNumIDS addObject:[NSNumber numberWithInt:1]];
                
                // 分别统计每个产品加入购物车
                JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_AddCart extraPramaDic:nil] autorelease];
                [prama setProductId:vo.productId];
                [prama setMerchant_id:[NSString stringWithFormat:@"%@",vo.merchantId]];
                [DoTracking doJsTrackingWithParma:prama];
            }
            CartService *cServ=[[[CartService alloc] init] autorelease];
            __normResult=[[cServ addOptionalProduct:[GlobalValue getGlobalValueInstance].token productIds:productIDS merchantIds:productMercIDS quantitys:productNumIDS promotionIds:promIDS] retain];

//            __normResult = [[cServ updateOptional:[GlobalValue getGlobalValueInstance].token promotionIds:promIDS promotionLevelIDs:promLevIDS productIds:productIDS promotionGiftMerchantIDs:productMercIDS promotionGiftNums:productNumIDS] retain];
        }
        [pool drain];
    } completionInMainBlock:^(){
        
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        [self hideLoading];
        
        if ([GlobalValue getGlobalValueInstance].token == nil)
        {
            [SharedDelegate enterUserManageWithTag:14];
            
        }
        else if (__normResult==nil || [__normResult isKindOfClass:[NSNull class]]) {
            
            [self showInfo:@"网络异常，请检查网络配置..."];
            
        }
        else if([[__normResult resultCode] intValue]==1)
        {
            //更新购物车
//            __block CartVO *carVo;
            __block int ProNumber=0;
            [self performInThreadBlock:^(){
                NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                CartService *service = [[[CartService alloc] init] autorelease];
//                carVo = [(CartVO*)[service getSessionCart:[GlobalValue getGlobalValueInstance].token] retain];
                ProNumber = [service countSessionCart:[GlobalValue getGlobalValueInstance].token siteType: [NSNumber numberWithInt:1]];

                [pool drain];
            } completionInMainBlock:^(){
                int ProNumber = 0;
//                if (carVo && ![carVo isKindOfClass:[NSNull class]])
//                {
//                    ProNumber = [carVo.totalquantity intValue];
//                }
                [SharedDelegate clearCartNum];
                if (ProNumber > 0)
                {
                    [SharedDelegate setCartNum:ProNumber];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChanged" object:nil];
//                OTS_SAFE_RELEASE(carVo);
                self.showCart = YES;
                self.fromCart = NO;
                [self nnpiecesLoadStatus:@"替换成功"];
            }];
            
        }
        else
        {
            [self showBarTip:[__normResult errorInfo]];
        }
        OTS_SAFE_RELEASE(__normResult);
    }];
}

-(BOOL)iNNPiecesShowCart
{
    BOOL temp;
    
    if (self.fromCart)
        temp = YES;
    
    else if (self.showCart) {
        self.showCart = NO;
        temp = YES;
    }
    else
        temp = self.showCart;
    
    return temp;
}

-(void)iNNPiecesSetShowCart
{
    self.showCart = YES;
}

//返回按钮
-(void)returnBtnClicked:(id)sender
{
    [self.view.superview.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:@"Reveal"];
    [self removeSelf];
}


#pragma mark tableView相关delegate和dataSource
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==[self.productsArray count]-1 && [self.productsArray count]<productTotalCount) {
        if (!isLoadingMore) {
            [tableView loadingMoreWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40) target:self selector:@selector(getMoreProduct) type:UITableViewLoadingMoreForeIphone];
            isLoadingMore=YES;
        }
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 102;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProductVO  *productVO = [self.productsArray objectAtIndex:indexPath.row];
    //n元n件商品不传促销id
    OTSProductDetail *productDetail=[[[OTSProductDetail alloc] initWithProductId:[productVO.productId longValue] promotionId:nil fromTag:PD_FROM_OTHER] autorelease];
    [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
    [self pushVC:productDetail animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int objCount=[self.productsArray count];//实际的数目
    return objCount ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	[UIView setAnimationsEnabled:NO];
    ProductVO  *product = [OTSUtility safeObjectAtIndex:indexPath.row inArray:self.productsArray];
    OTSNNPiecesTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OTSNNPiecesTableCell"];
    if (cell == nil) {
        cell = [[[OTSNNPiecesTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OTSNNPiecesTableCell" delegate:self] autorelease];
    }
    
    [cell updateWithProductVO:product];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

#pragma mark OTSNNPiecesTableCellDelegate
-(void)accessoryButtonTap:(UIControl *)button withEvent:(UIEvent *)event
{
	NSIndexPath *indexPath=[self.listTableView indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.listTableView]];//获得NSIndexPath
	if (indexPath==nil)
    {
		return;
	}
    else
    {
        id obj = [self.productsArray objectAtIndex:[indexPath row]];
        if ([obj isKindOfClass:[ProductVO class]]) {
            ProductVO *productVO= obj;
            if ([productVO.canBuy isEqualToString:@"true"])
            {
                //添加商品到列表,判断当前top数组小于条件值
                if ([self.topviewproductsArray count] <  [[self.promotionDVO conditionValue] intValue])
                {
                    [self.topviewproductsArray insertObject:obj atIndex:0];
                    if ([self.topviewproductsArray count] == [[self.promotionDVO conditionValue] intValue])
                    {
                        [self nnpiecesLoadStatus];
                    }
                    else
                        [self updateTopScrollView];
                }
                else
                {
                    NSString *tipStr = [NSString stringWithFormat:@"该活动商品至多选择%d件", self.promotionDVO.conditionValue.intValue];
                    [self showBarTip:tipStr];
                }
            }
        }
	}
}

- (void) updateTopScrollView
{
    [self.topView removeFromSuperview];
    self.topView = [[[OTSNNPiecesTopView alloc] initWithFrame:CGRectMake(0, 0, 320, TOPVIEWHIGHT) MobilePromotionDetailVO:self.promotionDVO TopViewproducts:self.topviewproductsArray isExistOptionalInCart:self.isExistOptional MainView:self.mainView delegate:self] autorelease];
    [self.mainView addSubview:self.topView];
    [self setLine:self.topView.opHight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
