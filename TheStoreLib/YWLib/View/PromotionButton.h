//
//  PromotionButton.h
//  TheStoreApp
//
//  Created by LinPan on 14-1-15.
//
//

#import <UIKit/UIKit.h>

@class PromotionInfo;
@class ConditionInfo;

@interface PromotionButton : UIButton

@property (retain, nonatomic) PromotionInfo *promotion;
@property (retain, nonatomic) ConditionInfo *condition;


- (id)initWithFrame:(CGRect)frame promotion:(PromotionInfo *)promotion condition:(ConditionInfo *)condition;
@end
