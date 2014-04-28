//
//  MyCoupon.m
//  TheStoreApp
//
//  Created by towne on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define THREAD_STATUS_GET_MY_COUPON  1 //我的一号店查询抵用卷
#define THREAD_STATUS_GET_MYCOUPON_COUNT 2//我的一号店查询所有抵用卷数量

#define LOADMORE_HEIGHT 40
#import "MyCoupon.h"
#import "CouponCell.h"
@implementation MyCoupon
//@synthesize fromOrder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self initMyCoupon];
    
    // iphone5适配 - dym
//    rc.size.height = self.view.frame.size.height -  OTS_IPHONE_NAVI_BAR_HEIGHT;
    CGRect rc = m_ScrollView.frame;
    rc.size.height = self.view.frame.size.height - OTS_IPHONE_NAVI_BAR_HEIGHT - 36;
    rc.origin.y = 80;
    m_ScrollView.frame = rc;
    m_ScrollView.backgroundColor = [UIColor whiteColor];
}

//初始化我的抵用卷列表
-(void)initMyCoupon
{
    [self.view setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    [m_ScrollView setBackgroundColor:[UIColor clearColor]];
    [m_ScrollView setDelegate:self];
    [m_ScrollView setAlwaysBounceVertical:YES];
    
    m_LoadingMoreLabel=[[LoadingMoreLabel alloc] initWithFrame:CGRectMake(0, 0, 320, LOADMORE_HEIGHT)];
    
    m_CouponType=0;//查询是否有抵用卷
    
//    m_CouponType =1;//test 等接口好了去掉
    
    m_PageIndex=1;
    m_AllCoupons=[[NSMutableArray alloc] init];
    m_CurrentTypeIndex=0;
    
    m_CouponTotalNum = 10;
    //获取我的抵用卷
    m_ThreadStatus=THREAD_STATUS_GET_MYCOUPON_COUNT;
    [self setUpThread:YES];
}

-(void)updateMyCoupon
{
    //删除scrollview所有子view
    for (UIView *view in [m_ScrollView subviews]) {
        if ([view isKindOfClass:[UITableView class]] || [view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    if ([m_AllCoupons count]==0) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 330)];
        imageView.backgroundColor = [UIColor blueColor];
        if (1==m_CouponType) {
            [imageView setImage:[UIImage imageNamed:@"emptymycoupon@2x.png"]];
            [m_ScrollView setAlwaysBounceVertical:NO];
        } else if (2==m_CouponType) {
            [imageView setImage:[UIImage imageNamed:@"emptymycoupon1@2x.png"]];
            [m_ScrollView setAlwaysBounceVertical:NO];
        } else if (3==m_CouponType) {
            [imageView setImage:[UIImage imageNamed:@"emptymycoupon2@2x.png"]];
            [m_ScrollView setAlwaysBounceVertical:NO];
        } 
        [m_ScrollView addSubview:imageView];
        [imageView release];
        [m_ScrollView setContentSize:CGSizeMake(320, [m_ScrollView frame].size.height)];
    } else {

        CGFloat yValue=0.0;
        int i;
        for (i=0; i<[m_AllCoupons count]; i++) {
            CGFloat height = 121.0;
            UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, yValue, 320, height) style:UITableViewStylePlain];
            [tableView setTag:100+i];
            [tableView setBackgroundColor:[UIColor clearColor]];
            [tableView setScrollEnabled:NO];
            [tableView setDelegate:self];
            [tableView setDataSource:self];
            [m_ScrollView addSubview:tableView];
            [tableView release];
            yValue+=height;
        }
        [m_ScrollView setContentSize:CGSizeMake(320, yValue+20)];
        
        //加载更多
        if ([m_AllCoupons count]<m_CouponTotalNum) {
            [m_LoadingMoreLabel setFrame:CGRectMake(0, yValue, 320, LOADMORE_HEIGHT)];
            [m_ScrollView addSubview:m_LoadingMoreLabel];
            [m_ScrollView setContentSize:CGSizeMake(320, yValue+LOADMORE_HEIGHT)];
        }
    }
    
    //更新数量
    /* 暂不显示数量
    if (m_CurrentTypeIndex==0) {
        for (UIView *view in [m_TypeView subviews]) {
            if ([view isKindOfClass:[UIButton class]] && [view tag]==0) {
                UIButton *button=(UIButton *)view;
                [button setTitle:[NSString stringWithFormat:@"未使用 (%d) ",[m_AllCoupons count]] forState:UIControlStateNormal];
            }
        }
    }
    if (m_CurrentTypeIndex==1) {
        for (UIView *view in [m_TypeView subviews]) {
            if ([view isKindOfClass:[UIButton class]] && [view tag]==1) {
                UIButton *button=(UIButton *)view;
                [button setTitle:[NSString stringWithFormat:@"已使用 (%d) ",[m_AllCoupons count]] forState:UIControlStateNormal];
            }
        }
    }
    if (m_CurrentTypeIndex==2) {
        for (UIView *view in [m_TypeView subviews]) {
            if ([view isKindOfClass:[UIButton class]] && [view tag]==2) {
                UIButton *button=(UIButton *)view;
                [button setTitle:[NSString stringWithFormat:@"已过期 (%d) ",[m_AllCoupons count]] forState:UIControlStateNormal];
            }
        }
    }
    */
    
}


