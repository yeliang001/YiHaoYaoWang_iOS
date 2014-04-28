//
//  TuanCell.h
//  TheStoreApp
//
//  Created by LinPan on 13-12-23.
//
//

#import <UIKit/UIKit.h>

@interface TuanCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *productImgView;
@property (retain, nonatomic) IBOutlet UILabel *productNameLbl;
@property (retain, nonatomic) IBOutlet UILabel *nowPriceLbl;
@property (retain, nonatomic) IBOutlet UILabel *oldPriceLbl;
@property (retain, nonatomic) IBOutlet UILabel *priceOffLbl;
@property (retain, nonatomic) IBOutlet UILabel *buyedCountLbl;

@end
