//
//  PromotionViewController.h
//  TheStoreApp
//
//  Created by yuan jun on 12-10-26.
//
//

#import <UIKit/UIKit.h>
@interface PromotionViewController : OTSBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *giftTable;
}

@property (retain, nonatomic) NSMutableArray *giftPromotionList;//所有满赠的促销 购物车传入
@property (retain, nonatomic) NSMutableArray *selectedGiftList; //选中的赠品 购物车传入
@end
