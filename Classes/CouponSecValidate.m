//
//  CouponSecValidate.m
//  TheStoreApp
//
//  Created by towne on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CouponSecValidate.h"
#import "DoTracking.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define OTS_STR_PHONE_NUM_TIP                  @"为了您的账户安全，系统会发送验证码到您的手机"
#define OTS_STR_VALIDATE_CODE_TIP              @"请将手机上收到的验证码，在30分钟内填入验证码输入框"

#define OTS_STR_PHONE_EMPTY                    @"! 手机号码不能为空，请输入"
#define OTS_STR_PHONE_ERROR                    @"! 请输入11位号码，您输入了%d位"
#define OTS_STR_CODE_EMPTY                     @"! 验证码不能为空，请输入"
#define OTS_STR_CODE_ERROR                     @"! 请输入%d位验证码，您输入了%d位"

#define OTS_STR_PHONE_PLACEHOLDER              @"输入手机号码" 
#define OTS_STR_CODE_PLACEHOLDER               @"输入验证码" 
#define OTS_STR_CODE_RECEIVE_ONPHONE           @"请在您绑定的手机上查收验证码"

#define DEFAULT_KEY_SECURITY_VALITATION_CODE   @"default_key_security_valitation_code"
#define VALIDATE_CODE_LENGTH                   6

#define STR_RESEND_CODE_FORMAT                 @"%02d秒后重新发送"
#define STR_SEND_CODE                          @"发   送"
#define STR_RESEND_CODE                        @"重新发送"
#define OFFSET                                 12.0
#define OFFSETZORE                             0.0
#define ICOUNT                                 299 // 5 分钟

#define ALERTVIEW_TAG_SEND_CODE_SUCCESS        0
#define ALERTVIEW_TAG_SEND_CODE_FAILED         1
#define ALERTVIEW_TAG_CHECK_CODE_SUCCESS       2
#define ALERTVIEW_TAG_CHECK_CODE_FAILED        3
#define ALERTVIEW_TAG_SAVECOUPON_SUCCESS       4
#define ALERTVIEW_TAG_SAVECOUPON_FAILED        5


@interface CouponSecValidate ()
-(void)threadDoAction:(id)aActionTypeObj;
-(void)threadDoAction:(id)aActionTypeObj message:(NSString*)aMessage;
@end

@implementation CouponSecValidate
@synthesize phoneNumFd;
@synthesize validationNumFd;
@synthesize finishBtn;
@synthesize m_NeedCheck;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - 初始化
//--------------------------不绑定手机----------------------
-(id)initWithNeedCheckResult:(CouponCheckResult*)aNeedCheckResult 
                couponNum:(NSString *)aCouponNum 
                notifyTarget:(id)aNotifyTarget 
                notifyAction:(SEL)aNotifyAction
{
    if (aNeedCheckResult == nil) 
    {
        return nil;
    }
    self = [self initWithNibName:@"CouponSecValidate" bundle:nil];
    if (self)
    {
        m_CouponNumber = aCouponNum;
        notifyTarget = aNotifyTarget;
        notifyAction = aNotifyAction;
        offset       = OFFSETZORE;
    }
    
    return self;
}

