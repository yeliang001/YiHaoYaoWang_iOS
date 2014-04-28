//
//  OTSPhoneMotionableView.m
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-9.
//
//
#import <AudioToolbox/AudioToolbox.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define kAccelerometerFrequency        50.0 //Hz

#import "OTSPhoneMotionableView.h"

@implementation OTSPhoneMotionableView
@synthesize delegate = _delegate;

-(id)initWithDelegate:(id<OTSPhoneMotionableViewDelegate>)aDelegate
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        _delegate = aDelegate;
        [self configureAccelerometer];
        [self becomeFirstResponder];
    }
    
    return self;
}

#pragma mark - 摇动
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

-(BOOL)canResignFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    DebugLog(@"motion detected!!!");
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   // 让iPhone震动，注意touch不会震动
    
    [self.delegate handleMotionEvent];
}

// 设置加速计
-(void)configureAccelerometer
{
    UIAccelerometer *theAccelerometer=[UIAccelerometer sharedAccelerometer];
    theAccelerometer.delegate = self;
    [theAccelerometer setUpdateInterval:1/kAccelerometerFrequency];
}

@end
