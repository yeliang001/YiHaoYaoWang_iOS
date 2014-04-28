//
//  OTSTimedSendButton.h
//  TheStoreApp
//
//  Created by yiming dong on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTSTimedSendButton : UIView
{
    UIButton*       realButton;
    id              theTarget;
    SEL             theAction;
    
    NSTimer*        timer;
    int             expireSeconds;
    int             currentSeconds;
    
    int             originalWidth;
}

- (id)initWithFrame:(CGRect)frame taget:(id)aTarget selector:(SEL)aSelector;
- (id)initWithFrameType2:(CGRect)frame taget:(id)aTarget selector:(SEL)aSelector;
-(void)startTimerWithOutDoAction;
@end
