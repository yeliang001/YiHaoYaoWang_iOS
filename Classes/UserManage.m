#import "UserManage.h"

#import "UserVO.h"
#import "PhoneCartViewController.h"
#import "UserService.h"
#import "GlobalValue.h"
#import "Trader.h"
#import "VerifyCodeVO.h"
#import "FeedbackService.h"
#import <QuartzCore/QuartzCore.h>
#import "CartService.h"
#import "CartVO.h"
#import "FavoriteService.h"
#import "LocalCartService.h"
#import "LocalCartItemVO.h"
#import "TheStoreAppAppDelegate.h"
#import "RegexKitLite.h"
#import "ErrorStrings.h"
#import "DoTracking.h"
#import "OTSAlertView.h"
#import "OTSUnionLoginView.h"
#import "OTSAliPayWebView.h"
#import "OTSNaviAnimation.h"
#import "OTSOnlinePayNotifier.h"
#import "OTSServiceHelper.h"

#import "YWUserLoginHelper.h"
#import "LoginResultInfo.h"
#import "YWUserService.h"
#import "GetIPAddress.h"
#import "RegistResultInfo.h"
#import "UserInfo.h"
#import "MobClick.h"

#import "AlipayHelper.h"

#define START_LOGIN  1
#define START_UNION_LOGIN   5
#define START_REGISTE  2
#define START_FORGETPWD  3
#define START_MODIFY      4
#define ALERTVIEW_TAG_OTHERS 199

#define SVHIGHT  44
#define REG_PLACEHOLDER      @" 注册用手机号码"
#define REG_PHONE_EMPTY      @" 手机号码不能为空，请输入"
#define REG_PHONE_CHECK11    @" 请输入11位手机号,您输入了%d位"
#define REG_PHONE_CHECKINUSE @" 该手机已经绑定其他帐户，请重新输入"
#define REG_CODE_DEFAULT     @" 请输入验证码"
#define REG_CODE_LENGTH  6
#define REG_CODE_ERROR       @" 请输入%d位验证码，您输入了%d位"
#define REG_CODE_EMPTY       @" 验证码不能为空，请输入"
#define REG_CODE_CHECK       @" 验证码不正确，请重新输入"
#define REG_RFBTN_TEXT       @" 重新获取验证码"
#define REG_RFBTN1_TEXT      @" 重新获取验证码(%ds)"
#define OFFSETMAX      15.0

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface UserManage ()
{
}
@property (retain) NSTimer*     _timer;

@property(nonatomic, retain)OTSUnionLoginView* unionLoginView;
@property (retain, nonatomic) IBOutlet UIView *loginVerifyView;
@property (retain, nonatomic) IBOutlet UITextField *loginVerifyTF;
@property (retain, nonatomic) IBOutlet UIImageView *loginVerifyImageView;
@property (retain, nonatomic) NSString* tempoToken;
@property (nonatomic)BOOL isNeedRestIdState;
-(void)logoutSinaAccount;
@end

@implementation UserManage
@synthesize CallTag, verifycodeVO, aliPlayWebView,_timer,tempoToken;
@synthesize m_UserName, m_NickName, m_UserImg, m_Cocode, unionLoginView,isNeedRestIdState
, quitWithAnimation = _quitWithAnimation;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.quitWithAnimation = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    DebugLog(@"===> viewDidLoad start %@", [NSDate date]);
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor redColor]];
    [loginView setFrame:CGRectMake(0, 0, ApplicationWidth, ApplicationHeight)];
    [user_registeView setFrame:CGRectMake(0, 0, ApplicationWidth, ApplicationHeight)];
    [user_phoneregisteScrollview setFrame:CGRectMake(0, SVHIGHT, 320, ApplicationHeight-NAVIGATION_BAR_HEIGHT)];
    
    // 注册页面默认勾选同意协议
    isAgreeAgreement = YES;
    // 支付宝登录视图
//    self.aliPlayWebView = [[[OTSAliPayWebView alloc] initWithFrame:self.view.bounds] autorelease];
//    aliPlayWebView.aliPayDelegate = self;
//    [self.view addSubview:aliPlayWebView];
    
    // 联合登录
//    self.unionLoginView = [[[OTSUnionLoginView alloc] initWithFrame:CGRectZero] autorelease];
//    [unionLoginView setYPos:200];
//    unionLoginView.delegate = self;
//    [loginScrollView addSubview:unionLoginView];
    
    
	[UIView setAnimationsEnabled:NO];
	[self.view addSubview:loginView];
    m_userTool = [UserManageTool sharedInstance];
	CallTag=0;
    registShowPwd=NO;
    
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSinaAccount) name:@"LogoutSina" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountAutoRetrieve) name:@"AccountAutoRetrieve" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeViewFromTabBar) name:@"RemoveUserManageFromTabbar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oneMallLoginSuccess) name:@"OneMallUnionLoginOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayLoginFinished:) name:kYaoNitifyAlipayLogin object:nil];
    

    [registmainScrollview setAlwaysBounceVertical:YES];
    [registmainScrollview setDelegate:self];
    [loginScrollView setAlwaysBounceVertical:YES];
    [phoneverificationmainScrollview setAlwaysBounceVertical:YES];
    [phoneverificationmainScrollview setDelegate:self];
    [passSettingMainScrollview setAlwaysBounceVertical:YES];
    [passSettingMainScrollview setDelegate:self];
    [passSettingPWD setDelegate:self];
    [phoneregisteNum setDelegate:self];
    [phoneverificationCodeReFetch setTitle:REG_RFBTN_TEXT forState:UIControlStateNormal];

    DebugLog(@"===> viewDidLoad end %@", [NSDate date]);
}

-(void)keyboardWillShow
{
}

- (void)accountAutoRetrieve
{
    [rememberMeBtn setTitle:@"√" forState:UIControlStateNormal];
    DebugLog(@"user %@",[[UserManageTool sharedInstance] GetUser]);
    loginTextfieldName.text = [[UserManageTool sharedInstance] GetTheOneStoreAccount];

    loginTextfieldCode.secureTextEntry = YES;
}

