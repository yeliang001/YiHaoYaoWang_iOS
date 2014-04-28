//
//  LoginViewController.h
//  yhd
//
//  Created by zhlgong on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TencentOAuth.h"
#import "WBEngine.h"
#import "WBSendView.h"
#import "WBLogInAlertView.h"
#import "WBSDKTimelineViewController.h"
#import "CartVO.h"

@class OTSAliPayWebView;

@protocol LoginDelegate <NSObject>
@optional
-(void)loginsucceed;
-(void)loginclosed;
-(void)registersucceed;
//max modify
//-(void)loginSucceedFinish:(NSInteger)type;
@end


@interface LoginViewController : BaseViewController<TencentSessionDelegate,WBEngineDelegate,WBLogInAlertViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    TencentOAuth* _tencentOAuth;
    NSMutableArray* _permissions; 
    
    WBEngine* _sinaOAuth;
    WBSDKTimelineViewController *timeLineViewController;
    
    IBOutlet UIButton      *loginBtn;
    
    IBOutlet UITextField* mLoginUserName;
    IBOutlet UITextField* mLoginUserPassword;
    
    IBOutlet UITextField * mRegisterUserName;
    IBOutlet UITextField * mRegisterPasswordTextField;
    IBOutlet UISwitch * mShowPasswordSwitch;
    
    IBOutlet UIImageView * mverifyCodeImageView;
    IBOutlet UITextField * mverifyCodeTextField;
    
    IBOutlet UIView *loginVerifyView;
    IBOutlet UITextField *loginVerifyTF;
    IBOutlet UIImageView *loginVerifyImageView;
    
    IBOutlet UIButton*      remenberMeBtn;
    IBOutlet UIButton*      autoLoginBtn;
    NSString * mtemptoken;
    
    BOOL mloginsucceed;
    
    NSString * mUserName;
    NSString * mNickName;
    NSString * mUserImage;
    NSString * mCocode;
    
    BOOL msinaLogedin;
    
    BOOL mneedToAddInCart;
    CartVO * mcart;
    
    id delegate;
}

@property (nonatomic, retain) WBEngine                      *weiBoEngine;
@property(nonatomic,assign)BOOL                             mneedToAddInCart;
@property(nonatomic,retain)CartVO                           *mcart;
@property(nonatomic,retain)id                               delegate;
@property(nonatomic, retain) OTSAliPayWebView               *aliPlayWebView;
@property(retain)VerifyCodeVO                 *verifycodeVO;

@property (retain, nonatomic) IBOutlet UIButton *closeButton;
@property (retain, nonatomic) IBOutlet UIButton*      remenberMeBtn;
@property (retain, nonatomic) IBOutlet UIButton*      autoLoginBtn;
-(IBAction)switchchanged:(id)sender;
-(IBAction)loginClicked:(id)sender;

-(IBAction)zhifubaologinClicked:(id)sender;
-(IBAction)qqloginClicked:(id)sender;
-(IBAction)sinaweibologinClicked:(id)sender;
-(IBAction)oneMallLoginAction:(id)sender;

-(IBAction)registerClicked:(id)sender;
-(IBAction)changeVerifyCodeClicked:(id)sender;
-(IBAction)closeClicked:(id)sender;
-(IBAction)rememberPasswordClick:(id)sender;
-(IBAction)autoLoginClick:(id)sender;



-(void)synCart;
-(void)popLogin;
@end
