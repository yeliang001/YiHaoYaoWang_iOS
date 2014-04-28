//
//  PromotionGiftCellView.h
//  TheStoreApp
//
//  Created by LinPan on 14-1-22.
//
//

#import <UIKit/UIKit.h>
@class GiftInfo;
//购物车中显示赠品的View
@interface PromotionGiftCellView : UIView
{
    UIButton *_deleteButton;
}

@property (retain, nonatomic) GiftInfo *gift;
- (id)initWithFrame:(CGRect)frame giftName:(NSString *)name count:(NSInteger)count;
- (void)addTarget:(id)target action:(SEL)action index:(NSInteger)index;
@end
