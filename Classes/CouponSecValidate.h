//
//  CouponSecValidate.h
//  TheStoreApp
//
//  Created by towne on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GlobalValue.h"
#import "CouponService.h"
#import "OTSLoadingView.h"
#import "OTSUtil.h"
#import "OTSNaviAnimation.h"
#import "CouponCheckResult.h"
#import "OTSAlertView.h"

// 接口行为类别
enum CPSSecurityValidationActionType
{
    CPSSecurityValidationActionSendCode = 0            // 检查手机号
    , CPSSecurityValidationActionCheckCode =1          // 检查验证码
    , CPSSecurityValidationActionSaveCoupon = 2        // 验证成功后保存订单   
};

@interface CouponSecValidate : OTSBaseViewController<UITextFieldDelegate,UIScrollViewDelegate>
{
    IBOutlet UIScrollView       *m_ScrollView;
    IBOutlet UITextField        *phoneNumFd;
    IBOutlet UITextField        *validationNumFd;
    IBOutlet UIButton           *finishBtn;
    UIButton                    *sendBtn;
    UIImageView                 *m_BGView;
    NSTimer                     *m_timer;
    int                         m_iCount;
    
    UILabel                     *phoneWarningLbl;
    UILabel                     *validationWarningLbl;
    
    BOOL                        isBond;             // 是否绑定 （从NeedCheckResult得到）
    NSString*                   userPhoneNumber;    // 用户手机号（从NeedCheckResult得到）
    
    id                          notifyTarget;
    SEL                         notifyAction;
    
    CouponCheckResult           *m_NeedCheck;
    NSString                    *m_CouponNumber;    //当前正验证的抵用卷号
    CGFloat                     offset;
    BOOL                        rever; 
}
@property(nonatomic,retain) UITextField          *phoneNumFd;
@property(nonatomic,retain) UITextField          *validationNumFd;
@property(nonatomic,retain) UIButton             *finishBtn;
@property(nonatomic,retain) CouponCheckResult    *m_NeedCheck;

-(id)initWithNeedCheckResult:(CouponCheckResult*)aNeedCheckResult 
                   couponNum:(NSString *)aCouponNum
                    phoneNum:(NSString *)aPhoneNum
                notifyTarget:(id)aNotifyTarget 
                notifyAction:(SEL)aNotifyAction;

-(id)initWithNeedCheckResult:(CouponCheckResult*)aNeedCheckResult
                   couponNum:(NSString*)aCouponNum
                notifyTarget:(id)aNotifyTarget 
                notifyAction:(SEL)aNotifyAction;
-(void)KeyBoardRiseAnim;
-(void)KeyBoardRevertAnim;
-(BOOL)validatePhoneNumField;
-(BOOL)validateCodeField;
-(id)requestCodeAction;
-(BOOL)revertSendBtnPosition;
-(void)naviToCheckOrder:(id)aObj;
-(IBAction)resignTextFieldAction:(id)sender;
-(void)aLert:(NSString*)aMessage Tag:(int)aTag;

@end
