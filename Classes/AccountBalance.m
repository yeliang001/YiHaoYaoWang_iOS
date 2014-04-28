//
//  AccountBalance.m
//  TheStoreApp
//
//  Created by jiming huang on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AccountBalance.h"
#import <QuartzCore/QuartzCore.h>
#import "RegexKitLite.h"
#import "PayService.h"
#import "SavePayByAccountResult.h"
#import "AlertView.h"
#import "OTSSecurityValidationVC.h"
#import "OTSNaviAnimation.h"
#import "NeedCheckResult.h"
#import "GlobalValue.h"
#import "UIDeviceHardware.h"
#import "OTSActionSheet.h"

#define THREAD_STATUS_SAVE_ACCOUNT_PAY_MONEY    1
#define THREAD_STATUS_GET_NEED_CHECK_SMS    2

#define CONTACT_CUSTOM_SERVICE_TABLEVIEW    1

@interface AccountBalance ()
@property (retain, nonatomic) IBOutlet UILabel *avalableAccountLabel;
@property (retain, nonatomic) IBOutlet UILabel *needPayAccountLabel;
@property (retain, nonatomic) IBOutlet UILabel *cardNumLabel;

@end

@implementation AccountBalance
@synthesize m_InputDictionay;
@synthesize payStyle;

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.isFullScreen)
    {
        [self strechViewToBottom:m_ScrollView];
    }
    
    [self initAccountBalance];
}

