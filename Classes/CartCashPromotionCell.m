//
//  CartCashPromotionCell.m
//  TheStoreApp
//
//  Created by yuan jun on 12-11-29.
//
//

#import "CartCashPromotionCell.h"

@implementation CartCashPromotionCell
@synthesize cashAmount,cashDescription;
-(void)dealloc{
     [cashDescription release];
     [cashAmount release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        cashDescription=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 44)];
        cashDescription.backgroundColor=[UIColor clearColor];
        cashDescription.textColor=[UIColor blackColor];
        cashDescription.numberOfLines=2;
        cashDescription.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:cashDescription];
        
        cashAmount=[[UILabel alloc] initWithFrame:CGRectMake(165, 0, 120, 44)];
        cashAmount.backgroundColor=[UIColor clearColor];
        cashAmount.textAlignment=NSTextAlignmentRight;
        cashAmount.textColor=[UIColor colorWithRed:0.686 green:0.078 blue:0.01 alpha:1];
        cashAmount.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:cashAmount];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
