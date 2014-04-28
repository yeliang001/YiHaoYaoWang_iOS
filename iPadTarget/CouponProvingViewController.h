//
//  CouponProvingViewController.h
//  TheStoreApp
//
//  Created by xuexiang on 12-11-28.
//
//

#import "BaseViewController.h"
#import "CouponCheckResult.h"

@interface CouponProvingViewController : BaseViewController<UITextFieldDelegate>{
    CouponCheckResult* checkResult;
    NSString* couponNum;
    
}
@property (retain, nonatomic) CouponCheckResult* checkResult;
@property (retain, nonatomic) NSString* couponNum;
@property (retain, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (retain, nonatomic) IBOutlet UIButton *flishiBtn;

-(IBAction)getCodeBtnClicked:(id)sender;
-(IBAction)flishBtnClicked:(id)sender;
-(IBAction)close:(id)sender;
@end
