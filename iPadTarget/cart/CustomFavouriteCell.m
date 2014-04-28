//
//  CustomFavouriteCell.m
//  yhd
//
//  Created by dev dev on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomFavouriteCell.h"


#import <QuartzCore/QuartzCore.h>
#import "NSObject+OTS.h"
#import "FavoriteVO.h"
#import "ProductVO.h"
#import "OTSServiceHelper.h"
#import "FavoriteVO.h"
#import "GlobalValue.h"
@implementation CustomFavouriteCell
@synthesize mlabel;
@synthesize mFavourite;
@synthesize delegate;
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
-(void)initview
{
    mBorderView.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    mBorderView.layer.borderWidth =1;
    mlabel.text = mFavourite.product.cnName;
    if ([mFavourite.product.canBuy isEqualToString:@"false"] || mFavourite.product.price == nil) {
        [m_AddCartButton setImage:[UIImage imageNamed:@"soldout.png"] forState:UIControlStateNormal];
        [m_AddCartButton setEnabled:NO];
        [self.priceNotLabel setHidden:YES];
        mPriceLabel.hidden = YES;
    }else{
        [m_AddCartButton setImage:[UIImage imageNamed:@"addtocartinusercenterunclicked.png"] forState:UIControlStateNormal];
        [m_AddCartButton setEnabled:YES];
        mPriceLabel.text = [NSString stringWithFormat:@"¥%0.2f",[mFavourite.product.price doubleValue]];
        [self.priceNotLabel setHidden:NO];
        mPriceLabel.hidden = NO;
    }
   
    //mMarketLabel.text = [NSString stringWithFormat:@"¥%0.2f",[mFavourite.product.maketPrice doubleValue]];
    
    SDWebDataManager * datamanager = [SDWebDataManager sharedManager];
    if ([mFavourite.product.midleDefaultProductUrl rangeOfString:@"null"].location==NSNotFound) {
        [datamanager downloadWithURL:[NSURL URLWithString:mFavourite.product.midleDefaultProductUrl] delegate:self];
    }else {
        mProductImageView.image=[UIImage imageNamed:@"defaultimg76.png"];
    }
}
-(void)dealloc
{
    [mlabel release];
    [mFavourite release];
    [_priceNotLabel release];
    [super dealloc];
}
-(IBAction)DeleteFavourite:(id)sender
{
    [self otsDetatchMemorySafeNewThreadSelector:@selector(DelFavouriteToServer) toTarget:self withObject:nil];
}
-(IBAction)AddToCartClicked:(id)sender
{
    [self.delegate addtocart:mFavourite];
}
-(void)DelFavouriteToServer
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    OTSServiceHelper* service = [OTSServiceHelper sharedInstance];
    int result = [service delFavorite:[GlobalValue getGlobalValueInstance].token productId:mFavourite.product.productId];
    if (result==1)
    {
        [self performSelectorOnMainThread:@selector(PushRefreshFavourite) withObject:nil waitUntilDone:YES];
    }
    [pool drain];
}
-(void)PushRefreshFavourite
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"kRefreshFavourite" object:nil userInfo:nil];
}
#pragma mark - SDWebDelegate
- (void)webDataManager:(SDWebDataManager *)dataManager didFinishWithData:(NSData *)aData isCache:(BOOL)isCache
{
    mProductImageView.image = [UIImage imageWithData:aData];
}
@end