-(void)showError:(NSString *)error
{
    [AlertView showAlertView:nil alertMsg:error buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
}

//加载更多
-(void)getMoreCoupon
{
    m_ThreadStatus=THREAD_STATUS_GET_MY_COUPON;
    [self setUpThread:NO];
}

#pragma mark    新线程相关
-(void)setUpThread:(BOOL)showLoading {
	if (!m_ThreadRunning) {
		m_ThreadRunning=YES;
        [self showLoading:showLoading];
		[self otsDetatchMemorySafeNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
	}
}

//返回
-(IBAction)returnBtnClicked:(id)sender
{
    [self.view.superview.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:@"Reveal"];
    [self removeSelf];
}

//按类型获取
-(IBAction)typeBtnClicked:(id)sender {
    
    UIButton *button=sender;
//    fromOrder = NO;
    if ([button tag]==m_CurrentTypeIndex) {
        return;
    }
    else
    {
        //删除scrollview所有子view
        for (UIView *view in [m_ScrollView subviews]) {
            if ([view isKindOfClass:[UITableView class]] || [view isKindOfClass:[UIImageView class]]) {
                [view removeFromSuperview];
            }
        }
    }
    m_CurrentTypeIndex=[button tag];
	m_PageIndex=1;
    m_CouponTotalNum=0;
    if (m_AllCoupons!=nil) {
        [m_AllCoupons removeAllObjects];
    }
    [m_ScrollView setContentOffset:CGPointMake(0, 0)];    
    switch ([button tag]) {
        case 0: {
            for (UIView *view in [m_TypeView subviews]) {
                if ([view isKindOfClass:[UIButton class]]) {
                    UIButton *button=(UIButton *)view;
                    if ([button tag]==0) {
                        [button setBackgroundImage:[UIImage imageNamed:@"sort_sel.png"] forState:UIControlStateNormal];
                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    } else {
                        [button setBackgroundImage:[UIImage imageNamed:@"sort_unsel.png"] forState:UIControlStateNormal];
                        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }
                }
            }
            m_CouponType=1;
            m_ThreadStatus=THREAD_STATUS_GET_MY_COUPON;
            [self setUpThread:YES];
            break;
        }
        case 1: {
            for (UIView *view in [m_TypeView subviews]) {
                if ([view isKindOfClass:[UIButton class]]) {
                    UIButton *button=(UIButton *)view;
                    if ([button tag]==1) {
                        [button setBackgroundImage:[UIImage imageNamed:@"sort_sel.png"] forState:UIControlStateNormal];
                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    } else {
                        [button setBackgroundImage:[UIImage imageNamed:@"sort_unsel.png"] forState:UIControlStateNormal];
                        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }
                }
            }
            m_CouponType=2;
            m_ThreadStatus=THREAD_STATUS_GET_MY_COUPON;
            [self setUpThread:YES];
            break;
        }
        case 2: {
            for (UIView *view in [m_TypeView subviews]) {
                if ([view isKindOfClass:[UIButton class]]) {
                    UIButton *button=(UIButton *)view;
                    if ([button tag]==2) {
                        [button setBackgroundImage:[UIImage imageNamed:@"sort_sel.png"] forState:UIControlStateNormal];
                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    } else {
                        [button setBackgroundImage:[UIImage imageNamed:@"sort_unsel.png"] forState:UIControlStateNormal];
                        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }
                }
            }
            m_CouponType=3;
            m_ThreadStatus=THREAD_STATUS_GET_MY_COUPON;
            [self setUpThread:YES];
            break;
        }
        default:
            break;
    }
}


//开启线程
-(void)startThread {
	while (m_ThreadRunning) {
		@synchronized(self) {
            switch (m_ThreadStatus) {
                case THREAD_STATUS_GET_MY_COUPON: {//获取我的抵用卷
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                    CouponService *cServ=[[CouponService alloc] init];
                    Page *tempPage = nil;
                    @try {
                        tempPage=[cServ getMyCouponList:[GlobalValue getGlobalValueInstance].token type:m_CouponType currentPage:[NSNumber numberWithInt:m_PageIndex] pageSize:[NSNumber numberWithInt:5]];
                    } @catch (NSException * e) {
                    } @finally {
                        if (tempPage!=nil && ![tempPage isKindOfClass:[NSNull class]]) {
                            [m_AllCoupons addObjectsFromArray:[tempPage objList]];
                            m_PageIndex++;
                            m_CouponTotalNum=[[tempPage totalSize] intValue];
//                            [self performSelectorOnMainThread:@selector(updateMyCoupon) withObject:nil waitUntilDone:NO];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self updateMyCoupon];
                            });

						} else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self showError:@"网络异常，请检查网络配置..."];
                            });
                        }
                        [m_LoadingMoreLabel performSelectorOnMainThread:@selector(reset) withObject:self waitUntilDone:NO];
                        [self stopThread];
                    }
                    [cServ release];
                    [pool drain];
                    break;
                }
                case THREAD_STATUS_GET_MYCOUPON_COUNT: {//获取我的所有抵用卷数量 type=0
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                    CouponService *cServ=[[CouponService alloc] init];
                    Page *tempPage = nil;
                    @try {
                        tempPage=[cServ getMyCouponList:[GlobalValue getGlobalValueInstance].token type:0 currentPage:[NSNumber numberWithInt:m_PageIndex] pageSize:[NSNumber numberWithInt:5]];
                    } @catch (NSException * e) {
                    } @finally {
                        if (tempPage!=nil && ![tempPage isKindOfClass:[NSNull class]]) {
                            m_CouponTotalNum=[[tempPage totalSize] intValue];
                            if (m_CouponTotalNum == 0)
                            {
                                [self stopThread];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    m_empScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 368)];
                                    UIImageView *aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 368)];
                                    [aImageView setImage:[UIImage imageNamed:@"emptymycouponbase@2x.png"]];
                                    [m_empScrollView addSubview:aImageView];
                                    [self.view addSubview:m_empScrollView];
                                    [aImageView release];
                                    [m_empScrollView release];
                                });
                            }
                            else
                            {
                                [self stopThread];
                                m_CouponType = 1;
                                m_ThreadStatus=THREAD_STATUS_GET_MY_COUPON;
                                [self setUpThread:YES];
                            }
                            
						} else {
                            [self stopThread];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self showError:@"网络异常，请检查网络配置..."];
                            });                            
                        }
                    }
                    [cServ release];
                    [pool drain];
                    break;
                }
                default:
                    break;
            }
		}
	}
}

