//
//  listDetailViewController.m
//  yhd
//
//  Created by dev dev on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OtspOrderConfirmVC.h"
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
#import "OTSGpsHelper.h"
#import "OTSUtility.h"
#import "CouponViewController.h"
#import "CouponVO.h"
#import "CouponProvingViewController.h"


#define knewview 101
#define kpayinwebview 102
#define knewaddressview 103
#define kotheraddressview 104
#define kinvoiceView 105
#define kcouponView 106
#define kcouponProvingView 107

@interface OtspOrderConfirmVC ()
{
    dispatch_queue_t    _myQueue;
}
@property(nonatomic, retain)CouponViewController* couponVC;
@property(nonatomic, retain)CouponProvingViewController* couponProvingVC;
@property (retain) InvoiceVO * editInvoiceVO;
@end

@implementation OtspOrderConfirmVC
@synthesize mpaymentTypeLabels;
@synthesize mOrderNumber;
@synthesize currentOrder = _currentOrder;
@synthesize mreceiveListArray;
@synthesize mpaymethodinwebTexts;
@synthesize mpaymentTypeArray;
@synthesize mcity;
@synthesize mcounty;
@synthesize mprovince;
@synthesize motherAddressView;
@synthesize mPaymentIds;
@synthesize couponVC,couponProvingVC;
@synthesize editInvoiceVO = _editInvoiceVO;

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
    
//    [MobClick event:@"cart_checkout"];
//    JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_CheckOrder extraPramaDic:nil]autorelease];
//    [DoTracking doJsTrackingWithParma:prama];
    
    _myQueue  = dispatch_queue_create([[NSString stringWithFormat:@"%@.%@", [self.class description], self] UTF8String], NULL);
    
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
    
    mcouponBtn.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    mcouponBtn.layer.borderWidth =1;
    
    mneedfapiao.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    mneedfapiao.layer.borderWidth =1;
    
    mtotalinfoView.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    mtotalinfoView.layer.borderWidth =1;
    
    msendDayChooseButton.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    msendDayChooseButton.layer.borderWidth =1;
    
    self.mpaymethodinwebTexts = [NSArray arrayWithObjects:@"财付通",@"招商银行",@"支付宝",@"手机支付",@"银联支付",nil];
    
    mpaymentchooseIndicaterImageView.frame = CGRectMake(0, 0, 0, 0);
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeCouponVC:) name:@"CloseCouponVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeCouponProvingVC:) name:@"CloseCouponProvingVC" object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    dispatch_release(_myQueue);
    _myQueue = NULL;
    
    [mpaymentTypeLabels release];
    [mOrderNumber release];
    [_currentOrder release];
    [motherAddressView release];
    if (invoiceVC != nil) {
        [invoiceVC release];
    }
    
    [_editInvoiceVO release];
    
    if (couponVC!=nil) {
        [couponVC release];
        
    }
    if (couponProvingVC!=nil) {
        [couponProvingVC release];
    }
    
    [super dealloc];
}

