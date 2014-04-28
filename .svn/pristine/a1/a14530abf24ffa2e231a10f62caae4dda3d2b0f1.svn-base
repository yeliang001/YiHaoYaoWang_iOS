//
//  UserBackView.m
//  yhd
//
//  Created by dev dev on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserBackView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSObject+OTS.h"
#import "OTSServiceHelper.h"

@interface UserBackView ()
{
    BOOL    _hasEdit;
}
@end

@implementation UserBackView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    mTextView.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    mTextView.layer.borderWidth =1;
    mLabel.textColor = kGrayColor;
}
-(IBAction)SubmitClicked:(id)sender
{
    if (!_hasEdit || [mTextView.text isEqualToString:@""]) {
        UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入您的反馈意见" delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else {
        [self otsDetatchMemorySafeNewThreadSelector:@selector(AddFeedbacktoServer) toTarget:self withObject:nil];
    }
}
-(void)AddFeedbacktoServer
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    int result = [service addFeedback:[GlobalValue getGlobalValueInstance].token feedbackcontext:mTextView.text];
   
    [self performInMainBlock:^{
        
        if (result == 1)
        {
            mTextView.text = @"";
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"反馈结果" message:@"提交反馈成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"反馈结果" message:@"提交反馈失败,请重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }

        
    }];
    
    [pool drain];
}
#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请留下您宝贵的意见"]) {
        textView.text=@"";
    }
    
    _hasEdit = YES;
    
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
//    if (!textView.hasText) {
//        textView.text=@"请留下您宝贵的意见";
//    }
    return YES;
}
@end
