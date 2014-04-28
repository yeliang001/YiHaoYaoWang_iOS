//
//  UseCoupon.m
//  TheStoreApp
//
//  Created by towne on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#define THREAD_STATUS_GET_MY_COUPON                1  //订单查询可用抵用卷
#define THREAD_STATUS_SAVE_COUPON_AND_CHECK_SMS    2  //保存抵用卷到订单并判定是否需要短信验证
#define THREAD_STATUS_DEL_COUPON                   3  //删除抵用卷

#define LOADMORE_HEIGHT        40
#define NEED_CHECK_PHONE      -27
#define NEED_CHECK_VALIDATION -30
#define NEED_NOT_CHECK         1
#define NEED_CHECK_DEL         -9


#import "UseCoupon.h"
#import "DoTracking.h"

@implementation UseCoupon
@synthesize m_NeedCheck;
@synthesize m_CouponNumber;
@synthesize m_OriginalCouponNumber;

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
    // Do any additional setup after loading the view from its nib.
    [self initMyCoupon];
}

//-----------------------初始化我的抵用卷列表--------------------------------
-(void)initMyCoupon
{
    [self.view setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    //iphone5
    CGRect rc = m_ScrollView.frame;
    rc.size.height = self.view.frame.size.height;
    rc.origin.y = OTS_IPHONE_NAVI_BAR_HEIGHT;
    m_ScrollView.frame = rc;
    
    [m_ScrollView setBackgroundColor:[UIColor clearColor]];
    [m_ScrollView setDelegate:self];
    [m_ScrollView setAlwaysBounceVertical:YES];
    
    m_LoadingMoreLabel=[[LoadingMoreLabel alloc] initWithFrame:CGRectMake(0, 0, 320, LOADMORE_HEIGHT)];
    
    m_PageIndex=1;
    m_AllCoupons=[[NSMutableArray alloc] init];
    m_CouponStatus=1;       //满足使用条件
    inputManually = NO;     //默认不是手动输入
    m_ThreadStatus=THREAD_STATUS_GET_MY_COUPON;
    [self setUpThread:YES];
}

-(void)updateMyCoupon
{    
    //删除scrollview所有子view
    for (UIView *view in [m_ScrollView subviews]) {
        if ([view isKindOfClass:[UITableView class]] || [view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
            DebugLog(@"view>>>>>>>>> %@",view);
        }
    }
    // base Y轴
    CGFloat yValue=5.0f;
    
    // --------------------------添加一张抵用卷------------------------------
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, yValue, 320, 31)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:ADD_A_COUPON];
    [label setTextColor:UIColorFromRGB(0x4c566c)];
    [label setFont:[UIFont systemFontOfSize:17.0]];
    [m_ScrollView addSubview:label];
    [label release];
    yValue += 33;
    
    // --------------------------抵用卷输入筐------------------------------
    couponNumFd = [[UITextField alloc] initWithFrame:CGRectMake(10, yValue, 205, 35)];
	couponNumFd.returnKeyType = UIReturnKeyDone; 
	[couponNumFd setDelegate:self];		
    couponNumFd.textAlignment = NSTextAlignmentLeft;
    couponNumFd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    couponNumFd.borderStyle = UITextBorderStyleRoundedRect;
    couponNumFd.placeholder = INPUT_COUPON_CODE; 
//    [myTextField setTextColor:UIColorFromRGB(0xcccccc)];	//
	[couponNumFd setFont:[UIFont systemFontOfSize:16.0f]];
    couponNumFd.clearsOnBeginEditing = YES;
    couponNumFd.adjustsFontSizeToFitWidth = YES;
    couponNumFd.clearButtonMode = UITextFieldViewModeUnlessEditing;
    
    // --------------------------使用抵用卷------------------------------
    couponUse=[[UIButton alloc] initWithFrame:CGRectMake(230, yValue, 76, 35)];
    [couponUse setBackgroundColor:[UIColor clearColor]];
    [couponUse setTitle:USE_COUPON forState:UIControlStateNormal];
    [couponUse setTitleColor:UIColorFromRGB(0xe35d23) forState:UIControlStateNormal];
    [couponUse setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [couponUse setBackgroundImage:[UIImage imageNamed:@"use.png"] forState:UIControlStateNormal];
    [couponUse.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [couponUse addTarget:self action:@selector(saveCouponSessionOrder) forControlEvents:UIControlEventTouchUpInside];
    
    yValue += 35;
    // 短信验证提示信息 uiview = imageview + uilable

    couponValidateInfo=[[UILabel alloc] initWithFrame:CGRectMake(30, yValue, 290, 40)];
    [couponValidateInfo setBackgroundColor:[UIColor clearColor]];
    [couponValidateInfo setText:@"提示"];
    [couponValidateInfo setTextColor:UIColorFromRGB(0xd53c3c)];
    [couponValidateInfo setNumberOfLines:2];
    [couponValidateInfo setFont:[UIFont systemFontOfSize:13.0]];
    [couponValidateInfo setHidden:YES];
    [m_ScrollView addSubview:couponValidateInfo];
    
    //提示的x图片

    couponWarningCros = [[UIButton alloc] initWithFrame:CGRectMake(5, yValue+6, 20, 20)];
    [couponWarningCros setBackgroundColor:[UIColor clearColor]];
    [couponWarningCros setBackgroundImage:[UIImage imageNamed:@"sec_val_warning_cross@2x.png"] forState:UIControlStateNormal];
    [couponWarningCros setHidden:YES];
    [m_ScrollView addSubview:couponWarningCros];
    
    yValue += 40;
    
    //------------------------ background view-------------------------
    CGRect roundCornderBgRect = CGRectMake(0
                                           , 5
                                           , 320
                                           , 150);
    roundCornerBgView = [UIButton buttonWithType:UIButtonTypeCustom];
    roundCornerBgView.frame = roundCornderBgRect;
    roundCornerBgView.backgroundColor = [UIColor clearColor];
    [roundCornerBgView addTarget:self action:@selector(resignTextFieldAction) forControlEvents:UIControlEventTouchUpInside];
    [roundCornerBgView addSubview:couponNumFd];
    [roundCornerBgView addSubview:couponUse];
    [m_ScrollView addSubview:roundCornerBgView];  //---->>>
    
    if ([m_AllCoupons count]==0) 
    {
        UILabel *msgLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 310, 40)];
        [msgLabel setBackgroundColor:[UIColor clearColor]];
        [msgLabel setTextColor:[UIColor colorWithRed:48.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1.0]];
        [msgLabel setFont:[UIFont systemFontOfSize:16.0]];
        [msgLabel setNumberOfLines:10];
        
        [m_ScrollView addSubview:msgLabel];
        [msgLabel release];
        [m_ScrollView setContentSize:CGSizeMake(320, [m_ScrollView frame].size.height)];
    } 
    else 
    {
        // --------------------------选择已有的抵用卷------------------------------
        label=[[UILabel alloc] initWithFrame:CGRectMake(10, yValue, 320,61)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setNumberOfLines:2];
        [label setText:SELECTED_EXSIT_COUPON];
        [label setTextColor:UIColorFromRGB(0x4c566c)];
        [label setFont:[UIFont systemFontOfSize:16.0]];
        [m_ScrollView addSubview:label];
        [label release];
        yValue += 63;
        
        int i;
        for (i=0; i<[m_AllCoupons count]; i++) {
            CGFloat height;
            height=121.0;
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
        [m_ScrollView setContentSize:CGSizeMake(320, yValue+20.0)];
        
        //加载更多
        if ([m_AllCoupons count]<m_CouponTotalNum) {
            [m_LoadingMoreLabel setFrame:CGRectMake(0, yValue, 320, LOADMORE_HEIGHT)];
            [m_ScrollView addSubview:m_LoadingMoreLabel];
            [m_ScrollView setContentSize:CGSizeMake(320, yValue+LOADMORE_HEIGHT)];
        }
    }
}

//-----------------------检查订单的接口回调----------------------------------------
-(void)setTaget:(id)taget finishSelector:(SEL)selector
{
    m_Taget=taget;
    m_FinishSelector=selector;
}


//-----------------------进入短信验证界面------------------------------------
-(void)enterCheckSMS{
    [self enterCheckSMS:nil];
}

-(void)enterCheckSMS:(NSString *)aPhoneNum
{
    // 修改一下 pushvc
    CouponSecValidate *_SecValidateVC;
    if ([self validatePhoneNumField:aPhoneNum]) {
        _SecValidateVC = [[[CouponSecValidate alloc] 
                           initWithNeedCheckResult:m_NeedCheck
                           couponNum:m_CouponNumber 
                           phoneNum:aPhoneNum
                           notifyTarget:self 
                           notifyAction:@selector(handleCheckSmsOK:)] autorelease];
    }
    else
    {
        _SecValidateVC = [[[CouponSecValidate alloc] 
                           initWithNeedCheckResult:m_NeedCheck
                           couponNum:m_CouponNumber 
                           notifyTarget:self 
                           notifyAction:@selector(handleCheckSmsOK:)] autorelease];
    }
    if(_SecValidateVC)
    [self pushVC:_SecValidateVC animated:YES fullScreen:YES];
}

//-------------------验证电话号码---------------------------------------------
-(BOOL)validatePhoneNumField:(NSString *)aPhoneNum
{
    BOOL passed = NO;
    
    if (aPhoneNum == nil || [aPhoneNum length] <= 0)
    {
        return passed;
    }
    else if ([aPhoneNum length] != 11)
    {
        return passed;
    }
    else
    {
        passed = YES;
    }
    
    return passed;
}

//-----------------------处理是否需要短信验证-----------------------------------
-(void)dealWithNeedCheckSMS
{
    if (m_NeedCheck!=nil && ![m_NeedCheck isKindOfClass:[NSNull class]]) {
        if ([m_NeedCheck.resultCode intValue] == NEED_CHECK_PHONE) {
        //------------------需要手机验证--------------------------------------  
            [self enterCheckSMS];
        }else if([m_NeedCheck.resultCode intValue] == NEED_CHECK_VALIDATION){
        //------------------只需要验证码验证-----------------------------------
            NSString *aBoundPhoneNum = [self getNumbersFromString:m_NeedCheck.errorInfo];
            [self enterCheckSMS:aBoundPhoneNum];
        } 
        else if([m_NeedCheck.resultCode intValue] == NEED_NOT_CHECK){
        //------------------保存抵用卷成功,转到订单详情--------------------------
            //用通知或代理去修改订单详情得抵用卷显示界面
            CATransition *animation = [CATransition animation]; 
            animation.duration = 0.3f;
            animation.timingFunction = UIViewAnimationCurveEaseInOut;
            [animation setType:kCATransitionPush];
            [animation setSubtype: kCATransitionFromLeft];
            [self.view.superview.layer addAnimation:animation forKey:@"Reveal"];
            if ([m_Taget respondsToSelector:m_FinishSelector]) {
                [m_Taget performSelector:m_FinishSelector withObject:m_CouponNumber];
            }
            
            // 需传入额外的couponNumber
//            NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:1];
//            [dic setSafeObject:m_CouponNumber forKey:@"couponNumber"];
//            JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_SaveCoupon extraPramaDic:dic] autorelease];
            JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_SaveCoupon extraPrama:m_CouponNumber, nil]autorelease];
            [DoTracking doJsTrackingWithParma:prama];
            
            [self removeSelf];
        }else
        {
        //------------------其他打出error信息---------------------------------
            if (inputManually == YES) 
            {
                couponValidateInfo.text = m_NeedCheck.errorInfo;
                couponValidateInfo.hidden = NO;
                couponWarningCros.hidden = NO;
                inputManually = NO;
            }
            else
            {
                //-----------如果返回－9就清除订单抵用卷---------------------------
                if ([m_NeedCheck.resultCode intValue] == NEED_CHECK_DEL) {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"您确定不在订单中使用该抵用券吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alert autorelease];
                    [alert setTag:NEED_CHECK_DEL];
                    [alert show];
                }
                else
                {
                    [self aLert:m_NeedCheck.errorInfo Tag:[m_NeedCheck.resultCode intValue]];
                }
            }

        }
    } else {
        [self showError:NET_ERROR];
    }
}

