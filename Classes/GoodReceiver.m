//
//  GoodReceiver.m
//  GoodReceiver
//
//  Created by yangxd on 11-2-15.
//  Updated by yangxd on 11-3-11.
//  Updated by yangxd on 11-06-14  去除成功时的提示框
//  Copyright 2011 vsc. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "GoodReceiver.h"
#import "GoodReceiverVO.h"
#import "AddressService.h"
#import "OrderService.h"
#import "GlobalValue.h"
#import "CheckOrder.h"
#import "ProductVO.h"
#import "ProvinceVO.h"
#import "CityVO.h"
#import "CountyVO.h"
#import "Trader.h"
#import "MyStoreViewController.h"
#import "UserManage.h"
#import "RegexKitLite.h"
#import "EditGoodsReceiver.h"
#import "AlertView.h"
#import "OTSAlertView.h"
#import "TheStoreAppAppDelegate.h"
#import "DoTracking.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ALERTVIEW_TAG_SET_RECEIVER 1
#define ALERTVIEW_TAG_ORDER_DISTRIBUTION 2
#define ALERTVIEW_TAG_ORDER_DISTRIBUTIONV2 3

#define THREAD_STATUS_GET_RECEIVERLIST 1
#define THREAD_STATUS_SAVE_RECEIVER_TO_ORDER 2

@implementation GoodReceiver

@synthesize isFromGroupon;//传入参数，是否从团购过来
@synthesize isFromCart;   //传入参数，是否从购物车过来
@synthesize m_FromTag;//传入参数，从1号店进入或是从检查订单进入
@synthesize m_DefaultReceiverId;//传入参数，默认收货地址id
@synthesize distributionArray;//无法配送的商品列表
@synthesize m_EditGoodsReceiver;
@synthesize m_SelectedGift;
@synthesize backToCart;//返回购物车标示

-(void)viewWillDisappear:(BOOL)animated
{
    DebugLog(@"GoodReceiver viewWillDisappear"); 
}


- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    [m_ScrollView setFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, ApplicationWidth, ApplicationHeight-NAVIGATION_BAR_HEIGHT - TABBAR_HEIGHT)];
    [self initGoodReceiver];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeSubView) name:@"CloseReceiverList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateReceiverList) name:@"UpdateReceiverList" object:nil];
    done = NO;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateReceiverList" object:nil];
    [self strechViewToBottom:m_ScrollView];
    [self strechViewToBottom:m_InfoView];
}

-(void)closeSubView
{
    [self removeSelf];
}

-(void)updateReceiverList
{
    m_ThreadState=THREAD_STATUS_GET_RECEIVERLIST;
	[self setUpThread];
}

-(void)initGoodReceiver {
    if (m_FromTag==FROM_CHECK_ORDER || isFromGroupon) {
        [m_TitleLabel setText:@"选择收货地址"];
    } else {
        [m_TitleLabel setText:@"收货地址"];
    }
    //当前省份
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"SaveProvinceId.plist"];
    NSArray *mArray=[NSArray arrayWithContentsOfFile:filename];
    m_CurrentProvince=[[mArray objectAtIndex:0] retain];
    //添加收货地址提示
    m_NewAddressView=[[UIView alloc]initWithFrame:CGRectMake(9,0,302,34)];
    [m_NewAddressView.layer setBorderWidth:1.0];
    [m_NewAddressView.layer setBorderColor:[[UIColor colorWithRed:255.0/255.0 green:219.0/255.0 blue:167.0/255.0 alpha:1.0] CGColor]];
    [m_NewAddressView setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:254.0/254.0 blue:238.0/255.0 alpha:1.0]];
    [m_ScrollView addSubview:m_NewAddressView];
    [m_NewAddressView release];
    [m_NewAddressView setHidden:YES];
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(11,9,16,16)];
    [imageView setImage:[UIImage imageNamed:@"switchProvince_warn.png"]];
    [m_NewAddressView addSubview:imageView];
    [imageView release];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(30, 0, 270, 34)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:[NSString stringWithFormat:@"当前收货省份%@没有收货地址，请新建地址",m_CurrentProvince]];
    [label setFont:[UIFont systemFontOfSize:13.0]];
    [m_NewAddressView addSubview:label];
    [label release];
    
    [m_ScrollView setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:UIColorFromRGB(0xeeeeee)];
    
	m_ThreadState=THREAD_STATUS_GET_RECEIVERLIST;
	[self setUpThread];
}

