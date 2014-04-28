//
//  OTSSecurityValidationVC.h
//  TheStoreApp
//
//  Created by yiming dong on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OTSTimedSendButton;
@class OTSSecurityValidateService;
@class NeedCheckResult;
@class OTSHilightedTextField;
@class AccountBalance;

// 接口行为类别
enum EOTSSecurityValidationActionType
{
    KOTSSecurityValidationActionSendCode = 0         // 绑定手机号
    , KOTSSecurityValidationActionCheckCode             // 检查验证码
};

// 调用者类别
//typedef enum _EOTSSecurityValidationCallerType
//{
//    KOTSSVCallerNobody = 0         
//    , KOTSSVCallerBalancePay             // 余额支付
//}EOTSSecurityValidationCallerType;

@interface OTSSecurityValidationVC : OTSBaseViewController <UITextFieldDelegate, UIScrollViewDelegate>
{
    UIScrollView            * scrollView;
    UIButton                  * roundCornerBgView;
    UITextField             * phoneNumFd;
    UILabel                 * isPhoneBoundLbl;
    UILabel                 * phoneWarningLbl;
    OTSTimedSendButton      * requestCodeBtn;
    OTSTimedSendButton      * secondTimerBtn;
    UIView                  * devideLine;
    UILabel                 * validationTipLbl;
    UILabel                 * validateNumLbl;
    UITextField             * validationNumFd;
    UILabel                 * validationWarningLbl;
    UIButton                * finishBtn;
    
    NSArray                 * phoneWarnAffectViews;
    
    UIButton                *doneInKeyboardButton;  // 数字键盘上的done按钮
    
    OTSSecurityValidateService  *service;
    BOOL                        isBond;             // 是否绑定 （从NeedCheckResult得到）
    NSString*                   userPhoneNumber;    // 用户手机号（从NeedCheckResult得到）
    
    BOOL                        isShowingMe;        // 记录当前视图是否为本控制器的视图，解决其他界面键盘被修改的问题
    
    //EOTSSecurityValidationCallerType    callerType;     // 调用者类型
    //id                                  callerObject;   // 调用者数据对象
    
    AccountBalance              *accountBalance;    //余额支付VC
    
    id                          notifyTarget;
    SEL                         notifyAction;
}

/**
 * 初始化方法：请使用这个初始化方法
 *
 * @param aNeedCheckResult 余额支付界面获得的NeedCheckResult，据此设置isBond和userPhoneNumber
 * @param aCallerType 调用者类型
 * @param aCallerObject 调用者数据对象， 验证成功后传给调用者
 * @return 类实例对象
 */
-(id)initWithNeedCheckResult:(NeedCheckResult*)aNeedCheckResult 
                notifyTarget:(id)aNotifyTarget 
                notifyAction:(SEL)aNotifyAction;
//                  callerType:(EOTSSecurityValidationCallerType)aCallerType 
//                callerObject:(id)aCallerObject;

+(NSString*)validateCode;   // 获取已存储的验证码
@end


