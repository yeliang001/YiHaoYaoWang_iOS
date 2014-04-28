//
//  OTSUtility.h
//  TheStoreApp
//
//  Created by yiming dong on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProductVO;

@interface OTSUtility : NSObject

// date
+(NSDate *)NSStringDateToNSDate:(NSString *)anString;
+(NSString *)NSDateToNSStringDate:(NSDate *)anDate;

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

// other
+(id)safeObjectAtIndex:(int)aIndex inArray:(NSArray*)anArray;
+(void)callWithPhoneNumber:(NSString*)aPhoneNumber;
+(NSString*)chineseForDigit:(int)aDigit;

// test
+(void)testiPadInterface;

@end


enum _EOtsRectModifyType
{
    KOtsRectModifyX = 0
    , KOtsRectModifyY
    , KOtsRectModifyWidth
    , KOtsRectModifyHeight
};