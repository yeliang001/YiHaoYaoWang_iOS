//
//  CartCashPromotionCell.h
//  TheStoreApp
//
//  Created by yuan jun on 12-11-29.
//
//

#import <UIKit/UIKit.h>

@interface CartCashPromotionCell : UITableViewCell{
    UILabel* cashDescription;
    UILabel* cashAmount;
}
@property(nonatomic,retain)    UILabel* cashDescription;
@property(nonatomic,retain)   UILabel* cashAmount;
@end