-(void)removeViewFromTabBar
{
    if (CallTag==kEnterLoginFromWeRock || CallTag==kEnterLoginFromGrouponDetail) {
        [self.view.superview.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:@"Reveal"];
    } else if (self.quitWithAnimation) {
        CATransition *animation=[CATransition animation];
        [animation setDuration:0.3f];
        [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
        [animation setType:kCATransitionReveal];
        [animation setSubtype: kCATransitionFromBottom];
        [self.view.superview.layer addAnimation:animation forKey:@"Reveal"];
    }
    [self removeSelf];
}

#pragma mark 切换动画
-(void)cateTableAnimation:(UIScrollView *)scrollview{
    [scrollview.layer addAnimation:[OTSNaviAnimation animationFade] forKey:nil];
}

#pragma mark 按类型获取
-(IBAction)typeBtnClicked:(id)sender {
    UIButton *button=sender;
    
    m_CurrentTypeIndex=[button tag];
    
    switch ([button tag])
    {
        case 0:
        {
            for (UIView *view in [typeView subviews]) {
                if ([view isKindOfClass:[UIButton class]]) {
                    UIButton *button=(UIButton *)view;
                    if ([button tag]==0) {
                        [button setBackgroundImage:[UIImage imageNamed:@"registetypebg.png"] forState:UIControlStateNormal];
                    } else {
                        [button setBackgroundImage:[UIImage imageNamed:@"registetype.png"] forState:UIControlStateNormal];
                    }
                }
                [user_phoneregisteScrollview setHidden:YES];
                //                [user_phoneregisteScrollview setDelegate:nil];
                [user_registeScrollView setHidden:NO];
                [self cateTableAnimation:user_registeScrollView];
                //                [user_registeScrollView setDelegate:self];
            }
            break;
        }
        case 1:
        {
            for (UIView *view in [typeView subviews])
            {
                if ([view isKindOfClass:[UIButton class]])
                {
                    UIButton *button=(UIButton *)view;
                    if ([button tag]==1) {
                        [button setBackgroundImage:[UIImage imageNamed:@"registetypebg.png"] forState:UIControlStateNormal];
                    } else {
                        [button setBackgroundImage:[UIImage imageNamed:@"registetype.png"] forState:UIControlStateNormal];
                    }
                }
                [user_registeScrollView setHidden:YES];
                //                [user_registeScrollView setDelegate:nil];
                [user_phoneregisteScrollview setHidden:NO];
                //                [user_phoneregisteScrollview setDelegate:self];
                [self cateTableAnimation:user_phoneregisteScrollview];
            }
            break;
        }
        default:
            break;
    }
}

//登录成功
-(void)oneMallLoginSuccess
{
    switch (CallTag) {
        case 6:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FeedbackMsg" object:self]; //向更多栏发可以进入意见反馈消息
            break;
        case 11:
            [SharedDelegate enterHomePageLogistic];//登录成功进入物流查询页面
            break;
        case 12:
            [SharedDelegate enterMyFavorite:FROM_CART_TO_FAVORITE];//登录成功进入我的收藏页面
            break;
        case 15:
            [SharedDelegate enterMyFavorite:FROM_HOMEPAGE_TO_FAVORITE];//登录成功进入我的收藏页面
            break;
        case 13: {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyStore" object:[NSNumber numberWithInt:FROM_TABBAR_CLICK]];
            break;
        }
        default:
            break;
    }
    [self removeViewFromTabBar];
}

-(void)fromBuy:(NSNumber*)productIdStr merchanID:(NSNumber*)merchantId productNumber:(NSNumber*)number buyTag:(NSString*)tag MsgNamestr:(NSString*)notificationStr;
{
    if (productIdString!=nil) {
        [productIdString release];
    }
    productIdString = [[NSNumber alloc]initWithInt:[productIdStr intValue]];
    if (productNumbers!=nil) {
        [productNumbers release];
    }
    productNumbers = [[NSNumber alloc] initWithInt:[number intValue]];
    if ([tag isEqualToString:@"0"]) {
        if (merchanID!=nil) {
            [merchanID release];
        }
        merchanID = [[NSNumber alloc]initWithInt:[merchantId intValue]];
    }
    if (notificationString!=nil) {
        [notificationString release];
    }
    notificationString = [[NSString alloc] initWithString:notificationStr];
}
//设置调用标记，表示在哪个地方调用了此类
-(void)mysetCallTag:(NSNumber*)selectTag
{
	CallTag = [selectTag integerValue];
	if (CallTag == 8) {
		[self.view addSubview: modifyPwdView];
	}
}
#pragma mark 登录页面的相关操作
-(void)setLoginviewUserName:(NSString*)userName{
    [m_userTool Del:KEY withNeedToSave:YES];
    [m_userTool AddOrUpdate:KEY withName:@"" withTheOneStoreAccount:userName withPass:@"" withRememberme:[NSNumber numberWithInt:0] withCocode:@"" withUnionlogin:@"" withNickname:@"" withUserimg:@"" withAutoLoginStatus:@"0" withNeedToSave:YES];
    [loginTextfieldName setText:userName];
}
-(void)setLoginview
{

	[self.view bringSubviewToFront:loginView];
    [loginTextfieldName setText:[m_userTool GetTheOneStoreAccount]];
    [loginTextfieldCode setText:@""];
}

-(void)hiddenLoginVerifyView{
    [_loginVerifyView setHidden:YES];
    [loginBtn setFrame:CGRectMake(10, 133, 302, 43)];
    [unionLoginView setYPos:200];
}
//输入用户名和密码后的login操作
-(IBAction)clickedLoginBtn:(id)sender
{
    loginBtn.enabled = NO;
    [loginTextfieldCode resignFirstResponder];
	[loginTextfieldName resignFirstResponder];
    
    if ([[loginTextfieldName text]length]==0 || [[loginTextfieldName.text stringByReplacingOccurrencesOfString:@" " withString:@""] length]<1) {
        [self showAlertView:@"用户名不能为空"];
        [loginTextfieldName setText:@""];
        return;
    }
    if ([[loginTextfieldCode text]length]==0 || [[loginTextfieldCode.text stringByReplacingOccurrencesOfString:@" " withString:@""] length]<1) {
        [self showAlertView:@"密码不能为空"];
        [loginTextfieldCode setText:@""];
        return;
    }
//    if(_loginVerifyView.hidden == NO && ([[_loginVerifyTF text]length]==0 || [[_loginVerifyTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] length]<1)){
//        [self showAlertView:REG_CODE_EMPTY];
//        [_loginVerifyTF setText:@""];
//        return;
//    }
	if (![[loginTextfieldCode text] isMatchedByRegex:@"^\\S+$"]) {
        [self showAlertView:@"您的输入有误,密码中不允许有空格!"];
		[loginTextfieldCode setText:@""];
        return;
    }
    if (![[loginTextfieldName text] isMatchedByRegex:@"^[^&]+$"] || ![[loginTextfieldCode text] isMatchedByRegex:@"^[^&]+$"]) {
        [self showAlertView:@"您的输入有误,帐号或密码中不允许有&符号!"];
		[loginTextfieldCode setText:@""];
        return;
    }
    currentState = START_LOGIN;
    [self setThread];
}

//记住我
-(IBAction)rememberMe:(id)sender{
    UIButton *button=sender;
    if ([button titleForState:UIControlStateNormal]==nil || [[button titleForState:UIControlStateNormal] isEqualToString:@""]) {
        [button setTitle:@"√" forState:UIControlStateNormal];
        rememberMyAccout=YES;
    } else {
        [button setTitle:@"" forState:UIControlStateNormal];
        rememberMyAccout=NO;
    }
}

//返回
-(IBAction)returnFront:(id)sender
{
	{
        [loginTextfieldCode resignFirstResponder];
        [loginTextfieldName resignFirstResponder];
        [user_registePWD resignFirstResponder];
        [user_registeVerifyCode resignFirstResponder];
        [user_registeName resignFirstResponder];
        [forgetpwdNameTextField  resignFirstResponder];
        [forgetpwdVerifycodeTextField resignFirstResponder];
        [oldCodeInModifypwd resignFirstResponder];
        [codeInModifypwd resignFirstResponder];
        [confirmcodeInModify resignFirstResponder];
        [user_registeScrollView setFrame:CGRectMake(0, SVHIGHT, 320, ApplicationHeight-NAVIGATION_BAR_HEIGHT)];
	}
	[self removeViewFromTabBar];
    if (CallTag==13) {//点tabbar进入我的1号店，返回到首页
        [SharedDelegate enterHomePageRoot];
    }
    [loginTextfieldCode setText:@""];
    [loginTextfieldName setText:@""];
    [codeInModifypwd setText:@""];
    [confirmcodeInModify setText:@""];
    [codeInModifypwd setText:@""];
}

// 点击“新用户注册”后的操作
-(IBAction)returnInAgreement{
	CATransition *animation=[CATransition animation];
	animation.duration=0.3f;
	animation.timingFunction=UIViewAnimationCurveEaseInOut;
	[animation setType:kCATransitionReveal];
	[animation setSubtype: kCATransitionFromLeft];
	[self.view.layer addAnimation:animation forKey:@"Reveal"];
	[m_ServiceAgreeView removeFromSuperview];
}
-(IBAction)returninVerification{
	CATransition *animation=[CATransition animation];
	animation.duration=0.3f;
	animation.timingFunction=UIViewAnimationCurveEaseInOut;
	[animation setType:kCATransitionReveal];
	[animation setSubtype: kCATransitionFromLeft];
	[self.view.layer addAnimation:animation forKey:@"Reveal"];
	[m_VarificationView removeFromSuperview];
}
-(IBAction)returnInPassSetting{
	CATransition *animation=[CATransition animation];
	animation.duration=0.3f;
	animation.timingFunction=UIViewAnimationCurveEaseInOut;
	[animation setType:kCATransitionReveal];
	[animation setSubtype: kCATransitionFromLeft];
	[self.view.layer addAnimation:animation forKey:@"Reveal"];
	[passSettingview removeFromSuperview];
}
-(IBAction)user_registe:(id)sender
{
	[loginTextfieldCode resignFirstResponder];
	[loginTextfieldName resignFirstResponder];
	CATransition *animation=[CATransition animation];
	animation.duration=0.3f;
	animation.timingFunction=UIViewAnimationCurveEaseInOut;
	[animation setType:kCATransitionReveal];
	[animation setSubtype: kCATransitionFromRight];
	[self.view.layer addAnimation:animation forKey:@"Reveal"];
	
//    [self showVerifyCodeInView:registeVerifycodeImgView];
    
	[self.view addSubview:user_registeView];
    
    [phoneregisteBTN setBackgroundImage:[UIImage imageNamed:@"registetypebg.png"] forState:UIControlStateNormal];
    [user_registeScrollView setHidden:NO];
    [user_phoneregisteScrollview setHidden:YES];
    [user_registeName setText:@""];
    [user_registePWD setText:@""];
    [user_registePWD setFont:[UIFont systemFontOfSize:9.0]];
    [user_registeVerifyCode setText:@""];
    
    
    //药网直接显示邮箱注册
    UIButton *btn = [[[UIButton alloc] init] autorelease];
    btn.tag = 0;
//    [self typeBtnClicked:btn];
    
    
    //[DoTracking doTrackingSecond:[NSString stringWithFormat:@"registerPage_%@",[GlobalValue getGlobalValueInstance].provinceId]];//进入注册页数据统计
//    JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_Register extraPramaDic:nil]autorelease];
//    [DoTracking doJsTrackingWithParma:prama];
}

-(IBAction)tencentUnionLogin:(id)sender
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [self loginWithQQAccount];
}

