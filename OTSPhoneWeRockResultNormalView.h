//
//  OTSPhoneWeRockResultNormalView.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-10-26.
//
//

#import <UIKit/UIKit.h>
#import "UIView+LoadFromNib.h"
#include "OTSPhoneWebRock.h"

@class RockResultV2;

typedef enum  {
    kRockReultActionVanish = 0
    , kRockReultActionAddToCart
    , kRockReultActionAddToFav
    , kRockReultActionGetTicket
    , kRockReultActionActivateGame
    , kRockReultActionToDetail
    , kRockReultActionCheckPrize
    , kRockReultActionRockNow
}OTSRockReultActionType;


//
@protocol OTSPhoneWeRockResultNormalViewDelegate
@required
-(void)handleRockResultAction:(OTSRockReultActionType)anActionType resultObject:(id)aResultObj;
@end


//
@interface OTSPhoneWeRockResultNormalView : UIView

@property (retain, nonatomic) IBOutlet UIImageView *bgGrayIV;
@property (retain, nonatomic) IBOutlet UIImageView *bgYellowIV;
@property (retain, nonatomic) IBOutlet UIImageView *bgSunIV;

@property (retain, nonatomic) IBOutlet UIView *productInfoView;
@property (retain, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (retain, nonatomic) IBOutlet UIImageView *productPictureIV;
@property (retain, nonatomic) IBOutlet UILabel *productCountDownLabel;
@property (retain, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (retain, nonatomic) IBOutlet UILabel *productMarketPriceLabel;
@property (retain, nonatomic) IBOutlet UIImageView *productCornerMarkIV;
@property (retain, nonatomic) IBOutlet UILabel *productRobTimeLabel;



@property (retain, nonatomic) IBOutlet UIView *ticketInfoView;
@property (retain, nonatomic) IBOutlet UILabel *ticketPriceLabel;
@property (retain, nonatomic) IBOutlet UILabel *ticketTimeLabel;

@property (retain, nonatomic) IBOutlet UIImageView *gamePicIV;


@property (retain, nonatomic) IBOutlet UIImageView *cornerIV;
@property (retain, nonatomic) IBOutlet UIImageView *cornerYellowIV;

@property (retain, nonatomic) IBOutlet UILabel *resultNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *resultCountLabel;

@property (retain, nonatomic) IBOutlet UIImageView *starIV;

@property (retain, nonatomic) IBOutlet UIButton *vanishBtn;
@property (retain, nonatomic) IBOutlet UIButton *addToCartBtn;
@property (retain, nonatomic) IBOutlet UIButton *addFavBtn;
@property (retain, nonatomic) IBOutlet UIButton *getTicketBtn;
@property (retain, nonatomic) IBOutlet UIButton *gameActiveBtn;
@property (retain, nonatomic) IBOutlet UIButton *goToDetailBtn;
@property (retain, nonatomic) IBOutlet UIImageView *mallLogo;
@property (retain, nonatomic) IBOutlet UIImageView *groupLogo;
@property (retain, nonatomic) IBOutlet UIImageView *groupProductIV;
@property (retain, nonatomic) IBOutlet UILabel *groupPriceLabel;
@property (retain, nonatomic) IBOutlet UILabel *groupCountLabel;
@property (retain, nonatomic) IBOutlet UIImageView *bootLine;

@property (retain, nonatomic) IBOutlet UIImageView *cornerMarkSuperIV;
@property (retain, nonatomic) IBOutlet UIImageView *cornerMarkHalfIV;
@property (retain, nonatomic) IBOutlet UIImageView *cornerMarkGuessIV;
@property (retain, nonatomic) IBOutlet UIImageView *weRockMainPrizeOK;
@property (retain, nonatomic) IBOutlet UIView *productInfoMainView;
@property (retain, nonatomic) IBOutlet UIImageView *prizeProgressBg;
@property (retain, nonatomic) IBOutlet UIImageView *prizeProgress;
@property (retain, nonatomic) IBOutlet UILabel *prizeTimeLabel;
@property (retain, nonatomic) IBOutlet UIButton *prizeAgainBtn;
@property (retain, nonatomic) IBOutlet UIImageView *prizeSuccessIV;
@property (retain, nonatomic) IBOutlet UIImageView *prizeFaildIV;



@property (assign)    id<OTSPhoneWeRockResultNormalViewDelegate>    delegate;
@property (retain)    RockResultV2                                  *rockResult;

+(OTSPhoneWeRockResultNormalView*)viewFromNibWithOwner:(id)aOwner type:(OTSWeRockResultType)aType rockResult:(RockResultV2*)rockResult;

-(void)setMarketPrice:(NSString*)aMarketPriceString;

-(IBAction)vanishAction:(id)sender;
-(IBAction)addToCartAction:(id)sender;
-(IBAction)addToFavAction:(id)sender;
-(IBAction)getTicketAction:(id)sender;
-(IBAction)activateGameAction:(id)sender;
-(IBAction)goToDetail:(id)sender;
@end