#pragma mark - UserAction
-(IBAction)submitOrderClicked:(id)sender
{
    [MobClick event:@"submit_order"];
    
    
    if (mpaymentMethod <= 0
        || (mpaymentMethod == 1 && mGateWayId == nil))  // 如果是网上支付，且gateWayID是nil
    {
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择一种支付方式" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    else
    {
        DataHandler * tempdatahandler = [DataHandler sharedDataHandler];
        [tempdatahandler.cart.buyItemList  removeAllObjects];
        [tempdatahandler.cart.gifItemtList removeAllObjects];
        tempdatahandler.cart.totalprice = [NSNumber numberWithInt:0];
        tempdatahandler.cart.totalquantity = [NSNumber numberWithInt:0];
        tempdatahandler.cart.totalsavedprice = [NSNumber numberWithInt:0];
        tempdatahandler.cart.totalWeight = [NSNumber numberWithInt:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyCartChange object:nil];
        NSMutableDictionary *mDictionary=[[NSMutableDictionary alloc] init];
        GoodReceiverVO *goodReceiverVO=[OTSUtility safeObjectAtIndex:mreceiveindex inArray:mreceiveListArray];
        NSNumber *methodId=[OTSUtility safeObjectAtIndex:mpaymentMethod-1 inArray:mPaymentIds];
        [mDictionary setObject:[NSNumber numberWithInt:[[goodReceiverVO nid] intValue]] forKey:@"GoodReceiverId"];
        [mDictionary setObject:[NSNumber numberWithInt:[methodId intValue]] forKey:@"MethodId"];
        [mDictionary setObject:[NSNumber numberWithInt:[mGateWayId intValue]] forKey:@"GateWayId"];
        if (invoiceVC.m_InvoiceTitle==nil) {
            [mDictionary setObject:@"" forKey:@"InvoiceTitle"];
        } else {
            [mDictionary setObject:[NSString stringWithString:invoiceVC.m_InvoiceTitle] forKey:@"InvoiceTitle"];
        }
        if (invoiceVC.m_InvoiceContent==nil) {
            [mDictionary setObject:@"" forKey:@"InvoiceContent"];
        } else {
            [mDictionary setObject:[NSString stringWithString:invoiceVC.m_InvoiceContent] forKey:@"InvoiceContent"];
        }
        if (invoiceVC.m_InvoiceAmount==nil) {
            [mDictionary setObject:[NSNumber numberWithInt:0] forKey:@"InvoiceAmount"];
        } else {
            [mDictionary setObject:[NSNumber numberWithInt:[invoiceVC.m_InvoiceAmount intValue]] forKey:@"InvoiceAmount"];
        }
        if (couponVC.currentCouponNumber==nil || [couponVC.currentCouponNumber isEqualToString:@""]) {
            [mDictionary setObject:@"" forKey:@"CouponNumber"];
        } else {
            [mDictionary setObject:[NSString stringWithString:couponVC.currentCouponNumber] forKey:@"CouponNumber"];
        }
        [self setUpThreadWithStatus:THREAD_STATUS_SUBMIT_ORDER showLoading:YES withObject:mDictionary finishSelector:@selector(handleSubmitOrder:)];
        [mDictionary release];
    }
}

-(void)getPaymentType
{
    //[self otsDetatchMemorySafeNewThreadSelector:@selector(PaymentType) toTarget:self withObject:nil];
    
    dispatch_async(_myQueue, ^{
        [self PaymentType];
    });
}
-(void)getReceiveList
{
    //[self otsDetatchMemorySafeNewThreadSelector:@selector(AddressList) toTarget:self withObject:nil];
    
    dispatch_async(_myQueue, ^{
        [self AddressList];
    });
}
-(void)getSessionOrder
{
    //[self otsDetatchMemorySafeNewThreadSelector:@selector(SessionOrder) toTarget:self withObject:nil];
    
    dispatch_async(_myQueue, ^{
        [self SessionOrder];
    });
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
            NSLog(@"data nid is %i",[[OTSGpsHelper sharedInstance].provinceVO.nid intValue]);
            if ([((GoodReceiverVO*)[mreceiveListArray objectAtIndex:i]).provinceId intValue] == [[OTSGpsHelper sharedInstance].provinceVO.nid intValue])
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
    if (mreceiveListArray==nil || [mreceiveListArray count]==0) {
        return;
    }
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
    [mnewAddressView.mcloseButton setFrame:CGRectMake(34, 16, mnewAddressView.mcloseButton.frame.size.width, mnewAddressView.mcloseButton.frame.size.height)];
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
        if ([((GoodReceiverVO*)[mreceiveListArray objectAtIndex:i]).provinceId longValue]== [[OTSGpsHelper sharedInstance].provinceVO.nid longValue] ) {
            isAddressavailable = YES;
        }
    }
    motherAddressView.mIsAllAddressunavailable = !isAddressavailable;
    [self.view addSubview:motherAddressView];
    [self moveToLeftSide:motherAddressView];
    [newview release];
}
-(IBAction)couponBtnClicked:(id)sender{
    
    UIView * newview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view addSubview:newview];
    [newview setBackgroundColor:[UIColor grayColor]];
    [newview setAlpha:0.6];
    [newview setTag:knewview];
    
    //这里内存有问题 改用 self , autorelease 否则每点一次就泄露一次
    self.couponVC = [[[CouponViewController alloc]init] autorelease];
    [couponVC.view setTag:kcouponView];
    [couponVC setCurrentCouponNumber:[[self.currentOrder coupon] number]];
    [couponVC.view setFrame:CGRectMake(277, 768, couponVC.view.frame.size.width, couponVC.view.frame.size.height)];
    [self.view addSubview:couponVC.view];
    [self moveToLeftSide:couponVC.view];
    [newview release];
