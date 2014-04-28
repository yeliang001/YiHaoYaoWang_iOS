//
//  ProvinceViewController.h
//  yhd
//
//  Created by  on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProvinceVO.h"
#import "BaseViewController.h"
@protocol ProvinceViewControllerDelegate <NSObject>

- (void)provinceItemSelected:(ProvinceVO *)item;

@end
@interface ProvinceViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>{
    NSArray *listData;
    NSMutableDictionary *provinceDic;
    NSMutableDictionary *provinceIDDic;
    IBOutlet UITableView * provinceTableView;
    id<ProvinceViewControllerDelegate> provinceDelegate;
}
@property(nonatomic,retain)NSArray *listData;
@property(nonatomic,assign)id<ProvinceViewControllerDelegate> provinceDelegate;
@end
