//
//  OtspCordinatorController.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-9-12.
//
//  DESCRIPTION: 用于协调UI切换的中介者(mediator)

#import <Foundation/Foundation.h>

typedef enum
{
    OtspUIChangeMain = 0            // 首页
    , OtspUIChangeMyStore           // 我的1好店
    , OtspUIChangeShoppingCart      // 购物车
    , OtspUIChangeReturn            // 返回
}OtspUIChangeType;

@interface OtspCordinatorController : NSObject

+ (OtspCordinatorController *)sharedInstance;

-(void)changeUIWithObject:(id)sender;
@end

#warning still under construction...dym