//    [couponVC release];
}
-(IBAction)savePaymentMethod:(id)sender
{
    NSLog(@"%i,%i",[mPaymentIds count],mpaymentMethod);
    [MobClick event:@"select_payment"];
    
    mpaymentMethod = ((UIButton*)sender).tag <= [mPaymentIds count] ? ((UIButton*)sender).tag : mpaymentMethod;
    NSLog(@"%i",mpaymentMethod);
    
    switch (mpaymentMethod)
    {
        case 1:
            mpaymentchooseIndicaterImageView.frame = CGRectMake(66, 80, 217, 35);
            break;
        case 2:
            mpaymentchooseIndicaterImageView.frame = CGRectMake(312, 130, 217, 35);
            break;
        case 3:
            mpaymentchooseIndicaterImageView.frame = CGRectMake(66, 130, 217, 35);
            break;
        case 4:
            mpaymentchooseIndicaterImageView.frame = CGRectMake(312, 80, 217, 35);
            break;
        default:
            break;
    }
    
    if(((UIButton*)sender).tag <= [mPaymentIds count])
    {
        //根据method_name 判断是否弹出网上支付选项
        NSString* current_paymethod_name = ((PaymentMethodVO*)[OTSUtility safeObjectAtIndex:mpaymentMethod-1 inArray:mpaymentTypeArray]).methodName;
        
        if (![current_paymethod_name isEqualToString:@"网上支付"])
        {
            mpaymentMethod =((UIButton*)sender).tag;
        }
        else
        {
            UIView * newview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
            [self.view addSubview:newview];
            [newview setBackgroundColor:[UIColor grayColor]];
            [newview setAlpha:0.6];
            [newview setTag:knewview];
            [newview release];
            
            //[self otsDetatchMemorySafeNewThreadSelector:@selector(GetGateWay) toTarget:self withObject:nil];
            dispatch_async(_myQueue, ^{
                [self GetGateWay];
            });
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
    if ([self.currentOrder goodReceiver]==nil) {
        [self showAlertView:nil alertMsg:@"您目前没有选择送货地址,请先选择您的送货地址!" alertTag:4];
    } else if ([self.currentOrder.paymentMethodForString isEqualToString:@"此地址不支持货到付款"]) {
        [self showAlertView:nil alertMsg:@"您目前的送货地址不正确,请先确认您的送货地址!" alertTag:2];
    } else if ([self.currentOrder.productAmount doubleValue] == 0) {
		[self showAlertView:nil alertMsg:@"商品金额为0，无法开具发票" alertTag:3];
	} else {
        if (invoiceVC != nil) {
            [invoiceVC release];
            invoiceVC = nil;
        }
        invoiceVC = [[InvoiceViewController alloc] init];
        
        if ( self.editInvoiceVO == nil ) {
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
            if (![self.editInvoiceVO.title isEqualToString:@"个人"]) {
                [invoiceVC setM_InvoiceTitle:self.editInvoiceVO.title];
            }
            [invoiceVC setM_InvoiceContent:self.editInvoiceVO.content];
            [invoiceVC setM_InvoiceAmount:self.currentOrder.productAmount];
        }
        
        [invoiceVC setM_InvoiceType:self.currentOrder.canIssuedInvoiceType];
        
        if(self.currentOrder.invoiceList!=nil && [self.currentOrder.invoiceList count]>0){
            self.editInvoiceVO = [self.currentOrder.invoiceList objectAtIndex:0];
            if (![self.editInvoiceVO.title isEqualToString:@"个人"]) {
                [invoiceVC setM_InvoiceTitle:self.editInvoiceVO.title];
            }
            [invoiceVC setM_InvoiceContent:self.editInvoiceVO.content];
            [invoiceVC setM_InvoiceAmount:self.editInvoiceVO.amount];
        }
        
        [invoiceVC.view setFrame:CGRectMake(240, 768, invoiceVC.view.frame.size.width, invoiceVC.view.frame.size.height)];
        [invoiceVC.view setTag:kinvoiceView];
        
        UIView * newview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
        [self.view addSubview:newview];
        [newview setBackgroundColor:[UIColor grayColor]];
        [newview setAlpha:0.6];
        [newview setTag:knewview];
        
        //[mnewAddressView getprovince];
        [self.view addSubview:invoiceVC.view];
        [self moveToLeftSide:invoiceVC.view];
        [newview release];
    }
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

-(void)delAll
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    int result = [service delAllProduct:[GlobalValue getGlobalValueInstance].token];
    NSLog(@"delAllProduct, result:%d", result);
    [pool drain];
}

-(void)SessionOrder
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    
    self.currentOrder = [service getSessionOrder:[GlobalValue getGlobalValueInstance].token];
    
    [self performInMainBlock:^{
        
        mtotalCountLabel.text = [NSString stringWithFormat:@"%@件",[self.currentOrder totalProductQuantity]];
        mtotalWeightLabel.text = [NSString stringWithFormat:@"运费(%.2fkg):",[self.currentOrder.orderTotalWeight doubleValue]];
        mproductAmount.text = [NSString stringWithFormat:@"   ¥ %.2f",[self.currentOrder.productAmount doubleValue]];
        //mproductAmount.textColor = kRedColor;
        mdeliveryAmountLabel.text = [NSString stringWithFormat:@"+ ¥ %@",self.currentOrder.deliveryAmount];
        //mdeliveryAmountLabel.textColor = kRedColor;
        mcouponAmountLabel.text = [NSString stringWithFormat:@"-  ¥ %@",self.currentOrder.couponAmount];
        if (self.currentOrder.couponAmount && [self.currentOrder.couponAmount doubleValue]>0) {
            UIImageView *imageView = (UIImageView*)[mpaymentmethodView viewWithTag:1001];
            if (imageView == nil) {
                UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(65, 12, 217, 35)];
                [imv setImage:[UIImage imageNamed:@"paymentmethodchoose@2x.png"]];
                [imv setTag:1001];
                [mpaymentmethodView addSubview:imv];
                [imv release];
            }
            [mcouponLabel setHidden:NO];
            [mcouponLabel setText:[NSString stringWithFormat:@" ¥ %@",self.currentOrder.couponAmount]];
        }else{
            UIImageView *imageView = (UIImageView*)[mpaymentmethodView viewWithTag:1001];
            if (imageView.superview!=nil) {
                [imageView removeFromSuperview];
            }
            [mcouponLabel setHidden:YES];
        }
        mpaymentAccountLabel.text = [NSString stringWithFormat:@"¥ %.2f",[self.currentOrder.paymentAccount doubleValue]];
        mpaymentAccountLabel.textColor = kRedColor;
        NSString * date = [self.currentOrder.expectReceiveDateTo substringWithRange:NSMakeRange(5, 5)];
        NSString * month = [date substringWithRange:NSMakeRange(0, 2)];
        if ([[month substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"0"]) {
            month = [month substringWithRange:NSMakeRange(1, 1)];
        }
        NSString * day = [date substringWithRange:NSMakeRange(3, 2)];
        mDeliverLabel.text = [NSString stringWithFormat:@"%@: %.0f元", self.currentOrder.deliveryMethodForString, [self.currentOrder.deliveryAmount doubleValue]];
        mDeliverDayLabel.text = [NSString stringWithFormat:@"预计%@月%@日送达",month,day];
        mDeliverWeightLabel.text = [NSString stringWithFormat:@"运费(%.2fkg):¥%@",[self.currentOrder.orderTotalWeight doubleValue],self.currentOrder.deliveryAmount];
        
    }];
    
    
    [pool drain];
}
-(void)handleSubmitOrder:(NSNumber*)result
{
    long long resultcode = [result longLongValue];
    if (resultcode >0)
    {
        listsucceedViewController * temp = [[listsucceedViewController alloc]init];
        self.mOrderNumber = result;
        
        DebugLog(@"-----> order confirm orderID:%@", result);
        [temp setOrdernumber:result];
        NSLog(@"%@",self.currentOrder.paymentAccount);
        [temp setMtotalprice:[self.currentOrder.paymentAccount doubleValue]];
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
    
    //[self otsDetatchMemorySafeNewThreadSelector:@selector(delAll) toTarget:self withObject:nil];
    dispatch_async(_myQueue, ^{
        [self delAll];
    });
}
-(void)PaymentType
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    self.mpaymentTypeArray = [service getPaymentMethodsForSessionOrder:[GlobalValue getGlobalValueInstance].token];
    
    [self performInMainBlock:^{
        
        //重新加载支付方式
        [mpaymentType0 setText:@""];
        [mpaymentType1 setText:@""];
        [mpaymentType2 setText:@""];
        [mpaymentType3 setText:@""];
        mpaymentMethod = 0;
        mpaymentchooseIndicaterImageView.frame = CGRectMake(0, 0, 0, 0);
        
        self.mPaymentIds = [NSMutableArray arrayWithCapacity:1];
        int k = 0;
        for (int i=0; i<[mpaymentTypeArray count]; i++)
        {
            NSLog(@"%@,%@",((PaymentMethodVO*)[mpaymentTypeArray objectAtIndex:i]).methodName,((PaymentMethodVO*)[mpaymentTypeArray objectAtIndex:i]).isDefaultPaymentMethod);
            NSLog(@"->%@",((PaymentMethodVO*)[mpaymentTypeArray objectAtIndex:i]).gatewayId);
            if (!((PaymentMethodVO*)[mpaymentTypeArray objectAtIndex:i]).gatewayId)
            {
                ((UILabel*)[mpaymentTypeLabels objectAtIndex:k++]).text = ((PaymentMethodVO*)[mpaymentTypeArray objectAtIndex:i]).methodName;
                [mPaymentIds addObject:((PaymentMethodVO*)[mpaymentTypeArray objectAtIndex:i]).methodId];
            }
            if ([((PaymentMethodVO*)[mpaymentTypeArray objectAtIndex:i]).isDefaultPaymentMethod isEqualToString:@"true"]&&!((PaymentMethodVO*)[mpaymentTypeArray objectAtIndex:i]).gatewayId)
            {
                switch (i+1) {
                    case 1:
                        mpaymentchooseIndicaterImageView.frame = CGRectMake(66, 80, 217, 35);
                        break;
                    case 2:
                        mpaymentchooseIndicaterImageView.frame = CGRectMake(312, 130, 217, 35);
                        break;
                    case 3:
                        mpaymentchooseIndicaterImageView.frame = CGRectMake(66, 130, 217, 35);
                        break;
                    case 4:
                        mpaymentchooseIndicaterImageView.frame = CGRectMake(312, 80, 217, 35);
                        break;
                    default:
                        break;
                }
                mpaymentMethod = i+1;
            }
            NSLog(@"%@,%@",((PaymentMethodVO*)[mpaymentTypeArray objectAtIndex:i]).methodName,((PaymentMethodVO*)[mpaymentTypeArray objectAtIndex:i]).methodId);
        }
        
    }];
//    JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_CheckPayment extraPramaDic:nil]autorelease];
//    [DoTracking doJsTrackingWithParma:prama];
    
    [pool drain];
}
-(void)AddressList
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    self.mreceiveListArray =[NSMutableArray arrayWithArray:[service getGoodReceiverListByToken:[GlobalValue getGlobalValueInstance].token]];
    
    [self performInMainBlock:^{
        
        int i=0;
        for (i = 0; i<[mreceiveListArray count]; i++)
        {
            NSLog(@"data nid is %i",[[OTSGpsHelper sharedInstance].provinceVO.nid intValue]);
            if ([((GoodReceiverVO*)[mreceiveListArray objectAtIndex:i]).provinceId intValue] == [[OTSGpsHelper sharedInstance].provinceVO.nid intValue])
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
        
    }];
    
    [pool drain];
}
-(void)ShowAddress:(GoodReceiverVO*)goodreceiver
{
//    [self performSelector:@selector(getSessionOrder) withObject:nil];
//    [self performSelector:@selector(getPaymentType) withObject:nil afterDelay:1];
    dispatch_async(_myQueue, ^{
        [self PaymentType];
        [self SessionOrder];
    });
    
    mreceivenameLabel.text = goodreceiver.receiveName;
    
    if (goodreceiver.receiverMobile) {
        mpostCodeLabel.text = goodreceiver.receiverMobile;
    }
    else {
        mpostCodeLabel.text = goodreceiver.receiverPhone;
    }
    
    if ([goodreceiver.provinceName isEqualToString:@"上海"]) {
        maddressLabel.text = [NSString stringWithFormat:@"%@  %@  %@",goodreceiver.provinceName,goodreceiver.cityName,goodreceiver.address1];
    } else {
        maddressLabel.text = [NSString stringWithFormat:@"%@  %@  %@  %@",goodreceiver.provinceName,goodreceiver.cityName,goodreceiver.countyName,goodreceiver.address1];
    }
    
}

-(void)GetGateWay
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    Page * temppage = [service getBankVOList:[GlobalValue getGlobalValueInstance].trader name:@"" type:[NSNumber numberWithInt:-1] currentPage:[NSNumber numberWithInt:1] pageSize:[NSNumber numberWithInt:20]];
    
    [self performInMainBlock:^{
        
        //        if (temppage.objList && temppage.objList.count > 0)
        //        {
        //            NSLog(@"PAGE %@",[temppage objList]);
        //            mGateWayId = ((BankVO*)[[temppage objList] objectAtIndex:0]).gateway;
        //
        //            for (int i = 0 ; i<[[temppage objList] count]; i++)
        //            {
        //                NSLog(@"%@",((BankVO*)[[temppage objList] objectAtIndex:i]).bankname);
        //            }
        //            NSLog(@"%@",mGateWayId);
        //        }
        
        mBankList = [temppage objList];
        [self performSelectorOnMainThread:@selector(popuppayinwebview) withObject:nil waitUntilDone:YES];
        
    }];
    
    [pool drain];
}

