//
//  listsucceedViewController.h
//  yhd
//
//  Created by dev dev on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderV2.h"
#import "BaseViewController.h"
#import "LTInterface.h"
#import "OtsPadLoadingView.h" 

@interface listsucceedViewController : BaseViewController<LTInterfaceDelegate>
{
    IBOutlet UILabel * orderNumberLabel;
    IBOutlet UILabel * mtotalPriceLabel;
    IBOutlet UIView * mpayView;
    IBOutlet UIView * mmassageView;
    IBOutlet UIView * mtopbarView;
    IBOutlet UIView *m_LoadingView;
    IBOutlet UILabel *m_PayInfoLabel;
    IBOutlet UILabel *m_InfoLabel;
    NSNumber * ordernumber;
    double mtotalprice;
    BOOL mpayViewIsHidden;
    OrderV2 * mdetailOrder;
    NSNumber * mGateWayId;
    UIViewController *UnionpayViewCtrl;// 银联的内嵌容器
    int _mallCup;   //1号商城银联网关
    int _storeCup;  //1号店银联网关
    int _storeAlix; //1号店安全支付网关
    bool backreflushdone;
}
@property(nonatomic,retain)NSNumber * ordernumber;
@property (retain, nonatomic) IBOutlet UIButton *oldPayButton;
@property (retain, nonatomic) IBOutlet UIButton *payLaterBtn;
@property(nonatomic,assign)double mtotalprice;
@property(nonatomic,assign)BOOL mpayViewIsHidden;
@property(nonatomic,retain)NSNumber * mGateWayId;
-(IBAction)payClicked:(id)sender;
-(IBAction)backClicked:(id)sender;
-(IBAction)listDetailClicked:(id)sender;
-(IBAction)goonShoppingClicked:(id)sender;
// 交易插件退出回调方法，需要商户客户端实现 strResult：交易结果，若为空则用户未进行交易。
- (void) returnWithResult:(NSString *)strResult;
// 弹出银联插件
-(void)popTheUnionpayView:(UINavigationController*)aNavigate onlineOrderId:(NSNumber*)onlineOrderId;
// 弹出支付宝安全支付
-(void)popTheAlixpayView:(NSNumber *)aOnlineorderid;
@end
