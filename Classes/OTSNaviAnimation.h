//
//  OTSNaviAnimation.h
//  TheStoreApp
//
//  Created by yiming dong on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CAAnimation;

@interface OTSNaviAnimation : NSObject
+(CAAnimation*)animationFade;
+(CAAnimation*)animationPushFromLeft;
+(CAAnimation*)animationPushFromRight;
+(CAAnimation*)animationMoveInFromTop;
+(CAAnimation*)animationMoveInFromBottom;
+(CAAnimation*)animationPushFromTop;
+(CAAnimation*)animationPushFromBottom;

+(CATransition*)transactionFade;
@end