//--------------------------绑定手机，无需验证手机号码----------------------
-(id)initWithNeedCheckResult:(CouponCheckResult*)aNeedCheckResult 
                   couponNum:(NSString *)aCouponNum
                    phoneNum:(NSString *)aPhoneNum
                notifyTarget:(id)aNotifyTarget 
                notifyAction:(SEL)aNotifyAction
{
    if (aNeedCheckResult == nil) 
    {
        return nil;
    }
    self = [self initWithNibName:@"CouponSecValidate" bundle:nil];
    if (self)
    {
        m_CouponNumber = aCouponNum;
        userPhoneNumber = aPhoneNum;
        notifyTarget = aNotifyTarget;
        notifyAction = aNotifyAction;
        offset       = OFFSETZORE;
        m_iCount     = ICOUNT;
        isBond       = YES;
        m_timer      = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)resignTextFieldAction
{
    [phoneNumFd resignFirstResponder];
    [validationNumFd resignFirstResponder];
    [self revertSendBtnPosition];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_ScrollView.backgroundColor = [UIColor clearColor];
    m_ScrollView.delegate = self;
    
    CGRect rc = m_ScrollView.frame;
    rc.size.height = self.view.frame.size.height;
    rc.origin.y = OTS_IPHONE_NAVI_BAR_HEIGHT;
    m_ScrollView.frame = rc;
    
//    m_ScrollView.contentSize = CGSizeMake(320, [m_ScrollView frame].size.height+1);
    m_ScrollView.alwaysBounceVertical = YES;
    
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    CGRect screenRect = [UIScreen mainScreen].bounds;
    [phoneNumFd setDelegate:self];
    [validationNumFd setDelegate:self];
    //---------------------判断电话号码是否为绑定状态----------------------
    if (isBond)
    {
        phoneNumFd.enabled = NO;
        phoneNumFd.text = userPhoneNumber;
    }
    //---------------------短信验证按钮---------------------------------
    sendBtn=[[UIButton alloc] initWithFrame:CGRectMake(84,120,76,30)];
    [sendBtn setBackgroundColor:[UIColor clearColor]];
    [sendBtn setTitle:STR_SEND_CODE forState:UIControlStateNormal];
    [sendBtn setTitleColor:UIColorFromRGB(0xdf5f06) forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"light_yellow_btn.png"] forState:UIControlStateNormal];
    [sendBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [sendBtn addTarget:self action:@selector(sendPhone) forControlEvents:UIControlEventTouchUpInside];
    [m_ScrollView addSubview:sendBtn];
    
    // ------------------------手机号错误提示---------------------------
    CGRect phoneWarningRect = CGRectMake(phoneNumFd.frame.origin.x
                                         , CGRectGetMaxY(phoneNumFd.frame)+2
                                         , screenRect.size.width - phoneNumFd.frame.origin.x-30
                                         , 25);
    phoneWarningLbl = [OTSUtil labelWithTitle:OTS_STR_PHONE_EMPTY rect:phoneWarningRect font:[UIFont systemFontOfSize:13.f] color:OTS_COLOR_FROM_RGB(0xCC0000)];
    phoneWarningLbl.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:0.7];
    phoneWarningLbl.textAlignment = NSTextAlignmentLeft;
    phoneWarningLbl.clipsToBounds = NO;
    phoneWarningLbl.hidden=YES;
    [m_ScrollView addSubview:phoneWarningLbl]; //---->>>
    
    // ------------------------验证码错误提示---------------------------
    CGRect validationWarningRect = CGRectMake(validationNumFd.frame.origin.x
                                         , CGRectGetMaxY(validationNumFd.frame)+5
                                         , screenRect.size.width - validationNumFd.frame.origin.x-30
                                         , 25);
    validationWarningLbl = [OTSUtil labelWithTitle:OTS_STR_CODE_EMPTY rect:validationWarningRect font:[UIFont systemFontOfSize:13.f] color:OTS_COLOR_FROM_RGB(0xCC0000)];
    validationWarningLbl.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:0.7];
    validationWarningLbl.textAlignment = NSTextAlignmentLeft;
    validationWarningLbl.clipsToBounds = NO;
    validationWarningLbl.hidden=YES;
    [m_ScrollView addSubview:validationWarningLbl];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    OTS_SAFE_RELEASE(sendBtn);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//验证手机号码生成验证码
-(void)sendPhone {
    
    [self resignTextFieldAction];
    
    BOOL validateSuccess = [self validatePhoneNumField];
    
    if (validateSuccess)
    {
        DebugLog(@"m_iCount %d",m_iCount); 
        if (m_iCount < 0) {
            [self requestCodeAction];
            m_iCount = ICOUNT;
            m_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        }
        else
        {
            [self aLert:@"每次验证需间隔5分钟，请您稍后再试；5分钟之后点击发送，可以发送成功" Tag:99];
        }

    }
}

//- (void)OnTimer
//{
//    int iSec = m_iCount%60;
//    NSString * strTime = [NSString stringWithFormat:STR_RESEND_CODE_FORMAT,iSec];
//    [sendBtn setTitle:strTime forState:UIControlStateNormal];
//    [sendBtn setFrame:CGRectMake(84, 120, 136, 31)];
//    [sendBtn setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateNormal];
//    [sendBtn setBackgroundImage:[UIImage imageNamed:@"gray_long_btn.png"] forState:UIControlStateNormal];
//    [sendBtn setEnabled:NO];
//    [sendBtn setAdjustsImageWhenDisabled:YES];
//    if((--m_iCount) == -1)
//    {
//        [sendBtn setTitle:STR_RESEND_CODE forState:UIControlStateNormal];
//        [sendBtn setFrame:CGRectMake(84,120,106,30)];
//        [sendBtn setBackgroundColor:[UIColor clearColor]];
//        [sendBtn setTitleColor:UIColorFromRGB(0xdf5f06) forState:UIControlStateNormal];
//        [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//        [sendBtn setBackgroundImage:[UIImage imageNamed:@"light_yellow_btn.png"] forState:UIControlStateNormal];
//        [sendBtn setEnabled:YES];
//        [sendBtn setAdjustsImageWhenDisabled:NO];
//        //over time and go to fail page
//        [m_timer invalidate];
//    }
//}

