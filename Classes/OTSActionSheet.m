//
//  OTSActionSheet.m
//  TheStoreApp
//
//  Created by yiming dong on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSActionSheet.h"

@implementation OTSActionSheet

-(void)resetDelegate:(NSNotification *)notification
{
    if (self.delegate == notification.object)
    {
        self.delegate = nil;
    }
}

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetDelegate:) name:OTS_VC_REMOVED object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
@end
