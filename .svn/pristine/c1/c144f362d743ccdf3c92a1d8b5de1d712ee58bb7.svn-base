//
//  OtherAddressViewCell.h
//  yhd
//
//  Created by dev dev on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodReceiverVO.h"
@protocol OtherAddressViewDelegate <NSObject>
@optional
-(void)editFromAddressCell:(int)index;
@end
@interface OtherAddressViewCell : UITableViewCell
{
    IBOutlet UIImageView * mselectedindicatorImageView;
    GoodReceiverVO * mGoodReceiver;
    IBOutlet UILabel * mreceivenameLabel;
    IBOutlet UILabel * mprovinceNameLabel;
    IBOutlet UILabel * mcityNameLabel;
    IBOutlet UILabel * maddressLabel;
    IBOutlet UILabel * mtelephoneLabel;
    int mindex;
    id<OtherAddressViewDelegate> delegate;
}
@property(nonatomic,retain)GoodReceiverVO * mGoodReceiver;
@property(nonatomic,assign)int mindex;
@property(nonatomic,retain)id<OtherAddressViewDelegate> delegate;
-(void)refresh;
-(IBAction)editClicked:(id)sender;
@end