- (void) onTimer
{
    if ((--m_iCount) == -1) {
        [m_timer invalidate];
        m_timer = nil;
    }
}

#pragma mark    scrollView相关delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![phoneNumFd isExclusiveTouch]) { 
        phoneNumFd.placeholder = OTS_STR_PHONE_PLACEHOLDER;
        [phoneNumFd resignFirstResponder];  
    }  
    if (![validationNumFd isExclusiveTouch]) {
        validationNumFd.placeholder = OTS_STR_CODE_PLACEHOLDER;
        [validationNumFd resignFirstResponder];
    }
    validationNumFd.placeholder = OTS_STR_CODE_PLACEHOLDER;
    [self performSelector:@selector(resignWindow) withObject:nil afterDelay:0];
    [self KeyBoardRevertAnim];
    
    if (scrollView!=m_ScrollView) {
        return;
    }
}

//-------------------返回-----------------------------
-(IBAction)returnBtnClicked:(id)sender
{
    [self.view.superview.layer addAnimation:[OTSNaviAnimation animationPushFromLeft] forKey:@"Reveal"];
    [self removeSelf];
}

//-------------------完成-----------------------------
-(IBAction)finishAction:(id)sender
{
    [self resignTextFieldAction];
    
    BOOL phoneNumberOK = [self validatePhoneNumField];
    BOOL codeOK = [self validateCodeField];
    
    if (phoneNumberOK && codeOK)
    {
        [self threadDoAction:[NSNumber numberWithInt:CPSSecurityValidationActionCheckCode]];
    }
}

//----------------------关闭键盘回到初始状态-----------------------
-(IBAction)resignTextFieldAction:(id)sender
{
    if (![phoneNumFd isExclusiveTouch]) { 
        phoneNumFd.placeholder = OTS_STR_PHONE_PLACEHOLDER;
        [phoneNumFd resignFirstResponder];  
    }  
    if (![validationNumFd isExclusiveTouch]) {
        validationNumFd.placeholder = OTS_STR_CODE_PLACEHOLDER;
        [self KeyBoardRevertAnim];
        [validationNumFd resignFirstResponder];
//        [self performSelector:@selector(resignWindow) withObject:nil afterDelay:0.5f];
    }
    
}

-(void)resignWindow
{
    [validationNumFd resignFirstResponder];
}

#pragma mark - 线程操作

-(void)threadDoAction:(id)aActionTypeObj message:(NSString*)aMessage
{

    [self otsDetatchMemorySafeNewThreadSelector:@selector(threadFunction:) 
                                       toTarget:self 
                                     withObject:aActionTypeObj];
    
    [[OTSGlobalLoadingView sharedInstance] showInView:self.view title:aMessage];
    
}

-(void)threadDoAction:(id)aActionTypeObj
{
    [self threadDoAction:aActionTypeObj message:nil];
}

#pragma mark - text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == phoneNumFd)
    {
        phoneNumFd.text = @"";
        phoneWarningLbl.hidden = YES;
        [self revertSendBtnPosition];
    }
    else if (textField == validationNumFd)
    {
        [self KeyBoardRiseAnim];
        validationNumFd.text = @"";
        validationWarningLbl.hidden = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == phoneNumFd)
    {
        [self validatePhoneNumField];
        phoneWarningLbl.hidden = [phoneNumFd.text length] > 0;
    }
    else if (textField == validationNumFd)
    {
        [self validateCodeField];
        validationWarningLbl.hidden = [validationNumFd.text length] > 0;
    }
    
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger changedLength = [string length];
    
    if (textField == phoneNumFd && [phoneNumFd.text length] >= 11 && changedLength)
    {
        return NO;
    }
    else if (textField == validationNumFd && [validationNumFd.text length] >= VALIDATE_CODE_LENGTH && changedLength)
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)revertSendBtnPosition{
    if (rever) {
        sendBtn.layer.position = CGPointMake(sendBtn.frame.origin.x+sendBtn.frame.size.width/2, sendBtn.frame.origin.y+sendBtn.frame.size.height/2-offset);
        rever = NO;
    }
    return rever;
}

