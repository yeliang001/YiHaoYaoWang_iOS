//
//  OTSMaterialFLowVC.m
//  TheStoreApp
//
//  Created by yiming dong on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSMaterialFLowVC.h"
#import "OTSProductThumbScrollView.h"
#import "OTSUtil.h"
#import "OTSNaviAnimation.h"
#import "OTSMFInfoButton.h"
#import "OTSMfStackLabel.h"
#import "OTSImagedLabel.h"
#import "OTSMfQueryItemView.h"
#import <QuartzCore/QuartzCore.h>
#import "OrderV2.h"
#import "OrderItemVO.h"
#import "ProductVO.h"
#import "OrderStatusTrackVO.h"
#import "OTSMfServant.h"
#import "TheStoreAppAppDelegate.h"
#import "OTSLoadingView.h"
#import "OTSOrderMfVC.h"
#import "OTSMfImageCache.h"
#import "MyOrder.h"
#import "GlobalValue.h"
#import "OTSTablePullToLoadView.h"
#import "OTSNavigationBar.h"
#import "OTSBadgeView.h"
#import "GTMBase64.h"
#import "DoTracking.h"

#import "YWOrderService.h"
#import "UserInfo.h"
#import "ResultInfo.h"
#import "MyOrderInfo.h"
#import "OrderPackageInfo.h"
#import "OTSImageView.h"


typedef enum _EOtsMfRequestType
{
    KOtsMfRequestOrderList = 0
    , KOtsMfrequestOrderDetailForCurrentPage
    , KOtsMfRequestAllSubOrderStatus
}EOtsMfRequestType;


#define TIP_VIEW_TAG        OTS_MAGIC_TAG_NUMBER + 1
#define FOOTER_VIEW_TAG     OTS_MAGIC_TAG_NUMBER + 2

@interface OTSMaterialFLowVC ()

-(void)requestAsync:(id)aRequestObj;
-(void)requestAsync:(id)aRequestObj showLoading:(BOOL)aShowLoading;

@end 


@implementation OTSMaterialFLowVC

#pragma mark -

-(void)requestOrderListShowLoading:(BOOL)aShowLoading
{
    [self requestAsync:[NSNumber numberWithInt:KOtsMfRequestOrderList] showLoading:aShowLoading];
}

-(void)navigateBackAction
{
	HomePage *homePage = [SharedDelegate.tabBarController.viewControllers objectAtIndex:0];
	[homePage setUniqueScrollToTopFor:homePage->m_ScrollView];
    [self.view.superview.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:@"Reveal"];
    [self removeSelf];
}


