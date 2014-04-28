//
//  PromotionCell.m
//  TheStoreApp
//
//  Created by yuan jun on 12-10-29.
//
//

#import "PromotionCell.h"
@implementation PromotionCell
@synthesize isMulti,isNotEnough;
@synthesize productIcon,checkImg,tittleLabel,priceLab,conditionLab;
@synthesize marketPriceLbl,flogyView,notEnough;
-(void)dealloc{
    [notEnough release];
    [flogyView release];
    [checkImg release];
    [conditionLab release];
    [marketPriceLbl release];
    [priceLab release];
    [tittleLabel release];
    [productIcon release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle=UITableViewCellSelectionStyleNone;


        tittleLabel=[[UILabel alloc] initWithFrame:CGRectMake(78, 16, 150, 40)];
        tittleLabel.font=[UIFont systemFontOfSize:15];
        tittleLabel.textColor=[UIColor blackColor];
        tittleLabel.numberOfLines=2;
        tittleLabel.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:tittleLabel];

        priceLab=[[UILabel alloc] initWithFrame:CGRectMake(78, 55, 70, 20)];
        priceLab.textColor=[UIColor blackColor];
        priceLab.font=[UIFont systemFontOfSize:14];
        priceLab.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:priceLab];

        marketPriceLbl=[[StrikeThroughLabel alloc] initWithFrame:CGRectMake(148, 55, 70, 20)];
        marketPriceLbl.textColor=[UIColor grayColor];
        marketPriceLbl.font=[UIFont systemFontOfSize:14];
        marketPriceLbl.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:marketPriceLbl];
        
        conditionLab=[[UILabel alloc] initWithFrame:CGRectMake(220, 55, 100, 20)];
        conditionLab.textColor=[UIColor grayColor];
        conditionLab.font=[UIFont systemFontOfSize:14];
        conditionLab.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:conditionLab];
        
        checkImg=[[UIImageView alloc] initWithFrame:CGRectMake(310-25, 32, 25, 25)];
        [self.contentView addSubview:checkImg];
        
        flogyView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
        flogyView.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.5];
        flogyView.alpha=0.9;
        [self.contentView addSubview:flogyView];
        flogyView.hidden=YES;

        
        notEnough=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
        UIImageView*notEnoughLog=[[UIImageView alloc] initWithFrame:CGRectMake(320-62 , 0, 62, 62)];
        notEnoughLog.image=[UIImage imageNamed:@"gift_nil.png"];
        [notEnough addSubview:notEnoughLog];
        [notEnoughLog release];
        notEnough.hidden=YES;
        [self.contentView addSubview:notEnough];
        productIcon=[[OTSImageView alloc] initWithFrame:CGRectMake(10, 15, 60, 60)];
        //        [productIcon setImage:[UIImage imageNamed:@"defaultimg85.png"]];
        [self.contentView addSubview:productIcon];

    }
    return self;
}
-(void)addCheckView{
    if (isMulti)
        checkImg.image=[UIImage imageNamed:@"cutoff_multi_check.png"];
    else
        checkImg.image=[UIImage imageNamed:@"cutoff_single_check.png"];

}


-(void)selectCell{
    if (isMulti){
        if (checkImg.image==[UIImage imageNamed:@"cutoff_multi_selected.png"]) {
            checkImg.image=[UIImage imageNamed:@"cutoff_multi_check.png"];
        }else{
        checkImg.image=[UIImage imageNamed:@"cutoff_multi_selected.png"];
        }
    }
    else
        if (checkImg.image==[UIImage imageNamed:@"cutoff_single_selected.png"]) {
            checkImg.image=[UIImage imageNamed:@"cutoff_single_check.png"];
        }else{
            checkImg.image=[UIImage imageNamed:@"cutoff_single_selected.png"];
        }
}
-(void)hasNoMore{
    flogyView.hidden=NO;
    notEnough.hidden=NO;
    self.userInteractionEnabled = NO;
}
-(void)canNotJoin{
    flogyView.hidden=NO;
    self.userInteractionEnabled = NO;
}
-(void)productIcon:(NSString*)iconUrl{
    [productIcon loadImgUrl:iconUrl];
    
//    if (iconUrl==nil) {
//        productIcon.image=[UIImage imageNamed:@"defaultimg85.png"];
//    }else{
//        SDWebDataManager*sd=[SDWebDataManager sharedManager];
//        [sd downloadWithURL:[NSURL URLWithString:iconUrl] delegate:self];
//    }
}

- (void)webDataManager:(SDWebDataManager *)dataManager didFinishWithData:(NSData *)aData isCache:(BOOL)isCache{
    if (aData!=nil) {
        productIcon.image=[UIImage imageWithData:aData];
    }else{
        productIcon.image=[UIImage imageNamed:@"defaultimg85.png"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