-(IBAction)sinaUnionLogin:(id)sender
{
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (NSHTTPCookie *cookie in [storage cookies]) {
//        [storage deleteCookie:cookie];
//    }
//    [self loginWithSinaAccount];
    
    //现在暂时没有新浪，所以这里我直接改成支付宝登录  妈的 不管了， 就这样。

    [self alipayUnionLogin:nil];
}

-(void)oneMallUnionLogin:(id)sender
{
    NSString* urlStr=[NSString stringWithFormat:@"http://m.1mall.com/mw/login?mallcomingtype=true"];
    [SharedDelegate enterWap:0 invokeUrl:urlStr isClearCookie:YES];
}

#pragma mark - 支付宝登录

-(void)alipayUnionLogin:(id)sender
{
    DebugLog(@"alipayUnionLogin");
    
    AlipayHelper *alipayHelper = [[[AlipayHelper alloc] init] autorelease];
    [alipayHelper loginByAlipay:nil];
    
//    [aliPlayWebView removeFromSuperview];
//    //[self.view.layer addAnimation:[OTSNaviAnimation animationPushFromTop] forKey:OTS_VIEW_ANIM_KEY];
//    [self.view addSubview:aliPlayWebView];
//    [self.view bringSubviewToFront:aliPlayWebView];
//    [aliPlayWebView goLogin];
}

-(void)handleAliPayLoginResult:(NSArray*)aResultInfoArr
{
    DebugLog(@"user manager: handleAliPayLoginResult");
    
    self.m_UserName = [[[NSString alloc] initWithFormat:@"%@@alipay", [aResultInfoArr objectAtIndex:0]] autorelease];
    
    
    self.m_NickName = [[[NSString alloc] initWithFormat:@"%@", [aResultInfoArr objectAtIndex:1]] autorelease];
    
    if (m_NickName == nil || [m_NickName length] <= 0)//昵称为空，用手机号登录的情况
    {
        self.m_NickName = [[[NSString alloc] initWithFormat:@"%@", [aResultInfoArr objectAtIndex:2]] autorelease];
    }
    
    if (m_NickName == nil || [m_NickName length] <= 0) // 如果还为空，用userName
    {
        self.m_NickName = m_UserName;
    }
    
    OTS_SAFE_RELEASE(m_UserImg);
    
    [m_Cocode release];
    m_Cocode=[[NSString alloc] initWithString:@"alipay"];
    
    currentState=START_UNION_LOGIN;
    [self setThread];
}

- (void)alipayLoginFinished:(NSNotification *)notify
{
    ResultInfo *result = notify.object;
    NSLog(@"++++++++> %@",result);
    if (result.resultCode == 9000)
    {
        NSDictionary *resultDic = result.resultObject;
          NSLog(@"++++++++> %@",resultDic);
        NSString *auth_code = resultDic[@"auth_code"];
        NSString *alipay_user_id = resultDic[@"alipay_user_id"];
        
        self.m_UserName = alipay_user_id;
        self.m_NickName = auth_code;
        
        _loginType = kYWLoginAlipay;
        currentState=START_UNION_LOGIN;
        [self setThread];
    }

}

#pragma mark - 注册页面相关的操作

//-(void)crashMe
//{
//#warning 测试闪退的代码
//    int randomNum = arc4random() % 3;
//    switch (randomNum)
//    {
//        case 0:
//        {
//            DebugLog(@"Spawn a Zombie crash!!!");
//            id obj = [[NSObject alloc] init];
//            [obj release];
//            [obj retain];
//
//        }
//            break;
//
//        case 1:
//        {
//            DebugLog(@"Spawn a unrecognized selector crash!!!");
//            id obj = [[[NSObject alloc] init] autorelease];
//            [obj performSelector:@selector(makeYouCrash)];
//        }
//            break;
//
//        case 2:
//        {
//            DebugLog(@"Spawn a index out of bounds crash!!!");
//            NSArray* obj = [NSArray array];
//            [obj objectAtIndex:9999];
//        }
//            break;
//
//        default:
//            break;
//    }
//}

//返回到登录页
-(void)toAgreementView
{
    //[self crashMe];
    
    if (!m_ServiceAgreeView)
    {
        m_ServiceAgreeView = [[[NSBundle mainBundle] loadNibNamed:@"AgreementView" owner:self options:nil] lastObject];
        _protocol.frame = CGRectMake(0, 44, 320, ApplicationHeight-NAVIGATION_BAR_HEIGHT);
        
    }
    
	CATransition *animation=[CATransition animation];
	animation.duration=0.3f;
	animation.timingFunction=UIViewAnimationCurveEaseInOut;
	[animation setType:kCATransitionPush];
	[animation setSubtype: kCATransitionFromRight];
	[self.view.layer addAnimation:animation forKey:@"Reveal"];
	[self.view addSubview:m_ServiceAgreeView];
}
-(void)toVarificationView
{
	CATransition *animation=[CATransition animation];
	animation.duration=0.3f;
	animation.timingFunction=UIViewAnimationCurveEaseInOut;
	[animation setType:kCATransitionPush];
	[animation setSubtype: kCATransitionFromRight];
	[self.view.layer addAnimation:animation forKey:@"Reveal"];
	[self.view addSubview:m_VarificationView];
}

-(void)toPassSettingView
{
	CATransition *animation=[CATransition animation];
	animation.duration=0.3f;
	animation.timingFunction=UIViewAnimationCurveEaseInOut;
	[animation setType:kCATransitionPush];
	[animation setSubtype: kCATransitionFromRight];
	[self.view.layer addAnimation:animation forKey:@"Reveal"];
	[self.view addSubview:passSettingview];
}

-(IBAction)onRegistePageLogin:(id)sender
{
	[loginTextfieldCode resignFirstResponder];
	[loginTextfieldName resignFirstResponder];
	[user_registePWD resignFirstResponder];
	[user_registeVerifyCode resignFirstResponder];
	[user_registeName resignFirstResponder];
	[forgetpwdNameTextField  resignFirstResponder];
	[forgetpwdVerifycodeTextField resignFirstResponder];
    [user_registeScrollView setFrame:CGRectMake(0, 0/*SVHIGHT*/, 320, ApplicationHeight-NAVIGATION_BAR_HEIGHT)];
	
	CATransition *animation=[CATransition animation];
	animation.duration=0.3f;
	animation.timingFunction=UIViewAnimationCurveEaseInOut;
	[animation setType:kCATransitionPush];
	[animation setSubtype: kCATransitionFromLeft];
	[self.view.layer addAnimation:animation forKey:@"Reveal"];
    [self.view bringSubviewToFront:loginView];
}
-(IBAction)toggleShowPwd:(id)sender
{
    UIButton *button=sender;
    if ([button titleForState:UIControlStateNormal]==nil
        || [[button titleForState:UIControlStateNormal] isEqualToString:@""])
    {
        //_showPwd = YES;
        
        [button setTitle:@"√" forState:UIControlStateNormal];
		if (button.tag == 0) {
			[user_registePWD setSecureTextEntry:NO];
			registShowPwd=YES;
		}else {
			[registeBtn setEnabled:YES];
            isAgreeAgreement = YES;
		}
    } else {
        [button setTitle:@"" forState:UIControlStateNormal];
        //_showPwd = NO;
        
        [user_registePWD setSecureTextEntry:YES];
		if (button.tag == 0) {
			registShowPwd=NO;
		}else {
			[registeBtn setEnabled:NO];
            isAgreeAgreement = NO;
		}
        
    }
    [user_registePWD resignFirstResponder];
}


//提交注册
-(IBAction)clickedSubmitRegisteBtn:(id)sender
{
	registeBtn.enabled = NO;
	[user_registeVerifyCode resignFirstResponder];
	[user_registeName resignFirstResponder];
	[forgetpwdNameTextField  resignFirstResponder];
    [user_registeScrollView setFrame:CGRectMake(0, 0/*SVHIGHT*/, 320, ApplicationHeight-NAVIGATION_BAR_HEIGHT)];
    
    if ([[usernameTF text]length] == 0|| [[usernameTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] length]<1)
    {
        [self showAlertView:@"用户名不能为空"];
        [usernameTF setText:@""];
        return;
    }
    
    if ([[usernameTF text] length] > 20 || [[usernameTF text] length] < 4)
    {
        [self showAlertView:@"用户名为4-20个字符"];
        [usernameTF setText:@""];
        return;
    }
    
    if ([[user_registeName text]length] == 0|| [[user_registeName.text stringByReplacingOccurrencesOfString:@" " withString:@""] length]<1)
    {
        [self showAlertView:@"邮箱不能为空"];
        [user_registeName setText:@""];
        return;
    }
    if ([[user_registePWD text]length] == 0|| [[user_registePWD.text stringByReplacingOccurrencesOfString:@" " withString:@""] length]<1)
    {
        [self showAlertView:@"密码不能为空"];
        [user_registePWD setText:@""];
        return;
    }
	if (![[user_registePWD text] isMatchedByRegex:@"^\\S+$"])
    {
        [self showAlertView:@"您的输入有误,密码中不允许有空格!"];
		[user_registePWD setText:@""];
        return;
    }
    
    if (![user_registePWD.text canBeConvertedToEncoding: NSASCIIStringEncoding])
    {
        [self showAlertView:@"密码中不可以包含中文字符"];
		[user_registePWD setText:@""];
        return;
    }

    
    if (![UserManage validatePwdCharacters:user_registePWD.text])
    {
        [self showAlertView:@"密码由6－20位数字或字母组成"];
        [user_registePWD setText:@""];
        return;
    }
    

    
//    if ([[user_registeVerifyCode text]length] == 0 || [[user_registeVerifyCode.text stringByReplacingOccurrencesOfString:@" " withString:@""] length]<1) {
//        [self showAlertView:@"请输入验证码"];
//        [user_registeVerifyCode setText:@""];
//        return;
//    }
    currentState = START_REGISTE ;
    [self setThread];
}

+(BOOL)validateHasChineseChar:(NSString*)aCandidate
{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
	return [predicate evaluateWithObject:aCandidate];
}

+ (BOOL) validatePwdCharacters: (NSString *) candidate
{
    NSString *characterRegex = @"[^\\n\\s]{6,20}";
    return [self validateFormatOfString:candidate format:characterRegex];
}

+ (BOOL) validateFormatOfString: (NSString *) targetString format: (NSString*) formatString
{
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", formatString];
    return [emailTest evaluateWithObject:targetString];
}

#pragma mark -
#pragma mark 验证码

//点击换一张验证码图片，根据BUTTON的Tag值来区分不同页面的不同图片
-(IBAction)clickedChangeVerifyCode:(id)sender
{
	UIButton *theBtn = (UIButton *)sender;
	if (theBtn.tag == 0) {
        VerifyCodeImageView = registeVerifycodeImgView;
	}
	if (theBtn.tag == 1) {
        VerifyCodeImageView =  forgetpwdVerifyImgView;
	}
    if (theBtn.tag == 2) {
        VerifyCodeImageView = _loginVerifyImageView;
    }
	//[self otsDetatchMemorySafeNewThreadSelector:@selector(getVerifyCode) toTarget:self withObject:nil];
    [self performInThreadBlock:^(){
        NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
        UserService *ser = [[UserService alloc] init];
        self.verifycodeVO = [ser getVerifyCodeUrl:[GlobalValue getGlobalValueInstance].trader];
        [ser release];
        [pool drain];
    } completionInMainBlock:^() {
        NSURL *url = [NSURL URLWithString:verifycodeVO.codeUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        VerifyCodeImageView.image = [UIImage imageWithData:data];
    }];
}
// 显示验证码到对应的imageview上去
-(void)showVerifyCodeInView:(UIImageView*)imageView{
    [self performInThreadBlock:^(){
        NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
        UserService *ser = [[UserService alloc] init];
        self.verifycodeVO = [ser getVerifyCodeUrl:[GlobalValue getGlobalValueInstance].trader];
        self.tempoToken = verifycodeVO.tempToken;
        [ser release];
        [pool drain];
    } completionInMainBlock:^() {
        NSURL *url = [NSURL URLWithString:verifycodeVO.codeUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        imageView.image = [UIImage imageWithData:data];
    }];
}
//-(void)getVerifyCode
//{
//    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
//    
//	UserService *ser = [[UserService alloc] init];
//    //    if (verifycodeVO!=nil) {
//    //        [verifycodeVO release];
//    //    }
//	self.verifycodeVO = [ser getVerifyCodeUrl:[GlobalValue getGlobalValueInstance].trader];
//	
//	NSURL *url = [NSURL URLWithString:verifycodeVO.codeUrl];
//	NSData *data = [NSData dataWithContentsOfURL:url];
//    UIImage* img = [UIImage imageWithData:data];
//	[self performSelectorOnMainThread:@selector(setImageVerifyCode:) withObject:img waitUntilDone:NO];
//    [ser release];
//    [pool drain];
//}
//-(void)setImageVerifyCode:(UIImage*)img
//{
//    VerifyCodeImageView.image = img;
//}
#pragma mark -
#pragma mark 修改忘记密码相关操作
//修改密码
-(IBAction)submitModifyPwd:(id)sender
{
	[UIView setAnimationsEnabled:YES];
	modifyBtn.enabled = NO;
    [oldCodeInModifypwd resignFirstResponder];
    [codeInModifypwd resignFirstResponder];
    [confirmcodeInModify resignFirstResponder];
    
    if (0 == [[oldCodeInModifypwd text]length]|| [[oldCodeInModifypwd.text stringByReplacingOccurrencesOfString:@" " withString:@""] length]<1) {
        [self showAlertView:@"原始密码不能为空"];
        [oldCodeInModifypwd setText:@""];
        return;
    }
    if (0 == [[codeInModifypwd text]length]|| [[codeInModifypwd.text stringByReplacingOccurrencesOfString:@" " withString:@""] length]<1) {
        [self showAlertView:@"新密码不能为空"];
        [codeInModifypwd setText:@""];
        return;
    }
    if (0 == [[confirmcodeInModify text ]length]|| [[confirmcodeInModify.text stringByReplacingOccurrencesOfString:@" " withString:@""] length]<1) {
        [self showAlertView:@"确认密码不能为空"];
		[confirmcodeInModify setText:@""];
        return;
    }
    if (![oldCodeInModifypwd.text isEqualToString:[GlobalValue getGlobalValueInstance].userPassword] ||
		![oldCodeInModifypwd.text isMatchedByRegex:@"^\\w+$"]) {
        [self showAlertView:@"原始密码不正确"];
		[oldCodeInModifypwd setText:@""];
        return;
    }
    if ([[codeInModifypwd text]length]<6) {
        [self showAlertView:@"密码由6－20位数字或字母组成"];
        [codeInModifypwd setText:@""];
        return;
    }
    if (![codeInModifypwd.text isEqualToString:confirmcodeInModify.text]){
        [self showAlertView:@"两次密码不一致"];
        [codeInModifypwd setText:@""];
        [confirmcodeInModify setText:@""];
        return;
    }
	if(![codeInModifypwd.text isMatchedByRegex:@"^\\S+$"]){
		[self showAlertView:@"您的输入有误,密码中不允许有空格!"];
		[codeInModifypwd setText:@""];
        return;
	}
    currentState = START_MODIFY;          //开始提交服务器
    [self setThread];
 	[UIView setAnimationsEnabled:NO];
}

-(void)showAlertView:(NSString*)alertStr
{
    UIAlertView *tempAltView = [[UIAlertView  alloc]initWithTitle:nil message:alertStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil ];
    [tempAltView show];
    [tempAltView release];
    loginBtn.enabled = YES;
	registeBtn.enabled = YES;
    forgetBtn.enabled = YES;
	modifyBtn.enabled = YES;
    [UIView setAnimationsEnabled:NO];
}

//点击“忘记密码操作”进入忘记密码页面
-(IBAction)forgetpwdtest:(id)sender
{
	CATransition *animation=[CATransition animation];
	animation.duration=0.3f;
	animation.timingFunction=UIViewAnimationCurveEaseInOut;
	[animation setType:kCATransitionPush];
	[animation setSubtype: kCATransitionFromRight];
	[self.view.layer addAnimation:animation forKey:@"Reveal"];
	//[self otsDetatchMemorySafeNewThreadSelector:@selector(setForgetPwdVerifyCode) toTarget:self withObject:nil];
    [self showVerifyCodeInView:forgetpwdVerifyImgView];
	[self.view addSubview:forgetpwdView];
    [forgetpwdNameTextField setText:@""];
    [forgetpwdVerifycodeTextField setText:@""];
}

//点击忘记密码页面的确认按钮操作
-(IBAction)clickedForgetpwdConfirm:(id)sender
{
	forgetBtn.enabled = NO;
    [forgetpwdNameTextField  resignFirstResponder];
	[forgetpwdVerifycodeTextField resignFirstResponder];
    
    if (0 == [[forgetpwdNameTextField text]length]|| [[forgetpwdNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length]<1) {
        [self showAlertView:@"用户名或邮箱不能为空"];
        [forgetpwdNameTextField setText:@""];
        return;
    }
    if (0 == [[forgetpwdVerifycodeTextField text]length]|| [[forgetpwdVerifycodeTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length]<1) {
        [self showAlertView:@"请输入验证码"];
        [forgetpwdVerifycodeTextField setText:@""];
        return;
    }
    currentState = START_FORGETPWD;
    [self setThread];
}
#pragma mark textfielddelegete
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == phoneregisteNum)
    {
//        phoneregisteNum.text = @"";
        phoneregisteWarningLbl.hidden = YES;
        phoneregisteWarningMask.hidden = YES;
        [self revertPhoneregisteVerifyBTNPosition];
    }
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	[UIView setAnimationsEnabled:NO];
    if (textField==user_registePWD) {
        [user_registePWD setFont:[UIFont systemFontOfSize:15.0]];
        if (registShowPwd) {
            [user_registePWD setSecureTextEntry:NO];
        } else {
            [user_registePWD setSecureTextEntry:YES];
        }
    }
    if (textField==passSettingPWD) {
        [passSettingPWD setFont:[UIFont systemFontOfSize:15.0]];
        if (registShowPwd) {
            [passSettingPWD setSecureTextEntry:NO];
        } else {
            [passSettingPWD setSecureTextEntry:YES];
        }
    }
    if (textField==user_registeVerifyCode) {
        [user_registeScrollView setFrame:CGRectMake(0, -10, 320, ApplicationHeight-NAVIGATION_BAR_HEIGHT)];
    } else {
        [registmainScrollview setFrame:CGRectMake(0,44,320,ApplicationHeight-NAVIGATION_BAR_HEIGHT)];
    }
    //    [rememberMeBtn setTitle:@"√" forState:UIControlStateNormal];
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField==user_registePWD) {
        if ([user_registePWD.text isEqualToString:@""] || user_registePWD.text == nil) {
            [user_registePWD setFont:[UIFont systemFontOfSize:9.0]];
        }
    }
    return YES;
}
//各页面点击键盘 return 键后的操作
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[UIView setAnimationsEnabled:NO];
    
	if (textField == loginTextfieldName) {
		[loginTextfieldCode becomeFirstResponder];
	}
	if (textField == loginTextfieldCode) {
		[self clickedLoginBtn:loginBtn];
		[loginTextfieldCode resignFirstResponder];
	}
	if (textField == user_registeName) {
		[user_registePWD becomeFirstResponder];
	}
	if (textField == user_registePWD) {
		[user_registeVerifyCode becomeFirstResponder];
	}
	if (textField == user_registeVerifyCode) {
        if (isAgreeAgreement) {
            [self clickedSubmitRegisteBtn:registeBtn];
            [user_registeScrollView setFrame:CGRectMake(0, SVHIGHT, 320, ApplicationHeight-NAVIGATION_BAR_HEIGHT)];
            [user_registeVerifyCode resignFirstResponder];
        }
	}
	if (textField == forgetpwdNameTextField) {
		[forgetpwdVerifycodeTextField becomeFirstResponder];
	}
	if (textField == forgetpwdVerifycodeTextField) {
		[forgetpwdVerifycodeTextField resignFirstResponder];
		[self clickedForgetpwdConfirm:forgetBtn];
	}
	if (textField == oldCodeInModifypwd) {
		[codeInModifypwd becomeFirstResponder];
	}
	if (textField == codeInModifypwd ) {
		[confirmcodeInModify becomeFirstResponder];
	}
	if (textField == confirmcodeInModify) {
		[confirmcodeInModify resignFirstResponder];
		[self submitModifyPwd:modifyBtn];
	}
    if (textField == phoneregisteNum) {
        [self validatePhoneNumField];
        phoneregisteWarningLbl.hidden = [phoneregisteNum.text length] > 0 ;
        phoneregisteWarningMask.hidden = [phoneregisteNum.text length] > 0 ;
    }
    if (textField == passSettingPWD) {
        [passSettingPWD resignFirstResponder];
    }

	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger changedLength = [string length];
    
    if (textField == phoneregisteNum && [phoneregisteNum.text length] >= 11 && changedLength)
    {
        return NO;
    }
    if ([phoneregisteNum.text length] == 10) {
        [phoneregisteVerifyBTN setEnabled:YES];
    }
    else {
        [phoneregisteVerifyBTN setEnabled:NO];
    }
    if (textField == loginTextfieldName && _loginVerifyView.hidden == NO && isNeedRestIdState) {
        [self hiddenLoginVerifyView];
        isNeedRestIdState = NO;
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [phoneregisteVerifyBTN setEnabled:NO];
//    if (textField == loginTextfieldName && _loginVerifyView.hidden == NO&& isNeedRestIdState) {
//        [self hiddenLoginVerifyView];
//    }
    return YES;
}


#pragma mark scrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[loginTextfieldName resignFirstResponder];
	[loginTextfieldCode resignFirstResponder];
    [usernameTF resignFirstResponder];
	[user_registePWD resignFirstResponder];
	[user_registeName resignFirstResponder];
	[user_registeVerifyCode resignFirstResponder];
	[forgetpwdNameTextField resignFirstResponder];
	[forgetpwdVerifycodeTextField resignFirstResponder];
	[oldCodeInModifypwd resignFirstResponder];
	[codeInModifypwd resignFirstResponder];
	[confirmcodeInModify resignFirstResponder];
    [phoneregisteNum resignFirstResponder];
    [phoneverificationCode resignFirstResponder];
    [passSettingPWD resignFirstResponder];
    [self revertPhoneregisteVerifyBTNPosition];
    [self revertPhoneVerification];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	[scrollView setContentSize:CGSizeMake(320, ApplicationHeight-NAVIGATION_BAR_HEIGHT)];
	[user_registeScrollView setFrame:CGRectMake(0, 0/*SVHIGHT*/, 320, ApplicationHeight-NAVIGATION_BAR_HEIGHT)];
    [user_phoneregisteScrollview setFrame:CGRectMake(0, SVHIGHT, 320, ApplicationHeight-NAVIGATION_BAR_HEIGHT)];
	[loginScrollView setFrame:CGRectMake(0, 44, 320, ApplicationHeight-NAVIGATION_BAR_HEIGHT)];
//    [_loginVerifyTF resignFirstResponder];
    
}

#pragma mark 线程相关
//设置线程
-(void)setThread
{
	threadRuning = YES;
    [self.loadingView showInView:self.view];
	[self otsDetatchMemorySafeNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
}
//开始线程
-(void)startThread
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    while (threadRuning) {
		switch (currentState)
		{
			case START_LOGIN:   //登录
                [self startLogin];
                [self stopThread];
				break;
            case START_UNION_LOGIN:{//联合登录
                [self startUnionLogin];
                [self stopThread];
                break;
            }
			case START_REGISTE://注册
                [self startRegiste];
                [self stopThread];
				break;
			case START_FORGETPWD://忘记密码
				[self startForgetPwd];
				[self stopThread];
				break;
			case START_MODIFY: //修改密码
				[self startModify];
				[self stopThread];
				break;
			default:
				break;
		}
	}
    
    [self performInMainBlock:^{
        [self.loadingView hide];
    }];
    
    [pool drain];
}

//关闭线程
-(void)stopThread
{
	threadRuning = NO;
}
//本地判断后开始登录
-(void)startLogin
{
	
    NSDictionary *paramDic = @{@"username" : loginTextfieldName.text, @"password" : loginTextfieldCode.text};
    [[YWUserLoginHelper sharedInstance] loginWithType:kYWLoginStore param:paramDic];
    
    
	if ([YWUserLoginHelper sharedInstance].isResultHasError)
    {
        [self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常,请稍候再试..." waitUntilDone:NO];
	}
    else if ([YWUserLoginHelper sharedInstance].isNilResult)
    {
        [self performSelectorOnMainThread:@selector(showError:) withObject:[YWUserLoginHelper sharedInstance].loginResult.errorStr waitUntilDone:NO];
    }
    else if ([YWUserLoginHelper sharedInstance].isLoginSuccess)
    {
		if ( 100 != CallTag)
        {
            //登陆之后同步购物车 暂时注释
//            [self synCart:[OTSUserLoginHelper sharedInstance].loginResult.token];
        }
	}
	[self performSelectorOnMainThread:@selector(loginResultShow) withObject:nil waitUntilDone:NO];
}

#pragma mark 显示登录结果提示框
-(void)showLoginResultAlertView:(NSString *)result {
	switch ([result intValue]) {
		case -1:
			[self showAlertView:@"登录失败" alertMsg:@"用户不存在!" alertTag:ALERTVIEW_TAG_OTHERS];
			break;
		case -2:
			[self showAlertView:@"登录失败" alertMsg:@"密码不正确!" alertTag:ALERTVIEW_TAG_OTHERS];
			break;
		default:
			break;
	}
}
#pragma mark 显示提示框
-(void)showAlertView:(NSString *)alertTitle alertMsg:(NSString *)alertMsg alertTag:(int)alertTag {
	[[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:YES];
    UIAlertView * alert = [[OTSAlertView alloc]initWithTitle:alertTitle message:alertMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
    alert.tag = alertTag;
	if (alert.tag == ALERTVIEW_TAG_OTHERS) {
		alert.delegate = nil;
	}
	[alert show];
	[alert release];
	alert = nil;
}
-(void)synCart:(NSString*)mytoken{
    
    LocalCartService * lcservice = [[LocalCartService alloc]init ];
    NSMutableArray *tempArray = [lcservice getLocalCartSynDateFromSqlite3];
    if (tempArray!=nil && [tempArray count]>0 && [[tempArray objectAtIndex:0] count]>0) {
        NSMutableArray *productIds = [tempArray objectAtIndex:0];
        NSMutableArray *merchantIds = [tempArray objectAtIndex:1];
        NSMutableArray *promotionIds = [tempArray objectAtIndex:2];
        NSMutableArray *quantitys = [tempArray objectAtIndex:3];

        //landingpage
        NSMutableArray *lproductIds = [NSMutableArray array];
        NSMutableArray *lmerchantIds = [NSMutableArray array];
        NSMutableArray *lpromotionIds = [NSMutableArray array];
        NSMutableArray *lquantitys = [NSMutableArray array];
        //普通商品
        NSMutableArray *nproductIds = [NSMutableArray array];
        NSMutableArray *nmerchantIds = [NSMutableArray array];
        NSMutableArray *nquantitys = [NSMutableArray array];
        
        for (int i=0; i<promotionIds.count; i++) {
            NSString* promotionId= [promotionIds objectAtIndex:i];
            NSNumber* productId=[productIds objectAtIndex:i];
            NSNumber* merchantId=[merchantIds objectAtIndex:i];
            NSNumber* quantity=[quantitys objectAtIndex:i];
            if ([promotionId rangeOfString:@"landingpage"].location!=NSNotFound) {
                [lpromotionIds addObject:promotionId];
                [lproductIds addObject:productId];
                [lmerchantIds addObject:merchantId];
                [lquantitys addObject:quantity];
            }else{
                [nquantitys addObject:quantity];
                [nproductIds addObject:productId];
                [nmerchantIds addObject:merchantId];
            }
        }
        
        [NSThread sleepForTimeInterval:0.5f];
        CartService *tempCarSer=[[[CartService alloc] init] autorelease];

        AddProductResult* result=[tempCarSer addNormalProducts:[GlobalValue getGlobalValueInstance].token productIds:nproductIds merchantIds:nmerchantIds quantitys:nquantitys];
        if (result.resultCode.intValue==1) {
            if(lpromotionIds.count>0){
                CartService* ser=[[[CartService alloc] init] autorelease];
                AddProductResult* result2 =[ser addLandingpageProducts:[GlobalValue getGlobalValueInstance].token productIds:lproductIds merchantIds:lmerchantIds quantitys:lquantitys promotionids:lpromotionIds];
                if (result2.resultCode.intValue==1) {
                    [lcservice cleanLocalCartFromSqlite3];
                    [self performSelectorOnMainThread:@selector(refreshCart) withObject:nil waitUntilDone:NO];
                }
                
            }
        }
    }
    [lcservice release];
}

//登录结果显示
-(void)loginResultShow
{
    if (![YWUserLoginHelper sharedInstance].isLoginSuccess)
    {
        if([YWUserLoginHelper sharedInstance].isNilResult)
        {
            loginBtn.enabled = YES;
            return;
        }
        
		[self showLoginResultAlertView:[YWUserLoginHelper sharedInstance].loginResult.errorInfo];
        
		loginBtn.enabled = YES;
		return;
    }
    else
    {
        [[GlobalValue getGlobalValueInstance] setUserPassword:[loginTextfieldCode text]];
        [[GlobalValue getGlobalValueInstance] setUserName:[loginTextfieldName text]];
        
        switch (CallTag)
        {
            case 6:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"FeedbackMsg" object:self]; //向更多栏发可以进入意见反馈消息
                break;
			case 11:
                [SharedDelegate enterHomePageLogistic];//登录成功进入物流查询页面
				break;
			case 12:
                [SharedDelegate enterMyFavorite:FROM_CART_TO_FAVORITE];//登录成功进入我的收藏页面
				break;
            case 13: {
                //刷新个人中心，暂时注释
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyStore" object:[NSNumber numberWithInt:FROM_TABBAR_CLICK]];
                break;
            }
            case 14: {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"cartload" object:[NSNumber numberWithInt:FROM_TABBAR_CLICK]];
                break;
            }
            case 15:
                [SharedDelegate enterMyFavorite:FROM_HOMEPAGE_TO_FAVORITE];//登录成功进入我的收藏页面
                break;
			default:
                break;
        }
        
        //需要刷新我的1号店
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyStoreChanged" object:self];
        
        if([GlobalValue getGlobalValueInstance].storeToken == nil)
        {
            return;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setLoingBtnIcon" object:self]; //向首页发设置用户图标的消息
        loginBtn.enabled = YES;

		switch (currentState)
		{
			case START_LOGIN:
                [m_userTool AddOrUpdate:KEY withName:[loginTextfieldName text] withTheOneStoreAccount:[loginTextfieldName text] withPass:[loginTextfieldCode text]  withRememberme:[NSNumber numberWithBool:rememberMyAccout] withCocode:@"" withUnionlogin:@"LOGIN" withNickname:@"" withUserimg:@"" withAutoLoginStatus:@"1" withNeedToSave:YES];
				break;
                
            case START_UNION_LOGIN:
                if ([m_userTool GetTheOneStoreAccount] == nil)
                {
                    [m_userTool AddOrUpdate:KEY withName:m_UserName withTheOneStoreAccount:@"" withPass:@"" withRememberme:[NSNumber numberWithBool:rememberMyAccout] withCocode:m_Cocode withUnionlogin:@"UNIONLOGIN"withNickname:m_NickName withUserimg:m_UserImg withAutoLoginStatus:@"1" withNeedToSave:YES];
                }
                else
                {
//                    [m_userTool AddOrUpdate:KEY withName:m_UserName withTheOneStoreAccount:[m_userTool GetTheOneStoreAccount] withPass:@"" withRememberme:[NSNumber numberWithBool:rememberMyAccout] withCocode:m_Cocode withUnionlogin:@"UNIONLOGIN"withNickname:m_NickName withUserimg:m_UserImg withAutoLoginStatus:@"1" withNeedToSave:YES];
                }
                self.quitWithAnimation = NO;    // 如果是联合登录，退出时不做动画
                
                break;
			default:
				break;
		}
		
        [self removeViewFromTabBar];
        
        if (CallTag != 100) {
            [self otsDetatchMemorySafeNewThreadSelector:@selector(postCart) toTarget:self withObject:nil];
        }
        else if (CallTag == 100 )
        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"CartDirectToOrder" object:nil];
//            [NSThread sleepForTimeInterval:1.0f];
            [self otsDetatchMemorySafeNewThreadSelector:@selector(synCartWithEnterOrder) toTarget:self withObject:nil];
        }
    }
}
-(void)synCartWithEnterOrder
{
    TheStoreAppAppDelegate *delegate = (TheStoreAppAppDelegate *)([UIApplication sharedApplication].delegate);
//    ((PhoneCartViewController*)[delegate.tabBarController.viewControllers objectAtIndex:2]).view.userInteractionEnabled = NO;
    [[delegate.tabBarController.viewControllers objectAtIndex:2] /*newThreadSynCart*/refreshCart];
}

-(void)addCartResultShow:(NSString *)strResult{
    int addTag=[strResult intValue];
	NSString * alertMsg;
    if (addTag != 1) {
        alertMsg = [ErrorStrings getCartError:addTag];
    }

	if (addTag != 1) {
		UIAlertView * alert = [[OTSAlertView alloc]initWithTitle:nil message:alertMsg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
		[alert show];
		[alert release];
		alert = nil;
		[UIView setAnimationsEnabled:NO];
	}
    //[alertMsg release];
}

-(void)postCart
{
//    NSAutoreleasePool * pool=[[NSAutoreleasePool alloc] init];
//    CartService *service = [[CartService alloc]init];
//
//    int ProNumber=0;
//    ProNumber=[service countSessionCart:[GlobalValue getGlobalValueInstance].token siteType:[NSNumber numberWithInt:1]];
//    [SharedDelegate clearCartNum];
//    if (ProNumber>0) {
//        [SharedDelegate setCartNum:ProNumber];
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"CartChanged" object:nil];
//    
//    [pool drain];
}
-(NSMutableArray * )readFile
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"USER_MANAGE.plist"];
    DebugLog(@"filename %@",filename);
    NSMutableArray *theUserArray=[[NSMutableArray alloc] initWithContentsOfFile:filename];
    return [theUserArray autorelease];
}



