//
//  Invoice.h
//  TheStoreApp
//
//  Created by yangxd on 11-08-24.
//  Copyright 2011 vsc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InvoiceVO;

@interface Invoice : OTSBaseViewController<UIScrollViewDelegate, UITextViewDelegate, UIActionSheetDelegate,UIPickerViewDelegate,UITableViewDelegate,UITableViewDataSource> {
	UIButton * invoiceSpinner;						// 发票内容下拉按钮
	NSArray * invoiceContentArray;					// 所有发票内容
	UITextField * invoiceTitleField;				// 发票抬头输入框
	UITextField * invoiceAmountField;				// 发票金额输入框
	IBOutlet UIPickerView * invoiceSelectPicker;//	// 发票内容滚轴
	UIActionSheet * invoiceSelectActionview;		// 发票滚轴
	UITextView* invoiceTitleTextView;				// 抬头输入view
	UIView* textBgView;								// 加载text的view
	
	NSString * m_InvoiceContent;					// 发票内容
	NSString * m_InvoiceTitle;						// 发票抬头
	NSNumber * m_InvoiceAmount;						// 发票金额
	NSNumber * m_InvoiceType;						// 发票类型，1：普通，2：3c， 3：都有
	BOOL textViewIsEditing;							// 是否正在编辑
	
	UITableView* contentTableView;					// 主tableview
	UIScrollView* m_scrollView;						// 底层scrollview
	UIButton* titleDoneBtn;							// 标题栏完成按钮
	UIButton* doneBtn;								// 下方的完成按钮
	UILabel* warnLabel;								// 输入错误提示label
	BOOL isNeedInvoice;								// 是否需要发票
	CGRect keyboardBounds;							// 键盘尺寸
	CGRect applicationFrame;						// 程序屏幕尺寸
//	CGSize scrollViewOriginalSize;					// scrollview原始尺寸
	NSNumber* titleStyle;							// 抬头类型  0为个人，1为公司
	UIImageView *CheckMarkView;						// 选中勾号
	UIView* separateLine;							// 分割线
	BOOL isHaveMoreRow;								// 是否为多行
	int addedRowCount;								// 界面动态变化多增加的行数
	UIButton* clearTextBtn;							// 清空文字
	
	UILabel * invoiceLbl2;							//说明文字
    int invoiceContentRow;
    NSInteger frontSelectedItemPicker;
    
	int currentState;								// 当前线程状态
	BOOL running;
    
}
@property (nonatomic, retain)NSString * m_InvoiceTitle;
@property (nonatomic, retain)NSNumber * m_InvoiceAmount;
@property (nonatomic, retain)NSString * m_InvoiceContent;
@property (nonatomic, retain)NSNumber * m_InvoiceType;

@property (assign, nonatomic)BOOL isMedicalInstrument;// 是不是医疗器械

-(IBAction)switchValueChange:(id)sender;
-(void)clearText;
#pragma mark 初始化发票开具界面
-(void)initInvoiceView;
#pragma mark 返回到检查订单页面
-(void)backCheckOrderView;

#pragma mark 页面下移
-(void)viewMoveDown;

#pragma mark 点击发票内容按钮显示的模态窗口
-(void)setInvoiceSpinnerView;
#pragma mark 在模态窗口点击确定后触发的事件
-(void)clickFinishSettingInvoiceSpinner;
#pragma mark 取消发票内容按钮显示的模态窗口
-(void)cancelSettingInvoiceSpinner;

@end
