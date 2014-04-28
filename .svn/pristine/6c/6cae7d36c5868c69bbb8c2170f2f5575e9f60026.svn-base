//
//  CityChooseAddressViewController.h
//  yhd
//
//  Created by dev dev on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@protocol CityChooseAddressDelegate<NSObject>
@required
-(void)CityChooseAtIndex:(int)index:(NSArray*)cityArray;
@end
@interface CityChooseAddressViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray* mcity;//cityvo
    NSNumber * mcityId;
    NSNumber * mProvinceId;
    int mcityselectedindex;
    IBOutlet UITableView* mTableView;
    
    id<CityChooseAddressDelegate>delegate;
}
@property(nonatomic,retain)NSArray* mcity;
@property(nonatomic,retain)NSNumber* mProvinceId;
@property(nonatomic,retain)id<CityChooseAddressDelegate>delegate;
@end
