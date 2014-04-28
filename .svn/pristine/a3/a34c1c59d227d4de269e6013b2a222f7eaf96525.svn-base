//
//  UIView+Common.m
//  HappyShare
//
//  Created by Lin Pan on 13-3-14.
//  Copyright (c) 2013年 Lin Pan. All rights reserved.
//

#import "UIView+Common.h"

@implementation UIView (Common)

- (CGFloat)left
{
    return  self.frame.origin.x;
}
- (CGFloat)top
{
    return self.frame.origin.y;
}

- (CGFloat)right
{
    return  self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)bottom
{
    return  self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)width
{
    return  self.frame.size.width;
}

- (CGFloat)height
{
    return  self.frame.size.height;
}

- (void)removeAllSubviews
{
    for (id obj in [self subviews])
    {
        [(UIView *)obj removeFromSuperview];
    }
}
@end
