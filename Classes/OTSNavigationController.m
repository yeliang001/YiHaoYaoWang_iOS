//
//  OTSNavigationController.m
//  TheStoreApp
//
//  Created by yiming dong on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSNavigationController.h"

@implementation OTSNavigationController

-(id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self)
    {
        self.navigationBarHidden = YES;
    }
    
    return self;
}

-(UIViewController*)getRootVC
{
    return [self.viewControllers objectAtIndex:0];
}

#pragma mark -
- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:[self getRootVC]];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector 
{
    return [[[self getRootVC] class] instanceMethodSignatureForSelector:aSelector];
}
@end
