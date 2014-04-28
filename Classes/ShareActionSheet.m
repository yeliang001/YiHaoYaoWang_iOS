//
//  ShareActionSheet.m
//  TheStoreApp
//
//  Created by jiming huang on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#define SHARE_ACTION_SHEET_TAG          100
#define SHARE_SMS_ALERT_VIEW_TAG        101

#define TO_JIEPANG_FROM_PRODUCTDETAIL   0

#import "ShareActionSheet.h"
#import "GlobalValue.h"
#import "UIDeviceHardware.h"
#import "ShareToMicroBlog.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "JiePang.h"
#import "ProductVO.h"
#import "OTSAlertView.h"
#import "OTSActionSheet.h"
#import "TheStoreAppAppDelegate.h"

@implementation ShareActionSheet

#pragma mark 显示按钮sheet
-(void)shareProduct:(NSString *)productName price:(NSNumber *)productPrice productId:(NSNumber *)productId provinceId:(NSNumber *)provinceId  isExclusive:(BOOL)isExclusive{
    m_ProductName=[productName retain];
    m_ProductPrice=[productPrice retain];
    m_ProductId=[productId retain];
    m_ProvinceId=[provinceId retain];
    m_IsExclusive=isExclusive;
	UIActionSheet * sheet = [[OTSActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享到新浪微博",@"分享到街旁",@"短信转发", nil];
    [sheet setTag:SHARE_ACTION_SHEET_TAG];
	[sheet showInView:[UIApplication sharedApplication].keyWindow];
	[sheet release];
}

#pragma mark 分享微博
-(void)doShareBLOG {
    [[GlobalValue getGlobalValueInstance].mbService setIsFromGroupon:YES];
    [[GlobalValue getGlobalValueInstance].mbService setIsExclusive:m_IsExclusive];
	[[GlobalValue getGlobalValueInstance].mbService shareProduct:m_ProductName 
                                                           price:[m_ProductPrice description]
                                                       productId:[m_ProductId description]
                                                        blogType:ShareToSina];
    [[GlobalValue getGlobalValueInstance].mbService setIsFromGroupon:NO];
}

#pragma mark 分享短信
-(void)doShareSMS {
	// 创建设备对象
	UIDeviceHardware * hardware = [[UIDeviceHardware alloc] init];
	// 判断设备是否iphone
	/* if (!([[hardware platformString] isEqualToString:@"iPhone 1G"] || 
     [[hardware platformString] isEqualToString:@"iPhone 3G"] || 
     [[hardware platformString] isEqualToString:@"iPhone 3GS"] || 
     [[hardware platformString] isEqualToString:@"iPhone 4"] || 
     [[hardware platformString] isEqualToString:@"Verizon iPhone 4"])) */
    NSRange range = [[hardware platformString] rangeOfString:@"iPhone"];
    if (range.length <= 0)  {// 不是iphone提示用户
		UIAlertView *alert=[[OTSAlertView alloc] initWithTitle:nil 
													  message:@"您的设备不支持此项功能,感谢您对1号药店的支持!"
													 delegate:self 
											cancelButtonTitle:nil 
											otherButtonTitles:@"确定",nil];
		alert.tag=100;
		[alert show];
		[alert release];
	} else {// 是iphone调用短消息
		/*[[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:YES];
		UIAlertView *alert=[[OTSAlertView alloc] initWithTitle:@"短信分享" 
													  message:@"商品信息已复制，请在短信页面粘贴发送。" 
													 delegate:self 
											cancelButtonTitle:@"取消" 
											otherButtonTitles:@"确定",nil];
		alert.tag=SHARE_SMS_ALERT_VIEW_TAG;
		[alert show];
		[alert release];
		alert=nil;
		UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];//获得系统粘贴板
		NSString *content = [NSString stringWithFormat:@"1号店热卖团购：%@ 我觉得很不错，你也去看看吧 http://www.yihaodian.com/tuangou/index.do?grouponId=%@", m_ProductName, m_ProductId];
        if (m_IsExclusive) {
            content = [NSString stringWithFormat:@"1号店专享团购：%@ 更多精彩团购尽在1号店：http://m.yihaodian.com/qrcode.action", m_ProductName];
        }
		
		NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys: content, @"public.utf8-plain-text", 
							  [NSURL URLWithString:content], (NSString *)kUTTypeURL,nil];  			
		pasteboard.items = [NSArray arrayWithObject:item];*/
		NSString *content = [NSString stringWithFormat:@"1号药店热卖团购：%@ 我觉得很不错，你也去看看吧 http://www.yihaodian.com/tuangou/index.do?grouponId=%@", m_ProductName, m_ProductId];
        if (m_IsExclusive) {
            content = [NSString stringWithFormat:@"1号药店专享团购：%@ 更多精彩团购尽在1号药店：http://m.yihaodian.com/qrcode.action", m_ProductName];
        }
		MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
		controller.body = content;
		controller.messageComposeDelegate = self;
		[SharedDelegate.tabbarMaskVC presentModalViewController:controller animated:YES];
	}
	[hardware release];
}
//messagecomposeviewcontroller的delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	[controller dismissModalViewControllerAnimated:NO];//关键的一句   不能为YES
	switch ( result ) {
		case MessageComposeResultCancelled:
        {
			//click cancel button
		}
			break;
		case MessageComposeResultFailed:// send failed
            
			break;
		case MessageComposeResultSent:
		{
			//click send button
		}
			break;
		default:
			break;
	}
}

#pragma mark 分享街旁
-(void)doShareJiePang {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toNextView) name:@"toNextViewFromProductDetail" object:nil];
	[[GlobalValue getGlobalValueInstance].mbService shareProduct:m_ProductName 
														   price:[m_ProductPrice description]
                                                       productId:[m_ProductId description]
														blogType:ShareToJiePang];
}

