//
//  OTSPadProductDetailInfoView.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-16.
//
//

#import <UIKit/UIKit.h>

@class OTSLineThroughLabel;
@class OTSAddMinusTextField;
@class OTSPadProductStarView;
@class OTSProductActivityView;

@interface OTSPadProductDetailInfoView : UIView
@property (retain, nonatomic) IBOutlet UILabel *priceLbl;
@property (retain, nonatomic) IBOutlet OTSLineThroughLabel *marketPriceLbl;
@property (retain, nonatomic) IBOutlet OTSAddMinusTextField *countTextFd;
@property (retain, nonatomic) IBOutlet OTSPadProductStarView *starView;
@property (retain, nonatomic) IBOutlet OTSProductActivityView *activityView;
@property (retain, nonatomic) IBOutlet UILabel *storageStatLbl;
@property (retain, nonatomic) IBOutlet UIButton *addToCartBtn;
@property (retain, nonatomic) IBOutlet UIButton *addToFavBtn;
@property (retain, nonatomic) IBOutlet UIButton *seeCommentBtn;

@property (retain, nonatomic) IBOutlet UIView *giftNoteView;
@property (retain, nonatomic) IBOutlet UILabel *buyAmountStaticLbl;

-(IBAction)addToCartAction:(id)sender;
-(IBAction)addToFavAction:(id)sender;
-(IBAction)seeCommentAction:(id)sender;

-(void)updateUIWithProduct:(ProductVO*)aProduct;

-(void)updateUIWithGifts:(NSArray*)aGifts;
-(void)updateUIWithExchangeBuys:(NSArray*)aExchangeBuys;

@property (assign) id   delegate;

@end