-(void)initAccountBalance
{
    m_AccountBalance=[[m_InputDictionay objectForKey:@"AccountBalance"] doubleValue];
    m_FrozenMoney=[[m_InputDictionay objectForKey:@"FrozenMoney"] doubleValue];
    m_NeedPayMoney=[[m_InputDictionay objectForKey:@"NeedPayMoney"] doubleValue];
//    BOOL showBalanceDetail=[[m_InputDictionay objectForKey:@"ShowBalanceDetail"] boolValue];
    
    [m_ScrollView setBackgroundColor:[UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1.0]];
    
    if (payStyle == 1) {    // 礼品卡余额支付
        [m_TitleLabel setText:@"使用礼品卡账户余额"];
        numberOfGiftCard = [[m_InputDictionay objectForKey:@"NumberOfGiftCard"]intValue];
        [self.cardNumLabel setText:[NSString stringWithFormat:@"已绑定%d张礼品卡",numberOfGiftCard]];
        [self.cardNumLabel setHidden:NO];
        [self.avalableAccountLabel setText:[NSString stringWithFormat:@"礼品卡账户可用余额： ￥%.2f",m_AccountBalance]];
    }else{
        [self.avalableAccountLabel setText:[NSString stringWithFormat:@"账户可用余额： ￥%.2f",m_AccountBalance]];
    }
    
    if (m_AccountBalance>-0.0001 && m_AccountBalance<0.0001) {//账户余额为0
        [m_TopRightBtn setHidden:YES];
        UIView* nullView = [[UIView alloc]initWithFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT, ApplicationWidth, self.view.frame.size.height-NAVIGATION_BAR_HEIGHT)];
        [nullView setBackgroundColor:[UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1.0]];
        
        UIImageView* nullImageView = [[UIImageView alloc]initWithFrame:CGRectMake(95, ((nullView.frame.size.height-120)/2)-44, 125, 100)];
        [nullImageView setImage:[UIImage imageNamed:@"piggy"]];
        [nullView addSubview:nullImageView];
        [nullImageView release];
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(60, nullImageView.frame.origin.y+130, 200, 60)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setNumberOfLines:0];
        if (payStyle == 1) {
            if (m_FrozenMoney > 0) {
                [label setText:[NSString stringWithFormat:@"礼品卡账户可用余额为￥0，\n被冻结金额为￥%.2f,请选择其他支付方式支付。",m_FrozenMoney]];
            }else
                [label setText:@"礼品卡账户可用余额为￥0，请选择其他支付方式支付。\n"];
        }else{
            if (m_FrozenMoney > 0) {
                [label setText:[NSString stringWithFormat:@"现金账户可用余额为￥0，\n被冻结金额为￥%.2f,请选择其他支付方式支付。 ",m_FrozenMoney]];
            }else
                [label setText:@"现金账户可用余额为￥0，请选择其他支付方式支付。\n"];
        }
        [label setFont:[UIFont systemFontOfSize:15.0]];
        [nullView addSubview:label];
        [label release];
    
        UILabel* warinLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(20, nullView.frame.size.height-60, 280, 40)];
        [warinLabel1 setText:@"友情提示：1号药店客户端暂不支持礼品卡充值，如需充值请在1号药店网站进行充值"];
        [warinLabel1 setTextColor:[UIColor lightGrayColor]];
        [warinLabel1 setBackgroundColor:[UIColor clearColor]];
        [warinLabel1 setFont:[UIFont systemFontOfSize:15.0]];
        [warinLabel1 setNumberOfLines:0];
        [nullView addSubview:warinLabel1];
        [warinLabel1 release];
    
        [self.view addSubview:nullView];
        [nullView release];
        return;
    }
    
    double yValue=0.0;
    double height=194.0;
    
    [self.needPayAccountLabel setText:[NSString stringWithFormat:@"￥%.2f", ABS(m_NeedPayMoney)]];
    
    [m_TextField setBorderStyle:UITextBorderStyleRoundedRect];
    [m_TextField setPlaceholder:@"请输入支付金额"];
    if (m_AccountBalance>=m_NeedPayMoney) {
        [m_TextField setText:[NSString stringWithFormat:@"￥%.2f",ABS(m_NeedPayMoney)]];
    } else {
        [m_TextField setText:[NSString stringWithFormat:@"￥%.2f",ABS(m_AccountBalance)]];
    }
    [m_TextField setFont:[UIFont systemFontOfSize:15.0]];
    [m_TextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [m_TextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [m_TextField setKeyboardType:UIKeyboardTypeDecimalPad];
    
    //全额支付
    double xValue=20.0;
    double fullMoney=m_AccountBalance>=m_NeedPayMoney?m_NeedPayMoney:m_AccountBalance;
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(xValue, 139, 76, 30)];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setBackgroundImage:[UIImage imageNamed:@"gray_btn.png"] forState:UIControlStateNormal];
    [button setTitle:[NSString stringWithFormat:@"￥%.2f",fullMoney] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [[button titleLabel] setFont:[UIFont systemFontOfSize:15.0]];
    [button addTarget:self action:@selector(fullPayment:) forControlEvents:UIControlEventTouchUpInside];
    [m_ScrollView addSubview:button];
    [button release];
    xValue+=86.0;
    //十位
    int intValue=[[NSNumber numberWithFloat:m_NeedPayMoney] intValue];
    double money=m_NeedPayMoney-intValue/100*100;
    if (intValue/10%10!=0 && fullMoney>money) {
        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(xValue, 139, 58, 30)];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setBackgroundImage:[UIImage imageNamed:@"gray_short_btn.png"] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"￥%.2f",money] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [[button titleLabel] setFont:[UIFont systemFontOfSize:15.0]];
        [button addTarget:self action:@selector(partPayment:) forControlEvents:UIControlEventTouchUpInside];
        [m_ScrollView addSubview:button];
        [button release];
        xValue+=68.0;
    }
    //个位
    money=m_NeedPayMoney-intValue/10*10;
    if (intValue%10!=0 && fullMoney>money) {
        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(xValue, 139, 58, 30)];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setBackgroundImage:[UIImage imageNamed:@"gray_short_btn.png"] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"￥%.2f",money] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [[button titleLabel] setFont:[UIFont systemFontOfSize:15.0]];
        [button addTarget:self action:@selector(partPayment:) forControlEvents:UIControlEventTouchUpInside];
        [m_ScrollView addSubview:button];
        [button release];
        xValue+=68.0;
    }
    //小数位
    money=m_NeedPayMoney-intValue;
    if (money>0 && fullMoney>money) {
        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(xValue, 139, 58, 30)];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setBackgroundImage:[UIImage imageNamed:@"gray_short_btn.png"] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"￥%.2f",money] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [[button titleLabel] setFont:[UIFont systemFontOfSize:15.0]];
        [button addTarget:self action:@selector(partPayment:) forControlEvents:UIControlEventTouchUpInside];
        [m_ScrollView addSubview:button];
        [button release];
    }
    
    yValue+=height+14.0;
    
    //完成按钮
    UIButton *OKBtn=[[UIButton alloc] initWithFrame:CGRectMake(23, yValue, 274, 40)];
    [OKBtn setBackgroundColor:[UIColor clearColor]];
    [OKBtn setBackgroundImage:[UIImage imageNamed:@"orange_long_btn.png"] forState:UIControlStateNormal];
    [OKBtn setTitle:@"完 成" forState:UIControlStateNormal];
    [OKBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[OKBtn titleLabel] setFont:[UIFont boldSystemFontOfSize:20.0]];
    [OKBtn addTarget:self action:@selector(finishBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [m_ScrollView addSubview:OKBtn];
    [OKBtn release];
    yValue+=55.0;
    
    //提示
    if (m_AccountBalance<m_NeedPayMoney) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(23,yValue,274,35)];
        [view.layer setBorderWidth:1.0];
        [view.layer setBorderColor:[[UIColor colorWithRed:255.0/255.0 green:219.0/255.0 blue:167.0/255.0 alpha:1.0] CGColor]];
        [view setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:254.0/254.0 blue:238.0/255.0 alpha:1.0]];
        [m_ScrollView addSubview:view];
        [view release];
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 274, 35)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:@"剩余部分选择其他支付方式支付"];
        [label setFont:[UIFont systemFontOfSize:11.0]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setAdjustsFontSizeToFitWidth:YES];
        [view addSubview:label];
        [label release];
    }
    UILabel* warinLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, m_ScrollView.frame.size.height-60, 280, 40)];
    [warinLabel setText:@"友情提示：1号药店客户端暂不支持礼品卡充值，如需充值请在1号药店网站进行充值"];
    [warinLabel setTextColor:[UIColor lightGrayColor]];
    [warinLabel setBackgroundColor:[UIColor clearColor]];
    [warinLabel setFont:[UIFont systemFontOfSize:15.0]];
    [warinLabel setNumberOfLines:0];
    [m_ScrollView addSubview:warinLabel];
    [warinLabel release];
    
    [m_ScrollView setContentSize:CGSizeMake(320, [m_ScrollView frame].size.height+1)];
}