//停止线程
-(void)stopThread {
	m_ThreadRunning=NO;
	m_ThreadStatus=-1;
    [self hideLoading];
}

#pragma mark    scrollView相关delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView!=m_ScrollView || m_AllCoupons==nil || [m_AllCoupons count]>=m_CouponTotalNum) {
        return;
    }
    [m_LoadingMoreLabel scrollViewDidScroll:scrollView selector:@selector(getMoreCoupon) target:self];
}
#pragma mark    tableView的datasource和delegate
-(void)tableView:(UITableView * )tableView didSelectRowAtIndexPath:(NSIndexPath * )indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中颜色
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableViewDetailCell:(UITableView *)aTableView couponVO:(CouponVO*)aCouponVO tableIndex:(int)aIndex
{
    CouponCell *cell=[aTableView dequeueReusableCellWithIdentifier:@"CouponCell"];
//     UITableViewCell *cell=[aTableView dequeueReusableCellWithIdentifier:@"CouponCell"];
  /*  if (cell==nil) {
        NSArray *nibArray=[[NSBundle mainBundle] loadNibNamed:@"CouponCell" owner:self options:nil];
        cell=(UITableViewCell *)[nibArray objectAtIndex:0];
        
        //"抵用卷金额："
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 50)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:[NSString stringWithFormat:@"%@元",aCouponVO.amount]];
        [label setTextAlignment:NSTextAlignmentRight];
        [label setTextColor:[UIColor colorWithRed:204.0/255.0 green:0 blue:0 alpha:1.0]];
        [label setFont:[UIFont systemFontOfSize:22.0]];
        [cell addSubview:label];
        [label release];
        //"抵用卷描述："
        label=[[UILabel alloc] initWithFrame:CGRectMake(85, 5,225, 40)];
        [label setBackgroundColor:[UIColor clearColor]];
        NSString * c_description = [NSString stringWithFormat:@"满%@元抵%@元",aCouponVO.threshOld,aCouponVO.amount];
        [label setText:c_description];
        [label setFont:[UIFont systemFontOfSize:16.0]];
        [label setNumberOfLines:2];
        [cell addSubview:label];
        [label release];
        //"抵用卷有效日期："
        label=[[UILabel alloc] initWithFrame:CGRectMake(85, 35, 225, 40)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:[NSString stringWithFormat:@"有效日期:%@ - %@",[OTSUtility NSDateToNSStringDate:aCouponVO.beginTime],[OTSUtility NSDateToNSStringDate:aCouponVO.expiredTime]]];
        [label setFont:[UIFont systemFontOfSize:13.0]];
        [label setNumberOfLines:2];
        [label setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
        [cell addSubview:label];
        [label release];
        //"抵用卷规则按钮："
        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(85, 70, 76, 30)];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitle:@"规则" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [button setBackgroundImage:[UIImage imageNamed:@"regulation.png"] forState:UIControlStateNormal];
        [button setTag:10000+aIndex];
        [button addTarget:self action:@selector(regulation:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button];
        [button release];
        
        //"抵用卷状态："
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(320-61, 0, 61, 61)];
        // m_CouponType == 1 不显示
        if(m_CouponType == 2)
        {
            [imageView setImage:[UIImage imageNamed:@"hasUsed.png"]];
            CGRect rect = cell.bounds;
            rect.size.height-=10;
            UIView * view  = [[UIView alloc] initWithFrame:rect];
            [view setBackgroundColor:[UIColor whiteColor]];
            view.layer.opacity = 0.5;
            [cell addSubview:view];
            [view release];
        }
        else if(m_CouponType == 3) 
        {
            [imageView setImage:[UIImage imageNamed:@"hasExpired.png"]];
            CGRect rect = cell.bounds;
            rect.size.height-=10;
            UIView * view  = [[UIView alloc] initWithFrame:rect];
            [view setBackgroundColor:[UIColor whiteColor]];
            view.layer.opacity = 0.5;
            
            [cell addSubview:view];
            [view release];
        }
        [cell addSubview:imageView];
        [imageView release];
    }
    
   */ if (cell==nil) {
        cell=[[[CouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CouponCell"] autorelease];
    }
    cell.countlabel.text=[NSString stringWithFormat:@"%@元",aCouponVO.amount];
    cell.descriptLab.text=[NSString stringWithFormat:@"满%@元抵%@元",aCouponVO.threshOld,aCouponVO.amount];
    cell.lastDate.text= [NSString stringWithFormat:@"有效日期:%@ - %@",[OTSUtility NSDateToNSStringDate:aCouponVO.beginTime],[OTSUtility NSDateToNSStringDate:aCouponVO.expiredTime]];
    if(m_CouponType == 2)
    {
        [cell.stastusImg setImage:[UIImage imageNamed:@"hasUsed.png"]];
        [cell addAlphaCover];
    }else if(m_CouponType == 3)
    {
        [cell.stastusImg setImage:[UIImage imageNamed:@"hasExpired.png"]];
        [cell addAlphaCover];
    }
    [cell.regBtn setTag:10000+aIndex];
    [cell.regBtn addTarget:self action:@selector(regulation:) forControlEvents:UIControlEventTouchUpInside];

//    UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
//    backView.backgroundColor = [UIColor clearColor];
//    cell.backgroundView = backView;
    return  cell;
}

-(void)regulation:(id)sender 
{
    int index=[sender tag]-10000;
    CouponVO *couponVO=[m_AllCoupons objectAtIndex:index];
    CouponRule *couponrule = [[[CouponRule alloc] initWithCoupon:couponVO] autorelease];
    [self pushVC:couponrule animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index=[tableView tag]-100;
    CouponVO *couponVO=[m_AllCoupons objectAtIndex:index];
    return [self tableViewDetailCell:tableView couponVO:couponVO tableIndex:index];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //int index=[tableView tag]-100;
    return 200;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//设置行按钮样式
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)delloc
{
    [super dealloc];
}

@end
