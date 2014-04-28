//
//  OtherAddressView.h
//  yhd
//
//  Created by dev dev on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "OtherAddressViewCell.h"

@interface OtherAddressView : BaseView<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,OtherAddressViewDelegate>
{
    NSArray* mReceiveList;//GoodReceiverVO
    
    IBOutlet UITableView * mTableView;
    IBOutlet UIImageView * mImageView;
    NSInteger mreceivelistselectedindex;
    BOOL mIsAllAddressunavailable;
    
    IBOutlet UILabel * mProvinceLabel;
    IBOutlet UILabel * mProvinceAfterLabel;
    IBOutlet UIImageView * mGoToNewImageView;
}
@property(nonatomic,retain)NSArray* mReceiveList;
@property(nonatomic,assign)BOOL mIsAllAddressunavailable;
-(IBAction)closeClicked:(id)sender;
-(IBAction)newaddressClicked:(id)sender;
@end
