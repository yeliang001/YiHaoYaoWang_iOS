//
//  OrderTrackDetailCell.m
//  yhd
//
//  Created by  on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OrderTrackDetailCell.h"
#import "DataHandler.h"
@implementation OrderTrackDetailCell
@synthesize orderTrack,height,preDate,isLast;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}
-(void)freshCell{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 5, 155.0, 16.0) ];
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.backgroundColor=[UIColor clearColor];
    timeLabel.font=[timeLabel.font fontWithSize:13.0];
    if ([orderTrack.oprCreatetime length]>19) {
        if ([preDate isEqualToString:[orderTrack.oprCreatetime substringToIndex:10]]) {
            NSRange range=NSMakeRange(10, 9);
            timeLabel.text=[[orderTrack clonedOprCreatetime] substringWithRange:range];
            timeLabel.frame=CGRectMake(80, 0, 155.0, 30.0);
        }else {
            timeLabel.text=[[orderTrack clonedOprCreatetime] substringToIndex:19];
        }
        
        
        
    }
    [self addSubview:timeLabel];
    [timeLabel release];
    UIFont *font=[UIFont fontWithName:@"Helvetica" size:13];
    CGSize contentSize =[orderTrack.oprContent  sizeWithFont:font constrainedToSize:CGSizeMake(190, 200)];
    int contentRowCount=(contentSize.height/16)>0?(contentSize.height/16):1;
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(175, 5, 200.0, contentRowCount*20) ];
    if (isLast) {//[orderTrack.oprNum intValue]==54
        contentLabel.textColor =kRedColor ;
    }else {
        contentLabel.textColor = kBlackColor;
    }
    contentLabel.backgroundColor=[UIColor clearColor];
    contentLabel.numberOfLines=contentRowCount;
    contentLabel.font=[contentLabel.font fontWithSize:14.0];
    contentLabel.text=orderTrack.oprContent;
    [self addSubview:contentLabel];
    [contentLabel release];
    
    CGSize remarkSize =[orderTrack.oprRemark  sizeWithFont:font constrainedToSize:CGSizeMake(150, 200)];
    int remarkRowCount=(remarkSize.height/16)>0?(remarkSize.height/16):1;
    
    UILabel *remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(390, 4, 160.0, remarkRowCount*20) ];
    if (isLast) {
        remarkLabel.textColor =kRedColor ;
    }else {
        remarkLabel.textColor = kBlackColor;
    }
    
    remarkLabel.backgroundColor=[UIColor clearColor];
    remarkLabel.numberOfLines=remarkRowCount;
    remarkLabel.font=[remarkLabel.font fontWithSize:14.0];
    remarkLabel.text=orderTrack.oprRemark;
    [self addSubview:remarkLabel];
    [remarkLabel release];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)dealloc
{
    
    [preDate release];
    [orderTrack release];
    [super dealloc];
}
@end
