//
//  OTSProductActivityView.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-19.
//
//

#import <UIKit/UIKit.h>

@interface OTSProductActivityView : UIView
@property (retain, nonatomic) IBOutlet UIView *giftView;
@property (retain, nonatomic) IBOutlet UIView *exchangeBuyView;

@property (retain, nonatomic) IBOutlet UIImageView *giftBgIV;
@property (retain, nonatomic) IBOutlet UIImageView *exchangeBuyIV;

@property (retain, nonatomic) IBOutlet UILabel *giftLabel;
@property (retain, nonatomic) IBOutlet UILabel *exchangeBuyLabel;

@property (retain, nonatomic) IBOutlet UIImageView *giftBuyIv;
@property (retain, nonatomic) IBOutlet UIImageView *exchangeBuyDotIv;

@property (assign) id   delegate;

-(IBAction)giftTapped:(id)sender;
-(IBAction)exchangeBuyTapped:(id)sender;

-(void)setGiftTitle:(NSString*)aTitle;
-(void)setExchangeBuyTitle:(NSString*)aTitle;
-(void)layoutMe;

@end
