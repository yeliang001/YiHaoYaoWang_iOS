//
//  CouponRule.h
//  TheStoreApp
//
//  Created by towne on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "OTSNaviAnimation.h"
#import "CouponVO.h"

@interface CouponRule : OTSBaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    CouponVO *mCoupon;
    IBOutlet UIScrollView *mScrollView;
    UITextView *mTextView;
    NSArray * RegulationArr;
}
@property(nonatomic,retain) CouponVO *mCoupon;
@property(nonatomic,retain) UITextView *mTextView;
@property(nonatomic,retain)  NSArray * RegulationArr;
@property(retain, nonatomic) IBOutlet UITableView *regulationTableView;
@property(retain, nonatomic) IBOutlet UILabel *mLabel;

-(id)initWithCoupon:(CouponVO *)aCoupon;
@end
