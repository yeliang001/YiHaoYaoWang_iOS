//
//  OrderTypeCell.m
//  yhd
//
//  Created by dev dev on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OrderTypeCell.h"

@implementation OrderTypeCell
@synthesize arrIV = _arrIV;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setArrowImg];
    }
    return self;
}

-(void)awakeFromNib
{
    [self setArrowImg];
}

-(void)setArrowImg
{
    self.arrIV.image = [UIImage imageNamed:@"padGrayArrowRight"];
}

-(void)dealloc
{
    [_arrIV release];
    [_bgIV release];
    [_myTextLabel release];
    
    [super dealloc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (selected) {
        _bgIV.image = [UIImage imageNamed:@"redbackgroundinusercenter@2x.png"];
        _myTextLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        _bgIV.image = nil;
        _myTextLabel.textColor = [UIColor blackColor];
    }
}

@end
