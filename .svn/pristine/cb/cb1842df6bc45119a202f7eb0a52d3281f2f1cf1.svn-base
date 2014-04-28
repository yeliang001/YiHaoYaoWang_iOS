//
//  CouponViewController.h
//  TheStoreApp
//
//  Created by xuexiang on 12-11-26.
//
//

#import "BaseViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define CLOSE_COUPON_CLOSEDIRECTLY @"close"
#define SAVE_COUPON_SUCCESS @"savesuccess"

#define NEED_CHECK_PHONE      -27
#define NEED_CHECK_VALIDATION -30
#define NEED_NOT_CHECK         1
#define NEED_CHECK_DEL         -9

@interface CouponViewController : BaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic, retain)NSString* currentCouponNumber;
-(IBAction)closeCouponVC:(id)sender;
-(IBAction)closeRegulation:(id)sender;
@end
