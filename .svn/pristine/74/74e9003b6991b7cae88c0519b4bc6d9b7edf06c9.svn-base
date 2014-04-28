//
//  CellPhoneBindViewController.h
//  TheStoreApp
//
//  Created by towne on 12-10-31.
//
//


#import "OTSBaseViewController.h"
#import "UIDeviceHardware.h"
#import "OTSNaviAnimation.h"
#import "OTSActionSheet.h"
#import "GlobalValue.h"
#import "AlertView.h"

#import "OTSServiceHelper.h"

@interface BindViewController : OTSBaseViewController<UIScrollViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>
{
    IBOutlet UIView        *_phoneBindingView;
    IBOutlet UIView        *_phoneBindingverifyView;
    IBOutlet UIView        *_phoneBindAlreadyView;
    
    IBOutlet UIButton      *_1haodianCustomerServiceBTN;
    IBOutlet UILabel       *_phoneBindingNUM;
    
    IBOutlet UIScrollView  *_phoneBingdingScrollView;
    IBOutlet UITextField   *_needBindingPhoneNUM;
    IBOutlet UIButton      *_phoneBindingWarningMask;
    IBOutlet UILabel       *_phoneBindingWarningLB;
    IBOutlet UIButton      *_phoneBindingGetVerifyBTN;
    CGFloat                 _offset;
    BOOL                    _rever;
    
    //手机绑定验证相关
    IBOutlet UIScrollView  *_phoneBindingVerifyScrollView;
    IBOutlet UILabel       *_phoneBindingVerifyWarningLB;
    IBOutlet UIButton      *_phoneBindingVerifyWarningMask;
    IBOutlet UILabel       *_phoneBindingVerifyPhoneNUM;
    IBOutlet UITextField   *_phoneBindingVerifyCode;
    
    IBOutlet UIButton      *_phoneBindingVerifyCodeSubmitBTN;
    IBOutlet UIButton      *_phoneBindingVerifyCodeRefetchBTN;
    NSTimer*                _timer;
    int                     _expireSeconds;
    int                     _currentSeconds;
    
}
@property(nonatomic)BOOL    isBindMobile;   // 是否绑定手机
@property(nonatomic,retain) NSNumber *bindMobileNum; //若绑定,则存绑定的号码

@end
