//
//  OTSUtil.m
//  TheStoreApp
//
//  Created by yiming dong on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSUtil.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "OTSAlertView.h"
#import "OTSUtility.h"

@implementation OTSUtil
+(UILabel*)labelWithTitle:(NSString*)aTitle rect:(CGRect)aRect font:(UIFont*)aFont color:(UIColor*)aColor
{
    if (aTitle && aFont && aColor)
    {
        UILabel* label = [[[UILabel alloc] initWithFrame:aRect] autorelease];
        
        label.backgroundColor = [UIColor clearColor];
        label.textColor = aColor;
        label.font = aFont;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = aTitle;
        
        return label;
    }
    
    return nil;
}


+(UIButton*)buttonWithTitle:(NSString*)aTitle 
                       rect:(CGRect)aRect 
                   bgNormal:(UIImage*)aBgNormalImage 
             bgHightlighted:(UIImage*)aBgHightlightedImage 
                     target:(id)aTarget
                   selector:(SEL)aSelector 
                titleShadow:(BOOL)aTitleShadow
{
    UIButton* theButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    theButton.frame = aRect;
    
    [theButton setTitle:aTitle forState:UIControlStateNormal];
    
    theButton.titleLabel.font = [UIFont boldSystemFontOfSize:13.f];
    if (aTitleShadow) 
    {
        [OTSUtility setShadowForView:theButton.titleLabel];
    }
    
    [theButton setBackgroundImage:aBgNormalImage forState:UIControlStateNormal];
    [theButton setBackgroundImage:aBgHightlightedImage forState:UIControlStateHighlighted];
    [theButton addTarget:aTarget action:aSelector forControlEvents:UIControlEventTouchUpInside];
    
    return theButton;
}



+(void)alert:(NSString*)aMessage
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" 
                                                    message:aMessage 
                                                   delegate:self 
                                          cancelButtonTitle:@"确定" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

+(void)alert:(NSString*)aMessage title:(NSString*)aTitle
{
    UIAlertView* alert = [[OTSAlertView alloc] initWithTitle:aTitle
                                                    message:aMessage 
                                                   delegate:self 
                                          cancelButtonTitle:@"确定" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

+(UIImage*)downloadImageFromUrl:(NSString*)aUrlString
{
    @synchronized([NSThread currentThread])
    {
        UIImage* image = nil;
        
        NSURL *imgUrl=[NSURL URLWithString:aUrlString];
        NSData *imgData=[NSData dataWithContentsOfURL:imgUrl];
        if(imgData)
        {
            image = [UIImage imageWithData:imgData];
        }
        
        return image;
    }
}

//+(void)playSoundFileInBundle:(NSString*)aSoundFileName type:(NSString*)aSoundType
//{
//    [self playSoundFile:[[NSBundle mainBundle] pathForResource:aSoundFileName ofType:aSoundType]];
//}
//
//+(void)playSoundFile:(NSString*)aSoundFilePath
//{
//    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(dispatchQueue, ^(void) {
//        NSData* fileData = [[NSData alloc] initWithContentsOfFile:aSoundFilePath];
//        NSError* error = nil;
//        
//        AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
//        if (error)
//        {
//            NSLog(@"error:%@", error);
//        }
//        
//        BOOL isPlayOK = NO;
//        if (player && [player prepareToPlay] && [player play])
//        {
//            isPlayOK = YES;
//        }
//        else
//        {
//            isPlayOK = NO;
//        }
//        
//        [player release];
//        [fileData release];
//    });
//    
//}

+ (BOOL) validateFormatOfString: (NSString *) targetString format: (NSString*) formatString 
{
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", formatString]; 
    return [emailTest evaluateWithObject:targetString];
}

+ (BOOL) validateMobile: (NSString *) candidate 
{ 
    NSString *mobileRegex = @"[0-9]{11}";  // mobile phone number length must be 11.
    //NSString *mobileRegex = @"[0-9]{8,14}";
    return [self validateFormatOfString:candidate format:mobileRegex];
}

@end