//----------------------------从字串中获取数字---------------------------------
-(NSString*)getNumbersFromString:(NSString*)String{
    NSArray* Array = [String componentsSeparatedByCharactersInSet:
                      [[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
    NSMutableArray *newArray = [[[NSMutableArray alloc] init] autorelease];
    for(NSString *obj in Array)
    {
        if (![obj isEqualToString:@""]) {
            [newArray addObject: obj];
        }
    }
    
    NSString* returnString = [newArray componentsJoinedByString:@"****"];
    return (returnString);
}

//----------------------保存抵用卷到订单---------------------------------------
-(void)saveCouponSessionOrder{

    [self resignTextFieldAction];
    BOOL validateSuccess = [self validateCouponNumField];
    if (validateSuccess)
    {
        inputManually = YES;
        m_ThreadStatus=THREAD_STATUS_SAVE_COUPON_AND_CHECK_SMS;
        [self setUpThread:YES];
    }
}

-(void)handleCheckSmsOK:(NSString *)aObj
{ 
    //--------------回调接口-------------------------------------------------
    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveCouponToOrder" object:aObj];
    [self.view.superview.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:@"Reveal"];
    
    [self stopThread];
    [self removeSelf];
}

-(void)resignTextFieldAction
{
    [couponNumFd resignFirstResponder];
}

-(BOOL)validateCouponNumField
{
    BOOL passed = NO;
    
    if (couponNumFd.text == nil || [couponNumFd.text length] <= 0)
    {
        couponValidateInfo.text = STR_COUPON_EMPTY;
    }
    else
    {
        self.m_CouponNumber = couponNumFd.text;
        couponValidateInfo.text=@"";
        passed = YES;
    }
    couponValidateInfo.hidden = passed;
    couponWarningCros.hidden = passed;
    
    return passed;
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
-(void)setUpThread:(BOOL)showLoading{
	if (!m_ThreadRunning) {
		m_ThreadRunning=YES;
//        [self showLoading:showLoading];
		[self otsDetatchMemorySafeNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
	}
}

//返回
-(IBAction)returnBtnClicked:(id)sender
{
    [self popSelfAnimated:YES];
}

//开启线程
-(void)startThread {
	while (m_ThreadRunning) {
		@synchronized(self) {
            [self showLoading];
            switch (m_ThreadStatus) {
                case THREAD_STATUS_SAVE_COUPON_AND_CHECK_SMS:{
                //-----------------保存抵用券到订单并判定是否需要短信验证----------------
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                    CouponService *couponService=[[CouponService alloc] init];
                    @try {
                        self.m_NeedCheck = [couponService saveCouponToSessionOrderV2:[GlobalValue getGlobalValueInstance].token couponNumber:m_CouponNumber];
                    }
                    @catch (NSException *exception) {
                    }
                    @finally {
                        [self stopThread];
                        [self performSelectorOnMainThread:@selector(dealWithNeedCheckSMS) withObject:nil waitUntilDone:NO];
                    }
                    [couponService release];
                    [pool drain];
                    break;
                }
                case THREAD_STATUS_DEL_COUPON:{
                //------------------删除抵用卷-------------------------------------
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                    CouponService *couponService=[[CouponService alloc] init];
                    @try {
                        self.m_NeedCheck = [couponService deleteCouponFromSessionOrder:[GlobalValue getGlobalValueInstance].token];
                    }
                    @catch (NSException *exception) {
                    }
                    @finally {
                        [self stopThread];
                        if ([m_NeedCheck.resultCode intValue]==1) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                CATransition *animation = [CATransition animation]; 
                                animation.duration = 0.3f;
                                animation.timingFunction = UIViewAnimationCurveEaseInOut;
                                [animation setType:kCATransitionPush];
                                [animation setSubtype: kCATransitionFromLeft];
                                [self.view.superview.layer addAnimation:animation forKey:@"Reveal"];
                                if ([m_Taget respondsToSelector:m_FinishSelector]) {
                                    [m_Taget performSelector:m_FinishSelector withObject:0];
                                }
                                [self removeSelf];
                            });
                        }
                        else
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self aLert:m_NeedCheck.errorInfo Tag:[m_NeedCheck.resultCode intValue]];
                            });
                        }

                    }
                    [couponService release];
                    [pool drain];
                    break;
                }
                case THREAD_STATUS_GET_MY_COUPON: {//获取订单的抵用卷
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                    CouponService *cServ=[[CouponService alloc] init];
                    Page *tempPage = nil;
                    @try {
                        tempPage=[cServ getCouponListForSessionOrder:[GlobalValue getGlobalValueInstance].token currentPage:[NSNumber numberWithInt:m_PageIndex] pageSize:[NSNumber numberWithInt:10]];
                    } @catch (NSException * e) {
                    } @finally {
                        if (tempPage!=nil && ![tempPage isKindOfClass:[NSNull class]]) {
                            [m_AllCoupons addObjectsFromArray:[tempPage objList]];
                            m_PageIndex++;
                            m_CouponTotalNum=[[tempPage totalSize] intValue];
                            [self performSelectorOnMainThread:@selector(updateMyCoupon) withObject:nil waitUntilDone:NO];
						} else {
                            [self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常，请检查网络配置..." waitUntilDone:NO];
                        }
                        [m_LoadingMoreLabel performSelectorOnMainThread:@selector(reset) withObject:self waitUntilDone:NO];
                        [self stopThread];
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
	//[[NSNotificationCenter defaultCenter] postNotificationName:@"MainWindowHideLoading" object:nil];
}

#pragma mark    scrollView相关delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self resignTextFieldAction];
    if (scrollView!=m_ScrollView || m_AllCoupons==nil || [m_AllCoupons count]>=m_CouponTotalNum) {
        return;
    }
    [m_LoadingMoreLabel scrollViewDidScroll:scrollView selector:@selector(getMoreCoupon) target:self];
}

-(void)tableView:(UITableView * )tableView didSelectRowAtIndexPath:(NSIndexPath * )indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中颜色
    int index = [tableView tag]-100;
    CouponVO *couponV2=[m_AllCoupons objectAtIndex:index];
    //设置勾选状态
    int i;
    int count= [m_AllCoupons count];
    
    for (i=0; i<count; i++) {
        if (i!=index && ![[couponV2 canUse] isEqualToString:@"false"]) {
            UIButton * button = (UIButton *)[self.view viewWithTag:1000+i];
            [button setHidden:YES];
        }
    }
    
    //修改一下 NO
    if (![[couponV2 canUse] isEqualToString:@"false"]) {
        done = NO;
        NSMutableDictionary *useinfo = [[NSMutableDictionary alloc] init];
        [useinfo setObject:[NSNumber numberWithInt:index] forKey:@"index"];
        NSTimer *_busTimer = [NSTimer timerWithTimeInterval:.1f target:self selector:@selector(showCheckBtn:) userInfo:useinfo repeats:NO];
        [useinfo release];
        [[NSRunLoop currentRunLoop] addTimer:_busTimer forMode:NSRunLoopCommonModes];
        do
        {
            [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
            
        }while (!done);
        
        //--------------------------保存抵用卷到订单----------------------------------
        CouponVO *couponV2=[m_AllCoupons objectAtIndex:index];
        m_CouponNumber = [[[couponV2 number]copy]autorelease];
        if (m_CouponNumber!= nil) {
            m_ThreadStatus=THREAD_STATUS_SAVE_COUPON_AND_CHECK_SMS;
            [self setUpThread:YES];
        }
    }  
}

-(void)showCheckBtn:(NSTimer *)timer
{
    NSNumber *aObj = [[timer userInfo] objectForKey:@"index"];
    UIButton * button = (UIButton *)[self.view viewWithTag:1000+[aObj intValue]];
    [button setHidden:NO];
    [self resignTextFieldAction];
    
    done = YES;
}

-(UIButton*)checkMarkView
{
    UIImage * image = [UIImage imageNamed:@"coupon_select_img.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(13.0, 40.0, image.size.width, image.size.height);
    button.frame = frame;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    return button;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableViewDetailCell:(UITableView *)aTableView couponVO:(CouponVO*)aCouponVO tableIndex:(int)aIndex
{
    UITableViewCell *cell=[aTableView dequeueReusableCellWithIdentifier:@"CouponCellInUse"];
    if (cell==nil) {
        NSArray *nibArray=[[NSBundle mainBundle] loadNibNamed:@"CouponCellInUse" owner:self options:nil];
        cell=(UITableViewCell *)[nibArray objectAtIndex:0];
        //"抵用卷描述："
         UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(120,5,200, 40)];
        [label setBackgroundColor:[UIColor clearColor]];
        NSString * c_description = [NSString stringWithFormat:@"满%@元抵%@元",aCouponVO.threshOld,aCouponVO.amount];
        [label setText:c_description];
//        [label setText:aCouponVO.description];
        [label setNumberOfLines:2];
        [label setFont:[UIFont systemFontOfSize:16.0]];
        [cell addSubview:label];
        [label release];
        
        //"抵用卷金额："
        label=[[UILabel alloc] initWithFrame:CGRectMake(40, 10, 60, 50)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:[NSString stringWithFormat:@"%@元",aCouponVO.amount]];
        [label setTextAlignment:NSTextAlignmentRight];
        [label setTextColor:[UIColor colorWithRed:204.0/255.0 green:0 blue:0 alpha:1.0]];
        [label setFont:[UIFont systemFontOfSize:22.0]];
        [cell addSubview:label];
        [label release];
        
        //"抵用卷有效日期："
        label=[[UILabel alloc] initWithFrame:CGRectMake(120, 35, 200, 40)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:[NSString stringWithFormat:@"有效日期:%@ - %@",[OTSUtility NSDateToNSStringDate:aCouponVO.beginTime],[OTSUtility NSDateToNSStringDate:aCouponVO.expiredTime]]];
        [label setFont:[UIFont systemFontOfSize:12.0]];
        [label setNumberOfLines:2];
        [label setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
        [cell addSubview:label];
        [label release];
        //"抵用卷规则按钮："
        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(120, 70, 76, 30)];
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
        //勾选按钮 若非选中 默认隐藏
        
         button=[[UIButton alloc] initWithFrame:CGRectMake(13.0, 40.0, 25, 25)];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setBackgroundImage:[UIImage imageNamed:@"goodReceiver_sel.png"] forState:UIControlStateNormal];
        if (![aCouponVO.number isEqualToString:m_CouponNumber]) {
            [button setHidden:YES];
        }
        else
        {
            [button setHidden:NO];
        }

        [button setUserInteractionEnabled:NO];
        [button setTag:1000+aIndex];
        [cell addSubview:button];
        [button release];
        
        if([[aCouponVO canUse] isEqualToString:@"false"])
        {
            for ( UIView* view in cell.contentView.subviews ) 
            {
                if ([view isKindOfClass:[UIImageView class]]) {
                    UIImageView *mm = (UIImageView *)view;
                    [mm setImage:[UIImage imageNamed:@"couponcellinuseundo@2x.png"]];
                }
            }
            
            for (UIView *view in cell.subviews) {
                if ([view isKindOfClass:[UILabel class]]) {
                    UILabel *lm = (UILabel *)view;
                    if ([[lm text] isEqualToString:[NSString stringWithFormat:@"%@元",aCouponVO.amount]]) {
                        //"抵用卷金额：不可用时的位置调整"
                        [lm setFrame:CGRectMake(40, 20, 60, 50)];
                    }
                }
            }
            
            CGRect rect = CGRectMake(0, 2, cell.bounds.size.width*0.35, cell.bounds.size.height);
            rect.size.height-=10;
            UIView * view  = [[UIView alloc] initWithFrame:rect];
            [view setBackgroundColor:[UIColor whiteColor]];
            view.layer.opacity = 0.7;
            [cell addSubview:view];
            [view release];
            [cell addSubview:label];
            
            UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(8, 12, 100, 20)];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTag:10000+aIndex];
            [button setTitle:NOT_ACHIEVE_USE forState:UIControlStateNormal];
            [button addTarget:self action:@selector(regulation:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:UIColorFromRGB(0xcc0001) forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            [cell addSubview:button];
            [button release];
        }   
        
    }
    UIView *tempView = [[[UIView alloc] init] autorelease];
    [cell setBackgroundView:tempView];
    [cell setBackgroundColor:[UIColor clearColor]]; 
    return  cell;
}

-(void)regulation:(id)sender 
{
    int index=[sender tag]-10000;
    CouponVO *couponVO=[m_AllCoupons objectAtIndex:index];
    CouponRule *couponrule = [[[CouponRule alloc] initWithCoupon:couponVO] autorelease];
    //[self pushVC:couponrule animated:YES];
    [self pushVC:couponrule animated:YES fullScreen:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index=[tableView tag]-100;
    CouponVO *couponVO=[m_AllCoupons objectAtIndex:index];
    return [self tableViewDetailCell:tableView couponVO:couponVO tableIndex:index];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    int index=[tableView tag]-100;
    return 200;
}

#pragma mark textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *) aTextfield {
    [aTextfield resignFirstResponder];
    DebugLog(@"atextfield %@",[aTextfield text]);
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *) aTextfield
{
    couponWarningCros.hidden = YES;
    couponValidateInfo.hidden = YES;
    return YES;
}

-(void)dealloc
{
    OTS_SAFE_RELEASE(couponValidateInfo);
    OTS_SAFE_RELEASE(couponWarningCros);
    OTS_SAFE_RELEASE(couponNumFd);
    OTS_SAFE_RELEASE(m_NeedCheck);
    OTS_SAFE_RELEASE(m_OriginalCouponNumber);
    OTS_SAFE_RELEASE(m_CouponNumber);
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)aLert:(NSString*)aMessage Tag:(int)aTag
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" 
                                                     message:aMessage 
                                                    delegate:self 
                                           cancelButtonTitle:@"确定" 
                                           otherButtonTitles:nil];
    [alert setTag:aTag];
    [alert show];
    [alert release];
}

#pragma mark 设置alert点击操作
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    //弹出提示后，抵用券前面的圆点不勾选状态
    int i;
    int count= [m_AllCoupons count];
    for (i=0; i<count; i++) {
        UIButton * button = (UIButton *)[self.view viewWithTag:1000+i];
        CouponVO *aCouponVO=[m_AllCoupons objectAtIndex:i];
        
        if(button.hidden == NO){
            [button setHidden:YES];
        }
        if ([aCouponVO.number isEqualToString:m_OriginalCouponNumber]) {
            [button setHidden:NO];
        }
    }
    
    switch (alertView.tag) {
        case 1: {
            if (buttonIndex==0) {
                
            }
            break;
        }
        case 2: {
            if (buttonIndex==0) {
                //
            }
            break;
        }
        case 3: {
            if (buttonIndex==0) {
                //
            }
            break;
        }
        case 4: {
            if (buttonIndex==0) {
                //
            }
            break;
        }
        case 5: {
            if (buttonIndex==0) {
                //
            }
            break;
        }
        case 6: {
            if (buttonIndex==0) {
                //
            }
            break;
        }
        case -9: {
            if (buttonIndex==1) {
                //清除订单中使用的抵用卷
                int i;
                int count= [m_AllCoupons count];
                for (i=0; i<count; i++) {
                    UIButton * button = (UIButton *)[self.view viewWithTag:1000+i];
                    if(button.hidden == NO){
                        [button setHidden:YES];
                    }
                }
                m_ThreadStatus=THREAD_STATUS_DEL_COUPON;
                [self setUpThread:YES];
            }
            break;
        }
        default:
            break;
    }
    [[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:NO];
}

@end