-(void)popuppayinwebview
{
    NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"PayInWebView" owner:self options:nil];
    PayInWebView *  temppayView = [nib objectAtIndex:0];
    temppayView.mBankArray = mBankList;
    temppayView.tag = kpayinwebview;
    [self.view addSubview:temppayView];
    [temppayView setFrame:CGRectMake(240, 768, 545, 533)];
    [self moveToLeftSide:temppayView];
    
}

#pragma mark - Notification
-(void)popPayInWebView:(NSNotification*)notification
{
    mpaymethodinwebindex = [notification.object intValue];
    
    PayInWebView *payListView = (PayInWebView *)[self.view viewWithTag:kpayinwebview];
    
    if (mpaymethodinwebindex >= 0)
    {
		BankVO* bankVO = (BankVO*)([mBankList objectAtIndex: mpaymethodinwebindex]);
        mGateWayId = bankVO.gateway;
        NSLog(@">>>>>>> %d",mpaymentMethod);
        //  这里需要判断一下是否是网上支付的 lable 才去改名称
        for (int i=0; i<[mpaymentTypeArray count]; i++)
        {
            NSString* current_paymethod_name = ((PaymentMethodVO*)[OTSUtility safeObjectAtIndex:i inArray:mpaymentTypeArray]).methodName;
            if ([current_paymethod_name isEqualToString:@"网上支付"])
            {
                ((UILabel*)[mpaymentTypeLabels objectAtIndex:i]).text =  bankVO.bankname;
                switch (i+1)
                {
                    case 1:
                        mpaymentchooseIndicaterImageView.frame = CGRectMake(66, 80, 217, 35);
                        break;
                    case 2:
                        mpaymentchooseIndicaterImageView.frame = CGRectMake(312, 130, 217, 35);
                        break;
                    case 3:
                        mpaymentchooseIndicaterImageView.frame = CGRectMake(66, 130, 217, 35);
                        break;
                    case 4:
                        mpaymentchooseIndicaterImageView.frame = CGRectMake(312, 80, 217, 35);
                        break;
                    default:
                        break;
                }
                mpaymentMethod = i+1;
            }
            break;
        }
    }
    [self moveToRightSide:payListView];
}


