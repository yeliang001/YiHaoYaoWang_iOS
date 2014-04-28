//
//  OTSProductDtTab2View.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-26.
//
//

#import <UIKit/UIKit.h>

typedef enum
{
    kPadProdDetailTabDescription = 1    // 详情
    , kPadProdDetailTabComment          // 评论
    , kPadProdDetailTabPromotion        // 促销
    , kPadProdDetailTabSameCate         // 同类推荐
}OTSPadProdDetailTabType;

@protocol OTSProductDtTabViewDelegate
@required
-(void)tabTappedWithIndex:(OTSPadProdDetailTabType)anIndex;
@end

@interface OTSProductDtTab2View : UIView
@property (retain, nonatomic) IBOutlet UIView *tabViewSameCate;
@property (retain, nonatomic) IBOutlet UIView *tabViewPromotion;
@property (retain, nonatomic) IBOutlet UIView *tabViewComment;
@property (retain, nonatomic) IBOutlet UIView *tabViewProfile;

@property (retain, nonatomic) IBOutlet UIButton *btnSameCate;
@property (retain, nonatomic) IBOutlet UIButton *btnPromotion;
@property (retain, nonatomic) IBOutlet UIButton *btnComment;
@property (retain, nonatomic) IBOutlet UIButton *btnProfile;

@property (retain, nonatomic) IBOutlet UILabel *labelSameCate;
@property (retain, nonatomic) IBOutlet UILabel *labelPromotion;
@property (retain, nonatomic) IBOutlet UILabel *labelComment;
@property (retain, nonatomic) IBOutlet UILabel *labelProfile;

@property (retain, nonatomic) IBOutlet UIImageView *imageViewSameCate;
@property (retain, nonatomic) IBOutlet UIImageView *imageViewPromotion;
@property (retain, nonatomic) IBOutlet UIImageView *imageViewComment;
@property (retain, nonatomic) IBOutlet UIImageView *imageViewProfile;

@property (assign) id<OTSProductDtTabViewDelegate>  delegate;
-(IBAction)tabClicked:(id)sender;
-(void)selectTabIndex:(int)aTabIndex;
-(void)hidePromotionTab:(BOOL)aIsHide;

@end
