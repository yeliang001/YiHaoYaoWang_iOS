//
//  OrderTrackCell.m
//  yhd
//
//  Created by  on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OrderTrackCell.h"
#import "DataHandler.h"
@implementation OrderTrackCell
-(void)dealloc{
    [nameLabel release];
    [super dealloc];
}
@synthesize height,row,nameLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100.0, 30.0) ];
        nameLabel.textColor = kBlackColor;  
        nameLabel.backgroundColor=[UIColor clearColor];        
        [self addSubview:nameLabel];

        UIImageView *lineImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"track_xline1.png"]];
        [lineImage setFrame:CGRectMake((kOrderDetailTableViewWidth-325)/2, height-1, 325, 1)];
        [self insertSubview:lineImage atIndex:1];
        [lineImage release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
