//
//  invoiceContentViewController.h
//  yhd
//
//  Created by xuexiang on 12-8-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@protocol invoiceContentChooseDelegate <NSObject>
@required
-(void)contentChooseAtIndex:(int)index:(NSArray*)contentArray;
@end

@interface invoiceContentViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>{
    id<invoiceContentChooseDelegate> delegate;
    NSArray * contentArray;
}
@property (nonatomic, assign)id<invoiceContentChooseDelegate> delegate;
@property (nonatomic, retain)NSArray * contentArray;
@end
