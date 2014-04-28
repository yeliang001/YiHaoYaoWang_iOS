//
//  listDetailViewController.m
//  yhd
//
//  Created by dev dev on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "listDetailViewController.h"
#import "listsucceedViewController.h"
#import "PaymentMethodVO.h"
#import "OrderStatusHeaderVO.h"
#import "OrderV2.h"
#import "GoodReceiverVO.h"
#import <QuartzCore/QuartzCore.h>
#import "PayInWebView.h"
#import "OtherAddressView.h"
#import "OtherAddressViewCell.h"
#import "DataHandler.h"
#import "ProvinceVO.h"
#import "Page.h"
#import "BankVO.h"
#import "CartVO.h"
#import "CityVO.h"
#import "CountyVO.h"
#define knewview 101
#define kpayinwebview 102
#define knewaddressview 103
#define kotheraddressview 104
#define kinvoiceView 105
@interface listDetailViewController ()

@end

@implementation listDetailViewController
@synthesize mpaymentTypeLabels;
@synthesize mOrderNumber;
@synthesize mCurrentOrder;
@synthesize mreceiveListArray;
@synthesize mpaymethodinwebTexts;
@synthesize mpaymentTypeArray;
@synthesize mcity;
@synthesize mcounty;
@synthesize mprovince;
@synthesize motherAddressView;
@synthesize mPaymentIds;
#pragma mark - View
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
    // Do any additional setup after loading the view from its nib.
    UIImage * bgImag = [UIImage imageNamed:@"topbarback@2x.png"];
    UIColor * color = [[UIColor alloc]initWithPatternImage:bgImag];
    mtopbarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top_bg.png"]];
    [color release];
    self.navigationController.navigationBar.hidden = YES;
    self.mpaymentTypeLabels = [NSArray arrayWithObjects:mpaymentType0,mpaymentType1,mpaymentType2,mpaymentType3, nil];
    
    mreceiverinfoView.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    mreceiverinfoView.layer.borderWidth =1;
    
    msendmethodView.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    msendmethodView.layer.borderWidth =1;
    
    mpaymentmethodView.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    mpaymentmethodView.layer.borderWidth =1;
    
    mhighchooseView.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    mhighchooseView.layer.borderWidth =1;
    
    mthreeinonedayButton.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    mthreeinonedayButton.layer.borderWidth =1;
    
    mpaymentchooseButton1.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    mpaymentchooseButton1.layer.borderWidth =1;
    
    mpaymentchooseButton2.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    mpaymentchooseButton2.layer.borderWidth =1;
    
    mpaymentchooseButton3.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    mpaymentchooseButton3.layer.borderWidth =1;
    
    mpaymentchooseButton4.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    mpaymentchooseButton4.layer.borderWidth =1;
    
  //  musediscountButton.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0].CGColor;
  //  musediscountButton.layer.borderWidth =1;
    
  //  musecouponButton.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
  //  musecouponButton.layer.borderWidth =1;
    
  //  mneedfapiao.layer.borderColor = [UIColor colorWithRed:0.9725 green:0.2980 blue:0.2980 alpha:1.0].CGColor;
  //  mneedfapiao.layer.borderWidth =1;
    
    mneedfapiao.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    mneedfapiao.layer.borderWidth =1;
    
    mtotalinfoView.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    mtotalinfoView.layer.borderWidth =1;
    
    msendDayChooseButton.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    msendDayChooseButton.layer.borderWidth =1;
    
    self.mpaymethodinwebTexts = [NSArray arrayWithObjects:@"财付通",@"招商银行",@"支付宝",@"手机支付",@"银联支付",nil];
    
    mpaymentchooseIndicaterImageView.frame = CGRectMake(0, 0, 0, 0);
    //[self performSelector:@selector(getPaymentType) withObject:nil];
    
    [self performSelector:@selector(getReceiveList) withObject:nil];
    [self performSelector:@selector(getSessionOrder)withObject:nil];
    [self performSelector:@selector(getPaymentType) withObject:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popPayInWebView:) name:@"popPayInWebView" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popNewAddressView:) name:@"newaddresssucceed" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popNewAddressView:) name:@"editaddresssucceed" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popotheraddress:) name:@"popotheraddress" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushNewAddressViewFromOtherAddress) name:@"pushnewaddressfromotheraddress" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeNewAddressView:) name:@"popthnewaddressview" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushEditAddressViewFromOtherAddress:) name:@"EditAddressFromOtherAddress" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PopUpUIpickerview:) name:@"kPopUpUIpickerview" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PopSelf:) name:@"poptheDetailView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveInvoiceToOrder:) name:@"SaveInvoiceToOrder" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeInvoice:) name:@"CloseInvoice" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearInvoiceInfo:) name:@"ClearInvoiceInfo" object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    [mpaymentTypeLabels release];
    [mOrderNumber release];
    [mCurrentOrder release];
    [motherAddressView release];
    if (invoiceVC != nil) {
        [invoiceVC release];
    }
    if (editInvoiceVO != nil) {
        [editInvoiceVO release];
    }
    [super dealloc];
}
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//	return YES;
//}
#pragma mark - UserAction
-(IBAction)submitOrderClicked:(id)sender
{
    [MobClick event:@"submit_order"];
    if (mpaymentMethod!=0) {
        DataHandler * tempdatahandler = [DataHandler sharedDataHandler];
        [tempdatahandler.cart.buyItemList  removeAllObjects];
        [tempdatahandler.cart.gifItemtList removeAllObjects];
        tempdatahandler.cart.totalprice = [NSNumber numberWithInt:0];
        tempdatahandler.cart.totalquantity = [NSNumber numberWithInt:0];
        tempdatahandler.cart.totalsavedprice = [NSNumber numberWithInt:0];
        tempdatahandler.cart.totalWeight = [NSNumber numberWithInt:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartChange object:nil];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"krefreshafterlogin" object:nil];
        [self otsDetatchMemorySafeNewThreadSelector:@selector(saveaddress) toTarget:self withObject:nil];
    }
    else {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择一种支付方式" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
-(void)getPaymentType
{
    [self otsDetatchMemorySafeNewThreadSelector:@selector(PaymentType) toTarget:self withObject:nil];
}
-(void)getReceiveList
{
    [self otsDetatchMemorySafeNewThreadSelector:@selector(AddressList) toTarget:self withObject:nil];
}
-(void)getSessionOrder
{
    [self otsDetatchMemorySafeNewThreadSelector:@selector(SessionOrder) toTarget:self withObject:nil];
}
-(IBAction)useCouponClicked:(id)sender
{
}
-(IBAction)newaddressClicked:(id)sender
{
    if ([mreceiveListArray count]==10) 
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"注意" message:@"您的收货地址不能超过10个" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else 
    {
        [MobClick beginLogPageView:@"new_address"];
        UIView * newview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
        [self.view addSubview:newview];
        [newview setBackgroundColor:[UIColor grayColor]];
        [newview setAlpha:0.6];
        [newview setTag:knewview];
        
        NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"NewAddressView" owner:self options:nil];
        mnewAddressView = [nib objectAtIndex:0];
        [mnewAddressView setFrame:CGRectMake(240, 768, mnewAddressView.frame.size.width, mnewAddressView.frame.size.height)];
        [mnewAddressView setTag:knewaddressview];
        [mnewAddressView setIsnewAddress:YES];
        int i=0;
        for (i = 0; i<[mreceiveListArray count]; i++)
        {
            NSLog(@"data nid is %i",[dataHandler.province.nid intValue]);
            if ([((GoodReceiverVO*)[mreceiveListArray objectAtIndex:i]).provinceId intValue] == [dataHandler.province.nid intValue])
            {
                break;
            }
        }
        if (i == [mreceiveListArray count])
        {
            mnewAddressView.isShowingBack = YES;
        }
        //[mnewAddressView getprovince];
        [self.view addSubview:mnewAddressView];
        [self moveToLeftSide:mnewAddressView];
        [newview release];
    }
    
}
-(IBAction)editaddressClicked:(id)sender
{
    [MobClick beginLogPageView:@"edit_address"];
    UIView * newview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view addSubview:newview];
    [newview setBackgroundColor:[UIColor grayColor]];
    [newview setAlpha:0.6];
    [newview setTag:knewview];
    
    NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"NewAddressView" owner:self options:nil];
    mnewAddressView = [nib objectAtIndex:0];
    [mnewAddressView setFrame:CGRectMake(240, 768, mnewAddressView.frame.size.width, mnewAddressView.frame.size.height)];
    [mnewAddressView setTag:knewaddressview];
    [mnewAddressView setIsnewAddress:NO];
    [mnewAddressView setMnewgoodreceive:(GoodReceiverVO*)[mreceiveListArray objectAtIndex:mreceiveindex]];
    mProvinceId = mnewAddressView.mnewgoodreceive.provinceId;
    mCityId = mnewAddressView.mnewgoodreceive.cityId;
    mCountyId = mnewAddressView.mnewgoodreceive.countyId;
    [mnewAddressView showgoodreceive];
    [self.view addSubview:mnewAddressView];
    [self moveToLeftSide:mnewAddressView];
    [newview release];
}
-(IBAction)otheraddressClicked:(id)sender
{
    [MobClick beginLogPageView:@"select_address"];
    UIView * newview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view addSubview:newview];
    [newview setBackgroundColor:[UIColor grayColor]];
    [newview setAlpha:0.6];
    [newview setTag:knewview];
    
    NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"OtherAddressView" owner:self options:nil];
    self.motherAddressView = [nib objectAtIndex:0];
    [motherAddressView setFrame:CGRectMake(240, 768, motherAddressView.frame.size.width, motherAddressView.frame.size.height)];
    motherAddressView.tag = kotheraddressview;
    motherAddressView.mReceiveList = mreceiveListArray;
    BOOL isAddressavailable = NO;
    for (int i = 0; i<[mreceiveListArray count]; i++) {
        if ([((GoodReceiverVO*)[mreceiveListArray objectAtIndex:i]).provinceId longValue]== [dataHandler.province.nid longValue] ) {
            isAddressavailable = YES;
        }
    }
    motherAddressView.mIsAllAddressunavailable = !isAddressavailable;
    [self.view addSubview:motherAddressView];
    [self moveToLeftSide:motherAddressView];
    [newview release];
    
    

    
}
-(IBAction)savePaymentMethod:(id)sender
{
    NSLog(@"%i,%i",[mPaymentIds count],mpaymentMethod);
    [MobClick event:@"select_payment"];
    mpaymentMethod = ((UIButton*)sender).tag<=[mPaymentIds count]?((UIButton*)sender).tag:mpaymentMethod;
    NSLog(@"%i",mpaymentMethod);
    switch (mpaymentMethod) {
        case 1:
            mpaymentchooseIndicaterImageView.frame = CGRectMake(67, 15, 217, 35);
            break;
        case 2:
            mpaymentchooseIndicaterImageView.frame = CGRectMake(313, 15, 217, 35);
            break;
        case 3:
            mpaymentchooseIndicaterImageView.frame = CGRectMake(67, 65, 217, 35);
            break;
        case 4:
            mpaymentchooseIndicaterImageView.frame = CGRectMake(313, 65, 217, 35);
            break;
        default:
            break;
    }
    if(((UIButton*)sender).tag<=[mPaymentIds count])
    {
        if (mpaymentMethod!=1) 
        {
            //[self otsDetatchMemorySafeNewThreadSelector:@selector(SavePaymentMethod) toTarget:self withObject:nil];
            mpaymentMethod =((UIButton*)sender).tag;
        }
        else 
        {
            [self otsDetatchMemorySafeNewThreadSelector:@selector(GetGateWay) toTarget:self withObject:nil];
//            UIView * newview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
//            [self.view addSubview:newview];
//            [newview setBackgroundColor:[UIColor grayColor]];
//            [newview setAlpha:0.5];
//            [newview setTag:knewview];
//        
//             NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"PayInWebView" owner:self options:nil];
//            PayInWebView *  temppayView = [nib objectAtIndex:0];
//            temppayView.tag = kpayinwebview;
//            [self.view addSubview:temppayView];
//            [temppayView setFrame:CGRectMake(240, 768, 545, 533)];
//            [self moveToLeftSide:temppayView];
//        
//            [newview release];
        }
    }
}
//显示提示框
-(void)showAlertView:(NSString *) alertTitle alertMsg:(NSString *)alertMsg alertTag:(int)tag {
    UIAlertView *alert;
    if (tag==1) {
        alert=[[UIAlertView alloc]initWithTitle:alertTitle message:alertMsg delegate:self cancelButtonTitle:@"查看订单" otherButtonTitles:@"去晒单", nil];
    } else {
        alert=[[UIAlertView alloc]initWithTitle:alertTitle message:alertMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
    }
    alert.tag=tag;
	[alert show];
	[alert release];
}
-(IBAction)invoiceBtnClicked:(id)sender{
   if ([mCurrentOrder goodReceiver]==nil) {
        [self showAlertView:nil alertMsg:@"您目前没有选择送货地址,请先选择您的送货地址!" alertTag:4];
    } else if ([mCurrentOrder.paymentMethodForString isEqualToString:@"此地址不支持货到付款"]) {
        [self showAlertView:nil alertMsg:@"您目前的送货地址不正确,请先确认您的送货地址!" alertTag:2];
    } else if ([mCurrentOrder.productAmount doubleValue] == 0) {
		[self showAlertView:nil alertMsg:@"商品金额为0，无法开具发票" alertTag:3];
	} else {
        if (invoiceVC != nil) {
            [invoiceVC release];
            invoiceVC = nil;
        }
        invoiceVC = [[InvoiceViewController alloc] init];
        
        if ( editInvoiceVO == nil ) {
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* directory = [paths objectAtIndex:0];
            NSString* fileName = [directory stringByAppendingPathComponent:@"InvoiceTitle.plist"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
                NSString* tempstr = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
                if (![tempstr isEqualToString:@"个人"]) {
                    [invoiceVC setM_InvoiceTitle:tempstr];
                    DebugLog(@"title is:%@ ",tempstr);
                }
            }
        }else {
            if (![editInvoiceVO.title isEqualToString:@"个人"]) {	
                [invoiceVC setM_InvoiceTitle:editInvoiceVO.title];
            }
            [invoiceVC setM_InvoiceContent:editInvoiceVO.content];
            [invoiceVC setM_InvoiceAmount:mCurrentOrder.productAmount];
        }
        
        [invoiceVC setM_InvoiceType:mCurrentOrder.canIssuedInvoiceType];
        
        if(mCurrentOrder.invoiceList!=nil && [mCurrentOrder.invoiceList count]>0){
            editInvoiceVO = [mCurrentOrder.invoiceList objectAtIndex:0];
            if (![editInvoiceVO.title isEqualToString:@"个人"]) {
                [invoiceVC setM_InvoiceTitle:editInvoiceVO.title];
            }
            [invoiceVC setM_InvoiceContent:editInvoiceVO.content];
            [invoiceVC setM_InvoiceAmount:editInvoiceVO.amount];
        }
        
        [invoiceVC.view setFrame:CGRectMake(240, 768, invoiceVC.view.frame.size.width, invoiceVC.view.frame.size.height)];
        [invoiceVC.view setTag:kinvoiceView];
      /*  UINavigationController*nav=[[UINavigationController alloc] initWithRootViewController:invoiceVC];
        nav.modalPresentationStyle=UIModalPresentationFormSheet;
        nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        
        [self.navigationController presentModalViewController:nav animated:YES];
        nav.view.superview.frame = CGRectMake(0, 0, 522 , 501);
        nav.view.superview.center = self.view.center;
        [nav release];*/
        UIView * newview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
        [self.view addSubview:newview];
        [newview setBackgroundColor:[UIColor grayColor]];
        [newview setAlpha:0.6];
        [newview setTag:knewview];
        
        [self.view addSubview:invoiceVC.view];
        [self moveToLeftSide:invoiceVC.view];
        [newview release];
        }
    
}
- (void)moveToLeftSide:(UIView *)view{
    [UIView animateWithDuration:0.5 animations:^{
        view.frame = CGRectMake(240, 80, 545, 533);
    }
                     completion:^(BOOL finished)
     {
         
     }];
}
-(void)submitOrderAfterUpdateAddress
{
    [self otsDetatchMemorySafeNewThreadSelector:@selector(SubmitOrder) toTarget:self withObject:nil];
}
-(IBAction)backClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)threeinOnedayClicked:(id)sender
{
    msentmethodIndicaterImageView.frame = CGRectMake(65, 65, 349, 35);
}
-(IBAction)senddayClicked:(id)sender
{
    msentmethodIndicaterImageView.frame = CGRectMake(65, 15, 349, 35);
}
#pragma mark - SDKthread function
-(void)SubmitOrder
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    int ordernumber = [service submitOrderEx:[OTSRuntimeData sharedInstance].token];
    NSLog(@"%i",ordernumber);
    NSNumber * result = [NSNumber numberWithInt:ordernumber];
    [self performSelectorOnMainThread:@selector(handleSubmitOrder:) withObject:result waitUntilDone:YES];
   
    [pool drain];
}
- (void)saveInvoice{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    [service saveInvoiceToSessionOrder:[OTSRuntimeData sharedInstance].token invoiceTitle:invoiceVC.m_InvoiceTitle invoiceContent:invoiceVC.m_InvoiceContent invoiceAmount:invoiceVC.m_InvoiceAmount];
    
    [self performSelectorOnMainThread:@selector(submitOrderAfterUpdateAddress) withObject:nil waitUntilDone:YES];
    
    [pool drain];
}
-(void)delAll
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    int result = [service delAllProduct:[OTSRuntimeData sharedInstance].token];
    NSLog(@"delAllProduct, result:%d", result);
    [pool drain];
}
-(void)saveaddress
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    NSLog(@"%@",((GoodReceiverVO*)[mreceiveListArray objectAtIndex:mreceiveindex]).nid);
    int result = [service saveGoodReceiverToSessionOrder:[OTSRuntimeData sharedInstance].token goodReceiverId:((GoodReceiverVO*)[mreceiveListArray objectAtIndex:mreceiveindex]).nid];
    NSLog(@"result is %i,%@",result,((GoodReceiverVO*)[mreceiveListArray objectAtIndex:mreceiveindex]).provinceName);
    if (result==1) {
        [self otsDetatchMemorySafeNewThreadSelector:@selector(SavePaymentMethod) toTarget:self withObject:nil];
        //[self performSelectorOnMainThread:@selector(submitOrderAfterUpdateAddress) withObject:nil waitUntilDone:YES];
    }
    [pool drain];
}
-(void)SessionOrder
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    self.mCurrentOrder = [service getSessionOrder:[OTSRuntimeData sharedInstance].token];
    mtotalCountLabel.text = [NSString stringWithFormat:@"%@件",mCurrentOrder.productCount];
    mtotalWeightLabel.text = [NSString stringWithFormat:@"%.2fkg",[mCurrentOrder.orderTotalWeight doubleValue]];
    mproductAmount.text = [NSString stringWithFormat:@"¥ %.2f",[mCurrentOrder.productAmount doubleValue]];
    mproductAmount.textColor = kRedColor;
    mdeliveryAmountLabel.text = [NSString stringWithFormat:@"¥ %@",mCurrentOrder.deliveryAmount];
    mdeliveryAmountLabel.textColor = kRedColor;
    mcouponAmountLabel.text = [NSString stringWithFormat:@"¥ %@",mCurrentOrder.couponAmount];
    mpaymentAccountLabel.text = [NSString stringWithFormat:@"¥ %.2f",[mCurrentOrder.paymentAccount doubleValue]];
    mpaymentAccountLabel.textColor = kRedColor;
    NSString * date = [mCurrentOrder.expectReceiveDateTo substringWithRange:NSMakeRange(5, 5)];
    NSString * month = [date substringWithRange:NSMakeRange(0, 2)];
    if ([[month substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"0"]) {
        month = [month substringWithRange:NSMakeRange(1, 1)];
    }
    NSString * day = [date substringWithRange:NSMakeRange(3, 2)];
    mDeliverLabel.text = [NSString stringWithFormat:@"普通快递 %.0f元     预计%@月%@日送达",[mCurrentOrder.deliveryAmount doubleValue],month,day];
    [pool drain];
}
-(void)handleSubmitOrder:(NSNumber*)result
{
    int resultcode = [result intValue];
    if (resultcode >0) 
    {
        listsucceedViewController * temp = [[listsucceedViewController alloc]init];
        self.mOrderNumber = result;
        [temp setOrdernumber:result];
        NSLog(@"%@",mCurrentOrder.paymentAccount);
        [temp setMtotalprice:[mCurrentOrder.paymentAccount doubleValue]];
        NSLog(@"mgatewayid is %@",mGateWayId);
        if (!mGateWayId) {
            temp.mpayViewIsHidden = YES;
        }
        else {
            temp.mpayViewIsHidden = NO;
        }
        temp.mGateWayId = mGateWayId;
        [self.navigationController pushViewController:temp animated:YES];
        [temp release];
    }
    else
    {
        NSString * errormessage = @"未知错误";
        switch (resultcode) 
        {
            case -1:
                errormessage = @"用户没有登录";
                break;
            case -2:
                errormessage = @"订单限制";
                break;
            case -3:
                errormessage = @"抵用券错误";
                break;
            case -4:
                errormessage =@"产品售完";
                break;
            case -5:
                errormessage =@"库存错误";
                break;
            case -6:
                errormessage =@"订单验证错误";
                break;
            case -7:
                errormessage =@"dsp错误";
                break;
            case -8:
                errormessage =@"秒杀产品错误";
                break;
            case -9:
                errormessage =@"每日一销产品错误";
                break;
            case -10:
                errormessage =@"到达每日下单上限";
                break;
            case -11:
                errormessage =@"礼品错误";
                break;
            case -12:
                errormessage =@"账户金额不足";
                break;
            case -19:
                errormessage =@"订单不存在";
                break;
            default:
                break;
        }
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提交失败" message:errormessage delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [self otsDetatchMemorySafeNewThreadSelector:@selector(delAll) toTarget:self withObject:nil];
}
-(void)PaymentType
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    self.mpaymentTypeArray = [service getPaymentMethodsForSessionOrder:[OTSRuntimeData sharedInstance].token];
    self.mPaymentIds = [NSMutableArray arrayWithCapacity:1];
    int k = 0;
    for (int i=0; i<[mpaymentTypeArray count]; i++) 
    {
        NSLog(@"%@,%@",((PaymentMethodVO*)[mpaymentTypeArray objectAtIndex:i]).methodName,((PaymentMethodVO*)[mpaymentTypeArray objectAtIndex:i]).isDefaultPaymentMethod);
//        if ([((PaymentMethodVO*)[mpaymentTypeArray objectAtIndex:i]).isDefaultPaymentMethod isEqualToString:@"false"])
//        {
        if (!((PaymentMethodVO*)[mpaymentTypeArray objectAtIndex:i]).gatewayId)
        {
            ((UILabel*)[mpaymentTypeLabels objectAtIndex:k++]).text = ((PaymentMethodVO*)[mpaymentTypeArray objectAtIndex:i]).methodName;
            [mPaymentIds addObject:((PaymentMethodVO*)[mpaymentTypeArray objectAtIndex:i]).methodId];  
        }
        if ([((PaymentMethodVO*)[mpaymentTypeArray objectAtIndex:i]).isDefaultPaymentMethod isEqualToString:@"true"]&&!((PaymentMethodVO*)[mpaymentTypeArray objectAtIndex:i]).gatewayId)
        {
            switch (i+1) {
                case 1:
                    mpaymentchooseIndicaterImageView.frame = CGRectMake(67, 15, 217, 35);
                    break;
                case 2:
                    mpaymentchooseIndicaterImageView.frame = CGRectMake(313, 15, 217, 35);
                    break;
                case 3:
                    mpaymentchooseIndicaterImageView.frame = CGRectMake(67, 65, 217, 35);
                    break;
                case 4:
                    mpaymentchooseIndicaterImageView.frame = CGRectMake(313, 65, 217, 35);
                    break;
                default:
                    break;
            }
            mpaymentMethod = i+1;
        }
        NSLog(@"%@,%@",((PaymentMethodVO*)[mpaymentTypeArray objectAtIndex:i]).methodName,((PaymentMethodVO*)[mpaymentTypeArray objectAtIndex:i]).methodId);
    }
    [pool drain];
}
-(void)AddressList
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    self.mreceiveListArray =[NSMutableArray arrayWithArray:[service getGoodReceiverListByToken:[OTSRuntimeData sharedInstance].token]];
    int i=0;
    for (i = 0; i<[mreceiveListArray count]; i++)
    {
        NSLog(@"data nid is %i",[dataHandler.province.nid intValue]);
        if ([((GoodReceiverVO*)[mreceiveListArray objectAtIndex:i]).provinceId intValue] == [dataHandler.province.nid intValue])
        {
            break;
        }
    }
    if (i==[mreceiveListArray count])
    {
        [self performSelectorOnMainThread:@selector(newaddressClicked:) withObject:nil waitUntilDone:YES];
    }
    else
    {
        //[self ShowAddress:(GoodReceiverVO*)[mreceiveListArray objectAtIndex:i]];
        mreceiveindex = i;
        [self performSelectorOnMainThread:@selector(ShowAddress:) withObject:(GoodReceiverVO*)[mreceiveListArray objectAtIndex:i] waitUntilDone:YES];
    }
    [pool drain];
}
-(void)ShowAddress:(GoodReceiverVO*)goodreceiver
{
    [self performSelector:@selector(getSessionOrder) withObject:nil];
    [self performSelector:@selector(getPaymentType) withObject:nil afterDelay:1];
    mreceivenameLabel.text = goodreceiver.receiveName;
    
    if (goodreceiver.receiverMobile) {
        mpostCodeLabel.text = goodreceiver.receiverMobile;
    }
    else {
        mpostCodeLabel.text = goodreceiver.receiverPhone;
    }
    
    
    maddressLabel.text = [NSString stringWithFormat:@"%@  %@  %@  %@",goodreceiver.provinceName,goodreceiver.cityName,goodreceiver.countyName,goodreceiver.address1];
}
-(void)SavePaymentMethod
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    NSLog(@"mpaymentmethod is %i",mpaymentMethod);
//     int result = [service savePaymentToSessionOrder:[OTSRuntimeData sharedInstance].token methodid:((PaymentMethodVO*)[mpaymentTypeArray objectAtIndex:mpaymentMethod-1]).methodId  gatewayid:mGateWayId];//if mpaymentMethod is 2 gatewayid need to get through getbankvolist;ordervo has no gateway
    int result = [service savePaymentToSessionOrder:[OTSRuntimeData sharedInstance].token methodid:((NSNumber*)[mPaymentIds objectAtIndex:mpaymentMethod-1]) gatewayid:mGateWayId];
    
    if (result == 1) {
        //[self performSelectorOnMainThread:@selector(submitOrderAfterUpdateAddress) withObject:nil waitUntilDone:YES];
        [self otsDetatchMemorySafeNewThreadSelector:@selector(saveInvoice) toTarget:self withObject:nil];
    }
    [pool drain];
}
-(void)GetGateWay
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    Page * temppage = [service getBankVOList:[self getClientInfo].trader name:@"" type:[NSNumber numberWithInt:-1] currentPage:[NSNumber numberWithInt:1] pageSize:[NSNumber numberWithInt:20]];
    NSLog(@"PAGE %@",[temppage objList]);
    mGateWayId = ((BankVO*)[[temppage objList] objectAtIndex:0]).gateway;
    for (int i = 0 ; i<[[temppage objList] count]; i++)
    {
        NSLog(@"%@",((BankVO*)[[temppage objList] objectAtIndex:i]).bankname);
    }
    NSLog(@"%@",mGateWayId);
    mBankList = [temppage objList];
    [self performSelectorOnMainThread:@selector(popuppayinwebview) withObject:nil waitUntilDone:YES];
    [pool drain];
}
-(void)popuppayinwebview
{
    UIView * newview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view addSubview:newview];
    [newview setBackgroundColor:[UIColor grayColor]];
    [newview setAlpha:0.6];
    [newview setTag:knewview];
    
    NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"PayInWebView" owner:self options:nil];
    PayInWebView *  temppayView = [nib objectAtIndex:0];
    temppayView.mBankArray = mBankList;
    temppayView.tag = kpayinwebview;
    [self.view addSubview:temppayView];
    [temppayView setFrame:CGRectMake(240, 768, 545, 533)];
    [self moveToLeftSide:temppayView];
    
    [newview release];
}
#pragma mark - Notification
-(void)popPayInWebView:(NSNotification*)notification
{
    mpaymethodinwebindex = [notification.object intValue];
    mpaymentType0.text = ((BankVO*)[mBankList objectAtIndex:mpaymethodinwebindex]).bankname;
    mGateWayId = ((BankVO*)[mBankList objectAtIndex:mpaymethodinwebindex]).gateway;
    //mpaymentType0.text = [mpaymethodinwebTexts objectAtIndex:mpaymethodinwebindex];
    [self moveToRightSide:[self.view viewWithTag:kpayinwebview]];
    
}
-(void)popNewAddressView:(NSNotification*)notification
{
    if (!((NewAddressView*)[self.view viewWithTag:knewaddressview]).isnewAddress) {
        [MobClick endLogPageView:@"edit_address"];
    }
    else {
        [MobClick endLogPageView:@"new_address"];
    }
    [self PushDownUIPickerView];
    [self moveToRightSide:[self.view viewWithTag:knewaddressview]];
    [self getReceiveList];
}
-(void)popotheraddress:(NSNotification*)notification
{
    if (notification.object) 
    {
        mreceiveindex = [notification.object intValue];
        [self moveToRightSide:[self.view viewWithTag:kotheraddressview]];
        [self ShowAddress:(GoodReceiverVO*)[mreceiveListArray objectAtIndex:[notification.object intValue]]];
    }
    else
    {
        [self moveToRightSide:[self.view viewWithTag:kotheraddressview]];
    }
    [MobClick endLogPageView:@"select_address"];
}
-(void)PopSelf:(NSNotification*)notification
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)closeNewAddressView:(NSNotification*)notification
{
    if (!((NewAddressView*)[self.view viewWithTag:knewaddressview]).isnewAddress) {
        [MobClick endLogPageView:@"edit_address"];
    }
    else {
        [MobClick endLogPageView:@"new_address"];
    }
    [self PushDownUIPickerView];
    [self moveToRightSide:[self.view viewWithTag:knewaddressview]];
}
-(void)closeInvoice:(NSNotification*)notification{
    [self moveToRightSide:[self.view viewWithTag:kinvoiceView]];
}
//清楚发票信息
-(void)clearInvoiceInfo:(NSNotification *)notification{
    [m_InvoiceLabel setText:@"使用发票"];
    UIImageView *imageView = (UIImageView*)[mhighchooseView viewWithTag:1001];
    if (imageView) {
        [imageView removeFromSuperview];
        imageView = nil;
    }
}
//保存发票信息到订单
-(void)saveInvoiceToOrder:(NSNotification *)notification
{
	NSArray* tempArray = (NSArray*)[notification object];
	if (editInvoiceVO != nil) {
		[editInvoiceVO release];
	}
	editInvoiceVO = [[tempArray objectAtIndex:0] retain];
	//titleStyle = [tempArray objectAtIndex:1];						//抬头类型 个人为0，公司为1
	
	NSNumber* isHadSave = [tempArray objectAtIndex:2];				//标帜从“返回”返回，还是从“保存”返回 0为保存，1为返回
	if (isHadSave == [NSNumber numberWithInt:0]) {
		[m_InvoiceLabel setText:editInvoiceVO.title];
        UIImageView *imageView = (UIImageView*)[mhighchooseView viewWithTag:1001];
        if (imageView == nil) {
            UIImageView *imv = [[UIImageView alloc] initWithFrame:mneedfapiao.frame];
            [imv setImage:[[UIImage imageNamed:@"paymentmethodchoose.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
            [imv setTag:1001];
            [mhighchooseView addSubview:imv];
            [imv release];
        }
        
		[invoiceVC setM_InvoiceTitle:editInvoiceVO.title];
		[invoiceVC setM_InvoiceContent:editInvoiceVO.content];
		[invoiceVC setM_InvoiceAmount:mCurrentOrder.productAmount];
		//isNeedInvoice = YES;
		//将抬头保存到本地
		NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString* directory = [paths objectAtIndex:0];
		NSString* fileName = [directory stringByAppendingPathComponent:@"InvoiceTitle.plist"];
		[editInvoiceVO.title writeToFile:fileName atomically:NO encoding:NSUTF8StringEncoding error:nil];
	}else {
		NSNumber* isNeed = [tempArray objectAtIndex:3];
		if ([isNeed intValue] == 1) {						//不需要需要发票
			[m_InvoiceLabel setText:@"使用发票"];
			//isNeedInvoice = NO;
		}
	}
}
-(void)pushNewAddressViewFromOtherAddress
{
    [self moveToRightSide:[self.view viewWithTag:kotheraddressview]];
    [self performSelector:@selector(newaddressClicked:)withObject:self];
}
-(void)pushEditAddressViewFromOtherAddress:(NSNotification*)notification
{
    UIView * newview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view addSubview:newview];
    [newview setBackgroundColor:[UIColor grayColor]];
    [newview setAlpha:0.6];
    [newview setTag:knewview];
    
    NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"NewAddressView" owner:self options:nil];
    mnewAddressView = [nib objectAtIndex:0];
    [mnewAddressView setFrame:CGRectMake(240, 768, mnewAddressView.frame.size.width, mnewAddressView.frame.size.height)];
    [mnewAddressView setTag:knewaddressview];
    [mnewAddressView setIsnewAddress:NO];
    
    [mnewAddressView setMnewgoodreceive:(GoodReceiverVO*)(notification.object)];
    mProvinceId = mnewAddressView.mnewgoodreceive.provinceId;
    mCityId = mnewAddressView.mnewgoodreceive.cityId;
    mCountyId = mnewAddressView.mnewgoodreceive.countyId;
    [mnewAddressView showgoodreceive];
    [self.view addSubview:mnewAddressView];
    [self moveToLeftSide:mnewAddressView];
    [self moveToRightSide:[self.view viewWithTag:kotheraddressview]];
    [newview release];

}
- (void)moveToRightSide:(UIView *)view{
    [UIView animateWithDuration:0.5 animations:^{
        view.frame = CGRectMake(240, 768, 545, 533);
    }
                     completion:^(BOOL finished)
     {
         [[self.view viewWithTag:knewview] removeFromSuperview];
         [view removeFromSuperview];
     }];
    
}
-(void)PopUpUIpickerview:(NSNotification*)notification
{
    mCurrentTypeForUIPickerView = [notification.object intValue];
    [self.view bringSubviewToFront:mAddressChoosePickerView];
    [UIView animateWithDuration:0.5 animations:^{
        mAddressChoosePickerView.frame = CGRectMake(0,552, 1024, 216);
    }
     completion:^(BOOL finished)
     {
         
     }];
    switch (mCurrentTypeForUIPickerView) 
    {
        case 1:
        {
                [self getprovince];
        }
            break;
        case 2:
        {
            if (mProvinceId) {
                [self getcity:mProvinceId];
            }
            else {
                [self getcity: ((ProvinceVO*)[mprovince objectAtIndex:mproviceselectedindex]).nid];
            }
            
        }
            break;
        case 3:
        {
            if (mCityId) {
                [self getcounty:mCityId];
            }
            else {
                [self getcounty:((CityVO*)[mcity objectAtIndex:mcityselectedindex]).nid];
            }
            
        }
            break;
        default:
            break;
    }
}
-(void)PushDownUIPickerView
{
    [UIView animateWithDuration:0.5 animations:^{
        mAddressChoosePickerView.frame = CGRectMake(0, 768, 1024, 216);
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int temp;
    temp = 0;
    switch (mCurrentTypeForUIPickerView)
    {
        case 1:
            temp = [mprovince count];
            break;
        case 2:
            temp = [mcity count];
            break;
        case 3:
            temp = [mcounty count];
            break;            
        default:
            break;
    }
    return temp;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (mCurrentTypeForUIPickerView) {
        case 1:
        {
            return ((ProvinceVO*)[mprovince objectAtIndex:row]).provinceName;
        }
            break;
        case 2:
        {
            return ((CityVO*)[mcity objectAtIndex:row]).cityName;
        }
            break;
        case 3:
        {
            return ((CountyVO*)[mcounty objectAtIndex:row]).countyName;
        }
        default:
            break;
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (mCurrentTypeForUIPickerView) {
        case 1:
        {
            [self PushDownUIPickerView];
            NSDictionary * user = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:row],@"row",mprovince,@"provinces",nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"kProvinceSelected" object:((ProvinceVO*)[mprovince objectAtIndex:row]).provinceName userInfo:user];
            NSLog(@"%@",((ProvinceVO*)[mprovince objectAtIndex:row]).nid);
            mproviceselectedindex = row;
            mProvinceId = nil;
            [self getcity:((ProvinceVO*)[mprovince objectAtIndex:row]).nid];
        }
            break;
        case 2:
        {
            [self PushDownUIPickerView];
            NSDictionary * user = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:row],@"row",mcity,@"citys",nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"kCitySelected" object:((CityVO*)[mcity objectAtIndex:row]).cityName userInfo:user];
            mcityselectedindex = row;
            mCityId = nil;
            [self getcounty:((CityVO*)[mcity objectAtIndex:row]).nid];
        }
            break;
        case 3:
        {
            [self PushDownUIPickerView];
            NSDictionary * user = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:row],@"row",mcounty,@"countys",nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"kCountySelected" object:((CountyVO*)[mcounty objectAtIndex:row]).countyName userInfo:user];
            mcountyselectedindex = row;
            mCountyId = nil;
        }
        default:
            break;
    }
}
#pragma mark - Address service
-(void)getprovince
{
    [self otsDetatchMemorySafeNewThreadSelector:@selector(getprovincefromserver) toTarget:self withObject:nil];
}
-(void)getprovincefromserver
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    
    self.mprovince = [service getAllProvince:[self getClientInfo].trader];
    [mAddressChoosePickerView reloadComponent:0];
    [pool drain];
}
-(void)getcity:(NSNumber*)provinceid
{
    [self otsDetatchMemorySafeNewThreadSelector:@selector(getcityfromserver:) toTarget:self withObject:provinceid];
}
-(void)getcityfromserver:(NSNumber*)provinceid
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    NSLog(@"%@",provinceid);
    self.mcity = [service getCityByProvinceId:[self getClientInfo].trader provinceId:provinceid];
    [mAddressChoosePickerView reloadComponent:0];
    [pool drain];
}
-(void)getcounty:(NSNumber *)cityid
{
    [self otsDetatchMemorySafeNewThreadSelector:@selector(getcountyfromserver:) toTarget:self withObject:cityid];
}
-(void)getcountyfromserver:(NSNumber*)cityid
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    
    self.mcounty = [service getCountyByCityId:[self getClientInfo].trader cityId:cityid];
    [mAddressChoosePickerView reloadComponent:0];
    [pool drain];
}
@end
