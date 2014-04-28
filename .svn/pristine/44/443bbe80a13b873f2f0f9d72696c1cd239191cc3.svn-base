//
//  UIView+VCManage.m
//  TheStoreApp
//
//  Created by yiming dong on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIView+VCManage.h"

#import "OTSViewControllerManager.h"
#import "OTSBaseViewController.h"

@implementation UIView (VCManage)
-(void)removeSubControllerClass:(Class)aViewControllerClass
{
    int theTag = [OTSBaseViewController tagForRootViewByClass:aViewControllerClass];
    
    UIView* theView = [self viewWithTag:theTag];
    
    if (theView && theView != self)
    {
        OTSBaseViewController* ctrl = [[OTSViewControllerManager sharedInstance] controllerForView:theView];
        if (ctrl)
        {
            [ctrl removeSelf];
        }
    }
}

//-(void)removeAllSubViewForVC:(Class)aViewControllerClass
//{
//    DebugLog(@"removeAllSubViewForVC:%@", [aViewControllerClass description]);
//    
//    int theTag = [OTSBaseViewController tagForRootViewByClass:aViewControllerClass];
//    
//    UIView* theView = [self viewWithTag:theTag];
//    
//    DebugLog(@"found view:%@, tag:%d", theView, theTag);
//    if (theView)
//    {
//        
//        OTSBaseViewController* ctrl = [[OTSViewControllerManager sharedInstance] viewControllerForView:theView];
//        if (ctrl)
//        {
//            [ctrl removeSelf];
//        }
//    }
//}
@end
