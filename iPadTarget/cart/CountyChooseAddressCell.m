//
//  CountyChooseAddressCell.m
//  yhd
//
//  Created by dev dev on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CountyChooseAddressCell.h"

@implementation CountyChooseAddressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    mSelectedIndicator.hidden = !selected;
    // Configure the view for the selected state
}

@end
