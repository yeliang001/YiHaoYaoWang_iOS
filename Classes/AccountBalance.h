//
//  AccountBalance.h
//  TheStoreApp
//
//  Created by jiming huang on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h> 
@class NeedCheckResult;
@class OTSSecurityValidationVC;

@interface AccountBalance : OTSBaseViewController<UITextFieldDelegate,UIActionSheetDelegate> {
    IBOutlet UIScrollView *m_ScrollView; //
    IBOutlet UILabel *m_TitleLabel;  //
    IBOutlet UIButton *m_TopRightBtn;//
    IBOutlet UITextField *m_TextField;
    NSMutableDictionary *m_InputDictionay;//传入参数，包含账户可用余额，需要支付金额
    double m_AccountBalance;//账户可用余额
    double m_FrozenMoney;//账户冻结金额
    double m_NeedPayMoney;//需要支付金额
    double m_PayMoney;//用户支付的金额
    NeedCheckResult *m_NeedCheck;//查询是否需要安全验证结果
    OTSSecurityValidationVC *m_SecValidateVC;
    NSString *m_ValidCode;
    int m_ThreadState;
    BOOL m_ThreadRunning;
    
    id m_Taget;
    SEL m_FinishSelector;
    int m_Type;//type为1表示普通结算，type为2表示团购结算
    int payStyle;  //0为现金余额支付，1为礼品卡余额支付
    int numberOfGiftCard;
}

@property(retain,nonatomic) NSMutableDictionary *m_InputDictionay;//传入参数，包含账户可用余额，需要支付金额
@property(nonatomic)int payStyle;

-(void)setTaget:(id)taget finishSelector:(SEL)selector type:(int)type;
-(void)initAccountBalance;
-(void)setUpThread;
-(void)stopThread;
@end