-(void)updateGoodReceiver {
    //删除所有tableview
    NSArray *mSubViews=[m_ScrollView subviews];
    for (UIView *view in mSubViews)
    {
        if ([view isKindOfClass:[UITableView class]])
        {
            [view removeFromSuperview];
        }
    }
    if (m_FromTag==FROM_MY_STORE)
    {
        [m_ScrollView setFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, ApplicationWidth, ApplicationHeight-NAVIGATION_BAR_HEIGHT-TABBAR_HEIGHT)];
    }
    else
    {
        [m_ScrollView setFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, ApplicationWidth, ApplicationHeight-NAVIGATION_BAR_HEIGHT)];
    }
    
	if (m_ReceiverArray==nil || [m_ReceiverArray count]<=0) {//无收货地址
	    [m_InfoView setHidden:NO];
        m_InfoView.backgroundColor = [UIColor whiteColor];
        [m_NewAddressView setHidden:YES];
        [m_ScrollView setContentSize:CGSizeMake(320,367)];
	}
    else
    {
        [m_InfoView setHidden:YES];
        //收货地址信息列表
        BOOL hasAddressInCurProvince=NO;
		for (GoodReceiverVO *vo in m_ReceiverArray)
        {
			if ([vo.provinceId intValue] == [[GlobalValue getGlobalValueInstance].provinceId intValue])//[[vo provinceName] isEqualToString:m_CurrentProvince])
            {
                hasAddressInCurProvince=YES;
                break;
            }
		}
        CGFloat yValue=10.0;
        if (!hasAddressInCurProvince)
        {
            [m_NewAddressView setFrame:CGRectMake(9,yValue,302,34)];
            [m_NewAddressView setHidden:NO];
            yValue+=34.0;
        }
        else
        {
            [m_NewAddressView setHidden:YES];
        }
        //收货地址tableview
        int i;
        for (i=0; i<[m_ReceiverArray count]; i++) {
            GoodReceiverVO *goodReceiver=[m_ReceiverArray objectAtIndex:i];
            CGFloat height=93.0;
            if ([goodReceiver receiverMobile]!=nil && ![[goodReceiver receiverMobile] isEqualToString:@""]) {
                height+=20.0;
            }
            if ([goodReceiver receiverPhone]!=nil && ![[goodReceiver receiverPhone] isEqualToString:@""]) {
                height+=20.0;
            }
            UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, height) style:UITableViewStyleGrouped];
            [tableView setTag:100+i];
            [tableView setBackgroundColor:[UIColor clearColor]];
            [tableView setBackgroundView:nil];
            [tableView setScrollEnabled:NO];
            [tableView setDelegate:self];
            [tableView setDataSource:self];
            [m_ScrollView addSubview:tableView];
            tableView.backgroundView=nil;
            [tableView release];
            yValue+=height;
        }
        yValue+=10.0;
        //让scrollview可以滑动
        if (yValue<=[m_ScrollView frame].size.height) {
            [m_ScrollView setContentSize:CGSizeMake(320,[m_ScrollView frame].size.height+1)];
        } else {
            [m_ScrollView setContentSize:CGSizeMake(320,yValue)];
        }
    }
}

