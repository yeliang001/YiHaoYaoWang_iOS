//
//  PayInWebView.h
//  yhd
//
//  Created by dev dev on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
@interface PayInWebView :BaseView<UITableViewDelegate,UITableViewDataSource>
{
    NSArray* mpaymethodImageArray;
    NSArray* mpaymethodTextArray;
    NSArray* mBankArray;
    int  mselectedindex;
}
@property(nonatomic,retain)NSArray* mpaymethodImageArray;
@property(nonatomic,retain)NSArray* mpaymethodTextArray;
@property(nonatomic,retain)NSArray* mBankArray;

@property BOOL      hasSelectOnlinePay;     // 是否选择了银行

-(IBAction)CloseClicked:(id)sender;
@end
