//
//  CustomAddressCell.h
//  yhd
//
//  Created by dev dev on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodReceiverVO.h"
@protocol CustomAddressDelegate<NSObject>
@required
-(void)deleteAddressByAddressId:(NSNumber*)deleteAddressId;
@end
@interface CustomAddressCell : UITableViewCell
{
    IBOutlet UILabel * mlabel;
    GoodReceiverVO* mGoodReceiver;
    IBOutlet UIButton * mSetDefaultButton;
    id<CustomAddressDelegate> delegate;
}
@property(nonatomic,retain)GoodReceiverVO* mGoodReceiver;
@property(nonatomic,retain)id<CustomAddressDelegate>delegate;
-(void)showAddress;
-(IBAction)setDefaultAddress:(id)sender;
-(IBAction)deleteAddress:(id)sender;
-(IBAction)editAddress:(id)sender;
@end
