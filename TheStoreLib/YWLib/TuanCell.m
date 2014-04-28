//
//  TuanCell.m
//  TheStoreApp
//
//  Created by LinPan on 13-12-23.
//
//

#import "TuanCell.h"

@implementation TuanCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_productImgView release];
    [_productNameLbl release];
    [_nowPriceLbl release];
    [_oldPriceLbl release];
    [_priceOffLbl release];
    [_buyedCountLbl release];
    [super dealloc];
}
@end