#pragma mark -
-(void)assembleSubViews
{
    OTSNavigationBar* naviBar = [[[OTSNavigationBar alloc] initWithTitle:@"物流查询" 
                                                               backTitle:@"返回" 
                                                              backAction:@selector(navigateBackAction) 
                                                        backActionTarget:self] autorelease];
    
    [self.view addSubview:naviBar];
    
    // iphone5适配 - dym
    CGRect rc = self.view.frame;
    rc.origin.y = OTS_IPHONE_NAVI_BAR_HEIGHT;
    rc.size.height = self.view.frame.size.height -  OTS_IPHONE_NAVI_BAR_HEIGHT;

    _scrollView = [[UIScrollView alloc] initWithFrame:rc];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView setAlwaysBounceVertical:YES];
    [self.view addSubview:_scrollView];
    
    
    
    // tip view when there is no material flow
    UIView* tipView = [[[UIView alloc] initWithFrame:rc] autorelease];
    tipView.backgroundColor = [UIColor whiteColor];
    tipView.tag = TIP_VIEW_TAG;
    tipView.hidden = YES;
    [self.view addSubview:tipView];
    
    // empty image view
    UIImage* fmEmptyImg = [UIImage imageNamed:@"mf_empty"];
    UIImageView* fmEmptyIV = [[[UIImageView alloc] initWithImage:fmEmptyImg] autorelease];
    fmEmptyIV.frame = CGRectMake((tipView.frame.size.width - fmEmptyImg.size.width) / 2
                                 , 100
                                 , fmEmptyImg.size.width
                                 , fmEmptyImg.size.height);
    [tipView addSubview:fmEmptyIV];
    
    // label
    CGRect tipLblRc = tipView.bounds;
    tipLblRc.origin.x += 50;
    tipLblRc.size.width -= 100;
    tipLblRc.origin.y = CGRectGetMaxY(fmEmptyIV.frame) + 20;
    tipLblRc.size.height = 70;
    UILabel* tipLabel = [[[UILabel alloc] initWithFrame:tipLblRc] autorelease];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textColor = [UIColor lightGrayColor];
    tipLabel.font = [UIFont boldSystemFontOfSize:16.f];
    tipLabel.numberOfLines = 10;
    tipLabel.text = @"目前没有已发货订单，了解更\n多订单信息，可以到我的订单\n中查看～";
    [tipLabel sizeToFit];
    [tipView addSubview:tipLabel];
    
    // button
    UIButton* myOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    float btnW = 90;
    float btnH = 40;
    myOrderBtn.frame = CGRectMake((tipView.frame.size.width - btnW) / 2, CGRectGetMaxY(tipLblRc) + 5, btnW, btnH);
    [myOrderBtn setTitle:@"我的订单" forState:UIControlStateNormal];
    myOrderBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    
    [myOrderBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [myOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    UIImage* btnBgImg = [UIImage imageNamed:@"gray_btn.png"];
    [myOrderBtn setBackgroundImage:btnBgImg forState:UIControlStateNormal];

    [myOrderBtn addTarget:self action:@selector(gotoMyOrderAction) forControlEvents:UIControlEventTouchUpInside];
    [tipView addSubview:myOrderBtn];
    
}

-(void)gotoMyOrderAction
{
    MyOrder* myOrderVC = [[[MyOrder alloc]initWithNibName:@"MyOrder" bundle:nil] autorelease];
    [[GlobalValue getGlobalValueInstance] setToOrderFromPage:[NSNumber numberWithInt:0]];

    [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
    [self.view addSubview:myOrderVC.view];
}


#pragma mark -
-(void)requestAsync:(id)aRequestObj showLoading:(BOOL)aShowLoading
{
    if (aShowLoading)
    {
        [[OTSGlobalLoadingView sharedInstance] showInView:self.view];
    }
    
    // 开线程
    [self otsDetatchMemorySafeNewThreadSelector:@selector(threadMain:) 
                                       toTarget:self 
                                     withObject:aRequestObj];
    
}

-(void)requestAsync:(id)aRequestObj
{
    [self requestAsync:aRequestObj showLoading:YES]; 
}

-(void)threadMain:(id)aRequestObj
{
    int requestType = [aRequestObj intValue];
    switch (requestType)
    {
        case KOtsMfRequestOrderList:
        {
//            if (!servant.isRequesting) 
//            {
//                [servant requestOrderListPaged];
//            }
            
            NSDictionary *dic = @{@"pageindex":@"1",
                                  @"pagesize":@"100",
                                  @"orderstatus":@"0",
                                  @"token":[GlobalValue getGlobalValueInstance].ywToken,
                                  @"userid": [GlobalValue getGlobalValueInstance].userInfo.ecUserId,
                                  @"username":[GlobalValue getGlobalValueInstance].userInfo.uid};
            YWOrderService *oSer = [[YWOrderService alloc] init];
            ResultInfo * result = [oSer getMyOrder:dic];
            _orderList = [result.resultObject retain];
            NSLog(@"orderList %@",_orderList);
            
        }
            break;
            
        default:
            break;
    }
    
    [self performSelectorOnMainThread:@selector(updateUIAfterAction:) withObject:aRequestObj waitUntilDone:YES];
}

-(void)updateUIAfterAction:(id)aRequestObj
{
    int requestType = [aRequestObj intValue];
    switch (requestType)
    {
        case KOtsMfRequestOrderList:
        { 
            [[OTSGlobalLoadingView sharedInstance] hide];
            if (_orderList && _orderList.count > 0)
            {
                [self updateOrderTables];
            }
            else
            {
                [self.view viewWithTag:TIP_VIEW_TAG].hidden = NO;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
-(void)notifiedEnterOrderDetail:(NSNotification*)aNotify
{
    OrderV2* order = [aNotify object];
    
    OTSOrderMfVC* orderMfVC = [[[OTSOrderMfVC alloc] initWithNibName:@"OTSOrderMfVC" bundle:nil] autorelease];
    orderMfVC.theOrder = order;
    [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
    [self.view addSubview:orderMfVC.view];
}

#pragma deal Data
- (void)updateOrderTables
{

    [_scrollView removeAllSubviews];
    
    int yValue = 10;
    
    int i = 0;
    for (MyOrderInfo *myOrder in _orderList)
    {
        NSInteger height = 150;
        height +=  20 * myOrder.orderPackageArr.count;
        
        UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, height) style:UITableViewStyleGrouped];
        [tableView setTag:100+i];
        [tableView setBackgroundColor:[UIColor clearColor]];
        [tableView setBackgroundView:nil];
        [tableView setScrollEnabled:NO];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [tableView setScrollsToTop:NO];
        
        //为了适配iOS7
        if (ISIOS7)
        {
            tableView.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 1.0f)] autorelease];
        }
        [_scrollView addSubview:tableView];
        [tableView release];
        
        i++;
        yValue += height;
    }
    _scrollView.contentSize = CGSizeMake(320, yValue);
    
}



#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self assembleSubViews];
    
    

    
    [self requestAsync:[NSNumber numberWithInt:KOtsMfRequestOrderList]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiedEnterOrderDetail:) name:OTS_ENTER_ORDER_DETAIL object:nil];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_orderList release];

    [super dealloc];
}

