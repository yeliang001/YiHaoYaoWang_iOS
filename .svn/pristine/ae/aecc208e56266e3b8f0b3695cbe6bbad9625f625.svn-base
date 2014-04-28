//
//  OTSViewControllerManager.m
//  TheStoreApp
//
//  Created by yiming dong on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSViewControllerManager.h"
#import "OTSUtility.h"

@interface OTSViewControllerManager ()

@end

@implementation OTSViewControllerManager
@synthesize controllers;
-(void)removeVCAutoreleased:(UIViewController*)aViewController
{
    if (aViewController.view && aViewController.view.superview)
    {
        [aViewController.view removeFromSuperview]; // 避免view被其他对象retain，再次释放的问题
    }
    
    [[aViewController retain] autorelease]; // 延迟释放
    [controllers removeObject:aViewController];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:OTS_VC_REMOVED object:aViewController];
}

-(void)cleanUpForced:(BOOL)aForceClean
{
    int count = [controllers count];
    if (aForceClean || count > 10)
    {
        for (int i = count - 1; i >= 0; i--)
        {
            UIViewController* ctrl = [controllers objectAtIndex:i];
            //ISSUE #4815 -[NSPathStore2 view]: unrecognized selector sent to instance 0x6f0fc0
            if ([ctrl isKindOfClass:[UIViewController class]] && ctrl.view.superview == nil)
            {
                //[controllers removeObject:ctrl];
                [self removeVCAutoreleased:ctrl];
            }
        }
    }
}

-(void)cleanUp
{
    [self cleanUpForced:YES];
}

-(BOOL)hasViewController:(UIViewController*)aViewController
{
    if (aViewController == nil)
    {
        return NO;
    }
    
    for (UIViewController* ctrl in controllers)
    {
        if (ctrl == aViewController)
        {
            return YES;
        }
    }
    
    return NO;
}


-(void)registerController:(UIViewController*)aViewController
{
    if (aViewController == nil)
    {
        return;
    }
    [self cleanUpForced:NO];
 
//    if (![self hasViewController:aViewController])  //防止register相同对象
//    {
        [controllers addObject:aViewController];
        
        DebugLog(@"vc registered:\n%@", [[aViewController class] description]);
//    }
}

-(void)unregisterController:(UIViewController*)aViewController
{
    if (aViewController)
    {
        int count = [controllers count];
        for (int i = count - 1; i >= 0; i--)
        {
            UIViewController* ctrl = [controllers objectAtIndex:i];
            if (ctrl == aViewController)
            {
                DebugLog(@"vc unregistered:\n%@", [[ctrl class] description]);
                //[controllers removeObject:ctrl];
                [self removeVCAutoreleased:ctrl];
                break;
            }
        }
    }
    else
    {
        [self cleanUpForced:YES];
    }
}

-(void)unregisterControllerWithView:(UIView*)aRootView
{
    if (aRootView && aRootView.superview)
    {
        return;
    }
    
    if (aRootView)
    {
        int count = [controllers count];
        for (int i = count - 1; i >= 0; i--)
        {
            UIViewController* ctrl = [controllers objectAtIndex:i];
            if (ctrl.view == aRootView)
            {
                DebugLog(@"vc unregistered:\n%@", [[ctrl class] description]);
                //[controllers removeObject:ctrl];
                [self removeVCAutoreleased:ctrl];
                break;
            }
        }
    }
    else
    {
        [self cleanUpForced:YES];
    }
}


-(OTSBaseViewController*)controllerForView:(UIView*)aView
{    
    if (aView)
    {
        int count = [controllers count];
        for (int i = 0; i < count; i++)
        {
            // CRASH LYTICS FIX -- by dym
            // ISSUE #724
            // Reason *** -[NSMutableArray objectAtIndex:]: index 6 beyond bounds [0 .. 5]
            OTSBaseViewController* ctrl = [OTSUtility safeObjectAtIndex:i inArray:controllers];
            // // CRASH LYTICS FIX END
            
            if (ctrl.view == aView)
            {
                return ctrl;
            }
        }
    }
    
    return nil;
}


#pragma mark - singleton methods
static OTSViewControllerManager *sharedInstance = nil;

+ (OTSViewControllerManager *)sharedInstance
{ 
    @synchronized(self) 
    { 
        if (sharedInstance == nil) 
        { 
            sharedInstance = [[self alloc] init];
            [NSTimer scheduledTimerWithTimeInterval:20 target:sharedInstance selector:@selector(cleanUp) userInfo:nil repeats:YES];
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
            sharedInstance->controllers = [[NSMutableArray alloc] initWithCapacity:10];
            
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
@end
