//
//  OTSNaviAnimation.m
//  TheStoreApp
//
//  Created by yiming dong on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSNaviAnimation.h"
#import <QuartzCore/QuartzCore.h>

@implementation OTSNaviAnimation

+(CAAnimation*)animationWithType:(NSString*)aType 
                         subType:(NSString*)aSubType 
{
    CATransition *animation = [CATransition animation]; 
	animation.duration = 0.3f;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	[animation setType:aType];
	[animation setSubtype: aSubType];
	
    return animation;
}

+(CAAnimation*)animationFade
{
    return [self animationWithType:kCATransitionFade subType:kCATransitionFromLeft];
}

+(CAAnimation*)animationPushFromLeft
{
    return [self animationWithType:kCATransitionPush subType:kCATransitionFromLeft];
}

+(CAAnimation*)animationPushFromRight
{
    return [self animationWithType:kCATransitionPush subType:kCATransitionFromRight];
}

+(CAAnimation*)animationPushFromTop
{
    return [self animationWithType:kCATransitionPush subType:kCATransitionFromTop];
}

+(CAAnimation*)animationPushFromBottom
{
    return [self animationWithType:kCATransitionPush subType:kCATransitionFromBottom];
}

+(CAAnimation*)animationMoveInFromTop
{
    return [self animationWithType:kCATransitionMoveIn subType:kCATransitionFromTop];
}

+(CAAnimation*)animationMoveInFromBottom
{
    return [self animationWithType:kCATransitionMoveIn subType:kCATransitionFromBottom];
}


+(CATransition*)transactionFade
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type =kCATransitionFade; //@"cube";
    transition.subtype = kCATransitionFromRight;
    return transition;
}

@end
