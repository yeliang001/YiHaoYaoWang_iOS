//
//  OnlinePayViewController.m
//  yhd
//
//  Created by dev dev on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OnlinePayViewController.h"
#import "DataHandler.h"
#import "ProvinceVO.h"
#import "GlobalValue.h"
#import "Trader.h"
#import "OTSGpsHelper.h"
#import "MyListViewController.h"
#import "OtsPadLoadingView.h"
#import "OrderV2.h"
#import "PadPayOKVC.h"

@interface OnlinePayViewController ()
@property(nonatomic, retain) OtsPadLoadingView *loadingView;
@property(nonatomic, retain) OrderV2 *orderV2;
@end

@implementation OnlinePayViewController
@synthesize mGateWayId;
@synthesize mOrderId;
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
    // <<BUG 0109483>>: : 【支付】点击支付的时候要检查一下订单的状态---------->dym
    [self.loadingView showInView:self.view];
    
    [self performInThreadBlock:^{
        self.orderV2 = [[OTSServiceHelper sharedInstance] getOrderDetailByOrderIdEx:[GlobalValue getGlobalValueInstance].token orderId:self.mOrderId];
    } completionInMainBlock:^{
        
        [self.loadingView hide];
        
        BOOL canPay = YES;
        if (self.orderV2.hasPayedOnline)
        {
            [OTSUtility alert:@"订单已支付成功，无需再次支付。我们会尽快为您发货"];
            canPay = NO;
        }
        else if (self.orderV2.isCanceled)
        {
            [OTSUtility alert:@"由于逾期未支付，订单已取消，请重新下单。"];
            canPay = NO;
        }
        
        if (!canPay)
        {
            [self.navigationController.view.layer addAnimation:[OTSNaviAnimation transactionFade] forKey:nil];
            [self.navigationController popViewControllerAnimated:NO];
        }
    }];
    // <<BUG 0109483>>: : 【支付】点击支付的时候要检查一下订单的状态<---------------
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"%@",[GlobalValue getGlobalValueInstance].trader);
    NSLog(@"%@",[GlobalValue getGlobalValueInstance].trader.traderName);
    //DataHandler * tempdata = [DataHandler sharedDataHandler];
    NSString * urlStr = [NSString stringWithFormat:@"http://m.yihaodian.com/mw/pay/%@/%@/%@/%@/%@?osType=40", 
						 [GlobalValue getGlobalValueInstance].trader.traderName, 
						 [GlobalValue getGlobalValueInstance].token, 
						 [OTSGpsHelper sharedInstance].provinceVO.nid, 
						 mOrderId, 
						 mGateWayId];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    
    UIImage * bgImag = [UIImage imageNamed:@"topbarback@2x.png"];
    UIColor * color = [[UIColor alloc]initWithPatternImage:bgImag];
    mtopbarView.backgroundColor = color;
    [color release];
    self.navigationController.navigationBar.hidden = YES;
}
#pragma mark -
#pragma mark webview delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString* requestString = request.URL.absoluteString;
    NSArray *components=[requestString componentsSeparatedByString:@"/"];
    
    if (components.count>2 && [(NSString *)[components objectAtIndex:components.count-2] isEqualToString:@"mallpayok"]) {
        
        [SharedPadDelegate.navigationController.view.layer addAnimation:[OTSNaviAnimation animationFade] forKey:nil];
        PadPayOKVC *payOKVC = [[[PadPayOKVC alloc] initWithNibName:nil bundle:nil] autorelease];
        payOKVC.orderV2 = self.orderV2;
        [SharedPadDelegate.navigationController pushViewController:payOKVC animated:NO];
        
        return NO;
    }
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}
- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    _webView.delegate = nil;
    [_webView stopLoading];
    [_webView release];
    
    [mGateWayId release];
    [mOrderId release];
    
    [_loadingView release];
    
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"order_onlinepay"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"order_onlinepay"];
}
-(IBAction)backClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshSuccessView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