-(void)popNewAddressView:(NSNotification*)notification
{
    GoodReceiverVO* goodRcver = (GoodReceiverVO*)notification.object;
    
    BOOL isAddAddress = ((NewAddressView*)[self.view viewWithTag:knewaddressview]).isnewAddress;
    if (!isAddAddress)
    {
        [MobClick endLogPageView:@"edit_address"];
    }
    else
    {
        [MobClick endLogPageView:@"new_address"];
    }
    
    [self PushDownUIPickerView];
    [self moveToRightSide:[self.view viewWithTag:knewaddressview]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (isAddAddress)
        {
            NSArray* goodRecievers = [[OTSServiceHelper sharedInstance] getGoodReceiverListByToken:[GlobalValue getGlobalValueInstance].token];
            
            if (goodRecievers && goodRecievers.count > 0)
            {
                GoodReceiverVO* latestReciver = [goodRecievers objectAtIndex:0];
                
                if (latestReciver && latestReciver.nid)
                {
                    [[OTSServiceHelper sharedInstance] saveGoodReceiverToSessionOrder:[GlobalValue getGlobalValueInstance].token goodReceiverId:latestReciver.nid];
                }
                // 需额外传入goodReceiverId
//                JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_SaveReciveToOrder extraPrama:latestReciver.nid, nil]autorelease];
//                [DoTracking doJsTrackingWithParma:prama];
            }
        }
        else
        {
            if (goodRcver && goodRcver.nid)
            {
                [[OTSServiceHelper sharedInstance] saveGoodReceiverToSessionOrder:[GlobalValue getGlobalValueInstance].token goodReceiverId:goodRcver.nid];
            }
            // 需额外传入goodReceiverId
//            JSTrackingPrama* prama = [[[JSTrackingPrama alloc]initWithJSType:EJStracking_SaveReciveToOrder extraPrama:goodRcver.nid, nil]autorelease];
//            [DoTracking doJsTrackingWithParma:prama];
        }
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self getReceiveList];
//            [self getPaymentType];
//            [self getSessionOrder];
//        });
        dispatch_async(_myQueue, ^{
            [self AddressList];
            [self PaymentType];
            [self SessionOrder];
        });
    });
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
-(void)PopSelfWithOutAnimated:(NSNotification*)notification{
    [self.navigationController popViewControllerAnimated:NO];
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
    
    int i = 0;
    for (i = 0; i<[mreceiveListArray count]; i++)
    {
        NSLog(@"data nid is %i",[[OTSGpsHelper sharedInstance].provinceVO.nid intValue]);
        if ([((GoodReceiverVO*)[mreceiveListArray objectAtIndex:i]).provinceId intValue] == [[OTSGpsHelper sharedInstance].provinceVO.nid intValue])
        {
            break;
        }
    }
    if (i==[mreceiveListArray count])
    {
        [self PopSelf:nil];
    }
}