//本地判断后开始注册
-(void)showInfo:(NSString *)info
{
    UIAlertView *alerView=[[UIAlertView  alloc] initWithTitle:nil message:info delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alerView show];
    [alerView release];
}

-(void)startRegiste
{
    YWUserService *registeSer=[[[YWUserService alloc] init] autorelease];

    NSDictionary *dic = @{@"username" : usernameTF.text,@"password":[user_registePWD text],@"email":[user_registeName text]};
    RegistResultInfo *registerResult=[registeSer regist:dic];
    
    [self performInMainBlock:^{
        [self registeResultShow:registerResult];
    }];
}

//注册结果
-(void)registeResultShow:(RegistResultInfo *)registerResult
{
    
    if (registerResult.responseCode == -100)
    {
        [self showInfo:@"网络异常，请检查网络配置..."];
        registeBtn.enabled = YES;
    }
    else
    {
        if ([registerResult resultCode] == 1)
        {
            //注册成功
            [self.loadingView showInView:self.view];
            [self otsDetatchMemorySafeNewThreadSelector:@selector(registeSucceed) toTarget:self withObject:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MyStoreChanged" object:self];
        }
        else
        {
            [self showInfo:[registerResult errorStr]];
            
            registeBtn.enabled = YES;
            
            //邮箱注册，输入错误格式邮箱 更新验证码
//            [self showVerifyCodeInView:registeVerifycodeImgView];
            
        }
    }
    [user_registeScrollView setFrame:CGRectMake(0, 0/*SVHIGHT*/, 320, ApplicationHeight-NAVIGATION_BAR_HEIGHT)];
    [user_registePWD resignFirstResponder];
    [user_registeName resignFirstResponder];
    [user_registeVerifyCode resignFirstResponder];

  /*
    if (registerResult  ==nil || [registerResult isKindOfClass:[NSNull class]])
    {
        [self showInfo:@"网络异常，请检查网络配置..."];
        registeBtn.enabled = YES;
    }
    
    else
    {
        if ([[registerResult resultCode] intValue]==1)
        {
            //注册成功
            [self.loadingView showInView:self.view];
            [self otsDetatchMemorySafeNewThreadSelector:@selector(registeSucceed) toTarget:self withObject:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MyStoreChanged" object:self];
        }
        else
        {
            [self showInfo:[registerResult errorInfo]];

            registeBtn.enabled = YES;

            //邮箱注册，输入错误格式邮箱 更新验证码
            [self showVerifyCodeInView:registeVerifycodeImgView];

        }
    }
    [user_registeScrollView setFrame:CGRectMake(0, SVHIGHT, 320, ApplicationHeight-NAVIGATION_BAR_HEIGHT)];
    [user_registePWD resignFirstResponder];
    [user_registeName resignFirstResponder];
    [user_registeVerifyCode resignFirstResponder];
*/
}

- (void)postRefreshMyStore
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyStore" object:nil];
}


