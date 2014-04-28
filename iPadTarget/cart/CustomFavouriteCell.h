//
//  CustomFavouriteCell.h
//  yhd
//
//  Created by dev dev on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebDataManager.h"
@class FavoriteVO;
@protocol CustomFavouriteDelegate <NSObject>

-(void)addtocart:(FavoriteVO*)favourite;

@end
@interface CustomFavouriteCell : UITableViewCell<SDWebDataManagerDelegate>
{
    IBOutlet UILabel * mlabel;
    IBOutlet UIView * mBorderView;
    IBOutlet UIImageView * mProductImageView;
    IBOutlet UILabel * mPriceLabel;
    IBOutlet UILabel * mMarketLabel;
    IBOutlet UIButton * m_AddCartButton;
    FavoriteVO * mFavourite;
    id<CustomFavouriteDelegate>delegate;
}
@property (retain, nonatomic) IBOutlet UILabel *priceNotLabel;
@property(nonatomic,retain)UILabel * mlabel;
@property(nonatomic,retain)FavoriteVO * mFavourite;
@property(nonatomic,retain)id<CustomFavouriteDelegate>delegate;
-(void)initview;
-(IBAction)DeleteFavourite:(id)sender;
-(IBAction)AddToCartClicked:(id)sender;
@end
