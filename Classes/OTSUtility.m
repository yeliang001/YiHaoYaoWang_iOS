//
//  OTSUtility.m
//  TheStoreApp
//
//  Created by yiming dong on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSUtility.h"
#import "DataController.h"
#import "UIDeviceHardware.h"
#import "GlobalValue.h"
#import "ProductVO.h"
#import "OTSServiceHelper.h"
#import "CmsPageVO.h"
#import "PayService.h"
#import "OrderService.h"
#import "OTSAlertView.h"
#import <MessageUI/MessageUI.h>
#import "UserManage.h"
#import "TheStoreAppAppDelegate.h"
#import "Reachability.h"

@implementation OTSUtility


+(NSString*)documentDirectoryWithFileName:(NSString*)name
{
    NSArray* arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* path = [arr objectAtIndex:0];
    NSString* file = [path stringByAppendingPathComponent:name];
    return file;
}
+(id)safeObjectAtIndex:(int)aIndex inArray:(NSArray*)anArray
{
    if (anArray && aIndex >=0 && aIndex < [anArray count])
    {
        return [anArray objectAtIndex:aIndex];
    }
    
    return nil;
}


//缓存page
+(void)putPagesToLocal:(Page*)aPage withPageName:(NSString *)name withKey:(NSString *)key
{
    NSString *  filePath = [NSString stringWithFormat:@"%@_%@.plist",name,key];
    NSString *fileName=[self documentDirectoryWithFileName:filePath];
    NSData* pageData = [NSKeyedArchiver archivedDataWithRootObject:aPage];
    [pageData writeToFile:fileName atomically:NO];
}

+(Page*)getPagesFromLocal:(NSString *)name withKey:(NSString *)key
{
    NSString *  filePath = [NSString stringWithFormat:@"%@_%@.plist",name,key];
    NSString *fileName=[self documentDirectoryWithFileName:filePath];
    Page* aPage = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    return aPage;
}

//删除文件
//NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//NSString *path=[paths    objectAtIndex:0];
//NSString *filename=[path stringByAppendingPathComponent:@"personal.plist"];
//DeleteSingleFile(filename);
+(BOOL)DeleteSingleFile:(NSString *) filePath{
    NSError *err = nil;
    
    if (nil == filePath) {
        return NO;
    }
    
    NSFileManager *appFileManager = [NSFileManager defaultManager];
    
    if (![appFileManager fileExistsAtPath:filePath]) {
        return YES;
    }
    
    if (![appFileManager isDeletableFileAtPath:filePath]) {
        return NO;
    }
    
    return [appFileManager removeItemAtPath:filePath error:&err];
}


+(UIImage*)getMiniImageWithProductId:(NSNumber*)aProductId
{
    if (aProductId)
    {
        NSString *fileName = [NSString stringWithFormat:@"mini_%@",aProductId];
        NSData *data = [DataController applicationDataFromFile:fileName];
        if (data) 
        {
            return [UIImage imageWithData:data];
        }
    }
    
    return [UIImage imageNamed:OTS_DEFAULT_PRODUCT_IMG];
}


+(NSDate *)NSStringDateToNSDate:(NSString *)anString{ 
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    NSDate *date = [dateFormatter dateFromString:anString];
    
    [dateFormatter release];
    
    return date;
}

+(NSString *)NSDateToNSStringDate:(NSDate *)anDate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //#towne 对于格式 2013-01-19 23:59:59 截取成 2013－01－19 并且这里需要做时区的判定
    NSDate *date = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    anDate= [anDate  dateByAddingTimeInterval: -interval];
    
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    NSString *anString = [dateFormatter stringFromDate:anDate];
    
    anString = [anString substringToIndex:10];
    
    [dateFormatter release];
    
    return anString;
}

+(NSString *)NSDateToNSStringDateV2:(NSDate *)anDate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //#towne 对于格式 2013-01-19 23:59:59 截取成 2013－01－19 并且这里需要做时区的判定
    NSDate *date = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    anDate= [anDate  dateByAddingTimeInterval: -interval];
    
    [dateFormatter setDateFormat:@"yyyy_MM_dd HH:mm:ss"];
    
    NSString *anString = [dateFormatter stringFromDate:anDate];
    
    anString = [anString substringToIndex:10];
    
    [dateFormatter release];
    
    return anString;
}

