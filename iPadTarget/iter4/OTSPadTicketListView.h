//
//  OTSPadTicketListView.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-28.
//
//

#import <UIKit/UIKit.h>

//抵用卷类型 0:所有 1:未使用 2：已使用 3：已过期

typedef enum {
    kTicketTabAll = 0           // 0:所有
    , kTicketTabUnused          // 未使用
    , kTicketTabUsed            // 已使用
    , kTicketTabExpired         // 已过期
}OTSTicketTabType;

@protocol OTSPadTicketListViewDelegate
@required
-(void)ticketTabSelected:(OTSTicketTabType)aSelectedType;
@end

@interface OTSPadTicketListView : UIView
@property (retain, nonatomic) IBOutlet UIButton *btnUnused;
@property (retain, nonatomic) IBOutlet UIButton *btnUsed;
@property (retain, nonatomic) IBOutlet UIButton *btnExpired;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIView *emptyView;
@property (retain, nonatomic) IBOutlet UILabel *emptyLabel;

@property (assign) id<OTSPadTicketListViewDelegate>     delegate;

-(IBAction)btnSelected:(id)sender;
@end
