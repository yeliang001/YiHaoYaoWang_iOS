//
//  OTSPadProductDetailView.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-16.
//
//

#import <UIKit/UIKit.h>
#import "OTSProductDtTab2View.h"

@class OTSProductDtTab2View;
@class OTSPadProductDtMovingHeadView;
@class OTSPadProductCommentView;
@class OTSPadProductPromotionView;
@class OTSPadProductSameCateView;


@protocol  OTSPadProductDetailViewDelegate
@required
-(BOOL)isPopped;
-(void)scrollToTabIndex;
@end

@interface OTSPadProductDetailView : UIView
<UIScrollViewDelegate, OTSProductDtTabViewDelegate>

@property (retain, nonatomic) IBOutlet UILabel *productNameLabel;
@property (retain, nonatomic) IBOutlet UIScrollView *baseScrollView;
@property (retain, nonatomic) IBOutlet OTSProductDtTab2View *tabView;
@property (retain, nonatomic) IBOutlet OTSPadProductDtMovingHeadView *movingHeadView;
@property (retain, nonatomic) IBOutlet UIButton *closeBtn;
@property (retain, nonatomic) IBOutlet UIImageView *naviBgIV;

@property (retain, nonatomic) UIWebView *webView;
@property (retain, nonatomic) OTSPadProductCommentView *commentView;
@property (retain, nonatomic) OTSPadProductPromotionView *promotionView;
@property (retain, nonatomic) OTSPadProductSameCateView *sameCateView;

@property (assign)  id<OTSPadProductDetailViewDelegate>  delegate;

-(IBAction)closeMe:(id)sender;
//-(void)adjustContentSizeIfPopped;

@end
