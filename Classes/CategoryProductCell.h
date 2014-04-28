//
//  CategoryProductCell.h
//  TheStoreApp
//
//  Created by jun yuan on 12-9-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StrikeThroughLabel.h"
#import "SDWebDataManager.h"
#import "OTSImageView.h"
@interface CategoryProductCell : UITableViewCell<SDWebDataManagerDelegate>{
    UILabel* productNameLbl;
    UILabel* hasCashLbl;
    StrikeThroughLabel* marketPriceLbl;
    UILabel * priceLbl;
    UILabel * shoppingCountLbl;
    UILabel * canBuyLbl;
    UIButton *operateBtn;
    UIImageView *giftLogo;
    OTSImageView *imageView;
    UIImageView *the1MallLogo;
    
    UIButton *_giftBtn;
    UIButton *_reduceBtn;
}
@property(nonatomic, retain)  UILabel *productNameLbl;
@property(nonatomic, retain)  UILabel* hasCashLbl;
@property(nonatomic, retain)  StrikeThroughLabel *marketPriceLbl;
@property(nonatomic, retain)  UILabel *priceLbl;
@property(nonatomic, retain)  UILabel *shoppingCountLbl;
@property(nonatomic, retain)  UILabel *canBuyLbl;
@property(nonatomic, retain)  UIButton *operateBtn;
@property(nonatomic, retain)  UIImageView *giftLogo;
@property(nonatomic, retain)  OTSImageView *imageView;
@property(nonatomic, retain)  UIImageView *the1MallLogo;
- (void)downloadImage:(NSString*)url;


- (void)showGift:(BOOL)bShow; //显示是否有赠品
- (void)showReduce:(BOOL)bShow; //显示是否有满减
@end
