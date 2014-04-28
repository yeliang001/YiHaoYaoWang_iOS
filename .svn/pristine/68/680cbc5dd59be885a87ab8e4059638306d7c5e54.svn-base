//
//  UIScrollView+OTS.m
//  TheStoreApp
//
//  Created by yiming dong on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIScrollView+OTS.h"

@implementation UIScrollView (OTS)


-(void)disableScrollToTopOfView:(UIView*)aSuperView
{
    for (UIView* subView in aSuperView.subviews)
    {
        if ([subView isKindOfClass:[UIScrollView class]])
        {
            ((UIScrollView*)subView).scrollsToTop = NO;
        }
        
        [self disableScrollToTopOfView:subView];
    }
}

-(void)ScrollMeToTopOnly
{
    UIView* superView = self;
    while (superView.superview) 
    {
        superView = superView.superview;
    }
    
    [self disableScrollToTopOfView:superView];
    self.scrollsToTop = YES;
}

@end