-(void)setTaget:(id)taget finishSelector:(SEL)selector type:(int)type
{
    m_Taget=taget;
    m_FinishSelector=selector;
    m_Type=type;
}

-(IBAction)cancelBtnClicked:(id)sender
{
    [self.view.superview.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:@"Reveal"];
    [self removeSelf];
}

-(IBAction)finishBtnClicked:(id)sender
{
    if ([m_TextField text]!=nil && ![[m_TextField text] isEqualToString:@""] && [[[m_TextField text] substringWithRange:NSMakeRange([[m_TextField text] length]-1, 1)] isEqualToString:@"."]) {
        [m_TextField setText:[[m_TextField text] substringWithRange:NSMakeRange(0, [[m_TextField text] length]-1)]];
    }
#warning 此处需要验证一下手机是否绑定 -(BindMobileResult *)isBindMobile:(NSString *)token 0119772: 【余额】若某账号24小时内已验证过一次，解绑手机之后，再使用余额，没有进入绑定手机流程

    NSString *resultStr=[[m_TextField text] stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    if (resultStr==nil || [resultStr isEqualToString:@""] || [resultStr isEqualToString:@"0"] || [resultStr isEqualToString:@"0.0"] || [resultStr isEqualToString:@"0.00"]) {
        m_PayMoney=0.0;
        m_ThreadState=THREAD_STATUS_GET_NEED_CHECK_SMS;
        [self setUpThread];
    } else {
        m_PayMoney=[resultStr doubleValue];
        m_ThreadState=THREAD_STATUS_GET_NEED_CHECK_SMS;
        [self setUpThread];
    }
    [m_TextField resignFirstResponder];
}

//全额支付
-(void)fullPayment:(id)sender
{
    double fullMoney=m_AccountBalance>=m_NeedPayMoney?m_NeedPayMoney:m_AccountBalance;
    [m_TextField setText:[NSString stringWithFormat:@"￥%.2f",fullMoney]];
}

//部分支付
-(void)partPayment:(id)sender
{
    UIButton *button=sender;
    NSString *str=[button titleForState:UIControlStateNormal];
    [m_TextField setText:str];
}

//保存余额支付金额成功
-(void)saveAccountPayMoneySuccess
{
    if (m_NeedCheck!=nil && ![m_NeedCheck isKindOfClass:[NSNull class]] && [m_NeedCheck.resultCode intValue]!=0) {//短信验证过
    } else {
        [self cancelBtnClicked:nil];
    }
    if ([m_Taget respondsToSelector:m_FinishSelector]) {
        [m_Taget performSelector:m_FinishSelector withObject:[NSNumber numberWithFloat:m_PayMoney]];
    }
}

//保存余额支付金额错误显示
-(void)showError:(NSString *)errorInfo
{
    [AlertView showAlertView:nil alertMsg:errorInfo buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
}

-(void)handleCheckSmsOK:(NSString*)aValidateCode
{
    [self removeSelf];
    
    if (m_ValidCode!=nil) {
        [m_ValidCode release];
    }
    m_ValidCode=[aValidateCode retain];
    m_ThreadState=THREAD_STATUS_SAVE_ACCOUNT_PAY_MONEY;
    [self setUpThread];
}

//进入短信验证界面
-(void)enterCheckSMS
{
    if (m_SecValidateVC!=nil) {
        [m_SecValidateVC release];
    }
    m_SecValidateVC=[[OTSSecurityValidationVC alloc] initWithNeedCheckResult:m_NeedCheck notifyTarget:self notifyAction:@selector(handleCheckSmsOK:)];
    
    [self.view addSubview:m_SecValidateVC.view];
    [self.view.layer addAnimation:[OTSNaviAnimation animationPushFromRight] forKey:@"Reveal"];
}

//处理是否需要短信验证
-(void)dealWithNeedCheckSMS
{
    if (m_NeedCheck!=nil && ![m_NeedCheck isKindOfClass:[NSNull class]]) {
   // if (1) {
        if ([m_NeedCheck.resultCode intValue]!=0) {
            [self enterCheckSMS];
        } else {
            m_ThreadState=THREAD_STATUS_SAVE_ACCOUNT_PAY_MONEY;
            [self setUpThread];
        }
    } else {
        [self showError:@"网络异常，请检查网络配置..."];
    }
}

#pragma mark 建立线程
-(void)setUpThread 
{
	if (!m_ThreadRunning) 
    {
//		[[NSNotificationCenter defaultCenter] postNotificationName:@"MainWindowShowLoading" object:[NSNumber numberWithBool:YES]];
        [self showLoading:YES];
        
		m_ThreadRunning=YES;
		[self otsDetatchMemorySafeNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
	}
}

#pragma mark 开启线程
-(void)startThread {
	while (m_ThreadRunning) {
		@synchronized(self){
            switch (m_ThreadState) {
                case THREAD_STATUS_GET_NEED_CHECK_SMS: {//是否需要短信验证
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
                    PayService *payService=[[PayService alloc] init];
                    
                    __block NeedCheckResult *tempResult = nil;
                    [self tryCatch:^{
                        tempResult = [payService needSmsCheck:[GlobalValue getGlobalValueInstance].token
                                                 payByAccount:[NSNumber numberWithFloat:m_PayMoney]];
                    } finally:^{
                        if (m_NeedCheck!=nil) {
                            [m_NeedCheck release];
                        }
                        if (tempResult!=nil && ![tempResult isKindOfClass:[NSNull class]]) {
                            m_NeedCheck=[tempResult retain];
                        } else {
                            m_NeedCheck=nil;
                        }
                        [self stopThread];
//                        m_NeedCheck.mobile = nil;
//                        m_NeedCheck.resultCode = [NSNumber numberWithInt:1];
                        [self performSelectorOnMainThread:@selector(dealWithNeedCheckSMS) withObject:nil waitUntilDone:NO];
                    }];
                    
                    [payService release];
                    [pool drain];
                    break;
                }
                case THREAD_STATUS_SAVE_ACCOUNT_PAY_MONEY: {//余额支付，保存余额支付金额
                    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
					PayService *pServ=[[PayService alloc] init];
                    if (m_ValidCode==nil) {
                        m_ValidCode=@"";
                    }
                    SavePayByAccountResult *tempResult;
                    @try {
                        if (payStyle == 1) {// 礼品卡余额支付
                            tempResult=[pServ savePayByAccount:[GlobalValue getGlobalValueInstance].token payByAccount:[NSNumber numberWithFloat:m_PayMoney] validCode:m_ValidCode type:[NSNumber numberWithInt:m_Type] accountType:[NSNumber numberWithInt:2]];
                        }else{
                            tempResult=[pServ savePayByAccount:[GlobalValue getGlobalValueInstance].token payByAccount:[NSNumber numberWithFloat:m_PayMoney] validCode:m_ValidCode type:[NSNumber numberWithInt:m_Type]];
                        }
                        
                    } @catch (NSException * e) {
                    } @finally {
                        if (tempResult!=nil && ![tempResult isKindOfClass:[NSNull class]]) {
                            int result=[[tempResult resultCode] intValue];
                            if (result==1) {//成功
                                [self performSelectorOnMainThread:@selector(saveAccountPayMoneySuccess) withObject:self waitUntilDone:NO];
                            } else {
                                [self performSelectorOnMainThread:@selector(showError:) withObject:[tempResult errorInfo] waitUntilDone:NO];
                            }
                        } else {
                            [self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常，请检查网络配置..." waitUntilDone:NO];
                        }
						[pServ release];
                        [self stopThread];
                    }
                    [pool drain];
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

#pragma mark actionsheet相关
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            UIDeviceHardware *hardware=[[UIDeviceHardware alloc] init];
            NSRange range = [[hardware platformString] rangeOfString:@"iPhone"];
            if (range.length <= 0) {
                [[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:YES];
                [AlertView showAlertView:nil alertMsg:@"您的设备不支持此项功能,感谢您对1号药店的支持!" buttonTitles:nil alertTag:ALERTVIEW_TAG_COMMON];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000070958"]];
            }
            [hardware release];
            break;
        }
        default:
            break;
    }
}

#pragma mark textfield相关
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField text]==nil || [[textField text] isEqualToString:@""]) {
        [textField setText:@"￥"];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    if (range.location==0 && range.length==0 && ![string isEqualToString:@""]) {
//        if ([textField text]==nil || [[textField text] isEqualToString:@""]) {
//            [textField setText:[NSString stringWithFormat:@"￥%@",string]];
//        }
//        return NO;
//    } else
    if (range.location==0 && range.length==1 && [string isEqualToString:@""]) {
        return NO;
    } else {
        
        NSString *resultStr=[[textField text] stringByReplacingCharactersInRange:range withString:string];
        NSString *resultMoneyStr;
        if (range.location==0 && range.length==0 && ![string isEqualToString:@""]) {
            resultMoneyStr = string;
        }else{
            resultMoneyStr=[resultStr stringByReplacingOccurrencesOfString:@"￥" withString:@""];
        }
        if ([resultMoneyStr isEqualToString:@""]) {
            return YES;
        } else {
            BOOL matched=NO;
            if ([resultMoneyStr isMatchedByRegex:@"^0[0-9]$"]) {
                matched=NO;
            } else if ([resultMoneyStr isMatchedByRegex:@"^0$"]) {
                matched=YES;
            } else if ([resultMoneyStr isMatchedByRegex:@"^0.[0-9]?[0-9]?$"]) {
                matched=YES;
            } else if ([resultMoneyStr isMatchedByRegex:@"^[1-9][0-9]*$"]) {
                matched=YES;
            } else if ([resultMoneyStr isMatchedByRegex:@"^[1-9][0-9]*.[0-9]?[0-9]?$"]) {
                matched=YES;
            } else {
                matched=NO;
            }
            
            if (matched) {
                NSNumberFormatter *formatter=[[NSNumberFormatter alloc] init];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
                NSNumber *payNumber=[formatter numberFromString:resultMoneyStr];
                [formatter release];
                double minValue=m_AccountBalance<m_NeedPayMoney?m_AccountBalance:m_NeedPayMoney;
                if ([payNumber doubleValue]>minValue) {
                    [m_TextField setText:[NSString stringWithFormat:@"￥%.2f",minValue]];
                    return NO;
                } else {
                    if (range.location==0 && range.length==0 && ![string isEqualToString:@""]) {
                        if ([textField text]==nil || [[textField text] isEqualToString:@""]) {
                            [textField setText:[NSString stringWithFormat:@"￥%@",string]];
                        }
                        return NO;
                    }else
                        return YES;
                }
            } else {
                return NO;
            }
        }
    }
}

#pragma mark -
-(void)releaseMyResoures
{
    OTS_SAFE_RELEASE(m_InputDictionay);
    OTS_SAFE_RELEASE(m_NeedCheck);
    OTS_SAFE_RELEASE(m_SecValidateVC);
    OTS_SAFE_RELEASE(m_ValidCode);
    
    // release outlet
    OTS_SAFE_RELEASE(m_ScrollView);
    OTS_SAFE_RELEASE(m_TitleLabel);
    OTS_SAFE_RELEASE(m_TopRightBtn);
}

- (void)viewDidUnload
{
    [self setAvalableAccountLabel:nil];
    [self setNeedPayAccountLabel:nil];
    [self setCardNumLabel:nil];
    [super viewDidUnload];
    
    [self releaseMyResoures];
}


- (void)dealloc
{
    [self releaseMyResoures];
    
    [_avalableAccountLabel release];
    [_needPayAccountLabel release];
    [_cardNumLabel release];
    [super dealloc];
}

#pragma mark -
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[m_TextField resignFirstResponder];
}

@end