#pragma mark    编辑送货地址页面
-(IBAction)enterEditGoodsReceiver:(id)sender
{
    
	m_EditGoodsReceiver=[[EditGoodsReceiver alloc] initWithNibName:@"EditGoodsReceiver" bundle:nil];
    m_EditGoodsReceiver.isFullScreen = self.isFullScreen;
    
    [m_EditGoodsReceiver setM_FromTag:m_FromTag];
    [m_EditGoodsReceiver setIsFromCart:isFromCart];
    [m_EditGoodsReceiver setBackToCart:backToCart];
    if (sender!=nil)
    {
        UIButton *button=sender;
        m_CurrentIndex=[button tag];
        GoodReceiverVO *goodsReceiverVO=[m_ReceiverArray objectAtIndex:m_CurrentIndex];
        [m_EditGoodsReceiver setM_GoodsReceiverVO:goodsReceiverVO];
    }
    if (mo_Address)
    {
        GoodReceiverVO *goodsReceiverVO=[m_ReceiverArray objectAtIndex:m_CurrentIndex];
        [m_EditGoodsReceiver setM_GoodsReceiverVO:goodsReceiverVO];
        mo_Address = NO;
    }
    [sender setBackgroundColor:[UIColor colorWithRed:3.0/255.0 green:125.0/255.0 blue:241.0/255.0 alpha:0.7]];
    NSTimer *_busTimer = [NSTimer timerWithTimeInterval:.5f target:self selector:@selector(callsomethingelse:) userInfo:sender repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_busTimer forMode:NSRunLoopCommonModes];
    do
    {
        [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        
    }while (!done);

    CATransition *animation = [CATransition animation]; 
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    [animation setType:kCATransitionPush];
    [animation setSubtype: kCATransitionFromRight];
    [self.view.layer addAnimation:animation forKey:@"Reveal"];

    [self.view addSubview:[m_EditGoodsReceiver view]];

}

#pragma mark    新增送货地址
-(IBAction)enterAddGoodsReceiver:(id)sender
{
    if (m_ReceiverArray!=nil && [m_ReceiverArray count]>=10)
    {
        [AlertView showAlertView:nil alertMsg:@"收货地址最多只能保存10个!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
        return;
    }
    [self enterEditGoodsReceiver:nil];
}

#pragma mark    设为收货地址
-(IBAction)setGoodsReceiverClicked:(id)sender
{
    UIButton *button=sender;
    m_CurrentIndex=[button tag];
    GoodReceiverVO *receiverVO=[m_ReceiverArray objectAtIndex:m_CurrentIndex];
    if (isFromGroupon)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveGoodReceiverForGroupon" object:receiverVO];
        [self returnBtnClicked:nil];
    }
    else
    {
        if (m_FromTag==FROM_CHECK_ORDER)
        {
            DebugLog(@"[GlobalValue getGlobalValueInstance].provinceId intValue]= %d",[[GlobalValue getGlobalValueInstance].provinceId intValue]);
            if ([[GlobalValue getGlobalValueInstance].provinceId intValue] != [receiverVO.provinceId intValue])
            {
                NSString *title=@"无法下订单";
                NSString *message=[NSString stringWithFormat:@"订单地址与收货省份%@不一致，无法下单。\n切换省份，会使您购物车中的部分商品价格变化或者不能购买",m_CurrentProvince];
                UIAlertView *alertView=[[OTSAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"修改地址" otherButtonTitles:@"更换省份", nil];
                [alertView setTag:ALERTVIEW_TAG_SET_RECEIVER];
                [alertView show];
                [alertView release];
            }
            else
            {
                [sender setBackgroundColor:[UIColor colorWithRed:3.0/255.0 green:125.0/255.0 blue:241.0/255.0 alpha:0.7]];
                NSTimer *_busTimer = [NSTimer timerWithTimeInterval:.1f target:self selector:@selector(callsomethingelse:) userInfo:sender repeats:NO];
                [[NSRunLoop currentRunLoop] addTimer:_busTimer forMode:NSRunLoopCommonModes];
                m_ThreadState=THREAD_STATUS_SAVE_RECEIVER_TO_ORDER;
                [self setUpThread];
            }
        }
        else
        {
            if (m_CurrentBtn!=button)
            {
                [m_CurrentBtn setBackgroundImage:[UIImage imageNamed:@"goodReceiver_unsel.png"] forState:UIControlStateNormal];
                m_CurrentBtn=button;
                [m_CurrentBtn setBackgroundImage:[UIImage imageNamed:@"goodReceiver_sel.png"] forState:UIControlStateNormal];
            }
        }
    }
}

-(void)callsomethingelse:(id)timer
{
    UIButton *Btn = (UIButton *)[timer userInfo];
    [Btn setBackgroundColor:[UIColor clearColor]];
    done = YES;
    if (timer!=nil) {
        [timer invalidate];
        timer = nil;
    }
}

-(void)changeProvinceWhenSetReceiver
{
    GoodReceiverVO *receiverVO=[m_ReceiverArray objectAtIndex:m_CurrentIndex];
    NSString *provinceName=[receiverVO provinceName];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProvinceChanged" object:provinceName];
    [SharedDelegate enterCartWithUpdate:NO];
}

#pragma mark    返回按钮
-(IBAction)returnBtnClicked:(id)sender {
	[self.view.superview.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:@"Reveal"];
    [self removeSelf];
}

#pragma mark    tableview相关
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(void)tableView:(UITableView * )tableView didSelectRowAtIndexPath:(NSIndexPath * )indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    m_CurrentIndex=[tableView tag]-100;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath * )indexPath
{
	int index=[tableView tag]-100;
	GoodReceiverVO *goodReceiver=[m_ReceiverArray objectAtIndex:index];
    CGFloat height=78.0;
    if ([goodReceiver receiverMobile]!=nil && ![[goodReceiver receiverMobile] isEqualToString:@""]) {
        height+=20.0;
    }
    if ([goodReceiver receiverPhone]!=nil && ![[goodReceiver receiverPhone] isEqualToString:@""]) {
        height+=20.0;
    }
    
    UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    
    //已选中收货地址 从订单及团购中选择
    float offset = -25.0; // 收货人信息的缩进值
    if (m_FromTag==FROM_CHECK_ORDER || isFromGroupon) {
        offset = 5.0;
        UIButton *SelBtn=[[UIButton alloc] initWithFrame:CGRectMake(20, height/2-12, 24, 24)];
        [SelBtn setTag:index];
        if ([[goodReceiver nid] intValue]==[m_DefaultReceiverId intValue]) {
            m_CurrentBtn=SelBtn;
            [SelBtn setBackgroundImage:[UIImage imageNamed:@"goodReceiver_sel.png"] forState:UIControlStateNormal];
        } else {
            [SelBtn setBackgroundImage:[UIImage imageNamed:@"goodReceiver_unsel.png"] forState:UIControlStateNormal];
        }
        [cell addSubview:SelBtn];
        [SelBtn release];
    }
    //收货人
    CGFloat yValue=10.0;
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(58+offset, yValue, 205, 20)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:[goodReceiver receiveName]];
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:16.0]];
    [cell addSubview:label];
    [label release];
    yValue+=20.0;
    //地址
    label=[[UILabel alloc] initWithFrame:CGRectMake(58+offset, yValue, 205, 20)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:[goodReceiver address1]];
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:16.0]];
    [cell addSubview:label];
    [label release];
    yValue+=20.0;
    //省市区
    label=[[UILabel alloc] initWithFrame:CGRectMake(58+offset, yValue, 205, 20)];
    [label setBackgroundColor:[UIColor clearColor]];
    if ([goodReceiver.provinceName isEqualToString:@"上海"]) {
        [label setText:[NSString stringWithFormat:@"%@ %@", goodReceiver.provinceName, goodReceiver.cityName]];
    } else {
        [label setText:[NSString stringWithFormat:@"%@ %@ %@", goodReceiver.provinceName, goodReceiver.cityName, goodReceiver.countyName]];
    }
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:16.0]];
    [cell addSubview:label];
    [label release];
    yValue+=20.0;
    //手机
    if ([goodReceiver receiverMobile]!=nil && ![[goodReceiver receiverMobile] isEqualToString:@""]) {
        label=[[UILabel alloc] initWithFrame:CGRectMake(58+offset, yValue, 205, 20)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:[goodReceiver receiverMobile]];
        [label setTextColor:[UIColor blackColor]];
        [label setFont:[UIFont systemFontOfSize:16.0]];
        [cell addSubview:label];
        [label release];
        yValue+=20.0;
    }
    //电话
    if ([goodReceiver receiverPhone]!=nil && ![[goodReceiver receiverPhone] isEqualToString:@""]) {
        label=[[UILabel alloc] initWithFrame:CGRectMake(58+offset, yValue, 205, 20)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:[goodReceiver receiverPhone]];
        [label setTextColor:[UIColor blackColor]];
        [label setFont:[UIFont systemFontOfSize:16.0]];
        [cell addSubview:label];
        [label release];
        //yValue+=20.0;
    }
    //分割线
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(272, 0, 1, height)];
    [view setBackgroundColor:[UIColor lightGrayColor]];
    [cell addSubview:view];
    [view release];
    
    // MODIFIED_BY:dong yiming DATE:2012.5.28. COMMENT:to fix bug 0062437 ---- BEGIN
    //编辑收货地址
    UIButton* button=[[UIButton alloc] initWithFrame:CGRectMake(282, height/2-8, 16, 16)];
    //[button setTag:index];
    [button setBackgroundImage:[UIImage imageNamed:@"goodReceiver_edit.png"] forState:UIControlStateNormal];
    //[button addTarget:self action:@selector(enterEditGoodsReceiver:) forControlEvents:UIControlEventTouchDown];
    [cell addSubview:button];
    [button release];
    
    
    if (m_FromTag==FROM_CHECK_ORDER || isFromGroupon) 
    {
        //选择收货地址--透明响应区域
        float selectAreaHeight = height; //72.;
        float selectAreaWidth = 272;
        
        CGRect selectAreaRect = CGRectMake(10,0,selectAreaWidth-10, selectAreaHeight);
        UIButton* transparentSelectBtn=[[UIButton alloc] initWithFrame:selectAreaRect];
        transparentSelectBtn.backgroundColor = [UIColor clearColor];
        [transparentSelectBtn.layer setMasksToBounds:YES];
        [transparentSelectBtn.layer setCornerRadius:5.0]; 
        [transparentSelectBtn setTag:index];
        [transparentSelectBtn addTarget:self action:@selector(setGoodsReceiverClicked:) forControlEvents:UIControlEventTouchDown];
        [cell addSubview:transparentSelectBtn];
        [transparentSelectBtn release];
    }

    //编辑收货地址--透明响应区域
    float editAreaHeight = height; //72.;
    float editAreaWidth = (height / 2)-8;
    CGRect editAreaRect = CGRectMake(312 - editAreaWidth, (height - editAreaHeight) / 2, editAreaWidth, editAreaHeight);
    UIButton* transparentEditBtn=[[UIButton alloc] initWithFrame:editAreaRect];
    transparentEditBtn.backgroundColor = [UIColor clearColor];
    [transparentEditBtn.layer setMasksToBounds:YES];
    [transparentEditBtn.layer setCornerRadius:5.0];  
    [transparentEditBtn setTag:index];
    [transparentEditBtn addTarget:self action:@selector(enterEditGoodsReceiver:) forControlEvents:UIControlEventTouchDown];
    [cell addSubview:transparentEditBtn];
    [transparentEditBtn release];
    // MODIFIED_BY:dong yiming DATE:2012.5.28. COMMENT:to fix bug 0062437 ---- END
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int index=[tableView tag]-100;
	GoodReceiverVO *goodReceiver=[m_ReceiverArray objectAtIndex:index];
    CGFloat height=78.0;
    if ([goodReceiver receiverMobile]!=nil && ![[goodReceiver receiverMobile] isEqualToString:@""]) {
        height+=20.0;
    }
    if ([goodReceiver receiverPhone]!=nil && ![[goodReceiver receiverPhone] isEqualToString:@""]) {
        height+=20.0;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}


