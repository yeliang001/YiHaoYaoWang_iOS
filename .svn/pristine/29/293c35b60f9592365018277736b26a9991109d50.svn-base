//
//  OTSPhoneWeRockInventoryVC.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-10-26.
//
//

#import "OTSPhoneWeRockInventoryVC.h"
#import "OTSPhoneWebRockInventoryCell.h"
#import "UIView+LoadFromNib.h"
#import "OTSWeRockService.h"
#import "GlobalValue.h"
#import "OTSUtility.h"
#import "StorageBoxVO.h"
#import "OTSBadgeView.h"
#import "TheStoreAppAppDelegate.h"
#import "Page.h"
#import "OTSWrBoxPageGetter.h"
#import "OTSPhoneFooterLoadingView.h"
#import "DoTracking.h"
#import "OTSProductDetail.h"

#define TABLE_VIEW_PAGE_SIZE     5

@interface OTSPhoneWeRockInventoryVC ()
{
    NSUInteger      _tablePageIndex;        // table view page index
    BOOL           _isFirstAppear;
}

@property (retain)  NSTimer     *timer;     // unused...
@property (retain) OTSBadgeView *badgeView;
@end

@implementation OTSPhoneWeRockInventoryVC

@synthesize tableView;
@synthesize emptyView = _emptyView;
@synthesize timer = _timer;
@synthesize badgeView = _badgeView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [self setIsFullScreen:YES];
    [super viewDidLoad];
    [tableView setFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, ApplicationWidth, ApplicationHeight-NAVIGATION_BAR_HEIGHT)];
    [_emptyView setFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, ApplicationWidth, ApplicationHeight-NAVIGATION_BAR_HEIGHT)];
    
    // add cart btn
    UIImageView *cartBtnBgIV = [[[UIImageView alloc] initWithImage:
                                 [UIImage imageNamed:@"wrInvNaviCartBg"]] autorelease];
    cartBtnBgIV.frame = CGRectOffset(cartBtnBgIV.frame, self.naviBar.frame.size.width - cartBtnBgIV.frame.size.width, 0);
    [self.naviBar addSubview:cartBtnBgIV];
    
    UIButton *cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *cartBtnImg = [UIImage imageNamed:@"wrInvNaviCart"];
    [cartBtn setImage:cartBtnImg forState:UIControlStateNormal];
    cartBtn.frame = cartBtnBgIV.frame;//CGRectMake(0, 0, cartBtnImg.size.width, cartBtnImg.size.height);
    [cartBtn addTarget:self action:@selector(enterCartAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar addSubview:cartBtn];
    
    int cartCount = [((UITabBarItem*)[SharedDelegate.tabBarController.tabBar.items objectAtIndex:2]).badgeValue intValue];
    self.badgeView = [[[OTSBadgeView alloc] initWithPosition:CGPointMake(30, 0) badgeNumber:cartCount] autorelease];
    self.badgeView.transform = CGAffineTransformMakeScale(.6f, .6f);
    [cartBtn addSubview:self.badgeView];
    
    // transparent button
    UIButton *cartMaskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cartMaskBtn.backgroundColor = [UIColor clearColor];
    cartMaskBtn.frame = cartBtn.frame;
    [cartMaskBtn addTarget:self action:@selector(enterCartAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar addSubview:cartMaskBtn];
    
    self.naviBar.titleLabel.text = @"礼物盒";
    
    //
    self.tableView.alwaysBounceVertical = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:NOTIFY_STORAGE_BOX_CHANGED object:nil];
    
    [self.naviBar.leftNaviBtn addTarget:self action:@selector(naviBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _isFirstAppear = YES;
}

-(void)naviBackAction:(id)sender
{
    [self popSelfAnimated:YES];
}

-(void)updateUINaviBarTitle
{
    self.naviBar.titleLabel.text = [NSString stringWithFormat:@"礼物盒 (%d)", [[OTSPhoneRuntimeData sharedInstance].boxPager totalPageItemsCount]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if (_isFirstAppear)
    {
        _isFirstAppear = NO;
    }
    else
    {
        [self refreshUI];
    }
}


-(void)refreshUI
{
    OTSWrBoxPageGetter *sharedBoxPager = [OTSPhoneRuntimeData sharedInstance].boxPager;
    int totalCount = sharedBoxPager.allPageItems.count;
    if (totalCount <= 0 && [sharedBoxPager isRunning])
    {
        self.emptyView.hidden=YES;
        self.tableView.hidden=YES;
        [self.loadingView showInView:self.view];
        return;
    }
    
    
    [self.loadingView hide];
    
    int num = [self currentCellCount];
    
    if (num<=0) {
        self.emptyView.hidden=NO;
        self.tableView.hidden=YES;
    } else {
        self.emptyView.hidden=YES;
        self.tableView.hidden=NO;
    }
    
    if (num >= totalCount)
    {
        //num = totalCount;
        self.tableView.tableFooterView = nil;
    }
    else
    {
        OTSPhoneFooterLoadingView * footerLoadingView = [OTSPhoneFooterLoadingView viewFromNibWithOwner:self];
        self.tableView.tableFooterView = footerLoadingView;
    }

    
    [self.tableView reloadData];
    
    [self updateUINaviBarTitle];
}



- (void)viewDidUnload
{
    [self setTableView:nil];

    [self setEmptyView:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [tableView release];
    
    [_timer invalidate];
    [_timer release];
    
    [_badgeView release];
    
    [_emptyView release];
    [super dealloc];
}

#pragma mark - Table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int num = [self currentCellCount];
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idStr = @"cell";
    
    OTSPhoneWebRockInventoryCell *cell = [aTableView dequeueReusableCellWithIdentifier:idStr];
    if (cell == nil)
    {
        cell = [OTSPhoneWebRockInventoryCell viewFromNibWithOwner:self];
    }
    
    cell.delegate = self;
    
    StorageBoxVO *item = [[OTSPhoneRuntimeData sharedInstance].boxPager.allPageItems objectAtIndex:indexPath.row];
    
    OTSRockBoxItemType itemType = [item.type intValue];
    [cell updateWithModel:item];
    
    switch (itemType)
    {
        case kRockBoxItemProduct:
        {
            
        }
            break;
            
        case kRockBoxItemTicket:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(int)currentCellCount
{
    int num = TABLE_VIEW_PAGE_SIZE * (_tablePageIndex + 1);
    int totalCount = [OTSPhoneRuntimeData sharedInstance].boxPager.allPageItems.count;
    num = num < totalCount ? num : totalCount;
    
    return num;
}

#pragma mark - scroll view delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGSize contentSize = scrollView.contentSize;
    CGSize scrollViewSize = scrollView.frame.size;
    CGPoint contentOffset = scrollView.contentOffset;
    
    if (contentOffset.y >= contentSize.height - scrollViewSize.height)
    {
        // to the bottom, request if needed
        DebugLog(@"to the bottom");
        
        int num = [self currentCellCount];
        int totalCount = [OTSPhoneRuntimeData sharedInstance].boxPager.allPageItems.count;
        
        if (num < totalCount)
        {
            _tablePageIndex++;
            [self refreshUI];
        }
        
    }
}

#pragma mark - table cell delegate
-(void)showRuleWithCell:(id)sender
{
    LOG_THE_METHORD;
    OTSPhoneWebRockInventoryCell *cell = (OTSPhoneWebRockInventoryCell*)sender;
    if ([cell.dataModel getItemType] == kRockBoxItemTicket)
    {
        CouponVO *couponVO = cell.dataModel.rockCouponVO.couponVO;
        CouponRule *couponrule = [[[CouponRule alloc] initWithCoupon:couponVO] autorelease];
        [self pushVC:couponrule animated:YES fullScreen:self.isFullScreen];
    }
}

-(void)addToCartWithProduct:(id)sender
{
    LOG_THE_METHORD;
    OTSPhoneWebRockInventoryCell *cell = (OTSPhoneWebRockInventoryCell*)sender;
    if ([cell.dataModel getItemType] == kRockBoxItemProduct)
    {
        //add the product
        ProductVO *product = cell.dataModel.rockProductV2.prodcutVO;
        if (product)
        {
            [self.loadingView showInView:self.view];
            
            __block AddProductResult *result = nil;
            
            [self performInThreadBlock:^{
                CartService* cSer=[[CartService alloc] init];
                result = [cSer addSingleProduct:[GlobalValue getGlobalValueInstance].token
                                                               productId:product.productId
                                                              merchantId:product.merchantId
                                                                quantity:[NSNumber numberWithInt:1]
                                                             promotionid:product.promotionId];
                [result retain];
                [cSer release];
                if (result.isSuccess && product.promotionId && [product.promotionId rangeOfString:@"landingpage"].location!=NSNotFound) {
                
                    [[OTSWeRockService myInstance]updateStroageBoxProductType:[GlobalValue getGlobalValueInstance].token promotionIdList:[NSMutableArray arrayWithObject:product.promotionId] productIdList:[NSMutableArray arrayWithObject:product.productId] productStatus:[NSNumber numberWithInt:1]];
                }
                
            } completionInMainBlock:^{
                
                [self.loadingView hide];
                
                if (result.isSuccess)
                {
                    [OTSUtility alert:@"加入购物车成功!"];
                    [SharedDelegate refreshCart];
                    
                    
                    // 修改状态
                    cell.dataModel.rockProductV2.rockProductType = [NSNumber numberWithInt:kRockProductHasAddCart];
                    [self.tableView reloadData];
                }
                else
                {
                    [OTSUtility alert:result.errorInfo];
                }
                
                [result release];
                
            }];
            //加入购物车数据统计
            JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_AddCart extraPramaDic:nil]autorelease];
            [prama setProductId:product.productId];
            [prama setMerchant_id:[NSString stringWithFormat:@"%@",product.merchantId]];
            [DoTracking doJsTrackingWithParma:prama];
        }
    }
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
    OTSPhoneWebRockInventoryCell *cell = (OTSPhoneWebRockInventoryCell*)[aTableView cellForRowAtIndexPath:indexPath];
    if ([cell.dataModel getItemType] == kRockBoxItemProduct)
    {
        ProductVO *product = cell.dataModel.rockProductV2.prodcutVO;
        if (product)
        {
            
            OTSProductDetail *productDetail=[[[OTSProductDetail alloc] initWithProductId:product.productId.longLongValue promotionId:product.promotionId fromTag:PD_FROM_OTHER] autorelease];
            [self pushVC:productDetail animated:YES fullScreen:YES];
        }
    }
}


#pragma mark - actions
-(void)enterCartAction:(id)sender
{
    LOG_THE_METHORD;
    
    [SharedDelegate enterCartRoot];
    
    if ([_quitTaget respondsToSelector:_quitAction])
    {
        [_quitTaget performSelector:_quitAction];
    }
}

-(void)setQuitTaget:(id)aTaget action:(SEL)anAction
{
    _quitTaget = aTaget;
    _quitAction = anAction;
}

-(IBAction)rockBtnClicked:(id)sender
{
    [self naviBackAction:nil];
}

@end
