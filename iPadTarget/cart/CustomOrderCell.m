//
//  CustomOrderCell.m
//  yhd
//
//  Created by dev dev on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define ALERTVIEW_TAG_CANCEL_ORDER_CONFIRM  1

#import "CustomOrderCell.h"
#import "OrderV2.h"
#import "ProductVO.h"
#import "NSObject+OTS.h"
#import "OrderItemVO.h"
#import "OTSServiceHelper.h"
#import "ProductCellImageView.h"
#import "GoodReceiverVO.h"
#import <QuartzCore/QuartzCore.h>
@implementation CustomOrderCell
@synthesize mlabel;
@synthesize mOrder;
@synthesize delegate, payButton = _payButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)reloadCellWithOrder:(OrderV2 *)orderV2
{
    self.mOrder=orderV2;
    
    if (self.mOrder)
    {
        [self updateCell];
        
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInview:)];
        [mItemScrollView addGestureRecognizer:tap];
        [tap release];
    }
}

-(void)updateCell
{
    for (UIView* subview in mItemScrollView.subviews) {
        if ([subview isMemberOfClass:[ProductCellImageView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    int count = [mOrder.orderItemList count];
    for (int i = 0; i<count; i++)
    {
        ProductCellImageView* tempImageView=nil;
        NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"ProductCellImageView" owner:self options:nil];
        tempImageView = [nib objectAtIndex:0];
        [tempImageView setFrame:CGRectMake(20+i*109, 0, 109, 109)];
        tempImageView.tag = 100+i;
        
        tempImageView.mPrice = ((OrderItemVO*)[mOrder.orderItemList objectAtIndex:i]).product.price;
        tempImageView.mCount = ((OrderItemVO*)[mOrder.orderItemList objectAtIndex:i]).buyQuantity;
        ProductVO* theProduct = ((OrderItemVO*)[mOrder.orderItemList objectAtIndex:i]).product;
        NSString *imgUrl = theProduct.midleDefaultProductUrl ? theProduct.midleDefaultProductUrl : theProduct.miniDefaultProductUrl;
        tempImageView.mURL = [NSURL URLWithString:imgUrl];
        [tempImageView refreshImage];
        [mItemScrollView addSubview:tempImageView];
    }
    if ([mOrder.orderType intValue]==2) {//团购
        UIWebView*web=[[UIWebView alloc] initWithFrame:CGRectMake(129, 0, 675-129, 109)];
        NSString *file2 = [[NSBundle mainBundle] pathForResource:@"icon_tuan" ofType:@"png"];//设置占位图片
        NSString *imgstr=[NSString stringWithFormat:@"<img src='file://%@' width=22 height=22 style=\"FLOAT: LEFT; MARGIN-TOP: 0px; MARGIN-RIGHT: 10px\" alt=\"\">",file2];//红色的就是占位图的属性设置：居左，距离上边 0px，距离右边文字10px
        web.backgroundColor = [UIColor clearColor];
        web.opaque = NO;
        //这行能在模拟器下明下加快 loadHTMLString 后显示的速度，其实在真机上没有下句也感觉不到加载过程
        web.dataDetectorTypes = UIDataDetectorTypeNone;
        NSString* groupName=((OrderItemVO*)[mOrder.orderItemList objectAtIndex:0]).product.cnName;
        NSString *webviewText = [NSString stringWithFormat:@"<style>body{margin:10;align:center;font-color:black;font:17px/20px Custom-Font-Name}</style></br>%@<font color=#4F4F4F>%@</font>",imgstr,groupName];//红色部分将文字图片连接在一起
        [web loadHTMLString:webviewText baseURL:nil]; //在 WebView 中显示本地的字符串
        web.userInteractionEnabled=NO;
        [mItemScrollView addSubview:web];
        [web release];
    }
    mBackView.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    mBackView.layer.borderWidth =1;
    mItemScrollView.contentSize = CGSizeMake(count*109, 109);
    mlabel.text=[mOrder orderCode];
    mDateLabel.text = [NSString stringWithFormat:@"%@",[[mOrder createOrderLocalTime] substringToIndex:10]];
    mNameLabel.text = [NSString stringWithFormat:@"%@",mOrder.goodReceiver.receiveName];
    mTotalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[mOrder.orderAmount doubleValue]];
    mOrderStatueLabel.text = mOrder.orderStatusForString;
    mPaymentLabel.text = mOrder.paymentMethodForString;
    
    if ([mOrder.orderStatusForString isEqualToString:@"待结算"])
    {
        if (mOrder.isPayWhenGoodsArriving) 
        {
            mGotoPayButton.hidden = YES;
            mAddtoCartButton.hidden = NO;
        }
        else
        {
            mGotoPayButton.hidden = NO;
            mAddtoCartButton.hidden = YES;
        }
    }
    else
    {
        mGotoPayButton.hidden = YES;
        mAddtoCartButton.hidden = NO;
    }
    
    //取消订单按钮
    BOOL showCancelBtn=YES;
    if ([[mOrder orderType] intValue]==2) {//团购订单不显示取消订单
        showCancelBtn=NO;
    } else if (![mOrder.orderStatusForString isEqualToString:@"待结算"] && ![mOrder.orderStatusForString isEqualToString:@"待处理"]) {
        showCancelBtn=NO;
    } else {
        int i;
        for (i=0; i<[[mOrder childOrderList] count]; i++) {
            OrderV2 *subOrder=[[mOrder childOrderList] objectAtIndex:i];
            if (subOrder.orderStatusForString!=nil && (![subOrder.orderStatusForString isEqualToString:@"待结算"]&&![subOrder.orderStatusForString isEqualToString:@"待处理"]))
            {//子订单中有非待结算、非待处理的订单，不显示取消订单
                showCancelBtn=NO;
                break;
            }
        }
    }
    if (showCancelBtn) {
        [m_CancelButton setHidden:NO];
    } else {
        [m_CancelButton setHidden:YES];
    }

    self.payButton.hidden = mOrder.hasPayedOnline;
    
    if (!mAddtoCartButton.hidden)
    {
        self.payButton.hidden = YES;
    }
    //    团购隐藏再次购买按钮
    if ([mOrder.orderType intValue]==2) {
        mAddtoCartButton.hidden=YES;
    }
}
-(void)tapInview:(UITapGestureRecognizer*)tap{
    if (mOrder.orderType.intValue == 2) {
        return;
    }
    [delegate productViewClicked:mOrder];
}
-(void)PushDetailOrderNotification
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"kGetDetailOrder" object:self.mOrder userInfo:nil];
}
-(IBAction)PushOrderTrackNotification
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"kGetOrderTrack" object:self.mOrder userInfo:nil];
}
-(IBAction)cancelButtonClicked:(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"取消订单提示" message:@"确定要取消该订单吗？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alert setTag:ALERTVIEW_TAG_CANCEL_ORDER_CONFIRM];
	[alert show];
	[alert release];
}

-(IBAction)GotoPayClicked:(id)sender
{
    [self.delegate payclicked:mOrder];
}

//再次放入购物车
-(IBAction)AddToCartClicked:(id)sender
{
    [self.delegate addtoCart:mOrder];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch ([alertView tag]) {
        case ALERTVIEW_TAG_CANCEL_ORDER_CONFIRM: {
            if (buttonIndex==1) {
                if ([self.delegate respondsToSelector:@selector(cancelOrder:)]) {
                    [self.delegate performSelector:@selector(cancelOrder:) withObject:self.mOrder];
                }
            }
            break;
        }
        default:
            break;
    }
}

-(void)dealloc
{
    [mOrder release];
    [mlabel release];
    [_payButton release];
    
    [super dealloc];
}

@end