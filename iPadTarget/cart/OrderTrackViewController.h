//
//  OrderTrackViewController.h
//  yhd
//
//  Created by  on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TopView.h"
#import "ProductListTopView.h"
@class OrderV2,OrderTrackView;
@interface OrderTrackViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>{
    TopView *topView;
    ProductListTopView *productListTopView;
    IBOutlet UITableView *orderDetailTableView;
    IBOutlet UIImageView *orderDetailTableFootView;
    IBOutlet UITableView *trackTableView;
    
    IBOutlet UILabel *statusLabe;
    IBOutlet UIView *trackView;
    UIButton *nextBut;
    UIButton *previousBut;
    OrderV2 *orderDetail;
    OrderV2 *childOrder;
    NSInteger childOrderIndex;
    NSMutableArray *trackData;
    BOOL isOut;//是否已出库
    BOOL isFinish;//是否配送成功
    
    
//    OrderTrackView *orderTrackView1;
//    OrderTrackView *orderTrackView2;
//    OrderTrackView *orderTrackView3;
//    UIImageView *jian1;
//    UIImageView *jian2;
    
}
@property(nonatomic,retain)OrderV2 *orderDetail;
@property(nonatomic,retain)OrderV2 *childOrder;
@property(nonatomic,retain)NSMutableArray *trackData;
@end
