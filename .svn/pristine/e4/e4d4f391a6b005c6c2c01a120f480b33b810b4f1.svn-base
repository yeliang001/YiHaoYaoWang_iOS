//
//  OTSChangePayButton.m
//  MakePayBtn
//
//  Created by yiming dong on 12-8-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSChangePayButton.h"

@interface OTSChangePayButton ()
@property (nonatomic) BOOL  isLongButton;
@end


@implementation OTSChangePayButton
@synthesize payButton, changePayButton, isLongButton;

-(void)dealloc
{
    [payButton release];
    [changePayButton release];
    
    [super dealloc];
}


-(void)extraInit
{
    NSString *payImageName = nil;
    UIImage *payImage = nil;
    UIImage *changePayImage = nil;
    
    if (ISIPADDEVICE)
    {
        payImage = [UIImage imageNamed:@"payChangeBtnLeft"];
        changePayImage = [UIImage imageNamed:@"payChangeBtnRight"];
    }
    else
    {
        payImageName = isLongButton ? @"payBtnLong" : @"payBtnShort";
        payImage = [UIImage imageNamed:payImageName];
        changePayImage = [UIImage imageNamed:@"changePayBtn"];
    }
    
    // pay Button
    self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [payButton setBackgroundImage:payImage forState:UIControlStateNormal];
    payButton.frame = CGRectMake(0, 0, payImage.size.width, payImage.size.height);
    payButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
    [self addSubview:payButton];
    
    //CGRect rc = payButton.frame;
    
    // change pay button
    self.changePayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changePayButton setBackgroundImage:changePayImage forState:UIControlStateNormal];
    
    // 切图稍有偏差，依此调节
    if (isLongButton)
    {
        changePayButton.frame = CGRectMake(CGRectGetMaxX(payButton.frame) , 0, changePayImage.size.width, changePayImage.size.height + 0.5f);
    }
    else
    {
        changePayButton.frame = CGRectMake(CGRectGetMaxX(payButton.frame), 0, changePayImage.size.width, changePayImage.size.height-0.18f);
    }
    
    [self addSubview:changePayButton];
    
    //rc = changePayButton.frame;
    
    // adjust self bounds
    self.frame = CGRectMake(0, 0, CGRectGetMaxX(changePayButton.frame), payImage.size.height);
    
    // add bg image view to optimize the appearance
    CGRect bgRect = self.bounds;
    bgRect.origin.x += 20;
    bgRect.size.width -= 40;
    bgRect.origin.y += 0.5;
    bgRect.size.height -= 1.5;
    UIImageView* bgIV = [[[UIImageView alloc] initWithFrame:bgRect] autorelease];
    bgIV.image = payImage;
    [self addSubview:bgIV];
    [self sendSubviewToBack:bgIV];
    
    //rc = self.frame;
}

-(id)initWithLongButton:(BOOL)aIsLongButton
{
    self = [super initWithFrame:CGRectZero];
    if (self) 
    {
        isLongButton = aIsLongButton;
        [self extraInit];
    }
    return self;
}

@end
