//
//  OTSAnimationTableView.h
//  TheStoreApp
//
//  Created by jiming huang on 12-10-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductVO;
@class OTSAnimationTableView;
@class MobilePromotion;
@class MobilePromotionVO;

@protocol OTSAnimationTableViewDelegate

@required
-(void)promotionTableSizeChanged:(OTSAnimationTableView *)animationTableView;
-(void)enterCashList:(MobilePromotionVO *)mobilePromotionVO;//进入满减列表
-(void)enterNNList:(MobilePromotionVO *)mobilePromotionVO;//进入N元n件列表

@end

@interface OTSAnimationTableView : UIView<UITableViewDelegate,UITableViewDataSource> {
    UITableView *m_TableView;
    int m_UnFoldIndexForGift;
    NSArray *m_Array; //赠品列表
    NSArray *mjArray;//满减列表
    NSArray *m_NNArray;//N元n件列表
    id m_Delegate;
}

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style productVO:(ProductVO *)productVO delegate:(id<OTSAnimationTableViewDelegate>)delegate;
@end
