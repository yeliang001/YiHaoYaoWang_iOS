//
//  OTSPadImageSliderView.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-16.
//
//

#import <UIKit/UIKit.h>

@interface OTSPadImageSliderView : UIView
@property (retain, nonatomic) UITapGestureRecognizer *tapGesture;
@property (retain, nonatomic) IBOutlet UIScrollView *thumbScrollView;
@property (retain, nonatomic) IBOutlet UIImageView *pictureIV;

@property (retain) ProductVO    *product;

-(IBAction)thumbnailTapped:(id)sender;

-(void)updateUI;
-(void)updateUIWithProduct:(ProductVO*)aProduct;

@end