-(BOOL)validatePhoneNumField
{
    BOOL passed = NO;
    
    if (phoneNumFd.text == nil || [phoneNumFd.text length] <= 0)
    {
        phoneWarningLbl.text = OTS_STR_PHONE_EMPTY;
        rever = YES;
        offset = OFFSET;
    }
    else if ([phoneNumFd.text length] != 11)
    {
        phoneWarningLbl.text = [NSString stringWithFormat:OTS_STR_PHONE_ERROR, [phoneNumFd.text length]];
        rever = YES;
        offset = OFFSET;
    }
    else
    {
        phoneWarningLbl.text = @"";
        passed = YES;
        offset = OFFSETZORE;
    }
    
    phoneWarningLbl.hidden = passed;
    
    sendBtn.layer.position = 
    CGPointMake(sendBtn.frame.origin.x+sendBtn.frame.size.width/2,
                sendBtn.frame.origin.y+sendBtn.frame.size.height/2+offset);
    
    return passed;
}

-(BOOL)validateCodeField
{
    BOOL passed = NO;
    
    if (validationNumFd.text == nil || [validationNumFd.text length] <= 0 || [validationNumFd.text isEqualToString:@"请输入验证码"])
    {
        validationWarningLbl.text = OTS_STR_CODE_EMPTY;
    }
    else if ([validationNumFd.text length] != VALIDATE_CODE_LENGTH)
    {
        validationWarningLbl.text = [NSString stringWithFormat:OTS_STR_CODE_ERROR
                                     , VALIDATE_CODE_LENGTH
                                     , [validationNumFd.text length]];
    }
    else
    {
        validationWarningLbl.text = @"";
        passed = YES;
    }
    
    validationWarningLbl.hidden = passed;
    
    return passed;
}

-(id)requestCodeAction
{
    [self resignTextFieldAction];
    
    BOOL validateSuccess = [self validatePhoneNumField];
    
    if (validateSuccess)
    {
        [self threadDoAction:[NSNumber numberWithInt:CPSSecurityValidationActionSendCode]];
    }
    return [NSNumber numberWithBool:validateSuccess];
}


// 线程函数
-(void)threadFunction:(id)aActionTypeObj
{
//    phoneNumFd.text = @"";
    int actionType = [aActionTypeObj intValue];
    CouponService *cpService=[[[CouponService alloc] init] autorelease];
    switch (actionType)
    {
        case CPSSecurityValidationActionSendCode:
        {
            //---------------重新发送时候要判断是否绑定手机-------------------
            if (isBond) 
            {
                self.m_NeedCheck = [cpService saveCouponToSessionOrderV2:[GlobalValue getGlobalValueInstance].token couponNumber:m_CouponNumber];
            }
            else
            {
                self.m_NeedCheck = [cpService getCouponCheckCode:[GlobalValue getGlobalValueInstance].token mobile:phoneNumFd.text];
            }

        }
            break;
            
        case CPSSecurityValidationActionCheckCode:
        {
            self.m_NeedCheck = [cpService verifyCouponCheckCode:[GlobalValue getGlobalValueInstance].token mobile:phoneNumFd.text checkCode:validationNumFd.text];
        }
            break;
        case CPSSecurityValidationActionSaveCoupon:
        {
            self.m_NeedCheck = [cpService saveCouponToSessionOrderV2:[GlobalValue getGlobalValueInstance].token couponNumber:m_CouponNumber];
        }
            break;
        default:
            break;
    }
    
    // 刷新UI
    [self performSelectorOnMainThread:@selector(updateUIAfterAction:) withObject:aActionTypeObj waitUntilDone:YES]; 
}

#pragma mark - 更新UI

