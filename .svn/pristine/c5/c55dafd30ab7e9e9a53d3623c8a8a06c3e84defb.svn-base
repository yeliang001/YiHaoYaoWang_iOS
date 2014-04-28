//
//  OTSHilightedTextField.m
//  TheStoreApp
//
//  Created by yiming dong on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSHilightedTextField.h"

@implementation OTSHilightedTextField

-(id)initWithFrame:(CGRect)frame placeholder:(NSString*)aPlaceHolder 
{
    self = [self initWithFrame:frame];
    if (self)
    {
        self.placeholder = aPlaceHolder;
    }
    return self;
}

-(void)makeFocus:(BOOL)aIsFocus
{
    bgImageView.highlighted = aIsFocus;
}

-(void)installBgViews
{
    UIImage* normalImage = [UIImage imageNamed:@"sec_val_fd_bg_normal"];
    UIImage* highlightedImage = [UIImage imageNamed:@"sec_val_fd_bg_warning"];
    
    bgImageView = [[UIImageView alloc] initWithImage:normalImage highlightedImage:highlightedImage];
    CGRect bgRect = self.bounds;
    bgRect.origin.x -= 5;
    bgRect.size.width += 5;
    bgImageView.frame = bgRect;
    [self addSubview:bgImageView];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.keyboardType = UIKeyboardTypeNumberPad;
        self.borderStyle = UITextBorderStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.font = [UIFont systemFontOfSize:15.f];
        self.textColor = [UIColor darkGrayColor];
        self.clipsToBounds = NO;
        
        [self installBgViews];
    }
    
    return self;
}

-(void)dealloc
{
    [bgImageView release];
    
    [super dealloc];
}

@end
