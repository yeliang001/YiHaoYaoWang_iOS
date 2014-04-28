//
//  InvoiceViewController.m
//  yhd
//
//  Created by xuexiang on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InvoiceViewController.h"
#import "OTSServiceHelper.h"
#import "InvoiceVO.h"
#import <QuartzCore/QuartzCore.h>
#import "RegexKitLite.h"

@interface InvoiceViewController ()

@end

@implementation InvoiceViewController

@synthesize m_InvoiceTitle;
@synthesize m_InvoiceContent;
@synthesize m_InvoiceAmount;
@synthesize m_InvoiceType;
@synthesize m_PopOverController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isNeedInvoice = YES;
    toogleView.backgroundColor = [UIColor clearColor];
    toogleView.layer.borderColor = [UIColor colorWithRed:0.6039 green:0.6039 blue:0.6039 alpha:1.0].CGColor;
    toogleView.layer.borderWidth =1;
    toogleView.layer.cornerRadius = 7.0;
    toogleView.layer.masksToBounds = YES;
    
    titleView.backgroundColor = [UIColor clearColor];
    titleView.layer.borderColor = [UIColor colorWithRed:0.6039 green:0.6039 blue:0.6039 alpha:1.0].CGColor;
    titleView.layer.borderWidth =1;
    titleView.layer.cornerRadius = 7.0;
    titleView.layer.masksToBounds = YES;
    
    contentView.backgroundColor = [UIColor clearColor];
    contentView.layer.borderColor = [UIColor colorWithRed:0.6039 green:0.6039 blue:0.6039 alpha:1.0].CGColor;
    contentView.layer.borderWidth =1;
    contentView.layer.cornerRadius = 7.0;
    contentView.layer.masksToBounds = YES;
    
    // 界面初始化
    UIBarButtonItem* barCloseButton=[[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeModal:)];
    self.navigationItem.rightBarButtonItem=barCloseButton;
    [barCloseButton release];
    self.navigationItem.title = @"开具发票";
    
	checkMarkView =[[UIImageView alloc] initWithFrame:CGRectMake(420, 9, 22, 19)];  //选中的勾号
	[checkMarkView setImage:[UIImage imageNamed:@"filter_dui.png"]];
    
    if (m_InvoiceTitle == nil || [m_InvoiceTitle isEqualToString:@""]){
		titleStyle = [NSNumber numberWithInt:0];
        [personalBtn addSubview:checkMarkView];
	}else {
		titleStyle = [NSNumber numberWithInt:1];
        [companyBtn addSubview:checkMarkView];
        [companyTextField setHidden:NO];
	}
    
    if (m_InvoiceContent != nil) {                                                  // 内容不缓存本地，临时保存
		[contentLabel setText:m_InvoiceContent];
	}
    if ([m_InvoiceType intValue] == 2) {
        downArrowImage.hidden = YES;                                                // 商品只有3C商品时，隐藏发票内容的向下箭头。
        contentLabel.text = @"商品明细";
    }
    
    if (m_InvoiceTitle == nil || [m_InvoiceTitle isEqualToString:@""]){             // 设置抬头及抬头类型，默认抬头类型为个人
		titleStyle = [NSNumber numberWithInt:0];
        [companyTextField setText:@""];
	}else {
		titleStyle = [NSNumber numberWithInt:1];
        [companyTextField setText:m_InvoiceTitle];
	}
    
    [companyTextField setPlaceholder:@"请输入单位名称"];
    
    warnLabel = [[UILabel alloc] init];
	[warnLabel setTextColor:[UIColor redColor]];
	[warnLabel setFont:[UIFont systemFontOfSize:14]];
	[warnLabel setBackgroundColor:[UIColor clearColor]];
		
    // 发票内容数组初始化
    invoiceContentArray = [[NSArray alloc] initWithObjects:@"酒", @"饮料", @"食品", @"玩具", @"日用品", 
						   @"装修材料", @"化妆品", @"图书", @"办公用品", @"音像用品", @"学生用品", 
						   @"饰品", @"服装", @"箱包", @"精品", @"家电", @"劳防用品", nil];
    
}
- (void)saveInvoice{
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    [service saveInvoiceToSessionOrder:[GlobalValue getGlobalValueInstance].token invoiceTitle:m_InvoiceTitle invoiceContent:m_InvoiceContent invoiceAmount:m_InvoiceAmount];
}
#pragma mark -
#pragma mark User Actions
- (IBAction)closeBtn:(id)sender{
    if (!isNeedInvoice) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ClearInvoiceInfo" object:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseInvoice" object:nil];
}
- (IBAction)OKbtnClicked:(id)sender{
    BOOL isHaveSpecialWord = [companyTextField.text isMatchedByRegex:@"[~!@#$%^&*_+~！@#￥%……&*——+]"];
    
    if (![warnLabel.text isEqualToString:@""] && warnLabel.text != nil) { //若已经存在错误提示，什么都不做
	}else
        if (([companyTextField.text isEqualToString:@""] || [[companyTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0 || isHaveSpecialWord) && ([titleStyle intValue] == 1)) {
            if (isHaveSpecialWord) {
                [warnLabel setText:@"抬头格式错误，请修改"];
           //     addedRowCount++;
           //     [self viewMoveDown];
          //      textViewIsEditing = NO;
          //      [self updateTableView];
                [warnLabel setFrame:CGRectMake(28, 142, 150, 20)];
                [canHiddenView addSubview:warnLabel];
            }else {
                [warnLabel setText:@"请填写发票抬头"];
                [warnLabel setFrame:CGRectMake(28, 142, 150, 20)];
                [canHiddenView addSubview:warnLabel];
            }
        } else if (([contentLabel.text isEqualToString:@"发票内容"] || [m_InvoiceContent isEqualToString:@""])&& [m_InvoiceType intValue] != 2){
            if (![warnLabel.text isEqualToString:@"请选择发票内容"]) {
                [warnLabel setText:@"请选择发票内容"];
           //     addedRowCount++;
         //       [self viewMoveDown];
         //       [m_scrollView addSubview:warnLabel];
        //        textViewIsEditing = NO;
         //       [self updateTableView];
                [warnLabel setFrame:CGRectMake(28, 242, 150, 20)];
                [canHiddenView addSubview:warnLabel];
            }
        } else {
            [warnLabel setText:@""];
            if ([titleStyle intValue] == 0) {
                [companyTextField setText:@"个人"];
            }
            NSMutableArray* tempArray = [NSMutableArray arrayWithCapacity:4];
            InvoiceVO* tempVo = [[[InvoiceVO alloc] init] autorelease];
            if ([m_InvoiceType intValue] == 2) {
                [tempVo setContent:@"商品明细"];
            }else {
                [tempVo setContent:m_InvoiceContent];
            }
            [tempVo setTitle:companyTextField.text];
            [tempArray addObject:tempVo];
            [tempArray addObject:titleStyle];							//抬头的类型
            [tempArray addObject:[NSNumber numberWithInt:0]];			//标帜是从保存返回检查订单页面
            if (!isNeedInvoice) {
                [tempArray addObject:[NSNumber numberWithInt:1]];		//是否需要发票 0需要，1不需要
            }else {
                [tempArray addObject:[NSNumber numberWithInt:0]];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveInvoiceToOrder" object:tempArray];
            
            self.m_InvoiceTitle = companyTextField.text;
            //[self.navigationController dismissModalViewControllerAnimated:YES];
            [MobClick event:@"click_invoice"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseInvoice" object:nil];
            
        }
}
- (IBAction)hiddenContentView:(id)sender{
    UISwitch*  switchToogle = (UISwitch*)sender;
    if (switchToogle.on) {
        [canHiddenView setHidden:NO];
        isNeedInvoice = YES;
    }else {
        [canHiddenView setHidden:YES];
        isNeedInvoice = NO;
    }
}
- (IBAction)contentChoseBtn:(id)sender{
    if ([m_InvoiceType intValue] != 2) {
        invoiceContentViewController * contentViewController = [[invoiceContentViewController alloc]init];
        contentViewController.delegate = self;
        
        self.m_PopOverController = [[[WEPopoverController alloc] initWithContentViewController:contentViewController] autorelease];
        self.m_PopOverController.delegate = self;
        self.m_PopOverController.popoverContentSize=CGSizeMake(193.0, 234.0);
        if ([self.m_PopOverController respondsToSelector:@selector(setContainerViewProperties:)]) 
        {
            [self.m_PopOverController setContainerViewProperties:[self improvedContainerViewProperties]];
        }
        
        //}
        [self.m_PopOverController presentPopoverFromRect:CGRectMake(20,390, 500, 40) inView:self.view permittedArrowDirections:(UIPopoverArrowDirectionDown|UIPopoverArrowDirectionUp) animated:YES];
    }
}
- (IBAction)personalBtnClicked:(id)sender{
    titleStyle = [NSNumber numberWithInt:0];
    self.m_InvoiceTitle = @"个人";
    UIButton *tempBtn = (UIButton*)sender;
    [tempBtn addSubview:checkMarkView];
    [companyTextField setHidden:YES];
    [companyTextField resignFirstResponder];
    if ([warnLabel.text isEqualToString:@"请填写发票抬头"] || [warnLabel.text isEqualToString:@"抬头格式错误，请修改"]) {
        [warnLabel setText:@""];
    }
}
- (IBAction)companyBtnClicked:(id)sender{
    titleStyle = [NSNumber numberWithInt:1];
    self.m_InvoiceTitle = companyTextField.text;
    UIButton *tempBtn = (UIButton*)sender;
    [tempBtn addSubview:checkMarkView];
    [companyTextField setHidden:NO];
    [companyTextField becomeFirstResponder];
    if ([warnLabel.text isEqualToString:@"请填写发票抬头"] || [warnLabel.text isEqualToString:@"抬头格式错误，请修改"]) {
        [warnLabel setText:@""];
    }
}
-(void)closeModal:(id)sender{
    if (!isNeedInvoice) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ClearInvoiceInfo" object:nil];
    }
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark ContentView Delegate
-(void)contentChooseAtIndex:(int)index:(NSArray*)contentArray{
    if (m_InvoiceContent != nil) {
        [m_InvoiceContent release];
        m_InvoiceContent = nil;
    }
    self.m_InvoiceContent = [invoiceContentArray objectAtIndex:index];
    [contentLabel setText:m_InvoiceContent];
    [m_PopOverController dismissPopoverAnimated:YES];
    if ([warnLabel.text isEqualToString:@"请选择发票内容"]) {
		[warnLabel setText:@""];
    }
}
- (WEPopoverContainerViewProperties *)improvedContainerViewProperties {
	
	WEPopoverContainerViewProperties *props = [[WEPopoverContainerViewProperties alloc] autorelease];
	NSString *bgImageName = nil;
	CGFloat bgMargin = 0.0;
	CGFloat bgCapSize = 0.0;
	CGFloat contentMargin = 4.0;
	
    
	bgImageName = @"ProvinceInAddress@2x.png";
	
	// These constants are determined by the popoverBg.png image file and are image dependent
	bgMargin = 4; // margin width of 13 pixels on all sides popoverBg.png (62 pixels wide - 36 pixel background) / 2 == 26 / 2 == 13 
	bgCapSize = 0; // ImageSize/2  == 62 / 2 == 31 pixels
	
	props.leftBgMargin = bgMargin;
	props.rightBgMargin = bgMargin;
	props.topBgMargin =8;// bgMargin;
	props.bottomBgMargin = 12;
	props.leftBgCapSize = bgCapSize;
	props.topBgCapSize = bgCapSize;
	props.bgImageName = bgImageName;
	props.leftContentMargin = contentMargin;
	props.rightContentMargin =0;// contentMargin - 1; // Need to shift one pixel for border to look correct
	props.topContentMargin = 0;//contentMargin; 
	props.bottomContentMargin = -5;
	
	props.arrowMargin = 4.0;
	
	props.upArrowImageName = @"popoverArrowUp.png";
	props.downArrowImageName = @"popoverArrowDownGray.png";
	props.leftArrowImageName = @"popoverArrowLeft.png";
	props.rightArrowImageName = @"popoverArrowRight.png";
	return props;	
}
#pragma mark -
#pragma mark textField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    CGRect rect = CGRectMake(self.view.frame.origin.x, -1, width, height);
    self.view.frame = rect;
    [UIView commitAnimations];
}
-(BOOL)disablesAutomaticKeyboardDismissal{
    return NO;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (companyTextField.text != nil && ![companyTextField.text isEqualToString:@""]) {   //输入完毕，清空输入框的错误提示
        if ([warnLabel.text isEqualToString:@"请填写发票抬头"] || [warnLabel.text isEqualToString:@"抬头格式错误，请修改"]) {
            [warnLabel setText:@""];
        }
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(self.view.frame.origin.x, 80, self.view.frame.size.width,self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; 
	if (companyTextField == textField)  
    {
		if ([toBeString length] > 50) { 
            textField.text = [toBeString substringToIndex:50]; 
			UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:@"发票抬头不可超过50个字，请修改" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] autorelease]; 
			[alert show]; 
			return NO; 
        } 
	} 
	return YES;
}

#pragma mark -
#pragma mark popoverView Delegate
- (void)popoverControllerDidDismissPopover:(WEPopoverController *)thePopoverController {
	//Safe to release the popover here
	self.m_PopOverController = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
	//The popover is automatically dismissed if you click outside it, unless you return NO here
	return YES;
}

#pragma mark -
#pragma mark 内存释放
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc{
    if (m_InvoiceContent != nil) {
        [m_InvoiceContent release];
        m_InvoiceContent = nil;
    }
    if (m_InvoiceTitle != nil) {
        [m_InvoiceTitle release];
        m_InvoiceTitle = nil;
    }
    if (m_InvoiceAmount != nil) {
        [m_InvoiceAmount release];
        m_InvoiceAmount = nil;
    }
    if (m_InvoiceType != nil) {
        [m_InvoiceType release];
        m_InvoiceType = nil;
    }
    if (checkMarkView!= nil) {
        [checkMarkView release];
        checkMarkView = nil;
    }
    
    [super dealloc];
}

@end