+(void)callWithPhoneNumber:(NSString*)aPhoneNumber
{
    if (aPhoneNumber && [aPhoneNumber length] > 0)
    {
        UIDeviceHardware *hardware = [[[UIDeviceHardware alloc] init] autorelease];
        //判断设备是否iphone
        /* if (!([[hardware platformString] isEqualToString:@"iPhone 1G"] || 
         [[hardware platformString] isEqualToString:@"iPhone 3G"] || 
         [[hardware platformString] isEqualToString:@"iPhone 3GS"] || 
         [[hardware platformString] isEqualToString:@"iPhone 4"] || 
         [[hardware platformString] isEqualToString:@"Verizon iPhone 4"])) */
        NSRange range = [[hardware platformString] rangeOfString:@"iPhone"];
        if (range.length <= 0) 
        {
            [[GlobalValue getGlobalValueInstance] setHaveAlertViewInShow:YES];
            UIAlertView* av = [[[UIAlertView alloc] initWithTitle:nil message:@"您的设备不支持此项功能,感谢您对1号药网的支持!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
            [av show];
        } 
        else 
        {
            aPhoneNumber = [aPhoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString* urlStr = [NSString stringWithFormat:@"tel://%@", aPhoneNumber];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
    }
}



+(NSString*)chineseForDigit:(int)aDigit
{
    switch (aDigit) 
    {
        case 0:
        {
            return @"零";
        }
            break;
            
        case 1:
        {
            return @"一";
        }
            break;
            
        case 2:
        {
            return @"二";
        }
            break;
            
        case 3:
        {
            return @"三";
        }
            break;
            
        case 4:
        {
            return @"四";
        }
            break;
            
        case 5:
        {
            return @"五";
        }
            break;
            
        case 6:
        {
            return @"六";
        }
            break;
            
        case 7:
        {
            return @"七";
        }
            break;
            
        case 8:
        {
            return @"八";
        }
            break;
            
        case 9:
        {
            return @"九";
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

+(void)logRect:(CGRect)aRect
{
    DebugLog(@"<Rectagle at point:(%f, %f), width:%f, height:%f", aRect.origin.x, aRect.origin.y, aRect.size.width, aRect.size.height);
}


+(CGRect)modifyRect:(CGRect)aRect value:(float)aValue modifyType:(int)aType
{
    switch (aType)
    {
        case KOtsRectModifyX:
            aRect.origin.x = aValue;
            break;
            
        case KOtsRectModifyY:
            aRect.origin.x = aValue;
            break;
            
        case KOtsRectModifyWidth:
            aRect.size.width = aValue;
            break;
            
        case KOtsRectModifyHeight:
            aRect.size.height = aValue;
            break;
            
        default:
            break;
    }
    
    return aRect;
}

+(UIImage*)miniImageForProduct:(ProductVO*)aProduct
{
    if (aProduct)
    {
        UIImage *image = nil;
        NSString *fileName = [NSString stringWithFormat:@"mini_%@",aProduct.productId];
        NSData *data = [DataController applicationDataFromFile:fileName];
        
        if (data) 
        {
            image = [UIImage imageWithData:data];
        } 
        else 
        {
            NSData *netData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[aProduct miniDefaultProductUrl]]];
            if (netData) 
            {
                image = [UIImage imageWithData:netData];
                [DataController writeApplicationData:netData name:fileName];
            } 
            else 
            {
                image = [UIImage imageNamed:@"defaultimg55.png"];
            }
        }
        
        return image;
    }
    
    return nil;
}

+(BOOL)canBuyProduct:(ProductVO*)aProduct
{
    return [aProduct.canBuy isEqualToString:@"true"];
}

// 设置视图的阴影
+(void)setShadowForView:(UIView*)aView
{
    if (aView)
    {
        if ([aView isKindOfClass:[UILabel class]]) 
        {
            ((UILabel*)aView).shadowColor = [UIColor blackColor];
            ((UILabel*)aView).shadowOffset = CGSizeMake(1, -1);
        }
        else
        {
            aView.layer.shadowColor = [UIColor blackColor].CGColor;
            aView.layer.shadowOffset = CGSizeMake(1, -1);
            aView.layer.shadowRadius = 1;
            aView.layer.shadowOpacity = 1;
        }
    }
}

+(void)setCornerRadius:(int)aCornerRadius borderColor:(UIColor*)aBorderColor forView:(UIView*)aView
{
    if (aView)
    {
        aView.layer.cornerRadius = aCornerRadius;
        aView.layer.borderWidth = 1;
        aView.layer.borderColor = aBorderColor.CGColor;
    }
}

+(void)horizontalCenterViews:(NSArray*)aViews inView:(UIView*)aSuperView margin:(NSUInteger)aMargin
{
    if (aSuperView && aViews && [aViews count] > 0) 
    {
        int totalLen = 0;
        for (UIView* view in aViews)
        {
            totalLen += view.frame.size.width + aMargin;
        }
        totalLen -= aMargin;
        
        int startX = (aSuperView.frame.size.width - totalLen) / 2;
        
        for (int i = 0; i < [aViews count]; i++)
        {
            UIView* view = [aViews objectAtIndex:i];
            
            if (i > 0)
            {
                startX = CGRectGetMaxX(((UIView*)[aViews objectAtIndex:i - 1]).frame) + aMargin;
            }
            
            view.frame = CGRectMake(startX
                                    , view.frame.origin.y
                                    , view.frame.size.width
                                    , view.frame.size.height);
        }
    }
}

#pragma mark - 
+(void)testiPadInterface
{
    // 20120801095059
    // 20120801161522
    Page *page = nil;
    
    page = [[OTSServiceHelper sharedInstance] getCmsPageList:[GlobalValue getGlobalValueInstance].trader
                                                  provinceId:[NSNumber numberWithInt:1]  
                                                  activityId:[NSNumber numberWithLongLong: 20120801161522] currentPage:[NSNumber numberWithInt:1] 
                                                    pageSize:[NSNumber numberWithInt:50]];
    
    DebugLog(@"%@", page.objList);
    
    if (page.objList && [page.objList count] > 0)
    {
        CmsPageVO* cmsPage = [page.objList objectAtIndex:0];
        page = [[OTSServiceHelper sharedInstance] getCmsColumnList:[GlobalValue getGlobalValueInstance].trader 
                                                        provinceId:[NSNumber numberWithInt:1] 
                                                         cmsPageId:cmsPage.nid 
                                                              type:cmsPage.type 
                                                       currentPage:[NSNumber numberWithInt:1] pageSize:[NSNumber numberWithInt:50]];
        DebugLog(@"%@", page.objList);
    }
    
    
    //    page = [[OTSServiceHelper sharedInstance] getHotProductByActivityID:[GlobalValue getGlobalValueInstance].trader 
    //                                                             activityID:[NSNumber numberWithLongLong: 20120801095059]
    //                                                             provinceId:[NSNumber numberWithInt:1] 
    //                                                            currentPage:[NSNumber numberWithInt:1] 
    //                                                               pageSize:[NSNumber numberWithInt:50]];
    
    DebugLog(@"%@", page.objList);
}

// this method is recommended to be called in sub thread
+(NSArray*)requestBanks
{
    return nil;
    
    NSArray* banks = [GlobalValue getGlobalValueInstance].bankVOList;
    
    if (banks == nil)
    {
        PayService* service = [[[PayService alloc] init] autorelease];
        Page* page = [service getBankVOList:[GlobalValue getGlobalValueInstance].trader
                                       name:@"" type:[NSNumber numberWithInt:-1]
                                currentPage:[NSNumber numberWithInt:1]
                                   pageSize:[NSNumber numberWithInt:20]];
        banks = page.objList;
        [GlobalValue getGlobalValueInstance].bankVOList = banks;
    }
    
    return banks;
}

//银联支付签名
+(NSString*)requestSignature:(NSNumber*)aOnlineorderid
{
    NSString * str = @"";
    NSString * token=[[GlobalValue getGlobalValueInstance] token];
    NSString * orderid = [aOnlineorderid stringValue];
    OrderService * _orderService = [[[OrderService alloc]init] autorelease];
    //-------------取签名
    int timeout = 0;
    do {
        str = [_orderService CUPSignature:token orderId:orderid];
        sleep(0.1);
        timeout++;
    } while (!str&&timeout<10);
    return  str;
}

//支付宝快捷支付签名
+(NSString *)requestAliPaySignature:(NSNumber*)aOnlineorderid
{
    NSString * str = @"";
    NSString * token=[[GlobalValue getGlobalValueInstance] token];
    NSString * orderId = [aOnlineorderid stringValue];
    OrderService * _orderService = [[[OrderService alloc]init] autorelease];
    //-------------取签名
    int timeout = 0;
    do {
        str = [_orderService aliPaySignature:token orderId:orderId];
        sleep(0.1);
        timeout++;
    } while (!str&&timeout<10);
    return  str;
}

#pragma mark -
#pragma mark 显示提示框

+(void)alert:(NSString*)aMessage
{
    UIAlertView * alert = [[OTSAlertView alloc]initWithTitle:@""
                                                     message:aMessage
                                                    delegate:nil
                                           cancelButtonTitle:@"确认"
                                           otherButtonTitles:nil];
    alert.tag = 0;
	[alert show];
	[alert release];
}

+(void)alertWhenDebug:(NSString*)aMessage
{
#ifdef DEBUG
    [self alert:aMessage];
#endif
}

+(void)showAlertView:(NSString *) alertTitle
            alertMsg:(NSString *)alertMsg
            alertTag:(int)tag
{
    UIAlertView * alert = [[OTSAlertView alloc]initWithTitle:alertTitle message:alertMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
    alert.tag = tag;
	[alert show];
	[alert release];
}


#pragma mark -
+(void)threadRequestSaveGateWay:(BankVO*)aBankVO forOrder:(OrderV2*)anOrder
{
    BankVO *bankVO = [[aBankVO retain] autorelease];
    if (anOrder)
    {
        if ([anOrder isGroupBuyOrder])
        {
            // change group buy order bank
            
            int resultFlag = [[OTSServiceHelper sharedInstance] saveGateWayToGrouponOrder:[GlobalValue getGlobalValueInstance].token
                                                                                  orderId:anOrder.orderId
                                                                                gatewayId:bankVO.gateway];
            if (resultFlag == 1)
            {
                DebugLog(@"gateway saved OK: %d, bankName:%@", [bankVO.gateway intValue], bankVO.bankname);
                anOrder.gateway = bankVO.gateway;
            }
            else
            {
                UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"保存支付方式失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
                
                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
            }
        }
        else
        {
            // change normal order bank
            
            SaveGateWayToOrderResult *result = [[OTSServiceHelper sharedInstance] saveGateWayToOrder:[GlobalValue getGlobalValueInstance].token
                                                                                             orderId:anOrder.orderId
                                                                                           gateWayId:bankVO.gateway];
            
            if (result && ![result isKindOfClass:[NSNull class]])
            {
                if ([result.resultCode intValue] == 1)
                {
                    DebugLog(@"gateway saved OK: %d, bankName:%@", [bankVO.gateway intValue], bankVO.bankname);
                    anOrder.gateway = bankVO.gateway;
                }
                else
                {
                    [self performSelectorOnMainThread:@selector(showError:) withObject:[result errorInfo] waitUntilDone:NO];
                }
                
            }
            else
            {
                [self performSelectorOnMainThread:@selector(showError:) withObject:@"网络异常，请检查网络配置..." waitUntilDone:NO];
            }
        }
    }
}

+(void)showError:(NSString *)error
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}


+(NSString*)timeStringFromInterval:(int)aInterval
{
    int hours = aInterval / (60 * 60);
    aInterval -= hours * (60 * 60);
    int minutes = aInterval / 60;
    aInterval -= minutes * 60;
    int seconds =  aInterval % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

+(BOOL)hasNetwork
{
//    Reachability *r = [Reachability reachabilityWithHostName:@"interface.m.yihaodian.com"];
//    int status = [r currentReachabilityStatus];
//    DebugLog(@"network status: %d", status);
//    return status != kNotReachable;
    return YES;
}

+(NSString*)getInterfaceNameFromSelector:(SEL)aSelector
{
    if (aSelector)
    {
        NSString *selStr = NSStringFromSelector(aSelector);
        NSRange range = [NSStringFromSelector(aSelector) rangeOfString:@":" options:NSLiteralSearch];
        if (range.location != NSNotFound)
        {
            NSString *retStr = [selStr substringToIndex:range.location];
            return retStr;
        }
    }
    
    return nil;
}

@end
