//
//  RedemptionListViewController.h
//  TheStoreApp
//
//  Created by yuan jun on 12-11-27.
//
//

#import <UIKit/UIKit.h>
#import "MobilePromotionVO.h"
#import "ProductVO.h"
@protocol RedemptionSelectedDelegate <NSObject>
-(void)didSelectRedemption:(NSArray*)selRedemptionArray indexPath:(NSIndexPath*)selIndexPath;
-(void)didSelectRedemption:(ProductVO*)product;
@end
@interface RedemptionListViewController : OTSBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    MobilePromotionVO* mobilePromotionVO;
    NSMutableArray* selectedRedemptionArray;
    NSMutableArray* currentSelectedRedemptionArray;
    id<RedemptionSelectedDelegate>delegate;
    NSIndexPath* fromIndex;
}
@property(nonatomic,retain)NSIndexPath* fromIndex;
@property(nonatomic,retain)NSMutableArray* selectedRedemptionArray;
@property(nonatomic,assign)id<RedemptionSelectedDelegate>delegate;
@property(nonatomic,retain)   MobilePromotionVO* mobilePromotionVO;
@end