-(void)registeSucceed
{
    //友盟统计注册事件
    [MobClick event:@"register"];
    
    
    NSDictionary *paramDic = @{@"username" : usernameTF.text, @"password" : user_registePWD.text};
    [[YWUserLoginHelper sharedInstance] loginWithType:kYWLoginStore param:paramDic];
    if (![YWUserLoginHelper sharedInstance].isLoginSuccess)
    {
        registeBtn.enabled = YES;
		return;
	}
    
    if ( 100 != CallTag)
    {
        [self synCart:[YWUserLoginHelper sharedInstance].loginResult.token];
        [self postCart];
        [self performSelectorOnMainThread:@selector(registeSucceedShow) withObject:nil waitUntilDone:NO];
        
        [self performSelectorOnMainThread:@selector(postRefreshMyStore) withObject:nil waitUntilDone:NO];
    }
    else
    {
        [self synCartWithEnterOrder];
        
        [self performSelectorOnMainThread:@selector(removeViewFromTabBar) withObject:nil waitUntilDone:NO];
 
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setLoingBtnIcon" object:self]; //向首页发设置用户图标的消息
    }
    
    [self performInMainBlock:^{
        [self.loadingView hide];
        registeBtn.enabled = YES;
    }];

    
    
    
    // auto login when register OK
    /*
    OTSLgoinParam *param = [[[OTSLgoinParam alloc] init] autorelease];
    param.userName = user_registeName.text;
    param.password = user_registePWD.text;
    [[OTSUserLoginHelper sharedInstance] loginWithParam:param];
    
	if (![OTSUserLoginHelper sharedInstance].isLoginSuccess)
    {
        registeBtn.enabled = YES;
		return;
	}
    
    if ( 100 != CallTag)
    {
        [self synCart:[OTSUserLoginHelper sharedInstance].loginResult.token];
        [self postCart];
        [self performSelectorOnMainThread:@selector(registeSucceedShow) withObject:nil waitUntilDone:NO];
    }
    else
    {
        [self synCartWithEnterOrder];
        
        [self performSelectorOnMainThread:@selector(removeViewFromTabBar) withObject:nil waitUntilDone:NO];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setLoingBtnIcon" object:self]; //向首页发设置用户图标的消息
    }
    
    [self performInMainBlock:^{
        [self.loadingView hide];
        registeBtn.enabled = YES;
    }];*/
}

