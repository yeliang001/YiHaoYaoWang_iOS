//
//  ProvinceChooseAddressViewController.h
//  yhd
//
//  Created by dev dev on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@protocol ProvinceChooseAddressDelegate <NSObject>
@required
-(void)ProvinceChooseAtIndex:(int)index:(NSArray*)provinceArray;

@end 
@interface ProvinceChooseAddressViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * mprovince;//provicevo
    NSNumber * mProvinceId;
    int mproviceselectedindex;
    IBOutlet UITableView * mTableView;
    
    id<ProvinceChooseAddressDelegate>delegate;
}
@property(nonatomic,retain)NSArray * mprovince;
@property(nonatomic,retain)id<ProvinceChooseAddressDelegate>delegate;
@end
