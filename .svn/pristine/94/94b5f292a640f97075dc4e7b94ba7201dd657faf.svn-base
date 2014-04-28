//
//  OtherAddressViewCell.m
//  yhd
//
//  Created by dev dev on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OtherAddressViewCell.h"
#import "DataHandler.h"
#import "ProvinceVO.h"
#import "OTSGpsHelper.h"

@implementation OtherAddressViewCell
@synthesize mGoodReceiver;
@synthesize mindex;
@synthesize delegate;
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
    if (selected) {
       // DataHandler * tempdata = [DataHandler sharedDataHandler];
        if ([[OTSGpsHelper sharedInstance].provinceVO.nid longValue] != [mGoodReceiver.provinceId longValue]) 
        {
            
        }
        else 
        {
            mselectedindicatorImageView.hidden = !selected;
        }
    }
    else
    {
        mselectedindicatorImageView.hidden = !selected;
    }
    
    // Configure the view for the selected state
}
-(void)dealloc
{
    [mGoodReceiver release];
    [super dealloc];
}
-(void)refresh
{
    mreceivenameLabel.text = mGoodReceiver.receiveName;
    maddressLabel.text = mGoodReceiver.address1;
    if (mGoodReceiver.receiverMobile) {
        mtelephoneLabel.text = mGoodReceiver.receiverMobile;
    }
    else
    {
        mtelephoneLabel.text = mGoodReceiver.receiverPhone;
    }
    if ([mGoodReceiver.provinceName isEqualToString:@"上海"]) {
        mcityNameLabel.text = [NSString  stringWithFormat:@"%@ %@",mGoodReceiver.provinceName,mGoodReceiver.cityName];
    } else {
        mcityNameLabel.text = [NSString  stringWithFormat:@"%@ %@ %@",mGoodReceiver.provinceName,mGoodReceiver.cityName,mGoodReceiver.countyName];
    }
}
-(void)editClicked:(id)sender
{
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"EditAddressFromCell" object:self userInfo:nil];
    if ([delegate respondsToSelector:@selector(editFromAddressCell:)])
    {
        [self.delegate editFromAddressCell:mindex];
    }
}
@end
