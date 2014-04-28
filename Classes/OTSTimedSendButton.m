//
//  OTSTimedSendButton.m
//  TheStoreApp
//
//  Created by yiming dong on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSTimedSendButton.h"
#import "OTSUtil.h"


#define OTS_STR_RESEND_CODE_FORMAT          @"重新获取验证码(%ds)"
#define OTS_STR_SEND_CODE                   @"获取验证码"
#define OTS_STR_RESEND_CODE                 @"重新发送"

@interface OTSTimedSendButton ()
@property(nonatomic)int type;
@end

@implementation OTSTimedSendButton
@synthesize type;

- (void)timerFireMethod:(NSTimer*)theTimer
{
    currentSeconds++;
    if (currentSeconds >= expireSeconds)
    {
        [realButton setTitle:OTS_STR_RESEND_CODE forState:UIControlStateNormal];
        //[realButton setTitleColor:OTS_COLOR_FROM_RGB(0xE15D08) forState:UIControlStateNormal];
        if (type == 2) {
            [realButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else{
            [realButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        realButton.enabled = YES;
        
        [timer invalidate];
        timer = nil;
        
        currentSeconds = 0;
        
//        CGRect btnRc = realButton.frame;
//        btnRc.size.width = originalWidth;
//        realButton.frame = btnRc;
    }
    else
    {
        [realButton setTitle:[NSString stringWithFormat:OTS_STR_RESEND_CODE_FORMAT, expireSeconds - currentSeconds] forState:UIControlStateNormal];
    }
}
-(void)startTimerWithOutDoAction{
    realButton.enabled = NO;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(timerFireMethod:)
                                           userInfo:nil
                                            repeats:YES];
    
    [realButton setTitle:[NSString stringWithFormat:OTS_STR_RESEND_CODE_FORMAT, expireSeconds - currentSeconds] forState:UIControlStateNormal];
    [realButton setTitleColor:OTS_COLOR_FROM_RGB(0x999999) forState:UIControlStateNormal];
    
    CGRect btnRc = realButton.frame;
    //btnRc.size.width = originalWidth * 2;
    btnRc.size.width = originalWidth;
    realButton.frame = btnRc;
}
-(void)buttonAction
{
    BOOL isActionSeccess = NO;
    if (theTarget && [theTarget respondsToSelector:theAction])
    {
        isActionSeccess = [[theTarget performSelector:theAction] boolValue];
    }
    
//    if (isActionSeccess)
//    {
//        realButton.enabled = NO;
//        
//        timer = [NSTimer scheduledTimerWithTimeInterval:1 
//                                                 target:self 
//                                               selector:@selector(timerFireMethod:)
//                                               userInfo:nil 
//                                                repeats:YES];
//        
//        [realButton setTitle:[NSString stringWithFormat:OTS_STR_RESEND_CODE_FORMAT, expireSeconds - currentSeconds] forState:UIControlStateNormal];
//        [realButton setTitleColor:OTS_COLOR_FROM_RGB(0x999999) forState:UIControlStateNormal];
//        
//        CGRect btnRc = realButton.frame;
//        //btnRc.size.width = originalWidth * 2;
//        btnRc.size.width = originalWidth;
//        realButton.frame = btnRc;
//    }
}

- (id)initWithFrame:(CGRect)frame taget:(id)aTarget selector:(SEL)aSelector
{
    self = [self initWithFrame:frame];
    if (self)
    {
        theTarget = aTarget;
        theAction = aSelector;
        expireSeconds = 60;
        originalWidth = frame.size.width;
    }
    
    return self;
}
- (id)initWithFrameType2:(CGRect)frame taget:(id)aTarget selector:(SEL)aSelector{
    self = [self initWithFrameType2:frame];
    if (self)
    {
        theTarget = aTarget;
        theAction = aSelector;
        expireSeconds = 60;
        originalWidth = frame.size.width;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        realButton = [[OTSUtil buttonWithTitle:OTS_STR_SEND_CODE 
                                   rect:self.bounds 
                               bgNormal:[[UIImage imageNamed:@"orange_long_btn"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10]
                         bgHightlighted:[[UIImage imageNamed:@"orange_long_btn"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10]
                                 target:self 
                            selector:@selector(buttonAction) 
                            titleShadow:NO] retain];
        
        [realButton setBackgroundImage:[[UIImage imageNamed:@"sec_val_send_btn_disabled"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10] forState:UIControlStateDisabled];
        //[realButton setTitleColor:OTS_COLOR_FROM_RGB(0xE15D08) forState:UIControlStateNormal];
        [realButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [realButton.titleLabel setFont:[UIFont systemFontOfSize:20.0]];
        
        [self addSubview:realButton];
    }
    
    return self;
}
- (id)initWithFrameType2:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.type = 2;
    if (self)
    {
        realButton = [[OTSUtil buttonWithTitle:OTS_STR_SEND_CODE
                                          rect:self.bounds
                                      bgNormal:[[UIImage imageNamed:@"sec_val_send_btn_disabled"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0]
                                bgHightlighted:[[UIImage imageNamed:@"sec_val_send_btn_disabled"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0]
                                        target:self
                                      selector:@selector(buttonAction)
                                   titleShadow:NO] retain];
        
        [realButton setBackgroundImage:[[UIImage imageNamed:@"sec_val_send_btn_disabled"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0] forState:UIControlStateDisabled];
        //[realButton setTitleColor:OTS_COLOR_FROM_RGB(0xE15D08) forState:UIControlStateNormal];
        [realButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [realButton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [realButton.titleLabel setNumberOfLines:0];
        [realButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:realButton];
    }
    
    return self;
}

-(void)dealloc
{
    [timer release];
    [realButton release];
    
    [super dealloc];
}

@end