-(void)updateUIAfterAction:(id)aActionTypeObj
{
    [[OTSGlobalLoadingView sharedInstance] hide];
    
    int actionType = [aActionTypeObj intValue];
    
    switch (actionType)
    {
        case CPSSecurityValidationActionSendCode:
        {
            if (isBond) 
            {
                if ([self.m_NeedCheck.resultCode intValue] == -30) {
                      [self aLert:self.m_NeedCheck.errorInfo Tag:ALERTVIEW_TAG_SEND_CODE_SUCCESS];
                }
                else
                {
                    [self aLert:self.m_NeedCheck.errorInfo Tag:ALERTVIEW_TAG_SEND_CODE_FAILED];
                }
            }
            else
            {
                if ([self.m_NeedCheck.resultCode intValue] == 1)
                {
                    [self aLert:OTS_STR_CODE_RECEIVE_ONPHONE Tag:ALERTVIEW_TAG_SEND_CODE_SUCCESS];
                }
                else
                {
                    [self aLert:self.m_NeedCheck.errorInfo Tag:ALERTVIEW_TAG_SEND_CODE_FAILED];
                }
            }
  
        }
            break;
            
        case CPSSecurityValidationActionCheckCode:
        {
            if ([self.m_NeedCheck.resultCode intValue] == 1)
            {
                [self threadDoAction:[NSNumber numberWithInt:CPSSecurityValidationActionSaveCoupon]];
            }
            else
            {
                [self aLert:self.m_NeedCheck.errorInfo Tag:ALERTVIEW_TAG_CHECK_CODE_FAILED];
            }
        }
            break;
        case CPSSecurityValidationActionSaveCoupon:{
            if ([self.m_NeedCheck.resultCode intValue] == 1) {
             //------------------保存抵用卷成功,转到订单详情------------------------------------
                // 需传入额外的couponNumber
//                NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:1];
//                [dic setSafeObject:m_CouponNumber forKey:@"couponNumber"];
//                JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_SaveCoupon extraPramaDic:dic] autorelease];
//                JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_SaveCoupon extraPrama:m_CouponNumber, nil]autorelease];
//                [DoTracking doJsTrackingWithParma:prama];
                
                // 导航
                [self naviToCheckOrder:nil];
            }
            else
            {
                [self naviToCheckOrder:self.m_NeedCheck.errorInfo];
                
            }
        
        }
        default:
            break;
    }
}

//-----------------------------导航到检查订单------------------------------------
-(void)naviToCheckOrder:(id)aObj{
    
    if ([notifyTarget respondsToSelector:notifyAction]){
        
        [notifyTarget performSelector:notifyAction withObject:aObj];

    }
}

//-----------------------------键盘上升动画--------------------------------------
- (void) KeyBoardRiseAnim
{
    NSTimeInterval animationDuration=0.1f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width=self.view.frame.size.width;
    float height=self.view.frame.size.height;
    CGRect rect=CGRectMake(0.0f,-70,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}

//-----------------------------键盘回复动画--------------------------------------
- (void) KeyBoardRevertAnim
{
    NSTimeInterval animationDuration=0.1f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width=self.view.frame.size.width;
    float height=self.view.frame.size.height;
    CGRect rect=CGRectMake(0.0f,0.0f,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}

#pragma mark 设置alert点击操作
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    switch (alertView.tag) {
        case ALERTVIEW_TAG_SEND_CODE_SUCCESS: {
            if (buttonIndex==0) {
                [validationNumFd becomeFirstResponder];
            }
            break;
        }
        case ALERTVIEW_TAG_SEND_CODE_FAILED: {
            if (buttonIndex==0) {
                //
            }
            break;
        }
        case ALERTVIEW_TAG_CHECK_CODE_SUCCESS: {
            if (buttonIndex==0) {
                //
            }
            break;
        }
        case ALERTVIEW_TAG_CHECK_CODE_FAILED: {
            if (buttonIndex==0) {
                //
            }
            break;
        }
        case ALERTVIEW_TAG_SAVECOUPON_SUCCESS: {
            if (buttonIndex==0) {
                //
            }
            break;
        }
        case ALERTVIEW_TAG_SAVECOUPON_FAILED: {
            if (buttonIndex==0) {
                //
            }
            break;
        }
        default:
            break;
    }
    [[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:NO];
}

-(void)aLert:(NSString*)aMessage Tag:(int)aTag
{
    if (![aMessage isEqualToString:@""]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" 
                                                        message:aMessage 
                                                       delegate:self 
                                              cancelButtonTitle:@"确定" 
                                              otherButtonTitles:nil];
        [alert setTag:aTag];
        [alert show];
        [alert release];
    }
}

-(void)dealloc
{
    OTS_SAFE_RELEASE(phoneNumFd);
    OTS_SAFE_RELEASE(validationNumFd);
    OTS_SAFE_RELEASE(finishBtn);
    OTS_SAFE_RELEASE(m_NeedCheck);
    [super dealloc];
}

@end
