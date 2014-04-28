//
//  OTSUnionLoginView.m
//  TheStoreApp
//
//  Created by yiming dong on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSUnionLoginView.h"
#import <QuartzCore/QuartzCore.h>

@implementation OTSUnionLoginView
@synthesize delegate;

-(UIView*)addLineAtYPos:(int)aYPos
{
    CGRect lineRc = CGRectMake(0, aYPos, self.frame.size.width, 1);
    UIView* line = [[[UIView alloc] initWithFrame:lineRc] autorelease];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    
    return line;
}

-(UIButton*)addButtonWithBgImage:(UIImage*)aBgImage title:(NSString*)aTitle yPos:(int)aYPos action:(SEL)aAction
{
    //UIImage* alipayImage = aBgImage;
    UIButton* aliBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    aliBtn.frame = CGRectMake(0, aYPos, self.frame.size.width, 34);
    //[aliBtn setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView* logoImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 2, 50, 30)] autorelease];
    logoImgView.image = aBgImage;
    logoImgView.contentMode = UIViewContentModeScaleAspectFit;
    [aliBtn addSubview:logoImgView];
    
    [aliBtn setBackgroundImage:[UIImage imageNamed:@"white1x1.png"] forState:UIControlStateNormal];
    [aliBtn setTitle:aTitle forState:UIControlStateNormal];
    aliBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    aliBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [aliBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [aliBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [aliBtn addTarget:self action:aAction forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:aliBtn];
    
    return aliBtn;
}

-(void)extraInit
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1;
    self.clipsToBounds = YES;
    
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect selfRect = CGRectMake(10, 0, screenSize.width - 20, 0);
    self.frame = selfRect;
    //
    UIImage* titleImage = [UIImage imageNamed:@"login_union_bg"];// stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImageView* titleImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, selfRect.size.width, 40)] autorelease];
    titleImageView.image = titleImage;
    //titleImageView.
    //titleImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:titleImageView];
    
    //合作账号登录
    CGRect titleRc = CGRectOffset(titleImageView.frame, 20, 0);
    UILabel* titleLbl = [[[UILabel alloc] initWithFrame:titleRc] autorelease];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.text = @"合作账号登录";
    titleLbl.font = [UIFont boldSystemFontOfSize:15.f];
    [self addSubview:titleLbl];
    
    UIButton* btn = [self addButtonWithBgImage:[UIImage imageNamed:@"alipay_logo"] title:@"               支付宝" yPos:CGRectGetMaxY(titleImageView.frame) action:@selector(alipayUnionLogin:)];
    UIView* line = [self addLineAtYPos:CGRectGetMaxY(btn.frame) + 5];
    
    btn = [self addButtonWithBgImage:[UIImage imageNamed:@"sina_logo"] title:@"               新浪微博" yPos:CGRectGetMaxY(line.frame) action:@selector(sinaUnionLogin:)];
    line = [self addLineAtYPos:CGRectGetMaxY(btn.frame) + 5];
    
    btn = [self addButtonWithBgImage:[UIImage imageNamed:@"tencent_logo"] title:@"               腾讯QQ" yPos:CGRectGetMaxY(line.frame) action:@selector(tencentUnionLogin:)];
    
    //line = [self addLineAtYPos:CGRectGetMaxY(btn.frame) + 5];
    
//    btn = [self addButtonWithBgImage:[UIImage imageNamed:@"oneMall"] title:@"               1号商城" yPos:CGRectGetMaxY(line.frame) + 2 action:@selector(oneMallUnionLogin:)];
    
    selfRect.size.height = CGRectGetMaxY(btn.frame) + 5;
    self.frame = selfRect;
    
//    UIImage* alipayImage = [UIImage imageNamed:@"login_sina"];
//    UIButton* aliBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    aliBtn.frame = CGRectMake(0, CGRectGetMaxY(titleImageView.frame), self.frame.size.width, 40);
//    [aliBtn setBackgroundImage:alipayImage forState:UIControlStateNormal];
//    [aliBtn setTitle:@"           支付宝" forState:UIControlStateNormal];
//    aliBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
//    aliBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [aliBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [aliBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    [aliBtn addTarget:self action:@selector(alipayUnionLogin:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:aliBtn];
}

-(void)setYPos:(int)aYPos
{
    CGRect newRect = self.frame;
    newRect.origin.y = aYPos;
    self.frame = newRect;
}


-(void)tencentUnionLogin:(id)sender
{
    if (delegate && [delegate respondsToSelector:_cmd])
    {
        [delegate performSelector:_cmd];
    }
}

-(void)sinaUnionLogin:(id)sender
{
    if (delegate && [delegate respondsToSelector:_cmd])
    {
        [delegate performSelector:_cmd];
    }
}

-(void)alipayUnionLogin:(id)sender
{
    if (delegate && [delegate respondsToSelector:_cmd])
    {
        [delegate performSelector:_cmd];
    }
}

-(void)oneMallUnionLogin:(id)sender
{
    if (delegate && [delegate respondsToSelector:_cmd])
    {
        [delegate performSelector:_cmd];
    }
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self extraInit];
    }
    return self;
}


@end
