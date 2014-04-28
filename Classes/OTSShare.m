//
//  OTSShare.m
//  TheStoreApp
//
//  Created by jiming huang on 12-11-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSShare.h"
#import "ProductVO.h"
#import "GlobalValue.h"
#import "ShareToMicroBlog.h"
#import "OTSAlertView.h"
#import "TheStoreAppAppDelegate.h"
#import "ProductInfo.h"



@implementation OTSShare

#pragma mark - 分享到微博
-(void)shareToBlogWithProduct:(ProductInfo *)productVO delegate:(id)delegate
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toMyOrderViewAfterWeiboShare) name:@"toMyOrderViewAfterWeiboShare" object:nil];
    [[GlobalValue getGlobalValueInstance].mbService shareProduct:productVO.name price:[NSString stringWithFormat:@"%@",productVO.price] productId:[NSString stringWithFormat:@"%@",productVO.productId] blogType:ShareToSina];
}

-(void)shareToBlogWithString:(NSString *)string delegate:(id)delegate
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toMyOrderViewAfterWeiboShare) name:@"toMyOrderViewAfterWeiboShare" object:nil];
    [[GlobalValue getGlobalValueInstance].mbService shareString:string blogType:ShareToSina];
}

//微博分享成功后执行界面跳转
-(void)toMyOrderViewAfterWeiboShare {
	static int i=-1;
	i++;
	while(i>=0){
		[[NSNotificationCenter defaultCenter] removeObserver:self name:@"toMyOrderViewAfterWeiboShare" object:nil];
		i--;
		if(i==-1){
            UIAlertView *alert=[[OTSAlertView alloc] initWithTitle:nil 
                                                           message:@"分享新浪微博成功!"
                                                          delegate:self 
                                                 cancelButtonTitle:nil 
                                                 otherButtonTitles:@"确定",nil];
            [alert show];
            [alert release];
		}
	}
}

#pragma mark - 分享到街旁
-(void)shareToJiePangWithProduct:(ProductVO *)productVO delegate:(id)delegate
{
    if (m_ProductVO!=nil) {
        [m_ProductVO release];
    }
    m_ProductVO=[productVO retain];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toNextView) name:@"toNextViewFromProductDetail" object:nil];
	[[GlobalValue getGlobalValueInstance].mbService shareProduct:productVO.cnName price:[NSString stringWithFormat:@"%@",productVO.price] productId:[NSString stringWithFormat:@"%@",productVO.productId] blogType:ShareToJiePang];
}

-(void)toNextView {
	NSNumber * tempNumber = [[NSNumber alloc] initWithInt:0];
    [[GlobalValue getGlobalValueInstance] setToJiePangFromPage:tempNumber];
    [tempNumber release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"toNextViewFromProductDetail" object:nil];
    [self performSelectorOnMainThread:@selector(doEnterJiePang) withObject:nil waitUntilDone:NO];
}

-(void)doEnterJiePang
{
    [SharedDelegate enterJiePangWithProductVO:m_ProductVO isExclusive:NO];
}

#pragma mark - 短信分享
-(void)shareToMessageWithProduct:(ProductInfo *)productVO delegate:(id)delegate
{
    UIDeviceHardware *hardware=[[UIDeviceHardware alloc] init];
    NSRange range = [[hardware platformString] rangeOfString:@"iPhone"];
    if (range.length <= 0) {
        UIAlertView *alert=[[OTSAlertView alloc] initWithTitle:nil 
                                                       message:@"您的设备不支持此项功能,感谢您对1号药店的支持!"
                                                      delegate:self 
                                             cancelButtonTitle:nil 
                                             otherButtonTitles:@"确定",nil];
		alert.tag=100;
		[alert show];
		[alert release];
	}
    else
    {
        
        NSString *msg = [NSString stringWithFormat:@"我在1号药店发现了%@,只要%@元，快来抢购吧！http://111.com.cn 手机购药更优惠!", productVO.name,productVO.price];
        
//		NSString *name=[NSString stringWithFormat:@"%@",productVO.name];
//		NSString *price=[NSString stringWithFormat:@"%@",productVO.price];
//		NSString *theProductId=[NSString stringWithFormat:@"%@",productVO.productId];
		MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
//		NSString *content=[NSString stringWithFormat:@"我在1号药店发现了%@,只要%@元，快来抢购吧！http://111.com.cn 手机购药更优惠!", name, price, theProductId, [GlobalValue getGlobalValueInstance].provinceId];
		controller.body = msg;
		controller.messageComposeDelegate=self;
		[delegate presentModalViewController:controller animated:YES];
	}
	[hardware release];
}

#pragma mark - MFMessageComposeViewController相关delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	[controller dismissModalViewControllerAnimated:NO];//关键的一句 不能为YES
	switch (result) {
		case MessageComposeResultCancelled: {
			//click cancel button
            break;
		}
		case MessageComposeResultFailed: {// send failed
			break;
        }
		case MessageComposeResultSent: {
			//click send button
            break;
		}
		default:
			break;
	}
}

#pragma mark - singleton methods
static OTSShare *sharedInstance = nil;

+ (OTSShare *)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [[self alloc] init];
        }
    }
    
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release
{
}

- (id)autorelease
{
    return self;
}

-(void)dealloc
{
    OTS_SAFE_RELEASE(m_ProductVO);
    [super dealloc];
}
@end