#pragma mark    alertview相关
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case ALERTVIEW_TAG_SET_RECEIVER: {
            if (buttonIndex==1) {
                [self changeProvinceWhenSetReceiver];
            }
            break;
        }
        case ALERTVIEW_TAG_ORDER_DISTRIBUTIONV2:{
            [(PhoneCartViewController *)[SharedDelegate.tabBarController.viewControllers objectAtIndex:2] refreshCart];
            [(PhoneCartViewController *)[SharedDelegate.tabBarController.viewControllers objectAtIndex:2] showMainViewFromTabbarMaskAnimated:NO];
            break;
        }
        case ALERTVIEW_TAG_ORDER_DISTRIBUTION: {
            if (buttonIndex==1) {
                __block int result;
                [self performInThreadBlock:^()
                 {
                     @autoreleasepool {
                         CartService *cService=[[[CartService alloc] init] autorelease];
                         if ([distributionArray count]>0) {
                             NSMutableArray * productids = [[[NSMutableArray alloc] init] autorelease];
                             NSMutableArray * merchantids = [[[NSMutableArray alloc] init] autorelease];
                             NSMutableArray * promotionlist = [[[NSMutableArray alloc] init] autorelease];
                             for (int i= 0; i< [distributionArray count]; i++) {
                                 ProductVO *vo = [distributionArray objectAtIndex:i];
                                 if (vo.productId == nil) {
                                     vo.productId = 0;
                                 }
                                 if (vo.merchantId == nil) {
                                     vo.merchantId = 0;
                                 }
                                 if (vo.promotionId == nil) {
                                     vo.promotionId = @"";
                                 }
                                 [productids addObject:vo.productId];
                                 [merchantids addObject:vo.merchantId];
                                 [promotionlist addObject:vo.promotionId];
                             }
                             result = [cService delProducts:[GlobalValue getGlobalValueInstance].token productIds:productids merchantIds:merchantids promotionList:promotionlist];
                         }
                     }
                 }
                     completionInMainBlock:^(){
                         if (result==1) {
                             [SharedDelegate enterCartWithUpdate:YES];
                         } else {
                             [self toastShowString:@"删除失败"];
                         }
                         
                     }];
            } else if (buttonIndex==0) {
                DebugLog(@"修改地址");
                mo_Address = YES;
                [self enterEditGoodsReceiver:nil];
            }
            break;
        }
        default:
            break;
    }
    [[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:NO];
}

