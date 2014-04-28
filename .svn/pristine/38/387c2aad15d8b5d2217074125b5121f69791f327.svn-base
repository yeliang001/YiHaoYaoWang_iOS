//
//  GroupBuyOrderDetail.h
//  TheStoreApp
//
//  Created by jiming huang on 12-2-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrouponOrderVO.h"
#import "GroupBuyService.h"
#import "OnlinePay.h"

@class OTSChangePayButton;

@interface GroupBuyOrderDetail : OTSBaseViewController<UITableViewDelegate,UITableViewDataSource> {
    IBOutlet UIScrollView *m_ScrollView;//
    IBOutlet UIView *m_DetailView;//团购商品明细
    IBOutlet UIScrollView *m_DetailScrollView;//团购商品明细scrollview
    
    bool m_ThreadIsRunning;
    NSInteger m_CurrentState;
    
    NSNumber *m_OrderId;//传入参数，订单id
    GrouponOrderVO *m_OrderVO;//订单VO
    
    GroupBuyService *m_Service;
    NSString    *groupImageUrl;
}
@property(nonatomic,retain)NSString *groupImageUrl;
@property(nonatomic,retain)NSNumber *m_OrderId;
@property(nonatomic, retain)OTSChangePayButton *changePayBtn;

-(IBAction)returnBtnClicked:(id)sender;
-(void)updateOrderDetail;
-(void)setUpThread;
-(void)stopThread;
@end
