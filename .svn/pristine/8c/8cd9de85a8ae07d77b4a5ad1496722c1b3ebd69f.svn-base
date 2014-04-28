//
//  OTSUtility.h
//  TheStoreApp
//
//  Created by yiming dong on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProductVO;
@class BankVO;
@class OrderV2;
@class Page;

@interface OTSUtility : NSObject

// date
+(NSDate *)NSStringDateToNSDate:(NSString *)anString;
+(NSString *)NSDateToNSStringDate:(NSDate *)anDate;
+(NSString *)NSDateToNSStringDateV2:(NSDate *)anDate;

// rect
+(void)logRect:(CGRect)aRect;
+(CGRect)modifyRect:(CGRect)aRect value:(float)aValue modifyType:(int)aType;

// product
+(UIImage*)miniImageForProduct:(ProductVO*)aProduct;
+(BOOL)canBuyProduct:(ProductVO*)aProduct;
+(UIImage*)getMiniImageWithProductId:(NSNumber*)aProductId;

// UIView
+(void)setShadowForView:(UIView*)aView;
+(void)setCornerRadius:(int)aCornerRadius borderColor:(UIColor*)aBorderColor forView:(UIView*)aView;
+(void)horizontalCenterViews:(NSArray*)aViews inView:(UIView*)aSuperView margin:(NSUInteger)aMargin;

// other
+(id)safeObjectAtIndex:(int)aIndex inArray:(NSArray*)anArray;
+(void)callWithPhoneNumber:(NSString*)aPhoneNumber;
+(NSString*)chineseForDigit:(int)aDigit;
+(NSString*)documentDirectoryWithFileName:(NSString*)name;

// test
+(void)testiPadInterface;

// runtime data
+(NSArray*)requestBanks;

// return Signature
+(NSString*)requestSignature:(NSNumber*)aOnlineorderid;
+(NSString *)requestAliPaySignature:(NSNumber *)aOnlineorderid;

+(void)alert:(NSString*)aMessage;
+(void)alertWhenDebug:(NSString*)aMessage;
+(void)showAlertView:(NSString *) alertTitle
            alertMsg:(NSString *)alertMsg
            alertTag:(int)tag;

+(NSString*)timeStringFromInterval:(int)aInterval;
+(BOOL)hasNetwork;

+(void)threadRequestSaveGateWay:(BankVO*)aBankVO forOrder:(OrderV2*)anOrder;
+(NSString*)getInterfaceNameFromSelector:(SEL)aSelector;

//缓存page
+(void)putPagesToLocal:(Page*)aPage withPageName:(NSString *)name withKey:(NSString *)key;
+(Page*)getPagesFromLocal:(NSString *)name withKey:(NSString *)key;

@end


enum _EOtsRectModifyType
{
    KOtsRectModifyX = 0
    , KOtsRectModifyY
    , KOtsRectModifyWidth
    , KOtsRectModifyHeight
};