//
//  OTSViewControllerManager.h
//  TheStoreApp
//
//  Created by yiming dong on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTSBaseViewController.h"

@interface OTSViewControllerManager : NSObject
{
    NSMutableArray      *controllers;
}
@property(nonatomic,retain)NSMutableArray      *controllers;
+ (OTSViewControllerManager *)sharedInstance;
-(void)removeVCAutoreleased:(UIViewController*)aViewController;
-(void)registerController:(UIViewController*)aViewController;
-(void)unregisterController:(UIViewController*)aViewController;
-(void)unregisterControllerWithView:(UIView*)aRootView;

-(OTSBaseViewController*)controllerForView:(UIView*)aView;      // 根据root view查找对应的vc

-(void)cleanUp;     // 清理不在view层次结构中的vc

@end