-(void)showError:(NSString *)error
{
    [self showAlertView:error];
}

-(void)registeSucceedShow {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setLoingBtnIcon" object:self]; //向首页发设置用户图标的消息
    NSString *userNameStr = [[NSString alloc]initWithFormat:@"您的帐号是%@", usernameTF.text/*user_registeName.text*/];//modifiy
    UIAlertView *sucAltView = [[UIAlertView  alloc]initWithTitle:@"恭喜您注册成功!" message:userNameStr delegate:self cancelButtonTitle:@"我的1号药店" otherButtonTitles:@"开始购物",nil];
    sucAltView.tag = 11;
    UILabel *sucLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 30) ];//modfiy
    sucLabel.text = @"恭喜您注册成功!";
    sucLabel.textColor = [UIColor whiteColor];
    sucLabel.textAlignment = NSTextAlignmentLeft;
    sucLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.001f];
    
    UILabel *userNameLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 260, 30)];//modifiy
    userNameLab.text = userNameStr;
    userNameLab.textAlignment = NSTextAlignmentLeft;
    userNameLab.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.001f];//modifiy
    userNameLab.textColor = [UIColor whiteColor];
//    [sucAltView addSubview: sucLabel];
//    [sucAltView addSubview:userNameLab];
    [sucAltView show];
    [sucAltView release];
    sucAltView = nil;
    [userNameLab release];
    [sucLabel release];
    [userNameStr release];
//    [GlobalValue getGlobalValueInstance].userInfo.uid = usernameTF.text;
    [[GlobalValue getGlobalValueInstance] setUserName:[user_registeName text]];
    [[GlobalValue getGlobalValueInstance] setUserPassword:[user_registePWD text]];
}

-(void)startUnionLogin
{
    NSDictionary *paramDic;
    ///开始QQ登录
    if (_loginType == kYWLoginQQ)
    {
    paramDic = @{@"platform": [NSString stringWithFormat:@"%d",kYWLoginQQ],
                              @"nickname": m_NickName,
                              @"username": m_UserName,
                              @"userid": @"",
                              @"token": @""};
    }
    else if(_loginType == kYWLoginAlipay)
    {
        paramDic = @{@"platform": [NSString stringWithFormat:@"%d",kYWLoginAlipay],
                     @"auth_code": m_NickName,
                     @"alipay_user_id": m_UserName};
    }
   /*
    YWUserService *userSer = [[YWUserService alloc] init];
     LoginResultInfo *userResult = [userSer loginUnion:paramDic];
    
    if (userResult.resultCode == 1)
    {
        [[GlobalValue getGlobalValueInstance] setNickName:m_NickName];
        [[GlobalValue getGlobalValueInstance] setUserImg:m_UserImg];
        [[GlobalValue getGlobalValueInstance] setIsUnionLogin:YES];
        [GlobalValue getGlobalValueInstance].ywToken = userResult.token;
        [GlobalValue getGlobalValueInstance].userInfo = userResult.userInfo;
    }
    else
    {
        [self showError:userResult.errorStr];
    }
    */
    
    [[YWUserLoginHelper sharedInstance] loginWithType:_loginType param:paramDic];
    
    
	if ([YWUserLoginHelper sharedInstance].isResultHasError)
    {
        [self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常,请稍候再试..." waitUntilDone:NO];
	}
    else if ([YWUserLoginHelper sharedInstance].isNilResult)
    {
        [self performSelectorOnMainThread:@selector(showError:) withObject:[YWUserLoginHelper sharedInstance].loginResult.errorStr waitUntilDone:NO];
    }
    else if ([YWUserLoginHelper sharedInstance].isLoginSuccess)
    {
	}
	[self performSelectorOnMainThread:@selector(loginResultShow) withObject:nil waitUntilDone:NO];
}

#pragma mark    新浪微博联合登录
-(void)logoutSinaAccount
{
    if (m_WBEngine!=nil) {
        [m_WBEngine logOut];
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [storage cookies]) {
            [storage deleteCookie:cookie];
        }
    }
}

-(void)loginWithSinaAccount
{
    if (m_WBEngine!=nil) {
        [m_WBEngine release];
    }
    m_WBEngine=[[WBEngine alloc] initWithAppKey:@"356866357" appSecret:@"5905214414e9e8a5aa50cb17bd499210"];
    [m_WBEngine setRootViewController:self];
    [m_WBEngine setDelegate:self];
    [m_WBEngine setRedirectURI:@"http://"];
    [m_WBEngine setIsUserExclusive:YES];
    [self logoutSinaAccount];
    [m_WBEngine logIn];
}



-(void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    NSDictionary *dict=[[[NSDictionary alloc] initWithObjectsAndKeys:[m_WBEngine userID], @"uid", nil] autorelease];
    [m_WBEngine loadRequestWithMethodName:@"users/show.json" httpMethod:@"GET" params:dict postDataType:kWBRequestPostDataTypeNone httpHeaderFields:nil];
}

-(void)engineDidLogIn:(WBEngine *)engine
{
    NSDictionary *dict=[[[NSDictionary alloc] initWithObjectsAndKeys:[engine userID], @"uid", nil] autorelease];
    [engine loadRequestWithMethodName:@"users/show.json" httpMethod:@"GET" params:dict postDataType:kWBRequestPostDataTypeNone httpHeaderFields:nil];
}

-(void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    UIAlertView *alert=[[OTSAlertView alloc]initWithTitle:nil message:@"网络异常，请检查网络配置..." delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alert show];
    [alert release];
    alert=nil;
}

-(void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    UIAlertView *alert=[[OTSAlertView alloc]initWithTitle:nil message:@"网络异常，请检查网络配置..." delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alert show];
    [alert release];
    alert=nil;
}

-(void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    if ([result isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)result;
        if (m_UserName!=nil) {
            [m_UserName release];
        }
        m_UserName=[[NSString alloc] initWithFormat:@"%@@sina",[dict objectForKey:@"id"]];
        if (m_NickName!=nil) {
            [m_NickName release];
        }
        m_NickName=[[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"name"]];
        if (m_UserImg!=nil) {
            [m_UserImg release];
        }
        m_UserImg=[[NSString alloc] initWithFormat:@"%@",[dict objectForKey:@"profile_image_url"]];
        if (m_Cocode!=nil) {
            [m_Cocode release];
        }
        m_Cocode=[[NSString alloc] initWithString:@"sina"];
        
        currentState=START_UNION_LOGIN;
        [self setThread];
    }
}


#pragma mark    QQ联合登录
-(void)loginWithQQAccount
{
    if (m_TencentOAuth!=nil)
    {
        [m_TencentOAuth release];
    }
    m_TencentOAuth=[[TencentOAuth alloc] initWithAppId:@"100318694" andDelegate:self];
    [m_TencentOAuth setRedirectURI:@"www.qq.com"];
    [m_TencentOAuth authorize:nil inSafari:NO];
}

-(void)tencentDidLogin
{
    [m_TencentOAuth getUserInfo];
}

-(void)tencentDidNotLogin:(BOOL)cancelled
{
    
    DebugLog(@"tencentDidNotLogin");
    
}


//String nickName = arg0.getString("nickname");
//String openId = appInfo.getString(Const.QQ_OPENID, null);
//if (null != openId)
//{
//    handler.sendEmptyMessage(SHOWPROGRESS_DIALOG);
//    MainAsyncTask asyncTask = new MainAsyncTask(ConstMethod.USER_UNION_LOGIN, handler,LOGIN_MESSAGE_ID, new UserJson(), "");
//    ArrayList<BasicNameValuePair> params = new ArrayList<BasicNameValuePair>();
//    params.add(new BasicNameValuePair("method", ConstMethod.USER_UNION_LOGIN));
//    params.add(new BasicNameValuePair(Const.UNIONLOGIN_USERID, ""));
//    params.add(new BasicNameValuePair(Const.UNIONLOGIN_PLATFORM, Const.UNIONLOGIN_QQID));
//    params.add(new BasicNameValuePair(Const.UNIONLOGIN_NICKNAME, nickName));
//    params.add(new BasicNameValuePair(Const.UNIONLOGIN_USERNAME, openId));
//    params.add(new BasicNameValuePair(Const.UNIONLOGIN_TOKEN, ""));
//    asyncTask.execute(params);
//} else {showToast("认证失败!");}