-(void)closeInvoice:(NSNotification*)notifcation{
    [self moveToRightSide:[self.view viewWithTag:kinvoiceView]];
}

//清除发票信息
-(void)clearInvoiceInfo:(NSNotification *)notification{
    [m_InvoiceLabel setText:@""];
    UIImageView *imageView = (UIImageView*)[mhighchooseView viewWithTag:1001];
    if (imageView) {
        [imageView removeFromSuperview];
        imageView = nil;
    }
}
-(void)closeCouponVC:(NSNotification *)notification{
    NSArray* closeInfoArr = (NSArray*)notification.object;
    NSString* closeInfo = [closeInfoArr objectAtIndex:0];
    if (closeInfoArr.count == 2) {          // 同时传递了couponNumber 和CouponCheckResult，进入短信验证页面
        
        CouponCheckResult* couponResult = [closeInfoArr objectAtIndex:1];
        if (![closeInfo isEqualToString:CLOSE_COUPON_CLOSEDIRECTLY]) {
            dispatch_async(_myQueue, ^{
//                [self AddressList];
                [self PaymentType];
                [self SessionOrder];
            });
//            [self getSessionOrder];
        }
        // 进入短信验证页面
        couponProvingVC = [[CouponProvingViewController alloc]init];
        [couponProvingVC setCheckResult:couponResult];
        [couponProvingVC setCouponNum:closeInfo];
        [couponProvingVC.view setTag:kcouponProvingView];
        [couponProvingVC.view setFrame:CGRectMake(277, 768, couponProvingVC.view.frame.size.width, couponProvingVC.view.frame.size.height)];
        [self.view addSubview:couponProvingVC.view];
        
        [self moveToLeftSide:couponProvingVC.view];
        // 偷偷关闭抵用券页面
        [[self.view viewWithTag:kcouponView] removeFromSuperview];
    }else{                                  // 保存抵用券成功或者直接关闭抵用券
        if ([closeInfo isEqualToString:SAVE_COUPON_SUCCESS]) {//若对抵用券进行了修改（删除后者使用），从新获取订单
            //            [self getSessionOrder];
            dispatch_async(_myQueue, ^{
//                [self AddressList];
                [self PaymentType];
                [self SessionOrder];
            });
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self getReceiveList];
//                [self getSessionOrder];
//                [self getPaymentType];
//            });
        }
        [self moveToRightSide:[self.view viewWithTag:kcouponView]];
    }
}
-(void)closeCouponProvingVC:(NSNotification *)notification{
    NSString* notifyStr = (NSString*)notification.object;
    if ([notifyStr isEqualToString:@"CloseWithReload"]) {          // 发送了object说明验证页面操作成功了
        dispatch_async(_myQueue, ^{
            [self PaymentType];
            [self SessionOrder];
        });
    }else{
        [couponVC setCurrentCouponNumber:@""];
    }
    [self moveToRightSide:[self.view viewWithTag:kcouponProvingView]];
}
//保存发票信息到订单
-(void)saveInvoiceToOrder:(NSNotification *)notification
{
	NSArray* tempArray = (NSArray*)[notification object];
    
	self.editInvoiceVO = [tempArray objectAtIndex:0];
	//titleStyle = [tempArray objectAtIndex:1];						//抬头类型 个人为0，公司为1
	
	NSNumber* isHadSave = [tempArray objectAtIndex:2];				//标帜从“返回”返回，还是从“保存”返回 0为保存，1为返回
	if (isHadSave == [NSNumber numberWithInt:0]) {
		[m_InvoiceLabel setText:self.editInvoiceVO.title];
        UIImageView *imageView = (UIImageView*)[mhighchooseView viewWithTag:1001];
        if (imageView == nil) {
            UIImageView *imv = [[UIImageView alloc] initWithFrame:mneedfapiao.frame];
            [imv setImage:[[UIImage imageNamed:@"paymentmethodchoose.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
            [imv setTag:1001];
            [mhighchooseView addSubview:imv];
            [imv release];
        }
        
		[invoiceVC setM_InvoiceTitle:self.editInvoiceVO.title];
		[invoiceVC setM_InvoiceContent:self.editInvoiceVO.content];
		[invoiceVC setM_InvoiceAmount:self.currentOrder.productAmount];
        
		//将抬头保存到本地
		NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString* directory = [paths objectAtIndex:0];
		NSString* fileName = [directory stringByAppendingPathComponent:@"InvoiceTitle.plist"];
		[self.editInvoiceVO.title writeToFile:fileName atomically:NO encoding:NSUTF8StringEncoding error:nil];
	}else {
		NSNumber* isNeed = [tempArray objectAtIndex:3];
		if ([isNeed intValue] == 1) {						//不需要需要发票
			[m_InvoiceLabel setText:@""];
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
- (void)moveToLeftSide:(UIView *)view{
    CGRect rect = view.frame;
    float x = (1024-rect.size.width)/2.0;
    [UIView animateWithDuration:0.5 animations:^{
        view.frame = CGRectMake(x, 80, rect.size.width, rect.size.height);
    }
                     completion:^(BOOL finished)
     {
         
     }];
}
- (void)moveToRightSide:(UIView *)view{
    CGRect rect = view.frame;
    float x = (1024-rect.size.width)/2.0;
    [UIView animateWithDuration:0.5 animations:^{
        view.frame = CGRectMake(x, 768, rect.size.width, rect.size.height);
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
    } completion:^(BOOL finished){
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
    //[self otsDetatchMemorySafeNewThreadSelector:@selector(getprovincefromserver) toTarget:self withObject:nil];
    dispatch_async(_myQueue, ^{
        [self getprovincefromserver];
    });
}
-(void)getprovincefromserver
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    
    self.mprovince = [service getAllProvince:[GlobalValue getGlobalValueInstance].trader];
    
    [self performInMainBlock:^{
        [mAddressChoosePickerView reloadComponent:0];
    }];
    
    [pool drain];
}
-(void)getcity:(NSNumber*)provinceid
{
    //[self otsDetatchMemorySafeNewThreadSelector:@selector(getcityfromserver:) toTarget:self withObject:provinceid];
    dispatch_async(_myQueue, ^{
        [self getcityfromserver:provinceid];
    });
}
-(void)getcityfromserver:(NSNumber*)provinceid
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    NSLog(@"%@",provinceid);
    self.mcity = [service getCityByProvinceId:[GlobalValue getGlobalValueInstance].trader provinceId:provinceid];
    
    [self performInMainBlock:^{
        [mAddressChoosePickerView reloadComponent:0];
    }];
    
    [pool drain];
}
-(void)getcounty:(NSNumber *)cityid
{
    //[self otsDetatchMemorySafeNewThreadSelector:@selector(getcountyfromserver:) toTarget:self withObject:cityid];
    
    dispatch_async(_myQueue, ^{
        [self getcountyfromserver:cityid];
    });
}
-(void)getcountyfromserver:(NSNumber*)cityid
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    
    self.mcounty = [service getCountyByCityId:[GlobalValue getGlobalValueInstance].trader cityId:cityid];
    
    [self performInMainBlock:^{
        [mAddressChoosePickerView reloadComponent:0];
    }];
    
    [pool drain];
}
@end
