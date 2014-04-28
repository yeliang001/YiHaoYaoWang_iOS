//
//  PaymentSheet.h
//  yhd
//
//  Created by jun yuan on 12-8-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentMethodVO.h"
#import "BankVO.h"
#import "BaseViewController.h"
@protocol PayMentDelegate;
@interface PaymentSheet : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray*mBankArray;
    UITableView *payTable;
    NSArray*mpaymethodImageArray;
    NSArray*mpaymethodTextArray;
    id<PayMentDelegate> delegate;

}
@property(nonatomic, assign) id<PayMentDelegate> delegate;
@property(nonatomic,retain)NSMutableArray*mBankArray;

@end
@protocol PayMentDelegate <NSObject>
@required
-(void)selectedPayment:(BankVO*)payMentMethodVO;

@end