#pragma mark  进入jiepang 
-(void)doEnterJiePang
{
    ProductVO *product=[[[ProductVO alloc] init] autorelease];
    [product setCnName:m_ProductName];
    [product setPrice:m_ProductPrice];
    [product setProductId:m_ProductId];
    [SharedDelegate enterJiePangWithProductVO:product isExclusive:m_IsExclusive];
}


#pragma mark 街旁登录成功后跳转至下一个页面
-(void)toNextView{
	NSNumber * tempNumber = [[NSNumber alloc] initWithInt:TO_JIEPANG_FROM_PRODUCTDETAIL];
	[[GlobalValue getGlobalValueInstance] setToJiePangFromPage:tempNumber];
	[tempNumber release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"toNextViewFromProductDetail" object:nil];
    [self performSelectorOnMainThread:@selector(doEnterJiePang) withObject:nil waitUntilDone:YES];
}

#pragma mark 设置按钮sheet操作
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if ([actionSheet tag]==SHARE_ACTION_SHEET_TAG) {
        switch (buttonIndex) {
                // 分享到新浪微博
            case 0:
                [self doShareBLOG];
                break;
                // 分享到街旁
            case 1:
                [self doShareJiePang];
                break;
            case 2:
                // 短信转发
                [self doShareSMS];
                break;
            default:
                break;
        }
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	if(alertView.tag==SHARE_SMS_ALERT_VIEW_TAG){//调用短信接口
		if (buttonIndex==1) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms:// "]];
		}
	}
    [[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:NO];
}

-(void)dealloc
{
    if (m_ProductName!=nil) {
        [m_ProductName release];
        m_ProductName=nil;
    }
    if (m_ProductPrice!=nil) {
        [m_ProductPrice release];
        m_ProductPrice=nil;
    }
    if (m_ProductId!=nil) {
        [m_ProductId release];
        m_ProductId=nil;
    }
    if (m_ProvinceId!=nil) {
        [m_ProvinceId release];
        m_ProvinceId=nil;
    }
    if (m_JiePang!=nil) {
        [m_JiePang release];
        m_JiePang=nil;
    }
    [super dealloc];
}
@end
