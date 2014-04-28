//
//  MyCoupon.h
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
#import "CouponRule.h"
#import "OTSUtility.h"

#define HAVE_NOT_CAN_USE_COUPON @"您目前没有未使用的抵用券！"
#define HAVE_NOT_IN_USE_COUPON  @"您目前没有已经使用的抵用券！"
#define HAVE_NOT_EXPIRED_COUPON @"您目前没有已经过期的抵用券！"

@class LoadingMoreLabel;

@interface MyCoupon : OTSBaseViewController<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
{
    IBOutlet UIScrollView *m_ScrollView;
    UIScrollView *m_empScrollView;
    IBOutlet UIView *m_TypeView;
    
    LoadingMoreLabel *m_LoadingMoreLabel;
    
    int m_ThreadStatus;
    BOOL m_ThreadRunning;
    
    int m_CouponType;//抵用卷类型 0:所有 1:未使用 2：已使用 3：已过期
    int m_PageIndex;//页面索引
    int m_CouponTotalNum;//抵用卷总数量
    NSMutableArray *m_AllCoupons;//所有的抵用卷
    int m_CurrentTypeIndex;//当前类型按钮的索引值
}
//@property(nonatomic) bool              fromOrder;

-(void)initMyCoupon;
-(void)setUpThread:(BOOL)showLoading;
-(void)stopThread;

@end