// yaowang
- (void)saveGoodReceiverToOrder:(NSString *)addressId
{

    [NSThread sleepForTimeInterval:0.5];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveGoodReceiveToOrder" object:addressId];
    [self returnBtnClicked:nil];
}
#pragma mark    保存地址到订单结果处理
-(void)showSaveGoodReceiverToOrderAlertView:(SaveGoodReceiverResult *)result {
	[self stopThread];
    int intresult=[[result resultCode] intValue];
	switch (intresult){
        case 1:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"removeDistributionArray" object:nil];
            [NSThread sleepForTimeInterval:0.5];
			[self returnBtnClicked:nil];
            GoodReceiverVO * receiverVO = [m_ReceiverArray objectAtIndex:m_CurrentIndex];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"SaveGoodReceiveToOrder" object:receiverVO];
			break;
		case 0:
            [AlertView showAlertView:nil alertMsg:@"保存失败!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
			break;
		case -1:
            [AlertView showAlertView:nil alertMsg:@"地址不属于本人!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
			break;
		case -2:
            [AlertView showAlertView:nil alertMsg:@"地址和登录的地区不同!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
			break;
		case -4:
            [AlertView showAlertView:nil alertMsg:@"不支持货到付款!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
			break;
		case -19:
            [AlertView showAlertView:nil alertMsg:@"订单不存在!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
			break;
        case -270:
        {
            UIAlertView *alert=[[OTSAlertView alloc] initWithTitle:nil message:result.errorInfo delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alert setTag:ALERTVIEW_TAG_ORDER_DISTRIBUTIONV2];
            [alert show];
            [alert release];
        }
            break;
        case -271:
        {
            self.backToCart = YES;
            [self showErrorOfDistribution:result];
        }
            break;
		default:
            [AlertView showAlertView:nil alertMsg:@"网络异常，请检查网络配置..." buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
			break;
	}
}


-(void)showErrorOfDistribution:(SaveGoodReceiverResult *)result
{
    self.distributionArray = result.productList;
    [self.loadingView hide];
    NSString *disMessage = result.errorInfo;
    NSArray *listItems = [disMessage componentsSeparatedByString:@"收货地址"];
    NSString * mTitle = [[listItems objectAtIndex:0] stringByAppendingString:@"收货地址"];
    //返回的以逗号隔开
    NSArray * mProducts = [[listItems objectAtIndex:1] componentsSeparatedByString:@","];
    NSString * StringProduct = [mProducts objectAtIndex:0];
    for (int i = 1; i< [mProducts count]; i++) {
        NSString * temps = [NSString stringWithFormat:@"\r%@",[mProducts objectAtIndex:i]];
        StringProduct = [StringProduct stringByAppendingString:temps];
    }
    UIAlertView *alert=[[OTSAlertView alloc] initWithTitle:mTitle message:StringProduct delegate:self cancelButtonTitle:@"修改地址" otherButtonTitles:@"删除商品", nil];
    [alert setTag:ALERTVIEW_TAG_ORDER_DISTRIBUTION];
	[alert show];
	[alert release];
}

#pragma mark 建立线程
-(void)setUpThread{
	if (!m_ThreadRunning) {
        m_ThreadRunning=YES;
        [self showLoading:YES];
		[self otsDetatchMemorySafeNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
	}
}

//开启线程
-(void)startThread
{
	while (m_ThreadRunning)
    {
		@synchronized(self)
        {
            switch (m_ThreadState)
            {
                case THREAD_STATUS_GET_RECEIVERLIST:
                {  // 获取送货地址信息
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
					YWAddressService *aServ=[[YWAddressService alloc] init];
                    NSArray *tempArray=nil;
                    @try
                    {
//                        tempArray=[aServ getGoodReceiverListByToken:[GlobalValue getGlobalValueInstance].token];
                        
                        tempArray = [aServ getMyGoodRecevicer];
                        
                    }
                    @catch (NSException * e)
                    {
                    }
                    @finally
                    {
                        if (m_ReceiverArray!=nil)
                        {
							[m_ReceiverArray release];
						}
                        if (tempArray!=nil && ![tempArray isKindOfClass:[NSNull class]])
                        {
                            m_ReceiverArray=[tempArray retain];
                        }
                        else
                        {
                            m_ReceiverArray=nil;
                        }
						[self performSelectorOnMainThread:@selector(updateGoodReceiver) withObject:self waitUntilDone:NO];
                        [self stopThread];
                    }
                    [aServ release];
                    [pool drain];
                    break;
                }
                case THREAD_STATUS_SAVE_RECEIVER_TO_ORDER:
                {  // 保存地址到订单

                    GoodReceiverVO * receiverVO = [m_ReceiverArray objectAtIndex:m_CurrentIndex];
                        [self performSelectorOnMainThread:@selector(saveGoodReceiverToOrder:) withObject:[receiverVO.nid stringValue] waitUntilDone:NO];

                        [self stopThread];

                    break;
                }
                default:
                    break;
            }
		}
	}
}

#pragma mark 停止线程
-(void)stopThread {
	m_ThreadRunning=NO;
	m_ThreadState=-1;
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"MainWindowHideLoading" object:nil];
    [self hideLoading];
}

#pragma mark error
-(void)toastShowString:(NSString *)string
{
    [self.loadingView showTipInView:self.view title:string];
    
	[UIView setAnimationsEnabled:NO];
}


#pragma mark -
-(void)releaseMyResoures
{
    OTS_SAFE_RELEASE(m_EditGoodsReceiver);
    OTS_SAFE_RELEASE(m_ReceiverArray);
    OTS_SAFE_RELEASE(m_DefaultReceiverId);
    OTS_SAFE_RELEASE(m_CurrentProvince);
    
    // release outlet
    OTS_SAFE_RELEASE(m_TitleLabel);
    OTS_SAFE_RELEASE(m_ScrollView);
    OTS_SAFE_RELEASE(m_InfoView);
    OTS_SAFE_RELEASE(distributionArray);
    OTS_SAFE_RELEASE(m_SelectedGift);
    
	// remove vc
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseMyResoures];
}

-(void)dealloc
{
    [self releaseMyResoures];
    [super dealloc];
}
@end
