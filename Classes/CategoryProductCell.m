//
//  CategoryProductCell.m
//  TheStoreApp
//
//  Created by jun yuan on 12-9-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CategoryProductCell.h"

@implementation CategoryProductCell
@synthesize     operateBtn,productNameLbl ,marketPriceLbl,priceLbl,shoppingCountLbl,canBuyLbl,giftLogo,imageView,hasCashLbl,the1MallLogo;

- (void)dealloc{
    [productNameLbl release];
    [hasCashLbl release];
    [marketPriceLbl release];
    [priceLbl release];
    [shoppingCountLbl release];
    [canBuyLbl release];
    [giftLogo release];
    [imageView release];
    [operateBtn release];
    [the1MallLogo release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        productNameLbl=[[UILabel alloc] initWithFrame:CGRectMake(98, 10, 170, 40)];
        productNameLbl.numberOfLines = 0;
        productNameLbl.font=[UIFont boldSystemFontOfSize:16];
        productNameLbl.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:productNameLbl];
        
        hasCashLbl=[[UILabel alloc] initWithFrame:CGRectMake(98, 49, 170, 15)];
        hasCashLbl.font=[UIFont systemFontOfSize:13.0];
        hasCashLbl.backgroundColor=[UIColor clearColor];
        hasCashLbl.textColor = [UIColor colorWithRed:0.65 green:0.13 blue:0.14 alpha:1];
        [self.contentView addSubview:hasCashLbl];
        
        
        priceLbl=[[UILabel alloc] initWithFrame:CGRectMake(98, 75, 85, 18)];
        priceLbl.textColor=[UIColor colorWithRed:180.0/255.0 green:1.0/255.0 blue:0.0/255.0 alpha:1.0];
        priceLbl.font=[UIFont systemFontOfSize:16];
        priceLbl.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:priceLbl];

        marketPriceLbl=[[StrikeThroughLabel alloc] initWithFrame:CGRectMake(183, 75, 85, 18)];
        marketPriceLbl.textColor=[UIColor grayColor];
        marketPriceLbl.font=[UIFont systemFontOfSize:14];
        marketPriceLbl.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:marketPriceLbl];
        
//        canBuyLbl=[[UILabel alloc] initWithFrame:CGRectMake(98 , 81, 50, 16)];
//        canBuyLbl.textColor=[UIColor darkGrayColor];
//        canBuyLbl.font=[UIFont systemFontOfSize:14];
//        canBuyLbl.backgroundColor=[UIColor clearColor];
//        [self.contentView addSubview:canBuyLbl];
//        
//        shoppingCountLbl=[[UILabel alloc] initWithFrame:CGRectMake(215 , 81, 80, 16)];
//        shoppingCountLbl.textColor=[UIColor lightGrayColor];
//        shoppingCountLbl.font=[UIFont systemFontOfSize:14];
//        shoppingCountLbl.backgroundColor=[UIColor clearColor];
//        [self.contentView addSubview:shoppingCountLbl];
        
       

//        for (int i=0; i<5; i++) {
//            UIImageView* star=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pentagon_Gray.png"]];
//            star.tag=1000+i;
//            star.frame=CGRectMake(142+14*i, 81, 13, 13);
//            [self.contentView addSubview:star];
//            [star release];
//        }
        
        
        imageView=[[OTSImageView alloc] initWithFrame:CGRectMake(11, 10, 80, 80)];
//        imageView.image=[UIImage imageNamed:@"img_default.png"];
        [self.contentView addSubview:imageView];
        
        operateBtn=[[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [operateBtn setImage:[UIImage imageNamed:@"product_cart.png"] forState:UIControlStateNormal];
        operateBtn.frame=CGRectMake(270, 8, 50, 85);
        [self.contentView addSubview:operateBtn];
        
        giftLogo=[[UIImageView alloc] initWithFrame:CGRectMake(320-32, 0, 32, 32)];
        giftLogo.image=[UIImage imageNamed:@"giftLog.png"];
        [self.contentView addSubview:giftLogo];
        
        the1MallLogo =[[UIImageView alloc] initWithFrame:CGRectMake(98, 10, 17, 17)];
        the1MallLogo.image=[UIImage imageNamed:@"mall_logo.png"];
        [self.contentView addSubview:the1MallLogo];
        [the1MallLogo setHidden:YES];
        
        
        _giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _giftBtn.backgroundColor = [UIColor redColor];
//        [_giftBtn setTitle:@"赠" forState:UIControlStateNormal];
//        _giftBtn.titleLabel.textColor = [UIColor whiteColor];
        [_giftBtn setBackgroundImage:[UIImage imageNamed:@"zeng24.png"] forState:UIControlStateNormal];
        _giftBtn.frame = CGRectMake(98, 51, 20, 20);
        _giftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        _giftBtn.hidden = YES;
        [self.contentView addSubview:_giftBtn];


        _reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reduceBtn.frame = CGRectMake(98+24, 52, 20, 20);
//        _reduceBtn.backgroundColor = [UIColor redColor];
//        _reduceBtn.titleLabel.textColor = [UIColor whiteColor];
//        _reduceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
//        [_reduceBtn setTitle:@"减" forState:UIControlStateNormal];
        [_reduceBtn setBackgroundImage:[UIImage imageNamed:@"jian24.png"] forState:UIControlStateNormal];
        
        _reduceBtn.hidden = YES;
        [self.contentView addSubview:_reduceBtn];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - SDWebDelegate
- (void)downloadImage:(NSString*)url
{
    [imageView loadImgUrl:url];

}
- (void)webDataManager:(SDWebDataManager *)dataManager didFinishWithData:(NSData *)aData isCache:(BOOL)isCache
{
    imageView.image = [UIImage imageWithData:aData];
}

- (void)showGift:(BOOL)bShow
{
    _giftBtn.hidden = !bShow;
    
    if (bShow)
    {
        if (_reduceBtn.hidden)
        {
            _giftBtn.frame = CGRectMake(98, 52, 18, 18);
        }
        else
        {
            _reduceBtn.frame = CGRectMake(98+22, 52, 18, 18);
        }
    }
    
    
}

- (void)showReduce:(BOOL)bShow
{
    _reduceBtn.hidden = !bShow;
    
    if (bShow)
    {
        if (_giftBtn.hidden)
        {
            _reduceBtn.frame = CGRectMake(98, 52, 18, 18);
        }
        else
        {
            _reduceBtn.frame = CGRectMake(98+22, 52, 18, 18);
        }
    }
}

@end