-(void)getUserInfoResponse:(APIResponse*) response
{
    if (m_UserName!=nil) {
        [m_UserName release];
    }
    m_UserName=[[NSString alloc] initWithFormat:@"%@",[[m_TencentOAuth openId] lowercaseString]];
    if (m_NickName!=nil) {
        [m_NickName release];
    }
    m_NickName=[[NSString alloc] initWithFormat:@"%@",[response.jsonResponse objectForKey:@"nickname"]];
    if (m_UserImg!=nil) {
        [m_UserImg release];
    }
    m_UserImg=[[NSString alloc] initWithFormat:@"%@",[response.jsonResponse objectForKey:@"figureurl_1"]];
    if (m_Cocode!=nil) {
        [m_Cocode release];
    }
    m_Cocode=[[NSString alloc] initWithString:@"tencent"];
    
    
    _loginType = kYWLoginQQ;
    currentState=START_UNION_LOGIN;
    [self setThread];

}

#pragma mark 相应弹出框点击

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag==11) {
		switch (buttonIndex) {
			case 0://进入1号店
			{
				[SharedDelegate enterMyStoreWithUpdate:YES];
			}
				break;
			case 1://进入分类
			{
				[SharedDelegate enterCategory];
			}
				break;
			default:
				break;
		}
	}
	if (alertView.tag == 12) {
		[self.view bringSubviewToFront:loginView];
	}
    [[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:NO];
    [self removeViewFromTabBar];
}
//本地判断后开始 忘记密码 提交
-(void)startForgetPwd
{NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	UserService *registeSer = [[UserService alloc] init];
	forgetPwdResult = [registeSer findPasswordByEmail:[GlobalValue getGlobalValueInstance].trader emailname:[forgetpwdNameTextField text] verifycode:[forgetpwdVerifycodeTextField text] tempToken:verifycodeVO.tempToken];
	[self performSelectorOnMainThread:@selector(forgetPwdResultShow) withObject:nil waitUntilDone:NO];
	[registeSer release];
	[pool drain];
}
//忘记密码后续结果显示
-(void)forgetPwdResultShow
{
	NSString *resultStr;
	UIAlertView *sucAltView = [[UIAlertView  alloc]initWithTitle:[forgetpwdNameTextField text] message:@"密码已经发送至您的邮箱，请查收" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil ];
	
	switch (forgetPwdResult) {
		case 1:
			[forgetpwdNameTextField resignFirstResponder];
			[forgetpwdVerifycodeTextField resignFirstResponder];
			sucAltView.tag = 12;
			[sucAltView show];
			break;
			
		case -1:
			resultStr = @"用户名格式错误";
			UIAlertView *userNameErrorAltShow = [[UIAlertView  alloc]initWithTitle:nil message:resultStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil ];
			[userNameErrorAltShow show];
			[userNameErrorAltShow release];
			break;
			
		case -2:
			resultStr = @"用户不存在";
			UIAlertView *noUserAltShow = [[UIAlertView  alloc]initWithTitle:nil message:resultStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil ];
			[noUserAltShow show];
			[noUserAltShow release];
			break;
			
		case -3:
			resultStr = @"验证码错误";
			UIAlertView *verifycodeErrorAltShow = [[UIAlertView  alloc]initWithTitle:nil message:resultStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil ];
			[verifycodeErrorAltShow show];
			[verifycodeErrorAltShow release];
			break;
			
		default:
			break;
	}
    [sucAltView release];
    
	sucAltView = nil;
	forgetBtn.enabled = YES;
}
//本地判断后 修改密码
-(void)startModify
{
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    UserService *service = [[UserService alloc]init];
	if ([GlobalValue getGlobalValueInstance].token!=nil)
	{
        
		UserVO *myUserVo = [service getSessionUser:[GlobalValue getGlobalValueInstance].token];
        modifyPwdResult=[service modifyPassword:[GlobalValue getGlobalValueInstance].token
                                       username:myUserVo.username oldpassword:oldCodeInModifypwd.text
                                    newpassword:codeInModifypwd.text];
		[self performSelectorOnMainThread:@selector(modifyPwdShow) withObject:nil waitUntilDone:NO];
	}
    [service release];
	[pool drain];
}
//密码修改结果显示
-(void)modifyPwdShow
{
	NSString *str;
	switch (modifyPwdResult) {
		case 1:
			str = @"修改成功";
			[[GlobalValue getGlobalValueInstance]setUserPassword:[codeInModifypwd text]];
			break;
		case -1:
			str= @"密码错误";
			break;
		case -2:
			str= @"密码格式错误";
			break;
		default:
			break;
	}
	modifyBtn.enabled = YES;
	if (modifyPwdResult == -1||modifyPwdResult==1||modifyPwdResult== -2) {
		UIAlertView *modifyPwdShowAlt = [[OTSAlertView alloc] initWithTitle:nil message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[modifyPwdShowAlt show];
		[modifyPwdShowAlt release];
		[self removeViewFromTabBar];
		modifyPwdShowAlt= nil;
	}
    if (modifyPwdResult == 1) {
        //[self writeFile];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)fireTheTimer
{
    expireSeconds = 60;

    [self._timer invalidate];
    self._timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(timerFireMethod:)
                                            userInfo:nil
                                             repeats:YES];
}

#pragma mark 手机注册－获取验证码
-(IBAction)phoneregisteVerifyClick:(id)sender
{
    Trader *trader=[GlobalValue getGlobalValueInstance].trader;
    NSString *phoneNumber = [phoneregisteNum text];
    BOOL phoneNumberOK = [self validatePhoneNumField];
    
    if (phoneNumberOK) {
        [phoneregisteNum resignFirstResponder];
        
        [self showLoading];
        
        __block SendValidCodeForPhoneRegisterResult *__svcfprResult =nil;
        __block CheckUserNameResult *__cunResult = nil;
        [self performInThreadBlock:^(){
            //验证手机号
            __cunResult = [[[OTSServiceHelper sharedInstance] checkUserName:trader userName:phoneNumber] retain];
            if ([__cunResult.resultCode isEqualToNumber:[NSNumber numberWithInt:1]]) {
                //转入注册流程
                __svcfprResult =
                [[[OTSServiceHelper sharedInstance] sendValidCodeForPhoneRegister:trader mobile:phoneNumber] retain];
            }
            
        } completionInMainBlock:^(){
            //刷新ui
            [phoneverificationNum setText:phoneNumber];
            
            [self hideLoading];
            
            if ([__cunResult.resultCode isEqualToNumber:[NSNumber numberWithInt:1]]) {
                if ([[__svcfprResult resultCode] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    //----成功以后重新获取验证码开始倒计时-------
                    [self fireTheTimer];
                    [self toVarificationView];
                }
                else if(__svcfprResult == nil || [__svcfprResult isKindOfClass:[NSNull class]])
                {
                    [self showInfo:@"网络异常，请检查网络配置..."];
                }
                else
                {
                    [self showError:__svcfprResult.errorInfo];
                }
            }
            else if (__cunResult == nil || [__cunResult isKindOfClass:[NSNull class]])
            {
                [self showInfo:@"网络异常，请检查网络配置..."];
            }
            else
            {
                [self showError:__cunResult.errorInfo];
            }
            
            OTS_SAFE_RELEASE(__cunResult);
            OTS_SAFE_RELEASE(__svcfprResult);
        }];
    }
}

-(BOOL)validatePhoneNumField
{
    BOOL passed = NO;
    
    if (phoneregisteNum.text == nil || [phoneregisteNum.text length] <= 0)
    {
        phoneregisteWarningLbl.text = REG_PHONE_EMPTY;
        _offset = OFFSETMAX;
    }
    else if ([phoneregisteNum.text length] != 11)
    {
        phoneregisteWarningLbl.text = [NSString stringWithFormat:REG_PHONE_CHECK11, [phoneregisteNum.text length]];
        _offset = OFFSETMAX;
    }
    else
    {
        phoneregisteWarningLbl.text = @"";
        passed = YES;
    }
    
    phoneregisteWarningLbl.hidden = passed;
    phoneregisteWarningMask.hidden = passed;
    
    if (!_rever && !passed) {
        phoneregisteVerifyBTN.layer.position =
        CGPointMake(phoneregisteVerifyBTN.frame.origin.x+phoneregisteVerifyBTN.frame.size.width/2,
                    phoneregisteVerifyBTN.frame.origin.y+phoneregisteVerifyBTN.frame.size.height/2+_offset);
        _rever = YES;
    }
    return passed;
}

- (BOOL)revertPhoneregisteVerifyBTNPosition{
    if (_rever) {
        phoneregisteVerifyBTN.layer.position = CGPointMake(phoneregisteVerifyBTN.frame.origin.x+phoneregisteVerifyBTN.frame.size.width/2, phoneregisteVerifyBTN.frame.origin.y+phoneregisteVerifyBTN.frame.size.height/2-_offset);
        phoneregisteWarningLbl.hidden = YES;
        phoneregisteWarningMask.hidden = YES;
        _rever = NO;
    }
    return _rever;
}

#pragma mark 手机注册－提交验证码
-(IBAction)verificationSubmit:(id)sender
{
    Trader *trader=[GlobalValue getGlobalValueInstance].trader;
    NSString *phoneNumber = [phoneverificationNum text];
    NSString *codeNumber = [phoneverificationCode text];
    BOOL codeNumberOK = [self validateCodeField];
    if (codeNumberOK) {
        [phoneverificationCode resignFirstResponder];
        [self showLoading];
        __block CheckValidCodeForPhoneRegisterResult *__cvcfprResult = nil;
        [self performInThreadBlock:^(){
            __cvcfprResult = [[[OTSServiceHelper sharedInstance] checkValidCodeForPhoneRegister:trader mobile:phoneNumber validCode:codeNumber] retain];
        } completionInMainBlock:^(){
            //刷新ui
            [self hideLoading];
            if ([[__cvcfprResult resultCode] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                [self toPassSettingView];
            }
            else if(__cvcfprResult == nil || [__cvcfprResult isKindOfClass:[NSNull class]])
            {
                [self showInfo:@"网络异常，请检查网络配置..."];
            }
            else
            {
                [self showError:__cvcfprResult.errorInfo];
            }
            OTS_SAFE_RELEASE(__cvcfprResult);
        }];
    }
}

-(IBAction)verificationReFetch:(id)sender
{
    [phoneverificationCode resignFirstResponder];
    Trader *trader=[GlobalValue getGlobalValueInstance].trader;
    __block SendValidCodeForPhoneRegisterResult *__svcfprResult =nil;
    NSString *phoneNumber = [phoneverificationNum text];
    [self showLoading];
    [self performInThreadBlock:^(){
        //重新发送验证码
        __svcfprResult =
        [[[OTSServiceHelper sharedInstance] sendValidCodeForPhoneRegister:trader mobile:phoneNumber] retain];
        
    } completionInMainBlock:^(){
        //刷新ui
        [self hideLoading];
        if(__svcfprResult == nil || [__svcfprResult isKindOfClass:[NSNull class]])
        {
            [self showInfo:@"网络异常，请检查网络配置..."];
        }
        else if (![[__svcfprResult resultCode] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [self showError:[__svcfprResult errorInfo]];
        }
        else {
            [self fireTheTimer];
        }
        OTS_SAFE_RELEASE(__svcfprResult);
    }];
}
-(void)revertPhoneVerification
{
    phoneverificationWarningLbl.hidden = YES;
    phoneverificationWarningMask.hidden = YES;
    passSettingWarningLbl.hidden = YES;
    passSettingWarningMask.hidden = YES;
}

-(BOOL)validateCodeField
{
    BOOL passed = NO;
    
    if (phoneverificationCode.text == nil || [phoneverificationCode.text length] <= 0 || [phoneverificationCode.text isEqualToString:@"请输入验证码"])
    {
        phoneverificationWarningLbl.text = REG_CODE_EMPTY;
    }
    else if ([phoneverificationCode.text length] != REG_CODE_LENGTH)
    {
        phoneverificationWarningLbl.text = [NSString stringWithFormat:REG_CODE_ERROR
                                            , REG_CODE_LENGTH
                                            , [phoneverificationCode.text length]];
    }
    else
    {
        phoneverificationWarningLbl.text = @"";
        passed = YES;
    }
    
    phoneverificationWarningLbl.hidden = passed;
    phoneverificationWarningMask.hidden = passed;
    
    return passed;
}

-(BOOL)validatePassField{
    BOOL passed = NO;
    
    if (passSettingPWD.text == nil || [passSettingPWD.text length] <= 0 || [passSettingPWD.text isEqualToString:@"6-20位字母、数字或符号组合"])
    {
        passSettingWarningLbl.text = @" 密码不能为空";
    }
    else if (![[passSettingPWD text] isMatchedByRegex:@"^\\S+$"])
    {
        passSettingWarningLbl.text = @" 您的输入有误,密码中不允许有空格";
    }
    else if([[passSettingPWD text] length] < 6)
    {
        passSettingWarningLbl.text = @" 请输入6-20字母、数字或符号组合";
    }
    else
    {
        passSettingWarningLbl.text = @"";
        passed = YES;
    }
    passSettingWarningLbl.hidden = passed;
    passSettingWarningMask.hidden = passed;
    
    return passed;
}

- (void)timerFireMethod:(NSTimer*)theTimer
{
    currentSeconds++;
    if (currentSeconds >= expireSeconds)
    {
        [phoneverificationCodeReFetch setTitle:REG_RFBTN_TEXT forState:UIControlStateNormal];
        [phoneverificationCodeReFetch setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        phoneverificationCodeReFetch.enabled = YES;
        [self._timer invalidate];
        self._timer = nil;
         currentSeconds = 0;
    }
    else
    {
        phoneverificationCodeReFetch.enabled = NO;
        [phoneverificationCodeReFetch setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [phoneverificationCodeReFetch setTitle:[NSString stringWithFormat:REG_RFBTN1_TEXT, expireSeconds - currentSeconds] forState:UIControlStateNormal];
    }
}

#pragma mark 手机注册－提交注册
-(IBAction)phoneRegisteSubmit:(id)sender{
    Trader *trader=[GlobalValue getGlobalValueInstance].trader;
    NSString *phoneNumber = [phoneverificationNum text];
    NSString *passNumber = [passSettingPWD text];
    NSString *codeNumber = [phoneverificationCode text];
    [passSettingPWD resignFirstResponder];
    BOOL passwordCheckOK = [self validatePassField];
    __block RegisterResult *__registerResult;
    if (passwordCheckOK) {
        [self showLoading];
        [self performInThreadBlock:^(){
            //手机注册
            __registerResult  = [[[OTSServiceHelper sharedInstance] registerV3:trader email:@"" userName:phoneNumber password:passNumber verifycode:codeNumber tempToken:@"" type:[NSNumber numberWithInt:2]] retain];
        } completionInMainBlock:^(){
            //刷新ui
            [self performBlock:^(){
                [self hideLoading];
            }
            afterDelay:2.5];
            
            if (__registerResult==nil || [__registerResult isKindOfClass:[NSNull class]]) {
                [self showInfo:@"网络异常，请检查网络配置..."];
            } else {
                if ([[__registerResult resultCode] intValue]==1) {//注册成功
                    DebugLog(@"name,pass>>>>>>>>>> %@||%@",phoneregisteNum.text,passSettingPWD.text);
                    user_registeName.text = phoneregisteNum.text;
                    user_registePWD.text =passSettingPWD.text;
                    [self otsDetatchMemorySafeNewThreadSelector:@selector(registeSucceed) toTarget:self withObject:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyStoreChanged" object:self];
                } else {
                    [self showInfo:[__registerResult errorInfo]];
                }
            }
            OTS_SAFE_RELEASE(__registerResult);
        }];
    }
}

-(IBAction)toggleShowphoneRegistePwd:(id)sender
{
    UIButton *button=sender;
    if (button.tag==1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [button setImage:[UIImage imageNamed:@"phone_regpass_selected@2x.png"] forState:UIControlStateNormal];
            [passSettingPWD setSecureTextEntry:NO];
            registShowPwd=YES;
        });
        button.tag = 0;
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [passSettingPWD setSecureTextEntry:YES];
            registShowPwd=NO;
        });
        button.tag = 1;
    }
    [passSettingPWD resignFirstResponder];
}

#pragma mark -
-(void)releaseMyResoures
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    OTS_SAFE_RELEASE(verifycodeVO);
    
    OTS_SAFE_RELEASE(productIdString);
    OTS_SAFE_RELEASE(merchanID);
    
    OTS_SAFE_RELEASE(productNumbers);
    OTS_SAFE_RELEASE(notificationString);
    OTS_SAFE_RELEASE(carSer);
    OTS_SAFE_RELEASE(userArray);
    OTS_SAFE_RELEASE(m_WBEngine);
    
    OTS_SAFE_RELEASE(m_TencentOAuth);
    OTS_SAFE_RELEASE(m_UserName);
    OTS_SAFE_RELEASE(m_NickName);
    OTS_SAFE_RELEASE(m_UserImg);
    OTS_SAFE_RELEASE(m_Cocode);
    OTS_SAFE_RELEASE(aliPlayWebView);
    
    
    // release outlet
    OTS_SAFE_RELEASE(loginTextfieldName);
    OTS_SAFE_RELEASE(loginTextfieldCode);
    OTS_SAFE_RELEASE(rememberMeBtn);
    OTS_SAFE_RELEASE(loginScrollView);
    OTS_SAFE_RELEASE(user_registeName);
    OTS_SAFE_RELEASE(user_registePWD);
    OTS_SAFE_RELEASE(user_registeVerifyCode);
    OTS_SAFE_RELEASE(registeVerifycodeImgView);
    OTS_SAFE_RELEASE(user_registeScrollView);
    OTS_SAFE_RELEASE(m_ServiceAgreeView);
    OTS_SAFE_RELEASE(m_VarificationView);
    OTS_SAFE_RELEASE(forgetpwdNameTextField);
    OTS_SAFE_RELEASE(forgetpwdVerifycodeTextField);
    OTS_SAFE_RELEASE(forgetpwdVerifyImgView);
    OTS_SAFE_RELEASE(loginView);
    OTS_SAFE_RELEASE(user_registeView);
    OTS_SAFE_RELEASE(forgetpwdView);
    OTS_SAFE_RELEASE(modifyPwdView);
    OTS_SAFE_RELEASE(oldCodeInModifypwd);
    OTS_SAFE_RELEASE(codeInModifypwd);
    OTS_SAFE_RELEASE(confirmcodeInModify);
    OTS_SAFE_RELEASE(returnBtnInLogin);
    OTS_SAFE_RELEASE(returnBtnInRegiste);
    OTS_SAFE_RELEASE(returnBtnInForget);
    OTS_SAFE_RELEASE(returnBtnInModifyPwd);
    OTS_SAFE_RELEASE(loginBtn);
    OTS_SAFE_RELEASE(registeBtn);
    OTS_SAFE_RELEASE(forgetBtn);
    OTS_SAFE_RELEASE(modifyBtn);
    OTS_SAFE_RELEASE(typeView);
    OTS_SAFE_RELEASE(phoneregisteBTN);
    OTS_SAFE_RELEASE(mailregisteBTN);
    OTS_SAFE_RELEASE(registmainScrollview);
    OTS_SAFE_RELEASE(phoneregisteImgView);
    OTS_SAFE_RELEASE(phoneregisteNum);
    OTS_SAFE_RELEASE(phoneregisteWarningLbl);
    OTS_SAFE_RELEASE(phoneregisteWarningMask);
    OTS_SAFE_RELEASE(phoneregisteVerifyBTN);
    OTS_SAFE_RELEASE(phoneverificationmainScrollview);
    OTS_SAFE_RELEASE(phoneverificationImaview);
    OTS_SAFE_RELEASE(phoneverificationNum);
    OTS_SAFE_RELEASE(phoneverificationCode);
    OTS_SAFE_RELEASE(phoneverificationWarningLbl);
    OTS_SAFE_RELEASE(phoneverificationWarningMask);
    OTS_SAFE_RELEASE(phoneverificationCodeSubmit);
    OTS_SAFE_RELEASE(phoneverificationCodeReFetch);
    
    OTS_SAFE_RELEASE(passSettingview);
    OTS_SAFE_RELEASE(passSettingMainScrollview);
    OTS_SAFE_RELEASE(passSettingPWD);
    OTS_SAFE_RELEASE(passSettingWarningLbl);
    OTS_SAFE_RELEASE(passSettingWarningMask);
    OTS_SAFE_RELEASE(passSettingCheckbox);
    OTS_SAFE_RELEASE(passSettingSubmit);
    OTS_SAFE_RELEASE(unionLoginView);
    OTS_SAFE_RELEASE(tempoToken);
    [_timer invalidate];
    [_timer release];
    
	//
}

- (void)viewDidUnload
{
    [self setLoginVerifyView:nil];
    [self setLoginVerifyTF:nil];
    [self setLoginVerifyImageView:nil];
    [super viewDidUnload];
    [self releaseMyResoures];
}

-(void)dealloc
{
    [self releaseMyResoures];
//    [_loginVerifyTF release];
    [_loginVerifyImageView release];
    [usernameLbl release];
    [usernameTF release];
    [_protocol release];
    [super dealloc];
}
@end