#pragma mark - tv data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DebugLog(@"the orderCount is:%d",_orderList.count);

    return 3;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellStr = @"mfCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr] autorelease];
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [[cell viewWithTag:OTS_MAGIC_TAG_NUMBER] removeFromSuperview];
    
    
    MyOrderInfo *order = _orderList[tableView.tag - 100];
    if (indexPath.row == 0)
    {
        UILabel *orderIdLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 30)];
        orderIdLbl.backgroundColor = [UIColor clearColor];
        orderIdLbl.font = [UIFont systemFontOfSize:11];
        orderIdLbl.text = order.orderId;
        [cell.contentView addSubview:orderIdLbl];
        [orderIdLbl release];
        
        UILabel *timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(190, 0, 120, 30)];
        timeLbl.backgroundColor = [UIColor clearColor];
        timeLbl.font = [UIFont systemFontOfSize:11];
        timeLbl.text = order.orderDate;
        [cell.contentView addSubview:timeLbl];
        [timeLbl release];
        
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    else if (indexPath.row == 1)
    {
        int h = 30 + 20 * order.orderPackageArr.count;
        NSString *packageName = @"";
        for (OrderPackageInfo *package in order.orderPackageArr)
        {
            packageName = [packageName stringByAppendingString:package.name];
            packageName = [packageName stringByAppendingString:@" "];
        }
        
        
        UILabel *packageLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, h)];
        packageLbl.backgroundColor = [UIColor clearColor];
        packageLbl.numberOfLines = 0;
//        [packageLbl f];
        packageLbl.text = packageName;
        [cell.contentView addSubview:packageLbl];
        [packageLbl release];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        if (order.productNum == 1)
        {
            return [self tableViewSecondCellForSingleProduct:tableView orderV2:order];
        }
        else
        {
            return [self tableViewSecondCellForMultiProduct:tableView orderV2:order];
        }
    }
    
    
    
    return cell;
}


