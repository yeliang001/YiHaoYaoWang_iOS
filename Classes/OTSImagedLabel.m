//
//  OTSImagedLabel.m
//  TheStoreApp
//
//  Created by yiming dong on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OTSImagedLabel.h"

@implementation OTSImagedLabel
@synthesize iv, lbl;

-(void)extraInit
{
    CGRect ivRc = CGRectMake(10
                             , (self.frame.size.height - 40) / 2
                             , 40
                             , 40);
    self.iv = [[[UIImageView alloc] initWithFrame:ivRc] autorelease];
    iv.backgroundColor = [UIColor redColor];
    [self addSubview:iv];
    
    self.lbl = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ivRc) + 10
                                                            , 0
                                                            , self.frame.size.width - CGRectGetMaxX(ivRc) - 30
                                                            , self.frame.size.height)] autorelease];
    lbl.text = @"描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述";
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont systemFontOfSize:14.f];
    lbl.numberOfLines = 2;
    [self addSubview:lbl];
                                                            
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.backgroundColor = [UIColor whiteColor];
        [self extraInit];
    }
    return self;
}

-(void)dealloc
{
    [iv release];
    [lbl release];
    
    [super dealloc];
}

@end
