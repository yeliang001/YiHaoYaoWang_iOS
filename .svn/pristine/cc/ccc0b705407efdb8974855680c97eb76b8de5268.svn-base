//
//  UseCoupon.h
//  TheStoreApp
//
//  Created by towne on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "CouponService.h"
#import "GlobalValue.h"
#import "LoadingMoreLabel.h"
#import "AlertView.h"
#import "CouponVO.h"
#import "OTSNaviAnimation.h"
#import "CouponSecValidate.h"
#import "CouponRule.h"
#import "OTSUtility.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ADD_A_COUPON              @"添加一张抵用券"
#define INPUT_COUPON_CODE         @"输入抵用卷编码"
#define USE_COUPON                @"使 用"
#define SELECTED_EXSIT_COUPON     @"选择已有的抵用券\n(使用抵用券后仅支持网上支付)"
#define NOT_ACHIEVE_USE           @"未满足使用条件"
#define STR_COUPON_EMPTY          @"抵用券号不能为空"
#define NET_ERROR                 @"网络异常，请检查网络配置..."

@class LoadingMoreLabel;

@interface UseCoupon : OTSBaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    IBOutlet UIScrollView            *m_ScrollView;
    LoadingMoreLabel                 *m_LoadingMoreLabel;
    
    int                              m_ThreadStatus;
    BOOL                             m_ThreadRunning;
    
    int                              m_PageIndex;         //页面索引
    int                              m_CouponTotalNum;    //抵用卷总数量
    NSMutableArray                   *m_AllCoupons;       //所有的抵用卷
    int                              m_CouponStatus;      //抵用卷使用条件 1:满足 2：未满足 
    
    UILabel                          *couponValidateInfo; //短信验证提示信息
    UIButton                         *couponWarningCros;  //提示信息警告
    UITextField                      *couponNumFd;        //抵用卷输入编号验证
    UIButton                         *couponUse;          //使用抵用卷按钮
//    CouponSecValidate                *m_SecValidateVC;    //短信验证界面
    CouponCheckResult                *m_NeedCheck;        //抵用卷检查结果VO
    NSString                         *m_CouponNumber;     //当前待验证的抵用卷号
    NSString                         *m_OriginalCouponNumber; //原始抵用卷
    UIButton                         *roundCornerBgView;
    bool                             done;
    bool                             inputManually;       //是手动输入的抵用卷
    
    id m_Taget;
    SEL m_FinishSelector;
}
@property(retain) CouponCheckResult *m_NeedCheck;
@property(nonatomic,retain)  NSString  *m_CouponNumber;
@property(nonatomic,retain)  NSString  *m_OriginalCouponNumber;

-(void)initMyCoupon;
-(void)setUpThread:(BOOL)showLoading;
-(void)stopThread;
-(UIImageView*)checkMarkView;
-(void)enterCheckSMS;
-(void)enterCheckSMS:(NSString *)aPhoneNum;
-(void)showError:(NSString *)error;
-(void)saveCouponSessionOrder;
-(void)resignTextFieldAction;
-(BOOL)validateCouponNumField;
-(BOOL)validatePhoneNumField:(NSString *)aPhoneNum;
-(NSString*)getNumbersFromString:(NSString*)String;
-(void)aLert:(NSString*)aMessage Tag:(int)aTag;
-(void)setTaget:(id)taget finishSelector:(SEL)selector;
@end
