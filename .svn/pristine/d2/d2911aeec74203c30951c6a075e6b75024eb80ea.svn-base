//
//  OTSPhoneWebRockInventoryCell.h
//  TheStoreApp
//
//  Created by Yim Daniel on 12-10-30.
//
//

#import <UIKit/UIKit.h>


@class StorageBoxVO;

@interface OTSPhoneWebRockInventoryCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIView *productView;
@property (retain, nonatomic) IBOutlet UILabel *productMarkeetPriceLabel;
@property (retain, nonatomic) IBOutlet UILabel *productPromotionPriceLabel;
@property (retain, nonatomic) IBOutlet UILabel *productTimeLimitLabel;  // 限时抢购
@property (retain, nonatomic) IBOutlet UILabel *productTimeDownLabel;   // 24:00:00
@property (retain, nonatomic) IBOutlet UIImageView *productPicIV;


@property (retain, nonatomic) IBOutlet UIView *ticketView;
@property (retain, nonatomic) IBOutlet UILabel *ticketValidDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *ticketMoneyLabel;
@property (retain, nonatomic) IBOutlet UIButton *ticketRuleBtn;

@property (retain, nonatomic) IBOutlet UILabel *statusLabel;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UIButton *addCartBtn;
@property (retain, nonatomic) IBOutlet UIImageView *expiredIV;

@property (assign)  id                delegate;

@property (retain) StorageBoxVO*       dataModel;


-(void)updateWithModel:(StorageBoxVO*)aModel;

-(IBAction)addCartAction:(id)sender;
-(IBAction)showRuleAction:(id)sender;

@end



