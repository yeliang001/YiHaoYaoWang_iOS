//
//  OTSGlobalNavigationController.m
//  TheStoreApp
//
//  Created by yiming dong on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSGlobalNavigationController.h"

@implementation OTSGlobalNavigationController

-(void)setRootViewController:(UIViewController*)aViewController
{
    if (aViewController)
    {
        [self popToRootViewControllerAnimated:YES];
        
        NSArray* viewControllers = [NSArray arrayWithObject:aViewController];
        self.viewControllers = viewControllers;
    }
}

#pragma mark - singleton methods
static OTSGlobalNavigationController *sharedInstance = nil;

+ (OTSGlobalNavigationController *)sharedInstance:(UIViewController*)aViewController
{ 
    @synchronized(self) 
    { 
        if (sharedInstance == nil) 
        { 
            sharedInstance = [[self alloc] initWithRootViewController:aViewController]; 
        } 
    } 
    
    [sharedInstance setRootViewController:aViewController];
    
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
@end
