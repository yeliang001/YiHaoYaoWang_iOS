//
//  OTSAdModelBView.h
//  TheStoreApp
//
//  Created by jiming huang on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OTSAdModelBViewDelegate;
@class AdvertisingPromotionVO;
@class GrouponVO;
@class ProductVO;

@interface OTSAdModelBView : UIView<UITableViewDelegate,UITableViewDataSource> {
    id<OTSAdModelBViewDelegate> m_Delegate;
    AdvertisingPromotionVO *m_AdVO;
    BOOL m_IsFold;//是否是折叠状态
    UITableView *m_TableView;
    UIImageView *m_BottomImageView;
    UIImageView *m_ArrayImageView;
    UIButton *m_FoldButton;
    UIButton *m_BigFoldButton;
}

-(id)initWithFrame:(CGRect)frame delegate:(id)delegate tag:(int)tag;
-(void)reloadModelBView;
-(BOOL)isFold;
-(void)setIsFold:(BOOL)isFold;
@end

@protocol OTSAdModelBViewDelegate <NSObject>
-(AdvertisingPromotionVO *)adModelBViewData:(OTSAdModelBView *)adModelBView;
-(void)adModelBView:(OTSAdModelBView *)adModelBView foldBtnClicked:(UIButton *)foldBtn;
-(void)adModelBView:(OTSAdModelBView *)adModelBView enterGrouponDetail:(GrouponVO *)grouponVO;
-(void)adModelBView:(OTSAdModelBView *)adModelBView enterProductDetail:(ProductVO *)productVO;
-(void)adModelBView:(OTSAdModelBView *)adModelBView didSelectRowAtIndexPath:(NSIndexPath * )indexPath;
-(void)adModelBView:(OTSAdModelBView *)adModelBView keyWordBtnClicked:(UIButton *)keyWordBtn;
@end
