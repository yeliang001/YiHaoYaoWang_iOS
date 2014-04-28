//
//  StrikeThroughLabel.m
//  TheStoreApp
//
//  Created by jiming huang on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "StrikeThroughLabel.h"

@implementation StrikeThroughLabel
- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	CGContextRef context=UIGraphicsGetCurrentContext();
	CGContextSetRGBStrokeColor(context, 0.667, 0.667, 0.667, 1.0);
	CGContextSetLineWidth(context, 1.0);
	
	// Draw a single line from left to right
	CGContextMoveToPoint(context,0,[self frame].size.height/2);
    float lineLength=[[self text]length]*[[self font]pointSize]/2;
	CGContextAddLineToPoint(context,lineLength,[self frame].size.height/2);
	CGContextStrokePath(context);
}
@end
