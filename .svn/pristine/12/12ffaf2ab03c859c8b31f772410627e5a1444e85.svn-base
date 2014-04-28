//
//  InvoiceViewController.h
//  yhd
//
//  Created by xuexiang on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEPopoverController.h"
#import "invoiceContentViewController.h"
#import "BaseViewController.h"

@interface InvoiceViewController : BaseViewController<UIActionSheetDelegate,WEPopoverControllerDelegate, UIPopoverControllerDelegate,invoiceContentChooseDelegate,UITextFieldDelegate>
{
    // 传入参数
    NSString * m_InvoiceContent;					// 发票内容
	NSString * m_InvoiceTitle;						// 发票抬头
	NSNumber * m_InvoiceAmount;						// 发票金额
	NSNumber * m_InvoiceType;						// 发票类型，1：普通，2：3c， 3：都有
    // outlet
    IBOutlet UIView * toogleView;                   // 开关的View
    IBOutlet UIView * canHiddenView;                // 可以隐藏View, 作为下面2个VIEW的容器
    IBOutlet UIView * contentView;                  // 内容View
    IBOutlet UIView * titleView;                    // 抬头View
    IBOutlet UILabel * contentLabel;                // 内容label
    IBOutlet UITextField * companyTextField;        // 单位输入框
    IBOutlet UIButton * personalBtn;                // 个人Btn
    IBOutlet UIButton * companyBtn;                 // 单位抬头Btn
    IBOutlet UIImageView * downArrowImage;          // 非3C商品时，发票内容可点击的按钮箭头
    
    UIImageView * checkMarkView;                    // 选中的勾的标识
    NSNumber* titleStyle;							// 抬头类型  0为个人，1为公司
    UILabel* warnLabel;								// 输入错误提示label
    BOOL isNeedInvoice;								// 是否需要发票
    
    WEPopoverController * m_PopOverController;      // 弹出窗控制器
    NSArray * invoiceContentArray;
}
@property (nonatomic, retain)NSString * m_InvoiceTitle;
@property (nonatomic, retain)NSNumber * m_InvoiceAmount;
@property (nonatomic, retain)NSString * m_InvoiceContent;
@property (nonatomic, retain)NSNumber * m_InvoiceType;
@property (nonatomic, retain)WEPopoverController * m_PopOverController;

- (IBAction)closeBtn:(id)sender;
- (IBAction)OKbtnClicked:(id)sender;
- (IBAction)hiddenContentView:(id)sender;
- (IBAction)contentChoseBtn:(id)sender;
- (IBAction)personalBtnClicked:(id)sender;
- (IBAction)companyBtnClicked:(id)sender;
@end
