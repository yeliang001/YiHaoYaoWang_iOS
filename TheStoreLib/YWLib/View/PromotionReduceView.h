//
//  PromotionReduceView.h
//  TheStoreApp
//
//  Created by LinPan on 14-1-21.
//
//

#import <UIKit/UIKit.h>
//购物车中显示满减的View
@interface PromotionReduceView : UIView

- (id)initWithFrame:(CGRect)frame promotionDesc:(NSString *)desc promotionResult:(NSString *)result;
@end
