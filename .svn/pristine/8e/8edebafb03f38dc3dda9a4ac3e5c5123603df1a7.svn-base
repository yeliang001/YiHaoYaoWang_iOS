//
//  OTSBadgeView.m
//  TheStoreApp
//
//  Created by yiming dong on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSBadgeView.h"

@implementation OTSBadgeView
@dynamic badgeNumber, bgImg;

-(UIImage*)bgImg
{
    return bgImg;
}

-(void)setBgImg:(UIImage *)aBgImg
{
    if (aBgImg != bgImg)
    {
        [bgImg release];
        bgImg = [aBgImg retain];
        
        // do update
        [self setNeedsDisplay];
    }
}

-(int)badgeNumber
{
    return badgeNumber;
}

-(void)setBadgeNumber:(int)aBadgeNumber
{
    badgeNumber = aBadgeNumber;
    self.hidden = (aBadgeNumber == 0);
    // update...
    [self setNeedsDisplay];
}

-(id)initWithPosition:(CGPoint)aPosition badgeNumber:(int)aBadgeNumber
{
    UIImage* theImg = [UIImage imageNamed:@"badge_bg"];
    
    if (theImg)
    {
        self = [self initWithFrame:CGRectMake(aPosition.x, aPosition.y, theImg.size.width, theImg.size.height)];
        
        if (self) 
        {
            bgImg = [theImg retain];
            badgeNumber = aBadgeNumber;
            self.hidden = (aBadgeNumber == 0);
            
            [self setBackgroundColor:[UIColor clearColor]];
        }
        return self;
    }
    
    return nil;
}

-(void)drawRect:(CGRect)rect
{
    [bgImg drawAtPoint:CGPointZero];
    NSString* numberStr = [NSString stringWithFormat:@"%d", badgeNumber];
   
    [[UIColor whiteColor] set];
    
    numberStr = [numberStr length] > 2 ? @"99+" : numberStr;
    UIFont *helveticaBold = [numberStr length] > 2 ? [UIFont boldSystemFontOfSize:14.f] : [UIFont boldSystemFontOfSize:18.f];
    
    
    CGSize theSize = [numberStr sizeWithFont:helveticaBold forWidth:320.0 lineBreakMode:UILineBreakModeWordWrap];
    float xPos = (bgImg.size.width - theSize.width) / 2; 
    float yPos = (bgImg.size.height - theSize.height) / 2 - 1; 
    [numberStr drawAtPoint:CGPointMake(xPos, yPos) withFont:helveticaBold];
}


@end


@implementation OTSGrayBadgeView

-(id)initWithPosition:(CGPoint)aPosition badgeNumber:(int)aBadgeNumber
{
    UIImage* theImg = [UIImage imageNamed:@"ots_badgeGrayBg"];
    
    if (theImg)
    {
        self = [self initWithFrame:CGRectMake(aPosition.x, aPosition.y, theImg.size.width, theImg.size.height)];
        
        if (self)
        {
            bgImg = [theImg retain];
            badgeNumber = aBadgeNumber;
            
            [self setBackgroundColor:[UIColor clearColor]];
        }
        return self;
    }
    
    return nil;
}

-(void)drawRect:(CGRect)rect
{
    [bgImg drawAtPoint:CGPointZero];
    NSString* numberStr = [NSString stringWithFormat:@"%d", badgeNumber];
    
    [[UIColor whiteColor] set];
    
    numberStr = [numberStr length] > 2 ? @"99+" : numberStr;
    UIFont *helveticaBold = [numberStr length] > 2 ? [UIFont boldSystemFontOfSize:11.f] : [UIFont boldSystemFontOfSize:14.f];
    
    
    CGSize theSize = [numberStr sizeWithFont:helveticaBold forWidth:320.0 lineBreakMode:UILineBreakModeWordWrap];
    float xPos = (bgImg.size.width - theSize.width) / 2; 
    float yPos = (bgImg.size.height - theSize.height) / 2 - 1; 
    [numberStr drawAtPoint:CGPointMake(xPos, yPos) withFont:helveticaBold];
}

@end

@implementation OTSRedBadgeView

-(id)initWithPosition:(CGPoint)aPosition badgeNumber:(int)aBadgeNumber
{
    UIImage* theImg = [UIImage imageNamed:@"ots_badgeRedBg"];
    
    if (theImg)
    {
        self = [self initWithFrame:CGRectMake(aPosition.x, aPosition.y, theImg.size.width, theImg.size.height)];
        
        if (self)
        {
            bgImg = [theImg retain];
            badgeNumber = aBadgeNumber;
            
            [self setBackgroundColor:[UIColor clearColor]];
        }
        return self;
    }
    
    return nil;
}

-(void)drawRect:(CGRect)rect
{
    [bgImg drawAtPoint:CGPointZero];
    NSString* numberStr = [NSString stringWithFormat:@"%d", badgeNumber];
    
    [[UIColor whiteColor] set];
    
    numberStr = [numberStr length] > 2 ? @"99+" : numberStr;
    UIFont *helveticaBold = [numberStr length] > 2 ? [UIFont boldSystemFontOfSize:11.f] : [UIFont boldSystemFontOfSize:14.f];
    
    
    CGSize theSize = [numberStr sizeWithFont:helveticaBold forWidth:320.0 lineBreakMode:UILineBreakModeWordWrap];
    float xPos = (bgImg.size.width - theSize.width) / 2; 
    float yPos = (bgImg.size.height - theSize.height) / 2 - 1; 
    [numberStr drawAtPoint:CGPointMake(xPos, yPos) withFont:helveticaBold];
}

@end


@implementation OTSCircleBadgeView

-(id)initWithPosition:(CGPoint)aPosition badgeNumber:(int)aBadgeNumber
{
    UIImage* theImg = [UIImage imageNamed:@"ots_badgeBg2"];
    
    if (theImg)
    {
        self = [self initWithFrame:CGRectMake(aPosition.x, aPosition.y, theImg.size.width, theImg.size.height)];
        
        if (self)
        {
            bgImg = [theImg retain];
            badgeNumber = aBadgeNumber;
            
            [self setBackgroundColor:[UIColor clearColor]];
        }
        return self;
    }
    
    return nil;
}

-(void)drawRect:(CGRect)rect
{
    NSString* numberStr = [NSString stringWithFormat:@"%d", badgeNumber];
    
    [[UIColor whiteColor] set];
    
    //numberStr = [numberStr length] > 2 ? STR_BADGE_BIG_NUMBER : numberStr;
    //UIFont *helveticaBold = [UIFont boldSystemFontOfSize:13.f];;
    UIFont *helveticaBold = [numberStr length] > 2 ? [UIFont boldSystemFontOfSize:11.f] : [UIFont boldSystemFontOfSize:13.f];
    
    
    [bgImg drawAtPoint:CGPointZero];
    
    CGSize theSize = [numberStr sizeWithFont:helveticaBold forWidth:320.0 lineBreakMode:UILineBreakModeWordWrap];
    float xPos = (bgImg.size.width - theSize.width) / 2;
    float yPos = (bgImg.size.height - theSize.height) / 2 - 2.f;
    [numberStr drawAtPoint:CGPointMake(xPos, yPos) withFont:helveticaBold];
}

@end

