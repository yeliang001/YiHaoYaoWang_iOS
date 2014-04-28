//
//  OTSPadProductSameCateView.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-20.
//
//

#import <UIKit/UIKit.h>
#import "OTSPadProductDetailView.h"

@class Page;

@interface OTSPadProductSameCateView : UIView
<UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (assign)  id<OTSPadProductDetailViewDelegate>  delegate;

-(void)updateWithPage:(Page*)aPage;

@end
