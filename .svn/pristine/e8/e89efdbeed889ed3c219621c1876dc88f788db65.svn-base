//
//  OTSAlertView.m
//  TheStoreApp
//
//  Created by yiming dong on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSAlertView.h"

@implementation OTSAlertView

-(void)retainDelegate
{
    if (!isDelegateRetained)
    {
        [self.delegate retain];     // 不是泄漏
        isDelegateRetained = YES;
    }
}

-(void)releaseDelegate
{
    if (isDelegateRetained)
    {
        [self.delegate release];    // 不是泄漏
        isDelegateRetained = NO;
    }
}

-(void)resetDelegate:(NSNotification *)notification
{
    if (self.delegate == notification.object)
    {
        [self releaseDelegate];
        
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
    [self releaseDelegate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

-(id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    
    if (otherButtonTitles)
    {
        va_list va_Average;
        NSString *str;
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
        [array addObject:otherButtonTitles];
        
        va_start(va_Average, otherButtonTitles); // va_start 第二个参数为... 的前一个参数
        while ((str = va_arg(va_Average, NSString *)))
        {
            [array addObject:str];
        }
        va_end(va_Average);
        
        DebugLog(@"len:%d\n",[array count]);
        DebugLog(@"%@",[array componentsJoinedByString:@";"]);
        
        for (NSString *item in array) 
        {
            [self addButtonWithTitle:item];
        }
    }
    
    return self;
}

@end
