//
//  OTSContainerViewController.m
//  TheStoreApp
//
//  Created by yiming dong on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSContainerViewController.h"
#import "TheStoreAppAppDelegate.h"

@implementation OTSContainerViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = [SharedDelegate screenRectHasTabBar:NO statusBar:YES];
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor clearColor];
}
@end
