//
//  OTSPadProductPromotionView.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-20.
//
//

#import <UIKit/UIKit.h>
#import "OTSPadProductDetailView.h"

@interface OTSPadProductPromotionView : UIView
<UITableViewDelegate, UITableViewDataSource>
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (assign)  id<OTSPadProductDetailViewDelegate>  delegate;

-(void)updateWithGift:(NSArray*)aGifts exchangeBuys:(NSArray*)aExchangeBuys;

@end
