//
//  PadPayOKVC.m
//  TheStoreApp
//
//  Created by huang jiming on 13-5-23.
//
//

#import "PadPayOKVC.h"
#import "OrderTrackViewController.h"

@interface PadPayOKVC ()

@end

@implementation PadPayOKVC
@synthesize orderV2;

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
	// Do any additional setup after loading the view.
    [self initUI];
}

/**
 *  功能:初始化ui
 */
- (void)initUI
{
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1024, 55)];
    titleLbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top_bg"]];
    titleLbl.text = @"支付成功";
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.font = [UIFont systemFontOfSize:23.0];
    titleLbl.shadowOffset = CGSizeMake(0, -1);
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLbl];
    [titleLbl release];
    
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(200, 185, 624, 235)];
    centerView.layer.borderWidth = 1.0;
    centerView.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    centerView.layer.cornerRadius = 10.0;
    [self.view addSubview:centerView];
    [centerView release];
    
    UILabel *orderNum = [[UILabel alloc] initWithFrame:CGRectMake(410, 20, 200, 21)];
    orderNum.backgroundColor = [UIColor clearColor];
    if (self.orderV2.orderCode != nil) {
        orderNum.text = [NSString stringWithFormat:@"订单号：%@", self.orderV2.orderCode];
    } else {
        orderNum.text = [NSString stringWithFormat:@"订单号：%@", self.orderV2.orderId];
    }
    orderNum.textColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1.0];
    orderNum.font = [UIFont systemFontOfSize:17.0];
    [centerView addSubview:orderNum];
    [orderNum release];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(28, 49, 27, 23)];
    icon.image = [UIImage imageNamed:@"yesinsucceed"];
    [centerView addSubview:icon];
    [icon release];
    
    UILabel *textLbl = [[UILabel alloc] initWithFrame:CGRectMake(63, 46, 529, 52)];
    textLbl.backgroundColor = [UIColor clearColor];
    textLbl.numberOfLines = 2;
    textLbl.text = @"恭喜您，您的订单已经成功提交，我们会为您尽快发货！";
    textLbl.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    textLbl.font = [UIFont boldSystemFontOfSize:23.0];
    [centerView addSubview:textLbl];
    [textLbl release];
    
    UILabel *payedLbl = [[UILabel alloc] initWithFrame:CGRectMake(25, 140, 100, 21)];
    payedLbl.backgroundColor = [UIColor clearColor];
    payedLbl.text = @"您已支付：";
    payedLbl.textColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1.0];
    payedLbl.font = [UIFont systemFontOfSize:19.0];
    [centerView addSubview:payedLbl];
    
    UILabel *orderMoney = [[UILabel alloc] initWithFrame:CGRectMake(128, 140, 100, 21)];
    orderMoney.backgroundColor = [UIColor clearColor];
    if (self.orderV2.paymentAccount != nil) {
        orderMoney.text = [NSString stringWithFormat:@"¥ %@", self.orderV2.paymentAccount];
    } else {
        orderMoney.text = [NSString stringWithFormat:@"¥ %@", self.orderV2.orderAmount];
    }
    orderMoney.textColor = [UIColor colorWithRed:241.0/255.0 green:0.0 blue:0.0 alpha:1.0];
    orderMoney.font = [UIFont boldSystemFontOfSize:19.0];
    [centerView addSubview:orderMoney];
    
    UIButton *orderDetailBtn = [[UIButton alloc] initWithFrame:CGRectMake(270, 433, 177, 45)];
    [orderDetailBtn setBackgroundImage:[UIImage imageNamed:@"gotoorderdetailunClicked"] forState:UIControlStateNormal];
    [orderDetailBtn addTarget:self action:@selector(orderDetailBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:orderDetailBtn];
    [orderDetailBtn release];
    
    UIButton *continueBuyBtn = [[UIButton alloc] initWithFrame:CGRectMake(577, 433, 177, 45)];
    [continueBuyBtn setBackgroundImage:[UIImage imageNamed:@"gotoshoppingunClicked"] forState:UIControlStateNormal];
    [continueBuyBtn addTarget:self action:@selector(continueBuyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:continueBuyBtn];
    [continueBuyBtn release];
    
}

/**
 *  功能:查看订单详情
 */
- (void)orderDetailBtnClicked:(id)sender
{
    OrderTrackViewController *orderTrackVC = [[[OrderTrackViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    orderTrackVC.orderDetail = self.orderV2;
    [self.navigationController pushViewController:orderTrackVC animated:NO];
}

/**
 *  功能:继续购物
 */
- (void)continueBuyBtnClicked:(id)sender
{
    [self.navigationController.view.layer addAnimation:[OTSNaviAnimation transactionFade] forKey:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
