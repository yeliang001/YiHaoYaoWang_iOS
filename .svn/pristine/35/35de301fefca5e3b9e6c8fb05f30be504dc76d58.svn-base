//
//  CountyChooseAddressViewController.h
//  yhd
//
//  Created by dev dev on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@protocol CountyChooseAddressDelegate<NSObject>
@required
-(void)CountyChooseAtIndex:(int)index:(NSArray*)countyArray;
@end
@interface CountyChooseAddressViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * mcounty;//countyvo
    NSNumber * mCountyId;
    NSNumber * mCityId;
    int mcountyselectedindex;
    IBOutlet UITableView * mtableview;
    
    id<CountyChooseAddressDelegate>delegate;
}
@property(nonatomic,retain)NSArray* mcounty;
@property(nonatomic,retain)NSNumber* mCityId;
@property(nonatomic,retain)id<CountyChooseAddressDelegate>delegate;
@end
