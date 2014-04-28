//
//  CouponProvingViewController.m
//  TheStoreApp
//
//  Created by xuexiang on 12-11-28.
//
//

#import "CouponProvingViewController.h"
#import "CouponViewController.h"
#import "CouponService.h"

#define errStateNormal  100
#define errStatePhone   101
#define errStateCode    102
#define errStateBoth    103

#define serviceStateGetCode     200
#define serviceStateSaveCoupon  201
#define serviceStateVerify      202

#define VERTIFY_TYPE_PHONE      10
#define VERTIFY_TYPE_CODE       11

#define FRAME_GETCODEBTN    CGRectMake(68, 84, 201, 41)
#define FRAME_FLISHBTN      CGRectMake(68, 74, 201, 41)
#define FRAME_BOTTOMVIEW    CGRectMake(0, 161, 435, 160)

@interface CouponProvingViewController ()
@property (retain, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (retain, nonatomic) IBOutlet UITextField *secCodeTF;
@property (retain, nonatomic) IBOutlet UILabel *notBindngLabel;
@property (retain, nonatomic) IBOutlet UIView *frameView;
@property (retain, nonatomic) IBOutlet UIView *errInfoView;
@property (retain, nonatomic) IBOutlet UILabel *errorLabel;
@property (retain, nonatomic) IBOutlet UIView *errInfoView2;
@property (retain, nonatomic) IBOutlet UILabel *errorLabel2;
@property (retain, nonatomic) IBOutlet UIView *bottomView;
@property (retain, nonatomic) NSString* phoneNumber;
@property (retain, nonatomic) NSTimer* timer;
@property (nonatomic, retain) CouponCheckResult *m_CheckResult;
@property (nonatomic)NSUInteger curTime;
@property (nonatomic)NSUInteger errState;
@property (nonatomic)NSUInteger serviceState;
@property (nonatomic)BOOL isObtainCodeAgain;
@property (nonatomic)NSUInteger vertifyType;
@end

@implementation CouponProvingViewController

@synthesize errState,serviceState,isObtainCodeAgain,vertifyType,curTime;
@synthesize checkResult, couponNum, phoneNumber, m_CheckResult,timer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _frameView.layer.borderColor = [UIColor colorWithRed:201.0/255 green:201.0/255 blue:201.0/255 alpha:1.0].CGColor;
    _frameView.layer.borderWidth =1;
    _frameView.layer.cornerRadius = 7.0;
    _frameView.layer.masksToBounds = YES;
    
    isObtainCodeAgain = NO;
    curTime = 60;
    [self initUI];
}
-(void)initUI{
    if ([checkResult.resultCode intValue] == NEED_CHECK_PHONE) {
        //------------------需要手机验证-----------------------------------------------
        vertifyType = VERTIFY_TYPE_PHONE;
        isObtainCodeAgain = NO;
        [_getCodeBtn setBackgroundImage:[UIImage imageNamed:@"orange_long_button.png"] forState:UIControlStateNormal];
        [_getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else if([checkResult.resultCode intValue] == NEED_CHECK_VALIDATION){
        //------------------已绑定手机，只需要验证码验证-----------------------------------
        vertifyType = VERTIFY_TYPE_CODE;
        [_notBindngLabel setText:@"已绑定"];
        self.phoneNumber = [self getNumbersFromString:[checkResult errorInfo]];
        [_phoneNumTF setText:phoneNumber];
        [_phoneNumTF setEnabled:NO];
        isObtainCodeAgain = YES;
        // 获取验证码按钮进入倒计时
        [_getCodeBtn setTitle:@"重新获取(60)" forState:UIControlStateNormal];
        [_getCodeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_getCodeBtn setEnabled:NO];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFunction) userInfo:nil repeats:YES];
        [_getCodeBtn setEnabled:NO];
        
        [_flishiBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_flishiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_flishiBtn setFrame:CGRectMake(68, 74, 120, 41)];
        [_flishiBtn setBackgroundImage:[UIImage imageNamed:@"orange_button.png"] forState:UIControlStateNormal];
    }
}
-(BOOL)checkThePhoneNO{
    if (_phoneNumTF.text.length == 11) {
        self.phoneNumber = _phoneNumTF.text;
        return YES;
    }else{
        _errorLabel.text = @"手机号码格式不正确，请重新输入";
        [_errInfoView setHidden:NO];
        if (errState!=errStatePhone) {
            errState = errStatePhone;
            [self updateHandel];
        }
        return NO;
    }
}
-(void)saveCouponHandel{
    if (m_CheckResult.resultCode.intValue == 1) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CloseCouponProvingVC" object:@"CloseWithReload"];
    }else{
        errState = errStateCode;
        [self updateHandel];
    }
}
-(void)updateHandel{
    if (errState == errStateNormal) {       // 接口调用成功
        // 获取验证码调用成功
        if (serviceState == serviceStateGetCode ||  serviceState == serviceStateSaveCoupon) {  // 倒计时60重新获取验证码可用
            curTime = 60;
            [_getCodeBtn setTitle:@"重新获取(60)" forState:UIControlStateNormal];
            [_getCodeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [_getCodeBtn setEnabled:NO];
            [_getCodeBtn setBackgroundImage:[UIImage imageNamed:@"couponProving_Btn.png"] forState:UIControlStateNormal];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFunction) userInfo:nil repeats:YES];
        }
        if (serviceState == serviceStateVerify) {// 输入验证码后调用成功，直接保存抵用券
            [self performInThreadBlock:^{
                [self saveCouponToSessionOrder];
            } completionInMainBlock:^{
                [self saveCouponHandel];
            }];
        }
        if (vertifyType == VERTIFY_TYPE_PHONE && serviceState == serviceStateGetCode) {
            [_flishiBtn setBackgroundImage:[UIImage imageNamed:@"orange_long_button.png"] forState:UIControlStateNormal];
            [_flishiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        else{                                  // 隐藏错误信息
            [_getCodeBtn setFrame:FRAME_GETCODEBTN];
            [_bottomView setFrame:FRAME_BOTTOMVIEW];
            [_flishiBtn setFrame:FRAME_FLISHBTN];
            [_errInfoView setHidden:YES];
        }
    }else                                   // 接口调用错误，显示错误信息
    if (errState == errStatePhone) {
        [_errInfoView setHidden:NO];
        [_errorLabel setText:m_CheckResult.errorInfo];
        [_getCodeBtn setFrame:CGRectMake(FRAME_GETCODEBTN.origin.x, FRAME_GETCODEBTN.origin.y+15, FRAME_GETCODEBTN.size.width, FRAME_GETCODEBTN.size.height)];
        [_bottomView setFrame:CGRectMake(FRAME_BOTTOMVIEW.origin.x, FRAME_BOTTOMVIEW.origin.y+15, FRAME_BOTTOMVIEW.size.width, FRAME_BOTTOMVIEW.size.height)];
        
    }else if (errState == errStateCode){
        [_flishiBtn setFrame:CGRectMake(FRAME_FLISHBTN.origin.x, FRAME_FLISHBTN.origin.y+15, FRAME_FLISHBTN.size.width, FRAME_FLISHBTN.size.height)];
        [_errInfoView2 setHidden:NO];
        [_errorLabel2 setText:m_CheckResult.errorInfo];
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
-(void)timerFunction{
    [_getCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%d)",--curTime]  forState:UIControlStateNormal];
    if (curTime == 0) {
        [timer invalidate];
        self.timer = nil;
        [_getCodeBtn setBackgroundImage:[UIImage imageNamed:@"orange_button.png"] forState:UIControlStateNormal];
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_getCodeBtn setEnabled:YES];
        curTime = 60;
    }
}
#pragma mark -
#pragma mark actions
-(IBAction)close:(id)sender{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CloseCouponProvingVC" object:nil];
}
-(IBAction)getCodeBtnClicked:(id)sender{
    [_phoneNumTF resignFirstResponder];
    [_secCodeTF resignFirstResponder];
    if (curTime != 60) {
        return;
    }
    if (isObtainCodeAgain && vertifyType == VERTIFY_TYPE_CODE) { // 已绑定用户再次获取验证码
        [self performInThreadBlock:^(){
            [self saveCouponToSessionOrder];
        }completionInMainBlock:^(){
            [self updateHandel];
        }];
    }else{                                                       // 未绑定用户获取验证码,调用接口不一致
        if ([self checkThePhoneNO]) {
            [self performInThreadBlock:^(){
                [self getCouponCheckCode];
            }completionInMainBlock:^(){
                [self updateHandel];
            }];
        }
    }
   
}
-(IBAction)flishBtnClicked:(id)sender{                          // 提交验证码，正确后直接保存到订单，若成功，直接返回到检查订单页面。
    [_phoneNumTF resignFirstResponder];
    [_secCodeTF resignFirstResponder];
    [self performInThreadBlock:^(){
        [self verifyCouponCheckCode];
    }completionInMainBlock:^(){
        [self updateHandel];
    }];
}
#pragma mark -
#pragma mark Service
// 保存抵用券到当前订单
-(void)saveCouponToSessionOrder{
    serviceState = serviceStateSaveCoupon;
    CouponService *cpService=[[[CouponService alloc] init] autorelease];
    self.m_CheckResult = [cpService saveCouponToSessionOrderV2:[GlobalValue getGlobalValueInstance].token couponNumber:couponNum];
    if (m_CheckResult.resultCode.intValue == 1) {
        errState = errStateNormal;
    }else{
        errState = errStatePhone;
    }
}
// 获取验证码
-(void)getCouponCheckCode{
    serviceState = serviceStateGetCode;
    CouponService *cpService=[[[CouponService alloc] init] autorelease];
    self.m_CheckResult = [cpService getCouponCheckCode:[GlobalValue getGlobalValueInstance].token mobile:phoneNumber];
    if (m_CheckResult.resultCode.intValue == 1) {
        errState = errStateNormal;
    }else{
        errState = errStatePhone;
    }
}
// 提交验证码
-(void)verifyCouponCheckCode{
    serviceState = serviceStateVerify;
    CouponService *cpService=[[[CouponService alloc] init] autorelease];
    self.m_CheckResult = [cpService verifyCouponCheckCode:[GlobalValue getGlobalValueInstance].token mobile:phoneNumber checkCode:_secCodeTF.text];
    if (m_CheckResult.resultCode.intValue == 1) {
        errState = errStateNormal;
    }else{
        errState = errStateCode;
    }
}

#pragma mark -
#pragma mark UITextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;{
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    CGRect rect = CGRectMake(self.view.frame.origin.x, -1, width, height);
    self.view.frame = rect;
    [UIView commitAnimations];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(self.view.frame.origin.x, 80, self.view.frame.size.width,self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
}
#pragma mark -
#pragma mark release

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [_flishiBtn release];
    [_getCodeBtn release];
    [_phoneNumTF release];
    [_secCodeTF release];
    [_notBindngLabel release];
    [_frameView release];
    [_errInfoView release];
    [_errorLabel release];
    [_bottomView release];
    [_errInfoView2 release];
    [_errorLabel2 release];
    
    OTS_SAFE_RELEASE(phoneNumber);
    OTS_SAFE_RELEASE(timer);
    OTS_SAFE_RELEASE(m_CheckResult);
    [super dealloc];
}
- (void)viewDidUnload {
    [self setFlishiBtn:nil];
    [self setGetCodeBtn:nil];
    [self setPhoneNumTF:nil];
    [self setSecCodeTF:nil];
    [self setNotBindngLabel:nil];
    [self setFrameView:nil];
    [self setErrInfoView:nil];
    [self setErrorLabel:nil];
    [self setBottomView:nil];
    [self setErrInfoView2:nil];
    [self setErrorLabel2:nil];
    
    OTS_SAFE_RELEASE(phoneNumber);
    OTS_SAFE_RELEASE(timer);
    OTS_SAFE_RELEASE(m_CheckResult);
    [super viewDidUnload];
}
@end