//单个商品的第二行cell
-(UITableViewCell *)tableViewSecondCellForSingleProduct:(UITableView *)tableView orderV2:(MyOrderInfo *)orderV2
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MyOrderSecondCellForSingle"];
    if (cell==nil)
    {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyOrderSecondCellForSingle"] autorelease];
        [cell setBackgroundColor:[UIColor whiteColor]];
        //商品图片
        OTSImageView *imageView=[[OTSImageView alloc] initWithFrame:CGRectMake(20, 12, 40, 40)];
        [imageView setTag:1];
        [cell addSubview:imageView];
        [imageView release];
        //商品名称
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(73, 10, 227, 43)];
        [label setTag:2];
        [label setNumberOfLines:2];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [cell addSubview:label];
        [label release];
    }
    //商品图片
    //    ProductVO *productVO=[[[orderV2 orderItemList] objectAtIndex:0] product];
    OrderProductInfo *product = orderV2.productInfoArr[0];
    OTSImageView *imageView=(OTSImageView *)[cell viewWithTag:1];
    [imageView loadImgUrl:product.productPicture];
    //商品名称
    UILabel *label=(UILabel *)[cell viewWithTag:2];
    [label setText:[product productName]];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    return cell;
}
//多个商品的第二行cell
-(UITableViewCell *)tableViewSecondCellForMultiProduct:(UITableView *)tableView orderV2:(MyOrderInfo *)orderV2
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MyOrderSecondCellForMulti"];
    if (cell==nil)
    {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyOrderSecondCellForMulti"] autorelease];
        [cell setBackgroundColor:[UIColor whiteColor]];
        //左箭头
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 24, 7, 13)];
        [imageView setImage:[UIImage imageNamed:@"shopList_left_arrow.png"]];
        [cell addSubview:imageView];
        [imageView release];
        //scroll view
        UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(40, 1, 240, 61)];
        [scrollView setTag:1];
        [cell addSubview:scrollView];
        [scrollView release];
        //右箭头
        imageView=[[UIImageView alloc] initWithFrame:CGRectMake(293, 24, 7, 13)];
        [imageView setImage:[UIImage imageNamed:@"shopList_right_arrow.png"]];
        [cell addSubview:imageView];
        [imageView release];
    }
    UIScrollView *scrollView=(UIScrollView *)[cell viewWithTag:1];
    for (UIView *view in [scrollView subviews]) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    CGFloat xValue=0.0;
    int i;
    for (i=0; i<[[orderV2 productInfoArr] count]; i++)
    {
        OTSImageView *imageView=[[OTSImageView alloc] initWithFrame:CGRectMake(xValue, 10, 40, 40)];
        OrderProductInfo *productVO=[[orderV2 productInfoArr] objectAtIndex:i];
        
        [imageView loadImgUrl:productVO.productPicture];
        [scrollView addSubview:imageView];
        [imageView release];
        xValue+=50.0;
    }
    [scrollView setContentSize:CGSizeMake(xValue-10.0, 61)];
    [scrollView setContentSize:CGSizeMake(xValue-10.0, 61)];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    return cell;
}


#pragma mark - tv delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 30;
    }
    else if (indexPath.row == 1)
    {
        MyOrderInfo *order = _orderList[(tableView.tag - 100)];
        return 30 + order.orderPackageArr.count * 20;
    }
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DebugLog("@didSelectRowAtIndexPath");
    
    MyOrderInfo *order = _orderList[tableView.tag - 100];
    
    [self removeSubControllerClass:[OTSOrderMfVC class]];
    OTSOrderMfVC *orderMfVC=[[[OTSOrderMfVC alloc] initWithNibName:@"OTSOrderMfVC" bundle:nil] autorelease];
//    orderMfVC.theOrder=m_OrderV2;
//    orderMfVC.subPackIndex = packageIndex;
    orderMfVC.orderId = order.orderId;
    [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
    [self pushVC:orderMfVC animated:YES fullScreen:self.isFullScreen];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}



@end
