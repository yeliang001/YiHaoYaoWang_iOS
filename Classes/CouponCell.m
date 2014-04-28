//
//  CouponCell.m
//  TheStoreApp
//
//  Created by yuan jun on 12-10-25.
//
//

#import "CouponCell.h"

@implementation CouponCell
@synthesize descriptLab,countlabel,lastDate,stastusImg,regBtn;
- (void)dealloc{
    [descriptLab release];
    [countlabel release];
    [lastDate release];
    [stastusImg release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView* bgImg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 110)];
        bgImg.image=[UIImage imageNamed:@"couponcell.png"];
        [self.contentView addSubview:bgImg];
        [bgImg release];
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        //"抵用卷金额："
        countlabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 50)];
        [countlabel setBackgroundColor:[UIColor clearColor]];

        [countlabel setTextAlignment:NSTextAlignmentRight];
        [countlabel setTextColor:[UIColor colorWithRed:204.0/255.0 green:0 blue:0 alpha:1.0]];
        [countlabel setFont:[UIFont systemFontOfSize:22.0]];
        [self.contentView addSubview:countlabel];
        
        //"抵用卷描述："
        descriptLab=[[UILabel alloc] initWithFrame:CGRectMake(85, 5,225, 40)];
        [descriptLab setBackgroundColor:[UIColor clearColor]];
        [descriptLab setFont:[UIFont systemFontOfSize:16.0]];
        [descriptLab setNumberOfLines:2];
        [self.contentView addSubview:descriptLab];

        //"抵用卷有效日期："
        lastDate=[[UILabel alloc] initWithFrame:CGRectMake(85, 35, 225, 40)];
        [lastDate setBackgroundColor:[UIColor clearColor]];
        [lastDate setFont:[UIFont systemFontOfSize:13.0]];
        [lastDate setNumberOfLines:2];
        [lastDate setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
        [self.contentView addSubview:lastDate];

        //"抵用卷规则按钮："
        regBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        regBtn.frame=CGRectMake(85, 70, 76, 30);
        [regBtn setBackgroundColor:[UIColor clearColor]];
        [regBtn setTitle:@"规则" forState:UIControlStateNormal];
        [regBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [regBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [regBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [regBtn setBackgroundImage:[UIImage imageNamed:@"regulation.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:regBtn];

        stastusImg=[[UIImageView alloc] initWithFrame:CGRectMake(320-61, 0, 61, 61)];
        [self.contentView addSubview:stastusImg];

        CGRect rect = self.bounds;
        rect.size.height=190;
        UIView * view  = [[UIView alloc] initWithFrame:rect];
        view.tag=10081;
        view.hidden=YES;
        [view setBackgroundColor:[UIColor whiteColor]];
        view.layer.opacity = 0.5;
        [self.contentView addSubview:view];
        [view release];

    }
    return self;
}
-(void)addAlphaCover{
    UIView*v=[self.contentView viewWithTag:10081];
    v.hidden=NO;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
