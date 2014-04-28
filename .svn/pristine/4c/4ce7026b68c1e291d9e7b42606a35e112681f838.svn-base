//
//  OTSBadgeButton.m
//  TheStoreApp
//
//  Created by towne on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSBadgeButton.h"

@implementation OTSBadgeButton
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
    // update...
    [self setNeedsDisplay];
}

-(id)initWithFrame:(CGRect)aFrame badgeNumber:(int)aBadgeNumber{

    UIImage* theImg = [UIImage imageNamed:@"couponBG"];
    
    if (theImg)
    {
        self = [self initWithFrame:aFrame];
        
        if (self) 
        {
            bgImg = [theImg retain];
            badgeNumber = aBadgeNumber;
            [self setBackgroundColor:[UIColor clearColor]];
            [self setTitle:[NSString stringWithFormat:@"¥%d",aBadgeNumber] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self setBackgroundImage:theImg forState:UIControlStateNormal];
            [self setUserInteractionEnabled:NO];
        }
        return self;
    }
    
    return nil;
}

-(void)drawRect:(CGRect)rect
{
    [self setBackgroundImage:bgImg forState:UIControlStateNormal];
    NSString* numberStr = [NSString stringWithFormat:@"¥%d", badgeNumber];
    [[UIColor whiteColor] set];  
    
    switch ([numberStr length]) {
        case 3:{
            [self.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
            break;
        }
        case 4:{
            [self.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
            break;
        }
        case 5:{
            [self.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
            break;
        }
        default:
            break;
    }

}

@end
