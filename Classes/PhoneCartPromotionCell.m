//
//  PhoneCartPromotionCell.m
//  TheStoreApp
//
//  Created by yuan jun on 12-11-26.
//
//

#import "PhoneCartPromotionCell.h"

@implementation PhoneCartPromotionCell
@synthesize  descriptionLab;
@synthesize  titleLab,checkBtn;
-(void)dealloc{
    [titleLab release];
    [descriptionLab release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor=[UIColor whiteColor];
        checkBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        checkBtn.frame=CGRectMake(10, 7, 30, 30);
        [checkBtn setBackgroundImage:[UIImage imageNamed:@"goodReceiver_unsel.png"] forState:UIControlStateNormal];
        [checkBtn setBackgroundImage:[UIImage imageNamed:@"goodReceiver_sel.png"] forState:UIControlStateSelected];
        [self.contentView addSubview:checkBtn];
        
        titleLab=[[UILabel alloc] initWithFrame:CGRectMake(40, 0, 145, 44)];
        titleLab.font=[UIFont systemFontOfSize:15];
        titleLab.numberOfLines=2;
        titleLab.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:titleLab];
        
        descriptionLab=[[UILabel alloc] initWithFrame:CGRectMake(155, 0, 115, 44)];
        descriptionLab.textAlignment=NSTextAlignmentRight;
        descriptionLab.font=[UIFont systemFontOfSize:14];
        descriptionLab.backgroundColor=[UIColor clearColor];
        descriptionLab.textColor=[UIColor colorWithRed:(68.0/255.0) green:(84.0/255.0) blue:(135.0/255.0) alpha:1];
        [self.contentView addSubview:descriptionLab];
    }
    return self;
}
-(void)isNotcashCell{
    checkBtn.hidden=YES;
    titleLab.frame=CGRectMake(10, 0, 90, 44);
    descriptionLab.frame=CGRectMake(115, 0, 155, 44);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end

