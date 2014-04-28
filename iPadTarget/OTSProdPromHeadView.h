//
//  OTSProdPromHeadView.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-11-20.
//
//

#import <UIKit/UIKit.h>

@interface OTSProdPromHeadView : UIView
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UIImageView *symbolIV;
@property (retain, nonatomic) IBOutlet UIImageView *markIV;

-(void)swtichToExchangeBuy;
-(void)switchToPoppedMode;

+(float)height;

@end
